@echo off
REM Docker Master Platform - Advanced Cleanup & Optimization Script
REM Dọn dẹp toàn diện Docker containers, images, volumes và tối ưu RAM

setlocal enabledelayedexpansion

echo.
echo ========================================
echo   Docker Master - Advanced Cleanup
echo ========================================
echo.

REM Kiểm tra Docker có chạy không
docker version >nul 2>&1
if errorlevel 1 (
    echo ❌ Docker is not running! Please start Docker first.
    pause
    exit /b 1
)

echo 🔍 Analyzing current Docker usage...
echo.

REM Hiển thị thông tin hiện tại
echo 📊 Current Docker Status:
echo ================================================================
docker system df
echo.

REM Menu lựa chọn
echo 🛠️  Cleanup Options:
echo ================================================================
echo [1] Quick Cleanup (Safe - Remove unused containers/images)
echo [2] Deep Cleanup (Remove ALL stopped containers/unused images)
echo [3] Nuclear Cleanup (Remove EVERYTHING - containers, images, volumes)
echo [4] RAM Optimization Only (Keep containers, optimize settings)
echo [5] Show Docker Status Only
echo [0] Exit
echo.

set /p choice="Choose option (0-5): "

if "%choice%"=="0" goto :end
if "%choice%"=="1" goto :quick_cleanup
if "%choice%"=="2" goto :deep_cleanup
if "%choice%"=="3" goto :nuclear_cleanup
if "%choice%"=="4" goto :ram_optimize
if "%choice%"=="5" goto :show_status

echo ❌ Invalid choice!
goto :end

:quick_cleanup
echo.
echo 🧹 Starting Quick Cleanup...
echo ================================================================

echo 📦 Removing unused containers...
docker container prune -f

echo 🖼️  Removing dangling images...
docker image prune -f

echo 💾 Removing unused volumes...
docker volume prune -f

echo 🌐 Removing unused networks...
docker network prune -f

goto :cleanup_files

:deep_cleanup
echo.
echo 🧹 Starting Deep Cleanup...
echo ================================================================

echo ⚠️  This will remove ALL stopped containers and unused images!
set /p confirm="Continue? (y/N): "
if /i not "%confirm%"=="y" goto :end

echo 📦 Stopping all running containers...
for /f "tokens=1" %%i in ('docker ps -q') do docker stop %%i

echo 📦 Removing all containers...
docker container prune -f

echo 🖼️  Removing all unused images...
docker image prune -a -f

echo 💾 Removing unused volumes...
docker volume prune -f

echo 🌐 Removing unused networks...
docker network prune -f

goto :cleanup_files

:nuclear_cleanup
echo.
echo ☢️  Starting Nuclear Cleanup...
echo ================================================================

echo ⚠️  WARNING: This will remove EVERYTHING!
echo    - All containers (running and stopped)
echo    - All images
echo    - All volumes (including data!)
echo    - All networks
echo.
set /p confirm="Are you ABSOLUTELY sure? Type 'YES' to continue: "
if not "%confirm%"=="YES" goto :end

echo 🛑 Stopping all containers...
for /f "tokens=1" %%i in ('docker ps -aq') do docker stop %%i 2>nul

echo 📦 Removing all containers...
for /f "tokens=1" %%i in ('docker ps -aq') do docker rm -f %%i 2>nul

echo 🖼️  Removing all images...
for /f "tokens=1" %%i in ('docker images -aq') do docker rmi -f %%i 2>nul

echo 💾 Removing all volumes...
for /f "tokens=1" %%i in ('docker volume ls -q') do docker volume rm -f %%i 2>nul

echo 🌐 Removing all networks...
for /f "tokens=1" %%i in ('docker network ls -q') do docker network rm %%i 2>nul

echo 🧹 Running system prune...
docker system prune -a -f --volumes

goto :cleanup_files

:ram_optimize
echo.
echo 🚀 RAM Optimization Mode...
echo ================================================================

echo 📊 Current memory usage:
docker stats --no-stream --format "table {{.Container}}\t{{.CPUPerc}}\t{{.MemUsage}}\t{{.MemPerc}}"

echo.
echo 🔧 Optimizing containers for low RAM usage...
echo    - Restarting containers with memory limits
echo    - Switching to low-RAM compose file

echo 🛑 Stopping current containers...
docker-compose down

echo 🚀 Starting with low-RAM configuration...
docker-compose -f docker-compose.low-ram.yml up -d

goto :cleanup_files

:show_status
echo.
echo 📊 Docker System Information:
echo ================================================================
docker system df
echo.
echo 📦 Running Containers:
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
echo.
echo 🖼️  Images:
docker images --format "table {{.Repository}}\t{{.Tag}}\t{{.Size}}"
echo.
echo 💾 Volumes:
docker volume ls
echo.
goto :end

:cleanup_files
echo.
echo 🧹 Cleaning up project files...
echo ================================================================

REM Xóa files rác với tên lạ
echo 📁 Removing junk files...
if exist "*%*" del /f /q "*%*" 2>nul
if exist "*)*" del /f /q "*)*" 2>nul

REM Xóa thư mục rác trong config/
echo 📁 Cleaning config directory...
if exist "config\logs" (
    echo Removing: config\logs
    rmdir /s /q "config\logs" 2>nul
)
if exist "config\scripts" (
    echo Removing: config\scripts
    rmdir /s /q "config\scripts" 2>nul
)

REM Xóa files backup tạm thời
echo 📁 Removing temporary files...
del /f /q *.tmp 2>nul
del /f /q *.bak 2>nul
del /f /q *~ 2>nul
del /f /q .DS_Store 2>nul

REM Xóa logs cũ (> 7 ngày)
echo 📁 Cleaning old log files...
forfiles /p logs /m *.log /d -7 /c "cmd /c del @path" 2>nul

REM Xóa cache folders
echo 📁 Cleaning cache directories...
if exist "projects\*\storage\logs\*" (
    forfiles /p projects /s /m *.log /d -3 /c "cmd /c del @path" 2>nul
)

echo.
echo ✅ Cleanup completed!
echo.
echo 📊 Final Docker Status:
echo ================================================================
docker system df
echo.
echo 💡 What was cleaned:
echo    • Docker containers, images, volumes, networks
echo    • Junk files with special characters
echo    • Temporary backup files
echo    • Old log files (>7 days)
echo    • Cache directories
echo    • Accidentally created folders
echo.

:end
echo Press any key to exit...
pause >nul
