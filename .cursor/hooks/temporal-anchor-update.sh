#!/bin/bash
# temporal-anchor-update.sh - Updates .cursor/.timestamp-reference BEFORE file operations
# Ensures temporal anchor exists and is current before any file edit/write
# This is critical for date/time references in cursor rules

json_input=$(cat)
hook_event=$(echo "$json_input" | jq -r '.hook_event_name // "unknown"')

# Path to temporal anchor file (used by cursor rules for date/time references)
TIMESTAMP_REF=".cursor/.timestamp-reference"
TIMESTAMP_DIR=$(dirname "$TIMESTAMP_REF")

# Create directory if it doesn't exist
mkdir -p "$TIMESTAMP_DIR"

# Update timestamp reference file for time detection
# Strategy: Create a temp file, get its creation date, recreate reference file, then delete temp file
# This ensures the reference file has the current creation timestamp

# Create a temporary file to establish current creation date
TEMP_FILE=$(mktemp "$TIMESTAMP_DIR/.timestamp-temp-XXXXXX" 2>/dev/null)

# If mktemp fails, use a simpler approach
if [ ! -f "$TEMP_FILE" ]; then
    TEMP_FILE="${TIMESTAMP_DIR}/.timestamp-temp-$$"
    touch "$TEMP_FILE"
fi

# Get the creation date from the temporary file
if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS: Get birth time (creation time)
    TEMP_CREATION_DATE=$(stat -f "%Sm" -t "%Y-%m-%d" "$TEMP_FILE" 2>/dev/null || date -u +"%Y-%m-%d")
    TEMP_CREATION_TIME=$(stat -f "%Sm" -t "%H:%M:%S" "$TEMP_FILE" 2>/dev/null || date -u +"%H:%M:%S")
    TEMP_CREATION_TIMESTAMP=$(stat -f "%Sm" -t "%Y-%m-%dT%H:%M:%SZ" "$TEMP_FILE" 2>/dev/null || date -u +"%Y-%m-%dT%H:%M:%SZ")
else
    # Linux: Get birth time or modification time as fallback
    TEMP_CREATION_DATE=$(stat -c "%w" "$TEMP_FILE" 2>/dev/null || stat -c "%y" "$TEMP_FILE" 2>/dev/null | cut -d' ' -f1 || date -u +"%Y-%m-%d")
    TEMP_CREATION_TIME=$(stat -c "%w" "$TEMP_FILE" 2>/dev/null || stat -c "%y" "$TEMP_FILE" 2>/dev/null | cut -d' ' -f2 | cut -d'.' -f1 || date -u +"%H:%M:%S")
    TEMP_CREATION_TIMESTAMP="${TEMP_CREATION_DATE}T${TEMP_CREATION_TIME}Z"
fi

# Delete the old timestamp reference file if it exists
if [ -f "$TIMESTAMP_REF" ]; then
    rm -f "$TIMESTAMP_REF"
fi

# Recreate the timestamp reference file immediately after temp file
# Both files will have the same creation date since they're created in quick succession
touch "$TIMESTAMP_REF"

# Get the creation date from the newly created timestamp reference file
if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS: Get birth time (creation time) from the reference file
    REF_CREATION_DATE=$(stat -f "%Sm" -t "%Y-%m-%d" "$TIMESTAMP_REF" 2>/dev/null || date -u +"%Y-%m-%d")
    REF_CREATION_TIME=$(stat -f "%Sm" -t "%H:%M:%S" "$TIMESTAMP_REF" 2>/dev/null || date -u +"%H:%M:%S")
    REF_CREATION_TIMESTAMP=$(stat -f "%Sm" -t "%Y-%m-%dT%H:%M:%SZ" "$TIMESTAMP_REF" 2>/dev/null || date -u +"%Y-%m-%dT%H:%M:%SZ")
else
    # Linux: Get birth time or modification time as fallback
    REF_CREATION_DATE=$(stat -c "%w" "$TIMESTAMP_REF" 2>/dev/null || stat -c "%y" "$TIMESTAMP_REF" 2>/dev/null | cut -d' ' -f1 || date -u +"%Y-%m-%d")
    REF_CREATION_TIME=$(stat -c "%w" "$TIMESTAMP_REF" 2>/dev/null || stat -c "%y" "$TIMESTAMP_REF" 2>/dev/null | cut -d' ' -f2 | cut -d'.' -f1 || date -u +"%H:%M:%S")
    REF_CREATION_TIMESTAMP="${REF_CREATION_DATE}T${REF_CREATION_TIME}Z"
fi

# Clean up temporary file
rm -f "$TEMP_FILE"

# Log the update (optional, for debugging)
# TIMESTAMP_LOG="${HOME}/.cursor/audit/temporal-anchor-updates.log"
# mkdir -p "${HOME}/.cursor/audit"
# echo "[$(date '+%Y-%m-%d %H:%M:%S')] TEMPORAL_ANCHOR_UPDATED | EVENT=$hook_event | TIMESTAMP=$REF_CREATION_TIMESTAMP" >> "$TIMESTAMP_LOG" 2>/dev/null || true

# Exit successfully (this hook doesn't block operations)
exit 0
