# 📖 Hướng dẫn từng bước chi tiết

> **Mục tiêu**: Hiểu rõ từng bước và cách hoạt động của dự án

## 📋 Tổng quan dự án

**Docker Master Platform** là hệ thống phát triển đa framework với:
- **3 ứng dụng**: Laravel PHP 8.4, Laravel PHP 7.4, WordPress
- **3 database**: PostgreSQL, MySQL, Redis  
- **3 tools**: phpMyAdmin, pgAdmin, Mailhog
- **Xdebug**: Hỗ trợ debug cho tất cả PHP versions

## 🏗️ Cấu trúc dự án

```
docker_master/
├── 📁 platforms/          # Cấu hình Docker Compose cho từng platform
├── 📁 projects/           # Source code các ứng dụng
├── 📁 docker/             # Dockerfiles và configs
├── 📁 data/               # Database data (persistent)
├── 📁 logs/               # Application logs
├── 📁 scripts/            # Helper scripts (.bat cho Windows)
└── 📁 docs/               # Tài liệu (thư mục này)
```

## 🔧 Bước 1: Chuẩn bị môi trường

### 1.1 Kiểm tra Docker
```bash
# Kiểm tra Docker
docker --version
docker-compose --version

# Kiểm tra Docker đang chạy
docker ps
```

### 1.2 Hiểu về Scripts
- **setup.bat**: Tạo thư mục, pull images, build containers
- **start.bat**: Khởi động tất cả containers
- **stop.bat**: Dừng tất cả containers
- **restart.bat**: Restart containers
- **logs.bat**: Xem logs

## 🚀 Bước 2: Setup chi tiết

### 2.1 Chạy Setup
```bash
.\scripts\setup.bat
```

**Script này làm gì?**
1. ✅ Kiểm tra Docker có sẵn
2. 📁 Tạo thư mục `data/`, `logs/`
3. 📄 Tạo file `.env` (nếu chưa có)
4. 🐳 Pull Docker images từ registry
5. 🔨 Build custom images với PHP + Xdebug

### 2.2 Hiểu quá trình Build
```bash
# Xem quá trình build
docker-compose build --no-cache

# Images được build:
# - docker_master-laravel-php84-psql (PHP 8.4 + Xdebug)
# - docker_master-laravel-php74-psql (PHP 7.4 + Xdebug)  
# - docker_master-wordpress-php74-mysql (WordPress + Xdebug)
```

## 🌐 Bước 3: Khởi động và hiểu Services

### 3.1 Start Services
```bash
.\scripts\start.bat
# Hoặc
docker-compose up -d
```

### 3.2 Các Services được khởi động

| Service | Container Name | Ports | Mô tả |
|---------|----------------|-------|-------|
| **Laravel PHP 8.4** | laravel_php84_psql_app | 8010:80, 9084:9003 | Web + Debug |
| **Laravel PHP 7.4** | laravel_php74_psql_app | 8011:80, 9074:9003 | Web + Debug |
| **WordPress** | wordpress_php74_mysql_app | 8012:80, 9012:9003 | Web + Debug |
| **PostgreSQL** | postgres_server | 5432:5432 | Database |
| **MySQL** | mysql_server | 3306:3306 | Database |
| **Redis** | redis_server | 6379:6379 | Cache |
| **phpMyAdmin** | phpmyadmin | 8080:80 | MySQL GUI |
| **pgAdmin** | pgadmin | 8081:80 | PostgreSQL GUI |
| **Mailhog** | mailhog | 8025:8025, 1025:1025 | Email testing |

### 3.3 Kiểm tra trạng thái
```bash
# Xem tất cả containers
docker-compose ps

# Xem logs của container cụ thể
docker-compose logs laravel_php84_psql_app

# Vào trong container
docker exec -it laravel_php84_psql_app bash
```

## 📁 Bước 4: Hiểu Source Code

### 4.1 Cấu trúc Projects
```
projects/
├── laravel-php84-psql/     # Laravel với PHP 8.4
│   ├── public/             # Web root
│   ├── app/                # Laravel app code
│   └── xdebug_test.php     # File test Xdebug
├── laravel-php74-psql/     # Laravel với PHP 7.4  
└── wordpress-php74-mysql/  # WordPress
```

### 4.2 Path Mapping
- **Container path**: `/app/laravel-php84-psql`
- **Local path**: `D:\www\docker_master\projects\laravel-php84-psql`
- **Web root**: `/app/laravel-php84-psql/public`

## 🗄️ Bước 5: Database Management

### 5.1 PostgreSQL (Laravel)
```bash
# Truy cập pgAdmin: http://localhost:8081
# Email: admin@admin.com
# Password: admin

# Thêm server:
# Host: postgres_server
# Username: postgres_user  
# Password: postgres_pass
# Database: laravel_php84_psql, laravel_php74_psql
```

### 5.2 MySQL (WordPress)
```bash
# Truy cập phpMyAdmin: http://localhost:8080
# Username: root
# Password: rootpassword123
# Database: wordpress_php74_mysql
```

### 5.3 Database Commands
```bash
# Backup PostgreSQL
docker exec postgres_server pg_dump -U postgres_user laravel_php84_psql > backup.sql

# Backup MySQL
docker exec mysql_server mysqldump -u root -prootpassword123 wordpress_php74_mysql > backup.sql

# Restore
docker exec -i postgres_server psql -U postgres_user laravel_php84_psql < backup.sql
```

## 🔧 Bước 6: Development Workflow

### 6.1 Chỉnh sửa Code
1. **Mở IDE** (VS Code khuyến nghị)
2. **Edit files** trong `projects/`
3. **Changes tự động sync** vào container
4. **Refresh browser** để thấy thay đổi

### 6.2 Xem Logs
```bash
# Logs tất cả services
docker-compose logs

# Logs service cụ thể
docker-compose logs -f laravel_php84_psql_app

# Apache logs
tail -f logs/apache/laravel-php84-psql/access.log
```

### 6.3 Restart Services
```bash
# Restart tất cả
.\scripts\restart.bat

# Restart service cụ thể
docker-compose restart laravel_php84_psql_app
```

## 🎯 Bước 7: Tiếp theo

**Cần debug code?** → [04-DEBUG-SETUP.md](04-DEBUG-SETUP.md)

**Muốn tạo project mới?** → [03-DEVELOPMENT.md](03-DEVELOPMENT.md)

**Gặp vấn đề?** → [06-TROUBLESHOOTING.md](06-TROUBLESHOOTING.md)

---

## 💡 Tips hữu ích

- **Hot reload**: Code thay đổi tự động cập nhật
- **Persistent data**: Database data lưu trong `data/`
- **Logs**: Tất cả logs lưu trong `logs/`
- **Network**: Tất cả containers trong cùng network `docker_master_network`
