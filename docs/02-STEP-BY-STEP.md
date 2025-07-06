# 📖 Hướng dẫn từng bước chi tiết - Auto Platform Creation

> **Mục tiêu**: Hiểu rõ cách tạo platforms tự động với AI detection và dual database

## 📋 Tổng quan hệ thống mới

**Docker Master Platform** là hệ thống tạo platforms tự động với:
- **🤖 AI Auto-Detection**: Tự động nhận diện loại project và chọn database phù hợp
- **🗄️ Dual Database**: MySQL và PostgreSQL hoạt động song song
- **🐛 Full Xdebug**: Debug support cho PHP 7.4 và 8.4
- **⚡ Auto Platform Creation**: Tạo platform chỉ với 1 lệnh
- **🔧 Smart Configuration**: Tự động cấu hình port, database, PHP version

## 🏗️ Cấu trúc dự án mới

```
docker_master/
├── 📁 platforms/              # Auto-generated platforms
│   ├── wp-blog-example/       # WordPress PHP 7.4 + MySQL
│   ├── laravel74-api-example/ # Laravel PHP 7.4 + PostgreSQL
│   └── laravel84-shop-example/# Laravel PHP 8.4 + MySQL
├── 📁 scripts/                # Auto-creation scripts
│   ├── auto-platform.bat     # Core auto-creation logic
│   ├── examples-summary.bat   # Examples overview
│   └── *.bat                  # Management scripts
├── 📁 docs/                   # Documentation
├── docker-compose.low-ram.yml # Core services (MySQL, PostgreSQL, Redis)
├── create.bat                 # Main creation command
└── EXAMPLES-GUIDE.md          # Complete examples guide
```

## 🔧 Bước 1: Khởi động Core Services

### 1.1 Kiểm tra Docker
```bash
# Kiểm tra Docker
docker --version
docker-compose --version

# Kiểm tra Docker đang chạy
docker ps
```

### 1.2 Khởi động Database Services
```bash
# Khởi động MySQL, PostgreSQL, Redis
docker-compose -f docker-compose.low-ram.yml up -d

# Kiểm tra trạng thái
docker ps
```

**Core Services được khởi động:**
- **MySQL 8.0**: Port 3306 (256MB RAM)
- **PostgreSQL 15.13**: Port 5432 (128MB RAM)
- **Redis**: Port 6379 (32MB RAM)
- **Mailhog**: Port 8025 (32MB RAM)

## 🚀 Bước 2: Tạo Platform Tự Động

### 2.1 Lệnh Tạo Platform Cơ Bản
```bash
# Cú pháp cơ bản
create.bat [tên-project]

# Ví dụ
create.bat my-blog
create.bat user-api
create.bat online-shop
```

### 2.2 🤖 AI Auto-Detection Rules

**AI sẽ tự động nhận diện và chọn:**
- **Database**: MySQL hoặc PostgreSQL
- **PHP Version**: 7.4 hoặc 8.4
- **Platform Type**: WordPress, Laravel API, hoặc E-commerce

#### 📝 MySQL Projects (Tự động chọn MySQL):
```bash
# E-commerce keywords
create.bat my-shop           → MySQL + Laravel 8.4
create.bat food-delivery     → MySQL + Laravel 8.4
create.bat online-store      → MySQL + Laravel 8.4
create.bat book-shop         → MySQL + Laravel 8.4

# WordPress/CMS keywords
create.bat my-blog           → MySQL + WordPress PHP 7.4
create.bat company-website   → MySQL + WordPress PHP 7.4
create.bat news-portal       → MySQL + WordPress PHP 7.4
create.bat portfolio-site    → MySQL + WordPress PHP 7.4
```

#### 🚀 PostgreSQL Projects (Tự động chọn PostgreSQL):
```bash
# API/Service keywords
create.bat user-api          → PostgreSQL + Laravel 8.4
create.bat payment-service   → PostgreSQL + Laravel 8.4
create.bat notification-api  → PostgreSQL + Laravel 8.4
create.bat inventory-service → PostgreSQL + Laravel 8.4

# Default Laravel projects
create.bat my-app            → PostgreSQL + Laravel 8.4
create.bat web-application   → PostgreSQL + Laravel 8.4
```

## � Bước 3: Cách Chọn PHP Version

### 3.1 🔧 PHP Version Rules

**Mặc định:**
- **WordPress**: Luôn dùng PHP 7.4 (tương thích tốt nhất)
- **Laravel**: Mặc định PHP 8.4 (hiệu suất cao)

