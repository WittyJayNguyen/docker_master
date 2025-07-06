@echo off
setlocal enabledelayedexpansion

REM Docker Development Environment - Quick Start Script
REM Shortcut for dev.bat start with additional features

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
echo %BLUE%           Quick Start%NC%
echo %BLUE%========================================%NC%
echo.

REM Check if Docker is running
call :log_info "Checking Docker status..."
docker info >nul 2>&1
if errorlevel 1 (
    call :log_error "Docker is not running. Please start Docker Desktop first."
    echo.
    echo Steps to fix:
    echo   1. Start Docker Desktop
    echo   2. Wait for Docker to fully start
    echo   3. Run this script again
    pause
    exit /b 1
)

call :log_success "Docker is running!"

REM Check if environment exists
cd /d "%PROJECT_ROOT%"

if not exist ".env" (
    call :log_warning "Environment file not found."
    if exist ".env.example" (
        call :log_info "Creating .env from template..."
        copy ".env.example" ".env" >nul
        call :log_success "Environment file created!"
    ) else (
        call :log_error "No .env.example found. Please check your installation."
        pause
        exit /b 1
    )
)

REM Check if services are already running
call :log_info "Checking current service status..."
docker-compose ps --services --filter "status=running" >nul 2>&1
if not errorlevel 1 (
    call :log_info "Some services are already running:"
    docker-compose ps
    echo.
    set /p restart="Do you want to restart all services? (y/N): "
    if /i "!restart!"=="y" (
        call :log_info "Restarting services..."
        docker-compose restart
        goto :show_status
    ) else (
        call :log_info "Keeping current services running."
        goto :show_status
    )
)

REM Run auto-optimization if not done recently
if not exist ".ram-optimized" (
    call :log_info "Running auto RAM optimization..."
    call "%SCRIPT_DIR%auto-optimize.bat"
    echo.
)

REM Start services using dev.bat
call :log_info "Starting Docker development environment..."
call "%SCRIPT_DIR%dev.bat" start

if errorlevel 1 (
    call :log_error "Failed to start services."
    echo.
    call :log_info "Troubleshooting steps:"
    echo   1. Check Docker Desktop is running
    echo   2. Check for port conflicts
    echo   3. Try: %SCRIPT_DIR%reset.bat (if desperate)
    echo   4. Check logs: docker-compose logs
    pause
    exit /b 1
)

:show_status
echo.
call :log_success "Environment is ready!"

REM Show quick access information
echo.
echo %GREEN%========================================%NC%
echo %GREEN%   Quick Access Information%NC%
echo %GREEN%========================================%NC%
echo.

echo %YELLOW%🌐 Web Access:%NC%
echo   Main Page:        http://localhost
echo   Database Test:    http://localhost/test-db.php
echo   RAM Status:       http://localhost/ram-optimization.php
echo   Adminer:          http://localhost:8080
echo   phpMyAdmin:       http://localhost:8081
echo.

echo %YELLOW%🗄️ Database Info:%NC%
echo   MySQL:     localhost:3306 (user: dev_user, pass: dev_pass)
echo   PostgreSQL: localhost:5432 (user: dev_user, pass: dev_pass)
echo   Redis:     localhost:6379
echo.

echo %YELLOW%🔧 Quick Commands:%NC%
echo   Stop:      %SCRIPT_DIR%stop.bat
echo   Restart:   %SCRIPT_DIR%start.bat
echo   Reset:     %SCRIPT_DIR%reset.bat
echo   Status:    %SCRIPT_DIR%dev.bat status
echo   Logs:      %SCRIPT_DIR%dev.bat logs
echo   Help:      %SCRIPT_DIR%dev.bat help
echo.

echo %YELLOW%📁 Create Project:%NC%
echo   %SCRIPT_DIR%dev.bat create-project myproject php84 public
echo.

echo %YELLOW%📚 Documentation:%NC%
echo   DOCUMENTATION.md - Choose the right guide
echo   docs\            - Detailed documentation
echo.

REM Check if any projects exist
if exist "www" (
    call :log_info "Existing projects:"
    for /d %%d in (www\*) do (
        if exist "%%d" (
            echo   - %%~nd
        )
    )
    echo.
)

REM Offer to open browser
set /p open_browser="Open main page in browser? (y/N): "
if /i "%open_browser%"=="y" (
    start http://localhost
    call :log_success "Browser opened!"
)

echo.
call :log_success "🎉 Docker Development Environment is ready to use!"
echo.

REM Show resource usage
call :log_info "Current resource usage:"
docker stats --no-stream --format "table {{.Name}}\t{{.CPUPerc}}\t{{.MemUsage}}\t{{.MemPerc}}" 2>nul

echo.
call :log_info "Happy coding! 🚀"
pause
