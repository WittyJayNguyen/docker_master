@echo off
echo ========================================
echo ORDER SYSTEM - FINAL STATUS CHECK
echo ========================================
echo.

echo [1] Container Status:
docker ps --format "table {{.Names}}\t{{.Status}}" | findstr -E "(order-system|nginx_proxy)"
echo.

echo [2] Database Connection Test:
docker exec order-system_php74 php -r "
try {
    \$pdo = new PDO('pgsql:host=postgres_low_ram;port=5432;dbname=aws_order_system', 'postgres_user', 'postgres_pass');
    echo '[OK] Database connection successful' . PHP_EOL;
} catch (Exception \$e) {
    echo '[ERROR] Database connection failed: ' . \$e->getMessage() . PHP_EOL;
}
" 2>nul
echo.

echo [3] Application Response Test:
echo Testing internal container...
docker exec order-system_php74 curl -s -I http://localhost/ | findstr "HTTP\|Location" | head -2
echo.

echo [4] Nginx Proxy Test:
echo Testing nginx proxy...
docker exec nginx_proxy_low_ram curl -s -I http://order-system_php74:80 | findstr "HTTP\|Location" | head -2
echo.

echo [5] Domain Access Test:
echo Testing order-system.io domain...
echo Checking hosts file entry...
findstr "order-system.io" C:\Windows\System32\drivers\etc\hosts
echo.

echo [6] Service URLs:
echo ========================================
echo ORDER SYSTEM ACCESS:
echo - Main URL: http://order-system.io
echo - Should redirect to: http://order-system.io/login
echo.
echo DATABASE ACCESS:
echo - pgAdmin: http://localhost:8080
echo - Direct: docker exec -it postgres_low_ram psql -U postgres_user -d aws_order_system
echo.
echo CONTAINER MANAGEMENT:
echo - Restart order-system: docker restart order-system_php74
echo - Restart nginx: docker restart nginx_proxy_low_ram
echo - View logs: docker logs order-system_php74
echo.

echo ========================================
echo STATUS SUMMARY:
echo ========================================
if exist "C:\Windows\System32\drivers\etc\hosts" (
    findstr /C:"127.0.0.1 order-system.io" C:\Windows\System32\drivers\etc\hosts >nul
    if !errorlevel! equ 0 (
        echo [OK] Hosts file configured correctly
    ) else (
        echo [WARNING] Hosts file may need order-system.io entry
    )
)

docker ps | findstr "order-system_php74" | findstr "Up" >nul
if !errorlevel! equ 0 (
    echo [OK] Order System container is running
) else (
    echo [ERROR] Order System container is not running
)

docker ps | findstr "nginx_proxy_low_ram" | findstr "Up" >nul
if !errorlevel! equ 0 (
    echo [OK] Nginx proxy is running
) else (
    echo [ERROR] Nginx proxy is not running
)

echo.
echo If all checks show [OK], you can access:
echo http://order-system.io
echo.
pause
