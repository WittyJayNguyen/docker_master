@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

echo.
echo ================================================================
echo   🗄️  MYSQL BACKUP & RESTORE GUIDE
echo ================================================================
echo.

:MENU
echo 📋 Chọn thao tác:
echo ----------------------------------------------------------------
echo   1. 📤 Dump (Xuất) Database
echo   2. 📥 Import (Nhập) Database  
echo   3. 📊 Xem danh sách databases
echo   4. 🔧 Kết nối MySQL CLI
echo   5. ❌ Thoát
echo.
set /p choice="Nhập lựa chọn (1-5): "

if "%choice%"=="1" goto DUMP_MENU
if "%choice%"=="2" goto IMPORT_MENU
if "%choice%"=="3" goto LIST_DATABASES
if "%choice%"=="4" goto MYSQL_CLI
if "%choice%"=="5" goto END
goto MENU

:DUMP_MENU
echo.
echo 📤 DUMP DATABASE OPTIONS:
echo ----------------------------------------------------------------
echo   1. Dump toàn bộ databases
echo   2. Dump một database cụ thể
echo   3. Dump một table cụ thể
echo   4. Quay lại menu chính
echo.
set /p dump_choice="Nhập lựa chọn (1-4): "

if "%dump_choice%"=="1" goto DUMP_ALL
if "%dump_choice%"=="2" goto DUMP_SINGLE_DB
if "%dump_choice%"=="3" goto DUMP_SINGLE_TABLE
if "%dump_choice%"=="4" goto MENU
goto DUMP_MENU

:DUMP_ALL
echo.
echo 📤 Đang dump toàn bộ databases...
echo ----------------------------------------------------------------
set backup_file=backup_all_databases_%date:~-4,4%%date:~-10,2%%date:~-7,2%_%time:~0,2%%time:~3,2%%time:~6,2%.sql
set backup_file=%backup_file: =0%
docker exec mysql_low_ram mysqldump -u mysql_user -pmysql_pass --all-databases > "%backup_file%"
if errorlevel 1 (
    echo ❌ Lỗi khi dump database!
) else (
    echo ✅ Dump thành công: %backup_file%
    echo 📁 File được lưu tại: %cd%\%backup_file%
)
pause
goto MENU

:DUMP_SINGLE_DB
echo.
echo 📤 Dump một database cụ thể:
echo ----------------------------------------------------------------
set /p db_name="Nhập tên database: "
if "%db_name%"=="" (
    echo ❌ Tên database không được để trống!
    pause
    goto DUMP_SINGLE_DB
)
set backup_file=backup_%db_name%_%date:~-4,4%%date:~-10,2%%date:~-7,2%_%time:~0,2%%time:~3,2%%time:~6,2%.sql
set backup_file=%backup_file: =0%
docker exec mysql_low_ram mysqldump -u mysql_user -pmysql_pass %db_name% > "%backup_file%"
if errorlevel 1 (
    echo ❌ Lỗi khi dump database %db_name%!
) else (
    echo ✅ Dump thành công: %backup_file%
    echo 📁 File được lưu tại: %cd%\%backup_file%
)
pause
goto MENU

:DUMP_SINGLE_TABLE
echo.
echo 📤 Dump một table cụ thể:
echo ----------------------------------------------------------------
set /p db_name="Nhập tên database: "
set /p table_name="Nhập tên table: "
if "%db_name%"=="" (
    echo ❌ Tên database không được để trống!
    pause
    goto DUMP_SINGLE_TABLE
)
if "%table_name%"=="" (
    echo ❌ Tên table không được để trống!
    pause
    goto DUMP_SINGLE_TABLE
)
set backup_file=backup_%db_name%_%table_name%_%date:~-4,4%%date:~-10,2%%date:~-7,2%_%time:~0,2%%time:~3,2%%time:~6,2%.sql
set backup_file=%backup_file: =0%
docker exec mysql_low_ram mysqldump -u mysql_user -pmysql_pass %db_name% %table_name% > "%backup_file%"
if errorlevel 1 (
    echo ❌ Lỗi khi dump table %table_name%!
) else (
    echo ✅ Dump thành công: %backup_file%
    echo 📁 File được lưu tại: %cd%\%backup_file%
)
pause
goto MENU

:IMPORT_MENU
echo.
echo 📥 IMPORT DATABASE OPTIONS:
echo ----------------------------------------------------------------
echo   1. Import từ file SQL
echo   2. Import và tạo database mới
echo   3. Quay lại menu chính
echo.
set /p import_choice="Nhập lựa chọn (1-3): "

if "%import_choice%"=="1" goto IMPORT_FILE
if "%import_choice%"=="2" goto IMPORT_NEW_DB
if "%import_choice%"=="3" goto MENU
goto IMPORT_MENU

:IMPORT_FILE
echo.
echo 📥 Import từ file SQL:
echo ----------------------------------------------------------------
set /p sql_file="Nhập đường dẫn file SQL: "
if "%sql_file%"=="" (
    echo ❌ Đường dẫn file không được để trống!
    pause
    goto IMPORT_FILE
)
if not exist "%sql_file%" (
    echo ❌ File không tồn tại: %sql_file%
    pause
    goto IMPORT_FILE
)
echo 📥 Đang import file: %sql_file%
docker exec -i mysql_low_ram mysql -u mysql_user -pmysql_pass < "%sql_file%"
if errorlevel 1 (
    echo ❌ Lỗi khi import file!
) else (
    echo ✅ Import thành công!
)
pause
goto MENU

:IMPORT_NEW_DB
echo.
echo 📥 Import và tạo database mới:
echo ----------------------------------------------------------------
set /p new_db_name="Nhập tên database mới: "
set /p sql_file="Nhập đường dẫn file SQL: "
if "%new_db_name%"=="" (
    echo ❌ Tên database không được để trống!
    pause
    goto IMPORT_NEW_DB
)
if "%sql_file%"=="" (
    echo ❌ Đường dẫn file không được để trống!
    pause
    goto IMPORT_NEW_DB
)
if not exist "%sql_file%" (
    echo ❌ File không tồn tại: %sql_file%
    pause
    goto IMPORT_NEW_DB
)
echo 🔧 Tạo database: %new_db_name%
docker exec mysql_low_ram mysql -u mysql_user -pmysql_pass -e "CREATE DATABASE IF NOT EXISTS %new_db_name%;"
echo 📥 Đang import vào database: %new_db_name%
docker exec -i mysql_low_ram mysql -u mysql_user -pmysql_pass %new_db_name% < "%sql_file%"
if errorlevel 1 (
    echo ❌ Lỗi khi import!
) else (
    echo ✅ Tạo và import database thành công!
)
pause
goto MENU

:LIST_DATABASES
echo.
echo 📊 Danh sách databases:
echo ----------------------------------------------------------------
docker exec mysql_low_ram mysql -u mysql_user -pmysql_pass -e "SHOW DATABASES;"
pause
goto MENU

:MYSQL_CLI
echo.
echo 🔧 Kết nối MySQL CLI:
echo ----------------------------------------------------------------
echo 💡 Sử dụng lệnh sau để thoát: exit
echo.
docker exec -it mysql_low_ram mysql -u mysql_user -pmysql_pass
goto MENU

:END
echo.
echo 👋 Cảm ơn bạn đã sử dụng MySQL Backup & Restore Tool!
echo.
pause
exit /b 0
