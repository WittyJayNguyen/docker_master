@echo off
REM Docker Master Platform - Create Databases for All Platforms
REM Tạo databases cho tất cả platforms hiện có

echo.
echo ========================================
echo   Create Databases for All Platforms
echo ========================================
echo.

echo 🗄️ CREATING DATABASES FOR ALL PLATFORMS
echo ================================================================

echo ℹ️  This script will:
echo   • Scan all existing platforms
echo   • Create MySQL/PostgreSQL databases as needed
echo   • Grant proper permissions
echo   • Test connections

echo.
echo 🔍 Step 1: Scan existing platforms
echo ----------------------------------------------------------------

if not exist "platforms\" (
    echo ❌ No platforms directory found!
    pause
    exit /b 1
)

echo Scanning platforms directory...
for /d %%i in (platforms\*) do (
    set platform_name=%%~ni
    call :create_database_for_platform "!platform_name!"
)

echo.
echo 🧪 Step 2: Test database connections
echo ----------------------------------------------------------------

echo Testing MySQL connections...
docker exec mysql_low_ram mysql -u mysql_user -pmysql_pass -e "SHOW DATABASES;" 2>nul
if errorlevel 1 (
    echo ❌ MySQL connection failed!
) else (
    echo ✅ MySQL connection successful
)

echo Testing PostgreSQL connections...
docker exec postgres_low_ram psql -U postgres_user -d postgres -c "\l" 2>nul
if errorlevel 1 (
    echo ❌ PostgreSQL connection failed!
) else (
    echo ✅ PostgreSQL connection successful
)

echo.
echo 🎉 DATABASE CREATION COMPLETED!
echo ================================================================

echo 📊 Created Databases:
echo ----------------------------------------------------------------

echo MySQL Databases:
docker exec mysql_low_ram mysql -u root -pmysql_root_pass -e "SHOW DATABASES;" 2>nul | findstr "_db"

echo.
echo PostgreSQL Databases:
docker exec postgres_low_ram psql -U postgres_user -d postgres -c "\l" 2>nul | findstr "_db"

echo.
echo 💡 Database Credentials:
echo ----------------------------------------------------------------
echo   MySQL:     mysql_user / mysql_pass (localhost:3306)
echo   PostgreSQL: postgres_user / postgres_pass (localhost:5432)

echo.
echo 🌟 ALL DATABASES READY FOR USE!

pause
exit /b 0

:create_database_for_platform
set platform_name=%~1

REM Convert platform name to database name (replace hyphens with underscores)
set db_name=%platform_name:-=_%_db

echo Processing platform: %platform_name%

REM Determine database type based on platform name
set db_type=mysql
echo %platform_name% | findstr /C:"api" >nul
if not errorlevel 1 set db_type=postgresql

echo %platform_name% | findstr /C:"service" >nul
if not errorlevel 1 set db_type=postgresql

echo %platform_name% | findstr /C:"micro" >nul
if not errorlevel 1 set db_type=postgresql

echo %platform_name% | findstr /C:"backend" >nul
if not errorlevel 1 set db_type=postgresql

REM Force PostgreSQL for laravel74 projects
echo %platform_name% | findstr /C:"laravel74" >nul
if not errorlevel 1 set db_type=postgresql

echo   Database: %db_name% (%db_type%)

if "%db_type%"=="mysql" (
    REM Create MySQL database
    docker exec mysql_low_ram mysql -u root -pmysql_root_pass -e "CREATE DATABASE IF NOT EXISTS %db_name%; GRANT ALL PRIVILEGES ON %db_name%.* TO 'mysql_user'@'%%'; FLUSH PRIVILEGES;" 2>nul
    if errorlevel 1 (
        echo   ❌ Failed to create MySQL database: %db_name%
    ) else (
        echo   ✅ MySQL database created: %db_name%
    )
) else (
    REM Create PostgreSQL database
    docker exec postgres_low_ram psql -U postgres_user -d postgres -c "CREATE DATABASE %db_name%;" 2>nul
    if errorlevel 1 (
        echo   ⚠️  PostgreSQL database may already exist: %db_name%
    ) else (
        echo   ✅ PostgreSQL database created: %db_name%
    )
)

exit /b 0
