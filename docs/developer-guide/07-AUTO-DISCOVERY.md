# 🤖 Auto-Discovery Platform Creation

## 🎯 Tổng quan

Hệ thống Auto-Discovery của Docker Master cho phép bạn tạo platform hoàn chỉnh chỉ với **1 lệnh duy nhất**. Hệ thống sử dụng AI để tự động phát hiện và cấu hình loại platform phù hợp nhất dựa trên tên dự án.

## 🚀 Cách sử dụng siêu đơn giản

### Lệnh chính (Khuyến nghị)
```bash
# Chỉ cần 1 lệnh - mọi thứ tự động!
create.bat [tên-dự-án]
```

### Ví dụ thực tế
```bash
create.bat my-shop           # → Platform E-commerce
create.bat food-delivery     # → Platform giao đồ ăn  
create.bat my-blog           # → WordPress blog
create.bat api-service       # → Laravel API
create.bat coffee-shop       # → Cửa hàng cà phê
create.bat news-portal       # → Website tin tức
```

## 🤖 AI Auto-Detection

Hệ thống tự động phát hiện loại platform dựa trên từ khóa trong tên dự án:

### 🛒 E-commerce Platforms
**Từ khóa:** `shop`, `store`, `ecommerce`, `commerce`, `buy`, `sell`, `delivery`, `food`, `cafe`, `restaurant`

**Kết quả:** Laravel 8.4 E-commerce với PostgreSQL + Redis

**Ví dụ:**
- `my-shop` → Cửa hàng online
- `food-delivery` → Platform giao đồ ăn
- `coffee-shop` → Website cà phê
- `online-store` → Cửa hàng trực tuyến

### 📝 WordPress Platforms
**Từ khóa:** `blog`, `news`, `cms`, `content`, `portfolio`, `personal`, `website`

**Kết quả:** WordPress PHP 7.4 với PostgreSQL

**Ví dụ:**
- `my-blog` → Blog cá nhân
- `news-portal` → Website tin tức
- `portfolio-site` → Portfolio cá nhân
- `company-website` → Website công ty

### 🚀 Laravel API Platforms
**Từ khóa:** `api`, `service`, `micro`, `backend`

**Kết quả:** Laravel 8.4 API với PostgreSQL + Redis

**Ví dụ:**
- `api-service` → REST API service
- `user-service` → Microservice
- `backend-api` → Backend API

### 🔧 Platform mặc định
**Không khớp từ khóa:** Laravel 7.4 application

## 📁 Cấu trúc được tạo tự động

Mỗi platform sẽ tự động tạo:

```
platforms/[tên-dự-án]/
├── docker-compose.[tên-dự-án].yml  # Cấu hình standalone
├── README.md                       # Tài liệu platform

projects/[tên-dự-án]/
├── index.php                       # File ứng dụng chính

logs/apache/[tên-dự-án]/           # File log Apache

data/uploads/[tên-dự-án]/          # Thư mục upload file
```

## 🗄️ Quản lý Database

### Tạo Database tự động
- **Tên dự án:** `my-shop` → **Database:** `my_shop_db`
- **Tên dự án:** `food-delivery` → **Database:** `food_delivery_db`
- **Tên dự án:** `coffee-shop` → **Database:** `coffee_shop_db`

### Quy tắc đặt tên Database
- Dấu gạch ngang (`-`) tự động chuyển thành gạch dưới (`_`)
- Tự động thêm hậu tố `_db`
- Database được tạo trong PostgreSQL tự động

## 🚀 Tùy chọn triển khai

### Tùy chọn 1: Triển khai độc lập (Khuyến nghị)
```bash
# Di chuyển đến thư mục platform
cd platforms/[tên-dự-án]

# Khởi động platform
docker-compose -f docker-compose.[tên-dự-án].yml up -d
```

### Tùy chọn 2: Triển khai tích hợp
Thêm service vào `docker-compose.low-ram.yml` và chạy:
```bash
docker-compose -f docker-compose.low-ram.yml up -d [tên-dự-án]
```

## 🛠️ Các lệnh có sẵn

### 1. Lệnh siêu đơn giản (Thư mục gốc)
```bash
create.bat [tên-dự-án]
```
- **Vị trí:** Thư mục gốc
- **Tính năng:** 1 lệnh, mọi thứ tự động
- **Phù hợp:** Tạo platform nhanh

### 2. Lệnh đầy đủ tính năng (Thư mục gốc)
```bash
auto-platform.bat [tên-dự-án]
```
- **Vị trí:** Thư mục gốc  
- **Tính năng:** Giống create.bat nhưng hiển thị chi tiết hơn
- **Phù hợp:** Khi muốn xem quá trình tạo chi tiết

### 3. Lệnh nâng cao (Thư mục scripts)
```bash
scripts\create-platform.bat [loại] [tên] [port]
```
- **Vị trí:** Thư mục scripts/
- **Tính năng:** Chọn loại thủ công, port tùy chỉnh
- **Phù hợp:** Người dùng nâng cao muốn kiểm soát hoàn toàn

