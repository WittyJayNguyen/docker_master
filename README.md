# 🐳 Docker Master Platform

## 🚀 Multi-Framework Development Environment

**Hệ thống Docker modular với auto-discovery cho Laravel, WordPress và nhiều framework khác.**

### ✨ Tính Năng Chính

- 🔍 **Auto-Discovery Platforms** - Tự động phát hiện platforms mà không cần config thủ công
- 🏗️ **Kiến Trúc Modular** - Mỗi platform độc lập, dễ quản lý
- 🔗 **Shared Services** - Database, Redis, Mail server được chia sẻ
- ⚡ **Quick Setup** - Khởi chạy toàn bộ môi trường trong vài phút
- 🎮 **Platform Manager** - Script quản lý platforms tự động
- 📋 **Templates** - Tạo platforms mới từ templates có sẵn

### 🎯 Example Platforms (Sẵn Sàng Sử Dụng)

| Platform | Port | Framework | Database | Status |
|----------|------|-----------|----------|--------|
| Laravel PHP 8.4 | 8010 | Laravel + PHP 8.4 | PostgreSQL | ✅ Running |
| Laravel PHP 7.4 | 8011 | Laravel + PHP 7.4 | PostgreSQL | ✅ Running |
| WordPress | 8012 | WordPress + PHP 7.4 | MySQL | ✅ Running |

### 🔗 Shared Services

| Service | Port | URL | Mô tả |
|---------|------|-----|-------|
| MySQL | 3306 | - | Database cho WordPress |
| PostgreSQL | 5432 | - | Database cho Laravel |
| Redis | 6379 | - | Cache & Sessions |
| phpMyAdmin | 8080 | http://localhost:8080 | MySQL GUI |
| pgAdmin | 8081 | http://localhost:8081 | PostgreSQL GUI |
| Mailhog | 8025 | http://localhost:8025 | Email testing |

## 🚀 Quick Start

### 1. Setup Môi Trường
```bash
# Clone repository
git clone <repository-url>
cd docker_master

# Setup environment
./platform-manager.sh setup

# Start all platforms
./platform-manager.sh start
```

### 2. Truy Cập Ứng Dụng
- **Laravel PHP 8.4:** http://localhost:8010 (PHP 8.4 features demo)
- **Laravel PHP 7.4:** http://localhost:8011 (PHP 7.4 features demo)
- **WordPress:** http://localhost:8012 (WordPress demo)
- **phpMyAdmin:** http://localhost:8080 (MySQL management)
- **pgAdmin:** http://localhost:8081 (PostgreSQL management)
- **Mailhog:** http://localhost:8025 (Email testing)

### 3. Quản Lý Platforms
```bash
# Xem danh sách platforms
./platform-manager.sh list

# Start platform cụ thể
./platform-manager.sh start laravel-php84-psql

# Stop platform
./platform-manager.sh stop laravel-php84-psql

# Xem status
./platform-manager.sh status

# Xem logs
./platform-manager.sh logs laravel-php84-psql
```

## 🆕 Tạo Platform Mới

### Sử Dụng Script (Khuyến nghị)
```bash
# Tạo Laravel project
./create-platform.sh laravel my-shop 8015

# Tạo WordPress site
./create-platform.sh wordpress my-blog 8016

# Tạo Vue.js app
./create-platform.sh vue my-frontend 8017

# Platform tự động được phát hiện!
./platform-manager.sh list
./platform-manager.sh start my-shop
```

### Thủ Công
```bash
# 1. Tạo thư mục
mkdir platforms/my-project

# 2. Copy template
cp platforms/templates/laravel.template.yml \
   platforms/my-project/docker-compose.my-project.yml

# 3. Chỉnh sửa cấu hình
# 4. Platform tự động được phát hiện!
```

## 📁 Cấu Trúc Project

