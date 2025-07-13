# Docker Master - PHP Base Image
# Optimized base image for all PHP services

FROM php:8.4-apache-alpine

LABEL maintainer="Docker Master Platform"
LABEL description="Optimized PHP base image with common extensions"
LABEL version="1.0.0"

# Install system dependencies
RUN apk add --no-cache \
    # Build dependencies
    $PHPIZE_DEPS \
    # Database drivers
    postgresql-dev \
    mysql-dev \
    sqlite-dev \
    # Image processing
    freetype-dev \
    libjpeg-turbo-dev \
    libpng-dev \
    libwebp-dev \
    imagemagick-dev \
    # Compression
    zlib-dev \
    libzip-dev \
    # XML processing
    libxml2-dev \
    # Internationalization
    icu-dev \
    # SSL/TLS
    openssl-dev \
    # Common tools
    git \
    curl \
    wget \
    unzip \
    nano \
    bash \
    # Process management
    supervisor \
    # Caching
    redis

# Configure and install PHP extensions
RUN docker-php-ext-configure gd \
        --with-freetype \
        --with-jpeg \
        --with-webp \
    && docker-php-ext-configure intl \
    && docker-php-ext-install -j$(nproc) \
        # Database extensions
        pdo_pgsql \
        pdo_mysql \
        pdo_sqlite \
        # Image processing
        gd \
        # Compression
        zip \
        # Performance
        opcache \
        # Internationalization
        intl \
        # XML
        xml \
        soap \
        # Math
        bcmath \
        # Multibyte string
        mbstring \
        # File info
        fileinfo \
        # Sockets
        sockets

# Install PECL extensions
RUN pecl install \
        redis \
        imagick \
    && docker-php-ext-enable \
        redis \
        imagick

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Create application user
RUN addgroup -g 1000 -S appuser \
    && adduser -u 1000 -S appuser -G appuser

# Configure Apache
RUN a2enmod rewrite headers ssl

# Copy base configurations
COPY config/php.ini /usr/local/etc/php/conf.d/99-docker-master.ini
COPY config/opcache.ini /usr/local/etc/php/conf.d/10-opcache.ini
COPY config/apache.conf /etc/apache2/sites-available/000-default.conf
COPY config/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Create necessary directories
RUN mkdir -p \
    /var/www/html \
    /var/log/apache2 \
    /var/log/supervisor \
    /app/uploads \
    /tmp/php-sessions \
    && chown -R appuser:appuser \
        /var/www/html \
        /app/uploads \
        /tmp/php-sessions \
    && chmod -R 755 \
        /var/www/html \
        /app/uploads \
    && chmod -R 700 /tmp/php-sessions

# Set working directory
WORKDIR /var/www/html

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD curl -f http://localhost/ || exit 1

# Expose port
EXPOSE 80

# Use supervisor to manage processes
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
