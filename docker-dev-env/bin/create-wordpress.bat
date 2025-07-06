@echo off
setlocal enabledelayedexpansion

REM Create WordPress Project Script
REM Creates a new WordPress project with PHP 7.4

set "SCRIPT_DIR=%~dp0"
set "PROJECT_ROOT=%SCRIPT_DIR%.."

REM Colors
set "GREEN=[92m"
set "BLUE=[94m"
set "YELLOW=[93m"
set "RED=[91m"
set "NC=[0m"

REM Helper functions
:log_info
echo %BLUE%[INFO]%NC% %~1
goto :eof

:log_success
echo %GREEN%[SUCCESS]%NC% %~1
goto :eof

:log_warning
echo %YELLOW%[WARNING]%NC% %~1
goto :eof

:log_error
echo %RED%[ERROR]%NC% %~1
goto :eof

echo %BLUE%========================================%NC%
echo %BLUE%   WordPress Project Creator%NC%
echo %BLUE%        PHP 7.4 + MySQL%NC%
echo %BLUE%========================================%NC%
echo.

REM Get project name
set "PROJECT_NAME=%~1"
if "%PROJECT_NAME%"=="" (
    set /p PROJECT_NAME="Enter project name (e.g., asmokaigo): "
)

if "%PROJECT_NAME%"=="" (
    call :log_error "Project name is required!"
    pause
    exit /b 1
)

REM Get domain name
set "DOMAIN_NAME=%~2"
if "%DOMAIN_NAME%"=="" (
    set /p DOMAIN_NAME="Enter domain name (e.g., asmo-%PROJECT_NAME%.io): "
)

if "%DOMAIN_NAME%"=="" (
    set "DOMAIN_NAME=%PROJECT_NAME%.local"
)

call :log_info "Creating WordPress project: %PROJECT_NAME%"
call :log_info "Domain: %DOMAIN_NAME%"
echo.

cd /d "%PROJECT_ROOT%"

REM Check if Docker is running
docker info >nul 2>&1
if errorlevel 1 (
    call :log_error "Docker is not running. Please start Docker Desktop first."
    pause
    exit /b 1
)

REM Create project directory
call :log_info "Creating project directory..."
if exist "www\%PROJECT_NAME%" (
    call :log_warning "Project directory already exists!"
    set /p overwrite="Do you want to overwrite? (y/N): "
    if /i not "!overwrite!"=="y" (
        echo Operation cancelled.
        pause
        exit /b 0
    )
    rmdir /s /q "www\%PROJECT_NAME%"
)

mkdir "www\%PROJECT_NAME%"
mkdir "www\%PROJECT_NAME%\wordpress"
call :log_success "Project directory created"

REM Download WordPress using WP-CLI
call :log_info "Downloading WordPress..."
docker-compose exec php74 wp core download --path=/var/www/html/%PROJECT_NAME%/wordpress --allow-root

if errorlevel 1 (
    call :log_error "Failed to download WordPress"
    pause
    exit /b 1
)

call :log_success "WordPress downloaded"

REM Create database
call :log_info "Creating database..."
docker-compose exec mysql mysql -u root -proot123 -e "CREATE DATABASE IF NOT EXISTS %PROJECT_NAME% CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"
docker-compose exec mysql mysql -u root -proot123 -e "GRANT ALL PRIVILEGES ON %PROJECT_NAME%.* TO 'dev_user'@'%%';"
docker-compose exec mysql mysql -u root -proot123 -e "FLUSH PRIVILEGES;"

if errorlevel 1 (
    call :log_error "Failed to create database"
    pause
    exit /b 1
)

call :log_success "Database '%PROJECT_NAME%' created"

REM Create wp-config.php
call :log_info "Creating wp-config.php..."
docker-compose exec php74 wp config create ^
    --path=/var/www/html/%PROJECT_NAME%/wordpress ^
    --dbname=%PROJECT_NAME% ^
    --dbuser=dev_user ^
    --dbpass=dev_pass ^
    --dbhost=mysql ^
    --dbcharset=utf8mb4 ^
    --allow-root

if errorlevel 1 (
    call :log_error "Failed to create wp-config.php"
    pause
    exit /b 1
)

call :log_success "wp-config.php created"

REM Install WordPress
call :log_info "Installing WordPress..."
set /p site_title="Enter site title (default: %PROJECT_NAME% Site): "
if "%site_title%"=="" set "site_title=%PROJECT_NAME% Site"

set /p admin_user="Enter admin username (default: admin): "
if "%admin_user%"=="" set "admin_user=admin"

set /p admin_email="Enter admin email (default: admin@%DOMAIN_NAME%): "
if "%admin_email%"=="" set "admin_email=admin@%DOMAIN_NAME%"

set /p admin_pass="Enter admin password (default: admin123): "
if "%admin_pass%"=="" set "admin_pass=admin123"

