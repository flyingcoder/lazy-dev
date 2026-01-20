#!/bin/bash
# mcp-governance.sh - Comprehensive MCP governance and visibility
# Tracks MCP servers, monitors tool usage patterns, scans responses for sensitive data

# Configuration
AUDIT_DIR="${HOME}/.cursor/audit"
MCP_INVENTORY="${AUDIT_DIR}/mcp-inventory.json"
MCP_USAGE_LOG="${AUDIT_DIR}/mcp-usage-patterns.log"
MCP_RESPONSE_SCAN="${AUDIT_DIR}/mcp-response-scan.log"
MCP_METRICS="${AUDIT_DIR}/mcp-metrics.csv"

# Create audit directory
mkdir -p "${AUDIT_DIR}"

# Initialize MCP inventory if it doesn't exist
if [ ! -f "$MCP_INVENTORY" ]; then
    echo '{"servers": [], "tools": {}, "last_updated": null}' > "$MCP_INVENTORY"
fi

# Read JSON input
json_input=$(cat)

# Extract common fields
hook_event=$(echo "$json_input" | jq -r '.hook_event_name // "unknown"')
conversation_id=$(echo "$json_input" | jq -r '.conversation_id // "none"')
user_email=$(echo "$json_input" | jq -r '.user_email // "anonymous"')
model=$(echo "$json_input" | jq -r '.model // "unknown"')
timestamp=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
iso_timestamp="$timestamp"
epoch_timestamp=$(date +%s)

# Function to scan content for sensitive data
scan_for_sensitive_data() {
    local content="$1"
    local source="$2"
    local found=0
    local patterns_found=()
    
    # PII patterns
    if echo "$content" | grep -qE "\b\d{3}-\d{2}-\d{4}\b|\b\d{3}\.\d{2}\.\d{4}\b"; then
        patterns_found+=("SSN_PATTERN")
        found=1
    fi
    
    # Credit card patterns
    if echo "$content" | grep -qE "\b\d{4}[-\s]?\d{4}[-\s]?\d{4}[-\s]?\d{4}\b"; then
        patterns_found+=("CREDIT_CARD_PATTERN")
        found=1
    fi
    
    # Email addresses (excluding common test domains)
    if echo "$content" | grep -qE "\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}\b" && \
       ! echo "$content" | grep -qE "@(example|test|localhost)"; then
        patterns_found+=("EMAIL_ADDRESS")
        found=1
    fi
    
    # Phone numbers
    if echo "$content" | grep -qE "\b(\+?1[-.\s]?)?\(?\d{3}\)?[-.\s]?\d{3}[-.\s]?\d{4}\b"; then
        patterns_found+=("PHONE_NUMBER")
        found=1
    fi
    
    # AWS keys
    if echo "$content" | grep -qE "AKIA[0-9A-Z]{16}"; then
        patterns_found+=("AWS_ACCESS_KEY")
        found=1
    fi
    
    # Private keys
    if echo "$content" | grep -q "BEGIN.*PRIVATE KEY"; then
        patterns_found+=("PRIVATE_KEY")
        found=1
    fi
    
    # API keys (generic)
    if echo "$content" | grep -qiE "(api[_-]?key|apikey)[\"\']?\s*[:=]\s*[\"\']?[a-zA-Z0-9]{20,}"; then
        patterns_found+=("API_KEY")
        found=1
    fi
    
    # Database connection strings
    if echo "$content" | grep -qiE "(mongodb://|postgresql://|mysql://|redis://).*[@:].*[@:]"; then
        patterns_found+=("DATABASE_CONNECTION_STRING")
        found=1
    fi
    
    if [ $found -eq 1 ]; then
        echo "[$timestamp] 🚨 SENSITIVE_DATA_DETECTED | SOURCE: $source | PATTERNS: ${patterns_found[*]}" >> "$MCP_RESPONSE_SCAN"
        echo "[$timestamp] CONTENT_PREVIEW: $(echo "$content" | head -c 500)" >> "$MCP_RESPONSE_SCAN"
        return 0
    fi
    
    return 1
}

