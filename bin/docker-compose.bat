@echo off
REM Docker Master Platform - Docker Compose Wrapper (Windows)
REM Cross-platform compatible wrapper for docker-compose

setlocal enabledelayedexpansion

REM Set the config file path (try cross-platform first, fallback to low-ram)
set CONFIG_FILE=app\config\environments\docker-compose.cross-platform.yml
if not exist "%CONFIG_FILE%" (
    set CONFIG_FILE=app\config\environments\docker-compose.low-ram.yml
)

REM Check if config file exists
if not exist "%CONFIG_FILE%" (
    echo ❌ Error: Configuration file not found: %CONFIG_FILE%
    echo Please make sure you're running this from the docker_master root directory.
    exit /b 1
)

REM If no arguments provided, show help
if "%1"=="" (
    echo 🐳 Docker Master Platform - Docker Compose Wrapper
    echo.
    echo Usage: docker-compose.bat [docker-compose-command]
    echo.
    echo Examples:
    echo   docker-compose.bat up -d          # Start all services
    echo   docker-compose.bat down           # Stop all services
    echo   docker-compose.bat ps             # Show running containers
    echo   docker-compose.bat logs           # Show logs
    echo   docker-compose.bat restart        # Restart services
    echo.
    echo Config file: %CONFIG_FILE%
    exit /b 0
)

REM Execute docker-compose with the config file and all arguments
echo 🚀 Running: docker-compose -f %CONFIG_FILE% %*
docker-compose -f %CONFIG_FILE% %*
