@echo off
REM Create all required databases for platforms

echo.
echo ========================================
echo   Creating All Platform Databases
echo ========================================
echo.

echo 🗄️ Creating MySQL databases...

REM Create my_blog_db
docker exec mysql_low_ram mysql -u root -pmysql_root_pass -e "CREATE DATABASE IF NOT EXISTS my_blog_db; GRANT ALL PRIVILEGES ON my_blog_db.* TO 'mysql_user'@'%%'; FLUSH PRIVILEGES;" 2>nul
if not errorlevel 1 (
    echo ✅ my_blog_db created
) else (
    echo ❌ Failed to create my_blog_db
)

REM Create my_shop_db
docker exec mysql_low_ram mysql -u root -pmysql_root_pass -e "CREATE DATABASE IF NOT EXISTS my_shop_db; GRANT ALL PRIVILEGES ON my_shop_db.* TO 'mysql_user'@'%%'; FLUSH PRIVILEGES;" 2>nul
if not errorlevel 1 (
    echo ✅ my_shop_db created
) else (
    echo ❌ Failed to create my_shop_db
)

REM Create common databases
docker exec mysql_low_ram mysql -u root -pmysql_root_pass -e "CREATE DATABASE IF NOT EXISTS wordpress_db; GRANT ALL PRIVILEGES ON wordpress_db.* TO 'mysql_user'@'%%'; FLUSH PRIVILEGES;" 2>nul
docker exec mysql_low_ram mysql -u root -pmysql_root_pass -e "CREATE DATABASE IF NOT EXISTS laravel_db; GRANT ALL PRIVILEGES ON laravel_db.* TO 'mysql_user'@'%%'; FLUSH PRIVILEGES;" 2>nul

echo.
echo 🐘 Creating PostgreSQL databases...

REM Create PostgreSQL databases
docker exec postgres_low_ram psql -U postgres_user -d postgres -c "CREATE DATABASE my_blog_db;" 2>nul
docker exec postgres_low_ram psql -U postgres_user -d postgres -c "CREATE DATABASE my_shop_db;" 2>nul
docker exec postgres_low_ram psql -U postgres_user -d postgres -c "CREATE DATABASE laravel_db;" 2>nul

echo.
echo 📊 Listing created databases...

echo.
echo MySQL Databases:
docker exec mysql_low_ram mysql -u mysql_user -pmysql_pass -e "SHOW DATABASES;" 2>nul

echo.
echo PostgreSQL Databases:
docker exec postgres_low_ram psql -U postgres_user -d postgres -c "\l" 2>nul | findstr "_db"

echo.
echo ✅ All databases created successfully!
echo.
echo 💡 Database Credentials:
echo   MySQL:     mysql_user / mysql_pass (localhost:3306)
echo   PostgreSQL: postgres_user / postgres_pass (localhost:5432)
echo.

pause
