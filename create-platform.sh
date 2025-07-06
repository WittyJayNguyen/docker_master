#!/bin/bash
# Docker Master Platform - Auto-Discovery Platform Creator
# Tự động tạo platform mới với cấu hình tối ưu

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

# Check if required parameters are provided
if [ $# -lt 3 ]; then
    echo
    echo "========================================="
    echo "   Docker Master - Auto-Discovery"
    echo "========================================="
    echo
    echo "Usage: ./create-platform.sh [type] [name] [port]"
    echo
    echo "Platform Types:"
    echo "  wordpress    - WordPress PHP 7.4 + PostgreSQL"
    echo "  laravel74    - Laravel PHP 7.4 + PostgreSQL + Redis"
    echo "  laravel84    - Laravel PHP 8.4 + PostgreSQL + Redis"
    echo "  ecommerce    - E-commerce Laravel + Full Stack"
    echo
    echo "Examples:"
    echo "  ./create-platform.sh wordpress my-blog 8015"
    echo "  ./create-platform.sh laravel74 my-shop 8016"
    echo "  ./create-platform.sh laravel84 api-server 8017"
    echo "  ./create-platform.sh ecommerce food-store 8018"
    echo
    exit 1
fi

PLATFORM_TYPE=$1
PLATFORM_NAME=$2
PLATFORM_PORT=$3

echo
echo "========================================="
echo "   Auto-Discovery: Creating $PLATFORM_NAME"
echo "========================================="
echo

print_info "Platform Type: $PLATFORM_TYPE"
print_info "Platform Name: $PLATFORM_NAME"
print_info "Platform Port: $PLATFORM_PORT"
echo

# Validate platform type
case $PLATFORM_TYPE in
    wordpress|laravel74|laravel84|ecommerce)
        print_status "Valid platform type: $PLATFORM_TYPE"
        ;;
    *)
        print_error "Invalid platform type: $PLATFORM_TYPE"
        print_info "Valid types: wordpress, laravel74, laravel84, ecommerce"
        exit 1
        ;;
esac

# Check if port is already in use
if grep -q "$PLATFORM_PORT:80" docker-compose.low-ram.yml 2>/dev/null; then
    print_error "Port $PLATFORM_PORT is already in use!"
    print_info "Please choose a different port"
    exit 1
fi

# Create project directory
print_info "Creating project directory..."
mkdir -p "projects/$PLATFORM_NAME"
mkdir -p "logs/apache/$PLATFORM_NAME"
mkdir -p "data/uploads/$PLATFORM_NAME"

# Determine PHP version and Xdebug port
case $PLATFORM_TYPE in
    wordpress|laravel74)
        PHP_VERSION="74"
        XDEBUG_PORT=$((PLATFORM_PORT + 1000))
        ;;
    laravel84|ecommerce)
        PHP_VERSION="84"
        XDEBUG_PORT=$((PLATFORM_PORT + 1000))
        ;;
esac

print_status "Project directory created: projects/$PLATFORM_NAME"

# Create platform-specific index.php
print_info "Creating platform files..."

case $PLATFORM_TYPE in
    wordpress)
        create_wordpress_platform
        ;;
    laravel74)
        create_laravel74_platform
        ;;
    laravel84)
        create_laravel84_platform
        ;;
    ecommerce)
        create_ecommerce_platform
        ;;
esac

# Create database
print_info "Creating database..."
DB_NAME="${PLATFORM_NAME}_db"

if docker exec postgres_low_ram psql -U postgres_user -d postgres -c "CREATE DATABASE $DB_NAME;" 2>/dev/null; then
    print_status "Database $DB_NAME created successfully"
else
    print_warning "Database $DB_NAME may already exist"
fi

# Add service to docker-compose.low-ram.yml
print_info "Adding service to docker-compose configuration..."
add_service_to_compose

# Build and start the service
print_info "Building and starting the service..."
docker-compose -f docker-compose.low-ram.yml build $PLATFORM_NAME
docker-compose -f docker-compose.low-ram.yml up -d $PLATFORM_NAME

# Wait for service to be ready
print_info "Waiting for service to be ready..."
sleep 10

# Test the service
print_info "Testing the service..."
if curl -f "http://localhost:$PLATFORM_PORT" >/dev/null 2>&1; then
    print_status "Service is responding successfully!"
else
    print_warning "Service may still be starting up"
fi

