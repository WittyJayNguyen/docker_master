@echo off
REM Docker Master Platform - Fix Database Corruption
REM Khắc phục lỗi database corruption sau khi xóa data files

echo.
echo ========================================
echo   Fix Database Corruption
========================================
echo.

echo 🔧 Fixing database corruption issues...
echo.

echo ⚠️  WARNING: This will reset all database data!
echo    • All MySQL databases will be recreated
echo    • All PostgreSQL databases will be recreated
echo    • Application data will be lost
echo.

set /p confirm="Continue? This will delete all database data (y/N): "
if /i not "%confirm%"=="y" (
    echo ❌ Operation cancelled
    exit /b 0
)

echo.
echo 🛑 Stopping all services...
call bin\stop.bat >nul 2>&1

echo.
echo 🗑️ Removing corrupted database directories...
if exist "data\mysql" (
    echo Removing data\mysql...
    rmdir /s /q "data\mysql" 2>nul
)

if exist "data\postgres" (
    echo Removing data\postgres...
    rmdir /s /q "data\postgres" 2>nul
)

if exist "data\redis" (
    echo Removing data\redis...
    rmdir /s /q "data\redis" 2>nul
)

if exist "data\pgadmin" (
    echo Removing data\pgadmin...
    rmdir /s /q "data\pgadmin" 2>nul
)

echo.
echo 📁 Creating fresh database directories...
mkdir "data\mysql" 2>nul
mkdir "data\postgres" 2>nul
mkdir "data\redis" 2>nul
mkdir "data\pgadmin" 2>nul

echo ✅ Database directories recreated

echo.
echo 🚀 Starting services with fresh databases...
call bin\start.bat

echo.
echo ✅ Database corruption fixed!
echo.
echo 💡 What was done:
echo    • Stopped all Docker containers
echo    • Removed corrupted database files
echo    • Created fresh database directories
echo    • Restarted all services with clean databases
echo.
echo 🌐 Services should now be accessible:
echo    • phpMyAdmin: http://localhost:8080
echo    • pgAdmin: http://localhost:8081
echo    • Applications: http://localhost:8010-8012
echo.
pause
