#!/bin/bash
# automated-formatter.sh - Automated code formatting after file edits
# Runs appropriate formatters based on file type

json_input=$(cat)
hook_event=$(echo "$json_input" | jq -r '.hook_event_name')

# Only handle file edit events
if [ "$hook_event" != "afterFileEdit" ] && [ "$hook_event" != "afterTabFileEdit" ]; then
    exit 0
fi

file_path=$(echo "$json_input" | jq -r '.file_path // empty')

if [ -z "$file_path" ] || [ ! -f "$file_path" ]; then
    exit 0
fi

# Get file extension
file_ext="${file_path##*.}"
file_base=$(basename "$file_path")

# Function to run formatter
run_formatter() {
    local formatter="$1"
    local file="$2"
    
    # Check if formatter is available
    if ! command -v "$formatter" >/dev/null 2>&1; then
        return 1
    fi
    
    # Run formatter based on type
    case "$formatter" in
        "prettier")
            if [ -f "$file" ]; then
                npx prettier --write "$file" 2>/dev/null
                return $?
            fi
            ;;
        "black")
            if [ -f "$file" ]; then
                black "$file" 2>/dev/null
                return $?
            fi
            ;;
        "gofmt")
            if [ -f "$file" ]; then
                gofmt -w "$file" 2>/dev/null
                return $?
            fi
            ;;
        "rustfmt")
            if [ -f "$file" ]; then
                rustfmt "$file" 2>/dev/null
                return $?
            fi
            ;;
    esac
    
    return 1
}

# Format based on file type
case "$file_ext" in
    "ts"|"tsx"|"js"|"jsx"|"json"|"css"|"scss"|"md"|"yaml"|"yml")
        # JavaScript/TypeScript/JSON/CSS/Markdown/YAML
        run_formatter "prettier" "$file_path"
        ;;
    
    "py")
        # Python
        run_formatter "black" "$file_path"
        ;;
    
    "go")
        # Go
        run_formatter "gofmt" "$file_path"
        ;;
    
    "rs")
        # Rust
        run_formatter "rustfmt" "$file_path"
        ;;
esac

# Exit successfully (don't block even if formatting fails)
exit 0

