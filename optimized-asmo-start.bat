@echo off
REM Optimized ASMO Food Service - Single Platform Start
REM Tối ưu hóa chỉ cho dự án ASMO Food Service

echo.
echo ========================================
echo   ASMO FOOD SERVICE - OPTIMIZED START
echo ========================================
echo.

echo 🍕 STARTING ASMO FOOD SERVICE PLATFORM
echo ================================================================

echo ℹ️  Optimized for single platform:
echo   • Only ASMO Food Service platform
echo   • Minimal resource usage
echo   • Fast startup time
echo   • Clean environment

echo.
echo 🔍 Step 1: Check Docker Desktop
echo ----------------------------------------------------------------

echo Checking Docker Desktop status...
docker ps >nul 2>&1
if errorlevel 1 (
    echo ❌ Docker Desktop is not running!
    echo.
    echo 💡 Please start Docker Desktop first and try again.
    echo.
    pause
    exit /b 1
)

echo ✅ Docker Desktop is running

echo.
echo 🗄️ Step 2: Start core services
echo ----------------------------------------------------------------

echo Starting optimized core services...
docker-compose -f docker-compose.low-ram.yml up -d

echo ⏳ Waiting for core services...
timeout /t 8 /nobreak >nul

echo.
echo 🍕 Step 3: Start ASMO Food Service
echo ----------------------------------------------------------------

echo Starting ASMO Food Service platform...
cd platforms\asmo-foodservice
docker-compose -f docker-compose.asmo-foodservice.yml up -d
cd ..\..

echo ⏳ Waiting for platform to start...
timeout /t 10 /nobreak >nul

echo.
echo 🔄 Step 4: Fast system check
echo ----------------------------------------------------------------

echo Testing platform connectivity...
powershell -Command "try { Invoke-WebRequest -Uri 'http://localhost:8090' -TimeoutSec 5 -UseBasicParsing | Out-Null; Write-Host '✅ Platform ready: http://localhost:8090' -ForegroundColor Green } catch { Write-Host '⚠️  Platform starting...' -ForegroundColor Yellow }" 2>nul

echo.
echo 🎉 ASMO FOOD SERVICE READY!
echo ================================================================

echo 📊 PLATFORM STATUS:
echo ----------------------------------------------------------------
docker ps --filter "name=asmo-foodservice" --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"

echo.
echo 🌐 ACCESS URLS:
echo ----------------------------------------------------------------
echo   • Direct Access:    http://localhost:8090
echo   • Domain Access:    http://asmo-foodservice.io
echo   • Your Project:     http://localhost:8090/[your-files]

echo.
echo 🗄️ DATABASE INFO:
echo ----------------------------------------------------------------
echo   • MySQL:            localhost:3306
echo   • Database:         asmo_foodservice_db
echo   • Username:         mysql_user
echo   • Password:         mysql_pass

echo.
echo 🐛 DEBUG INFO:
echo ----------------------------------------------------------------
echo   • Xdebug Port:      9090
echo   • PHP Version:      7.4
echo   • Platform:         WordPress/PHP

echo.
echo 💡 QUICK TIPS:
echo ================================================================
echo   • Add your project files to: projects\asmo-foodservice\wordpress\
echo   • Files appear instantly (no restart needed)
echo   • Access via: http://localhost:8090/your-file.php
echo   • For domain access, run: scripts\setup-domains.bat (as Admin)

echo.
echo 🌟 OPTIMIZED ASMO PLATFORM READY!
echo    Single platform, maximum performance!

echo.
echo 🌐 Opening platform...
start http://localhost:8090

pause
