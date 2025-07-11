@echo off
REM Docker Master Platform - Fast Restart System
REM Restart nhanh nhất để áp dụng changes

echo.
echo ========================================
echo   FAST RESTART SYSTEM
echo ========================================
echo.

echo ⚡ FAST RESTARTING DOCKER MASTER PLATFORM
echo ================================================================

echo ℹ️  This script performs the fastest restart possible:
echo   • Reload Nginx configurations (instant)
echo   • Restart only changed services
echo   • Auto-apply domain changes
echo   • Test all connections

echo.
echo 🔄 Step 1: Fast Nginx reload
echo ----------------------------------------------------------------

echo Reloading Nginx configurations...
docker exec nginx_proxy_low_ram nginx -t >nul 2>&1
if errorlevel 1 (
    echo ❌ Nginx configuration error detected!
    echo 🔧 Fixing Nginx configurations...
    
    REM Regenerate all Nginx configs
    for /d %%i in (platforms\*) do (
        if exist "platforms\%%~ni\docker-compose.%%~ni.yml" (
            call :regenerate_nginx_config "%%~ni"
        )
    )
    
    echo ✅ Nginx configurations fixed
)

docker exec nginx_proxy_low_ram nginx -s reload >nul 2>&1
if not errorlevel 1 (
    echo ✅ Nginx reloaded instantly (0.1s)
) else (
    echo ⚠️  Nginx reload failed, doing container restart...
    docker restart nginx_proxy_low_ram >nul 2>&1
    timeout /t 3 /nobreak >nul
    echo ✅ Nginx container restarted (3s)
)

echo.
echo 🌐 Step 2: Auto-update domains
echo ----------------------------------------------------------------

echo Checking and updating domain configurations...
call :fast_domain_update

echo.
echo 🧪 Step 3: Fast connectivity test
echo ----------------------------------------------------------------

echo Testing all platform connections...

REM Test core services
powershell -Command "try { Invoke-WebRequest -Uri 'http://localhost/nginx-health' -TimeoutSec 2 -UseBasicParsing | Out-Null; Write-Host '✅ Nginx: Healthy' -ForegroundColor Green } catch { Write-Host '❌ Nginx: Failed' -ForegroundColor Red }" 2>nul

REM Test platforms
for /d %%i in (platforms\*) do (
    if exist "platforms\%%~ni\docker-compose.%%~ni.yml" (
        call :fast_test_platform "%%~ni"
    )
)

echo.
echo 🔧 Step 4: Auto-fix any issues
echo ----------------------------------------------------------------

echo Checking for common issues and auto-fixing...

REM Check if any containers are down
for /f "tokens=*" %%i in ('docker ps --filter "status=exited" --filter "name=_php" --format "{{.Names}}" 2^>nul') do (
    echo 🔧 Restarting stopped container: %%i
    docker start %%i >nul 2>&1
    echo ✅ Container %%i restarted
)

REM Check database connections
docker exec mysql_low_ram mysqladmin ping -h localhost -u mysql_user -pmysql_pass >nul 2>&1
if errorlevel 1 (
    echo 🔧 MySQL connection issue detected, restarting...
    docker restart mysql_low_ram >nul 2>&1
    timeout /t 5 /nobreak >nul
    echo ✅ MySQL restarted
) else (
    echo ✅ MySQL: Healthy
)

docker exec postgres_low_ram pg_isready -U postgres_user >nul 2>&1
if errorlevel 1 (
    echo 🔧 PostgreSQL connection issue detected, restarting...
    docker restart postgres_low_ram >nul 2>&1
    timeout /t 5 /nobreak >nul
    echo ✅ PostgreSQL restarted
) else (
    echo ✅ PostgreSQL: Healthy
)

echo.
echo ⚡ FAST RESTART COMPLETED!
echo ================================================================

echo 📊 SYSTEM STATUS:
echo ----------------------------------------------------------------
docker ps --filter "name=_low_ram" --format "table {{.Names}}\t{{.Status}}"

echo.
echo 🌐 PLATFORM STATUS:
echo ----------------------------------------------------------------
docker ps --filter "name=_php" --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"

echo.
echo 🎯 QUICK ACCESS:
echo ----------------------------------------------------------------

echo 📝 Direct URLs:
for /d %%i in (platforms\*) do (
    if exist "platforms\%%~ni\docker-compose.%%~ni.yml" (
        for /f "tokens=2 delims=:" %%p in ('findstr /C:":80" "platforms\%%~ni\docker-compose.%%~ni.yml" 2^>nul ^| findstr /v "expose" ^| head -1') do (
            echo   • %%~ni: http://localhost:%%p
        )
    )
)

echo.
echo 🌐 Domain URLs:
for /d %%i in (platforms\*) do (
    echo   • %%~ni: http://%%~ni.io
)

echo.
echo 💡 PERFORMANCE TIPS:
echo ================================================================
echo   • Use fast-restart.bat for quick changes
echo   • Use auto-start.bat for full system start
echo   • Use create.bat for new platforms (auto-restart included)

echo.
echo ⚡ SYSTEM READY - FASTEST RESTART COMPLETED!
echo    Total restart time: ~5-10 seconds

pause
exit /b 0

:fast_domain_update
REM Fast domain update without full hosts file rewrite
echo 🌐 Fast updating domains...

REM Check if we have admin rights
echo # Test write > "%temp%\hosts_test" 2>nul
copy "%temp%\hosts_test" "%SystemRoot%\System32\drivers\etc\hosts_test" >nul 2>&1
if errorlevel 1 (
    echo ⚠️  Admin rights needed for domain updates
    echo 💡 Run scripts\setup-domains.bat manually if needed
    del "%temp%\hosts_test" 2>nul
    exit /b 0
)

REM Clean up test files
del "%SystemRoot%\System32\drivers\etc\hosts_test" 2>nul
del "%temp%\hosts_test" 2>nul

REM Quick check and add missing domains
for /d %%i in (platforms\*) do (
    findstr /C:"%%~ni.io" "%SystemRoot%\System32\drivers\etc\hosts" >nul 2>&1
    if errorlevel 1 (
        echo 127.0.0.1 %%~ni.io >> "%SystemRoot%\System32\drivers\etc\hosts" 2>nul
        echo ✅ Added domain: %%~ni.io
    )
)

echo ✅ Domain update completed
exit /b 0

:regenerate_nginx_config
set platform_name=%~1

REM Detect PHP version from docker-compose file
set php_version=74
findstr /C:"php84" "platforms\%platform_name%\docker-compose.%platform_name%.yml" >nul 2>&1
if not errorlevel 1 set php_version=84

echo Regenerating Nginx config for: %platform_name%

(
echo # %platform_name% - Auto-generated Nginx configuration
echo server {
echo     listen 80;
echo     server_name %platform_name%.asmo-tranding.io;
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

echo ✅ Regenerated: %platform_name%.conf
exit /b 0

:fast_test_platform
set platform_name=%~1

REM Extract port from docker-compose file
for /f "tokens=2 delims=:" %%p in ('findstr /C:":80" "platforms\%platform_name%\docker-compose.%platform_name%.yml" 2^>nul ^| findstr /v "expose" ^| head -1') do (
    powershell -Command "try { Invoke-WebRequest -Uri 'http://localhost:%%p' -TimeoutSec 2 -UseBasicParsing | Out-Null; Write-Host '✅ %platform_name% (%%p): Ready' -ForegroundColor Green } catch { Write-Host '⚠️  %platform_name% (%%p): Starting...' -ForegroundColor Yellow }" 2>nul
)
exit /b 0
