# 🚀 Docker Master Platform 2025 - Quick Reference

> **Cập nhật mới nhất với Multi-PHP, Dual-Database, Xdebug Ready**

## ⚡ Quick Start Commands

### 🐳 System Management
```bash
# Start system
docker-compose -f docker-compose.low-ram.yml up -d

# Stop system  
docker-compose -f docker-compose.low-ram.yml down

# Restart clean
docker-compose -f docker-compose.low-ram.yml down
docker-compose -f docker-compose.low-ram.yml up -d

# Check status
docker ps
```

### 🏗️ Platform Creation
```bash
# Create new platform (AI auto-detection)
bin\create.bat my-project

# Examples:
bin\create.bat my-shop        # → E-commerce (Laravel 8.4 + PostgreSQL)
bin\create.bat tech-blog      # → WordPress (PHP 7.4 + MySQL)
bin\create.bat user-api       # → API (Laravel 8.4 + PostgreSQL)
```

## 🌐 URLs Reference (2025)

### 📍 Core Platform URLs
- **Main Dashboard**: http://localhost:8010
- **Laravel PHP 8.4**: http://localhost:8010/laravel.php
- **Laravel PHP 7.4**: http://localhost:8020
- **WordPress PHP 7.4**: http://localhost:8030

### 🛠️ Development Tools
- **Database Test**: http://localhost:8010/test-db.php
- **PHP Info**: http://localhost:8010/phpinfo.php
- **Mailhog**: http://localhost:8025

### 🐛 Xdebug Testing URLs
- **Laravel 8.4**: http://localhost:8010/phpinfo.php?XDEBUG_SESSION_START=VSCODE
- **Laravel 7.4**: http://localhost:8020/phpinfo.php?XDEBUG_SESSION_START=VSCODE
- **WordPress**: http://localhost:8030/phpinfo.php?XDEBUG_SESSION_START=VSCODE

## 🗄️ Database Credentials

### 🐬 MySQL
```
Host: localhost
Port: 3306
Username: mysql_user
Password: mysql_pass
Database: main_db
```

### 🐘 PostgreSQL
```
Host: localhost
Port: 5432
Username: postgres_user
Password: postgres_pass
Database: postgres
```

### 🔴 Redis
```
Host: localhost
Port: 6379
Password: (none)
```

## 🐛 Xdebug Configuration

### 📍 Debug Ports
- **Laravel PHP 7.4**: 9074
- **Laravel PHP 8.4**: 9084
- **WordPress PHP 7.4**: 9075

### ⚙️ VS Code Configuration
```json
{
    "name": "Listen for Xdebug (Laravel 8.4)",
    "type": "php",
    "request": "launch",
    "port": 9084,
    "pathMappings": {
        "/var/www/html": "${workspaceFolder}"
    }
}
```

## 💻 Database Commands

### 🐬 MySQL Operations
```bash
# Connect to MySQL
docker exec mysql_low_ram mysql -u mysql_user -pmysql_pass

# List databases
docker exec mysql_low_ram mysql -u mysql_user -pmysql_pass -e "SHOW DATABASES;"

# Create database
docker exec mysql_low_ram mysql -u mysql_user -pmysql_pass -e "CREATE DATABASE my_new_db;"
```

### 🐘 PostgreSQL Operations
```bash
# Connect to PostgreSQL
docker exec postgres_low_ram psql -U postgres_user -d postgres

# List databases
docker exec postgres_low_ram psql -U postgres_user -d postgres -c "\l"

# Create database
docker exec postgres_low_ram psql -U postgres_user -d postgres -c "CREATE DATABASE my_new_db;"
```

### 🔴 Redis Operations
```bash
# Connect to Redis
docker exec redis_low_ram redis-cli

# Test connection
docker exec redis_low_ram redis-cli ping
```

## 🔧 Troubleshooting

### ❌ Database Connection Failed
```bash
# Test connections
curl http://localhost:8010/test-db.php

# Check credentials (updated 2025)
# MySQL: mysql_user/mysql_pass
# PostgreSQL: postgres_user/postgres_pass
```

### ❌ Container Not Starting
```bash
# Check logs
docker logs [container-name]

# Restart specific container
docker restart [container-name]

# Full system restart
docker-compose -f docker-compose.low-ram.yml restart
```

### ❌ Port Conflicts
```bash
# Check port usage
netstat -an | findstr :8010

# Stop conflicting service
docker stop [container-name]
```

## 📊 Monitoring Commands

### 🔍 System Status
```bash
# Container status
docker ps

# Resource usage
docker stats

# Disk usage
docker system df

# Network info
docker network ls
```

### 🧪 Health Checks
```bash
# Test all databases
curl http://localhost:8010/test-db.php

# Check PHP info
curl http://localhost:8010/phpinfo.php

# Test email
curl http://localhost:8025
```

## 🎯 Best Practices

### 📝 Project Naming
- Use descriptive keywords: `my-shop`, `tech-blog`, `user-api`
- AI will auto-detect platform type from name
- Avoid special characters, use hyphens

### 🔄 Regular Maintenance
```bash
# Weekly cleanup
docker system prune -f

# Monthly optimization
docker-compose -f docker-compose.low-ram.yml down
docker volume prune -f
docker-compose -f docker-compose.low-ram.yml up -d
```

### 💾 Backup Important Data
```bash
# Backup database
docker exec postgres_low_ram pg_dump -U postgres_user my_db > backup.sql

# Backup project files
xcopy projects\my-project backup\my-project\ /E /I
```

---

**🌟 Docker Master Platform 2025 - Ready for Modern Development!**

*Multi-PHP • Dual-Database • Auto-Creation • Xdebug Ready*
