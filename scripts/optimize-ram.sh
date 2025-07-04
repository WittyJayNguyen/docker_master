#!/bin/bash

# Docker Master Platform - RAM Optimizer for macOS/Linux

# Colors for better output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

clear
echo ""
echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}  Docker Master Platform - RAM Optimizer${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""
echo "Select RAM optimization profile:"
echo ""
echo -e "${RED}1. 🔥 LOW RAM (4GB)${NC}    - Only essential services (~1-2GB)"
echo "   - Laravel PHP 8.4 + PostgreSQL + Redis + Mailhog"
echo ""
echo -e "${YELLOW}2. ⚡ OPTIMIZED (8GB)${NC}  - All services with limits (~2-3GB)"
echo "   - All services with memory limits applied"
echo ""
echo -e "${GREEN}3. 🚀 DEFAULT (16GB+)${NC}  - Full configuration (~4-6GB)"
echo "   - All services without limits"
echo ""
echo -e "${CYAN}4. 📊 MONITOR${NC}          - Show current RAM usage"
echo ""
echo -e "${PURPLE}5. ❌ EXIT${NC}"
echo ""
read -p "Enter your choice (1-5): " choice

case $choice in
    1)
        echo ""
        echo -e "${RED}🔥 Starting LOW RAM profile...${NC}"
        echo "Stopping current containers..."
        docker-compose down
        echo ""
        echo "Starting essential services only..."
        docker-compose -f docker-compose.low-ram.yml up -d
        echo ""
        echo -e "${GREEN}✅ LOW RAM profile started!${NC}"
        echo -e "${CYAN}📱 Access: http://localhost:8010 (Laravel PHP 8.4)${NC}"
        show_usage
        ;;
    2)
        echo ""
        echo -e "${YELLOW}⚡ Starting OPTIMIZED profile...${NC}"
        echo "Stopping current containers..."
        docker-compose down
        echo ""
        echo "Starting all services with memory limits..."
        docker-compose -f docker-compose.yml -f docker-compose.override.yml up -d
        echo ""
        echo -e "${GREEN}✅ OPTIMIZED profile started!${NC}"
        echo -e "${CYAN}📱 Laravel PHP 8.4: http://localhost:8010${NC}"
        echo -e "${CYAN}📱 Laravel PHP 7.4: http://localhost:8011${NC}"
        echo -e "${CYAN}📱 WordPress: http://localhost:8012${NC}"
        show_usage
        ;;
    3)
        echo ""
        echo -e "${GREEN}🚀 Starting DEFAULT profile...${NC}"
        echo "Stopping current containers..."
        docker-compose down
        echo ""
        echo "Starting all services without limits..."
        docker-compose up -d
        echo ""
        echo -e "${GREEN}✅ DEFAULT profile started!${NC}"
        echo -e "${CYAN}📱 Laravel PHP 8.4: http://localhost:8010${NC}"
        echo -e "${CYAN}📱 Laravel PHP 7.4: http://localhost:8011${NC}"
        echo -e "${CYAN}📱 WordPress: http://localhost:8012${NC}"
        echo -e "${CYAN}📱 phpMyAdmin: http://localhost:8080${NC}"
        echo -e "${CYAN}📱 pgAdmin: http://localhost:8081${NC}"
        show_usage
        ;;
    4)
        echo ""
        echo -e "${CYAN}📊 Current Docker RAM Usage:${NC}"
        echo "================================"
        docker stats --format "table {{.Container}}\t{{.MemUsage}}\t{{.MemPerc}}" --no-stream
        echo ""
        echo -e "${PURPLE}💾 Docker System Usage:${NC}"
        docker system df
        echo ""
        
        # Show system memory for macOS/Linux
        if [[ "$OSTYPE" == "darwin"* ]]; then
            echo -e "${YELLOW}🍎 macOS Memory Info:${NC}"
            total_mem=$(sysctl -n hw.memsize)
            total_gb=$((total_mem / 1024 / 1024 / 1024))
            echo "Total Memory: ${total_gb}GB"
            
            # Memory pressure
            memory_pressure=$(memory_pressure 2>/dev/null | head -1 || echo "Normal")
            echo "Memory Pressure: $memory_pressure"
            
        elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
            echo -e "${YELLOW}🐧 Linux Memory Info:${NC}"
            free -h | head -2
        fi
        
        echo ""
        read -p "Press any key to continue..."
        ;;
    5)
        echo ""
        echo -e "${PURPLE}👋 Goodbye!${NC}"
        exit 0
        ;;
    *)
        echo ""
        echo -e "${RED}❌ Invalid choice. Please enter 1-5.${NC}"
        echo ""
        read -p "Press any key to try again..."
        exec "$0"
        ;;
esac

# Function to show usage after starting
show_usage() {
    echo ""
    echo -e "${CYAN}📊 Checking RAM usage...${NC}"
    sleep 3
    docker stats --format "table {{.Container}}\t{{.MemUsage}}\t{{.MemPerc}}" --no-stream
    echo ""
    echo -e "${YELLOW}💡 Tips:${NC}"
    echo "- Use 'docker stats' to monitor real-time usage"
    echo "- Run this script again to switch profiles"
    echo "- Check docs/07-RAM-OPTIMIZATION.md for details"
    echo ""
    read -p "Press any key to exit..."
}

# Check if we're in the right directory
if [ ! -f "docker-compose.yml" ]; then
    echo -e "${RED}❌ Please run this script from the docker_master directory${NC}"
    exit 1
fi
