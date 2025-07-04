FROM webdevops/php-apache:7.4

# Install additional packages
RUN apt-get update && apt-get install -y \
    git \
    curl \
    zip \
    unzip \
    nano \
    wget \
    && rm -rf /var/lib/apt/lists/*

# Install WP-CLI
RUN curl -O https://raw.githubusercontent.com/wp-cli/wp-cli/v2.8.1/wp-cli.phar \
    && chmod +x wp-cli.phar \
    && mv wp-cli.phar /usr/local/bin/wp

# Set working directory
WORKDIR /app

# Create WordPress directory structure
RUN mkdir -p /app/wordpress

# Copy custom PHP configuration for WordPress
COPY php.ini /opt/docker/etc/php/php.ini

# Create uploads directory and set permissions
RUN mkdir -p /app/wordpress/wp-content/uploads \
    && chown -R application:application /app/wordpress \
    && chmod -R 755 /app/wordpress

# Expose port
EXPOSE 80
