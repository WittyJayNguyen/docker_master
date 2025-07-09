@echo off
REM Quick Setup - One command to create new project

echo.
echo ========================================
echo   🚀 QUICK PROJECT SETUP
echo ========================================
echo.

if "%~1"=="" (
    echo 💡 Quick Examples:
    echo.
    echo   quick-setup.bat my-shop
    echo   quick-setup.bat my-blog  
    echo   quick-setup.bat my-api
    echo.
    echo ⚡ AI will auto-detect project type and setup everything!
    echo.
    set /p PROJECT_NAME="Enter project name: "
) else (
    set PROJECT_NAME=%~1
)

if "%PROJECT_NAME%"=="" (
    echo ❌ Project name required
    pause
    exit /b 1
)

echo.
echo 🤖 AI Auto-Detection for: %PROJECT_NAME%
echo ================================================================

REM AI Detection Logic
set PHP_VERSION=84
set DB_TYPE=mysql
set PROJECT_TYPE=laravel

REM E-commerce detection
echo %PROJECT_NAME% | findstr /i "shop store ecommerce commerce buy sell" >nul
if not errorlevel 1 (
    set PROJECT_TYPE=ecommerce
    set PHP_VERSION=84
    set DB_TYPE=mysql
    echo ✅ Detected: E-commerce Platform
    echo   → Laravel PHP 8.4 + MySQL + Redis
)

REM Blog/CMS detection  
echo %PROJECT_NAME% | findstr /i "blog news cms content website portfolio" >nul
if not errorlevel 1 (
    set PROJECT_TYPE=wordpress
    set PHP_VERSION=74
    set DB_TYPE=mysql
    echo ✅ Detected: Blog/CMS Platform
    echo   → WordPress PHP 7.4 + MySQL
)

REM API detection
echo %PROJECT_NAME% | findstr /i "api service micro backend rest graphql" >nul
if not errorlevel 1 (
    set PROJECT_TYPE=api
    set PHP_VERSION=84
    set DB_TYPE=postgres
    echo ✅ Detected: API Service
    echo   → Laravel PHP 8.4 + PostgreSQL + Redis
)

echo.
echo 🚀 Auto-creating project with detected settings...
echo.

REM Call the main auto-setup script
call scripts\auto-setup-project.bat %PROJECT_NAME% %PHP_VERSION% %DB_TYPE%

echo.
echo 🎉 QUICK SETUP COMPLETED!
echo ================================================================
echo.
echo 💡 Next Steps:
echo   1. Edit code in: projects\%PROJECT_NAME%\
echo   2. Access: http://localhost:[auto-assigned-port]
echo   3. Debug: VS Code with Xdebug ready
echo.
echo 🌟 Happy coding!
