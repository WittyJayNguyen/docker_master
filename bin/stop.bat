@echo off
REM ========================================
REM   Docker Master Platform - STOP ALL
REM   Dừng tất cả services
REM ========================================

echo.
echo ========================================
echo   🛑 STOP ALL - Docker Master Platform
echo ========================================
echo.

echo 🛑 Stopping all Docker Master Platform services...
echo.

REM Stop monitoring first
echo 📊 Stopping auto-monitoring...
docker-compose -f config/docker-compose.monitoring.yml down
echo ✅ Auto-monitoring stopped
echo.

REM Stop main services
echo 🚀 Stopping main services...
docker-compose down
echo ✅ Main services stopped
echo.

REM Show remaining containers
echo 📋 Remaining containers:
docker ps --format "table {{.Names}}\t{{.Status}}"
echo.

REM Clean up networks
echo 🌐 Cleaning up networks...
docker network prune -f >nul 2>&1
echo ✅ Networks cleaned
echo.

echo 🎉 All Docker Master Platform services stopped!
echo.
echo 💡 To start again, run: start.bat
echo.
pause
