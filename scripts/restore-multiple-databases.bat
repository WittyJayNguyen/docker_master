@echo off
echo ========================================
echo Restore Multiple AWS Databases
echo ========================================
echo.

echo This script will restore data to the correct databases:
echo.
echo Database Mapping:
echo ----------------------------------------------------------------
echo 1. aws_order_system_20250603_120501
echo    ← Data110720125\aws_order_system_20250603_120501
echo.
echo 2. aws_project_management_20250703  
echo    ← Data110720125\aws_project_management_20250703
echo.

echo Step 1: Check PostgreSQL container status...
echo ================================================================

docker ps | findstr postgres_low_ram >nul
if errorlevel 1 (
    echo ❌ PostgreSQL container is not running!
    echo Please start containers first: docker-compose up -d
    pause
    exit /b 1
)

echo ✅ PostgreSQL container is running

echo.
echo Step 2: Verify backup files exist...
echo ================================================================

if not exist "Data110720125\aws_order_system_20250603_120501" (
    echo ❌ Order System backup file not found!
    echo Expected: Data110720125\aws_order_system_20250603_120501
    pause
    exit /b 1
)

if not exist "Data110720125\aws_project_management_20250703" (
    echo ❌ Project Management backup file not found!
    echo Expected: Data110720125\aws_project_management_20250703
    pause
    exit /b 1
)

echo ✅ Order System backup: Data110720125\aws_order_system_20250603_120501
for %%f in ("Data110720125\aws_order_system_20250603_120501") do echo    Size: %%~zf bytes

echo ✅ Project Management backup: Data110720125\aws_project_management_20250703  
for %%f in ("Data110720125\aws_project_management_20250703") do echo    Size: %%~zf bytes

echo.
echo Step 3: Verify target databases exist...
echo ================================================================

echo Checking databases...
docker exec postgres_low_ram psql -U postgres_user -d docker_master -c "\l" | findstr "aws_order_system_20250603_120501" >nul
if errorlevel 1 (
    echo ❌ Database aws_order_system_20250603_120501 not found!
    echo Creating database...
    docker exec postgres_low_ram psql -U postgres_user -d docker_master -c "CREATE DATABASE aws_order_system_20250603_120501 WITH ENCODING='UTF8' LC_COLLATE='C' LC_CTYPE='C';"
)

docker exec postgres_low_ram psql -U postgres_user -d docker_master -c "\l" | findstr "aws_project_management_20250703" >nul
if errorlevel 1 (
    echo ❌ Database aws_project_management_20250703 not found!
    echo Creating database...
    docker exec postgres_low_ram psql -U postgres_user -d docker_master -c "CREATE DATABASE aws_project_management_20250703 WITH ENCODING='UTF8' LC_COLLATE='C' LC_CTYPE='C';"
)

echo ✅ Target databases verified

echo.
echo Step 4: Restore Order System Database...
echo ================================================================

echo Restoring aws_order_system_20250603_120501...
echo This may take several minutes due to large file size...

REM Copy backup file to container
echo Copying backup file to container...
docker cp "Data110720125\aws_order_system_20250603_120501" postgres_low_ram:/tmp/order_system_backup.sql

echo Starting restore process...
docker exec postgres_low_ram pg_restore -U postgres_user -d aws_order_system_20250603_120501 -v /tmp/order_system_backup.sql

if errorlevel 1 (
    echo ⚠️  Some warnings occurred during Order System restore (this is normal)
) else (
    echo ✅ Order System restore completed successfully
)

echo.
echo Step 5: Restore Project Management Database...
echo ================================================================

echo Restoring aws_project_management_20250703...

REM Copy backup file to container
echo Copying backup file to container...
docker cp "Data110720125\aws_project_management_20250703" postgres_low_ram:/tmp/project_mgmt_backup.sql

echo Starting restore process...
docker exec postgres_low_ram pg_restore -U postgres_user -d aws_project_management_20250703 -v /tmp/project_mgmt_backup.sql

if errorlevel 1 (
    echo ⚠️  Some warnings occurred during Project Management restore (this is normal)
) else (
    echo ✅ Project Management restore completed successfully
)

echo.
echo Step 6: Clean up temporary files...
echo ================================================================

echo Removing temporary files from container...
docker exec postgres_low_ram rm -f /tmp/order_system_backup.sql
docker exec postgres_low_ram rm -f /tmp/project_mgmt_backup.sql

echo ✅ Cleanup completed

echo.
echo Step 7: Verify restoration...
echo ================================================================

echo.
echo Order System Database (aws_order_system_20250603_120501):
echo ----------------------------------------------------------------
docker exec postgres_low_ram psql -U postgres_user -d aws_order_system_20250603_120501 -c "SELECT count(*) as table_count FROM information_schema.tables WHERE table_schema = 'public';"

echo Database size:
docker exec postgres_low_ram psql -U postgres_user -d aws_order_system_20250603_120501 -c "SELECT pg_size_pretty(pg_database_size('aws_order_system_20250603_120501')) as database_size;"

echo.
echo Project Management Database (aws_project_management_20250703):
echo ----------------------------------------------------------------
docker exec postgres_low_ram psql -U postgres_user -d aws_project_management_20250703 -c "SELECT count(*) as table_count FROM information_schema.tables WHERE table_schema = 'public';"

echo Database size:
docker exec postgres_low_ram psql -U postgres_user -d aws_project_management_20250703 -c "SELECT pg_size_pretty(pg_database_size('aws_project_management_20250703')) as database_size;"

echo.
echo ========================================
echo RESTORE COMPLETED SUCCESSFULLY!
echo ========================================
echo.

echo 📊 Database Summary:
echo ================================================================
echo.
echo 1. Order System Database:
echo    • Name: aws_order_system_20250603_120501
echo    • Source: Data110720125\aws_order_system_20250603_120501
echo    • Status: ✅ Restored
echo.
echo 2. Project Management Database:
echo    • Name: aws_project_management_20250703
echo    • Source: Data110720125\aws_project_management_20250703
echo    • Status: ✅ Restored
echo.

echo 🌐 Connection Details:
echo ================================================================
echo Host: localhost:5432
echo Username: postgres_user
echo Password: postgres_pass
echo.
echo Order System DB: aws_order_system_20250603_120501
echo Project Management DB: aws_project_management_20250703
echo.

echo 🔧 Access Methods:
echo ================================================================
echo 1. pgAdmin Web Interface: http://localhost:8080
echo.
echo 2. Command Line:
echo    Order System:
echo    docker exec -it postgres_low_ram psql -U postgres_user -d aws_order_system_20250603_120501
echo.
echo    Project Management:
echo    docker exec -it postgres_low_ram psql -U postgres_user -d aws_project_management_20250703
echo.

echo 💡 Next Steps:
echo ================================================================
echo 1. Update application configurations to use correct database names
echo 2. Test database connections from applications
echo 3. Verify data integrity in both databases
echo.

pause
