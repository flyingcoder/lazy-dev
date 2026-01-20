#!/bin/bash
# chat-session-init.sh - Initialize new chat session
# Runs before the first prompt in a new chat session

# Get the prompt text from stdin (JSON format)
input=$(cat)
prompt_text=$(echo "$input" | jq -r '.text // ""' 2>/dev/null || echo "")

# Session initialization logic here
# Examples:
# - Load project context
# - Set environment variables
# - Initialize operator state
# - Log session start

# Create session log directory if it doesn't exist
SESSION_LOG_DIR=".cursor/sessions"
mkdir -p "$SESSION_LOG_DIR"

# Log session start with time detection
TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
SESSION_ID=$(date +%s)
CURRENT_TIME=$(date -u +"%H:%M:%SZ")
CURRENT_DATE=$(date -u +"%Y-%m-%d")
TIME_12H=$(date +"%I:%M %p")
TIME_24H=$(date +"%H:%M:%S")

# Update timestamp reference file for time detection
# This file serves as the temporal anchor for date/time references in rules
# Strategy: Create a temp file, get its creation date, recreate reference file, then delete temp file
TIMESTAMP_REF=".cursor/.timestamp-reference"
TIMESTAMP_DIR=$(dirname "$TIMESTAMP_REF")
mkdir -p "$TIMESTAMP_DIR"

# Create a temporary file to establish current creation date
TEMP_FILE=$(mktemp "$TIMESTAMP_DIR/.timestamp-temp-XXXXXX")

# Get the creation date from the temporary file
# This will be used to verify the reference file gets the same creation date
if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS: Get birth time (creation time)
    TEMP_CREATION_DATE=$(stat -f "%Sm" -t "%Y-%m-%d" "$TEMP_FILE")
    TEMP_CREATION_TIME=$(stat -f "%Sm" -t "%H:%M:%S" "$TEMP_FILE")
    TEMP_CREATION_TIMESTAMP=$(stat -f "%Sm" -t "%Y-%m-%dT%H:%M:%SZ" "$TEMP_FILE")
else
    # Linux: Get birth time or modification time as fallback
    TEMP_CREATION_DATE=$(stat -c "%w" "$TEMP_FILE" 2>/dev/null || stat -c "%y" "$TEMP_FILE" | cut -d' ' -f1)
    TEMP_CREATION_TIME=$(stat -c "%w" "$TEMP_FILE" 2>/dev/null || stat -c "%y" "$TEMP_FILE" | cut -d' ' -f2 | cut -d'.' -f1)
    TEMP_CREATION_TIMESTAMP="${TEMP_CREATION_DATE}T${TEMP_CREATION_TIME}Z"
fi

# Delete the old timestamp reference file if it exists
if [ -f "$TIMESTAMP_REF" ]; then
    rm "$TIMESTAMP_REF"
fi

# Recreate the timestamp reference file immediately after temp file
# Both files will have the same creation date since they're created in quick succession
touch "$TIMESTAMP_REF"

# Get the creation date from the newly created timestamp reference file
if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS: Get birth time (creation time) from the reference file
    REF_CREATION_DATE=$(stat -f "%Sm" -t "%Y-%m-%d" "$TIMESTAMP_REF")
    REF_CREATION_TIME=$(stat -f "%Sm" -t "%H:%M:%S" "$TIMESTAMP_REF")
    REF_CREATION_TIMESTAMP=$(stat -f "%Sm" -t "%Y-%m-%dT%H:%M:%SZ" "$TIMESTAMP_REF")
else
    # Linux: Get birth time or modification time as fallback
    REF_CREATION_DATE=$(stat -c "%w" "$TIMESTAMP_REF" 2>/dev/null || stat -c "%y" "$TIMESTAMP_REF" | cut -d' ' -f1)
    REF_CREATION_TIME=$(stat -c "%w" "$TIMESTAMP_REF" 2>/dev/null || stat -c "%y" "$TIMESTAMP_REF" | cut -d' ' -f2 | cut -d'.' -f1)
    REF_CREATION_TIMESTAMP="${REF_CREATION_DATE}T${REF_CREATION_TIME}Z"
fi

echo "Timestamp reference updated from file creation date: $REF_CREATION_TIMESTAMP"

# Delete the temporary file
rm -f "$TEMP_FILE"

