# 🔧 Command Reference Guide

Tổng hợp tất cả commands để quản lý Docker Development Environment.

## 🚀 Management Scripts

### **Windows Commands:**

**🚀 Quick Scripts (Recommended):**
```cmd
# Quick start with auto-optimization
bin\start.bat

# Stop all services
bin\stop.bat

# Restart all services
bin\restart.bat

# Show comprehensive status
bin\status.bat

# Complete environment reset (DANGEROUS)
bin\reset.bat

# Auto RAM optimization
bin\auto-optimize.bat
```

**🔧 Detailed Management (dev.bat):**
```cmd
# Start environment (with auto-optimization)
bin\dev.bat start

# Stop environment
bin\dev.bat stop

# Restart environment
bin\dev.bat restart

# Build images
bin\dev.bat build

# Rebuild images (no cache)
bin\dev.bat rebuild

# Show status
bin\dev.bat status

# View logs
bin\dev.bat logs
bin\dev.bat logs nginx

# Open shell in container
bin\dev.bat shell
bin\dev.bat shell php84

# Create new project
bin\dev.bat create-project myproject php84 public

# List projects
bin\dev.bat list-projects

# Cleanup unused containers
bin\dev.bat cleanup

# Show help
bin\dev.bat help
```

### **Linux/macOS Commands:**
```bash
# Start environment (with auto-optimization)
./bin/dev.sh start

# Stop environment
./bin/dev.sh stop

# Restart environment
./bin/dev.sh restart

# Build images
./bin/dev.sh build

# Rebuild images (no cache)
./bin/dev.sh rebuild

# Show status
./bin/dev.sh status

# View logs
./bin/dev.sh logs
./bin/dev.sh logs nginx

# Open shell in container
./bin/dev.sh shell
./bin/dev.sh shell php84

# Create new project
./bin/dev.sh create-project myproject php84 public

# List projects
./bin/dev.sh list-projects

# Cleanup unused containers
./bin/dev.sh cleanup

# Show help
./bin/dev.sh help
```

## 🧠 RAM Optimization Commands

### **Auto-Optimization:**
```bash
# Windows
bin\auto-optimize.bat

# Linux/macOS
./bin/auto-optimize.sh
```

### **Manual Optimization:**
```bash
# Windows
bin\optimize-ram.bat

# Linux/macOS
./bin/optimize-ram.sh
```

### **Test RAM Detection:**
```bash
# Windows
bin\test-ram-detection.bat

# Linux/macOS
./bin/test-ram-detection.sh
```

### **Monitor RAM Usage:**
```bash
# Windows
bin\monitor-ram.bat

# Linux/macOS
./bin/monitor-ram.sh
```

## 🐳 Docker Compose Commands

### **Service Management:**
```bash
# Start all services
docker-compose up -d

# Start specific service
docker-compose up -d nginx

# Stop all services
docker-compose down

# Stop specific service
docker-compose stop nginx

# Restart all services
docker-compose restart

# Restart specific service
docker-compose restart nginx

# Remove all containers and volumes
docker-compose down -v
```

### **Building:**
```bash
# Build all images
docker-compose build

# Build specific image
docker-compose build php84

# Build without cache
docker-compose build --no-cache

# Build and start
docker-compose up -d --build
```

### **Monitoring:**
```bash
# Show running containers
docker-compose ps

# Show logs for all services
docker-compose logs

# Show logs for specific service
docker-compose logs nginx

# Follow logs in real-time
docker-compose logs -f

# Show last 50 lines
docker-compose logs --tail=50
```

## 🔍 Container Access Commands

### **Shell Access:**
```bash
# PHP 8.4 container
docker-compose exec php84 /bin/sh

# PHP 7.4 container
docker-compose exec php74 /bin/sh

# MySQL container
docker-compose exec mysql /bin/bash

# PostgreSQL container
docker-compose exec postgresql /bin/bash

# Nginx container
docker-compose exec nginx /bin/sh

# Redis container
docker-compose exec redis /bin/sh
```

### **Database Access:**
```bash
# MySQL CLI
docker-compose exec mysql mysql -u root -p
docker-compose exec mysql mysql -u dev_user -p dev_db

# PostgreSQL CLI
docker-compose exec postgresql psql -U dev_user -d dev_db

# Redis CLI
docker-compose exec redis redis-cli
```

## 🗄️ Database Commands

### **MySQL:**
```bash
# Connect to MySQL
docker-compose exec mysql mysql -u root -p

# Create database
docker-compose exec mysql mysql -u root -p -e "CREATE DATABASE myproject;"

# Import SQL file
docker-compose exec -T mysql mysql -u root -p myproject < backup.sql

# Export database
docker-compose exec mysql mysqldump -u root -p myproject > backup.sql

# Show databases
docker-compose exec mysql mysql -u root -p -e "SHOW DATABASES;"

# Show MySQL status
docker-compose exec mysql mysql -u root -p -e "SHOW STATUS LIKE 'Innodb_buffer_pool%';"
```

### **PostgreSQL:**
```bash
# Connect to PostgreSQL
docker-compose exec postgresql psql -U dev_user -d dev_db

# Create database
docker-compose exec postgresql createdb -U dev_user myproject

# Import SQL file
docker-compose exec -T postgresql psql -U dev_user -d myproject < backup.sql

# Export database
docker-compose exec postgresql pg_dump -U dev_user myproject > backup.sql

# List databases
docker-compose exec postgresql psql -U dev_user -l
```

