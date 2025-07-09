@echo off
REM Auto Setup New Project - Complete automation
REM Usage: auto-setup-project.bat [project-name] [php-version] [db-type]

setlocal enabledelayedexpansion

if "%~1"=="" (
    echo.
    echo ========================================
    echo   Auto Setup New Project
    echo ========================================
    echo.
    echo Usage: auto-setup-project.bat [project-name] [php-version] [db-type]
    echo.
    echo Examples:
    echo   auto-setup-project.bat my-shop 84 mysql
    echo   auto-setup-project.bat my-blog 74 mysql
    echo   auto-setup-project.bat my-api 84 postgres
    echo.
    echo PHP Versions: 74, 84
    echo DB Types: mysql, postgres
    echo.
    pause
    exit /b 1
)

set PROJECT_NAME=%~1
set PHP_VERSION=%~2
set DB_TYPE=%~3

REM Default values
if "%PHP_VERSION%"=="" set PHP_VERSION=84
if "%DB_TYPE%"=="" set DB_TYPE=mysql

echo.
echo 🚀 AUTO SETUP PROJECT: %PROJECT_NAME%
echo ================================================================
echo   • PHP Version: %PHP_VERSION%
echo   • Database: %DB_TYPE%
echo   • Auto nginx config
echo   • Auto port detection
echo   • Auto database creation

echo.
echo 🔍 Step 1: Finding available port...

REM Find available port starting from 8017
set /a PORT=8017
:find_port
docker ps --format "{{.Ports}}" | findstr ":%PORT%->" >nul 2>&1
if not errorlevel 1 (
    set /a PORT+=1
    goto :find_port
)

set /a XDEBUG_PORT=%PORT%+1000
echo ✅ Using ports: %PORT% (web), %XDEBUG_PORT% (xdebug)

echo.
echo 📁 Step 2: Creating project structure...

REM Create directories
mkdir "projects\%PROJECT_NAME%" 2>nul
mkdir "platforms\%PROJECT_NAME%" 2>nul

echo ✅ Directories created

echo.
echo 🐳 Step 3: Generating Docker Compose...

REM Create docker-compose.yml
(
echo version: '3.8'
echo services:
echo   %PROJECT_NAME%_php%PHP_VERSION%:
echo     build:
echo       context: ../../docker/php%PHP_VERSION%
echo       dockerfile: Dockerfile
echo     container_name: %PROJECT_NAME%_php%PHP_VERSION%
echo     restart: unless-stopped
echo     ports:
echo       - "%PORT%:80"
echo       - "%XDEBUG_PORT%:9003"
echo     expose:
echo       - "80"
echo     volumes:
echo       - ../../projects/%PROJECT_NAME%:/var/www/html
echo     environment:
echo       # PHP Configuration
echo       PHP_VERSION: %PHP_VERSION%
echo       PHP_MEMORY_LIMIT: 256M
echo       PHP_MAX_EXECUTION_TIME: 300
echo       
echo       # Xdebug Configuration
echo       XDEBUG_MODE: develop,debug
echo       XDEBUG_START_WITH_REQUEST: yes
echo       XDEBUG_CLIENT_HOST: host.docker.internal
echo       XDEBUG_CLIENT_PORT: 9003
echo       XDEBUG_IDEKEY: VSCODE
echo       
echo       # Database Configuration
if "%DB_TYPE%"=="mysql" (
echo       DB_CONNECTION: mysql
echo       DB_HOST: mysql_low_ram
echo       DB_PORT: 3306
echo       DB_DATABASE: %PROJECT_NAME%_db
echo       DB_USERNAME: mysql_user
echo       DB_PASSWORD: mysql_pass
) else (
echo       DB_CONNECTION: pgsql
echo       DB_HOST: postgres_low_ram
echo       DB_PORT: 5432
echo       DB_DATABASE: %PROJECT_NAME%_db
echo       DB_USERNAME: postgres_user
echo       DB_PASSWORD: postgres_pass
)
echo     networks:
echo       - docker_master_low_ram
echo.
echo networks:
echo   docker_master_low_ram:
echo     external: true
) > "platforms\%PROJECT_NAME%\docker-compose.%PROJECT_NAME%.yml"

echo ✅ Docker Compose created

echo.
echo 🌐 Step 4: Creating Nginx configuration...

