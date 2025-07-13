# 🐳 Docker Master - Optimized Docker Structure

## 📁 Cấu Trúc Docker Mới

```
docker/
├── base/                     # Base images cho tái sử dụng
│   ├── php-base/            # Base PHP image với common extensions
│   ├── nginx-base/          # Base Nginx với optimized config
│   └── alpine-base/         # Base Alpine với common tools
├── services/                # Service-specific images
│   ├── php/                 # PHP services
│   │   ├── php74/          # PHP 7.4 optimized
│   │   └── php84/          # PHP 8.4 optimized
│   ├── databases/          # Database services
│   │   ├── postgres/       # PostgreSQL optimized
│   │   ├── mysql/          # MySQL optimized
│   │   └── redis/          # Redis optimized
│   ├── web/                # Web servers
│   │   ├── nginx/          # Nginx proxy
│   │   └── apache/         # Apache (if needed)
│   └── tools/              # Development tools
│       ├── mailhog/        # Email testing
│       └── monitoring/     # Monitoring tools
├── templates/              # Docker templates
│   ├── compose/            # Docker Compose templates
│   ├── dockerfiles/        # Dockerfile templates
│   └── configs/            # Configuration templates
└── scripts/                # Docker utility scripts
    ├── build-all.sh        # Build all images
    ├── push-images.sh      # Push to registry
    └── cleanup.sh          # Cleanup unused images
```

## 🎯 Tối Ưu Hóa Chính

### 1. Base Images Strategy
- **Shared base images** để giảm duplication
- **Multi-stage builds** để optimize image size
- **Layer caching** để tăng tốc build
- **Security scanning** cho all images

### 2. Service Organization
- **Separation of concerns** - mỗi service một thư mục
- **Version management** - clear versioning strategy
- **Configuration externalization** - configs outside images
- **Health checks** cho tất cả services

### 3. Build Optimization
- **Parallel builds** để tăng tốc
- **Incremental builds** chỉ build khi cần
- **Registry caching** để tái sử dụng layers
- **Size optimization** với multi-stage builds

## 🏗️ Base Images

### PHP Base Image
```dockerfile
# docker/base/php-base/Dockerfile
FROM php:8.4-apache-alpine

# Common PHP extensions
RUN apk add --no-cache \
    postgresql-dev \
    mysql-dev \
    redis \
    imagemagick-dev \
    && docker-php-ext-install \
    pdo_pgsql \
    pdo_mysql \
    gd \
    zip \
    opcache

# Common tools
RUN apk add --no-cache \
    git \
    curl \
    wget \
    unzip \
    nano

# Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Base configuration
COPY php.ini /usr/local/etc/php/
COPY apache.conf /etc/apache2/sites-available/000-default.conf
```

### Nginx Base Image
```dockerfile
# docker/base/nginx-base/Dockerfile
FROM nginx:alpine

# Install common tools
RUN apk add --no-cache \
    curl \
    openssl \
    certbot

# Copy optimized nginx config
COPY nginx.conf /etc/nginx/nginx.conf
COPY ssl/ /etc/nginx/ssl/

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD curl -f http://localhost/health || exit 1
```

## 🔧 Service Images

### PHP 7.4 Service
```dockerfile
# docker/services/php/php74/Dockerfile
FROM docker-master/php-base:latest

# PHP 7.4 specific configurations
COPY php74.ini /usr/local/etc/php/conf.d/
COPY xdebug.ini /usr/local/etc/php/conf.d/

# Install Xdebug for PHP 7.4
RUN pecl install xdebug-3.1.6 \
    && docker-php-ext-enable xdebug

# Memory optimization for PHP 7.4
ENV PHP_MEMORY_LIMIT=96M
ENV PHP_OPCACHE_MEMORY_CONSUMPTION=32

LABEL version="7.4"
LABEL description="PHP 7.4 optimized for Docker Master"
```

### PHP 8.4 Service
```dockerfile
# docker/services/php/php84/Dockerfile
FROM docker-master/php-base:latest

# PHP 8.4 specific configurations
COPY php84.ini /usr/local/etc/php/conf.d/
COPY xdebug.ini /usr/local/etc/php/conf.d/

# Install latest Xdebug
RUN pecl install xdebug \
    && docker-php-ext-enable xdebug

# Enhanced memory for PHP 8.4
ENV PHP_MEMORY_LIMIT=128M
ENV PHP_OPCACHE_MEMORY_CONSUMPTION=64

LABEL version="8.4"
LABEL description="PHP 8.4 optimized for Docker Master"
```

