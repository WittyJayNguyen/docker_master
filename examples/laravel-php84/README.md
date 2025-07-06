# Laravel PHP 8.4 Example

Ví dụ về cách setup Laravel với PHP 8.4 trong Docker development environment.

## 🚀 Quick Setup

### 1. Tạo project Laravel

```bash
# Linux/macOS
./bin/dev.sh create-project laravel-php84 php84 public

# Windows
bin\dev.bat create-project laravel-php84 php84 public
```

### 2. Cài đặt Laravel

```bash
# Vào container PHP 8.4
docker-compose exec php84 /bin/sh

# Chuyển đến thư mục project
cd /var/www/html/laravel-php84

# Cài đặt Laravel qua Composer
composer create-project laravel/laravel . --prefer-dist

# Hoặc sử dụng Laravel installer
composer global require laravel/installer
laravel new . --force
```

### 3. Cấu hình environment

Sửa file `.env`:

```env
APP_NAME="Laravel PHP 8.4"
APP_ENV=local
APP_KEY=base64:your-app-key-here
APP_DEBUG=true
APP_URL=http://laravel-php84.local

LOG_CHANNEL=stack
LOG_DEPRECATIONS_CHANNEL=null
LOG_LEVEL=debug

DB_CONNECTION=mysql
DB_HOST=mysql
DB_PORT=3306
DB_DATABASE=laravel_php84
DB_USERNAME=dev_user
DB_PASSWORD=dev_pass

# PostgreSQL alternative
# DB_CONNECTION=pgsql
# DB_HOST=postgresql
# DB_PORT=5432
# DB_DATABASE=laravel_php84
# DB_USERNAME=dev_user
# DB_PASSWORD=dev_pass

BROADCAST_DRIVER=log
CACHE_DRIVER=redis
FILESYSTEM_DISK=local
QUEUE_CONNECTION=redis
SESSION_DRIVER=redis
SESSION_LIFETIME=120

REDIS_HOST=redis
REDIS_PASSWORD=null
REDIS_PORT=6379

MAIL_MAILER=smtp
MAIL_HOST=mailpit
MAIL_PORT=1025
MAIL_USERNAME=null
MAIL_PASSWORD=null
MAIL_ENCRYPTION=null
MAIL_FROM_ADDRESS="hello@example.com"
MAIL_FROM_NAME="${APP_NAME}"
```

### 4. Tạo database

```bash
# Kết nối MySQL và tạo database
docker-compose exec mysql mysql -u root -p

# Trong MySQL console
CREATE DATABASE laravel_php84 CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
GRANT ALL PRIVILEGES ON laravel_php84.* TO 'dev_user'@'%';
FLUSH PRIVILEGES;
EXIT;
```

### 5. Chạy migrations

```bash
# Trong container PHP 8.4
docker-compose exec php84 /bin/sh
cd /var/www/html/laravel-php84

# Generate app key
php artisan key:generate

# Run migrations
php artisan migrate

# Seed database (optional)
php artisan db:seed
```

### 6. Cấu hình hosts file

Thêm vào hosts file:
```
127.0.0.1 laravel-php84.local
```

### 7. Truy cập Laravel

Mở trình duyệt và truy cập: `http://laravel-php84.local`

## 🔧 Laravel Artisan Commands

### Các lệnh cơ bản

```bash
# Vào container
docker-compose exec php84 /bin/sh
cd /var/www/html/laravel-php84

# Tạo controller
php artisan make:controller UserController

# Tạo model với migration
php artisan make:model Post -m

# Tạo middleware
php artisan make:middleware CheckAge

# Tạo request
php artisan make:request StoreUserRequest

# Tạo seeder
php artisan make:seeder UserSeeder

# Tạo factory
php artisan make:factory PostFactory

# Clear cache
php artisan cache:clear
php artisan config:clear
php artisan route:clear
php artisan view:clear

# Optimize for production
php artisan optimize
```

### Queue Workers

```bash
# Chạy queue worker
php artisan queue:work

# Chạy queue worker với restart
php artisan queue:work --timeout=60

# Chạy specific queue
php artisan queue:work --queue=high,default
```

### Scheduler

Thêm vào crontab (trong container):
```bash
* * * * * cd /var/www/html/laravel-php84 && php artisan schedule:run >> /dev/null 2>&1
```

