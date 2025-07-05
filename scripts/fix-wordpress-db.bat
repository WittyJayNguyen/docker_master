@echo off
REM Docker Master Platform - Fix WordPress Database Connection
REM Sửa cấu hình WordPress để sử dụng PostgreSQL thay vì MySQL

setlocal enabledelayedexpansion

echo.
echo ========================================
echo   Docker Master - Fix WordPress DB
echo ========================================
echo.

echo 🔧 Fixing WordPress database connection...
echo ================================================================

echo 📊 Current container status:
docker ps --filter "name=wordpress_php74_low_ram" --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
echo.

echo 🔍 Checking WordPress configuration...

REM Kiểm tra xem có file wp-config.php không
if exist "projects\wordpress-php74-mysql\wp-config.php" (
    echo ✅ Found wp-config.php
    
    echo 🔧 Creating PostgreSQL-compatible wp-config.php...
    
    REM Backup file cũ
    copy "projects\wordpress-php74-mysql\wp-config.php" "projects\wordpress-php74-mysql\wp-config.php.backup" >nul 2>&1
    
    REM Tạo wp-config.php mới cho PostgreSQL
    (
    echo ^<?php
    echo /**
    echo  * WordPress Database Configuration for PostgreSQL
    echo  * Docker Master Platform - Low RAM Configuration
    echo  */
    echo.
    echo // PostgreSQL Database settings
    echo define^( 'DB_NAME', 'wordpress_php74' ^);
    echo define^( 'DB_USER', 'postgres_user' ^);
    echo define^( 'DB_PASSWORD', 'postgres_pass' ^);
    echo define^( 'DB_HOST', 'postgres_low_ram:5432' ^);
    echo define^( 'DB_CHARSET', 'utf8' ^);
    echo define^( 'DB_COLLATE', '' ^);
    echo.
    echo // Use PostgreSQL instead of MySQL
    echo define^( 'DB_TYPE', 'pgsql' ^);
    echo.
    echo // WordPress Security Keys
    echo define^( 'AUTH_KEY',         'put your unique phrase here' ^);
    echo define^( 'SECURE_AUTH_KEY',  'put your unique phrase here' ^);
    echo define^( 'LOGGED_IN_KEY',    'put your unique phrase here' ^);
    echo define^( 'NONCE_KEY',        'put your unique phrase here' ^);
    echo define^( 'AUTH_SALT',        'put your unique phrase here' ^);
    echo define^( 'SECURE_AUTH_SALT', 'put your unique phrase here' ^);
    echo define^( 'LOGGED_IN_SALT',   'put your unique phrase here' ^);
    echo define^( 'NONCE_SALT',       'put your unique phrase here' ^);
    echo.
    echo // WordPress Table prefix
    echo $table_prefix = 'wp_';
    echo.
    echo // WordPress Debug mode
    echo define^( 'WP_DEBUG', true ^);
    echo define^( 'WP_DEBUG_LOG', true ^);
    echo define^( 'WP_DEBUG_DISPLAY', false ^);
    echo.
    echo // Memory limit
    echo define^( 'WP_MEMORY_LIMIT', '96M' ^);
    echo.
    echo // WordPress URLs
    echo define^( 'WP_HOME', 'http://localhost:8030' ^);
    echo define^( 'WP_SITEURL', 'http://localhost:8030' ^);
    echo.
    echo // Disable file editing
    echo define^( 'DISALLOW_FILE_EDIT', true ^);
    echo.
    echo // WordPress absolute path
    echo if ^( ! defined^( 'ABSPATH' ^) ^) {
    echo     define^( 'ABSPATH', __DIR__ . '/' ^);
    echo }
    echo.
    echo // WordPress settings
    echo require_once ABSPATH . 'wp-settings.php';
    ) > "projects\wordpress-php74-mysql\wp-config.php"
    
    echo ✅ Created PostgreSQL-compatible wp-config.php
    
) else (
    echo ❌ wp-config.php not found, creating new one...
    
    REM Tạo thư mục nếu chưa có
    mkdir "projects\wordpress-php74-mysql" 2>nul
    
    REM Tạo wp-config.php mới
    (
    echo ^<?php
    echo /**
    echo  * WordPress Database Configuration for PostgreSQL
    echo  * Docker Master Platform - Low RAM Configuration
    echo  */
    echo.
    echo // PostgreSQL Database settings
    echo define^( 'DB_NAME', 'wordpress_php74' ^);
    echo define^( 'DB_USER', 'postgres_user' ^);
    echo define^( 'DB_PASSWORD', 'postgres_pass' ^);
    echo define^( 'DB_HOST', 'postgres_low_ram:5432' ^);
    echo define^( 'DB_CHARSET', 'utf8' ^);
    echo define^( 'DB_COLLATE', '' ^);
    echo.
    echo // WordPress Security Keys ^(generate new ones^)
    echo define^( 'AUTH_KEY',         'your-auth-key-here' ^);
    echo define^( 'SECURE_AUTH_KEY',  'your-secure-auth-key-here' ^);
    echo define^( 'LOGGED_IN_KEY',    'your-logged-in-key-here' ^);
    echo define^( 'NONCE_KEY',        'your-nonce-key-here' ^);
    echo define^( 'AUTH_SALT',        'your-auth-salt-here' ^);
    echo define^( 'SECURE_AUTH_SALT', 'your-secure-auth-salt-here' ^);
    echo define^( 'LOGGED_IN_SALT',   'your-logged-in-salt-here' ^);
    echo define^( 'NONCE_SALT',       'your-nonce-salt-here' ^);
    echo.
    echo $table_prefix = 'wp_';
    echo define^( 'WP_DEBUG', true ^);
    echo define^( 'WP_MEMORY_LIMIT', '96M' ^);
    echo define^( 'WP_HOME', 'http://localhost:8030' ^);
    echo define^( 'WP_SITEURL', 'http://localhost:8030' ^);
    echo.
    echo if ^( ! defined^( 'ABSPATH' ^) ^) {
    echo     define^( 'ABSPATH', __DIR__ . '/' ^);
    echo }
    echo require_once ABSPATH . 'wp-settings.php';
    ) > "projects\wordpress-php74-mysql\wp-config.php"
    
    echo ✅ Created new wp-config.php for PostgreSQL
)

