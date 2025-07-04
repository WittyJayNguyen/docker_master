# 🐳 Docker Master Platform - Hướng Dẫn Đầy Đủ

## 📖 Mục Lục
1. [Giới Thiệu](#giới-thiệu)
2. [Cài Đặt Nhanh](#cài-đặt-nhanh)
3. [Cấu Trúc Thư Mục](#cấu-trúc-thư-mục)
4. [Quản Lý Platform](#quản-lý-platform)
5. [Tạo Dự Án Mới](#tạo-dự-án-mới)
6. [Tái Sử Dụng Template](#tái-sử-dụng-template)
7. [Troubleshooting](#troubleshooting)

---

## 🎯 Giới Thiệu

**Docker Master Platform** là hệ thống Docker Compose modular cho phép:
- ✅ Quản lý nhiều dự án web trong 1 môi trường
- ✅ Chia sẻ database, Redis, Email server
- ✅ Tạo dự án mới từ template trong vài giây
- ✅ Start/stop từng dự án độc lập
- ✅ Tái sử dụng cấu hình dễ dàng

**Hỗ trợ:** Laravel, WordPress, Vue.js, React, Node.js...

---

## ⚡ Cài Đặt Nhanh

### Bước 1: Setup môi trường
```bash
# Tạo network và thư mục cần thiết
./platform-manager.sh setup
```

### Bước 2: Khởi chạy
```bash
# Start tất cả services
./platform-manager.sh start

# Hoặc start từng phần
./platform-manager.sh start shared           # Database, Redis...
./platform-manager.sh start laravel-ecommerce # Laravel app
```

### Bước 3: Truy cập ứng dụng
- **Laravel E-commerce**: http://localhost:8006
- **phpMyAdmin**: http://localhost:8080
- **Mailhog**: http://localhost:8025

---

## 📁 Cấu Trúc Thư Mục

```
docker_master/
├── 🐳 docker-compose.yml          # File chính
├── 🔧 platform-manager.sh         # Quản lý platforms
├── ➕ create-platform.sh          # Tạo platform mới
│
├── 📦 platforms/                  # Các platforms
│   ├── shared/                   # Services chung (DB, Redis...)
│   ├── laravel-ecommerce/        # Laravel project
│   ├── wordpress/                # WordPress project
│   ├── vue/                      # Vue.js project
│   ├── templates/                # Templates tái sử dụng
│   └── base/                     # Base configurations
│
├── 💻 projects/                   # Source code
│   ├── laravel_ecommerce/
│   ├── wordpress/
│   └── vue_app/
│
├── 🐋 docker/                     # Dockerfiles
│   ├── php74/
│   ├── php84/
│   └── node/
│
├── 💾 data/                       # Database data
│   ├── mysql/
│   ├── postgres/
│   └── redis/
│
└── 📋 logs/                       # Application logs
    └── apache/
```

---

## 🎮 Quản Lý Platform

### Commands Cơ Bản

```bash
# 🚀 Khởi động
./platform-manager.sh start [platform_name]

# ⏹️ Dừng
./platform-manager.sh stop [platform_name]

# 🔄 Restart
./platform-manager.sh restart [platform_name]

# 📊 Xem trạng thái
./platform-manager.sh status

# 📝 Xem logs
./platform-manager.sh logs [platform_name]

# 🔨 Build lại
./platform-manager.sh build [platform_name]

# 📋 Liệt kê platforms
./platform-manager.sh list
```

### Ví Dụ Thực Tế

```bash
# Start chỉ Laravel project
./platform-manager.sh start laravel-ecommerce

# Xem logs WordPress
./platform-manager.sh logs wordpress

# Restart tất cả
./platform-manager.sh restart

# Kiểm tra trạng thái
./platform-manager.sh status
```

### Kết Quả Status
```
🟢 shared: Running (6/6 containers)
🟢 laravel-ecommerce: Running (3/3 containers)
🔴 wordpress: Stopped
🔴 vue: Stopped
```

---

## 🆕 Tạo Dự Án Mới

### ⚡ Cách 1: Auto-Discovery (Khuyến nghị)

**Chỉ cần 1 lệnh - Platform tự động được phát hiện!**

```bash
# Syntax: ./create-platform.sh <type> <name> <port>

# Tạo Laravel project
./create-platform.sh laravel my-shop 8008

# Tạo WordPress site
./create-platform.sh wordpress my-blog 8009

# Tạo Vue.js app
./create-platform.sh vue my-frontend 8010
```

**✨ Điều kỳ diệu xảy ra:**
- ✅ Tự động tạo thư mục `platforms/my-shop/`
- ✅ Tự động tạo docker-compose file từ template
- ✅ Tự động thêm vào main docker-compose.yml
- ✅ Tự động được phát hiện bởi platform-manager.sh
- ✅ Sẵn sàng chạy ngay: `./platform-manager.sh start my-shop`

### 🔧 Cách 2: Thủ công (Vẫn Auto-Discovery)

**Chỉ cần tạo thư mục + file, không cần config thêm!**

1. **Tạo thư mục platform**
```bash
mkdir platforms/my-new-project
```

2. **Copy template**
```bash
cp platforms/templates/laravel.template.yml \
   platforms/my-new-project/docker-compose.my-new-project.yml
```

3. **Chỉnh sửa cấu hình**
```yaml
# Thay đổi tên project, port, volumes...
services:
  my-new-project:
    ports: ["8011:80"]
    volumes: ["../../projects/my-new-project:/app/my-new-project"]
```

4. **✨ Tự động phát hiện - Không cần thêm vào docker-compose.yml!**
```bash
# Platform sẽ tự động xuất hiện trong danh sách
./platform-manager.sh list
```

5. **Khởi chạy**
```bash
./platform-manager.sh start my-new-project
```

### 🔄 Sync tất cả platforms (Optional)
```bash
# Nếu muốn rebuild main docker-compose.yml
./sync-platforms.sh
```

---

## 🔄 Tái Sử Dụng Template

### Phương Pháp 1: Extends (Kế thừa)

**Base Template** (`platforms/base/docker-compose.base.yml`):
```yaml
services:
  php-app:
    build: ../../docker/php84
    environment:
      - DB_HOST=mysql_server
      - REDIS_HOST=redis_server
    networks: [app-network]
```

**Sử dụng**:
```yaml
services:
  my-app:
    extends:
      file: ../base/docker-compose.base.yml
      service: php-app
    ports: ["8008:80"]
    volumes: ["./app:/app"]
```

### Phương Pháp 2: YAML Anchors

```yaml
# Định nghĩa template
x-php-base: &php-base
  build: ../../docker/php84
  environment: &php-env
    - DB_HOST=mysql_server
    - REDIS_HOST=redis_server

services:
  # Tái sử dụng cho nhiều services
  app1:
    <<: *php-base
    ports: ["8008:80"]
  
  app2:
    <<: *php-base
    ports: ["8009:80"]
```

### Phương Pháp 3: Environment Variables

**.env file**:
```bash
PROJECT_NAME=my-shop
PROJECT_PORT=8008
PHP_VERSION=8.4
APP_PATH=../../projects/my-shop
```

**docker-compose.yml**:
```yaml
services:
  ${PROJECT_NAME}:
    container_name: ${PROJECT_NAME}_php84
    ports: ["${PROJECT_PORT}:80"]
    volumes: ["${APP_PATH}:/app/${PROJECT_NAME}"]
```

---

## 🌐 Services & Ports

### Shared Services (Luôn Chạy)
| Service | Port | URL | Mô tả |
|---------|------|-----|-------|
| MySQL | 3306 | - | Database chính |
| PostgreSQL | 5432 | - | Database phụ |
| Redis | 6379 | - | Cache & Sessions |
| phpMyAdmin | 8080 | http://localhost:8080 | MySQL GUI |
| pgAdmin | 8081 | http://localhost:8081 | PostgreSQL GUI |
| Mailhog | 8025 | http://localhost:8025 | Email testing |

### Application Ports
| Project | Port | URL | Framework |
|---------|------|-----|-----------|
| Laravel E-commerce | 8006 | http://localhost:8006 | Laravel + PHP 8.4 |
| WordPress | 8001 | http://localhost:8001 | WordPress + PHP 7.4 |
| Vue.js | 8002 | http://localhost:8002 | Vue.js + Node.js |

---

## 🗄️ Database Management

### MySQL
```bash
# Truy cập MySQL CLI
docker exec -it mysql_server mysql -u root -prootpassword123

# Tạo database mới
docker exec -it mysql_server mysql -u root -prootpassword123 \
  -e "CREATE DATABASE my_new_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"

# Import SQL file
docker exec -i mysql_server mysql -u root -prootpassword123 my_db < backup.sql

# Backup database
docker exec mysql_server mysqldump -u root -prootpassword123 my_db > backup.sql
```

### PostgreSQL
```bash
# Truy cập PostgreSQL CLI
docker exec -it postgres_server psql -U postgres

# Tạo database mới
docker exec -it postgres_server createdb -U postgres my_new_db

# Import SQL file
docker exec -i postgres_server psql -U postgres my_db < backup.sql

# Backup database
docker exec postgres_server pg_dump -U postgres my_db > backup.sql
```

---

## 🐛 Troubleshooting

### Lỗi Thường Gặp

#### 1. Container name conflicts
```bash
# Dừng tất cả containers
docker stop $(docker ps -aq)
docker rm $(docker ps -aq)

# Restart platform
./platform-manager.sh start
```

#### 2. Port đã được sử dụng
```bash
# Kiểm tra port
lsof -i :8006

# Kill process sử dụng port
kill -9 $(lsof -t -i:8006)

# Hoặc thay đổi port trong docker-compose
```

#### 3. Database connection failed
```bash
# Kiểm tra MySQL logs
docker logs mysql_server

# Restart shared services
./platform-manager.sh restart shared

# Test connection
docker exec mysql_server mysql -u root -prootpassword123 -e "SHOW DATABASES;"
```

#### 4. Permission denied
```bash
# Fix quyền scripts
chmod +x platform-manager.sh create-platform.sh

# Fix quyền thư mục
sudo chown -R $USER:$USER projects/ data/ logs/
```

#### 5. Laravel migration errors
```bash
# Vào container Laravel
docker exec -it laravel_ecommerce_php84 bash

# Chạy migrations
cd /app/laravel_ecommerce
php artisan migrate:fresh --seed
```

### Debug Commands

```bash
# Xem logs chi tiết
./platform-manager.sh logs laravel-ecommerce

# Kiểm tra containers
docker ps -a

# Kiểm tra networks
docker network ls

# Kiểm tra volumes
docker volume ls

# Kiểm tra images
docker images

# Clean up
docker system prune -a
```

---

## 💡 Tips & Best Practices

### 1. Naming Convention
- **Platform names**: `kebab-case` (my-shop, user-management)
- **Container names**: `project_service` (my-shop_php84)
- **Ports**: Sequential (8006, 8007, 8008...)

### 2. Environment Management
```bash
# Development
cp .env.example .env.dev

# Production  
cp .env.example .env.prod

# Load specific env
docker-compose --env-file .env.prod up
```

### 3. Backup Strategy
```bash
# Script backup tự động
#!/bin/bash
DATE=$(date +%Y%m%d_%H%M%S)

# Backup MySQL
docker exec mysql_server mysqldump -u root -prootpassword123 --all-databases > "backup_mysql_$DATE.sql"

# Backup PostgreSQL
docker exec postgres_server pg_dumpall -U postgres > "backup_postgres_$DATE.sql"

# Backup project files
tar -czf "backup_projects_$DATE.tar.gz" projects/
```

### 4. Performance Optimization
```yaml
# Trong docker-compose.yml
services:
  app:
    deploy:
      resources:
        limits:
          memory: 512M
          cpus: '0.5'
    restart: unless-stopped
```

---

## 🔐 Security Notes

1. **Thay đổi default passwords**
```bash
# Trong .env
MYSQL_ROOT_PASSWORD=your_secure_password
POSTGRES_PASSWORD=your_secure_password
```

2. **Sử dụng Docker secrets**
```yaml
secrets:
  db_password:
    file: ./secrets/db_password.txt

services:
  app:
    secrets:
      - db_password
```

3. **Network isolation**
```yaml
networks:
  frontend:
    driver: bridge
  backend:
    driver: bridge
    internal: true  # Không có internet access
```

---

## 📞 Hỗ Trợ

### Khi gặp vấn đề:
1. 📋 Kiểm tra logs: `./platform-manager.sh logs`
2. 🔄 Restart services: `./platform-manager.sh restart`
3. 📖 Đọc documentation này
4. 🐛 Tạo issue với thông tin chi tiết

### Thông tin hữu ích khi báo lỗi:
```bash
# System info
docker version
docker-compose version

# Platform status
./platform-manager.sh status

# Container logs
./platform-manager.sh logs [platform]

# System resources
docker stats
```

---

**🎉 Chúc bạn coding vui vẻ với Docker Master Platform!**

*Tài liệu này được cập nhật thường xuyên. Hãy kiểm tra phiên bản mới nhất.*
