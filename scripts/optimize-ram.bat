@echo off
echo.
echo ========================================
echo   Docker Master Platform - RAM Optimizer
echo ========================================
echo.
echo Select RAM optimization profile:
echo.
echo 1. 🔥 LOW RAM (4GB)    - Only essential services (~1-2GB)
echo    - Laravel PHP 8.4 + PostgreSQL + Redis + Mailhog
echo.
echo 2. ⚡ OPTIMIZED (8GB)  - All services with limits (~2-3GB) 
echo    - All services with memory limits applied
echo.
echo 3. 🚀 DEFAULT (16GB+)  - Full configuration (~4-6GB)
echo    - All services without limits
echo.
echo 4. 📊 MONITOR          - Show current RAM usage
echo.
echo 5. ❌ EXIT
echo.
set /p choice="Enter your choice (1-5): "

if "%choice%"=="1" goto low_ram
if "%choice%"=="2" goto optimized
if "%choice%"=="3" goto default
if "%choice%"=="4" goto monitor
if "%choice%"=="5" goto exit
goto invalid

:low_ram
echo.
echo 🔥 Starting LOW RAM profile...
echo Stopping current containers...
docker-compose down
echo.
echo Starting essential services only...
docker-compose -f docker-compose.low-ram.yml up -d
echo.
echo ✅ LOW RAM profile started!
echo 📱 Access: http://localhost:8010 (Laravel PHP 8.4)
goto show_usage

:optimized
echo.
echo ⚡ Starting OPTIMIZED profile...
echo Stopping current containers...
docker-compose down
echo.
echo Starting all services with memory limits...
docker-compose -f docker-compose.yml -f docker-compose.override.yml up -d
echo.
echo ✅ OPTIMIZED profile started!
echo 📱 Laravel PHP 8.4: http://localhost:8010
echo 📱 Laravel PHP 7.4: http://localhost:8011
echo 📱 WordPress: http://localhost:8012
goto show_usage

:default
echo.
echo 🚀 Starting DEFAULT profile...
echo Stopping current containers...
docker-compose down
echo.
echo Starting all services without limits...
docker-compose up -d
echo.
echo ✅ DEFAULT profile started!
echo 📱 Laravel PHP 8.4: http://localhost:8010
echo 📱 Laravel PHP 7.4: http://localhost:8011
echo 📱 WordPress: http://localhost:8012
echo 📱 phpMyAdmin: http://localhost:8080
echo 📱 pgAdmin: http://localhost:8081
goto show_usage

:monitor
echo.
echo 📊 Current Docker RAM Usage:
echo ================================
docker stats --format "table {{.Container}}\t{{.MemUsage}}\t{{.MemPerc}}" --no-stream
echo.
echo 💾 Docker System Usage:
docker system df
echo.
pause
goto start

:show_usage
echo.
echo 📊 Checking RAM usage...
timeout /t 3 /nobreak >nul
docker stats --format "table {{.Container}}\t{{.MemUsage}}\t{{.MemPerc}}" --no-stream
echo.
echo 💡 Tips:
echo - Use 'docker stats' to monitor real-time usage
echo - Run this script again to switch profiles
echo - Check docs/07-RAM-OPTIMIZATION.md for details
echo.
pause
goto exit

:invalid
echo.
echo ❌ Invalid choice. Please enter 1-5.
echo.
pause
goto start

:start
cls
goto :eof

:exit
echo.
echo 👋 Goodbye!
exit /b 0
