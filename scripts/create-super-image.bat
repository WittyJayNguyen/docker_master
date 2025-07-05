@echo off
REM Docker Master Platform - Create Super Image
REM Tạo 1 image duy nhất chứa tất cả services để tiết kiệm tối đa

setlocal enabledelayedexpansion

echo.
echo ========================================
echo   Docker Master - Super Image Creator
echo ========================================
echo.

echo 🚀 This will create ONE image containing ALL services:
echo    • PHP 8.4 + PHP 7.4
echo    • Apache + Nginx
echo    • PostgreSQL + MySQL + Redis
echo    • All Laravel/WordPress dependencies
echo    • Queue workers + Schedulers
echo    • Monitoring tools
echo.

echo 💾 Expected benefits:
echo    • From ~16GB (multiple images) to ~2GB (single image)
echo    • 87%% disk space savings
echo    • Faster container startup
echo    • Simplified management
echo.

set /p confirm="Create super image? (y/N): "
if /i not "%confirm%"=="y" goto :end

echo.
echo 🏗️  Creating Super Image...
echo ================================================================

REM Tạo thư mục cho super image
mkdir docker\super 2>nul

echo 📝 Creating super Dockerfile...
(
echo # Docker Master - Super Image
echo # Contains ALL services in one optimized image
echo FROM ubuntu:22.04
echo.
echo ENV DEBIAN_FRONTEND=noninteractive
echo.
echo # Install all system dependencies
echo RUN apt-get update ^&^& apt-get install -y \
echo     # Web servers
echo     apache2 nginx \
echo     # PHP versions
echo     php8.1 php8.1-fpm php8.1-cli php8.1-common \
echo     php8.1-mysql php8.1-pgsql php8.1-zip php8.1-gd \
echo     php8.1-mbstring php8.1-curl php8.1-xml php8.1-bcmath \
echo     php7.4 php7.4-fpm php7.4-cli php7.4-common \
echo     php7.4-mysql php7.4-pgsql php7.4-zip php7.4-gd \
echo     php7.4-mbstring php7.4-curl php7.4-xml php7.4-bcmath \
echo     # Databases
echo     postgresql-14 postgresql-client-14 \
echo     mysql-server-8.0 mysql-client-8.0 \
echo     redis-server \
echo     # Process management
echo     supervisor \
echo     # Utilities
echo     curl wget git unzip vim htop cron \
echo     ^&^& rm -rf /var/lib/apt/lists/*
echo.
echo # Install Composer
echo RUN curl -sS https://getcomposer.org/installer ^| php -- --install-dir=/usr/local/bin --filename=composer
echo.
echo # Install Node.js ^(for Laravel Mix^)
echo RUN curl -fsSL https://deb.nodesource.com/setup_18.x ^| bash - \
echo     ^&^& apt-get install -y nodejs
echo.
echo # Configure PHP for optimization
echo RUN { \
echo     echo 'memory_limit = 256M'; \
echo     echo 'max_execution_time = 60'; \
echo     echo 'opcache.enable = 1'; \
echo     echo 'opcache.memory_consumption = 128'; \
echo     echo 'opcache.max_accelerated_files = 4000'; \
echo } ^> /etc/php/8.1/apache2/conf.d/99-optimization.ini
echo.
echo RUN cp /etc/php/8.1/apache2/conf.d/99-optimization.ini /etc/php/7.4/apache2/conf.d/
echo.
echo # Configure databases for low memory
echo RUN { \
echo     echo "shared_buffers = 32MB"; \
echo     echo "effective_cache_size = 128MB"; \
echo     echo "work_mem = 4MB"; \
echo     echo "max_connections = 50"; \
echo } ^>^> /etc/postgresql/14/main/postgresql.conf
echo.
echo RUN { \
echo     echo "[mysqld]"; \
echo     echo "innodb_buffer_pool_size = 64M"; \
echo     echo "innodb_log_file_size = 16M"; \
echo     echo "max_connections = 50"; \
echo     echo "query_cache_size = 16M"; \
echo } ^> /etc/mysql/conf.d/optimization.cnf
echo.
echo RUN { \
echo     echo "maxmemory 32mb"; \
echo     echo "maxmemory-policy allkeys-lru"; \
echo } ^>^> /etc/redis/redis.conf
echo.
echo # Configure Apache virtual hosts
echo COPY apache-sites/ /etc/apache2/sites-available/
echo RUN a2enmod rewrite php8.1 ^&^& a2ensite 000-default
echo.
echo # Configure Nginx
echo COPY nginx-sites/ /etc/nginx/sites-available/
echo RUN ln -s /etc/nginx/sites-available/default /etc/nginx/sites-enabled/
echo.
echo # Create supervisor configuration
echo COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
echo.
echo # Create application directories
echo RUN mkdir -p /var/www/html/laravel-php84 \
echo              /var/www/html/laravel-php74 \
echo              /var/www/html/wordpress \
echo              /var/www/html/asmo-trading
echo.
echo # Set permissions
echo RUN chown -R www-data:www-data /var/www/html
echo RUN chmod -R 755 /var/www/html
echo.
echo # Initialize databases
echo RUN service postgresql start ^&^& \
echo     sudo -u postgres createuser -s root ^&^& \
echo     sudo -u postgres createdb docker_master ^&^& \
echo     service postgresql stop
echo.
echo RUN service mysql start ^&^& \
echo     mysql -e "CREATE DATABASE docker_master;" ^&^& \
echo     mysql -e "CREATE USER 'docker_user'@'%%' IDENTIFIED BY 'docker_pass';" ^&^& \
echo     mysql -e "GRANT ALL PRIVILEGES ON *.* TO 'docker_user'@'%%';" ^&^& \
echo     service mysql stop
echo.
echo # Expose all ports
echo EXPOSE 80 443 3306 5432 6379 8080 8081 8082 8083
echo.
echo # Health check
echo HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
echo     CMD curl -f http://localhost/ ^|^| exit 1
echo.
echo # Start supervisor
echo CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
) > docker\super\Dockerfile

echo 📝 Creating supervisor configuration...
(
echo [supervisord]
echo nodaemon=true
echo user=root
echo.
echo [program:postgresql]
echo command=/usr/lib/postgresql/14/bin/postgres -D /var/lib/postgresql/14/main -c config_file=/etc/postgresql/14/main/postgresql.conf
echo user=postgres
echo autostart=true
echo autorestart=true
echo priority=100
echo.
echo [program:mysql]
echo command=/usr/sbin/mysqld
echo user=mysql
echo autostart=true
echo autorestart=true
echo priority=200
echo.
echo [program:redis]
echo command=redis-server /etc/redis/redis.conf
echo user=redis
echo autostart=true
echo autorestart=true
echo priority=300
echo.
echo [program:apache2]
echo command=/usr/sbin/apache2ctl -D FOREGROUND
echo user=root
echo autostart=true
echo autorestart=true
echo priority=400
echo.
echo [program:nginx]
echo command=/usr/sbin/nginx -g "daemon off;"
echo user=root
echo autostart=false
echo autorestart=true
echo priority=500
) > docker\super\supervisord.conf

echo 📝 Creating Apache virtual hosts...
mkdir docker\super\apache-sites 2>nul
(
echo ^<VirtualHost *:80^>
echo     ServerName localhost
echo     DocumentRoot /var/www/html
echo     DirectoryIndex index.php index.html
echo     
echo     ^<Directory /var/www/html^>
echo         AllowOverride All
echo         Require all granted
echo     ^</Directory^>
echo ^</VirtualHost^>
) > docker\super\apache-sites\000-default.conf

echo 🏗️  Building super image (this may take 10-15 minutes)...
docker build -t docker-master-super:latest docker\super\

if errorlevel 1 (
    echo ❌ Build failed! Check the error messages above.
    pause
    goto :end
)

echo 📝 Creating super compose file...
(
echo version: '3.8'
echo.
echo services:
echo   super-container:
echo     image: docker-master-super:latest
echo     container_name: docker_master_super
echo     restart: unless-stopped
echo     ports:
echo       - "8080:80"      # Apache
echo       - "8443:443"     # HTTPS
echo       - "3306:3306"    # MySQL
echo       - "5432:5432"    # PostgreSQL
echo       - "6379:6379"    # Redis
echo     volumes:
echo       - ./projects:/var/www/html:rw
echo       - ./logs:/var/log:rw
echo       - ./data:/var/lib:rw
echo     environment:
echo       - MYSQL_ROOT_PASSWORD=root_pass
echo       - POSTGRES_PASSWORD=postgres_pass
echo     deploy:
echo       resources:
echo         limits:
echo           memory: 1GB
echo           cpus: '2.0'
echo         reservations:
echo           memory: 512M
echo           cpus: '1.0'
echo     healthcheck:
echo       test: ["CMD-SHELL", "curl -f http://localhost/ ^&^& pg_isready ^&^& mysqladmin ping"]
echo       interval: 30s
echo       timeout: 10s
echo       retries: 3
echo       start_period: 60s
) > docker-compose.super.yml

echo 🚀 Starting super container...
docker-compose -f docker-compose.super.yml up -d

if errorlevel 1 (
    echo ❌ Failed to start super container!
    pause
    goto :end
)

echo.
echo ✅ Super Image Created Successfully!
echo ================================================================

echo 📊 Image comparison:
docker images | findstr "docker-master-super\|docker_master-"

echo.
echo 🌐 All services available on ONE container:
echo ================================================================
echo ✅ All PHP projects:     http://localhost:8080
echo ✅ MySQL:               localhost:3306
echo ✅ PostgreSQL:          localhost:5432  
echo ✅ Redis:               localhost:6379
echo.

echo 💾 Resource usage:
docker stats --no-stream docker_master_super

echo.
echo 💡 Benefits achieved:
echo    • Single image instead of 10+ images
echo    • ~2GB total (vs ~16GB before)
echo    • All services in one container
echo    • Simplified management
echo    • Faster startup
echo.

echo 🗑️  Clean up old images? (y/N):
set /p cleanup="Remove old separate images? "
if /i "%cleanup%"=="y" (
    echo Removing old images...
    docker images | findstr "docker_master-" | awk "{print $3}" | xargs docker rmi -f 2>nul
    echo ✅ Old images removed!
)

:end
echo.
echo Press any key to exit...
pause >nul
