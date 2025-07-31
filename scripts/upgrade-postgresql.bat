@echo off
echo.
echo ========================================
echo   PostgreSQL Upgrade to Version 17
echo ========================================
echo.

REM Set variables
set BACKUP_DIR=backups\postgresql
set TIMESTAMP=%date:~-4,4%%date:~-10,2%%date:~-7,2%_%time:~0,2%%time:~3,2%%time:~6,2%
set TIMESTAMP=%TIMESTAMP: =0%
set BACKUP_FILE=%BACKUP_DIR%\postgres_backup_%TIMESTAMP%.sql

echo 📋 PostgreSQL Upgrade Process
echo --------------------------------
echo Current version: PostgreSQL 15
echo Target version:  PostgreSQL 17
echo.

REM Create backup directory
if not exist "%BACKUP_DIR%" (
    mkdir "%BACKUP_DIR%"
    echo ✅ Created backup directory: %BACKUP_DIR%
)

echo.
echo 🔍 Step 1: Check current PostgreSQL status
echo ----------------------------------------------------------------
docker ps | findstr postgres_low_ram >nul
if errorlevel 1 (
    echo ❌ PostgreSQL container is not running
    echo Please start PostgreSQL first: docker-compose up -d postgres
    pause
    exit /b 1
) else (
    echo ✅ PostgreSQL container is running
)

echo.
echo 💾 Step 2: Backup current databases
echo ----------------------------------------------------------------
echo Creating backup file: %BACKUP_FILE%

REM Backup all databases
docker exec postgres_low_ram pg_dumpall -U postgres_user > "%BACKUP_FILE%"
if errorlevel 1 (
    echo ❌ Backup failed!
    pause
    exit /b 1
) else (
    echo ✅ Backup completed successfully
    echo 📁 Backup saved to: %BACKUP_FILE%
)

echo.
echo ⚠️  Step 3: Stop current PostgreSQL container
echo ----------------------------------------------------------------
echo Stopping PostgreSQL container...
docker-compose stop postgres
if errorlevel 1 (
    echo ❌ Failed to stop PostgreSQL container
    pause
    exit /b 1
) else (
    echo ✅ PostgreSQL container stopped
)

echo.
echo 🗑️  Step 4: Remove old container and volume (OPTIONAL)
echo ----------------------------------------------------------------
echo WARNING: This will remove all current data!
echo The data will be restored from backup in the next step.
echo.
set /p CONFIRM="Do you want to remove the old container and volume? (y/N): "
if /i "%CONFIRM%"=="y" (
    echo Removing old container...
    docker rm postgres_low_ram 2>nul
    echo.
    echo ⚠️  IMPORTANT: Remove old volume?
    echo This will permanently delete all PostgreSQL data!
    echo Data will be restored from backup.
    echo.
    set /p CONFIRM_VOLUME="Remove PostgreSQL volume? (y/N): "
    if /i "%CONFIRM_VOLUME%"=="y" (
        docker volume rm docker_master_postgres_data 2>nul
        echo ✅ Old volume removed
    ) else (
        echo ℹ️  Volume kept - data will be preserved
    )
) else (
    echo ℹ️  Keeping existing container and volume
)

echo.
echo 🚀 Step 5: Start PostgreSQL 17
echo ----------------------------------------------------------------
echo Starting PostgreSQL 17 container...
docker-compose up -d postgres
if errorlevel 1 (
    echo ❌ Failed to start PostgreSQL 17
    pause
    exit /b 1
)

echo Waiting for PostgreSQL to be ready...
timeout /t 10 /nobreak >nul

REM Wait for PostgreSQL to be ready
:wait_loop
docker exec postgres_low_ram pg_isready -U postgres_user >nul 2>&1
if errorlevel 1 (
    echo Waiting for PostgreSQL...
    timeout /t 5 /nobreak >nul
    goto wait_loop
)

echo ✅ PostgreSQL 17 is ready

echo.
echo 📥 Step 6: Restore data from backup
echo ----------------------------------------------------------------
if /i "%CONFIRM_VOLUME%"=="y" (
    echo Restoring data from backup...
    docker exec -i postgres_low_ram psql -U postgres_user < "%BACKUP_FILE%"
    if errorlevel 1 (
        echo ❌ Data restore failed!
        echo Please check the backup file and try manual restore
        pause
        exit /b 1
    ) else (
        echo ✅ Data restored successfully
    )
) else (
    echo ℹ️  Skipping restore - existing data preserved
)

echo.
echo ✅ Step 7: Verify upgrade
echo ----------------------------------------------------------------
echo Checking PostgreSQL version...
docker exec postgres_low_ram psql -U postgres_user -d postgres -c "SELECT version();"

echo.
echo Checking databases...
docker exec postgres_low_ram psql -U postgres_user -d postgres -c "\l"

echo.
echo 🎉 PostgreSQL upgrade completed!
echo ================================
echo.
echo 📋 Summary:
echo - Upgraded from PostgreSQL 15 to PostgreSQL 17
echo - Backup saved to: %BACKUP_FILE%
echo - All databases should be accessible
echo.
echo 🔧 Next steps:
echo 1. Test your applications with PostgreSQL 17
echo 2. Update any application configs if needed
echo 3. Remove old backups after confirming everything works
echo.
echo 📚 PostgreSQL 17 New Features:
echo - Improved performance and query optimization
echo - Enhanced security features
echo - Better JSON and SQL/JSON support
echo - Improved parallel query processing
echo.
pause
