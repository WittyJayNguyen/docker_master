# 🚀 Installation Guide - Docker Master Platform

> **Beginner Level** - Hướng dẫn cài đặt Docker Master từ đầu

## 📋 System Requirements

### Minimum Requirements
- **RAM:** 4GB (8GB recommended)
- **Storage:** 10GB free space
- **Docker:** 20.10+ with Docker Compose
- **OS:** Windows 10/11, macOS, or Linux

### Recommended Setup
- **RAM:** 8GB+ for multiple platforms
- **SSD:** For better performance
- **CPU:** 4+ cores for optimal experience

## 🔧 Prerequisites

### 1. Install Docker Desktop

#### Windows
1. Download Docker Desktop từ [docker.com](https://www.docker.com/products/docker-desktop)
2. Run installer và follow instructions
3. Restart computer khi được yêu cầu
4. Verify installation:
   ```bash
   docker --version
   docker-compose --version
   ```

#### macOS
1. Download Docker Desktop for Mac
2. Drag Docker.app to Applications folder
3. Launch Docker Desktop
4. Verify installation:
   ```bash
   docker --version
   docker-compose --version
   ```

#### Linux (Ubuntu/Debian)
```bash
# Update package index
sudo apt update

# Install Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

# Add user to docker group
sudo usermod -aG docker $USER

# Install Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/download/v2.20.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Verify installation
docker --version
docker-compose --version
```

### 2. Configure Docker Resources

#### Memory Allocation
- **Minimum:** 4GB RAM allocated to Docker
- **Recommended:** 6-8GB for multiple platforms

#### Storage
- Ensure at least 10GB free space
- Consider using SSD for better performance

## 📥 Download Docker Master

### Option 1: Git Clone (Recommended)
```bash
# Clone repository
git clone https://github.com/your-repo/docker-master.git
cd docker-master

# Verify structure
ls -la
```

### Option 2: Download ZIP
1. Download ZIP từ GitHub releases
2. Extract to desired location
3. Open terminal in extracted folder

## ⚙️ Initial Setup

### 1. Environment Configuration
```bash
# Copy environment template
cp .env.example .env

# Edit configuration (optional)
nano .env
```

### 2. Build Base Images
```bash
# Build all base images
docker/scripts/build-all.sh

# Or use automation script
automation/maintenance/update-images.sh
```

### 3. Initialize System
```bash
# Start core services
docker-compose -f docker-compose.low-ram.yml up -d

# Wait for services to be ready
automation/monitoring/health-check.sh

# Verify installation
node cli/monitor.js status
```

## ✅ Verification

### 1. Check Docker Services
```bash
# List running containers
docker ps

# Expected services:
# - postgres_low_ram
# - mysql_low_ram  
# - redis_low_ram
# - nginx_proxy (if configured)
```

### 2. Test Platform Creation
```bash
# Create test platform
node cli/create.js test-platform

# Verify platform is running
curl http://localhost:8015

# Clean up test
node cli/manage.js delete test-platform
```

### 3. Access Management Tools
- **PostgreSQL:** http://localhost:8081 (pgAdmin)
- **MySQL:** http://localhost:8080 (phpMyAdmin)
- **Email Testing:** http://localhost:8025 (Mailhog)

## 🔧 Configuration Options

### Environment Variables
```bash
# Core settings
DOCKER_COMPOSE_FILE=docker-compose.low-ram.yml
DEFAULT_PHP_VERSION=84
DEFAULT_DATABASE=postgres

# Resource limits
MEMORY_LIMIT=128M
CPU_LIMIT=0.5

# Networking
DEFAULT_PORT_RANGE_START=8015
DEFAULT_PORT_RANGE_END=8100

# Development
DEBUG_MODE=true
LOG_LEVEL=info
```

### Custom Configuration
```bash
# Create local config override
cp src/config/environments/development.json src/config/local.json

# Edit local settings
nano src/config/local.json
```

## 🚨 Troubleshooting

### Common Issues

#### Docker Not Running
```bash
# Check Docker status
docker info

# Start Docker Desktop (Windows/Mac)
# Or start Docker daemon (Linux)
sudo systemctl start docker
```

#### Port Conflicts
```bash
# Check port usage
netstat -tulpn | grep :8015

# Kill process using port
sudo kill -9 <PID>

# Or use different port range
export DEFAULT_PORT_RANGE_START=9015
```

#### Memory Issues
```bash
# Check Docker memory allocation
docker system df

# Clean up unused resources
docker system prune -f

# Increase Docker memory limit in Docker Desktop settings
```

#### Permission Issues (Linux)
```bash
# Add user to docker group
sudo usermod -aG docker $USER

# Logout and login again
# Or use newgrp
newgrp docker
```

### Getting Help

#### Check Logs
```bash
# System logs
automation/monitoring/log-analyzer.sh

# Docker logs
docker-compose -f docker-compose.low-ram.yml logs

# Specific service logs
docker logs postgres_low_ram
```

#### Diagnostic Commands
```bash
# System health check
automation/monitoring/health-check.sh

# Resource usage
automation/monitoring/resource-monitor.sh

# Full system status
node cli/monitor.js status --verbose
```

## 🎯 Next Steps

### Quick Start
1. **[Create Your First Platform](first-platform.md)** - Tạo platform đầu tiên
2. **[Basic Commands](basic-commands.md)** - Học các lệnh cơ bản
3. **[Platform Types](../user-guide/platform-types.md)** - Hiểu các loại platform

### Advanced Setup
1. **[Auto-Discovery](../user-guide/auto-discovery.md)** - Sử dụng AI detection
2. **[Database Configuration](../user-guide/database-setup.md)** - Thiết lập database
3. **[Nginx Configuration](../user-guide/nginx-config.md)** - Cấu hình web server

### Development
1. **[Debug Setup](../advanced/debugging.md)** - Cấu hình debugging
2. **[Custom Platforms](../advanced/customization.md)** - Tùy chỉnh platform
3. **[Performance Tuning](../advanced/performance.md)** - Tối ưu hóa

## 📚 Additional Resources

### Documentation
- **[User Guide](../user-guide/README.md)** - Complete user documentation
- **[API Reference](../api/README.md)** - CLI and configuration reference
- **[Examples](../examples/README.md)** - Real-world examples

### Community
- **GitHub Issues** - Report bugs and request features
- **Discussions** - Ask questions and share tips
- **Wiki** - Community-contributed guides

---

**🎉 Installation Complete!** 

Ready to create your first platform? Continue to **[First Platform Guide](first-platform.md)**
