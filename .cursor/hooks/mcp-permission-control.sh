#!/bin/bash
# mcp-permission-control.sh - Advanced MCP tool permission control
# Implements least-privilege policies for MCP tools with granular control

# Configuration
POLICY_CONFIG="${HOME}/.cursor/mcp-policies.json"

# Initialize policy config if it doesn't exist
if [ ! -f "$POLICY_CONFIG" ]; then
    cat > "$POLICY_CONFIG" << 'EOF'
{
  "tool_policies": {
    "*": {
      "default_permission": "allow",
      "require_approval": []
    }
  },
  "destructive_tools": [
    "delete", "destroy", "remove", "drop", "clear", "truncate",
    "kill", "terminate", "uninstall", "purge", "wipe", "erase"
  ],
  "write_tools": [
    "write", "create", "add", "insert", "update", "set", "modify",
    "edit", "change", "replace", "patch", "publish", "post", "put"
  ],
  "read_tools": [
    "read", "get", "fetch", "list", "search", "query", "find",
    "lookup", "retrieve", "load", "download", "export"
  ],
  "execution_tools": [
    "execute", "run", "call", "invoke", "trigger", "launch",
    "start", "open", "send", "deploy", "build", "compile"
  ],
  "sensitive_tools": [
    "secret", "credential", "password", "token", "key", "auth",
    "login", "session", "permission", "access", "admin"
  ],
  "blocked_tools": [],
  "require_approval_tools": []
}
EOF
fi

# Read JSON input
json_input=$(cat)
hook_event=$(echo "$json_input" | jq -r '.hook_event_name')

# Only handle beforeMCPExecution
if [ "$hook_event" != "beforeMCPExecution" ]; then
    exit 0
fi

tool_name=$(echo "$json_input" | jq -r '.tool_name // empty')
tool_input=$(echo "$json_input" | jq -r '.tool_input // empty')

if [ -z "$tool_name" ]; then
    # No tool name, allow
    cat << 'EOF'
{
  "permission": "allow"
}
EOF
    exit 0
fi

# Load policy config
destructive_tools=$(jq -r '.destructive_tools[]' "$POLICY_CONFIG" 2>/dev/null || echo "")
write_tools=$(jq -r '.write_tools[]' "$POLICY_CONFIG" 2>/dev/null || echo "")
blocked_tools=$(jq -r '.blocked_tools[]' "$POLICY_CONFIG" 2>/dev/null || echo "")
require_approval=$(jq -r '.require_approval_tools[]' "$POLICY_CONFIG" 2>/dev/null || echo "")

# Check if tool is explicitly blocked
for blocked in $blocked_tools; do
    if echo "$tool_name" | grep -qiE "$blocked"; then
        cat << EOF
{
  "permission": "deny",
  "user_message": "🚫 MCP tool blocked: $tool_name is not allowed by policy",
  "agent_message": "The MCP tool '$tool_name' has been blocked by security policy. Please use an alternative tool or contact your administrator."
}
EOF
        exit 0
    fi
done

# Check if tool requires approval
for approval_tool in $require_approval; do
    if echo "$tool_name" | grep -qiE "$approval_tool"; then
        cat << EOF
{
  "permission": "ask",
  "user_message": "⚠️  MCP tool requires approval: $tool_name",
  "agent_message": "The MCP tool '$tool_name' requires explicit approval. Please review and approve if you want to proceed."
}
EOF
        exit 0
    fi
done

# Check for destructive operations
for destructive in $destructive_tools; do
    if echo "$tool_name" | grep -qiE "$destructive"; then
        cat << EOF
{
  "permission": "ask",
  "user_message": "🗑️  Destructive MCP tool requires approval: $tool_name",
  "agent_message": "The MCP tool '$tool_name' performs a destructive operation. Please review the operation carefully and approve only if you understand the consequences."
}
EOF
        exit 0
    fi
done

# Check for write operations on sensitive data
for write_tool in $write_tools; do
    if echo "$tool_name" | grep -qiE "$write_tool"; then
        # Check if tool input contains sensitive patterns
        if echo "$tool_input" | grep -qiE "(password|secret|credential|token|key|auth|api[_-]?key)"; then
            cat << EOF
{
  "permission": "ask",
  "user_message": "🔐 Sensitive write operation requires approval: $tool_name",
          "agent_message": "The MCP tool '$tool_name' is writing sensitive data (passwords, secrets, credentials, tokens, or keys). Please review and approve if this is intentional."
}
EOF
            exit 0
        fi
    fi
done

# Check for sensitive tools (even read operations)
sensitive_tools=$(jq -r '.sensitive_tools[]' "$POLICY_CONFIG" 2>/dev/null || echo "")
for sensitive in $sensitive_tools; do
    if echo "$tool_name" | grep -qiE "$sensitive"; then
        cat << EOF
{
  "permission": "ask",
  "user_message": "🔒 Sensitive MCP tool requires approval: $tool_name",
  "agent_message": "The MCP tool '$tool_name' accesses sensitive information. Please review and approve if this is necessary."
}
EOF
        exit 0
    fi
done

# Check for execution tools (may execute code or commands)
for exec_tool in $(jq -r '.execution_tools[]' "$POLICY_CONFIG" 2>/dev/null || echo ""); do
    if echo "$tool_name" | grep -qiE "$exec_tool"; then
        # Additional check: if tool input looks like it might execute shell commands
        if echo "$tool_input" | grep -qE "(sh|bash|python|node|npm|pip|apt|yum|brew|curl.*\|)"; then
            cat << EOF
{
  "permission": "ask",
  "user_message": "⚡ Execution tool with command-like input requires approval: $tool_name",
  "agent_message": "The MCP tool '$tool_name' appears to be executing commands or scripts. Please review the input carefully and approve only if you trust the command."
}
EOF
            exit 0
        fi
    fi
done

# Default: allow
cat << 'EOF'
{
  "permission": "allow"
}
EOF

exit 0

