@echo off
REM ========================================
REM   Docker Master Platform - STATUS CHECK
REM   Kiểm tra trạng thái nhanh
REM ========================================

echo.
echo ========================================
echo   📊 STATUS - Docker Master Platform
echo ========================================
echo.

REM Check Docker
echo 🔍 Docker Status:
docker version >nul 2>&1
if errorlevel 1 (
    echo ❌ Docker is not running
) else (
    echo ✅ Docker is running
)
echo.

REM Show running containers
echo 🐳 Running Containers:
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
echo.

REM Show RAM usage
echo 💾 RAM Usage:
docker stats --format "table {{.Container}}\t{{.MemUsage}}\t{{.MemPerc}}" --no-stream
echo.

REM Check services
echo 🌐 Service Status:
echo ================================================================

REM Check each service
powershell -Command "try { $response = Invoke-WebRequest -Uri http://localhost:8010 -UseBasicParsing -TimeoutSec 3; if($response.StatusCode -eq 200) { Write-Host '✅ Laravel PHP 8.4: http://localhost:8010' } } catch { Write-Host '❌ Laravel PHP 8.4: Not responding' }"

powershell -Command "try { $response = Invoke-WebRequest -Uri http://localhost:8011 -UseBasicParsing -TimeoutSec 3; if($response.StatusCode -eq 200) { Write-Host '✅ Laravel PHP 7.4: http://localhost:8011' } } catch { Write-Host '❌ Laravel PHP 7.4: Not responding' }"

powershell -Command "try { $response = Invoke-WebRequest -Uri http://localhost:8012 -UseBasicParsing -TimeoutSec 3; if($response.StatusCode -eq 200) { Write-Host '✅ WordPress: http://localhost:8012' } } catch { Write-Host '❌ WordPress: Not responding' }"

powershell -Command "try { $response = Invoke-WebRequest -Uri http://localhost:8080 -UseBasicParsing -TimeoutSec 3; if($response.StatusCode -eq 200) { Write-Host '✅ phpMyAdmin: http://localhost:8080' } } catch { Write-Host '❌ phpMyAdmin: Not responding' }"

powershell -Command "try { $response = Invoke-WebRequest -Uri http://localhost:8081 -UseBasicParsing -TimeoutSec 3; if($response.StatusCode -eq 200) { Write-Host '✅ pgAdmin: http://localhost:8081' } } catch { Write-Host '❌ pgAdmin: Not responding' }"

powershell -Command "try { $response = Invoke-WebRequest -Uri http://localhost:8090 -UseBasicParsing -TimeoutSec 3; if($response.StatusCode -eq 200) { Write-Host '✅ RAM Dashboard: http://localhost:8090' } } catch { Write-Host '❌ RAM Dashboard: Not responding' }"

echo.
echo 🗄️ Database Status:
docker exec postgres_server pg_isready -U postgres_user 2>nul && echo ✅ PostgreSQL: Ready || echo ❌ PostgreSQL: Not ready
docker exec mysql_server mysqladmin ping -u root -prootpassword123 2>nul && echo ✅ MySQL: Ready || echo ❌ MySQL: Not ready
docker exec redis_server redis-cli ping 2>nul && echo ✅ Redis: Ready || echo ❌ Redis: Not ready

echo.
echo 💡 Quick Commands:
echo    • Start all:    bin\start.bat
echo    • Stop all:     bin\stop.bat
echo    • Restart all:  bin\restart.bat
echo    • Monitor RAM:  scripts\monitor-ram.bat
echo.
echo 🚨 Troubleshooting:
echo    • Database issues: scripts\fix-database-corruption.bat
echo    • Full guide: TROUBLESHOOTING.md
echo.
pause
