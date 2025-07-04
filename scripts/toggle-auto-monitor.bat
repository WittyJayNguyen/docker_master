@echo off
echo.
echo ========================================
echo   Docker Master Platform - Auto Monitor
echo ========================================
echo.

REM Check if monitoring is currently running
docker ps | findstr "docker_master_ram_monitor" >nul
if %errorlevel%==0 (
    set monitor_status=RUNNING
) else (
    set monitor_status=STOPPED
)

echo Current Status: %monitor_status%
echo.

if "%monitor_status%"=="RUNNING" (
    echo 🔴 Auto-monitoring is currently RUNNING
    echo.
    echo Options:
    echo 1. Stop auto-monitoring
    echo 2. View monitoring dashboard ^(http://localhost:8090^)
    echo 3. View current logs
    echo 4. Restart monitoring
    echo 5. Exit
    echo.
    set /p choice="Enter choice (1-5): "
    
    if "!choice!"=="1" goto stop_monitoring
    if "!choice!"=="2" goto open_dashboard
    if "!choice!"=="3" goto view_logs
    if "!choice!"=="4" goto restart_monitoring
    if "!choice!"=="5" goto exit
    
) else (
    echo 🟢 Auto-monitoring is currently STOPPED
    echo.
    echo Options:
    echo 1. Start auto-monitoring
    echo 2. Start with dashboard ^(recommended^)
    echo 3. View old logs
    echo 4. Exit
    echo.
    set /p choice="Enter choice (1-4): "
    
    if "!choice!"=="1" goto start_monitoring
    if "!choice!"=="2" goto start_with_dashboard
    if "!choice!"=="3" goto view_logs
    if "!choice!"=="4" goto exit
)

goto invalid_choice

:start_monitoring
echo.
echo 🚀 Starting auto-monitoring...
docker-compose -f docker-compose.monitoring.yml up -d ram-monitor
echo.
echo ✅ Auto-monitoring started!
echo 📊 Monitor will check containers every 30 seconds
echo 📁 Logs will be saved to: logs/
goto show_status

:start_with_dashboard
echo.
echo 🚀 Starting auto-monitoring with web dashboard...
docker-compose -f docker-compose.monitoring.yml up -d
echo.
echo ✅ Auto-monitoring and dashboard started!
echo 📊 Monitor: Running in background
echo 🌐 Dashboard: http://localhost:8090
echo 📁 Logs: logs/
echo.
echo Opening dashboard in browser...
start http://localhost:8090
goto show_status

:stop_monitoring
echo.
echo 🛑 Stopping auto-monitoring...
docker-compose -f docker-compose.monitoring.yml down
echo.
echo ✅ Auto-monitoring stopped!
goto show_status

:restart_monitoring
echo.
echo 🔄 Restarting auto-monitoring...
docker-compose -f docker-compose.monitoring.yml restart
echo.
echo ✅ Auto-monitoring restarted!
goto show_status

:open_dashboard
echo.
echo 🌐 Opening monitoring dashboard...
start http://localhost:8090
goto show_status

:view_logs
echo.
echo 📁 Recent monitoring logs:
echo ================================
if exist "logs\current_stats.log" (
    echo 📊 Current Stats:
    type logs\current_stats.log
    echo.
)

if exist "logs\alerts.log" (
    echo ⚠️ Recent Alerts:
    type logs\alerts.log | findstr /C:"HIGH RAM"
    echo.
)

echo 📂 All log files:
dir logs\*.log /B 2>nul
echo.
pause
goto show_status

:show_status
echo.
echo 📊 Current Status:
echo ================================
docker-compose -f docker-compose.monitoring.yml ps
echo.
echo 💡 Tips:
echo - Dashboard: http://localhost:8090
echo - Logs folder: logs/
echo - Manual monitor: scripts\monitor-ram.bat
echo.
pause
goto exit

:invalid_choice
echo.
echo ❌ Invalid choice. Please try again.
pause
goto :eof

:exit
echo.
echo 👋 Goodbye!
exit /b 0
