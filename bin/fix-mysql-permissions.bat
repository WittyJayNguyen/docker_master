@echo off
setlocal enabledelayedexpansion

REM Fix MySQL Permissions Script
REM Grants necessary permissions to dev_user for database operations

set "SCRIPT_DIR=%~dp0"
set "PROJECT_ROOT=%SCRIPT_DIR%.."

REM Colors
set "GREEN=[92m"
set "BLUE=[94m"
set "YELLOW=[93m"
set "RED=[91m"
set "NC=[0m"

echo %BLUE%========================================%NC%
echo %BLUE%   MySQL Permissions Fix%NC%
echo %BLUE%========================================%NC%
echo.

echo %YELLOW%This script will grant necessary permissions to dev_user:%NC%
echo   ✅ CREATE - Create new databases
echo   ✅ DROP - Drop databases
echo   ✅ ALL PRIVILEGES - Full access to all databases
echo.

set /p confirm="Do you want to proceed? (y/N): "
if /i not "%confirm%"=="y" (
    echo Operation cancelled.
    pause
    exit /b 0
)

echo.
echo %BLUE%[INFO]%NC% Connecting to MySQL as root...

cd /d "%PROJECT_ROOT%"

REM Create temporary SQL file
echo -- Fix MySQL Permissions for dev_user > temp_permissions.sql
echo -- Grant database creation permissions >> temp_permissions.sql
echo GRANT CREATE ON *.* TO 'dev_user'@'%%'; >> temp_permissions.sql
echo GRANT DROP ON *.* TO 'dev_user'@'%%'; >> temp_permissions.sql
echo GRANT ALTER ON *.* TO 'dev_user'@'%%'; >> temp_permissions.sql
echo GRANT INDEX ON *.* TO 'dev_user'@'%%'; >> temp_permissions.sql
echo GRANT REFERENCES ON *.* TO 'dev_user'@'%%'; >> temp_permissions.sql
echo. >> temp_permissions.sql
echo -- Grant full privileges on all databases >> temp_permissions.sql
echo GRANT ALL PRIVILEGES ON *.* TO 'dev_user'@'%%' WITH GRANT OPTION; >> temp_permissions.sql
echo. >> temp_permissions.sql
echo -- Create asmokaigo database if it doesn't exist >> temp_permissions.sql
echo CREATE DATABASE IF NOT EXISTS asmokaigo CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci; >> temp_permissions.sql
echo. >> temp_permissions.sql
echo -- Flush privileges >> temp_permissions.sql
echo FLUSH PRIVILEGES; >> temp_permissions.sql
echo. >> temp_permissions.sql
echo -- Show current grants >> temp_permissions.sql
echo SHOW GRANTS FOR 'dev_user'@'%%'; >> temp_permissions.sql
echo. >> temp_permissions.sql
echo -- Show databases >> temp_permissions.sql
echo SHOW DATABASES; >> temp_permissions.sql

REM Execute SQL file
echo %BLUE%[INFO]%NC% Executing permission fixes...
docker-compose exec -T mysql mysql -u root -proot123 < temp_permissions.sql

if errorlevel 1 (
    echo %RED%[ERROR]%NC% Failed to execute permissions fix.
    echo Please check if MySQL is running and root password is correct.
    del temp_permissions.sql
    pause
    exit /b 1
)

REM Clean up
del temp_permissions.sql

echo.
echo %GREEN%[SUCCESS]%NC% MySQL permissions have been fixed!
echo.

echo %YELLOW%What was done:%NC%
echo   ✅ Granted CREATE/DROP permissions to dev_user
echo   ✅ Granted ALL PRIVILEGES on all databases
echo   ✅ Created 'asmokaigo' database
echo   ✅ Flushed privileges
echo.

echo %YELLOW%Now you can:%NC%
echo   ✅ Create databases in DBeaver with dev_user
echo   ✅ Drop databases if needed
echo   ✅ Full access to all database operations
echo.

echo %BLUE%[INFO]%NC% Testing connection with dev_user...
docker-compose exec mysql mysql -u dev_user -pdev_pass -e "SHOW DATABASES;"

if errorlevel 1 (
    echo %RED%[WARNING]%NC% Could not test dev_user connection.
) else (
    echo %GREEN%[SUCCESS]%NC% dev_user can now access databases!
)

echo.
echo %YELLOW%DBeaver Connection Settings:%NC%
echo   Host: localhost
echo   Port: 3306
echo   Database: asmokaigo (or any database name)
echo   Username: dev_user
echo   Password: dev_pass
echo   SSL: Disabled
echo.

pause
