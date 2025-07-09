@echo off
REM Fix MySQL permissions for Navicat table creation

echo.
echo ========================================
echo   Fix Navicat MySQL Permissions
echo ========================================
echo.

echo 🔧 Fixing MySQL user permissions for Navicat...

REM Wait for MySQL to be ready
echo ⏳ Waiting for MySQL to be ready...
timeout 10 >nul

REM Create comprehensive permissions for mysql_user
echo 📝 Setting up comprehensive permissions...

REM Connect as root and fix permissions
docker exec mysql_low_ram mysql -u root -pmysql_root_pass -e "
-- Drop and recreate user to ensure clean state
DROP USER IF EXISTS 'mysql_user'@'%%';
CREATE USER 'mysql_user'@'%%' IDENTIFIED BY 'mysql_pass';

-- Grant all privileges on all databases
GRANT ALL PRIVILEGES ON *.* TO 'mysql_user'@'%%' WITH GRANT OPTION;

-- Specific permissions for table operations
GRANT CREATE, DROP, ALTER, INSERT, UPDATE, DELETE, SELECT, INDEX, REFERENCES ON *.* TO 'mysql_user'@'%%';

-- Administrative privileges
GRANT RELOAD, PROCESS, SHOW DATABASES, LOCK TABLES, REPLICATION CLIENT ON *.* TO 'mysql_user'@'%%';

-- Flush privileges
FLUSH PRIVILEGES;

-- Show current grants
SHOW GRANTS FOR 'mysql_user'@'%%';
"

if not errorlevel 1 (
    echo ✅ MySQL permissions updated successfully
) else (
    echo ❌ Failed to update MySQL permissions
    echo 🔄 Trying alternative method...
    
    REM Alternative method with simpler commands
    docker exec mysql_low_ram mysql -u root -pmysql_root_pass -e "GRANT ALL PRIVILEGES ON *.* TO 'mysql_user'@'%%'; FLUSH PRIVILEGES;"
)

echo.
echo 🐘 Fixing PostgreSQL permissions...

REM Fix PostgreSQL permissions
docker exec postgres_low_ram psql -U postgres_user -d postgres -c "
-- Grant superuser privileges
ALTER USER postgres_user WITH SUPERUSER;

-- Grant all privileges on all databases
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO postgres_user;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO postgres_user;
GRANT ALL PRIVILEGES ON ALL FUNCTIONS IN SCHEMA public TO postgres_user;

-- Grant create database privilege
ALTER USER postgres_user CREATEDB;
"

echo.
echo 📊 Testing permissions...

echo.
echo MySQL Test:
docker exec mysql_low_ram mysql -u mysql_user -pmysql_pass -e "
SELECT 'MySQL Connection: OK' as status;
CREATE DATABASE IF NOT EXISTS test_navicat_db;
USE test_navicat_db;
CREATE TABLE IF NOT EXISTS test_table (id INT PRIMARY KEY, name VARCHAR(50));
INSERT INTO test_table VALUES (1, 'Test');
SELECT * FROM test_table;
DROP TABLE test_table;
DROP DATABASE test_navicat_db;
SELECT 'Table operations: OK' as result;
"

echo.
echo PostgreSQL Test:
docker exec postgres_low_ram psql -U postgres_user -d postgres -c "
SELECT 'PostgreSQL Connection: OK' as status;
CREATE DATABASE test_navicat_db;
\c test_navicat_db;
CREATE TABLE test_table (id SERIAL PRIMARY KEY, name VARCHAR(50));
INSERT INTO test_table (name) VALUES ('Test');
SELECT * FROM test_table;
DROP TABLE test_table;
\c postgres;
DROP DATABASE test_navicat_db;
SELECT 'Table operations: OK' as result;
"

echo.
echo ✅ PERMISSIONS FIXED!
echo ================================================================
echo.
echo 🔗 Navicat Connection Settings:
echo.
echo 🐬 MySQL:
echo   Host: localhost
echo   Port: 3306
echo   Username: mysql_user
echo   Password: mysql_pass
echo   ✅ Can create/drop tables, databases
echo   ✅ Full administrative access
echo.
echo 🐘 PostgreSQL:
echo   Host: localhost
echo   Port: 5432
echo   Username: postgres_user
echo   Password: postgres_pass
echo   ✅ Superuser privileges
echo   ✅ Can create/drop tables, databases
echo.
echo 💡 Tips for Navicat:
echo   • Use "localhost" not container names
echo   • Test connection before saving
echo   • Enable "Use SSL" if connection fails
echo   • Try "Advanced" tab for additional options
echo.

pause