## 🐛 Debug Configuration

### Xdebug cho Laravel

Thêm vào `.env`:
```env
XDEBUG_MODE=debug
XDEBUG_CONFIG="client_host=host.docker.internal client_port=9003"
```

### VS Code launch.json

```json
{
    "version": "0.2.0",
    "configurations": [
        {
            "name": "Listen for Xdebug - Laravel PHP 8.4",
            "type": "php",
            "request": "launch",
            "port": 9003,
            "pathMappings": {
                "/var/www/html/laravel-php84": "${workspaceFolder}/www/laravel-php84"
            },
            "ignore": [
                "**/vendor/**/*.php"
            ]
        }
    ]
}
```

### Laravel Telescope

```bash
# Cài đặt Telescope
composer require laravel/telescope --dev

# Publish assets
php artisan telescope:install

# Run migrations
php artisan migrate
```

Truy cập Telescope: `http://laravel-php84.local/telescope`

## 📁 Cấu trúc thư mục

```
laravel-php84/
├── app/
│   ├── Http/
│   ├── Models/
│   └── ...
├── bootstrap/
├── config/
├── database/
│   ├── migrations/
│   ├── seeders/
│   └── factories/
├── public/              # Document root
│   ├── index.php
│   └── ...
├── resources/
│   ├── views/
│   ├── js/
│   └── css/
├── routes/
├── storage/
├── tests/
├── vendor/
├── .env
├── artisan
├── composer.json
└── README.md
```

## 🎨 Frontend Development

### Laravel Mix (Webpack)

```bash
# Cài đặt dependencies
npm install

# Development build
npm run dev

# Watch for changes
npm run watch

# Production build
npm run prod
```

### Vite (Laravel 9+)

```bash
# Cài đặt dependencies
npm install

# Development server
npm run dev

# Build for production
npm run build
```

## 🧪 Testing

### PHPUnit

```bash
# Chạy tất cả tests
php artisan test

# Chạy specific test
php artisan test --filter UserTest

# Chạy với coverage
php artisan test --coverage
```

### Pest (Alternative)

```bash
# Cài đặt Pest
composer require pestphp/pest --dev --with-all-dependencies
./vendor/bin/pest --init

# Chạy tests
./vendor/bin/pest
```

## 🔍 Troubleshooting

### Lỗi permissions

```bash
# Fix storage permissions
docker-compose exec php84 chmod -R 775 /var/www/html/laravel-php84/storage
docker-compose exec php84 chmod -R 775 /var/www/html/laravel-php84/bootstrap/cache

# Fix ownership
docker-compose exec php84 chown -R www:www /var/www/html/laravel-php84/storage
docker-compose exec php84 chown -R www:www /var/www/html/laravel-php84/bootstrap/cache
```

### Lỗi Composer

```bash
# Clear Composer cache
docker-compose exec php84 composer clear-cache

# Update Composer
docker-compose exec php84 composer self-update

# Install with no scripts
docker-compose exec php84 composer install --no-scripts
```

### Lỗi database connection

- Kiểm tra MySQL container: `docker-compose ps`
- Kiểm tra .env file
- Test connection: `php artisan tinker` → `DB::connection()->getPdo()`

## 🚀 Performance Tips

### OPcache optimization

Đã được cấu hình trong `php.ini`:
```ini
opcache.enable=1
opcache.memory_consumption=128
opcache.max_accelerated_files=4000
opcache.revalidate_freq=2
```

### Laravel optimization

```bash
# Config cache
php artisan config:cache

# Route cache
php artisan route:cache

# View cache
php artisan view:cache

# Event cache
php artisan event:cache
```

### Database optimization

```bash
# Database indexes
php artisan make:migration add_indexes_to_users_table

# Query optimization
php artisan model:show User
```

## 📚 Useful Packages

### Development
```bash
composer require --dev barryvdh/laravel-debugbar
composer require --dev barryvdh/laravel-ide-helper
composer require --dev nunomaduro/collision
```

### Production
```bash
composer require laravel/sanctum
composer require spatie/laravel-permission
composer require intervention/image
```

## 📚 Useful Links

- [Laravel Documentation](https://laravel.com/docs)
- [Laravel News](https://laravel-news.com/)
- [Laracasts](https://laracasts.com/)
- [Laravel Daily](https://laraveldaily.com/)
