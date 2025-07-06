#!/bin/bash

# Docker Development Environment - First Time Setup Script
# This script guides new users through the complete setup process

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

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}   Docker Development Environment${NC}"
echo -e "${BLUE}        First Time Setup${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

echo -e "${YELLOW}Welcome to Docker Development Environment!${NC}"
echo "This script will guide you through the complete setup process."
echo ""

# Check if Docker is installed
echo -e "${BLUE}[STEP 1/7]${NC} Checking Docker installation..."

if ! command -v docker &> /dev/null; then
    log_error "Docker is not installed."
    echo ""
    echo "Please install Docker first:"
    echo "  macOS: https://www.docker.com/products/docker-desktop/"
    echo "  Linux: Follow instructions in INSTALLATION.md"
    echo ""
    echo "After installing Docker, restart this script."
    exit 1
fi

if ! command -v docker-compose &> /dev/null; then
    log_error "Docker Compose is not available."
    echo "Please ensure Docker is properly installed."
    exit 1
fi

# Check if Docker daemon is running
if ! docker info &> /dev/null; then
    log_error "Docker daemon is not running."
    echo "Please start Docker and try again."
    exit 1
fi

log_success "Docker is installed and running."
DOCKER_VERSION=$(docker --version | cut -d' ' -f3 | cut -d',' -f1)
echo "  Docker version: $DOCKER_VERSION"
echo ""

# Check environment file
echo -e "${BLUE}[STEP 2/7]${NC} Setting up environment configuration..."

if [ ! -f "$PROJECT_ROOT/.env" ]; then
    if [ -f "$PROJECT_ROOT/.env.example" ]; then
        cp "$PROJECT_ROOT/.env.example" "$PROJECT_ROOT/.env"
        log_success "Environment file created from template."
    else
        log_warning ".env.example not found. Creating basic .env file..."
        cat > "$PROJECT_ROOT/.env" << EOF
# Docker Development Environment Configuration
MYSQL_ROOT_PASSWORD=root123
MYSQL_DATABASE=dev_db
MYSQL_USER=dev_user
MYSQL_PASSWORD=dev_pass

POSTGRES_DB=dev_db
POSTGRES_USER=dev_user
POSTGRES_PASSWORD=dev_pass

DEFAULT_PHP_VERSION=dev_php84
TIMEZONE=Asia/Ho_Chi_Minh
EOF
        log_success "Basic .env file created."
    fi
else
    log_success "Environment file already exists."
fi
echo ""

