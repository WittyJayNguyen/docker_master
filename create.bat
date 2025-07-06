@echo off
REM Docker Master - Super Simple Platform Creator
REM Usage: create.bat [project-name]

if "%~1"=="" (
    echo.
    echo ========================================
    echo   Docker Master - Quick Platform Creator
    echo ========================================
    echo.
    echo Usage: create.bat [project-name]
    echo.
    echo Examples:
    echo   create.bat my-shop
    echo   create.bat food-delivery
    echo   create.bat my-blog
    echo   create.bat api-service
    echo.
    echo The system will auto-detect the best platform type!
    echo.
    pause
    exit /b 1
)

echo.
echo 🚀 Creating platform: %1
echo ================================================================

call scripts\auto-platform.bat %1
