#!/bin/bash

# Fix Apache configuration issues
echo "Fixing Apache configuration..."

# Remove problematic module loading from apache2.conf
sed -i 's/^LoadModule mpm_prefork_module/#LoadModule mpm_prefork_module/' /etc/apache2/apache2.conf 2>/dev/null || true
sed -i 's/^LoadModule mpm_worker_module/#LoadModule mpm_worker_module/' /etc/apache2/apache2.conf 2>/dev/null || true
sed -i 's/^LoadModule mpm_event_module/#LoadModule mpm_event_module/' /etc/apache2/apache2.conf 2>/dev/null || true

# Enable required modules
a2enmod rewrite ssl headers 2>/dev/null || true

# Start Apache in foreground
echo "Starting Apache..."
exec apache2-foreground
