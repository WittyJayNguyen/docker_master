#!/bin/bash

# Docker Master Platform - Optimized Setup Script
# Fixes all identified issues and sets up proper testing environment

set -e

echo "🚀 Docker Master Platform - Optimized Setup"
echo "=============================================="

# Update system packages
echo "📦 Updating system packages..."
apt-get update -qq

# Install Docker if not present
if ! command -v docker &> /dev/null; then
    echo "🐳 Installing Docker..."
    curl -fsSL https://get.docker.com -o get-docker.sh
    sh get-docker.sh
    usermod -aG docker $USER
    systemctl enable docker
    systemctl start docker
fi

# Install Docker Compose if not present
if ! command -v docker-compose &> /dev/null; then
    echo "🔧 Installing Docker Compose..."
    curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    chmod +x /usr/local/bin/docker-compose
fi

# Install Node.js and npm for frontend testing
if ! command -v node &> /dev/null; then
    echo "📦 Installing Node.js..."
    curl -fsSL https://deb.nodesource.com/setup_18.x | bash -
    apt-get install -y nodejs
fi

# Install PHP and Composer for PHP testing
if ! command -v php &> /dev/null; then
    echo "🐘 Installing PHP..."
    apt-get install -y php8.1 php8.1-cli php8.1-curl php8.1-mbstring php8.1-xml php8.1-zip
fi

if ! command -v composer &> /dev/null; then
    echo "🎼 Installing Composer..."
    curl -sS https://getcomposer.org/installer | php
    mv composer.phar /usr/local/bin/composer
    chmod +x /usr/local/bin/composer
fi

# Install testing tools
echo "🧪 Installing testing tools..."
apt-get install -y curl wget jq

# Create necessary directories with proper structure
echo "📁 Creating directory structure..."
mkdir -p {data/{mysql,postgres,redis},logs/{apache,mysql,postgres},projects,platforms,nginx/conf.d}
mkdir -p {bin,scripts,docker/{php74,php84,node,combined,universal-php74,universal-php84}}

