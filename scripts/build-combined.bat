@echo off
REM Docker Master Platform - Build Combined Container
REM Tạo và chạy container tối ưu gom tất cả services

setlocal enabledelayedexpansion

echo.
echo ========================================
echo   Docker Master - Build Combined
echo ========================================
echo.

REM Kiểm tra Docker
docker version >nul 2>&1
if errorlevel 1 (
    echo ❌ Docker is not running! Please start Docker first.
    pause
    exit /b 1
)

echo 🔍 Current Docker Status:
docker system df
echo.

echo 🛠️  Build Options:
echo ================================================================
echo [1] Build and Start Combined Container (Recommended)
echo [2] Rebuild from Scratch (Clean build)
echo [3] Start Existing Combined Container
echo [4] Stop Combined Container
echo [5] Show Combined Container Status
echo [0] Exit
echo.

set /p choice="Choose option (0-5): "

if "%choice%"=="0" goto :end
if "%choice%"=="1" goto :build_start
if "%choice%"=="2" goto :rebuild
if "%choice%"=="3" goto :start_existing
if "%choice%"=="4" goto :stop_container
if "%choice%"=="5" goto :show_status

echo ❌ Invalid choice!
goto :end

:build_start
echo.
echo 🏗️  Building and Starting Combined Container...
echo ================================================================

echo 🛑 Stopping existing services...
docker-compose down >nul 2>&1

echo 🧹 Cleaning up...
docker container prune -f >nul 2>&1

echo 🏗️  Building combined image...
docker-compose -f docker-compose.combined.yml build

if errorlevel 1 (
    echo ❌ Build failed! Check the error messages above.
    pause
    goto :end
)

echo 🚀 Starting combined services...
docker-compose -f docker-compose.combined.yml up -d

if errorlevel 1 (
    echo ❌ Failed to start services! Check the error messages above.
    pause
    goto :end
)

goto :show_success

:rebuild
echo.
echo 🔄 Rebuilding from Scratch...
echo ================================================================

echo ⚠️  This will remove existing containers and rebuild everything
set /p confirm="Continue? (y/N): "
if /i not "%confirm%"=="y" goto :end

echo 🛑 Stopping all services...
docker-compose down >nul 2>&1
docker-compose -f docker-compose.combined.yml down >nul 2>&1

echo 🧹 Removing old containers and images...
docker container prune -f >nul 2>&1
docker image prune -a -f >nul 2>&1

echo 🏗️  Building fresh combined image...
docker-compose -f docker-compose.combined.yml build --no-cache

echo 🚀 Starting fresh services...
docker-compose -f docker-compose.combined.yml up -d

goto :show_success

:start_existing
echo.
echo 🚀 Starting Existing Combined Container...
echo ================================================================

docker-compose -f docker-compose.combined.yml up -d

if errorlevel 1 (
    echo ❌ Failed to start! Container may not exist. Try option 1 to build first.
    pause
    goto :end
)

goto :show_success

:stop_container
echo.
echo 🛑 Stopping Combined Container...
echo ================================================================

docker-compose -f docker-compose.combined.yml down

echo ✅ Combined container stopped!
goto :end

:show_status
echo.
echo 📊 Combined Container Status:
echo ================================================================

echo 📦 Containers:
docker ps -a --filter "name=docker_master_combined" --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"

echo.
echo 💾 Resource Usage:
docker stats --no-stream --format "table {{.Container}}\t{{.CPUPerc}}\t{{.MemUsage}}\t{{.MemPerc}}" docker_master_combined 2>nul

echo.
echo 🖼️  Images:
docker images --filter "reference=*combined*" --format "table {{.Repository}}\t{{.Tag}}\t{{.Size}}"

echo.
echo 📋 Logs (last 10 lines):
docker logs --tail 10 docker_master_combined 2>nul

goto :end

:show_success
echo.
echo ✅ Combined Container Successfully Started!
echo ================================================================

echo 📦 Running Services:
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"

echo.
echo 💾 Memory Usage:
docker stats --no-stream --format "table {{.Container}}\t{{.MemUsage}}\t{{.MemPerc}}" 2>nul

echo.
echo 🌐 Available Services:
echo ================================================================
echo ✅ PHP 8.4 + Apache:    http://localhost:8080
echo ✅ PostgreSQL:          localhost:5432
echo ✅ Redis:               localhost:6379
echo ✅ Mailhog SMTP:        localhost:1025
echo ✅ Mailhog Web UI:      http://localhost:8025
echo.

echo 🔑 Database Connection:
echo    Host: localhost
echo    Port: 5432
echo    Database: docker_master
echo    Username: postgres_user
echo    Password: postgres_pass
echo.

echo 💡 Benefits of Combined Container:
echo    • Single container instead of 4+ containers
echo    • RAM usage: ~200MB (vs 500MB+ separate)
echo    • Faster startup time
echo    • Simplified management
echo    • Less network overhead
echo.

echo 🔧 Management Commands:
echo    • View logs: docker logs docker_master_combined
echo    • Enter container: docker exec -it docker_master_combined bash
echo    • Restart: docker restart docker_master_combined
echo.

:end
echo.
echo Press any key to exit...
pause >nul
