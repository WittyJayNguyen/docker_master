#!/bin/bash
# Docker Master Platform - Restart Script (Linux/macOS)
# Fast restart for development

set -e

echo "🔄 Docker Master Platform - Restarting System..."
echo "================================================================"
echo ""

# Check if specific service provided
if [ -n "$1" ]; then
    echo "🔄 Restarting specific service: $1"
    ./bin/docker-compose.sh restart "$1"
    echo "✅ Service $1 restarted"
else
    echo "🔄 Restarting all services..."
    
    # Stop services
    echo "🛑 Stopping services..."
    ./bin/stop.sh
    
    echo ""
    echo "⏳ Waiting 3 seconds..."
    sleep 3
    
    # Start services
    echo "🚀 Starting services..."
    ./bin/start.sh
fi

echo ""
echo "🎉 Restart completed!"
echo "================================================================"
