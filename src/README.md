# 🏗️ Docker Master - Source Code Architecture

## 📁 Cấu Trúc Thư Mục

```
src/
├── core/                     # Core business logic
│   ├── platform/             # Platform management
│   ├── database/             # Database operations
│   ├── docker/               # Docker operations
│   └── discovery/            # Auto-discovery logic
├── services/                 # Service layer
│   ├── platform-creator/     # Platform creation service
│   ├── auto-discovery/       # AI detection service
│   ├── monitoring/           # Monitoring service
│   └── nginx-manager/        # Nginx configuration service
├── utils/                    # Utility functions
│   ├── logger/               # Logging utilities
│   ├── validator/            # Validation utilities
│   └── file-manager/         # File operations
└── config/                   # Configuration management
    ├── environments/         # Environment configs
    ├── templates/            # Template configs
    └── defaults/             # Default configurations
```

## 🎯 Nguyên Tắc Thiết Kế

### Clean Architecture
- **Core**: Business logic không phụ thuộc vào framework
- **Services**: Orchestration layer cho các use cases
- **Utils**: Shared utilities và helpers
- **Config**: Configuration management tập trung

### Separation of Concerns
- Mỗi module có trách nhiệm rõ ràng
- Loose coupling giữa các components
- High cohesion trong từng module

### Maintainability
- Code dễ đọc và hiểu
- Easy to test và debug
- Scalable architecture

## 🔧 Module Descriptions

### Core Modules
- **platform/**: Platform lifecycle management
- **database/**: Database operations và migrations
- **docker/**: Docker container management
- **discovery/**: AI-powered platform detection

### Service Layer
- **platform-creator/**: Orchestrates platform creation
- **auto-discovery/**: Handles AI detection logic
- **monitoring/**: System monitoring và health checks
- **nginx-manager/**: Nginx configuration management

### Utilities
- **logger/**: Centralized logging system
- **validator/**: Input validation và sanitization
- **file-manager/**: File operations và templates

### Configuration
- **environments/**: Environment-specific configs
- **templates/**: Configuration templates
- **defaults/**: Default configuration values
