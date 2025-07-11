@echo off
echo.
echo ========================================
echo   Docker Master Platform - RAM Monitor
echo ========================================
echo.

:monitor_loop
cls
echo 📊 Docker RAM Usage Monitor - %date% %time%
echo ================================================================
echo.

REM Check if Docker is running
docker version >nul 2>&1
if errorlevel 1 (
    echo ❌ Docker is not running or not accessible
    echo Please start Docker Desktop and try again.
    pause
    exit /b 1
)

echo 🐳 Container RAM Usage:
echo ----------------------------------------------------------------
docker stats --format "table {{.Container}}\t{{.MemUsage}}\t{{.MemPerc}}\t{{.CPUPerc}}" --no-stream 2>nul
if errorlevel 1 (
    echo ⚠️  No containers running
) else (
    echo.
    echo 💾 Total Docker System Usage:
    echo ----------------------------------------------------------------
    docker system df
    
    echo.
    echo 📈 System Memory Info:
    echo ----------------------------------------------------------------
    powershell -Command "Get-CimInstance -ClassName Win32_OperatingSystem | Select-Object @{Name='TotalMemoryGB';Expression={[math]::Round($_.TotalVisibleMemorySize/1MB,2)}}, @{Name='FreeMemoryGB';Expression={[math]::Round($_.FreePhysicalMemory/1MB,2)}} | Format-Table -AutoSize"
)

echo.
echo ================================================================
echo Options:
echo 1. Refresh (auto-refresh every 5 seconds)
echo 2. Optimize RAM (switch to low RAM profile)
echo 3. Show detailed container info
echo 4. Exit
echo.
echo Press Ctrl+C to stop auto-refresh
echo.

REM Auto refresh every 5 seconds
choice /c 1234 /t 5 /d 1 /m "Choose option (auto-refresh in 5s)"

if errorlevel 4 goto exit
if errorlevel 3 goto detailed
if errorlevel 2 goto optimize
if errorlevel 1 goto monitor_loop

:detailed
cls
echo 🔍 Detailed Container Information:
echo ================================================================
echo.
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
echo.
echo 📊 Resource Limits:
echo ----------------------------------------------------------------
for /f "tokens=*" %%i in ('docker ps --format "{{.Names}}"') do (
    echo.
    echo Container: %%i
    docker inspect %%i --format "  Memory Limit: {{.HostConfig.Memory}}" 2>nul
    docker inspect %%i --format "  CPU Limit: {{.HostConfig.CpuQuota}}" 2>nul
)
echo.
pause
goto monitor_loop

:optimize
echo.
echo 🔧 Starting RAM Optimization...
call optimize-ram.bat
goto monitor_loop

:exit
echo.
echo 👋 Monitoring stopped.
exit /b 0
