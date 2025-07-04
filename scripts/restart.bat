@echo off
echo 🔄 Restarting Docker Multi-Project Environment...
echo ================================================

REM Stop services
echo 🛑 Stopping containers...
docker-compose down

REM Wait a moment
echo ⏳ Waiting...
timeout /t 3 /nobreak >nul

REM Start services
echo 🚀 Starting containers...
docker-compose up -d

REM Wait for services to start
echo ⏳ Waiting for services to start...
timeout /t 10 /nobreak >nul

REM Check status
echo 📊 Checking service status...
docker-compose ps

echo.
echo ✅ Restart completed!
echo.
echo 🌐 Access URLs:
echo - Vue.js:      http://localhost:3000
echo - phpMyAdmin:  http://localhost:8080
echo - pgAdmin:     http://localhost:8081
echo.
pause
