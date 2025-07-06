FROM php:8.2-fpm-alpine

# Install system dependencies
RUN apk add --no-cache \
    git \
    curl \
    libpng-dev \
    libxml2-dev \
    zip \
    unzip \
    oniguruma-dev \
    autoconf \
    g++ \
    make \
    openssl-dev \
    libzip-dev \
    freetype-dev \
    libjpeg-turbo-dev \
    postgresql-dev \
    icu-dev \
    nodejs \
    npm \
    linux-headers

# Install PHP extensions
RUN docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) \
        pdo \
        pdo_mysql \
        pdo_pgsql \
        mbstring \
        exif \
        pcntl \
        bcmath \
        gd \
        zip \
        intl \
        opcache \
        soap \
        sockets

# Install Redis extension
RUN pecl install redis \
    && docker-php-ext-enable redis

# Install Xdebug
RUN pecl install xdebug \
    && docker-php-ext-enable xdebug

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Configure PHP
COPY php.ini /usr/local/etc/php/conf.d/custom.ini
COPY xdebug.ini /usr/local/etc/php/conf.d/xdebug.ini

# Set working directory
WORKDIR /var/www/html

# Create www-data user with proper permissions
RUN addgroup -g 1000 www && \
    adduser -u 1000 -G www -s /bin/sh -D www

# Change ownership of working directory
RUN chown -R www:www /var/www/html

# Switch to www user
USER www

# Expose port 9000
EXPOSE 9000

CMD ["php-fpm"]
