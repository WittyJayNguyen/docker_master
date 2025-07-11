@echo off
REM Docker Master Platform - Windows Setup Script
REM Automatic setup for Windows (PowerShell/Command Prompt)

setlocal enabledelayedexpansion

echo 🐳 Docker Master Platform - Windows Setup
echo ================================================================
echo.

REM Check Docker installation
echo 🐳 Checking Docker installation...
docker --version >nul 2>&1
if errorlevel 1 (
    echo ❌ Docker is not installed!
    echo Please install Docker Desktop from: https://www.docker.com/products/docker-desktop
    pause
    exit /b 1
)

docker info >nul 2>&1
if errorlevel 1 (
    echo ❌ Docker is not running!
    echo Please start Docker Desktop and try again.
    pause
    exit /b 1
)

echo ✅ Docker is installed and running

REM Check Docker Compose
docker-compose --version >nul 2>&1
if errorlevel 1 (
    echo ❌ Docker Compose is not installed!
    pause
    exit /b 1
)

echo ✅ Docker Compose is available
echo.

REM Setup environment file
echo ⚙️ Setting up environment configuration...
if not exist ".env" (
    if exist ".env.example" (
        copy ".env.example" ".env" >nul
        echo ✅ Environment file created from .env.example
    ) else (
        echo ⚠️ No .env.example found, creating basic .env
        (
        echo # Docker Master Platform - Environment Variables
        echo COMPOSE_PROJECT_NAME=docker_master
        echo COMPOSE_FILE=src/config/environments/docker-compose.cross-platform.yml
        echo.
        echo # PostgreSQL Configuration
        echo POSTGRES_PORT=5432
        echo POSTGRES_DB=docker_master
        echo POSTGRES_USER=postgres_user
        echo POSTGRES_PASSWORD=postgres_pass
        echo.
        echo # MySQL Configuration
        echo MYSQL_PORT=3306
        echo MYSQL_ROOT_PASSWORD=root_password
        echo MYSQL_DATABASE=docker_master
        echo MYSQL_USER=mysql_user
        echo MYSQL_PASSWORD=mysql_pass
        echo.
        echo # Redis Configuration
        echo REDIS_PORT=6379
        echo.
        echo # Laravel PHP 8.4 Configuration
        echo LARAVEL84_PORT=8010
        echo LARAVEL84_DEBUG_PORT=9084
        echo.
        echo # Development Configuration
        echo ENABLE_XDEBUG=true
        echo ENABLE_OPCACHE=true
        ) > .env
    )
) else (
    echo ⚠️ .env file already exists, skipping
)

echo.

REM Create runtime directories
echo 📁 Creating runtime directories...
mkdir "runtime\projects" 2>nul
mkdir "runtime\logs\apache" 2>nul
mkdir "runtime\logs\mysql" 2>nul
mkdir "runtime\logs\postgresql" 2>nul
mkdir "runtime\logs\php" 2>nul
mkdir "runtime\logs\redis" 2>nul
mkdir "runtime\data\uploads" 2>nul
mkdir "runtime\backups" 2>nul

REM Create .gitkeep files for empty directories
echo. > "runtime\projects\.gitkeep"
echo. > "runtime\logs\.gitkeep"
echo. > "runtime\data\.gitkeep"
echo. > "runtime\backups\.gitkeep"

echo ✅ Runtime directories created
echo.

REM Test installation
echo 🧪 Testing installation...

if exist "bin\start.bat" (
    echo ✅ Windows scripts available
) else (
    echo ❌ Windows scripts not found
    pause
    exit /b 1
)

if exist "docker-master" (
    echo ✅ Universal launcher available
) else (
    echo ❌ Universal launcher not found
)

echo.

REM Show next steps
echo 🎉 Setup completed successfully!
echo ================================================================
echo.
echo ✅ Docker Master Platform is ready for Windows development
echo.
echo 🚀 Quick Start Commands:
echo   # Windows-specific:
echo   bin\start.bat
echo   bin\create.bat my-project
echo   bin\status.bat
echo.
echo   # Universal launcher (Git Bash/WSL):
echo   ./docker-master start
echo   ./docker-master create my-project
echo.
echo 📚 Documentation:
echo   docs\user-guide\CROSS-PLATFORM-INSTALLATION.md
echo   docs\user-guide\QUICK-REFERENCE.md
echo.
echo 🔧 Configuration:
echo   Edit .env file to customize settings
echo   src\config\environments\ for Docker configurations
echo.
echo 💡 Platform: Windows
echo.

pause
