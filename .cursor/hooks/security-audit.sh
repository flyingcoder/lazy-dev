#!/bin/bash
# security-audit.sh - Comprehensive security auditing and logging
# Tracks all agent operations for compliance and security review

# Configuration
AUDIT_DIR="${HOME}/.cursor/audit"
MAIN_LOG="${AUDIT_DIR}/security-audit.log"
ALERTS_LOG="${AUDIT_DIR}/security-alerts.log"
METRICS_LOG="${AUDIT_DIR}/metrics.csv"

# Create audit directory
mkdir -p "${AUDIT_DIR}"

# Read JSON input
json_input=$(cat)

# Enhanced date/time detection with multiple formats
timestamp=$(date '+%Y-%m-%d %H:%M:%S')
iso_timestamp=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
local_timestamp=$(date '+%Y-%m-%dT%H:%M:%S%z')
epoch_timestamp=$(date +%s)
readable_date=$(date '+%A, %B %d, %Y')
readable_time=$(date '+%I:%M:%S %p %Z')

# Extract common fields
hook_event=$(echo "$json_input" | jq -r '.hook_event_name // "unknown"')
conversation_id=$(echo "$json_input" | jq -r '.conversation_id // "none"')
user_email=$(echo "$json_input" | jq -r '.user_email // "anonymous"')
model=$(echo "$json_input" | jq -r '.model // "unknown"')
workspace=$(echo "$json_input" | jq -r '.workspace_roots[0] // "unknown"')

# Main audit log - everything goes here
echo "[$timestamp] EVENT=$hook_event | USER=$user_email | CONV=$conversation_id | MODEL=$model | WORKSPACE=$workspace" >> "${MAIN_LOG}"
echo "[$timestamp] DATA: $json_input" >> "${MAIN_LOG}"
echo "---" >> "${MAIN_LOG}"

# Event-specific security checks
case "$hook_event" in
  "beforeShellExecution")
    command=$(echo "$json_input" | jq -r '.command')
    
    # Check for dangerous commands
    if echo "$command" | grep -qE "(rm -rf|sudo|DROP TABLE|DELETE FROM|truncate|mkfs|dd if=|>\/dev\/|curl.*\|.*sh|wget.*\|.*sh|eval|exec)"; then
      echo "[$timestamp] 🚨 SECURITY_ALERT | USER=$user_email | DANGEROUS_COMMAND: $command" >> "${ALERTS_LOG}"
    fi
    
    # Check for privilege escalation
    if echo "$command" | grep -qE "(sudo|su |doas)"; then
      echo "[$timestamp] ⚠️  PRIVILEGE_ESCALATION | USER=$user_email | COMMAND: $command" >> "${ALERTS_LOG}"
    fi
    
    # Check for network operations
    if echo "$command" | grep -qE "(curl|wget|nc |netcat|ssh|scp|rsync.*@)"; then
      echo "[$timestamp] 🌐 NETWORK_OPERATION | USER=$user_email | COMMAND: $command" >> "${ALERTS_LOG}"
    fi
    ;;
    
  "afterShellExecution")
    command=$(echo "$json_input" | jq -r '.command')
    duration=$(echo "$json_input" | jq -r '.duration')
    output_length=$(echo "$json_input" | jq -r '.output | length')
    
    # Log metrics
    echo "$iso_timestamp,shell_execution,$duration,$output_length,$user_email,$model" >> "${METRICS_LOG}"
    ;;
    
  "beforeReadFile")
    file_path=$(echo "$json_input" | jq -r '.file_path // "unknown"')
    attachments=$(echo "$json_input" | jq -r '.attachments // []')
    
    # Log file read with detailed date/time information
    echo "[$timestamp] 📖 FILE_READ_ATTEMPT | USER=$user_email | FILE: $file_path | TIME: $readable_time | DATE: $readable_date | EPOCH: $epoch_timestamp | ISO: $iso_timestamp" >> "${MAIN_LOG}"
    
    # Check for sensitive file access
    if echo "$file_path" | grep -qE "(\.env|\.pem|\.key|\.cert|id_rsa|\.aws/credentials|\.ssh/|password|secret)"; then
      echo "[$timestamp] 🔐 SENSITIVE_FILE_READ | USER=$user_email | FILE: $file_path | TIME: $readable_time | DATE: $readable_date" >> "${ALERTS_LOG}"
    fi
    
    # Log to file access tracking
    FILE_ACCESS_LOG="${AUDIT_DIR}/file-access.log"
    echo "[$timestamp] [$iso_timestamp] [$epoch_timestamp] READ | USER=$user_email | FILE=$file_path | TIME=$readable_time | DATE=$readable_date" >> "${FILE_ACCESS_LOG}"
    ;;
    
  "afterFileEdit")
    file_path=$(echo "$json_input" | jq -r '.file_path')
    edit_count=$(echo "$json_input" | jq -r '.edits | length')
    
    # Enhanced logging with detailed date/time before edit
    echo "[$timestamp] ✏️  FILE_EDIT_COMPLETED | USER=$user_email | FILE: $file_path | EDITS: $edit_count | TIME: $readable_time | DATE: $readable_date | EPOCH: $epoch_timestamp | ISO: $iso_timestamp" >> "${MAIN_LOG}"
    
    # Check for sensitive file modifications
    if echo "$file_path" | grep -qE "(\.env|\.pem|\.key|\.cert|id_rsa|\.aws/credentials|\.ssh/|password|secret)"; then
      echo "[$timestamp] 🔐 SENSITIVE_FILE_EDIT | USER=$user_email | FILE: $file_path | EDITS: $edit_count | TIME: $readable_time | DATE: $readable_date" >> "${ALERTS_LOG}"
    fi
    
    # Log to file access tracking
    FILE_ACCESS_LOG="${AUDIT_DIR}/file-access.log"
    echo "[$timestamp] [$iso_timestamp] [$epoch_timestamp] EDIT | USER=$user_email | FILE=$file_path | EDITS=$edit_count | TIME=$readable_time | DATE=$readable_date" >> "${FILE_ACCESS_LOG}"
    ;;
    
  "beforeMCPExecution")
    tool_name=$(echo "$json_input" | jq -r '.tool_name')
    echo "[$timestamp] 🔌 MCP_TOOL_REQUEST | USER=$user_email | TOOL: $tool_name" >> "${MAIN_LOG}"
    ;;
    
  "afterMCPExecution")
    tool_name=$(echo "$json_input" | jq -r '.tool_name')
    duration=$(echo "$json_input" | jq -r '.duration')
    echo "$iso_timestamp,mcp_execution,$duration,0,$user_email,$model" >> "${METRICS_LOG}"
    ;;
esac

exit 0
