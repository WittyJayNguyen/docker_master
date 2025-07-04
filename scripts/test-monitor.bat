@echo off
echo.
echo ========================================
echo   Docker Master Platform - RAM Test
echo ========================================
echo.

REM Check if Docker is running
docker version >nul 2>&1
if errorlevel 1 (
    echo ❌ Docker is not running
    pause
    exit /b 1
)

echo ✅ Docker is running
echo.

echo 📊 Current Container RAM Usage:
echo ----------------------------------------------------------------
docker stats --format "table {{.Container}}\t{{.MemUsage}}\t{{.MemPerc}}" --no-stream

echo.
echo 💾 Docker System Usage:
echo ----------------------------------------------------------------
docker system df

echo.
echo 🖥️ Windows System Memory:
echo ----------------------------------------------------------------
wmic OS get TotalVisibleMemorySize,FreePhysicalMemory /format:table

echo.
echo ✅ Test completed successfully!
pause
