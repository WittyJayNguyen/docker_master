# 🗄️ Navicat Setup Guide - Fix Table Creation Issues

> **Hướng dẫn kết nối Navicat và khắc phục lỗi không tạo được table**

## ⚡ Quick Fix

### 🔧 Bước 1: Fix Permissions (Chạy 1 lần)
```bash
# Fix tất cả permissions cho Navicat
scripts\fix-navicat-permissions.bat
```

### 🔗 Bước 2: Navicat Connection Settings

#### 🐬 **MySQL Connection:**
```
Connection Name: Docker Master MySQL
Host: localhost
Port: 3306
Username: mysql_user
Password: mysql_pass
Database: (leave empty or select specific)

Advanced Settings:
✅ Use SSL: No
✅ Allow Invalid Certificates: Yes
✅ Use Compression: No
```

#### 🐘 **PostgreSQL Connection:**
```
Connection Name: Docker Master PostgreSQL
Host: localhost
Port: 5432
Username: postgres_user
Password: postgres_pass
Database: postgres

Advanced Settings:
✅ SSL Mode: Disable
✅ Use SSH: No
```

## 🔧 Troubleshooting Table Creation

### ❌ **Lỗi: "Access denied for user"**

**Nguyên nhân:** User không có quyền CREATE TABLE

**Giải pháp:**
```bash
# Fix MySQL permissions
docker exec mysql_low_ram mysql -u root -pmysql_root_pass -e "
GRANT ALL PRIVILEGES ON *.* TO 'mysql_user'@'%' WITH GRANT OPTION;
FLUSH PRIVILEGES;
"

# Fix PostgreSQL permissions
docker exec postgres_low_ram psql -U postgres_user -d postgres -c "
ALTER USER postgres_user WITH SUPERUSER;
"
```

### ❌ **Lỗi: "Table doesn't exist" sau khi tạo**

**Nguyên nhân:** Database/Schema selection sai

**Giải pháp:**
1. **MySQL**: Chọn đúng database trong Navicat
2. **PostgreSQL**: Đảm bảo đang ở schema `public`

### ❌ **Lỗi: "Connection timeout"**

**Nguyên nhân:** Container chưa sẵn sàng

**Giải pháp:**
```bash
# Restart containers
docker restart mysql_low_ram postgres_low_ram

# Wait for ready
timeout 30

# Test connection
docker exec mysql_low_ram mysql -u mysql_user -pmysql_pass -e "SELECT 1;"
```

## 📋 Step-by-Step Navicat Setup

### 🐬 **MySQL Setup:**

#### 1. **Create New Connection**
- File → New Connection → MySQL

#### 2. **Basic Settings**
```
Host: localhost
Port: 3306
User Name: mysql_user
Password: mysql_pass
```

#### 3. **Test Connection**
- Click "Test Connection"
- Should show "Connection Successful"

#### 4. **Advanced Settings** (if needed)
```
Tab: Advanced
✅ Use SSL: Unchecked
✅ Use Compression: Unchecked
✅ Auto Connect: Checked

Tab: SSH
✅ Use SSH: Unchecked
```

#### 5. **Connect and Test**
```sql
-- Test table creation
CREATE DATABASE test_db;
USE test_db;
CREATE TABLE test_table (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
INSERT INTO test_table (name) VALUES ('Test Record');
SELECT * FROM test_table;
DROP TABLE test_table;
DROP DATABASE test_db;
```

### 🐘 **PostgreSQL Setup:**

#### 1. **Create New Connection**
- File → New Connection → PostgreSQL

#### 2. **Basic Settings**
```
Host: localhost
Port: 5432
User Name: postgres_user
Password: postgres_pass
Initial Database: postgres
```

#### 3. **Test Connection**
- Click "Test Connection"
- Should show "Connection Successful"

#### 4. **Advanced Settings**
```
Tab: Advanced
✅ SSL Mode: disable
✅ Use SSH: Unchecked

Tab: SSH
✅ Use SSH: Unchecked
```

#### 5. **Connect and Test**
```sql
-- Test table creation
CREATE DATABASE test_db;
\c test_db;
CREATE TABLE test_table (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
INSERT INTO test_table (name) VALUES ('Test Record');
SELECT * FROM test_table;
DROP TABLE test_table;
\c postgres;
DROP DATABASE test_db;
```

## 🛠️ Common Issues & Solutions

### 🔒 **Permission Issues**

#### **MySQL Permission Check:**
```sql
-- Check current user privileges
SHOW GRANTS FOR 'mysql_user'@'%';

-- Should see:
-- GRANT ALL PRIVILEGES ON *.* TO 'mysql_user'@'%' WITH GRANT OPTION
```

#### **PostgreSQL Permission Check:**
```sql
-- Check user privileges
SELECT * FROM pg_user WHERE usename = 'postgres_user';

-- Should show: usesuper = true
```

### 🌐 **Connection Issues**

#### **Check Container Status:**
```bash
# Check if containers are running
docker ps --filter "name=mysql_low_ram"
docker ps --filter "name=postgres_low_ram"

# Check container logs
docker logs mysql_low_ram --tail 20
docker logs postgres_low_ram --tail 20
```

#### **Test Direct Connection:**
```bash
# Test MySQL
docker exec mysql_low_ram mysql -u mysql_user -pmysql_pass -e "SELECT VERSION();"

# Test PostgreSQL
docker exec postgres_low_ram psql -U postgres_user -d postgres -c "SELECT version();"
```

### 🔄 **Reset Everything**

#### **Complete Reset (if all else fails):**
```bash
# Stop containers
docker-compose -f docker-compose.low-ram.yml down

# Remove volumes (WARNING: This deletes all data)
docker volume rm docker_master_mysql_data
docker volume rm docker_master_postgres_data

# Restart fresh
docker-compose -f docker-compose.low-ram.yml up -d

# Wait for startup
timeout 60

# Fix permissions again
scripts\fix-navicat-permissions.bat
```

## ✅ Verification Checklist

### 📋 **Before Using Navicat:**
- [ ] Containers are running (`docker ps`)
- [ ] Can connect via command line
- [ ] Permissions script executed successfully
- [ ] Test connection in Navicat works

### 📋 **Table Creation Test:**
- [ ] Can create database
- [ ] Can create table with various column types
- [ ] Can insert/update/delete data
- [ ] Can drop table and database

## 💡 Pro Tips

### 🚀 **Performance:**
- Use connection pooling in Navicat
- Limit result set size for large tables
- Use indexes for better query performance

### 🔒 **Security:**
- Don't use these credentials in production
- Consider creating separate users for different projects
- Use SSL in production environments

### 🛠️ **Development:**
- Save frequently used queries as snippets
- Use Navicat's data modeling features
- Export/import data for testing

---

**🎯 Sau khi làm theo hướng dẫn này, Navicat sẽ hoạt động hoàn hảo với Docker Master Platform!**

*Full table creation • Full database management • No permission issues*
