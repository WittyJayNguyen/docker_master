# 🐳 Docker Master Platform 2025 - Professional Edition

> **Hệ thống phát triển Docker tối ưu với Multi-PHP, Dual-Database, AI Auto-Detection và Xdebug Ready**
> **🏗️ Professional Architecture & Clean Code Structure**
> **🌍 Cross-Platform: Windows, Linux, macOS**

[![Docker](https://img.shields.io/badge/Docker-20.10+-blue.svg)](https://docker.com)
[![PHP](https://img.shields.io/badge/PHP-7.4%20%7C%208.4-purple.svg)](https://php.net)
[![Laravel](https://img.shields.io/badge/Laravel-9%2B-red.svg)](https://laravel.com)
[![WordPress](https://img.shields.io/badge/WordPress-6%2B-blue.svg)](https://wordpress.org)
[![Xdebug](https://img.shields.io/badge/Xdebug-3.3+-orange.svg)](https://xdebug.org)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

## � Table of Contents

- [📚 Documentation & Guides](#-documentation--guides)
- [🌟 Tính Năng Nổi Bật](#-tính-năng-nổi-bật)
- [📁 Directory Structure](#-directory-structure-explained)
- [⚡ Quick Start](#-quick-start---30-giây)
- [🔧 Advanced Usage](#-advanced-usage)
- [💡 Pro Tips](#-pro-tips)
- [🆘 Support & Resources](#-support--resources)

## �📚 Documentation & Guides

### **🚀 Quick Start**
- **[Cross-Platform Installation](docs/user-guide/CROSS-PLATFORM-INSTALLATION.md)** - Setup cho Windows, Linux, macOS
- **[Quick Reference Guide](docs/user-guide/QUICK-REFERENCE.md)** - Essential commands và usage patterns
- **[Complete Guide](docs/COMPLETE-GUIDE.md)** - Comprehensive tutorial từ A-Z

### **🏗️ Architecture & Structure**
- **[Professional Structure Overview](docs/architecture/FINAL-STRUCTURE-SUMMARY.md)** - Giải thích cấu trúc enterprise-level
- **[Directory Organization](docs/architecture/PROFESSIONAL-STRUCTURE-SUMMARY.md)** - Chi tiết về app/, public/, storage/
- **[Configuration Management](app/config/README.md)** - Quản lý cấu hình tập trung

### **🔧 Development**
- **[Developer Guide](docs/developer-guide/)** - Advanced development topics
- **[Auto Platform Creation](docs/developer-guide/AUTO-PLATFORM-CREATION.md)** - AI-powered platform generation
- **[Debug Setup](docs/developer-guide/04-DEBUG-SETUP.md)** - Xdebug configuration cho multi-PHP

### **🛠️ Support & Troubleshooting**
- **[Troubleshooting Guide](docs/troubleshooting/)** - Common issues và solutions
- **[Cross-Platform Issues](docs/project-management/CROSS-PLATFORM-SUMMARY.md)** - Platform-specific problems
- **[Complete Documentation Index](docs/DOCUMENTATION-INDEX.md)** - Tất cả documentation có sẵn

## 🌟 Tính Năng Nổi Bật

### 🤖 AI-Powered Auto-Detection
- **Smart Platform Detection**: Tự động nhận diện loại project từ tên
- **Optimal Configuration**: Chọn database, PHP version, và cấu hình tối ưu
- **Zero Configuration**: Không cần setup phức tạp, chỉ cần 1 lệnh

### 🌐 Advanced Auto Domain System
- **Dynamic Routing**: Tự động tạo domain [project].io
- **Nginx Integration**: Cấu hình reverse proxy tự động
- **SSL Ready**: Hỗ trợ SSL certificates cho development

### ⚡ Performance & Optimization
- **Fast Restart**: Áp dụng thay đổi trong 0.1 giây
- **RAM Optimized**: Tối ưu cho hệ thống từ 4GB RAM
- **Smart Caching**: Redis + OPcache + Database optimization
- **Resource Monitoring**: Real-time RAM và performance tracking

### 🗄️ Dual Database Support (Updated 2025)
- **PostgreSQL 15**: Primary database với credentials: postgres_user/postgres_pass
- **MySQL 8.0**: Secondary database với credentials: mysql_user/mysql_pass
- **Redis 7**: Caching layer không cần password
- **Auto Migration**: Tự động tạo database và permissions

### 🐛 Developer Experience (Enhanced 2025)
- **Multi-PHP Xdebug**: PHP 7.4 (port 9074), PHP 8.4 (port 9084), WordPress (port 9075)
- **VS Code Ready**: Launch configurations có sẵn với IDE Key VSCODE
- **Real-time Testing**: phpinfo.php và test-db.php trên mỗi platform
- **Hot Reload**: Auto-restart khi có thay đổi code
- **Comprehensive Dashboard**: Real-time database status và monitoring

### 🏗️ Professional Architecture (New 2025)
- **Clean Code Structure**: Organized by Domain-Driven Design principles
- **Separation of Concerns**: Clear separation between core, infrastructure, and runtime
- **Maintainable**: Easy to extend and modify with professional directory structure
- **Scalable**: Ready for enterprise-level development

### 🌍 Cross-Platform Support (New 2025)
- **Windows**: Native `.bat` scripts + PowerShell/CMD + Git Bash/WSL support
- **Linux**: Native `.sh` scripts + Docker Engine + All major distributions
- **macOS**: Native `.sh` scripts + Docker Desktop + Intel/Apple Silicon
- **Universal Launcher**: Single entry point that auto-detects platform

```
docker_master/
├── 📁 app/                    # Application code & infrastructure
│   ├── 📁 services/          # Business services (platform, docker, database)
│   ├── 📁 infrastructure/    # Docker, Nginx, monitoring
│   ├── 📁 platforms/         # Platform templates & instances
│   ├── 📁 scripts/           # Organized automation scripts
│   └── 📁 config/            # Centralized configuration
├── 📁 storage/               # Data storage (projects, logs, uploads)
├── 📁 public/                # Public web files & dashboard
├── 📁 docs/                  # Organized documentation
├── 📁 config/                # Setup & environment files
└── 📁 bin/                   # Executable commands
```

### **📁 Directory Structure Explained**

- **`app/`** - [Application Code](app/README.md): Core business logic, infrastructure, và automation scripts
- **`storage/`** - [Data Storage](storage/README.md): Projects, logs, uploads, cache, backups
- **`public/`** - Public Web Files: Dashboard, assets, API endpoints
- **`docs/`** - [Documentation](docs/DOCUMENTATION-INDEX.md): Comprehensive guides và references
- **`config/`** - Configuration: Setup scripts, environment templates
- **`bin/`** - Executable Commands: Cross-platform scripts cho daily operations

> **📖 Chi tiết:** [Professional Structure Overview](docs/architecture/FINAL-STRUCTURE-SUMMARY.md)

## ⚡ Quick Start - 30 Giây

> **📖 Chi tiết:** [Cross-Platform Installation Guide](docs/user-guide/CROSS-PLATFORM-INSTALLATION.md)

### Bước 1: Setup (Lần đầu tiên)
```bash
# Clone repository
git clone https://github.com/your-repo/docker_master.git
cd docker_master

# Setup cho platform của bạn
config/setup.sh      # Linux/macOS
config/setup.bat     # Windows
```

> **💡 Tip:** Xem [Setup Troubleshooting](docs/troubleshooting/) nếu gặp vấn đề

### Bước 2: Khởi Động Hệ Thống (Cross-Platform)
```bash
# Universal launcher (khuyến nghị - hoạt động trên mọi platform)
./docker-master start

# Hoặc platform-specific
bin\start.bat    # Windows
./bin/start.sh   # Linux/macOS

# Kiểm tra trạng thái
docker ps
```

### Bước 3: Tạo Platform Đầu Tiên
```bash
# AI tự động chọn cấu hình dựa trên tên
./docker-master create my-shop

# Kết quả tự động:
# ✅ Laravel 8.4 + MySQL (E-commerce detected)
# ✅ Domain: my-shop.io
# ✅ Port: 8010
# ✅ Database: my_shop_db
# ✅ Xdebug: Port 9084
```

> **📖 Chi tiết:** [Auto Platform Creation Guide](docs/developer-guide/AUTO-PLATFORM-CREATION.md)

### Bước 4: Truy Cập và Monitor (URLs 2025)
```bash
# Main Dashboard
http://localhost:8010

# Platform URLs
http://localhost:8010/laravel.php  # Laravel PHP 8.4 Welcome
http://localhost:8020              # Laravel PHP 7.4 Platform
http://localhost:8030              # WordPress PHP 7.4 Platform

# Development Tools
http://localhost:8010/test-db.php  # Database Connection Test
http://localhost:8010/phpinfo.php # PHP Info với Xdebug Status
http://localhost:8025              # Mailhog Email Testing

# Professional Domains (auto-configured)
http://my-shop.io                  # Your created platform
```

> **📖 Chi tiết:** [Quick Reference Guide](docs/user-guide/QUICK-REFERENCE.md) | [Debug Setup](docs/developer-guide/04-DEBUG-SETUP.md)

# Xdebug Testing
http://localhost:8010/phpinfo.php?XDEBUG_SESSION_START=VSCODE
http://localhost:8020/phpinfo.php?XDEBUG_SESSION_START=VSCODE
http://localhost:8030/phpinfo.php?XDEBUG_SESSION_START=VSCODE
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
# http://my-awesome-project.io

# Make changes and fast restart
fast-restart.bat
```

### Team Development:
```bash
# Setup domains once (as Administrator)
scripts\setup-domains.bat

# Share professional URLs
# http://user-api.io
# http://admin-panel.io
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

## 🆘 Support & Resources

### **📖 Documentation**
- **[Complete Documentation Index](docs/DOCUMENTATION-INDEX.md)** - All available guides
- **[Troubleshooting Guide](docs/troubleshooting/)** - Common issues và solutions
- **[Developer Guide](docs/developer-guide/)** - Advanced development topics
- **[Examples Guide](docs/EXAMPLES-GUIDE.md)** - Practical examples

### **🏗️ Architecture & Structure**
- **[Professional Structure](docs/architecture/FINAL-STRUCTURE-SUMMARY.md)** - Enterprise-level organization
- **[Configuration Guide](app/config/README.md)** - Configuration management
- **[Cross-Platform Setup](docs/user-guide/CROSS-PLATFORM-INSTALLATION.md)** - Multi-OS support

### **🔧 Development Tools**
- **[Auto Platform Creation](docs/developer-guide/AUTO-PLATFORM-CREATION.md)** - AI-powered platform generation
- **[Debug Setup](docs/developer-guide/04-DEBUG-SETUP.md)** - Xdebug configuration
- **[Quick Reference](docs/user-guide/QUICK-REFERENCE.md)** - Essential commands

---

**🌟 Professional Docker development environment with AI automation, cross-platform support, and enterprise-ready structure!**

**Made with ❤️ for developers who want zero-configuration, maximum productivity, and professional standards.**
