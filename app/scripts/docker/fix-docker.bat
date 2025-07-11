@echo off
REM Docker Master Platform - Fix Docker Issues
REM Khắc phục các vấn đề Docker Desktop

echo.
echo ========================================
echo   Docker Master - Fix Docker Issues
echo ========================================
echo.

echo 🔧 Docker Desktop Troubleshooting Guide
echo ================================================================

echo 📋 Current Status Check:
echo ----------------------------------------------------------------

echo 🔍 Checking if Docker Desktop is running...
tasklist /FI "IMAGENAME eq Docker Desktop.exe" 2>nul | find /I "Docker Desktop.exe" >nul
if errorlevel 1 (
    echo ❌ Docker Desktop is NOT running
) else (
    echo ✅ Docker Desktop process is running
)

echo.
echo 🔍 Checking Docker service...
sc query com.docker.service >nul 2>&1
if errorlevel 1 (
    echo ❌ Docker service not found
) else (
    echo ✅ Docker service exists
)

echo.
echo 🛠️  Automatic Fix Attempts:
echo ================================================================

echo 🔄 Step 1: Killing existing Docker processes...
taskkill /F /IM "Docker Desktop.exe" >nul 2>&1
taskkill /F /IM "dockerd.exe" >nul 2>&1
taskkill /F /IM "docker.exe" >nul 2>&1
echo ✅ Processes killed

echo.
echo 🔄 Step 2: Restarting Docker Desktop...
start "" "C:\Program Files\Docker\Docker\Docker Desktop.exe"
echo ✅ Docker Desktop started

echo.
echo ⏳ Step 3: Waiting for Docker to initialize (60 seconds)...
timeout /t 60 /nobreak

echo.
echo 🧪 Step 4: Testing Docker connection...
docker version >nul 2>&1
if errorlevel 1 (
    echo ❌ Docker still not responding
    goto :manual_steps
) else (
    echo ✅ Docker is now working!
    goto :success
)

:manual_steps
echo.
echo 🔧 MANUAL TROUBLESHOOTING STEPS:
echo ================================================================

echo 📋 Step 1: Check WSL2
echo ----------------------------------------------------------------
echo • Open PowerShell as Administrator
echo • Run: wsl --status
echo • If WSL2 not installed: wsl --install
echo • Restart computer after WSL2 installation

echo.
echo 📋 Step 2: Reset Docker Desktop
echo ----------------------------------------------------------------
echo • Close Docker Desktop completely
echo • Open PowerShell as Administrator
echo • Run: "C:\Program Files\Docker\Docker\Docker Desktop.exe" --reset-to-factory
echo • Wait for reset to complete
echo • Restart Docker Desktop

echo.
echo 📋 Step 3: Check Windows Features
echo ----------------------------------------------------------------
echo • Open "Turn Windows features on or off"
echo • Enable: "Virtual Machine Platform"
echo • Enable: "Windows Subsystem for Linux"
echo • Enable: "Hyper-V" (if available)
echo • Restart computer

echo.
echo 📋 Step 4: Update Docker Desktop
echo ----------------------------------------------------------------
echo • Download latest Docker Desktop from: https://www.docker.com/products/docker-desktop
echo • Uninstall current version
echo • Install latest version
echo • Restart computer

echo.
echo 📋 Step 5: Alternative - Use Docker without Desktop
echo ----------------------------------------------------------------
echo • Install Docker Engine directly
echo • Use WSL2 with Docker installed in Linux
echo • Configure Docker to run in WSL2

echo.
echo 🆘 If all else fails:
echo ================================================================
echo • Restart your computer
echo • Check Windows Updates
echo • Disable antivirus temporarily
echo • Check disk space (need at least 10GB free)
echo • Run Windows Memory Diagnostic

goto :end

:success
echo.
echo 🎉 SUCCESS! Docker is now working!
echo ================================================================

echo 📊 Docker Status:
docker version

echo.
echo 📊 System Info:
docker system df

echo.
echo 🚀 You can now run the rebuild script:
echo    scripts\nuclear-clean.bat

:end
echo.
echo Press any key to exit...
pause >nul