## 📋 Templates

### Platform Docker Compose Template
```yaml
# docker/templates/compose/platform.yml
version: '3.8'

services:
  {{PLATFORM_NAME}}:
    build:
      context: ./docker/services/php/php{{PHP_VERSION}}
      dockerfile: Dockerfile
    container_name: {{PLATFORM_NAME}}_php{{PHP_VERSION}}
    restart: unless-stopped
    ports:
      - "{{PLATFORM_PORT}}:80"
      - "{{XDEBUG_PORT}}:9003"
    volumes:
      - ./projects/{{PLATFORM_NAME}}:/var/www/html
      - ./logs/apache/{{PLATFORM_NAME}}:/var/log/apache2
      - ./data/uploads/{{PLATFORM_NAME}}:/app/uploads
    environment:
      - WEB_DOCUMENT_ROOT=/var/www/html
      - PHP_VERSION={{PHP_VERSION}}
      - DB_HOST={{DB_HOST}}
      - DB_PORT={{DB_PORT}}
      - DB_DATABASE={{DB_NAME}}
      - DB_USERNAME={{DB_USER}}
      - DB_PASSWORD={{DB_PASS}}
      - REDIS_HOST={{REDIS_HOST}}
      - REDIS_PORT={{REDIS_PORT}}
    deploy:
      resources:
        limits:
          memory: {{MEMORY_LIMIT}}
        reservations:
          memory: {{MEMORY_RESERVATION}}
    networks:
      - {{NETWORK_NAME}}
    depends_on:
      - {{DATABASE_SERVICE}}
      - redis
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost/"]
      interval: 30s
      timeout: 10s
      retries: 3

networks:
  {{NETWORK_NAME}}:
    external: true
```

## 🚀 Build Scripts

### Build All Images
```bash
#!/bin/bash
# docker/scripts/build-all.sh

source ../automation/shared/common.sh

print_header "Building Docker Master Images"

# Build base images first
log_info "Building base images..."
docker build -t docker-master/php-base:latest ./base/php-base/
docker build -t docker-master/nginx-base:latest ./base/nginx-base/
docker build -t docker-master/alpine-base:latest ./base/alpine-base/

# Build service images
log_info "Building PHP service images..."
docker build -t docker-master/php74:latest ./services/php/php74/
docker build -t docker-master/php84:latest ./services/php/php84/

log_info "Building database images..."
docker build -t docker-master/postgres:latest ./services/databases/postgres/
docker build -t docker-master/mysql:latest ./services/databases/mysql/
docker build -t docker-master/redis:latest ./services/databases/redis/

log_info "Building web server images..."
docker build -t docker-master/nginx:latest ./services/web/nginx/

log_success "All images built successfully!"
```

### Image Cleanup
```bash
#!/bin/bash
# docker/scripts/cleanup.sh

source ../automation/shared/common.sh

print_header "Docker Cleanup"

# Remove unused images
log_info "Removing unused images..."
docker image prune -f

# Remove unused volumes
log_info "Removing unused volumes..."
docker volume prune -f

# Remove unused networks
log_info "Removing unused networks..."
docker network prune -f

# Remove build cache
log_info "Removing build cache..."
docker builder prune -f

log_success "Docker cleanup completed!"
```

## 📊 Benefits của Cấu Trúc Mới

### 1. Reduced Build Time
- **Base image reuse** giảm thời gian build
- **Layer caching** tối ưu hóa rebuilds
- **Parallel builds** cho multiple services

### 2. Smaller Image Sizes
- **Multi-stage builds** loại bỏ unnecessary files
- **Alpine base** cho minimal footprint
- **Shared layers** giảm storage usage

### 3. Better Maintainability
- **Clear separation** giữa base và service images
- **Version management** dễ dàng hơn
- **Configuration externalization** dễ customize

### 4. Enhanced Security
- **Regular base image updates** 
- **Security scanning** integration
- **Minimal attack surface** với Alpine

### 5. Development Experience
- **Faster container startup** với optimized images
- **Better debugging** với proper health checks
- **Consistent environments** across platforms

## 🔄 Migration Plan

### Phase 1: Base Images
1. Tạo base images mới
2. Test với existing platforms
3. Optimize performance

### Phase 2: Service Migration
1. Migrate PHP services
2. Update database services  
3. Enhance web server configs

### Phase 3: Template System
1. Create compose templates
2. Implement template engine
3. Update automation scripts

### Phase 4: Optimization
1. Implement build caching
2. Add security scanning
3. Performance monitoring
