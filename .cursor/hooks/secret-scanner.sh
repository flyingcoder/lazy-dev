#!/bin/bash
# secret-scanner.sh - Scans for exposed secrets and credentials
# Works on file edits and prompts

json_input=$(cat)
hook_event=$(echo "$json_input" | jq -r '.hook_event_name')
SECRETS_LOG="${HOME}/.cursor/audit/secrets-detected.log"
timestamp=$(date '+%Y-%m-%d %H:%M:%S')

# Create audit directory if it doesn't exist
mkdir -p "${HOME}/.cursor/audit"

scan_for_secrets() {
  local content="$1"
  local source="$2"
  local found=0
  
  # AWS Keys
  if echo "$content" | grep -qE "AKIA[0-9A-Z]{16}"; then
    echo "[$timestamp] 🔑 AWS_ACCESS_KEY_DETECTED | SOURCE: $source" >> "$SECRETS_LOG"
    found=1
  fi
  
  # Generic API Keys (common patterns)
  if echo "$content" | grep -qiE "(api[_-]?key|apikey)[\"\']?\s*[:=]\s*[\"\']?[a-zA-Z0-9]{20,}"; then
    echo "[$timestamp] 🔑 API_KEY_PATTERN_DETECTED | SOURCE: $source" >> "$SECRETS_LOG"
    found=1
  fi
  
  # Private keys
  if echo "$content" | grep -q "BEGIN.*PRIVATE KEY"; then
    echo "[$timestamp] 🔐 PRIVATE_KEY_DETECTED | SOURCE: $source" >> "$SECRETS_LOG"
    found=1
  fi
  
  # GitHub tokens
  if echo "$content" | grep -qE "ghp_[a-zA-Z0-9]{36}"; then
    echo "[$timestamp] 🔑 GITHUB_TOKEN_DETECTED | SOURCE: $source" >> "$SECRETS_LOG"
    found=1
  fi
  
  # Slack tokens
  if echo "$content" | grep -qE "xox[baprs]-[0-9]{10,13}-[0-9]{10,13}-[a-zA-Z0-9]{24,}"; then
    echo "[$timestamp] 🔑 SLACK_TOKEN_DETECTED | SOURCE: $source" >> "$SECRETS_LOG"
    found=1
  fi
  
  # Google API keys
  if echo "$content" | grep -qE "AIza[0-9A-Za-z\\-_]{35}"; then
    echo "[$timestamp] 🔑 GOOGLE_API_KEY_DETECTED | SOURCE: $source" >> "$SECRETS_LOG"
    found=1
  fi
  
  # Stripe keys
  if echo "$content" | grep -qE "sk_live_[0-9a-zA-Z]{24,}"; then
    echo "[$timestamp] 🔑 STRIPE_KEY_DETECTED | SOURCE: $source" >> "$SECRETS_LOG"
    found=1
  fi
  
  # Generic tokens (JWT-like patterns)
  if echo "$content" | grep -qE "eyJ[A-Za-z0-9-_=]+\.eyJ[A-Za-z0-9-_=]+\.?[A-Za-z0-9-_.+/=]*"; then
    echo "[$timestamp] 🔑 JWT_TOKEN_DETECTED | SOURCE: $source" >> "$SECRETS_LOG"
    found=1
  fi
  
  return $found
}

case "$hook_event" in
  "afterFileEdit")
    file_path=$(echo "$json_input" | jq -r '.file_path')
    edits=$(echo "$json_input" | jq -r '.edits | tostring')
    
    if scan_for_secrets "$edits" "file_edit:$file_path"; then
      # Log but don't block (post-edit detection)
      echo "[$timestamp] ⚠️  Secret detected in file edit: $file_path" >> "$SECRETS_LOG"
    fi
    ;;
    
  "beforeSubmitPrompt")
    if scan_for_secrets "$prompt" "prompt"; then
      # Block prompt submission if secrets detected
      cat << 'EOF'
{
  "continue": false,
  "user_message": "⚠️ Security Alert: Your prompt appears to contain secrets or credentials. Please remove any API keys, tokens, or passwords before submitting."
}
EOF
      exit 0
    fi
    ;;
    
  "afterTabFileEdit")
    file_path=$(echo "$json_input" | jq -r '.file_path')
    edits=$(echo "$json_input" | jq -r '.edits | tostring')
    
    if scan_for_secrets "$edits" "tab_edit:$file_path"; then
      echo "[$timestamp] ⚠️  Secret detected in Tab edit: $file_path" >> "$SECRETS_LOG"
    fi
    ;;
esac

exit 0
