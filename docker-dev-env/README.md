# Docker Development Environment

Một hệ thống Docker-based hoàn chỉnh để thay thế MAMP, MySQL, PostgreSQL với khả năng hỗ trợ nhiều phiên bản PHP, tự động tạo virtual hosts và quản lý dễ dàng.

## 🚀 Tính năng

- **Multi-PHP Support**: PHP 7.4, 8.2, 8.4 với Xdebug
- **Database**: MySQL 8.0, PostgreSQL 15, Redis
- **Web Server**: Nginx với auto virtual hosts
- **Management UI**: Adminer, phpMyAdmin
- **Auto Scripts**: Tự động tạo project và virtual host
- **Cross-platform**: Hỗ trợ Windows, macOS, Linux

## 📁 Cấu trúc thư mục

```
docker-dev-env/
├── docker-compose.yml          # Docker services configuration
├── .env                        # Environment variables
├── .env.example               # Environment template
├── README.md                  # Documentation
│
├── bin/                       # Management scripts
│   ├── dev.sh                # Linux/macOS management script
│   ├── dev.bat               # Windows management script
│   ├── generate-vhost.sh     # Linux/macOS vhost generator
│   └── generate-vhost.bat    # Windows vhost generator
│
├── nginx/                     # Nginx configuration
│   ├── default.conf          # Default server config
│   └── sites/                # Virtual hosts directory
│       ├── project-template.conf
│       └── *.local.conf      # Auto-generated vhosts
│
├── php/                       # PHP configurations
│   ├── 7.4/
│   │   ├── Dockerfile
│   │   ├── php.ini
│   │   └── xdebug.ini
│   ├── 8.2/
│   │   ├── Dockerfile
│   │   ├── php.ini
│   │   └── xdebug.ini
│   └── 8.4/
│       ├── Dockerfile
│       ├── php.ini
│       └── xdebug.ini
│
├── www/                       # Projects directory
│   └── your-projects/
│
├── database/                  # Database data
│   ├── mysql/data/
│   └── postgresql/data/
│
└── logs/                      # Service logs
    ├── nginx/
    ├── php74/
    ├── php82/
    ├── php84/
    ├── mysql/
    └── postgresql/
```

## 🛠️ Cài đặt

### 📚 **Complete Documentation:**

**👉 [📚 DOCUMENTATION.md](DOCUMENTATION.md) - Chọn hướng dẫn phù hợp với bạn**

**📁 docs/ - Detailed Documentation:**
- **🚀 [docs/INSTALLATION.md](docs/INSTALLATION.md)** - Hướng dẫn cài đặt từ đầu chi tiết
- **📋 [docs/STEP_BY_STEP.md](docs/STEP_BY_STEP.md)** - Hướng dẫn từng bước cho người mới
- **⚡ [docs/QUICK_START.md](docs/QUICK_START.md)** - Hướng dẫn nhanh 5 phút
- **🔧 [docs/COMMANDS.md](docs/COMMANDS.md)** - Tổng hợp tất cả commands
- **🧠 [docs/AUTO_OPTIMIZATION.md](docs/AUTO_OPTIMIZATION.md)** - Chi tiết về auto RAM optimization
- **🚨 [docs/TROUBLESHOOTING.md](docs/TROUBLESHOOTING.md)** - Hướng dẫn xử lý lỗi
- **📚 [docs/INDEX.md](docs/INDEX.md)** - Navigation tất cả documentation

### ⚡ Quick Start:

**🎯 Cho người mới (Automated Setup):**
```bash
# 1. Clone repository
git clone <repository-url> docker-dev-env
cd docker-dev-env

# 2. Run setup script (guides you through everything)
bin\setup.bat           # Windows
./bin/setup.sh          # Linux/macOS
```

**🚀 Cho người có kinh nghiệm (Manual Setup):**
```bash
# 1. Clone repository
git clone <repository-url> docker-dev-env
cd docker-dev-env

# 2. Copy environment file
cp .env.example .env    # Linux/macOS
copy .env.example .env  # Windows

# 3. Start with auto-optimization
./bin/dev.sh start      # Linux/macOS
bin\dev.bat start       # Windows
```

### 🎯 **Cho người mới bắt đầu:**
👉 **Chạy setup script hoặc đọc [STEP_BY_STEP.md](STEP_BY_STEP.md)** để có hướng dẫn chi tiết từng bước

## 📖 Hướng dẫn sử dụng

### Quản lý Services

**Khởi động tất cả services:**
```bash
./bin/dev.sh start        # Linux/macOS
bin\dev.bat start         # Windows
```

**Dừng tất cả services:**
```bash
./bin/dev.sh stop         # Linux/macOS
bin\dev.bat stop          # Windows
```