```
docker_master/
├── 🐳 docker-compose.yml              # Main orchestration
├── 🔧 platform-manager.sh             # Platform management
├── ➕ create-platform.sh              # Create new platforms
├── 🔄 sync-platforms.sh               # Sync platforms
│
├── 📦 platforms/                      # Platform configs
│   ├── shared/                       # Shared services
│   ├── laravel-php84-psql/           # Laravel PHP 8.4 + PostgreSQL
│   ├── laravel-php74-psql/           # Laravel PHP 7.4 + PostgreSQL
│   ├── wordpress-php74-mysql/        # WordPress PHP 7.4 + MySQL
│   ├── templates/                    # Reusable templates
│   └── base/                         # Base configurations
│
├── 💻 projects/                       # Source code
│   ├── laravel-php84-psql/           # Laravel PHP 8.4 demo
│   ├── laravel-php74-psql/           # Laravel PHP 7.4 demo
│   └── wordpress-php74-mysql/        # WordPress demo
├── 🐋 docker/                         # Dockerfiles
├── 💾 data/                          # Persistent data
└── 📋 logs/                          # Application logs
```

## 🔄 Docker Compose Reusability

### 1. Include Pattern (Hiện tại)
```yaml
include:
  - ./platforms/shared/docker-compose.shared.yml
  - ./platforms/laravel-php84-psql/docker-compose.laravel-php84-psql.yml
  - ./platforms/laravel-php74-psql/docker-compose.laravel-php74-psql.yml
  - ./platforms/wordpress-php74-mysql/docker-compose.wordpress-php74-mysql.yml
```

### 2. Extends Pattern
```yaml
services:
  my-app:
    extends:
      file: ./platforms/base/docker-compose.base.yml
      service: php-base
```

### 3. YAML Anchors
```yaml
x-php-base: &php-base
  build: ./docker/php84
  environment: &php-env
    - DB_HOST=postgres_server

services:
  app1:
    <<: *php-base
  app2:
    <<: *php-base
```

### 4. Environment Variables
```yaml
services:
  app:
    image: php:${PHP_VERSION:-8.4}
    ports:
      - "${APP_PORT:-8000}:80"
```

## 🗄️ Database Management

### PostgreSQL (Laravel Examples)
```bash
# Access PostgreSQL CLI
docker exec -it postgres_server psql -U postgres_user

# Create new database
docker exec -it postgres_server createdb -U postgres_user my_new_db

# List databases
docker exec -it postgres_server psql -U postgres_user -c "\l"
```

### MySQL (WordPress)
```bash
# Access MySQL CLI
docker exec -it mysql_server mysql -u mysql_user -pmysql_pass

# Create new database
docker exec -it mysql_server mysql -u mysql_user -pmysql_pass \
  -e "CREATE DATABASE my_new_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"

# Show databases
docker exec -it mysql_server mysql -u mysql_user -pmysql_pass -e "SHOW DATABASES;"
```

## 🎮 Platform Manager Commands

```bash
# Setup & Management
./platform-manager.sh setup          # Setup environment
./platform-manager.sh list           # List all platforms
./platform-manager.sh start [name]   # Start platform(s)
./platform-manager.sh stop [name]    # Stop platform(s)
./platform-manager.sh restart [name] # Restart platform(s)
./platform-manager.sh status         # Show status
./platform-manager.sh logs [name]    # View logs
./platform-manager.sh build [name]   # Build images

# Platform Creation
./create-platform.sh <type> <name> <port>

# Sync & Demo
./sync-platforms.sh                  # Sync all platforms
./demo-auto-discovery.sh             # Demo auto-discovery
```

## 🔧 Environment Variables

### Global (.env)
```bash
# Database Credentials
MYSQL_ROOT_PASSWORD=mysql_pass
MYSQL_USER=mysql_user
MYSQL_PASSWORD=mysql_pass

POSTGRES_USER=postgres_user
POSTGRES_PASSWORD=postgres_pass

# Redis
REDIS_PASSWORD=redis_pass

# Mail
MAIL_HOST=mailhog
MAIL_PORT=1025
```

### Platform-specific
```bash
# platforms/my-project/.env
PROJECT_NAME=my-project
PROJECT_PORT=8015
PHP_VERSION=8.4
APP_PATH=../../projects/my-project
```

## 🐛 Troubleshooting

### Network Issues
```bash
# Recreate network
docker network rm docker_master_network
./platform-manager.sh setup
```

