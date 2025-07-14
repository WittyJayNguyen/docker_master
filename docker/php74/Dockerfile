FROM php:7.4-apache

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git \
    curl \
    zip \
    unzip \
    nano \
    wget \
    libpq-dev \
    libzip-dev \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    && rm -rf /var/lib/apt/lists/*

# Install PHP extensions
RUN docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) \
        pdo \
        pdo_mysql \
        pdo_pgsql \
        zip \
        gd \
        mysqli

# Install Xdebug for PHP 7.4
RUN pecl install xdebug-3.1.6 \
    && docker-php-ext-enable xdebug

# Enable Apache mod_rewrite
RUN a2enmod rewrite

# Install WP-CLI
RUN curl -O https://raw.githubusercontent.com/wp-cli/wp-cli/v2.8.1/wp-cli.phar \
    && chmod +x wp-cli.phar \
    && mv wp-cli.phar /usr/local/bin/wp

# Set working directory
WORKDIR /var/www/html

# Copy custom PHP configuration
COPY php.ini /usr/local/etc/php/php.ini

# Copy Xdebug configuration
COPY xdebug.ini /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini

# Create Xdebug log directory
RUN mkdir -p /tmp/xdebug && chmod 777 /tmp/xdebug

# Create uploads directory and set permissions
RUN mkdir -p /var/www/html/wp-content/uploads \
    && chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html

# Expose port
EXPOSE 80
