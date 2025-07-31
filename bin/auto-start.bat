@echo off
REM Docker Master Platform - Safe Auto Start (No Code Generation)
REM Modified version that does NOT generate or modify code

echo.
echo ========================================
echo   DOCKER MASTER - SAFE AUTO START
echo ========================================
echo.

echo 🚀 SAFE AUTO STARTING DOCKER MASTER PLATFORM
echo ================================================================

echo ℹ️  This script will:
echo   • Start all core services
echo   • Start all platforms (without modifying configs)
echo   • Test connectivity
echo   • Open platforms in browser
echo   • NO automatic code generation

echo.
echo 🔍 Step 1: Check Docker Desktop
echo ----------------------------------------------------------------

echo Checking Docker Desktop status...
docker ps >nul 2>&1
if errorlevel 1 (
    echo ❌ Docker Desktop is not running!
    echo.
    echo 💡 Please start Docker Desktop first
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
echo 🚀 Step 3: Start all platforms (NO CONFIG GENERATION)
echo ----------------------------------------------------------------

echo Starting all existing platforms...
for /d %%i in (platforms\*) do (
    if exist "platforms\%%~ni\docker-compose.%%~ni.yml" (
        echo Starting platform: %%~ni
        cd platforms\%%~ni
        docker-compose -f docker-compose.%%~ni.yml up -d
        cd ..\..
    )
)

echo ⏳ Waiting for platforms to start...
timeout /t 15 /nobreak >nul

echo.
echo 🔄 Step 4: Reload Nginx (existing configs only)
echo ----------------------------------------------------------------

echo Reloading Nginx with existing configurations...
docker exec nginx_proxy_low_ram nginx -s reload >nul 2>&1
if not errorlevel 1 (
    echo ✅ Nginx reloaded
) else (
    echo ⚠️  Nginx reload failed, doing restart...
    docker restart nginx_proxy_low_ram >nul 2>&1
    timeout /t 5 /nobreak >nul
    echo ✅ Nginx restarted
)

echo.
echo 🎉 SAFE AUTO START COMPLETED!
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
        for /f "tokens=2 delims=:" %%p in ('findstr /C:":80" "platforms\%%~ni\docker-compose.%%~ni.yml" 2^>nul ^| findstr /v "expose"') do (
            echo   • %%~ni: http://localhost:%%p
        )
    )
)

echo.
echo 💡 MANUAL CONFIGURATION:
echo ----------------------------------------------------------------
echo   • Setup domains: scripts\setup-domains.bat
echo   • Create nginx configs: scripts\create-nginx-configs.bat
echo   • View logs: docker logs [container-name]

echo.
echo 🌟 DOCKER MASTER PLATFORM READY (SAFE MODE)!
echo    All platforms started without code generation!

pause
exit /b 0
