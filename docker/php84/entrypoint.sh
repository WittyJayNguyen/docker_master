#!/bin/bash

# Custom entrypoint script for PHP 8.4 container
# Handles WEB_DOCUMENT_ROOT environment variable

set -e

# Function to update Apache DocumentRoot
update_document_root() {
    local new_root="$1"
    echo "Setting DocumentRoot to: $new_root"
    
    # Update the default Apache site configuration
    sed -i "s|DocumentRoot /var/www/html|DocumentRoot $new_root|g" /etc/apache2/sites-available/000-default.conf
    
    # Update the default Apache directory configuration
    if [ -f /etc/apache2/apache2.conf ]; then
        # Update the Directory directive for /var/www/html
        sed -i "s|<Directory /var/www/html>|<Directory $new_root>|g" /etc/apache2/apache2.conf
        
        # If the directory doesn't exist in apache2.conf, add it
        if ! grep -q "<Directory $new_root>" /etc/apache2/apache2.conf; then
            cat >> /etc/apache2/apache2.conf << EOF

<Directory $new_root>
    Options Indexes FollowSymLinks
    AllowOverride All
    Require all granted
</Directory>
EOF
        fi
    fi
    
    # Ensure the directory exists and has proper permissions
    if [ ! -d "$new_root" ]; then
        echo "Creating directory: $new_root"
        mkdir -p "$new_root"
    fi
    
    chown -R www-data:www-data "$new_root"
    chmod -R 755 "$new_root"
}

# Check if WEB_DOCUMENT_ROOT is set and different from default
if [ -n "$WEB_DOCUMENT_ROOT" ] && [ "$WEB_DOCUMENT_ROOT" != "/var/www/html" ]; then
    echo "WEB_DOCUMENT_ROOT is set to: $WEB_DOCUMENT_ROOT"
    update_document_root "$WEB_DOCUMENT_ROOT"
else
    echo "Using default DocumentRoot: /var/www/html"
fi

# Apply memory limit if set
if [ -n "$PHP_MEMORY_LIMIT" ]; then
    echo "Setting PHP memory limit to: $PHP_MEMORY_LIMIT"
    echo "memory_limit = $PHP_MEMORY_LIMIT" > /usr/local/etc/php/conf.d/docker-php-memlimit.ini
fi

# Enable Apache modules if needed
a2enmod rewrite
a2enmod headers

# Reload Apache configuration
service apache2 reload 2>/dev/null || true

echo "Starting Apache with DocumentRoot: $(grep DocumentRoot /etc/apache2/sites-available/000-default.conf | awk '{print $2}')"

# Execute the original docker-php-entrypoint with the provided arguments
exec docker-php-entrypoint "$@"
