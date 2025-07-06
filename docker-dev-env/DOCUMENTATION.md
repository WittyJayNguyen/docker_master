# 📚 Docker Development Environment - Documentation

Tổng hợp tất cả documentation cho Docker Development Environment với auto RAM optimization.

## 🎯 Chọn hướng dẫn phù hợp với bạn

### 👶 **Người mới bắt đầu (Chưa biết Docker)**
```
📋 docs/STEP_BY_STEP.md
└── Hướng dẫn từng bước chi tiết từ con số 0
    ├── Cài đặt Docker Desktop
    ├── Download source code  
    ├── Setup environment
    ├── Khởi động services
    ├── Tạo project đầu tiên
    └── Verify installation
```

### 🚀 **Người có kinh nghiệm (Biết Docker cơ bản)**
```
🚀 docs/INSTALLATION.md
└── Hướng dẫn cài đặt đầy đủ
    ├── System requirements
    ├── Docker setup
    ├── Environment configuration
    └── Advanced options
```

### ⚡ **Người muốn setup nhanh (5 phút)**
```
⚡ docs/QUICK_START.md
└── Hướng dẫn nhanh
    ├── Clone repository
    ├── Run setup script
    └── Start developing
```

## 🛠️ Setup Scripts (Recommended)

### **Automated Setup - Cho người mới:**
```bash
# Windows
bin\setup.bat

# Linux/macOS  
./bin/setup.sh
```
**Script sẽ tự động:**
- ✅ Check Docker installation
- ✅ Setup environment file
- ✅ Run RAM optimization
- ✅ Build và start services
- ✅ Create example project
- ✅ Verify installation

### **Manual Setup - Cho người có kinh nghiệm:**
```bash
# Windows
bin\dev.bat start

# Linux/macOS
./bin/dev.sh start
```

## 📖 Documentation Structure

### **📁 docs/ - Detailed Documentation**

| File | Mục đích | Đối tượng | Thời gian |
|------|----------|-----------|-----------|
| **[📋 STEP_BY_STEP.md](docs/STEP_BY_STEP.md)** | Hướng dẫn từng bước chi tiết | Người mới | 30-60 phút |
| **[🚀 INSTALLATION.md](docs/INSTALLATION.md)** | Hướng dẫn cài đặt đầy đủ | Có kinh nghiệm | 15-30 phút |
| **[⚡ QUICK_START.md](docs/QUICK_START.md)** | Hướng dẫn nhanh | Muốn setup nhanh | 5 phút |
| **[🔧 COMMANDS.md](docs/COMMANDS.md)** | Tổng hợp commands | Developers | Reference |
| **[🧠 AUTO_OPTIMIZATION.md](docs/AUTO_OPTIMIZATION.md)** | Auto RAM optimization | Advanced users | Reference |
| **[🚨 TROUBLESHOOTING.md](docs/TROUBLESHOOTING.md)** | Xử lý lỗi | Khi gặp vấn đề | As needed |
| **[📚 INDEX.md](docs/INDEX.md)** | Tổng hợp tất cả docs | Navigation | Reference |

### **📁 Root Files - Quick Access**

| File | Mục đích |
|------|----------|
| **[README.md](README.md)** | Overview và quick start |
| **[DOCUMENTATION.md](DOCUMENTATION.md)** | File này - Navigation |
| **[.env.example](.env.example)** | Environment template |
| **[docker-compose.yml](docker-compose.yml)** | Services configuration |

## 🎯 Quick Decision Tree

```
Bạn muốn gì?
│
├── 🆕 Setup lần đầu
│   ├── 👶 Chưa biết Docker → docs/STEP_BY_STEP.md
│   ├── 🚀 Biết Docker → docs/INSTALLATION.md  
│   └── ⚡ Setup nhanh → docs/QUICK_START.md
│
├── 🔧 Đang sử dụng
│   ├── 📖 Cần commands → docs/COMMANDS.md
│   ├── 🚨 Gặp lỗi → docs/TROUBLESHOOTING.md
│   └── 🧠 Tối ưu RAM → docs/AUTO_OPTIMIZATION.md
│
└── 📚 Tìm hiểu thêm → docs/INDEX.md
```

## 🚀 Recommended Setup Flow

