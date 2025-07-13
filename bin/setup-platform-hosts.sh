#!/bin/bash

# Docker Master Platform - Auto Setup Platform Hosts for macOS/Linux
# Tự động thêm tất cả platform hosts vào /etc/hosts file

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

echo ""
echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}  DOCKER MASTER - PLATFORM HOST SETUP${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

# Check if running with sudo
if [ "$EUID" -ne 0 ]; then
    echo -e "${RED}❌ ERROR: This script requires sudo privileges!${NC}"
    echo ""
    echo -e "${YELLOW}💡 Please run with sudo:${NC}"
    echo "   sudo ./bin/setup-platform-hosts.sh"
    echo ""
    exit 1
fi

echo -e "${GREEN}🚀 Setting up hosts for all Docker Master Platform projects...${NC}"
echo ""

# Common platform hosts for Docker Master Platform
PLATFORMS=(
    "my-blog.io"
    "my-shop.io"
    "user-api.io"
    "admin-panel.io"
    "laravel-api.io"
    "wordpress-blog.io"
    "ecommerce-shop.io"
    "payment-service.io"
    "notification-api.io"
    "tech-blog.io"
)

# Auto-detect existing platforms from platforms directory
echo -e "${BLUE}🔍 Auto-detecting existing platforms...${NC}"
if [ -d "platforms" ]; then
    for platform_dir in platforms/*/; do
        if [ -d "$platform_dir" ]; then
            platform_name=$(basename "$platform_dir")
            echo "  Found platform: $platform_name"
            ./bin/auto-host.sh add "${platform_name}.io"
        fi
    done
fi

echo ""
echo -e "${CYAN}📝 Adding common Docker Master Platform hosts...${NC}"

# Add common platform hosts
for platform in "${PLATFORMS[@]}"; do
    echo "Adding: $platform"
    ./bin/auto-host.sh add "$platform"
done

echo ""
echo -e "${YELLOW}🌐 Adding development domains...${NC}"
./bin/auto-host.sh add "localhost.dev"
./bin/auto-host.sh add "api.dev"
./bin/auto-host.sh add "admin.dev"
./bin/auto-host.sh add "dashboard.dev"

echo ""
echo -e "${GREEN}✅ Platform hosts setup completed!${NC}"
echo ""
echo -e "${CYAN}📋 All configured hosts:${NC}"
./bin/auto-host.sh list

echo ""
echo -e "${YELLOW}💡 You can now access your platforms using:${NC}"
echo "  • http://my-blog.io"
echo "  • http://my-shop.io"
echo "  • http://user-api.io"
echo "  • http://admin-panel.io"
echo "  • And more..."

echo ""
echo -e "${BLUE}🔧 To add custom hosts:${NC}"
echo "   sudo ./bin/auto-host.sh add [hostname]"
echo ""
echo -e "${RED}🗑️  To remove hosts:${NC}"
echo "   sudo ./bin/auto-host.sh remove [hostname]"
echo ""
