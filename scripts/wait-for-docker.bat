@echo off
REM Docker Master Platform - Wait for Docker
REM Đợi Docker khởi động hoàn toàn

echo.
echo ========================================
echo   Docker Master - Wait for Docker
echo ========================================
echo.

echo 🐳 Checking Docker status...

set /a counter=0
set /a max_attempts=30

:check_docker
set /a counter+=1
echo [%counter%/%max_attempts%] Checking Docker... 

docker version >nul 2>&1
if errorlevel 1 (
    if %counter% geq %max_attempts% (
        echo ❌ Docker failed to start after %max_attempts% attempts
        echo.
        echo 💡 Troubleshooting:
        echo    • Make sure Docker Desktop is installed
        echo    • Try restarting Docker Desktop manually
        echo    • Check if WSL2 is enabled
        echo    • Restart your computer if needed
        pause
        exit /b 1
    )
    echo    Docker not ready yet, waiting 5 seconds...
    timeout /t 5 /nobreak >nul
    goto :check_docker
)

echo ✅ Docker is ready!
echo.

echo 📊 Docker version:
docker version

echo.
echo 📊 Current containers:
docker ps

echo.
echo 📊 Current images:
docker images

echo.
echo 📊 System usage:
docker system df

echo.
echo 🎉 Docker is fully operational!
echo    You can now run other scripts safely.

pause
