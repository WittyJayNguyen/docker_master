#!/bin/bash
# Docker Master Platform - Cross-Platform Setup Script
# Automatic setup for Windows, Linux, and macOS

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Function to print colored output
print_color() {
    local color=$1
    local message=$2
    echo -e "${color}${message}${NC}"
}

# Function to detect operating system
detect_os() {
    case "$OSTYPE" in
        msys*|mingw*|cygwin*)
            echo "windows"
            ;;
        darwin*)
            echo "macos"
            ;;
        linux*)
            echo "linux"
            ;;
        *)
            echo "unknown"
            ;;
    esac
}

# Function to check if running on Windows environment
is_windows_env() {
    if [[ "$OSTYPE" == "msys" ]] || [[ "$OSTYPE" == "mingw"* ]] || [[ "$OSTYPE" == "cygwin" ]]; then
        return 0
    elif [[ -n "$WSL_DISTRO_NAME" ]] || [[ -n "$WSLENV" ]]; then
        return 0
    elif [[ "$(uname -r)" == *"Microsoft"* ]] || [[ "$(uname -r)" == *"microsoft"* ]]; then
        return 0
    else
        return 1
    fi
}

# Function to check Docker installation
check_docker() {
    print_color $BLUE "🐳 Checking Docker installation..."
    
    if ! command -v docker >/dev/null 2>&1; then
        print_color $RED "❌ Docker is not installed!"
        print_color $YELLOW "Please install Docker Desktop from: https://www.docker.com/products/docker-desktop"
        return 1
    fi
    
    if ! docker info >/dev/null 2>&1; then
        print_color $RED "❌ Docker is not running!"
        print_color $YELLOW "Please start Docker Desktop and try again."
        return 1
    fi
    
    print_color $GREEN "✅ Docker is installed and running"
    
    # Check Docker Compose
    if ! command -v docker-compose >/dev/null 2>&1; then
        print_color $RED "❌ Docker Compose is not installed!"
        return 1
    fi
    
    print_color $GREEN "✅ Docker Compose is available"
    return 0
}

# Function to setup permissions
setup_permissions() {
    local os=$(detect_os)
    
    if [[ "$os" != "windows" ]] && ! is_windows_env; then
        print_color $BLUE "🔐 Setting up script permissions..."
        
        # Make main launcher executable
        chmod +x docker-master 2>/dev/null || true
        
        # Make bin scripts executable
        find bin -name "*.sh" -exec chmod +x {} \; 2>/dev/null || true
        
        # Make src scripts executable
        find src/scripts -name "*.sh" -exec chmod +x {} \; 2>/dev/null || true
        
        print_color $GREEN "✅ Script permissions set"
    fi
}

# Function to setup environment file
setup_environment() {
    print_color $BLUE "⚙️ Setting up environment configuration..."
    
    if [[ ! -f ".env" ]]; then
        if [[ -f ".env.example" ]]; then
            cp .env.example .env
            print_color $GREEN "✅ Environment file created from .env.example"
        else
            print_color $YELLOW "⚠️ No .env.example found, creating basic .env"
            cat > .env << EOF
# Docker Master Platform - Environment Variables
COMPOSE_PROJECT_NAME=docker_master
COMPOSE_FILE=src/config/environments/docker-compose.cross-platform.yml

# PostgreSQL Configuration
POSTGRES_PORT=5432
POSTGRES_DB=docker_master
POSTGRES_USER=postgres_user
POSTGRES_PASSWORD=postgres_pass

# MySQL Configuration
MYSQL_PORT=3306
MYSQL_ROOT_PASSWORD=root_password
MYSQL_DATABASE=docker_master
MYSQL_USER=mysql_user
MYSQL_PASSWORD=mysql_pass

# Redis Configuration
REDIS_PORT=6379

# Laravel PHP 8.4 Configuration
LARAVEL84_PORT=8010
LARAVEL84_DEBUG_PORT=9084

# Development Configuration
ENABLE_XDEBUG=true
ENABLE_OPCACHE=true
EOF
        fi
    else
        print_color $YELLOW "⚠️ .env file already exists, skipping"
    fi
}

