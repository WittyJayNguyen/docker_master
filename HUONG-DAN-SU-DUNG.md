# 🐳 Docker Master Platform - Hướng Dẫn Sử Dụng Hoàn Chỉnh

## 📋 Mục Lục
1. [Giới thiệu](#giới-thiệu)
2. [Cài đặt ban đầu](#cài-đặt-ban-đầu)
3. [Tạo Platform tự động (Auto-Discovery)](#tạo-platform-tự-động)
4. [Quản lý Platform](#quản-lý-platform)
5. [Troubleshooting](#troubleshooting)
6. [Ví dụ thực tế](#ví-dụ-thực-tế)

---

## 🎯 Giới thiệu

Docker Master Platform là hệ thống tạo website/ứng dụng **hoàn toàn tự động** chỉ với **1 lệnh duy nhất**.

### ✨ Điều kỳ diệu
```bash
# Chỉ cần gõ lệnh này:
create.bat my-shop

# Hệ thống sẽ tự động:
# ✅ Phát hiện đây là E-commerce
# ✅ Tạo Laravel + PostgreSQL + Redis
# ✅ Cấu hình database
# ✅ Khởi động website
# ✅ Mở browser: http://localhost:8015
```

### 🎁 Bạn nhận được gì?
- **Website hoàn chỉnh** chạy ngay lập tức
- **Database** đã được tạo và kết nối
- **Cấu hình tối ưu** cho development
- **Tài liệu** hướng dẫn riêng cho từng project

---

## 🚀 Cài đặt ban đầu

### Bước 1: Kiểm tra Docker
```bash
# Mở Command Prompt và gõ:
docker --version
```
**Nếu báo lỗi:** Cài Docker Desktop từ https://docker.com

### Bước 2: Khởi động Docker Master
```bash
# Di chuyển vào thư mục docker_master
cd D:\www\docker_master

# Khởi động hệ thống cơ bản
docker-compose -f docker-compose.low-ram.yml up -d
```

### Bước 3: Kiểm tra hệ thống
```bash
# Xem các service đang chạy
docker ps
```

**Bạn sẽ thấy:**
- `postgres_low_ram` - Database chính
- `redis_low_ram` - Cache
- `mailhog_low_ram` - Email testing
- Và các service khác

### Bước 4: Truy cập Dashboard
- **Monitor**: http://localhost:8090
- **Mailhog**: http://localhost:8025

---

## 🤖 Tạo Platform tự động (Auto-Discovery)

### 🎯 Lệnh chính - CHỈ CẦN NHỚ CÁI NÀY!

```bash
create.bat [tên-project-của-bạn]
```

### 📝 Quy tắc đặt tên (AI sẽ tự hiểu)

#### 🛒 Muốn tạo E-commerce? Dùng từ khóa:
- `shop`, `store`, `ecommerce`, `delivery`, `food`, `cafe`, `restaurant`

**Ví dụ:**
```bash
create.bat my-shop          # → Cửa hàng online
create.bat food-delivery    # → App giao đồ ăn
create.bat coffee-store     # → Cửa hàng cà phê
create.bat book-shop        # → Cửa hàng sách
```

#### 📝 Muốn tạo Website/Blog? Dùng từ khóa:
- `blog`, `news`, `cms`, `website`, `portfolio`

**Ví dụ:**
```bash
create.bat my-blog          # → Blog cá nhân
create.bat news-portal      # → Website tin tức
create.bat company-website  # → Website công ty
create.bat my-portfolio     # → Portfolio cá nhân
```

#### 🚀 Muốn tạo API? Dùng từ khóa:
- `api`, `service`, `backend`

**Ví dụ:**
```bash
create.bat user-api         # → API quản lý user
create.bat payment-service  # → Service thanh toán
create.bat auth-backend     # → Backend xác thực
```

### 🔄 Quá trình tự động diễn ra

Khi bạn chạy lệnh, hệ thống sẽ:

1. **🤖 AI phân tích tên** → Chọn loại platform phù hợp
2. **📁 Tạo thư mục** → Cấu trúc project hoàn chỉnh
3. **🗄️ Tạo database** → PostgreSQL với tên phù hợp
4. **⚙️ Tạo cấu hình** → Docker, PHP, Apache
5. **🚀 Khởi động** → Build và start container
6. **🌐 Mở browser** → Hiển thị website của bạn

### 📊 Kết quả nhận được

Sau khi chạy lệnh, bạn sẽ có:

```
📁 Cấu trúc project:
platforms/my-shop/
├── docker-compose.my-shop.yml  # Cấu hình riêng
├── README.md                   # Hướng dẫn riêng

projects/my-shop/
├── index.php                   # Code ứng dụng

🗄️ Database: my_shop_db (tự động tạo)
🌐 URL: http://localhost:8015 (tự động mở)
🐛 Debug: localhost:9015 (Xdebug)
```

---

## 🛠️ Quản lý Platform

### 📊 Xem Platform đang chạy
```bash
# Xem tất cả containers
docker ps

# Chỉ xem platforms
docker ps --filter "name=_php"
```

### 🌐 Truy cập Platform
```bash
# Mở website trong browser
start http://localhost:8015

# Hoặc gõ trực tiếp vào browser:
# http://localhost:8015
# http://localhost:8016
# http://localhost:8017
```

### 📝 Xem logs
```bash
# Xem logs của platform
docker logs my-shop_php84

# Xem logs realtime
docker logs -f my-shop_php84
```

### 🔧 Truy cập shell (cho developer)
```bash
# Vào bên trong container
docker exec -it my-shop_php84 bash

# Sau đó có thể chạy các lệnh PHP, composer, etc.
```

### ⏹️ Dừng Platform
```bash
# Dừng 1 platform cụ thể
cd platforms/my-shop
docker-compose -f docker-compose.my-shop.yml down

# Dừng tất cả
docker-compose -f docker-compose.low-ram.yml down
```

### 🔄 Restart Platform
```bash
# Restart 1 platform
cd platforms/my-shop
docker-compose -f docker-compose.my-shop.yml restart

# Restart tất cả
docker-compose -f docker-compose.low-ram.yml restart
```

---

## 🔧 Troubleshooting

### ❌ Lỗi "Docker not found"
**Nguyên nhân:** Docker chưa cài hoặc chưa khởi động

**Giải pháp:**
1. Cài Docker Desktop
2. Khởi động Docker Desktop
3. Đợi icon Docker màu xanh

### ❌ Lỗi "Port already in use"
**Nguyên nhân:** Port đã được sử dụng

**Giải pháp:**
```bash
# Xem port nào đang dùng
netstat -an | findstr :8015

# Dừng service đang dùng port đó
docker stop [container-name]
```

### ❌ Website không mở được
**Nguyên nhân:** Container chưa start xong

**Giải pháp:**
```bash
# Kiểm tra trạng thái
docker ps

# Xem logs để biết lỗi
docker logs [container-name]

# Đợi thêm 1-2 phút rồi thử lại
```

### ❌ Database connection failed
**Nguyên nhân:** Database chưa được tạo hoặc tên sai

**Giải pháp:**
```bash
# Chạy script sửa database
scripts\fix-platform-databases.bat

# Hoặc tạo database thủ công
docker exec postgres_low_ram psql -U postgres_user -d postgres -c "CREATE DATABASE my_shop_db;"
```

### 🆘 Script khắc phục tự động
```bash
# Sửa tất cả vấn đề database
scripts\fix-platform-databases.bat

# Tối ưu hệ thống
scripts\one-click-optimize.bat

# Hiển thị trạng thái tổng quan
scripts\final-test-all.bat
```

---

## 🎯 Ví dụ thực tế

### Ví dụ 1: Tạo cửa hàng cà phê online

```bash
# Bước 1: Tạo platform
create.bat coffee-paradise

# Bước 2: Đợi hệ thống tự động tạo (30 giây)
# Bước 3: Website tự động mở: http://localhost:8015
# Bước 4: Bắt đầu customize code trong projects/coffee-paradise/
```

**Kết quả:**
- ✅ E-commerce platform với Laravel 8.4
- ✅ Database: `coffee_paradise_db`
- ✅ Sẵn sàng cho: sản phẩm, giỏ hàng, thanh toán

### Ví dụ 2: Tạo blog công nghệ

```bash
# Bước 1: Tạo platform
create.bat tech-blog

# Bước 2: Website tự động mở: http://localhost:8016
# Bước 3: Cài WordPress hoặc customize code
```

**Kết quả:**
- ✅ WordPress platform với PHP 7.4
- ✅ Database: `tech_blog_db`
- ✅ Sẵn sàng cho: bài viết, comments, SEO

### Ví dụ 3: Tạo API cho mobile app

```bash
# Bước 1: Tạo platform
create.bat mobile-api

# Bước 2: Website tự động mở: http://localhost:8017
# Bước 3: Phát triển API endpoints
```

**Kết quả:**
- ✅ Laravel 8.4 API với Redis
- ✅ Database: `mobile_api_db`
- ✅ Sẵn sàng cho: REST API, authentication, caching

---

## 🎉 Tóm tắt - Nhớ những điều này!

### 🚀 Lệnh chính (quan trọng nhất)
```bash
create.bat [tên-project]
```

### 🎯 Quy tắc đặt tên
- **E-commerce:** dùng từ `shop`, `store`, `food`, `delivery`
- **Website/Blog:** dùng từ `blog`, `news`, `website`, `portfolio`  
- **API:** dùng từ `api`, `service`, `backend`

### 🌐 URLs mặc định
- Platform đầu tiên: http://localhost:8015
- Platform thứ hai: http://localhost:8016
- Platform thứ ba: http://localhost:8017

### 🛠️ Lệnh quản lý cơ bản
```bash
docker ps                    # Xem platforms đang chạy
docker logs [container]      # Xem logs
docker restart [container]   # Restart platform
```

### 🆘 Khi gặp lỗi
```bash
scripts\fix-platform-databases.bat    # Sửa database
scripts\one-click-optimize.bat        # Tối ưu hệ thống
```

---

---

## 📚 Phần Bổ Sung - Chi Tiết Từng Bước

### 🔍 Bước 1: Chuẩn bị môi trường (Chỉ làm 1 lần)

#### 1.1 Kiểm tra Docker Desktop
```bash
# Mở Command Prompt (cmd) và gõ:
docker --version

# Nếu thấy: Docker version 20.x.x → OK
# Nếu báo lỗi → Cài Docker Desktop
```

#### 1.2 Khởi động Docker Master lần đầu
```bash
# Bước 1: Mở Command Prompt
# Bước 2: Di chuyển vào thư mục
cd D:\www\docker_master

# Bước 3: Khởi động hệ thống
docker-compose -f docker-compose.low-ram.yml up -d

# Bước 4: Đợi 2-3 phút để tất cả service khởi động
```

#### 1.3 Kiểm tra hệ thống hoạt động
```bash
# Xem các service
docker ps

# Mở dashboard
start http://localhost:8090
start http://localhost:8025
```

### 🎯 Bước 2: Tạo Platform đầu tiên (Ví dụ cụ thể)

#### 2.1 Tạo cửa hàng online
```bash
# Trong Command Prompt, gõ:
create.bat my-online-shop

# Hệ thống sẽ hiển thị:
# 🤖 AI Auto-Detection Results:
#   • Project Name: my-online-shop
#   • Detected Type: E-commerce store
#   • Platform: ecommerce
#   • Port: 8015
#   • PHP Version: 84
#   • Xdebug: 9015
```

#### 2.2 Theo dõi quá trình tạo
```
🏗️ Creating platform structure...
✅ Directories created

ℹ️ Creating database: my_online_shop_db
✅ Database my_online_shop_db created

ℹ️ Creating docker-compose configuration...
✅ Platform docker-compose created

ℹ️ Creating application files...
✅ Platform created successfully!

🚀 Starting platform...
✅ Platform is running successfully!
```

#### 2.3 Kết quả nhận được
- **Website**: http://localhost:8015 (tự động mở)
- **Database**: `my_online_shop_db` (đã tạo sẵn)
- **Files**: Trong `projects/my-online-shop/`
- **Config**: Trong `platforms/my-online-shop/`

### 🔄 Bước 3: Tạo thêm Platform khác

#### 3.1 Tạo blog cá nhân
```bash
create.bat my-personal-blog

# Kết quả:
# • Detected Type: WordPress blog
# • Port: 8016 (tự động gán port tiếp theo)
# • URL: http://localhost:8016
```

#### 3.2 Tạo API service
```bash
create.bat user-management-api

# Kết quả:
# • Detected Type: Laravel API
# • Port: 8017
# • URL: http://localhost:8017
```

### 📊 Bước 4: Quản lý nhiều Platform

#### 4.1 Xem tất cả Platform đang chạy
```bash
docker ps --filter "name=_php"

# Kết quả sẽ hiển thị:
# my-online-shop_php84    Up 10 minutes   0.0.0.0:8015->80/tcp
# my-personal-blog_php74  Up 5 minutes    0.0.0.0:8016->80/tcp
# user-management-api_php84 Up 2 minutes  0.0.0.0:8017->80/tcp
```

#### 4.2 Truy cập từng Platform
```bash
# Cửa hàng online
start http://localhost:8015

# Blog cá nhân
start http://localhost:8016

# API service
start http://localhost:8017
```

#### 4.3 Quản lý riêng từng Platform
```bash
# Dừng cửa hàng online
cd platforms/my-online-shop
docker-compose -f docker-compose.my-online-shop.yml down

# Khởi động lại blog
cd platforms/my-personal-blog
docker-compose -f docker-compose.my-personal-blog.yml restart

# Xem logs API
docker logs user-management-api_php84
```

### 🗄️ Bước 5: Làm việc với Database

#### 5.1 Xem tất cả Database
```bash
docker exec postgres_low_ram psql -U postgres_user -d postgres -c "\l"

# Sẽ thấy:
# my_online_shop_db
# my_personal_blog_db
# user_management_api_db
```

#### 5.2 Kết nối Database từ code
```php
// Trong file projects/my-online-shop/index.php
$pdo = new PDO(
    "pgsql:host=postgres_low_ram;dbname=my_online_shop_db",
    "postgres_user",
    "postgres_pass"
);
```

#### 5.3 Kết nối Database từ tool (Navicat, phpMyAdmin)
```
Host: localhost
Port: 5432
Database: my_online_shop_db
Username: postgres_user
Password: postgres_pass
```

### 🎨 Bước 6: Customize Platform

#### 6.1 Chỉnh sửa code
```bash
# Mở VS Code
code projects/my-online-shop/

# Hoặc mở bằng editor khác
notepad projects/my-online-shop/index.php
```

#### 6.2 Thêm file mới
```bash
# Tạo file trong projects/my-online-shop/
# Ví dụ: products.php, cart.php, checkout.php
```

#### 6.3 Cài thêm package (nếu cần)
```bash
# Vào trong container
docker exec -it my-online-shop_php84 bash

# Cài Composer packages
composer install
composer require laravel/framework
```

### 🔧 Bước 7: Debug và Development

#### 7.1 Xdebug đã được cấu hình sẵn
```
Platform: my-online-shop
Xdebug Port: 9015

Platform: my-personal-blog
Xdebug Port: 9016

Platform: user-management-api
Xdebug Port: 9017
```

#### 7.2 Cấu hình VS Code cho Debug
```json
// .vscode/launch.json
{
    "name": "Debug my-online-shop",
    "type": "php",
    "request": "launch",
    "port": 9015,
    "pathMappings": {
        "/var/www/html": "${workspaceFolder}/projects/my-online-shop"
    }
}
```

### 🚨 Bước 8: Xử lý lỗi thường gặp

#### 8.1 Platform không khởi động
```bash
# Xem lỗi chi tiết
docker logs my-online-shop_php84

# Restart platform
cd platforms/my-online-shop
docker-compose -f docker-compose.my-online-shop.yml restart
```

#### 8.2 Database connection failed
```bash
# Chạy script sửa tự động
scripts\fix-platform-databases.bat

# Hoặc tạo database thủ công
docker exec postgres_low_ram psql -U postgres_user -d postgres -c "CREATE DATABASE my_online_shop_db;"
```

#### 8.3 Port conflict
```bash
# Xem port nào đang dùng
netstat -an | findstr :8015

# Dừng service đang dùng port
docker stop [container-using-port]
```

### 📈 Bước 9: Tối ưu và Maintenance

#### 9.1 Tối ưu hệ thống định kỳ
```bash
# Chạy hàng tuần
scripts\one-click-optimize.bat

# Tối ưu toàn diện (hàng tháng)
scripts\ultimate-optimize.bat
```

#### 9.2 Backup dữ liệu
```bash
# Backup database
docker exec postgres_low_ram pg_dump -U postgres_user my_online_shop_db > backup.sql

# Backup code
xcopy projects\my-online-shop backup\my-online-shop\ /E /I
```

#### 9.3 Monitor resource usage
```bash
# Xem RAM/CPU usage
docker stats

# Xem disk usage
docker system df
```

---

## 🎓 Kết luận - Bạn đã học được gì?

### ✅ Kỹ năng đã có:
1. **Tạo platform tự động** với 1 lệnh
2. **Quản lý nhiều project** cùng lúc
3. **Làm việc với database** PostgreSQL
4. **Debug và development** với Xdebug
5. **Xử lý lỗi** cơ bản
6. **Tối ưu hệ thống** định kỳ

### 🚀 Bước tiếp theo:
1. **Thực hành** tạo nhiều platform khác nhau
2. **Customize code** theo nhu cầu dự án
3. **Deploy production** khi sẵn sàng
4. **Chia sẻ kiến thức** với team

### 💡 Nhớ những điều quan trọng:
- **Lệnh chính**: `create.bat [tên-project]`
- **Quy tắc đặt tên**: Dùng từ khóa mô tả dự án
- **URLs**: Bắt đầu từ localhost:8015
- **Khi gặp lỗi**: Chạy scripts trong thư mục `scripts/`

**🌟 Chúc bạn thành công với Docker Master Platform!**

*Từ giờ, việc tạo website/app chỉ mất 30 giây thay vì 30 phút!*
