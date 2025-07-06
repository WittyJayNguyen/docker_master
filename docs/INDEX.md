# 📚 Documentation Index

Tổng hợp tất cả documentation cho Docker Development Environment.

## 🚀 Getting Started

### **Cho người mới bắt đầu:**
1. **📋 [STEP_BY_STEP.md](STEP_BY_STEP.md)** - Hướng dẫn từng bước chi tiết từ con số 0
2. **🚀 [INSTALLATION.md](INSTALLATION.md)** - Hướng dẫn cài đặt đầy đủ
3. **⚡ [QUICK_START.md](QUICK_START.md)** - Hướng dẫn nhanh 5 phút

### **Setup Scripts:**
```bash
# Automated setup (recommended for beginners)
bin\setup.bat          # Windows
./bin/setup.sh          # Linux/macOS

# Manual setup
bin\dev.bat start       # Windows  
./bin/dev.sh start      # Linux/macOS
```

## 📖 Core Documentation

### **📋 [README.md](README.md)**
- Tổng quan về tính năng
- Cấu trúc thư mục
- Hướng dẫn cơ bản
- Access URLs

### **🔧 [COMMANDS.md](COMMANDS.md)**
- Tổng hợp tất cả commands
- Management scripts
- Docker commands
- Database operations
- Development tools

### **🧠 [AUTO_OPTIMIZATION.md](AUTO_OPTIMIZATION.md)**
- Auto RAM detection
- Dynamic configuration
- Optimization profiles
- Cross-platform support

### **🚨 [TROUBLESHOOTING.md](TROUBLESHOOTING.md)**
- Common issues và solutions
- Docker problems
- Network issues
- Database connection errors
- Performance problems

## 🎯 Quick Reference

### **Essential Commands:**
```bash
# Start environment
bin\dev.bat start                    # Windows
./bin/dev.sh start                   # Linux/macOS

# Create project
bin\dev.bat create-project myapp php84 public

# Monitor resources
docker stats
http://localhost/ram-optimization.php

# Access containers
docker-compose exec php84 /bin/sh
docker-compose exec mysql mysql -u root -p
```

### **Important URLs:**
- **Main Page**: http://localhost
- **Database Test**: http://localhost/test-db.php
- **RAM Status**: http://localhost/ram-optimization.php
- **Adminer**: http://localhost:8080
- **phpMyAdmin**: http://localhost:8081

## 🏗️ Project Examples

### **📁 [examples/](examples/)**
- **[basic-php/](examples/basic-php/)** - Basic PHP project
- **[wordpress-php74/](examples/wordpress-php74/)** - WordPress với PHP 7.4
- **[laravel-php84/](examples/laravel-php84/)** - Laravel với PHP 8.4

### **Project Creation:**
```bash
# WordPress project
bin\dev.bat create-project myblog php74 public

# Laravel project  
bin\dev.bat create-project myapp php84 public

# Basic PHP project
bin\dev.bat create-project mysite php82 public
```

## 🔧 Configuration Files

### **Environment Configuration:**
- **[.env.example](.env.example)** - Environment template
- **[.env](.env)** - Your environment settings

