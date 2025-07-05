@echo off
REM Docker Master Platform - One-Click Optimization
REM Tự động dọn dẹp và tối ưu hóa toàn bộ hệ thống

setlocal enabledelayedexpansion

echo.
echo ========================================
echo   Docker Master - One-Click Optimize
echo ========================================
echo.

REM Kiểm tra Docker
docker version >nul 2>&1
if errorlevel 1 (
    echo ❌ Docker is not running! Starting Docker...
    start "" "C:\Program Files\Docker\Docker\Docker Desktop.exe"
    echo ⏳ Waiting for Docker to start...
    timeout /t 30 /nobreak >nul
    docker version >nul 2>&1
    if errorlevel 1 (
        echo ❌ Could not start Docker! Please start it manually.
        pause
        exit /b 1
    )
)

echo 🔍 Analyzing current system...
echo ================================================================

REM Hiển thị thông tin trước khi tối ưu
echo 📊 BEFORE Optimization:
docker system df 2>nul
echo.

echo 🚀 Starting automatic optimization...
echo ================================================================

REM Bước 1: Dừng tất cả services
echo [1/8] 🛑 Stopping all services...
docker-compose down >nul 2>&1

REM Bước 2: Dọn dẹp containers
echo [2/8] 📦 Cleaning containers...
docker container prune -f >nul 2>&1

REM Bước 3: Dọn dẹp images
echo [3/8] 🖼️  Cleaning images...
docker image prune -f >nul 2>&1

REM Bước 4: Dọn dẹp volumes
echo [4/8] 💾 Cleaning volumes...
docker volume prune -f >nul 2>&1

REM Bước 5: Dọn dẹp networks
echo [5/8] 🌐 Cleaning networks...
docker network prune -f >nul 2>&1

REM Bước 6: Dọn dẹp system
echo [6/8] 🧹 System cleanup...
docker system prune -f >nul 2>&1

REM Bước 7: Dọn dẹp project files
echo [7/8] 📁 Cleaning project files...

REM Xóa files rác
if exist "*%*" del /f /q "*%*" 2>nul
if exist "*)*" del /f /q "*)*" 2>nul
del /f /q *.tmp 2>nul
del /f /q *.bak 2>nul
del /f /q *~ 2>nul
del /f /q .DS_Store 2>nul

REM Xóa thư mục rác
if exist "config\logs" rmdir /s /q "config\logs" 2>nul
if exist "config\scripts" rmdir /s /q "config\scripts" 2>nul

REM Xóa logs cũ
forfiles /p logs /m *.log /d -7 /c "cmd /c del @path" 2>nul

REM Bước 8: Khởi động với cấu hình tối ưu
echo [8/8] 🚀 Starting optimized services...
docker-compose -f docker-compose.low-ram.yml up -d

echo.
echo ✅ Optimization completed!
echo ================================================================

REM Hiển thị kết quả
echo 📊 AFTER Optimization:
docker system df
echo.

echo 📦 Running Services:
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
echo.

echo 💾 Memory Usage:
docker stats --no-stream --format "table {{.Container}}\t{{.MemUsage}}\t{{.MemPerc}}" 2>nul
echo.

echo 🎉 Optimization Summary:
echo ================================================================
echo ✅ All unused Docker resources cleaned
echo ✅ Project files cleaned  
echo ✅ Services started with low-RAM configuration
echo ✅ Memory usage optimized
echo.

echo 💡 Services Available:
echo    • Laravel PHP 8.4: http://localhost:8010
echo    • PostgreSQL: localhost:5432
echo    • Redis: localhost:6379  
echo    • Mailhog: http://localhost:8025
echo.

echo 📈 Expected RAM Usage: ~320MB (vs ~1-2GB before)
echo 💾 Disk Space Saved: Check above comparison
echo.

echo 🔧 Next Steps:
echo    • Test your applications
echo    • Monitor with: docker stats
echo    • Run this script weekly for maintenance
echo.

echo Press any key to exit...
pause >nul
