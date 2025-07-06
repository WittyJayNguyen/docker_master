#!/bin/bash

# Auto RAM Optimization Script for Docker Development Environment
# Automatically detects system RAM and optimizes configurations

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

# Detect system RAM
detect_ram() {
    local ram_gb=8  # Default fallback

    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        # Linux - try multiple methods
        if command -v free >/dev/null 2>&1; then
            ram_gb=$(free -g | awk '/^Mem:/{print $2}')
        elif [ -f /proc/meminfo ]; then
            ram_kb=$(grep MemTotal /proc/meminfo | awk '{print $2}')
            ram_gb=$((ram_kb / 1024 / 1024))
        fi
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS
        if command -v sysctl >/dev/null 2>&1; then
            RAM_BYTES=$(sysctl -n hw.memsize 2>/dev/null)
            if [ -n "$RAM_BYTES" ]; then
                ram_gb=$((RAM_BYTES / 1024 / 1024 / 1024))
            fi
        fi
    elif [[ "$OSTYPE" == "msys" ]] || [[ "$OSTYPE" == "cygwin" ]]; then
        # Windows Git Bash or Cygwin
        if command -v powershell.exe >/dev/null 2>&1; then
            ram_bytes=$(powershell.exe -command "(Get-CimInstance -ClassName Win32_ComputerSystem).TotalPhysicalMemory" 2>/dev/null)
            if [ -n "$ram_bytes" ]; then
                ram_gb=$((ram_bytes / 1024 / 1024 / 1024))
            fi
        fi
    fi

    # Ensure we have a valid number
    if ! [[ "$ram_gb" =~ ^[0-9]+$ ]] || [ "$ram_gb" -lt 1 ]; then
        ram_gb=8
    fi

    echo $ram_gb
}

# Generate optimized MySQL configuration
generate_mysql_config() {
    local ram_gb=$1
    local config_file="$PROJECT_ROOT/database/mysql/conf/my.cnf"
    
    log_info "Generating MySQL config for ${ram_gb}GB RAM..."
    
    # Calculate MySQL memory allocation (25% of total RAM)
    local mysql_memory=$((ram_gb * 256 / 4))  # MB
    local innodb_buffer=$((mysql_memory * 70 / 100))  # 70% of MySQL memory
    local query_cache=$((mysql_memory * 10 / 100))    # 10% of MySQL memory
    
    # Minimum values
    if [ $innodb_buffer -lt 128 ]; then innodb_buffer=128; fi
    if [ $query_cache -lt 16 ]; then query_cache=16; fi
    
    cat > "$config_file" << EOF
[mysqld]
# Auto-generated MySQL configuration for ${ram_gb}GB RAM
# Generated on $(date)

# Disable SSL for development
ssl = 0
require_secure_transport = OFF

# Memory settings (optimized for ${ram_gb}GB RAM)
innodb_buffer_pool_size = ${innodb_buffer}M
innodb_log_file_size = $((innodb_buffer / 4))M
innodb_log_buffer_size = $((innodb_buffer / 8))M
query_cache_size = ${query_cache}M
query_cache_limit = 2M
tmp_table_size = $((mysql_memory / 8))M
max_heap_table_size = $((mysql_memory / 8))M

# Connection settings
max_connections = $((ram_gb * 25))
max_allowed_packet = 64M
thread_cache_size = $((ram_gb * 2))
table_open_cache = $((ram_gb * 100))

# InnoDB settings
innodb_flush_log_at_trx_commit = 2
innodb_flush_method = O_DIRECT
innodb_file_per_table = 1
innodb_open_files = $((ram_gb * 100))

# Character set
character-set-server = utf8mb4
collation-server = utf8mb4_unicode_ci

# Query cache
query_cache_type = 1

# Logging (minimal for development)
general_log = 0
slow_query_log = 1
slow_query_log_file = /var/log/mysql/slow.log
long_query_time = 2

# Binary logging (minimal)
log-bin = mysql-bin
binlog_format = ROW
expire_logs_days = 3
max_binlog_size = 100M

[mysql]
default-character-set = utf8mb4

[client]
default-character-set = utf8mb4
EOF

    log_success "MySQL config generated: ${innodb_buffer}MB InnoDB buffer, ${query_cache}MB query cache"
}