# Function to create runtime directories
setup_directories() {
    print_color $BLUE "📁 Creating runtime directories..."
    
    local dirs=(
        "runtime/projects"
        "runtime/logs/apache"
        "runtime/logs/mysql"
        "runtime/logs/postgresql"
        "runtime/logs/php"
        "runtime/logs/redis"
        "runtime/data/uploads"
        "runtime/backups"
    )
    
    for dir in "${dirs[@]}"; do
        mkdir -p "$dir"
        # Create .gitkeep if directory is empty
        if [[ ! "$(ls -A "$dir" 2>/dev/null)" ]]; then
            touch "$dir/.gitkeep"
        fi
    done
    
    print_color $GREEN "✅ Runtime directories created"
}

# Function to test installation
test_installation() {
    print_color $BLUE "🧪 Testing installation..."
    
    # Test universal launcher
    if [[ -f "docker-master" ]]; then
        if is_windows_env; then
            print_color $GREEN "✅ Universal launcher available (Windows mode)"
        else
            chmod +x docker-master
            print_color $GREEN "✅ Universal launcher available (Unix mode)"
        fi
    else
        print_color $RED "❌ Universal launcher not found"
        return 1
    fi
    
    # Test platform-specific scripts
    local os=$(detect_os)
    if is_windows_env; then
        if [[ -f "bin/start.bat" ]]; then
            print_color $GREEN "✅ Windows scripts available"
        else
            print_color $RED "❌ Windows scripts not found"
        fi
    else
        if [[ -f "bin/start.sh" ]]; then
            print_color $GREEN "✅ Unix scripts available"
        else
            print_color $RED "❌ Unix scripts not found"
        fi
    fi
    
    return 0
}

# Function to show next steps
show_next_steps() {
    local os=$(detect_os)
    
    print_color $CYAN "🎉 Setup completed successfully!"
    print_color $CYAN "================================================================"
    echo ""
    print_color $GREEN "✅ Docker Master Platform is ready for cross-platform development"
    echo ""
    print_color $PURPLE "🚀 Quick Start Commands:"
    
    if is_windows_env; then
        echo "  # Universal launcher (recommended):"
        echo "  ./docker-master start"
        echo "  ./docker-master create my-project"
        echo ""
        echo "  # Windows-specific:"
        echo "  bin\\start.bat"
        echo "  bin\\create.bat my-project"
    else
        echo "  # Universal launcher (recommended):"
        echo "  ./docker-master start"
        echo "  ./docker-master create my-project"
        echo ""
        echo "  # Platform-specific:"
        echo "  ./bin/start.sh"
        echo "  ./bin/create.sh my-project"
    fi
    
    echo ""
    print_color $PURPLE "📚 Documentation:"
    echo "  docs/user-guide/CROSS-PLATFORM-INSTALLATION.md"
    echo "  docs/user-guide/QUICK-REFERENCE.md"
    echo ""
    print_color $PURPLE "🔧 Configuration:"
    echo "  Edit .env file to customize settings"
    echo "  src/config/environments/ for Docker configurations"
    echo ""
    print_color $YELLOW "💡 Detected Platform: $os"
    if is_windows_env; then
        print_color $YELLOW "💡 Environment: Windows (Git Bash/WSL/PowerShell)"
    fi
}

# Main setup function
main() {
    print_color $CYAN "🐳 Docker Master Platform - Cross-Platform Setup"
    print_color $CYAN "================================================================"
    echo ""
    
    local os=$(detect_os)
    print_color $BLUE "🔍 Detected OS: $os"
    
    if is_windows_env; then
        print_color $BLUE "🔍 Environment: Windows (Git Bash/WSL)"
    fi
    
    echo ""
    
    # Check prerequisites
    if ! check_docker; then
        print_color $RED "❌ Setup failed: Docker requirements not met"
        exit 1
    fi
    
    echo ""
    
    # Setup steps
    setup_permissions
    setup_environment
    setup_directories
    
    echo ""
    
    # Test installation
    if ! test_installation; then
        print_color $RED "❌ Setup failed: Installation test failed"
        exit 1
    fi
    
    echo ""
    
    # Show next steps
    show_next_steps
}

# Run main function
main "$@"