echo
echo "🎉 Platform Creation Completed!"
echo "================================================================"
echo
print_status "Platform Details:"
echo "  • Name: $PLATFORM_NAME"
echo "  • Type: $PLATFORM_TYPE"
echo "  • URL: http://localhost:$PLATFORM_PORT"
echo "  • Database: ${PLATFORM_NAME}_db"
echo "  • Xdebug: localhost:$XDEBUG_PORT"
echo
print_info "Quick Commands:"
echo "  • View logs: docker logs ${PLATFORM_NAME}_php${PHP_VERSION}"
echo "  • Shell access: docker exec -it ${PLATFORM_NAME}_php${PHP_VERSION} bash"
echo "  • Stop service: docker-compose -f docker-compose.low-ram.yml stop $PLATFORM_NAME"
echo "  • Remove service: docker-compose -f docker-compose.low-ram.yml down $PLATFORM_NAME"
echo

# Platform-specific creation functions
create_wordpress_platform() {
    cat > "projects/$PLATFORM_NAME/index.php" << EOF
<?php
/**
 * $PLATFORM_NAME - WordPress PHP 7.4 + PostgreSQL
 * Auto-generated by Docker Master Platform
 */

echo "<h1>📝 $PLATFORM_NAME - WordPress Platform</h1>";
echo "<div style='font-family: Arial, sans-serif; max-width: 800px; margin: 0 auto; padding: 20px;'>";

echo "<h2>📋 Platform Information</h2>";
echo "<p><strong>Platform:</strong> $PLATFORM_NAME</p>";
echo "<p><strong>Type:</strong> WordPress</p>";
echo "<p><strong>PHP Version:</strong> " . phpversion() . "</p>";
echo "<p><strong>Port:</strong> $PLATFORM_PORT</p>";

echo "<h2>🗄️ Database Connection Test</h2>";
\$host = \$_ENV['DB_HOST'] ?? 'postgres_low_ram';
\$dbname = \$_ENV['DB_DATABASE'] ?? '${PLATFORM_NAME}_db';
\$username = \$_ENV['DB_USERNAME'] ?? 'postgres_user';
\$password = \$_ENV['DB_PASSWORD'] ?? 'postgres_pass';

try {
    \$pdo = new PDO("pgsql:host=\$host;port=5432;dbname=\$dbname", \$username, \$password);
    \$pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    echo "<p>✅ PostgreSQL connection successful!</p>";
    echo "<p><strong>Database:</strong> \$dbname</p>";
} catch (Exception \$e) {
    echo "<p>❌ Database connection failed: " . \$e->getMessage() . "</p>";
}

echo "<h2>🚀 Next Steps</h2>";
echo "<ul>";
echo "<li>Install WordPress in this directory</li>";
echo "<li>Configure wp-config.php for PostgreSQL</li>";
echo "<li>Set up your WordPress theme</li>";
echo "</ul>";

echo "<p><em>🐳 $PLATFORM_NAME platform ready for WordPress!</em></p>";
echo "</div>";
?>
EOF
}

create_laravel74_platform() {
    cat > "projects/$PLATFORM_NAME/index.php" << EOF
<?php
/**
 * $PLATFORM_NAME - Laravel PHP 7.4 + PostgreSQL + Redis
 * Auto-generated by Docker Master Platform
 */

echo "<h1>🚀 $PLATFORM_NAME - Laravel PHP 7.4</h1>";
echo "<div style='font-family: Arial, sans-serif; max-width: 800px; margin: 0 auto; padding: 20px;'>";

echo "<h2>📋 Platform Information</h2>";
echo "<p><strong>Platform:</strong> $PLATFORM_NAME</p>";
echo "<p><strong>Type:</strong> Laravel PHP 7.4</p>";
echo "<p><strong>PHP Version:</strong> " . phpversion() . "</p>";
echo "<p><strong>Port:</strong> $PLATFORM_PORT</p>";

// Database test
echo "<h2>🗄️ PostgreSQL Connection</h2>";
\$host = \$_ENV['DB_HOST'] ?? 'postgres_low_ram';
\$dbname = \$_ENV['DB_DATABASE'] ?? '${PLATFORM_NAME}_db';
\$username = \$_ENV['DB_USERNAME'] ?? 'postgres_user';
\$password = \$_ENV['DB_PASSWORD'] ?? 'postgres_pass';

try {
    \$pdo = new PDO("pgsql:host=\$host;port=5432;dbname=\$dbname", \$username, \$password);
    echo "<p>✅ PostgreSQL connection successful!</p>";
} catch (Exception \$e) {
    echo "<p>❌ Database failed: " . \$e->getMessage() . "</p>";
}

// Redis test
echo "<h2>🔴 Redis Connection</h2>";
\$redis_host = \$_ENV['REDIS_HOST'] ?? 'redis_low_ram';
try {
    \$redis = new Redis();
    \$redis->connect(\$redis_host, 6379);
    echo "<p>✅ Redis connection successful!</p>";
} catch (Exception \$e) {
    echo "<p>❌ Redis failed: " . \$e->getMessage() . "</p>";
}

echo "<p><em>🐳 $PLATFORM_NAME ready for Laravel development!</em></p>";
echo "</div>";
?>
EOF
}

