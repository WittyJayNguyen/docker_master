ARG PHP_VERSION=8.2
FROM webdevops/php-apache:${PHP_VERSION}

# Install additional packages
RUN apt-get update && apt-get install -y \
    git \
    curl \
    zip \
    unzip \
    nano \
    wget \
    supervisor \
    && rm -rf /var/lib/apt/lists/*

# Install Node.js and npm
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - \
    && apt-get install -y nodejs

# Set working directory
WORKDIR /app

# Create Laravel directory structure
RUN mkdir -p /app/laravel

# Copy custom PHP configuration for Laravel
COPY php.ini /opt/docker/etc/php/php.ini

# Create storage and cache directories
RUN mkdir -p /app/laravel/storage/logs \
    && mkdir -p /app/laravel/storage/framework/cache \
    && mkdir -p /app/laravel/storage/framework/sessions \
    && mkdir -p /app/laravel/storage/framework/views \
    && mkdir -p /app/laravel/bootstrap/cache

# Set proper permissions for Laravel
RUN chown -R application:application /app/laravel \
    && chmod -R 775 /app/laravel

# Expose port
EXPOSE 80
