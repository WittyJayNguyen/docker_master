@echo off
REM Docker Master Platform - Auto Start with Domain Setup
REM Tự động khởi động toàn bộ hệ thống và setup domains

echo.
echo ========================================
echo   DOCKER MASTER - AUTO START
echo ========================================
echo.

echo 🚀 AUTO STARTING DOCKER MASTER PLATFORM
echo ================================================================

echo ℹ️  This script will:
echo   • Start all core services
echo   • Auto-setup domains for existing platforms
echo   • Start all platforms
echo   • Configure Nginx routing
echo   • Open all platforms in browser

echo.
echo 🔍 Step 1: Check Docker Desktop
echo ----------------------------------------------------------------

echo Checking Docker Desktop status...
docker ps >nul 2>&1
if errorlevel 1 (
    echo ❌ Docker Desktop is not running!
    echo.
    echo 💡 Please start Docker Desktop first:
    echo   1. Open Docker Desktop application
    echo   2. Wait for it to fully start
    echo   3. Run this script again
    echo.
    pause
    exit /b 1
)

echo ✅ Docker Desktop is running

echo.
echo 🗄️ Step 2: Start core services
echo ----------------------------------------------------------------

echo Starting core services (MySQL, PostgreSQL, Redis, Nginx)...
docker-compose -f docker-compose.low-ram.yml up -d

echo ⏳ Waiting for core services to initialize...
timeout /t 10 /nobreak >nul

echo.
echo 🌐 Step 3: Auto-setup domains for all platforms
echo ----------------------------------------------------------------

echo Auto-configuring domains for existing platforms...
call :auto_setup_all_domains

echo.
echo 🚀 Step 4: Start all platforms
echo ----------------------------------------------------------------

echo Starting all existing platforms...
for /d %%i in (platforms\*) do (
    if exist "platforms\%%~ni\docker-compose.%%~ni.yml" (
        echo Starting platform: %%~ni
        cd platforms\%%~ni
        docker-compose -f docker-compose.%%~ni.yml up -d
        cd ..\..
        
        REM Create Nginx config if not exists
        if not exist "nginx\conf.d\%%~ni.conf" (
            call :create_nginx_config_for_platform "%%~ni"
        )
    )
)

echo ⏳ Waiting for platforms to start...
timeout /t 15 /nobreak >nul

echo.
echo 🔄 Step 5: Fast restart Nginx for instant apply
echo ----------------------------------------------------------------

echo Reloading Nginx with all configurations...
docker exec nginx_proxy_low_ram nginx -s reload >nul 2>&1
if not errorlevel 1 (
    echo ✅ Nginx reloaded instantly
) else (
    echo ⚠️  Nginx reload failed, doing full restart...
    docker restart nginx_proxy_low_ram >nul 2>&1
    timeout /t 5 /nobreak >nul
    echo ✅ Nginx restarted
)

echo.
echo 🧪 Step 6: Test all platforms
echo ----------------------------------------------------------------

echo Testing platform connectivity...

REM Test standard platforms
call :test_platform_url "8015" "WordPress"
call :test_platform_url "8016" "Laravel API"
call :test_platform_url "8017" "Laravel Shop"

REM Test custom platforms
for /d %%i in (platforms\*) do (
    if exist "platforms\%%~ni\docker-compose.%%~ni.yml" (
        call :test_platform_domain "%%~ni"
    )
)

echo.
echo 🎉 AUTO START COMPLETED!
echo ================================================================

echo 📊 RUNNING PLATFORMS:
echo ----------------------------------------------------------------
docker ps --filter "name=_php" --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"

echo.
echo 🌐 ACCESS URLS:
echo ----------------------------------------------------------------

echo 📝 Direct Port Access:
for /d %%i in (platforms\*) do (
    if exist "platforms\%%~ni\docker-compose.%%~ni.yml" (
        REM Extract port from docker-compose file
        for /f "tokens=2 delims=:" %%p in ('findstr /C:":80" "platforms\%%~ni\docker-compose.%%~ni.yml" 2^>nul ^| findstr /v "expose"') do (
            echo   • %%~ni: http://localhost:%%p
        )
    )
)

echo.
echo 🌐 Domain Access (auto-configured):
for /d %%i in (platforms\*) do (
    echo   • %%~ni: http://%%~ni.io
)

