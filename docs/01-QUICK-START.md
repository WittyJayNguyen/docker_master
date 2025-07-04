# ⚡ Bắt đầu nhanh - 5 phút chạy được dự án!

> **Mục tiêu**: Chạy được dự án trong 5 phút mà không cần hiểu gì cả!

## ✅ Yêu cầu

- **Docker Desktop** đã cài đặt và đang chạy
- **Windows 10/11** (hướng dẫn này cho Windows)

**Chưa có Docker?** → Tải tại https://docker.com/products/docker-desktop

## 🚀 3 bước đơn giản

### Bước 1: Kiểm tra Docker
Mở **Command Prompt** hoặc **PowerShell**:
```bash
docker --version
```

**Thấy version number?** ✅ Tiếp tục  
**Báo lỗi?** ❌ Cài Docker Desktop trước

### Bước 2: Setup dự án
```bash
# Di chuyển vào thư mục dự án
cd d:\www\docker_master

# Chạy setup (chỉ cần 1 lần)
.\scripts\setup.bat
```

**Đợi 2-3 phút** để Docker tải và build images...

### Bước 3: Khởi động
```bash
# Start tất cả services
.\scripts\start.bat
```

**Đợi 1-2 phút** để containers khởi động...

## 🎉 Xong! Truy cập ứng dụng

Mở browser và truy cập:

| Ứng dụng | URL | Mô tả |
|----------|-----|-------|
| **Laravel mới nhất** | http://localhost:8010 | PHP 8.4 + PostgreSQL |
| **Laravel cũ** | http://localhost:8011 | PHP 7.4 + PostgreSQL |
| **WordPress** | http://localhost:8012 | CMS phổ biến |
| **Quản lý MySQL** | http://localhost:8080 | phpMyAdmin |
| **Quản lý PostgreSQL** | http://localhost:8081 | pgAdmin |
| **Test Email** | http://localhost:8025 | Mailhog |

## 🔍 Kiểm tra hoạt động

### Test Laravel PHP 8.4
1. Truy cập: http://localhost:8010
2. **Thấy trang Laravel?** ✅ Thành công!

### Test WordPress  
1. Truy cập: http://localhost:8012
2. **Thấy trang WordPress?** ✅ Thành công!

## 🛑 Nếu có lỗi

### Containers không chạy
```bash
# Xem trạng thái
docker-compose ps

# Xem lỗi chi tiết
docker-compose logs
```

### Port bị chiếm
**Lỗi**: "Port 8010 is already in use"  
**Giải pháp**: Tắt ứng dụng đang dùng port đó hoặc đổi port

### Rebuild nếu cần
```bash
# Dừng tất cả
docker-compose down

# Build lại từ đầu
docker-compose build --no-cache

# Start lại
docker-compose up -d
```

## 🎯 Tiếp theo làm gì?

**Muốn hiểu rõ hơn?** → Đọc [02-STEP-BY-STEP.md](02-STEP-BY-STEP.md)

**Cần debug code?** → Đọc [04-DEBUG-SETUP.md](04-DEBUG-SETUP.md)

**Gặp lỗi khác?** → Đọc [06-TROUBLESHOOTING.md](06-TROUBLESHOOTING.md)

---

## 📱 Commands hữu ích

```bash
# Xem trạng thái containers
docker-compose ps

# Dừng tất cả
.\scripts\stop.bat

# Khởi động lại
.\scripts\restart.bat

# Xem logs
.\scripts\logs.bat
```

**🎉 Chúc mừng! Bạn đã chạy thành công Docker Master Platform!**
