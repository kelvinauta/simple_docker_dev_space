#!/bin/bash

load_environment() {
    source .env
}

determine_execution_mode() {
    MODE="production"
    COMMAND="bun run start"

    if [ "$DEV_MODE" = "true" ]; then
        MODE="development"
        COMMAND="tail -f /dev/null"
    fi
}

print_mode_status() {
    echo "Running in ${MODE} mode..."
}

execute_command() {
    exec $COMMAND
}

load_environment
determine_execution_mode
print_mode_status
execute_command