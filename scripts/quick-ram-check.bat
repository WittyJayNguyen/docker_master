@echo off
echo.
echo 🚀 Quick RAM Check - Docker Master Platform
echo ============================================
echo.

REM Quick Docker check
docker version >nul 2>&1
if errorlevel 1 (
    echo ❌ Docker not running
    exit /b 1
)

echo ✅ Docker Status: Running
echo.

echo 📊 Container RAM Usage:
docker stats --format "table {{.Container}}\t{{.MemUsage}}\t{{.MemPerc}}" --no-stream
echo.

echo 💾 Total Docker Usage:
docker system df --format "table {{.Type}}\t{{.TotalCount}}\t{{.Size}}\t{{.Reclaimable}}"
echo.

echo 🖥️ System Memory (PowerShell):
powershell -Command "$mem = Get-CimInstance Win32_OperatingSystem; Write-Host ('Total: ' + [math]::Round($mem.TotalVisibleMemorySize/1MB,1) + 'GB'); Write-Host ('Free: ' + [math]::Round($mem.FreePhysicalMemory/1MB,1) + 'GB'); Write-Host ('Used: ' + [math]::Round(($mem.TotalVisibleMemorySize - $mem.FreePhysicalMemory)/1MB,1) + 'GB')"
echo.

echo 🎯 RAM Optimization Status:
if exist "docker-compose.override.yml" (
    echo ✅ RAM optimization is ACTIVE
    echo    - Memory limits applied to all containers
    echo    - Expected usage: 2-3GB instead of 4-6GB
) else (
    echo ⚠️  RAM optimization is NOT active
    echo    - Run: scripts\optimize-ram.bat
    echo    - Choose option 2 for optimized profile
)

echo.
echo 💡 Tips:
echo    - Run 'scripts\optimize-ram.bat' to change RAM profile
echo    - Run 'scripts\monitor-ram.bat' for real-time monitoring
echo    - Current containers using ~%total_ram%MB total
echo.
