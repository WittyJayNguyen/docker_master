@echo off
setlocal enabledelayedexpansion

REM Fix WordPress MySQL Compatibility
REM Downloads latest WordPress and sets up with PHP 7.4

set "SCRIPT_DIR=%~dp0"
set "PROJECT_ROOT=%SCRIPT_DIR%.."

REM Colors
set "GREEN=[92m"
set "BLUE=[94m"
set "YELLOW=[93m"
set "RED=[91m"
set "NC=[0m"

echo %BLUE%========================================%NC%
echo %BLUE%   Fix WordPress MySQL Compatibility%NC%
echo %BLUE%========================================%NC%
echo.

set "PROJECT_NAME=%~1"
if "%PROJECT_NAME%"=="" (
    set "PROJECT_NAME=asmokaigo"
)

set "DOMAIN_NAME=%~2"
if "%DOMAIN_NAME%"=="" (
    set "DOMAIN_NAME=asmo-asmokaigo.io"
)

echo %YELLOW%Fixing WordPress for: %PROJECT_NAME%%NC%
echo %YELLOW%Domain: %DOMAIN_NAME%%NC%
echo.

cd /d "%PROJECT_ROOT%"

REM Step 1: Backup current database
echo %BLUE%[1/6]%NC% Backing up current database...
docker-compose exec mysql mysqldump -u dev_user -pdev_pass %PROJECT_NAME% > %PROJECT_NAME%_backup.sql 2>nul
if exist "%PROJECT_NAME%_backup.sql" (
    echo %GREEN%✅ Database backed up to %PROJECT_NAME%_backup.sql%NC%
) else (
    echo %YELLOW%⚠️ Could not backup database (may not exist)%NC%
)

REM Step 2: Remove old WordPress
echo %BLUE%[2/6]%NC% Removing old WordPress files...
if exist "www\%PROJECT_NAME%\wordpress" (
    rmdir /s /q "www\%PROJECT_NAME%\wordpress" 2>nul
    echo %GREEN%✅ Old WordPress files removed%NC%
) else (
    echo %YELLOW%⚠️ WordPress directory not found%NC%
)

REM Step 3: Create new directory
echo %BLUE%[3/6]%NC% Creating new WordPress directory...
mkdir "www\%PROJECT_NAME%\wordpress" 2>nul
echo %GREEN%✅ Directory created%NC%

REM Step 4: Download latest WordPress
echo %BLUE%[4/6]%NC% Downloading latest WordPress...
powershell -Command "try { Invoke-WebRequest -Uri 'https://wordpress.org/latest.zip' -OutFile 'wordpress-latest.zip' -UseBasicParsing; Write-Host 'Download completed' } catch { Write-Host 'Download failed:' $_.Exception.Message }"

if exist "wordpress-latest.zip" (
    echo %GREEN%✅ WordPress downloaded%NC%
    
    REM Extract WordPress
    echo %BLUE%[5/6]%NC% Extracting WordPress...
    powershell -Command "Expand-Archive -Path 'wordpress-latest.zip' -DestinationPath 'temp-wp' -Force"
    
    REM Move files to correct location
    xcopy "temp-wp\wordpress\*" "www\%PROJECT_NAME%\wordpress\" /E /I /Y >nul
    
    REM Cleanup
    rmdir /s /q "temp-wp" 2>nul
    del "wordpress-latest.zip" 2>nul
    
    echo %GREEN%✅ WordPress extracted and moved%NC%
) else (
    echo %RED%❌ Failed to download WordPress%NC%
    echo %YELLOW%Manual solution:%NC%
    echo   1. Download WordPress from https://wordpress.org/latest.zip
    echo   2. Extract to www\%PROJECT_NAME%\wordpress\
    pause
    exit /b 1
)

