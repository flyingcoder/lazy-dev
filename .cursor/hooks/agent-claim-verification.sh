#!/bin/bash
# agent-claim-verification.sh - Verifies AI agent claims against codebase
# Prevents hallucinations by checking claims against actual codebase state

set -e

# Configuration
HOOK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$HOOK_DIR/../.." && pwd)"
LOG_DIR="${HOME}/.cursor/audit"
VERIFICATION_LOG="${LOG_DIR}/claim-verification.log"
FALSE_CLAIMS_LOG="${LOG_DIR}/false-claims.log"
UNVERIFIED_CLAIMS_LOG="${LOG_DIR}/unverified-claims.log"

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Ensure log directory exists
mkdir -p "$LOG_DIR"

# Log function
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$VERIFICATION_LOG"
}

log_false() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$FALSE_CLAIMS_LOG"
}

log_unverified() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$UNVERIFIED_CLAIMS_LOG"
}

# Read JSON input from stdin
json_input=$(cat 2>/dev/null || echo "{}")

# Extract context from input
agent_response=$(echo "$json_input" | jq -r '.response // .text // .content // empty' 2>/dev/null || echo "")
hook_event=$(echo "$json_input" | jq -r '.event // .hook // "unknown"' 2>/dev/null || echo "unknown")
conversation_id=$(echo "$json_input" | jq -r '.conversation_id // "none"' 2>/dev/null || echo "none")

