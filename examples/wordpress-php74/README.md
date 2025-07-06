# WordPress PHP 7.4 Example

Ví dụ về cách setup WordPress với PHP 7.4 trong Docker development environment.

## 🚀 Quick Setup

### 1. Tạo project WordPress

```bash
# Linux/macOS
./bin/dev.sh create-project wordpress-php74 php74 public

# Windows
bin\dev.bat create-project wordpress-php74 php74 public
```

### 2. Download WordPress

```bash
# Vào thư mục project
cd www/wordpress-php74

# Download WordPress
curl -O https://wordpress.org/latest.tar.gz
tar -xzf latest.tar.gz --strip-components=1 -C public/
rm latest.tar.gz

# Hoặc sử dụng WP-CLI
docker-compose exec php74 wp core download --path=/var/www/html/wordpress-php74/public
```

### 3. Cấu hình database

Tạo file `public/wp-config.php`:

```php
<?php
define('DB_NAME', 'wordpress_php74');
define('DB_USER', 'dev_user');
define('DB_PASSWORD', 'dev_pass');
define('DB_HOST', 'mysql');
define('DB_CHARSET', 'utf8mb4');
define('DB_COLLATE', '');

// WordPress Security Keys
define('AUTH_KEY',         'your-auth-key-here');
define('SECURE_AUTH_KEY',  'your-secure-auth-key-here');
define('LOGGED_IN_KEY',    'your-logged-in-key-here');
define('NONCE_KEY',        'your-nonce-key-here');
define('AUTH_SALT',        'your-auth-salt-here');
define('SECURE_AUTH_SALT', 'your-secure-auth-salt-here');
define('LOGGED_IN_SALT',   'your-logged-in-salt-here');
define('NONCE_SALT',       'your-nonce-salt-salt-here');

$table_prefix = 'wp_';

define('WP_DEBUG', true);
define('WP_DEBUG_LOG', true);
define('WP_DEBUG_DISPLAY', false);

if ( ! defined( 'ABSPATH' ) ) {
    define( 'ABSPATH', __DIR__ . '/' );
}

require_once ABSPATH . 'wp-settings.php';
```

### 4. Tạo database

```bash
# Kết nối MySQL và tạo database
docker-compose exec mysql mysql -u root -p

# Trong MySQL console
CREATE DATABASE wordpress_php74 CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
GRANT ALL PRIVILEGES ON wordpress_php74.* TO 'dev_user'@'%';
FLUSH PRIVILEGES;
EXIT;
```

### 5. Cấu hình hosts file

Thêm vào hosts file:
```
127.0.0.1 wordpress-php74.local
```

### 6. Truy cập WordPress

Mở trình duyệt và truy cập: `http://wordpress-php74.local`

## 🔧 WordPress CLI Commands

### Cài đặt WP-CLI trong container

```bash
# Vào container PHP 7.4
docker-compose exec php74 /bin/sh

# Download WP-CLI
curl -O https://raw.githubusercontent.com/wp-cli/wp-cli/v2.8.1/phar/wp-cli.phar
chmod +x wp-cli.phar
mv wp-cli.phar /usr/local/bin/wp

# Test WP-CLI
wp --info
```

### Các lệnh WP-CLI hữu ích

```bash
# Download WordPress core
wp core download --path=/var/www/html/wordpress-php74/public

# Tạo wp-config.php
wp config create --dbname=wordpress_php74 --dbuser=dev_user --dbpass=dev_pass --dbhost=mysql

# Cài đặt WordPress
wp core install --url=http://wordpress-php74.local --title="WordPress PHP 7.4" --admin_user=admin --admin_password=admin123 --admin_email=admin@example.com

# Cài đặt themes
wp theme install twentytwentythree --activate

# Cài đặt plugins
wp plugin install contact-form-7 --activate
wp plugin install yoast-seo --activate

# Tạo sample content
wp post create --post_type=post --post_title="Hello World" --post_content="This is a sample post" --post_status=publish
```

## 🐛 Debug Configuration

### Xdebug cho WordPress

Thêm vào `wp-config.php`:

```php
// Xdebug configuration for WordPress
if (function_exists('xdebug_set_filter')) {
    xdebug_set_filter(
        XDEBUG_FILTER_CODE_COVERAGE,
        XDEBUG_PATH_WHITELIST,
        ['/var/www/html/wordpress-php74/public/wp-content/themes/', '/var/www/html/wordpress-php74/public/wp-content/plugins/']
    );
}
```

### VS Code launch.json

```json
{
    "version": "0.2.0",
    "configurations": [
        {
            "name": "Listen for Xdebug - WordPress PHP 7.4",
            "type": "php",
            "request": "launch",
            "port": 9003,
            "pathMappings": {
                "/var/www/html/wordpress-php74": "${workspaceFolder}/www/wordpress-php74"
            },
            "ignore": [
                "**/vendor/**/*.php"
            ]
        }
    ]
}
```

## 📁 Cấu trúc thư mục

```
wordpress-php74/
├── public/                 # WordPress root
│   ├── wp-admin/
│   ├── wp-content/
│   │   ├── themes/
│   │   ├── plugins/
│   │   └── uploads/
│   ├── wp-includes/
│   ├── wp-config.php
│   └── index.php
├── logs/                   # WordPress logs
└── README.md
```

## 🔍 Troubleshooting

### Lỗi kết nối database
- Kiểm tra MySQL container đang chạy: `docker-compose ps`
- Kiểm tra thông tin database trong wp-config.php
- Kiểm tra database đã được tạo chưa

### Lỗi permissions
```bash
# Fix permissions cho uploads
docker-compose exec php74 chown -R www:www /var/www/html/wordpress-php74/public/wp-content/uploads
docker-compose exec php74 chmod -R 755 /var/www/html/wordpress-php74/public/wp-content/uploads
```

### Xdebug không hoạt động
- Kiểm tra Xdebug extension: `docker-compose exec php74 php -m | grep xdebug`
- Kiểm tra VS Code PHP Debug extension
- Kiểm tra pathMappings trong launch.json

## 🚀 Performance Tips

### Caching
```php
// Thêm vào wp-config.php
define('WP_CACHE', true);
define('ENABLE_CACHE', true);
```

### Memory limit
```php
// Thêm vào wp-config.php
ini_set('memory_limit', '256M');
```

### Database optimization
```bash
# Optimize database
wp db optimize
```

## 📚 Useful Links

- [WordPress Codex](https://codex.wordpress.org/)
- [WP-CLI Documentation](https://wp-cli.org/)
- [WordPress Developer Resources](https://developer.wordpress.org/)
- [WordPress Debugging](https://wordpress.org/support/article/debugging-in-wordpress/)
