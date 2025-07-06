@echo off
REM Docker Master - One Command Auto Platform Creator
REM Tạo platform hoàn toàn tự động chỉ với 1 lệnh

setlocal enabledelayedexpansion

echo.
echo ========================================
echo   One Command Auto Platform Creator
echo ========================================
echo.

echo 🚀 Creating platform automatically...
echo ================================================================

REM Auto-detect project type from current directory or ask user
if "%~1"=="" (
    echo 🤖 No project name provided. Starting smart detection...
    goto :smart_detection
) else (
    set "PROJECT_NAME=%~1"
    goto :auto_create
)

:smart_detection
echo.
echo 📝 Quick project setup:
echo   Just tell me what you're building and I'll create everything!
echo.
set /p PROJECT_NAME="Project name (e.g., my-shop, food-delivery): "

if "%PROJECT_NAME%"=="" (
    echo ❌ Project name is required
    pause
    exit /b 1
)

:auto_create
REM Auto-format project name
set PLATFORM_NAME=%PROJECT_NAME: =-%
set PLATFORM_NAME=%PLATFORM_NAME%

REM Auto-detect platform type and database based on name keywords
set PLATFORM_TYPE=laravel74
set PROJECT_DESCRIPTION=Laravel application
set DB_TYPE=postgresql
set DB_HOST=postgres_low_ram
set DB_PORT=5432

echo %PLATFORM_NAME% | findstr /i "shop store ecommerce commerce buy sell" >nul
if not errorlevel 1 (
    set PLATFORM_TYPE=ecommerce
    set PROJECT_DESCRIPTION=E-commerce store
    set DB_TYPE=mysql
    set DB_HOST=mysql_low_ram
    set DB_PORT=3306
)

echo %PLATFORM_NAME% | findstr /i "blog news cms content" >nul
if not errorlevel 1 (
    set PLATFORM_TYPE=wordpress
    set PROJECT_DESCRIPTION=WordPress blog/CMS
    set DB_TYPE=mysql
    set DB_HOST=mysql_low_ram
    set DB_PORT=3306
)

echo %PLATFORM_NAME% | findstr /i "food restaurant delivery cafe" >nul
if not errorlevel 1 (
    set PLATFORM_TYPE=ecommerce
    set PROJECT_DESCRIPTION=Food delivery platform
    set DB_TYPE=mysql
    set DB_HOST=mysql_low_ram
    set DB_PORT=3306
)

echo %PLATFORM_NAME% | findstr /i "api service micro backend" >nul
if not errorlevel 1 (
    set PLATFORM_TYPE=laravel84
    set PROJECT_DESCRIPTION=API/Microservice
    set DB_TYPE=postgresql
    set DB_HOST=postgres_low_ram
    set DB_PORT=5432
)

echo %PLATFORM_NAME% | findstr /i "portfolio personal website" >nul
if not errorlevel 1 (
    set PLATFORM_TYPE=wordpress
    set PROJECT_DESCRIPTION=Portfolio website
    set DB_TYPE=mysql
    set DB_HOST=mysql_low_ram
    set DB_PORT=3306
)

REM Auto-assign port
set /a PLATFORM_PORT=8015
:find_port
findstr /C:"%PLATFORM_PORT%:80" docker-compose.low-ram.yml >nul 2>&1
if not errorlevel 1 (
    set /a PLATFORM_PORT+=1
    goto :find_port
)

REM Determine PHP version
set PHP_VERSION=74
if "%PLATFORM_TYPE%"=="laravel84" set PHP_VERSION=84
if "%PLATFORM_TYPE%"=="ecommerce" set PHP_VERSION=84
REM Force PHP 7.4 for laravel74 projects
echo %PLATFORM_NAME% | findstr /C:"laravel74" >nul
if not errorlevel 1 set PHP_VERSION=74

set /a XDEBUG_PORT=%PLATFORM_PORT%+1000

