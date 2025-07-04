# 🛠️ Scripts Directory

## 📋 Available Scripts

### 🖥️ Cross-Platform Scripts

| Script | Windows | macOS | Linux | Description |
|--------|---------|-------|-------|-------------|
| **monitor-ram-universal.sh** | ✅ | ✅ | ✅ | Auto-detect OS and run appropriate monitor |
| **monitor-ram.bat** | ✅ | ❌ | ❌ | Windows RAM monitor |
| **monitor-ram.sh** | ✅* | ✅ | ✅ | Unix RAM monitor (*Git Bash/WSL) |
| **optimize-ram.bat** | ✅ | ❌ | ❌ | Windows RAM optimizer |
| **optimize-ram.sh** | ✅* | ✅ | ✅ | Unix RAM optimizer (*Git Bash/WSL) |

## 🚀 Quick Usage

### Universal (Recommended)
```bash
# Auto-detect OS and run appropriate monitor
./scripts/monitor-ram-universal.sh

# Make executable first (macOS/Linux)
chmod +x scripts/*.sh
./scripts/monitor-ram-universal.sh
```

### Windows Specific
```cmd
# RAM Monitor
scripts\monitor-ram.bat

# RAM Optimizer
scripts\optimize-ram.bat
```

### macOS/Linux Specific
```bash
# Make executable
chmod +x scripts/*.sh

# RAM Monitor
./scripts/monitor-ram.sh

# RAM Optimizer  
./scripts/optimize-ram.sh
```

## 📊 Features by Platform

### 🪟 Windows Features
- **System Memory**: Uses `wmic` to show total/free memory
- **Container Stats**: Docker stats with formatted output
- **Interactive Menu**: Choice-based navigation
- **Auto-refresh**: 5-second intervals
- **Resource Limits**: Shows container memory limits

### 🍎 macOS Features
- **System Memory**: Uses `sysctl` and `vm_stat` for memory info
- **Memory Pressure**: Shows macOS memory pressure status
- **Container Stats**: Docker stats with colored output
- **Interactive Menu**: Bash-based navigation
- **Real-time Updates**: Live monitoring with colors

### 🐧 Linux Features
- **System Memory**: Uses `free -h` command
- **Container Stats**: Docker stats with formatted output
- **Interactive Menu**: Bash-based navigation
- **Resource Monitoring**: Detailed container resource usage

## 🎯 RAM Optimization Profiles

All platforms support 3 optimization profiles:

### 1. 🔥 LOW RAM (4GB machines)
```bash
# Only essential services
- Laravel PHP 8.4
- PostgreSQL  
- Redis
- Mailhog
# Total: ~1-2GB RAM
```

### 2. ⚡ OPTIMIZED (8GB machines)
```bash
# All services with memory limits
- All Laravel/WordPress apps
- All databases
- All admin tools
# Total: ~2-3GB RAM
```

### 3. 🚀 DEFAULT (16GB+ machines)
```bash
# Full configuration without limits
- All services
- No memory restrictions
# Total: ~4-6GB RAM
```

## 🔧 Customization

### Adding New Platforms
Edit the optimization scripts to add new Docker Compose profiles:

```bash
# In optimize-ram.sh or optimize-ram.bat
docker-compose -f docker-compose.yml -f docker-compose.your-profile.yml up -d
```

### Changing Memory Limits
Edit `docker-compose.override.yml` to adjust memory limits:

```yaml
services:
  your-service:
    deploy:
      resources:
        limits:
          memory: 256M
```

### Custom Monitoring
Add custom monitoring commands in the monitor scripts:

```bash
# Example: Add custom Docker command
docker inspect container_name --format "{{.State.Health.Status}}"
```

## 🐛 Troubleshooting

### Script Not Executable (macOS/Linux)
```bash
chmod +x scripts/*.sh
```

### Docker Not Found
```bash
# Check Docker installation
docker --version

# Start Docker Desktop
open -a Docker  # macOS
```

### Permission Denied (Windows)
```cmd
# Run PowerShell as Administrator
Set-ExecutionPolicy RemoteSigned
```

### Path Issues
```bash
# Make sure you're in the project root
cd /path/to/docker_master
ls docker-compose.yml  # Should exist
```

## 💡 Tips

1. **Use Universal Script**: `monitor-ram-universal.sh` works on all platforms
2. **Regular Monitoring**: Run monitor during development to catch memory leaks
3. **Profile Switching**: Switch between profiles based on current work
4. **Automation**: Add scripts to your IDE or terminal shortcuts

## 📚 Related Documentation

- [07-RAM-OPTIMIZATION.md](../docs/07-RAM-OPTIMIZATION.md) - Detailed RAM optimization guide
- [06-TROUBLESHOOTING.md](../docs/06-TROUBLESHOOTING.md) - General troubleshooting
- [05-SYSTEM-MANAGEMENT.md](../docs/05-SYSTEM-MANAGEMENT.md) - System management guide

## 🎯 Quick Commands

```bash
# Monitor RAM (any OS)
./scripts/monitor-ram-universal.sh

# Optimize for low RAM
./scripts/optimize-ram.sh  # or .bat on Windows
# Choose option 1

# Check current usage
docker stats --no-stream

# Switch to optimized profile
docker-compose -f docker-compose.yml -f docker-compose.override.yml up -d
```
