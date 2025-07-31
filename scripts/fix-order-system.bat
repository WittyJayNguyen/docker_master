@echo off
echo ========================================
echo Order System Fix Script
echo ========================================
echo.

echo Step 1: Check container status
docker ps | findstr order-system
echo.

echo Step 2: Check nginx status
docker ps | findstr nginx
echo.

echo Step 3: Test internal connection
docker exec order-system_php74 curl -s http://localhost/public/ | findstr "title"
echo.

echo Step 4: Check database connection
docker exec order-system_php74 php -r "
try {
    $pdo = new PDO('pgsql:host=postgres_low_ram;port=5432;dbname=aws_order_system', 'postgres_user', 'postgres_pass');
    echo 'Database connection: OK' . PHP_EOL;
} catch (Exception $e) {
    echo 'Database connection failed: ' . $e->getMessage() . PHP_EOL;
}
"
echo.

echo Step 5: Check Laravel configuration
docker exec order-system_php74 php artisan config:cache
echo.

echo Step 6: Clear Laravel cache
docker exec order-system_php74 php artisan cache:clear
echo.

echo Step 7: Test application
echo Testing http://order-system.io
echo Please check your browser or try: curl http://order-system.io
echo.

echo ========================================
echo Fix completed! 
echo ========================================
echo.
echo If still having issues:
echo 1. Check hosts file: C:\Windows\System32\drivers\etc\hosts
echo 2. Ensure this line exists: 127.0.0.1 order-system.io
echo 3. Try accessing: http://localhost/public/ directly
echo.
pause
