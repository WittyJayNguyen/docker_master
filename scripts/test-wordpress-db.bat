@echo off
REM Docker Master Platform - Test WordPress PostgreSQL Connection
REM Kiểm tra kết nối PostgreSQL của WordPress

echo.
echo ========================================
echo   Docker Master - WordPress DB Test
echo ========================================
echo.

echo 🔍 Testing WordPress PostgreSQL Connection...
echo ================================================================

echo 📊 Container Status:
docker ps --filter "name=wordpress_php74_low_ram" --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
echo.

echo 🗄️ PostgreSQL Database Check:
echo ----------------------------------------------------------------
echo 📋 Available Databases:
docker exec postgres_low_ram psql -U postgres_user -d postgres -c "\l" | findstr wordpress_php74
echo.

echo 🔗 Testing Database Connection:
docker exec postgres_low_ram psql -U postgres_user -d wordpress_php74 -c "SELECT version();"
echo.

echo 📊 Database Tables:
docker exec postgres_low_ram psql -U postgres_user -d wordpress_php74 -c "\dt"
echo.

echo 🌐 Testing WordPress Web Response:
echo ----------------------------------------------------------------
powershell -Command "try { $response = Invoke-WebRequest -Uri 'http://localhost:8030' -TimeoutSec 10 -UseBasicParsing; Write-Host 'Status Code:' $response.StatusCode; Write-Host 'Content Length:' $response.Content.Length; if ($response.Content -match 'PostgreSQL') { Write-Host '✅ PostgreSQL connection working in WordPress' -ForegroundColor Green } else { Write-Host '⚠️  PostgreSQL connection status unclear' -ForegroundColor Yellow } } catch { Write-Host '❌ WordPress not responding:' $_.Exception.Message -ForegroundColor Red }"

echo.
echo 🔧 WordPress Configuration Check:
echo ----------------------------------------------------------------
echo 📝 wp-config.php Database Settings:
type "projects\wordpress-php74-mysql\wp-config.php" | findstr "DB_"

echo.
echo 📋 Environment Variables in Container:
docker exec wordpress_php74_low_ram env | findstr "DB_"

echo.
echo 🧪 Manual Database Test:
echo ----------------------------------------------------------------
echo 🔍 Testing direct connection from WordPress container:
docker exec wordpress_php74_low_ram php -r "
try {
    \$pdo = new PDO('pgsql:host=postgres_low_ram;port=5432;dbname=wordpress_php74', 'postgres_user', 'postgres_pass');
    echo '✅ Direct PostgreSQL connection successful from WordPress container\n';
    \$result = \$pdo->query('SELECT version()');
    echo 'PostgreSQL Version: ' . \$result->fetchColumn() . '\n';
} catch (Exception \$e) {
    echo '❌ Direct connection failed: ' . \$e->getMessage() . '\n';
}
"

echo.
echo 📊 Network Connectivity Test:
echo ----------------------------------------------------------------
echo 🔍 Testing network connectivity between containers:
docker exec wordpress_php74_low_ram ping -c 2 postgres_low_ram 2>nul
if errorlevel 1 (
    echo ❌ Network connectivity issue between WordPress and PostgreSQL
) else (
    echo ✅ Network connectivity OK
)

echo.
echo 🔍 Testing PostgreSQL port accessibility:
docker exec wordpress_php74_low_ram nc -zv postgres_low_ram 5432 2>nul
if errorlevel 1 (
    echo ❌ PostgreSQL port 5432 not accessible from WordPress container
) else (
    echo ✅ PostgreSQL port 5432 accessible
)

echo.
echo 📋 Summary Report:
echo ================================================================
echo 🎯 WordPress PHP 7.4 + PostgreSQL Status:
echo    • Container: wordpress_php74_low_ram
echo    • Database: wordpress_php74 on postgres_low_ram:5432
echo    • User: postgres_user
echo    • Web URL: http://localhost:8030

echo.
echo 💡 Troubleshooting Tips:
echo ================================================================
echo • View WordPress logs: docker logs wordpress_php74_low_ram
echo • View PostgreSQL logs: docker logs postgres_low_ram
echo • Restart WordPress: docker-compose -f docker-compose.low-ram.yml restart wordpress-php74
echo • Check wp-config.php: type projects\wordpress-php74-mysql\wp-config.php
echo • Test manually: docker exec -it wordpress_php74_low_ram bash

echo.
echo 🔧 Quick Fixes:
echo • If connection fails, check network: docker network ls
echo • If database missing, create: docker exec postgres_low_ram psql -U postgres_user -d postgres -c "CREATE DATABASE wordpress_php74;"
echo • If user issues, check: docker exec postgres_low_ram psql -U postgres_user -d postgres -c "\du"

echo.
pause