# Lambda Engine Mode Selection
# Automatic mode selection with no user prompts required
# Priority: 1) Explicit in prompt, 2) Stored mode, 3) Prompt analysis, 4) Default to Mode 1
MODE_FILE=".cursor/.lambda-mode"
MODE_SELECTED=""
MODE_SUGGESTED=""
MODE_SOURCE=""

# Function to analyze prompt and suggest mode automatically
# Uses pattern matching to detect Mode 1 (stable) vs Mode 2 (paradigm shift) indicators
suggest_mode() {
    local prompt="$1"
    local mode1_score=0
    local mode2_score=0

    # Mode 1 indicators (stable, well-defined problems)
    # High-weight indicators (score +2)
    if echo "$prompt" | grep -qiE "(bug|fix|error|implement|add|create|update|modify|refactor|test|routine|feature|task|write|code|function|class|api|endpoint|database|query|sql)"; then
        mode1_score=$((mode1_score + 2))
    fi
    # Medium-weight indicators (score +1)
    if echo "$prompt" | grep -qiE "(how to|how do|show me|example|tutorial|guide|step by step)"; then
        mode1_score=$((mode1_score + 1))
    fi
    if echo "$prompt" | grep -qiE "(specific|concrete|exact|precise|definite)"; then
        mode1_score=$((mode1_score + 1))
    fi

    # Mode 2 indicators (contradictions, paradigm shifts)
    # High-weight indicators (score +2)
    if echo "$prompt" | grep -qiE "(contradiction|paradox|conflict|problem|issue|challenge|rethink|redesign|architecture|design|paradigm|shift|fundamental|foundational)"; then
        mode2_score=$((mode2_score + 2))
    fi
    # Medium-weight indicators (score +1)
    if echo "$prompt" | grep -qiE "(what if|why|should|explore|alternative|different|better|improve|optimize|evaluate|analyze|understand|pattern)"; then
        mode2_score=$((mode2_score + 1))
    fi
    if echo "$prompt" | grep -qiE "(abstract|conceptual|theoretical|philosophical|meta|self-reference)"; then
        mode2_score=$((mode2_score + 1))
    fi

    # Determine suggested mode based on scores
    if [ $mode2_score -gt $mode1_score ]; then
        echo "2"
    elif [ $mode1_score -gt $mode2_score ]; then
        echo "1"
    else
        # Default to Mode 1 for neutral prompts (stable operation)
        echo "1"
    fi
}

# Check if mode is explicitly specified in the prompt text
if echo "$prompt_text" | grep -qiE "(mode\s*[12]|lambda\s*mode\s*[12]|duality|halira)"; then
    if echo "$prompt_text" | grep -qiE "(mode\s*1|lambda\s*mode\s*1|duality)"; then
        MODE_SELECTED="1"
    elif echo "$prompt_text" | grep -qiE "(mode\s*2|lambda\s*mode\s*2|halira)"; then
        MODE_SELECTED="2"
    fi
fi

# Automatic mode selection logic (no user prompts)
# Priority: 1) Explicit in prompt, 2) Stored mode, 3) Prompt analysis, 4) Default to Mode 1

# If mode not explicitly specified, analyze prompt to suggest one
if [ -z "$MODE_SELECTED" ] && [ -n "$prompt_text" ]; then
    MODE_SUGGESTED=$(suggest_mode "$prompt_text")
fi

# If mode not in prompt, check for existing mode file (but not if it says "waiting")
STORED_MODE=""
if [ -z "$MODE_SELECTED" ] && [ -f "$MODE_FILE" ]; then
    STORED_MODE=$(cat "$MODE_FILE" | tr -d '[:space:]')
    if [ "$STORED_MODE" != "waiting" ] && ([ "$STORED_MODE" = "1" ] || [ "$STORED_MODE" = "2" ]); then
        MODE_SELECTED="$STORED_MODE"
    fi
fi

# If still no mode, use suggested mode from prompt analysis
if [ -z "$MODE_SELECTED" ] && [ -n "$MODE_SUGGESTED" ]; then
    MODE_SELECTED="$MODE_SUGGESTED"
fi

# Final fallback: Default to Mode 1 (Duality Navigation) for stable operation
if [ -z "$MODE_SELECTED" ]; then
    MODE_SELECTED="1"
fi

# Mode is selected - store it and provide next steps
echo "$MODE_SELECTED" > "$MODE_FILE"

