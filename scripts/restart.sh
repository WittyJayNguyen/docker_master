#!/bin/bash

# Docker Multi-Project Restart Script
echo "🔄 Restarting Docker Multi-Project Environment..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Stop services
echo -e "${YELLOW}🛑 Stopping services...${NC}"
./scripts/stop.sh

# Wait a moment
sleep 3

# Start services
echo -e "${GREEN}🚀 Starting services...${NC}"
./scripts/start.sh

echo -e "${GREEN}✅ Restart completed!${NC}"