# Make scripts executable
echo -e "${BLUE}[STEP 3/7]${NC} Making scripts executable..."
chmod +x "$SCRIPT_DIR"/*.sh
log_success "Scripts made executable."
echo ""

# Run RAM optimization
echo -e "${BLUE}[STEP 4/7]${NC} Optimizing for your system RAM..."
"$SCRIPT_DIR/auto-optimize.sh"
echo ""

# Build and start services
echo -e "${BLUE}[STEP 5/7]${NC} Building and starting Docker services..."
echo "This may take 10-15 minutes on first run..."
echo ""

cd "$PROJECT_ROOT"
if docker-compose up -d --build; then
    log_success "All services started successfully!"
else
    log_error "Failed to start services."
    echo "Please check the error messages above."
    echo "You can try running: docker-compose logs"
    exit 1
fi
echo ""

# Wait for services to be ready
echo -e "${BLUE}[STEP 6/7]${NC} Waiting for services to be ready..."
sleep 10

# Check service status
echo "Checking service status..."
docker-compose ps
echo ""

# Create example project
echo -e "${BLUE}[STEP 7/7]${NC} Creating example project..."
read -p "Do you want to create an example project? (y/N): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "Creating example project 'demo'..."
    
    # Create project directory
    mkdir -p "$PROJECT_ROOT/www/demo/public"
    
    # Create index.php
    cat > "$PROJECT_ROOT/www/demo/public/index.php" << 'EOF'
<?php
echo "<h1>🎉 Welcome to Docker Development Environment!</h1>";
echo "<p>PHP Version: " . PHP_VERSION . "</p>";
echo "<p>Server Time: " . date('Y-m-d H:i:s') . "</p>";
echo "<h2>Quick Links:</h2>";
echo "<ul>";
echo "<li><a href='http://localhost/test-db.php'>Database Test</a></li>";
echo "<li><a href='http://localhost/ram-optimization.php'>RAM Optimization Status</a></li>";
echo "<li><a href='http://localhost:8080'>Adminer (Database Management)</a></li>";
echo "<li><a href='http://localhost:8081'>phpMyAdmin</a></li>";
echo "</ul>";
phpinfo();
?>
EOF
    
    # Create virtual host
    if [ -f "$PROJECT_ROOT/nginx/sites/project-template.conf.example" ]; then
        sed 's/{{PROJECT_NAME}}/demo/g; s/{{PHP_VERSION}}/dev_php84/g; s/{{PUBLIC_DIR}}/public/g' \
            "$PROJECT_ROOT/nginx/sites/project-template.conf.example" > \
            "$PROJECT_ROOT/nginx/sites/demo.local.conf"
        
        # Restart nginx
        docker-compose restart nginx
        
        log_success "Example project created!"
        echo "  Project URL: http://demo.local"
        echo "  Add to hosts file: 127.0.0.1 demo.local"
    else
        log_warning "Virtual host template not found. Project created without virtual host."
    fi
else
    echo "Skipping example project creation."
fi
echo ""

# Final verification
echo "Final verification..."

# Test web access
echo "Testing web access..."
if curl -s http://localhost > /dev/null; then
    log_success "Main page accessible"
else
    log_error "Main page not accessible"
fi

# Test database
echo "Testing database connections..."
if docker-compose exec -T mysql mysql -u dev_user -pdev_pass -e "SELECT 'MySQL OK' as status;" &> /dev/null; then
    log_success "MySQL connection working"
else
    log_warning "MySQL connection failed"
fi

echo ""
echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}   Setup Complete!${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""

echo -e "${BLUE}🎉 Your Docker Development Environment is ready!${NC}"
echo ""
echo -e "${YELLOW}Quick Access URLs:${NC}"
echo "  Main Page:        http://localhost"
echo "  Database Test:    http://localhost/test-db.php"
echo "  RAM Status:       http://localhost/ram-optimization.php"
echo "  Adminer:          http://localhost:8080"
echo "  phpMyAdmin:       http://localhost:8081"

if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "  Demo Project:     http://demo.local (add to hosts file)"
fi

echo ""
echo -e "${YELLOW}Next Steps:${NC}"
echo "  1. Add demo.local to your hosts file (if created)"
echo "  2. Read README.md for complete documentation"
echo "  3. Check examples/ folder for sample projects"
echo "  4. Start building your projects!"
echo ""

echo -e "${YELLOW}Useful Commands:${NC}"
echo "  Start:     ./bin/dev.sh start"
echo "  Stop:      ./bin/dev.sh stop"
echo "  Status:    ./bin/dev.sh status"
echo "  Logs:      ./bin/dev.sh logs"
echo "  Help:      ./bin/dev.sh help"
echo ""

echo -e "${YELLOW}Documentation:${NC}"
echo "  DOCUMENTATION.md     - Choose the right guide for you"
echo "  docs/INSTALLATION.md   - Complete installation guide"
echo "  docs/STEP_BY_STEP.md   - Step-by-step tutorial"
echo "  docs/COMMANDS.md       - Command reference"
echo "  docs/TROUBLESHOOTING.md - Problem solving"
echo ""

read -p "Open main page in browser? (y/N): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    if command -v open &> /dev/null; then
        open http://localhost  # macOS
    elif command -v xdg-open &> /dev/null; then
        xdg-open http://localhost  # Linux
    else
        echo "Please open http://localhost in your browser"
    fi
fi

echo ""
echo -e "${GREEN}Happy coding! 🚀${NC}"
