@echo off
echo ========================================
echo AWS Order System Database Restore Script
echo ========================================
echo.

REM Set variables
set POSTGRES_HOST=localhost
set POSTGRES_PORT=5432
set POSTGRES_USER=postgres_user
set POSTGRES_PASSWORD=postgres_pass
set POSTGRES_DB=docker_master
set NEW_DB_NAME=aws_order_system
set BACKUP_FILE=Data110720125\aws_order_system_20250603_120501

echo Step 1: Check if PostgreSQL is running...
docker ps | findstr postgres_low_ram
if %ERRORLEVEL% neq 0 (
    echo ERROR: PostgreSQL container is not running!
    echo Please start the containers first: docker-compose up -d
    pause
    exit /b 1
)

echo.
echo Step 2: Create new database '%NEW_DB_NAME%'...
docker exec -i postgres_low_ram psql -U %POSTGRES_USER% -d %POSTGRES_DB% -c "DROP DATABASE IF EXISTS %NEW_DB_NAME%;"
docker exec -i postgres_low_ram psql -U %POSTGRES_USER% -d %POSTGRES_DB% -c "CREATE DATABASE %NEW_DB_NAME% WITH ENCODING='UTF8' LC_COLLATE='C' LC_CTYPE='C';"

if %ERRORLEVEL% neq 0 (
    echo ERROR: Failed to create database!
    pause
    exit /b 1
)

echo Database '%NEW_DB_NAME%' created successfully!
echo.

echo Step 3: Restore data from backup file...
echo This may take several minutes due to the large file size (600MB)...
echo.

REM Copy backup file to container and restore
docker cp "%BACKUP_FILE%" postgres_low_ram:/tmp/backup.sql
docker exec -i postgres_low_ram psql -U %POSTGRES_USER% -d %NEW_DB_NAME% -f /tmp/backup.sql

if %ERRORLEVEL% neq 0 (
    echo ERROR: Failed to restore database!
    pause
    exit /b 1
)

echo.
echo Step 4: Clean up temporary files...
docker exec -i postgres_low_ram rm -f /tmp/backup.sql

echo.
echo Step 5: Verify database restoration...
docker exec -i postgres_low_ram psql -U %POSTGRES_USER% -d %NEW_DB_NAME% -c "\dt"

echo.
echo ========================================
echo Database restoration completed successfully!
echo ========================================
echo.
echo Database Details:
echo - Host: %POSTGRES_HOST%
echo - Port: %POSTGRES_PORT%
echo - Database: %NEW_DB_NAME%
echo - Username: %POSTGRES_USER%
echo - Password: %POSTGRES_PASSWORD%
echo.
echo You can now connect to the database using:
echo - pgAdmin: http://localhost:8080
echo - Command line: docker exec -it postgres_low_ram psql -U %POSTGRES_USER% -d %NEW_DB_NAME%
echo.
pause
