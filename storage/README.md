# Runtime Directory

This directory contains all runtime data and temporary files generated during platform operation.

## Directory Structure

```
runtime/
├── 📁 projects/              # Active project files
├── 📁 logs/                  # Application and system logs
├── 📁 data/                  # Persistent data and uploads
└── 📁 backups/               # Backup files
```

## Contents

### 📂 Projects (`runtime/projects/`)
Contains the actual project files for each platform:
- Laravel applications
- WordPress installations  
- Custom PHP projects
- Static websites

### 📋 Logs (`runtime/logs/`)
Contains log files organized by service:
- **apache/** - Apache web server logs
- **mysql/** - MySQL database logs
- **postgresql/** - PostgreSQL database logs
- **php/** - PHP application logs
- **redis/** - Redis cache logs

### 💾 Data (`runtime/data/`)
Contains persistent data:
- **uploads/** - File uploads from applications
- **cache/** - Application cache files
- **sessions/** - Session data
- **temp/** - Temporary files

### 🔄 Backups (`runtime/backups/`)
Contains backup files:
- Database dumps
- Project backups
- Configuration backups
- System snapshots

## Important Notes

⚠️ **Warning**: This directory contains runtime data that should not be committed to version control.

✅ **Safe to delete**: 
- Log files (will be regenerated)
- Cache files
- Temporary files

❌ **Do not delete**:
- Project files in `projects/`
- Database data
- User uploads in `data/uploads/`
- Important backups

## Maintenance

### Cleanup Commands
```bash
# Clean old logs (older than 7 days)
scripts/cleanup.bat

# Clear cache files
scripts/clear-cache.bat

# Create backup
scripts/backup.bat
```

### Monitoring
- Log files are automatically rotated
- Disk usage is monitored
- Backups are created automatically