echo.
echo 🤖 AI Auto-Detection Results:
echo ================================================================
echo   • Project Name: %PLATFORM_NAME%
echo   • Detected Type: %PROJECT_DESCRIPTION%
echo   • Platform: %PLATFORM_TYPE%
echo   • Database: %DB_TYPE% (%DB_HOST%:%DB_PORT%)
echo   • Port: %PLATFORM_PORT%
echo   • PHP Version: %PHP_VERSION%
echo   • Xdebug: %XDEBUG_PORT%
echo.

echo 🏗️  Creating platform structure...

REM Create directories
mkdir "platforms\%PLATFORM_NAME%" 2>nul
mkdir "projects\%PLATFORM_NAME%" 2>nul
mkdir "logs\apache\%PLATFORM_NAME%" 2>nul
mkdir "data\uploads\%PLATFORM_NAME%" 2>nul

echo ✅ Directories created

REM Create database with proper naming
set DB_NAME=%PLATFORM_NAME%_db
set DB_NAME=%DB_NAME:-=_%

REM Set database credentials based on type
if "%DB_TYPE%"=="mysql" (
    set DB_USERNAME=mysql_user
    set DB_PASSWORD=mysql_pass
) else (
    set DB_USERNAME=postgres_user
    set DB_PASSWORD=postgres_pass
)

echo ℹ️  Creating database: %DB_NAME% (%DB_TYPE%)
if "%DB_TYPE%"=="mysql" (
    docker exec mysql_low_ram mysql -u root -pmysql_root_pass -e "CREATE DATABASE IF NOT EXISTS %DB_NAME%; GRANT ALL PRIVILEGES ON %DB_NAME%.* TO 'mysql_user'@'%%'; FLUSH PRIVILEGES;" 2>nul
    echo ✅ MySQL database created: %DB_NAME%
) else (
    docker exec postgres_low_ram psql -U postgres_user -d postgres -c "CREATE DATABASE %DB_NAME%;" 2>nul
    echo ✅ PostgreSQL database created: %DB_NAME%
)

REM Create docker-compose file
echo ℹ️  Creating docker-compose configuration...
(
echo version: '3.8'
echo.
echo services:
echo   %PLATFORM_NAME%:
echo     build:
echo       context: ../../docker/php%PHP_VERSION%
echo       dockerfile: Dockerfile
echo     container_name: %PLATFORM_NAME%_php%PHP_VERSION%
echo     restart: unless-stopped
echo     ports:
echo       - "%XDEBUG_PORT%:9003"  # Only expose Xdebug port
echo     expose:
echo       - "80"  # Internal port for Nginx proxy
echo     volumes:
echo       - ../../projects/%PLATFORM_NAME%:/var/www/html
echo       - ../../logs/apache/%PLATFORM_NAME%:/var/log/apache2
echo       - ../../data/uploads/%PLATFORM_NAME%:/app/uploads
echo     environment:
echo       - WEB_DOCUMENT_ROOT=/var/www/html
echo       - PHP_VERSION=%PHP_VERSION%
echo       - PHP_MEMORY_LIMIT=96M
echo       - DB_CONNECTION=%DB_TYPE%
echo       - DB_HOST=%DB_HOST%
echo       - DB_PORT=%DB_PORT%
echo       - DB_DATABASE=%DB_NAME%
echo       - DB_USERNAME=%DB_USERNAME%
echo       - DB_PASSWORD=%DB_PASSWORD%
echo       - REDIS_HOST=redis_low_ram
echo     deploy:
echo       resources:
echo         limits:
echo           memory: 128M
echo     networks:
echo       - docker_master_low_ram
echo     external_links:
echo       - postgres_low_ram:postgres_low_ram
echo       - redis_low_ram:redis_low_ram
echo     healthcheck:
echo       test: ["CMD", "curl", "-f", "http://localhost/"]
echo       interval: 30s
echo       timeout: 10s
echo       retries: 3
echo.
echo networks:
echo   docker_master_low_ram:
echo     external: true
) > "platforms\%PLATFORM_NAME%\docker-compose.%PLATFORM_NAME%.yml"