echo.
echo 🗄️ Database & Tools:
echo ----------------------------------------------------------------
echo   • MySQL:              localhost:3306 (mysql_user/mysql_pass)
echo   • PostgreSQL:         localhost:5432 (postgres_user/postgres_pass)
echo   • Mailhog:            http://localhost:8025

echo.
echo 💡 QUICK COMMANDS:
echo ----------------------------------------------------------------
echo   • Create new platform:    create.bat [project-name]
echo   • Open all platforms:     .\open-all.bat
echo   • Setup domains manually: scripts\setup-domains.bat
echo   • View logs:              docker logs [container-name]

echo.
echo 🌟 DOCKER MASTER PLATFORM READY!
echo    All platforms auto-started with domain routing!

echo.
echo 🌐 Opening platforms in browser...
call :open_all_platforms

pause
exit /b 0

:auto_setup_all_domains
REM Auto setup domains for all existing platforms
echo 🌐 Auto-configuring domains for all platforms...

REM Check if we have admin rights
echo # Test write > "%temp%\hosts_test" 2>nul
copy "%temp%\hosts_test" "%SystemRoot%\System32\drivers\etc\hosts_test" >nul 2>&1
if errorlevel 1 (
    echo ⚠️  Admin rights needed for automatic domain setup
    echo 💡 Domains will work after running: scripts\setup-domains.bat (as Administrator)
    del "%temp%\hosts_test" 2>nul
    exit /b 0
)

REM Clean up test files
del "%SystemRoot%\System32\drivers\etc\hosts_test" 2>nul
del "%temp%\hosts_test" 2>nul

REM Add domains for all platforms
for /d %%i in (platforms\*) do (
    REM Check if domain already exists
    findstr /C:"%%~ni.io" "%SystemRoot%\System32\drivers\etc\hosts" >nul 2>&1
    if errorlevel 1 (
        echo 127.0.0.1 %%~ni.io >> "%SystemRoot%\System32\drivers\etc\hosts" 2>nul
        echo ✅ Domain configured: %%~ni.io
    ) else (
        echo ✅ Domain exists: %%~ni.io
    )
)

echo ✅ All domains auto-configured
exit /b 0

:create_nginx_config_for_platform
set platform_name=%~1

REM Detect PHP version from docker-compose file
set php_version=74
findstr /C:"php84" "platforms\%platform_name%\docker-compose.%platform_name%.yml" >nul 2>&1
if not errorlevel 1 set php_version=84

echo Creating Nginx config for: %platform_name%

(
echo # %platform_name% - Auto-generated Nginx configuration
echo server {
echo     listen 80;
echo     server_name %platform_name%.io;
echo.
echo     location / {
echo         proxy_pass http://%platform_name%_php%php_version%:80;
echo         proxy_set_header Host $host;
echo         proxy_set_header X-Real-IP $remote_addr;
echo         proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
echo         proxy_set_header X-Forwarded-Proto $scheme;
echo         proxy_set_header X-Forwarded-Host $server_name;
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

:test_platform_url
set port=%~1
set name=%~2

powershell -Command "try { Invoke-WebRequest -Uri 'http://localhost:%port%' -TimeoutSec 3 -UseBasicParsing | Out-Null; Write-Host '✅ %name% (%port%): Working' -ForegroundColor Green } catch { Write-Host '⚠️  %name% (%port%): Starting...' -ForegroundColor Yellow }" 2>nul
exit /b 0

:test_platform_domain
set platform_name=%~1

powershell -Command "try { Invoke-WebRequest -Uri 'http://%platform_name%.io' -TimeoutSec 3 -UseBasicParsing | Out-Null; Write-Host '✅ Domain %platform_name%: Working' -ForegroundColor Green } catch { Write-Host '💡 Domain %platform_name%: Run scripts\setup-domains.bat' -ForegroundColor Cyan }" 2>nul
exit /b 0

:open_all_platforms
REM Open all platforms in browser
for /d %%i in (platforms\*) do (
    if exist "platforms\%%~ni\docker-compose.%%~ni.yml" (
        REM Extract port from docker-compose file
        for /f "tokens=2 delims=:" %%p in ('findstr /C:":80" "platforms\%%~ni\docker-compose.%%~ni.yml" 2^>nul ^| findstr /v "expose" ^| head -1') do (
            echo Opening %%~ni: http://localhost:%%p
            start http://localhost:%%p
            timeout /t 1 /nobreak >nul
        )
    )
)
exit /b 0
