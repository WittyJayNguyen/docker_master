#!/bin/bash

# Docker Development Environment Management Script
# Usage: ./bin/dev.sh [command] [options]

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
COMPOSE_FILE="$PROJECT_ROOT/docker-compose.yml"
ENV_FILE="$PROJECT_ROOT/.env"

# Load environment variables
if [ -f "$ENV_FILE" ]; then
    source "$ENV_FILE"
fi

# Helper functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if Docker is running
check_docker() {
    if ! docker info > /dev/null 2>&1; then
        log_error "Docker is not running. Please start Docker first."
        exit 1
    fi
}

# Show help
show_help() {
    echo "Docker Development Environment Management"
    echo ""
    echo "Usage: $0 [command] [options]"
    echo ""
    echo "Commands:"
    echo "  start           Start all services"
    echo "  stop            Stop all services"
    echo "  restart         Restart all services"
    echo "  build           Build all images"
    echo "  rebuild         Rebuild all images (no cache)"
    echo "  status          Show services status"
    echo "  logs [service]  Show logs for all services or specific service"
    echo "  shell [service] Open shell in service container"
    echo "  create-project  Create new project with virtual host"
    echo "  list-projects   List all projects"
    echo "  cleanup         Remove unused containers and images"
    echo "  help            Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0 start"
    echo "  $0 logs nginx"
    echo "  $0 shell php84"
    echo "  $0 create-project myproject php84 public"
    echo ""
    echo "Documentation:"
    echo "  DOCUMENTATION.md - Choose the right guide for you"
    echo "  docs/            - Detailed documentation folder"
}

# Start services
start_services() {
    log_info "Starting Docker development environment..."
    check_docker
    cd "$PROJECT_ROOT"
    docker-compose up -d
    log_success "All services started successfully!"
    show_status
}

# Stop services
stop_services() {
    log_info "Stopping Docker development environment..."
    cd "$PROJECT_ROOT"
    docker-compose down
    log_success "All services stopped successfully!"
}

# Restart services
restart_services() {
    log_info "Restarting Docker development environment..."
    stop_services
    start_services
}

# Build images
build_images() {
    log_info "Building Docker images..."
    check_docker
    cd "$PROJECT_ROOT"
    docker-compose build
    log_success "All images built successfully!"
}

# Rebuild images (no cache)
rebuild_images() {
    log_info "Rebuilding Docker images (no cache)..."
    check_docker
    cd "$PROJECT_ROOT"
    docker-compose build --no-cache
    log_success "All images rebuilt successfully!"
}

# Show status
show_status() {
    log_info "Services status:"
    cd "$PROJECT_ROOT"
    docker-compose ps
    echo ""
    log_info "Access URLs:"
    echo "  Web Server: http://localhost"
    echo "  Adminer: http://localhost:8080"
    echo "  phpMyAdmin: http://localhost:8081"
}

# Show logs
show_logs() {
    cd "$PROJECT_ROOT"
    if [ -n "$1" ]; then
        log_info "Showing logs for service: $1"
        docker-compose logs -f "$1"
    else
        log_info "Showing logs for all services"
        docker-compose logs -f
    fi
}

# Open shell in container
open_shell() {
    local service=${1:-php84}
    log_info "Opening shell in $service container..."
    cd "$PROJECT_ROOT"
    docker-compose exec "$service" /bin/sh
}

# Create new project
create_project() {
    local project_name="$1"
    local php_version="${2:-php84}"
    local public_dir="${3:-public}"
    
    if [ -z "$project_name" ]; then
        log_error "Project name is required"
        echo "Usage: $0 create-project <project_name> [php_version] [public_dir]"
        echo "Example: $0 create-project myproject php84 public"
        exit 1
    fi
    
    log_info "Creating project: $project_name"
    
    # Create project directory
    local project_path="$PROJECT_ROOT/www/$project_name"
    mkdir -p "$project_path/$public_dir"
    
    # Create basic index.php
    cat > "$project_path/$public_dir/index.php" << EOF
<?php
phpinfo();
?>
EOF
    
    # Generate nginx virtual host
    "$SCRIPT_DIR/generate-vhost.sh" "$project_name" "$php_version" "$public_dir"
    
    log_success "Project '$project_name' created successfully!"
    log_info "Project path: $project_path"
    log_info "Access URL: http://$project_name.local"
    log_warning "Don't forget to add '$project_name.local' to your hosts file!"
}

# List projects
list_projects() {
    log_info "Available projects:"
    local www_dir="$PROJECT_ROOT/www"
    if [ -d "$www_dir" ]; then
        for project in "$www_dir"/*; do
            if [ -d "$project" ]; then
                local project_name=$(basename "$project")
                echo "  - $project_name"
            fi
        done
    else
        log_warning "No projects found in $www_dir"
    fi
}

# Cleanup unused containers and images
cleanup() {
    log_info "Cleaning up unused containers and images..."
    docker system prune -f
    log_success "Cleanup completed!"
}

# Main script logic
case "$1" in
    start)
        start_services
        ;;
    stop)
        stop_services
        ;;
    restart)
        restart_services
        ;;
    build)
        build_images
        ;;
    rebuild)
        rebuild_images
        ;;
    status)
        show_status
        ;;
    logs)
        show_logs "$2"
        ;;
    shell)
        open_shell "$2"
        ;;
    create-project)
        create_project "$2" "$3" "$4"
        ;;
    list-projects)
        list_projects
        ;;
    cleanup)
        cleanup
        ;;
    help|--help|-h)
        show_help
        ;;
    *)
        log_error "Unknown command: $1"
        show_help
        exit 1
        ;;
esac
