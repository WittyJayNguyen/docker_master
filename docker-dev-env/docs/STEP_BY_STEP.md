# 📋 Step-by-Step Setup Guide

Hướng dẫn từng bước chi tiết để setup Docker Development Environment từ con số 0.

## 🎯 Mục tiêu

Sau khi hoàn thành guide này, bạn sẽ có:
- ✅ Docker Development Environment hoạt động
- ✅ Auto RAM optimization
- ✅ Multi-PHP support (7.4, 8.2, 8.4)
- ✅ MySQL, PostgreSQL, Redis
- ✅ Nginx với virtual hosts
- ✅ Xdebug debugging
- ✅ Project management tools

## 📝 Checklist Preparation

### **Before Starting:**
- [ ] Máy tính có ít nhất 4GB RAM (khuyến nghị 8GB+)
- [ ] 10GB free disk space
- [ ] Internet connection stable
- [ ] Admin/sudo privileges
- [ ] Text editor (VS Code recommended)

---

## 🔧 STEP 1: Install Docker Desktop

### **1.1 Windows Installation:**

**Download Docker Desktop:**
1. Mở browser, vào https://www.docker.com/products/docker-desktop/
2. Click "Download for Windows"
3. Chờ download hoàn tất (khoảng 500MB)

**Install Docker Desktop:**
1. Double-click file `Docker Desktop Installer.exe`
2. Check "Use WSL 2 instead of Hyper-V" (recommended)
3. Click "Ok" để start installation
4. Đợi installation hoàn tất (5-10 phút)
5. Click "Close and restart" khi được yêu cầu
6. Restart máy tính

**Verify Installation:**
1. Sau khi restart, Docker Desktop sẽ tự động start
2. Mở Command Prompt hoặc PowerShell
3. Chạy commands:
```cmd
docker --version
docker-compose --version
docker run hello-world
```
4. Nếu thấy version numbers và "Hello from Docker!" → Success!

### **1.2 macOS Installation:**

**Download và Install:**
1. Vào https://www.docker.com/products/docker-desktop/
2. Download "Docker Desktop for Mac"
3. Mở file `.dmg` đã download
4. Drag Docker icon vào Applications folder
5. Mở Applications, double-click Docker
6. Enter password khi được yêu cầu
7. Đợi Docker start (có thể mất vài phút)

**Verify Installation:**
```bash
docker --version
docker-compose --version
docker run hello-world
```

### **1.3 Linux (Ubuntu) Installation:**

**Install Docker Engine:**
```bash
# Update package index
sudo apt update

# Install prerequisites
sudo apt install apt-transport-https ca-certificates curl gnupg lsb-release

# Add Docker's GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

# Add Docker repository
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Install Docker
sudo apt update
sudo apt install docker-ce docker-ce-cli containerd.io docker-compose-plugin

# Add user to docker group
sudo usermod -aG docker $USER

# Logout and login again (or restart)
```

**Verify Installation:**
```bash
docker --version
docker-compose --version
docker run hello-world
```

---

## 📥 STEP 2: Get Source Code

### **2.1 Option A: Git Clone (Recommended)**

**Install Git (if not installed):**
- Windows: Download từ https://git-scm.com/
- macOS: `brew install git` hoặc download từ website
- Linux: `sudo apt install git`

**Clone Repository:**
```bash
# Navigate to desired location
cd C:\                    # Windows
cd ~/                     # macOS/Linux

# Clone repository
git clone <repository-url> docker-dev-env
cd docker-dev-env

# Verify files
dir                       # Windows
ls -la                    # macOS/Linux
```

### **2.2 Option B: Download ZIP**

1. Vào repository page trên GitHub/GitLab
2. Click "Code" → "Download ZIP"
3. Extract ZIP file vào folder `docker-dev-env`
4. Mở terminal/command prompt trong folder đó

### **2.3 Option C: Manual Creation**

**Nếu không có access vào repository:**
```bash
# Create main directory
mkdir docker-dev-env
cd docker-dev-env

# Create folder structure
mkdir bin nginx php www database logs examples
mkdir nginx/sites
mkdir php/7.4 php/8.2 php/8.4
mkdir database/mysql database/postgresql database/redis
mkdir database/mysql/data database/mysql/init database/mysql/conf
mkdir database/postgresql/data database/postgresql/init
mkdir logs/nginx logs/php74 logs/php82 logs/php84 logs/mysql logs/postgresql
mkdir examples/basic-php examples/wordpress-php74 examples/laravel-php84

# Create placeholder files
touch .env.example docker-compose.yml README.md
```

