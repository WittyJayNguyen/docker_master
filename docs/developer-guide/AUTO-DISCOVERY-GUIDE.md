# Docker Master - Auto-Discovery Platform Creation Guide

## 🚀 Overview

Docker Master's Auto-Discovery system allows you to create complete development platforms with just **one command**. The system uses AI-powered detection to automatically configure the best platform type based on your project name.

## 📋 Quick Start

### Super Simple Usage (Recommended)

```bash
# Just one command - everything is automatic!
create.bat [your-project-name]
```

**Examples:**
```bash
create.bat my-shop           # → E-commerce platform
create.bat food-delivery     # → Food delivery platform  
create.bat my-blog           # → WordPress blog
create.bat api-service       # → Laravel API
create.bat coffee-shop       # → E-commerce store
create.bat news-portal       # → WordPress CMS
```

## 🤖 AI Auto-Detection

The system automatically detects the best platform type based on keywords in your project name:

### 🛒 E-commerce Platforms
**Keywords:** `shop`, `store`, `ecommerce`, `commerce`, `buy`, `sell`, `delivery`, `food`, `cafe`, `restaurant`

**Result:** Laravel 8.4 E-commerce platform with PostgreSQL + Redis

**Examples:**
- `my-shop` → E-commerce store
- `food-delivery` → Food delivery platform
- `coffee-shop` → Cafe e-commerce site
- `online-store` → Online retail platform

### 📝 WordPress Platforms
**Keywords:** `blog`, `news`, `cms`, `content`, `portfolio`, `personal`, `website`

**Result:** WordPress PHP 7.4 with PostgreSQL

**Examples:**
- `my-blog` → WordPress blog
- `news-portal` → News website
- `portfolio-site` → Personal portfolio
- `company-website` → Corporate site

### 🚀 Laravel API Platforms
**Keywords:** `api`, `service`, `micro`, `backend`

**Result:** Laravel 8.4 API with PostgreSQL + Redis

**Examples:**
- `api-service` → REST API service
- `user-service` → Microservice
- `backend-api` → Backend API

### 🔧 Default Platform
**No keywords matched:** Laravel 7.4 application

## 📁 What Gets Created

For each platform, the system automatically creates:

```
platforms/[project-name]/
├── docker-compose.[project-name].yml  # Standalone configuration
├── README.md                          # Platform documentation

projects/[project-name]/
├── index.php                          # Application entry point

logs/apache/[project-name]/            # Apache log files

data/uploads/[project-name]/           # File upload storage
```

## 🗄️ Database Management

### Automatic Database Creation
- **Project name:** `my-shop` → **Database:** `my_shop_db`
- **Project name:** `food-delivery` → **Database:** `food_delivery_db`
- **Project name:** `coffee-shop` → **Database:** `coffee_shop_db`

### Database Naming Rules
- Hyphens (`-`) are automatically converted to underscores (`_`)
- `_db` suffix is automatically added
- Database is created in PostgreSQL automatically

## 🚀 Deployment Options

### Option 1: Standalone Deployment (Recommended)
```bash
# Navigate to platform directory
cd platforms/[project-name]

# Start the platform
docker-compose -f docker-compose.[project-name].yml up -d
```

### Option 2: Integrated Deployment
Add the service to `docker-compose.low-ram.yml` and run:
```bash
docker-compose -f docker-compose.low-ram.yml up -d [project-name]
```

## 🛠️ Available Commands

### 1. Super Simple Command (Root Directory)
```bash
create.bat [project-name]
```
- **Location:** Root directory
- **Features:** One command, everything automatic
- **Best for:** Quick platform creation

### 2. Full-Featured Command (Root Directory)
```bash
auto-platform.bat [project-name]
```
- **Location:** Root directory  
- **Features:** Same as create.bat but with more verbose output
- **Best for:** When you want to see detailed creation process

### 3. Advanced Command (Scripts Directory)
```bash
scripts\create-platform.bat [type] [name] [port]
```
- **Location:** scripts/ folder
- **Features:** Manual type selection, custom port
- **Best for:** Advanced users who want full control

