@echo off
echo ========================================
echo ORDER SYSTEM STATUS CHECK
echo ========================================
echo.

echo [1] Container Status:
docker ps --format "table {{.Names}}\t{{.Status}}" | findstr -E "order-system\|nginx_proxy"
echo.

echo [2] Application Test:
echo Testing order-system container...
docker exec order-system_php74 curl -s -I http://localhost/ | findstr "HTTP"
echo.

echo [3] Nginx Proxy Test:
echo Testing nginx proxy...
docker exec nginx_proxy_low_ram curl -s -I http://order-system_php74:80 | findstr "HTTP"
echo.

echo [4] Hosts File Check:
findstr "order-system.io" C:\Windows\System32\drivers\etc\hosts
echo.

echo ========================================
echo SUMMARY:
echo ========================================
echo If you see:
echo - Both containers showing "Up" status
echo - HTTP/1.1 302 Found responses
echo - 127.0.0.1 order-system.io in hosts file
echo.
echo Then you can access: http://order-system.io
echo.
echo Database info:
echo - Database: aws_order_system
echo - pgAdmin: http://localhost:8080
echo.
pause
