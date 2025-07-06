# 🚨 Troubleshooting Guide

Hướng dẫn xử lý các lỗi thường gặp khi sử dụng Docker Development Environment.

## 🔍 Diagnostic Commands

### **Quick Health Check:**
```bash
# Check container status
docker-compose ps

# Check Docker status
docker --version
docker info

# Check system resources
docker stats --no-stream

# Check logs
docker-compose logs --tail=50
```

---

## 🐳 Docker Issues

### **❌ Docker Desktop Not Starting**

**Symptoms:**
- Docker Desktop won't start
- "Docker Desktop starting..." forever
- Cannot connect to Docker daemon

**Solutions:**

**Windows:**
```cmd
# Restart Docker Desktop
# 1. Close Docker Desktop completely
# 2. Open Task Manager, kill all Docker processes
# 3. Restart Docker Desktop as Administrator

# Reset Docker Desktop
# 1. Docker Desktop → Settings → Reset → Reset to factory defaults

# Check WSL2 (if using WSL2 backend)
wsl --list --verbose
wsl --set-default-version 2
```

**macOS:**
```bash
# Restart Docker
sudo killall Docker
open /Applications/Docker.app

# Reset Docker
# Docker → Preferences → Reset → Reset to factory defaults
```

**Linux:**
```bash
# Restart Docker service
sudo systemctl restart docker

# Check Docker service status
sudo systemctl status docker

# Add user to docker group (if permission denied)
sudo usermod -aG docker $USER
# Logout and login again
```

### **❌ "Cannot connect to the Docker daemon"**

**Solutions:**
```bash
# Check if Docker is running
docker info

# Start Docker service (Linux)
sudo systemctl start docker

# Check Docker socket permissions (Linux)
sudo chmod 666 /var/run/docker.sock

# Restart Docker Desktop (Windows/macOS)
```

---

## 🔌 Port Conflicts

### **❌ "Port already in use" / "Address already in use"**

**Check what's using ports:**

**Windows:**
```cmd
# Check port 80
netstat -ano | findstr :80

# Check port 3306
netstat -ano | findstr :3306

# Kill process using port
taskkill /PID <PID> /F
```

**Linux/macOS:**
```bash
# Check port 80
lsof -i :80
sudo netstat -tulpn | grep :80

# Check port 3306
lsof -i :3306

# Kill process using port
sudo kill -9 <PID>
```

**Change ports in .env:**
```env
# Change conflicting ports
NGINX_PORT=8080
MYSQL_PORT=3307
POSTGRESQL_PORT=5433
ADMINER_PORT=8082
PHPMYADMIN_PORT=8083
```

**Restart services:**
```bash
docker-compose down
docker-compose up -d
```

---

## 🏗️ Build Issues

### **❌ "Build failed" / "Image build error"**

**Common Solutions:**

**Clear Docker cache:**
```bash
# Remove all containers and images
docker-compose down
docker system prune -a

# Rebuild without cache
docker-compose build --no-cache
docker-compose up -d
```

**Check Dockerfile syntax:**
```bash
# Validate Dockerfile
docker build --no-cache -t test-image php/8.4/

# Check for syntax errors in docker-compose.yml
docker-compose config
```

**Network issues during build:**
```bash
# If packages fail to download
# Check internet connection
# Try building again (temporary network issues)

# Use different package mirrors
# Edit Dockerfile to use different Alpine mirrors
```

### **❌ "No space left on device"**

**Clean up Docker:**
```bash
# Remove unused containers, networks, images
docker system prune -a

# Remove unused volumes
docker volume prune

# Check disk usage
docker system df

# Remove specific images
docker images
docker rmi <image_id>
```

---

## 🌐 Web Access Issues

### **❌ "This site can't be reached" / "Connection refused"**

**Check Nginx status:**
```bash
# Check if nginx container is running
docker-compose ps nginx

# Check nginx logs
docker-compose logs nginx

# Test nginx configuration
docker-compose exec nginx nginx -t

# Restart nginx
docker-compose restart nginx
```

**Check virtual host configuration:**
```bash
# List virtual hosts
ls nginx/sites/

# Check virtual host syntax
cat nginx/sites/myproject.local.conf

# Verify hosts file entry
# Windows: C:\Windows\System32\drivers\etc\hosts
# Linux/macOS: /etc/hosts
# Should contain: 127.0.0.1 myproject.local
```

### **❌ "502 Bad Gateway" / "504 Gateway Timeout"**

**Check PHP-FPM:**
```bash
# Check PHP container status
docker-compose ps php84

# Check PHP logs
docker-compose logs php84

# Restart PHP container
docker-compose restart php84

# Test PHP-FPM connection
docker-compose exec nginx nc -z php84 9000
```

**Check file permissions:**
```bash
# Fix permissions (Linux/macOS)
sudo chown -R $USER:$USER www/
chmod -R 755 www/

# Check if files exist
ls -la www/myproject/public/
```

---

## 🗄️ Database Issues

### **❌ MySQL Connection Failed**

**Check MySQL status:**
```bash
# Check MySQL container
docker-compose ps mysql

# Check MySQL logs
docker-compose logs mysql

# Test MySQL connection
docker-compose exec mysql mysql -u root -p
```

