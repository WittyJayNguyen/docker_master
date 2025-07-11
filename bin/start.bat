@echo off
REM ========================================
REM   Docker Master Platform - ONE COMMAND START
REM   Chạy tất cả services với một lệnh duy nhất
REM ========================================

echo.
echo  ██████╗  ██████╗  ██████╗██╗  ██╗███████╗██████╗ 
echo  ██╔══██╗██╔═══██╗██╔════╝██║ ██╔╝██╔════╝██╔══██╗
echo  ██║  ██║██║   ██║██║     █████╔╝ █████╗  ██████╔╝
echo  ██║  ██║██║   ██║██║     ██╔═██╗ ██╔══╝  ██╔══██╗
echo  ██████╔╝╚██████╔╝╚██████╗██║  ██╗███████╗██║  ██║
echo  ╚═════╝  ╚═════╝  ╚═════╝╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝
echo.
echo  ███╗   ███╗ █████╗ ███████╗████████╗███████╗██████╗ 
echo  ████╗ ████║██╔══██╗██╔════╝╚══██╔══╝██╔════╝██╔══██╗
echo  ██╔████╔██║███████║███████╗   ██║   █████╗  ██████╔╝
echo  ██║╚██╔╝██║██╔══██║╚════██║   ██║   ██╔══╝  ██╔══██╗
echo  ██║ ╚═╝ ██║██║  ██║███████║   ██║   ███████╗██║  ██║
echo  ╚═╝     ╚═╝╚═╝  ╚═╝╚══════╝   ╚═╝   ╚══════╝╚═╝  ╚═╝
echo.
echo ========================================
echo   🚀 ONE COMMAND START - All Services
echo ========================================
echo.

REM Check if Docker is running
echo 🔍 Checking Docker status...
docker version >nul 2>&1
if errorlevel 1 (
    echo ❌ Docker is not running!
    echo 💡 Please start Docker Desktop first
    pause
    exit /b 1
)
echo ✅ Docker is running
echo.

REM Stop any existing containers
echo 🛑 Stopping existing containers...
call bin\docker-compose.bat down >nul 2>&1
docker-compose -f src\config\environments\docker-compose.monitoring.yml down >nul 2>&1
echo ✅ Cleaned up existing containers
echo.

REM Start main services with RAM optimization
echo 🚀 Starting main services with RAM optimization...
call bin\docker-compose.bat up -d
if errorlevel 1 (
    echo ❌ Failed to start main services
    pause
    exit /b 1
)
echo ✅ Main services started
echo.

REM Wait for databases to be ready
echo ⏳ Waiting for databases to initialize (60 seconds)...
timeout /t 60 /nobreak >nul
echo ✅ Database initialization completed
echo.

REM Initialize databases
echo 🗄️ Initializing databases...
call scripts\init-databases.bat >nul 2>&1
echo ✅ Databases initialized
echo.

REM Start auto-monitoring
echo 🤖 Starting auto-monitoring...
docker-compose -f app\config\environments\docker-compose.monitoring.yml up -d >nul 2>&1
echo ✅ Auto-monitoring started
echo.

REM Show final status
echo 📊 Final system status:
echo ================================================================
call bin\docker-compose.bat ps --format "table {{.Name}}\t{{.Status}}\t{{.Ports}}"
echo.

echo 🌐 Available Services:
echo ================================================================
echo 📱 Applications:
echo    • Laravel PHP 8.4:  http://localhost:8010
echo    • Laravel PHP 7.4:  http://localhost:8011
echo    • WordPress:         http://localhost:8012
echo.
echo 🛠️ Admin Tools:
echo    • phpMyAdmin:        http://localhost:8080
echo    • pgAdmin:           http://localhost:8081
echo    • Mailhog:           http://localhost:8025
echo.
echo 🤖 Monitoring:
echo    • RAM Dashboard:     http://localhost:8090
echo.
echo 🗄️ Database Connections:
echo    • PostgreSQL:        localhost:5432 (postgres_user/postgres_pass)
echo    • MySQL:             localhost:3306 (root/rootpassword123)
echo    • Redis:             localhost:6379
echo.

REM Show RAM usage
echo 💾 Current RAM Usage:
docker stats --format "table {{.Container}}\t{{.MemUsage}}\t{{.MemPerc}}" --no-stream
echo.

echo 🎉 Docker Master Platform is ready!
echo ================================================================
echo 💡 Quick commands:
echo    • Stop all:          bin\docker-compose.bat down
echo    • View logs:         bin\docker-compose.bat logs
echo    • Restart service:   bin\docker-compose.bat restart [service_name]
echo    • Monitor RAM:       app\scripts\monitoring\monitor-ram.bat
echo.
echo 🌐 Opening main dashboard...
start http://localhost:8090

echo.
echo ✅ All services are running!
echo.
echo 💡 Troubleshooting:
echo    • If phpMyAdmin shows "Cannot connect": run scripts\fix-database-corruption.bat
echo    • If services not responding: wait 2-3 minutes for full startup
echo    • For other issues: see TROUBLESHOOTING.md
echo.
echo Press any key to exit...
pause >nul
