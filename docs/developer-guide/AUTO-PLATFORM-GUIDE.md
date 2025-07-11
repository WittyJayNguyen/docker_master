# 🤖 Auto Platform Creation - Complete Guide

## 🎯 Overview

Docker Master Platform có hệ thống **AI Auto-Detection** thông minh để tự động:
- 🗄️ **Chọn database** phù hợp (MySQL hoặc PostgreSQL)
- 🐘 **Chọn PHP version** (7.4 hoặc 8.4)
- 🏗️ **Tạo platform type** (WordPress, Laravel API, E-commerce)
- 🔌 **Assign ports** tự động
- 🐛 **Cấu hình Xdebug** cho debugging

## 🚀 Basic Usage

### Lệnh cơ bản:
```bash
create.bat [project-name]
```

### Ví dụ:
```bash
create.bat my-blog           # → WordPress + MySQL + PHP 7.4
create.bat user-api          # → Laravel + PostgreSQL + PHP 8.4
create.bat online-shop       # → Laravel + MySQL + PHP 8.4
```

## 🤖 AI Detection Rules

### 📝 MySQL Projects (Auto-detected)

**E-commerce Keywords:**
```bash
create.bat my-shop           → MySQL + Laravel 8.4 + E-commerce
create.bat online-store      → MySQL + Laravel 8.4 + E-commerce
create.bat food-delivery     → MySQL + Laravel 8.4 + E-commerce
create.bat book-shop         → MySQL + Laravel 8.4 + E-commerce
create.bat electronics-store → MySQL + Laravel 8.4 + E-commerce
```

**WordPress/CMS Keywords:**
```bash
create.bat my-blog           → MySQL + WordPress + PHP 7.4
create.bat company-website   → MySQL + WordPress + PHP 7.4
create.bat news-portal       → MySQL + WordPress + PHP 7.4
create.bat portfolio-site    → MySQL + WordPress + PHP 7.4
create.bat content-cms       → MySQL + WordPress + PHP 7.4
```

**Food/Restaurant Keywords:**
```bash
create.bat restaurant-app    → MySQL + Laravel 8.4 + E-commerce
create.bat cafe-website      → MySQL + WordPress + PHP 7.4
create.bat food-blog         → MySQL + WordPress + PHP 7.4
```

### 🚀 PostgreSQL Projects (Auto-detected)

**API/Service Keywords:**
```bash
create.bat user-api          → PostgreSQL + Laravel 8.4 + API
create.bat payment-service   → PostgreSQL + Laravel 8.4 + API
create.bat notification-api  → PostgreSQL + Laravel 8.4 + API
create.bat inventory-service → PostgreSQL + Laravel 8.4 + API
create.bat auth-microservice → PostgreSQL + Laravel 8.4 + API
```

**Backend Keywords:**
```bash
create.bat backend-system    → PostgreSQL + Laravel 8.4 + API
create.bat data-processor    → PostgreSQL + Laravel 8.4 + API
create.bat analytics-engine  → PostgreSQL + Laravel 8.4 + API
```

**Default Laravel:**
```bash
create.bat my-app            → PostgreSQL + Laravel 8.4 + API
create.bat web-application   → PostgreSQL + Laravel 8.4 + API
create.bat custom-system     → PostgreSQL + Laravel 8.4 + API
```

## 🔧 PHP Version Control

### Automatic PHP Selection:
- **WordPress**: Luôn PHP 7.4 (tương thích tốt nhất)
- **Laravel**: Mặc định PHP 8.4 (hiệu suất cao)

### Force PHP 7.4:
```bash
# Thêm "laravel74" vào tên project
create.bat laravel74-user-api     → PHP 7.4 + PostgreSQL
create.bat laravel74-shop-system  → PHP 7.4 + MySQL
create.bat laravel74-cms-backend  → PHP 7.4 + PostgreSQL
create.bat laravel74-legacy-app   → PHP 7.4 + PostgreSQL
```

### Force PHP 8.4 (Default):
```bash
# Tất cả Laravel projects mặc định dùng PHP 8.4
create.bat modern-api             → PHP 8.4 + PostgreSQL
create.bat advanced-shop          → PHP 8.4 + MySQL
create.bat high-performance-app   → PHP 8.4 + PostgreSQL
```

## 📊 Port Assignment System

### Web Ports:
- **WordPress**: 8015, 8018, 8021, 8024... (increment by 3)
- **Laravel API**: 8016, 8019, 8022, 8025... (increment by 3)
- **E-commerce**: 8017, 8020, 8023, 8026... (increment by 3)

### Xdebug Ports:
- **Pattern**: 90XX (XX = last 2 digits of web port)
- **Examples**:
  - Web 8015 → Xdebug 9015
  - Web 8016 → Xdebug 9016
  - Web 8017 → Xdebug 9017

### Port Conflict Handling:
- System automatically finds next available port
- Checks for existing containers
- Increments port if conflict detected

## 🗄️ Database Configuration

### MySQL Connection:
```bash
Host: mysql_low_ram (or localhost:3306)
Username: mysql_user
Password: mysql_pass
Root Password: mysql_root_pass
Memory: 256MB (optimized for stability)
```

