@echo off
setlocal enabledelayedexpansion

REM Debug WordPress Site Script
REM Helps diagnose WordPress 404 issues

set "SCRIPT_DIR=%~dp0"
set "PROJECT_ROOT=%SCRIPT_DIR%.."

REM Colors
set "GREEN=[92m"
set "BLUE=[94m"
set "YELLOW=[93m"
set "RED=[91m"
set "NC=[0m"

echo %BLUE%========================================%NC%
echo %BLUE%   WordPress Debug Tool%NC%
echo %BLUE%========================================%NC%
echo.

set "SITE_NAME=%~1"
if "%SITE_NAME%"=="" (
    set /p SITE_NAME="Enter site name (e.g., asmokaigo): "
)

if "%SITE_NAME%"=="" (
    echo %RED%[ERROR]%NC% Site name is required!
    pause
    exit /b 1
)

set "DOMAIN_NAME=%~2"
if "%DOMAIN_NAME%"=="" (
    set /p DOMAIN_NAME="Enter domain name (e.g., asmo-asmokaigo.io): "
)

if "%DOMAIN_NAME%"=="" (
    set "DOMAIN_NAME=%SITE_NAME%.local"
)

cd /d "%PROJECT_ROOT%"

echo %YELLOW%Debugging WordPress site: %SITE_NAME%%NC%
echo %YELLOW%Domain: %DOMAIN_NAME%%NC%
echo.

REM 1. Check if project directory exists
echo %BLUE%[1/8]%NC% Checking project directory...
if exist "www\%SITE_NAME%" (
    echo %GREEN%✅ Project directory exists: www\%SITE_NAME%%NC%
) else (
    echo %RED%❌ Project directory not found: www\%SITE_NAME%%NC%
    echo Create it with: mkdir www\%SITE_NAME%\wordpress
    pause
    exit /b 1
)

REM 2. Check WordPress files
echo %BLUE%[2/8]%NC% Checking WordPress files...
if exist "www\%SITE_NAME%\wordpress\wp-config.php" (
    echo %GREEN%✅ wp-config.php exists%NC%
) else (
    echo %RED%❌ wp-config.php not found%NC%
    echo WordPress may not be installed properly.
)

if exist "www\%SITE_NAME%\wordpress\index.php" (
    echo %GREEN%✅ index.php exists%NC%
) else (
    echo %RED%❌ index.php not found%NC%
    echo WordPress core files missing.
)

REM 3. Check virtual host
echo %BLUE%[3/8]%NC% Checking virtual host configuration...
if exist "nginx\sites\%SITE_NAME%.local.conf" (
    echo %GREEN%✅ Virtual host exists: nginx\sites\%SITE_NAME%.local.conf%NC%
) else (
    echo %RED%❌ Virtual host not found: nginx\sites\%SITE_NAME%.local.conf%NC%
    echo Create it with the create-wordpress script.
)

REM 4. Check hosts file
echo %BLUE%[4/8]%NC% Checking hosts file...
type C:\Windows\System32\drivers\etc\hosts | findstr "%DOMAIN_NAME%" >nul
if not errorlevel 1 (
    echo %GREEN%✅ Domain found in hosts file%NC%
) else (
    echo %RED%❌ Domain not found in hosts file%NC%
    echo Add this line to C:\Windows\System32\drivers\etc\hosts:
    echo 127.0.0.1 %DOMAIN_NAME%
)

REM 5. Check database
echo %BLUE%[5/8]%NC% Checking database...
docker-compose exec mysql mysql -u dev_user -pdev_pass -e "USE %SITE_NAME%; SELECT COUNT(*) as tables FROM information_schema.tables WHERE table_schema='%SITE_NAME%';" 2>nul | findstr "tables" >nul
if not errorlevel 1 (
    echo %GREEN%✅ Database '%SITE_NAME%' exists and has tables%NC%
) else (
    echo %RED%❌ Database '%SITE_NAME%' not found or empty%NC%
    echo Create it with: docker-compose exec mysql mysql -u root -proot123 -e "CREATE DATABASE %SITE_NAME%;"
)

REM 6. Check nginx configuration
echo %BLUE%[6/8]%NC% Checking nginx configuration...
docker-compose exec nginx nginx -t >nul 2>&1
if not errorlevel 1 (
    echo %GREEN%✅ Nginx configuration is valid%NC%
) else (
    echo %RED%❌ Nginx configuration has errors%NC%
    docker-compose exec nginx nginx -t
)

REM 7. Check if nginx loads the virtual host
echo %BLUE%[7/8]%NC% Checking if nginx loads virtual host...
docker-compose exec nginx nginx -T 2>/dev/null | findstr "%DOMAIN_NAME%" >nul
if not errorlevel 1 (
    echo %GREEN%✅ Virtual host loaded by nginx%NC%
) else (
    echo %RED%❌ Virtual host not loaded by nginx%NC%
    echo Check nginx configuration and restart nginx.
)

REM 8. Test site access
echo %BLUE%[8/8]%NC% Testing site access...
powershell -Command "try { $response = Invoke-WebRequest -Uri 'http://localhost/' -Headers @{'Host'='%DOMAIN_NAME%'} -UseBasicParsing -TimeoutSec 5; Write-Host '[SUCCESS] Site responds with status:' $response.StatusCode -ForegroundColor Green } catch { Write-Host '[ERROR] Site not accessible:' $_.Exception.Message -ForegroundColor Red }"

echo.
echo %YELLOW%========================================%NC%
echo %YELLOW%   Debug Summary%NC%
echo %YELLOW%========================================%NC%

REM Show recent nginx access logs
echo %YELLOW%Recent nginx access logs:%NC%
docker-compose exec nginx tail -3 /var/log/nginx/access.log

echo.
echo %YELLOW%Recent nginx error logs:%NC%
docker-compose exec nginx tail -3 /var/log/nginx/error.log 2>/dev/null || echo "No recent errors"

echo.
echo %YELLOW%WordPress URLs in database:%NC%
docker-compose exec mysql mysql -u dev_user -pdev_pass -e "SELECT option_name, option_value FROM %SITE_NAME%.wp_options WHERE option_name IN ('siteurl', 'home');" 2>/dev/null || echo "Could not check WordPress URLs"

echo.
echo %YELLOW%Quick fixes:%NC%
echo   1. Restart nginx: docker-compose restart nginx
echo   2. Check file permissions in www\%SITE_NAME%\wordpress\
echo   3. Verify wp-config.php database settings
echo   4. Test with: http://%DOMAIN_NAME%/wp-admin/
echo.

set /p open_site="Try to open site in browser? (y/N): "
if /i "%open_site%"=="y" (
    start http://%DOMAIN_NAME%
)

pause
