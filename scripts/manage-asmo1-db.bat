@echo off
echo ========================================
echo ASMO1 Database Management Script
echo ========================================
echo.

:menu
echo Choose an option:
echo 1. Test database connection
echo 2. Show database statistics
echo 3. Backup asmo1 database
echo 4. Access MySQL CLI for asmo1
echo 5. Show tables
echo 6. Exit
echo.
set /p choice="Enter your choice (1-6): "

if "%choice%"=="1" goto test_connection
if "%choice%"=="2" goto show_stats
if "%choice%"=="3" goto backup_db
if "%choice%"=="4" goto mysql_cli
if "%choice%"=="5" goto show_tables
if "%choice%"=="6" goto exit
echo Invalid choice. Please try again.
goto menu

:test_connection
echo.
echo Testing connection to asmo1 database...
docker exec -i mysql_low_ram mysql -u mysql_user -pmysql_pass -e "USE asmo1; SELECT 'Connection successful!' as status;"
echo.
pause
goto menu

:show_stats
echo.
echo Database Statistics:
echo ====================
docker exec -i mysql_low_ram mysql -u mysql_user -pmysql_pass -e "USE asmo1; SELECT COUNT(*) as 'Total Posts' FROM wp_posts; SELECT COUNT(*) as 'Total Options' FROM wp_options; SELECT COUNT(*) as 'Total Users' FROM wp_users;"
echo.
pause
goto menu

:backup_db
echo.
echo Creating backup of asmo1 database...
set backup_file=backups\asmo1_backup_%date:~-4,4%%date:~-10,2%%date:~-7,2%_%time:~0,2%%time:~3,2%%time:~6,2%.sql
set backup_file=%backup_file: =0%
docker exec mysql_low_ram mysqldump -u mysql_user -pmysql_pass asmo1 > "%backup_file%"
echo Backup created: %backup_file%
echo.
pause
goto menu

:mysql_cli
echo.
echo Connecting to MySQL CLI for asmo1 database...
echo Type 'exit' to return to this menu.
docker exec -it mysql_low_ram mysql -u mysql_user -pmysql_pass asmo1
goto menu

:show_tables
echo.
echo Tables in asmo1 database:
echo =========================
docker exec -i mysql_low_ram mysql -u mysql_user -pmysql_pass -e "USE asmo1; SHOW TABLES;"
echo.
pause
goto menu

:exit
echo.
echo Goodbye!
pause
