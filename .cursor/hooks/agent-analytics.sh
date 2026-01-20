#!/bin/bash
# agent-analytics.sh - Agent behavior analytics and metrics
# Tracks agent responses, thinking patterns, and performance metrics

# Configuration
AUDIT_DIR="${HOME}/.cursor/audit"
ANALYTICS_LOG="${AUDIT_DIR}/agent-analytics.log"
THINKING_LOG="${AUDIT_DIR}/agent-thinking-patterns.log"
METRICS_CSV="${AUDIT_DIR}/agent-metrics.csv"

# Create audit directory
mkdir -p "${AUDIT_DIR}"

# Read JSON input
json_input=$(cat)

# Extract common fields
hook_event=$(echo "$json_input" | jq -r '.hook_event_name // "unknown"')
conversation_id=$(echo "$json_input" | jq -r '.conversation_id // "none"')
user_email=$(echo "$json_input" | jq -r '.user_email // "anonymous"')
model=$(echo "$json_input" | jq -r '.model // "unknown"')
generation_id=$(echo "$json_input" | jq -r '.generation_id // "none"')
timestamp=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
iso_timestamp="$timestamp"
epoch_timestamp=$(date +%s)

# Process hook events
case "$hook_event" in
  "afterAgentResponse")
    text=$(echo "$json_input" | jq -r '.text // empty')
    text_length=${#text}
    word_count=$(echo "$text" | wc -w)
    
    # Analyze response characteristics
    has_code=$(echo "$text" | grep -q "```" && echo "yes" || echo "no")
    has_links=$(echo "$text" | grep -qE "https?://" && echo "yes" || echo "no")
    has_files=$(echo "$text" | grep -qE "file:|path:" && echo "yes" || echo "no")
    
    # Log analytics
    echo "[$timestamp] 📊 AGENT_RESPONSE | CONV: $conversation_id | GENERATION: $generation_id | USER: $user_email | MODEL: $model | LENGTH: $text_length | WORDS: $word_count | HAS_CODE: $has_code | HAS_LINKS: $has_links | HAS_FILES: $has_files" >> "$ANALYTICS_LOG"
    
    # Log metrics
    echo "$iso_timestamp,agent_response,$conversation_id,$generation_id,$text_length,$word_count,$has_code,$has_links,$has_files,$user_email,$model" >> "$METRICS_CSV"
    ;;
    
  "afterAgentThought")
    text=$(echo "$json_input" | jq -r '.text // empty')
    duration_ms=$(echo "$json_input" | jq -r '.duration_ms // 0')
    text_length=${#text}
    
    # Analyze thinking patterns
    # Check for operator sequences mentioned
    operator_mentions=$(echo "$text" | grep -oiE "(ortho|kata|para|ana|weave|bind|meta|retro|latch|seed|axis|flux|pro|non|crux|braid|fold|telo|echo|vale)" | wc -l | tr -d ' ')
    
    # Check for state detection
    state_mentions=$(echo "$text" | grep -oiE "(J=0|S\*|Void|collapse|sterile|productive)" | wc -l | tr -d ' ')
    
    # Check for mode mentions
    mode_mentions=$(echo "$text" | grep -oiE "(Mode 1|Mode 2|HALIRA|Duality Navigation)" | wc -l | tr -d ' ')
    
    # Log thinking patterns
    echo "[$timestamp] 🧠 AGENT_THINKING | CONV: $conversation_id | GENERATION: $generation_id | DURATION: ${duration_ms}ms | LENGTH: $text_length | OPERATORS: $operator_mentions | STATES: $state_mentions | MODES: $mode_mentions" >> "$THINKING_LOG"
    
    # Log thinking content preview (first 500 chars)
    thinking_preview=$(echo "$text" | head -c 500)
    echo "[$timestamp] THINKING_PREVIEW: $thinking_preview" >> "$THINKING_LOG"
    
    # Log metrics
    echo "$iso_timestamp,agent_thinking,$conversation_id,$generation_id,$duration_ms,$text_length,$operator_mentions,$state_mentions,$mode_mentions,$user_email,$model" >> "$METRICS_CSV"
    ;;
    
  "stop")
    status=$(echo "$json_input" | jq -r '.status // "unknown"')
    loop_count=$(echo "$json_input" | jq -r '.loop_count // 0')
    
    # Log agent completion
    echo "[$timestamp] 🏁 AGENT_STOP | CONV: $conversation_id | STATUS: $status | LOOP_COUNT: $loop_count | USER: $user_email" >> "$ANALYTICS_LOG"
    
    # Log metrics
    echo "$iso_timestamp,agent_stop,$conversation_id,$status,$loop_count,$user_email,$model" >> "$METRICS_CSV"
    ;;
esac

exit 0

