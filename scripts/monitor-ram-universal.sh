#!/bin/bash

# Docker Master Platform - Universal RAM Monitor
# Auto-detects OS and runs appropriate monitor
# Works on macOS, Linux, and Windows (Git Bash/WSL)

# Colors for better output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to detect OS
detect_os() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        echo "macOS"
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        echo "Linux"
    elif [[ "$OSTYPE" == "msys" ]] || [[ "$OSTYPE" == "cygwin" ]]; then
        echo "Windows"
    else
        echo "Unknown"
    fi
}

# Function to run Windows monitor
run_windows_monitor() {
    if [ -f "./scripts/monitor-ram.bat" ]; then
        echo -e "${GREEN}🪟 Running Windows RAM Monitor...${NC}"
        cmd.exe /c "scripts\\monitor-ram.bat"
    else
        echo -e "${RED}❌ Windows monitor script not found${NC}"
        exit 1
    fi
}

# Function to run Unix monitor (macOS/Linux)
run_unix_monitor() {
    if [ -f "./scripts/monitor-ram.sh" ]; then
        echo -e "${GREEN}🐧 Running Unix RAM Monitor...${NC}"
        chmod +x ./scripts/monitor-ram.sh
        ./scripts/monitor-ram.sh
    else
        echo -e "${RED}❌ Unix monitor script not found${NC}"
        exit 1
    fi
}

# Main function
main() {
    clear
    echo -e "${BLUE}========================================${NC}"
    echo -e "${BLUE}  Docker Master Platform - RAM Monitor${NC}"
    echo -e "${BLUE}========================================${NC}"
    echo ""
    
    # Detect OS
    OS=$(detect_os)
    echo -e "${YELLOW}🔍 Detected OS: $OS${NC}"
    echo ""
    
    # Check if we're in the right directory
    if [ ! -f "docker-compose.yml" ]; then
        echo -e "${RED}❌ Please run this script from the docker_master directory${NC}"
        exit 1
    fi
    
    # Run appropriate monitor based on OS
    case $OS in
        "macOS")
            echo -e "${GREEN}🍎 Starting macOS RAM Monitor...${NC}"
            run_unix_monitor
            ;;
        "Linux")
            echo -e "${GREEN}🐧 Starting Linux RAM Monitor...${NC}"
            run_unix_monitor
            ;;
        "Windows")
            echo -e "${GREEN}🪟 Starting Windows RAM Monitor...${NC}"
            run_windows_monitor
            ;;
        *)
            echo -e "${RED}❌ Unsupported OS: $OS${NC}"
            echo "Please run the appropriate monitor script manually:"
            echo "- Windows: scripts/monitor-ram.bat"
            echo "- macOS/Linux: scripts/monitor-ram.sh"
            exit 1
            ;;
    esac
}

# Run main function
main
