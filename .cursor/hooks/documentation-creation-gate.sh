#!/bin/bash
# documentation-creation-gate.sh - Intercepts .md file creation and asks agent to justify
# Prevents over-documentation by requiring justification before creating documentation files

# Configuration
LOG_DIR="${HOME}/.cursor/audit"
GATE_LOG="${LOG_DIR}/documentation-gate.log"
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

# Colors
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Ensure log directory exists
mkdir -p "$LOG_DIR"

# Log function
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$GATE_LOG"
}

# Read JSON input
json_input=$(cat 2>/dev/null || echo "{}")

# Extract hook event and file path
hook_event=$(echo "$json_input" | jq -r '.hook_event_name // .event // "unknown"')
file_path=$(echo "$json_input" | jq -r '.file_path // .path // empty' 2>/dev/null || echo "")

# Function to check if file is new (doesn't exist)
is_new_file() {
    local path="$1"
    if [ -z "$path" ]; then
        return 1
    fi
    
    # Resolve to absolute path if relative
    if [[ "$path" != /* ]]; then
        path="${PROJECT_ROOT}/${path}"
    fi
    
    # Check if file doesn't exist
    [ ! -f "$path" ]
}

# Function to check if file is markdown
is_markdown_file() {
    local path="$1"
    [[ "$path" =~ \.(md|mdc)$ ]]
}

# Function to check if file is in docs directory
is_docs_file() {
    local path="$1"
    [[ "$path" =~ ^docs/ ]] || [[ "$path" =~ ^\.cursor/rules/ ]]
}

# Function to determine if documentation creation should be questioned
should_question_creation() {
    local path="$1"
    
    # Skip if not markdown
    if ! is_markdown_file "$path"; then
        return 1
    fi
    
    # Skip if not in docs/ or .cursor/rules/
    if ! is_docs_file "$path"; then
        return 1
    fi
    
    # Skip if file already exists (updating, not creating)
    if ! is_new_file "$path"; then
        return 1
    fi
    
    # Skip certain files that are always allowed
    if [[ "$path" =~ (README\.md|CHANGELOG\.md|LICENSE|\.gitignore) ]]; then
        return 1
    fi
    
    # Question all other new .md files in docs/
    return 0
}

# Function to generate question JSON response
ask_justification() {
    local file_path="$1"
    local file_name=$(basename "$file_path")
    
    log "Questioning creation of: $file_path"
    
    cat << EOF
{
  "permission": "ask",
  "user_message": "📝 Documentation Creation Gate",
  "agent_message": "You're about to create a new documentation file: $file_name\n\nPlease justify why this documentation is needed:\n\n1. What is the purpose of this documentation?\n2. Does it meet the CREATE criteria from automated-documentation.mdc?\n3. Is this a question/exploration (DON'T CREATE) or an established decision/pattern (CREATE)?\n4. What documentation type is this? (decision|architecture|guide|reference|status|migration)\n\nSee: .cursor/rules/workflow/automated-documentation.mdc for documentation creation guidelines.\n\nIf this is just answering a question or exploring options, please DON'T CREATE the file. Provide the answer directly instead."
}
EOF
}

# Main processing
case "$hook_event" in
    "afterAgentResponse")
        # Detect documentation creation intent in agent response
        # Since Cursor doesn't support beforeFileEdit, we detect intent from agent's response
        agent_response=$(echo "$json_input" | jq -r '.response // .text // .content // empty' 2>/dev/null || echo "")
        
        # Check if agent mentions creating a .md file
        if echo "$agent_response" | grep -qiE "(create.*\.md|writing.*\.md|creating.*documentation|new.*\.md.*file|I.*will.*create.*\.md|I'm.*creating.*\.md)"; then
            # Extract potential file paths
            potential_files=$(echo "$agent_response" | grep -oE "docs/[^[:space:]]+\.md" | sort -u)
            
            if [ -n "$potential_files" ]; then
                for potential_file in $potential_files; do
                    if should_question_creation "$potential_file"; then
                        log "⚠️  Documentation creation intent detected: $potential_file"
                        echo -e "${YELLOW}⚠️  Documentation Creation Gate: $potential_file${NC}" >&2
                        echo -e "${BLUE}💡 Before creating, verify this meets CREATE criteria:${NC}" >&2
                        echo -e "${BLUE}   1. Is this an established decision/pattern (CREATE) or just a question (DON'T CREATE)?${NC}" >&2
                        echo -e "${BLUE}   2. Does it meet automated-documentation.mdc CREATE triggers?${NC}" >&2
                        echo -e "${BLUE}   3. What is the documentation type and purpose?${NC}" >&2
                        echo -e "${BLUE}   See: .cursor/rules/workflow/automated-documentation.mdc${NC}" >&2
                    fi
                done
            fi
        fi
        ;;
    
    "afterFileEdit")
        # Log new documentation creation (for analytics)
        # Note: File already created at this point, but we can log for tracking
        if [ -n "$file_path" ] && is_markdown_file "$file_path" && is_docs_file "$file_path"; then
            # Try to detect if this was a new file (heuristic: check if file is very small/new)
            if [ -f "$file_path" ]; then
                file_size=$(stat -f%z "$file_path" 2>/dev/null || stat -c%s "$file_path" 2>/dev/null || echo "0")
                # If file is very small (< 500 bytes), might be newly created
                if [ "$file_size" -lt 500 ]; then
                    log "Possible new documentation created: $file_path (size: $file_size bytes)"
                else
                    log "Documentation file edited: $file_path"
                fi
            fi
        fi
        ;;
esac

# Allow by default (non-blocking for now, just logging)
exit 0

