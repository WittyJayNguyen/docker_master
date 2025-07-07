# 🐳 Docker Master Platform - Complete Development Environment

> **Hệ thống phát triển Docker tối ưu với AI Auto-Detection, Auto Domain và RAM Optimization**

[![Docker](https://img.shields.io/badge/Docker-20.10+-blue.svg)](https://docker.com)
[![PHP](https://img.shields.io/badge/PHP-7.4%20%7C%208.4-purple.svg)](https://php.net)
[![Laravel](https://img.shields.io/badge/Laravel-9%2B-red.svg)](https://laravel.com)
[![WordPress](https://img.shields.io/badge/WordPress-6%2B-blue.svg)](https://wordpress.org)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

## 🌟 Tính Năng Nổi Bật

### 🤖 AI-Powered Auto-Detection
- **Smart Platform Detection**: Tự động nhận diện loại project từ tên
- **Optimal Configuration**: Chọn database, PHP version, và cấu hình tối ưu
- **Zero Configuration**: Không cần setup phức tạp, chỉ cần 1 lệnh

### 🌐 Advanced Auto Domain System
- **Dynamic Routing**: Tự động tạo domain [project].asmo-tranding.io
- **Nginx Integration**: Cấu hình reverse proxy tự động
- **SSL Ready**: Hỗ trợ SSL certificates cho development

### ⚡ Performance & Optimization
- **Fast Restart**: Áp dụng thay đổi trong 0.1 giây
- **RAM Optimized**: Tối ưu cho hệ thống từ 4GB RAM
- **Smart Caching**: Redis + OPcache + Database optimization
- **Resource Monitoring**: Real-time RAM và performance tracking

### 🗄️ Dual Database Support
- **PostgreSQL**: Primary database cho modern applications
- **MySQL**: Secondary database cho WordPress và legacy systems
- **Auto Migration**: Tự động tạo database và permissions

### 🐛 Developer Experience
- **Xdebug Ready**: Cấu hình sẵn cho PHP 7.4 & 8.4
- **VS Code Integration**: Launch configurations có sẵn
- **Hot Reload**: Auto-restart khi có thay đổi code
- **Comprehensive Logging**: Detailed logs cho debugging

## ⚡ Quick Start - 30 Giây

### Bước 1: Khởi Động Hệ Thống
```bash
# Di chuyển vào thư mục docker_master
cd D:\www\docker_master

# Auto-start toàn bộ services (đã được tối ưu)
bin\auto-start.bat

# Kiểm tra trạng thái
docker ps
```

### Bước 2: Tạo Platform Đầu Tiên
```bash
# AI tự động chọn cấu hình dựa trên tên
bin\create.bat my-shop

# Kết quả tự động:
# ✅ Laravel 8.4 + MySQL (E-commerce detected)
# ✅ Domain: my-shop.asmo-tranding.io
# ✅ Port: 8010
# ✅ Database: my_shop_db
# ✅ Xdebug: Port 9084
```

### Bước 3: Truy Cập và Monitor
```bash
# Dashboard chính
http://localhost/

# Platform vừa tạo
http://my-shop.asmo-tranding.io  # Auto domain
http://localhost:8010           # Direct access

# RAM monitoring
http://localhost/ram-optimization.php

# Database management
http://localhost:8080           # Adminer
http://localhost:8081           # phpMyAdmin
```

## 🌐 Professional URLs

Thay vì `http://localhost:8015`, bạn có:
- **WordPress**: http://my-blog.asmo-tranding.io
- **Laravel API**: http://user-api.asmo-tranding.io
- **E-commerce**: http://online-shop.asmo-tranding.io

## 🤖 AI Auto-Detection Examples

### WordPress Projects:
```bash
create.bat tech-blog         → MySQL + WordPress + PHP 7.4
create.bat company-website   → MySQL + WordPress + PHP 7.4
create.bat news-portal       → MySQL + WordPress + PHP 7.4
```

### Laravel API Projects:
```bash
create.bat user-api          → PostgreSQL + Laravel + PHP 8.4
create.bat payment-service   → PostgreSQL + Laravel + PHP 8.4
create.bat notification-api  → PostgreSQL + Laravel + PHP 8.4
```

### E-commerce Projects:
```bash
create.bat online-shop       → MySQL + Laravel + PHP 8.4
create.bat food-delivery     → MySQL + Laravel + PHP 8.4
create.bat book-store        → MySQL + Laravel + PHP 8.4
```

## 🔧 Available Scripts

### Main Commands:
| Script | Function | Time |
|--------|----------|------|
| `auto-start.bat` | Start system + auto domain setup | ~1 min |
| `create.bat [name]` | Create platform with auto features | ~30 sec |
| `fast-restart.bat` | Fast restart for changes | ~3 sec |
| `fix-all.bat` | Complete system fix | ~2 min |

### Utility Commands:
| Script | Function |
|--------|----------|
| `open-all.bat` | Open all platforms in browser |
| `scripts\setup-domains.bat` | Manual domain setup (admin) |
| `scripts\create-databases.bat` | Create databases for platforms |

## 📊 System Status

### Core Services:
- **Nginx Proxy**: nginx_proxy_low_ram (64MB)
- **MySQL**: mysql_low_ram (256MB)
- **PostgreSQL**: postgres_low_ram (128MB)
- **Redis**: redis_low_ram (32MB)
- **Mailhog**: mailhog_low_ram (32MB)

### Platform Examples:
- **WordPress**: wp-blog-example (8015 → 9015)
- **Laravel 7.4**: laravel74-api-example (8016 → 9016)
- **Laravel 8.4**: laravel84-shop-example (8017 → 9017)

## 🗄️ Database Connections

| Database | Connection | Credentials |
|----------|------------|-------------|
| **MySQL** | localhost:3306 | mysql_user / mysql_pass |
| **PostgreSQL** | localhost:5432 | postgres_user / postgres_pass |

## 🐛 VS Code Debug Configuration

```json
{
  "version": "0.2.0",
  "configurations": [
    {
      "name": "My Blog Debug",
      "type": "php",
      "request": "launch",
      "port": 9015,
      "pathMappings": {
        "/var/www/html": "${workspaceFolder}/platforms/my-blog/projects"
      }
    }
  ]
}
```

## 📚 Documentation

### Quick Guides:
- **[Quick Start](docs/01-QUICK-START.md)** - 1 phút setup
- **[Auto Platform Creation](docs/AUTO-PLATFORM-CREATION.md)** - AI detection guide
- **[Auto Workflow](docs/AUTO-WORKFLOW-GUIDE.md)** - Chi tiết cách hoạt động

### Detailed Guides:
- **[Step by Step](docs/02-STEP-BY-STEP.md)** - Hướng dẫn từng bước
- **[Debug Setup](docs/04-DEBUG-SETUP.md)** - Cấu hình debug
- **[Troubleshooting](docs/06-TROUBLESHOOTING.md)** - Khắc phục sự cố

## 🎯 Workflow Examples

### Daily Development:
```bash
# Start system
auto-start.bat

# Create new project
create.bat my-awesome-project

# Access via domain
# http://my-awesome-project.asmo-tranding.io

# Make changes and fast restart
fast-restart.bat
```

### Team Development:
```bash
# Setup domains once (as Administrator)
scripts\setup-domains.bat

# Share professional URLs
# http://user-api.asmo-tranding.io
# http://admin-panel.asmo-tranding.io
```

## 🌟 Benefits

### ✅ **Developer Experience:**
- One command platform creation
- Professional domain URLs
- Instant configuration changes
- Zero manual setup required
- Auto debugging ready

### ✅ **Performance:**
- Fast creation: 15-30 seconds
- Ultra-fast restart: 0.1 seconds
- Memory optimized: <1.5GB total
- Auto error recovery

### ✅ **Professional Features:**
- Domain routing like production
- SSL ready for HTTPS
- Load balancing capable
- Health monitoring included

## 🚀 Getting Started

1. **Clone repository**:
   ```bash
   git clone [repository-url]
   cd docker_master
   ```

2. **Start system**:
   ```bash
   auto-start.bat
   ```

3. **Create your first platform**:
   ```bash
   create.bat my-awesome-project
   ```

4. **Access via domain**:
   ```
   http://my-awesome-project.asmo-tranding.io
   ```

5. **Start developing!**

## 💡 Tips

- Use meaningful project names for better AI detection
- Run `scripts\setup-domains.bat` as Administrator once for domain access
- Use `fast-restart.bat` for quick changes
- Check `docker ps` to see all running platforms
- Use VS Code with provided debug configurations

## 🆘 Support

- **Issues**: Check [Troubleshooting Guide](docs/06-TROUBLESHOOTING.md)
- **Documentation**: Browse [docs/](docs/) folder
- **Examples**: See [EXAMPLES-GUIDE.md](EXAMPLES-GUIDE.md)

---

**🌟 Professional Docker development environment with AI automation and instant domain routing!**

**Made with ❤️ for developers who want zero-configuration, maximum productivity.**
