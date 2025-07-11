# 🛠️ Hướng dẫn phát triển

> **Mục tiêu**: Tùy chỉnh, mở rộng và tạo platform mới

## 🏗️ Kiến trúc dự án

### Modular Design
Mỗi platform là một module độc lập:
```
platforms/
├── shared/                    # Services chung (DB, Redis, Mail)
├── laravel-php84-psql/       # Laravel PHP 8.4 platform
├── laravel-php74-psql/       # Laravel PHP 7.4 platform
└── wordpress-php74-mysql/    # WordPress platform
```

### Auto-Discovery
- Docker Compose tự động scan thư mục `platforms/`
- Tìm tất cả file `docker-compose.*.yml`
- Include vào main compose file

## 🆕 Tạo Platform mới

### Cách 1: Sử dụng Script (Khuyến nghị)
```bash
# Tạo Laravel project
.\create-platform.sh laravel my-shop 8015

# Tạo WordPress site  
.\create-platform.sh wordpress my-blog 8016

# Tạo Vue.js app
.\create-platform.sh vue my-frontend 8017
```

### Cách 2: Thủ công

#### Bước 1: Tạo Platform Config
```bash
# Tạo thư mục platform
mkdir platforms/my-project

# Copy template
cp platforms/templates/laravel.template.yml platforms/my-project/docker-compose.my-project.yml
```

#### Bước 2: Chỉnh sửa Config
```yaml
# platforms/my-project/docker-compose.my-project.yml
version: '3.8'

services:
  my-project:
    build:
      context: ../../docker/php84
    container_name: my_project_app
    ports:
      - "8015:80"      # Đổi port
      - "9015:9003"    # Debug port
    volumes:
      - ../../projects/my-project:/app/my-project
    environment:
      - WEB_DOCUMENT_ROOT=/app/my-project
      - PROJECT_NAME=my-project
```

#### Bước 3: Tạo Source Code
```bash
# Tạo thư mục project
mkdir projects/my-project

# Copy code từ template hoặc tạo mới
cp -r projects/laravel-php84-psql projects/my-project
```

#### Bước 4: Update Main Compose
```yaml
# docker-compose.yml - thêm vào include section
include:
  - ./platforms/shared/docker-compose.shared.yml
  - ./platforms/my-project/docker-compose.my-project.yml
```

## 🔧 Tùy chỉnh Platform

### Thay đổi PHP Version
```dockerfile
# docker/my-custom-php/Dockerfile
FROM webdevops/php-apache:8.3

# Custom PHP extensions
RUN docker-php-ext-install pdo_mysql gd
```

### Thêm Services
```yaml
# platforms/my-project/docker-compose.my-project.yml
services:
  my-project-redis:
    image: redis:alpine
    container_name: my_project_redis
    ports:
      - "6380:6379"
```

### Custom Environment Variables
```yaml
environment:
  - APP_ENV=development
  - DB_HOST=postgres_server
  - CUSTOM_VAR=my_value
```

## 📁 Cấu trúc Templates

### Laravel Template
```yaml
# platforms/templates/laravel.template.yml
services:
  {{PROJECT_NAME}}:
    build:
      context: ../../docker/php{{PHP_VERSION}}
    container_name: {{PROJECT_NAME}}_app
    ports:
      - "{{PORT}}:80"
      - "{{DEBUG_PORT}}:9003"
    volumes:
      - ../../projects/{{PROJECT_NAME}}:/app/{{PROJECT_NAME}}
    environment:
      - WEB_DOCUMENT_ROOT=/app/{{PROJECT_NAME}}/public
```

### WordPress Template
```yaml
# platforms/templates/wordpress.template.yml
services:
  {{PROJECT_NAME}}:
    build:
      context: ../../docker/php74
    container_name: {{PROJECT_NAME}}_app
    ports:
      - "{{PORT}}:80"
    environment:
      - WORDPRESS_DB_HOST=mysql_server
      - WORDPRESS_DB_NAME={{PROJECT_NAME}}
```

## 🐳 Custom Dockerfiles

