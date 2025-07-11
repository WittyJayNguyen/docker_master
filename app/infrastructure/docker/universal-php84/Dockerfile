FROM php:8.4-apache
RUN apt-get update && apt-get install -y \
    postgresql-client mysql-client \
    libpq-dev libzip-dev libpng-dev libjpeg-dev libfreetype6-dev \
    supervisor cron git unzip curl vim htop \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) \
        pdo pdo_mysql pdo_pgsql pgsql mysqli zip gd mbstring xml curl bcmath opcache \
    && rm -rf /var/lib/apt/lists/*
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer
RUN a2enmod rewrite && { \
    echo 'memory_limit = 128M'; \
    echo 'opcache.enable = 1'; \
    echo 'opcache.memory_consumption = 64'; \
} > /usr/local/etc/php/conf.d/optimization.ini
WORKDIR /var/www/html
EXPOSE 80 9003