### PostgreSQL Connection:
```bash
Host: postgres_low_ram (or localhost:5432)
Username: postgres_user
Password: postgres_pass
Memory: 128MB (optimized for performance)
```

### Database Naming:
- **Pattern**: `[project-name]_db`
- **Examples**:
  - `my-blog` → `my_blog_db`
  - `user-api` → `user_api_db`
  - `online-shop` → `online_shop_db`

## 🏗️ Platform Structure

### Generated Files:
```
platforms/[project-name]/
├── docker-compose.[project-name].yml  # Container configuration
├── Dockerfile                         # PHP + Xdebug setup
├── README.md                          # Platform documentation
└── projects/
    └── index.php                      # Application entry point
```

### Docker Compose Configuration:
```yaml
version: '3.8'
services:
  [project-name]_php[version]:
    build: .
    container_name: [project-name]_php[version]
    ports:
      - "[web-port]:80"
      - "[xdebug-port]:9003"
    environment:
      - PHP_VERSION=[version]
      - DB_CONNECTION=[mysql/pgsql]
      - DB_HOST=[database-host]
      - DB_DATABASE=[database-name]
      - DB_USERNAME=[username]
      - DB_PASSWORD=[password]
    volumes:
      - ./projects:/app
    networks:
      - docker_master_low_ram
```

## 🐛 Xdebug Configuration

### Automatic Xdebug Setup:
- **PHP 7.4**: Xdebug 3.1.6 (compatible)
- **PHP 8.4**: Xdebug 3.3+ (latest)
- **Mode**: debug,develop
- **Client Host**: host.docker.internal

### VS Code Configuration:
```json
{
  "version": "0.2.0",
  "configurations": [
    {
      "name": "[Project Name] Debug",
      "type": "php",
      "request": "launch",
      "port": [xdebug-port],
      "pathMappings": {
        "/app": "${workspaceFolder}/platforms/[project-name]/projects"
      }
    }
  ]
}
```

## 🎯 Complete Examples

### WordPress Blog:
```bash
create.bat tech-blog
# Result:
# - Type: WordPress
# - PHP: 7.4 + Xdebug
# - Database: MySQL (tech_blog_db)
# - Port: 8015
# - Xdebug: 9015
# - URL: http://localhost:8015
```

### Laravel API:
```bash
create.bat user-management-api
# Result:
# - Type: Laravel API
# - PHP: 8.4 + Xdebug
# - Database: PostgreSQL (user_management_api_db)
# - Port: 8016
# - Xdebug: 9016
# - URL: http://localhost:8016
```

### E-commerce Store:
```bash
create.bat fashion-shop
# Result:
# - Type: E-commerce
# - PHP: 8.4 + Xdebug
# - Database: MySQL (fashion_shop_db)
# - Port: 8017
# - Xdebug: 9017
# - URL: http://localhost:8017
```

### Legacy Laravel:
```bash
create.bat laravel74-legacy-system
# Result:
# - Type: Laravel API
# - PHP: 7.4 + Xdebug (forced)
# - Database: PostgreSQL (laravel74_legacy_system_db)
# - Port: 8019
# - Xdebug: 9019
# - URL: http://localhost:8019
```

## 🛠️ Management Commands

### Platform Management:
```bash
# Start platform
docker-compose -f platforms/[name]/docker-compose.[name].yml up -d

# Stop platform
docker-compose -f platforms/[name]/docker-compose.[name].yml down

# View logs
docker logs [name]_php74
docker logs [name]_php84

# Access container
docker exec -it [name]_php74 bash
docker exec -it [name]_php84 bash
```

### Database Management:
```bash
# MySQL access
docker exec -it mysql_low_ram mysql -u mysql_user -pmysql_pass [database_name]

# PostgreSQL access
docker exec -it postgres_low_ram psql -U postgres_user -d [database_name]

# List databases
docker exec mysql_low_ram mysql -u mysql_user -pmysql_pass -e "SHOW DATABASES;"
docker exec postgres_low_ram psql -U postgres_user -d postgres -c "\l"
```

## 🎉 Success Workflow

1. **Create Platform**: `create.bat my-project`
2. **AI Detection**: Automatically selects best configuration
3. **Database Creation**: Database created with proper permissions
4. **Container Start**: Platform starts automatically
5. **Access URL**: Open http://localhost:[assigned-port]
6. **Start Coding**: Edit files in `platforms/[name]/projects/`
7. **Debug**: Use VS Code with Xdebug on assigned port
8. **Database Work**: Connect using provided credentials

## 🌟 Advanced Tips

### Custom Configuration:
- Edit `scripts/auto-platform.bat` for custom rules
- Modify detection keywords for your needs
- Adjust memory limits in docker-compose files

### Performance Optimization:
- MySQL: 256MB for stability
- PostgreSQL: 128MB for performance
- Each platform: ~128MB
- Total system: ~1.4GB for full setup

### Development Best Practices:
- Use meaningful project names for better AI detection
- Follow naming conventions for PHP version control
- Keep platforms organized in separate directories
- Use VS Code for optimal debugging experience

## 🚀 Ready to Create!

```bash
# Start core services
docker-compose -f docker-compose.low-ram.yml up -d

# Create your first platform
create.bat my-awesome-project

# Start developing!
```

**🌟 AI-powered platform creation makes development effortless!**
