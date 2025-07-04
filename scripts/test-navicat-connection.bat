@echo off
echo.
echo ========================================
echo   Docker Master Platform - Navicat Connection Test
echo ========================================
echo.

echo 🔍 Testing PostgreSQL connection for Navicat...
echo.

REM Check if PostgreSQL container is running
docker ps | findstr "postgres_server" >nul
if errorlevel 1 (
    echo ❌ PostgreSQL container is not running
    echo 💡 Start it with: docker-compose up -d
    exit /b 1
)

echo ✅ PostgreSQL container is running
echo.

REM Test PostgreSQL connection
echo 🧪 Testing PostgreSQL connection...
docker exec postgres_server pg_isready -U postgres_user
if errorlevel 1 (
    echo ❌ PostgreSQL is not ready
    exit /b 1
)

echo ✅ PostgreSQL is ready for connections
echo.

REM Show connection info
echo 📋 Navicat Connection Information:
echo ================================================================
echo Connection Name: Docker Master PostgreSQL
echo Host:           localhost (or 127.0.0.1)
echo Port:           5432
echo Initial DB:     postgres
echo Username:       postgres_user
echo Password:       postgres_pass
echo ================================================================
echo.

REM List available databases
echo 🗄️ Available Databases:
docker exec postgres_server psql -U postgres_user -d postgres -c "\l" -t | findstr "|"

echo.
echo 💡 Navicat Setup Steps:
echo 1. Open Navicat
echo 2. File → New Connection → PostgreSQL
echo 3. Enter the connection info above
echo 4. Click "Test Connection"
echo 5. If successful, click "OK" to save
echo.

echo 🌐 Alternative: Use pgAdmin web interface
echo URL: http://localhost:8081
echo Email: admin@example.com
echo Password: admin123
echo.

echo ✅ Connection test completed!
pause
