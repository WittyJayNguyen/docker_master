@echo off
setlocal enabledelayedexpansion

REM Docker Development Environment Management Script for Windows
REM Usage: bin\dev.bat [command] [options]

set "SCRIPT_DIR=%~dp0"
set "PROJECT_ROOT=%SCRIPT_DIR%.."
set "COMPOSE_FILE=%PROJECT_ROOT%\docker-compose.yml"
set "ENV_FILE=%PROJECT_ROOT%\.env"

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

:log_warning
echo %YELLOW%[WARNING]%NC% %~1
goto :eof

:log_error
echo %RED%[ERROR]%NC% %~1
goto :eof

REM Check if Docker is running
:check_docker
docker info >nul 2>&1
if errorlevel 1 (
    call :log_error "Docker is not running. Please start Docker first."
    exit /b 1
)
goto :eof

REM Show help
:show_help
echo Docker Development Environment Management
echo.
echo Usage: %~nx0 [command] [options]
echo.
echo Commands:
echo   start           Start all services
echo   stop            Stop all services
echo   restart         Restart all services
echo   build           Build all images
echo   rebuild         Rebuild all images (no cache)
echo   status          Show services status
echo   logs [service]  Show logs for all services or specific service
echo   shell [service] Open shell in service container
echo   create-project  Create new project with virtual host
echo   list-projects   List all projects
echo   cleanup         Remove unused containers and images
echo   help            Show this help message
echo.
echo Examples:
echo   %~nx0 start
echo   %~nx0 logs nginx
echo   %~nx0 shell php84
echo   %~nx0 create-project myproject php84 public
echo.
echo Documentation:
echo   DOCUMENTATION.md - Choose the right guide for you
echo   docs\            - Detailed documentation folder
goto :eof

REM Start services
:start_services
call :log_info "Starting Docker development environment..."
call :check_docker
if errorlevel 1 exit /b 1

REM Auto-optimize for current system RAM
call :log_info "Running auto RAM optimization..."
call "%SCRIPT_DIR%auto-optimize.bat"

cd /d "%PROJECT_ROOT%"
docker-compose up -d
call :log_success "All services started successfully!"
call :show_status
goto :eof

REM Stop services
:stop_services
call :log_info "Stopping Docker development environment..."
cd /d "%PROJECT_ROOT%"
docker-compose down
call :log_success "All services stopped successfully!"
goto :eof

REM Restart services
:restart_services
call :log_info "Restarting Docker development environment..."
call :stop_services
call :start_services
goto :eof

REM Build images
:build_images
call :log_info "Building Docker images..."
call :check_docker
if errorlevel 1 exit /b 1
cd /d "%PROJECT_ROOT%"
docker-compose build
call :log_success "All images built successfully!"
goto :eof

REM Rebuild images (no cache)
:rebuild_images
call :log_info "Rebuilding Docker images (no cache)..."
call :check_docker
if errorlevel 1 exit /b 1
cd /d "%PROJECT_ROOT%"
docker-compose build --no-cache
call :log_success "All images rebuilt successfully!"
goto :eof

REM Show status
:show_status
call :log_info "Services status:"
cd /d "%PROJECT_ROOT%"
docker-compose ps
echo.
call :log_info "Access URLs:"
echo   Web Server: http://localhost
echo   Adminer: http://localhost:8080
echo   phpMyAdmin: http://localhost:8081
goto :eof

REM Show logs
:show_logs
cd /d "%PROJECT_ROOT%"
if "%~2"=="" (
    call :log_info "Showing logs for all services"
    docker-compose logs -f
) else (
    call :log_info "Showing logs for service: %~2"
    docker-compose logs -f %~2
)
goto :eof

REM Open shell in container
:open_shell
set "service=%~2"
if "%service%"=="" set "service=php84"
call :log_info "Opening shell in %service% container..."
cd /d "%PROJECT_ROOT%"
docker-compose exec %service% /bin/sh
goto :eof

REM Create new project
:create_project
set "project_name=%~2"
set "php_version=%~3"
set "public_dir=%~4"
if "%php_version%"=="" set "php_version=php84"
if "%public_dir%"=="" set "public_dir=public"

if "%project_name%"=="" (
    call :log_error "Project name is required"
    echo Usage: %~nx0 create-project ^<project_name^> [php_version] [public_dir]
    echo Example: %~nx0 create-project myproject php84 public
    exit /b 1
)

call :log_info "Creating project: %project_name%"

REM Create project directory
set "project_path=%PROJECT_ROOT%\www\%project_name%"
mkdir "%project_path%\%public_dir%" 2>nul

REM Create basic index.php
echo ^<?php > "%project_path%\%public_dir%\index.php"
echo phpinfo(); >> "%project_path%\%public_dir%\index.php"
echo ?^> >> "%project_path%\%public_dir%\index.php"

REM Generate nginx virtual host
call "%SCRIPT_DIR%generate-vhost.bat" "%project_name%" "%php_version%" "%public_dir%"

call :log_success "Project '%project_name%' created successfully!"
call :log_info "Project path: %project_path%"
call :log_info "Access URL: http://%project_name%.local"
call :log_warning "Don't forget to add '%project_name%.local' to your hosts file!"
goto :eof

REM List projects
:list_projects
call :log_info "Available projects:"
set "www_dir=%PROJECT_ROOT%\www"
if exist "%www_dir%" (
    for /d %%i in ("%www_dir%\*") do (
        echo   - %%~ni
    )
) else (
    call :log_warning "No projects found in %www_dir%"
)
goto :eof

REM Cleanup unused containers and images
:cleanup
call :log_info "Cleaning up unused containers and images..."
docker system prune -f
call :log_success "Cleanup completed!"
goto :eof

REM Main script logic
if "%~1"=="start" goto start_services
if "%~1"=="stop" goto stop_services
if "%~1"=="restart" goto restart_services
if "%~1"=="build" goto build_images
if "%~1"=="rebuild" goto rebuild_images
if "%~1"=="status" goto show_status
if "%~1"=="logs" goto show_logs
if "%~1"=="shell" goto open_shell
if "%~1"=="create-project" goto create_project
if "%~1"=="list-projects" goto list_projects
if "%~1"=="cleanup" goto cleanup
if "%~1"=="help" goto show_help
if "%~1"=="--help" goto show_help
if "%~1"=="-h" goto show_help
if "%~1"=="" goto show_help

call :log_error "Unknown command: %~1"
call :show_help
exit /b 1
