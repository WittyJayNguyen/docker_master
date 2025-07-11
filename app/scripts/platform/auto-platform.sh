#!/bin/bash
# Docker Master Platform - Auto Platform Creation Script (Linux/macOS)
# AI-powered platform detection and creation

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Function to print colored output
print_color() {
    local color=$1
    local message=$2
    echo -e "${color}${message}${NC}"
}

# Function to detect platform type based on name
detect_platform_type() {
    local name="$1"
    local name_lower=$(echo "$name" | tr '[:upper:]' '[:lower:]')
    
    # WordPress detection
    if [[ "$name_lower" =~ (blog|news|cms|wordpress|wp|site|web|magazine|article) ]]; then
        echo "wordpress"
        return
    fi
    
    # E-commerce detection
    if [[ "$name_lower" =~ (shop|store|ecommerce|commerce|market|buy|sell|cart|order|product) ]]; then
        echo "ecommerce"
        return
    fi
    
    # API detection
    if [[ "$name_lower" =~ (api|service|micro|backend|rest|graphql|endpoint) ]]; then
        echo "laravel84"
        return
    fi
    
    # Default to Laravel 8.4
    echo "laravel84"
}

# Function to get database configuration
get_database_config() {
    local platform_type="$1"
    
    case "$platform_type" in
        "wordpress")
            echo "mysql mysql_cross_platform 3306 mysql_user mysql_pass"
            ;;
        "ecommerce")
            echo "mysql mysql_cross_platform 3306 mysql_user mysql_pass"
            ;;
        *)
            echo "postgresql postgres_cross_platform 5432 postgres_user postgres_pass"
            ;;
    esac
}

# Function to get PHP version
get_php_version() {
    local platform_type="$1"
    
    case "$platform_type" in
        "wordpress")
            echo "74"
            ;;
        "laravel74")
            echo "74"
            ;;
        *)
            echo "84"
            ;;
    esac
}

# Function to find available port
find_available_port() {
    local start_port="$1"
    local port=$start_port
    
    while netstat -an 2>/dev/null | grep -q ":$port " || ss -an 2>/dev/null | grep -q ":$port "; do
        port=$((port + 1))
    done
    
    echo "$port"
}

# Function to create platform
create_platform() {
    local platform_name="$1"
    local platform_type="$2"
    local php_version="$3"
    local platform_port="$4"
    local xdebug_port="$5"
    local db_config="$6"
    
    print_color $BLUE "📁 Creating platform directory structure..."
    
    # Create directories
    mkdir -p "src/platforms/instances/$platform_name"
    mkdir -p "runtime/projects/$platform_name"
    mkdir -p "runtime/logs/apache/$platform_name"
    mkdir -p "runtime/data/uploads/$platform_name"
    
    print_color $GREEN "✅ Platform directories created"
    
    # Parse database config
    read -r db_type db_host db_port db_user db_pass <<< "$db_config"
    
    # Create docker-compose file for platform
    cat > "src/platforms/instances/$platform_name/docker-compose.$platform_name.yml" << EOF
version: '3.8'

services:
  $platform_name:
    build:
      context: ../../infrastructure/docker/php$php_version
      dockerfile: Dockerfile
    container_name: ${platform_name}_php${php_version}
    restart: unless-stopped
    ports:
      - "$platform_port:80"
      - "$xdebug_port:9003"
    volumes:
      - ../../../runtime/projects/$platform_name:/var/www/html
      - ../../../runtime/logs/apache/$platform_name:/var/log/apache2
      - ../../../runtime/data/uploads/$platform_name:/app/uploads
    environment:
      - WEB_DOCUMENT_ROOT=/var/www/html
      - PHP_VERSION=$php_version
      - PHP_MEMORY_LIMIT=96M
      - PHP_OPCACHE_MEMORY_CONSUMPTION=32
      - DB_HOST=$db_host
      - DB_PORT=$db_port
      - DB_DATABASE=${platform_name}_db
      - DB_USERNAME=$db_user
      - DB_PASSWORD=$db_pass
      - REDIS_HOST=redis_cross_platform
      - REDIS_PORT=6379
      - PLATFORM_NAME=$platform_name
      - PLATFORM_TYPE=$platform_type
    depends_on:
      - $db_host
      - redis_cross_platform
    networks:
      - docker_master_cross_platform

networks:
  docker_master_cross_platform:
    external: true
EOF

    print_color $GREEN "✅ Docker compose configuration created"
    
    # Create platform-specific index.php
    create_platform_files "$platform_name" "$platform_type" "$platform_port"
    
    print_color $GREEN "✅ Platform files created"
}

# Function to create platform files
create_platform_files() {
    local platform_name="$1"
    local platform_type="$2"
    local platform_port="$3"
    
    case "$platform_type" in
        "wordpress")
            create_wordpress_files "$platform_name" "$platform_port"
            ;;
        "ecommerce")
            create_ecommerce_files "$platform_name" "$platform_port"
            ;;
        *)
            create_laravel_files "$platform_name" "$platform_port"
            ;;
    esac
}

