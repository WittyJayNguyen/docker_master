# 🚀 Docker Master Platform - Examples

## 📋 3 Example Platforms

Đây là 3 examples demonstrating different PHP versions và database combinations:

### 1. 🔥 Laravel PHP 8.4 + PostgreSQL
- **Port:** 8010
- **URL:** http://localhost:8010
- **PHP Version:** 8.4 (latest features)
- **Database:** PostgreSQL
- **Features:** Queue worker, Scheduler, Redis cache

### 2. 🔧 Laravel PHP 7.4 + PostgreSQL  
- **Port:** 8011
- **URL:** http://localhost:8011
- **PHP Version:** 7.4 (legacy support)
- **Database:** PostgreSQL
- **Features:** Queue worker, Scheduler, Redis cache

### 3. 📝 WordPress PHP 7.4 + MySQL
- **Port:** 8012
- **URL:** http://localhost:8012
- **PHP Version:** 7.4 (WordPress recommended)
- **Database:** MySQL
- **Features:** WordPress-style tables and configuration

## 🚀 Quick Start

### 1. Setup & Start All Examples
```bash
# Setup environment
./platform-manager.sh setup

# Start all platforms
./platform-manager.sh start

# Check status
./platform-manager.sh status
```

### 2. Access Examples
- **Laravel PHP 8.4:** http://localhost:8010
- **Laravel PHP 7.4:** http://localhost:8011  
- **WordPress:** http://localhost:8012
- **phpMyAdmin:** http://localhost:8080
- **pgAdmin:** http://localhost:8081

### 3. Individual Platform Management
```bash
# Start specific platform
./platform-manager.sh start laravel-php84-psql
./platform-manager.sh start laravel-php74-psql
./platform-manager.sh start wordpress-php74-mysql

# Stop specific platform
./platform-manager.sh stop laravel-php84-psql

# View logs
./platform-manager.sh logs laravel-php84-psql
```

## 🗄️ Database Information

### PostgreSQL (for Laravel examples)
- **Host:** postgres_server
- **Port:** 5432
- **Username:** postgres_user
- **Password:** postgres_pass
- **Databases:**
  - `laravel_php84_psql`
  - `laravel_php74_psql`

### MySQL (for WordPress)
- **Host:** mysql_server
- **Port:** 3306
- **Username:** mysql_user
- **Password:** mysql_pass
- **Database:** `wordpress_php74_mysql`

### Redis (shared cache)
- **Host:** redis_server
- **Port:** 6379

## 📁 Project Structure

```
docker_master/
├── platforms/
│   ├── shared/                           # Shared services
│   ├── laravel-php84-psql/              # Laravel 8.4 + PostgreSQL
│   ├── laravel-php74-psql/              # Laravel 7.4 + PostgreSQL
│   └── wordpress-php74-mysql/           # WordPress + MySQL
├── projects/
│   ├── laravel-php84-psql/              # PHP 8.4 demo code
│   ├── laravel-php74-psql/              # PHP 7.4 demo code
│   └── wordpress-php74-mysql/           # WordPress demo code
└── logs/
    └── apache/                          # Apache logs for each platform
```

## 🎯 What Each Example Demonstrates

### Laravel PHP 8.4 Example
- ✅ PHP 8.4 latest features (Enums, Match expressions)
- ✅ PostgreSQL connection and table creation
- ✅ Redis caching
- ✅ Queue workers and schedulers
- ✅ Modern PHP development practices

### Laravel PHP 7.4 Example  
- ✅ PHP 7.4 features (Arrow functions, Typed properties)
- ✅ PostgreSQL with different table structure
- ✅ Legacy PHP support
- ✅ Backward compatibility demonstration

### WordPress Example
- ✅ WordPress-style database tables (wp_posts, wp_users)
- ✅ MySQL connection optimized for WordPress
- ✅ WordPress constants and configuration
- ✅ PHP 7.4 for WordPress compatibility

## 🔧 Customization

### Adding Your Own Code
```bash
# Replace demo files with your actual Laravel/WordPress code
cp -r /path/to/your/laravel/* projects/laravel-php84-psql/
cp -r /path/to/your/wordpress/* projects/wordpress-php74-mysql/

# Restart platform to apply changes
./platform-manager.sh restart laravel-php84-psql
```

### Creating New Examples
```bash
# Use the create-platform script
./create-platform.sh laravel my-new-project 8020

# Or manually create platform folder
mkdir platforms/my-custom-example
# Add docker-compose.my-custom-example.yml
# Platform will be auto-discovered!
```

## 🐛 Troubleshooting

### Database Connection Issues
```bash
# Check if databases are running
./platform-manager.sh status shared

# Recreate databases
docker exec -it postgres_server psql -U postgres_user -c "DROP DATABASE IF EXISTS laravel_php84_psql; CREATE DATABASE laravel_php84_psql;"
```

### Port Conflicts
```bash
# Check what's using the ports
lsof -i :8010
lsof -i :8011
lsof -i :8012

# Stop conflicting services or change ports in docker-compose files
```

### Container Issues
```bash
# Rebuild containers
./platform-manager.sh stop
docker system prune -f
./platform-manager.sh build
./platform-manager.sh start
```

## 📊 Performance Monitoring

```bash
# Check container resource usage
docker stats

# View detailed logs
./platform-manager.sh logs laravel-php84-psql
./platform-manager.sh logs shared

# Check database connections
docker exec -it postgres_server psql -U postgres_user -c "\l"
docker exec -it mysql_server mysql -u mysql_user -pmysql_pass -e "SHOW DATABASES;"
```

---

## 🎉 Next Steps

1. **Explore the examples** - Visit each URL to see the demos
2. **Replace with your code** - Copy your actual projects into the folders
3. **Create new platforms** - Use the auto-discovery system to add more
4. **Scale up** - Add more services like Nginx, Elasticsearch, etc.

**Happy coding with Docker Master Platform! 🐳**
