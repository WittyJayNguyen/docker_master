@echo off
REM Docker Master Platform - Open All URLs
REM Mở tất cả URLs của platforms trong browser

echo.
echo ========================================
echo   Open All Platform URLs
========================================
echo.

echo 🌐 OPENING ALL PLATFORM URLS
echo ================================================================

echo ℹ️  Opening all available platforms in your default browser...

echo.
echo 🚀 Core Platforms:
echo ----------------------------------------------------------------

echo Opening WordPress Blog (Port 8015)...
start http://localhost:8015
timeout /t 2 /nobreak >nul

echo Opening Laravel PHP 8.4 (Port 8010)...
start http://localhost:8010
timeout /t 2 /nobreak >nul

echo Opening Laravel PHP 7.4 (Port 8020)...
start http://localhost:8020
timeout /t 2 /nobreak >nul

echo Opening WordPress Old (Port 8030)...
start http://localhost:8030
timeout /t 2 /nobreak >nul

echo.
echo 🗄️ Database Tools:
echo ----------------------------------------------------------------

echo Opening Mailhog (Email Testing)...
start http://localhost:8025
timeout /t 2 /nobreak >nul

echo.
echo 🔧 Nginx Health Check:
echo ----------------------------------------------------------------

echo Opening Nginx Health Check...
start http://localhost/nginx-health
timeout /t 2 /nobreak >nul

echo.
echo 🎉 ALL URLS OPENED!
echo ================================================================

echo 📋 Platform URLs:
echo ----------------------------------------------------------------
echo   • WordPress Blog:     http://localhost:8015
echo   • Laravel PHP 8.4:    http://localhost:8010
echo   • Laravel PHP 7.4:    http://localhost:8020
echo   • WordPress Old:      http://localhost:8030

echo.
echo 🗄️ Database Tools:
echo ----------------------------------------------------------------
echo   • Mailhog:            http://localhost:8025
echo   • MySQL:              localhost:3306 (mysql_user/mysql_pass)
echo   • PostgreSQL:         localhost:5432 (postgres_user/postgres_pass)

echo.
echo 🌐 Domain URLs (after hosts setup):
echo ----------------------------------------------------------------
echo   • WordPress:          http://wp-blog-example.asmo-tranding.io
echo   • Laravel 7.4:        http://laravel74-api-example.asmo-tranding.io
echo   • Laravel 8.4:        http://laravel84-shop-example.asmo-tranding.io

echo.
echo 💡 Setup Domain Routing:
echo ----------------------------------------------------------------
echo   Run as Administrator: scripts\setup-domains.bat

echo.
echo 🐛 Debug Ports:
echo ----------------------------------------------------------------
echo   • WordPress:          9015
echo   • Laravel 8.4:        9084
echo   • Laravel 7.4:        9074
echo   • WordPress Old:      9075

echo.
echo 🌟 ALL PLATFORMS READY FOR DEVELOPMENT!

pause
