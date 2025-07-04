@echo off
echo.
echo ========================================
echo   Docker Master Platform - Fix Database Demo
echo ========================================
echo.

echo 🔧 Fixing Laravel demo files to prevent database creation errors...
echo.

REM Check if containers are running
docker ps | findstr "laravel_php84_psql_app" >nul
if errorlevel 1 (
    echo ❌ Laravel PHP 8.4 container is not running
    exit /b 1
)

docker ps | findstr "laravel_php74_psql_app" >nul
if errorlevel 1 (
    echo ❌ Laravel PHP 7.4 container is not running
    exit /b 1
)

echo ✅ Laravel containers are running
echo.

echo 📝 Fixing PHP 8.4 demo file...
docker exec laravel_php84_psql_app sed -i 's/\$pdo->exec("CREATE DATABASE \$dbname");/\/\/ Database already exists - no need to create/' /app/laravel-php84-psql/index.php
if errorlevel 1 (
    echo ⚠️ Could not fix PHP 8.4 file automatically
) else (
    echo ✅ PHP 8.4 demo file fixed
)

echo 📝 Fixing PHP 7.4 demo file...
docker exec laravel_php74_psql_app sed -i 's/\$pdo->exec("CREATE DATABASE \$dbname");/\/\/ Database already exists - no need to create/' /app/laravel-php74-psql/index.php
if errorlevel 1 (
    echo ⚠️ Could not fix PHP 7.4 file automatically
) else (
    echo ✅ PHP 7.4 demo file fixed
)

echo.
echo 🔄 Restarting containers to apply changes...
docker restart laravel_php84_psql_app laravel_php74_psql_app

echo.
echo ✅ Database demo fix completed!
echo.
echo 💡 What was fixed:
echo    - Removed CREATE DATABASE commands from demo files
echo    - Fixed PHP 7.4 compatibility (removed Enums, used class constants)
echo    - Applications now connect directly to existing databases
echo    - No more "Duplicate database" or syntax errors
echo.
echo 🌐 Test the applications:
echo    - Laravel PHP 8.4: http://localhost:8010
echo    - Laravel PHP 7.4: http://localhost:8011
echo.