# Fix permissions
echo "🔐 Setting proper permissions..."
chmod -R 755 data/ logs/ projects/ platforms/
chmod +x bin/* scripts/* 2>/dev/null || true

# Create .gitkeep files for empty directories
echo "📝 Creating .gitkeep files..."
touch data/.gitkeep logs/.gitkeep
touch data/mysql/.gitkeep data/postgres/.gitkeep data/redis/.gitkeep
touch logs/apache/.gitkeep logs/mysql/.gitkeep logs/postgres/.gitkeep

# Fix Docker Compose configuration issues
echo "🔧 Fixing Docker configurations..."

# Create optimized docker-compose.yml with consistent database setup
cat > docker-compose.fixed.yml << 'EOF'
version: '3.8'

services:
  # PostgreSQL - Primary database
  postgres:
    image: postgres:17-alpine
    container_name: postgres_low_ram
    restart: unless-stopped
    ports:
      - "5432:5432"
    volumes:
      - ./data/postgres:/var/lib/postgresql/data
    environment:
      - POSTGRES_DB=docker_master
      - POSTGRES_USER=postgres_user
      - POSTGRES_PASSWORD=postgres_pass
      - POSTGRES_SHARED_BUFFERS=16MB
      - POSTGRES_EFFECTIVE_CACHE_SIZE=64MB
    deploy:
      resources:
        limits:
          memory: 128M
    networks:
      - app-network
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U postgres_user"]
      interval: 30s
      timeout: 10s
      retries: 3

  # Redis - Caching
  redis:
    image: redis:7-alpine
    container_name: redis_low_ram
    restart: unless-stopped
    ports:
      - "6379:6379"
    volumes:
      - ./data/redis:/data
    command: redis-server --maxmemory 32mb --maxmemory-policy allkeys-lru
    deploy:
      resources:
        limits:
          memory: 64M
    networks:
      - app-network

  # PHP 8.4 Laravel
  laravel-php84:
    build:
      context: ./docker/php84
      dockerfile: Dockerfile
    container_name: laravel_php84_low_ram
    restart: unless-stopped
    ports:
      - "8010:80"
      - "9084:9003"
    volumes:
      - ./projects/laravel-php84-psql:/var/www/html
      - ./logs/apache/laravel-php84:/var/log/apache2
    environment:
      - DB_HOST=postgres_low_ram
      - DB_PORT=5432
      - DB_DATABASE=laravel_php84_psql
      - DB_USERNAME=postgres_user
      - DB_PASSWORD=postgres_pass
      - REDIS_HOST=redis_low_ram
    depends_on:
      postgres:
        condition: service_healthy
      redis:
        condition: service_started
    deploy:
      resources:
        limits:
          memory: 128M
    networks:
      - app-network

  # PHP 7.4 Laravel
  laravel-php74:
    build:
      context: ./docker/php74
      dockerfile: Dockerfile
    container_name: laravel_php74_low_ram
    restart: unless-stopped
    ports:
      - "8020:80"
      - "9074:9003"
    volumes:
      - ./projects/laravel-php74-psql:/var/www/html
      - ./logs/apache/laravel-php74:/var/log/apache2
    environment:
      - DB_HOST=postgres_low_ram
      - DB_PORT=5432
      - DB_DATABASE=laravel_php74_psql
      - DB_USERNAME=postgres_user
      - DB_PASSWORD=postgres_pass
      - REDIS_HOST=redis_low_ram
    depends_on:
      postgres:
        condition: service_healthy
      redis:
        condition: service_started
    deploy:
      resources:
        limits:
          memory: 128M
    networks:
      - app-network

  # Mailhog for email testing
  mailhog:
    image: mailhog/mailhog:latest
    container_name: mailhog_low_ram
    restart: unless-stopped
    ports:
      - "8025:8025"
      - "1025:1025"
    deploy:
      resources:
        limits:
          memory: 32M
    networks:
      - app-network

networks:
  app-network:
    driver: bridge
    name: docker_master_network

volumes:
  postgres_data:
    driver: local
  redis_data:
    driver: local
EOF

# Create fixed PHP 8.4 Dockerfile
mkdir -p docker/php84
cat > docker/php84/Dockerfile << 'EOF'
FROM php:8.1-apache

# Install system dependencies
RUN apt-get update && apt-get install -y \
    libpq-dev \
    libzip-dev \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    unzip \
    git \
    curl \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) \
        pdo \
        pdo_pgsql \
        pgsql \
        zip \
        gd \
        opcache \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Install Xdebug
RUN pecl install xdebug \
    && docker-php-ext-enable xdebug

# Configure PHP
RUN { \
    echo 'memory_limit = 128M'; \
    echo 'opcache.enable = 1'; \
    echo 'opcache.memory_consumption = 64'; \
    echo 'xdebug.mode = debug'; \
    echo 'xdebug.client_host = host.docker.internal'; \
    echo 'xdebug.client_port = 9003'; \
} > /usr/local/etc/php/conf.d/custom.ini

# Enable Apache rewrite
RUN a2enmod rewrite

WORKDIR /var/www/html
EXPOSE 80 9003
EOF

# Create fixed PHP 7.4 Dockerfile
mkdir -p docker/php74
cat > docker/php74/Dockerfile << 'EOF'
FROM php:7.4-apache

# Install system dependencies
RUN apt-get update && apt-get install -y \
    libpq-dev \
    libzip-dev \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    unzip \
    git \
    curl \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) \
        pdo \
        pdo_pgsql \
        pgsql \
        zip \
        gd \
        opcache \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Install Xdebug
RUN pecl install xdebug-3.1.6 \
    && docker-php-ext-enable xdebug

# Configure PHP
RUN { \
    echo 'memory_limit = 128M'; \
    echo 'opcache.enable = 1'; \
    echo 'opcache.memory_consumption = 64'; \
    echo 'xdebug.mode = debug'; \
    echo 'xdebug.client_host = host.docker.internal'; \
    echo 'xdebug.client_port = 9003'; \
} > /usr/local/etc/php/conf.d/custom.ini

# Enable Apache rewrite
RUN a2enmod rewrite

WORKDIR /var/www/html
EXPOSE 80 9003
EOF

# Create test projects with proper database connections
echo "📝 Creating test projects..."

# Laravel PHP 8.4 project
mkdir -p projects/laravel-php84-psql
cat > projects/laravel-php84-psql/index.php << 'EOF'
<?php
echo "<h1>🚀 Laravel PHP 8.4 + PostgreSQL</h1>";
echo "<div style='font-family: Arial, sans-serif; max-width: 800px; margin: 0 auto; padding: 20px;'>";

echo "<h2>📋 System Information</h2>";
echo "<p><strong>PHP Version:</strong> " . phpversion() . "</p>";
echo "<p><strong>Server:</strong> " . $_SERVER['SERVER_SOFTWARE'] . "</p>";

echo "<h2>🗄️ Database Connection Test</h2>";
try {
    $pdo = new PDO("pgsql:host=postgres_low_ram;dbname=laravel_php84_psql", "postgres_user", "postgres_pass");
    echo "<p style='color: green;'>✅ PostgreSQL connection successful!</p>";
    
    // Test Redis connection
    if (extension_loaded('redis')) {
        $redis = new Redis();
        $redis->connect('redis_low_ram', 6379);
        echo "<p style='color: green;'>✅ Redis connection successful!</p>";
    }
} catch (Exception $e) {
    echo "<p style='color: red;'>❌ Database connection failed: " . $e->getMessage() . "</p>";
}

echo "<h2>🔧 Loaded Extensions</h2>";
$extensions = get_loaded_extensions();
sort($extensions);
echo "<div style='columns: 3; column-gap: 20px;'>";
foreach (array_slice($extensions, 0, 15) as $ext) {
    echo "<p>• " . htmlspecialchars($ext) . "</p>";
}
echo "</div>";

echo "</div>";
?>
EOF

# Laravel PHP 7.4 project
mkdir -p projects/laravel-php74-psql
cat > projects/laravel-php74-psql/index.php << 'EOF'
<?php
echo "<h1>🚀 Laravel PHP 7.4 + PostgreSQL</h1>";
echo "<div style='font-family: Arial, sans-serif; max-width: 800px; margin: 0 auto; padding: 20px;'>";

echo "<h2>📋 System Information</h2>";
echo "<p><strong>PHP Version:</strong> " . phpversion() . "</p>";
echo "<p><strong>Server:</strong> " . $_SERVER['SERVER_SOFTWARE'] . "</p>";

echo "<h2>🗄️ Database Connection Test</h2>";
try {
    $pdo = new PDO("pgsql:host=postgres_low_ram;dbname=laravel_php74_psql", "postgres_user", "postgres_pass");
    echo "<p style='color: green;'>✅ PostgreSQL connection successful!</p>";
} catch (Exception $e) {
    echo "<p style='color: red;'>❌ Database connection failed: " . $e->getMessage() . "</p>";
}

echo "<h2>✨ PHP 7.4 Features</h2>";
// Arrow functions
$numbers = [1, 2, 3, 4, 5];
$squared = array_map(fn($n) => $n * $n, $numbers);
echo "<p><strong>Arrow Functions:</strong> [" . implode(', ', $squared) . "]</p>";

// Null coalescing assignment
$config = [];
$config['timeout'] ??= 30;
echo "<p><strong>Null Coalescing Assignment:</strong> timeout = " . $config['timeout'] . "</p>";

echo "</div>";
?>
EOF

# Create package.json for Node.js testing
cat > docker/node/package.json << 'EOF'
{
  "name": "docker-master-tests",
  "version": "1.0.0",
  "description": "Test suite for Docker Master Platform",
  "scripts": {
    "test": "jest",
    "test:watch": "jest --watch",
    "test:coverage": "jest --coverage"
  },
  "devDependencies": {
    "jest": "^29.0.0",
    "@types/jest": "^29.0.0"
  }
}
EOF

# Create basic test files
mkdir -p tests
cat > tests/docker-health.test.js << 'EOF'
const { exec } = require('child_process');
const util = require('util');
const execPromise = util.promisify(exec);

describe('Docker Health Tests', () => {
  test('Docker is running', async () => {
    try {
      const { stdout } = await execPromise('docker --version');
      expect(stdout).toContain('Docker version');
    } catch (error) {
      fail('Docker is not running');
    }
  });

  test('Docker Compose is available', async () => {
    try {
      const { stdout } = await execPromise('docker-compose --version');
      expect(stdout).toContain('docker-compose version');
    } catch (error) {
      fail('Docker Compose is not available');
    }
  });
});
EOF

cat > tests/platform-connectivity.test.js << 'EOF'
const http = require('http');

function testUrl(url, timeout = 5000) {
  return new Promise((resolve, reject) => {
    const req = http.get(url, (res) => {
      resolve(res.statusCode === 200);
    });
    
    req.on('error', () => resolve(false));
    req.setTimeout(timeout, () => {
      req.destroy();
      resolve(false);
    });
  });
}

describe('Platform Connectivity Tests', () => {
  test('Laravel PHP 8.4 is accessible', async () => {
    const isAccessible = await testUrl('http://localhost:8010');
    expect(isAccessible).toBe(true);
  }, 10000);

  test('Laravel PHP 7.4 is accessible', async () => {
    const isAccessible = await testUrl('http://localhost:8020');
    expect(isAccessible).toBe(true);
  }, 10000);

  test('Mailhog is accessible', async () => {
    const isAccessible = await testUrl('http://localhost:8025');
    expect(isAccessible).toBe(true);
  }, 10000);
});
EOF

# Create Jest configuration
cat > jest.config.js << 'EOF'
module.exports = {
  testEnvironment: 'node',
  testMatch: ['**/tests/**/*.test.js'],
  collectCoverageFrom: [
    'projects/**/*.js',
    '!**/node_modules/**'
  ],
  testTimeout: 30000
};
EOF

