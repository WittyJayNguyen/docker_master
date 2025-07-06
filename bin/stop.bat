@echo off
setlocal enabledelayedexpansion

REM Docker Development Environment - Stop Script
REM Safely stops all Docker services

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

echo %BLUE%========================================%NC%
echo %BLUE%   Docker Development Environment%NC%
echo %BLUE%           Stop Services%NC%
echo %BLUE%========================================%NC%
echo.

REM Check if Docker is running
call :log_info "Checking Docker status..."
docker info >nul 2>&1
if errorlevel 1 (
    call :log_warning "Docker is not running or not accessible."
    echo Services may already be stopped.
    pause
    exit /b 0
)

REM Change to project directory
cd /d "%PROJECT_ROOT%"

REM Check if services are running
call :log_info "Checking running services..."
docker-compose ps --services --filter "status=running" >nul 2>&1
if errorlevel 1 (
    call :log_warning "No services appear to be running."
    echo.
    call :log_info "Current service status:"
    docker-compose ps
    echo.
    set /p continue="Do you want to run stop anyway? (y/N): "
    if /i not "!continue!"=="y" (
        echo Operation cancelled.
        pause
        exit /b 0
    )
)

REM Show current status
call :log_info "Current service status:"
docker-compose ps
echo.

REM Confirm stop
set /p confirm="Are you sure you want to stop all services? (y/N): "
if /i not "%confirm%"=="y" (
    echo Operation cancelled.
    pause
    exit /b 0
)

echo.
call :log_info "Stopping Docker development environment..."

REM Stop services gracefully
call :log_info "Stopping services gracefully..."
docker-compose stop

if errorlevel 1 (
    call :log_error "Failed to stop services gracefully."
    echo.
    call :log_info "Attempting force stop..."
    docker-compose down
    
    if errorlevel 1 (
        call :log_error "Force stop also failed."
        echo.
        call :log_info "You may need to stop services manually:"
        echo   docker-compose down --remove-orphans
        echo   docker-compose kill
        pause
        exit /b 1
    )
)

echo.
call :log_success "All services stopped successfully!"

REM Show final status
echo.
call :log_info "Final service status:"
docker-compose ps
echo.

REM Show resource cleanup info
call :log_info "Services have been stopped but containers still exist."
echo To completely remove containers and free up resources:
echo   %SCRIPT_DIR%reset.bat
echo.
echo To start services again:
echo   %SCRIPT_DIR%dev.bat start
echo   or
echo   %SCRIPT_DIR%start.bat
echo.

call :log_success "Stop operation completed!"
pause
