@echo off
REM Quick fix for Navicat table creation issues

echo.
echo 🔧 QUICK FIX: Navicat Table Creation
echo ================================================================
echo.

echo ⏳ Step 1: Restarting database containers...
docker restart mysql_low_ram postgres_low_ram

echo ⏳ Waiting for databases to be ready...
timeout 15 >nul

echo 🔐 Step 2: Fixing MySQL permissions...
docker exec mysql_low_ram mysql -u root -pmysql_root_pass -e "GRANT ALL PRIVILEGES ON *.* TO 'mysql_user'@'%%' WITH GRANT OPTION; FLUSH PRIVILEGES;" 2>nul
if not errorlevel 1 (
    echo ✅ MySQL permissions fixed
) else (
    echo ⚠️ MySQL permission update failed, but may still work
)

echo 🔐 Step 3: Fixing PostgreSQL permissions...
docker exec postgres_low_ram psql -U postgres_user -d postgres -c "ALTER USER postgres_user WITH SUPERUSER;" 2>nul
if not errorlevel 1 (
    echo ✅ PostgreSQL permissions fixed
) else (
    echo ⚠️ PostgreSQL permission update failed, but may still work
)

echo.
echo 🧪 Step 4: Testing table creation...

echo Testing MySQL...
docker exec mysql_low_ram mysql -u mysql_user -pmysql_pass -e "CREATE DATABASE IF NOT EXISTS test_navicat; USE test_navicat; CREATE TABLE IF NOT EXISTS test_table (id INT PRIMARY KEY, name VARCHAR(50)); DROP TABLE test_table; DROP DATABASE test_navicat;" 2>nul
if not errorlevel 1 (
    echo ✅ MySQL table creation: OK
) else (
    echo ❌ MySQL table creation: FAILED
)

echo Testing PostgreSQL...
docker exec postgres_low_ram psql -U postgres_user -d postgres -c "CREATE DATABASE test_navicat; \c test_navicat; CREATE TABLE test_table (id SERIAL PRIMARY KEY, name VARCHAR(50)); DROP TABLE test_table; \c postgres; DROP DATABASE test_navicat;" 2>nul
if not errorlevel 1 (
    echo ✅ PostgreSQL table creation: OK
) else (
    echo ❌ PostgreSQL table creation: FAILED
)

echo.
echo ✅ NAVICAT FIX COMPLETED!
echo ================================================================
echo.
echo 🔗 Navicat Connection Settings:
echo.
echo 🐬 MySQL:
echo   Host: localhost
echo   Port: 3306
echo   Username: mysql_user
echo   Password: mysql_pass
echo.
echo 🐘 PostgreSQL:
echo   Host: localhost
echo   Port: 5432
echo   Username: postgres_user
echo   Password: postgres_pass
echo   Database: postgres
echo.
echo 💡 Now try creating tables in Navicat!
echo.

pause
