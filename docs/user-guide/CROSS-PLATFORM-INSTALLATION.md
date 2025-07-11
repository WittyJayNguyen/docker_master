# 🌍 Cross-Platform Installation Guide

Docker Master Platform now supports **Windows, Linux, and macOS** with optimized scripts and configurations for each platform.

## 🖥️ Platform Support

### ✅ **Fully Supported Platforms**
- **Windows 10/11** (PowerShell, Command Prompt, Git Bash, WSL)
- **Linux** (Ubuntu, Debian, CentOS, Fedora, Arch)
- **macOS** (Intel and Apple Silicon)

### 🔧 **Requirements**

#### All Platforms:
- **Docker Desktop** or **Docker Engine** (20.10+)
- **Docker Compose** (2.0+)
- **Git** (for cloning repository)

#### Platform-Specific:
- **Windows**: PowerShell 5.1+ or Git Bash
- **Linux**: Bash 4.0+
- **macOS**: Bash 3.2+ or Zsh

## 🚀 Quick Installation

### 1. **Clone Repository**
```bash
git clone https://github.com/your-repo/docker_master.git
cd docker_master
```

### 2. **Make Scripts Executable (Linux/macOS)**
```bash
chmod +x docker-master
chmod +x bin/*.sh
chmod +x src/scripts/**/*.sh
```

### 3. **Copy Environment File**
```bash
cp .env.example .env
```

### 4. **Start Platform**

#### Universal Launcher (Recommended):
```bash
# Works on all platforms
./docker-master start
```

#### Platform-Specific:
```bash
# Windows
bin\start.bat

# Linux/macOS
./bin/start.sh
```

## 🖥️ Windows Installation

### **Option 1: PowerShell/Command Prompt**
```powershell
# Clone repository
git clone https://github.com/your-repo/docker_master.git
cd docker_master

# Copy environment file
copy .env.example .env

# Start platform
bin\start.bat
```

### **Option 2: Git Bash/WSL**
```bash
# Clone repository
git clone https://github.com/your-repo/docker_master.git
cd docker_master

# Make scripts executable
chmod +x docker-master bin/*.sh src/scripts/**/*.sh

# Copy environment file
cp .env.example .env

# Start platform (auto-detects Windows)
./docker-master start
```

### **Windows-Specific Features:**
- ✅ Native `.bat` scripts for PowerShell/CMD
- ✅ Auto-detection in Git Bash/WSL
- ✅ Windows path handling
- ✅ Docker Desktop integration

## 🐧 Linux Installation

### **Ubuntu/Debian:**
```bash
# Install Docker
sudo apt update
sudo apt install docker.io docker-compose git

# Add user to docker group
sudo usermod -aG docker $USER
newgrp docker

# Clone and setup
git clone https://github.com/your-repo/docker_master.git
cd docker_master
chmod +x docker-master bin/*.sh src/scripts/**/*.sh
cp .env.example .env

# Start platform
./docker-master start
```

### **CentOS/RHEL/Fedora:**
```bash
# Install Docker
sudo dnf install docker docker-compose git
sudo systemctl start docker
sudo systemctl enable docker
sudo usermod -aG docker $USER

# Clone and setup
git clone https://github.com/your-repo/docker_master.git
cd docker_master
chmod +x docker-master bin/*.sh src/scripts/**/*.sh
cp .env.example .env

# Start platform
./docker-master start
```

### **Linux-Specific Features:**
- ✅ Native Unix scripts
- ✅ Systemd integration
- ✅ Resource monitoring
- ✅ Performance optimization

## 🍎 macOS Installation

### **Using Homebrew (Recommended):**
```bash
# Install Docker Desktop
brew install --cask docker

# Install Git (if not already installed)
brew install git

# Clone and setup
git clone https://github.com/your-repo/docker_master.git
cd docker_master
chmod +x docker-master bin/*.sh src/scripts/**/*.sh
cp .env.example .env

# Start platform
./docker-master start
```

### **Manual Installation:**
1. Download and install [Docker Desktop for Mac](https://www.docker.com/products/docker-desktop)
2. Install Xcode Command Line Tools: `xcode-select --install`
3. Follow the clone and setup steps above

### **macOS-Specific Features:**
- ✅ Apple Silicon (M1/M2) support
- ✅ Intel Mac support
- ✅ Native Unix scripts
- ✅ Optimized for macOS Docker Desktop

## 🔧 Configuration

### **Environment Variables (.env)**
```bash
# Platform Detection (auto-detected)
PLATFORM_OS=auto

# Port Configuration
LARAVEL84_PORT=8010
LARAVEL74_PORT=8011
WORDPRESS_PORT=8012

# Database Configuration
POSTGRES_PORT=5432
MYSQL_PORT=3306
REDIS_PORT=6379

# Development Settings
ENABLE_XDEBUG=true
ENABLE_OPCACHE=true
```

### **Custom Configuration**
```bash
# Edit environment file
nano .env  # Linux/macOS
notepad .env  # Windows

# Restart platform
./docker-master restart
```

## 🚀 Usage Examples

### **Universal Commands (All Platforms):**
```bash
# Start platform
./docker-master start

# Create new platform
./docker-master create my-blog

# Check status
./docker-master status

# Stop platform
./docker-master stop

# View logs
./docker-master docker-compose logs
```

### **Platform-Specific Commands:**

#### Windows:
```powershell
bin\create.bat my-project
bin\status.bat
bin\docker-compose.bat ps
```

#### Linux/macOS:
```bash
./bin/create.sh my-project
./bin/status.sh
./bin/docker-compose.sh ps
```

## 🔍 Troubleshooting

### **Common Issues:**

#### **Permission Denied (Linux/macOS):**
```bash
chmod +x docker-master
chmod +x bin/*.sh
chmod +x src/scripts/**/*.sh
```

#### **Docker Not Running:**
```bash
# Linux
sudo systemctl start docker

# macOS/Windows
# Start Docker Desktop application
```

#### **Port Conflicts:**
```bash
# Check .env file and modify ports
nano .env

# Restart platform
./docker-master restart
```

#### **WSL Issues (Windows):**
```bash
# Ensure WSL 2 is enabled
wsl --set-default-version 2

# Use Docker Desktop with WSL 2 backend
```

## 🌟 Platform-Specific Optimizations

### **Windows:**
- Optimized for Docker Desktop
- Native PowerShell integration
- Git Bash compatibility
- WSL 2 support

### **Linux:**
- Native Docker Engine support
- Systemd integration
- Resource monitoring
- Performance tuning

### **macOS:**
- Apple Silicon optimization
- Docker Desktop integration
- Native Unix tools
- Homebrew compatibility

## 🎉 Ready for Development!

Your Docker Master Platform is now ready for cross-platform development. Choose your preferred method and start building amazing applications!

**Next Steps:**
1. Create your first platform: `./docker-master create my-project`
2. Check the status: `./docker-master status`
3. Start developing! 🚀