**Force PHP 7.4:**
```bash
# Thêm "laravel74" vào tên project
create.bat laravel74-user-api     → PHP 7.4 + PostgreSQL
create.bat laravel74-shop-system  → PHP 7.4 + MySQL
create.bat laravel74-cms-backend  → PHP 7.4 + PostgreSQL
```

**Force PHP 8.4:**
```bash
# Mặc định cho Laravel và E-commerce
create.bat modern-api             → PHP 8.4 + PostgreSQL
create.bat advanced-shop          → PHP 8.4 + MySQL
create.bat high-performance-app   → PHP 8.4 + PostgreSQL
```

### 3.2 📊 Port Assignment System

**Ports được tự động assign:**
- **WordPress**: 8015, 8018, 8021, 8024... (cách 3)
- **Laravel API**: 8016, 8019, 8022, 8025... (cách 3)
- **E-commerce**: 8017, 8020, 8023, 8026... (cách 3)

**Xdebug Ports:**
- **Port pattern**: 90XX (XX = last 2 digits of web port)
- **Ví dụ**: Web 8015 → Xdebug 9015

### 3.3 🗄️ Database Assignment

**MySQL được chọn cho:**
- Keywords: shop, store, ecommerce, commerce, buy, sell
- Keywords: blog, news, cms, content, portfolio, website
- Keywords: food, restaurant, delivery, cafe

**PostgreSQL được chọn cho:**
- Keywords: api, service, micro, backend
- Default: Tất cả Laravel projects không có keywords đặc biệt

## 📁 Bước 4: Hiểu Platform Structure

### 4.1 Cấu trúc Platform được tạo
```
platforms/
├── [project-name]/
│   ├── docker-compose.[project-name].yml  # Container config
│   ├── Dockerfile                         # PHP + Xdebug setup
│   ├── README.md                          # Platform documentation
│   └── projects/
│       └── index.php                      # Application entry point
```

### 4.2 Ví dụ Platform Structure
```
platforms/
├── wp-blog-example/                       # WordPress PHP 7.4 + MySQL
│   ├── docker-compose.wp-blog-example.yml
│   ├── Dockerfile
│   ├── README.md
│   └── projects/
│       └── index.php                      # WordPress demo
├── laravel74-api-example/                 # Laravel PHP 7.4 + PostgreSQL
│   ├── docker-compose.laravel74-api-example.yml
│   ├── Dockerfile
│   ├── README.md
│   └── projects/
│       └── index.php                      # Laravel API demo
└── laravel84-shop-example/                # Laravel PHP 8.4 + MySQL
    ├── docker-compose.laravel84-shop-example.yml
    ├── Dockerfile
    ├── README.md
    └── projects/
        └── index.php                      # E-commerce demo
```

### 4.3 Path Mapping trong Container
- **Container path**: `/app`
- **Local path**: `platforms/[project-name]/projects/`
- **Web accessible**: Tất cả files trong `projects/`

## 🗄️ Bước 5: Database Management

### 5.1 MySQL Connection (WordPress + E-commerce)
```bash
# Connection Details
Host: mysql_low_ram (or localhost:3306)
Username: mysql_user
Password: mysql_pass
Root Password: mysql_root_pass

# CLI Access
docker exec -it mysql_low_ram mysql -u mysql_user -pmysql_pass
docker exec -it mysql_low_ram mysql -u root -pmysql_root_pass

# Databases được tạo tự động:
# - wp_blog_example_db (WordPress)
# - laravel84_shop_example_db (E-commerce)
```

### 5.2 PostgreSQL Connection (APIs + Laravel)
```bash
# Connection Details
Host: postgres_low_ram (or localhost:5432)
Username: postgres_user
Password: postgres_pass

# CLI Access
docker exec -it postgres_low_ram psql -U postgres_user -d postgres

# Databases được tạo tự động:
# - laravel74_api_example_db (Laravel 7.4 API)
# - [project-name]_db (Other Laravel projects)
```

### 5.3 Database Commands
```bash
# List MySQL databases
docker exec mysql_low_ram mysql -u mysql_user -pmysql_pass -e "SHOW DATABASES;"

# List PostgreSQL databases
docker exec postgres_low_ram psql -U postgres_user -d postgres -c "\l"

# Backup MySQL
docker exec mysql_low_ram mysqldump -u mysql_user -pmysql_pass [database_name] > backup.sql

# Backup PostgreSQL
docker exec postgres_low_ram pg_dump -U postgres_user [database_name] > backup.sql
```

