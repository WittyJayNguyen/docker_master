# 🚀 Auto Setup New Project - Complete Guide

> **Hướng dẫn tạo project mới với auto nginx, PHP config và server setup**

## ⚡ Quick Setup (30 giây)

### 🎯 Bước 1: Clone và Setup Project
```bash
# Clone Docker Master Platform
git clone [your-repo] my-new-project
cd my-new-project

# Auto start toàn bộ hệ thống
docker-compose -f docker-compose.low-ram.yml up -d

# Đợi 30 giây để containers khởi động
timeout 30
```

### 🏗️ Bước 2: Tạo Platform Mới (Auto Everything)
```bash
# Tạo platform với AI auto-detection
bin\create.bat my-awesome-app

# Hệ thống sẽ tự động:
# ✅ Detect project type (Laravel/WordPress/API)
# ✅ Choose PHP version (7.4/8.4)
# ✅ Setup database (MySQL/PostgreSQL)
# ✅ Create nginx config
# ✅ Configure Xdebug
# ✅ Start containers
# ✅ Open browser
```

## 🔧 Manual Setup (Nếu cần custom)

### 📁 Bước 1: Tạo Project Structure
```bash
# Tạo thư mục project
mkdir projects/my-app
mkdir platforms/my-app
mkdir nginx/conf.d/my-app.conf

# Copy template files
cp templates/docker-compose.template.yml platforms/my-app/docker-compose.my-app.yml
cp templates/nginx.template.conf nginx/conf.d/my-app.conf
```

### ⚙️ Bước 2: Cấu hình Docker Compose
```yaml
# platforms/my-app/docker-compose.my-app.yml
version: '3.8'
services:
  my-app_php84:
    build:
      context: ../../docker/php84
      dockerfile: Dockerfile
    container_name: my-app_php84
    restart: unless-stopped
    ports:
      - "8017:80"      # Web port (auto-increment)
      - "9017:9003"    # Xdebug port
    volumes:
      - ../../projects/my-app:/var/www/html
    environment:
      # PHP Configuration
      PHP_VERSION: 8.4
      PHP_MEMORY_LIMIT: 256M
      
      # Xdebug Configuration
      XDEBUG_MODE: develop,debug
      XDEBUG_CLIENT_HOST: host.docker.internal
      XDEBUG_CLIENT_PORT: 9003
      XDEBUG_IDEKEY: VSCODE
      
      # Database Configuration
      DB_HOST: mysql_low_ram
      DB_PORT: 3306
      DB_DATABASE: my_app_db
      DB_USERNAME: mysql_user
      DB_PASSWORD: mysql_pass
    networks:
      - docker_master_low_ram

networks:
  docker_master_low_ram:
    external: true
```

### 🌐 Bước 3: Cấu hình Nginx
```nginx
# nginx/conf.d/my-app.conf
server {
    listen 80;
    server_name my-app.asmo-tranding.io;

    location / {
        proxy_pass http://my-app_php84:80;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;

        # PHP specific
        proxy_set_header SCRIPT_NAME $uri;
        proxy_set_header REQUEST_URI $request_uri;
        
        # Timeouts
        proxy_connect_timeout 60s;
        proxy_send_timeout 60s;
        proxy_read_timeout 60s;
    }

    # Health check
    location /health {
        return 200 "healthy\n";
        add_header Content-Type text/plain;
    }
}
```

### 🗄️ Bước 4: Tạo Database
```bash
# MySQL Database
docker exec mysql_low_ram mysql -u root -pmysql_root_pass -e "
CREATE DATABASE IF NOT EXISTS my_app_db;
GRANT ALL PRIVILEGES ON my_app_db.* TO 'mysql_user'@'%';
FLUSH PRIVILEGES;
"

# PostgreSQL Database (nếu cần)
docker exec postgres_low_ram psql -U postgres_user -d postgres -c "
CREATE DATABASE my_app_db;
"
```

### 🚀 Bước 5: Start Everything
```bash
# Start project container
docker-compose -f platforms/my-app/docker-compose.my-app.yml up -d

# Reload nginx
docker exec nginx_proxy_low_ram nginx -s reload

# Test
curl http://localhost:8017
```

## 🤖 Auto Script (Recommended)