**Platform Types:**
- `wordpress` - WordPress PHP 7.4 + PostgreSQL
- `laravel74` - Laravel PHP 7.4 + PostgreSQL + Redis
- `laravel84` - Laravel PHP 8.4 + PostgreSQL + Redis
- `ecommerce` - E-commerce Laravel + Full Stack

## 📊 Platform Management

### View Running Platforms
```bash
docker ps --filter "name=_php"
```

### Access Platform
```bash
# Open in browser
start http://localhost:[port]

# View logs
docker logs [platform-name]_php[version]

# Shell access
docker exec -it [platform-name]_php[version] bash
```

### Stop Platform
```bash
cd platforms/[platform-name]
docker-compose -f docker-compose.[platform-name].yml down
```

## 🎯 Real-World Examples

### Example 1: E-commerce Coffee Shop
```bash
create.bat coffee-paradise
```
**Result:**
- **Type:** E-commerce platform
- **URL:** http://localhost:8015
- **Database:** `coffee_paradise_db`
- **Features:** Product catalog, shopping cart, inventory

### Example 2: Food Delivery Service
```bash
create.bat quick-eats-delivery
```
**Result:**
- **Type:** E-commerce platform (food delivery)
- **URL:** http://localhost:8016
- **Database:** `quick_eats_delivery_db`
- **Features:** Restaurant listings, order management

### Example 3: Personal Blog
```bash
create.bat my-tech-blog
```
**Result:**
- **Type:** WordPress platform
- **URL:** http://localhost:8017
- **Database:** `my_tech_blog_db`
- **Features:** WordPress CMS, PostgreSQL backend

### Example 4: API Service
```bash
create.bat user-api-service
```
**Result:**
- **Type:** Laravel 8.4 API
- **URL:** http://localhost:8018
- **Database:** `user_api_service_db`
- **Features:** REST API, Redis caching

## 🔧 Troubleshooting

### Platform Not Starting
```bash
# Check container status
docker ps -a

# View logs
docker logs [container-name]

# Restart platform
cd platforms/[platform-name]
docker-compose -f docker-compose.[project-name].yml restart
```

### Database Connection Issues
```bash
# Check PostgreSQL status
docker exec postgres_low_ram pg_isready -U postgres_user

# List databases
docker exec postgres_low_ram psql -U postgres_user -d postgres -c "\l"

# Fix database naming
scripts\fix-platform-databases.bat
```

### Port Conflicts
The system automatically assigns available ports starting from 8015. If you need a specific port, use the advanced command:
```bash
scripts\create-platform.bat [type] [name] [custom-port]
```

## 📈 Advanced Features

### Interactive Mode
```bash
scripts\auto-discovery.bat
```
Features:
- AI-powered suggestions
- Template gallery
- Project analysis
- Step-by-step guidance

### Template Gallery
Pre-built templates for common use cases:
- **Food & Restaurant:** restaurant-menu, food-delivery, cafe-website
- **E-commerce:** online-store, marketplace, subscription-box
- **Content & Media:** news-portal, portfolio-site, blog-platform
- **Business:** corporate-site, saas-platform, booking-system

## 🎉 Success Tips

1. **Use descriptive project names** - The AI detection works better with clear names
2. **Include relevant keywords** - Help the system choose the right platform type
3. **Check the auto-assigned port** - Make sure it doesn't conflict with existing services
4. **Review the generated README** - Each platform gets its own documentation
5. **Customize after creation** - Edit the generated files to match your needs

## 🌟 Summary

Docker Master's Auto-Discovery system makes platform creation effortless:

✅ **One command** creates everything  
✅ **AI detection** chooses the right platform  
✅ **Automatic configuration** handles all setup  
✅ **Proper structure** follows best practices  
✅ **Database creation** with correct naming  
✅ **Instant deployment** and browser opening  

Just run `create.bat [your-project-name]` and start developing!
