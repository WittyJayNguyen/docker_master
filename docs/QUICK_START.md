# 🚀 Quick Start Guide

Hướng dẫn nhanh để bắt đầu với Docker Development Environment.

## ⚡ 5 phút setup

### 1. Khởi động environment

```bash
# Linux/macOS
chmod +x bin/dev.sh
./bin/dev.sh start

# Windows
bin\dev.bat start
```

### 2. Tạo project đầu tiên

```bash
# Tạo project PHP cơ bản
./bin/dev.sh create-project myproject php84 public

# Hoặc tạo project Laravel
./bin/dev.sh create-project mylaravel php84 public
```

### 3. Cấu hình hosts file

Thêm vào hosts file:
```
127.0.0.1 myproject.local
127.0.0.1 mylaravel.local
```

**Hosts file location:**
- Windows: `C:\Windows\System32\drivers\etc\hosts`
- Linux/macOS: `/etc/hosts`

### 4. Truy cập project

- Project: `http://myproject.local`
- Adminer: `http://localhost:8080`
- phpMyAdmin: `http://localhost:8081`

## 🎯 Common Tasks

### Tạo project WordPress

```bash
# 1. Tạo project
./bin/dev.sh create-project myblog php74 public

# 2. Download WordPress
cd www/myblog
curl -O https://wordpress.org/latest.tar.gz
tar -xzf latest.tar.gz --strip-components=1 -C public/

# 3. Tạo database
docker-compose exec mysql mysql -u root -p
# CREATE DATABASE myblog;

# 4. Cấu hình wp-config.php
# DB_HOST: mysql
# DB_USER: dev_user
# DB_PASS: dev_pass
```

### Tạo project Laravel

```bash
# 1. Tạo project
./bin/dev.sh create-project myapp php84 public

# 2. Cài đặt Laravel
docker-compose exec php84 /bin/sh
cd /var/www/html/myapp
composer create-project laravel/laravel . --prefer-dist

# 3. Cấu hình .env
# DB_HOST=mysql
# DB_USERNAME=dev_user
# DB_PASSWORD=dev_pass

# 4. Chạy migrations
php artisan migrate
```

### Debug với VS Code

1. Cài đặt PHP Debug extension
2. Tạo `.vscode/launch.json`:

```json
{
    "version": "0.2.0",
    "configurations": [
        {
            "name": "Listen for Xdebug",
            "type": "php",
            "request": "launch",
            "port": 9003,
            "pathMappings": {
                "/var/www/html": "${workspaceFolder}/www"
            }
        }
    ]
}
```

3. Đặt breakpoint và bắt đầu debug

## 🔧 Useful Commands

```bash
# Xem trạng thái services
./bin/dev.sh status

# Xem logs
./bin/dev.sh logs nginx
./bin/dev.sh logs php84

# Vào container
./bin/dev.sh shell php84
./bin/dev.sh shell mysql

# Restart services
./bin/dev.sh restart

# Dọn dẹp
./bin/dev.sh cleanup
```

## 🗄️ Database Access

### MySQL
- Host: `localhost:3306`
- User: `dev_user`
- Pass: `dev_pass`
- DB: `dev_db`

### PostgreSQL
- Host: `localhost:5432`
- User: `dev_user`
- Pass: `dev_pass`
- DB: `dev_db`

### Redis
- Host: `localhost:6379`

## 🚨 Troubleshooting

### Port đã được sử dụng
```bash
# Thay đổi ports trong .env
NGINX_PORT=8080
MYSQL_PORT=3307
```

### Container không start
```bash
# Xem logs
./bin/dev.sh logs service-name

# Rebuild
./bin/dev.sh rebuild
```

### Permission errors (Linux/macOS)
```bash
sudo chown -R $USER:$USER www/
chmod -R 755 www/
```

### Xdebug không hoạt động
1. Kiểm tra VS Code PHP Debug extension
2. Kiểm tra port 9003 không bị block
3. Restart PHP container: `docker-compose restart php84`

## 📚 Next Steps

1. Đọc [README.md](README.md) để hiểu chi tiết
2. Xem [examples/](examples/) để có project mẫu
3. Tùy chỉnh `.env` theo nhu cầu
4. Tạo virtual hosts cho projects hiện có

## 🎉 You're Ready!

Environment đã sẵn sàng để phát triển. Happy coding! 🚀
