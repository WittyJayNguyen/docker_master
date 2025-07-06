@echo off
setlocal enabledelayedexpansion

REM Docker Development Environment - Status Script
REM Shows comprehensive status of all services and system

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
echo %BLUE%           System Status%NC%
echo %BLUE%========================================%NC%
echo.

REM Change to project directory
cd /d "%PROJECT_ROOT%"

REM Check Docker status
call :log_info "Docker System Status:"
docker info >nul 2>&1
if errorlevel 1 (
    call :log_error "Docker is not running or not accessible"
    echo Please start Docker Desktop and try again.
    pause
    exit /b 1
) else (
    call :log_success "Docker is running"
)

REM Show Docker version
for /f "tokens=3" %%i in ('docker --version') do set docker_version=%%i
echo   Docker version: %docker_version%

REM Show Docker Compose version
for /f "tokens=4" %%i in ('docker-compose --version') do set compose_version=%%i
echo   Docker Compose version: %compose_version%
echo.

REM Show container status
call :log_info "Container Status:"
docker-compose ps
echo.

REM Show detailed service status
call :log_info "Service Health Check:"

REM Check web server
powershell -Command "try { $response = Invoke-WebRequest -Uri 'http://localhost' -UseBasicParsing -TimeoutSec 3; Write-Host '  ✅ Web Server (Port 80): OK' -ForegroundColor Green } catch { Write-Host '  ❌ Web Server (Port 80): Not responding' -ForegroundColor Red }"

REM Check Adminer
powershell -Command "try { $response = Invoke-WebRequest -Uri 'http://localhost:8080' -UseBasicParsing -TimeoutSec 3; Write-Host '  ✅ Adminer (Port 8080): OK' -ForegroundColor Green } catch { Write-Host '  ❌ Adminer (Port 8080): Not responding' -ForegroundColor Red }"

REM Check phpMyAdmin
powershell -Command "try { $response = Invoke-WebRequest -Uri 'http://localhost:8081' -UseBasicParsing -TimeoutSec 3; Write-Host '  ✅ phpMyAdmin (Port 8081): OK' -ForegroundColor Green } catch { Write-Host '  ❌ phpMyAdmin (Port 8081): Not responding' -ForegroundColor Red }"

REM Check MySQL
docker-compose exec -T mysql mysql -u dev_user -pdev_pass -e "SELECT 'OK' as status;" 2>nul >nul && (
    echo   %GREEN%✅ MySQL Database: OK%NC%
) || (
    echo   %RED%❌ MySQL Database: Not responding%NC%
)

REM Check PostgreSQL
docker-compose exec -T postgresql psql -U dev_user -d dev_db -c "SELECT 'OK' as status;" 2>nul >nul && (
    echo   %GREEN%✅ PostgreSQL Database: OK%NC%
) || (
    echo   %RED%❌ PostgreSQL Database: Not responding%NC%
)

REM Check Redis
docker-compose exec -T redis redis-cli ping 2>nul | findstr "PONG" >nul && (
    echo   %GREEN%✅ Redis Cache: OK%NC%
) || (
    echo   %RED%❌ Redis Cache: Not responding%NC%
)

echo.

REM Show resource usage
call :log_info "Resource Usage:"
docker stats --no-stream --format "table {{.Name}}\t{{.CPUPerc}}\t{{.MemUsage}}\t{{.MemPerc}}"
echo.

REM Show disk usage
call :log_info "Docker Disk Usage:"
docker system df
echo.

REM Show RAM optimization status
if exist ".ram-optimized" (
    for /f %%i in ('type ".ram-optimized"') do set ram_optimized=%%i
    call :log_success "RAM Optimization: Configured for !ram_optimized!GB"
) else (
    call :log_warning "RAM Optimization: Not configured (run auto-optimize.bat)"
)
echo.

REM Show existing projects
call :log_info "Existing Projects:"
if exist "www" (
    set project_count=0
    for /d %%d in (www\*) do (
        if exist "%%d" (
            set /a project_count+=1
            echo   - %%~nd
        )
    )
    if !project_count! equ 0 (
        echo   No projects found in www/
    )
) else (
    echo   www/ directory not found
)
echo.

REM Show virtual hosts
call :log_info "Virtual Hosts:"
if exist "nginx\sites" (
    set vhost_count=0
    for %%f in (nginx\sites\*.local.conf) do (
        set /a vhost_count+=1
        echo   - %%~nf
    )
    if !vhost_count! equ 0 (
        echo   No virtual hosts configured
    )
) else (
    echo   nginx/sites directory not found
)
echo.

REM Show environment status
call :log_info "Environment Configuration:"
if exist ".env" (
    call :log_success "Environment file: Present"
) else (
    call :log_error "Environment file: Missing"
)

if exist "docker-compose.yml" (
    call :log_success "Docker Compose file: Present"
) else (
    call :log_error "Docker Compose file: Missing"
)
echo.

REM Show quick access URLs
echo %YELLOW%========================================%NC%
echo %YELLOW%   Quick Access URLs%NC%
echo %YELLOW%========================================%NC%
echo   Main Page:        http://localhost
echo   Database Test:    http://localhost/test-db.php
echo   RAM Status:       http://localhost/ram-optimization.php
echo   Adminer:          http://localhost:8080
echo   phpMyAdmin:       http://localhost:8081
echo.

REM Show useful commands
echo %YELLOW%========================================%NC%
echo %YELLOW%   Useful Commands%NC%
echo %YELLOW%========================================%NC%
echo   Start:            %SCRIPT_DIR%start.bat
echo   Stop:             %SCRIPT_DIR%stop.bat
echo   Restart:          %SCRIPT_DIR%restart.bat
echo   Reset:            %SCRIPT_DIR%reset.bat
echo   Logs:             %SCRIPT_DIR%dev.bat logs
echo   Create Project:   %SCRIPT_DIR%dev.bat create-project myproject php84 public
echo   Shell Access:     %SCRIPT_DIR%dev.bat shell php84
echo.

REM Show system recommendations
call :log_info "System Recommendations:"

REM Check available RAM
for /f "tokens=2 delims==" %%i in ('wmic OS get TotalVisibleMemorySize /value ^| find "="') do set total_kb=%%i
for /f "tokens=2 delims==" %%i in ('wmic OS get FreePhysicalMemory /value ^| find "="') do set free_kb=%%i
set /a total_gb=!total_kb!/1024/1024
set /a free_gb=!free_kb!/1024/1024
set /a used_gb=!total_gb!-!free_gb!

echo   System RAM: !total_gb!GB total, !used_gb!GB used, !free_gb!GB free

if !free_gb! lss 2 (
    call :log_warning "Low free RAM (!free_gb!GB). Consider closing other applications."
) else (
    call :log_success "RAM usage looks good (!free_gb!GB free)."
)

REM Check disk space
for /f "tokens=3" %%i in ('dir /-c ^| find "bytes free"') do set free_space=%%i
echo   Disk space: %free_space% bytes free

echo.
call :log_success "Status check completed!"
pause
