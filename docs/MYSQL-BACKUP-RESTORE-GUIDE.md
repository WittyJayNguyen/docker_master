# 🗄️ MySQL Backup & Restore Guide

Hướng dẫn chi tiết cách dump và import MySQL trong Docker Master Platform.

## 🚀 Quick Start

### Chạy tool tự động:
```bash
scripts\mysql-backup-restore.bat
```

## 📤 DUMP (Xuất) Database

### 1. Dump toàn bộ databases
```bash
# Cách 1: Sử dụng lệnh trực tiếp
docker exec mysql_low_ram mysqldump -u mysql_user -pmysql_pass --all-databases > backup_all.sql

# Cách 2: Với timestamp
docker exec mysql_low_ram mysqldump -u mysql_user -pmysql_pass --all-databases > backup_all_%date:~-4,4%%date:~-10,2%%date:~-7,2%.sql
```

### 2. Dump một database cụ thể
```bash
# Thay 'database_name' bằng tên database thực tế
docker exec mysql_low_ram mysqldump -u mysql_user -pmysql_pass database_name > backup_database.sql

# Ví dụ: Dump database WordPress
docker exec mysql_low_ram mysqldump -u mysql_user -pmysql_pass wordpress > backup_wordpress.sql
```

### 3. Dump một table cụ thể
```bash
# Thay 'database_name' và 'table_name' 
docker exec mysql_low_ram mysqldump -u mysql_user -pmysql_pass database_name table_name > backup_table.sql

# Ví dụ: Dump table wp_posts từ database wordpress
docker exec mysql_low_ram mysqldump -u mysql_user -pmysql_pass wordpress wp_posts > backup_wp_posts.sql
```

### 4. Dump với các options nâng cao
```bash
# Dump với structure và data
docker exec mysql_low_ram mysqldump -u mysql_user -pmysql_pass --routines --triggers database_name > backup_full.sql

# Dump chỉ structure (không có data)
docker exec mysql_low_ram mysqldump -u mysql_user -pmysql_pass --no-data database_name > backup_structure.sql

# Dump chỉ data (không có structure)
docker exec mysql_low_ram mysqldump -u mysql_user -pmysql_pass --no-create-info database_name > backup_data.sql
```

## 📥 IMPORT (Nhập) Database

### 1. Import toàn bộ databases
```bash
# Import từ file backup
docker exec -i mysql_low_ram mysql -u mysql_user -pmysql_pass < backup_all.sql
```

### 2. Import vào database cụ thể
```bash
# Import vào database có sẵn
docker exec -i mysql_low_ram mysql -u mysql_user -pmysql_pass database_name < backup_database.sql

# Ví dụ: Import vào database wordpress
docker exec -i mysql_low_ram mysql -u mysql_user -pmysql_pass wordpress < backup_wordpress.sql
```

### 3. Tạo database mới và import
```bash
# Bước 1: Tạo database mới
docker exec mysql_low_ram mysql -u mysql_user -pmysql_pass -e "CREATE DATABASE new_database;"

# Bước 2: Import vào database mới
docker exec -i mysql_low_ram mysql -u mysql_user -pmysql_pass new_database < backup_database.sql
```

### 4. Import với xử lý lỗi
```bash
# Import và bỏ qua lỗi
docker exec -i mysql_low_ram mysql -u mysql_user -pmysql_pass --force database_name < backup_database.sql

# Import với verbose output
docker exec -i mysql_low_ram mysql -u mysql_user -pmysql_pass -v database_name < backup_database.sql
```

## 🔧 Các lệnh MySQL hữu ích

### Xem danh sách databases
```bash
docker exec mysql_low_ram mysql -u mysql_user -pmysql_pass -e "SHOW DATABASES;"
```

### Xem danh sách tables trong database
```bash
docker exec mysql_low_ram mysql -u mysql_user -pmysql_pass -e "USE database_name; SHOW TABLES;"
```

### Kết nối MySQL CLI
```bash
docker exec -it mysql_low_ram mysql -u mysql_user -pmysql_pass
```

### Kiểm tra kích thước database
```bash
docker exec mysql_low_ram mysql -u mysql_user -pmysql_pass -e "SELECT table_schema AS 'Database', ROUND(SUM(data_length + index_length) / 1024 / 1024, 2) AS 'Size (MB)' FROM information_schema.tables GROUP BY table_schema;"
```

## 📁 Quản lý Files

### Tạo thư mục backup
```bash
mkdir backups
cd backups
```

### Copy file từ container ra host
```bash
# Copy file từ container
docker cp mysql_low_ram:/backup.sql ./backup.sql

# Copy file vào container
docker cp ./backup.sql mysql_low_ram:/backup.sql
```

## ⚠️ Lưu ý quan trọng

### 1. Thông tin kết nối MySQL:
- **Host**: localhost:3306
- **Username**: mysql_user
- **Password**: mysql_pass
- **Container**: mysql_low_ram

### 2. Bảo mật:
- Không sử dụng password trên command line trong production
- Sử dụng file config hoặc environment variables
- Backup files nên được mã hóa

### 3. Performance:
- Dump database lớn có thể mất thời gian
- Sử dụng `--single-transaction` cho InnoDB
- Sử dụng `--quick` để tiết kiệm memory

### 4. Ví dụ backup script tự động:
```bash
# Tạo backup hàng ngày
set backup_dir=backups\%date:~-4,4%-%date:~-10,2%-%date:~-7,2%
mkdir "%backup_dir%" 2>nul
docker exec mysql_low_ram mysqldump -u mysql_user -pmysql_pass --all-databases > "%backup_dir%\backup_all.sql"
```

## 🚨 Troubleshooting

### Lỗi thường gặp:

1. **"Access denied"**: Kiểm tra username/password
2. **"Database doesn't exist"**: Tạo database trước khi import
3. **"File not found"**: Kiểm tra đường dẫn file
4. **"Container not running"**: Khởi động MySQL container

### Kiểm tra logs:
```bash
docker logs mysql_low_ram
```

## 📞 Hỗ trợ

Nếu gặp vấn đề, hãy:
1. Kiểm tra container đang chạy: `docker ps`
2. Xem logs: `docker logs mysql_low_ram`
3. Test kết nối: `docker exec mysql_low_ram mysql -u mysql_user -pmysql_pass -e "SELECT 1;"`
