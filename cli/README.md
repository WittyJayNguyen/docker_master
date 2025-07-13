# 🖥️ Docker Master CLI Tools

## 📁 Cấu Trúc CLI

```
cli/
├── commands/                 # Command implementations
│   ├── create/              # Platform creation commands
│   ├── manage/              # Platform management commands
│   ├── monitor/             # Monitoring commands
│   └── utils/               # Utility commands
├── create.js                # Main create command (thay thế create.bat)
├── manage.js                # Platform management CLI
├── monitor.js               # Monitoring CLI
└── docker-master.js         # Main CLI entry point
```

## 🚀 Sử Dụng

### Tạo Platform Mới
```bash
# Tạo platform với auto-discovery
node cli/create.js my-shop

# Tạo platform với type cụ thể
node cli/create.js my-blog --type wordpress --port 8020

# Xem các option có sẵn
node cli/create.js --help
```

### Quản Lý Platform
```bash
# Liệt kê tất cả platforms
node cli/manage.js list

# Start platform
node cli/manage.js start my-shop

# Stop platform
node cli/manage.js stop my-shop

# Xóa platform
node cli/manage.js delete my-shop

# Xem logs
node cli/manage.js logs my-shop
```

### Monitoring
```bash
# Xem trạng thái hệ thống
node cli/monitor.js status

# Xem resource usage
node cli/monitor.js resources

# Xem health check
node cli/monitor.js health

# Start monitoring daemon
node cli/monitor.js start-daemon
```

## 🔧 CLI Features

### Auto-Discovery
- Phát hiện tự động loại platform từ tên project
- Gợi ý cấu hình tối ưu
- Hiển thị alternatives và confidence score

### Interactive Mode
- Wizard-style platform creation
- Step-by-step configuration
- Validation và preview trước khi tạo

### Batch Operations
- Tạo nhiều platforms cùng lúc
- Bulk start/stop/delete operations
- Import/export platform configurations

### Rich Output
- Colored output với icons
- Progress bars cho long-running operations
- Structured tables cho data display
- JSON output option cho scripting

## 🎯 Migration từ Batch Scripts

### Mapping Commands
```bash
# Old (batch)              # New (Node.js CLI)
create.bat my-shop         → node cli/create.js my-shop
scripts\start.bat          → node cli/manage.js start-all
scripts\stop.bat           → node cli/manage.js stop-all
scripts\logs.bat           → node cli/manage.js logs
scripts\status.bat         → node cli/monitor.js status
```

### Backward Compatibility
- Batch scripts sẽ được giữ lại và redirect đến CLI mới
- Tất cả existing workflows sẽ tiếp tục hoạt động
- Gradual migration path cho users

## 🏗️ Architecture

### Command Pattern
- Mỗi command là một class riêng biệt
- Shared base class cho common functionality
- Plugin architecture cho custom commands

### Configuration
- Sử dụng ConfigManager từ src/config
- Environment-aware configuration
- User preferences và defaults

### Error Handling
- Structured error messages
- Exit codes cho scripting
- Rollback capabilities cho failed operations

### Logging
- Integrated với Logger từ src/utils
- Multiple output formats
- Debug mode cho troubleshooting