---

## ⚙️ STEP 3: Configure Environment

### **3.1 Setup Environment File:**

**Copy environment template:**
```bash
# Windows
copy .env.example .env

# macOS/Linux
cp .env.example .env
```

**Edit .env file:**
```bash
# Windows
notepad .env

# macOS
open -e .env

# Linux
nano .env
```

**Basic .env configuration:**
```env
# Database Configuration
MYSQL_ROOT_PASSWORD=root123
MYSQL_DATABASE=dev_db
MYSQL_USER=dev_user
MYSQL_PASSWORD=dev_pass

POSTGRES_DB=dev_db
POSTGRES_USER=dev_user
POSTGRES_PASSWORD=dev_pass

# Default PHP Version
DEFAULT_PHP_VERSION=dev_php84

# Timezone
TIMEZONE=Asia/Ho_Chi_Minh

# Ports (change if conflicts)
NGINX_PORT=80
MYSQL_PORT=3306
POSTGRESQL_PORT=5432
ADMINER_PORT=8080
PHPMYADMIN_PORT=8081
```

### **3.2 Make Scripts Executable:**

**Windows:**
- Scripts should work by default
- If issues: Right-click bin folder → Properties → Security → Allow execution

**macOS/Linux:**
```bash
chmod +x bin/*.sh
```

---

## 🚀 STEP 4: First Time Setup

### **4.1 Run Auto-Optimization:**

**Windows:**
```cmd
bin\auto-optimize.bat
```

**macOS/Linux:**
```bash
./bin/auto-optimize.sh
```

**Expected Output:**
```
========================================
   Docker Development Environment
        Auto RAM Optimization
========================================

[INFO] Detecting system RAM...
[SUCCESS] Detected: XGB RAM

[INFO] Running RAM optimization for XGB...
[SUCCESS] Optimization completed and saved.

========================================
   Environment Ready for XGB RAM
========================================

[SUMMARY] Current optimization settings:
  - Profile: [Profile Type]
  - MySQL InnoDB: ~XGB
  - PHP Memory: XMB
  - OPcache: XMB
```

### **4.2 Start Environment:**

**Windows:**
```cmd
bin\dev.bat start
```

**macOS/Linux:**
```bash
./bin/dev.sh start
```

**Expected Process:**
1. Auto-optimization runs (if not done before)
2. Docker images build (first time: 10-15 minutes)
3. Containers start
4. Services become available

**Monitor Progress:**
```bash
# Check container status
docker-compose ps

# Watch logs
docker-compose logs -f
```

---

## 🔍 STEP 5: Verify Installation

### **5.1 Check Container Status:**

```bash
docker-compose ps
```

**Expected Output:**
```
NAME             COMMAND                  SERVICE      STATUS
dev_nginx        "/docker-entrypoint.…"   nginx        Up
dev_php74        "docker-php-entrypoint…" php74        Up
dev_php82        "docker-php-entrypoint…" php82        Up
dev_php84        "docker-php-entrypoint…" php84        Up
dev_mysql        "docker-entrypoint.s…"   mysql        Up
dev_postgresql   "docker-entrypoint.s…"   postgresql   Up
dev_redis        "docker-entrypoint.s…"   redis        Up
dev_adminer      "entrypoint.sh php -…"   adminer      Up
dev_phpmyadmin   "/docker-entrypoint.…"   phpmyadmin   Up
```

### **5.2 Test Web Access:**

**Open browser và test các URLs:**

1. **Main Page**: http://localhost
   - Should show PHP info và environment details

2. **Database Test**: http://localhost/test-db.php
   - Should show successful MySQL, PostgreSQL, Redis connections

3. **RAM Optimization**: http://localhost/ram-optimization.php
   - Should show current RAM optimization status

4. **Adminer**: http://localhost:8080
   - Database management interface

5. **phpMyAdmin**: http://localhost:8081
   - MySQL management interface

### **5.3 Test Database Connections:**

**MySQL:**
```bash
docker-compose exec mysql mysql -u dev_user -p
# Password: dev_pass
# Should connect successfully
```

**PostgreSQL:**
```bash
docker-compose exec postgresql psql -U dev_user -d dev_db
# Should connect successfully
```

**Redis:**
```bash
docker-compose exec redis redis-cli ping
# Should return: PONG
```

