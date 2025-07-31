# AWS Order System Database Restore Guide

## Tổng quan
Tài liệu này hướng dẫn cách restore database AWS Order System từ file backup `aws_order_system_20250603_120501` vào PostgreSQL.

## Thông tin Database đã restore

### Thông tin kết nối
- **Host**: localhost
- **Port**: 5432
- **Database**: aws_order_system
- **Username**: postgres_user
- **Password**: postgres_pass
- **Container**: postgres_low_ram

### File backup
- **File**: `Data110720125\aws_order_system_20250603_120501`
- **Kích thước**: ~573 MB
- **Định dạng**: PostgreSQL custom format (pg_dump)
- **Ngày tạo**: 2025-06-03 12:05:01

## Quá trình Restore đã thực hiện

### 1. Tạo Database
```sql
DROP DATABASE IF EXISTS aws_order_system;
CREATE DATABASE aws_order_system WITH ENCODING='UTF8' LC_COLLATE='C' LC_CTYPE='C';
```

### 2. Copy file backup vào container
```bash
docker cp "Data110720125\aws_order_system_20250603_120501" postgres_low_ram:/tmp/backup.sql
```

### 3. Restore database
```bash
docker exec -i postgres_low_ram pg_restore -U postgres_user -d aws_order_system -v /tmp/backup.sql
```

## Cấu trúc Database

Database AWS Order System chứa các bảng chính sau:

### Bảng hệ thống
- `users` - Người dùng hệ thống
- `migrations` - Laravel migrations
- `personal_access_tokens` - API tokens
- `password_resets` - Reset password
- `failed_jobs` - Failed queue jobs

### Bảng nghiệp vụ chính
- `orders` - Đơn hàng
- `order_details` - Chi tiết đơn hàng
- `order_files` - File đính kèm đơn hàng
- `materials` - Nguyên liệu
- `material_types` - Loại nguyên liệu
- `suppliers` - Nhà cung cấp
- `businesses` - Doanh nghiệp
- `companies` - Công ty

### Bảng menu theo tháng
- `menus_YYYY_MM` - Menu theo từng tháng (từ 2023-02 đến 2027-02)
- `raw_menus_YYYY_MM` - Raw menu data theo tháng

### Bảng khác
- `purchases` - Đơn mua hàng
- `purchase_details` - Chi tiết đơn mua
- `inventories` - Tồn kho
- `staffs` - Nhân viên
- `activity_log` - Log hoạt động

## Cách truy cập Database

### 1. Qua pgAdmin Web Interface
- URL: http://localhost:8080
- Email: admin@example.com
- Password: admin_password

### 2. Qua Command Line
```bash
docker exec -it postgres_low_ram psql -U postgres_user -d aws_order_system
```

### 3. Qua ứng dụng client khác
- Host: localhost
- Port: 5432
- Database: aws_order_system
- Username: postgres_user
- Password: postgres_pass

## Kiểm tra Database

### Liệt kê tất cả bảng
```sql
\dt
```

### Đếm số lượng bảng
```sql
SELECT count(*) as table_count 
FROM information_schema.tables 
WHERE table_schema = 'public';
```

### Kiểm tra kích thước database
```sql
SELECT pg_size_pretty(pg_database_size('aws_order_system')) as database_size;
```

### Kiểm tra dữ liệu mẫu
```sql
-- Kiểm tra users
SELECT id, name, email FROM users LIMIT 5;

-- Kiểm tra orders
SELECT id, order_date, total_amount FROM orders LIMIT 5;

-- Kiểm tra materials
SELECT material_id, name, code FROM materials LIMIT 5;
```

## Scripts hỗ trợ

### 1. Script restore (PowerShell)
```bash
powershell -ExecutionPolicy Bypass -File "scripts\restore-order-system.ps1"
```

### 2. Script kiểm tra database
```bash
scripts\check-database.bat
```

## Lưu ý quan trọng

1. **Ownership warnings**: Trong quá trình restore có thể xuất hiện cảnh báo về role "postgres" không tồn tại. Điều này không ảnh hưởng đến dữ liệu.

2. **Performance**: Database có kích thước lớn với nhiều bảng partitioned theo tháng, cần tối ưu query khi truy vấn.

3. **Backup**: Nên tạo backup định kỳ cho database này:
```bash
docker exec postgres_low_ram pg_dump -U postgres_user -d aws_order_system > backup_$(date +%Y%m%d_%H%M%S).sql
```

4. **Monitoring**: Theo dõi performance và disk space do database có kích thước lớn.

## Troubleshooting

### Database không phản hồi
```bash
# Restart PostgreSQL container
docker restart postgres_low_ram

# Kiểm tra logs
docker logs postgres_low_ram
```

### Kết nối bị từ chối
```bash
# Kiểm tra container status
docker ps | findstr postgres

# Kiểm tra port
netstat -an | findstr 5432
```

### Dữ liệu không đầy đủ
```bash
# Kiểm tra quá trình restore
docker exec postgres_low_ram psql -U postgres_user -d aws_order_system -c "\dt"
```

## Kết luận

Database AWS Order System đã được restore thành công với:
- ✅ Tất cả bảng đã được tạo
- ✅ Dữ liệu đã được import
- ✅ Indexes và constraints đã được tạo
- ✅ Sequences đã được cập nhật

Database sẵn sàng sử dụng cho ứng dụng AWS Order System.
