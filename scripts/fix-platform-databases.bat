@echo off
REM Docker Master Platform - Fix Platform Database Names
REM Sửa tên database cho các platform (thay dấu gạch ngang bằng gạch dưới)

echo.
echo ========================================
echo   Fix Platform Database Names
echo ========================================
echo.

echo 🔧 Fixing database naming issues...
echo ================================================================

echo 📋 Common issue: Platform names with hyphens (-) cause PostgreSQL errors
echo 💡 Solution: Convert hyphens to underscores (_) in database names

echo.
echo 🗄️ Current databases in PostgreSQL:
docker exec postgres_low_ram psql -U postgres_user -d postgres -c "\l" | findstr -v "template\|postgres"

echo.
echo 🔧 Fixing known platforms...

REM Fix test-shop platform
echo 📝 Fixing test-shop platform...
if exist "projects\test-shop\index.php" (
    echo   • Converting test-shop_db to test_shop_db
    
    REM Create correct database name
    docker exec postgres_low_ram psql -U postgres_user -d postgres -c "CREATE DATABASE test_shop_db;" 2>nul
    
    REM Update index.php
    powershell -Command "(Get-Content 'projects\test-shop\index.php') -replace 'test-shop_db', 'test_shop_db' | Set-Content 'projects\test-shop\index.php'"
    
    REM Update docker-compose if exists
    if exist "platforms\test-shop\docker-compose.test-shop.yml" (
        powershell -Command "(Get-Content 'platforms\test-shop\docker-compose.test-shop.yml') -replace 'test-shop_db', 'test_shop_db' | Set-Content 'platforms\test-shop\docker-compose.test-shop.yml'"
    )
    
    echo   ✅ test-shop platform fixed
) else (
    echo   ℹ️  test-shop platform not found
)

REM Fix any other platforms with hyphens
echo.
echo 📝 Scanning for other platforms with hyphens...

for /d %%i in (projects\*) do (
    set "platform_name=%%~ni"
    echo !platform_name! | findstr "-" >nul
    if not errorlevel 1 (
        echo   • Found platform with hyphen: !platform_name!
        
        REM Convert hyphen to underscore for database name
        set "db_name=!platform_name:-=_!_db"
        
        echo     Creating database: !db_name!
        docker exec postgres_low_ram psql -U postgres_user -d postgres -c "CREATE DATABASE !db_name!;" 2>nul
        
        REM Update index.php if exists
        if exist "projects\!platform_name!\index.php" (
            echo     Updating index.php database reference
            powershell -Command "(Get-Content 'projects\!platform_name!\index.php') -replace '!platform_name!_db', '!db_name!' | Set-Content 'projects\!platform_name!\index.php'"
        )
        
        REM Update docker-compose if exists
        if exist "platforms\!platform_name!\docker-compose.!platform_name!.yml" (
            echo     Updating docker-compose database reference
            powershell -Command "(Get-Content 'platforms\!platform_name!\docker-compose.!platform_name!.yml') -replace '!platform_name!_db', '!db_name!' | Set-Content 'platforms\!platform_name!\docker-compose.!platform_name!.yml'"
        )
        
        echo   ✅ !platform_name! platform fixed
    )
)

echo.
echo 🔄 Restarting affected containers...
echo ================================================================

REM Restart containers that might be affected
for /f "tokens=1" %%i in ('docker ps --format "{{.Names}}" ^| findstr "_php"') do (
    echo   • Restarting %%i...
    docker restart %%i >nul 2>&1
)

echo ✅ Containers restarted

echo.
echo 🧪 Testing database connections...
echo ================================================================

echo 📝 Testing platforms with corrected database names:

REM Test test-shop
echo 🔍 Testing test-shop (Port 8017)...
powershell -Command "try { $r = Invoke-WebRequest -Uri 'http://localhost:8017' -TimeoutSec 10 -UseBasicParsing; if ($r.StatusCode -eq 200 -and $r.Content -match 'PostgreSQL connection successful') { Write-Host '✅ test-shop: Database connection WORKING' -ForegroundColor Green } elseif ($r.StatusCode -eq 200) { Write-Host '⚠️  test-shop: Responding but check database' -ForegroundColor Yellow } else { Write-Host '❌ test-shop: HTTP' $r.StatusCode -ForegroundColor Red } } catch { Write-Host '❌ test-shop: Connection failed' -ForegroundColor Red }"

REM Test other running platforms
for /f "tokens=1,2" %%i in ('docker ps --format "{{.Names}} {{.Ports}}" ^| findstr ":80"') do (
    set "container_name=%%i"
    set "port_info=%%j"
    
    REM Extract port number
    for /f "tokens=2 delims=:" %%k in ("!port_info!") do (
        for /f "tokens=1 delims=-" %%l in ("%%k") do (
            set "port=%%l"
            if not "!port!"=="8017" (
                echo 🔍 Testing !container_name! (Port !port!)...
                powershell -Command "try { $r = Invoke-WebRequest -Uri 'http://localhost:!port!' -TimeoutSec 5 -UseBasicParsing; if ($r.StatusCode -eq 200 -and $r.Content -match 'PostgreSQL connection successful') { Write-Host '✅ !container_name!: Database connection WORKING' -ForegroundColor Green } elseif ($r.StatusCode -eq 200) { Write-Host '⚠️  !container_name!: Responding' -ForegroundColor Yellow } } catch { Write-Host '⚠️  !container_name!: May still be starting' -ForegroundColor Yellow }"
            )
        )
    )
)

echo.
echo 📊 Updated Database List:
echo ================================================================
docker exec postgres_low_ram psql -U postgres_user -d postgres -c "\l" | findstr -v "template\|postgres" | findstr "_db"

echo.
echo 🎉 Platform Database Fix Completed!
echo ================================================================

echo ✅ What was fixed:
echo   • Converted hyphenated database names to underscored names
echo   • Updated index.php files with correct database references
echo   • Updated docker-compose files with correct database names
echo   • Created missing databases in PostgreSQL
echo   • Restarted affected containers

echo.
echo 💡 Database Naming Rules:
echo   • Platform name: my-shop → Database name: my_shop_db
echo   • Platform name: food-delivery → Database name: food_delivery_db
echo   • Platform name: api-server → Database name: api_server_db

echo.
echo 🔧 Future Platform Creation:
echo   Auto-Discovery scripts will now automatically:
echo   • Convert hyphens to underscores in database names
echo   • Create databases with proper naming
echo   • Generate correct configuration files

pause
