@echo off
echo ========================================
echo Order System Connection Test
echo ========================================
echo.

echo Step 1: Check nginx status
docker ps | findstr nginx
echo.

echo Step 2: Test internal container connection
echo Testing order-system_php74 container directly...
docker exec order-system_php74 curl -s -I http://localhost/public/ | findstr "HTTP\|Location"
echo.

echo Step 3: Test nginx proxy connection
echo Testing nginx proxy to order-system...
docker exec nginx_proxy_low_ram curl -s -I http://order-system_php74:80/public/ | findstr "HTTP\|Location"
echo.

echo Step 4: Test domain resolution
echo Testing order-system.io domain...
nslookup order-system.io
echo.

echo Step 5: Test final connection
echo Testing http://order-system.io...
curl -s -I http://order-system.io | findstr "HTTP\|Location" || echo "Connection failed"
echo.

echo ========================================
echo Test completed!
echo ========================================
echo.
echo If connection works, you should see:
echo - HTTP/1.1 302 Found
echo - Location: http://order-system.io/login
echo.
echo Try opening: http://order-system.io in your browser
echo.
pause
