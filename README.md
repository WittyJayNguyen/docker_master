# 🐳 Docker Master Platform - Auto Domain & Fast Restart

> **Hệ thống phát triển Docker với AI Auto-Detection + Auto Domain + Fast Restart**

## 🌟 Tính năng Auto Features

- **🤖 AI Auto-Detection**: Tự động chọn database, PHP version, platform type
- **🌐 Auto Domain**: Tự động tạo domain [project].asmo-tranding.io với Nginx routing
- **⚡ Fast Restart**: Apply changes trong 0.1 giây với smart restart system
- **🗄️ Auto Database**: Tự động tạo database với permissions phù hợp
- **🔧 Auto Nginx**: Tự động tạo và reload Nginx configuration
- **🐛 Auto Debug**: Xdebug tự động cho PHP 7.4 & 8.4
- **🚀 One Command**: Tạo platform hoàn chỉnh với 1 lệnh duy nhất
- **📊 Memory Optimized**: Toàn bộ hệ thống dưới 1.5GB RAM

## ⚡ Quick Start - 1 phút

### Khởi động toàn bộ hệ thống:
```bash
auto-start.bat
```

### Tạo platform mới với auto features:
```bash
create.bat my-blog           # → WordPress + MySQL + my-blog.asmo-tranding.io
create.bat user-api          # → Laravel + PostgreSQL + user-api.asmo-tranding.io
create.bat online-shop       # → E-commerce + MySQL + online-shop.asmo-tranding.io
```

### Fast restart cho changes:
```bash
fast-restart.bat             # → 0.1 giây apply changes
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
