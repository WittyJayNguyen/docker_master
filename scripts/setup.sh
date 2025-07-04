#!/bin/bash

# Docker Multi-Project Setup Script
echo "🚀 Setting up Docker Multi-Project Environment..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo -e "${RED}❌ Docker is not installed. Please install Docker first.${NC}"
    exit 1
fi

# Check if Docker Compose is installed
if ! command -v docker-compose &> /dev/null; then
    echo -e "${RED}❌ Docker Compose is not installed. Please install Docker Compose first.${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Docker and Docker Compose are installed${NC}"

# Create necessary directories
echo -e "${BLUE}📁 Creating necessary directories...${NC}"
mkdir -p data/mysql data/uploads logs/apache logs/mysql
mkdir -p projects/wordpress projects/laravel projects/vue

# Set permissions
echo -e "${BLUE}🔐 Setting permissions...${NC}"
chmod -R 755 data/
chmod -R 755 logs/
chmod +x scripts/*.sh

# Copy environment file if it doesn't exist
if [ ! -f .env ]; then
    echo -e "${YELLOW}⚠️  .env file not found. Please create one based on .env.example${NC}"
fi

# Enable Apache sites
echo -e "${BLUE}🌐 Preparing Apache virtual hosts...${NC}"
mkdir -p docker/apache/sites-enabled
ln -sf ../sites-available/wordpress.conf docker/apache/sites-enabled/
ln -sf ../sites-available/laravel.conf docker/apache/sites-enabled/

# Add hosts entries reminder
echo -e "${YELLOW}📝 Don't forget to add these entries to your /etc/hosts file:${NC}"
echo "127.0.0.1 wordpress.local"
echo "127.0.0.1 laravel.local"
echo "127.0.0.1 vue.local"

# Create sample projects if they don't exist
echo -e "${BLUE}📦 Creating sample project files...${NC}"

# WordPress sample
if [ ! -f projects/wordpress/index.php ]; then
    cat > projects/wordpress/index.php << 'EOF'
<?php
echo "<h1>WordPress Site</h1>";
echo "<p>WordPress will be installed here.</p>";
echo "<p>Database: wordpress_db</p>";
echo "<p>User: wp_user</p>";
phpinfo();
?>
EOF
fi

# Laravel sample
if [ ! -f projects/laravel/public/index.php ]; then
    mkdir -p projects/laravel/public
    cat > projects/laravel/public/index.php << 'EOF'
<?php
echo "<h1>Laravel Application</h1>";
echo "<p>Laravel will be installed here.</p>";
echo "<p>Database: laravel_db</p>";
echo "<p>User: laravel_user</p>";
phpinfo();
?>
EOF
fi

# Vue sample
if [ ! -f projects/vue/package.json ]; then
    cat > projects/vue/package.json << 'EOF'
{
  "name": "vue-project",
  "version": "1.0.0",
  "scripts": {
    "dev": "vue-cli-service serve --host 0.0.0.0 --port 3000",
    "build": "vue-cli-service build"
  },
  "dependencies": {
    "vue": "^3.3.0"
  },
  "devDependencies": {
    "@vue/cli-service": "^5.0.0"
  }
}
EOF

    cat > projects/vue/index.html << 'EOF'
<!DOCTYPE html>
<html>
<head>
    <title>Vue.js Project</title>
</head>
<body>
    <div id="app">
        <h1>Vue.js Application</h1>
        <p>Vue.js development server will run here on port 3000</p>
    </div>
</body>
</html>
EOF
fi

echo -e "${GREEN}✅ Setup completed successfully!${NC}"
echo -e "${BLUE}🎯 Next steps:${NC}"
echo "1. Run: ./scripts/start.sh"
echo "2. Access your applications:"
echo "   - WordPress: http://wordpress.local"
echo "   - Laravel: http://laravel.local"
echo "   - Vue.js: http://localhost:3000"
echo "   - phpMyAdmin: http://localhost:8080"
