@echo off
echo.
echo ========================================
echo   Docker Master Platform - Init Databases
echo ========================================
echo.

REM Check if PostgreSQL is running
docker exec postgres_server pg_isready -U postgres_user >nul 2>&1
if errorlevel 1 (
    echo ❌ PostgreSQL is not ready
    exit /b 1
)

echo ✅ PostgreSQL is ready
echo.

echo 📊 Creating databases if not exist...

REM Create Laravel PHP 8.4 database
echo Creating laravel_php84_psql database...
docker exec postgres_server psql -U postgres_user -d postgres -c "SELECT 1 FROM pg_database WHERE datname = 'laravel_php84_psql'" | findstr "1" >nul
if errorlevel 1 (
    docker exec postgres_server psql -U postgres_user -d postgres -c "CREATE DATABASE laravel_php84_psql OWNER postgres_user;"
    echo ✅ Created laravel_php84_psql
) else (
    echo ℹ️ laravel_php84_psql already exists
)

REM Create Laravel PHP 7.4 database
echo Creating laravel_php74_psql database...
docker exec postgres_server psql -U postgres_user -d postgres -c "SELECT 1 FROM pg_database WHERE datname = 'laravel_php74_psql'" | findstr "1" >nul
if errorlevel 1 (
    docker exec postgres_server psql -U postgres_user -d postgres -c "CREATE DATABASE laravel_php74_psql OWNER postgres_user;"
    echo ✅ Created laravel_php74_psql
) else (
    echo ℹ️ laravel_php74_psql already exists
)

echo.
echo 📋 Current databases:
docker exec postgres_server psql -U postgres_user -d postgres -c "\l"

echo.
echo ✅ Database initialization completed!
echo.
echo 💡 Next steps:
echo    1. Install Laravel in projects folders
echo    2. Run migrations: php artisan migrate
echo    3. Start queue/scheduler containers
echo.
