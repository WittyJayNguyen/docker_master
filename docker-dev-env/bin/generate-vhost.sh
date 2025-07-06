#!/bin/bash

# Generate Nginx Virtual Host Configuration
# Usage: ./bin/generate-vhost.sh <project_name> [php_version] [public_dir]

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Helper functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
NGINX_SITES_DIR="$PROJECT_ROOT/nginx/sites"
TEMPLATE_FILE="$NGINX_SITES_DIR/project-template.conf"

# Parameters
PROJECT_NAME="$1"
PHP_VERSION="${2:-dev_php84}"
PUBLIC_DIR="${3:-public}"

# Validate parameters
if [ -z "$PROJECT_NAME" ]; then
    log_error "Project name is required"
    echo "Usage: $0 <project_name> [php_version] [public_dir]"
    echo "Example: $0 myproject dev_php84 public"
    exit 1
fi

# Validate PHP version
case "$PHP_VERSION" in
    php74|dev_php74)
        PHP_CONTAINER="dev_php74"
        ;;
    php82|dev_php82)
        PHP_CONTAINER="dev_php82"
        ;;
    php84|dev_php84)
        PHP_CONTAINER="dev_php84"
        ;;
    *)
        log_error "Invalid PHP version: $PHP_VERSION"
        echo "Valid options: php74, php82, php84"
        exit 1
        ;;
esac

# Create nginx sites directory if it doesn't exist
mkdir -p "$NGINX_SITES_DIR"

# Generate virtual host configuration
VHOST_FILE="$NGINX_SITES_DIR/${PROJECT_NAME}.local.conf"

log_info "Generating virtual host for project: $PROJECT_NAME"
log_info "PHP Version: $PHP_CONTAINER"
log_info "Public Directory: $PUBLIC_DIR"

# Check if template exists
if [ ! -f "$TEMPLATE_FILE" ]; then
    log_error "Template file not found: $TEMPLATE_FILE"
    exit 1
fi

# Generate the virtual host configuration
cat "$TEMPLATE_FILE" | \
    sed "s/{{PROJECT_NAME}}/$PROJECT_NAME/g" | \
    sed "s/{{PHP_VERSION}}/$PHP_CONTAINER/g" | \
    sed "s/{{PUBLIC_DIR}}/$PUBLIC_DIR/g" > "$VHOST_FILE"

# Remove template comments
sed -i '/^# Template for project virtual host/d' "$VHOST_FILE"
sed -i '/^# Copy this file and rename it to your project name/d' "$VHOST_FILE"
sed -i '/^# Example: myproject.local.conf/d' "$VHOST_FILE"

log_success "Virtual host configuration created: $VHOST_FILE"

# Check if project uses Laravel
if [ -f "$PROJECT_ROOT/www/$PROJECT_NAME/artisan" ]; then
    log_info "Laravel project detected. Updating virtual host for Laravel..."
    
    # Update for Laravel specific configuration
    sed -i 's|# Laravel/Framework specific rules|# Laravel specific rules|g' "$VHOST_FILE"
    sed -i 's|# WordPress specific rules (uncomment if needed)|# WordPress specific rules|g' "$VHOST_FILE"
    
    log_success "Virtual host updated for Laravel project"
fi

# Check if project uses WordPress
if [ -f "$PROJECT_ROOT/www/$PROJECT_NAME/wp-config.php" ] || [ -f "$PROJECT_ROOT/www/$PROJECT_NAME/$PUBLIC_DIR/wp-config.php" ]; then
    log_info "WordPress project detected. Updating virtual host for WordPress..."
    
    # Comment out Laravel rules and uncomment WordPress rules
    sed -i 's|try_files $uri $uri/ /index.php?$query_string;|# try_files $uri $uri/ /index.php?$query_string;|g' "$VHOST_FILE"
    sed -i 's|# location / {|location / {|g' "$VHOST_FILE"
    sed -i 's|#     try_files $uri $uri/ /index.php?$args;|    try_files $uri $uri/ /index.php?$args;|g' "$VHOST_FILE"
    sed -i 's|# }|}|g' "$VHOST_FILE"
    
    log_success "Virtual host updated for WordPress project"
fi

# Show next steps
echo ""
log_info "Next steps:"
echo "1. Add the following line to your hosts file:"
echo "   127.0.0.1 $PROJECT_NAME.local"
echo ""
echo "2. Restart nginx to load the new configuration:"
echo "   docker-compose restart nginx"
echo ""
echo "3. Access your project at:"
echo "   http://$PROJECT_NAME.local"
echo ""

# Offer to restart nginx
read -p "Do you want to restart nginx now? (y/N): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    log_info "Restarting nginx..."
    cd "$PROJECT_ROOT"
    docker-compose restart nginx
    log_success "Nginx restarted successfully!"
fi
