@echo off
setlocal enabledelayedexpansion

REM Docker Development Environment - First Time Setup Script
REM This script guides new users through the complete setup process

set "SCRIPT_DIR=%~dp0"
set "PROJECT_ROOT=%SCRIPT_DIR%.."

REM Colors
set "GREEN=[92m"
set "BLUE=[94m"
set "YELLOW=[93m"
set "RED=[91m"
set "NC=[0m"

echo %BLUE%========================================%NC%
echo %BLUE%   Docker Development Environment%NC%
echo %BLUE%        First Time Setup%NC%
echo %BLUE%========================================%NC%
echo.

echo %YELLOW%Welcome to Docker Development Environment!%NC%
echo This script will guide you through the complete setup process.
echo.

REM Check if Docker is installed
echo %BLUE%[STEP 1/7]%NC% Checking Docker installation...
docker --version >nul 2>&1
if errorlevel 1 (
    echo %RED%[ERROR]%NC% Docker is not installed or not running.
    echo.
    echo Please install Docker Desktop first:
    echo   Windows: https://www.docker.com/products/docker-desktop/
    echo   macOS: https://www.docker.com/products/docker-desktop/
    echo   Linux: Follow instructions in INSTALLATION.md
    echo.
    echo After installing Docker, restart this script.
    pause
    exit /b 1
)

docker-compose --version >nul 2>&1
if errorlevel 1 (
    echo %RED%[ERROR]%NC% Docker Compose is not available.
    echo Please ensure Docker Desktop is properly installed.
    pause
    exit /b 1
)

echo %GREEN%[SUCCESS]%NC% Docker is installed and running.
for /f "tokens=3" %%i in ('docker --version') do set docker_version=%%i
echo   Docker version: %docker_version%
echo.

REM Check environment file
echo %BLUE%[STEP 2/7]%NC% Setting up environment configuration...
if not exist "%PROJECT_ROOT%\.env" (
    if exist "%PROJECT_ROOT%\.env.example" (
        copy "%PROJECT_ROOT%\.env.example" "%PROJECT_ROOT%\.env" >nul
        echo %GREEN%[SUCCESS]%NC% Environment file created from template.
    ) else (
        echo %YELLOW%[WARNING]%NC% .env.example not found. Creating basic .env file...
        (
            echo # Docker Development Environment Configuration
            echo MYSQL_ROOT_PASSWORD=root123
            echo MYSQL_DATABASE=dev_db
            echo MYSQL_USER=dev_user
            echo MYSQL_PASSWORD=dev_pass
            echo POSTGRES_DB=dev_db
            echo POSTGRES_USER=dev_user
            echo POSTGRES_PASSWORD=dev_pass
            echo DEFAULT_PHP_VERSION=dev_php84
            echo TIMEZONE=Asia/Ho_Chi_Minh
        ) > "%PROJECT_ROOT%\.env"
        echo %GREEN%[SUCCESS]%NC% Basic .env file created.
    )
) else (
    echo %GREEN%[SUCCESS]%NC% Environment file already exists.
)
echo.

REM Run RAM optimization
echo %BLUE%[STEP 3/7]%NC% Optimizing for your system RAM...
call "%SCRIPT_DIR%auto-optimize.bat"
echo.

REM Build and start services
echo %BLUE%[STEP 4/7]%NC% Building and starting Docker services...
echo This may take 10-15 minutes on first run...
echo.

cd /d "%PROJECT_ROOT%"
docker-compose up -d --build

if errorlevel 1 (
    echo %RED%[ERROR]%NC% Failed to start services.
    echo Please check the error messages above.
    echo You can try running: docker-compose logs
    pause
    exit /b 1
)

echo %GREEN%[SUCCESS]%NC% All services started successfully!
echo.

REM Wait for services to be ready
echo %BLUE%[STEP 5/7]%NC% Waiting for services to be ready...
timeout /t 10 /nobreak >nul

REM Check service status
echo Checking service status...
docker-compose ps
echo.

