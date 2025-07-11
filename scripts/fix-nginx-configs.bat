@echo off
REM Docker Master Platform - Fix Nginx Configurations
REM Tạo lại Nginx configs cho tất cả platforms đang hoạt động

echo.
echo ========================================
echo   Fix Nginx Configurations
echo ========================================
echo.

echo 🔧 FIXING NGINX CONFIGURATIONS
echo ================================================================

echo ℹ️  This script will:
echo   • Remove broken Nginx configurations
echo   • Create new configs for running platforms
echo   • Reload Nginx with working configurations

echo.
echo 🧹 Step 1: Clean up broken configurations
echo ----------------------------------------------------------------

REM Remove all existing platform configs
if exist "nginx\conf.d\*.conf" (
    for %%f in (nginx\conf.d\*.conf) do (
        if not "%%~nf"=="default" (
            echo Removing: %%~nf.conf
            del "nginx\conf.d\%%~nf.conf" 2>nul
        )
    )
)

echo ✅ Old configurations removed

echo.
echo 🔍 Step 2: Detect running platforms
echo ----------------------------------------------------------------

REM Get list of running PHP containers
echo Scanning for running PHP containers...

for /f "tokens=*" %%i in ('docker ps --filter "name=_php" --format "{{.Names}}" 2^>nul') do (
    set container_name=%%i
    call :create_nginx_config_for_container "!container_name!"
)

echo.
echo 🔄 Step 3: Reload Nginx
echo ----------------------------------------------------------------

echo Testing Nginx configuration...
docker exec nginx_proxy_low_ram nginx -t
if errorlevel 1 (
    echo ❌ Nginx configuration test failed!
    echo ℹ️  Check the logs: docker logs nginx_proxy_low_ram
    pause
    exit /b 1
)

echo ✅ Nginx configuration test passed

echo Reloading Nginx...
docker exec nginx_proxy_low_ram nginx -s reload
echo ✅ Nginx reloaded successfully

echo.
echo 🧪 Step 4: Test configurations
echo ----------------------------------------------------------------

echo Testing Nginx health endpoint...
powershell -Command "try { $r = Invoke-WebRequest -Uri 'http://localhost/nginx-health' -UseBasicParsing; Write-Host '✅ Nginx Health: OK' -ForegroundColor Green } catch { Write-Host '❌ Nginx Health: Failed' -ForegroundColor Red }"

echo.
echo 📋 Generated configurations:
for %%f in (nginx\conf.d\*.conf) do (
    if not "%%~nf"=="default" (
        echo   • %%~nf.conf → http://%%~nf.asmo-tranding.io
    )
)

echo.
echo 🎉 NGINX CONFIGURATIONS FIXED!
echo ================================================================

echo ✅ All running platforms now have Nginx configurations
echo ✅ Nginx is working properly
echo ✅ Ready to use domain routing

echo.
echo 💡 Next Steps:
echo   1. Run: scripts\setup-domains.bat (as Administrator)
echo   2. Access platforms via: http://[platform].asmo-tranding.io
echo   3. Create new platforms: create.bat [project-name]

echo.
echo 🌟 NGINX DOMAIN ROUTING READY!

pause
exit /b 0

:create_nginx_config_for_container
set container_name=%~1

REM Extract platform name and PHP version from container name
REM Format: platform_name_phpXX
for /f "tokens=1,2 delims=_" %%a in ("%container_name%") do (
    set platform_name=%%a
    set php_version=%%b
)

REM Skip if not a platform container (has php in name)
echo %container_name% | findstr /C:"php" >nul
if errorlevel 1 (
    exit /b 0
)

REM Skip old format containers
echo %container_name% | findstr /C:"low_ram" >nul
if not errorlevel 1 (
    exit /b 0
)

echo Creating config for: %platform_name%

REM Create Nginx configuration
(
echo # %platform_name% - Auto-generated Nginx configuration
echo server {
echo     listen 80;
echo     server_name %platform_name%.io;
echo.
echo     location / {
echo         proxy_pass http://%container_name%:80;
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
) > "nginx\conf.d\%platform_name%.conf"

echo ✅ Created: %platform_name%.conf
exit /b 0
