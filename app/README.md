# Docker Master Platform - Application Code

This directory contains the core application code and infrastructure for Docker Master Platform.

## Architecture Overview

Docker Master Platform follows **Clean Architecture** and **Domain-Driven Design** principles:

```
app/
├── 📁 services/               # Business services
├── 📁 infrastructure/         # Infrastructure layer
├── 📁 platforms/              # Platform management
├── 📁 scripts/                # Automation scripts
└── 📁 config/                 # Configuration management
```

## Core Components

### 🏗️ Services (`app/services/`)
Contains the core business services and domain logic:
- **platform/** - Platform management services
- **docker/** - Docker orchestration services
- **database/** - Database management services

### 🔧 Infrastructure (`app/infrastructure/`)
Contains infrastructure-related configurations:
- **docker/** - Docker container definitions
- **nginx/** - Web server configurations
- **monitoring/** - Monitoring and logging tools

### 🚀 Platforms (`app/platforms/`)
Contains platform definitions and instances:
- **templates/** - Platform templates for different types
- **instances/** - Active platform configurations

### 📜 Scripts (`app/scripts/`)
Contains automation scripts organized by function:
- **platform/** - Platform creation and management
- **docker/** - Docker operations and optimization
- **database/** - Database operations and maintenance
- **monitoring/** - System monitoring and health checks

### ⚙️ Config (`app/config/`)
Contains configuration management:
- **environments/** - Environment-specific configurations
- **templates/** - Configuration templates
- **defaults/** - Default settings and values

## Development Guidelines

### Adding New Features
1. Place core business logic in `app/services/`
2. Infrastructure code goes in `app/infrastructure/`
3. Scripts should be categorized by function in `app/scripts/`
4. Use templates in `app/config/templates/` for consistency

### Best Practices
- Follow the established directory structure
- Keep configurations centralized in `src/config/`
- Use meaningful names for scripts and organize by function
- Document any new components in their respective README files

## Quick Start

```bash
# View current structure
tree src/

# Run platform creation
bin/create.bat my-platform

# Check system status  
bin/status.bat
```
