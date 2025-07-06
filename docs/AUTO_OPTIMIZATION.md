# 🧠 Auto RAM Optimization

Hệ thống tự động phát hiện RAM và tối ưu cấu hình cho bất kỳ máy nào.

## 🚀 Tính năng Auto-Optimization

### ✅ **Tự động phát hiện RAM:**
- **Windows**: PowerShell + WMIC fallback
- **Linux**: /proc/meminfo + free command
- **macOS**: sysctl hw.memsize
- **WSL/Git Bash**: Multiple detection methods

### ✅ **Dynamic Configuration:**
- **MySQL**: InnoDB buffer, query cache, connections
- **PHP**: Memory limit, OPcache, JIT buffer
- **Nginx**: Workers, connections, buffers
- **Docker**: Container memory limits

### ✅ **Smart Profiles:**

| RAM Size | Profile | MySQL InnoDB | PHP Memory | OPcache | Description |
|----------|---------|--------------|------------|---------|-------------|
| ≤ 4GB | Low RAM (Conservative) | ~200MB | 256MB | 64MB | Minimal resource usage |
| ≤ 8GB | Medium RAM (Balanced) | ~400MB | 512MB | 128MB | Balanced performance |
| ≤ 16GB | High RAM (Performance) | ~1GB | 1GB | 256MB | Performance focused |
| > 16GB | Very High RAM (Max) | ~2GB | 2GB | 512MB | Maximum performance |

## 🔧 Cách sử dụng

### 1. **Auto-optimization khi start:**
```bash
# Windows
bin\dev.bat start

# Linux/macOS
./bin/dev.sh start
```

### 2. **Manual optimization:**
```bash
# Windows
bin\auto-optimize.bat

# Linux/macOS
./bin/auto-optimize.sh
```

### 3. **Test RAM detection:**
```bash
# Windows
bin\test-ram-detection.bat

# Linux/macOS
./bin/test-ram-detection.sh
```

## 📊 Monitoring

### **Real-time status:**
- **Web Interface**: `http://localhost/ram-optimization.php`
- **Container Stats**: `docker stats`
- **RAM Monitor**: `bin\monitor-ram.bat`

### **Optimization Files:**
- **Config Storage**: `.ram-optimized` (stores detected RAM)
- **MySQL Config**: `database/mysql/conf/my.cnf`
- **PHP Configs**: `php/*/php.ini`

## 🎯 Optimization Logic

### **MySQL Allocation:**
```
Low RAM (≤4GB):    20% of total RAM
Medium RAM (≤8GB):  25% of total RAM  
High RAM (≤16GB):   30% of total RAM
Very High (>16GB):  25% of total RAM (capped for development)
```

### **PHP Memory:**
```
Low RAM:    256MB script + 64MB OPcache
Medium RAM: 512MB script + 128MB OPcache
High RAM:   1GB script + 256MB OPcache
Very High:  2GB script + 512MB OPcache
```

### **Container Limits:**
```
MySQL:      25% of total RAM (min 256MB, max 4GB)
PHP (each): 10% of total RAM (min 128MB, max 512MB)
Nginx:      5% of total RAM (min 64MB, max 256MB)
```

## 🔄 Re-optimization

Hệ thống tự động phát hiện khi RAM thay đổi:

1. **Detect RAM change**: So sánh với `.ram-optimized`
2. **Auto re-optimize**: Chạy lại optimization nếu RAM khác
3. **Skip if same**: Bỏ qua nếu RAM không đổi
4. **Update configs**: Cập nhật tất cả config files

## 🌍 Cross-Platform Support

### **Windows:**
- PowerShell (primary)
- WMIC (fallback)
- SystemInfo (backup)

### **Linux:**
- /proc/meminfo (primary)
- free command (fallback)
- Multiple detection methods

### **macOS:**
- sysctl hw.memsize
- Cross-platform compatibility

### **WSL/Git Bash:**
- PowerShell.exe integration
- Linux-style fallbacks

## 📝 Example Scenarios

### **Laptop 8GB RAM:**
```
Profile: Medium RAM (Balanced)
MySQL InnoDB: 400MB
PHP Memory: 512MB per script
OPcache: 128MB
Container Limits: MySQL 512MB, PHP 256MB each
```

### **Workstation 32GB RAM:**
```
Profile: Very High RAM (Maximum Performance)
MySQL InnoDB: 2GB
PHP Memory: 2GB per script
OPcache: 512MB
Container Limits: MySQL 2GB, PHP 512MB each
```

### **Server 64GB RAM:**
```
Profile: Very High RAM (Maximum Performance)
MySQL InnoDB: 2GB (capped for development)
PHP Memory: 2GB per script
OPcache: 512MB
Container Limits: MySQL 4GB, PHP 512MB each
```

## 🚨 Troubleshooting

### **RAM Detection Failed:**
```bash
# Manual detection test
bin\test-ram-detection.bat

# Force specific RAM
echo 16 > .ram-optimized
bin\optimize-ram.bat
```

### **Performance Issues:**
```bash
# Check current optimization
http://localhost/ram-optimization.php

# Monitor resource usage
docker stats

# Re-optimize
bin\auto-optimize.bat
```

### **Config Problems:**
```bash
# Reset to defaults
del .ram-optimized
bin\auto-optimize.bat

# Check generated configs
type database\mysql\conf\my.cnf
type php\8.4\php.ini
```

## 🎉 Benefits

### **Portability:**
- ✅ Chạy trên bất kỳ máy nào
- ✅ Tự động tối ưu theo hardware
- ✅ Không cần config thủ công

### **Performance:**
- ✅ Tối ưu memory allocation
- ✅ Tránh over/under allocation
- ✅ Adaptive theo system resources

### **Maintenance:**
- ✅ Auto-update khi hardware thay đổi
- ✅ Smart caching optimization results
- ✅ Easy monitoring và debugging

---

**🚀 Bây giờ bạn có thể copy source code này sang bất kỳ máy nào và nó sẽ tự động tối ưu theo RAM của máy đó!**