# Function to create WordPress files
create_wordpress_files() {
    local platform_name="$1"
    local platform_port="$2"
    
    cat > "runtime/projects/$platform_name/index.php" << 'EOF'
<?php
/**
 * WordPress Platform - Auto-generated
 */

echo "<h1>📝 WordPress Platform</h1>";
echo "<div style='font-family: Arial, sans-serif; max-width: 800px; margin: 0 auto; padding: 20px;'>";

echo "<h2>📋 Platform Information</h2>";
echo "<p><strong>Platform:</strong> " . ($_ENV['PLATFORM_NAME'] ?? 'wordpress') . "</p>";
echo "<p><strong>Type:</strong> WordPress + MySQL + PHP 7.4</p>";
echo "<p><strong>Status:</strong> <span style='color: green;'>✅ Ready for WordPress installation</span></p>";

echo "<h2>🗄️ Database Connection</h2>";
echo "<p><strong>Host:</strong> " . ($_ENV['DB_HOST'] ?? 'mysql') . "</p>";
echo "<p><strong>Database:</strong> " . ($_ENV['DB_DATABASE'] ?? 'wordpress_db') . "</p>";
echo "<p><strong>User:</strong> " . ($_ENV['DB_USERNAME'] ?? 'mysql_user') . "</p>";

echo "<h2>🚀 Next Steps</h2>";
echo "<ol>";
echo "<li>Download WordPress and extract to this directory</li>";
echo "<li>Configure wp-config.php with the database settings above</li>";
echo "<li>Run WordPress installation</li>";
echo "</ol>";

echo "</div>";
?>
EOF
}

# Function to create Laravel files
create_laravel_files() {
    local platform_name="$1"
    local platform_port="$2"
    
    cat > "runtime/projects/$platform_name/index.php" << 'EOF'
<?php
/**
 * Laravel Platform - Auto-generated
 */

echo "<h1>🚀 Laravel Platform</h1>";
echo "<div style='font-family: Arial, sans-serif; max-width: 800px; margin: 0 auto; padding: 20px;'>";

echo "<h2>📋 Platform Information</h2>";
echo "<p><strong>Platform:</strong> " . ($_ENV['PLATFORM_NAME'] ?? 'laravel') . "</p>";
echo "<p><strong>Type:</strong> Laravel + PostgreSQL + Redis + PHP 8.4</p>";
echo "<p><strong>Status:</strong> <span style='color: green;'>✅ Ready for Laravel development</span></p>";

echo "<h2>🗄️ Database Connection</h2>";
echo "<p><strong>Host:</strong> " . ($_ENV['DB_HOST'] ?? 'postgres') . "</p>";
echo "<p><strong>Database:</strong> " . ($_ENV['DB_DATABASE'] ?? 'laravel_db') . "</p>";
echo "<p><strong>User:</strong> " . ($_ENV['DB_USERNAME'] ?? 'postgres_user') . "</p>";

echo "<h2>🚀 Next Steps</h2>";
echo "<ol>";
echo "<li>Create new Laravel project: <code>composer create-project laravel/laravel .</code></li>";
echo "<li>Configure .env file with database settings</li>";
echo "<li>Run migrations: <code>php artisan migrate</code></li>";
echo "</ol>";

echo "</div>";
?>
EOF
}

# Function to create E-commerce files
create_ecommerce_files() {
    local platform_name="$1"
    local platform_port="$2"
    
    create_laravel_files "$platform_name" "$platform_port"
    
    # Add e-commerce specific directories
    mkdir -p "runtime/projects/$platform_name/app/Models"
    mkdir -p "runtime/projects/$platform_name/database/migrations"
}

# Main function
main() {
    if [[ -z "$1" ]]; then
        print_color $RED "❌ Error: Platform name is required"
        echo ""
        echo "Usage: $0 [platform-name]"
        echo ""
        echo "Examples:"
        echo "  $0 my-blog           # → WordPress + MySQL + PHP 7.4"
        echo "  $0 user-api          # → Laravel + PostgreSQL + PHP 8.4"
        echo "  $0 online-shop       # → Laravel + MySQL + PHP 8.4"
        exit 1
    fi
    
    local platform_name="$1"
    
    print_color $CYAN "🤖 AI Auto-Detection Platform Creator"
    print_color $CYAN "================================================================"
    echo ""
    
    # Detect platform type
    local platform_type=$(detect_platform_type "$platform_name")
    print_color $YELLOW "🧠 Detected platform type: $platform_type"
    
    # Get configurations
    local php_version=$(get_php_version "$platform_type")
    local db_config=$(get_database_config "$platform_type")
    
    # Find available ports
    local base_port=8010
    local platform_port=$(find_available_port $base_port)
    local xdebug_port=$((platform_port + 1000))
    
    print_color $YELLOW "🔌 Assigned ports: HTTP=$platform_port, Xdebug=$xdebug_port"
    print_color $YELLOW "🐘 PHP version: $php_version"
    
    # Create platform
    create_platform "$platform_name" "$platform_type" "$php_version" "$platform_port" "$xdebug_port" "$db_config"
    
    print_color $GREEN "🎉 Platform '$platform_name' created successfully!"
    print_color $BLUE "🌐 Access at: http://localhost:$platform_port"
}

# Run main function
main "$@"
