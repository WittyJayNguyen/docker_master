#!/bin/bash

# Docker Multi-Project Start Script
echo "🚀 Starting Docker Multi-Project Environment..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Check if .env file exists
if [ ! -f .env ]; then
    echo -e "${RED}❌ .env file not found. Please run ./scripts/setup.sh first.${NC}"
    exit 1
fi

# Stop any existing containers
echo -e "${YELLOW}🛑 Stopping existing containers...${NC}"
docker-compose down

# Build and start containers
echo -e "${BLUE}🔨 Building and starting containers...${NC}"
docker-compose up -d --build

# Wait for services to be ready
echo -e "${BLUE}⏳ Waiting for services to be ready...${NC}"
sleep 10

# Check service status
echo -e "${BLUE}📊 Checking service status...${NC}"

# Check MySQL
if docker-compose exec -T mysql mysqladmin ping -h localhost --silent; then
    echo -e "${GREEN}✅ MySQL is running${NC}"
else
    echo -e "${RED}❌ MySQL is not responding${NC}"
fi

# Check PostgreSQL
if docker-compose exec -T postgres pg_isready -h localhost; then
    echo -e "${GREEN}✅ PostgreSQL is running${NC}"
else
    echo -e "${RED}❌ PostgreSQL is not responding${NC}"
fi

# Check WordPress (PHP 7.4)
if curl -s http://localhost > /dev/null; then
    echo -e "${GREEN}✅ WordPress Server (PHP 7.4) is running${NC}"
else
    echo -e "${RED}❌ WordPress Server is not responding${NC}"
fi

# Check Laravel (PHP 8.x)
if curl -s http://localhost:8000 > /dev/null; then
    echo -e "${GREEN}✅ Laravel Server (PHP 8.x) is running${NC}"
else
    echo -e "${RED}❌ Laravel Server is not responding${NC}"
fi

# Check phpMyAdmin
if curl -s http://localhost:8080 > /dev/null; then
    echo -e "${GREEN}✅ phpMyAdmin is running${NC}"
else
    echo -e "${RED}❌ phpMyAdmin is not responding${NC}"
fi

# Check pgAdmin
if curl -s http://localhost:8081 > /dev/null; then
    echo -e "${GREEN}✅ pgAdmin is running${NC}"
else
    echo -e "${RED}❌ pgAdmin is not responding${NC}"
fi

# Show running containers
echo -e "${BLUE}📋 Running containers:${NC}"
docker-compose ps

# Show access URLs
echo -e "${GREEN}🎯 Access your applications:${NC}"
echo "📱 WordPress (PHP 7.4): http://wordpress.local"
echo "🚀 Laravel (PHP 8.x): http://laravel.local:8000"
echo "⚡ Vue.js: http://localhost:3000"
echo "🗄️  phpMyAdmin (MySQL): http://localhost:8080"
echo "🐘 pgAdmin (PostgreSQL): http://localhost:8081"
echo ""
echo -e "${YELLOW}📝 Database credentials:${NC}"
echo "MySQL Host: localhost:3306 (Root: rootpassword123)"
echo "PostgreSQL Host: localhost:5432 (User: postgres, Pass: postgres123)"
echo ""
echo "WordPress DB: wordpress_db (MySQL: wp_user/wp_password123, PG: wp_user/wp_password123)"
echo "Laravel DB: laravel_db (MySQL: laravel_user/laravel_password123, PG: laravel_user/laravel_password123)"
echo ""
echo -e "${BLUE}🐘 PHP Version Management:${NC}"
echo "Check versions: ./scripts/php-version.sh show"
echo "Change Laravel PHP: ./scripts/php-version.sh set-laravel [7.4|8.0|8.1|8.2]"
echo ""
echo -e "${BLUE}🗄️ Database Management:${NC}"
echo "Database status: ./scripts/database.sh status"
echo "Connect MySQL: ./scripts/database.sh mysql"
echo "Connect PostgreSQL: ./scripts/database.sh postgres"
echo ""
echo -e "${BLUE}🔧 Useful commands:${NC}"
echo "View logs: ./scripts/logs.sh [wordpress-server|laravel-server|mysql|postgres]"
echo "Stop services: ./scripts/stop.sh"
echo "Restart services: ./scripts/restart.sh"
