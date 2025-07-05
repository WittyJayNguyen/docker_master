# 🐳 Docker Master Platform

> **Multi-platform Docker development environment với RAM optimization và auto-monitoring**

## ⚡ Quick Start - Chỉ một lệnh!

```bash
bin\start.bat
```

**Đợi 2-3 phút → Tất cả sẵn sàng!** 🚀

## 📁 Cấu trúc Project (Đã tối ưu)

```
docker_master/
├── 📂 bin/                    # Main executable scripts
│   ├── start.bat             # 🚀 Start all services
│   ├── stop.bat              # 🛑 Stop all services
│   ├── restart.bat           # 🔄 Restart all services
│   └── status.bat            # 📊 Check system status
│
├── 📂 config/                 # Configuration files
│   ├── docker-compose.override.yml    # RAM optimization
│   └── docker-compose.monitoring.yml  # Auto-monitoring
│
├── 📂 platforms/              # Platform definitions
├── 📂 scripts/               # Utility scripts
├── 📂 tools/                 # Development tools
├── 📂 data/                  # Persistent data
├── 📂 logs/                  # Application logs
├── 📂 projects/              # Your application code
├── 📂 docs/                  # Documentation
│
└── docker-compose.yml        # Main compose file
```

## 🌐 Services Available

| Service | URL | Credentials |
|---------|-----|-------------|
| **Laravel PHP 8.4** | http://localhost:8010 | - |
| **Laravel PHP 7.4** | http://localhost:8011 | - |
| **WordPress** | http://localhost:8012 | admin/admin |
| **phpMyAdmin** | http://localhost:8080 | root/rootpassword123 |
| **pgAdmin** | http://localhost:8081 | admin@example.com/admin123 |
| **Mailhog** | http://localhost:8025 | - |
| **RAM Dashboard** | http://localhost:8090 | - |

## 🗄️ Database Connections

| Database | Host | Port | Username | Password |
|----------|------|------|----------|----------|
| **PostgreSQL** | localhost | 5432 | postgres_user | postgres_pass |
| **MySQL** | localhost | 3306 | root | rootpassword123 |
| **Redis** | localhost | 6379 | - | - |

## 🎯 Key Features

### ⚡ One-Command Operation
```bash
bin\start.bat    # Start everything
bin\stop.bat     # Stop everything
bin\restart.bat  # Restart everything
bin\status.bat   # Check status
```

### 💾 RAM Optimization
- **~600MB total** thay vì 4-6GB
- **Memory limits** cho tất cả containers
- **Auto-optimization** khi start

### 🤖 Auto-Monitoring
- **Real-time monitoring** mỗi 30 giây
- **Web dashboard**: http://localhost:8090
- **Automatic alerts** khi RAM > 90%

## 🚀 Usage Examples

### Daily Workflow
```bash
# Morning - Start everything
bin\start.bat

# Check if everything is running
bin\status.bat

# Evening - Stop to save RAM
bin\stop.bat
```

### ⚠️ Troubleshooting - Database Connection Issues

**Nếu gặp lỗi phpMyAdmin "Không thể kết nối" hoặc MySQL/PostgreSQL không start:**

```bash
# Chạy script tự động khắc phục
scripts\fix-database-corruption.bat
```

**Nguyên nhân thường gặp:**
- Database files bị corrupted sau khi Git operations
- Containers restart liên tục
- Services không thể connect đến database

**Script sẽ tự động:**
- ✅ Stop tất cả services
- ✅ Xóa database directories bị corrupted
- ✅ Tạo lại fresh databases
- ✅ Restart tất cả services

### Development
```bash
# Monitor RAM usage
scripts\monitor-ram.bat

# View logs
docker-compose logs [service_name]
```

### Database Management
```bash
# Use Navicat with connection info above
# Or web interfaces:
start http://localhost:8080  # phpMyAdmin
start http://localhost:8081  # pgAdmin
```

## 📊 Performance

| Metric | Value |
|--------|-------|
| **Startup Time** | 2-3 phút |
| **RAM Usage** | ~600MB total |
| **CPU Usage** | <5% average |

## 📚 Documentation

- **[🆘 QUICK HELP](QUICK-HELP.md)** - Emergency commands & common issues
- **[🚨 TROUBLESHOOTING](TROUBLESHOOTING.md)** - Detailed problem solving
- **[RAM Optimization](docs/07-RAM-OPTIMIZATION.md)** - Chi tiết tối ưu RAM
- **[Auto-Monitoring](docs/08-AUTO-MONITORING.md)** - Hệ thống monitoring
- **[Scripts Guide](scripts/README.md)** - Utility scripts

## 🎉 Summary

**Docker Master Platform** cung cấp:

- ✅ **One-command operation** - Chỉ cần `start.bat`
- ✅ **RAM optimized** - Tiết kiệm 80% RAM
- ✅ **Auto-monitoring** - Web dashboard 24/7
- ✅ **Multi-platform** - Laravel, WordPress
- ✅ **Well-organized** - Cấu trúc rõ ràng

**🚀 Chỉ cần `bin\start.bat` và tất cả sẵn sàng!** 🎯
