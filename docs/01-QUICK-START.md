# ⚡ Bắt đầu nhanh - 2 phút tạo platform!

> **Mục tiêu**: Tạo được platform trong 2 phút với AI auto-detection!

## ✅ Yêu cầu

- **Docker Desktop** đã cài đặt và đang chạy
- **Windows 10/11** (hướng dẫn này cho Windows)

**Chưa có Docker?** → Tải tại https://docker.com/products/docker-desktop

## 🚀 2 bước siêu đơn giản

### Bước 1: Khởi động Core Services
Mở **Command Prompt** hoặc **PowerShell**:
```bash
# Di chuyển vào thư mục dự án
cd d:\www\docker_master

# Khởi động database services (MySQL + PostgreSQL)
docker-compose -f docker-compose.low-ram.yml up -d
```

**Đợi 1-2 phút** để databases khởi động...

### Bước 2: Tạo Platform Tự Động
```bash
# Tạo WordPress blog (AI chọn MySQL + PHP 7.4)
create.bat my-blog

# Tạo Laravel API (AI chọn PostgreSQL + PHP 8.4)
create.bat user-api

# Tạo E-commerce store (AI chọn MySQL + PHP 8.4)
create.bat online-shop
```

**🤖 AI sẽ tự động:**
- Chọn database phù hợp (MySQL/PostgreSQL)
- Chọn PHP version (7.4/8.4)
- Assign ports tự động
- Cấu hình Xdebug
- Tạo database và container

## 🎉 Xong! Truy cập Platforms

Mở browser và truy cập:

| Platform | URL | Mô tả |
|----------|-----|-------|
| **WordPress Blog** | http://localhost:8015 | PHP 7.4 + MySQL + Xdebug |
| **Laravel API** | http://localhost:8016 | PHP 8.4 + PostgreSQL + Xdebug |
| **E-commerce Store** | http://localhost:8017 | PHP 8.4 + MySQL + Xdebug |
## 🗄️ Database & Tools

| Service | Connection | Credentials |
|---------|------------|-------------|
| **MySQL** | localhost:3306 | mysql_user / mysql_pass |
| **PostgreSQL** | localhost:5432 | postgres_user / postgres_pass |
| **Mailhog** | http://localhost:8025 | Email testing |

## 🐛 Debug với VS Code

### Xdebug Ports:
- **WordPress**: Port 9015
- **Laravel API**: Port 9016
- **E-commerce**: Port 9017

### VS Code Configuration:
```json
{
  "version": "0.2.0",
  "configurations": [
    {
      "name": "WordPress Debug",
      "type": "php",
      "request": "launch",
      "port": 9015,
      "pathMappings": {
        "/app": "${workspaceFolder}/platforms/my-blog/projects"
      }
    }
  ]
}
```

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
