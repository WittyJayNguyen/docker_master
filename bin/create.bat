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
echo 🚀 Creating platform with auto features: %1
echo ================================================================
echo   • Auto AI detection (database, PHP version, platform type)
echo   • Auto domain configuration (*.asmo-tranding.io)
echo   • Auto Nginx setup and fast restart
echo   • Auto database creation with permissions
echo   • Auto container startup and testing

echo.
call scripts\auto-platform.bat %1

echo.
echo 🎉 PLATFORM CREATED WITH AUTO FEATURES!
echo ================================================================
echo.
echo 💡 What was automatically configured:
echo   ✅ Platform created with AI detection
echo   ✅ Domain configured: %1.asmo-tranding.io
echo   ✅ Nginx routing setup and reloaded
echo   ✅ Database created with proper permissions
echo   ✅ Container started and tested
echo.
echo 🌐 Access your platform:
echo   • Direct: http://localhost:[auto-assigned-port]
echo   • Domain: http://%1.asmo-tranding.io (if admin rights available)
echo.
echo 🚀 Ready for development!
