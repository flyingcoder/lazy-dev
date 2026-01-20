#!/bin/bash
# permission-control.sh - Granular permission and access control
# Controls what commands and tools the agent can execute

json_input=$(cat)
hook_event=$(echo "$json_input" | jq -r '.hook_event_name')

case "$hook_event" in
  "beforeShellExecution")
    command=$(echo "$json_input" | jq -r '.command')
    
    # BLOCKED COMMANDS - Deny outright
    if echo "$command" | grep -qE "(rm -rf /|mkfs|dd if=/dev/zero|:(){ :|:& };:|sudo rm|format c:)"; then
      cat << 'EOF'
{
  "permission": "deny",
  "user_message": "🚫 Command blocked: This command is extremely dangerous and is not allowed.",
  "agent_message": "This command has been blocked by security policy as it could cause irreversible damage to the system. Please use safer alternatives."
}
EOF
      exit 0
    fi
    
    # REQUIRE APPROVAL - Destructive operations
    if echo "$command" | grep -qE "(rm |git push --force|DROP |DELETE |truncate |sudo)"; then
      cat << 'EOF'
{
  "permission": "ask",
  "user_message": "⚠️  Destructive operation requires your approval",
  "agent_message": "This command performs a destructive operation. Please review and approve if you want to proceed."
}
EOF
      exit 0
    fi
    
    # DATABASE OPERATIONS - Require approval for writes
    if echo "$command" | grep -qE "(INSERT INTO|UPDATE |DELETE FROM|ALTER TABLE|CREATE TABLE|DROP TABLE)"; then
      cat << 'EOF'
{
  "permission": "ask",
  "user_message": "💾 Database modification requires approval",
  "agent_message": "This command will modify the database. Please review the query and approve if correct."
}
EOF
      exit 0
    fi
    
    # GIT FORCE OPERATIONS - Require approval
    if echo "$command" | grep -qE "(git push.*--force|git push.*-f|git reset --hard|git clean -fd)"; then
      cat << 'EOF'
{
  "permission": "ask",
  "user_message": "⚠️  Git force operation requires approval",
  "agent_message": "This git operation cannot be undone and may affect other team members. Please confirm."
}
EOF
      exit 0
    fi
    
    # NETWORK OPERATIONS - Require approval
    if echo "$command" | grep -qE "(curl.*POST|wget.*POST|nc.*-e|ssh.*-L|ssh.*-R)"; then
      cat << 'EOF'
{
  "permission": "ask",
  "user_message": "🌐 Network operation requires approval",
  "agent_message": "This command will perform a network operation. Please review and approve."
}
EOF
      exit 0
    fi
    
    # PACKAGE INSTALLATION - Require approval
    if echo "$command" | grep -qE "(npm install|pip install|gem install|cargo install|brew install|apt-get install|yum install)"; then
      cat << 'EOF'
{
  "permission": "ask",
  "user_message": "📦 Package installation requires approval",
  "agent_message": "This command will install new packages. Please verify the packages are from trusted sources."
}
EOF
      exit 0
    fi
    
    # Allow everything else
    cat << 'EOF'
{
  "permission": "allow"
}
EOF
    ;;
    
  "beforeMCPExecution")
    tool_name=$(echo "$json_input" | jq -r '.tool_name')
    
    # Example: Require approval for certain MCP tools
    if echo "$tool_name" | grep -qE "(delete|destroy|remove|drop)"; then
      cat << 'EOF'
{
  "permission": "ask",
  "user_message": "🔌 Destructive MCP tool requires approval",
  "agent_message": "This MCP tool performs a destructive operation. Please review and approve."
}
EOF
      exit 0
    fi
    
    # Allow other tools
    cat << 'EOF'
{
  "permission": "allow"
}
EOF
    ;;
esac

exit 0