**Loại Platform:**
- `wordpress` - WordPress PHP 7.4 + PostgreSQL
- `laravel74` - Laravel PHP 7.4 + PostgreSQL + Redis
- `laravel84` - Laravel PHP 8.4 + PostgreSQL + Redis
- `ecommerce` - E-commerce Laravel + Full Stack

## 📊 Quản lý Platform

### Xem Platform đang chạy
```bash
docker ps --filter "name=_php"
```

### Truy cập Platform
```bash
# Mở trong browser
start http://localhost:[port]

# Xem logs
docker logs [tên-platform]_php[version]

# Truy cập shell
docker exec -it [tên-platform]_php[version] bash
```

### Dừng Platform
```bash
cd platforms/[tên-platform]
docker-compose -f docker-compose.[tên-platform].yml down
```

## 🎯 Ví dụ thực tế

### Ví dụ 1: Cửa hàng cà phê E-commerce
```bash
create.bat coffee-paradise
```
**Kết quả:**
- **Loại:** E-commerce platform
- **URL:** http://localhost:8015
- **Database:** `coffee_paradise_db`
- **Tính năng:** Catalog sản phẩm, giỏ hàng, quản lý kho

### Ví dụ 2: Dịch vụ giao đồ ăn
```bash
create.bat quick-eats-delivery
```
**Kết quả:**
- **Loại:** E-commerce platform (giao đồ ăn)
- **URL:** http://localhost:8016
- **Database:** `quick_eats_delivery_db`
- **Tính năng:** Danh sách nhà hàng, quản lý đơn hàng

### Ví dụ 3: Blog cá nhân
```bash
create.bat my-tech-blog
```
**Kết quả:**
- **Loại:** WordPress platform
- **URL:** http://localhost:8017
- **Database:** `my_tech_blog_db`
- **Tính năng:** WordPress CMS, PostgreSQL backend

### Ví dụ 4: API Service
```bash
create.bat user-api-service
```
**Kết quả:**
- **Loại:** Laravel 8.4 API
- **URL:** http://localhost:8018
- **Database:** `user_api_service_db`
- **Tính năng:** REST API, Redis caching

## 🔧 Khắc phục sự cố

### Platform không khởi động
```bash
# Kiểm tra trạng thái container
docker ps -a

# Xem logs
docker logs [tên-container]

# Restart platform
cd platforms/[tên-platform]
docker-compose -f docker-compose.[tên-platform].yml restart
```

### Lỗi kết nối Database
```bash
# Kiểm tra PostgreSQL
docker exec postgres_low_ram pg_isready -U postgres_user

# Liệt kê databases
docker exec postgres_low_ram psql -U postgres_user -d postgres -c "\l"

# Sửa lỗi đặt tên database
scripts\fix-platform-databases.bat
```

### Xung đột Port
Hệ thống tự động gán port từ 8015. Nếu cần port cụ thể, dùng lệnh nâng cao:
```bash
scripts\create-platform.bat [loại] [tên] [port-tùy-chỉnh]
```

## 📈 Tính năng nâng cao

### Chế độ tương tác
```bash
scripts\auto-discovery.bat
```
Tính năng:
- Gợi ý AI-powered
- Thư viện template
- Phân tích dự án
- Hướng dẫn từng bước

### Thư viện Template
Template có sẵn cho các trường hợp phổ biến:
- **Đồ ăn & Nhà hàng:** restaurant-menu, food-delivery, cafe-website
- **E-commerce:** online-store, marketplace, subscription-box
- **Nội dung & Media:** news-portal, portfolio-site, blog-platform
- **Doanh nghiệp:** corporate-site, saas-platform, booking-system

## 🎉 Mẹo thành công

1. **Dùng tên dự án mô tả** - AI detection hoạt động tốt hơn với tên rõ ràng
2. **Bao gồm từ khóa liên quan** - Giúp hệ thống chọn đúng loại platform
3. **Kiểm tra port được gán** - Đảm bảo không xung đột với service khác
4. **Xem README được tạo** - Mỗi platform có tài liệu riêng
5. **Tùy chỉnh sau khi tạo** - Chỉnh sửa file được tạo theo nhu cầu

## 🌟 Tóm tắt

Hệ thống Auto-Discovery của Docker Master làm cho việc tạo platform trở nên dễ dàng:

✅ **1 lệnh** tạo mọi thứ  
✅ **AI detection** chọn platform phù hợp  
✅ **Cấu hình tự động** xử lý tất cả setup  
✅ **Cấu trúc đúng** theo best practices  
✅ **Tạo database** với tên đúng  
✅ **Triển khai ngay lập tức** và mở browser  

Chỉ cần chạy `create.bat [tên-dự-án-của-bạn]` và bắt đầu phát triển!