docker-compose exec php74 wp core install ^
    --path=/var/www/html/%PROJECT_NAME%/wordpress ^
    --url=http://%DOMAIN_NAME% ^
    --title="%site_title%" ^
    --admin_user=%admin_user% ^
    --admin_password=%admin_pass% ^
    --admin_email=%admin_email% ^
    --allow-root

if errorlevel 1 (
    call :log_error "Failed to install WordPress"
    pause
    exit /b 1
)

call :log_success "WordPress installed"

REM Create virtual host
call :log_info "Creating virtual host..."
(
    echo server {
    echo     listen 80;
    echo     server_name %DOMAIN_NAME%;
    echo     root /var/www/html/%PROJECT_NAME%/wordpress;
    echo     index index.php index.html index.htm;
    echo.
    echo     # Logging
    echo     access_log /var/log/nginx/%PROJECT_NAME%_access.log;
    echo     error_log /var/log/nginx/%PROJECT_NAME%_error.log;
    echo.
    echo     # Security headers
    echo     add_header X-Frame-Options "SAMEORIGIN" always;
    echo     add_header X-XSS-Protection "1; mode=block" always;
    echo     add_header X-Content-Type-Options "nosniff" always;
    echo.
    echo     # Handle PHP files with PHP 7.4
    echo     location ~ \.php$ {
    echo         try_files $uri =404;
    echo         fastcgi_split_path_info ^(.+\.php^)(/.+^)$;
    echo         fastcgi_pass dev_php74:9000;
    echo         fastcgi_index index.php;
    echo         fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
    echo         include fastcgi_params;
    echo         fastcgi_param XDEBUG_CONFIG "client_host=host.docker.internal client_port=9003";
    echo         fastcgi_param PHP_IDE_CONFIG "serverName=%PROJECT_NAME%";
    echo         fastcgi_read_timeout 300;
    echo         fastcgi_buffer_size 128k;
    echo         fastcgi_buffers 4 256k;
    echo         fastcgi_busy_buffers_size 256k;
    echo     }
    echo.
    echo     # WordPress specific rules
    echo     location / {
    echo         try_files $uri $uri/ /index.php?$args;
    echo     }
    echo.
    echo     # WordPress security
    echo     location ~* wp-config\.php {
    echo         deny all;
    echo     }
    echo.
    echo     location = /xmlrpc.php {
    echo         deny all;
    echo     }
    echo.
    echo     location ~* ^/wp-content/uploads/.*\.php$ {
    echo         deny all;
    echo     }
    echo.
    echo     # Handle static files
    echo     location ~* \.(js^|css^|png^|jpg^|jpeg^|gif^|ico^|svg^|woff^|woff2^|ttf^|eot^)$ {
    echo         expires 1y;
    echo         add_header Cache-Control "public, immutable";
    echo         try_files $uri =404;
    echo     }
    echo.
    echo     # Deny access to hidden files
    echo     location ~ /\. {
    echo         deny all;
    echo     }
    echo }
) > "nginx\sites\%PROJECT_NAME%.local.conf"

call :log_success "Virtual host created"

REM Restart nginx
call :log_info "Restarting nginx..."
docker-compose restart nginx

call :log_success "Nginx restarted"

echo.
echo %GREEN%========================================%NC%
echo %GREEN%   WordPress Project Created!%NC%
echo %GREEN%========================================%NC%
echo.

echo %YELLOW%Project Details:%NC%
echo   Name: %PROJECT_NAME%
echo   Domain: %DOMAIN_NAME%
echo   Path: www/%PROJECT_NAME%/wordpress
echo   Database: %PROJECT_NAME%
echo   PHP Version: 7.4
echo.

echo %YELLOW%WordPress Admin:%NC%
echo   URL: http://%DOMAIN_NAME%/wp-admin
echo   Username: %admin_user%
echo   Password: %admin_pass%
echo   Email: %admin_email%
echo.

echo %YELLOW%Database Connection:%NC%
echo   Host: localhost:3306
echo   Database: %PROJECT_NAME%
echo   Username: dev_user
echo   Password: dev_pass
echo.

echo %YELLOW%Next Steps:%NC%
echo   1. Add to hosts file: 127.0.0.1 %DOMAIN_NAME%
echo   2. Visit: http://%DOMAIN_NAME%
echo   3. Login to admin: http://%DOMAIN_NAME%/wp-admin
echo.

set /p add_hosts="Add to hosts file automatically? (y/N): "
if /i "%add_hosts%"=="y" (
    echo 127.0.0.1 %DOMAIN_NAME% >> C:\Windows\System32\drivers\etc\hosts
    call :log_success "Added to hosts file"
)

set /p open_browser="Open site in browser? (y/N): "
if /i "%open_browser%"=="y" (
    start http://%DOMAIN_NAME%
)

echo.
call :log_success "WordPress project '%PROJECT_NAME%' created successfully!"
pause