# Generate optimized PHP configuration
generate_php_config() {
    local ram_gb=$1
    local php_version=$2
    local config_file="$PROJECT_ROOT/php/$php_version/php.ini"
    
    log_info "Generating PHP $php_version config for ${ram_gb}GB RAM..."
    
    # Calculate PHP memory (10% of total RAM, max 512MB)
    local php_memory=$((ram_gb * 100))
    if [ $php_memory -gt 512 ]; then php_memory=512; fi
    if [ $php_memory -lt 128 ]; then php_memory=128; fi
    
    # OPcache memory (20% of PHP memory)
    local opcache_memory=$((php_memory / 5))
    if [ $opcache_memory -lt 64 ]; then opcache_memory=64; fi
    
    cat > "$config_file" << EOF
[PHP]
; Auto-generated PHP configuration for ${ram_gb}GB RAM
; Generated on $(date)

; Memory settings (optimized for ${ram_gb}GB RAM)
memory_limit = ${php_memory}M
max_execution_time = 300
max_input_time = 300
post_max_size = $((php_memory / 5))M
upload_max_filesize = $((php_memory / 5))M
max_file_uploads = 20

; Error reporting
display_errors = On
display_startup_errors = On
log_errors = On
error_log = /var/log/php/error.log
error_reporting = E_ALL

; Session settings
session.save_handler = files
session.save_path = "/tmp"
session.gc_maxlifetime = 1440
session.cookie_lifetime = 0

; OPcache settings (optimized for ${ram_gb}GB RAM)
opcache.enable = 1
opcache.enable_cli = 1
opcache.memory_consumption = ${opcache_memory}
opcache.interned_strings_buffer = $((opcache_memory / 8))
opcache.max_accelerated_files = $((ram_gb * 1000))
opcache.revalidate_freq = 2
opcache.fast_shutdown = 1
opcache.validate_timestamps = 1
opcache.save_comments = 0
EOF

    # Add JIT for PHP 8.2+
    if [[ "$php_version" == "8.2" || "$php_version" == "8.4" ]]; then
        cat >> "$config_file" << EOF
opcache.jit_buffer_size = $((opcache_memory / 2))M
opcache.jit = tracing
EOF
    fi
    
    cat >> "$config_file" << EOF

; Date settings
date.timezone = Asia/Ho_Chi_Minh

; Security
expose_php = Off
allow_url_fopen = On
allow_url_include = Off

; File uploads
file_uploads = On
upload_tmp_dir = /tmp

; Realpath cache
realpath_cache_size = $((ram_gb * 1024))K
realpath_cache_ttl = 600
EOF

    log_success "PHP $php_version config generated: ${php_memory}MB memory, ${opcache_memory}MB OPcache"
}

