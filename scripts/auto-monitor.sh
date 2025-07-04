#!/bin/bash

# Auto Monitor - Chạy ngầm và theo dõi Docker RAM cho macOS/Linux
# Tự động start khi Docker khởi động

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo ""
echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}  Docker Master Platform - Auto Monitor${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

# Function to check Docker
check_docker() {
    while ! docker version >/dev/null 2>&1; do
        echo -e "${YELLOW}⏳ Waiting for Docker to start...${NC}"
        sleep 10
    done
}

# Function to log with timestamp
log_with_timestamp() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$logfile"
}

# Function to check high RAM usage
check_high_ram() {
    # Get memory percentages and check for high usage
    docker stats --no-stream --format "{{.MemPerc}}" | while read mem_percent; do
        # Remove % sign
        mem_num=$(echo "$mem_percent" | sed 's/%//')
        
        # Check if it's a number and > 90
        if [[ "$mem_num" =~ ^[0-9]+\.?[0-9]*$ ]] && (( $(echo "$mem_num > 90" | bc -l) )); then
            echo -e "${RED}⚠️ HIGH RAM USAGE DETECTED: ${mem_percent} at $(date '+%H:%M:%S')${NC}"
            log_with_timestamp "⚠️ HIGH RAM USAGE: ${mem_percent}"
        fi
    done
}

# Main function
main() {
    # Check Docker initially
    check_docker
    
    echo -e "${GREEN}✅ Docker detected! Starting auto-monitor...${NC}"
    echo ""
    
    # Create log file with timestamp
    timestamp=$(date '+%Y%m%d_%H%M%S')
    logfile="logs/monitor_${timestamp}.log"
    
    # Create logs directory if not exists
    mkdir -p logs
    
    log_with_timestamp "Auto-monitoring started"
    echo "📊 Log file: $logfile"
    echo ""
    
    counter=0
    
    # Main monitoring loop
    while true; do
        current_time=$(date '+%H:%M:%S')
        
        # Check if Docker is still running
        if ! docker version >/dev/null 2>&1; then
            echo -e "${RED}❌ Docker stopped at $current_time${NC}"
            log_with_timestamp "❌ Docker stopped"
            echo "Waiting for Docker to restart..."
            check_docker
            echo -e "${GREEN}✅ Docker restarted!${NC}"
            log_with_timestamp "✅ Docker restarted"
            continue
        fi
        
        # Log RAM usage
        log_with_timestamp "Checking RAM usage..."
        
        # Get container stats and log them
        docker stats --no-stream --format "{{.Container}}: {{.MemUsage}} ({{.MemPerc}})" >> "$logfile" 2>&1
        
        # Check for high RAM usage
        check_high_ram
        
        # Show status every 5 minutes (30 iterations * 10 seconds)
        ((counter++))
        if [ $counter -ge 30 ]; then
            echo -e "${BLUE}[$current_time] Auto-monitor running... Containers:${NC}"
            docker ps --format "{{.Names}}: {{.Status}}" | grep "Up"
            counter=0
        fi
        
        # Wait 10 seconds before next check
        sleep 10
    done
}

# Handle Ctrl+C gracefully
trap 'echo -e "\n${YELLOW}Auto-monitor stopped by user${NC}"; log_with_timestamp "Auto-monitor stopped by user"; exit 0' INT

# Check if we're in the right directory
if [ ! -f "docker-compose.yml" ]; then
    echo -e "${RED}❌ Please run this script from the docker_master directory${NC}"
    exit 1
fi

# Start monitoring
main