**Xem trạng thái:**
```bash
./bin/dev.sh status       # Linux/macOS
bin\dev.bat status        # Windows
```

**Xem logs:**
```bash
./bin/dev.sh logs         # Tất cả services
./bin/dev.sh logs nginx   # Service cụ thể
```

### Tạo Project mới

**Tạo project với PHP 8.4:**
```bash
./bin/dev.sh create-project myproject php84 public
```

**Tạo project với PHP 7.4:**
```bash
./bin/dev.sh create-project oldproject php74 public
```

**Tham số:**
- `myproject`: Tên project
- `php84`: Phiên bản PHP (php74, php82, php84)
- `public`: Thư mục public (public, www, htdocs)

### Cấu hình Hosts File

Sau khi tạo project, thêm vào hosts file:

**Windows:** `C:\Windows\System32\drivers\etc\hosts`
**Linux/macOS:** `/etc/hosts`

```
127.0.0.1 myproject.local
127.0.0.1 oldproject.local
```

### Access URLs

- **Web Projects**: `http://project-name.local`
- **Default**: `http://localhost`
- **Adminer**: `http://localhost:8080`
- **phpMyAdmin**: `http://localhost:8081`

## 🗄️ Database Configuration

### MySQL
- **Host**: `localhost` hoặc `mysql`
- **Port**: `3306`
- **Username**: `dev_user` (hoặc theo .env)
- **Password**: `dev_pass` (hoặc theo .env)
- **Database**: `dev_db` (hoặc theo .env)

### PostgreSQL
- **Host**: `localhost` hoặc `postgresql`
- **Port**: `5432`
- **Username**: `dev_user` (hoặc theo .env)
- **Password**: `dev_pass` (hoặc theo .env)
- **Database**: `dev_db` (hoặc theo .env)

### Redis
- **Host**: `localhost` hoặc `redis`
- **Port**: `6379`
- **Password**: (không có hoặc theo .env)

## 🐛 Debug với Xdebug

### VS Code Configuration

Tạo file `.vscode/launch.json`:

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

### Xdebug Settings

- **Port**: `9003`
- **IDE Key**: `VSCODE`
- **Host**: `host.docker.internal`

## 🔧 Commands Reference

### Development Commands

```bash
# Build images
./bin/dev.sh build

# Rebuild images (no cache)
./bin/dev.sh rebuild

# Open shell in container
./bin/dev.sh shell php84
./bin/dev.sh shell mysql

# List all projects
./bin/dev.sh list-projects

# Cleanup unused containers
./bin/dev.sh cleanup

# Show help
./bin/dev.sh help
```

### Docker Compose Commands

```bash
# Start specific service
docker-compose up -d nginx

# View logs
docker-compose logs -f php84

# Execute command in container
docker-compose exec php84 composer install
docker-compose exec mysql mysql -u root -p

# Scale services (if needed)
docker-compose up -d --scale php84=2
```

## 📝 Example Projects

Xem thư mục `examples/` để có các project mẫu:

- **WordPress PHP 7.4**: `examples/wordpress-php74/`
- **Laravel PHP 8.4**: `examples/laravel-php84/`
- **Basic PHP**: `examples/basic-php/`

## 🚨 Troubleshooting

### Port conflicts
```bash
# Check ports in use
netstat -tulpn | grep :80
netstat -tulpn | grep :3306

# Change ports in .env file
NGINX_PORT=8080
MYSQL_PORT=3307
```

### Permission issues (Linux/macOS)
```bash
# Fix permissions
sudo chown -R $USER:$USER www/
chmod -R 755 www/
```

### Container not starting
```bash
# Check logs
./bin/dev.sh logs service-name

# Rebuild containers
./bin/dev.sh rebuild
```

### Xdebug not working
1. Check VS Code extension installed
2. Verify port 9003 is not blocked
3. Check pathMappings in launch.json
4. Restart PHP container

## 🔄 Updates & Maintenance

### Update images
```bash
docker-compose pull
./bin/dev.sh rebuild
```

### Backup databases
```bash
# MySQL backup
docker-compose exec mysql mysqldump -u root -p dev_db > backup.sql

# PostgreSQL backup
docker-compose exec postgresql pg_dump -U dev_user dev_db > backup.sql
```

### Clean up
```bash
# Remove unused containers and images
./bin/dev.sh cleanup

# Remove all data (careful!)
docker-compose down -v
```

## 📞 Support

Nếu gặp vấn đề, hãy:

1. Kiểm tra logs: `./bin/dev.sh logs`
2. Kiểm tra Docker status: `docker ps`
3. Restart services: `./bin/dev.sh restart`
4. Rebuild nếu cần: `./bin/dev.sh rebuild`

---

**Happy Coding! 🎉**
