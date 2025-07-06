# 🚀 Docker Development Environment - Installation Guide

Hướng dẫn cài đặt từ đầu cho Docker Development Environment với auto RAM optimization.

## 📋 Yêu cầu hệ thống

### **Minimum Requirements:**
- **RAM**: 4GB (khuyến nghị 8GB+)
- **Storage**: 10GB free space
- **OS**: Windows 10/11, macOS 10.14+, Ubuntu 18.04+

### **Software Requirements:**
- **Docker Desktop** (latest version)
- **Git** (for cloning repository)
- **Text Editor** (VS Code khuyến nghị)

## 🛠️ Bước 1: Cài đặt Docker Desktop

### **Windows:**
1. Download Docker Desktop: https://www.docker.com/products/docker-desktop/
2. Chạy installer và follow instructions
3. Restart máy khi được yêu cầu
4. Mở Docker Desktop và đợi khởi động

### **macOS:**
1. Download Docker Desktop for Mac
2. Drag Docker.app vào Applications folder
3. Launch Docker từ Applications
4. Authorize với password khi được yêu cầu

### **Linux (Ubuntu/Debian):**
```bash
# Update package index
sudo apt update

# Install required packages
sudo apt install apt-transport-https ca-certificates curl gnupg lsb-release

# Add Docker's official GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

# Add Docker repository
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Install Docker Engine
sudo apt update
sudo apt install docker-ce docker-ce-cli containerd.io docker-compose-plugin

# Add user to docker group
sudo usermod -aG docker $USER

# Logout and login again
```

### **Verify Docker Installation:**
```bash
# Check Docker version
docker --version

# Check Docker Compose
docker-compose --version

# Test Docker
docker run hello-world
```

## 📥 Bước 2: Download Source Code

### **Option 1: Git Clone (Recommended)**
```bash
# Clone repository
git clone <repository-url> docker-dev-env
cd docker-dev-env
```

### **Option 2: Download ZIP**
1. Download ZIP file từ repository
2. Extract vào folder `docker-dev-env`
3. Mở terminal/command prompt trong folder

### **Option 3: Manual Setup (Nếu không có Git)**
```bash
# Tạo folder structure
mkdir docker-dev-env
cd docker-dev-env

# Tạo các folder cần thiết
mkdir bin nginx php www database logs
mkdir nginx/sites php/7.4 php/8.2 php/8.4
mkdir database/mysql database/postgresql database/redis
mkdir database/mysql/data database/mysql/init database/mysql/conf
mkdir database/postgresql/data database/postgresql/init
mkdir logs/nginx logs/php74 logs/php82 logs/php84 logs/mysql logs/postgresql
```

## ⚙️ Bước 3: Setup Environment

### **Copy Environment File:**
```bash
# Windows
copy .env.example .env

# Linux/macOS
cp .env.example .env
```

### **Edit Environment Variables (Optional):**
```bash
# Windows
notepad .env

# Linux/macOS
nano .env
```

**Các biến có thể tùy chỉnh:**
```env
# Database passwords
MYSQL_ROOT_PASSWORD=your_password
MYSQL_PASSWORD=your_password
POSTGRES_PASSWORD=your_password

# Ports (nếu bị conflict)
NGINX_PORT=80
MYSQL_PORT=3306
POSTGRESQL_PORT=5432

# Timezone
TIMEZONE=Asia/Ho_Chi_Minh
```

## 🚀 Bước 4: First Time Setup

### **Windows:**
```cmd
# Make scripts executable (if needed)
# Right-click on bin folder -> Properties -> Security -> Allow execution

# Run auto-optimization
bin\auto-optimize.bat

# Start environment
bin\dev.bat start
```

### **Linux/macOS:**
```bash
# Make scripts executable
chmod +x bin/*.sh

# Run auto-optimization
./bin/auto-optimize.sh

# Start environment
./bin/dev.sh start
```

### **Alternative: Manual Docker Commands:**
```bash
# Build and start all services
docker-compose up -d --build

# Check status
docker-compose ps

# View logs
docker-compose logs
```

## 🔍 Bước 5: Verify Installation

### **Check Services:**
```bash
# Check all containers are running
docker-compose ps

# Should show all services as "Up"
```

### **Test URLs:**
1. **Main Page**: http://localhost
2. **Database Test**: http://localhost/test-db.php
3. **RAM Optimization**: http://localhost/ram-optimization.php
4. **Adminer**: http://localhost:8080
5. **phpMyAdmin**: http://localhost:8081

