#! /bin/bash

WORKSPACE_NAME=workspace
COMMAND="bun run dev"
BUILD_FLAG=""

handle_build_flag() {
    if [ "$1" == "--build" ]; then
        BUILD_FLAG="--build"
    fi
}

ensure_dev_mode() {
    if ! grep -q "DEV_MODE=true" .env; then
        echo "DEV_MODE=true" > .env
    fi
}

stop_containers() {
    echo "Stopping containers..."
    docker compose down
    exit 0
}

start_containers() {
    docker compose up -d $BUILD_FLAG
}

execute_workspace_command() {
    docker exec -t $WORKSPACE_NAME /bin/bash -c "trap 'exit 0' SIGINT SIGTERM; $COMMAND"
}

check_workspace_status() {
    if ! docker ps | grep -q $WORKSPACE_NAME; then
        echo "Error: Container $WORKSPACE_NAME is not running"
        echo "Checking container logs:"
        docker compose logs workspace
        stop_containers
    fi
}

trap stop_containers SIGINT SIGTERM

handle_build_flag "$1"
ensure_dev_mode
start_containers
check_workspace_status
execute_workspace_command