### **Docker Configuration:**
- **[docker-compose.yml](docker-compose.yml)** - Services definition
- **[php/*/Dockerfile](php/)** - PHP container configurations
- **[nginx/default.conf](nginx/default.conf)** - Nginx main config

### **Database Configuration:**
- **[database/mysql/conf/my.cnf](database/mysql/conf/my.cnf)** - MySQL settings
- **[database/mysql/init/](database/mysql/init/)** - MySQL initialization
- **[database/postgresql/init/](database/postgresql/init/)** - PostgreSQL initialization

## 🛠️ Development Tools

### **VS Code Setup:**
```json
// .vscode/launch.json
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

### **Recommended Extensions:**
- PHP Debug (Xdebug support)
- Docker (container management)
- PHP Intelephense (language support)
- GitLens (Git integration)

## 📊 Monitoring & Maintenance

### **Resource Monitoring:**
```bash
# Real-time stats
docker stats

# RAM monitoring
bin\monitor-ram.bat     # Windows
./bin/monitor-ram.sh    # Linux/macOS

# Web interface
http://localhost/ram-optimization.php
```

### **Log Management:**
```bash
# View all logs
docker-compose logs

# Specific service logs
docker-compose logs nginx
docker-compose logs php84
docker-compose logs mysql

# Follow logs
docker-compose logs -f
```

### **Backup & Restore:**
```bash
# Backup MySQL
docker-compose exec mysql mysqldump -u root -p dev_db > backup.sql

# Backup PostgreSQL
docker-compose exec postgresql pg_dump -U dev_user dev_db > backup.sql

# Restore MySQL
docker-compose exec -T mysql mysql -u root -p dev_db < backup.sql
```

## 🌍 Cross-Platform Support

### **Windows:**
- PowerShell scripts (`.bat`)
- Docker Desktop
- WSL2 support
- Windows hosts file

### **macOS:**
- Bash scripts (`.sh`)
- Docker Desktop
- Homebrew integration
- macOS hosts file

### **Linux:**
- Bash scripts (`.sh`)
- Docker Engine
- Native performance
- Linux hosts file

## 🚨 Emergency Procedures

### **Quick Fixes:**
```bash
# Restart all services
docker-compose restart

# Rebuild containers
docker-compose up -d --build

# Clean restart
docker-compose down
docker-compose up -d
```

### **Complete Reset:**
```bash
# Nuclear option
docker-compose down -v
docker system prune -a --volumes
rm .ram-optimized
docker-compose up -d --build
```

## 📞 Support & Resources

### **Getting Help:**
1. Check [TROUBLESHOOTING.md](TROUBLESHOOTING.md)
2. Review logs: `docker-compose logs`
3. Check container status: `docker-compose ps`
4. Verify configuration: `docker-compose config`

### **Useful Resources:**
- **Docker Documentation**: https://docs.docker.com/
- **PHP Documentation**: https://www.php.net/docs.php
- **MySQL Documentation**: https://dev.mysql.com/doc/
- **PostgreSQL Documentation**: https://www.postgresql.org/docs/
- **Nginx Documentation**: https://nginx.org/en/docs/

## 🎯 Learning Path

### **Beginner (Day 1):**
1. Read [STEP_BY_STEP.md](STEP_BY_STEP.md)
2. Run setup script
3. Create first project
4. Test basic functionality

### **Intermediate (Week 1):**
1. Learn [COMMANDS.md](COMMANDS.md)
2. Explore examples
3. Setup Xdebug
4. Create Laravel/WordPress projects

### **Advanced (Month 1):**
1. Understand [AUTO_OPTIMIZATION.md](AUTO_OPTIMIZATION.md)
2. Customize configurations
3. Performance tuning
4. Production deployment

## 📝 Checklists

### **Installation Checklist:**
- [ ] Docker Desktop installed
- [ ] Source code downloaded
- [ ] Environment configured
- [ ] Services started
- [ ] URLs accessible
- [ ] Database connections working

### **Development Checklist:**
- [ ] Project created
- [ ] Virtual host configured
- [ ] Hosts file updated
- [ ] Xdebug working
- [ ] Database connected
- [ ] Version control setup

### **Production Checklist:**
- [ ] Security configurations
- [ ] Performance optimization
- [ ] Backup procedures
- [ ] Monitoring setup
- [ ] SSL certificates
- [ ] Environment variables

---

## 🎉 Quick Start Summary

**For absolute beginners:**
```bash
# 1. Install Docker Desktop
# 2. Download source code
# 3. Run setup script
bin\setup.bat          # Windows
./bin/setup.sh          # Linux/macOS
```

**For experienced users:**
```bash
# 1. Clone repository
git clone <repo> docker-dev-env
cd docker-dev-env

# 2. Start environment
bin\dev.bat start       # Windows
./bin/dev.sh start      # Linux/macOS
```

**Access your environment:**
- Main: http://localhost
- Adminer: http://localhost:8080
- phpMyAdmin: http://localhost:8081

---

**💡 Tip: Bookmark this page for quick navigation to all documentation!**