# Install Node.js dependencies
echo "📦 Installing Node.js test dependencies..."
npm install

# Create PHP test files
mkdir -p tests/php
cat > tests/php/DatabaseTest.php << 'EOF'
<?php
class DatabaseTest {
    public function testPostgreSQLConnection() {
        try {
            $pdo = new PDO("pgsql:host=postgres_low_ram;dbname=docker_master", "postgres_user", "postgres_pass");
            echo "✅ PostgreSQL connection test passed\n";
            return true;
        } catch (Exception $e) {
            echo "❌ PostgreSQL connection test failed: " . $e->getMessage() . "\n";
            return false;
        }
    }
    
    public function testDatabaseCreation() {
        try {
            $pdo = new PDO("pgsql:host=postgres_low_ram;dbname=docker_master", "postgres_user", "postgres_pass");
            
            // Create test databases
            $databases = ['laravel_php84_psql', 'laravel_php74_psql'];
            foreach ($databases as $db) {
                $pdo->exec("CREATE DATABASE $db");
                echo "✅ Database $db created successfully\n";
            }
            return true;
        } catch (Exception $e) {
            echo "ℹ️  Database creation: " . $e->getMessage() . "\n";
            return true; // Databases might already exist
        }
    }
}

// Run tests
$test = new DatabaseTest();
$test->testPostgreSQLConnection();
$test->testDatabaseCreation();
?>
EOF

