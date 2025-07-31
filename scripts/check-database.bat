@echo off
echo Checking AWS Order System Database...
echo.

echo Step 1: Check PostgreSQL container status
docker ps | findstr postgres_low_ram
echo.

echo Step 2: List databases
docker exec -i postgres_low_ram psql -U postgres_user -d docker_master -c "\l"
echo.

echo Step 3: Check tables in aws_order_system database
docker exec -i postgres_low_ram psql -U postgres_user -d aws_order_system -c "\dt"
echo.

echo Step 4: Count tables
docker exec -i postgres_low_ram psql -U postgres_user -d aws_order_system -c "SELECT count(*) as table_count FROM information_schema.tables WHERE table_schema = 'public';"
echo.

echo Step 5: Check database size
docker exec -i postgres_low_ram psql -U postgres_user -d aws_order_system -c "SELECT pg_size_pretty(pg_database_size('aws_order_system')) as database_size;"
echo.

echo Step 6: Sample data from users table
docker exec -i postgres_low_ram psql -U postgres_user -d aws_order_system -c "SELECT id, name, email FROM users LIMIT 5;"
echo.

pause
