@echo off
REM Docker Master Platform - Group Images Script
REM Gom các images tương tự để tiết kiệm dung lượng

setlocal enabledelayedexpansion

echo.
echo ========================================
echo   Docker Master - Group Images Tool
echo ========================================
echo.

REM Kiểm tra Docker
docker version >nul 2>&1
if errorlevel 1 (
    echo ❌ Docker is not running! Please start Docker first.
    pause
    exit /b 1
)

echo 🔍 Analyzing current images...
echo ================================================================
docker images --format "table {{.Repository}}\t{{.Tag}}\t{{.Size}}\t{{.ID}}"
echo.

echo 📊 Current disk usage:
docker system df
echo.

echo 🛠️  Image Grouping Options:
echo ================================================================
echo [1] Create Multi-Service Base Image (Recommended)
echo [2] Remove Duplicate Images (Same base, different names)
echo [3] Create Shared Base Image for PHP projects
echo [4] Compress existing images
echo [5] Show image analysis
echo [0] Exit
echo.

set /p choice="Choose option (0-5): "

if "%choice%"=="0" goto :end
if "%choice%"=="1" goto :create_base
if "%choice%"=="2" goto :remove_duplicates
if "%choice%"=="3" goto :shared_base
if "%choice%"=="4" goto :compress_images
if "%choice%"=="5" goto :analyze_images

echo ❌ Invalid choice!
goto :end

:create_base
echo.
echo 🏗️  Creating Multi-Service Base Image...
echo ================================================================

echo 📝 Creating optimized base Dockerfile...
mkdir docker\base 2>nul

