# Docker Master Platform - Nginx Virtual Host Template
# Template for generating platform-specific Nginx configurations

server {
    listen 80;
    server_name {{DOMAIN_NAME}} {{PLATFORM_NAME}}.localhost;
    
    # Security headers
    add_header X-Frame-Options "SAMEORIGIN" always;
    add_header X-Content-Type-Options "nosniff" always;
    add_header X-XSS-Protection "1; mode=block" always;
    add_header Referrer-Policy "strict-origin-when-cross-origin" always;
    
    # Logging
    access_log /var/log/nginx/{{PLATFORM_NAME}}_access.log combined;
    error_log /var/log/nginx/{{PLATFORM_NAME}}_error.log warn;
    
    # Root directory
    root /var/www/html;
    index index.php index.html index.htm;
    
    # Client settings
    client_max_body_size {{MAX_UPLOAD_SIZE:-32M}};
    client_body_timeout 60s;
    client_header_timeout 60s;
    
    # Gzip compression
    gzip on;
    gzip_vary on;
    gzip_min_length 1024;
    gzip_proxied any;
    gzip_comp_level 6;
    gzip_types
        text/plain
        text/css
        text/xml
        text/javascript
        application/json
        application/javascript
        application/xml+rss
        application/atom+xml
        image/svg+xml;
    
    # Main location block
    location / {
        try_files $uri $uri/ /index.php?$query_string;
        
        # Proxy settings for PHP-FPM
        proxy_pass http://{{PLATFORM_NAME}}_backend;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        
        # Timeouts
        proxy_connect_timeout 60s;
        proxy_send_timeout 60s;
        proxy_read_timeout 60s;
        
        # Buffer settings
        proxy_buffering on;
        proxy_buffer_size 4k;
        proxy_buffers 8 4k;
        proxy_busy_buffers_size 8k;
    }
    
    # PHP-FPM handling
    location ~ \.php$ {
        try_files $uri =404;
        fastcgi_split_path_info ^(.+\.php)(/.+)$;
        
        # Pass to PHP-FPM
        fastcgi_pass {{PLATFORM_NAME}}_php:9000;
        fastcgi_index index.php;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        include fastcgi_params;
        
        # PHP-FPM settings
        fastcgi_connect_timeout 60s;
        fastcgi_send_timeout 60s;
        fastcgi_read_timeout 60s;
        fastcgi_buffer_size 4k;
        fastcgi_buffers 8 4k;
        fastcgi_busy_buffers_size 8k;
        
        # Security
        fastcgi_param HTTP_PROXY "";
        fastcgi_param HTTPS $https if_not_empty;
        fastcgi_param SERVER_PORT $server_port;
        fastcgi_param REMOTE_ADDR $remote_addr;
    }
    
    # Static files handling
    location ~* \.(js|css|png|jpg|jpeg|gif|ico|svg|woff|woff2|ttf|eot)$ {
        expires 1y;
        add_header Cache-Control "public, immutable";
        add_header Vary "Accept-Encoding";
        
        # CORS for fonts
        location ~* \.(woff|woff2|ttf|eot)$ {
            add_header Access-Control-Allow-Origin "*";
        }
    }
    
    # Security - deny access to sensitive files
    location ~ /\. {
        deny all;
        access_log off;
        log_not_found off;
    }
    
    location ~ ~$ {
        deny all;
        access_log off;
        log_not_found off;
    }
    
    location ~* \.(env|log|htaccess|htpasswd|ini|conf)$ {
        deny all;
        access_log off;
        log_not_found off;
    }
    
    # WordPress specific rules (if platform type is wordpress)
    {{#if PLATFORM_TYPE_WORDPRESS}}
    location = /favicon.ico {
        log_not_found off;
        access_log off;
    }
    
    location = /robots.txt {
        allow all;
        log_not_found off;
        access_log off;
    }
    
    location ~* /(?:uploads|files)/.*\.php$ {
        deny all;
    }
    
    location ~ ^/wp-content/uploads/.*\.(php|php5|phtml|pl|py|jsp|asp|sh|cgi)$ {
        deny all;
    }
    
    location ~* ^.+\.(ogg|ogv|svg|svgz|eot|otf|woff|mp4|ttf|css|rss|atom|js|jpg|jpeg|gif|png|ico|zip|tgz|gz|rar|bz2|doc|xls|exe|ppt|tar|mid|midi|wav|bmp|rtf)$ {
        access_log off;
        log_not_found off;
        expires max;
    }
    {{/if}}
    
    # Laravel specific rules (if platform type is laravel)
    {{#if PLATFORM_TYPE_LARAVEL}}
    location ~ /\.ht {
        deny all;
    }
    
    location ~ /storage/.*\.php$ {
        deny all;
    }
    
    location ~ /bootstrap/cache/.*\.php$ {
        deny all;
    }
    {{/if}}
    
    # Health check endpoint
    location /health {
        access_log off;
        return 200 "healthy\n";
        add_header Content-Type text/plain;
    }
    
    # Status endpoint for monitoring
    location /nginx-status {
        stub_status on;
        access_log off;
        allow 127.0.0.1;
        allow 172.16.0.0/12;
        allow 192.168.0.0/16;
        allow 10.0.0.0/8;
        deny all;
    }
}

# Upstream definition for load balancing
upstream {{PLATFORM_NAME}}_backend {
    server {{PLATFORM_NAME}}_php:80 max_fails=3 fail_timeout=30s;
    
    # Additional servers for load balancing (if needed)
    {{#each ADDITIONAL_SERVERS}}
    server {{this}} max_fails=3 fail_timeout=30s;
    {{/each}}
    
    # Health check
    keepalive 32;
    keepalive_requests 100;
    keepalive_timeout 60s;
}

# SSL configuration (if SSL is enabled)
{{#if SSL_ENABLED}}
server {
    listen 443 ssl http2;
    server_name {{DOMAIN_NAME}} {{PLATFORM_NAME}}.localhost;
    
    # SSL certificates
    ssl_certificate /etc/nginx/ssl/{{PLATFORM_NAME}}.crt;
    ssl_certificate_key /etc/nginx/ssl/{{PLATFORM_NAME}}.key;
    
    # SSL settings
    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers ECDHE-RSA-AES256-GCM-SHA512:DHE-RSA-AES256-GCM-SHA512:ECDHE-RSA-AES256-GCM-SHA384:DHE-RSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-SHA384;
    ssl_prefer_server_ciphers off;
    ssl_session_cache shared:SSL:10m;
    ssl_session_timeout 10m;
    ssl_session_tickets off;
    
    # HSTS
    add_header Strict-Transport-Security "max-age=63072000; includeSubDomains; preload" always;
    
    # Include the same location blocks as HTTP
    include /etc/nginx/conf.d/{{PLATFORM_NAME}}_locations.conf;
}

# Redirect HTTP to HTTPS
server {
    listen 80;
    server_name {{DOMAIN_NAME}} {{PLATFORM_NAME}}.localhost;
    return 301 https://$server_name$request_uri;
}
{{/if}}
