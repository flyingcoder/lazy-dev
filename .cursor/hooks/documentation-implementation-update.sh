#!/bin/bash
# documentation-implementation-update.sh - Detects implementation summaries and triggers documentation updates
# Triggers when AI provides summary of completed work that references documentation recommendations

set -e

# Configuration
HOOK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$HOOK_DIR/../.." && pwd)"
DOCS_DIR="${PROJECT_ROOT}/docs"
LOG_DIR="${HOME}/.cursor/audit"
LOG_FILE="${LOG_DIR}/documentation-updates.log"

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Ensure log directory exists
mkdir -p "$LOG_DIR"

# Log function
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_FILE"
}

# Read JSON input from stdin
json_input=$(cat 2>/dev/null || echo "{}")

# Extract context from input
agent_response=$(echo "$json_input" | jq -r '.response // .content // .text // empty' 2>/dev/null || echo "")
file_path=$(echo "$json_input" | jq -r '.file_path // .path // empty' 2>/dev/null || echo "")
hook_event=$(echo "$json_input" | jq -r '.event // .hook // "unknown"' 2>/dev/null || echo "unknown")

# Function to detect implementation summary patterns
detect_implementation_summary() {
    local text="$1"
    
    # Implementation completion patterns
    if echo "$text" | grep -qiE "(implementation.*complete|complete.*implementation|all.*implemented|implementation.*done|done.*implementation)"; then
        return 0
    fi
    
    # Summary patterns
    if echo "$text" | grep -qiE "(summary|implementation summary|summary of|completed|done|finished|all done)"; then
        return 0
    fi
    
    # Recommendation implementation patterns
    if echo "$text" | grep -qiE "(recommendation.*implemented|implemented.*recommendation|following.*recommendation|based.*on.*recommendation)"; then
        return 0
    fi
    
    # Documentation reference with completion
    if echo "$text" | grep -qiE "(following.*documentation|based.*on.*documentation|docs/.*\.md)" && \
       echo "$text" | grep -qiE "(implemented|completed|done|finished)"; then
        return 0
    fi
    
    return 1
}

# Function to extract documentation references
extract_doc_references() {
    local text="$1"
    local refs=()
    
    # Extract explicit file paths
    while IFS= read -r line; do
        if [[ "$line" =~ docs/[^[:space:]]+\.md ]]; then
            refs+=("${BASH_REMATCH[0]}")
        fi
    done <<< "$text"
    
    # Extract decision references (DDD-*.md pattern)
    while IFS= read -r line; do
        if [[ "$line" =~ (decision|Decision)[[:space:]]+[0-9]{3} ]]; then
            local num=$(echo "$line" | grep -oE '[0-9]{3}' | head -1)
            if [ -n "$num" ]; then
                # Try to find matching decision file
                local decision_file=$(find "$DOCS_DIR/decisions" -name "${num}-*.md" 2>/dev/null | head -1)
                if [ -n "$decision_file" ]; then
                    refs+=("$decision_file")
                fi
            fi
        fi
    done <<< "$text"
    
    # Extract plan references (NAME_PLAN.md pattern)
    while IFS= read -r line; do
        if [[ "$line" =~ ([A-Z_]+_PLAN|MIGRATION.*PLAN) ]]; then
            local plan_name=$(echo "$line" | grep -oE '[A-Z_]+_PLAN' | head -1)
            if [ -n "$plan_name" ]; then
                local plan_file=$(find "$DOCS_DIR" -name "${plan_name}.md" -o -name "*${plan_name}*.md" 2>/dev/null | head -1)
                if [ -n "$plan_file" ]; then
                    refs+=("$plan_file")
                fi
            fi
        fi
    done <<< "$text"
    
    # Remove duplicates and return
    printf '%s\n' "${refs[@]}" | sort -u
}

# Function to check if documentation needs update
needs_update() {
    local doc_file="$1"
    
    if [ ! -f "$doc_file" ]; then
        return 1  # File doesn't exist, can't update
    fi
    
    # Check if file has status field that could be updated
    if grep -qE "^status:" "$doc_file" 2>/dev/null; then
        local status=$(grep "^status:" "$doc_file" | head -1 | sed 's/^status:[[:space:]]*//' | tr -d '"' | tr -d "'")
        if [[ "$status" =~ (recommended|planning|pending|in_progress) ]]; then
            return 0  # Needs update
        fi
    fi
    
    # Check if file has "Next Steps" or "Recommendations" section
    if grep -qiE "(##[[:space:]]+Next Steps|##[[:space:]]+Recommendations|##[[:space:]]+Implementation)" "$doc_file" 2>/dev/null; then
        return 0  # Likely needs update
    fi
    
    return 1
}

