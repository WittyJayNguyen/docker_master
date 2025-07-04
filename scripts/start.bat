@echo off
echo 🚀 Starting Docker Multi-Project Environment...
echo ===============================================

REM Check if Docker is running
docker --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Docker is not running
    echo Please start Docker Desktop
    pause
    exit /b 1
)

REM Start services
echo 🐳 Starting containers...
docker-compose up -d

REM Wait a moment for services to start
echo ⏳ Waiting for services to start...
timeout /t 10 /nobreak >nul

REM Check status
echo 📊 Checking service status...
docker-compose ps

echo.
echo ✅ Services started successfully!
echo.
echo 🌐 Access URLs:
echo - Vue.js:      http://localhost:3000
echo - phpMyAdmin:  http://localhost:8080
echo - pgAdmin:     http://localhost:8081
echo - WordPress:   http://wordpress.local (after setup)
echo - Laravel:     http://laravel.local:8000 (after setup)
echo.
echo 🔧 Management commands:
echo - Status:      .\scripts\database.bat status
echo - Logs:        .\scripts\logs.bat all
echo - Stop:        .\scripts\stop.bat
echo.
pause
