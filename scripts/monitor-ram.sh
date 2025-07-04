#!/bin/bash

# Docker Master Platform - RAM Monitor for macOS/Linux
# Usage: ./scripts/monitor-ram.sh

# Colors for better output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Function to print colored text
print_header() {
    echo -e "${BLUE}========================================${NC}"
    echo -e "${BLUE}   Docker Master Platform - RAM Monitor${NC}"
    echo -e "${BLUE}========================================${NC}"
    echo ""
}

# Function to check if Docker is running
check_docker() {
    if ! docker version >/dev/null 2>&1; then
        echo -e "${RED}❌ Docker is not running or not accessible${NC}"
        echo "Please start Docker Desktop and try again."
        exit 1
    fi
}

# Function to get system memory info
get_system_memory() {
    echo -e "${PURPLE}💻 System Memory Info:${NC}"
    echo "----------------------------------------------------------------"
    
    if [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS
        total_mem=$(sysctl -n hw.memsize)
        total_gb=$((total_mem / 1024 / 1024 / 1024))
        
        # Get memory pressure
        memory_pressure=$(memory_pressure 2>/dev/null | head -1 || echo "Normal")
        
        # Get free memory using vm_stat
        vm_stat_output=$(vm_stat)
        page_size=$(vm_stat | grep "page size" | awk '{print $8}')
        free_pages=$(echo "$vm_stat_output" | grep "Pages free" | awk '{print $3}' | sed 's/\.//')
        free_mem_mb=$((free_pages * page_size / 1024 / 1024))
        
        echo "Total Memory: ${total_gb}GB"
        echo "Free Memory: ~${free_mem_mb}MB"
        echo "Memory Pressure: $memory_pressure"
        
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        # Linux
        free -h | head -2
        
    else
        echo "Unknown OS type: $OSTYPE"
    fi
    echo ""
}

# Function to monitor containers
monitor_containers() {
    echo -e "${CYAN}🐳 Container RAM Usage:${NC}"
    echo "----------------------------------------------------------------"
    
    # Check if any containers are running
    if ! docker ps -q >/dev/null 2>&1 || [ -z "$(docker ps -q)" ]; then
        echo -e "${YELLOW}⚠️  No containers running${NC}"
        return
    fi
    
    # Show container stats
    docker stats --format "table {{.Container}}\t{{.MemUsage}}\t{{.MemPerc}}\t{{.CPUPerc}}" --no-stream 2>/dev/null
    
    echo ""
    echo -e "${CYAN}💾 Total Docker System Usage:${NC}"
    echo "----------------------------------------------------------------"
    docker system df
    echo ""
}

# Function to show detailed container info
show_detailed_info() {
    clear
    print_header
    echo -e "${YELLOW}🔍 Detailed Container Information:${NC}"
    echo "================================================================"
    echo ""
    
    docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
    echo ""
    
    echo -e "${YELLOW}📊 Resource Limits:${NC}"
    echo "----------------------------------------------------------------"
    
    # Get container names and show their limits
    for container in $(docker ps --format "{{.Names}}"); do
        echo ""
        echo -e "${GREEN}Container: $container${NC}"
        
        # Memory limit
        memory_limit=$(docker inspect "$container" --format "{{.HostConfig.Memory}}" 2>/dev/null)
        if [ "$memory_limit" = "0" ]; then
            echo "  Memory Limit: No limit"
        else
            memory_mb=$((memory_limit / 1024 / 1024))
            echo "  Memory Limit: ${memory_mb}MB"
        fi
        
        # CPU limit
        cpu_quota=$(docker inspect "$container" --format "{{.HostConfig.CpuQuota}}" 2>/dev/null)
        if [ "$cpu_quota" = "0" ] || [ "$cpu_quota" = "-1" ]; then
            echo "  CPU Limit: No limit"
        else
            echo "  CPU Limit: $cpu_quota"
        fi
    done
    
    echo ""
    echo "Press any key to return to main monitor..."
    read -n 1
}

# Function to optimize RAM
optimize_ram() {
    echo ""
    echo -e "${GREEN}🔧 Starting RAM Optimization...${NC}"
    
    if [ -f "./scripts/optimize-ram.sh" ]; then
        ./scripts/optimize-ram.sh
    else
        echo "Creating optimize-ram.sh script..."
        # We'll create this if it doesn't exist
        create_optimize_script
        ./scripts/optimize-ram.sh
    fi
}

# Function to create optimize script for macOS/Linux
create_optimize_script() {
    cat > ./scripts/optimize-ram.sh << 'EOF'
#!/bin/bash

# Docker Master Platform - RAM Optimizer for macOS/Linux

echo ""
echo "========================================"
echo "  Docker Master Platform - RAM Optimizer"
echo "========================================"
echo ""
echo "Select RAM optimization profile:"
echo ""
echo "1. 🔥 LOW RAM (4GB)    - Only essential services (~1-2GB)"
echo "   - Laravel PHP 8.4 + PostgreSQL + Redis + Mailhog"
echo ""
echo "2. ⚡ OPTIMIZED (8GB)  - All services with limits (~2-3GB)"
echo "   - All services with memory limits applied"
echo ""
echo "3. 🚀 DEFAULT (16GB+)  - Full configuration (~4-6GB)"
echo "   - All services without limits"
echo ""
echo "4. 📊 MONITOR          - Show current RAM usage"
echo ""
echo "5. ❌ EXIT"
echo ""
read -p "Enter your choice (1-5): " choice

case $choice in
    1)
        echo ""
        echo "🔥 Starting LOW RAM profile..."
        echo "Stopping current containers..."
        docker-compose down
        echo ""
        echo "Starting essential services only..."
        docker-compose -f docker-compose.low-ram.yml up -d
        echo ""
        echo "✅ LOW RAM profile started!"
        echo "📱 Access: http://localhost:8010 (Laravel PHP 8.4)"
        ;;
    2)
        echo ""
        echo "⚡ Starting OPTIMIZED profile..."
        echo "Stopping current containers..."
        docker-compose down
        echo ""
        echo "Starting all services with memory limits..."
        docker-compose -f docker-compose.yml -f docker-compose.override.yml up -d
        echo ""
        echo "✅ OPTIMIZED profile started!"
        echo "📱 Laravel PHP 8.4: http://localhost:8010"
        echo "📱 Laravel PHP 7.4: http://localhost:8011"
        echo "📱 WordPress: http://localhost:8012"
        ;;
    3)
        echo ""
        echo "🚀 Starting DEFAULT profile..."
        echo "Stopping current containers..."
        docker-compose down
        echo ""
        echo "Starting all services without limits..."
        docker-compose up -d
        echo ""
        echo "✅ DEFAULT profile started!"
        echo "📱 Laravel PHP 8.4: http://localhost:8010"
        echo "📱 Laravel PHP 7.4: http://localhost:8011"
        echo "📱 WordPress: http://localhost:8012"
        echo "📱 phpMyAdmin: http://localhost:8080"
        echo "📱 pgAdmin: http://localhost:8081"
        ;;
    4)
        echo ""
        echo "📊 Current Docker RAM Usage:"
        echo "================================"
        docker stats --format "table {{.Container}}\t{{.MemUsage}}\t{{.MemPerc}}" --no-stream
        echo ""
        echo "💾 Docker System Usage:"
        docker system df
        echo ""
        read -p "Press any key to continue..."
        ;;
    5)
        echo ""
        echo "👋 Goodbye!"
        exit 0
        ;;
    *)
        echo ""
        echo "❌ Invalid choice. Please enter 1-5."
        ;;