### **🎯 Flow 1: Người mới (Recommended)**
```bash
1. 📖 Đọc docs/STEP_BY_STEP.md (10 phút)
2. 🛠️ Chạy bin\setup.bat hoặc ./bin/setup.sh
3. ✅ Verify installation
4. 🎉 Start developing!
```

### **🎯 Flow 2: Người có kinh nghiệm**
```bash
1. 📖 Scan docs/INSTALLATION.md (5 phút)
2. 🚀 Chạy bin\dev.bat start hoặc ./bin/dev.sh start
3. 📚 Bookmark docs/COMMANDS.md
4. 🎉 Start developing!
```

### **🎯 Flow 3: Muốn nhanh nhất**
```bash
1. 📖 Đọc docs/QUICK_START.md (2 phút)
2. ⚡ Copy-paste commands
3. 🎉 Done!
```

## 🌟 Key Features

### **✅ Auto RAM Optimization**
- Tự động phát hiện RAM của máy
- Dynamic configuration cho MySQL, PHP, Nginx
- Cross-platform support (Windows, macOS, Linux)
- Smart optimization profiles

### **✅ Multi-PHP Support**
- PHP 7.4, 8.2, 8.4 với Xdebug
- Isolated containers
- Easy switching between versions
- Production-ready configurations

### **✅ Complete Database Stack**
- MySQL 8.0 với optimization
- PostgreSQL 15
- Redis for caching
- Adminer và phpMyAdmin UI

### **✅ Developer-Friendly**
- Auto virtual host generation
- VS Code integration
- Comprehensive logging
- Easy project management

## 📊 System Requirements

| Component | Minimum | Recommended |
|-----------|---------|-------------|
| **RAM** | 4GB | 8GB+ |
| **Storage** | 10GB | 20GB+ |
| **OS** | Windows 10, macOS 10.14, Ubuntu 18.04 | Latest versions |
| **Docker** | Docker Desktop latest | Docker Desktop latest |

## 🎯 Quick Access URLs

Sau khi setup thành công:

| Service | URL | Purpose |
|---------|-----|---------|
| **Main Page** | http://localhost | Environment overview |
| **Database Test** | http://localhost/test-db.php | Test connections |
| **RAM Status** | http://localhost/ram-optimization.php | Optimization info |
| **Adminer** | http://localhost:8080 | Database management |
| **phpMyAdmin** | http://localhost:8081 | MySQL management |

## 🆘 Need Help?

### **Quick Fixes:**
```bash
# Restart services
docker-compose restart

# Check status  
docker-compose ps

# View logs
docker-compose logs
```

### **Documentation:**
1. **🚨 [TROUBLESHOOTING.md](docs/TROUBLESHOOTING.md)** - Xử lý lỗi thường gặp
2. **🔧 [COMMANDS.md](docs/COMMANDS.md)** - Command reference
3. **📚 [INDEX.md](docs/INDEX.md)** - Navigation tất cả docs

### **Emergency Reset:**
```bash
# Nuclear option
docker-compose down -v
docker system prune -a --volumes
bin\dev.bat start  # Windows
./bin/dev.sh start # Linux/macOS
```

## 🎉 Success Indicators

Bạn đã setup thành công khi:
- ✅ Tất cả containers đang chạy (`docker-compose ps`)
- ✅ http://localhost hiển thị PHP info
- ✅ http://localhost/test-db.php shows database connections
- ✅ Có thể tạo project mới
- ✅ Virtual hosts hoạt động

---

## 🚀 Ready to Start?

### **👶 Người mới:**
```bash
📖 Đọc docs/STEP_BY_STEP.md
🛠️ Chạy bin\setup.bat (Windows) hoặc ./bin/setup.sh (Linux/macOS)
```

### **🚀 Có kinh nghiệm:**
```bash
📖 Scan docs/INSTALLATION.md  
🚀 Chạy bin\dev.bat start (Windows) hoặc ./bin/dev.sh start (Linux/macOS)
```

### **⚡ Muốn nhanh:**
```bash
📖 docs/QUICK_START.md
⚡ Copy-paste commands
```

---

**💡 Tip: Bookmark file này để dễ dàng navigate đến documentation phù hợp!**
