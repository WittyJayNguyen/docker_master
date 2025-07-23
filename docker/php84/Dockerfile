# Use official PHP 8.4 with Apache
FROM php:8.4-apache

# Set working directory
WORKDIR /var/www/html

# Install system dependencies
RUN apt-get update && apt-get install -y \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libpng-dev \
    libzip-dev \
    libicu-dev \
    libonig-dev \
    libxml2-dev \
    libcurl4-openssl-dev \
    libssl-dev \
    libpq-dev \
    postgresql-client \
    default-mysql-client \
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
    unzip \
    git \
    curl \
    nano \
    wget \
    vim \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Configure PHP extensions
RUN docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-configure ldap --with-libdir=lib/x86_64-linux-gnu/ \
    && docker-php-ext-configure pgsql -with-pgsql=/usr/local/pgsql

# Install PHP extensions (core extensions for Laravel/WordPress)
RUN docker-php-ext-install -j$(nproc) \
        gd \
        zip \
        intl \
        mbstring \
        xml \
        curl \
        pdo \
        pdo_mysql \
        pdo_pgsql \
        pdo_sqlite \
        mysqli \
        pgsql \
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

# Enable Apache mod_rewrite
RUN a2enmod rewrite

# Install Xdebug for PHP 8.4
RUN pecl install xdebug \
    && docker-php-ext-enable xdebug

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Copy custom PHP configuration
COPY php-optimized.ini /usr/local/etc/php/php.ini

# Configure PHP for development and production
RUN echo "memory_limit = 512M" >> /usr/local/etc/php/conf.d/docker-php-memlimit.ini \
    && echo "upload_max_filesize = 64M" >> /usr/local/etc/php/conf.d/docker-php-uploads.ini \
    && echo "post_max_size = 64M" >> /usr/local/etc/php/conf.d/docker-php-uploads.ini \
    && echo "max_execution_time = 300" >> /usr/local/etc/php/conf.d/docker-php-timeouts.ini \
    && echo "max_input_vars = 3000" >> /usr/local/etc/php/conf.d/docker-php-vars.ini \
    && echo "date.timezone = Asia/Ho_Chi_Minh" >> /usr/local/etc/php/conf.d/docker-php-timezone.ini

# Configure OPcache for production performance
RUN echo "opcache.enable=1" >> /usr/local/etc/php/conf.d/docker-php-opcache.ini \
    && echo "opcache.memory_consumption=256" >> /usr/local/etc/php/conf.d/docker-php-opcache.ini \
    && echo "opcache.max_accelerated_files=20000" >> /usr/local/etc/php/conf.d/docker-php-opcache.ini \
    && echo "opcache.revalidate_freq=0" >> /usr/local/etc/php/conf.d/docker-php-opcache.ini \
    && echo "opcache.validate_timestamps=1" >> /usr/local/etc/php/conf.d/docker-php-opcache.ini

# Copy Xdebug configuration
COPY xdebug.ini /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini

# Create Xdebug log directory
RUN mkdir -p /tmp/xdebug && chmod 777 /tmp/xdebug

# Set proper permissions
RUN chown -R www-data:www-data /var/www/html

# Expose port 80
EXPOSE 80
