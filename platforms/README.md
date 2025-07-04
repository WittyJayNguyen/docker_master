# 🐳 Docker Master Platform - Hướng Dẫn Platforms

## 🏗️ Kiến Trúc Modular với Auto-Discovery

**Hệ thống tự động phát hiện platforms - Không cần config thủ công!**

### 📁 Cấu Trúc Thư Mục

```
docker_master/
├── 🐳 docker-compose.yml              # Main orchestration file
├── 🔧 platform-manager.sh             # Platform management script (auto-discovery)
├── ➕ create-platform.sh              # Create new platforms from templates
├── 🔄 sync-platforms.sh               # Sync all platforms to main compose
│
├── 📦 platforms/                      # Platform configurations (auto-scanned)
│   ├── shared/                       # 🔗 Shared services (DB, Redis, etc.)
│   │   └── docker-compose.shared.yml
│   ├── laravel-php84-psql/           # � Laravel PHP 8.4 + PostgreSQL
│   │   └── docker-compose.laravel-php84-psql.yml
│   ├── laravel-php74-psql/           # 🔧 Laravel PHP 7.4 + PostgreSQL
│   │   └── docker-compose.laravel-php74-psql.yml
│   ├── wordpress-php74-mysql/        # 📝 WordPress PHP 7.4 + MySQL
│   │   └── docker-compose.wordpress-php74-mysql.yml
│   ├── templates/                    # 📋 Reusable templates
│   │   ├── laravel.template.yml
│   │   ├── wordpress.template.yml
│   │   └── vue.template.yml
│   └── base/                         # 🏗️ Base configurations
│       └── docker-compose.base.yml
│
├── 💻 projects/                       # Source code directories
│   ├── laravel-php84-psql/           # Laravel PHP 8.4 demo project
│   ├── laravel-php74-psql/           # Laravel PHP 7.4 demo project
│   └── wordpress-php74-mysql/        # WordPress demo project
├── 🐋 docker/                         # Dockerfiles (PHP 7.4, 8.4, Node.js)
├── 💾 data/                          # Persistent data (MySQL, PostgreSQL, Redis)
└── 📋 logs/                          # Application logs
```

## ⚡ Quick Start

### 🚀 Setup & Khởi Chạy
```bash
# 1. Setup môi trường (tạo network, directories)
./platform-manager.sh setup

# 2. Khởi động tất cả platforms
./platform-manager.sh start

# 3. Truy cập ứng dụng
# Laravel PHP 8.4: http://localhost:8010
# Laravel PHP 7.4: http://localhost:8011
# WordPress: http://localhost:8012
# phpMyAdmin: http://localhost:8080
# pgAdmin: http://localhost:8081
# Mailhog: http://localhost:8025
```

## 🎮 Platform Manager Commands

### 📋 Xem Danh Sách Platforms (Auto-Discovery)
```bash
# Xem tất cả platforms được tự động phát hiện
./platform-manager.sh list

# Output:
# 📋 Available Platforms (auto-discovered):
#   ✓ shared (docker-compose.shared.yml)
#   ✓ laravel-php84-psql (docker-compose.laravel-php84-psql.yml)
#   ✓ laravel-php74-psql (docker-compose.laravel-php74-psql.yml)
#   ✓ wordpress-php74-mysql (docker-compose.wordpress-php74-mysql.yml)
```

### 🚀 Khởi Động Platforms
```bash
# Khởi động tất cả
./platform-manager.sh start

# Khởi động chỉ shared services (database, redis, etc.)
./platform-manager.sh start shared

# Khởi động platform cụ thể
./platform-manager.sh start laravel-php84-psql
./platform-manager.sh start laravel-php74-psql
./platform-manager.sh start wordpress-php74-mysql
```

### ⏹️ Dừng Platforms
```bash
# Dừng tất cả
./platform-manager.sh stop

# Dừng platform cụ thể
./platform-manager.sh stop laravel-php84-psql
./platform-manager.sh stop laravel-php74-psql
./platform-manager.sh stop wordpress-php74-mysql
```

### 🔄 Restart Platforms
```bash
# Restart tất cả
./platform-manager.sh restart

# Restart platform cụ thể
./platform-manager.sh restart laravel-php84-psql
./platform-manager.sh restart shared
```