# Function to update MCP server inventory
update_mcp_inventory() {
    local server_url=$(echo "$json_input" | jq -r '.url // empty')
    local server_command=$(echo "$json_input" | jq -r '.command // empty')
    local tool_name=$(echo "$json_input" | jq -r '.tool_name // empty')
    
    if [ -z "$server_url" ] && [ -z "$server_command" ]; then
        return 0
    fi
    
    # Use jq to update inventory
    local server_id
    if [ -n "$server_url" ]; then
        server_id="url:$server_url"
    else
        server_id="cmd:$server_command"
    fi
    
    # Check if server exists in inventory
    local exists=$(jq -r ".servers[] | select(.id == \"$server_id\")" "$MCP_INVENTORY")
    
    if [ -z "$exists" ]; then
        # Add new server
        local server_entry=$(jq -n \
            --arg id "$server_id" \
            --arg url "$server_url" \
            --arg cmd "$server_command" \
            --arg timestamp "$timestamp" \
            '{id: $id, url: $url, command: $cmd, first_seen: $timestamp, last_seen: $timestamp, tools: []}')
        
        jq --argjson entry "$server_entry" '.servers += [$entry]' "$MCP_INVENTORY" > "${MCP_INVENTORY}.tmp" && \
            mv "${MCP_INVENTORY}.tmp" "$MCP_INVENTORY"
        
        echo "[$timestamp] 📋 NEW_MCP_SERVER | ID: $server_id | URL: $server_url | CMD: $server_command" >> "$MCP_USAGE_LOG"
    else
        # Update last_seen
        jq --arg id "$server_id" --arg timestamp "$timestamp" \
            '(.servers[] | select(.id == $id) | .last_seen) = $timestamp' "$MCP_INVENTORY" > "${MCP_INVENTORY}.tmp" && \
            mv "${MCP_INVENTORY}.tmp" "$MCP_INVENTORY"
    fi
    
    # Update tool inventory
    if [ -n "$tool_name" ]; then
        # Track tool usage
        local tool_entry=$(jq -n \
            --arg tool "$tool_name" \
            --arg server "$server_id" \
            --arg timestamp "$timestamp" \
            '{tool: $tool, server: $server, first_seen: $timestamp, last_seen: $timestamp, usage_count: 1}')
        
        # Check if tool exists
        local tool_exists=$(jq -r ".tools[\"$tool_name\"]" "$MCP_INVENTORY")
        if [ "$tool_exists" = "null" ]; then
            jq --arg tool "$tool_name" --argjson entry "$tool_entry" '.tools[$tool] = $entry' "$MCP_INVENTORY" > "${MCP_INVENTORY}.tmp" && \
                mv "${MCP_INVENTORY}.tmp" "$MCP_INVENTORY"
        else
            # Update usage count and last_seen
            jq --arg tool "$tool_name" --arg timestamp "$timestamp" \
                '.tools[$tool].usage_count += 1 | .tools[$tool].last_seen = $timestamp' "$MCP_INVENTORY" > "${MCP_INVENTORY}.tmp" && \
                mv "${MCP_INVENTORY}.tmp" "$MCP_INVENTORY"
        fi
    fi
    
    # Update inventory timestamp
    jq --arg timestamp "$timestamp" '.last_updated = $timestamp' "$MCP_INVENTORY" > "${MCP_INVENTORY}.tmp" && \
        mv "${MCP_INVENTORY}.tmp" "$MCP_INVENTORY"
}

