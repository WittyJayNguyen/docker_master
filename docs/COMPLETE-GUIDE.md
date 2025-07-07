# 🐳 Docker Master Platform - Hướng Dẫn Hoàn Chỉnh

> **Hệ thống phát triển Docker tối ưu với AI Auto-Detection, Auto Domain và Fast Restart**

## 📋 Mục Lục

1. [Giới Thiệu](#-giới-thiệu)
2. [Cài Đặt Nhanh](#-cài-đặt-nhanh)
3. [Tính Năng Chính](#-tính-năng-chính)
4. [Hướng Dẫn Sử Dụng](#-hướng-dẫn-sử-dụng)
5. [Quản Lý Hệ Thống](#-quản-lý-hệ-thống)
6. [Tối Ưu Hóa](#-tối-ưu-hóa)
7. [Khắc Phục Sự Cố](#-khắc-phục-sự-cố)
8. [API và Tích Hợp](#-api-và-tích-hợp)

---

## 🎯 Giới Thiệu

**Docker Master Platform** là hệ thống phát triển web hoàn chỉnh được tối ưu hóa cho:

### ✨ Điểm Nổi Bật
- **🤖 AI Auto-Detection**: Tự động nhận diện loại project và chọn cấu hình phù hợp
- **🌐 Auto Domain**: Tự động tạo domain với Nginx routing
- **⚡ Fast Restart**: Áp dụng thay đổi trong 0.1 giây
- **🗄️ Dual Database**: Hỗ trợ cả MySQL và PostgreSQL
- **🐛 Debug Ready**: Xdebug đã cấu hình sẵn cho PHP 7.4 & 8.4
- **📊 RAM Optimized**: Tối ưu cho hệ thống từ 4GB RAM
- **🚀 One Command**: Tạo platform hoàn chỉnh với 1 lệnh

### 🏗️ Kiến Trúc Hệ Thống
```
Docker Master Platform
├── 🗄️ Core Services
│   ├── PostgreSQL (Primary DB)
│   ├── MySQL (Secondary DB)
│   ├── Redis (Cache & Sessions)
│   ├── Nginx (Reverse Proxy)
│   └── Mailhog (Email Testing)
├── 🐘 PHP Environments
│   ├── PHP 8.4 (Modern Laravel)
│   └── PHP 7.4 (Legacy/WordPress)
├── 🌐 Auto Platforms
│   ├── Laravel Projects
│   ├── WordPress Sites
│   └── Custom Applications
└── 🛠️ Management Tools
    ├── Web Dashboard
    ├── RAM Monitor
    └── Auto Scripts
```

---

## ⚡ Cài Đặt Nhanh

### Bước 1: Kiểm Tra Yêu Cầu
```bash
# Kiểm tra Docker
docker --version
docker-compose --version

# Yêu cầu tối thiểu:
# - Docker Desktop 4.0+
# - RAM: 4GB+ (khuyến nghị 8GB+)
# - Disk: 10GB+ trống
# - OS: Windows 10/11, macOS, Linux
```

### Bước 2: Khởi Động Hệ Thống
```bash
# Di chuyển vào thư mục dự án
cd d:\www\docker_master

# Khởi động toàn bộ hệ thống (Auto Start)
bin\auto-start.bat

# Hoặc khởi động thủ công
docker-compose -f docker-compose.low-ram.yml up -d
```

### Bước 3: Kiểm Tra Trạng Thái
```bash
# Xem dashboard chính
http://localhost/

# Kiểm tra RAM optimization
http://localhost/ram-optimization.php

# Xem trạng thái containers
docker ps
```

### Bước 4: Tạo Platform Đầu Tiên
```bash
# Tạo Laravel shop (AI sẽ tự động chọn cấu hình)
bin\create.bat my-shop

# Tạo WordPress blog
bin\create.bat my-blog

# Tạo API service
bin\create.bat api-service
```

---

## 🌟 Tính Năng Chính

### 🤖 AI Auto-Detection
Hệ thống tự động phát hiện loại project dựa trên tên:

| Từ Khóa | Platform | Database | PHP Version |
|---------|----------|----------|-------------|
| shop, store, ecommerce | Laravel E-commerce | MySQL | 8.4 |
| blog, cms, wordpress | WordPress | MySQL | 7.4 |
| api, service, rest | Laravel API | PostgreSQL | 8.4 |
| admin, dashboard | Laravel Admin | PostgreSQL | 8.4 |
| legacy, old | Laravel Legacy | PostgreSQL | 7.4 |

### 🌐 Auto Domain System
```bash
# Tự động tạo domains:
my-shop.asmo-tranding.io     → Laravel E-commerce
my-blog.asmo-tranding.io     → WordPress Blog
api-service.asmo-tranding.io → Laravel API

# Nginx tự động cấu hình routing
# SSL certificates tự động (development)
```

### ⚡ Fast Restart Technology
```bash
# Áp dụng thay đổi ngay lập tức
bin\fast-restart.bat

# Auto-restart khi có thay đổi
bin\auto-monitor.bat
```

---

## 📖 Hướng Dẫn Sử Dụng

### Tạo Platform Mới

#### Cách 1: Auto-Detection (Khuyến nghị)
```bash
# Chỉ cần tên project, AI sẽ làm tất cả
bin\create.bat [project-name]

# Ví dụ:
bin\create.bat online-shop    # → Laravel + MySQL + PHP 8.4
bin\create.bat company-blog   # → WordPress + MySQL + PHP 7.4
bin\create.bat user-api       # → Laravel + PostgreSQL + PHP 8.4
```

#### Cách 2: Chỉ Định Cụ Thể
```bash
# Tạo với cấu hình cụ thể
scripts\create-platform.bat [name] [type] [port] [php-version]

# Ví dụ:
scripts\create-platform.bat my-app laravel 8015 84
scripts\create-platform.bat my-site wordpress 8016 74
```

### Quản Lý Platform

#### Khởi Động/Dừng
```bash
# Khởi động tất cả
bin\start.bat

# Dừng tất cả
bin\stop.bat

# Restart nhanh
bin\restart.bat

# Xem trạng thái
bin\status.bat
```

#### Monitoring và Logs
```bash
# Monitor RAM real-time
bin\monitor-ram.bat

# Xem logs
scripts\logs.bat [service-name]

# Ví dụ:
scripts\logs.bat mysql
scripts\logs.bat laravel-php84
```

### Database Management

#### Truy Cập Database
```bash
# phpMyAdmin (MySQL)
http://localhost:8081

# Adminer (Universal)
http://localhost:8080

# pgAdmin (PostgreSQL)
http://localhost:8082
```

#### Tạo Database Mới
```bash
# Tự động tạo database cho platform
scripts\create-databases.bat [platform-name]

# Test kết nối database
http://localhost/test-db.php
```

---

## 🔧 Quản Lý Hệ Thống

### Cấu Hình RAM Optimization

#### Auto-Detection RAM
```bash
# Hệ thống tự động phát hiện RAM và tối ưu
scripts\optimize-ram.bat

# Kiểm tra trạng thái optimization
http://localhost/ram-optimization.php
```

#### Manual Configuration
```yaml
# Chỉnh sửa docker-compose.low-ram.yml
services:
  postgres:
    deploy:
      resources:
        limits:
          memory: 256M  # Tăng/giảm theo RAM hệ thống
```

### Backup và Restore

#### Backup Tự Động
```bash
# Backup tất cả databases
scripts\backup-all.bat

# Backup platform cụ thể
scripts\backup-platform.bat [platform-name]
```

#### Restore
```bash
# Restore từ backup
scripts\restore-platform.bat [platform-name] [backup-file]
```

### SSL và Security

#### Tự Động SSL (Development)
```bash
# Tạo SSL certificates cho development
scripts\setup-ssl.bat

# Cấu hình domains với SSL
scripts\setup-domains.bat
```

---

## 📊 Tối Ưu Hóa

### Performance Tuning

#### Database Optimization
```sql
-- MySQL optimization
SET GLOBAL innodb_buffer_pool_size = 256M;
SET GLOBAL query_cache_size = 64M;

-- PostgreSQL optimization
ALTER SYSTEM SET shared_buffers = '64MB';
ALTER SYSTEM SET effective_cache_size = '192MB';
```

#### PHP Optimization
```ini
; php.ini optimization
memory_limit = 256M
opcache.memory_consumption = 128
opcache.max_accelerated_files = 4000
opcache.jit_buffer_size = 64M
```

#### Redis Optimization
```conf
# redis.conf
maxmemory 48mb
maxmemory-policy allkeys-lru
save 900 1
appendonly yes
```

### Monitoring và Alerting

#### Real-time Monitoring
```bash
# Bật auto-monitoring 24/7
scripts\start-auto-monitor.bat

# Dashboard monitoring
http://localhost/ram-optimization.php
```

#### Performance Metrics
- RAM usage per container
- Database query performance
- PHP execution time
- Cache hit rates
- Network latency

---

## 🚨 Khắc Phục Sự Cố

### Lỗi Thường Gặp

#### Docker Issues
```bash
# Docker không khởi động được
scripts\fix-docker.bat

# Containers bị crash
scripts\fix-all.bat

# Port conflicts
scripts\fix-ports.bat
```

#### Database Issues
```bash
# MySQL connection failed
scripts\fix-mysql-connection.bat

# PostgreSQL corruption
scripts\fix-database-corruption.bat

# Database permissions
scripts\fix-database-demo.bat
```

#### Memory Issues
```bash
# RAM quá cao
scripts\optimize-ram.bat

# Container out of memory
scripts\nuclear-clean.bat  # Reset toàn bộ
```

### Debug và Troubleshooting

#### Xdebug Setup
```json
// VS Code launch.json
{
    "name": "Listen for Xdebug",
    "type": "php",
    "request": "launch",
    "port": 9003,
    "pathMappings": {
        "/var/www/html": "${workspaceFolder}/projects/[platform-name]"
    }
}
```

#### Log Analysis
```bash
# Xem logs chi tiết
scripts\logs.bat [service] | findstr ERROR

# Monitor logs real-time
docker logs -f [container-name]
```

---

## 🔗 API và Tích Hợp

### REST API Endpoints
```bash
# System status
GET /api/status

# Platform management
POST /api/platforms
GET /api/platforms/{id}
DELETE /api/platforms/{id}

# Resource monitoring
GET /api/resources/ram
GET /api/resources/cpu
```

### Webhook Integration
```bash
# Auto-deploy on git push
POST /webhook/deploy/{platform}

# Monitoring alerts
POST /webhook/alert/{type}
```

---

## 📞 Hỗ Trợ

### Quick Help
```bash
# Hiển thị help nhanh
bin\help.bat

# Documentation summary
scripts\docs-summary.bat

# System health check
scripts\health-check.bat
```

### Resources
- 📖 [Complete Documentation](./COMPLETE-GUIDE.md)
- 🚀 [Quick Start Guide](./01-QUICK-START.md)
- 🐛 [Debug Setup](./04-DEBUG-SETUP.md)
- 🔧 [Troubleshooting](./06-TROUBLESHOOTING.md)

---

**🎉 Chúc bạn phát triển thành công với Docker Master Platform!**