### 📝 Tạo Auto Setup Script
```bash
# scripts/auto-setup-project.bat
@echo off
set PROJECT_NAME=%1
set PHP_VERSION=%2
set DB_TYPE=%3

if "%PROJECT_NAME%"=="" (
    echo Usage: auto-setup-project.bat [project-name] [php-version] [db-type]
    echo Example: auto-setup-project.bat my-app 84 mysql
    exit /b 1
)

echo 🚀 Auto setting up project: %PROJECT_NAME%

REM Find available port
set /a PORT=8017
:find_port
docker ps --format "{{.Ports}}" | findstr "%PORT%" >nul
if not errorlevel 1 (
    set /a PORT+=1
    goto :find_port
)

echo ✅ Using port: %PORT%

REM Create directories
mkdir projects\%PROJECT_NAME% 2>nul
mkdir platforms\%PROJECT_NAME% 2>nul

REM Generate docker-compose
powershell -Command "(Get-Content templates\docker-compose.template.yml) -replace '{{PROJECT_NAME}}', '%PROJECT_NAME%' -replace '{{PORT}}', '%PORT%' -replace '{{PHP_VERSION}}', '%PHP_VERSION%' | Set-Content platforms\%PROJECT_NAME%\docker-compose.%PROJECT_NAME%.yml"

REM Generate nginx config
powershell -Command "(Get-Content templates\nginx.template.conf) -replace '{{PROJECT_NAME}}', '%PROJECT_NAME%' | Set-Content nginx\conf.d\%PROJECT_NAME%.conf"

REM Create database
if "%DB_TYPE%"=="mysql" (
    docker exec mysql_low_ram mysql -u root -pmysql_root_pass -e "CREATE DATABASE IF NOT EXISTS %PROJECT_NAME%_db; GRANT ALL PRIVILEGES ON %PROJECT_NAME%_db.* TO 'mysql_user'@'%%'; FLUSH PRIVILEGES;"
)

REM Start container
docker-compose -f platforms\%PROJECT_NAME%\docker-compose.%PROJECT_NAME%.yml up -d

REM Reload nginx
docker exec nginx_proxy_low_ram nginx -s reload

echo ✅ Project ready: http://localhost:%PORT%
start http://localhost:%PORT%
```

### 🎯 Sử dụng Auto Script
```bash
# Laravel PHP 8.4 + MySQL
scripts\auto-setup-project.bat my-laravel-app 84 mysql

# WordPress PHP 7.4 + MySQL  
scripts\auto-setup-project.bat my-wordpress 74 mysql

# API PHP 8.4 + PostgreSQL
scripts\auto-setup-project.bat my-api 84 postgres
```

## 📋 Template Files

### 🐳 Docker Compose Template
```yaml
# templates/docker-compose.template.yml
version: '3.8'
services:
  {{PROJECT_NAME}}_php{{PHP_VERSION}}:
    build:
      context: ../../docker/php{{PHP_VERSION}}
    container_name: {{PROJECT_NAME}}_php{{PHP_VERSION}}
    ports:
      - "{{PORT}}:80"
      - "{{XDEBUG_PORT}}:9003"
    volumes:
      - ../../projects/{{PROJECT_NAME}}:/var/www/html
    environment:
      XDEBUG_MODE: develop,debug
      XDEBUG_CLIENT_HOST: host.docker.internal
      XDEBUG_IDEKEY: VSCODE
    networks:
      - docker_master_low_ram
networks:
  docker_master_low_ram:
    external: true
```

### 🌐 Nginx Template
```nginx
# templates/nginx.template.conf
server {
    listen 80;
    server_name {{PROJECT_NAME}}.asmo-tranding.io;
    
    location / {
        proxy_pass http://{{PROJECT_NAME}}_php84:80;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    }
}
```

## ✅ Verification Checklist

### 🔍 Kiểm tra sau khi setup
```bash
# 1. Container running
docker ps --filter "name=my-app"

# 2. Port accessible
curl http://localhost:8017

# 3. Database connection
docker exec my-app_php84 php -r "new PDO('mysql:host=mysql_low_ram;dbname=my_app_db', 'mysql_user', 'mysql_pass');"

# 4. Xdebug working
curl http://localhost:8017/phpinfo.php | grep -i xdebug

# 5. Nginx config loaded
docker exec nginx_proxy_low_ram nginx -t
```

## 🎯 Best Practices

### 📝 Project Naming
- Use kebab-case: `my-awesome-app`
- Include type hint: `shop-ecommerce`, `blog-cms`, `api-service`
- Keep it short and descriptive

### 🔧 Port Management
- Auto-increment from 8017
- Reserve ranges: 8010-8030 (platforms), 9070-9090 (xdebug)
- Check conflicts before assignment

### 🗄️ Database Naming
- Pattern: `{project_name}_db`
- Replace hyphens with underscores
- Keep consistent with project name

---

**🌟 Với hướng dẫn này, bạn có thể setup project mới trong 30 giây với đầy đủ nginx, PHP config và database!**
