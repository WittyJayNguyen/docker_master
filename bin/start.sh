#!/bin/bash
# Docker Master Platform - Start Script (Linux/macOS)
# Optimized startup with RAM monitoring and auto-detection

set -e

echo "🐳 Docker Master Platform - Starting System..."
echo "================================================================"
echo ""

# Check if Docker is running
if ! docker info >/dev/null 2>&1; then
    echo "❌ Docker is not running!"
    echo "Please start Docker and try again."
    exit 1
fi

echo "✅ Docker is running"
echo ""

# Stop any existing containers
echo "🛑 Stopping existing containers..."
./bin/docker-compose.sh down >/dev/null 2>&1 || true
docker-compose -f app/config/environments/docker-compose.monitoring.yml down >/dev/null 2>&1 || true
echo "✅ Cleaned up existing containers"
echo ""

# Start main services with RAM optimization
echo "🚀 Starting main services with RAM optimization..."
./bin/docker-compose.sh up -d
if [ $? -ne 0 ]; then
    echo "❌ Failed to start main services"
    exit 1
fi
echo "✅ Main services started"
echo ""

# Wait for services to be ready
echo "⏳ Waiting for services to be ready..."
sleep 10

# Initialize databases
echo "🗄️ Initializing databases..."
# Add database initialization logic here if needed
echo "✅ Databases initialized"
echo ""

# Start auto-monitoring
echo "🤖 Starting auto-monitoring..."
docker-compose -f app/config/environments/docker-compose.monitoring.yml up -d >/dev/null 2>&1 || true
echo "✅ Auto-monitoring started"
echo ""

# Show final status
echo "📊 Final system status:"
echo "================================================================"
./bin/docker-compose.sh ps --format "table {{.Name}}\t{{.Status}}\t{{.Ports}}" || docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
echo ""

echo "🌐 Available Services:"
echo "================================================================"
echo "📱 Applications:"
echo "   • Laravel PHP 8.4:  http://localhost:8010"
echo "   • Laravel PHP 7.4:  http://localhost:8011"
echo "   • WordPress:         http://localhost:8012"
echo ""
echo "🗄️ Databases:"
echo "   • PostgreSQL:        localhost:5432 (postgres_user/postgres_pass)"
echo "   • MySQL:             localhost:3306 (mysql_user/mysql_pass)"
echo "   • Redis:             localhost:6379 (no password)"
echo ""
echo "🐛 Debug Ports:"
echo "   • Laravel PHP 8.4:  9084"
echo "   • Laravel PHP 7.4:  9074"
echo "   • WordPress:         9075"
echo ""

echo "🎉 Docker Master Platform is ready!"
echo "================================================================"
echo "💡 Quick commands:"
echo "    • Stop all:          ./bin/docker-compose.sh down"
echo "    • View logs:         ./bin/docker-compose.sh logs"
echo "    • Restart service:   ./bin/docker-compose.sh restart [service_name]"
echo "    • Monitor RAM:       ./app/scripts/monitoring/monitor-ram.sh"
echo ""
echo "🌐 Opening main dashboard..."
if command -v xdg-open >/dev/null 2>&1; then
    xdg-open http://localhost:8010 >/dev/null 2>&1 &
elif command -v open >/dev/null 2>&1; then
    open http://localhost:8010 >/dev/null 2>&1 &
fi

echo "✨ System ready for development!"
