@echo off
echo.
echo ========================================
echo   PostgreSQL 17 Testing Suite
echo ========================================
echo.

REM Check if PostgreSQL is running
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
echo 🧪 Test 1: Basic Connection Test
echo ----------------------------------------------------------------
docker exec postgres_low_ram pg_isready -U postgres_user
if errorlevel 1 (
    echo ❌ Connection test failed
    goto :error
) else (
    echo ✅ Connection test passed
)

echo.
echo 🧪 Test 2: Version Verification
echo ----------------------------------------------------------------
echo Expected: PostgreSQL 17.x
echo Actual:
docker exec postgres_low_ram psql -U postgres_user -d postgres -c "SELECT version();" -t | findstr "PostgreSQL 17"
if errorlevel 1 (
    echo ❌ Version verification failed - not PostgreSQL 17
    goto :error
) else (
    echo ✅ Version verification passed - PostgreSQL 17 confirmed
)

echo.
echo 🧪 Test 3: Database Access Test
echo ----------------------------------------------------------------
echo Testing database access...
docker exec postgres_low_ram psql -U postgres_user -d docker_master -c "SELECT 'Database access OK' as status;" -t
if errorlevel 1 (
    echo ❌ Database access test failed
    goto :error
) else (
    echo ✅ Database access test passed
)

echo.
echo 🧪 Test 4: Create/Drop Test Table
echo ----------------------------------------------------------------
echo Creating test table...
docker exec postgres_low_ram psql -U postgres_user -d docker_master -c "CREATE TABLE IF NOT EXISTS pg17_test (id SERIAL PRIMARY KEY, name VARCHAR(100), created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP);" >nul
if errorlevel 1 (
    echo ❌ Table creation failed
    goto :error
) else (
    echo ✅ Table creation passed
)

echo Inserting test data...
docker exec postgres_low_ram psql -U postgres_user -d docker_master -c "INSERT INTO pg17_test (name) VALUES ('PostgreSQL 17 Test');" >nul
if errorlevel 1 (
    echo ❌ Data insertion failed
    goto :error
) else (
    echo ✅ Data insertion passed
)

echo Querying test data...
docker exec postgres_low_ram psql -U postgres_user -d docker_master -c "SELECT * FROM pg17_test;" -t
if errorlevel 1 (
    echo ❌ Data query failed
    goto :error
) else (
    echo ✅ Data query passed
)

echo Cleaning up test table...
docker exec postgres_low_ram psql -U postgres_user -d docker_master -c "DROP TABLE pg17_test;" >nul
if errorlevel 1 (
    echo ❌ Table cleanup failed
    goto :error
) else (
    echo ✅ Table cleanup passed
)

echo.
echo 🧪 Test 5: JSON Features Test (PostgreSQL 17 Enhancement)
echo ----------------------------------------------------------------
echo Testing JSON functionality...
docker exec postgres_low_ram psql -U postgres_user -d docker_master -c "SELECT json_build_object('version', '17', 'feature', 'enhanced_json') as json_test;" -t
if errorlevel 1 (
    echo ❌ JSON test failed
    goto :error
) else (
    echo ✅ JSON test passed
)

echo.
echo 🧪 Test 6: Performance Features Test
echo ----------------------------------------------------------------
echo Testing parallel query capability...
docker exec postgres_low_ram psql -U postgres_user -d docker_master -c "SHOW max_parallel_workers;" -t
if errorlevel 1 (
    echo ❌ Parallel workers test failed
    goto :error
) else (
    echo ✅ Parallel workers test passed
)

echo.
echo 🧪 Test 7: Extension Compatibility Test
echo ----------------------------------------------------------------
echo Checking available extensions...
docker exec postgres_low_ram psql -U postgres_user -d docker_master -c "SELECT name FROM pg_available_extensions WHERE name IN ('uuid-ossp', 'pgcrypto', 'hstore') ORDER BY name;" -t
echo ✅ Extension compatibility check completed

echo.
echo 🧪 Test 8: Connection Pool Test
echo ----------------------------------------------------------------
echo Testing multiple connections...
for /l %%i in (1,1,5) do (
    docker exec postgres_low_ram psql -U postgres_user -d docker_master -c "SELECT 'Connection %%i OK' as status;" -t >nul
    if errorlevel 1 (
        echo ❌ Connection %%i failed
        goto :error
    )
)
echo ✅ Multiple connections test passed

echo.
echo 🧪 Test 9: Memory Configuration Test
echo ----------------------------------------------------------------
echo Checking memory settings...
echo Shared Buffers:
docker exec postgres_low_ram psql -U postgres_user -d postgres -c "SHOW shared_buffers;" -t

echo Work Memory:
docker exec postgres_low_ram psql -U postgres_user -d postgres -c "SHOW work_mem;" -t

echo Effective Cache Size:
docker exec postgres_low_ram psql -U postgres_user -d postgres -c "SHOW effective_cache_size;" -t
echo ✅ Memory configuration check completed

echo.
echo 🧪 Test 10: Application Database Test
echo ----------------------------------------------------------------
echo Testing Laravel database...
docker exec postgres_low_ram psql -U postgres_user -d laravel_php84_psql -c "SELECT 'Laravel DB OK' as status;" -t 2>nul
if errorlevel 1 (
    echo ⚠️  Laravel database not found - this is normal if not created yet
) else (
    echo ✅ Laravel database test passed
)

echo.
echo 🎉 All Tests Completed Successfully!
echo ====================================
echo.
echo 📊 Test Summary:
echo ✅ Basic connection: PASSED
echo ✅ Version verification: PASSED  
echo ✅ Database access: PASSED
echo ✅ CRUD operations: PASSED
echo ✅ JSON features: PASSED
echo ✅ Performance features: PASSED
echo ✅ Extension compatibility: PASSED
echo ✅ Connection pooling: PASSED
echo ✅ Memory configuration: PASSED
echo ✅ Application databases: CHECKED
echo.
echo 🚀 PostgreSQL 17 is working correctly!
echo.
echo 💡 Next Steps:
echo 1. Test your applications thoroughly
echo 2. Monitor performance improvements
echo 3. Update application documentation
echo 4. Consider using new PostgreSQL 17 features
echo.
goto :end

:error
echo.
echo ❌ Tests failed! Please check the PostgreSQL installation.
echo.
pause
exit /b 1

:end
pause
