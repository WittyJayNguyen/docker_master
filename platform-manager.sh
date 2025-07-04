#!/bin/bash

# Platform Manager Script
# Quản lý các platform Docker Compose một cách modular

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Auto-discover platforms from platforms/ directory
get_platforms() {
    local platforms=()

    # Tìm tất cả thư mục trong platforms/ (trừ templates và base)
    for dir in platforms/*/; do
        if [ -d "$dir" ]; then
            platform_name=$(basename "$dir")
            # Bỏ qua thư mục templates và base
            if [[ "$platform_name" != "templates" && "$platform_name" != "base" ]]; then
                # Kiểm tra có file docker-compose trong thư mục không
                if ls "$dir"docker-compose.*.yml 1> /dev/null 2>&1; then
                    platforms+=("$platform_name")
                fi
            fi
        fi
    done

    echo "${platforms[@]}"
}

# Get available platforms dynamically
PLATFORMS=($(get_platforms))

# Function to print colored output
print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_header() {
    echo -e "${BLUE}================================${NC}"
    echo -e "${BLUE}  Docker Platform Manager${NC}"
    echo -e "${BLUE}================================${NC}"
}

# Function to show usage
show_usage() {
    echo "Usage: $0 [COMMAND] [PLATFORM]"
    echo ""
    echo "Commands:"
    echo "  start [platform]     - Start specific platform or all"
    echo "  stop [platform]      - Stop specific platform or all"
    echo "  restart [platform]   - Restart specific platform or all"
    echo "  status              - Show status of all platforms"
    echo "  logs [platform]     - Show logs for specific platform"
    echo "  build [platform]    - Build specific platform"
    echo "  list                - List available platforms"
    echo "  setup               - Initial setup (create network, etc.)"
    echo ""
    echo "Available Platforms:"
    for platform in "${PLATFORMS[@]}"; do
        echo "  - $platform"
    done
    echo ""
    echo "Examples:"
    echo "  $0 start shared                    # Start only shared services"
    echo "  $0 start laravel-ecommerce        # Start Laravel e-commerce"
    echo "  $0 start                          # Start all platforms"
    echo "  $0 stop wordpress                 # Stop WordPress platform"
    echo "  $0 logs laravel-ecommerce         # Show Laravel logs"
}

# Function to check if platform exists
platform_exists() {
    local platform=$1
    for p in "${PLATFORMS[@]}"; do
        if [[ $p == $platform ]]; then
            return 0
        fi
    done
    return 1
}

# Function to setup initial environment
setup_environment() {
    print_status "Setting up Docker environment..."
    
    # Create network if it doesn't exist
    if ! docker network ls | grep -q "docker_master_network"; then
        print_status "Creating Docker network: docker_master_network"
        docker network create docker_master_network
    else
        print_status "Docker network already exists"
    fi
    
    # Create necessary directories
    print_status "Creating necessary directories..."
    mkdir -p data/{mysql,postgres,redis}
    mkdir -p logs/apache/{laravel_ecommerce,wordpress}
    mkdir -p data/uploads/{laravel_ecommerce,wordpress}
    
    print_status "Environment setup completed!"
}

# Function to start platform(s)
start_platform() {
    local platform=$1
    
    if [[ -z $platform ]]; then
        print_status "Starting all platforms..."
        docker-compose up -d
    else
        if platform_exists $platform; then
            print_status "Starting platform: $platform"
            docker-compose -f platforms/$platform/docker-compose.$platform.yml up -d
        else
            print_error "Platform '$platform' not found!"
            return 1
        fi
    fi
}

# Function to stop platform(s)
stop_platform() {
    local platform=$1
    
    if [[ -z $platform ]]; then
        print_status "Stopping all platforms..."
        docker-compose down
    else
        if platform_exists $platform; then
            print_status "Stopping platform: $platform"
            docker-compose -f platforms/$platform/docker-compose.$platform.yml down
        else
            print_error "Platform '$platform' not found!"
            return 1
        fi
    fi
}

# Function to restart platform(s)
restart_platform() {
    local platform=$1
    
    print_status "Restarting platform: ${platform:-all}"
    stop_platform $platform
    sleep 2
    start_platform $platform
}

# Function to show platform status
show_status() {
    print_status "Platform Status:"
    echo ""

    # Show status for each platform
    for platform in "${PLATFORMS[@]}"; do
        if [[ -f "platforms/$platform/docker-compose.$platform.yml" ]]; then
            echo -e "${GREEN}=== $platform Platform ===${NC}"
            docker-compose -f platforms/$platform/docker-compose.$platform.yml ps
            echo ""
        fi
    done

    # Show all containers
    echo -e "${GREEN}=== All Containers ===${NC}"
    docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
}

# Function to show logs
show_logs() {
    local platform=$1
    
    if [[ -z $platform ]]; then
        print_status "Showing logs for all platforms..."
        docker-compose logs -f
    else
        if platform_exists $platform; then
            print_status "Showing logs for platform: $platform"
            docker-compose -f platforms/$platform/docker-compose.$platform.yml logs -f
        else
            print_error "Platform '$platform' not found!"
            return 1
        fi
    fi
}

# Function to build platform
build_platform() {
    local platform=$1
    
    if [[ -z $platform ]]; then
        print_status "Building all platforms..."
        docker-compose build
    else
        if platform_exists $platform; then
            print_status "Building platform: $platform"
            docker-compose -f platforms/$platform/docker-compose.$platform.yml build
        else
            print_error "Platform '$platform' not found!"
            return 1
        fi
    fi
}

# Function to list platforms
list_platforms() {
    print_status "Available Platforms (auto-discovered):"
    local platforms=($(get_platforms))

    if [ ${#platforms[@]} -eq 0 ]; then
        echo -e "  ${RED}❌${NC} No platforms found in platforms/ directory"
        echo -e "  ${YELLOW}💡${NC} Create a platform using: ./create-platform.sh <type> <name> <port>"
        return
    fi

    for platform in "${platforms[@]}"; do
        local compose_file=""
        # Tìm file docker-compose trong thư mục platform
        for file in platforms/$platform/docker-compose.*.yml; do
            if [ -f "$file" ]; then
                compose_file=$(basename "$file")
                break
            fi
        done

        echo -e "  ${GREEN}✓${NC} $platform (${compose_file})"
    done

    echo ""
    echo -e "${YELLOW}💡 To add new platform:${NC}"
    echo "   1. Create folder: mkdir platforms/my-new-project"
    echo "   2. Add docker-compose file: platforms/my-new-project/docker-compose.my-new-project.yml"
    echo "   3. Platform will be auto-discovered!"
}

# Main script logic
print_header

case $1 in
    start)
        setup_environment
        start_platform $2
        ;;
    stop)
        stop_platform $2
        ;;
    restart)
        restart_platform $2
        ;;
    status)
        show_status
        ;;
    logs)
        show_logs $2
        ;;
    build)
        build_platform $2
        ;;
    list)
        list_platforms
        ;;
    setup)
        setup_environment
        ;;
    *)
        show_usage
        exit 1
        ;;
esac
