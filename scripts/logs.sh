#!/bin/bash

# Docker Multi-Project Logs Script
echo "📋 Docker Multi-Project Logs Viewer..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to show usage
show_usage() {
    echo -e "${BLUE}Usage: ./scripts/logs.sh [service] [options]${NC}"
    echo ""
    echo "Services:"
    echo "  mysql            - MySQL database logs"
    echo "  postgres         - PostgreSQL database logs"
    echo "  wordpress-server - WordPress (PHP 7.4) logs"
    echo "  laravel-server   - Laravel (PHP 8.x) logs"
    echo "  nodejs           - Node.js/Vue logs"
    echo "  phpmyadmin       - phpMyAdmin logs"
    echo "  pgadmin          - pgAdmin logs"
    echo "  all              - All services logs"
    echo ""
    echo "Options:"
    echo "  -f, --follow   Follow log output"
    echo "  -t, --tail N   Show last N lines (default: 100)"
    echo ""
    echo "Examples:"
    echo "  ./scripts/logs.sh mysql"
    echo "  ./scripts/logs.sh wordpress-server -f"
    echo "  ./scripts/logs.sh laravel-server --tail 50"
    echo "  ./scripts/logs.sh all -f"
}

# Default values
SERVICE=""
FOLLOW=""
TAIL="100"

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        mysql|postgres|wordpress-server|laravel-server|nodejs|phpmyadmin|pgadmin|all)
            SERVICE="$1"
            shift
            ;;
        -f|--follow)
            FOLLOW="-f"
            shift
            ;;
        -t|--tail)
            TAIL="$2"
            shift 2
            ;;
        -h|--help)
            show_usage
            exit 0
            ;;
        *)
            echo -e "${RED}❌ Unknown option: $1${NC}"
            show_usage
            exit 1
            ;;
    esac
done

# Check if service is specified
if [ -z "$SERVICE" ]; then
    echo -e "${RED}❌ Please specify a service${NC}"
    show_usage
    exit 1
fi

# Show logs based on service
case $SERVICE in
    mysql)
        echo -e "${GREEN}📊 MySQL Logs:${NC}"
        docker-compose logs --tail=$TAIL $FOLLOW mysql
        ;;
    postgres)
        echo -e "${GREEN}🐘 PostgreSQL Logs:${NC}"
        docker-compose logs --tail=$TAIL $FOLLOW postgres
        ;;
    wordpress-server)
        echo -e "${GREEN}📱 WordPress (PHP 7.4) Logs:${NC}"
        docker-compose logs --tail=$TAIL $FOLLOW wordpress-server
        ;;
    laravel-server)
        echo -e "${GREEN}🚀 Laravel (PHP 8.x) Logs:${NC}"
        docker-compose logs --tail=$TAIL $FOLLOW laravel-server
        ;;
    nodejs)
        echo -e "${GREEN}⚡ Node.js/Vue Logs:${NC}"
        docker-compose logs --tail=$TAIL $FOLLOW nodejs
        ;;
    phpmyadmin)
        echo -e "${GREEN}🗄️  phpMyAdmin Logs:${NC}"
        docker-compose logs --tail=$TAIL $FOLLOW phpmyadmin
        ;;
    pgadmin)
        echo -e "${GREEN}🐘 pgAdmin Logs:${NC}"
        docker-compose logs --tail=$TAIL $FOLLOW pgadmin
        ;;
    all)
        echo -e "${GREEN}📋 All Services Logs:${NC}"
        docker-compose logs --tail=$TAIL $FOLLOW
        ;;
esac
