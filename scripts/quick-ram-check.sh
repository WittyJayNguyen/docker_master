#!/bin/bash

# Quick RAM Check - Docker Master Platform for macOS/Linux

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

echo ""
echo -e "${BLUE}🚀 Quick RAM Check - Docker Master Platform${NC}"
echo "============================================"
echo ""

# Quick Docker check
if ! docker version >/dev/null 2>&1; then
    echo -e "${RED}❌ Docker not running${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Docker Status: Running${NC}"
echo ""

echo -e "${BLUE}📊 Container RAM Usage:${NC}"
docker stats --format "table {{.Container}}\t{{.MemUsage}}\t{{.MemPerc}}" --no-stream
echo ""

echo -e "${BLUE}💾 Total Docker Usage:${NC}"
docker system df --format "table {{.Type}}\t{{.TotalCount}}\t{{.Size}}\t{{.Reclaimable}}"
echo ""

echo -e "${BLUE}🖥️ System Memory:${NC}"
if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS
    total_mem=$(sysctl -n hw.memsize)
    total_gb=$((total_mem / 1024 / 1024 / 1024))
    
    # Get memory info using vm_stat
    vm_stat_output=$(vm_stat)
    page_size=$(vm_stat | grep "page size" | awk '{print $8}')
    free_pages=$(echo "$vm_stat_output" | grep "Pages free" | awk '{print $3}' | sed 's/\.//')
    free_gb=$(echo "scale=1; $free_pages * $page_size / 1024 / 1024 / 1024" | bc 2>/dev/null || echo "N/A")
    
    echo "Total: ${total_gb}GB"
    echo "Free: ~${free_gb}GB"
    
    # Memory pressure
    memory_pressure=$(memory_pressure 2>/dev/null | head -1 || echo "Normal")
    echo "Memory Pressure: $memory_pressure"
    
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    # Linux
    free -h | head -2
else
    echo "Unknown OS: $OSTYPE"
fi
echo ""

echo -e "${YELLOW}🎯 RAM Optimization Status:${NC}"
if [ -f "docker-compose.override.yml" ]; then
    echo -e "${GREEN}✅ RAM optimization is ACTIVE${NC}"
    echo "   - Memory limits applied to all containers"
    echo "   - Expected usage: 2-3GB instead of 4-6GB"
else
    echo -e "${YELLOW}⚠️  RAM optimization is NOT active${NC}"
    echo "   - Run: ./scripts/optimize-ram.sh"
    echo "   - Choose option 2 for optimized profile"
fi

echo ""
echo -e "${BLUE}💡 Tips:${NC}"
echo "   - Run './scripts/optimize-ram.sh' to change RAM profile"
echo "   - Run './scripts/monitor-ram.sh' for real-time monitoring"
echo "   - Use 'docker stats' for live container monitoring"
echo ""

# Calculate total Docker RAM usage
total_docker_ram=$(docker stats --no-stream --format "{{.MemUsage}}" | awk -F'/' '{sum += $1} END {print sum}' 2>/dev/null || echo "N/A")
if [ "$total_docker_ram" != "N/A" ]; then
    echo -e "${GREEN}📈 Total Docker RAM: ~${total_docker_ram}MB${NC}"
fi
