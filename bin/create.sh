#!/bin/bash
# Docker Master Platform - Create Platform Script (Linux/macOS)
# Auto-detection and platform creation with AI features

set -e

echo "🤖 Docker Master Platform - AI Auto-Detection Platform Creator"
echo "================================================================"
echo ""
echo "✨ Features:"
echo "   • AI-powered platform type detection"
echo "   • Auto database selection (MySQL/PostgreSQL)"
echo "   • Auto PHP version assignment (7.4/8.4)"
echo "   • Auto port management with conflict detection"
echo "   • Auto Nginx setup and fast restart"
echo "   • Auto database creation with permissions"
echo "   • Auto container startup and testing"
echo ""

# Check if platform name provided
if [ -z "$1" ]; then
    echo "❌ Error: Platform name is required"
    echo ""
    echo "Usage: ./create.sh [platform-name]"
    echo ""
    echo "Examples:"
    echo "  ./create.sh my-blog           # → WordPress + MySQL + PHP 7.4"
    echo "  ./create.sh user-api          # → Laravel + PostgreSQL + PHP 8.4"
    echo "  ./create.sh online-shop       # → Laravel + MySQL + PHP 8.4"
    echo ""
    exit 1
fi

# Call the auto-platform script
echo "🚀 Starting platform creation..."
./app/scripts/platform/auto-platform.sh "$1"

echo ""
echo "🎉 PLATFORM CREATED WITH AUTO FEATURES!"
echo "================================================================"
echo ""
echo "🌐 Your platform is ready at:"
echo "   http://localhost:[auto-assigned-port]"
echo ""
echo "💡 Next steps:"
echo "   • Check platform status: ./status.sh"
echo "   • View logs: ./docker-compose.sh logs"
echo "   • Open all platforms: ./open-all.sh"
echo ""
echo "🚀 Happy coding!"
