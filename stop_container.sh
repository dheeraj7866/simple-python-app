#!/bin/bash

# Usage function
usage() {
    echo "Usage: $0 <container_name_or_id>"
    exit 1
}

# Check if the container name or ID is provided
if [ "$#" -ne 1 ]; then
    usage
fi

CONTAINER_NAME_OR_ID=$1

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo "Docker is not installed. Please install Docker and try again."
    exit 1
fi

# Check if the container is running
if docker ps --format '{{.Names}}' | grep -w "$CONTAINER_NAME_OR_ID" &> /dev/null; then
    echo "Stopping container: $CONTAINER_NAME_OR_ID"
    docker stop "$CONTAINER_NAME_OR_ID"
    echo "Container stopped successfully."
else
    echo "Container $CONTAINER_NAME_OR_ID is not running or does not exist."
    exit 1
fi
