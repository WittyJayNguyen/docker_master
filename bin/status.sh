#!/bin/bash
# Docker Master Platform - Status Script (Linux/macOS)
# Show comprehensive system status

set -e

echo "📊 Docker Master Platform - System Status"
echo "================================================================"
echo ""

# Check Docker status
if ! docker info >/dev/null 2>&1; then
    echo "❌ Docker is not running!"
    exit 1
fi

echo "✅ Docker is running"
echo ""

# Show container status
echo "🐳 Container Status:"
echo "================================================================"
RUNNING_CONTAINERS=$(docker ps -q)
if [ -z "$RUNNING_CONTAINERS" ]; then
    echo "⚠️ No containers are running"
    echo ""
    echo "💡 To start the system:"
    echo "    ./bin/start.sh"
else
    docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
fi
echo ""

# Show service URLs
echo "🌐 Service URLs:"
echo "================================================================"
if docker ps --format "{{.Names}}" | grep -q "laravel_php84"; then
    echo "✅ Laravel PHP 8.4:  http://localhost:8010"
else
    echo "❌ Laravel PHP 8.4:  Not running"
fi

if docker ps --format "{{.Names}}" | grep -q "laravel_php74"; then
    echo "✅ Laravel PHP 7.4:  http://localhost:8011"
else
    echo "❌ Laravel PHP 7.4:  Not running"
fi

if docker ps --format "{{.Names}}" | grep -q "wordpress"; then
    echo "✅ WordPress:         http://localhost:8012"
else
    echo "❌ WordPress:         Not running"
fi
echo ""

# Show database status
echo "🗄️ Database Status:"
echo "================================================================"
if docker ps --format "{{.Names}}" | grep -q "postgres"; then
    echo "✅ PostgreSQL:        localhost:5432"
else
    echo "❌ PostgreSQL:        Not running"
fi

if docker ps --format "{{.Names}}" | grep -q "mysql"; then
    echo "✅ MySQL:             localhost:3306"
else
    echo "❌ MySQL:             Not running"
fi

if docker ps --format "{{.Names}}" | grep -q "redis"; then
    echo "✅ Redis:             localhost:6379"
else
    echo "❌ Redis:             Not running"
fi
echo ""

# Show resource usage
echo "💾 Resource Usage:"
echo "================================================================"
if command -v docker >/dev/null 2>&1; then
    docker stats --no-stream --format "table {{.Name}}\t{{.CPUPerc}}\t{{.MemUsage}}" 2>/dev/null || echo "Unable to get resource stats"
fi
echo ""

# Show disk usage
echo "💿 Disk Usage:"
echo "================================================================"
if command -v du >/dev/null 2>&1; then
    echo "Runtime data: $(du -sh runtime/ 2>/dev/null | cut -f1 || echo 'Unknown')"
    echo "Docker data:  $(docker system df --format 'table {{.Type}}\t{{.Size}}' 2>/dev/null | tail -n +2 | head -1 | awk '{print $2}' || echo 'Unknown')"
fi
echo ""

echo "💡 Quick commands:"
echo "    • Start system:      ./bin/start.sh"
echo "    • Stop system:       ./bin/stop.sh"
echo "    • View logs:         ./bin/docker-compose.sh logs"
echo "    • Create platform:   ./bin/create.sh [name]"
echo ""