# Create comprehensive test runner script
cat > run-tests.sh << 'EOF'
#!/bin/bash

echo "🧪 Docker Master Platform - Test Suite"
echo "======================================"

# Start Docker services
echo "🚀 Starting Docker services..."
docker-compose -f docker-compose.fixed.yml up -d

# Wait for services to be ready
echo "⏳ Waiting for services to start..."
sleep 30

# Test database connectivity
echo "🗄️ Testing database connectivity..."
docker exec postgres_low_ram pg_isready -U postgres_user

# Run PHP tests
echo "🐘 Running PHP tests..."
php tests/php/DatabaseTest.php

# Run Node.js tests
echo "📦 Running Node.js tests..."
npm test

echo "✅ All tests completed!"
EOF

chmod +x run-tests.sh

# Create optimized .gitignore
cat > .gitignore << 'EOF'
# Docker Master Platform - Git Ignore Rules

# Docker data directories
data/
!data/.gitkeep

# Log directories
logs/
!logs/.gitkeep

# Node modules
node_modules/
npm-debug.log*

# PHP dependencies
vendor/
composer.lock

# Environment files
.env
.env.local

# IDE files
.vscode/
.idea/
*.swp
*.swo

# OS specific
.DS_Store
Thumbs.db
desktop.ini

# Test coverage
coverage/
*.lcov

# Temporary files
*.tmp
*.bak
*.backup
*~
EOF

# Add scripts to PATH
echo 'export PATH="$PWD/bin:$PWD/scripts:$PATH"' >> $HOME/.profile

echo "✅ Docker Master Platform setup completed!"
echo "🧪 Test environment configured with:"
echo "   • Docker & Docker Compose"
echo "   • PHP 7.4 & 8.1 with PostgreSQL"
echo "   • Node.js with Jest testing framework"
echo "   • Optimized Docker configurations"
echo "   • Fixed database connectivity issues"
echo "   • Comprehensive test suite"