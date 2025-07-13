# 🤖 Docker Master Automation Scripts

## 📁 Cấu Trúc Automation

```
automation/
├── platform-management/     # Platform lifecycle automation
│   ├── create-platform.sh   # Platform creation (từ scripts/)
│   ├── start-platforms.sh   # Start multiple platforms
│   ├── stop-platforms.sh    # Stop multiple platforms
│   └── cleanup-platforms.sh # Platform cleanup
├── database-operations/     # Database automation
│   ├── create-databases.sh  # Database creation
│   ├── backup-databases.sh  # Database backup
│   ├── restore-databases.sh # Database restore
│   └── migrate-databases.sh # Database migrations
├── monitoring/              # System monitoring
│   ├── health-check.sh      # Health monitoring
│   ├── resource-monitor.sh  # Resource monitoring
│   ├── log-analyzer.sh      # Log analysis
│   └── alert-manager.sh     # Alert management
├── maintenance/             # System maintenance
│   ├── cleanup-docker.sh    # Docker cleanup
│   ├── optimize-system.sh   # System optimization
│   ├── update-images.sh     # Image updates
│   └── backup-system.sh     # System backup
└── shared/                  # Shared utilities
    ├── common.sh            # Common functions
    ├── config.sh            # Configuration helpers
    └── logging.sh           # Logging utilities
```

## 🎯 Migration từ Scripts Cũ

### Platform Management
```bash
# Old scripts/                    # New automation/platform-management/
scripts/create-platform.bat   →   automation/platform-management/create-platform.sh
scripts/start.bat              →   automation/platform-management/start-platforms.sh
scripts/stop.bat               →   automation/platform-management/stop-platforms.sh
scripts/cleanup.bat            →   automation/platform-management/cleanup-platforms.sh
```

### Database Operations
```bash
# Old scripts/                    # New automation/database-operations/
scripts/create-databases.bat  →   automation/database-operations/create-databases.sh
scripts/mysql-backup-restore.bat → automation/database-operations/backup-databases.sh
scripts/database.bat           →   automation/database-operations/migrate-databases.sh
```

### Monitoring
```bash
# Old scripts/                    # New automation/monitoring/
scripts/monitor-ram.bat        →   automation/monitoring/resource-monitor.sh
scripts/logs.bat               →   automation/monitoring/log-analyzer.sh
scripts/final-status.bat       →   automation/monitoring/health-check.sh
```

### Maintenance
```bash
# Old scripts/                    # New automation/maintenance/
scripts/cleanup.bat            →   automation/maintenance/cleanup-docker.sh
scripts/optimize-ram.bat       →   automation/maintenance/optimize-system.sh
scripts/nuclear-clean.bat      →   automation/maintenance/cleanup-docker.sh --force
```

## 🔧 Cải Tiến Chính

### 1. Modular Architecture
- Tách biệt các chức năng thành modules riêng biệt
- Shared utilities để tránh code duplication
- Consistent naming convention

### 2. Cross-Platform Support
- Shell scripts (.sh) thay vì batch files (.bat)
- Compatibility layer cho Windows/Linux/macOS
- Environment detection và adaptation

### 3. Enhanced Error Handling
- Proper exit codes
- Detailed error messages
- Rollback capabilities
- Logging integration

### 4. Configuration Management
- Environment-based configuration
- Centralized config files
- Runtime parameter validation

### 5. Improved Logging
- Structured logging với timestamps
- Multiple log levels (debug, info, warn, error)
- Log rotation và archiving
- Integration với monitoring systems

## 🚀 Sử Dụng

### Platform Management
```bash
# Tạo platform mới
automation/platform-management/create-platform.sh wordpress my-blog 8015

# Start tất cả platforms
automation/platform-management/start-platforms.sh

# Stop specific platform
automation/platform-management/stop-platforms.sh my-blog

# Cleanup unused platforms
automation/platform-management/cleanup-platforms.sh --dry-run
```

### Database Operations
```bash
# Tạo database cho platform
automation/database-operations/create-databases.sh my-blog

# Backup tất cả databases
automation/database-operations/backup-databases.sh

# Restore database từ backup
automation/database-operations/restore-databases.sh my-blog 2025-01-15

# Run migrations
automation/database-operations/migrate-databases.sh my-blog
```

### Monitoring
```bash
# Health check
automation/monitoring/health-check.sh

# Resource monitoring
automation/monitoring/resource-monitor.sh --interval 30

# Analyze logs
automation/monitoring/log-analyzer.sh --platform my-blog --last 1h

# Setup alerts
automation/monitoring/alert-manager.sh --setup
```

### Maintenance
```bash
# Docker cleanup
automation/maintenance/cleanup-docker.sh

# System optimization
automation/maintenance/optimize-system.sh

# Update all images
automation/maintenance/update-images.sh

# Full system backup
automation/maintenance/backup-system.sh
```

## 🔄 Backward Compatibility

### Wrapper Scripts
- Các batch files cũ sẽ được giữ lại như wrapper
- Redirect calls đến automation scripts mới
- Gradual migration path cho users

### Example Wrapper (bin/create.bat)
```batch
@echo off
REM Legacy wrapper for create.bat
echo [DEPRECATED] Using legacy create.bat, consider using: node cli/create.js %*
call automation\platform-management\create-platform.sh %*
```

## 📊 Benefits

### 1. Maintainability
- Easier to understand và modify
- Consistent code structure
- Better documentation

### 2. Reliability
- Improved error handling
- Better testing capabilities
- Rollback mechanisms

### 3. Scalability
- Modular design cho easy extension
- Plugin architecture
- Configuration-driven behavior

### 4. Monitoring
- Better observability
- Performance metrics
- Health monitoring

### 5. Cross-Platform
- Works on Windows, Linux, macOS
- Container-friendly
- CI/CD integration ready