## 🔧 Bước 6: Development Workflow

### 6.1 Tạo và Quản lý Platform
```bash
# Tạo platform mới
create.bat my-new-project

# Xem tất cả platforms
docker ps --filter "name=_php"

# Start specific platform
docker-compose -f platforms/[project-name]/docker-compose.[project-name].yml up -d

# Stop specific platform
docker-compose -f platforms/[project-name]/docker-compose.[project-name].yml down
```

### 6.2 Development Process
1. **Tạo platform**: `create.bat project-name`
2. **Edit code**: Trong `platforms/[project-name]/projects/`
3. **Access URL**: http://localhost:[assigned-port]
4. **Debug**: VS Code với Xdebug port
5. **Database**: Tự động kết nối với database phù hợp

### 6.3 Xem Logs và Debug
```bash
# Xem logs platform
docker logs [project-name]_php74
docker logs [project-name]_php84

# Access container
docker exec -it [project-name]_php74 bash
docker exec -it [project-name]_php84 bash

# Test database connection
docker exec [project-name]_php74 php -r "
try {
  \$pdo = new PDO('[connection-string]');
  echo 'Database: ✅ Connected\n';
} catch(Exception \$e) {
  echo 'Database: ❌ Failed\n';
}"
```

## 🎯 Bước 7: Advanced Usage

### 7.1 🔧 Custom Port Assignment
```bash
# Nếu muốn custom port, edit docker-compose file
# File: platforms/[project-name]/docker-compose.[project-name].yml
# Thay đổi:
ports:
  - "8025:80"      # Custom web port
  - "9025:9003"    # Custom Xdebug port
```

### 7.2 🗄️ Force Database Type
```bash
# Để force database type, edit auto-platform.bat
# Hoặc tạo project với naming convention:
create.bat mysql-my-api      # Force MySQL
create.bat psql-my-shop      # Force PostgreSQL
```

### 7.3 📊 Memory Management
```bash
# Xem memory usage
docker stats --no-stream

# Core services memory:
# - MySQL: 256MB
# - PostgreSQL: 128MB
# - Redis: 32MB
# - Each platform: ~128MB
```

## 🎯 Bước 8: Examples và Testing

### 8.1 Chạy Examples Summary
```bash
# Xem tổng kết 3 examples
scripts\examples-summary.bat

# Hoặc đọc guide
EXAMPLES-GUIDE.md
```

### 8.2 Test Database Connections
```bash
# Test tất cả connections
scripts\mysql-success-summary.bat

# Test individual platforms
docker exec wp-blog-example_php74 php -r "echo 'WordPress: '; try { new PDO('mysql:host=mysql_low_ram;dbname=wp_blog_example_db', 'mysql_user', 'mysql_pass'); echo '✅ OK\n'; } catch(Exception \$e) { echo '❌ Failed\n'; }"
```

## 🎯 Bước 9: Tiếp theo

**Cần debug code?** → [04-DEBUG-SETUP.md](04-DEBUG-SETUP.md)

**Muốn hiểu examples?** → [EXAMPLES-GUIDE.md](../EXAMPLES-GUIDE.md)

**Gặp vấn đề?** → [06-TROUBLESHOOTING.md](06-TROUBLESHOOTING.md)

---

## 💡 Tips hữu ích

### 🚀 Quick Commands
```bash
# Tạo platform nhanh
create.bat my-blog           # WordPress + MySQL
create.bat user-api          # Laravel + PostgreSQL
create.bat online-shop       # Laravel + MySQL

# Xem tất cả platforms
docker ps --filter "name=_php"

# Stop tất cả platforms
docker stop $(docker ps -q --filter "name=_php")
```

### 🔧 Development Tips
- **Auto-reload**: Code changes tự động cập nhật
- **Database persistence**: Data lưu trong Docker volumes
- **Network isolation**: Mỗi platform có network riêng
- **Memory optimized**: Tất cả services được tối ưu RAM
- **Cross-platform**: Hoạt động trên Windows, Mac, Linux

### 🐛 Debug Tips
- **Xdebug ports**: 9015, 9016, 9017... (tương ứng với web ports)
- **VS Code**: Cấu hình debug trong `.vscode/launch.json`
- **Path mapping**: `/app` trong container = `platforms/[name]/projects/` local
- **Breakpoints**: Set trong VS Code, trigger bằng browser
