@echo off
echo.
echo ========================================
echo   PostgreSQL Compatibility Check
echo ========================================
echo.

echo 🔍 Checking current PostgreSQL setup...
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
echo 📊 Current PostgreSQL Information:
echo ----------------------------------------------------------------

REM Get current version
echo 🔢 Current Version:
docker exec postgres_low_ram psql -U postgres_user -d postgres -c "SELECT version();" -t

echo.
echo 📋 Current Databases:
docker exec postgres_low_ram psql -U postgres_user -d postgres -c "\l" -t

echo.
echo 👥 Current Users:
docker exec postgres_low_ram psql -U postgres_user -d postgres -c "\du" -t

echo.
echo 🔧 Current Configuration:
echo ----------------------------------------------------------------
echo Shared Buffers:
docker exec postgres_low_ram psql -U postgres_user -d postgres -c "SHOW shared_buffers;" -t

echo Work Memory:
docker exec postgres_low_ram psql -U postgres_user -d postgres -c "SHOW work_mem;" -t

echo Max Connections:
docker exec postgres_low_ram psql -U postgres_user -d postgres -c "SHOW max_connections;" -t

echo.
echo 📈 Database Sizes:
echo ----------------------------------------------------------------
docker exec postgres_low_ram psql -U postgres_user -d postgres -c "SELECT datname, pg_size_pretty(pg_database_size(datname)) as size FROM pg_database WHERE datistemplate = false;" -t

echo.
echo 🔍 Extensions Check:
echo ----------------------------------------------------------------
docker exec postgres_low_ram psql -U postgres_user -d postgres -c "SELECT extname, extversion FROM pg_extension;" -t

echo.
echo ⚠️  Compatibility Notes for PostgreSQL 17:
echo ================================================================
echo.
echo ✅ COMPATIBLE:
echo - All standard SQL features
echo - Most PostgreSQL extensions
echo - Existing backup/restore procedures
echo - Current connection methods
echo.
echo 📝 CHANGES IN POSTGRESQL 17:
echo - Improved performance for large datasets
echo - Enhanced JSON and SQL/JSON support
echo - Better parallel query processing
echo - Improved security features
echo - Updated system catalogs
echo.
echo 🚨 POTENTIAL ISSUES:
echo - Some very old extensions might need updates
echo - Custom functions using deprecated features
echo - Applications using version-specific features
echo.
echo 💡 RECOMMENDATIONS:
echo ================================================================
echo 1. ✅ Backup all databases before upgrade
echo 2. ✅ Test applications in development first
echo 3. ✅ Update PostgreSQL client libraries if needed
echo 4. ✅ Review application logs after upgrade
echo 5. ✅ Update monitoring and backup scripts
echo.
echo 📋 Pre-upgrade Checklist:
echo ================================================================
echo [ ] Current data backed up
echo [ ] Applications tested with PostgreSQL 17
echo [ ] Client libraries updated
echo [ ] Monitoring configured
echo [ ] Rollback plan prepared
echo.
echo 🔧 Ready to upgrade?
echo Run: scripts\upgrade-postgresql.bat
echo.
pause
