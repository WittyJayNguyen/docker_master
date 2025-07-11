# 🚀 Docker Master Platform - Quick Reference

> **Tham khảo nhanh các lệnh và URL quan trọng**

## ⚡ Lệnh Cơ Bản

### Khởi Động Hệ Thống
```bash
# Auto start toàn bộ (khuyến nghị)
bin\auto-start.bat

# Start thủ công
docker-compose -f docker-compose.low-ram.yml up -d

# Kiểm tra trạng thái
docker ps
bin\status.bat
```

### Tạo Platform Mới
```bash
# AI Auto-detection (1 lệnh)
bin\create.bat [project-name]

# Ví dụ:
bin\create.bat my-shop      # → Laravel E-commerce
bin\create.bat my-blog      # → WordPress
bin\create.bat api-service  # → Laravel API
```

### Quản Lý Platform
```bash
# Start/Stop/Restart
bin\start.bat
bin\stop.bat
bin\restart.bat

# Fast restart (0.1s)
bin\fast-restart.bat

# Monitor RAM
bin\monitor-ram.bat
```

## 🌐 URLs Quan Trọng

### Dashboard & Monitoring
| Service | URL | Mô Tả |
|---------|-----|-------|
| **Main Dashboard** | http://localhost/ | Trang chủ hệ thống |
| **RAM Monitor** | http://localhost/ram-optimization.php | Theo dõi RAM real-time |
| **Database Test** | http://localhost/test-db.php | Test kết nối DB |

### Database Management
| Tool | URL | Username | Password |
|------|-----|----------|----------|
| **Adminer** | http://localhost:8080 | postgres_user | postgres_pass |
| **phpMyAdmin** | http://localhost:8081 | mysql_user | mysql_pass |
| **pgAdmin** | http://localhost:8082 | admin@admin.com | admin |

### Development Tools
| Tool | URL | Mô Tả |
|------|-----|-------|
| **Mailhog** | http://localhost:8025 | Email testing |
| **Laravel 8.4** | http://localhost:8010 | Modern Laravel |
| **Laravel 7.4** | http://localhost:8020 | Legacy Laravel |
| **WordPress** | http://localhost:8030 | WordPress sites |

## 🗄️ Database Connections

### PostgreSQL (Primary)
```env
DB_CONNECTION=pgsql
DB_HOST=postgres_low_ram
DB_PORT=5432
DB_DATABASE=docker_master
DB_USERNAME=postgres_user
DB_PASSWORD=postgres_pass
```

### MySQL (Secondary)
```env
DB_CONNECTION=mysql
DB_HOST=mysql_low_ram
DB_PORT=3306
DB_DATABASE=main_db
DB_USERNAME=mysql_user
DB_PASSWORD=mysql_pass
```

### Redis (Cache)
```env
REDIS_HOST=redis_low_ram
REDIS_PORT=6379
REDIS_PASSWORD=null
```

## 🐛 Debug Configuration

### Xdebug Ports
| PHP Version | Xdebug Port | Container |
|-------------|-------------|-----------|
| **PHP 8.4** | 9084 | laravel_php84_low_ram |
| **PHP 7.4** | 9074 | laravel_php74_low_ram |
| **WordPress** | 9075 | wordpress_php74_low_ram |

### VS Code Settings
```json
{
    "name": "Listen for Xdebug PHP 8.4",
    "type": "php",
    "request": "launch",
    "port": 9084,
    "pathMappings": {
        "/var/www/html": "${workspaceFolder}/projects/[platform-name]"
    }
}
```

## 📊 RAM Optimization

### Profiles Tự Động
| RAM Hệ Thống | Profile | MySQL | PHP | OPcache |
|---------------|---------|-------|-----|---------|
| **≤ 4GB** | Conservative | 200MB | 256MB | 64MB |
| **5-8GB** | Balanced | 512MB | 512MB | 128MB |
| **9-16GB** | Performance | 1GB | 1GB | 256MB |
| **>16GB** | Maximum | 2GB | 2GB | 512MB |