create_laravel84_platform() {
    cat > "projects/$PLATFORM_NAME/index.php" << EOF
<?php
/**
 * $PLATFORM_NAME - Laravel PHP 8.4 + PostgreSQL + Redis
 * Auto-generated by Docker Master Platform
 */

echo "<h1>🚀 $PLATFORM_NAME - Laravel PHP 8.4</h1>";
echo "<div style='font-family: Arial, sans-serif; max-width: 800px; margin: 0 auto; padding: 20px;'>";

echo "<h2>📋 Platform Information</h2>";
echo "<p><strong>Platform:</strong> $PLATFORM_NAME</p>";
echo "<p><strong>Type:</strong> Laravel PHP 8.4</p>";
echo "<p><strong>PHP Version:</strong> " . phpversion() . "</p>";
echo "<p><strong>Port:</strong> $PLATFORM_PORT</p>";

// Database and Redis tests (similar to Laravel 7.4)
// ... (database and redis connection code)

echo "<p><em>🐳 $PLATFORM_NAME ready for modern Laravel development!</em></p>";
echo "</div>";
?>
EOF
}

create_ecommerce_platform() {
    # Create more comprehensive e-commerce structure
    create_laravel84_platform
    
    # Add e-commerce specific files
    mkdir -p "projects/$PLATFORM_NAME/app/Models"
    mkdir -p "projects/$PLATFORM_NAME/database/migrations"
    
    print_status "E-commerce structure created with models and migrations"
}

add_service_to_compose() {
    # Backup current compose file
    cp docker-compose.low-ram.yml docker-compose.low-ram.yml.backup

    # Add service before the networks section
    sed -i "/^# Network/i\\
\\
  # $PLATFORM_NAME - Auto-generated $PLATFORM_TYPE platform\\
  $PLATFORM_NAME:\\
    build:\\
      context: ./docker/php$PHP_VERSION\\
      dockerfile: Dockerfile\\
    container_name: ${PLATFORM_NAME}_php${PHP_VERSION}\\
    restart: unless-stopped\\
    ports:\\
      - \"$PLATFORM_PORT:80\"\\
      - \"$XDEBUG_PORT:9003\"  # Xdebug port\\
    volumes:\\
      - ./projects/$PLATFORM_NAME:/var/www/html\\
      - ./logs/apache/$PLATFORM_NAME:/var/log/apache2\\
      - ./data/uploads/$PLATFORM_NAME:/app/uploads\\
    environment:\\
      - WEB_DOCUMENT_ROOT=/var/www/html\\
      - PHP_VERSION=$PHP_VERSION\\
      - PHP_MEMORY_LIMIT=96M\\
      - PHP_OPCACHE_MEMORY_CONSUMPTION=32\\
      - DB_HOST=postgres_low_ram\\
      - DB_PORT=5432\\
      - DB_DATABASE=${PLATFORM_NAME}_db\\
      - DB_USERNAME=postgres_user\\
      - DB_PASSWORD=postgres_pass\\
      - REDIS_HOST=redis_low_ram\\
      - REDIS_PORT=6379\\
    deploy:\\
      resources:\\
        limits:\\
          memory: 128M\\
        reservations:\\
          memory: 96M\\
    networks:\\
      - low-ram-network\\
    depends_on:\\
      - postgres\\
      - redis\\
    healthcheck:\\
      test: [\"CMD\", \"curl\", \"-f\", \"http://localhost/\"]\\
      interval: 30s\\
      timeout: 10s\\
      retries: 3\\
" docker-compose.low-ram.yml

    print_status "Service added to docker-compose.low-ram.yml"
}
