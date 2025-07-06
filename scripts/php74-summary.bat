@echo off
REM Docker Master Platform - PHP 7.4 Summary
REM Tổng kết tất cả services PHP 7.4 đang chạy

echo.
echo ========================================
echo   Docker Master - PHP 7.4 Summary
echo ========================================
echo.

echo 📊 Current System Status:
echo ================================================================

echo 🐳 Docker Containers:
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
echo.

echo 💾 Memory Usage:
docker stats --no-stream --format "table {{.Container}}\t{{.MemUsage}}\t{{.MemPerc}}" 2>nul
echo.

echo 🗄️ Disk Usage:
docker system df
echo.

echo 🌐 PHP 7.4 Services Available:
echo ================================================================

REM Check WordPress PHP 7.4
echo 🔍 Testing WordPress PHP 7.4 (Port 8030)...
powershell -Command "try { $response = Invoke-WebRequest -Uri 'http://localhost:8030' -TimeoutSec 5 -UseBasicParsing; if ($response.StatusCode -eq 200) { Write-Host '✅ WordPress PHP 7.4: http://localhost:8030 - WORKING' -ForegroundColor Green } else { Write-Host '❌ WordPress PHP 7.4: HTTP' $response.StatusCode -ForegroundColor Red } } catch { Write-Host '❌ WordPress PHP 7.4: Connection failed' -ForegroundColor Red }"

REM Check Laravel PHP 7.4 (if running)
echo 🔍 Testing Laravel PHP 7.4 (Port 8020)...
powershell -Command "try { $response = Invoke-WebRequest -Uri 'http://localhost:8020' -TimeoutSec 5 -UseBasicParsing; if ($response.StatusCode -eq 200) { Write-Host '✅ Laravel PHP 7.4: http://localhost:8020 - WORKING' -ForegroundColor Green } else { Write-Host '❌ Laravel PHP 7.4: HTTP' $response.StatusCode -ForegroundColor Red } } catch { Write-Host '❌ Laravel PHP 7.4: Not running (Port 8020)' -ForegroundColor Yellow }"

echo.
echo 🌐 Other Services:
echo ================================================================

REM Check Laravel PHP 8.4
echo 🔍 Testing Laravel PHP 8.4 (Port 8010)...
powershell -Command "try { $response = Invoke-WebRequest -Uri 'http://localhost:8010' -TimeoutSec 5 -UseBasicParsing; if ($response.StatusCode -eq 200) { Write-Host '✅ Laravel PHP 8.4: http://localhost:8010 - WORKING' -ForegroundColor Green } else { Write-Host '❌ Laravel PHP 8.4: HTTP' $response.StatusCode -ForegroundColor Red } } catch { Write-Host '❌ Laravel PHP 8.4: Connection failed' -ForegroundColor Red }"

REM Check Mailhog
echo 🔍 Testing Mailhog (Port 8025)...
powershell -Command "try { $response = Invoke-WebRequest -Uri 'http://localhost:8025' -TimeoutSec 5 -UseBasicParsing; if ($response.StatusCode -eq 200) { Write-Host '✅ Mailhog: http://localhost:8025 - WORKING' -ForegroundColor Green } else { Write-Host '❌ Mailhog: HTTP' $response.StatusCode -ForegroundColor Red } } catch { Write-Host '❌ Mailhog: Connection failed' -ForegroundColor Red }"

REM Check PostgreSQL
echo 🔍 Testing PostgreSQL (Port 5432)...
docker exec postgres_low_ram pg_isready -U postgres_user >nul 2>&1
if errorlevel 1 (
    echo ❌ PostgreSQL: localhost:5432 - NOT READY
) else (
    echo ✅ PostgreSQL: localhost:5432 - READY
)

REM Check Redis
echo 🔍 Testing Redis (Port 6379)...
docker exec redis_low_ram redis-cli ping >nul 2>&1
if errorlevel 1 (
    echo ❌ Redis: localhost:6379 - NOT READY
) else (
    echo ✅ Redis: localhost:6379 - READY
)

echo.
echo 📋 SUMMARY REPORT:
echo ================================================================

echo 🎯 PHP 7.4 Services:
echo    • WordPress PHP 7.4: http://localhost:8030 (Port 8030)
echo    • Laravel PHP 7.4: http://localhost:8020 (Port 8020) - Optional

echo.
echo 🎯 Other Services:
echo    • Laravel PHP 8.4: http://localhost:8010 (Port 8010)
echo    • Mailhog: http://localhost:8025 (Port 8025)
echo    • PostgreSQL: localhost:5432
echo    • Redis: localhost:6379

echo.
echo 💾 Resource Usage Summary:
for /f "tokens=2,4" %%a in ('docker stats --no-stream --format "{{.MemUsage}} {{.Container}}" ^| findstr -v "MEM"') do (
    echo    • %%b: %%a
)

echo.
echo 🔧 Quick Actions:
echo ================================================================
echo • Open WordPress: start http://localhost:8030
echo • Open Laravel 8.4: start http://localhost:8010
echo • Open Mailhog: start http://localhost:8025
echo • View all logs: docker-compose -f docker-compose.low-ram.yml logs
echo • Restart all: docker-compose -f docker-compose.low-ram.yml restart
echo • Stop all: docker-compose -f docker-compose.low-ram.yml down

echo.
echo 📝 Configuration Details:
echo ================================================================
echo • Total RAM Usage: ~159MB (5 main containers)
echo • Database: PostgreSQL (shared by all services)
echo • No MySQL (removed to save RAM)
echo • All services optimized for low memory usage
echo • WordPress uses PostgreSQL instead of MySQL

echo.
echo 💡 Tips:
echo    • WordPress may need PostgreSQL plugin for full compatibility
echo    • All services share the same PostgreSQL database server
echo    • Use docker stats to monitor real-time resource usage
echo    • Run scripts\one-click-optimize.bat weekly for maintenance

echo.
pause