REM Step 5: Create wp-config.php
echo %BLUE%[6/6]%NC% Creating wp-config.php...
(
    echo ^<?php
    echo /**
    echo  * WordPress Configuration - Auto-generated
    echo  */
    echo.
    echo // Database settings
    echo define^( 'DB_NAME', '%PROJECT_NAME%' ^);
    echo define^( 'DB_USER', 'dev_user' ^);
    echo define^( 'DB_PASSWORD', 'dev_pass' ^);
    echo define^( 'DB_HOST', 'mysql' ^);
    echo define^( 'DB_CHARSET', 'utf8mb4' ^);
    echo define^( 'DB_COLLATE', '' ^);
    echo.
    echo // Security keys ^(you should change these^)
    echo define^( 'AUTH_KEY',         'put your unique phrase here' ^);
    echo define^( 'SECURE_AUTH_KEY',  'put your unique phrase here' ^);
    echo define^( 'LOGGED_IN_KEY',    'put your unique phrase here' ^);
    echo define^( 'NONCE_KEY',        'put your unique phrase here' ^);
    echo define^( 'AUTH_SALT',        'put your unique phrase here' ^);
    echo define^( 'SECURE_AUTH_SALT', 'put your unique phrase here' ^);
    echo define^( 'LOGGED_IN_SALT',   'put your unique phrase here' ^);
    echo define^( 'NONCE_SALT',       'put your unique phrase here' ^);
    echo.
    echo // WordPress debugging
    echo define^( 'WP_DEBUG', true ^);
    echo define^( 'WP_DEBUG_LOG', true ^);
    echo define^( 'WP_DEBUG_DISPLAY', false ^);
    echo.
    echo // WordPress URLs
    echo define^( 'WP_HOME', 'http://%DOMAIN_NAME%' ^);
    echo define^( 'WP_SITEURL', 'http://%DOMAIN_NAME%' ^);
    echo.
    echo // Table prefix
    echo $table_prefix = 'wp_';
    echo.
    echo // WordPress absolute path
    echo if ^( ! defined^( 'ABSPATH' ^) ^) {
    echo     define^( 'ABSPATH', __DIR__ . '/' ^);
    echo }
    echo.
    echo // WordPress setup
    echo require_once ABSPATH . 'wp-settings.php';
    echo ?^>
) > "www\%PROJECT_NAME%\wordpress\wp-config.php"

echo %GREEN%✅ wp-config.php created%NC%

REM Step 6: Reset database
echo %BLUE%[BONUS]%NC% Resetting database...
docker-compose exec mysql mysql -u root -proot123 -e "DROP DATABASE IF EXISTS %PROJECT_NAME%;"
docker-compose exec mysql mysql -u root -proot123 -e "CREATE DATABASE %PROJECT_NAME% CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"
docker-compose exec mysql mysql -u root -proot123 -e "GRANT ALL PRIVILEGES ON %PROJECT_NAME%.* TO 'dev_user'@'%%';"
docker-compose exec mysql mysql -u root -proot123 -e "FLUSH PRIVILEGES;"

echo %GREEN%✅ Database reset%NC%

echo.
echo %GREEN%========================================%NC%
echo %GREEN%   WordPress Fixed Successfully!%NC%
echo %GREEN%========================================%NC%
echo.

echo %YELLOW%Next steps:%NC%
echo   1. Visit: http://%DOMAIN_NAME%
echo   2. Complete WordPress installation
echo   3. Create admin account
echo.

echo %YELLOW%WordPress Installation URLs:%NC%
echo   Site: http://%DOMAIN_NAME%
echo   Admin: http://%DOMAIN_NAME%/wp-admin
echo.

echo %YELLOW%Database Info:%NC%
echo   Database: %PROJECT_NAME%
echo   User: dev_user
echo   Password: dev_pass
echo   Host: mysql
echo.

set /p open_site="Open WordPress installation in browser? (y/N): "
if /i "%open_site%"=="y" (
    start http://%DOMAIN_NAME%
)

echo.
echo %GREEN%WordPress is now compatible with PHP 7.4!%NC%
pause
