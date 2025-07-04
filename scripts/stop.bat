@echo off
echo 🛑 Stopping Docker Multi-Project Environment...
echo ===============================================

REM Stop all services
echo 🐳 Stopping containers...
docker-compose down

echo ✅ All services stopped successfully!
echo.
echo 🔧 Other commands:
echo - Start:       .\scripts\start.bat
echo - Restart:     .\scripts\restart.bat
echo - Logs:        .\scripts\logs.bat all
echo.
pause