### Permission Issues
```bash
# Fix script permissions
chmod +x platform-manager.sh create-platform.sh

# Fix data permissions
sudo chown -R $USER:$USER data/ logs/
```

### Container Conflicts
```bash
# Clean up and restart
./platform-manager.sh stop
docker system prune -f
./platform-manager.sh start
```

### Database Connection Issues
```bash
# Check database status
./platform-manager.sh status shared

# Recreate databases
docker exec -it postgres_server psql -U postgres_user -c "DROP DATABASE IF EXISTS laravel_php84_psql; CREATE DATABASE laravel_php84_psql;"
```

## 📚 Documentation

- **[Examples Guide](EXAMPLES_README.md)** - Chi tiết về 3 example platforms
- **[Platforms Guide](platforms/README.md)** - Chi tiết về platform management
- **[Templates Guide](platforms/templates/README.md)** - Hướng dẫn templates
- **[Reusability Patterns](REUSABILITY_PATTERNS.md)** - Docker Compose patterns
- **[Auto-Discovery Demo](demo-auto-discovery.sh)** - Demo tính năng auto-discovery

## 🎯 Best Practices

### 1. Naming Convention
- Platform names: `kebab-case` (my-shop, user-management)
- Container names: `project_service` (my-shop_php84)
- Ports: Sequential (8010, 8011, 8012...)

### 2. Development Workflow
```bash
# 1. Create platform
./create-platform.sh laravel my-project 8020

# 2. Add source code
# Copy your code to projects/my-project/

# 3. Start platform
./platform-manager.sh start my-project

# 4. Access application
# http://localhost:8020
```

### 3. Backup Strategy
```bash
# Backup databases
docker exec mysql_server mysqldump -u mysql_user -pmysql_pass --all-databases > backup_mysql.sql
docker exec postgres_server pg_dumpall -U postgres_user > backup_postgres.sql

# Backup projects
tar -czf backup_projects.tar.gz projects/
```

## 🚀 Advanced Features

### Auto-Discovery System
- Tự động scan thư mục `platforms/`
- Phát hiện file `docker-compose.*.yml`
- Không cần config thủ công
- Thêm platform chỉ bằng cách tạo thư mục

### Template System
- Templates cho Laravel, WordPress, Vue.js
- Variable substitution
- Customizable configurations
- Quick platform creation

### Modular Architecture
- Mỗi platform độc lập
- Shared services tối ưu
- Easy scaling
- Clean separation

### Multi-PHP Support
- PHP 7.4 cho legacy projects
- PHP 8.4 cho modern development
- Isolated environments
- Version-specific features demo

## 🎯 What's Included

### Example Demonstrations
- **Laravel PHP 8.4**: Enums, Match expressions, modern features
- **Laravel PHP 7.4**: Arrow functions, Typed properties, legacy support
- **WordPress**: WordPress-style tables, MySQL optimization

### Database Examples
- **PostgreSQL**: Laravel projects với products tables
- **MySQL**: WordPress với wp_posts, wp_users tables
- **Redis**: Caching và session storage

### Development Tools
- **phpMyAdmin**: MySQL database management
- **pgAdmin**: PostgreSQL database management
- **Mailhog**: Email testing và debugging

## 🤝 Contributing

1. Fork the repository
2. Create feature branch (`git checkout -b feature/amazing-feature`)
3. Commit changes (`git commit -m 'Add amazing feature'`)
4. Push to branch (`git push origin feature/amazing-feature`)
5. Open Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 🎉 Quick Commands Cheat Sheet

```bash
# Complete setup
./platform-manager.sh setup && ./platform-manager.sh start

# Create new platform
./create-platform.sh laravel my-project 8020

# Management
./platform-manager.sh list
./platform-manager.sh status
./platform-manager.sh logs [platform]
./platform-manager.sh restart [platform]

# Access examples
curl http://localhost:8010  # Laravel PHP 8.4
curl http://localhost:8011  # Laravel PHP 7.4
curl http://localhost:8012  # WordPress

# Demo
./demo-auto-discovery.sh
```

**🐳 Happy coding with Docker Master Platform!**
```
