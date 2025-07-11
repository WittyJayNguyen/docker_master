@echo off
echo ================================================================
echo   🗄️  MYSQL BACKUP EXAMPLES
echo ================================================================
echo.

echo 📤 1. Dump toàn bộ databases:
echo docker exec mysql_low_ram mysqldump -u mysql_user -pmysql_pass --all-databases ^> backup_all.sql
echo.

echo 📤 2. Dump một database cụ thể:
echo docker exec mysql_low_ram mysqldump -u mysql_user -pmysql_pass [database_name] ^> backup_db.sql
echo.

echo 📥 3. Import database:
echo docker exec -i mysql_low_ram mysql -u mysql_user -pmysql_pass ^< backup_file.sql
echo.

echo 📥 4. Import vào database cụ thể:
echo docker exec -i mysql_low_ram mysql -u mysql_user -pmysql_pass [database_name] ^< backup_file.sql
echo.

echo 📊 5. Xem danh sách databases:
echo docker exec mysql_low_ram mysql -u mysql_user -pmysql_pass -e "SHOW DATABASES;"
echo.

echo 🔧 6. Kết nối MySQL CLI:
echo docker exec -it mysql_low_ram mysql -u mysql_user -pmysql_pass
echo.

echo ================================================================
echo   Thông tin kết nối MySQL:
echo   Host: localhost:3306
echo   Username: mysql_user  
echo   Password: mysql_pass
echo   Container: mysql_low_ram
echo ================================================================
echo.

pause