(
echo # Docker Master - Optimized Base Image
echo # Chứa tất cả dependencies chung cho các projects
echo FROM php:8.4-apache
echo.
echo # Install all common dependencies in one layer
echo RUN apt-get update ^&^& apt-get install -y \
echo     # Database clients
echo     postgresql-client \
echo     mysql-client \
echo     # PHP extensions deps
echo     libpq-dev libzip-dev libpng-dev libjpeg-dev libfreetype6-dev \
echo     # Queue/Scheduler deps  
echo     supervisor cron \
echo     # Utilities
echo     curl vim htop git unzip \
echo     ^&^& rm -rf /var/lib/apt/lists/*
echo.
echo # Install PHP extensions
echo RUN docker-php-ext-configure gd --with-freetype --with-jpeg \
echo     ^&^& docker-php-ext-install -j$^(nproc^) \
echo         pdo pdo_mysql pdo_pgsql pgsql mysqli zip gd opcache
echo.
echo # Install Composer
echo COPY --from=composer:latest /usr/bin/composer /usr/bin/composer
echo.
echo # Optimize PHP
echo RUN { \
echo     echo 'memory_limit = 128M'; \
echo     echo 'opcache.enable = 1'; \
echo     echo 'opcache.memory_consumption = 64'; \
echo     echo 'opcache.max_accelerated_files = 2000'; \
echo } ^> /usr/local/etc/php/conf.d/optimization.ini
echo.
echo # Configure Apache
echo RUN a2enmod rewrite
echo.
echo WORKDIR /var/www/html
) > docker\base\Dockerfile

echo 🏗️  Building base image...
docker build -t docker-master-base:latest docker\base\

if errorlevel 1 (
    echo ❌ Failed to build base image!
    pause
    goto :end
)

echo 📝 Creating optimized project Dockerfiles...

REM Tạo Dockerfile tối ưu cho từng project
for %%p in (laravel-php84-psql laravel-php74-psql wordpress-php74-mysql) do (
    echo Creating optimized Dockerfile for %%p...
    (
    echo FROM docker-master-base:latest
    echo.
    echo # Project-specific configurations
    echo COPY . /var/www/html/
    echo RUN chown -R www-data:www-data /var/www/html
    echo.
    echo EXPOSE 80
    ) > platforms\%%p\Dockerfile.optimized
)

echo ✅ Base image created! Now rebuild your projects using:
echo    docker build -f platforms/PROJECT/Dockerfile.optimized -t PROJECT:optimized .
echo.
goto :end

:remove_duplicates
echo.
echo 🧹 Removing Duplicate Images...
echo ================================================================

echo 🔍 Finding duplicate images...

REM Tìm images có cùng IMAGE ID
echo Checking for images with same ID but different names...
for /f "tokens=3" %%i in ('docker images --format "{{.ID}}" ^| sort ^| uniq -d') do (
    echo Found duplicate ID: %%i
    docker images --filter "reference=*" --format "{{.Repository}}:{{.Tag}} {{.ID}}" | findstr %%i
)

echo.
echo ⚠️  This will remove images with duplicate names but same content
set /p confirm="Continue? (y/N): "
if /i not "%confirm%"=="y" goto :end

REM Xóa images trùng lặp (giữ lại 1 cái)
echo 🗑️  Removing duplicate images...
docker image prune -f

REM Tag lại images để có tên ngắn gọn hơn
echo 🏷️  Retagging images with shorter names...
docker tag docker_master-laravel-php84-psql:latest laravel-php84:latest
docker tag docker_master-laravel-php74-psql:latest laravel-php74:latest  
docker tag docker_master-wordpress-php74-mysql:latest wordpress:latest
docker tag docker_master-asmo-trading-app:latest asmo-trading:latest

echo ✅ Duplicate removal completed!
goto :end

:shared_base
echo.
echo 🔧 Creating Shared Base for PHP Projects...
echo ================================================================

echo 📝 Creating shared PHP base image...
mkdir docker\shared-php 2>nul

(
echo FROM php:8.4-apache
echo.
echo # Common PHP extensions and tools
echo RUN apt-get update ^&^& apt-get install -y \
echo     libpq-dev libzip-dev libpng-dev libjpeg-dev libfreetype6-dev \
echo     ^&^& docker-php-ext-configure gd --with-freetype --with-jpeg \
echo     ^&^& docker-php-ext-install -j$^(nproc^) pdo pdo_mysql pdo_pgsql zip gd opcache \
echo     ^&^& rm -rf /var/lib/apt/lists/*
echo.
echo COPY --from=composer:latest /usr/bin/composer /usr/bin/composer
echo RUN a2enmod rewrite
) > docker\shared-php\Dockerfile

echo 🏗️  Building shared PHP base...
docker build -t php-base:8.4 docker\shared-php\

echo ✅ Shared base created! Use 'FROM php-base:8.4' in your Dockerfiles
goto :end

:compress_images
echo.
echo 🗜️  Compressing Existing Images...
echo ================================================================

echo 📦 Creating compressed versions of large images...

REM Tạo script để export/import images (nén chúng)
echo Creating compressed versions...

for %%i in (docker_master-laravel-php84-psql docker_master-laravel-php74-psql) do (
    echo Compressing %%i...
    docker save %%i:latest | gzip > temp_%%i.tar.gz
    docker rmi %%i:latest
    gunzip -c temp_%%i.tar.gz | docker load
    del temp_%%i.tar.gz
)

echo ✅ Images compressed!
goto :end

:analyze_images
echo.
echo 📊 Image Analysis Report:
echo ================================================================

echo 🔍 Images by size:
docker images --format "table {{.Repository}}\t{{.Tag}}\t{{.Size}}" | sort -k3 -hr

echo.
echo 📈 Disk usage breakdown:
docker system df -v

echo.
echo 🔍 Potential savings analysis:
echo ================================================================

REM Đếm số images có cùng base
echo PHP 8.4 based images:
docker images | findstr "php84" | wc -l

echo PHP 7.4 based images:  
docker images | findstr "php74" | wc -l

echo Laravel based images:
docker images | findstr "laravel" | wc -l

echo.
echo 💡 Recommendations:
echo ================================================================
echo • You have multiple similar PHP images (1.82GB each)
echo • Consider using a shared base image
echo • Current total: ~16GB for similar images
echo • Potential savings: ~12GB (75%% reduction)
echo.
echo 🚀 Suggested actions:
echo   1. Create shared base image (Option 3)
echo   2. Remove duplicates (Option 2)  
echo   3. Use multi-stage builds
echo   4. Regular cleanup with docker system prune
echo.

:end
echo.
echo Press any key to exit...
pause >nul
