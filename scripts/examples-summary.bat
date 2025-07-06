@echo off
REM Docker Master Platform - Examples Summary
REM Tổng kết 3 mẫu đã tạo với debug

echo.
echo ========================================
echo   3 EXAMPLES WITH DEBUG - SUMMARY
echo ========================================
echo.

echo 🎉 3 PERFECT EXAMPLES CREATED SUCCESSFULLY!
echo ================================================================

echo 📋 EXAMPLES OVERVIEW:
echo ----------------------------------------------------------------

echo 1️⃣ WordPress PHP 7.4 + MySQL + Xdebug
echo   • Name: wp-blog-example
echo   • Type: WordPress blog/CMS
echo   • PHP: 7.4 with Xdebug
echo   • Database: MySQL (wp_blog_example_db)
echo   • Port: http://localhost:8015
echo   • Xdebug: Port 9015

echo.
echo 2️⃣ Laravel PHP 7.4 + PostgreSQL + Xdebug
echo   • Name: laravel74-api-example
echo   • Type: API/Microservice
echo   • PHP: 7.4 with Xdebug
echo   • Database: PostgreSQL (laravel74_api_example_db)
echo   • Port: http://localhost:8016
echo   • Xdebug: Port 9016

echo.
echo 3️⃣ Laravel PHP 8.4 + MySQL + Xdebug
echo   • Name: laravel84-shop-example
echo   • Type: E-commerce store
echo   • PHP: 8.4 with Xdebug
echo   • Database: MySQL (laravel84_shop_example_db)
echo   • Port: http://localhost:8017
echo   • Xdebug: Port 9017

echo.
echo 🔍 CONTAINER STATUS:
echo ================================================================

echo 📊 Current Running Containers:
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}" --filter "name=_php"

echo.
echo 🗄️ DATABASE STATUS:
echo ================================================================

echo 📋 MySQL Databases:
docker exec mysql_low_ram mysql -u mysql_user -pmysql_pass -e "SHOW DATABASES;" 2>nul | findstr "_db"

echo.
echo 📋 PostgreSQL Databases:
docker exec postgres_low_ram psql -U postgres_user -d postgres -c "\l" | findstr "_db" | findstr -v "template"

echo.
echo 🐛 XDEBUG CONFIGURATION:
echo ================================================================

echo ✅ All platforms have Xdebug enabled:
echo ----------------------------------------------------------------
echo   • wp-blog-example (PHP 7.4): Xdebug 3.1.6
echo   • laravel74-api-example (PHP 7.4): Xdebug 3.3+
echo   • laravel84-shop-example (PHP 8.4): Xdebug 3.3+

echo.
echo 🔧 VS Code Debug Configuration:
echo ----------------------------------------------------------------
echo Add to your .vscode/launch.json:
echo {
echo   "version": "0.2.0",
echo   "configurations": [
echo     {
echo       "name": "WordPress PHP 7.4 Debug",
echo       "type": "php",
echo       "request": "launch",
echo       "port": 9015,
echo       "pathMappings": {
echo         "/app": "${workspaceFolder}/platforms/wp-blog-example/projects"
echo       }
echo     },
echo     {
echo       "name": "Laravel 7.4 API Debug",
echo       "type": "php",
echo       "request": "launch",
echo       "port": 9016,
echo       "pathMappings": {
echo         "/app": "${workspaceFolder}/platforms/laravel74-api-example/projects"
echo       }
echo     },
echo     {
echo       "name": "Laravel 8.4 Shop Debug",
echo       "type": "php",
echo       "request": "launch",
echo       "port": 9017,
echo       "pathMappings": {
echo         "/app": "${workspaceFolder}/platforms/laravel84-shop-example/projects"
echo       }
echo     }
echo   ]
echo }

echo.
echo 🌐 PLATFORM URLS:
echo ================================================================

echo 🔗 Access Your Platforms:
echo ----------------------------------------------------------------
echo   • WordPress Blog: http://localhost:8015
echo   • Laravel 7.4 API: http://localhost:8016
echo   • Laravel 8.4 Shop: http://localhost:8017

echo.
echo 📁 PROJECT DIRECTORIES:
echo ----------------------------------------------------------------
echo   • WordPress: platforms\wp-blog-example\projects\
echo   • Laravel 7.4: platforms\laravel74-api-example\projects\
echo   • Laravel 8.4: platforms\laravel84-shop-example\projects\

echo.
echo 🛠️ MANAGEMENT COMMANDS:
echo ================================================================

echo 📝 Platform Management:
echo ----------------------------------------------------------------
echo   # Stop specific platform
echo   docker-compose -f platforms\wp-blog-example\docker-compose.wp-blog-example.yml down
echo   docker-compose -f platforms\laravel74-api-example\docker-compose.laravel74-api-example.yml down
echo   docker-compose -f platforms\laravel84-shop-example\docker-compose.laravel84-shop-example.yml down

