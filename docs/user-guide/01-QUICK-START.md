# ⚡ Bắt đầu nhanh - 1 phút tạo platform với Auto Domain!

> **Mục tiêu**: Tạo platform trong 1 phút với AI auto-detection + Auto domain routing!

## ✅ Yêu cầu

- **Docker Desktop** đã cài đặt và đang chạy
- **Windows 10/11** (hướng dẫn này cho Windows)

**Chưa có Docker?** → Tải tại https://docker.com/products/docker-desktop

## 🚀 1 lệnh duy nhất - Tất cả tự động!

### Khởi động toàn bộ hệ thống với Auto Domain:
```bash
# Di chuyển vào thư mục dự án
cd d:\www\docker_master

# Auto start toàn bộ hệ thống + setup domains
auto-start.bat
```

**🤖 Hệ thống sẽ tự động:**
- ✅ Khởi động tất cả core services
- ✅ Auto-setup domains cho tất cả platforms
- ✅ Khởi động tất cả platforms hiện có
- ✅ Tạo Nginx configurations
- ✅ Mở tất cả platforms trong browser

### Hoặc tạo platform mới ngay lập tức:
```bash
# Tạo WordPress blog với auto domain
create.bat my-blog

# Tạo Laravel API với auto domain
create.bat user-api

# Tạo E-commerce store với auto domain
create.bat online-shop
```

**🤖 AI + Auto System sẽ:**
- 🧠 **AI Detection**: Chọn database + PHP version + platform type
- 🌐 **Auto Domain**: Tạo domain [project].asmo-tranding.io
- 🔧 **Auto Nginx**: Tạo và reload Nginx config
- 🗄️ **Auto Database**: Tạo database với permissions
- ⚡ **Fast Restart**: Apply changes trong 0.1 giây
- 🚀 **Auto Start**: Container sẵn sàng ngay lập tức

## 🎉 Xong! Truy cập Platforms với Auto Domain

### 🌐 **Professional Domain URLs (Auto-configured):**

| Platform | Domain URL | Direct URL | Mô tả |
|----------|------------|------------|-------|
| **WordPress Blog** | http://my-blog.asmo-tranding.io | http://localhost:8015 | PHP 7.4 + MySQL + Xdebug |
| **Laravel API** | http://user-api.asmo-tranding.io | http://localhost:8016 | PHP 8.4 + PostgreSQL + Xdebug |
| **E-commerce Store** | http://online-shop.asmo-tranding.io | http://localhost:8017 | PHP 8.4 + MySQL + Xdebug |

### ✨ **Auto Features đã hoạt động:**
- ✅ **Domain routing**: Không cần nhớ port numbers
- ✅ **Nginx proxy**: Professional URLs
- ✅ **Auto SSL ready**: Sẵn sàng cho HTTPS
- ✅ **Fast restart**: Changes apply trong 0.1 giây
## 🗄️ Database & Tools (Auto-configured)

| Service | Connection | Credentials | Auto Features |
|---------|------------|-------------|---------------|
| **MySQL** | localhost:3306 | mysql_user / mysql_pass | Auto database creation |
| **PostgreSQL** | localhost:5432 | postgres_user / postgres_pass | Auto database creation |
| **Mailhog** | http://localhost:8025 | Email testing | Auto SMTP config |

## 🐛 Debug với VS Code (Auto Xdebug)

### Auto-assigned Xdebug Ports:
- **WordPress**: Port 9015 (auto-configured)
- **Laravel API**: Port 9016 (auto-configured)
- **E-commerce**: Port 9017 (auto-configured)

### VS Code Configuration (Auto-generated paths):
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
    },
    {
      "name": "User API Debug",
      "type": "php",
      "request": "launch",
      "port": 9016,
      "pathMappings": {
        "/var/www/html": "${workspaceFolder}/platforms/user-api/projects"
      }
    }
  ]
}
```

### 🔧 **Auto Debug Features:**
- ✅ **Auto port assignment**: Không conflict
- ✅ **Auto path mapping**: Đúng container paths
- ✅ **Auto Xdebug config**: PHP 7.4 & 8.4 support
- ✅ **Auto VS Code ready**: Copy-paste configuration

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