echo.
echo 🗄️ Creating WordPress database in PostgreSQL...
docker exec postgres_low_ram psql -U postgres_user -c "CREATE DATABASE wordpress_php74;" 2>nul
if errorlevel 1 (
    echo ℹ️  Database wordpress_php74 may already exist
) else (
    echo ✅ Created database wordpress_php74
)

echo.
echo 🔄 Restarting WordPress container...
docker-compose -f docker-compose.low-ram.yml restart wordpress-php74

echo.
echo ⏳ Waiting for WordPress to start...
timeout /t 10 /nobreak >nul

echo.
echo 🌐 Testing WordPress connection...
curl -s -o nul -w "%%{http_code}" http://localhost:8030 > temp_wp_status.txt 2>nul
set /p wp_status=<temp_wp_status.txt
if "%wp_status%"=="200" (
    echo ✅ WordPress is responding: http://localhost:8030
) else (
    echo ⚠️  WordPress may still be starting up...
    echo    Check manually: http://localhost:8030
)
del temp_wp_status.txt 2>nul

echo.
echo 📋 WordPress Configuration Summary:
echo ================================================================
echo ✅ Database: PostgreSQL (postgres_low_ram:5432)
echo ✅ Database Name: wordpress_php74
echo ✅ Username: postgres_user
echo ✅ Password: postgres_pass
echo ✅ WordPress URL: http://localhost:8030
echo ✅ Debug Mode: Enabled
echo ✅ Memory Limit: 96M
echo.

echo 💡 Next Steps:
echo    1. Open http://localhost:8030 in browser
echo    2. Complete WordPress installation
echo    3. Install PostgreSQL plugin if needed
echo    4. Configure WordPress settings
echo.

echo 🔧 Troubleshooting:
echo    • View logs: docker logs wordpress_php74_low_ram
echo    • Check database: docker exec postgres_low_ram psql -U postgres_user -l
echo    • Restart: docker-compose -f docker-compose.low-ram.yml restart wordpress-php74
echo.

pause
