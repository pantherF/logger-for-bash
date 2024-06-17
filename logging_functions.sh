#!/bin/bash

# Define log file
TIMESTAMP=$(date +"%s")
if [ -n "$LOG_FILE_PATH" ] && [ -d "$LOG_FILE_PATH" ]; then
    LOG_FILE="${LOG_FILE_PATH}${LOG_NAME}_${TIMESTAMP}.log"
else
    echo "Warning: Invalid or undefined LOG_FILE_PATH. Using default log file path." >&2
    LOG_FILE="${TIMESTAMP}.log"
    echo "Default log file path: $(pwd)/$(basename "$LOG_FILE")" >&2
fi

# Log levels
INFO="INFO"
WARN="WARN"
ERROR="ERROR"
DEBUG="DEBUG"

# Function to log messages
log() {
    local LEVEL=$1
    local MESSAGE=$2
    local TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")
    echo -e "$TIMESTAMP [$LEVEL] : $MESSAGE" | tee -a $LOG_FILE
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