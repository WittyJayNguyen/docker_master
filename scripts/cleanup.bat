@echo off
REM Docker Master Platform - Cleanup Script
REM Xóa các files và folders rác không cần thiết

echo.
echo ========================================
echo   Docker Master Platform - Cleanup
echo ========================================
echo.

echo 🧹 Cleaning up unnecessary files and folders...
echo.

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
echo 📁 Removing temporary backup files...
del /f /q *.tmp 2>nul
del /f /q *.bak 2>nul
del /f /q *~ 2>nul

REM Xóa logs cũ (> 7 ngày)
echo 📁 Cleaning old log files...
forfiles /p logs /m *.log /d -7 /c "cmd /c del @path" 2>nul

REM Xóa Docker volumes không sử dụng
echo 🐳 Cleaning unused Docker volumes...
docker volume prune -f >nul 2>&1

REM Xóa Docker images không sử dụng
echo 🐳 Cleaning unused Docker images...
docker image prune -f >nul 2>&1

echo.
echo ✅ Cleanup completed!
echo.
echo 📊 Current directory structure:
echo ================================================================
dir /b | findstr /v /i "data logs projects"
echo.
echo 💡 What was cleaned:
echo    • Junk files with special characters
echo    • Temporary backup files
echo    • Old log files (>7 days)
echo    • Unused Docker volumes and images
echo    • Accidentally created folders in config/
echo.
pause
