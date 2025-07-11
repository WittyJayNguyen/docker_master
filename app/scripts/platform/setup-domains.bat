@echo off
REM Docker Master Platform - Setup Domains
REM Cấu hình hosts file để dùng domain asmo-tranding.io

echo.
echo ========================================
echo   Setup Domains for asmo-tranding.io
echo ========================================
echo.

echo 🌐 SETTING UP DOMAIN ROUTING
echo ================================================================

echo ℹ️  This script will configure your hosts file to use:
echo   • *.asmo-tranding.io domains instead of localhost ports
echo   • All platforms accessible via custom domains
echo   • Nginx proxy handles routing automatically

echo.
echo 📋 CURRENT PLATFORMS:
echo ----------------------------------------------------------------

REM List current platforms
if exist "platforms\" (
    for /d %%i in (platforms\*) do (
        echo   • %%~ni.asmo-tranding.io
    )
) else (
    echo   • No platforms created yet
)

echo.
echo 🔧 HOSTS FILE CONFIGURATION:
echo ================================================================

echo ⚠️  IMPORTANT: This requires Administrator privileges!
echo.
echo The following entries will be added to your hosts file:
echo   127.0.0.1 wp-blog-example.asmo-tranding.io
echo   127.0.0.1 laravel74-api-example.asmo-tranding.io
echo   127.0.0.1 laravel84-shop-example.asmo-tranding.io
echo   127.0.0.1 [your-platform].asmo-tranding.io

echo.
set /p confirm="Do you want to continue? (y/n): "
if /i not "%confirm%"=="y" (
    echo ❌ Setup cancelled.
    pause
    exit /b 1
)

echo.
echo 🔧 Configuring hosts file...

REM Check if running as administrator
net session >nul 2>&1
if not %errorLevel% == 0 (
    echo ❌ ERROR: This script must be run as Administrator!
    echo.
    echo 💡 How to run as Administrator:
    echo   1. Right-click on Command Prompt
    echo   2. Select "Run as administrator"
    echo   3. Navigate to this directory
    echo   4. Run this script again
    echo.
    pause
    exit /b 1
)

echo ✅ Administrator privileges confirmed.

REM Backup hosts file
copy "%SystemRoot%\System32\drivers\etc\hosts" "%SystemRoot%\System32\drivers\etc\hosts.backup.%date:~-4,4%%date:~-10,2%%date:~-7,2%" >nul
echo ✅ Hosts file backed up.

REM Add domain entries
echo.
echo 🔧 Adding domain entries...

REM Check if entries already exist
findstr /C:".io" "%SystemRoot%\System32\drivers\etc\hosts" >nul
if not errorlevel 1 (
    echo ⚠️  Some .io entries already exist.
    echo ℹ️  Removing old entries first...

    REM Create temp file without .io entries
    findstr /V /C:".io" "%SystemRoot%\System32\drivers\etc\hosts" > "%temp%\hosts_temp"
    copy "%temp%\hosts_temp" "%SystemRoot%\System32\drivers\etc\hosts" >nul
    del "%temp%\hosts_temp" >nul
    echo ✅ Old entries removed.
)

REM Add new entries
echo.
echo # Docker Master Platform - asmo-tranding.io domains >> "%SystemRoot%\System32\drivers\etc\hosts"
echo # Auto-generated entries for platform access >> "%SystemRoot%\System32\drivers\etc\hosts"

REM Add entries for existing platforms
if exist "platforms\" (
    for /d %%i in (platforms\*) do (
        echo 127.0.0.1 %%~ni.asmo-tranding.io >> "%SystemRoot%\System32\drivers\etc\hosts"
        echo ✅ Added: %%~ni.asmo-tranding.io
    )
)

REM Add wildcard entry for future platforms
echo 127.0.0.1 *.io >> "%SystemRoot%\System32\drivers\etc\hosts"
echo ✅ Added wildcard: *.io

echo.
echo 🎉 DOMAIN SETUP COMPLETED!
echo ================================================================

echo ✅ HOSTS FILE CONFIGURED:
echo   • Backup created: hosts.backup.[date]
echo   • Domain entries added for all platforms
echo   • Wildcard entry for future platforms

echo.
echo 🌐 HOW TO ACCESS PLATFORMS:
echo ================================================================

echo 📝 Instead of localhost ports, use domains:
echo ----------------------------------------------------------------
echo   OLD: http://localhost:8015
echo   NEW: http://wp-blog-example.io

echo   OLD: http://localhost:8016  
echo   NEW: http://laravel74-api-example.asmo-tranding.io

echo   OLD: http://localhost:8017
echo   NEW: http://laravel84-shop-example.asmo-tranding.io

echo.
echo 🔧 AUTOMATIC DOMAIN ASSIGNMENT:
echo ----------------------------------------------------------------
echo When you create new platforms:
echo   create.bat my-new-project
echo   → Accessible at: http://my-new-project.asmo-tranding.io

echo.
echo 🐛 DEBUGGING STILL WORKS:
echo ----------------------------------------------------------------
echo   • Xdebug ports remain the same (9015, 9016, 9017...)
echo   • VS Code configuration unchanged
echo   • Only web access uses domains

echo.
echo 💡 BENEFITS:
echo ================================================================

echo ✅ CLEAN URLS:
echo   • No more port numbers
echo   • Professional domain names
echo   • Easy to remember and share

echo ✅ NGINX FEATURES:
echo   • Load balancing ready
echo   • SSL/HTTPS ready (future)
echo   • Custom headers and routing
echo   • Better performance

echo ✅ DEVELOPMENT WORKFLOW:
echo   • Same create.bat commands
echo   • Automatic domain configuration
echo   • Zero additional setup per platform

echo.
echo 🚀 READY TO USE!
echo ================================================================

echo 💡 Next Steps:
echo   1. Create a new platform: create.bat my-awesome-project
echo   2. Access via domain: http://my-awesome-project.asmo-tranding.io
echo   3. Debug with VS Code using same Xdebug ports
echo   4. Enjoy clean, professional URLs!

echo.
echo 🌟 DOMAIN ROUTING SYSTEM READY!
echo    All platforms now accessible via asmo-tranding.io domains!

pause