---

## 🎯 STEP 6: Create First Project

### **6.1 Using Management Script:**

**Windows:**
```cmd
bin\dev.bat create-project myproject php84 public
```

**macOS/Linux:**
```bash
./bin/dev.sh create-project myproject php84 public
```

### **6.2 Manual Project Creation:**

**Create project structure:**
```bash
mkdir www/myproject
mkdir www/myproject/public
```

**Create index.php:**
```bash
# Windows
echo ^<?php phpinfo(); ?^> > www/myproject/public/index.php

# macOS/Linux
echo "<?php phpinfo(); ?>" > www/myproject/public/index.php
```

**Create virtual host:**
```bash
# Copy template
# Windows
copy nginx\sites\project-template.conf.example nginx\sites\myproject.local.conf

# macOS/Linux
cp nginx/sites/project-template.conf.example nginx/sites/myproject.local.conf
```

**Edit virtual host:**
- Replace `{{PROJECT_NAME}}` with `myproject`
- Replace `{{PHP_VERSION}}` with `dev_php84`
- Replace `{{PUBLIC_DIR}}` with `public`

### **6.3 Add to Hosts File:**

**Windows:**
1. Mở Notepad as Administrator
2. Open file: `C:\Windows\System32\drivers\etc\hosts`
3. Add line: `127.0.0.1 myproject.local`
4. Save file

**macOS/Linux:**
```bash
sudo nano /etc/hosts
# Add line: 127.0.0.1 myproject.local
```

### **6.4 Restart Nginx:**

```bash
docker-compose restart nginx
```

### **6.5 Test Project:**

Open browser: http://myproject.local
- Should show PHP info page

---

## 🛠️ STEP 7: Development Tools Setup

### **7.1 VS Code Setup:**

**Install VS Code:**
- Download từ https://code.visualstudio.com/

**Install Extensions:**
1. PHP Debug (for Xdebug)
2. Docker (for container management)
3. PHP Intelephense (PHP language support)
4. GitLens (Git integration)

**Configure Xdebug:**

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

### **7.2 Test Xdebug:**

1. Set breakpoint trong PHP file
2. Start debugging trong VS Code (F5)
3. Refresh browser page
4. Debugger should stop at breakpoint

---

## 📊 STEP 8: Monitoring Setup

### **8.1 Resource Monitoring:**

**Real-time container stats:**
```bash
docker stats
```

**RAM monitoring script:**
```bash
# Windows
bin\monitor-ram.bat

# macOS/Linux
./bin/monitor-ram.sh
```

### **8.2 Log Monitoring:**

**View all logs:**
```bash
docker-compose logs -f
```

**View specific service logs:**
```bash
docker-compose logs -f nginx
docker-compose logs -f php84
docker-compose logs -f mysql
```

---

## ✅ STEP 9: Success Verification

### **Final Checklist:**

- [ ] All containers running (`docker-compose ps`)
- [ ] Main page accessible (http://localhost)
- [ ] Database test page working (http://localhost/test-db.php)
- [ ] RAM optimization page showing correct info
- [ ] Adminer accessible (http://localhost:8080)
- [ ] phpMyAdmin accessible (http://localhost:8081)
- [ ] First project created và accessible
- [ ] Xdebug working trong VS Code
- [ ] Can access container shells
- [ ] Database connections working

### **If Everything Works:**

🎉 **Congratulations!** Your Docker Development Environment is ready!

**Next Steps:**
1. Read [README.md](README.md) for complete features
2. Explore [examples/](examples/) for sample projects
3. Check [COMMANDS.md](COMMANDS.md) for command reference
4. Start building your projects!

---

## 🚨 Troubleshooting

### **Common Issues:**

**Port Conflicts:**
```bash
# Change ports in .env
NGINX_PORT=8080
MYSQL_PORT=3307
```

**Permission Issues (Linux/macOS):**
```bash
sudo chown -R $USER:$USER .
chmod -R 755 www/
```

**Docker Not Starting:**
- Restart Docker Desktop
- Check Docker service status
- Verify system requirements

**Containers Not Building:**
```bash
# Clean và rebuild
docker-compose down
docker system prune -f
docker-compose up -d --build
```

---

**📞 Need Help?**
- Check [INSTALLATION.md](INSTALLATION.md) for detailed installation
- Review [COMMANDS.md](COMMANDS.md) for command reference
- Look at logs: `docker-compose logs`
