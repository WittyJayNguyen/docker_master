@echo off
REM Docker Master Platform - Docker Optimization Script
REM Tối ưu hóa Docker để tiết kiệm RAM và disk space

setlocal enabledelayedexpansion

echo.
echo ========================================
echo   Docker Master - Optimization Tool
echo ========================================
echo.

REM Kiểm tra Docker
docker version >nul 2>&1
if errorlevel 1 (
    echo ❌ Docker is not running! Please start Docker first.
    pause
    exit /b 1
)

echo 🔍 Current Docker Resource Usage:
echo ================================================================
docker system df
echo.

echo 📊 Memory Usage by Containers:
docker stats --no-stream --format "table {{.Container}}\t{{.CPUPerc}}\t{{.MemUsage}}\t{{.MemPerc}}" 2>nul
echo.

echo 🛠️  Optimization Options:
echo ================================================================
echo [1] Switch to Low-RAM Mode (Recommended for 4GB RAM or less)
echo [2] Combine Multiple Services (Single optimized container)
echo [3] Clean + Rebuild with Optimization
echo [4] Configure Docker Desktop Settings
echo [5] Show Optimization Tips
echo [0] Exit
echo.

set /p choice="Choose option (0-5): "

if "%choice%"=="0" goto :end
if "%choice%"=="1" goto :low_ram_mode
if "%choice%"=="2" goto :combine_services
if "%choice%"=="3" goto :clean_rebuild
if "%choice%"=="4" goto :docker_settings
if "%choice%"=="5" goto :optimization_tips

echo ❌ Invalid choice!
goto :end

:low_ram_mode
echo.
echo 🚀 Switching to Low-RAM Mode...
echo ================================================================

echo 🛑 Stopping current services...
docker-compose down

echo 🧹 Cleaning up unused resources...
docker system prune -f

echo 🚀 Starting with low-RAM configuration...
docker-compose -f docker-compose.low-ram.yml up -d

echo.
echo ✅ Low-RAM mode activated!
echo 📊 Services running:
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"

echo.
echo 💡 Low-RAM Mode Features:
echo    • PostgreSQL with 128MB limit
echo    • Redis with 32MB limit  
echo    • Single PHP 8.4 container (128MB limit)
echo    • Mailhog with 32MB limit
echo    • Total RAM usage: ~320MB
echo.
goto :end

:combine_services
echo.
echo 🔧 Creating Combined Services Container...
echo ================================================================

echo ⚠️  This will create a single container with multiple services
echo    (PHP + PostgreSQL + Redis + Apache)
echo.
set /p confirm="Continue? (y/N): "
if /i not "%confirm%"=="y" goto :end

echo 🛑 Stopping current services...
docker-compose down

echo 🏗️  Building combined container...
REM Tạo Dockerfile tối ưu
echo Creating optimized Dockerfile...

(
echo FROM php:8.4-apache
echo.
echo # Install system dependencies
echo RUN apt-get update ^&^& apt-get install -y \
echo     postgresql-15 \
echo     redis-server \
echo     supervisor \
echo     ^&^& rm -rf /var/lib/apt/lists/*
echo.
echo # Configure services
echo COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
echo.
echo # Optimize for low memory
echo RUN echo "memory_limit = 64M" ^>^> /usr/local/etc/php/php.ini
echo RUN echo "max_memory = 32MB" ^>^> /etc/redis/redis.conf
echo.
echo EXPOSE 80 5432 6379
echo CMD ["/usr/bin/supervisord"]
) > docker\combined\Dockerfile

echo 📦 Building combined image...
docker build -t docker-master-combined docker\combined\

echo 🚀 Starting combined container...
docker run -d --name combined-services \
    -p 8080:80 \
    -p 5432:5432 \
    -p 6379:6379 \
    -v "%cd%\projects:/var/www/html" \
    --memory=256m \
    docker-master-combined

echo ✅ Combined services container started!
goto :end

:clean_rebuild
echo.
echo 🧹 Clean Rebuild with Optimization...
echo ================================================================

echo ⚠️  This will remove all containers and rebuild optimized versions
set /p confirm="Continue? (y/N): "
if /i not "%confirm%"=="y" goto :end

echo 🛑 Stopping all services...
docker-compose down

echo 🧹 Removing old containers and images...
docker container prune -f
docker image prune -a -f

echo 🏗️  Rebuilding with optimization flags...
docker-compose -f docker-compose.low-ram.yml build --no-cache

echo 🚀 Starting optimized services...
docker-compose -f docker-compose.low-ram.yml up -d

echo ✅ Clean rebuild completed!
goto :end

:docker_settings
echo.
echo ⚙️  Docker Desktop Settings Recommendations:
echo ================================================================
echo.
echo 💾 Memory Settings:
echo    • Memory: 2GB (minimum) / 4GB (recommended)
echo    • Swap: 1GB
echo    • Disk image size: 20GB (minimum)
echo.
echo 🔧 Advanced Settings:
echo    • Enable experimental features: OFF
echo    • Use containerd for pulling images: ON
echo    • Send usage statistics: OFF
echo.
echo 📁 File Sharing:
echo    • Only share necessary directories
echo    • Current project: %cd%
echo.
echo 🌐 Network Settings:
echo    • Use default bridge network
echo    • Avoid custom networks if possible
echo.
echo 💡 To apply these settings:
echo    1. Open Docker Desktop
echo    2. Go to Settings ^> Resources
echo    3. Adjust Memory and Swap
echo    4. Go to Advanced and configure as above
echo    5. Click "Apply ^& Restart"
echo.
goto :end

:optimization_tips
echo.
echo 💡 Docker Optimization Tips:
echo ================================================================
echo.
echo 🚀 Performance Tips:
echo    • Use Alpine Linux images when possible
echo    • Combine RUN commands in Dockerfiles
echo    • Use multi-stage builds
echo    • Set memory limits for all containers
echo    • Use .dockerignore files
echo.
echo 💾 Memory Optimization:
echo    • Limit container memory usage
echo    • Use shared volumes instead of copying data
echo    • Stop unused containers regularly
echo    • Use docker system prune weekly
echo.
echo 🗄️  Storage Optimization:
echo    • Remove unused images: docker image prune -a
echo    • Remove unused volumes: docker volume prune
echo    • Use bind mounts instead of volumes when possible
echo    • Clean build cache: docker builder prune
echo.
echo 🔧 Configuration Tips:
echo    • Use docker-compose.low-ram.yml for development
echo    • Set restart policies to "unless-stopped"
echo    • Use healthchecks to monitor container status
echo    • Group related services in same compose file
echo.
echo 📊 Monitoring:
echo    • Use: docker stats (real-time monitoring)
echo    • Use: docker system df (disk usage)
echo    • Use: docker system events (system events)
echo.

:end
echo.
echo Press any key to exit...
pause >nul