REM Create nginx config
(
echo # %PROJECT_NAME% - Auto-generated Nginx configuration
echo server {
echo     listen 80;
echo     server_name %PROJECT_NAME%.asmo-tranding.io;
echo.
echo     location / {
echo         proxy_pass http://%PROJECT_NAME%_php%PHP_VERSION%:80;
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
) > "nginx\conf.d\%PROJECT_NAME%.conf"

echo ✅ Nginx config created

echo.
echo 🗄️ Step 5: Creating database...

set DB_NAME=%PROJECT_NAME%_db
set DB_NAME=%DB_NAME:-=_%

if "%DB_TYPE%"=="mysql" (
    echo Creating MySQL database: %DB_NAME%
    docker exec mysql_low_ram mysql -u root -pmysql_root_pass -e "CREATE DATABASE IF NOT EXISTS %DB_NAME%; GRANT ALL PRIVILEGES ON %DB_NAME%.* TO 'mysql_user'@'%%'; FLUSH PRIVILEGES;" 2>nul
    if not errorlevel 1 (
        echo ✅ MySQL database created
    ) else (
        echo ❌ Failed to create MySQL database
    )
) else (
    echo Creating PostgreSQL database: %DB_NAME%
    docker exec postgres_low_ram psql -U postgres_user -d postgres -c "CREATE DATABASE %DB_NAME%;" 2>nul
    if not errorlevel 1 (
        echo ✅ PostgreSQL database created
    ) else (
        echo ❌ Failed to create PostgreSQL database
    )
)

echo.
echo 📝 Step 6: Creating sample index.php...

REM Create sample index.php
(
echo ^<?php
echo /**
echo  * %PROJECT_NAME% - Auto-generated welcome page
echo  */
echo ?^>
echo ^<!DOCTYPE html^>
echo ^<html lang="en"^>
echo ^<head^>
echo     ^<meta charset="UTF-8"^>
echo     ^<meta name="viewport" content="width=device-width, initial-scale=1.0"^>
echo     ^<title^>🚀 %PROJECT_NAME%^</title^>
echo     ^<style^>
echo         body { font-family: Arial, sans-serif; margin: 0; padding: 20px; background: linear-gradient(135deg, #667eea 0%%, #764ba2 100%%); color: white; }
echo         .container { max-width: 800px; margin: 0 auto; background: rgba(255,255,255,0.1); padding: 30px; border-radius: 15px; backdrop-filter: blur(10px); }
echo         .status { padding: 5px 10px; border-radius: 20px; font-size: 12px; font-weight: bold; background: #4CAF50; }
echo     ^</style^>
echo ^</head^>
echo ^<body^>
echo     ^<div class="container"^>
echo         ^<h1^>🚀 %PROJECT_NAME%^</h1^>
echo         ^<p^>Project successfully created and running!^</p^>
echo         ^<span class="status"^>ACTIVE^</span^>
echo         
echo         ^<h3^>📊 Project Info^</h3^>
echo         ^<p^>^<strong^>PHP Version:^</strong^> ^<?= PHP_VERSION ?^>^</p^>
echo         ^<p^>^<strong^>Database:^</strong^> %DB_TYPE% (%DB_NAME%^)^</p^>
echo         ^<p^>^<strong^>Port:^</strong^> %PORT%^</p^>
echo         ^<p^>^<strong^>Xdebug:^</strong^> %XDEBUG_PORT%^</p^>
echo         
echo         ^<h3^>🔗 Quick Links^</h3^>
echo         ^<p^>^<a href="/phpinfo.php" style="color: white;"^>PHP Info^</a^> ^| ^<a href="http://localhost:8010" style="color: white;"^>Main Dashboard^</a^>^</p^>
echo     ^</div^>
echo ^</body^>
echo ^</html^>
) > "projects\%PROJECT_NAME%\index.php"

echo ✅ Sample index.php created

echo.
echo 🚀 Step 7: Starting container...

docker-compose -f "platforms\%PROJECT_NAME%\docker-compose.%PROJECT_NAME%.yml" up -d

echo ✅ Container started

echo.
echo 🔄 Step 8: Reloading Nginx...

docker exec nginx_proxy_low_ram nginx -s reload 2>nul
if not errorlevel 1 (
    echo ✅ Nginx reloaded
) else (
    echo ⚠️ Nginx reload failed, but container is accessible via direct port
)

echo.
echo 🎉 PROJECT SETUP COMPLETED!
echo ================================================================
echo.
echo ✅ Project Details:
echo   • Name: %PROJECT_NAME%
echo   • PHP: %PHP_VERSION%
echo   • Database: %DB_TYPE% (%DB_NAME%)
echo   • Port: %PORT%
echo   • Xdebug: %XDEBUG_PORT%
echo.
echo 🌐 Access URLs:
echo   • Direct: http://localhost:%PORT%
echo   • Domain: http://%PROJECT_NAME%.asmo-tranding.io
echo.
echo 🛠️ Development:
echo   • Edit files in: projects\%PROJECT_NAME%\
echo   • Container name: %PROJECT_NAME%_php%PHP_VERSION%
echo   • Database: %DB_NAME%
echo.
echo 🚀 Opening browser...
start http://localhost:%PORT%

echo.
pause
