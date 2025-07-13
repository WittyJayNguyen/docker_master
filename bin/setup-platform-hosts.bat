@echo off
REM Docker Master Platform - Auto Setup Platform Hosts for Windows
REM Tự động thêm tất cả platform hosts vào Windows hosts file

setlocal enabledelayedexpansion

echo.
echo ========================================
echo   DOCKER MASTER - PLATFORM HOST SETUP
echo ========================================
echo.

REM Check if running as Administrator
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo ❌ ERROR: This script requires Administrator privileges!
    echo.
    echo 💡 Please run as Administrator:
    echo   1. Right-click on Command Prompt
    echo   2. Select "Run as administrator"
    echo   3. Navigate to your project folder
    echo   4. Run: bin\setup-platform-hosts.bat
    echo.
    pause
    exit /b 1
)

echo 🚀 Setting up hosts for all Docker Master Platform projects...
echo.

REM Common platform hosts for Docker Master Platform
set PLATFORMS[0]=my-blog.io
set PLATFORMS[1]=my-shop.io
set PLATFORMS[2]=user-api.io
set PLATFORMS[3]=admin-panel.io
set PLATFORMS[4]=laravel-api.io
set PLATFORMS[5]=wordpress-blog.io
set PLATFORMS[6]=ecommerce-shop.io
set PLATFORMS[7]=payment-service.io
set PLATFORMS[8]=notification-api.io
set PLATFORMS[9]=tech-blog.io

REM Auto-detect existing platforms from platforms directory
echo 🔍 Auto-detecting existing platforms...
if exist "platforms\" (
    for /d %%i in (platforms\*) do (
        echo   Found platform: %%~ni
        call bin\auto-host.bat add %%~ni.io
    )
)

echo.
echo 📝 Adding common Docker Master Platform hosts...

REM Add common platform hosts
for /L %%i in (0,1,9) do (
    if defined PLATFORMS[%%i] (
        echo Adding: !PLATFORMS[%%i]!
        call bin\auto-host.bat add !PLATFORMS[%%i]!
    )
)

echo.
echo 🌐 Adding development domains...
call bin\auto-host.bat add localhost.dev
call bin\auto-host.bat add api.dev
call bin\auto-host.bat add admin.dev
call bin\auto-host.bat add dashboard.dev

echo.
echo ✅ Platform hosts setup completed!
echo.
echo 📋 All configured hosts:
call bin\auto-host.bat list

echo.
echo 💡 You can now access your platforms using:
echo   • http://my-blog.io
echo   • http://my-shop.io
echo   • http://user-api.io
echo   • http://admin-panel.io
echo   • And more...

echo.
echo 🔧 To add custom hosts:
echo   bin\auto-host.bat add [hostname]
echo.
echo 🗑️  To remove hosts:
echo   bin\auto-host.bat remove [hostname]

pause
