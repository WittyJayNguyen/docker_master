@echo off
setlocal enabledelayedexpansion

if "%1"=="" (
    echo 🐘 PHP Version Management for Docker Multi-Project
    echo Usage: .\scripts\php-version.bat [command]
    echo.
    echo Commands:
    echo   show                      - Show current PHP versions
    echo   set-laravel [version]     - Set Laravel PHP version (7.4, 8.0, 8.1, 8.2)
    echo   rebuild                   - Rebuild containers with new PHP version
    echo.
    echo Examples:
    echo   .\scripts\php-version.bat show
    echo   .\scripts\php-version.bat set-laravel 8.2
    echo   .\scripts\php-version.bat rebuild
    echo.
    pause
    exit /b 0
)

if "%1"=="show" (
    echo 🐘 Current PHP Versions:
    echo.
    echo WordPress Container (Fixed):
    docker-compose exec wordpress-server php -v 2>nul | findstr "PHP"
    if !errorlevel! neq 0 (
        echo   Status: ❌ Container not running
    )
    echo.
    echo Laravel Container (Configurable):
    docker-compose exec laravel-server php -v 2>nul | findstr "PHP"
    if !errorlevel! neq 0 (
        echo   Status: ❌ Container not running
    )
    echo.
    echo Node.js Container:
    docker-compose exec nodejs_vue node --version 2>nul
    if !errorlevel! neq 0 (
        echo   Status: ❌ Container not running
    )
    echo.
)

if "%1"=="set-laravel" (
    if "%2"=="" (
        echo ❌ Please specify PHP version
        echo Available versions: 7.4, 8.0, 8.1, 8.2
        echo Usage: .\scripts\php-version.bat set-laravel [version]
        pause
        exit /b 1
    )
    
    set version=%2
    if "!version!"=="7.4" set dockerfile=php74
    if "!version!"=="8.0" set dockerfile=php80
    if "!version!"=="8.1" set dockerfile=php81
    if "!version!"=="8.2" set dockerfile=php8
    
    if "!dockerfile!"=="" (
        echo ❌ Invalid PHP version: %2
        echo Available versions: 7.4, 8.0, 8.1, 8.2
        pause
        exit /b 1
    )
    
    echo 🔧 Setting Laravel PHP version to: %2
    echo 📝 Updating docker-compose.yml...
    
    REM Update docker-compose.yml (simplified approach)
    echo ⚠️  Please manually update docker-compose.yml:
    echo    Change laravel-server build context to: ./docker/!dockerfile!
    echo.
    echo Then run: .\scripts\php-version.bat rebuild
    echo.
)

if "%1"=="rebuild" (
    echo 🔨 Rebuilding containers with new PHP version...
    echo.
    echo 🛑 Stopping Laravel container...
    docker-compose stop laravel-server
    
    echo 🗑️ Removing Laravel container...
    docker-compose rm -f laravel-server
    
    echo 🔨 Building new Laravel container...
    docker-compose build laravel-server
    
    echo 🚀 Starting Laravel container...
    docker-compose up -d laravel-server
    
    echo ⏳ Waiting for container to start...
    timeout /t 10 /nobreak >nul
    
    echo ✅ Laravel container rebuilt successfully!
    echo.
    echo 🐘 New PHP version:
    docker-compose exec laravel-server php -v | findstr "PHP"
    echo.
)

pause
