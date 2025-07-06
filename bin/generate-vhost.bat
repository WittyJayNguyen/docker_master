@echo off
setlocal enabledelayedexpansion

REM Generate Nginx Virtual Host Configuration for Windows
REM Usage: bin\generate-vhost.bat <project_name> [php_version] [public_dir]

set "SCRIPT_DIR=%~dp0"
set "PROJECT_ROOT=%SCRIPT_DIR%.."
set "NGINX_SITES_DIR=%PROJECT_ROOT%\nginx\sites"
set "TEMPLATE_FILE=%NGINX_SITES_DIR%\project-template.conf"

REM Colors (limited support in Windows)
set "RED=[91m"
set "GREEN=[92m"
set "YELLOW=[93m"
set "BLUE=[94m"
set "NC=[0m"

REM Helper functions
:log_info
echo %BLUE%[INFO]%NC% %~1
goto :eof

:log_success
echo %GREEN%[SUCCESS]%NC% %~1
goto :eof

:log_error
echo %RED%[ERROR]%NC% %~1
goto :eof

REM Parameters
set "PROJECT_NAME=%~1"
set "PHP_VERSION=%~2"
set "PUBLIC_DIR=%~3"

if "%PHP_VERSION%"=="" set "PHP_VERSION=dev_php84"
if "%PUBLIC_DIR%"=="" set "PUBLIC_DIR=public"

REM Validate parameters
if "%PROJECT_NAME%"=="" (
    call :log_error "Project name is required"
    echo Usage: %~nx0 ^<project_name^> [php_version] [public_dir]
    echo Example: %~nx0 myproject dev_php84 public
    exit /b 1
)

REM Validate PHP version
set "PHP_CONTAINER="
if "%PHP_VERSION%"=="php74" set "PHP_CONTAINER=dev_php74"
if "%PHP_VERSION%"=="dev_php74" set "PHP_CONTAINER=dev_php74"
if "%PHP_VERSION%"=="php82" set "PHP_CONTAINER=dev_php82"
if "%PHP_VERSION%"=="dev_php82" set "PHP_CONTAINER=dev_php82"
if "%PHP_VERSION%"=="php84" set "PHP_CONTAINER=dev_php84"
if "%PHP_VERSION%"=="dev_php84" set "PHP_CONTAINER=dev_php84"

if "%PHP_CONTAINER%"=="" (
    call :log_error "Invalid PHP version: %PHP_VERSION%"
    echo Valid options: php74, php82, php84
    exit /b 1
)

REM Create nginx sites directory if it doesn't exist
if not exist "%NGINX_SITES_DIR%" mkdir "%NGINX_SITES_DIR%"

REM Generate virtual host configuration
set "VHOST_FILE=%NGINX_SITES_DIR%\%PROJECT_NAME%.local.conf"

call :log_info "Generating virtual host for project: %PROJECT_NAME%"
call :log_info "PHP Version: %PHP_CONTAINER%"
call :log_info "Public Directory: %PUBLIC_DIR%"

REM Check if template exists
if not exist "%TEMPLATE_FILE%" (
    call :log_error "Template file not found: %TEMPLATE_FILE%"
    exit /b 1
)

REM Generate the virtual host configuration using PowerShell for better text processing
powershell -Command "(Get-Content '%TEMPLATE_FILE%') -replace '{{PROJECT_NAME}}', '%PROJECT_NAME%' -replace '{{PHP_VERSION}}', '%PHP_CONTAINER%' -replace '{{PUBLIC_DIR}}', '%PUBLIC_DIR%' | Set-Content '%VHOST_FILE%'"

call :log_success "Virtual host configuration created: %VHOST_FILE%"

REM Check if project uses Laravel
if exist "%PROJECT_ROOT%\www\%PROJECT_NAME%\artisan" (
    call :log_info "Laravel project detected. Virtual host is configured for Laravel."
)

REM Check if project uses WordPress
if exist "%PROJECT_ROOT%\www\%PROJECT_NAME%\wp-config.php" (
    call :log_info "WordPress project detected. You may need to manually adjust the virtual host configuration."
)
if exist "%PROJECT_ROOT%\www\%PROJECT_NAME%\%PUBLIC_DIR%\wp-config.php" (
    call :log_info "WordPress project detected. You may need to manually adjust the virtual host configuration."
)

REM Show next steps
echo.
call :log_info "Next steps:"
echo 1. Add the following line to your hosts file:
echo    127.0.0.1 %PROJECT_NAME%.local
echo.
echo 2. Restart nginx to load the new configuration:
echo    docker-compose restart nginx
echo.
echo 3. Access your project at:
echo    http://%PROJECT_NAME%.local
echo.

REM Offer to restart nginx
set /p "restart=Do you want to restart nginx now? (y/N): "
if /i "%restart%"=="y" (
    call :log_info "Restarting nginx..."
    cd /d "%PROJECT_ROOT%"
    docker-compose restart nginx
    call :log_success "Nginx restarted successfully!"
)