# Function to extract file path claims
extract_file_claims() {
    local text="$1"
    local claims=()
    
    # Extract file paths mentioned
    while IFS= read -r line; do
        # Match patterns like: "file src/utils.ts", "the file app/components/Button.tsx", "path/to/file.md"
        if [[ "$line" =~ (file|File|path|Path)[[:space:]]+([a-zA-Z0-9_./-]+\.(ts|tsx|js|jsx|py|md|json|yaml|yml)) ]]; then
            local file_path="${BASH_REMATCH[2]}"
            # Check if it's a relative path
            if [[ "$file_path" != /* ]]; then
                file_path="${PROJECT_ROOT}/${file_path}"
            fi
            claims+=("$file_path")
        fi
        # Match code block file references: ```12:14:filepath
        if [[ "$line" =~ ^[[:space:]]*\`\`\`[0-9]+:[0-9]+:([a-zA-Z0-9_./-]+) ]]; then
            local file_path="${BASH_REMATCH[1]}"
            if [[ "$file_path" != /* ]]; then
                file_path="${PROJECT_ROOT}/${file_path}"
            fi
            claims+=("$file_path")
        fi
    done <<< "$text"
    
    # Remove duplicates
    printf '%s\n' "${claims[@]}" | sort -u
}

# Function to extract function/class definition claims
extract_definition_claims() {
    local text="$1"
    local claims=()
    
    # Extract function/class/method names mentioned with "defined", "exists", "does"
    while IFS= read -r line; do
        # Pattern: "function X is defined", "class Y exists", "method Z does"
        if [[ "$line" =~ (function|Function|class|Class|method|Method)[[:space:]]+([a-zA-Z0-9_]+)[[:space:]]+(is[[:space:]]+)?(defined|exists|does|handles|implements) ]]; then
            local name="${BASH_REMATCH[2]}"
            claims+=("$name")
        fi
    done <<< "$text"
    
    printf '%s\n' "${claims[@]}" | sort -u
}

# Function to verify file existence claim
verify_file_exists() {
    local file_path="$1"
    local claim_context="$2"
    
    # Resolve to absolute path if relative
    if [[ "$file_path" != /* ]]; then
        file_path="${PROJECT_ROOT}/${file_path}"
    fi
    
    if [ -f "$file_path" ]; then
        log "✅ VERIFIED: File exists - $file_path"
        return 0  # Verified
    else
        log_false "❌ FALSE: File does not exist - $file_path (Context: $claim_context)"
        echo -e "${RED}❌ False Claim: File does not exist - $file_path${NC}" >&2
        return 1  # False
    fi
}

# Function to verify function/class definition claim
verify_definition_exists() {
    local name="$1"
    local file_path="$2"
    local claim_context="$3"
    
    if [ -z "$file_path" ] || [ ! -f "$file_path" ]; then
        # Search entire codebase
        local found=$(grep -rE "(function|class|const|let|var)[[:space:]]+${name}[[:space:](]" "$PROJECT_ROOT" --include="*.ts" --include="*.tsx" --include="*.js" --include="*.jsx" --include="*.py" 2>/dev/null | head -1)
        if [ -n "$found" ]; then
            log "✅ VERIFIED: Definition found - $name"
            return 0  # Verified
        else
            log_false "❌ FALSE: Definition not found - $name (Context: $claim_context)"
            echo -e "${RED}❌ False Claim: Definition not found - $name${NC}" >&2
            return 1  # False
        fi
    else
        # Check specific file
        if grep -qE "(function|class|const|let|var)[[:space:]]+${name}[[:space:](]" "$file_path" 2>/dev/null; then
            log "✅ VERIFIED: Definition exists in $file_path - $name"
            return 0  # Verified
        else
            log_false "❌ FALSE: Definition not in $file_path - $name (Context: $claim_context)"
            echo -e "${RED}❌ False Claim: Definition not in file - $name in $file_path${NC}" >&2
            return 1  # False
        fi
    fi
}

# Function to detect claim patterns
detect_claims() {
    local text="$1"
    local claim_count=0
    
    # File existence claims
    if echo "$text" | grep -qiE "(file|File|path|Path).*(exists|is present|can be found)"; then
        claim_count=$((claim_count + 1))
    fi
    
    # Code behavior claims
    if echo "$text" | grep -qiE "(code|function|class|method).*(does|handles|implements|performs|returns)"; then
        claim_count=$((claim_count + 1))
    fi
    
    # Pattern usage claims
    if echo "$text" | grep -qiE "(pattern|Pattern).*(is used|used in|found in|exists)"; then
        claim_count=$((claim_count + 1))
    fi
    
    # Definition claims
    if echo "$text" | grep -qiE "(function|class|method).*(is defined|exists|defined in)"; then
        claim_count=$((claim_count + 1))
    fi
    
    # File content claims
    if echo "$text" | grep -qiE "(file|File).*(contains|has|includes)"; then
        claim_count=$((claim_count + 1))
    fi
    
    echo "$claim_count"
}

# Function to verify file path claims
verify_file_claims() {
    local text="$1"
    local verified=0
    local false_claims=0
    
    # Extract file claims
    file_claims=$(extract_file_claims "$text")
    
    if [ -z "$file_claims" ]; then
        return 0  # No file claims
    fi
    
    while IFS= read -r file_path; do
        if [ -z "$file_path" ]; then
            continue
        fi
        
        # Check if claim is about existence
        if echo "$text" | grep -qiE "(file|File|path|Path).*${file_path}.*(exists|is present|can be found)"; then
            if verify_file_exists "$file_path" "$text"; then
                verified=$((verified + 1))
            else
                false_claims=$((false_claims + 1))
            fi
        fi
    done <<< "$file_claims"
    
    if [ $false_claims -gt 0 ]; then
        return 1  # Has false claims
    fi
    
    return 0  # All verified or no claims
}

# Function to verify definition claims
verify_definition_claims() {
    local text="$1"
    local verified=0
    local false_claims=0
    
    # Extract definition claims
    definition_claims=$(extract_definition_claims "$text")
    
    if [ -z "$definition_claims" ]; then
        return 0  # No definition claims
    fi
    
    while IFS= read -r name; do
        if [ -z "$name" ]; then
            continue
        fi
        
        # Try to find file context from text
        local file_path=$(echo "$text" | grep -oE "[a-zA-Z0-9_./-]+\.(ts|tsx|js|jsx|py)" | head -1)
        
        if verify_definition_exists "$name" "$file_path" "$text"; then
            verified=$((verified + 1))
        else
            false_claims=$((false_claims + 1))
        fi
    done <<< "$definition_claims"
    
    if [ $false_claims -gt 0 ]; then
        return 1  # Has false claims
    fi
    
    return 0  # All verified or no claims
}

# Function to check for unverifiable claims
check_unverifiable_claims() {
    local text="$1"
    
    # Claims that are too vague to verify
    if echo "$text" | grep -qiE "(the code|the system|the application).*(does|handles|implements)" && \
       ! echo "$text" | grep -qiE "(file|function|class|method)[[:space:]]+[a-zA-Z0-9_]+"; then
        log_unverified "⚠️  UNVERIFIABLE: Vague claim about code behavior (Context: ${text:0:100}...)"
        echo -e "${YELLOW}⚠️  Unverifiable Claim: Vague statement about code behavior${NC}" >&2
        return 1
    fi
    
    return 0
}

# Main processing
process_agent_response() {
    if [ -z "$agent_response" ]; then
        return 0  # No response to process
    fi
    
    # Detect if there are claims
    claim_count=$(detect_claims "$agent_response")
    
    if [ "$claim_count" -eq 0 ]; then
        return 0  # No claims to verify
    fi
    
    log "Claim verification started - $claim_count claim(s) detected (CONV: $conversation_id)"
    echo -e "${BLUE}🔍 Verifying $claim_count claim(s) in agent response...${NC}" >&2
    
    # Verify file claims
    if ! verify_file_claims "$agent_response"; then
        echo -e "${RED}❌ False file claims detected${NC}" >&2
    fi
    
    # Verify definition claims
    if ! verify_definition_claims "$agent_response"; then
        echo -e "${RED}❌ False definition claims detected${NC}" >&2
    fi
    
    # Check for unverifiable claims
    if ! check_unverifiable_claims "$agent_response"; then
        echo -e "${YELLOW}⚠️  Unverifiable claims detected${NC}" >&2
    fi
    
    log "Claim verification completed (CONV: $conversation_id)"
}

# Main execution
case "$hook_event" in
    "afterAgentResponse"|"afterAgentThought")
        process_agent_response
        ;;
    *)
        # Unknown event, try to process anyway
        if [ -n "$agent_response" ]; then
            process_agent_response
        fi
        ;;
esac

exit 0

