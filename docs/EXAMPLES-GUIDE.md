# 🎯 Docker Master - 3 Perfect Examples Guide

## 🎉 Overview

This guide covers 3 perfectly configured development platforms with full debugging support:

1. **WordPress PHP 7.4 + MySQL + Xdebug**
2. **Laravel PHP 7.4 + PostgreSQL + Xdebug** 
3. **Laravel PHP 8.4 + MySQL + Xdebug**

## 📋 Platform Summary

| Platform | PHP | Database | Port | Xdebug | Type |
|----------|-----|----------|------|--------|------|
| wp-blog-example | 7.4 | MySQL | 8015 | 9015 | WordPress CMS |
| laravel74-api-example | 7.4 | PostgreSQL | 8016 | 9016 | Laravel API |
| laravel84-shop-example | 8.4 | MySQL | 8017 | 9017 | Laravel E-commerce |

## 🌐 Access URLs

- **WordPress Blog**: http://localhost:8015
- **Laravel 7.4 API**: http://localhost:8016  
- **Laravel 8.4 Shop**: http://localhost:8017

## 🗄️ Database Connections

### MySQL (WordPress + Laravel 8.4):
```bash
Host: mysql_low_ram (localhost:3306)
Username: mysql_user
Password: mysql_pass
Root Password: mysql_root_pass

# Connect via CLI
docker exec -it mysql_low_ram mysql -u mysql_user -pmysql_pass
```

### PostgreSQL (Laravel 7.4):
```bash
Host: postgres_low_ram (localhost:5432)
Username: postgres_user
Password: postgres_pass

# Connect via CLI
docker exec -it postgres_low_ram psql -U postgres_user -d postgres
```

## 🐛 VS Code Debug Configuration

Add this to your `.vscode/launch.json`:

```json
{
  "version": "0.2.0",
  "configurations": [
    {
      "name": "WordPress PHP 7.4 Debug",
      "type": "php",
      "request": "launch",
      "port": 9015,
      "pathMappings": {
        "/app": "${workspaceFolder}/platforms/wp-blog-example/projects"
      }
    },
    {
      "name": "Laravel 7.4 API Debug",
      "type": "php",
      "request": "launch",
      "port": 9016,
      "pathMappings": {
        "/app": "${workspaceFolder}/platforms/laravel74-api-example/projects"
      }
    },
    {
      "name": "Laravel 8.4 Shop Debug",
      "type": "php",
      "request": "launch",
      "port": 9017,
      "pathMappings": {
        "/app": "${workspaceFolder}/platforms/laravel84-shop-example/projects"
      }
    }
  ]
}
```

## 🛠️ Management Commands

### Start All Platforms:
```bash
# WordPress
docker-compose -f platforms/wp-blog-example/docker-compose.wp-blog-example.yml up -d

# Laravel 7.4 API
docker-compose -f platforms/laravel74-api-example/docker-compose.laravel74-api-example.yml up -d

# Laravel 8.4 Shop
docker-compose -f platforms/laravel84-shop-example/docker-compose.laravel84-shop-example.yml up -d
```

### Stop All Platforms:
```bash
docker-compose -f platforms/wp-blog-example/docker-compose.wp-blog-example.yml down
docker-compose -f platforms/laravel74-api-example/docker-compose.laravel74-api-example.yml down
docker-compose -f platforms/laravel84-shop-example/docker-compose.laravel84-shop-example.yml down
```

### View Logs:
```bash
docker logs wp-blog-example_php74
docker logs laravel74-api-example_php74
docker logs laravel84-shop-example_php84
```

### Access Containers:
```bash
docker exec -it wp-blog-example_php74 bash
docker exec -it laravel74-api-example_php74 bash
docker exec -it laravel84-shop-example_php84 bash
```

## 📁 File Structure

```
docker_master/
├── platforms/
│   ├── wp-blog-example/
│   │   ├── docker-compose.wp-blog-example.yml
│   │   ├── Dockerfile
│   │   ├── README.md
│   │   └── projects/
│   │       └── index.php (WordPress files)
│   ├── laravel74-api-example/
│   │   ├── docker-compose.laravel74-api-example.yml
│   │   ├── Dockerfile
│   │   ├── README.md
│   │   └── projects/
│   │       └── index.php (Laravel 7.4 files)
│   └── laravel84-shop-example/
│       ├── docker-compose.laravel84-shop-example.yml
│       ├── Dockerfile
│       ├── README.md
│       └── projects/
│           └── index.php (Laravel 8.4 files)
└── EXAMPLES-GUIDE.md (this file)
```

