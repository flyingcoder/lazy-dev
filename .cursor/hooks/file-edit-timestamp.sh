#!/bin/bash
# file-edit-timestamp.sh - Detects and logs current date/time before file edits
# Provides detailed timestamp information for file operations

json_input=$(cat)
hook_event=$(echo "$json_input" | jq -r '.hook_event_name')

# Enhanced date/time detection with multiple formats
timestamp=$(date '+%Y-%m-%d %H:%M:%S')
iso_timestamp=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
local_timestamp=$(date '+%Y-%m-%dT%H:%M:%S%z')
epoch_timestamp=$(date +%s)
readable_date=$(date '+%A, %B %d, %Y')
readable_time=$(date '+%I:%M:%S %p %Z')
timezone=$(date +%Z)
day_of_week=$(date '+%A')
week_number=$(date +%V)
year_day=$(date +%j)

TIMESTAMP_LOG="${HOME}/.cursor/audit/file-edit-timestamps.log"
mkdir -p "${HOME}/.cursor/audit"

case "$hook_event" in
  "beforeReadFile")
    file_path=$(echo "$json_input" | jq -r '.file_path // "unknown"')
    user_email=$(echo "$json_input" | jq -r '.user_email // "anonymous"')
    
    # Log detailed timestamp information before file read (often precedes edit)
    cat >> "${TIMESTAMP_LOG}" << EOF
[$timestamp] BEFORE_FILE_READ
  File: $file_path
  User: $user_email
  Timestamp: $timestamp
  ISO 8601 (UTC): $iso_timestamp
  Local ISO: $local_timestamp
  Epoch: $epoch_timestamp
  Readable Date: $readable_date
  Readable Time: $readable_time
  Timezone: $timezone
  Day of Week: $day_of_week
  Week Number: $week_number
  Day of Year: $year_day
---
EOF
    ;;
    
  "afterFileEdit")
    file_path=$(echo "$json_input" | jq -r '.file_path')
    edit_count=$(echo "$json_input" | jq -r '.edits | length')
    user_email=$(echo "$json_input" | jq -r '.user_email // "anonymous"')
    
    # Log detailed timestamp information after file edit
    cat >> "${TIMESTAMP_LOG}" << EOF
[$timestamp] AFTER_FILE_EDIT
  File: $file_path
  User: $user_email
  Edit Count: $edit_count
  Timestamp: $timestamp
  ISO 8601 (UTC): $iso_timestamp
  Local ISO: $local_timestamp
  Epoch: $epoch_timestamp
  Readable Date: $readable_date
  Readable Time: $readable_time
  Timezone: $timezone
  Day of Week: $day_of_week
  Week Number: $week_number
  Day of Year: $year_day
---
EOF
    ;;
    
  "afterTabFileEdit")
    file_path=$(echo "$json_input" | jq -r '.file_path')
    edit_count=$(echo "$json_input" | jq -r '.edits | length')
    user_email=$(echo "$json_input" | jq -r '.user_email // "anonymous"')
    
    # Log detailed timestamp information after Tab file edit
    cat >> "${TIMESTAMP_LOG}" << EOF
[$timestamp] AFTER_TAB_FILE_EDIT
  File: $file_path
  User: $user_email
  Edit Count: $edit_count
  Timestamp: $timestamp
  ISO 8601 (UTC): $iso_timestamp
  Local ISO: $local_timestamp
  Epoch: $epoch_timestamp
  Readable Date: $readable_date
  Readable Time: $readable_time
  Timezone: $timezone
  Day of Week: $day_of_week
  Week Number: $week_number
  Day of Year: $year_day
---
EOF
    ;;
esac

exit 0
