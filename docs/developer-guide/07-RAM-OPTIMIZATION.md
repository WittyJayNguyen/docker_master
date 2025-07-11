# 🚀 Tối ưu RAM cho Docker Master Platform

> **Mục tiêu**: Giảm thiểu RAM usage từ ~4-6GB xuống ~2-3GB

## 📊 Phân tích RAM hiện tại

### Kiểm tra RAM usage
```bash
# Xem RAM usage của tất cả containers
docker stats --no-stream

# Xem chi tiết từng container
docker stats --format "table {{.Container}}\t{{.CPUPerc}}\t{{.MemUsage}}\t{{.MemPerc}}"
```

### Containers tiêu tốn RAM nhiều nhất:
1. **PostgreSQL** (~200-300MB)
2. **MySQL** (~200-400MB) 
3. **Laravel PHP containers** (~100-200MB mỗi cái)
4. **pgAdmin** (~100-150MB)
5. **phpMyAdmin** (~50-100MB)

## ⚙️ Tối ưu cấu hình

### 1. Giới hạn RAM cho containers

Tạo file override để giới hạn RAM:

```yaml
# docker-compose.override.yml
version: '3.8'

services:
  # PostgreSQL - giảm từ 300MB xuống 150MB
  postgres:
    deploy:
      resources:
        limits:
          memory: 256M
        reservations:
          memory: 128M
    environment:
      - POSTGRES_SHARED_BUFFERS=32MB
      - POSTGRES_EFFECTIVE_CACHE_SIZE=128MB
      - POSTGRES_WORK_MEM=4MB

  # MySQL - giảm từ 400MB xuống 200MB  
  mysql:
    deploy:
      resources:
        limits:
          memory: 256M
        reservations:
          memory: 128M
    command: >
      --innodb-buffer-pool-size=64M
      --innodb-log-file-size=32M
      --max-connections=50
      --table-open-cache=32
      --query-cache-size=16M

  # Redis - giảm từ 50MB xuống 32MB
  redis:
    deploy:
      resources:
        limits:
          memory: 64M
        reservations:
          memory: 32M
    command: redis-server --maxmemory 32mb --maxmemory-policy allkeys-lru

  # Laravel PHP 8.4 - giảm từ 200MB xuống 128MB
  laravel-php84-psql:
    deploy:
      resources:
        limits:
          memory: 256M
        reservations:
          memory: 128M

  # Laravel PHP 7.4 - giảm từ 200MB xuống 128MB
  laravel-php74-psql:
    deploy:
      resources:
        limits:
          memory: 256M
        reservations:
          memory: 128M

  # WordPress - giảm từ 200MB xuống 128MB
  wordpress-php74-mysql:
    deploy:
      resources:
        limits:
          memory: 256M
        reservations:
          memory: 128M

  # pgAdmin - giảm từ 150MB xuống 64MB
  pgadmin:
    deploy:
      resources:
        limits:
          memory: 128M
        reservations:
          memory: 64M

  # phpMyAdmin - giảm từ 100MB xuống 64MB
  phpmyadmin:
    deploy:
      resources:
        limits:
          memory: 128M
        reservations:
          memory: 64M

  # Mailhog - giảm từ 50MB xuống 32MB
  mailhog:
    deploy:
      resources:
        limits:
          memory: 64M
        reservations:
          memory: 32M
```

### 2. Tối ưu PHP configuration

Cập nhật PHP settings để tiết kiệm RAM:

```ini
# docker/php74/php-optimized.ini
; Memory settings - giảm từ 256M xuống 128M
memory_limit = 128M
max_execution_time = 300

; OPcache settings - tối ưu cho RAM thấp
opcache.enable = 1
opcache.memory_consumption = 64
opcache.interned_strings_buffer = 4
opcache.max_accelerated_files = 2000
opcache.revalidate_freq = 2
opcache.fast_shutdown = 1

; Disable unused extensions
;extension=imagick
;extension=gd

; Reduce file upload limits
upload_max_filesize = 32M
post_max_size = 32M
max_file_uploads = 10
```

```ini
# docker/php84/php-optimized.ini  
; Memory settings - giảm từ 512M xuống 256M
memory_limit = 256M
max_execution_time = 300

; OPcache settings - tối ưu cho RAM thấp
opcache.enable = 1
opcache.memory_consumption = 128
opcache.interned_strings_buffer = 8
opcache.max_accelerated_files = 4000
opcache.revalidate_freq = 2
opcache.fast_shutdown = 1

; Reduce file upload limits
upload_max_filesize = 32M
post_max_size = 32M
max_file_uploads = 10
```

### 3. Tối ưu Database configurations

#### PostgreSQL optimization:
```sql
-- docker/postgres/postgresql-optimized.conf
# Memory settings
shared_buffers = 32MB
effective_cache_size = 128MB
work_mem = 4MB
maintenance_work_mem = 16MB

# Connection settings
max_connections = 50

# Checkpoint settings
checkpoint_completion_target = 0.9
wal_buffers = 1MB
```

#### MySQL optimization:
```cnf
# docker/mysql/my-optimized.cnf
[mysqld]
# Memory settings
innodb_buffer_pool_size = 64M
innodb_log_file_size = 32M
innodb_log_buffer_size = 8M

# Connection settings
max_connections = 50
table_open_cache = 32
query_cache_size = 16M
query_cache_limit = 1M

# Disable unused features
skip-name-resolve
```

