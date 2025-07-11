@echo off
REM Docker Master Platform - Clean Rebuild All
REM Xóa tất cả images và containers, sau đó rebuild từ đầu

setlocal enabledelayedexpansion

echo.
echo ========================================
echo   Docker Master - CLEAN REBUILD ALL
echo ========================================
echo.

echo ⚠️  WARNING: This will remove ALL Docker data!
echo ================================================================
echo 🗑️  What will be removed:
echo    • ALL containers (running and stopped)
echo    • ALL images (including base images)
echo    • ALL volumes (including data!)
echo    • ALL networks
echo    • ALL build cache
echo.
echo 💾 Current Docker usage:
docker system df
echo.

set /p confirm="Are you ABSOLUTELY sure? Type 'YES' to continue: "
if not "%confirm%"=="YES" (
    echo ❌ Operation cancelled.
    goto :end
)

echo.
echo 🧹 Starting complete cleanup...
echo ================================================================

echo [1/8] 🛑 Stopping all containers...
for /f "tokens=1" %%i in ('docker ps -aq') do (
    echo Stopping container %%i...
    docker stop %%i >nul 2>&1
)

echo [2/8] 📦 Removing all containers...
for /f "tokens=1" %%i in ('docker ps -aq') do (
    echo Removing container %%i...
    docker rm -f %%i >nul 2>&1
)

echo [3/8] 🖼️  Removing all images...
for /f "tokens=3" %%i in ('docker images -aq') do (
    echo Removing image %%i...
    docker rmi -f %%i >nul 2>&1
)

echo [4/8] 💾 Removing all volumes...
for /f "tokens=1" %%i in ('docker volume ls -q') do (
    echo Removing volume %%i...
    docker volume rm -f %%i >nul 2>&1
)

echo [5/8] 🌐 Removing all networks...
for /f "tokens=1" %%i in ('docker network ls -q') do (
    if not "%%i"=="bridge" if not "%%i"=="host" if not "%%i"=="none" (
        echo Removing network %%i...
        docker network rm %%i >nul 2>&1
    )
)

echo [6/8] 🧹 System prune...
docker system prune -a -f --volumes >nul 2>&1

echo [7/8] 🗂️  Cleaning build cache...
docker builder prune -a -f >nul 2>&1

echo [8/8] 📁 Cleaning project data...
if exist "data" (
    echo Removing data directory...
    rmdir /s /q "data" 2>nul
)
if exist "logs" (
    echo Cleaning logs directory...
    del /f /q "logs\*" 2>nul
)

echo.
echo ✅ Complete cleanup finished!
echo ================================================================

echo 📊 After cleanup:
docker system df
echo.

echo 🚀 Starting fresh rebuild...
echo ================================================================

echo 📝 Creating fresh data directories...
mkdir data\postgres 2>nul
mkdir data\redis 2>nul
mkdir logs\apache 2>nul
mkdir logs\apache\laravel-php84 2>nul
mkdir logs\apache\laravel-php74 2>nul
mkdir logs\apache\wordpress-php74 2>nul

echo 🏗️  Building fresh images...
echo This may take 5-10 minutes...

REM Build with low-RAM configuration
docker-compose -f docker-compose.low-ram.yml build --no-cache

if errorlevel 1 (
    echo ❌ Build failed! Check the error messages above.
    echo.
    echo 🔧 Troubleshooting tips:
    echo    • Check internet connection
    echo    • Ensure Docker has enough disk space
    echo    • Try: docker system prune -a -f
    echo    • Restart Docker Desktop
    pause
    goto :end
)

echo 🚀 Starting fresh services...
docker-compose -f docker-compose.low-ram.yml up -d

if errorlevel 1 (
    echo ❌ Failed to start services!
    pause
    goto :end
)

echo ⏳ Waiting for services to initialize...
timeout /t 30 /nobreak >nul

echo.
echo 🗄️ Setting up databases...
echo ================================================================

echo 📋 Creating databases...
docker exec postgres_low_ram psql -U postgres_user -d postgres -c "CREATE DATABASE laravel_php84_psql;" 2>nul
docker exec postgres_low_ram psql -U postgres_user -d postgres -c "CREATE DATABASE laravel_php74_psql;" 2>nul
docker exec postgres_low_ram psql -U postgres_user -d postgres -c "CREATE DATABASE wordpress_php74;" 2>nul

echo ✅ Databases created!

echo.
echo 🧪 Testing all services...
echo ================================================================

echo ⏳ Waiting for health checks...
timeout /t 20 /nobreak >nul

echo 🔍 Testing Laravel PHP 8.4 (Port 8010)...
powershell -Command "try { $r = Invoke-WebRequest -Uri 'http://localhost:8010' -TimeoutSec 10 -UseBasicParsing; if ($r.StatusCode -eq 200) { Write-Host '✅ Laravel PHP 8.4: WORKING' -ForegroundColor Green } else { Write-Host '❌ Laravel PHP 8.4: HTTP' $r.StatusCode -ForegroundColor Red } } catch { Write-Host '⚠️  Laravel PHP 8.4: Still starting...' -ForegroundColor Yellow }"

echo 🔍 Testing WordPress PHP 7.4 (Port 8030)...
powershell -Command "try { $r = Invoke-WebRequest -Uri 'http://localhost:8030' -TimeoutSec 10 -UseBasicParsing; if ($r.StatusCode -eq 200) { Write-Host '✅ WordPress PHP 7.4: WORKING' -ForegroundColor Green } else { Write-Host '❌ WordPress PHP 7.4: HTTP' $r.StatusCode -ForegroundColor Red } } catch { Write-Host '⚠️  WordPress PHP 7.4: Still starting...' -ForegroundColor Yellow }"

echo 🔍 Testing Mailhog (Port 8025)...
powershell -Command "try { $r = Invoke-WebRequest -Uri 'http://localhost:8025' -TimeoutSec 10 -UseBasicParsing; if ($r.StatusCode -eq 200) { Write-Host '✅ Mailhog: WORKING' -ForegroundColor Green } else { Write-Host '❌ Mailhog: HTTP' $r.StatusCode -ForegroundColor Red } } catch { Write-Host '⚠️  Mailhog: Still starting...' -ForegroundColor Yellow }"

echo.
echo 🎉 FRESH REBUILD COMPLETED!
echo ================================================================

echo 📊 Final Status:
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"

echo.
echo 💾 Memory Usage:
docker stats --no-stream --format "table {{.Container}}\t{{.MemUsage}}\t{{.MemPerc}}" 2>nul

echo.
echo 🗄️ Disk Usage:
docker system df

echo.
echo 🌐 Available Services:
echo ================================================================
echo ✅ Laravel PHP 8.4:    http://localhost:8010
echo ✅ WordPress PHP 7.4:   http://localhost:8030
echo ✅ Mailhog:             http://localhost:8025
echo ✅ PostgreSQL:          localhost:5432
echo ✅ Redis:               localhost:6379

echo.
echo 💡 Next Steps:
echo    • Test all URLs above
echo    • Check database connections
echo    • Run: scripts\final-status.bat for detailed report
echo    • If issues: docker-compose -f docker-compose.low-ram.yml logs

:end
echo.
echo Press any key to exit...
pause >nul
