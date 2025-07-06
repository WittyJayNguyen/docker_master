@echo off
setlocal enabledelayedexpansion

REM Docker RAM Monitoring Script
REM Shows real-time memory usage of all containers

echo ========================================
echo   Docker Development Environment
echo        RAM Usage Monitor
echo ========================================
echo.

:monitor_loop
cls
echo ========================================
echo   Docker RAM Usage Monitor
echo   Press Ctrl+C to exit
echo ========================================
echo.

REM Show system memory
echo [SYSTEM MEMORY]
for /f "tokens=2 delims==" %%i in ('wmic OS get TotalVisibleMemorySize /value ^| find "="') do set total_kb=%%i
for /f "tokens=2 delims==" %%i in ('wmic OS get FreePhysicalMemory /value ^| find "="') do set free_kb=%%i
set /a total_gb=!total_kb!/1024/1024
set /a free_gb=!free_kb!/1024/1024
set /a used_gb=!total_gb!-!free_gb!
echo Total RAM: %total_gb%GB
echo Used RAM:  %used_gb%GB
echo Free RAM:  %free_gb%GB
echo.

REM Show Docker container stats
echo [DOCKER CONTAINERS]
docker stats --no-stream --format "table {{.Name}}\t{{.CPUPerc}}\t{{.MemUsage}}\t{{.MemPerc}}\t{{.NetIO}}\t{{.BlockIO}}"
echo.

REM Show Docker system info
echo [DOCKER SYSTEM]
docker system df
echo.

echo Refreshing in 5 seconds...
timeout /t 5 /nobreak >nul
goto monitor_loop