# Generate optimized Nginx configuration
generate_nginx_config() {
    local ram_gb=$1
    local config_file="$PROJECT_ROOT/nginx/nginx.conf"
    
    log_info "Generating Nginx config for ${ram_gb}GB RAM..."
    
    # Calculate worker processes and connections
    local worker_processes=$((ram_gb / 2))
    if [ $worker_processes -lt 1 ]; then worker_processes=1; fi
    if [ $worker_processes -gt 4 ]; then worker_processes=4; fi
    
    local worker_connections=$((ram_gb * 512))
    if [ $worker_connections -lt 1024 ]; then worker_connections=1024; fi
    if [ $worker_connections -gt 4096 ]; then worker_connections=4096; fi
    
    cat > "$config_file" << EOF
# Auto-generated Nginx configuration for ${ram_gb}GB RAM
# Generated on $(date)

user nginx;
worker_processes ${worker_processes};
error_log /var/log/nginx/error.log warn;
pid /var/run/nginx.pid;

events {
    worker_connections ${worker_connections};
    use epoll;
    multi_accept on;
}

http {
    include /etc/nginx/mime.types;
    default_type application/octet-stream;

    # Logging
    log_format main '\$remote_addr - \$remote_user [\$time_local] "\$request" '
                    '\$status \$body_bytes_sent "\$http_referer" '
                    '"\$http_user_agent" "\$http_x_forwarded_for"';
    access_log /var/log/nginx/access.log main;

    # Performance settings
    sendfile on;
    tcp_nopush on;
    tcp_nodelay on;
    keepalive_timeout 65;
    types_hash_max_size 2048;
    server_tokens off;

    # Buffer settings (optimized for ${ram_gb}GB RAM)
    client_body_buffer_size = $((ram_gb * 16))k;
    client_header_buffer_size = $((ram_gb * 2))k;
    client_max_body_size = $((ram_gb * 8))m;
    large_client_header_buffers = 4 $((ram_gb * 4))k;

    # Gzip compression
    gzip on;
    gzip_vary on;
    gzip_min_length 1024;
    gzip_proxied expired no-cache no-store private auth;
    gzip_types text/plain text/css text/xml text/javascript application/x-javascript application/xml+rss application/json;
    gzip_comp_level 6;

    # Include configurations
    include /etc/nginx/conf.d/*.conf;
    include /etc/nginx/sites-available/*.conf;
}
EOF

    log_success "Nginx config generated: ${worker_processes} workers, ${worker_connections} connections each"
}

# Update docker-compose.yml with memory limits
update_docker_compose() {
    local ram_gb=$1
    local compose_file="$PROJECT_ROOT/docker-compose.yml"
    
    log_info "Adding memory limits to docker-compose.yml..."
    
    # Calculate memory limits (in MB)
    local mysql_limit=$((ram_gb * 256))      # 25% of RAM
    local php_limit=$((ram_gb * 128))        # 12.5% of RAM per PHP container
    local nginx_limit=$((ram_gb * 64))       # 6.25% of RAM
    local redis_limit=$((ram_gb * 32))       # 3.125% of RAM
    local postgres_limit=$((ram_gb * 128))   # 12.5% of RAM
    
    # Minimum limits
    if [ $mysql_limit -lt 256 ]; then mysql_limit=256; fi
    if [ $php_limit -lt 128 ]; then php_limit=128; fi
    if [ $nginx_limit -lt 64 ]; then nginx_limit=64; fi
    if [ $redis_limit -lt 32 ]; then redis_limit=32; fi
    if [ $postgres_limit -lt 128 ]; then postgres_limit=128; fi
    
    log_success "Memory limits calculated:"
    log_success "  MySQL: ${mysql_limit}MB"
    log_success "  PostgreSQL: ${postgres_limit}MB"
    log_success "  PHP containers: ${php_limit}MB each"
    log_success "  Nginx: ${nginx_limit}MB"
    log_success "  Redis: ${redis_limit}MB"
}

# Main optimization function
main() {
    log_info "🚀 Starting RAM optimization for Docker Development Environment"
    
    # Detect system RAM
    RAM_GB=$(detect_ram)
    log_info "Detected system RAM: ${RAM_GB}GB"
    
    if [ $RAM_GB -lt 4 ]; then
        log_warning "Low RAM detected (${RAM_GB}GB). Consider upgrading to at least 8GB for optimal performance."
    elif [ $RAM_GB -ge 16 ]; then
        log_success "High RAM detected (${RAM_GB}GB). Excellent for development!"
    else
        log_info "Moderate RAM detected (${RAM_GB}GB). Good for development."
    fi
    
    # Generate optimized configurations
    generate_mysql_config $RAM_GB
    generate_php_config $RAM_GB "7.4"
    generate_php_config $RAM_GB "8.2"
    generate_php_config $RAM_GB "8.4"
    generate_nginx_config $RAM_GB
    update_docker_compose $RAM_GB
    
    log_success "🎉 RAM optimization completed!"
    log_info "Next steps:"
    echo "1. Restart services: docker-compose restart"
    echo "2. Check memory usage: docker stats"
    echo "3. Monitor performance with optimized settings"
}

# Run main function
main "$@"