# Function to create update marker
create_update_marker() {
    local doc_file="$1"
    local summary="$2"
    local marker_file="${doc_file}.update_marker"
    
    cat > "$marker_file" <<EOF
# Documentation Update Marker
# Generated: $(date '+%Y-%m-%d %H:%M:%S')
# Trigger: Implementation summary detected

## Summary
$summary

## Action Required
Update documentation to reflect implementation completion:
- Update status field if present
- Mark recommendations as implemented
- Add implementation notes
- Update last_updated date

## Operator Sequence
Retro ∘ Ana ∘ Weave ∘ Ortho ∘ Latch

## Detection Pattern
Implementation summary detected in agent response
EOF
    
    echo "$marker_file"
}

# Main processing
process_agent_response() {
    if [ -z "$agent_response" ]; then
        return 0  # No response to process
    fi
    
    # Detect if this is an implementation summary
    if ! detect_implementation_summary "$agent_response"; then
        return 0  # Not an implementation summary
    fi
    
    log "Implementation summary detected in agent response"
    echo -e "${BLUE}📝 Implementation summary detected${NC}" >&2
    
    # Extract documentation references
    doc_refs=$(extract_doc_references "$agent_response")
    
    if [ -z "$doc_refs" ]; then
        log "No documentation references found in summary"
        return 0  # No docs to update
    fi
    
    # Process each documentation reference
    update_count=0
    while IFS= read -r doc_ref; do
        if [ -z "$doc_ref" ]; then
            continue
        fi
        
        # Resolve to absolute path
        if [[ "$doc_ref" != /* ]]; then
            doc_ref="${PROJECT_ROOT}/${doc_ref}"
        fi
        
        # Check if file exists
        if [ ! -f "$doc_ref" ]; then
            log "Documentation file not found: $doc_ref"
            continue
        fi
        
        # Check if update is needed
        if ! needs_update "$doc_ref"; then
            log "Documentation does not need update: $doc_ref"
            continue
        fi
        
        # Create update marker
        marker_file=$(create_update_marker "$doc_ref" "$agent_response")
        log "Created update marker: $marker_file for $doc_ref"
        
        echo -e "${YELLOW}📄 Documentation update needed: $(basename "$doc_ref")${NC}" >&2
        echo -e "${YELLOW}   Marker created: $(basename "$marker_file")${NC}" >&2
        
        update_count=$((update_count + 1))
    done <<< "$doc_refs"
    
    if [ $update_count -gt 0 ]; then
        log "Created $update_count update marker(s) for documentation updates"
        echo -e "${GREEN}✅ Documentation update markers created${NC}" >&2
        echo -e "${BLUE}💡 AI should update documentation using operator sequence: Retro ∘ Ana ∘ Weave ∘ Ortho ∘ Latch${NC}" >&2
    fi
}

# Process file edits for implementation completion
process_file_edit() {
    if [ -z "$file_path" ]; then
        return 0
    fi
    
    # Only process markdown files in docs/
    if [[ ! "$file_path" =~ ^docs/.*\.md$ ]]; then
        return 0
    fi
    
    # Check if file was just created (might be implementation summary)
    if [ -f "$file_path" ]; then
        # Check for implementation completion patterns in file
        if grep -qiE "(implementation.*complete|complete.*implementation|all.*implemented|status.*complete)" "$file_path" 2>/dev/null; then
            log "Implementation completion detected in file: $file_path"
            # Extract and process as agent response
            agent_response=$(cat "$file_path")
            process_agent_response
        fi
    fi
}

# Main execution
case "$hook_event" in
    "afterAgentResponse"|"afterAgentThought")
        process_agent_response
        ;;
    "afterFileEdit"|"afterTabFileEdit")
        process_file_edit
        ;;
    *)
        # Unknown event, try to process anyway
        if [ -n "$agent_response" ]; then
            process_agent_response
        elif [ -n "$file_path" ]; then
            process_file_edit
        fi
        ;;
esac

exit 0

