#!/bin/bash

# PHP Version Management Script
echo "🐘 PHP Version Management for Docker Multi-Project..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to show usage
show_usage() {
    echo -e "${BLUE}Usage: ./scripts/php-version.sh [command] [options]${NC}"
    echo ""
    echo "Commands:"
    echo "  show                    - Show current PHP versions"
    echo "  set-laravel [version]   - Set Laravel PHP version (7.4, 8.0, 8.1, 8.2)"
    echo "  rebuild                 - Rebuild containers with new PHP versions"
    echo ""
    echo "Examples:"
    echo "  ./scripts/php-version.sh show"
    echo "  ./scripts/php-version.sh set-laravel 8.1"
    echo "  ./scripts/php-version.sh rebuild"
}

# Function to show current versions
show_versions() {
    echo -e "${GREEN}📊 Current PHP Versions:${NC}"
    echo ""
    
    # WordPress (always PHP 7.4)
    echo -e "${BLUE}WordPress:${NC} PHP 7.4 (Fixed)"
    
    # Laravel (from .env)
    if [ -f .env ]; then
        LARAVEL_VERSION=$(grep "LARAVEL_PHP_VERSION" .env | cut -d '=' -f2)
        echo -e "${BLUE}Laravel:${NC} PHP ${LARAVEL_VERSION:-8.2}"
    else
        echo -e "${BLUE}Laravel:${NC} PHP 8.2 (Default)"
    fi
    
    echo ""
    echo -e "${YELLOW}Container Status:${NC}"
    docker-compose ps | grep -E "(wordpress|laravel)"
}

# Function to set Laravel PHP version
set_laravel_version() {
    local version=$1
    
    # Validate version
    case $version in
        7.4|8.0|8.1|8.2)
            echo -e "${GREEN}✅ Setting Laravel PHP version to $version${NC}"
            ;;
        *)
            echo -e "${RED}❌ Invalid PHP version: $version${NC}"
            echo "Supported versions: 7.4, 8.0, 8.1, 8.2"
            exit 1
            ;;
    esac
    
    # Update .env file
    if [ -f .env ]; then
        # Check if LARAVEL_PHP_VERSION exists
        if grep -q "LARAVEL_PHP_VERSION" .env; then
            # Update existing line
            sed -i.bak "s/LARAVEL_PHP_VERSION=.*/LARAVEL_PHP_VERSION=$version/" .env
        else
            # Add new line
            echo "LARAVEL_PHP_VERSION=$version" >> .env
        fi
        echo -e "${GREEN}✅ Updated .env file${NC}"
    else
        echo -e "${RED}❌ .env file not found${NC}"
        exit 1
    fi
    
    echo -e "${YELLOW}⚠️  Run './scripts/php-version.sh rebuild' to apply changes${NC}"
}

# Function to rebuild containers
rebuild_containers() {
    echo -e "${BLUE}🔨 Rebuilding containers with new PHP versions...${NC}"
    
    # Stop containers
    echo -e "${YELLOW}🛑 Stopping containers...${NC}"
    docker-compose down
    
    # Remove old images
    echo -e "${YELLOW}🗑️  Removing old images...${NC}"
    docker-compose down --rmi local
    
    # Rebuild and start
    echo -e "${GREEN}🚀 Building and starting containers...${NC}"
    docker-compose up -d --build
    
    # Wait for services
    echo -e "${BLUE}⏳ Waiting for services...${NC}"
    sleep 15
    
    # Show status
    show_versions
    
    echo -e "${GREEN}✅ Rebuild completed!${NC}"
}

# Parse command
case $1 in
    show)
        show_versions
        ;;
    set-laravel)
        if [ -z "$2" ]; then
            echo -e "${RED}❌ Please specify PHP version${NC}"
            show_usage
            exit 1
        fi
        set_laravel_version $2
        ;;
    rebuild)
        rebuild_containers
        ;;
    -h|--help|"")
        show_usage
        ;;
    *)
        echo -e "${RED}❌ Unknown command: $1${NC}"
        show_usage
        exit 1
        ;;
esac
