# 📚 Docker Master Platform 2025 - Documentation

> **Phiên bản 2025 - Multi-PHP, Dual-Database, Xdebug Ready**

## 🎯 Hướng dẫn theo cấp độ

### 👶 Người mới bắt đầu
1. **[Quick Reference 2025](QUICK-REFERENCE-2025.md)** 🚀
   - Tất cả URLs, credentials, commands mới nhất
   - Multi-PHP, Dual-Database, Xdebug ready
   - Copy-paste commands

2. **[Bắt đầu nhanh - 5 phút](01-QUICK-START.md)** ⚡
   - Chỉ 3 bước đơn giản để chạy dự án
   - Không cần hiểu sâu, chỉ cần chạy được

3. **[Hướng dẫn từng bước](02-STEP-BY-STEP.md)** 📖
   - Chi tiết từ A-Z
   - Giải thích từng bước làm gì
   - Troubleshooting cơ bản

### 🧑‍💻 Người có kinh nghiệm
3. **[Hướng dẫn phát triển](03-DEVELOPMENT.md)** 🛠️
   - Cấu trúc dự án
   - Tạo platform mới
   - Best practices

4. **[Cấu hình Debug](04-DEBUG-SETUP.md)** 🐛
   - Setup Xdebug cho PHP 7.4 & 8.4
   - Cấu hình IDE (VS Code, PhpStorm)
   - Test debugging

### 🔧 Quản trị viên
5. **[Quản lý hệ thống](05-SYSTEM-MANAGEMENT.md)** ⚙️
   - Docker commands
   - Database management
   - Performance tuning

6. **[Troubleshooting](06-TROUBLESHOOTING.md)** 🚨
   - Các lỗi thường gặp
   - Cách khắc phục
   - Debug containers

7. **[Auto-Discovery Platform](07-AUTO-DISCOVERY.md)** 🤖
   - Tạo platform với 1 lệnh
   - AI tự động phát hiện loại platform
   - Hướng dẫn sử dụng Auto-Discovery

## 🚀 Quick Access

### URLs chính
- **Laravel PHP 8.4**: http://localhost:8010
- **Laravel PHP 7.4**: http://localhost:8011
- **WordPress**: http://localhost:8012
- **phpMyAdmin**: http://localhost:8080
- **pgAdmin**: http://localhost:8081
- **Mailhog**: http://localhost:8025

### Commands nhanh
```bash
# Tạo platform mới (AUTO-DISCOVERY)
create.bat my-shop

# Setup lần đầu
.\scripts\setup.bat

# Start/Stop
.\scripts\start.bat
.\scripts\stop.bat

# Xem trạng thái
docker-compose ps
```

## 📋 Danh sách tài liệu

| File | Mô tả | Đối tượng |
|------|-------|-----------|
| [01-QUICK-START.md](01-QUICK-START.md) | Chạy nhanh trong 5 phút | Người mới |
| [02-STEP-BY-STEP.md](02-STEP-BY-STEP.md) | Hướng dẫn chi tiết từng bước | Người mới |
| [03-DEVELOPMENT.md](03-DEVELOPMENT.md) | Phát triển và tùy chỉnh | Developer |
| [04-DEBUG-SETUP.md](04-DEBUG-SETUP.md) | Cấu hình debug Xdebug | Developer |
| [05-SYSTEM-MANAGEMENT.md](05-SYSTEM-MANAGEMENT.md) | Quản lý hệ thống | Admin |
| [06-TROUBLESHOOTING.md](06-TROUBLESHOOTING.md) | Khắc phục sự cố | Tất cả |
| [07-AUTO-DISCOVERY.md](07-AUTO-DISCOVERY.md) | Auto-Discovery Platform | Tất cả |
| [07-RAM-OPTIMIZATION.md](07-RAM-OPTIMIZATION.md) | Tối ưu RAM (4GB→2GB) | Admin |
| [08-AUTO-MONITORING.md](08-AUTO-MONITORING.md) | Auto-monitor 24/7 | Admin |

## 🎯 Bắt đầu từ đâu?

**Chưa bao giờ dùng Docker?** → [01-QUICK-START.md](01-QUICK-START.md)

**Muốn hiểu rõ từng bước?** → [02-STEP-BY-STEP.md](02-STEP-BY-STEP.md)

**Cần debug code?** → [04-DEBUG-SETUP.md](04-DEBUG-SETUP.md)

**Gặp lỗi?** → [06-TROUBLESHOOTING.md](06-TROUBLESHOOTING.md)

**RAM cao?** → [07-RAM-OPTIMIZATION.md](07-RAM-OPTIMIZATION.md)

**Cần monitor 24/7?** → [08-AUTO-MONITORING.md](08-AUTO-MONITORING.md)

---

**💡 Tip**: Bắt đầu với file 01-QUICK-START.md để chạy được dự án, sau đó đọc các file khác khi cần!

---

## 📋 Tóm tắt nội dung từng file

### [01-QUICK-START.md](01-QUICK-START.md) ⚡
- ✅ Yêu cầu hệ thống
- 🚀 3 bước đơn giản chạy dự án
- 🌐 URLs truy cập
- 🛑 Khắc phục lỗi cơ bản

### [02-STEP-BY-STEP.md](02-STEP-BY-STEP.md) 📖
- 📋 Tổng quan dự án
- 🏗️ Cấu trúc thư mục
- 🔧 Setup chi tiết từng bước
- 🗄️ Database management
- 💡 Development workflow

### [03-DEVELOPMENT.md](03-DEVELOPMENT.md) 🛠️
- 🆕 Tạo platform mới
- 🔧 Tùy chỉnh cấu hình
- 🐳 Custom Dockerfiles
- 📊 Monitoring & logging
- 🚀 Production deployment

### [04-DEBUG-SETUP.md](04-DEBUG-SETUP.md) 🐛
- ✅ Xdebug đã cài sẵn
- 🔧 Setup VS Code & PhpStorm
- 🧪 Test files có sẵn
- 🎯 Debug workflow
- 🐛 Troubleshooting debug

### [05-SYSTEM-MANAGEMENT.md](05-SYSTEM-MANAGEMENT.md) ⚙️
- 🐳 Docker management
- 📊 Monitoring & performance
- 🗄️ Database operations
- 🔒 Security & backup
- 📈 Scaling strategies

### [06-TROUBLESHOOTING.md](06-TROUBLESHOOTING.md) 🚨
- 🔍 Chẩn đoán nhanh
- 🐳 Lỗi Docker thường gặp
- 🚢 Lỗi Container
- 🌐 Lỗi Port & Network
- 🔄 Reset hoàn toàn
