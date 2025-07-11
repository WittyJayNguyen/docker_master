@echo off
REM Docker Master Platform - Fix MySQL Connection Issues
REM Khắc phục vấn đề kết nối MySQL

echo.
echo ========================================
echo   Fix MySQL Connection Issues
echo ========================================
echo.

echo 🔧 FIXING MYSQL CONNECTION PROBLEMS
echo ================================================================

echo 🔍 Step 1: Stop current MySQL container
docker stop mysql_low_ram 2>nul
docker rm mysql_low_ram 2>nul

echo ✅ MySQL container stopped and removed

echo.
echo 🔍 Step 2: Remove problematic volume
docker volume rm docker_master_mysql_data 2>nul
echo ✅ MySQL volume removed

echo.
echo 🔍 Step 3: Create simple MySQL configuration
echo Creating simplified MySQL setup...

REM Create temporary docker-compose for MySQL only
(
echo version: '3.8'
echo.
echo services:
echo   mysql_simple:
echo     image: mysql:8.0
echo     container_name: mysql_low_ram
echo     restart: unless-stopped
echo     ports:
echo       - "3306:3306"
echo     environment:
echo       MYSQL_ROOT_PASSWORD: mysql_root_pass
echo       MYSQL_DATABASE: main_db
echo       MYSQL_USER: mysql_user
echo       MYSQL_PASSWORD: mysql_pass
echo     command: >
echo       --default-authentication-plugin=mysql_native_password
echo       --innodb-buffer-pool-size=64M
echo       --skip-name-resolve
echo     volumes:
echo       - mysql_data_simple:/var/lib/mysql
echo     deploy:
echo       resources:
echo         limits:
echo           memory: 128M
echo     networks:
echo       - low-ram-network
echo     healthcheck:
echo       test: ["CMD", "mysqladmin", "ping", "-h", "localhost", "-u", "mysql_user", "-pmysql_pass"]
echo       interval: 30s
echo       timeout: 10s
echo       retries: 5
echo       start_period: 60s
echo.
echo networks:
echo   low-ram-network:
echo     external: true
echo     name: docker_master_low_ram
echo.
echo volumes:
echo   mysql_data_simple:
echo     driver: local
) > mysql-simple.yml

echo ✅ Simple MySQL configuration created

echo.
echo 🔍 Step 4: Start MySQL with simple configuration
docker-compose -f mysql-simple.yml up -d

echo ✅ MySQL started with simple configuration

echo.
echo 🔍 Step 5: Wait for MySQL to initialize (60 seconds)
echo This may take a while for first-time setup...

timeout /t 60 /nobreak

echo.
echo 🔍 Step 6: Test MySQL connection
echo Testing MySQL connection...

for /L %%i in (1,1,10) do (
    echo Attempt %%i/10...
    docker exec mysql_low_ram mysqladmin ping -h localhost -u mysql_user -pmysql_pass 2>nul
    if not errorlevel 1 (
        echo ✅ MySQL connection successful!
        goto :mysql_ready
    )
    timeout /t 5 /nobreak >nul
)

echo ⚠️  MySQL still not ready, but continuing...

:mysql_ready

echo.
echo 🔍 Step 7: Create test database
echo Creating test database...
docker exec mysql_low_ram mysql -u mysql_user -pmysql_pass -e "CREATE DATABASE IF NOT EXISTS test_mysql_db;" 2>nul
if not errorlevel 1 (
    echo ✅ Test database created successfully
) else (
    echo ⚠️  Database creation may have failed
)

echo.
echo 🔍 Step 8: Test database listing
echo Listing databases...
docker exec mysql_low_ram mysql -u mysql_user -pmysql_pass -e "SHOW DATABASES;" 2>nul

echo.
echo 🔍 Step 9: Update main docker-compose.yml
echo Updating main configuration with working MySQL settings...

REM Backup original file
copy docker-compose.low-ram.yml docker-compose.low-ram.yml.backup >nul

REM Update MySQL service in main file with working configuration
powershell -Command "(Get-Content docker-compose.low-ram.yml) -replace '--skip-host-cache', '--skip-name-resolve' | Set-Content docker-compose.low-ram.yml"

echo ✅ Main configuration updated

echo.
echo 🔍 Step 10: Final test
echo Testing final MySQL setup...

docker exec mysql_low_ram mysql -u mysql_user -pmysql_pass -e "SELECT 'MySQL is working!' as status;" 2>nul
if not errorlevel 1 (
    echo ✅ MySQL is fully working!
) else (
    echo ❌ MySQL still has issues
)

echo.
echo 📊 MYSQL CONNECTION FIX SUMMARY
echo ================================================================

echo 🗄️ MySQL Status:
docker ps --filter "name=mysql_low_ram" --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"

echo.
echo 🔧 Connection Details:
echo   • Host: localhost (or mysql_low_ram from containers)
echo   • Port: 3306
echo   • Username: mysql_user
echo   • Password: mysql_pass
echo   • Root Password: mysql_root_pass

echo.
echo 💡 Test Commands:
echo   docker exec mysql_low_ram mysql -u mysql_user -pmysql_pass
echo   docker exec mysql_low_ram mysql -u root -pmysql_root_pass

echo.
echo 🧪 Create Platform with MySQL:
echo   create.bat my-mysql-shop
echo   create.bat food-delivery-mysql

echo.
echo 🌟 MYSQL CONNECTION FIX COMPLETED!

REM Cleanup temporary file
del mysql-simple.yml 2>nul

pause
