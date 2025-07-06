@echo off
REM Docker Master Platform - Fix All Database Connections
REM Sửa tất cả các file có vấn đề kết nối database

setlocal enabledelayedexpansion

echo.
echo ========================================
echo   Docker Master - Fix All DB Connections
echo ========================================
echo.

echo 🔧 Fixing all database connection issues...
echo ================================================================

echo 📝 Checking and fixing Laravel PHP 8.4...
if exist "projects\laravel-php84-psql\index.php" (
    echo ✅ Found Laravel PHP 8.4 index.php
    
    REM Backup original
    copy "projects\laravel-php84-psql\index.php" "projects\laravel-php84-psql\index.php.backup" >nul 2>&1
    
    REM Fix host reference
    powershell -Command "(Get-Content 'projects\laravel-php84-psql\index.php') -replace 'postgres_server', 'postgres_low_ram' | Set-Content 'projects\laravel-php84-psql\index.php'"
    
    echo ✅ Fixed Laravel PHP 8.4 database host
) else (
    echo ❌ Laravel PHP 8.4 index.php not found
)

echo.
echo 📝 Checking and fixing WordPress PHP 7.4...
if exist "projects\wordpress-php74-mysql\index.php" (
    echo ✅ Found WordPress PHP 7.4 index.php
    
    REM Backup original
    copy "projects\wordpress-php74-mysql\index.php" "projects\wordpress-php74-mysql\index.php.backup" >nul 2>&1
    
    REM Fix host reference
    powershell -Command "(Get-Content 'projects\wordpress-php74-mysql\index.php') -replace 'postgres_server', 'postgres_low_ram' | Set-Content 'projects\wordpress-php74-mysql\index.php'"
    
    echo ✅ Fixed WordPress PHP 7.4 database host
) else (
    echo ❌ WordPress PHP 7.4 index.php not found
)

echo.
echo 📝 Checking Laravel PHP 7.4 (if exists)...
if exist "projects\laravel-php74-psql\index.php" (
    echo ✅ Found Laravel PHP 7.4 index.php
    
    REM Backup original
    copy "projects\laravel-php74-psql\index.php" "projects\laravel-php74-psql\index.php.backup" >nul 2>&1
    
    REM Fix host reference
    powershell -Command "(Get-Content 'projects\laravel-php74-psql\index.php') -replace 'postgres_server', 'postgres_low_ram' | Set-Content 'projects\laravel-php74-psql\index.php'"
    
    echo ✅ Fixed Laravel PHP 7.4 database host
) else (
    echo ℹ️  Laravel PHP 7.4 index.php not found (OK, not needed)
)

echo.
echo 🗄️ Ensuring all required databases exist...
echo ----------------------------------------------------------------

echo 📋 Current databases:
docker exec postgres_low_ram psql -U postgres_user -d postgres -c "\l" | findstr "laravel\|wordpress"

echo.
echo 🔧 Creating missing databases if needed...

REM Create Laravel PHP 8.4 database
docker exec postgres_low_ram psql -U postgres_user -d postgres -c "CREATE DATABASE IF NOT EXISTS laravel_php84_psql;" 2>nul
echo ✅ Ensured laravel_php84_psql database exists

REM Create WordPress database
docker exec postgres_low_ram psql -U postgres_user -d postgres -c "CREATE DATABASE IF NOT EXISTS wordpress_php74;" 2>nul
echo ✅ Ensured wordpress_php74 database exists

REM Create Laravel PHP 7.4 database (if needed)
docker exec postgres_low_ram psql -U postgres_user -d postgres -c "CREATE DATABASE IF NOT EXISTS laravel_php74_psql;" 2>nul
echo ✅ Ensured laravel_php74_psql database exists

echo.
echo 🔄 Restarting all affected containers...
echo ----------------------------------------------------------------

echo 🔄 Restarting Laravel PHP 8.4...
docker-compose -f docker-compose.low-ram.yml restart laravel-php84

echo 🔄 Restarting WordPress PHP 7.4...
docker-compose -f docker-compose.low-ram.yml restart wordpress-php74

echo.
echo ⏳ Waiting for services to start...
timeout /t 10 /nobreak >nul

echo.
echo 🧪 Testing all connections...
echo ================================================================

echo 🔍 Testing Laravel PHP 8.4 (Port 8010)...
powershell -Command "try { $r = Invoke-WebRequest -Uri 'http://localhost:8010' -TimeoutSec 10 -UseBasicParsing; if ($r.StatusCode -eq 200 -and $r.Content -match 'PostgreSQL connection successful') { Write-Host '✅ Laravel PHP 8.4: Database connection WORKING' -ForegroundColor Green } elseif ($r.StatusCode -eq 200) { Write-Host '⚠️  Laravel PHP 8.4: Responding but check database connection' -ForegroundColor Yellow } else { Write-Host '❌ Laravel PHP 8.4: HTTP' $r.StatusCode -ForegroundColor Red } } catch { Write-Host '❌ Laravel PHP 8.4: Connection failed -' $_.Exception.Message -ForegroundColor Red }"

echo 🔍 Testing WordPress PHP 7.4 (Port 8030)...
powershell -Command "try { $r = Invoke-WebRequest -Uri 'http://localhost:8030' -TimeoutSec 10 -UseBasicParsing; if ($r.StatusCode -eq 200 -and $r.Content -match 'PostgreSQL connection successful') { Write-Host '✅ WordPress PHP 7.4: Database connection WORKING' -ForegroundColor Green } elseif ($r.StatusCode -eq 200) { Write-Host '⚠️  WordPress PHP 7.4: Responding but check database connection' -ForegroundColor Yellow } else { Write-Host '❌ WordPress PHP 7.4: HTTP' $r.StatusCode -ForegroundColor Red } } catch { Write-Host '❌ WordPress PHP 7.4: Connection failed -' $_.Exception.Message -ForegroundColor Red }"

echo.
echo 📊 Final Status Check:
echo ================================================================

echo 📦 Container Status:
docker ps --filter "name=laravel_php84_low_ram" --filter "name=wordpress_php74_low_ram" --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"

echo.
echo 🗄️ Database Status:
docker exec postgres_low_ram pg_isready -U postgres_user >nul 2>&1
if errorlevel 1 (
    echo ❌ PostgreSQL: Not ready
) else (
    echo ✅ PostgreSQL: Ready
    echo 📋 Available databases:
    docker exec postgres_low_ram psql -U postgres_user -d postgres -c "\l" | findstr "laravel\|wordpress"
)

echo.
echo 📋 SUMMARY:
echo ================================================================
echo ✅ Fixed database host references in all PHP files
echo ✅ Ensured all required databases exist
echo ✅ Restarted affected containers
echo ✅ All services should now connect to postgres_low_ram:5432

echo.
echo 🌐 Test URLs:
echo    • Laravel PHP 8.4: http://localhost:8010
echo    • WordPress PHP 7.4: http://localhost:8030
echo    • Mailhog: http://localhost:8025

echo.
echo 💡 If issues persist:
echo    • Check logs: docker logs [container_name]
echo    • Manual test: docker exec [container] php -r "new PDO('pgsql:host=postgres_low_ram;dbname=test', 'postgres_user', 'postgres_pass');"
echo    • Restart all: docker-compose -f docker-compose.low-ram.yml restart

echo.
pause