**Common MySQL issues:**

**Wrong credentials:**
```bash
# Check .env file
cat .env | grep MYSQL

# Reset MySQL password
docker-compose exec mysql mysql -u root -p -e "ALTER USER 'dev_user'@'%' IDENTIFIED BY 'new_password';"
```

**MySQL not starting:**
```bash
# Check MySQL configuration
docker-compose exec mysql cat /etc/mysql/conf.d/custom.cnf

# Remove corrupted data and restart
docker-compose down
rm -rf database/mysql/data/*
docker-compose up -d mysql
```

### **❌ PostgreSQL Connection Failed**

**Check PostgreSQL:**
```bash
# Check container status
docker-compose ps postgresql

# Check logs
docker-compose logs postgresql

# Test connection
docker-compose exec postgresql psql -U dev_user -d dev_db
```

**Reset PostgreSQL:**
```bash
# Remove data and restart
docker-compose down
rm -rf database/postgresql/data/*
docker-compose up -d postgresql
```

---

## 🧠 RAM Optimization Issues

### **❌ "RAM detection failed"**

**Manual RAM detection:**

**Windows:**
```cmd
# Test RAM detection
bin\test-ram-detection.bat

# Manual optimization for specific RAM
echo 16 > .ram-optimized
bin\optimize-ram.bat
```

**Linux/macOS:**
```bash
# Test RAM detection
./bin/test-ram-detection.sh

# Manual optimization
echo 16 > .ram-optimized
./bin/optimize-ram.sh
```

### **❌ "Out of memory" errors**

**Reduce memory usage:**
```bash
# Check current memory usage
docker stats

# Reduce MySQL memory in docker-compose.yml
# Change memory limits:
deploy:
  resources:
    limits:
      memory: 512M  # Reduce from higher value

# Restart services
docker-compose restart
```

---

## 🔧 Permission Issues

### **❌ Permission Denied (Linux/macOS)**

**Fix file permissions:**
```bash
# Fix ownership
sudo chown -R $USER:$USER .

# Fix directory permissions
chmod -R 755 .

# Fix script permissions
chmod +x bin/*.sh

# Fix web directory permissions
chmod -R 755 www/

# Fix storage permissions (Laravel)
chmod -R 775 www/myproject/storage/
chmod -R 775 www/myproject/bootstrap/cache/
```

### **❌ Cannot write to directory**

**Fix container permissions:**
```bash
# Check container user
docker-compose exec php84 id

# Fix permissions from inside container
docker-compose exec php84 chown -R www:www /var/www/html/myproject/storage/
```

---

## 🐛 Xdebug Issues

### **❌ Xdebug not working**

**Check Xdebug configuration:**
```bash
# Check if Xdebug is loaded
docker-compose exec php84 php -m | grep xdebug

# Check Xdebug configuration
docker-compose exec php84 php -i | grep xdebug
```

**VS Code configuration:**

**Check .vscode/launch.json:**
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

**Check firewall:**
```bash
# Windows: Allow port 9003 in Windows Firewall
# macOS: Check if port 9003 is blocked
# Linux: Check iptables rules
```

---

## 🧹 Complete Reset

### **❌ Nothing works - Nuclear option**

**Complete environment reset:**
```bash
# Stop everything
docker-compose down -v

# Remove all Docker data
docker system prune -a --volumes

# Remove optimization cache
rm -f .ram-optimized

# Remove logs
rm -rf logs/*

# Recreate log directories
mkdir -p logs/nginx logs/php74 logs/php82 logs/php84 logs/mysql logs/postgresql

# Start fresh
docker-compose up -d --build
```

**Reset to factory defaults:**
```bash
# Backup your projects
cp -r www/ ~/backup-www/

# Reset everything
git checkout .
git clean -fd

# Restore projects
cp -r ~/backup-www/* www/

# Restart setup
./bin/dev.sh start
```

---

## 📞 Getting Help

### **Diagnostic Information:**

**When asking for help, provide:**

```bash
# System information
uname -a                    # Linux/macOS
systeminfo                 # Windows

# Docker information
docker --version
docker-compose --version
docker info

# Container status
docker-compose ps

# Recent logs
docker-compose logs --tail=100

# Resource usage
docker stats --no-stream

# Configuration
cat .env
cat docker-compose.yml
```

### **Log Locations:**
- **Container logs**: `docker-compose logs <service>`
- **Nginx logs**: `logs/nginx/`
- **PHP logs**: `logs/php*/`
- **MySQL logs**: `logs/mysql/`
- **PostgreSQL logs**: `logs/postgresql/`

### **Useful Commands for Debugging:**
```bash
# Enter container for debugging
docker-compose exec php84 /bin/sh
docker-compose exec nginx /bin/sh
docker-compose exec mysql /bin/bash

# Check network connectivity
docker-compose exec php84 ping mysql
docker-compose exec nginx ping php84

# Check file permissions
docker-compose exec php84 ls -la /var/www/html/

# Check processes
docker-compose exec php84 ps aux
```

---

**💡 Remember: Most issues can be resolved by restarting services or rebuilding containers. When in doubt, try the complete reset procedure.**
