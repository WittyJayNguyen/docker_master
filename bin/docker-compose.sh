#!/bin/bash
# Docker Master Platform - Docker Compose Wrapper (Linux/macOS)
# This script provides easy access to docker-compose with the new structure

set -e

# Set the config file path (Unix-style)
CONFIG_FILE="app/config/environments/docker-compose.cross-platform.yml"
if [ ! -f "$CONFIG_FILE" ]; then
    CONFIG_FILE="app/config/environments/docker-compose.low-ram.yml"
fi

# Check if config file exists
if [ ! -f "$CONFIG_FILE" ]; then
    echo "❌ Error: Configuration file not found: $CONFIG_FILE"
    echo "Please make sure you're running this from the docker_master root directory."
    exit 1
fi

# If no arguments provided, show help
if [ $# -eq 0 ]; then
    echo "🐳 Docker Master Platform - Docker Compose Wrapper"
    echo ""
    echo "Usage: ./docker-compose.sh [docker-compose-command]"
    echo ""
    echo "Examples:"
    echo "  ./docker-compose.sh up -d          # Start all services"
    echo "  ./docker-compose.sh down           # Stop all services"
    echo "  ./docker-compose.sh ps             # Show running containers"
    echo "  ./docker-compose.sh logs           # Show logs"
    echo "  ./docker-compose.sh restart        # Restart services"
    echo ""
    echo "Config file: $CONFIG_FILE"
    exit 0
fi

# Execute docker-compose with the config file and all arguments
echo "🚀 Running: docker-compose -f $CONFIG_FILE $*"
docker-compose -f "$CONFIG_FILE" "$@"
