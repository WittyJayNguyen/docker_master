FROM php:7.4-apache

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git \
    curl \
    zip \
    unzip \
    nano \
    wget \
    vim \
    libpq-dev \
    postgresql-client \
    default-mysql-client \
    libzip-dev \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libicu-dev \
    libonig-dev \
    libxml2-dev \
    libcurl4-openssl-dev \
    libssl-dev \
    libmagickwand-dev \
    libmemcached-dev \
    libgmp-dev \
    libbz2-dev \
    libxslt1-dev \
    libreadline-dev \
    libldap2-dev \
    libsasl2-dev \
    libsqlite3-dev \
    libtidy-dev \
    libsnmp-dev \
    libenchant-2-dev \
    && rm -rf /var/lib/apt/lists/*

# Configure PHP extensions
RUN docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-configure ldap --with-libdir=lib/x86_64-linux-gnu/ \
    && docker-php-ext-configure pgsql -with-pgsql=/usr/local/pgsql

# Install PHP extensions (core extensions for Laravel/WordPress)
RUN docker-php-ext-install -j$(nproc) \
        pdo \
        pdo_mysql \
        pdo_pgsql \
        pdo_sqlite \
        mysqli \
        pgsql \
        zip \
        gd \
        intl \
        mbstring \
        xml \
        curl \
        bcmath \
        soap \
        exif \
        opcache \
        bz2 \
        calendar \
        gettext \
        gmp \
        iconv \
        sockets \
        fileinfo \
        ftp \
        posix

# Install PECL extensions
RUN pecl install redis memcached imagick \
    && docker-php-ext-enable redis memcached imagick

# Install Xdebug for PHP 7.4
RUN pecl install xdebug-3.1.6 \
    && docker-php-ext-enable xdebug

# Enable Apache mod_rewrite
RUN a2enmod rewrite

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

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