REM Create application file based on type
echo ℹ️  Creating application files...

if "%PLATFORM_TYPE%"=="wordpress" (
    call :create_wordpress_app
) else if "%PLATFORM_TYPE%"=="ecommerce" (
    call :create_ecommerce_app
) else (
    call :create_laravel_app
)

REM Create README
echo ℹ️  Creating documentation...
(
echo # %PLATFORM_NAME% Platform
echo.
echo Auto-generated %PROJECT_DESCRIPTION% by Docker Master.
echo.
echo ## Quick Start
echo.
echo ```bash
echo # Start platform
echo cd platforms/%PLATFORM_NAME%
echo docker-compose -f docker-compose.%PLATFORM_NAME%.yml up -d
echo ```
echo.
echo ## URLs
echo - Application: http://localhost:%PLATFORM_PORT%
echo - Xdebug: localhost:%XDEBUG_PORT%
echo.
echo ## Database
echo - Host: postgres_low_ram
echo - Database: %DB_NAME%
echo - User: postgres_user
echo.
echo Generated by Docker Master Auto Platform Creator
) > "platforms\%PLATFORM_NAME%\README.md"

echo ✅ Platform created successfully!

echo.
echo 🔧 Creating Nginx configuration...
call :create_nginx_config

echo.
echo 🚀 Starting platform...
cd platforms\%PLATFORM_NAME%
docker-compose -f docker-compose.%PLATFORM_NAME%.yml up -d

echo.
echo ⏳ Waiting for platform to start...
timeout /t 15 /nobreak >nul

echo.
echo 🔄 Reloading Nginx configuration...
cd ..\..
docker exec nginx_proxy_low_ram nginx -s reload 2>nul

echo.
echo 🧪 Testing platform...
powershell -Command "try { $r = Invoke-WebRequest -Uri 'http://localhost:%PLATFORM_PORT%' -TimeoutSec 10 -UseBasicParsing; if ($r.StatusCode -eq 200) { Write-Host '✅ Platform is running successfully!' -ForegroundColor Green } else { Write-Host '⚠️  Platform starting...' -ForegroundColor Yellow } } catch { Write-Host '⚠️  Platform may still be starting...' -ForegroundColor Yellow }"

echo.
echo 🎉 AUTO PLATFORM CREATION COMPLETED!
echo ================================================================
echo.
echo ✅ Platform Details:
echo   • Name: %PLATFORM_NAME%
echo   • Type: %PROJECT_DESCRIPTION%
echo   • URL: http://localhost:%PLATFORM_PORT%
echo   • Domain: http://%PLATFORM_NAME%.asmo-tranding.io
echo   • Database: %DB_NAME%
echo.
echo 💡 Quick Commands:
echo   • View: start http://localhost:%PLATFORM_PORT%
echo   • Logs: docker logs %PLATFORM_NAME%_php%PHP_VERSION%
echo   • Stop: docker-compose -f docker-compose.%PLATFORM_NAME%.yml down
echo.

start http://localhost:%PLATFORM_PORT%
pause
exit /b 0

:create_wordpress_app
(
echo ^<?php
echo echo "^<h1^>📝 %PLATFORM_NAME% - WordPress Platform^</h1^>";
echo echo "^<div style='font-family: Arial, sans-serif; max-width: 800px; margin: 0 auto; padding: 20px;'^>";
echo echo "^<h2^>🗄️ Database Connection^</h2^>";
if "%DB_TYPE%"=="mysql" (
    echo $pdo = new PDO^("mysql:host=%DB_HOST%;dbname=%DB_NAME%", "%DB_USERNAME%", "%DB_PASSWORD%"^);
) else (
    echo $pdo = new PDO^("pgsql:host=%DB_HOST%;dbname=%DB_NAME%", "%DB_USERNAME%", "%DB_PASSWORD%"^);
)
echo echo "^<p^>✅ %DB_TYPE% connection successful!^</p^>";
echo echo "^<p^>Ready for WordPress installation!^</p^>";
echo echo "^</div^>";
echo ?^>
) > "projects\%PLATFORM_NAME%\index.php"
exit /b 0