REM Create example project
echo %BLUE%[STEP 6/7]%NC% Creating example project...
set /p create_example="Do you want to create an example project? (y/N): "
if /i "%create_example%"=="y" (
    echo Creating example project 'demo'...
    
    REM Create project directory
    mkdir "%PROJECT_ROOT%\www\demo" 2>nul
    mkdir "%PROJECT_ROOT%\www\demo\public" 2>nul
    
    REM Create index.php
    (
        echo ^<?php
        echo echo "^<h1^>🎉 Welcome to Docker Development Environment!^</h1^>";
        echo echo "^<p^>PHP Version: " . PHP_VERSION . "^</p^>";
        echo echo "^<p^>Server Time: " . date('Y-m-d H:i:s'^) . "^</p^>";
        echo echo "^<h2^>Quick Links:^</h2^>";
        echo echo "^<ul^>";
        echo echo "^<li^>^<a href='http://localhost/test-db.php'^>Database Test^</a^>^</li^>";
        echo echo "^<li^>^<a href='http://localhost/ram-optimization.php'^>RAM Optimization Status^</a^>^</li^>";
        echo echo "^<li^>^<a href='http://localhost:8080'^>Adminer (Database Management^)^</a^>^</li^>";
        echo echo "^<li^>^<a href='http://localhost:8081'^>phpMyAdmin^</a^>^</li^>";
        echo echo "^</ul^>";
        echo phpinfo(^);
        echo ?^>
    ) > "%PROJECT_ROOT%\www\demo\public\index.php"
    
    REM Create virtual host
    if exist "%PROJECT_ROOT%\nginx\sites\project-template.conf.example" (
        powershell -Command "(Get-Content '%PROJECT_ROOT%\nginx\sites\project-template.conf.example') -replace '{{PROJECT_NAME}}', 'demo' -replace '{{PHP_VERSION}}', 'dev_php84' -replace '{{PUBLIC_DIR}}', 'public' | Set-Content '%PROJECT_ROOT%\nginx\sites\demo.local.conf'"
        
        REM Restart nginx
        docker-compose restart nginx
        
        echo %GREEN%[SUCCESS]%NC% Example project created!
        echo   Project URL: http://demo.local
        echo   Add to hosts file: 127.0.0.1 demo.local
    ) else (
        echo %YELLOW%[WARNING]%NC% Virtual host template not found. Project created without virtual host.
    )
) else (
    echo Skipping example project creation.
)
echo.

REM Final verification
echo %BLUE%[STEP 7/7]%NC% Final verification...

REM Test web access
echo Testing web access...
powershell -Command "try { Invoke-WebRequest -Uri 'http://localhost' -UseBasicParsing | Out-Null; Write-Host '[SUCCESS] Main page accessible' -ForegroundColor Green } catch { Write-Host '[ERROR] Main page not accessible' -ForegroundColor Red }"

REM Test database
echo Testing database connections...
docker-compose exec -T mysql mysql -u dev_user -pdev_pass -e "SELECT 'MySQL OK' as status;" 2>nul && echo %GREEN%[SUCCESS]%NC% MySQL connection working || echo %YELLOW%[WARNING]%NC% MySQL connection failed

echo.
echo %GREEN%========================================%NC%
echo %GREEN%   Setup Complete!%NC%
echo %GREEN%========================================%NC%
echo.

echo %BLUE%🎉 Your Docker Development Environment is ready!%NC%
echo.
echo %YELLOW%Quick Access URLs:%NC%
echo   Main Page:        http://localhost
echo   Database Test:    http://localhost/test-db.php
echo   RAM Status:       http://localhost/ram-optimization.php
echo   Adminer:          http://localhost:8080
echo   phpMyAdmin:       http://localhost:8081

if /i "%create_example%"=="y" (
    echo   Demo Project:     http://demo.local (add to hosts file^)
)

echo.
echo %YELLOW%Next Steps:%NC%
echo   1. Add demo.local to your hosts file (if created^)
echo   2. Read README.md for complete documentation
echo   3. Check examples/ folder for sample projects
echo   4. Start building your projects!
echo.

echo %YELLOW%Useful Commands:%NC%
echo   Start:     bin\dev.bat start
echo   Stop:      bin\dev.bat stop
echo   Status:    bin\dev.bat status
echo   Logs:      bin\dev.bat logs
echo   Help:      bin\dev.bat help
echo.

echo %YELLOW%Documentation:%NC%
echo   DOCUMENTATION.md     - Choose the right guide for you
echo   docs\INSTALLATION.md   - Complete installation guide
echo   docs\STEP_BY_STEP.md   - Step-by-step tutorial
echo   docs\COMMANDS.md       - Command reference
echo   docs\TROUBLESHOOTING.md - Problem solving
echo.

set /p open_browser="Open main page in browser? (y/N): "
if /i "%open_browser%"=="y" (
    start http://localhost
)

echo.
echo %GREEN%Happy coding! 🚀%NC%
pause