## 🔧 Cấu hình tối ưu cho máy RAM thấp

### Profile cho máy 4GB RAM:
```yaml
# docker-compose.low-ram.yml
version: '3.8'

services:
  # Chỉ chạy services cần thiết
  postgres:
    <<: *postgres-optimized
  
  redis:
    <<: *redis-optimized
    
  # Chỉ chạy 1 PHP version (PHP 8.4)
  laravel-php84-psql:
    <<: *php-optimized
    
  # Tắt các services không cần thiết
  # mysql: (comment out)
  # laravel-php74-psql: (comment out) 
  # wordpress-php74-mysql: (comment out)
  # pgadmin: (comment out)
  # phpmyadmin: (comment out)
```

### Profile cho máy 8GB RAM:
```yaml
# docker-compose.medium-ram.yml
version: '3.8'

services:
  # Chạy đầy đủ nhưng với giới hạn RAM
  postgres:
    <<: *postgres-optimized
    
  mysql:
    <<: *mysql-optimized
    
  redis:
    <<: *redis-optimized
    
  laravel-php84-psql:
    <<: *php-optimized
    
  laravel-php74-psql:
    <<: *php-optimized
    
  # Tắt admin tools khi không cần
  # pgadmin: (comment out khi không debug)
  # phpmyadmin: (comment out khi không debug)
```

## 📋 Scripts tối ưu

### Script chọn profile RAM:
```bash
# scripts/optimize-ram.bat
@echo off
echo Select RAM optimization profile:
echo 1. Low RAM (4GB) - Only essential services
echo 2. Medium RAM (8GB) - All services with limits  
echo 3. High RAM (16GB+) - Default configuration
set /p choice="Enter choice (1-3): "

if %choice%==1 (
    echo Starting low RAM profile...
    docker-compose -f docker-compose.yml -f docker-compose.low-ram.yml up -d
) else if %choice%==2 (
    echo Starting medium RAM profile...
    docker-compose -f docker-compose.yml -f docker-compose.override.yml up -d
) else (
    echo Starting default profile...
    docker-compose up -d
)
```

### Script monitor RAM:
```bash
# scripts/monitor-ram.bat
@echo off
echo Docker RAM Usage Monitor
echo ========================
docker stats --format "table {{.Container}}\t{{.MemUsage}}\t{{.MemPerc}}" --no-stream
echo.
echo Total Docker RAM usage:
docker system df
```

## 🎯 Chiến lược tối ưu theo use case

### 1. Development cơ bản (1-2GB RAM):
```bash
# Chỉ chạy 1 PHP version + PostgreSQL + Redis
docker-compose up -d postgres redis laravel-php84-psql
```

### 2. Full development (2-3GB RAM):
```bash
# Chạy tất cả nhưng với giới hạn RAM
docker-compose -f docker-compose.yml -f docker-compose.override.yml up -d
```

### 3. Production-like (3-4GB RAM):
```bash
# Chạy đầy đủ với monitoring
docker-compose up -d
```

## 🔄 Áp dụng tối ưu

### Bước 1: Tạo file override
```bash
# Tạo file docker-compose.override.yml với nội dung ở trên
```

### Bước 2: Restart với cấu hình mới
```bash
# Stop containers hiện tại
docker-compose down

# Start với cấu hình tối ưu
docker-compose up -d

# Kiểm tra RAM usage
docker stats --no-stream
```

### Bước 3: Monitor và điều chỉnh
```bash
# Theo dõi RAM usage
watch docker stats

# Nếu container bị kill do OOM, tăng memory limit
# Nếu RAM dư thừa, có thể giảm thêm
```

## 📊 Kết quả mong đợi

### Trước tối ưu:
- **Total RAM**: ~4-6GB
- **PostgreSQL**: ~300MB
- **MySQL**: ~400MB
- **PHP containers**: ~200MB mỗi cái
- **Admin tools**: ~250MB

### Sau tối ưu:
- **Total RAM**: ~2-3GB (giảm 50%)
- **PostgreSQL**: ~150MB
- **MySQL**: ~200MB  
- **PHP containers**: ~128MB mỗi cái
- **Admin tools**: ~128MB

## ⚠️ Lưu ý quan trọng

1. **Performance trade-off**: Giảm RAM có thể làm chậm performance
2. **Monitor OOM**: Theo dõi containers có bị kill do out of memory
3. **Adjust limits**: Điều chỉnh memory limits theo nhu cầu thực tế
4. **Database performance**: Database với RAM thấp sẽ chậm hơn
5. **Development vs Production**: Cấu hình khác nhau cho môi trường khác nhau

## 🎯 Quick Commands

```bash
# Áp dụng tối ưu RAM
docker-compose -f docker-compose.yml -f docker-compose.override.yml up -d

# Chỉ chạy services cần thiết
docker-compose up -d postgres redis laravel-php84-psql

# Monitor RAM usage
docker stats --format "table {{.Container}}\t{{.MemUsage}}\t{{.MemPerc}}"

# Restart container nếu cần
docker-compose restart laravel-php84-psql
```
