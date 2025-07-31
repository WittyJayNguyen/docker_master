@echo off
echo ========================================
echo AWS Order System Database Quick Check
echo ========================================
echo.

REM Simple check without interactive commands
echo Checking PostgreSQL container...
docker ps --filter "name=postgres_low_ram" --format "table {{.Names}}\t{{.Status}}"
echo.

echo Checking if database exists...
docker exec postgres_low_ram psql -U postgres_user -d docker_master -c "SELECT datname FROM pg_database WHERE datname = 'aws_order_system';"
echo.

echo Database is ready!
echo.
echo Connection Details:
echo - Host: localhost
echo - Port: 5432
echo - Database: aws_order_system
echo - Username: postgres_user
echo - Password: postgres_pass
echo.
echo Access via pgAdmin: http://localhost:8080
echo.
echo To connect via command line:
echo docker exec -it postgres_low_ram psql -U postgres_user -d aws_order_system
echo.
