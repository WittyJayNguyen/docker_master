@echo off
echo 🚀 Docker Multi-Project Environment Setup (Windows)
echo ================================================

REM Check if Docker is running
docker --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Docker is not installed or not running
    echo Please install Docker Desktop from: https://www.docker.com/products/docker-desktop
    pause
    exit /b 1
)

REM Check if Docker Compose is available
docker-compose --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Docker Compose is not available
    echo Please ensure Docker Desktop includes Docker Compose
    pause
    exit /b 1
)

echo ✅ Docker is available

REM Create necessary directories
echo 📁 Creating directories...
if not exist "data\mysql" mkdir data\mysql
if not exist "data\postgres" mkdir data\postgres
if not exist "data\uploads" mkdir data\uploads
if not exist "logs" mkdir logs
if not exist "backups\mysql" mkdir backups\mysql
if not exist "backups\postgres" mkdir backups\postgres
if not exist "projects\wordpress" mkdir projects\wordpress
if not exist "projects\laravel" mkdir projects\laravel
if not exist "projects\vue" mkdir projects\vue

REM Copy environment file
if not exist ".env" (
    echo 📝 Creating .env file...
    copy .env.example .env
) else (
    echo ✅ .env file already exists
)

REM Pull Docker images
echo 🐳 Pulling Docker images...
docker-compose pull

REM Build containers
echo 🔨 Building containers...
docker-compose build

echo ✅ Setup completed successfully!
echo.
echo 🚀 Next steps:
echo 1. Run: .\scripts\start.bat
echo 2. Visit: http://localhost:3000 (Vue.js)
echo 3. Visit: http://localhost:8080 (phpMyAdmin)
echo 4. Visit: http://localhost:8081 (pgAdmin)
echo.
pause