### 📊 Status & Monitoring
```bash
# Xem status tất cả platforms
./platform-manager.sh status

# Output:
# 🟢 shared: Running (6/6 containers)
# 🟢 laravel-php84-psql: Running (3/3 containers)
# 🟢 laravel-php74-psql: Running (3/3 containers)
# � wordpress-php74-mysql: Running (1/1 containers)
```

### 📝 Logs
```bash
# Xem logs của platform cụ thể
./platform-manager.sh logs laravel-php84-psql
./platform-manager.sh logs laravel-php74-psql
./platform-manager.sh logs wordpress-php74-mysql
./platform-manager.sh logs shared

# Xem logs tất cả
./platform-manager.sh logs
```

### 🔨 Build & Rebuild
```bash
# Build tất cả images
./platform-manager.sh build

# Build platform cụ thể
./platform-manager.sh build laravel-php84-psql
./platform-manager.sh build laravel-php74-psql
```

## 🆕 Tạo Platform Mới - Auto-Discovery

### ⚡ Cách 1: Sử Dụng Script (Khuyến nghị)
```bash
# Tạo Laravel project
./create-platform.sh laravel my-shop 8015

# Tạo WordPress site
./create-platform.sh wordpress my-blog 8016

# Tạo Vue.js app
./create-platform.sh vue my-frontend 8017

# ✨ Platform tự động được phát hiện và sẵn sàng sử dụng!
./platform-manager.sh list    # ← Sẽ thấy platform mới
./platform-manager.sh start my-shop  # ← Khởi chạy ngay
```

### 🔧 Cách 2: Thủ Công
```bash
# 1. Tạo thư mục
mkdir platforms/my-custom-project

# 2. Copy template
cp platforms/templates/laravel.template.yml \
   platforms/my-custom-project/docker-compose.my-custom-project.yml

# 3. Chỉnh sửa cấu hình (thay {{PROJECT_NAME}}, {{PORT}})

# 4. Platform tự động được phát hiện!
./platform-manager.sh list  # ← Xuất hiện ngay
```

## ✨ Ưu Điểm Kiến Trúc Modular + Auto-Discovery

### 1. **🔍 Auto-Discovery**
- Tự động phát hiện platforms từ thư mục `platforms/`
- Không cần thêm vào array hoặc config thủ công
- Chỉ cần tạo thư mục + file docker-compose

### 2. **🎯 Tách Biệt Rõ Ràng**
- Mỗi platform có file config riêng
- Enable/disable từng platform độc lập
- Không ảnh hưởng lẫn nhau

### 3. **🔗 Shared Services**
- Database, Redis, Mail server được chia sẻ
- Tiết kiệm tài nguyên hệ thống
- Cấu hình tập trung, dễ quản lý

### 4. **📈 Dễ Mở Rộng**
- Thêm platform mới trong vài giây
- Templates sẵn có cho Laravel, WordPress, Vue.js
- Không cần sửa file chính

### 5. **🎮 Quản Lý Linh Hoạt**
- Script tự động hóa mọi tác vụ
- Chạy từng platform riêng lẻ
- Logs và monitoring chi tiết

## 🌐 Services & Port Mapping

### 🔗 Shared Services (Luôn Chạy)
| Service | Port | URL | Mô tả |
|---------|------|-----|-------|
| MySQL | 3306 | - | Database cho WordPress |
| PostgreSQL | 5432 | - | Database cho Laravel |
| Redis | 6379 | - | Cache & Sessions |
| phpMyAdmin | 8080 | http://localhost:8080 | MySQL GUI |
| pgAdmin | 8081 | http://localhost:8081 | PostgreSQL GUI |
| Mailhog SMTP | 1025 | - | Email SMTP |
| Mailhog Web | 8025 | http://localhost:8025 | Email testing UI |

### 🚀 Application Platforms (Examples)
| Platform | Port | URL | Framework | Database |
|----------|------|-----|-----------|----------|
| Laravel PHP 8.4 | 8010 | http://localhost:8010 | Laravel + PHP 8.4 | PostgreSQL |
| Laravel PHP 7.4 | 8011 | http://localhost:8011 | Laravel + PHP 7.4 | PostgreSQL |
| WordPress | 8012 | http://localhost:8012 | WordPress + PHP 7.4 | MySQL |

