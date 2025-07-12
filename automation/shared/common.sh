#!/bin/bash

# Docker Master - Common Automation Functions
# Shared utilities for all automation scripts

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Icons
ICON_SUCCESS="✅"
ICON_ERROR="❌"
ICON_WARNING="⚠️"
ICON_INFO="ℹ️"
ICON_DOCKER="🐳"
ICON_DATABASE="🗄️"
ICON_NGINX="🌐"
ICON_PLATFORM="🚀"

# Script metadata
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

# Configuration
CONFIG_FILE="$PROJECT_ROOT/src/config/defaults/default.json"
LOG_DIR="$PROJECT_ROOT/logs/automation"
DOCKER_COMPOSE_FILE="$PROJECT_ROOT/docker-compose.low-ram.yml"

# Ensure log directory exists
mkdir -p "$LOG_DIR"

# Logging functions
log_info() {
    local message="$1"
    echo -e "${BLUE}${ICON_INFO} ${message}${NC}"
    echo "[$TIMESTAMP] INFO: $message" >> "$LOG_DIR/automation.log"
}

log_success() {
    local message="$1"
    echo -e "${GREEN}${ICON_SUCCESS} ${message}${NC}"
    echo "[$TIMESTAMP] SUCCESS: $message" >> "$LOG_DIR/automation.log"
}

log_warning() {
    local message="$1"
    echo -e "${YELLOW}${ICON_WARNING} ${message}${NC}"
    echo "[$TIMESTAMP] WARNING: $message" >> "$LOG_DIR/automation.log"
}

log_error() {
    local message="$1"
    echo -e "${RED}${ICON_ERROR} ${message}${NC}" >&2
    echo "[$TIMESTAMP] ERROR: $message" >> "$LOG_DIR/automation.log"
}

log_docker() {
    local message="$1"
    echo -e "${CYAN}${ICON_DOCKER} ${message}${NC}"
    echo "[$TIMESTAMP] DOCKER: $message" >> "$LOG_DIR/automation.log"
}

log_database() {
    local message="$1"
    echo -e "${PURPLE}${ICON_DATABASE} ${message}${NC}"
    echo "[$TIMESTAMP] DATABASE: $message" >> "$LOG_DIR/automation.log"
}

log_nginx() {
    local message="$1"
    echo -e "${BLUE}${ICON_NGINX} ${message}${NC}"
    echo "[$TIMESTAMP] NGINX: $message" >> "$LOG_DIR/automation.log"
}

log_platform() {
    local message="$1"
    echo -e "${GREEN}${ICON_PLATFORM} ${message}${NC}"
    echo "[$TIMESTAMP] PLATFORM: $message" >> "$LOG_DIR/automation.log"
}

