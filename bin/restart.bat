@echo off
setlocal enabledelayedexpansion

REM Docker Development Environment - Restart Script
REM Safely restarts all Docker services

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
echo %BLUE%          Restart Services%NC%
echo %BLUE%========================================%NC%
echo.

REM Check if Docker is running
call :log_info "Checking Docker status..."
docker info >nul 2>&1
if errorlevel 1 (
    call :log_error "Docker is not running. Please start Docker Desktop first."
    pause
    exit /b 1
)

REM Change to project directory
cd /d "%PROJECT_ROOT%"

REM Show current status
call :log_info "Current service status:"
docker-compose ps
echo.

REM Parse command line arguments
set "SERVICE=%~1"
if not "%SERVICE%"=="" (
    call :log_info "Restarting specific service: %SERVICE%"
    docker-compose restart %SERVICE%
    
    if errorlevel 1 (
        call :log_error "Failed to restart service: %SERVICE%"
        echo.
        call :log_info "Available services:"
        docker-compose ps --services
        pause
        exit /b 1
    )
    
    call :log_success "Service %SERVICE% restarted successfully!"
    goto :show_final_status
)

REM Restart all services
call :log_info "Restarting all Docker services..."

REM Method 1: Try graceful restart first
call :log_info "Attempting graceful restart..."
docker-compose restart

if errorlevel 1 (
    call :log_warning "Graceful restart failed. Trying stop and start..."
    
    REM Method 2: Stop and start
    call :log_info "Stopping services..."
    docker-compose stop
    
    if errorlevel 1 (
        call :log_warning "Stop failed. Trying force down..."
        docker-compose down
    )
    
    call :log_info "Starting services..."
    docker-compose up -d
    
    if errorlevel 1 (
        call :log_error "Failed to start services after restart."
        echo.
        call :log_info "Try these troubleshooting steps:"
        echo   1. Check Docker Desktop is running properly
        echo   2. Check for port conflicts
        echo   3. Run: %SCRIPT_DIR%reset.bat (if desperate)
        echo   4. Check logs: docker-compose logs
        pause
        exit /b 1
    )
)

call :log_success "All services restarted successfully!"

:show_final_status
echo.
call :log_info "Waiting for services to be ready..."
timeout /t 5 /nobreak >nul

echo.
call :log_info "Final service status:"
docker-compose ps
echo.

REM Check if services are healthy
call :log_info "Checking service health..."

REM Test web access
powershell -Command "try { Invoke-WebRequest -Uri 'http://localhost' -UseBasicParsing -TimeoutSec 5 | Out-Null; Write-Host '[SUCCESS] Web server is responding' -ForegroundColor Green } catch { Write-Host '[WARNING] Web server not responding yet' -ForegroundColor Yellow }"

REM Test database
docker-compose exec -T mysql mysql -u dev_user -pdev_pass -e "SELECT 'MySQL OK' as status;" 2>nul && (
    call :log_success "MySQL is responding"
) || (
    call :log_warning "MySQL not responding yet"
)

echo.
call :log_success "🎉 Restart operation completed!"
echo.

echo %YELLOW%Quick Access:%NC%
echo   Main Page:     http://localhost
echo   Adminer:       http://localhost:8080
echo   phpMyAdmin:    http://localhost:8081
echo.

echo %YELLOW%Useful Commands:%NC%
echo   Status:        %SCRIPT_DIR%dev.bat status
echo   Logs:          %SCRIPT_DIR%dev.bat logs
echo   Stop:          %SCRIPT_DIR%stop.bat
echo   Full Reset:    %SCRIPT_DIR%reset.bat
echo.

REM Show resource usage
call :log_info "Current resource usage:"
docker stats --no-stream --format "table {{.Name}}\t{{.CPUPerc}}\t{{.MemUsage}}\t{{.MemPerc}}" 2>nul

echo.
pause