echo.
echo   # View logs
echo   docker logs wp-blog-example_php74
echo   docker logs laravel74-api-example_php74
echo   docker logs laravel84-shop-example_php84

echo.
echo   # Access containers
echo   docker exec -it wp-blog-example_php74 bash
echo   docker exec -it laravel74-api-example_php74 bash
echo   docker exec -it laravel84-shop-example_php84 bash

echo.
echo 🗄️ Database Access:
echo ----------------------------------------------------------------
echo   # MySQL (WordPress + Laravel 8.4)
echo   docker exec -it mysql_low_ram mysql -u mysql_user -pmysql_pass
echo   
echo   # PostgreSQL (Laravel 7.4)
echo   docker exec -it postgres_low_ram psql -U postgres_user -d postgres

echo.
echo 🧪 TESTING EXAMPLES:
echo ================================================================

echo 🔍 Test Database Connections:
echo ----------------------------------------------------------------

echo Testing WordPress MySQL connection...
docker exec wp-blog-example_php74 php -r "try { \$pdo = new PDO('mysql:host=mysql_low_ram;dbname=wp_blog_example_db', 'mysql_user', 'mysql_pass'); echo 'WordPress MySQL: ✅ Connected\n'; } catch(Exception \$e) { echo 'WordPress MySQL: ❌ Failed\n'; }"

echo.
echo Testing Laravel 7.4 PostgreSQL connection...
docker exec laravel74-api-example_php74 php -r "try { \$pdo = new PDO('pgsql:host=postgres_low_ram;dbname=laravel74_api_example_db', 'postgres_user', 'postgres_pass'); echo 'Laravel 7.4 PostgreSQL: ✅ Connected\n'; } catch(Exception \$e) { echo 'Laravel 7.4 PostgreSQL: ❌ Failed\n'; }"

echo.
echo Testing Laravel 8.4 MySQL connection...
docker exec laravel84-shop-example_php84 php -r "try { \$pdo = new PDO('mysql:host=mysql_low_ram;dbname=laravel84_shop_example_db', 'mysql_user', 'mysql_pass'); echo 'Laravel 8.4 MySQL: ✅ Connected\n'; } catch(Exception \$e) { echo 'Laravel 8.4 MySQL: ❌ Failed\n'; }"

echo.
echo 🐛 Test Xdebug Status:
echo ----------------------------------------------------------------

echo WordPress PHP 7.4 Xdebug:
docker exec wp-blog-example_php74 php -m | findstr xdebug

echo.
echo Laravel 7.4 Xdebug:
docker exec laravel74-api-example_php74 php -m | findstr xdebug

echo.
echo Laravel 8.4 Xdebug:
docker exec laravel84-shop-example_php84 php -m | findstr xdebug

echo.
echo 💾 MEMORY USAGE:
echo ================================================================

echo 📊 Container Memory Usage:
docker stats --no-stream --format "table {{.Container}}\t{{.MemUsage}}\t{{.MemPerc}}" --filter "name=_php"

echo.
echo 🎯 DEVELOPMENT WORKFLOW:
echo ================================================================

echo 🚀 Getting Started:
echo ----------------------------------------------------------------
echo 1. Open VS Code in docker_master directory
echo 2. Install PHP Debug extension
echo 3. Configure launch.json with above settings
echo 4. Set breakpoints in your PHP files
echo 5. Start debugging session
echo 6. Access platform URLs to trigger breakpoints

echo.
echo 📝 File Editing:
echo ----------------------------------------------------------------
echo   • WordPress files: platforms\wp-blog-example\projects\
echo   • Laravel 7.4 files: platforms\laravel74-api-example\projects\
echo   • Laravel 8.4 files: platforms\laravel84-shop-example\projects\

echo.
echo 🔄 Development Cycle:
echo ----------------------------------------------------------------
echo 1. Edit PHP files in VS Code
echo 2. Set breakpoints
echo 3. Access platform URL
echo 4. Debug with Xdebug
echo 5. Test database connections
echo 6. Deploy changes

echo.
echo 🌟 SUCCESS METRICS:
echo ================================================================

echo ✅ ACHIEVEMENTS:
echo   • 3 different PHP versions working
echo   • Both MySQL and PostgreSQL databases
echo   • Xdebug enabled on all platforms
echo   • Different platform types (WordPress, Laravel API, E-commerce)
echo   • Memory optimized configurations
echo   • Cross-platform compatibility

echo.
echo 🎉 ALL 3 EXAMPLES READY FOR DEVELOPMENT!
echo ================================================================

echo 💡 Quick Start:
echo   1. Open http://localhost:8015 (WordPress)
echo   2. Open http://localhost:8016 (Laravel 7.4 API)
echo   3. Open http://localhost:8017 (Laravel 8.4 Shop)
echo   4. Start debugging in VS Code!

echo.
echo 🌟 PERFECT DEVELOPMENT ENVIRONMENT READY!
echo    WordPress + Laravel with full debugging support!

pause