## 🔄 Tái Sử Dụng & Templates

### 📋 Available Templates
- **`laravel.template.yml`** - Laravel với PHP 8.4, Queue, Scheduler
- **`wordpress.template.yml`** - WordPress với PHP 7.4
- **`vue.template.yml`** - Vue.js với Node.js, hot reload

### 🔧 Customization
```bash
# Sử dụng environment variables
PROJECT_NAME=my-shop
PROJECT_PORT=8015
PHP_VERSION=8.4

# Hoặc YAML anchors cho reusability
x-php-base: &php-base
  build: ../../docker/php84
  environment: &php-env
    - DB_HOST=mysql_server
```

## 🗄️ Database Management

### MySQL
```bash
# Truy cập MySQL CLI
docker exec -it mysql_server mysql -u root -prootpassword123

# Tạo database mới
docker exec -it mysql_server mysql -u root -prootpassword123 \
  -e "CREATE DATABASE my_new_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"

# Backup database
docker exec mysql_server mysqldump -u root -prootpassword123 my_db > backup.sql
```

### PostgreSQL
```bash
# Truy cập PostgreSQL CLI
docker exec -it postgres_server psql -U postgres

# Tạo database mới
docker exec -it postgres_server createdb -U postgres my_new_db
```

## 🔧 Environment Variables

```bash
# Mỗi platform có thể có file .env riêng
platforms/my-project/.env:
PROJECT_NAME=my-project
PROJECT_PORT=8015
PHP_VERSION=8.4
APP_PATH=../../projects/my-project
```

## 🐛 Troubleshooting

### 🌐 Network Issues
```bash
# Tạo lại network
docker network rm docker_master_network
./platform-manager.sh setup
```

### 🔐 Permission Issues
```bash
# Fix permissions cho scripts
chmod +x platform-manager.sh create-platform.sh

# Fix permissions cho data
sudo chown -R $USER:$USER data/ logs/
```

### 🔄 Container Conflicts
```bash
# Stop tất cả và cleanup
./platform-manager.sh stop
docker system prune -f
./platform-manager.sh start
```

### 🚀 Laravel Issues
```bash
# Vào container Laravel
docker exec -it laravel_ecommerce_php84 bash

# Chạy migrations
cd /app/laravel_ecommerce
php artisan migrate:fresh --seed
```

## 🎯 Best Practices

### 1. **Naming Convention**
- Platform names: `kebab-case` (my-shop, user-management)
- Container names: `project_service` (my-shop_php84)
- Ports: Sequential (8006, 8007, 8008...)

### 2. **Development Workflow**
```bash
# 1. Tạo platform mới
./create-platform.sh laravel my-project 8020

# 2. Add source code
# Copy your Laravel code to projects/my-project/

# 3. Start platform
./platform-manager.sh start my-project

# 4. Access application
# http://localhost:8020
```

### 3. **Backup Strategy**
```bash
# Backup script
#!/bin/bash
DATE=$(date +%Y%m%d_%H%M%S)

# Backup databases
docker exec mysql_server mysqldump -u root -prootpassword123 --all-databases > "backup_mysql_$DATE.sql"
docker exec postgres_server pg_dumpall -U postgres > "backup_postgres_$DATE.sql"

# Backup projects
tar -czf "backup_projects_$DATE.tar.gz" projects/
```

---

## 🚀 Quick Commands Cheat Sheet

```bash
# Setup & Start
./platform-manager.sh setup && ./platform-manager.sh start

# Create new platform
./create-platform.sh laravel my-project 8020

# List all platforms
./platform-manager.sh list

# Check status
./platform-manager.sh status

# View logs
./platform-manager.sh logs [platform-name]

# Restart specific platform
./platform-manager.sh restart [platform-name]

# Sync all platforms
./sync-platforms.sh

# Demo auto-discovery
./demo-auto-discovery.sh
```

**🎉 Happy coding with Docker Master Platform!**
