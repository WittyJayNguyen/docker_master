#!/bin/bash

# Docker Multi-Project Stop Script
echo "🛑 Stopping Docker Multi-Project Environment..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Stop containers
echo -e "${BLUE}🔄 Stopping containers...${NC}"
docker-compose down

# Check if containers are stopped
if [ "$(docker-compose ps -q)" ]; then
    echo -e "${YELLOW}⚠️  Some containers are still running${NC}"
    docker-compose ps
else
    echo -e "${GREEN}✅ All containers stopped successfully${NC}"
fi

# Optional: Remove volumes (uncomment if needed)
# echo -e "${YELLOW}🗑️  Removing volumes...${NC}"
# docker-compose down -v

# Optional: Remove images (uncomment if needed)
# echo -e "${YELLOW}🗑️  Removing images...${NC}"
# docker-compose down --rmi all

echo -e "${GREEN}🎯 Environment stopped successfully!${NC}"
echo -e "${BLUE}💡 To start again, run: ./scripts/start.sh${NC}"