# Function to analyze tool usage patterns
analyze_usage_patterns() {
    local tool_name=$(echo "$json_input" | jq -r '.tool_name // empty')
    local tool_input=$(echo "$json_input" | jq -r '.tool_input // empty')
    local duration=$(echo "$json_input" | jq -r '.duration // 0')
    local server_url=$(echo "$json_input" | jq -r '.url // empty')
    local server_command=$(echo "$json_input" | jq -r '.command // empty')
    
    if [ -z "$tool_name" ]; then
        return 0
    fi
    
    # Log usage pattern
    echo "[$timestamp] 🔌 TOOL_USAGE | TOOL: $tool_name | USER: $user_email | DURATION: ${duration}ms | CONV: $conversation_id" >> "$MCP_USAGE_LOG"
    
    # Analyze input patterns (first 500 chars)
    if [ -n "$tool_input" ]; then
        local input_preview=$(echo "$tool_input" | head -c 500)
        echo "[$timestamp] 📥 TOOL_INPUT | TOOL: $tool_name | PREVIEW: $input_preview" >> "$MCP_USAGE_LOG"
        
        # Check for sensitive data in input
        scan_for_sensitive_data "$tool_input" "MCP_TOOL_INPUT:$tool_name"
    fi
    
    # Categorize tool by name patterns
    local category="unknown"
    if echo "$tool_name" | grep -qiE "(read|get|fetch|list|search)"; then
        category="read"
    elif echo "$tool_name" | grep -qiE "(write|create|add|insert|update|set)"; then
        category="write"
    elif echo "$tool_name" | grep -qiE "(delete|remove|drop|destroy|clear)"; then
        category="destructive"
    elif echo "$tool_name" | grep -qiE "(execute|run|call|invoke)"; then
        category="execution"
    elif echo "$tool_name" | grep -qiE "(search|query|find|lookup)"; then
        category="query"
    fi
    
    # Log metrics
    echo "$iso_timestamp,$tool_name,$category,$duration,$user_email,$model,$conversation_id" >> "$MCP_METRICS"
}

# Function to scan MCP tool responses
scan_mcp_response() {
    local tool_name=$(echo "$json_input" | jq -r '.tool_name // empty')
    local result_json=$(echo "$json_input" | jq -r '.result_json // empty')
    
    if [ -z "$tool_name" ] || [ -z "$result_json" ]; then
        return 0
    fi
    
    # Scan result JSON for sensitive data
    scan_for_sensitive_data "$result_json" "MCP_TOOL_RESPONSE:$tool_name"
    
    # Log response size
    local response_size=$(echo "$result_json" | wc -c)
    if [ $response_size -gt 100000 ]; then
        echo "[$timestamp] ⚠️  LARGE_RESPONSE | TOOL: $tool_name | SIZE: $response_size bytes" >> "$MCP_RESPONSE_SCAN"
    fi
}

# Process hook events
case "$hook_event" in
  "beforeMCPExecution")
    tool_name=$(echo "$json_input" | jq -r '.tool_name // empty')
    
    # Update inventory
    update_mcp_inventory
    
    # Log tool request
    echo "[$timestamp] 🔌 MCP_TOOL_REQUEST | TOOL: $tool_name | USER: $user_email | CONV: $conversation_id" >> "$MCP_USAGE_LOG"
    
    # Check tool input for sensitive data BEFORE execution
    tool_input=$(echo "$json_input" | jq -r '.tool_input // empty')
    if [ -n "$tool_input" ]; then
        if scan_for_sensitive_data "$tool_input" "MCP_TOOL_INPUT:$tool_name"; then
            echo "[$timestamp] 🚨 SENSITIVE_DATA_IN_INPUT | TOOL: $tool_name | USER: $user_email" >> "$MCP_RESPONSE_SCAN"
        fi
    fi
    ;;
    
  "afterMCPExecution")
    tool_name=$(echo "$json_input" | jq -r '.tool_name // empty')
    result_json=$(echo "$json_input" | jq -r '.result_json // empty')
    duration=$(echo "$json_input" | jq -r '.duration // 0')
    
    # Analyze usage patterns
    analyze_usage_patterns
    
    # Scan response for sensitive data
    scan_mcp_response
    
    # Log successful execution
    echo "[$timestamp] ✅ MCP_TOOL_COMPLETED | TOOL: $tool_name | USER: $user_email | DURATION: ${duration}ms" >> "$MCP_USAGE_LOG"
    ;;
esac

exit 0

