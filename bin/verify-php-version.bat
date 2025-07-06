@echo off
setlocal enabledelayedexpansion

REM Verify PHP Version Script
REM Checks which PHP version is being used by each site

set "SCRIPT_DIR=%~dp0"
set "PROJECT_ROOT=%SCRIPT_DIR%.."

REM Colors
set "GREEN=[92m"
set "BLUE=[94m"
set "YELLOW=[93m"
set "RED=[91m"
set "NC=[0m"

echo %BLUE%========================================%NC%
echo %BLUE%   PHP Version Verification%NC%
echo %BLUE%========================================%NC%
echo.

cd /d "%PROJECT_ROOT%"

echo %YELLOW%Checking PHP containers status:%NC%
docker-compose ps php74 php82 php84
echo.

echo %YELLOW%PHP 7.4 Version:%NC%
docker-compose exec php74 php -v | head -1
echo.

echo %YELLOW%PHP 8.2 Version:%NC%
docker-compose exec php82 php -v | head -1
echo.

echo %YELLOW%PHP 8.4 Version:%NC%
docker-compose exec php84 php -v | head -1
echo.

echo %YELLOW%Testing asmo-asmokaigo.io site:%NC%
echo Creating test file...

REM Create PHP version test file
(
    echo ^<?php
    echo echo "Site: asmo-asmokaigo.io\n";
    echo echo "PHP Version: " . PHP_VERSION . "\n";
    echo echo "PHP Major: " . PHP_MAJOR_VERSION . "\n";
    echo echo "Extensions: ";
    echo if ^(extension_loaded^('mysqli'^)^) echo "MySQLi ";
    echo if ^(extension_loaded^('pdo_mysql'^)^) echo "PDO_MySQL ";
    echo if ^(function_exists^('mysql_connect'^)^) echo "MySQL_Legacy ";
    echo echo "\n";
    echo ?^>
) > "www\asmokaigo\wordpress\version_test.php"

echo Test file created: www\asmokaigo\wordpress\version_test.php
echo.

echo %YELLOW%Testing via web request:%NC%
powershell -Command "try { $response = Invoke-WebRequest -Uri 'http://localhost/version_test.php' -Headers @{'Host'='asmo-asmokaigo.io'} -UseBasicParsing -TimeoutSec 10; Write-Host $response.Content } catch { Write-Host 'Error:' $_.Exception.Message -ForegroundColor Red }"

echo.
echo %YELLOW%Virtual host configuration:%NC%
findstr "fastcgi_pass" nginx\sites\asmokaigo.local.conf
echo.

echo %YELLOW%Nginx status:%NC%
docker-compose exec nginx nginx -t
echo.

pause
