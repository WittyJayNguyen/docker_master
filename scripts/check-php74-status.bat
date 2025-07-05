@echo off
REM Docker Master Platform - Check PHP 7.4 Status
REM Kiểm tra trạng thái các services PHP 7.4

echo.
echo ========================================
echo   Docker Master - PHP 7.4 Status Check
echo ========================================
echo.

echo 📊 Current PHP 7.4 Services Status:
echo ================================================================

echo 🔍 All Running Containers:
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
echo.

echo 💾 Memory Usage:
docker stats --no-stream --format "table {{.Container}}\t{{.MemUsage}}\t{{.MemPerc}}" 2>nul
echo.

echo 🌐 Service Availability Check:
echo ================================================================

REM Check Laravel PHP 8.4
echo Checking Laravel PHP 8.4 (Port 8010)...
curl -s -o nul -w "%%{http_code}" http://localhost:8010 > temp_status.txt 2>nul
set /p status84=<temp_status.txt
if "%status84%"=="200" (
    echo ✅ Laravel PHP 8.4: http://localhost:8010 - WORKING
) else (
    echo ❌ Laravel PHP 8.4: http://localhost:8010 - NOT RESPONDING
)

REM Check WordPress PHP 7.4  
echo Checking WordPress PHP 7.4 (Port 8030)...
curl -s -o nul -w "%%{http_code}" http://localhost:8030 > temp_status.txt 2>nul
set /p status74=<temp_status.txt
if "%status74%"=="200" (
    echo ✅ WordPress PHP 7.4: http://localhost:8030 - WORKING
) else (
    echo ❌ WordPress PHP 7.4: http://localhost:8030 - NOT RESPONDING
)

REM Check Laravel PHP 7.4 (if running)
echo Checking Laravel PHP 7.4 (Port 8020)...
curl -s -o nul -w "%%{http_code}" http://localhost:8020 > temp_status.txt 2>nul
set /p status74l=<temp_status.txt
if "%status74l%"=="200" (
    echo ✅ Laravel PHP 7.4: http://localhost:8020 - WORKING
) else (
    echo ❌ Laravel PHP 7.4: http://localhost:8020 - NOT RESPONDING
)

REM Check PostgreSQL
echo Checking PostgreSQL (Port 5432)...
docker exec postgres_low_ram pg_isready -U postgres_user >nul 2>&1
if errorlevel 1 (
    echo ❌ PostgreSQL: localhost:5432 - NOT READY
) else (
    echo ✅ PostgreSQL: localhost:5432 - READY
)

REM Check Redis
echo Checking Redis (Port 6379)...
docker exec redis_low_ram redis-cli ping >nul 2>&1
if errorlevel 1 (
    echo ❌ Redis: localhost:6379 - NOT READY
) else (
    echo ✅ Redis: localhost:6379 - READY
)

REM Check MySQL
echo Checking MySQL (Port 3306)...
docker exec mysql_low_ram mysqladmin ping -u root -proot_pass >nul 2>&1
if errorlevel 1 (
    echo ❌ MySQL: localhost:3306 - NOT READY (This is OK if not needed)
) else (
    echo ✅ MySQL: localhost:3306 - READY
)

REM Check Mailhog
echo Checking Mailhog (Port 8025)...
curl -s -o nul -w "%%{http_code}" http://localhost:8025 > temp_status.txt 2>nul
set /p statusmail=<temp_status.txt
if "%statusmail%"=="200" (
    echo ✅ Mailhog: http://localhost:8025 - WORKING
) else (
    echo ❌ Mailhog: http://localhost:8025 - NOT RESPONDING
)

del temp_status.txt 2>nul

echo.
echo 📋 Summary:
echo ================================================================
echo 🎯 Working Services:
if "%status84%"=="200" echo    • Laravel PHP 8.4: http://localhost:8010
if "%status74%"=="200" echo    • WordPress PHP 7.4: http://localhost:8030  
if "%status74l%"=="200" echo    • Laravel PHP 7.4: http://localhost:8020
if "%statusmail%"=="200" echo    • Mailhog: http://localhost:8025

echo.
echo 💾 Total RAM Usage: 
for /f "tokens=2" %%i in ('docker stats --no-stream --format "{{.MemUsage}}" ^| findstr /v "MEM"') do (
    echo    • Container RAM: %%i
)

echo.
echo 🔧 Quick Actions:
echo    • Open Laravel 8.4: start http://localhost:8010
echo    • Open WordPress 7.4: start http://localhost:8030
echo    • Open Mailhog: start http://localhost:8025
echo    • View logs: docker-compose -f docker-compose.low-ram.yml logs
echo    • Restart all: docker-compose -f docker-compose.low-ram.yml restart
echo.

pause
