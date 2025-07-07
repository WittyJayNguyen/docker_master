@echo off
REM Clean up old databases - keep only asmo-foodservice related

echo.
echo ========================================
echo   CLEANING UP OLD DATABASES
echo ========================================
echo.

echo 🗄️ Cleaning PostgreSQL databases...
docker exec postgres_low_ram dropdb -U postgres_user laravel74_api_example_db 2>nul
docker exec postgres_low_ram dropdb -U postgres_user laravel_php74_psql 2>nul
docker exec postgres_low_ram dropdb -U postgres_user laravel_php84_psql 2>nul
docker exec postgres_low_ram dropdb -U postgres_user main_db 2>nul
docker exec postgres_low_ram dropdb -U postgres_user my_coffee_shop_db 2>nul
docker exec postgres_low_ram dropdb -U postgres_user my_shop_db 2>nul
docker exec postgres_low_ram dropdb -U postgres_user test_auto_domain_db 2>nul
docker exec postgres_low_ram dropdb -U postgres_user test_postgresql_api_db 2>nul
docker exec postgres_low_ram dropdb -U postgres_user test_restart_db 2>nul
docker exec postgres_low_ram dropdb -U postgres_user test_shop_db 2>nul
docker exec postgres_low_ram dropdb -U postgres_user test_structure_db 2>nul
docker exec postgres_low_ram dropdb -U postgres_user wordpress_php74 2>nul

echo ✅ PostgreSQL cleanup completed

echo.
echo 📊 Remaining databases:
echo.
echo MySQL:
docker exec mysql_low_ram mysql -u root -pmysql_root_pass -e "SHOW DATABASES;" 2>nul | findstr -v "Warning"

echo.
echo PostgreSQL:
docker exec postgres_low_ram psql -U postgres_user -d postgres -c "\l" 2>nul | findstr "asmo"

echo.
echo ✅ Database cleanup completed!
echo Only ASMO-related databases remain.

pause
