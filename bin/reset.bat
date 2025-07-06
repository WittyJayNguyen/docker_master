@echo off
setlocal enabledelayedexpansion

REM Docker Development Environment - Reset Script
REM Completely resets the environment (DANGEROUS - removes all data)

set "SCRIPT_DIR=%~dp0"
set "PROJECT_ROOT=%SCRIPT_DIR%.."

REM Colors
set "GREEN=[92m"
set "BLUE=[94m"
set "YELLOW=[93m"
set "RED=[91m"
set "NC=[0m"

REM Helper functions
:log_info
echo %BLUE%[INFO]%NC% %~1
goto :eof

:log_success
echo %GREEN%[SUCCESS]%NC% %~1
goto :eof

:log_warning
echo %YELLOW%[WARNING]%NC% %~1
goto :eof

:log_error
echo %RED%[ERROR]%NC% %~1
goto :eof

echo %RED%========================================%NC%
echo %RED%   Docker Development Environment%NC%
echo %RED%           RESET ENVIRONMENT%NC%
echo %RED%        ⚠️  DANGER ZONE ⚠️%NC%
echo %RED%========================================%NC%
echo.

call :log_warning "This script will COMPLETELY RESET your development environment!"
echo.
echo %RED%What will be DELETED:%NC%
echo   ❌ All database data (MySQL, PostgreSQL)
echo   ❌ All containers and images
echo   ❌ All logs
echo   ❌ RAM optimization cache
echo   ❌ Auto-generated virtual hosts
echo.
echo %GREEN%What will be PRESERVED:%NC%
echo   ✅ Your project files in www/
echo   ✅ Configuration files (.env, docker-compose.yml)
echo   ✅ Custom virtual host templates
echo.

REM Multiple confirmations for safety
set /p confirm1="Are you ABSOLUTELY SURE you want to reset everything? (yes/no): "
if /i not "%confirm1%"=="yes" (
    echo Operation cancelled for safety.
    pause
    exit /b 0
)

echo.
call :log_warning "Last chance! This action CANNOT be undone!"
set /p confirm2="Type 'RESET' in capital letters to confirm: "
if not "%confirm2%"=="RESET" (
    echo Operation cancelled. You must type exactly 'RESET' to confirm.
    pause
    exit /b 0
)

echo.
call :log_warning "Starting reset in 5 seconds... Press Ctrl+C to cancel!"
timeout /t 5

echo.
call :log_info "🔄 Starting complete environment reset..."

REM Change to project directory
cd /d "%PROJECT_ROOT%"

REM Step 1: Stop and remove all containers
call :log_info "Step 1/7: Stopping and removing all containers..."
docker-compose down -v --remove-orphans
if errorlevel 1 (
    call :log_warning "Some containers may not have stopped cleanly."
)

REM Step 2: Remove all Docker images related to this project
call :log_info "Step 2/7: Removing Docker images..."
for /f "tokens=1" %%i in ('docker images --format "{{.Repository}}:{{.Tag}}" ^| findstr "docker-dev-env\|dev_"') do (
    call :log_info "Removing image: %%i"
    docker rmi %%i --force
)

REM Step 3: Clean up Docker system
call :log_info "Step 3/7: Cleaning up Docker system..."
docker system prune -f
docker volume prune -f

REM Step 4: Remove database data
call :log_info "Step 4/7: Removing database data..."
if exist "database\mysql\data" (
    rmdir /s /q "database\mysql\data" 2>nul
    mkdir "database\mysql\data"
    call :log_success "MySQL data removed"
)

if exist "database\postgresql\data" (
    rmdir /s /q "database\postgresql\data" 2>nul
    mkdir "database\postgresql\data"
    call :log_success "PostgreSQL data removed"
)

if exist "database\redis\data" (
    rmdir /s /q "database\redis\data" 2>nul
    mkdir "database\redis\data"
    call :log_success "Redis data removed"
)

REM Step 5: Clear logs
call :log_info "Step 5/7: Clearing logs..."
if exist "logs" (
    for /d %%d in (logs\*) do (
        if exist "%%d" (
            del /q "%%d\*" 2>nul
            call :log_success "Cleared logs in %%d"
        )
    )
)

REM Step 6: Remove auto-generated configs
call :log_info "Step 6/7: Removing auto-generated configurations..."

REM Remove RAM optimization cache
if exist ".ram-optimized" (
    del ".ram-optimized"
    call :log_success "RAM optimization cache removed"
)

REM Remove auto-generated virtual hosts (keep templates)
if exist "nginx\sites" (
    for %%f in (nginx\sites\*.local.conf) do (
        del "%%f"
        call :log_success "Removed virtual host: %%f"
    )
)

REM Step 7: Reset optimization configurations to defaults
call :log_info "Step 7/7: Resetting configurations to defaults..."

REM Reset MySQL config to basic
if exist "database\mysql\conf\my.cnf" (
    (
        echo [mysqld]
        echo # Basic MySQL configuration
        echo ssl = 0
        echo require_secure_transport = OFF
        echo character-set-server = utf8mb4
        echo collation-server = utf8mb4_unicode_ci
        echo max_connections = 200
        echo max_allowed_packet = 64M
        echo innodb_buffer_pool_size = 256M
        echo query_cache_size = 32M
        echo.
        echo [mysql]
        echo default-character-set = utf8mb4
        echo.
        echo [client]
        echo default-character-set = utf8mb4
    ) > "database\mysql\conf\my.cnf"
    call :log_success "MySQL configuration reset to defaults"
)

REM Reset PHP configs to basic
for %%v in (7.4 8.2 8.4) do (
    if exist "php\%%v\php.ini" (
        (
            echo [PHP]
            echo memory_limit = 512M
            echo max_execution_time = 300
            echo display_errors = On
            echo log_errors = On
            echo error_reporting = E_ALL
            echo opcache.enable = 1
            echo opcache.memory_consumption = 128
            echo opcache.max_accelerated_files = 4000
            echo date.timezone = Asia/Ho_Chi_Minh
        ) > "php\%%v\php.ini"
        call :log_success "PHP %%v configuration reset to defaults"
    )
)

echo.
call :log_success "🎉 Complete environment reset finished!"
echo.

call :log_info "Environment has been completely reset to factory defaults."
echo.
echo %GREEN%Next steps:%NC%
echo   1. Run auto-optimization: %SCRIPT_DIR%auto-optimize.bat
echo   2. Start environment: %SCRIPT_DIR%dev.bat start
echo   3. Create your projects again
echo.

call :log_warning "Remember to:"
echo   - Recreate your databases
echo   - Restore any custom configurations
echo   - Re-add virtual hosts for existing projects
echo.

set /p start_fresh="Do you want to start the environment now? (y/N): "
if /i "%start_fresh%"=="y" (
    echo.
    call :log_info "Starting fresh environment..."
    call "%SCRIPT_DIR%auto-optimize.bat"
    call "%SCRIPT_DIR%dev.bat" start
) else (
    echo.
    call :log_info "Environment reset complete. Start when ready with:"
    echo   %SCRIPT_DIR%dev.bat start
)

echo.
call :log_success "Reset operation completed successfully!"
pause