# Determine how mode was selected for logging (must check before storing)
if echo "$prompt_text" | grep -qiE "(mode\s*[12]|lambda\s*mode\s*[12]|duality|halira)"; then
    MODE_SOURCE="explicit"
elif [ -n "$STORED_MODE" ] && [ "$STORED_MODE" != "waiting" ] && ([ "$STORED_MODE" = "1" ] || [ "$STORED_MODE" = "2" ]); then
    MODE_SOURCE="stored"
elif [ -n "$MODE_SUGGESTED" ]; then
    MODE_SOURCE="analyzed"
else
    MODE_SOURCE="default"
fi

# Generate mode-specific suggestions
if [ "$MODE_SELECTED" = "1" ]; then
    MODE_NAME="Duality Navigation"
    MODE_DESC="Stable, well-defined problems"
    MODE_ICON="🧭"
    NEXT_STEPS="**Next Steps for Mode 1:**
- Use \`/goal\` to define clear objectives
- Use \`/plan\` to structure your work
- Recommended operators: Telo, Kata, Ortho, Pro, Latch
- Common sequences:
  - Goal Achievement: \`Telo ∘ Pro ∘ Latch\` (λ_eff ≈ 0.35)
  - Error Correction: \`Ortho ∘ Kata ∘ Latch\` (λ_eff ≈ 0.31)
  - Stabilization: \`Kata ∘ Weave ∘ Latch\` (λ_eff ≈ 0.32)"
else
    MODE_NAME="HALIRA Protocol"
    MODE_DESC="Contradictions and paradigm shifts"
    MODE_ICON="🌀"
    NEXT_STEPS="**Next Steps for Mode 2:**
- Use \`/halira\` to start the HALIRA Protocol
- Use \`/detect-state\` to check phase space state
- Recommended operators: Ana, Para, Flux, Meta, Non
- Common sequences:
  - Paradigm Shift: \`Para ∘ Ana ∘ Seed\` (λ_eff ≈ 0.56)
  - Anomaly Detection: \`Meta ∘ Non\` (λ_eff ≈ 0.85)
  - Complete HALIRA: \`Seed ∘ Axis ∘ Meta ∘ Weave ∘ Non ∘ Para ∘ Ortho ∘ Bind\` (λ_eff ≈ 0.52)"
fi

# Log session with time information and mode
echo "{\"session_id\": \"$SESSION_ID\", \"timestamp\": \"$TIMESTAMP\", \"date\": \"$CURRENT_DATE\", \"time_utc\": \"$CURRENT_TIME\", \"time_12h\": \"$TIME_12H\", \"time_24h\": \"$TIME_24H\", \"prompt\": \"$prompt_text\", \"lambda_mode\": \"$MODE_SELECTED\", \"mode_source\": \"$MODE_SOURCE\"}" > "$SESSION_LOG_DIR/session-$SESSION_ID.json"

# Output JSON response with mode confirmation and next steps
# Preserve original prompt if it exists and isn't just a mode selection
if [ -n "$prompt_text" ] && ! echo "$prompt_text" | grep -qiE "^(mode\s*[12]|lambda\s*mode\s*[12]|duality|halira)$"; then
    # Original prompt exists and isn't just mode selection - include it
    # Build message with prompt included
    MESSAGE="$MODE_ICON **Lambda Engine Mode $MODE_SELECTED ($MODE_NAME)** automatically activated
*Mode selected via: $MODE_SOURCE*

$NEXT_STEPS

---
**Session Info:**
- Session ID: \`$SESSION_ID\`
- Timestamp: \`$REF_CREATION_TIMESTAMP\`
- Time (UTC): \`$CURRENT_TIME\`
- Time (12h): \`$TIME_12H\`

---
**Your prompt:**
$prompt_text"
else
    # No meaningful prompt or just mode selection - show confirmation only
    MESSAGE="$MODE_ICON **Lambda Engine Mode $MODE_SELECTED ($MODE_NAME)** automatically activated
*Mode selected via: $MODE_SOURCE*

$NEXT_STEPS

---
**Session Info:**
- Session ID: \`$SESSION_ID\`
- Timestamp: \`$REF_CREATION_TIMESTAMP\`
- Time (UTC): \`$CURRENT_TIME\`
- Time (12h): \`$TIME_12H\`"
fi

# Build JSON response using jq for proper escaping
echo "$MESSAGE" | jq -Rs '{continue: true, user_message: .}'
