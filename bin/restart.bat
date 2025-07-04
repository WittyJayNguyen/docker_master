@echo off
REM ========================================
REM   Docker Master Platform - RESTART ALL
REM   Restart tất cả services
REM ========================================

echo.
echo ========================================
echo   🔄 RESTART ALL - Docker Master Platform
echo ========================================
echo.

echo 🔄 Restarting Docker Master Platform...
echo.

REM Stop all services first
echo 🛑 Stopping all services...
call stop.bat

echo.
echo ⏳ Waiting 5 seconds before restart...
timeout /t 5 /nobreak >nul

echo.
echo 🚀 Starting all services...
call start.bat

echo.
echo 🎉 Docker Master Platform restarted successfully!
pause
