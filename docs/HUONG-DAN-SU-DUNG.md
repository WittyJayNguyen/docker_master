# 🐳 Docker Master Platform - Hướng Dẫn Sử Dụng Hoàn Chỉnh

> **Phiên bản mới nhất**: 2025.01 - Cập nhật đầy đủ với Multi-PHP, Xdebug, Auto-Platform Creation

## 📋 Mục Lục
1. [Khởi động nhanh](#khởi-động-nhanh)
2. [Dashboard và Monitoring](#dashboard-và-monitoring)
3. [Platform URLs và Xdebug](#platform-urls-và-xdebug)
4. [Tạo Platform tự động](#tạo-platform-tự-động)
5. [Quản lý Platform](#quản-lý-platform)
6. [Database và Tools](#database-và-tools)
7. [Troubleshooting](#troubleshooting)
8. [Ví dụ thực tế](#ví-dụ-thực-tế)

---

## 🚀 Khởi động nhanh

### ⚡ Khởi động hệ thống (1 lệnh)
```bash
# Di chuyển vào thư mục docker_master
cd D:\www\docker_master

# Khởi động toàn bộ hệ thống
docker-compose -f docker-compose.low-ram.yml up -d

# Hoặc dùng script tự động
bin\auto-start.bat
```

**Hệ thống sẽ tự động:**
- ✅ Khởi động tất cả services (MySQL, PostgreSQL, Redis, Nginx)
- ✅ Multi-PHP environments (7.4 & 8.4) với Xdebug
- ✅ Cấu hình database connections
- ✅ Mở dashboard trong browser
- ✅ Sẵn sàng tạo platforms

### 🎯 Tạo Platform đầu tiên
```bash
# Tạo cửa hàng online
bin\create.bat my-shop

# Hệ thống AI sẽ tự động:
# ✅ Phát hiện đây là E-commerce
# ✅ Tạo Laravel PHP 8.4 + PostgreSQL + Redis
# ✅ Cấu hình database và domain
# ✅ Khởi động website: http://localhost:8010
```

### 🎁 Bạn nhận được gì?
- **🌐 Main Dashboard**: http://localhost:8010 (Laravel PHP 8.4)
- **🔗 Platform URLs**:
  - Laravel PHP 8.4: http://localhost:8010/laravel.php
  - Laravel PHP 7.4: http://localhost:8020
  - WordPress PHP 7.4: http://localhost:8030
- **🧪 Database Test**: http://localhost:8010/test-db.php
- **📋 PHP Info**: http://localhost:8010/phpinfo.php
- **📧 Email Testing**: http://localhost:8025 (Mailhog)
- **🐛 Xdebug Ready**: Ports 9074, 9084, 9075

---

## 🎛️ Dashboard và Monitoring

### 🏠 Dashboard Chính
**URL**: http://localhost

**Tính năng:**
- 📊 Tổng quan hệ thống (containers, databases, platforms)
- 🔗 Quick links đến tất cả services
- 📈 Thống kê real-time
- 🛠️ Tools quản lý nhanh

### 📊 RAM Optimization Monitor
**URL**: http://localhost/ram-optimization.php

**Tính năng:**
- 💾 Hiển thị RAM usage hiện tại
- ⚡ Auto-detect RAM và đề xuất profile tối ưu
- 🔧 Tối ưu containers theo RAM available
- 📈 Lịch sử sử dụng memory

### 🧪 Database Connection Tester
**URL**: http://localhost/test-db.php

**Tính năng:**
- ✅ Test kết nối MySQL, PostgreSQL, Redis
- 📋 Hiển thị thông tin connection
- 🔍 Debug database issues
- 📊 Performance metrics

### 🌐 Platform URLs và Xdebug Testing

#### 📍 Core Platform URLs
- **🏠 Main Dashboard**: http://localhost (Nginx proxy)
- **🔗 Direct PHP 8.4**: http://localhost:8010 (Laravel container)
- **📧 Mailhog**: http://localhost:8025 (Email testing)

#### 🐛 Xdebug Configuration (Cập nhật 2025)
**Laravel PHP 7.4 Container:**
- **Port**: 9074 (Xdebug listener)
- **Host**: localhost
- **IDE Key**: VSCODE
- **URL**: http://localhost:8020

**Laravel PHP 8.4 Container:**
- **Port**: 9084 (Xdebug listener)
- **Host**: localhost
- **IDE Key**: VSCODE
- **URL**: http://localhost:8010

**WordPress PHP 7.4 Container:**
- **Port**: 9075 (Xdebug listener)
- **Host**: localhost
- **IDE Key**: VSCODE
- **URL**: http://localhost:8030

#### 🧪 Xdebug Testing URLs
Để kiểm tra Xdebug hoạt động, truy cập:
- **Laravel PHP 8.4**: http://localhost:8010/phpinfo.php?XDEBUG_SESSION_START=VSCODE
- **Laravel PHP 7.4**: http://localhost:8020/phpinfo.php?XDEBUG_SESSION_START=VSCODE
- **WordPress PHP 7.4**: http://localhost:8030/phpinfo.php?XDEBUG_SESSION_START=VSCODE

**Kiểm tra phpinfo() và Xdebug status:**
- **Laravel 8.4**: http://localhost:8010/phpinfo.php
- **Laravel 7.4**: http://localhost:8020/phpinfo.php
- **WordPress**: http://localhost:8030/phpinfo.php

*Tìm section "Xdebug" để xác nhận cấu hình và debug session status*

### 📧 Email Testing (Mailhog)
**URL**: http://localhost:8025

**Tính năng:**
- 📨 Catch tất cả emails từ applications
- 👀 Preview emails trong browser
- 🔍 Search và filter emails
- 📱 Responsive interface

### 🗄️ Database Management
**PostgreSQL**: localhost:5432 (postgres_user/postgres_pass)
**MySQL**: localhost:3306 (mysql_user/mysql_pass)
**Redis**: localhost:6379

---

## 🤖 Tạo Platform tự động

### 🎯 Lệnh chính - CHỈ CẦN NHỚ CÁI NÀY!

```bash
bin\create.bat [tên-project-của-bạn]
```

### 🧠 AI Auto-Detection System

Hệ thống AI sẽ tự động phân tích tên project và chọn:
- **� PHP Version**: 7.4 hoặc 8.4
- **🗄️ Database**: MySQL hoặc PostgreSQL
- **⚡ Cache**: Redis (nếu cần)
- **🌐 Port**: Tự động gán port available
- **🐛 Debug**: Xdebug với port riêng

### 📝 Quy tắc đặt tên thông minh

#### 🛒 E-commerce Platforms (Laravel PHP 8.4 + PostgreSQL + Redis)
```bash
bin\create.bat my-shop          # → Cửa hàng online
bin\create.bat food-delivery    # → App giao đồ ăn
bin\create.bat coffee-store     # → Cửa hàng cà phê
bin\create.bat book-shop        # → Cửa hàng sách
```
**Keywords**: `shop`, `store`, `ecommerce`, `delivery`, `food`, `cafe`, `restaurant`

#### 📝 Content Platforms (WordPress PHP 7.4 + MySQL)
```bash
bin\create.bat my-blog          # → Blog cá nhân
bin\create.bat news-portal      # → Website tin tức
bin\create.bat company-website  # → Website công ty
bin\create.bat my-portfolio     # → Portfolio cá nhân
```
**Keywords**: `blog`, `news`, `cms`, `website`, `portfolio`

#### 🚀 API Services (Laravel PHP 8.4 + PostgreSQL + Redis)
```bash
bin\create.bat user-api         # → API quản lý user
bin\create.bat payment-service  # → Service thanh toán
bin\create.bat auth-backend     # → Backend xác thực
```
**Keywords**: `api`, `service`, `backend`

### 🔄 Quá trình tự động diễn ra

Khi bạn chạy lệnh, hệ thống sẽ:

1. **🤖 AI phân tích tên** → Chọn loại platform phù hợp
2. **📁 Tạo thư mục** → Cấu trúc project hoàn chỉnh
3. **🗄️ Tạo database** → MySQL/PostgreSQL với tên phù hợp
4. **⚙️ Tạo cấu hình** → Docker, Nginx, PHP
5. **� Cấu hình Xdebug** → Debug port riêng cho từng platform
6. **�🚀 Khởi động** → Build và start containers
7. **🌐 Auto-routing** → Nginx tự động route domain
8. **📱 Mở browser** → Hiển thị website của bạn

### 📊 Kết quả nhận được

Sau khi chạy lệnh, bạn sẽ có:

```
📁 Cấu trúc project:
platforms/my-shop/
├── docker-compose.my-shop.yml  # Cấu hình riêng
├── nginx.conf                  # Nginx routing
├── README.md                   # Hướng dẫn riêng

projects/my-shop/
├── index.php                   # Code ứng dụng
├── config/                     # Database config

🗄️ Database: my_shop_db (tự động tạo)
🌐 URL: http://localhost:8010 (tự động mở)
🐛 Debug: localhost:9010 (Xdebug)
🔗 Domain: my-shop.local (optional)
```

### 🎯 Platform Templates Available

#### 🛒 E-commerce Template
- **Framework**: Laravel 8.4 với Blade templates
- **Database**: PostgreSQL với sample products table
- **Features**: Cart, checkout, user auth, admin panel
- **Cache**: Redis cho sessions và cache

#### 📝 WordPress Template
- **CMS**: WordPress latest với custom theme
- **Database**: MySQL với sample content
- **Features**: Posts, pages, comments, media library
- **Plugins**: Essential plugins pre-installed

#### 🚀 API Template
- **Framework**: Laravel 8.4 API-only
- **Database**: PostgreSQL với API tables
- **Features**: JWT auth, rate limiting, API docs
- **Cache**: Redis cho API caching

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

## 🗄️ Database và Tools

### 📊 Database Credentials (Cập nhật 2025)

#### 🐬 MySQL Database
```bash
Host: localhost
Port: 3306
Username: mysql_user
Password: mysql_pass
Database: main_db
SSL: Disabled
```

**Connection String:**
```php
$mysql = new PDO("mysql:host=mysql_low_ram;port=3306;dbname=main_db", "mysql_user", "mysql_pass");
```

#### 🐘 PostgreSQL Database
```bash
Host: localhost
Port: 5432
Username: postgres_user
Password: postgres_pass
Database: postgres
SSL Mode: Disable
```

**Connection String:**
```php
$pgsql = new PDO("pgsql:host=postgres_low_ram;port=5432;dbname=postgres", "postgres_user", "postgres_pass");
```

#### 🔴 Redis Cache
```bash
Host: localhost
Port: 6379
Password: (none)
```

**Connection:**
```php
$redis = new Redis();
$redis->connect('redis_low_ram', 6379);
```

### 🛠️ Database Management Tools

#### 📋 Web-based Testing
- **Database Test**: http://localhost:8010/test-db.php
- **PHP Info**: http://localhost:8010/phpinfo.php
- **Mailhog**: http://localhost:8025

#### 💻 Command Line Access
```bash
# MySQL CLI
docker exec mysql_low_ram mysql -u mysql_user -pmysql_pass

# PostgreSQL CLI
docker exec postgres_low_ram psql -U postgres_user -d postgres

# Redis CLI
docker exec redis_low_ram redis-cli
```

#### 🔍 Database Operations
```bash
# List MySQL databases
docker exec mysql_low_ram mysql -u mysql_user -pmysql_pass -e "SHOW DATABASES;"

# List PostgreSQL databases
docker exec postgres_low_ram psql -U postgres_user -d postgres -c "\l"

# Create new database
docker exec postgres_low_ram psql -U postgres_user -d postgres -c "CREATE DATABASE my_new_db;"
```

### 🔗 External Tool Connections

#### Navicat / DBeaver / phpMyAdmin
Sử dụng thông tin connection ở trên với:
- **Host**: localhost (không phải container name)
- **Ports**: 3306 (MySQL), 5432 (PostgreSQL)
- **Credentials**: Như đã liệt kê ở trên

---

## 🔧 Troubleshooting

### ❌ Nginx khởi động liên tục (FIXED)
**Nguyên nhân:** Duplicate default server configuration

**✅ Đã khắc phục:** Removed duplicate server block trong nginx.conf
```bash
# Kiểm tra Nginx status
docker ps --filter name=nginx_proxy_low_ram

# Nếu vẫn lỗi, restart:
docker restart nginx_proxy_low_ram
```

### ❌ Website trả về 404
**Nguyên nhân:** Files không đúng document root

**Giải pháp:**
```bash
# Kiểm tra document root
docker exec laravel_php84_low_ram ls -la /app/

# Copy files vào đúng thư mục
docker cp www/index.php laravel_php84_low_ram:/app/
```

### ❌ Lỗi "Port already in use"
**Nguyên nhân:** Port đã được sử dụng

**Giải pháp:**
```bash
# Xem port nào đang dùng
netstat -an | findstr :8010

# Dừng service đang dùng port đó
docker stop [container-name]
```

### ❌ Database connection failed (FIXED 2025)
**Nguyên nhân:** Credentials cũ hoặc connection string sai

**✅ Đã khắc phục:** Cập nhật credentials đúng
```bash
# Test database connections (URL mới)
curl http://localhost:8010/test-db.php

# Credentials đúng:
# MySQL: mysql_user/mysql_pass
# PostgreSQL: postgres_user/postgres_pass

# Tạo database thủ công nếu cần
docker exec postgres_low_ram psql -U postgres_user -d postgres -c "CREATE DATABASE my_shop_db;"
```

### ❌ Container không start
**Nguyên nhân:** Resource conflicts hoặc configuration errors

**Giải pháp:**
```bash
# Xem logs chi tiết
docker logs [container-name] --tail 50

# Restart toàn bộ hệ thống
docker-compose -f docker-compose.low-ram.yml restart

# Nếu vẫn lỗi, rebuild
docker-compose -f docker-compose.low-ram.yml up -d --build
```

### 🆘 Scripts khắc phục tự động
```bash
# Khởi động lại toàn bộ hệ thống
bin\auto-start.bat

# Kiểm tra và sửa tất cả vấn đề
bin\health-check.bat

# Tối ưu RAM và performance
scripts\one-click-optimize.bat
```

### 📊 Monitoring và Diagnostics
```bash
# Xem resource usage
docker stats

# Xem disk usage
docker system df

# Xem network
docker network ls

# Health check tổng quan
curl http://localhost/ram-optimization.php
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

### 🚀 Lệnh khởi động hệ thống
```bash
bin\auto-start.bat           # Khởi động toàn bộ hệ thống
```

### 🎯 Lệnh tạo platform (quan trọng nhất)
```bash
bin\create.bat [tên-project]
```

### 🌐 URLs chính
- **Dashboard**: http://localhost
- **RAM Monitor**: http://localhost/ram-optimization.php
- **DB Tester**: http://localhost/test-db.php
- **Mailhog**: http://localhost:8025

### 🚀 Development Platforms
- **Laravel PHP 8.4**: http://localhost:8010
- **Laravel PHP 7.4**: http://localhost:8020
- **WordPress PHP 7.4**: http://localhost:8030

### 🎯 Quy tắc đặt tên AI
- **E-commerce:** `shop`, `store`, `food`, `delivery` → Laravel 8.4 + PostgreSQL
- **Website/Blog:** `blog`, `news`, `website`, `portfolio` → WordPress + MySQL
- **API:** `api`, `service`, `backend` → Laravel 8.4 + PostgreSQL + Redis

### 🛠️ Lệnh quản lý cơ bản
```bash
docker ps                    # Xem containers đang chạy
docker logs [container]      # Xem logs
docker restart [container]   # Restart container
```

### 🆘 Khi gặp lỗi
```bash
bin\auto-start.bat                    # Restart toàn bộ hệ thống
bin\health-check.bat                  # Kiểm tra health
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

## 🎓 Kết luận - Docker Master Platform 2025

### ✅ Tính năng hoàn chỉnh:
1. **Multi-PHP Environment** - PHP 7.4 & 8.4 với Xdebug
2. **Dual Database Support** - MySQL & PostgreSQL
3. **Auto Platform Creation** - AI-powered project detection
4. **Real-time Monitoring** - Dashboard với database status
5. **Development Tools** - phpinfo, database test, email testing
6. **Clean Architecture** - Optimized containers và RAM usage

### 🌐 URLs quan trọng (Cập nhật 2025):
- **Main Dashboard**: http://localhost:8010
- **Laravel PHP 8.4**: http://localhost:8010/laravel.php
- **Laravel PHP 7.4**: http://localhost:8020
- **WordPress PHP 7.4**: http://localhost:8030
- **Database Test**: http://localhost:8010/test-db.php
- **PHP Info**: http://localhost:8010/phpinfo.php
- **Mailhog**: http://localhost:8025

### 🐛 Xdebug Ports:
- **Laravel PHP 7.4**: 9074
- **Laravel PHP 8.4**: 9084
- **WordPress PHP 7.4**: 9075

### 🗄️ Database Credentials:
- **MySQL**: mysql_user/mysql_pass (localhost:3306)
- **PostgreSQL**: postgres_user/postgres_pass (localhost:5432)
- **Redis**: No password (localhost:6379)

### 🚀 Quick Commands:
```bash
# Khởi động hệ thống
docker-compose -f docker-compose.low-ram.yml up -d

# Tạo platform mới
bin\create.bat my-project

# Test databases
curl http://localhost:8010/test-db.php

# Restart clean
docker-compose -f docker-compose.low-ram.yml down
docker-compose -f docker-compose.low-ram.yml up -d
```

**🌟 Docker Master Platform 2025 - Hoàn hảo cho Modern Development!**

*Multi-PHP, Dual-Database, Auto-Creation, Xdebug Ready!*
