# Laravel E-commerce Application

## Mô tả
Ứng dụng thương mại điện tử được xây dựng bằng Laravel 12.x với PHP 8.4, Bootstrap UI, và hệ thống API đầy đủ để test với Postman.

## Tính năng chính
- ✅ Hệ thống authentication với role admin/customer
- ✅ Admin panel với dashboard thống kê
- ✅ Quản lý sản phẩm, danh mục, đơn hàng
- ✅ REST API endpoints cho Postman testing
- ✅ Bootstrap UI responsive
- ✅ Database seeding với dữ liệu mẫu

## Cài đặt và chạy

### 1. Khởi động Docker containers
```bash
docker-compose up -d
```

### 2. Truy cập ứng dụng
- **Website**: http://localhost:8006
- **phpMyAdmin**: http://localhost:8080
- **API Base URL**: http://localhost:8006/api/v1

### 3. Tài khoản test
- **Admin**: admin@example.com / password
- **Customer**: test@example.com / password

## API Endpoints

### Products
- `GET /api/v1/products` - Lấy danh sách sản phẩm
- `GET /api/v1/products/{id}` - Lấy chi tiết sản phẩm
- `POST /api/v1/products` - Tạo sản phẩm mới
- `PUT /api/v1/products/{id}` - Cập nhật sản phẩm
- `DELETE /api/v1/products/{id}` - Xóa sản phẩm

### Categories
- `GET /api/v1/categories` - Lấy danh sách danh mục
- `GET /api/v1/categories/{id}` - Lấy danh mục với sản phẩm
- `GET /api/v1/categories/{id}/products` - Lấy sản phẩm theo danh mục

### Search & Featured
- `GET /api/v1/search/products?q={query}` - Tìm kiếm sản phẩm
- `GET /api/v1/products/featured` - Lấy sản phẩm nổi bật

## Postman Testing
Import file `Laravel_Ecommerce_API.postman_collection.json` vào Postman để test các API endpoints.

## Admin Panel
Truy cập admin panel tại: http://localhost:8006/admin
- Yêu cầu đăng nhập với tài khoản admin
- Dashboard hiển thị thống kê tổng quan
- Quản lý sản phẩm, đơn hàng, người dùng

## Database Schema
- **users**: Người dùng với role admin/customer
- **categories**: Danh mục sản phẩm (hỗ trợ nested)
- **products**: Sản phẩm với đầy đủ thông tin
- **orders**: Đơn hàng
- **order_items**: Chi tiết đơn hàng
- **carts**: Giỏ hàng

## Công nghệ sử dụng
- **Backend**: Laravel 12.x, PHP 8.4
- **Frontend**: Bootstrap 5, Blade Templates
- **Database**: MySQL 8.0
- **Container**: Docker, Docker Compose
- **API**: RESTful API với JSON responses

## Cấu trúc thư mục
```
laravel_ecommerce/
├── app/
│   ├── Http/Controllers/
│   │   ├── Admin/AdminController.php
│   │   └── Api/ProductController.php
│   ├── Http/Middleware/AdminMiddleware.php
│   └── Models/
├── database/
│   ├── migrations/
│   └── seeders/
├── resources/views/
│   ├── admin/dashboard.blade.php
│   └── layouts/app.blade.php
├── routes/
│   ├── web.php
│   └── api.php
└── Laravel_Ecommerce_API.postman_collection.json
```

## Lệnh hữu ích
```bash
# Chạy migrations và seeders
docker exec -w /app/laravel_ecommerce laravel_ecommerce_php84 php artisan migrate:fresh --seed

# Tạo controller mới
docker exec -w /app/laravel_ecommerce laravel_ecommerce_php84 php artisan make:controller ControllerName

# Xem routes
docker exec -w /app/laravel_ecommerce laravel_ecommerce_php84 php artisan route:list

# Build assets
docker exec -w /app/laravel_ecommerce laravel_ecommerce_php84 npm run build
```

## Hỗ trợ
Ứng dụng đã được test và hoạt động ổn định. Có thể mở rộng thêm các tính năng như:
- Payment gateway integration
- Email notifications
- Advanced search filters
- Product reviews and ratings
- Shopping cart functionality
- Order tracking system