## 🔧 Development Workflow

### 1. Setup VS Code:
1. Install PHP Debug extension
2. Configure launch.json with above settings
3. Open docker_master folder in VS Code

### 2. Start Development:
1. Choose your platform (WordPress/Laravel 7.4/Laravel 8.4)
2. Edit files in respective `projects/` directory
3. Set breakpoints in your PHP code
4. Start debugging session in VS Code
5. Access platform URL to trigger breakpoints

### 3. Database Development:
1. Use appropriate database tools (MySQL Workbench, pgAdmin)
2. Connect using provided credentials
3. Create tables, run migrations
4. Test database connections in your code

## 🧪 Testing Examples

### Test Database Connections:
```bash
# WordPress MySQL
docker exec wp-blog-example_php74 php -r "
try { 
  \$pdo = new PDO('mysql:host=mysql_low_ram;dbname=wp_blog_example_db', 'mysql_user', 'mysql_pass'); 
  echo 'WordPress MySQL: ✅ Connected\n'; 
} catch(Exception \$e) { 
  echo 'WordPress MySQL: ❌ Failed\n'; 
}"

# Laravel 7.4 PostgreSQL
docker exec laravel74-api-example_php74 php -r "
try { 
  \$pdo = new PDO('pgsql:host=postgres_low_ram;dbname=laravel74_api_example_db', 'postgres_user', 'postgres_pass'); 
  echo 'Laravel 7.4 PostgreSQL: ✅ Connected\n'; 
} catch(Exception \$e) { 
  echo 'Laravel 7.4 PostgreSQL: ❌ Failed\n'; 
}"

# Laravel 8.4 MySQL
docker exec laravel84-shop-example_php84 php -r "
try { 
  \$pdo = new PDO('mysql:host=mysql_low_ram;dbname=laravel84_shop_example_db', 'mysql_user', 'mysql_pass'); 
  echo 'Laravel 8.4 MySQL: ✅ Connected\n'; 
} catch(Exception \$e) { 
  echo 'Laravel 8.4 MySQL: ❌ Failed\n'; 
}"
```

### Test Xdebug:
```bash
# Check Xdebug status
docker exec wp-blog-example_php74 php -m | grep xdebug
docker exec laravel74-api-example_php74 php -m | grep xdebug
docker exec laravel84-shop-example_php84 php -m | grep xdebug
```

## 🎯 Use Cases

### WordPress Development (Port 8015):
- **CMS Development**: Build custom themes and plugins
- **Blog Creation**: Content management and publishing
- **PHP 7.4**: Stable WordPress compatibility
- **MySQL**: Traditional WordPress database

### Laravel 7.4 API Development (Port 8016):
- **API Development**: RESTful APIs and microservices
- **Legacy Support**: PHP 7.4 for older projects
- **PostgreSQL**: Advanced database features
- **Debugging**: Full Xdebug support

### Laravel 8.4 E-commerce (Port 8017):
- **Modern Development**: Latest PHP 8.4 features
- **E-commerce**: Shopping cart, payments, inventory
- **MySQL**: Reliable e-commerce database
- **Performance**: PHP 8.4 performance improvements

## 🌟 Features

✅ **Full Xdebug Support**: All platforms have debugging enabled
✅ **Dual Database**: Both MySQL and PostgreSQL available
✅ **Multiple PHP Versions**: 7.4 and 8.4 support
✅ **Memory Optimized**: Efficient resource usage
✅ **Auto-Discovery**: AI-powered platform detection
✅ **Cross-Platform**: Works on Windows, Mac, Linux
✅ **VS Code Integration**: Perfect debugging experience

## 🚀 Quick Start

1. **Start Core Services**:
   ```bash
   docker-compose -f docker-compose.low-ram.yml up -d
   ```

2. **Start All Examples**:
   ```bash
   # Run the examples summary script
   scripts\examples-summary.bat
   ```

3. **Access Platforms**:
   - WordPress: http://localhost:8015
   - Laravel 7.4: http://localhost:8016
   - Laravel 8.4: http://localhost:8017

4. **Start Debugging**:
   - Configure VS Code with provided settings
   - Set breakpoints and start debugging!

## 🎉 Perfect Development Environment Ready!

You now have 3 fully configured development platforms with:
- ✅ WordPress PHP 7.4 + MySQL + Xdebug
- ✅ Laravel PHP 7.4 + PostgreSQL + Xdebug
- ✅ Laravel PHP 8.4 + MySQL + Xdebug

Happy coding! 🚀