# Utility functions
print_header() {
    local title="$1"
    local width=60
    local padding=$(( (width - ${#title}) / 2 ))
    
    echo
    echo -e "${BLUE}$(printf '=%.0s' $(seq 1 $width))${NC}"
    echo -e "${BLUE}$(printf '%*s' $padding)${title}$(printf '%*s' $padding)${NC}"
    echo -e "${BLUE}$(printf '=%.0s' $(seq 1 $width))${NC}"
    echo
}

print_separator() {
    echo -e "${BLUE}$(printf '-%.0s' $(seq 1 60))${NC}"
}

# Validation functions
validate_platform_name() {
    local name="$1"
    
    if [[ -z "$name" ]]; then
        log_error "Platform name cannot be empty"
        return 1
    fi
    
    if [[ ! "$name" =~ ^[a-zA-Z0-9][a-zA-Z0-9_-]*$ ]]; then
        log_error "Platform name must start with alphanumeric character and contain only letters, numbers, hyphens, and underscores"
        return 1
    fi
    
    if [[ ${#name} -gt 50 ]]; then
        log_error "Platform name must be 50 characters or less"
        return 1
    fi
    
    return 0
}

validate_platform_type() {
    local type="$1"
    local valid_types=("wordpress" "laravel74" "laravel84" "ecommerce")
    
    if [[ -z "$type" ]]; then
        log_error "Platform type cannot be empty"
        return 1
    fi
    
    for valid_type in "${valid_types[@]}"; do
        if [[ "$type" == "$valid_type" ]]; then
            return 0
        fi
    done
    
    log_error "Invalid platform type: $type"
    log_info "Valid types: ${valid_types[*]}"
    return 1
}

validate_port() {
    local port="$1"
    
    if [[ ! "$port" =~ ^[0-9]+$ ]]; then
        log_error "Port must be a number"
        return 1
    fi
    
    if [[ $port -lt 1000 || $port -gt 65535 ]]; then
        log_error "Port must be between 1000 and 65535"
        return 1
    fi
    
    return 0
}

# Docker functions
check_docker() {
    if ! command -v docker &> /dev/null; then
        log_error "Docker is not installed or not in PATH"
        return 1
    fi
    
    if ! docker info &> /dev/null; then
        log_error "Docker daemon is not running"
        return 1
    fi
    
    return 0
}

check_docker_compose() {
    if ! command -v docker-compose &> /dev/null; then
        log_error "Docker Compose is not installed or not in PATH"
        return 1
    fi
    
    if [[ ! -f "$DOCKER_COMPOSE_FILE" ]]; then
        log_error "Docker Compose file not found: $DOCKER_COMPOSE_FILE"
        return 1
    fi
    
    return 0
}

is_container_running() {
    local container_name="$1"
    docker ps --format "table {{.Names}}" | grep -q "^${container_name}$"
}

is_service_healthy() {
    local service_name="$1"
    local health_status=$(docker inspect --format='{{.State.Health.Status}}' "$service_name" 2>/dev/null)
    [[ "$health_status" == "healthy" ]]
}

wait_for_service() {
    local service_name="$1"
    local timeout="${2:-60}"
    local interval="${3:-5}"
    local elapsed=0
    
    log_info "Waiting for service $service_name to be ready..."
    
    while [[ $elapsed -lt $timeout ]]; do
        if is_container_running "$service_name"; then
            if is_service_healthy "$service_name"; then
                log_success "Service $service_name is ready"
                return 0
            fi
        fi
        
        sleep $interval
        elapsed=$((elapsed + interval))
        echo -n "."
    done
    
    echo
    log_error "Service $service_name failed to become ready within ${timeout}s"
    return 1
}

# Port functions
is_port_in_use() {
    local port="$1"
    
    # Check if port is in use by any process
    if command -v netstat &> /dev/null; then
        netstat -tuln | grep -q ":${port} "
    elif command -v ss &> /dev/null; then
        ss -tuln | grep -q ":${port} "
    else
        # Fallback: try to connect to the port
        timeout 1 bash -c "</dev/tcp/localhost/$port" &>/dev/null
    fi
}

find_available_port() {
    local start_port="${1:-8015}"
    local end_port="${2:-8100}"
    
    for ((port=start_port; port<=end_port; port++)); do
        if ! is_port_in_use "$port"; then
            echo "$port"
            return 0
        fi
    done
    
    log_error "No available ports found in range $start_port-$end_port"
    return 1
}

# File functions
backup_file() {
    local file="$1"
    local backup_suffix="${2:-.backup.$(date +%Y%m%d_%H%M%S)}"
    
    if [[ -f "$file" ]]; then
        cp "$file" "${file}${backup_suffix}"
        log_info "Backed up $file to ${file}${backup_suffix}"
    fi
}

create_directory() {
    local dir="$1"
    local mode="${2:-755}"
    
    if [[ ! -d "$dir" ]]; then
        mkdir -p "$dir"
        chmod "$mode" "$dir"
        log_info "Created directory: $dir"
    fi
}

# Platform functions
platform_exists() {
    local platform_name="$1"
    [[ -d "$PROJECT_ROOT/projects/$platform_name" ]]
}

get_platform_port() {
    local platform_name="$1"
    
    if [[ -f "$PROJECT_ROOT/projects/$platform_name/.platform" ]]; then
        grep "PORT=" "$PROJECT_ROOT/projects/$platform_name/.platform" | cut -d'=' -f2
    else
        return 1
    fi
}

get_platform_type() {
    local platform_name="$1"
    
    if [[ -f "$PROJECT_ROOT/projects/$platform_name/.platform" ]]; then
        grep "TYPE=" "$PROJECT_ROOT/projects/$platform_name/.platform" | cut -d'=' -f2
    else
        return 1
    fi
}

save_platform_metadata() {
    local platform_name="$1"
    local platform_type="$2"
    local platform_port="$3"
    local php_version="$4"
    local database_type="$5"
    
    local metadata_file="$PROJECT_ROOT/projects/$platform_name/.platform"
    
    cat > "$metadata_file" << EOF
# Docker Master Platform Metadata
# Generated on: $TIMESTAMP
NAME=$platform_name
TYPE=$platform_type
PORT=$platform_port
PHP_VERSION=$php_version
DATABASE_TYPE=$database_type
CREATED_AT=$TIMESTAMP
XDEBUG_PORT=$((platform_port + 1000))
DATABASE_NAME=${platform_name//[^a-zA-Z0-9]/_}_db
EOF
    
    log_info "Saved platform metadata: $metadata_file"
}

# Error handling
handle_error() {
    local exit_code=$?
    local line_number=$1
    
    log_error "Script failed at line $line_number with exit code $exit_code"
    
    # Cleanup function if defined
    if declare -f cleanup > /dev/null; then
        log_info "Running cleanup..."
        cleanup
    fi
    
    exit $exit_code
}

# Set error trap
trap 'handle_error $LINENO' ERR

# Cleanup function (can be overridden by scripts)
cleanup() {
    log_info "Default cleanup - no specific cleanup actions defined"
}

# Environment detection
detect_os() {
    case "$(uname -s)" in
        Linux*)     echo "linux";;
        Darwin*)    echo "macos";;
        CYGWIN*|MINGW*|MSYS*) echo "windows";;
        *)          echo "unknown";;
    esac
}

is_wsl() {
    [[ -n "${WSL_DISTRO_NAME:-}" ]] || [[ "$(uname -r)" == *microsoft* ]]
}

# Configuration helpers
get_config_value() {
    local key="$1"
    local default_value="$2"
    
    if [[ -f "$CONFIG_FILE" ]] && command -v jq &> /dev/null; then
        jq -r "$key // \"$default_value\"" "$CONFIG_FILE" 2>/dev/null || echo "$default_value"
    else
        echo "$default_value"
    fi
}

# Progress indicator
show_progress() {
    local current="$1"
    local total="$2"
    local message="$3"
    local width=50
    
    local percentage=$((current * 100 / total))
    local filled=$((current * width / total))
    local empty=$((width - filled))
    
    printf "\r${BLUE}[%s%s] %d%% %s${NC}" \
        "$(printf '#%.0s' $(seq 1 $filled))" \
        "$(printf ' %.0s' $(seq 1 $empty))" \
        "$percentage" \
        "$message"
    
    if [[ $current -eq $total ]]; then
        echo
    fi
}

# Version comparison
version_compare() {
    local version1="$1"
    local version2="$2"
    
    if [[ "$version1" == "$version2" ]]; then
        echo "0"
    elif [[ "$(printf '%s\n' "$version1" "$version2" | sort -V | head -n1)" == "$version1" ]]; then
        echo "-1"
    else
        echo "1"
    fi
}

# Export functions for use in other scripts
export -f log_info log_success log_warning log_error log_docker log_database log_nginx log_platform
export -f print_header print_separator
export -f validate_platform_name validate_platform_type validate_port
export -f check_docker check_docker_compose is_container_running is_service_healthy wait_for_service
export -f is_port_in_use find_available_port
export -f backup_file create_directory
export -f platform_exists get_platform_port get_platform_type save_platform_metadata
export -f handle_error cleanup
export -f detect_os is_wsl
export -f get_config_value
export -f show_progress version_compare

# Export variables
export RED GREEN YELLOW BLUE PURPLE CYAN NC
export ICON_SUCCESS ICON_ERROR ICON_WARNING ICON_INFO ICON_DOCKER ICON_DATABASE ICON_NGINX ICON_PLATFORM
export SCRIPT_DIR PROJECT_ROOT TIMESTAMP
export CONFIG_FILE LOG_DIR DOCKER_COMPOSE_FILE
