# 🗄️ DBeaver Ultimate Setup Guide

Hướng dẫn kết nối DBeaver Ultimate với Docker Development Environment.

## 🔧 MySQL Connection Setup

### **Connection Settings:**
```
Connection Type: MySQL
Host: localhost
Port: 3306
Database: asmokaigo (hoặc tên database bạn muốn)
Username: dev_user
Password: dev_pass
```

### **Advanced Settings:**
```
SSL: Disabled
Allow Public Key Retrieval: Yes (nếu có option này)
Use SSL: No
```

## 🚨 Troubleshooting

### **❌ Lỗi "Access denied for user 'dev_user'@'%' to database 'asmokaigo'"**

**Nguyên nhân:** User `dev_user` không có quyền tạo database mới.

**Giải pháp:**
```bash
# Chạy script fix permissions
bin\fix-mysql-permissions.bat
```

**Hoặc fix thủ công:**
```sql
-- Kết nối MySQL với root user
docker-compose exec mysql mysql -u root -p

-- Cấp quyền cho dev_user
GRANT ALL PRIVILEGES ON *.* TO 'dev_user'@'%' WITH GRANT OPTION;
FLUSH PRIVILEGES;

-- Tạo database asmokaigo
CREATE DATABASE IF NOT EXISTS asmokaigo CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
```

### **❌ Lỗi "Connection refused" hoặc "Can't connect"**

**Kiểm tra Docker services:**
```bash
# Kiểm tra trạng thái
docker-compose ps

# Kiểm tra MySQL logs
docker-compose logs mysql

# Restart MySQL nếu cần
docker-compose restart mysql
```

**Kiểm tra port conflicts:**
```bash
# Windows
netstat -ano | findstr :3306

# Nếu port bị conflict, đổi port trong .env
MYSQL_PORT=3307
```

### **❌ Lỗi SSL/TLS**

**Tắt SSL trong DBeaver:**
1. Trong connection settings
2. Tìm tab "SSL" hoặc "Advanced"
3. Set "Use SSL" = No
4. Set "Allow Public Key Retrieval" = Yes

## 🗄️ PostgreSQL Connection Setup

### **Connection Settings:**
```
Connection Type: PostgreSQL
Host: localhost
Port: 5432
Database: dev_db (hoặc tên database bạn muốn)
Username: dev_user
Password: dev_pass
```

### **Advanced Settings:**
```
SSL Mode: Disable
Show all databases: Yes
```

## 📊 Redis Connection Setup (Nếu DBeaver hỗ trợ)

### **Connection Settings:**
```
Connection Type: Redis
Host: localhost
Port: 6379
Password: (để trống)
```

## 🎯 Best Practices

### **Database Naming Convention:**
```
project_name_env
Ví dụ:
- asmokaigo_dev
- asmokaigo_test
- myproject_local
```

### **Character Set:**
```
Character Set: utf8mb4
Collation: utf8mb4_unicode_ci
```

### **Connection Pooling:**
```
Max Connections: 10-20 (cho development)
Connection Timeout: 30 seconds
```

## 🔧 Useful SQL Commands

### **Database Management:**
```sql
-- Tạo database mới
CREATE DATABASE myproject CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- Xóa database
DROP DATABASE myproject;

-- Hiển thị tất cả databases
SHOW DATABASES;

-- Sử dụng database
USE myproject;

-- Hiển thị tables
SHOW TABLES;
```

### **User Management:**
```sql
-- Tạo user mới
CREATE USER 'newuser'@'%' IDENTIFIED BY 'password';

-- Cấp quyền
GRANT ALL PRIVILEGES ON myproject.* TO 'newuser'@'%';

-- Hiển thị quyền
SHOW GRANTS FOR 'dev_user'@'%';

-- Flush privileges
FLUSH PRIVILEGES;
```

### **Table Operations:**
```sql
-- Tạo table mẫu
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Insert data
INSERT INTO users (name, email) VALUES ('John Doe', 'john@example.com');

-- Select data
SELECT * FROM users;
```

## 🚀 Performance Tips

### **DBeaver Settings:**
```
Memory: Increase heap size in dbeaver.ini
-Xmx2048m

Connection Pool: 
- Initial: 1
- Max: 10
- Validation Query: SELECT 1
```

### **MySQL Optimization:**
```sql
-- Check current settings
SHOW VARIABLES LIKE 'innodb_buffer_pool_size';
SHOW VARIABLES LIKE 'max_connections';

-- Performance monitoring
SHOW PROCESSLIST;
SHOW STATUS LIKE 'Threads_connected';
```

## 📝 Import/Export Data

### **Export Database:**
```bash
# MySQL
docker-compose exec mysql mysqldump -u dev_user -pdev_pass asmokaigo > asmokaigo_backup.sql

# PostgreSQL
docker-compose exec postgresql pg_dump -U dev_user asmokaigo > asmokaigo_backup.sql
```

### **Import Database:**
```bash
# MySQL
docker-compose exec -T mysql mysql -u dev_user -pdev_pass asmokaigo < asmokaigo_backup.sql

# PostgreSQL
docker-compose exec -T postgresql psql -U dev_user -d asmokaigo < asmokaigo_backup.sql
```

### **DBeaver Import/Export:**
1. Right-click database → Tools → Export Data
2. Choose format (SQL, CSV, JSON, etc.)
3. Configure export settings
4. Execute export

## 🔍 Monitoring & Debugging

### **Connection Testing:**
```sql
-- Test MySQL connection
SELECT 'MySQL Connection OK' as status, NOW() as current_time;

-- Check user privileges
SELECT USER(), CURRENT_USER();

-- Show current database
SELECT DATABASE();
```

### **Performance Monitoring:**
```sql
-- Show running queries
SHOW PROCESSLIST;

-- Show database sizes
SELECT 
    table_schema AS 'Database',
    ROUND(SUM(data_length + index_length) / 1024 / 1024, 2) AS 'Size (MB)'
FROM information_schema.tables 
GROUP BY table_schema;
```

## 🆘 Emergency Recovery

### **Reset MySQL Permissions:**
```bash
# Run permission fix script
bin\fix-mysql-permissions.bat

# Or manual reset
docker-compose exec mysql mysql -u root -p
```

### **Reset Database:**
```bash
# Complete MySQL reset
docker-compose down
rm -rf database/mysql/data/*
docker-compose up -d mysql
```

### **Connection Issues:**
```bash
# Restart services
docker-compose restart mysql

# Check logs
docker-compose logs mysql

# Test connection
docker-compose exec mysql mysql -u dev_user -pdev_pass -e "SELECT 1"
```

---

## ✅ Success Checklist

- [ ] DBeaver connected to MySQL successfully
- [ ] Can create/drop databases
- [ ] Can create/modify tables
- [ ] Can import/export data
- [ ] SSL disabled (no warnings)
- [ ] Connection stable

**🎉 Bây giờ bạn có thể sử dụng DBeaver Ultimate với full permissions!**
