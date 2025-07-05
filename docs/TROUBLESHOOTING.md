# 🚨 Troubleshooting - Docker Master Platform

> **Hướng dẫn khắc phục các lỗi thường gặp**

## ⚠️ Lỗi Database Connection (Phổ biến nhất)

### 🔍 Triệu chứng:
- **phpMyAdmin**: "Không thể kết nối: cài đặt sai"
- **MySQL error**: "mysqli::real_connect(): php_network_getaddresses: getaddrinfo for mysql failed"
- **Containers restart** liên tục trong `bin\status.bat`
- **Services "Not responding"** trong status check

### 🛠️ Giải pháp nhanh:

```bash
# Chạy script tự động khắc phục (RECOMMENDED)
scripts\fix-database-corruption.bat
```

### 🔧 Giải pháp thủ công:

```bash
# 1. Stop tất cả services
bin\stop.bat

# 2. Xóa database directories bị corrupted
rmdir /s /q data\mysql
rmdir /s /q data\postgres
rmdir /s /q data\redis

# 3. Tạo lại directories
mkdir data\mysql
mkdir data\postgres  
mkdir data\redis

# 4. Start lại
bin\start.bat
```

### 💡 Nguyên nhân:
- **Git operations** xóa database files
- **Improper shutdown** của containers
- **Disk space** không đủ
- **Permission issues** với data directories

---

## 🐳 Docker Issues

### ❌ "Docker is not running"

```bash
# Start Docker Desktop
# Sau đó chạy:
bin\start.bat
```

### ❌ Port conflicts

```bash
# Kiểm tra ports đang sử dụng
netstat -an | findstr :8080
netstat -an | findstr :3306

# Kill processes sử dụng ports
taskkill /F /PID <process_id>
```

### ❌ "Network already exists"

```bash
# Clean up Docker networks
docker network prune -f
bin\start.bat
```

---

## 💾 RAM Issues

### ⚠️ High RAM usage

```bash
# Check RAM usage
scripts\monitor-ram.bat

# Optimize RAM
scripts\optimize-ram.bat

# Restart with optimization
bin\restart.bat
```

### ❌ Out of memory errors

```bash
# Stop non-essential services
docker stop laravel_php74_psql_queue laravel_php84_psql_queue

# Or use low-RAM mode
docker-compose -f docker-compose.low-ram.yml up -d
```

---

## 🌐 Service Access Issues

### ❌ "Service not responding"

```bash
# Check container status
bin\status.bat

# Check specific service logs
docker logs mysql_server
docker logs phpmyadmin
docker logs postgres_server

# Restart specific service
docker restart mysql_server
```

### ❌ 403/404 errors

```bash
# Wait for services to fully start (2-3 minutes)
# Check logs for errors
docker-compose logs [service_name]

# Restart if needed
bin\restart.bat
```

---

## 📁 File Permission Issues

### ❌ "Permission denied"

```bash
# Run as Administrator
# Right-click Command Prompt → "Run as administrator"
bin\start.bat
```

### ❌ "Cannot create directory"

```bash
# Check disk space
dir

# Create directories manually
mkdir data\mysql data\postgres data\redis data\pgadmin
```

---

## 🔧 Git Issues

### ❌ "LF will be replaced by CRLF"

```bash
# Configure Git line endings
git config core.autocrlf true
git config core.safecrlf false
```

### ❌ "unable to index file"

```bash
# Usually database files - check .gitignore
git status --ignored

# Reset if needed
git reset --hard HEAD
```

---

## 🚀 Performance Issues

### ⚠️ Slow startup

```bash
# Normal startup time: 2-3 minutes
# If slower, check:

# 1. Available RAM
scripts\quick-ram-check.bat

# 2. Docker resources
docker system df

# 3. Restart Docker Desktop
```

### ⚠️ Services timeout

```bash
# Increase wait time in start script
# Or start services individually:

docker-compose up -d mysql_server postgres_server
# Wait 1 minute
docker-compose up -d phpmyadmin pgadmin
# Wait 1 minute  
docker-compose up -d
```

---

## 📋 Quick Diagnostic Commands

### System Status
```bash
bin\status.bat                    # Overall system status
docker ps                         # Running containers
docker-compose logs --tail 20     # Recent logs
```

### Resource Usage
```bash
scripts\monitor-ram.bat           # RAM usage
docker system df                  # Disk usage
docker stats                     # Real-time stats
```

### Network & Connectivity
```bash
docker network ls                 # Docker networks
netstat -an | findstr :80         # Port usage
ping localhost                    # Basic connectivity
```

---

## 🆘 Emergency Reset

### 🚨 Nếu tất cả đều fail:

```bash
# 1. Nuclear option - Reset everything
bin\stop.bat
docker system prune -a -f
rmdir /s /q data

# 2. Fresh start
mkdir data\mysql data\postgres data\redis data\pgadmin
bin\start.bat
```

### 📞 Get Help

1. **Check logs**: `docker-compose logs [service_name]`
2. **Run diagnostics**: `bin\status.bat`
3. **Check documentation**: `docs/` folder
4. **Try automatic fix**: `scripts\fix-database-corruption.bat`

---

## 💡 Prevention Tips

### ✅ Best Practices:
- **Always use** `bin\stop.bat` before shutdown
- **Don't delete** `data/` folders manually
- **Regular cleanup**: `scripts\cleanup.bat`
- **Monitor RAM**: `scripts\monitor-ram.bat`
- **Backup databases** before major changes

### ❌ Avoid:
- **Force killing** Docker processes
- **Editing** database files directly
- **Running multiple** Docker platforms simultaneously
- **Ignoring** restart warnings in status

---

**🎯 Trong 90% trường hợp, `scripts\fix-database-corruption.bat` sẽ khắc phục được vấn đề!** 🚀
