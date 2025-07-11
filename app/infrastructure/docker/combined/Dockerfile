# Docker Master - Combined Services Container
# Tối ưu hóa bằng cách gom nhiều services vào 1 container
# RAM usage: ~200MB (thay vì 500MB+ cho nhiều containers)

FROM php:8.4-apache

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV POSTGRES_VERSION=15
ENV REDIS_VERSION=7

# Install system dependencies in one layer
RUN apt-get update && apt-get install -y \
    # PostgreSQL
    postgresql-${POSTGRES_VERSION} \
    postgresql-client-${POSTGRES_VERSION} \
    postgresql-contrib-${POSTGRES_VERSION} \
    # Redis
    redis-server \
    # Process manager
    supervisor \
    # PHP extensions dependencies
    libpq-dev \
    libzip-dev \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    # Utilities
    curl \
    vim \
    htop \
    && rm -rf /var/lib/apt/lists/*

# Install PHP extensions
RUN docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) \
        pdo \
        pdo_pgsql \
        pgsql \
        zip \
        gd \
        opcache

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Configure PHP for low memory usage
RUN { \
    echo 'memory_limit = 64M'; \
    echo 'max_execution_time = 30'; \
    echo 'max_input_vars = 1000'; \
    echo 'post_max_size = 8M'; \
    echo 'upload_max_filesize = 8M'; \
    echo 'opcache.enable = 1'; \
    echo 'opcache.memory_consumption = 32'; \
    echo 'opcache.max_accelerated_files = 1000'; \
    echo 'opcache.validate_timestamps = 0'; \
} > /usr/local/etc/php/conf.d/optimization.ini

# Configure PostgreSQL for low memory
RUN { \
    echo "shared_buffers = 16MB"; \
    echo "effective_cache_size = 64MB"; \
    echo "work_mem = 2MB"; \
    echo "maintenance_work_mem = 8MB"; \
    echo "max_connections = 25"; \
    echo "wal_buffers = 1MB"; \
    echo "checkpoint_segments = 8"; \
    echo "checkpoint_completion_target = 0.9"; \
} >> /etc/postgresql/${POSTGRES_VERSION}/main/postgresql.conf

# Configure Redis for low memory
RUN { \
    echo "maxmemory 16mb"; \
    echo "maxmemory-policy allkeys-lru"; \
    echo "save 900 1"; \
    echo "save 300 10"; \
    echo "save 60 10000"; \
    echo "tcp-keepalive 60"; \
} >> /etc/redis/redis.conf

# Create supervisor configuration
RUN mkdir -p /var/log/supervisor

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Configure Apache
RUN a2enmod rewrite
RUN { \
    echo 'ServerTokens Prod'; \
    echo 'ServerSignature Off'; \
    echo 'StartServers 1'; \
    echo 'MinSpareServers 1'; \
    echo 'MaxSpareServers 3'; \
    echo 'MaxRequestWorkers 10'; \
} >> /etc/apache2/apache2.conf

# Create application directory
RUN mkdir -p /var/www/html
WORKDIR /var/www/html

# Set proper permissions
RUN chown -R www-data:www-data /var/www/html
RUN chmod -R 755 /var/www/html

# Initialize PostgreSQL
RUN service postgresql start && \
    sudo -u postgres createuser -s root && \
    sudo -u postgres createdb docker_master && \
    service postgresql stop

# Expose ports
EXPOSE 80 5432 6379

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD curl -f http://localhost/ || exit 1

# Start supervisor
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
