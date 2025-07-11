@echo off

if "%1"=="" (
    echo 📋 Log Viewer for Docker Multi-Project
    echo Usage: .\scripts\logs.bat [service] [options]
    echo.
    echo Services:
    echo   all                    - All services
    echo   wordpress-server       - WordPress container
    echo   laravel-server         - Laravel container
    echo   nodejs_vue             - Node.js/Vue.js container
    echo   mysql_db               - MySQL database
    echo   postgres_db            - PostgreSQL database
    echo   phpmyadmin             - phpMyAdmin
    echo   pgadmin                - pgAdmin
    echo.
    echo Options:
    echo   -f                     - Follow logs (real-time)
    echo   --tail 50              - Show last 50 lines
    echo.
    echo Examples:
    echo   .\scripts\logs.bat all
    echo   .\scripts\logs.bat wordpress-server -f
    echo   .\scripts\logs.bat mysql_db --tail 100
    echo.
    pause
    exit /b 0
)

if "%1"=="all" (
    echo 📋 Showing logs for all services...
    if "%2"=="-f" (
        docker-compose logs -f
    ) else (
        docker-compose logs --tail=50
    )
) else (
    echo 📋 Showing logs for: %1
    if "%2"=="-f" (
        docker-compose logs -f %1
    ) else if "%2"=="--tail" (
        docker-compose logs --tail=%3 %1
    ) else (
        docker-compose logs --tail=50 %1
    )
)

pause
