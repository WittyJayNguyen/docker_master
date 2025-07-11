#!/bin/bash
# Docker Master Platform - Stop Script (Linux/macOS)
# Graceful shutdown of all services

set -e

echo "🛑 Docker Master Platform - Stopping System..."
echo "================================================================"
echo ""

# Stop main services
echo "🔄 Stopping main services..."
./bin/docker-compose.sh down
echo "✅ Main services stopped"
echo ""

# Stop monitoring services
echo "🔄 Stopping monitoring services..."
docker-compose -f src/config/environments/docker-compose.monitoring.yml down >/dev/null 2>&1 || true
echo "✅ Monitoring services stopped"
echo ""

# Show final status
echo "📊 Final status:"
echo "================================================================"
RUNNING_CONTAINERS=$(docker ps -q)
if [ -z "$RUNNING_CONTAINERS" ]; then
    echo "✅ All containers stopped successfully"
else
    echo "⚠️ Some containers are still running:"
    docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
fi

echo ""
echo "🎉 Docker Master Platform stopped!"
echo "================================================================"
echo "💡 To start again:"
echo "    ./bin/start.sh"
echo ""
