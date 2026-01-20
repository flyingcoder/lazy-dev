#!/bin/bash
# file-access-control.sh - Controls Tab file access with redaction capabilities
# Only applies to Tab (inline completions), not Agent operations

json_input=$(cat)
file_path=$(echo "$json_input" | jq -r '.file_path')
content=$(echo "$json_input" | jq -r '.content // ""')
ACCESS_LOG="${HOME}/.cursor/audit/file-access.log"
timestamp=$(date '+%Y-%m-%d %H:%M:%S')

# Create audit directory if it doesn't exist
mkdir -p "${HOME}/.cursor/audit"

# Log file access
echo "[$timestamp] 📁 TAB_FILE_READ | FILE: $file_path" >> "$ACCESS_LOG"

# Check for sensitive files that should be blocked
if echo "$file_path" | grep -qE "(\.env|\.pem|\.key|\.cert|id_rsa|\.aws/credentials|\.ssh/id_rsa|\.ssh/id_ed25519|password|secret|\.git/config)"; then
  echo "[$timestamp] 🚫 BLOCKED_SENSITIVE_FILE | FILE: $file_path" >> "$ACCESS_LOG"
  
  cat << 'EOF'
{
  "permission": "deny"
}
EOF
  exit 0
fi

# For sensitive but allowed files, could redact content here
# For now, allow access but log it
cat << 'EOF'
{
  "permission": "allow"
}
EOF

exit 0
