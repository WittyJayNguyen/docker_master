#!/bin/bash
# Docker Master Platform - Platform Detection Script
# Auto-detect OS and run appropriate scripts

set -e

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

# Function to check if running on Windows (Git Bash, WSL, etc.)
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

# Function to run appropriate script
run_script() {
    local script_name="$1"
    shift
    local args="$@"
    
    if is_windows_env; then
        # Windows environment - use .bat files
        if [[ -f "bin/${script_name}.bat" ]]; then
            echo "🖥️ Detected Windows environment - using .bat script"
            cmd.exe /c "bin\\${script_name}.bat $args"
        else
            echo "❌ Windows script not found: bin/${script_name}.bat"
            exit 1
        fi
    else
        # Unix environment - use .sh files
        local os=$(detect_os)
        echo "🐧 Detected $os environment - using .sh script"
        
        if [[ -f "bin/${script_name}.sh" ]]; then
            chmod +x "bin/${script_name}.sh"
            "./bin/${script_name}.sh" $args
        else
            echo "❌ Unix script not found: bin/${script_name}.sh"
            exit 1
        fi
    fi
}

# Main function
main() {
    echo "🔍 Docker Master Platform - Auto Platform Detection"
    echo "================================================================"
    
    if [[ $# -eq 0 ]]; then
        echo "Usage: $0 [script-name] [args...]"
        echo ""
        echo "Available scripts:"
        echo "  start           - Start the platform"
        echo "  stop            - Stop the platform"
        echo "  restart         - Restart the platform"
        echo "  status          - Show system status"
        echo "  create [name]   - Create new platform"
        echo "  docker-compose  - Docker compose wrapper"
        echo ""
        echo "Examples:"
        echo "  $0 start"
        echo "  $0 create my-project"
        echo "  $0 docker-compose ps"
        exit 0
    fi
    
    local script_name="$1"
    shift
    
    run_script "$script_name" "$@"
}

# Run main function with all arguments
main "$@"