esac

echo ""
echo "📊 Checking RAM usage..."
sleep 3
docker stats --format "table {{.Container}}\t{{.MemUsage}}\t{{.MemPerc}}" --no-stream
echo ""
echo "💡 Tips:"
echo "- Use 'docker stats' to monitor real-time usage"
echo "- Run this script again to switch profiles"
echo "- Check docs/07-RAM-OPTIMIZATION.md for details"
echo ""
EOF

    chmod +x ./scripts/optimize-ram.sh
}

# Main monitoring loop
main_loop() {
    while true; do
        clear
        print_header
        
        # Show current date/time
        echo -e "${GREEN}📊 Docker RAM Usage Monitor - $(date)${NC}"
        echo "================================================================"
        echo ""
        
        # Check Docker status
        check_docker
        
        # Show container stats
        monitor_containers
        
        # Show system memory
        get_system_memory
        
        echo "================================================================"
        echo "Options:"
        echo "1. Refresh (auto-refresh every 5 seconds)"
        echo "2. Optimize RAM (switch to low RAM profile)"
        echo "3. Show detailed container info"
        echo "4. Exit"
        echo ""
        echo "Press Ctrl+C to stop auto-refresh"
        echo ""
        
        # Wait for user input with timeout
        read -t 5 -p "Choose option (auto-refresh in 5s): " option
        
        case $option in
            2)
                optimize_ram
                ;;
            3)
                show_detailed_info
                ;;
            4)
                echo ""
                echo "👋 Monitoring stopped."
                exit 0
                ;;
            *)
                # Continue loop (refresh)
                ;;
        esac
    done
}

# Make sure we're in the right directory
if [ ! -f "docker-compose.yml" ]; then
    echo -e "${RED}❌ Please run this script from the docker_master directory${NC}"
    exit 1
fi

# Start monitoring
main_loop
