@echo off
setlocal enabledelayedexpansion

if "%1"=="" (
    echo 🗄️ Database Management for Docker Multi-Project
    echo Usage: .\scripts\database.bat [command]
    echo.
    echo Commands:
    echo   status                    - Show database status
    echo   mysql                     - Connect to MySQL CLI
    echo   postgres                  - Connect to PostgreSQL CLI
    echo   mysql-dump [db_name]      - Backup MySQL database
    echo   postgres-dump [db_name]   - Backup PostgreSQL database
    echo   mysql-restore [db] [file] - Restore MySQL database
    echo   postgres-restore [db] [file] - Restore PostgreSQL database
    echo   mysql-create [db_name]    - Create MySQL database
    echo   postgres-create [db_name] - Create PostgreSQL database
    echo.
    pause
    exit /b 0
)

if "%1"=="status" (
    echo 🗄️ Database Management for Docker Multi-Project...
    echo 📊 Database Status:
    echo.
    echo MySQL:
    docker-compose exec mysql_db mysqladmin -u root -prootpassword123 status 2>nul
    if !errorlevel! equ 0 (
        echo   Status: ✅ Running
        echo   Host: localhost:3306
        echo   Databases: wordpress_db, laravel_db, main_db
    ) else (
        echo   Status: ❌ Not running
    )
    echo.
    echo PostgreSQL:
    docker-compose exec postgres_db pg_isready -U postgres 2>nul
    if !errorlevel! equ 0 (
        echo   Status: ✅ Running
        echo   Host: localhost:5432
        echo   Databases: wordpress_db, laravel_db, main_db
    ) else (
        echo   Status: ❌ Not running
    )
    echo.
    echo Management Interfaces:
    echo   phpMyAdmin (MySQL): http://localhost:8080
    echo   pgAdmin (PostgreSQL): http://localhost:8081
    echo.
)

if "%1"=="mysql" (
    echo 🐬 Connecting to MySQL...
    docker-compose exec mysql_db mysql -u root -prootpassword123
)

if "%1"=="postgres" (
    echo 🐘 Connecting to PostgreSQL...
    docker-compose exec postgres_db psql -U postgres
)

if "%1"=="mysql-dump" (
    if "%2"=="" (
        echo ❌ Please specify database name
        echo Usage: .\scripts\database.bat mysql-dump [database_name]
        pause
        exit /b 1
    )
    set timestamp=%date:~-4,4%%date:~-10,2%%date:~-7,2%_%time:~0,2%%time:~3,2%%time:~6,2%
    set timestamp=!timestamp: =0!
    set filename=backups\mysql\mysql_%2_!timestamp!.sql
    echo 💾 Backing up MySQL database: %2
    docker-compose exec mysql_db mysqldump -u root -prootpassword123 %2 > !filename!
    echo ✅ Backup saved to: !filename!
)

if "%1"=="postgres-dump" (
    if "%2"=="" (
        echo ❌ Please specify database name
        echo Usage: .\scripts\database.bat postgres-dump [database_name]
        pause
        exit /b 1
    )
    set timestamp=%date:~-4,4%%date:~-10,2%%date:~-7,2%_%time:~0,2%%time:~3,2%%time:~6,2%
    set timestamp=!timestamp: =0!
    set filename=backups\postgres\postgres_%2_!timestamp!.sql
    echo 💾 Backing up PostgreSQL database: %2
    docker-compose exec postgres_db pg_dump -U postgres %2 > !filename!
    echo ✅ Backup saved to: !filename!
)

if "%1"=="mysql-create" (
    if "%2"=="" (
        echo ❌ Please specify database name
        echo Usage: .\scripts\database.bat mysql-create [database_name]
        pause
        exit /b 1
    )
    echo 🆕 Creating MySQL database: %2
    docker-compose exec mysql_db mysql -u root -prootpassword123 -e "CREATE DATABASE IF NOT EXISTS %2;"
    echo ✅ Database %2 created successfully!
)

if "%1"=="postgres-create" (
    if "%2"=="" (
        echo ❌ Please specify database name
        echo Usage: .\scripts\database.bat postgres-create [database_name]
        pause
        exit /b 1
    )
    echo 🆕 Creating PostgreSQL database: %2
    docker-compose exec postgres_db createdb -U postgres %2
    echo ✅ Database %2 created successfully!
)

pause