### **Redis:**
```bash
# Connect to Redis
docker-compose exec redis redis-cli

# Test Redis
docker-compose exec redis redis-cli ping

# Set/Get values
docker-compose exec redis redis-cli set test "Hello World"
docker-compose exec redis redis-cli get test

# Show Redis info
docker-compose exec redis redis-cli info memory
```

## 🌐 Web Server Commands

### **Nginx:**
```bash
# Test Nginx configuration
docker-compose exec nginx nginx -t

# Reload Nginx configuration
docker-compose exec nginx nginx -s reload

# View Nginx access logs
docker-compose exec nginx tail -f /var/log/nginx/access.log

# View Nginx error logs
docker-compose exec nginx tail -f /var/log/nginx/error.log
```

### **Virtual Host Management:**
```bash
# Generate virtual host (Windows)
bin\generate-vhost.bat myproject dev_php84 public

# Generate virtual host (Linux/macOS)
./bin/generate-vhost.sh myproject dev_php84 public

# List virtual hosts
ls nginx/sites/

# Test virtual host
curl -H "Host: myproject.local" http://localhost
```

## 🐘 PHP Commands

### **Composer:**
```bash
# Install dependencies
docker-compose exec php84 composer install

# Update dependencies
docker-compose exec php84 composer update

# Add package
docker-compose exec php84 composer require vendor/package

# Remove package
docker-compose exec php84 composer remove vendor/package

# Dump autoload
docker-compose exec php84 composer dump-autoload
```

### **Laravel Artisan:**
```bash
# Run artisan commands
docker-compose exec php84 php artisan migrate
docker-compose exec php84 php artisan make:controller UserController
docker-compose exec php84 php artisan cache:clear
docker-compose exec php84 php artisan config:clear
docker-compose exec php84 php artisan route:list
```

### **WordPress CLI:**
```bash
# Download WordPress
docker-compose exec php74 wp core download --path=/var/www/html/myproject

# Install WordPress
docker-compose exec php74 wp core install --url=myproject.local --title="My Site" --admin_user=admin --admin_password=password --admin_email=admin@example.com

# Install plugins
docker-compose exec php74 wp plugin install contact-form-7 --activate
```

### **NPM/Node:**
```bash
# Install NPM packages
docker-compose exec php84 npm install

# Run development build
docker-compose exec php84 npm run dev

# Run production build
docker-compose exec php84 npm run prod

# Watch for changes
docker-compose exec php84 npm run watch
```

## 📊 Monitoring Commands

### **Docker Stats:**
```bash
# Real-time container stats
docker stats

# One-time stats
docker stats --no-stream

# Formatted stats
docker stats --format "table {{.Name}}\t{{.CPUPerc}}\t{{.MemUsage}}\t{{.MemPerc}}"
```

### **System Information:**
```bash
# Docker system info
docker system df

# Docker version
docker --version
docker-compose --version

# Container processes
docker-compose top

# Container resource usage
docker-compose exec php84 top
```

## 🧹 Cleanup Commands

### **Docker Cleanup:**
```bash
# Remove unused containers, networks, images
docker system prune

# Remove unused containers, networks, images, volumes
docker system prune -a --volumes

# Remove specific containers
docker-compose rm php84

# Remove all stopped containers
docker container prune

# Remove unused images
docker image prune

# Remove unused volumes
docker volume prune
```

### **Project Cleanup:**
```bash
# Clean logs
rm -rf logs/*
mkdir -p logs/nginx logs/php74 logs/php82 logs/php84 logs/mysql logs/postgresql

# Reset database data
rm -rf database/mysql/data/*
rm -rf database/postgresql/data/*

# Clean optimization cache
rm .ram-optimized
```

## 🔧 Development Commands

### **File Permissions (Linux/macOS):**
```bash
# Fix ownership
sudo chown -R $USER:$USER .

# Fix permissions
chmod -R 755 www/
chmod +x bin/*.sh

# Fix storage permissions (Laravel)
docker-compose exec php84 chmod -R 775 storage/
docker-compose exec php84 chmod -R 775 bootstrap/cache/
```

### **SSL/HTTPS (Optional):**
```bash
# Generate self-signed certificate
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -keyout nginx/ssl/nginx.key \
  -out nginx/ssl/nginx.crt

# Update nginx configuration for SSL
# Add SSL configuration to virtual hosts
```

## 🚨 Emergency Commands

### **Force Restart:**
```bash
# Force stop all containers
docker kill $(docker ps -q)

# Remove all containers
docker rm $(docker ps -aq)

# Restart Docker service (Linux)
sudo systemctl restart docker

# Reset Docker Desktop (Windows/macOS)
# Restart Docker Desktop application
```

### **Complete Reset:**
```bash
# Stop and remove everything
docker-compose down -v

# Remove all Docker data
docker system prune -a --volumes

# Rebuild from scratch
docker-compose up -d --build
```

---

## 📚 Quick Reference

### **Most Used Commands:**
```bash
# Start development
bin\dev.bat start                    # Windows
./bin/dev.sh start                   # Linux/macOS

# Create project
bin\dev.bat create-project myapp php84 public

# Access containers
docker-compose exec php84 /bin/sh
docker-compose exec mysql mysql -u root -p

# Monitor
docker stats
http://localhost/ram-optimization.php

# Cleanup
docker system prune
```

### **Emergency Contacts:**
- **Documentation**: README.md, INSTALLATION.md
- **Examples**: examples/ directory
- **Logs**: logs/ directory
- **Configs**: .env, docker-compose.yml

---

**💡 Tip: Bookmark this page for quick command reference!**
