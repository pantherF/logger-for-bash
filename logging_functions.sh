#!/bin/bash

if [ -z "$LOG_NAME" ]; then
    LOG_NAME="log"
fi

# Define log file
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
if [ -n "$LOG_FILE_PATH" ] && [ -d "$LOG_FILE_PATH" ]; then
    LOG_FILE="${LOG_FILE_PATH}${LOG_NAME}_${TIMESTAMP}.log"
else
    echo "$(date +"%Y-%m-%d %H:%M:%S") [WARNING] : No logfile defined. Logs will not be written to a file." >&2
fi

# Log levels
INFO="INFO"
WARN="WARNING"
ERROR="ERROR"
DEBUG="DEBUG"

# Function to log messages
log() {
    local LEVEL=$1
    local MESSAGE=$2
    local TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")
    echo -e "$TIMESTAMP [$LEVEL] : $MESSAGE " | tee -a $LOG_FILE
}

# Function to execute commands and log their output
log_and_run() {
    local CMD="$@"
    log $INFO "Executing: '$CMD'"

    OUTPUT=$(eval "$CMD" 2>&1)
    STATUS=$?

    if [ -n "$OUTPUT" ]; then
        echo "$OUTPUT" | while IFS= read -r line; do
            # Skip logging empty lines
            if [ -n "$line" ]; then
                if [ $STATUS -ne 0 ]; then
                    log $ERROR "$line"
                else
                    log $DEBUG "$line"
                fi
            fi
        done
    else
        if $CMD; then
            log $INFO "Command '$CMD' executed successfully."
        else
            log $ERROR "Failed to execute command '$CMD' ."
        fi
    fi

    if [ $STATUS -ne 0 ]; then
        log $ERROR "Command failed with status code $STATUS"
    fi
    
    return $STATUS
}