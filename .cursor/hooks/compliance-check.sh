#!/bin/bash
# compliance-check.sh - Ensures prompts comply with organizational policies
# Validates prompts before submission

json_input=$(cat)
prompt=$(echo "$json_input" | jq -r '.prompt')
user_email=$(echo "$json_input" | jq -r '.user_email // "anonymous"')
COMPLIANCE_LOG="${HOME}/.cursor/audit/compliance.log"
timestamp=$(date '+%Y-%m-%d %H:%M:%S')

# Create audit directory if it doesn't exist
mkdir -p "${HOME}/.cursor/audit"

# Check for prohibited content
if echo "$prompt" | grep -qiE "(password|api[_-]?key|secret[_-]?key|private[_-]?key|access[_-]?token)"; then
  echo "[$timestamp] 🚨 COMPLIANCE_VIOLATION | USER=$user_email | REASON: Potential credential in prompt" >> "$COMPLIANCE_LOG"
  
  cat << 'EOF'
{
  "continue": false,
  "user_message": "⚠️ Security Policy Violation: Your prompt appears to contain credentials or sensitive information. Please remove any passwords, API keys, or secrets before submitting."
}
EOF
  exit 0
fi

# Check for PII (basic patterns)
if echo "$prompt" | grep -qE "([0-9]{3}-[0-9]{2}-[0-9]{4}|[0-9]{9})"; then
  echo "[$timestamp] ⚠️  POTENTIAL_PII | USER=$user_email | REASON: SSN-like pattern detected" >> "$COMPLIANCE_LOG"
  
  cat << 'EOF'
{
  "continue": false,
  "user_message": "⚠️ PII Detected: Your prompt may contain personal identifiable information (PII). Please remove any social security numbers, ID numbers, or similar sensitive data."
}
EOF
  exit 0
fi

# Check for credit card numbers (basic Luhn check pattern)
if echo "$prompt" | grep -qE "[0-9]{4}[- ]?[0-9]{4}[- ]?[0-9]{4}[- ]?[0-9]{4}"; then
  echo "[$timestamp] 🚨 PII_VIOLATION | USER=$user_email | REASON: Potential credit card number" >> "$COMPLIANCE_LOG"
  
  cat << 'EOF'
{
  "continue": false,
  "user_message": "⚠️ PII Detected: Your prompt may contain credit card information. Please remove any payment card numbers."
}
EOF
  exit 0
fi

# Log successful compliance check
echo "[$timestamp] ✅ COMPLIANCE_PASSED | USER=$user_email" >> "$COMPLIANCE_LOG"

# Allow the prompt
cat << 'EOF'
{
  "continue": true
}
EOF
exit 0
