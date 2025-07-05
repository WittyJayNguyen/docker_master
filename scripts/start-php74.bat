@echo off
REM Docker Master Platform - Start PHP 7.4 Services
REM Khởi động các services PHP 7.4 (Laravel + WordPress)

setlocal enabledelayedexpansion

echo.
echo ========================================
echo   Docker Master - Start PHP 7.4
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
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
echo.

echo 🛠️  PHP 7.4 Services Options:
echo ================================================================
echo [1] Start Laravel PHP 7.4 only (Port 8020)
echo [2] Start WordPress PHP 7.4 only (Port 8030)  
echo [3] Start Both Laravel + WordPress PHP 7.4
echo [4] Start Full Low-RAM Configuration (All services)
echo [5] Show PHP 7.4 Status
echo [0] Exit
echo.

set /p choice="Choose option (0-5): "

if "%choice%"=="0" goto :end
if "%choice%"=="1" goto :start_laravel74
if "%choice%"=="2" goto :start_wordpress74
if "%choice%"=="3" goto :start_both74
if "%choice%"=="4" goto :start_full_lowram
if "%choice%"=="5" goto :show_status

echo ❌ Invalid choice!
goto :end

:start_laravel74
echo.
echo 🚀 Starting Laravel PHP 7.4...
echo ================================================================

echo 🛑 Stopping conflicting services...
docker stop laravel_php74_low_ram 2>nul
docker rm laravel_php74_low_ram 2>nul

echo 🚀 Starting PostgreSQL (if not running)...
docker-compose -f docker-compose.low-ram.yml up -d postgres redis

echo 🚀 Starting Laravel PHP 7.4...
docker-compose -f docker-compose.low-ram.yml up -d laravel-php74

goto :show_results

:start_wordpress74
echo.
echo 🚀 Starting WordPress PHP 7.4...
echo ================================================================

echo 🛑 Stopping conflicting services...
docker stop wordpress_php74_low_ram 2>nul
docker rm wordpress_php74_low_ram 2>nul

echo 🚀 Starting MySQL (if not running)...
docker-compose -f docker-compose.low-ram.yml up -d mysql_low_ram

echo 🚀 Starting WordPress PHP 7.4...
docker-compose -f docker-compose.low-ram.yml up -d wordpress-php74

goto :show_results

:start_both74
echo.
echo 🚀 Starting Both Laravel + WordPress PHP 7.4...
echo ================================================================

echo 🚀 Starting databases...
docker-compose -f docker-compose.low-ram.yml up -d postgres redis mysql_low_ram

echo 🚀 Starting PHP 7.4 services...
docker-compose -f docker-compose.low-ram.yml up -d laravel-php74 wordpress-php74

goto :show_results

:start_full_lowram
echo.
echo 🚀 Starting Full Low-RAM Configuration...
echo ================================================================

echo 🚀 Starting all optimized services...
docker-compose -f docker-compose.low-ram.yml up -d

goto :show_results

:show_status
echo.
echo 📊 PHP 7.4 Services Status:
echo ================================================================

echo 📦 PHP 7.4 Containers:
docker ps --filter "name=php74" --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"

echo.
echo 💾 Memory Usage:
docker stats --no-stream --format "table {{.Container}}\t{{.MemUsage}}\t{{.MemPerc}}" | findstr php74

echo.
echo 🌐 Available PHP 7.4 Services:
if docker ps --filter "name=laravel_php74_low_ram" --filter "status=running" -q >nul 2>&1 (
    echo ✅ Laravel PHP 7.4: http://localhost:8020
) else (
    echo ❌ Laravel PHP 7.4: Not running
)

if docker ps --filter "name=wordpress_php74_low_ram" --filter "status=running" -q >nul 2>&1 (
    echo ✅ WordPress PHP 7.4: http://localhost:8030
) else (
    echo ❌ WordPress PHP 7.4: Not running
)

goto :end

:show_results
echo.
echo ✅ PHP 7.4 Services Started!
echo ================================================================

echo 📦 Running Services:
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"

echo.
echo 💾 Memory Usage:
docker stats --no-stream --format "table {{.Container}}\t{{.MemUsage}}\t{{.MemPerc}}" 2>nul

echo.
echo 🌐 Available Services:
echo ================================================================
if docker ps --filter "name=laravel_php84_low_ram" --filter "status=running" -q >nul 2>&1 (
    echo ✅ Laravel PHP 8.4: http://localhost:8010
)
if docker ps --filter "name=laravel_php74_low_ram" --filter "status=running" -q >nul 2>&1 (
    echo ✅ Laravel PHP 7.4: http://localhost:8020
)
if docker ps --filter "name=wordpress_php74_low_ram" --filter "status=running" -q >nul 2>&1 (
    echo ✅ WordPress PHP 7.4: http://localhost:8030
)
if docker ps --filter "name=postgres_low_ram" --filter "status=running" -q >nul 2>&1 (
    echo ✅ PostgreSQL: localhost:5432
)
if docker ps --filter "name=mysql_low_ram" --filter "status=running" -q >nul 2>&1 (
    echo ✅ MySQL: localhost:3306
)
if docker ps --filter "name=redis_low_ram" --filter "status=running" -q >nul 2>&1 (
    echo ✅ Redis: localhost:6379
)
if docker ps --filter "name=mailhog_low_ram" --filter "status=running" -q >nul 2>&1 (
    echo ✅ Mailhog: http://localhost:8025
)

echo.
echo 🔧 Management Commands:
echo ================================================================
echo • View logs: docker-compose -f docker-compose.low-ram.yml logs [service]
echo • Stop all: docker-compose -f docker-compose.low-ram.yml down
echo • Restart: docker-compose -f docker-compose.low-ram.yml restart [service]
echo • Monitor: docker stats
echo.

echo 💡 Port Mapping:
echo    • Laravel PHP 8.4: :8010
echo    • Laravel PHP 7.4: :8020  
echo    • WordPress PHP 7.4: :8030
echo    • PostgreSQL: :5432
echo    • MySQL: :3306
echo    • Redis: :6379
echo    • Mailhog: :8025
echo.

:end
echo.
echo Press any key to exit...
pause >nul
