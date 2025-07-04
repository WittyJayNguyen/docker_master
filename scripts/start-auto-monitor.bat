@echo off
echo.
echo 🚀 Starting Docker Master Auto-Monitor...
echo.

REM Check if monitoring is already running
docker ps | findstr "docker_master_ram_monitor" >nul
if %errorlevel%==0 (
    echo ⚠️ Auto-monitoring is already running!
    echo 🌐 Dashboard: http://localhost:8090
    echo.
    goto show_status
)

echo 📊 Starting monitoring services...
docker-compose -f docker-compose.monitoring.yml up -d

echo.
echo ✅ Auto-monitoring started successfully!
echo.
echo 📊 Features enabled:
echo    - RAM usage monitoring every 30 seconds
echo    - High RAM usage alerts (>90%%)
echo    - Container statistics logging
echo    - Web dashboard interface
echo.
echo 🌐 Access dashboard: http://localhost:8090
echo 📁 Logs location: logs/
echo.

:show_status
echo 📋 Current monitoring status:
docker-compose -f docker-compose.monitoring.yml ps

echo.
echo 💡 Management commands:
echo    - Stop: docker-compose -f docker-compose.monitoring.yml down
echo    - Restart: docker-compose -f docker-compose.monitoring.yml restart
echo    - View logs: docker-compose -f docker-compose.monitoring.yml logs
echo.

REM Open dashboard in browser
echo 🌐 Opening dashboard in browser...
start http://localhost:8090

echo.
echo ✅ Auto-monitoring is now active!
echo    Monitor will run in background and log all container activity.
echo.