### Lệnh Optimization
```bash
# Auto-optimize dựa trên RAM
scripts\optimize-ram.bat

# Monitor real-time
scripts\monitor-ram.bat

# Quick RAM check
scripts\quick-ram-check.bat
```

## 🔧 Troubleshooting Nhanh

### Lỗi Thường Gặp
```bash
# Docker issues
scripts\fix-docker.bat

# Database connection
scripts\fix-mysql-connection.bat
scripts\fix-database-corruption.bat

# All-in-one fix
scripts\fix-all.bat

# Nuclear option (reset all)
scripts\nuclear-clean.bat
```

### Health Checks
```bash
# System health
scripts\health-check.bat

# Database status
scripts\mysql-status-summary.bat

# Platform status
scripts\final-status.bat
```

## 📁 Cấu Trúc Thư Mục

```
docker_master/
├── 📁 bin/                    # Lệnh chính
│   ├── create.bat            # Tạo platform
│   ├── start.bat             # Khởi động
│   └── auto-start.bat        # Auto start
├── 📁 scripts/               # Scripts quản lý
│   ├── auto-platform.bat    # Auto-detection
│   ├── optimize-ram.bat      # RAM optimization
│   └── *.bat                 # Các scripts khác
├── 📁 projects/              # Platform projects
│   ├── laravel-php84-psql/   # Laravel 8.4
│   ├── laravel-php74-psql/   # Laravel 7.4
│   └── wordpress-php74/      # WordPress
├── 📁 docker/                # Docker configs
│   ├── php74/               # PHP 7.4 image
│   ├── php84/               # PHP 8.4 image
│   └── nginx/               # Nginx configs
├── 📁 data/                  # Persistent data
│   ├── postgres/            # PostgreSQL data
│   ├── mysql/               # MySQL data
│   └── redis/               # Redis data
├── 📁 logs/                  # Application logs
├── 📁 docs/                  # Documentation
└── docker-compose.low-ram.yml # Main config
```

## 🎯 AI Auto-Detection Rules

### Từ Khóa Nhận Diện
| Keywords | Platform Type | Database | PHP |
|----------|---------------|----------|-----|
| shop, store, ecommerce, buy, sell | E-commerce | MySQL | 8.4 |
| blog, cms, wordpress, news | WordPress | MySQL | 7.4 |
| api, service, rest, microservice | API Service | PostgreSQL | 8.4 |
| admin, dashboard, panel | Admin Panel | PostgreSQL | 8.4 |
| legacy, old, vintage | Legacy App | PostgreSQL | 7.4 |
| laravel74, php74 | Laravel 7.4 | PostgreSQL | 7.4 |
| laravel84, php84 | Laravel 8.4 | PostgreSQL | 8.4 |

### Port Auto-Assignment
- **8010-8019**: PHP 8.4 platforms
- **8020-8029**: PHP 7.4 platforms  
- **8030-8039**: WordPress platforms
- **8040-8049**: Custom platforms

## 🌐 Domain Routing

### Auto Domains
```bash
# Format: [platform].io
my-shop.io      # E-commerce
my-blog.io      # WordPress
api-service.io  # API Service
```

### Nginx Configuration
```nginx
# Auto-generated in nginx/conf.d/
server {
    listen 80;
    server_name [platform].io;
    location / {
        proxy_pass http://[container]:[port];
    }
}
```

## 📞 Quick Help

### Documentation
```bash
# Show all docs
scripts\docs-summary.bat

# Quick help
bin\help.bat

# Examples guide
scripts\examples-summary.bat
```

### Support Commands
```bash
# System summary
scripts\auto-system-summary.bat

# Final status check
scripts\final-auto-discovery-status.bat

# Complete test
scripts\final-test-all.bat
```

---

## 🎉 Ready to Go!

```bash
# Bắt đầu ngay:
1. bin\auto-start.bat          # Khởi động hệ thống
2. bin\create.bat my-project   # Tạo project đầu tiên
3. http://localhost/           # Mở dashboard
```

**Happy Coding! 🚀**
