# 🚀 Quick Start - New Project Setup

> **30 giây để có project hoàn chỉnh với nginx, PHP, database, Xdebug**

## ⚡ Super Quick (1 lệnh)

```bash
# Clone project và setup
git clone [repo] my-new-workspace
cd my-new-workspace

# Start Docker Master Platform
docker-compose -f docker-compose.low-ram.yml up -d

# Tạo project mới (AI auto-detect)
bin\quick-setup.bat my-awesome-app
```

**🎉 Done! Project sẵn sàng với:**
- ✅ Auto nginx config
- ✅ PHP 7.4/8.4 + Xdebug
- ✅ MySQL/PostgreSQL database
- ✅ Auto port assignment
- ✅ Browser auto-open

## 🎯 Examples

### 🛒 E-commerce
```bash
bin\quick-setup.bat my-shop
# → Laravel PHP 8.4 + MySQL + Port 8017
```

### 📝 Blog/CMS
```bash
bin\quick-setup.bat my-blog
# → WordPress PHP 7.4 + MySQL + Port 8018
```

### ⚡ API Service
```bash
bin\quick-setup.bat my-api
# → Laravel PHP 8.4 + PostgreSQL + Port 8019
```

## 🔧 Manual Setup (Advanced)

```bash
# Custom configuration
scripts\auto-setup-project.bat my-custom-app 84 postgres

# Parameters:
# - Project name: my-custom-app
# - PHP version: 74 or 84
# - Database: mysql or postgres
```

## 📁 What You Get

```
my-awesome-app/
├── 🌐 http://localhost:8017 (auto-assigned port)
├── 🐛 Xdebug on port 9017
├── 🗄️ Database: my_awesome_app_db
├── 📁 Code: projects/my-awesome-app/
├── 🐳 Container: my-awesome-app_php84
└── 🌍 Domain: my-awesome-app.asmo-tranding.io
```

## ✅ Verification

```bash
# Check container
docker ps --filter "name=my-awesome-app"

# Test website
curl http://localhost:8017

# Test database
docker exec my-awesome-app_php84 php -r "new PDO('mysql:host=mysql_low_ram;dbname=my_awesome_app_db', 'mysql_user', 'mysql_pass');"
```

## 🛠️ Development

### 📝 Edit Code
```bash
# All files sync automatically
code projects/my-awesome-app/
```

### 🐛 Debug Setup (VS Code)
```json
{
    "name": "Debug my-awesome-app",
    "type": "php",
    "request": "launch",
    "port": 9017,
    "pathMappings": {
        "/var/www/html": "${workspaceFolder}/projects/my-awesome-app"
    }
}
```

### 🗄️ Database Access
```bash
# MySQL
Host: localhost:3306
User: mysql_user
Pass: mysql_pass
DB: my_awesome_app_db

# PostgreSQL  
Host: localhost:5432
User: postgres_user
Pass: postgres_pass
DB: my_awesome_app_db
```

## 🎯 AI Auto-Detection Rules

| Keywords | Platform | PHP | Database |
|----------|----------|-----|----------|
| shop, store, ecommerce | Laravel | 8.4 | MySQL |
| blog, cms, news | WordPress | 7.4 | MySQL |
| api, service, backend | Laravel | 8.4 | PostgreSQL |
| Default | Laravel | 8.4 | MySQL |

## 🔄 Management Commands

```bash
# Stop project
docker stop my-awesome-app_php84

# Restart project
docker restart my-awesome-app_php84

# Remove project
docker-compose -f platforms/my-awesome-app/docker-compose.my-awesome-app.yml down
rm -rf projects/my-awesome-app
rm -rf platforms/my-awesome-app
rm nginx/conf.d/my-awesome-app.conf
```

---

**🌟 Từ giờ tạo project chỉ mất 30 giây thay vì 30 phút!**

*Auto nginx • Auto PHP • Auto database • Auto Xdebug • Auto everything!*