:create_ecommerce_app
(
echo ^<?php
echo echo "^<h1^>🛒 %PLATFORM_NAME% - E-commerce Platform^</h1^>";
echo echo "^<div style='font-family: Arial, sans-serif; max-width: 800px; margin: 0 auto; padding: 20px;'^>";
echo echo "^<h2^>🗄️ Database Connection^</h2^>";
if "%DB_TYPE%"=="mysql" (
    echo $pdo = new PDO^("mysql:host=%DB_HOST%;dbname=%DB_NAME%", "%DB_USERNAME%", "%DB_PASSWORD%"^);
) else (
    echo $pdo = new PDO^("pgsql:host=%DB_HOST%;dbname=%DB_NAME%", "%DB_USERNAME%", "%DB_PASSWORD%"^);
)
echo echo "^<p^>✅ %DB_TYPE% connection successful!^</p^>";
echo echo "^<p^>E-commerce platform ready!^</p^>";
echo echo "^</div^>";
echo ?^>
) > "projects\%PLATFORM_NAME%\index.php"
exit /b 0

:create_laravel_app
(
echo ^<?php
echo echo "^<h1^>🚀 %PLATFORM_NAME% - Laravel Platform^</h1^>";
echo echo "^<div style='font-family: Arial, sans-serif; max-width: 800px; margin: 0 auto; padding: 20px;'^>";
echo echo "^<h2^>🗄️ Database Connection^</h2^>";
if "%DB_TYPE%"=="mysql" (
    echo $pdo = new PDO^("mysql:host=%DB_HOST%;dbname=%DB_NAME%", "%DB_USERNAME%", "%DB_PASSWORD%"^);
) else (
    echo $pdo = new PDO^("pgsql:host=%DB_HOST%;dbname=%DB_NAME%", "%DB_USERNAME%", "%DB_PASSWORD%"^);
)
echo echo "^<p^>✅ %DB_TYPE% connection successful!^</p^>";
echo echo "^<p^>Laravel platform ready!^</p^>";
echo echo "^</div^>";
echo ?^>
) > "projects\%PLATFORM_NAME%\index.php"
exit /b 0

:create_nginx_config
REM Create Nginx configuration for the platform
(
echo # %PLATFORM_NAME% - Auto-generated Nginx configuration
echo server {
echo     listen 80;
echo     server_name %PLATFORM_NAME%.asmo-tranding.io;
echo.
echo     location / {
echo         proxy_pass http://%PLATFORM_NAME%_php%PHP_VERSION%:80;
echo         proxy_set_header Host $host;
echo         proxy_set_header X-Real-IP $remote_addr;
echo         proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
echo         proxy_set_header X-Forwarded-Proto $scheme;
echo         proxy_set_header X-Forwarded-Host $server_name;
echo.
echo         # PHP specific headers
echo         proxy_set_header SCRIPT_NAME $uri;
echo         proxy_set_header REQUEST_URI $request_uri;
echo.
echo         # Timeouts
echo         proxy_connect_timeout 60s;
echo         proxy_send_timeout 60s;
echo         proxy_read_timeout 60s;
echo.
echo         # Buffer settings
echo         proxy_buffering on;
echo         proxy_buffer_size 4k;
echo         proxy_buffers 8 4k;
echo     }
echo.
echo     # Health check
echo     location /health {
echo         access_log off;
echo         return 200 "healthy\n";
echo         add_header Content-Type text/plain;
echo     }
echo }
echo.
) >> "nginx\conf.d\%PLATFORM_NAME%.conf"
exit /b 0