### Tạo PHP Custom
```dockerfile
# docker/php-custom/Dockerfile
FROM webdevops/php-apache:8.4

# Install additional packages
RUN apt-get update && apt-get install -y \
    imagemagick \
    libmagickwand-dev \
    && docker-php-ext-install imagick

# Custom PHP config
COPY php.ini /usr/local/etc/php/conf.d/custom.ini

# Install Composer packages globally
RUN composer global require laravel/installer
```

### Multi-stage Build
```dockerfile
# docker/laravel-optimized/Dockerfile
FROM composer:latest AS composer
WORKDIR /app
COPY composer.json composer.lock ./
RUN composer install --no-dev --optimize-autoloader

FROM webdevops/php-apache:8.4
COPY --from=composer /app/vendor ./vendor
```

## 🔄 Development Workflow

### 1. Local Development
```bash
# Start development environment
docker-compose up -d

# Watch logs
docker-compose logs -f my-project

# Execute commands in container
docker exec -it my_project_app bash
docker exec -it my_project_app php artisan migrate
```

### 2. Code Sync
- **Volumes**: Real-time sync giữa host và container
- **Hot reload**: Thay đổi code tự động cập nhật
- **No rebuild**: Không cần rebuild container khi đổi code

### 3. Database Migrations
```bash
# Laravel migrations
docker exec -it my_project_app php artisan migrate

# WordPress setup
docker exec -it my_project_app wp core install \
  --url=http://localhost:8015 \
  --title="My Site" \
  --admin_user=admin \
  --admin_password=password \
  --admin_email=admin@example.com
```

## 🔧 Advanced Configuration

### Custom Networks
```yaml
# docker-compose.yml
networks:
  frontend:
    driver: bridge
  backend:
    driver: bridge
    internal: true

services:
  my-app:
    networks:
      - frontend
      - backend
```

### Health Checks
```yaml
services:
  my-app:
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost/health"]
      interval: 30s
      timeout: 10s
      retries: 3
      start_period: 40s
```

### Resource Limits
```yaml
services:
  my-app:
    deploy:
      resources:
        limits:
          cpus: '0.5'
          memory: 512M
        reservations:
          memory: 256M
```

## 📊 Monitoring & Logging

### Centralized Logging
```yaml
services:
  my-app:
    logging:
      driver: "json-file"
      options:
        max-size: "10m"
        max-file: "3"
```

### Performance Monitoring
```bash
# Container stats
docker stats

# Resource usage
docker exec my_project_app top

# PHP-FPM status
docker exec my_project_app curl localhost/fpm-status
```

## 🚀 Production Deployment

### Environment-specific Configs
```yaml
# docker-compose.prod.yml
services:
  my-app:
    environment:
      - APP_ENV=production
      - APP_DEBUG=false
    deploy:
      replicas: 3
      restart_policy:
        condition: on-failure
```

### Secrets Management
```yaml
services:
  my-app:
    secrets:
      - db_password
      - api_key

secrets:
  db_password:
    file: ./secrets/db_password.txt
```

## 🎯 Best Practices

### 1. Naming Convention
- **Platform names**: `kebab-case` (my-shop, user-management)
- **Container names**: `project_service` (my-shop_app)
- **Ports**: Sequential (8010, 8011, 8012...)

### 2. File Organization
```
my-project/
├── docker-compose.my-project.yml    # Platform config
├── .env                             # Environment variables
├── Dockerfile                       # Custom image (if needed)
└── README.md                        # Platform documentation
```

### 3. Version Control
```gitignore
# .gitignore
data/
logs/
.env
*.log
```

### 4. Documentation
Mỗi platform nên có README.md riêng với:
- Mô tả project
- Cách setup
- Environment variables
- API endpoints
- Troubleshooting

## 🔄 Platform Lifecycle

### Development → Staging → Production
```bash
# Development
docker-compose -f docker-compose.yml up -d

# Staging  
docker-compose -f docker-compose.yml -f docker-compose.staging.yml up -d

# Production
docker-compose -f docker-compose.yml -f docker-compose.prod.yml up -d
```

**Tiếp theo**: [04-DEBUG-SETUP.md](04-DEBUG-SETUP.md) để setup debugging
