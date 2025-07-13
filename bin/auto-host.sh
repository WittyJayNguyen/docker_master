#!/bin/bash

# Docker Master Platform - Auto Host Manager for macOS/Linux
# Tự động thêm/xóa host entries vào /etc/hosts file
# Usage: ./auto-host.sh [add|remove|list] [hostname] [ip]

# Colors for better output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

echo ""
echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}  DOCKER MASTER - AUTO HOST MANAGER${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

# Set hosts file path
HOSTS_FILE="/etc/hosts"

# Parse command line arguments
COMMAND="$1"
HOSTNAME="$2"
IP_ADDRESS="${3:-127.0.0.1}"

# Check if running with sudo privileges
check_sudo() {
    if [ "$EUID" -ne 0 ]; then
        echo -e "${RED}❌ ERROR: This script requires sudo privileges!${NC}"
        echo ""
        echo -e "${YELLOW}💡 Please run with sudo:${NC}"
        echo "   sudo ./bin/auto-host.sh [command] [hostname]"
        echo ""
        echo -e "${CYAN}Examples:${NC}"
        echo "   sudo ./bin/auto-host.sh add my-shop.local"
        echo "   sudo ./bin/auto-host.sh remove my-shop.local"
        echo "   sudo ./bin/auto-host.sh list"
        echo ""
        exit 1
    fi
}

# Show usage information
show_usage() {
    echo -e "${BLUE}🚀 Docker Master Platform - Auto Host Manager${NC}"
    echo ""
    echo -e "${YELLOW}📝 USAGE:${NC}"
    echo "   sudo ./auto-host.sh add [hostname] [ip]     - Add host entry"
    echo "   sudo ./auto-host.sh remove [hostname]       - Remove host entry"
    echo "   sudo ./auto-host.sh list                    - List all custom hosts"
    echo "   sudo ./auto-host.sh help                    - Show this help"
    echo ""
    echo -e "${CYAN}💡 EXAMPLES:${NC}"
    echo "   sudo ./auto-host.sh add my-shop.local"
    echo "   sudo ./auto-host.sh add api.local 192.168.1.100"
    echo "   sudo ./auto-host.sh remove my-shop.local"
    echo "   sudo ./auto-host.sh list"
    echo ""
    echo -e "${GREEN}🌐 COMMON DOCKER MASTER HOSTS:${NC}"
    echo "   sudo ./auto-host.sh add my-blog.io"
    echo "   sudo ./auto-host.sh add my-shop.io"
    echo "   sudo ./auto-host.sh add user-api.io"
    echo "   sudo ./auto-host.sh add admin-panel.io"
    echo ""
}

# Add host entry
add_host() {
    local HOST_NAME="$1"
    local HOST_IP="$2"
    
    if [ -z "$HOST_NAME" ]; then
        echo -e "${RED}❌ ERROR: Hostname is required!${NC}"
        echo "Usage: sudo ./auto-host.sh add [hostname] [ip]"
        exit 1
    fi
    
    echo -e "${BLUE}🔍 Checking if host already exists: ${HOST_NAME}${NC}"
    
    # Check if host already exists
    if grep -q "$HOST_NAME" "$HOSTS_FILE"; then
        echo -e "${YELLOW}⚠️  Host '${HOST_NAME}' already exists in hosts file${NC}"
        echo ""
        echo "Current entry:"
        grep "$HOST_NAME" "$HOSTS_FILE"
        echo ""
        read -p "Do you want to update it? (y/N): " OVERWRITE
        if [[ ! "$OVERWRITE" =~ ^[Yy]$ ]]; then
            echo -e "${RED}❌ Operation cancelled${NC}"
            exit 0
        fi
        
        # Remove existing entry first
        remove_host "$HOST_NAME" "silent"
    fi
    
    echo -e "${GREEN}📝 Adding host entry: ${HOST_IP} ${HOST_NAME}${NC}"
    
    # Create backup
    cp "$HOSTS_FILE" "${HOSTS_FILE}.backup.$(date +%Y%m%d_%H%M%S)"
    
    # Add new entry with comment
    echo "" >> "$HOSTS_FILE"
    echo "# Docker Master Platform - Added by auto-host.sh on $(date)" >> "$HOSTS_FILE"
    echo "$HOST_IP $HOST_NAME" >> "$HOSTS_FILE"
    
    # Verify addition
    if grep -q "$HOST_NAME" "$HOSTS_FILE"; then
        echo -e "${GREEN}✅ SUCCESS: Host '${HOST_NAME}' added successfully!${NC}"
        echo ""
        echo -e "${CYAN}🌐 You can now access: http://${HOST_NAME}${NC}"
        echo -e "${BLUE}🔄 DNS cache will be flushed automatically...${NC}"
        
        # Flush DNS cache (different commands for different OS)
        if [[ "$OSTYPE" == "darwin"* ]]; then
            # macOS
            sudo dscacheutil -flushcache
            sudo killall -HUP mDNSResponder
            echo -e "${GREEN}✅ macOS DNS cache flushed${NC}"
        elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
            # Linux
            if command -v systemctl &> /dev/null; then
                sudo systemctl restart systemd-resolved 2>/dev/null || true
            fi
            if command -v service &> /dev/null; then
                sudo service network-manager restart 2>/dev/null || true
            fi
            echo -e "${GREEN}✅ Linux DNS cache flushed${NC}"
        fi
    else
        echo -e "${RED}❌ ERROR: Failed to add host entry${NC}"
        exit 1
    fi
}

# Remove host entry
remove_host() {
    local HOST_NAME="$1"
    local SILENT_MODE="$2"
    
    if [ -z "$HOST_NAME" ]; then
        echo -e "${RED}❌ ERROR: Hostname is required!${NC}"
        echo "Usage: sudo ./auto-host.sh remove [hostname]"
        exit 1
    fi
    
    if [ "$SILENT_MODE" != "silent" ]; then
        echo -e "${YELLOW}🗑️  Removing host entry: ${HOST_NAME}${NC}"
    fi
    
    # Check if host exists
    if ! grep -q "$HOST_NAME" "$HOSTS_FILE"; then
        if [ "$SILENT_MODE" != "silent" ]; then
            echo -e "${YELLOW}⚠️  Host '${HOST_NAME}' not found in hosts file${NC}"
        fi
        return 0
    fi
    
    # Create backup
    cp "$HOSTS_FILE" "${HOSTS_FILE}.backup.$(date +%Y%m%d_%H%M%S)"
    
    # Remove the host entry and its comment
    sed -i.tmp "/# Docker Master Platform.*$(date +%Y-%m-%d)/d; /$HOST_NAME/d" "$HOSTS_FILE"
    rm -f "${HOSTS_FILE}.tmp"
    
    if [ "$SILENT_MODE" != "silent" ]; then
        echo -e "${GREEN}✅ SUCCESS: Host '${HOST_NAME}' removed successfully!${NC}"
        echo -e "${BLUE}🔄 DNS cache will be flushed automatically...${NC}"
        
        # Flush DNS cache
        if [[ "$OSTYPE" == "darwin"* ]]; then
            sudo dscacheutil -flushcache
            sudo killall -HUP mDNSResponder
            echo -e "${GREEN}✅ macOS DNS cache flushed${NC}"
        elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
            if command -v systemctl &> /dev/null; then
                sudo systemctl restart systemd-resolved 2>/dev/null || true
            fi
            echo -e "${GREEN}✅ Linux DNS cache flushed${NC}"
        fi
    fi
}

# List all custom hosts
list_hosts() {
    echo -e "${CYAN}📋 Current custom host entries:${NC}"
    echo "================================"
    echo ""
    
    # Show Docker Master Platform entries
    echo -e "${BLUE}🐳 Docker Master Platform hosts:${NC}"
    if grep -q "Docker Master Platform" "$HOSTS_FILE"; then
        grep -A1 "Docker Master Platform" "$HOSTS_FILE" | grep -v "^#" | grep -v "^--$" | sed 's/^/  /'
    else
        echo "  (No Docker Master Platform hosts found)"
    fi
    
    echo ""
    echo -e "${GREEN}🌐 All custom hosts (non-system):${NC}"
    grep -v "^#" "$HOSTS_FILE" | grep -v "localhost" | grep -v "::1" | grep "^[0-9]" | sed 's/^/  /' || echo "  (No custom hosts found)"
    
    echo ""
    echo -e "${YELLOW}💡 Use 'sudo ./auto-host.sh remove [hostname]' to remove entries${NC}"
}

# Main execution
case "$COMMAND" in
    "add")
        check_sudo
        add_host "$HOSTNAME" "$IP_ADDRESS"
        ;;
    "remove")
        check_sudo
        remove_host "$HOSTNAME"
        ;;
    "list")
        list_hosts
        ;;
    "help"|"")
        show_usage
        ;;
    *)
        echo -e "${RED}❌ Unknown command: $COMMAND${NC}"
        echo ""
        show_usage
        exit 1
        ;;
esac