### **Test Database Connections:**
```bash
# Test MySQL
docker-compose exec mysql mysql -u dev_user -p

# Test PostgreSQL
docker-compose exec postgresql psql -U dev_user -d dev_db

# Test Redis
docker-compose exec redis redis-cli ping
```

## 🎯 Bước 6: Create First Project

### **Using Scripts:**
```bash
# Windows
bin\dev.bat create-project myproject php84 public

# Linux/macOS
./bin/dev.sh create-project myproject php84 public
```

### **Manual Project Creation:**
```bash
# Create project folder
mkdir www/myproject
mkdir www/myproject/public

# Create index.php
echo "<?php phpinfo(); ?>" > www/myproject/public/index.php

# Create virtual host (copy from template)
# Windows
copy nginx\sites\project-template.conf.example nginx\sites\myproject.local.conf

# Linux/macOS
cp nginx/sites/project-template.conf.example nginx/sites/myproject.local.conf

# Edit virtual host
# Replace {{PROJECT_NAME}} with myproject
# Replace {{PHP_VERSION}} with dev_php84
# Replace {{PUBLIC_DIR}} with public
```

### **Add to Hosts File:**
```bash
# Windows: C:\Windows\System32\drivers\etc\hosts
# Linux/macOS: /etc/hosts
127.0.0.1 myproject.local
```

### **Restart Nginx:**
```bash
docker-compose restart nginx
```

### **Access Project:**
http://myproject.local

## 🔧 Bước 7: Development Tools Setup

### **VS Code Extensions (Recommended):**
- PHP Debug (Xdebug support)
- Docker (container management)
- PHP Intelephense (PHP language support)
- GitLens (Git integration)

### **Xdebug Configuration:**
Create `.vscode/launch.json`:
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

## 📊 Bước 8: Monitoring & Maintenance

### **Monitor Resource Usage:**
```bash
# Real-time container stats
docker stats

# RAM monitoring script
# Windows
bin\monitor-ram.bat

# Linux/macOS
./bin/monitor-ram.sh
```

### **Common Commands:**
```bash
# Start services
docker-compose up -d

# Stop services
docker-compose down

# Restart specific service
docker-compose restart nginx

# View logs
docker-compose logs nginx

# Access container shell
docker-compose exec php84 /bin/sh

# Backup database
docker-compose exec mysql mysqldump -u root -p dev_db > backup.sql
```

## 🚨 Troubleshooting

### **Port Conflicts:**
```bash
# Check what's using port 80
# Windows
netstat -ano | findstr :80

# Linux/macOS
lsof -i :80

# Change ports in .env
NGINX_PORT=8080
MYSQL_PORT=3307
```

### **Permission Issues (Linux/macOS):**
```bash
# Fix file permissions
sudo chown -R $USER:$USER .
chmod -R 755 www/
```

### **Docker Issues:**
```bash
# Restart Docker Desktop
# Windows/macOS: Restart Docker Desktop app

# Linux: Restart Docker service
sudo systemctl restart docker

# Clean up Docker
docker system prune -f
```

### **Memory Issues:**
```bash
# Check RAM optimization
http://localhost/ram-optimization.php

# Re-run optimization
bin\auto-optimize.bat

# Reduce container limits in docker-compose.yml
```

## ✅ Success Checklist

- [ ] Docker Desktop installed and running
- [ ] Source code downloaded/cloned
- [ ] Environment file configured
- [ ] Auto-optimization completed
- [ ] All containers running (docker-compose ps)
- [ ] Main page accessible (http://localhost)
- [ ] Database connections working
- [ ] First project created and accessible
- [ ] Xdebug configured (if using VS Code)

## 🎉 Next Steps

1. **Read Documentation:**
   - [README.md](README.md) - Complete feature overview
   - [QUICK_START.md](QUICK_START.md) - 5-minute quick start
   - [AUTO_OPTIMIZATION.md](AUTO_OPTIMIZATION.md) - RAM optimization details

2. **Explore Examples:**
   - [examples/](examples/) - Sample projects
   - WordPress, Laravel, Basic PHP examples

3. **Customize:**
   - Modify .env for your needs
   - Add custom virtual hosts
   - Install additional PHP extensions

4. **Deploy Projects:**
   - Create Laravel projects
   - Setup WordPress sites
   - Build custom PHP applications

---

**🚀 Congratulations! Your Docker Development Environment is ready!**

For support and updates, check the repository documentation.
