# ⚙️ Docker Master Configuration Management

## 📁 Cấu Trúc Configuration Mới

```
config/
├── docker-compose/          # Docker Compose configurations
│   ├── base.yml             # Base compose configuration
│   ├── development.yml      # Development overrides
│   ├── production.yml       # Production overrides
│   ├── monitoring.yml       # Monitoring stack
│   └── platforms/           # Platform-specific configs
│       ├── wordpress.yml    # WordPress platform config
│       ├── laravel74.yml    # Laravel 7.4 config
│       ├── laravel84.yml    # Laravel 8.4 config
│       └── ecommerce.yml    # E-commerce config
├── nginx/                   # Nginx configurations
│   ├── templates/           # Nginx config templates
│   │   ├── default.conf.tpl # Default virtual host template
│   │   ├── ssl.conf.tpl     # SSL configuration template
│   │   └── proxy.conf.tpl   # Reverse proxy template
│   ├── sites-available/     # Available site configurations
│   └── sites-enabled/       # Enabled site configurations
├── environments/            # Environment-specific configs
│   ├── development.env      # Development environment
│   ├── production.env       # Production environment
│   ├── testing.env          # Testing environment
│   └── local.env.example    # Local environment template
├── database/                # Database configurations
│   ├── postgres/            # PostgreSQL configs
│   │   ├── postgresql.conf  # Main PostgreSQL config
│   │   ├── pg_hba.conf      # Authentication config
│   │   └── init/            # Initialization scripts
│   ├── mysql/               # MySQL configs
│   │   ├── my.cnf           # MySQL configuration
│   │   └── init/            # Initialization scripts
│   └── redis/               # Redis configurations
│       └── redis.conf       # Redis configuration
└── platform-templates/     # Platform configuration templates
    ├── wordpress/           # WordPress platform template
    ├── laravel74/           # Laravel 7.4 template
    ├── laravel84/           # Laravel 8.4 template
    └── ecommerce/           # E-commerce template
```

## 🎯 Configuration Management Strategy

### 1. Environment-Based Configuration
- **Development** - Debug enabled, verbose logging, hot reload
- **Production** - Optimized performance, security hardened, minimal logging
- **Testing** - Isolated environment, test databases, mock services
- **Local** - User-specific overrides, custom ports, development tools

### 2. Hierarchical Configuration
```
Base Configuration (defaults)
    ↓
Environment Configuration (dev/prod/test)
    ↓
Platform Configuration (wordpress/laravel/etc)
    ↓
Local Configuration (user overrides)
```

### 3. Template-Based Generation
- **Dynamic configuration** generation based on platform type
- **Variable substitution** for environment-specific values
- **Validation** before applying configurations
- **Rollback** capabilities for failed configurations

## 🔧 Configuration Files

### Environment Configuration

#### Development Environment
```bash
# config/environments/development.env

# Core settings
NODE_ENV=development
DEBUG=true
LOG_LEVEL=debug

# Docker settings
COMPOSE_PROJECT_NAME=docker_master_dev
COMPOSE_FILE=config/docker-compose/base.yml:config/docker-compose/development.yml

# Database settings
POSTGRES_HOST=postgres_dev
POSTGRES_PORT=5432
POSTGRES_DB=docker_master_dev
POSTGRES_USER=dev_user
POSTGRES_PASSWORD=dev_password

MYSQL_HOST=mysql_dev
MYSQL_PORT=3306
MYSQL_DATABASE=docker_master_dev
MYSQL_USER=dev_user
MYSQL_PASSWORD=dev_password

REDIS_HOST=redis_dev
REDIS_PORT=6379

# Platform settings
DEFAULT_PHP_VERSION=84
DEFAULT_DATABASE=postgres
DEFAULT_PORT_START=8015
DEFAULT_PORT_END=8100

# Development features
HOT_RELOAD=true
AUTO_RESTART=true
XDEBUG_ENABLED=true
PROFILING_ENABLED=false

# Resource limits (development)
PHP_MEMORY_LIMIT=256M
MYSQL_MEMORY_LIMIT=512M
POSTGRES_MEMORY_LIMIT=512M
REDIS_MEMORY_LIMIT=128M
```

#### Production Environment
```bash
# config/environments/production.env

# Core settings
NODE_ENV=production
DEBUG=false
LOG_LEVEL=warn

# Docker settings
COMPOSE_PROJECT_NAME=docker_master_prod
COMPOSE_FILE=config/docker-compose/base.yml:config/docker-compose/production.yml

# Database settings (use secrets in production)
POSTGRES_HOST=postgres_prod
POSTGRES_PORT=5432
POSTGRES_DB=docker_master_prod
POSTGRES_USER_FILE=/run/secrets/postgres_user
POSTGRES_PASSWORD_FILE=/run/secrets/postgres_password

MYSQL_HOST=mysql_prod
MYSQL_PORT=3306
MYSQL_DATABASE=docker_master_prod
MYSQL_USER_FILE=/run/secrets/mysql_user
MYSQL_PASSWORD_FILE=/run/secrets/mysql_password

REDIS_HOST=redis_prod
REDIS_PORT=6379

# Platform settings
DEFAULT_PHP_VERSION=84
DEFAULT_DATABASE=postgres
DEFAULT_PORT_START=8015
DEFAULT_PORT_END=8100

# Production features
HOT_RELOAD=false
AUTO_RESTART=false
XDEBUG_ENABLED=false
PROFILING_ENABLED=false

# Security settings
SSL_ENABLED=true
FORCE_HTTPS=true
SECURITY_HEADERS=true

# Resource limits (production)
PHP_MEMORY_LIMIT=128M
MYSQL_MEMORY_LIMIT=1G
POSTGRES_MEMORY_LIMIT=1G
REDIS_MEMORY_LIMIT=256M

# Monitoring
MONITORING_ENABLED=true
METRICS_ENABLED=true
ALERTING_ENABLED=true
```

### Docker Compose Configuration

#### Base Configuration
```yaml
# config/docker-compose/base.yml
version: '3.8'

services:
  postgres:
    image: postgres:15-alpine
    container_name: ${POSTGRES_HOST:-postgres_low_ram}
    restart: unless-stopped
    environment:
      POSTGRES_DB: ${POSTGRES_DB:-docker_master}
      POSTGRES_USER: ${POSTGRES_USER:-postgres_user}
      POSTGRES_PASSWORD: ${POSTGRES_PASSWORD:-postgres_pass}
    volumes:
      - postgres_data:/var/lib/postgresql/data
      - ./config/database/postgres/postgresql.conf:/etc/postgresql/postgresql.conf
      - ./config/database/postgres/init:/docker-entrypoint-initdb.d
    networks:
      - docker_master_network

  mysql:
    image: mysql:8.0
    container_name: ${MYSQL_HOST:-mysql_low_ram}
    restart: unless-stopped
    environment:
      MYSQL_DATABASE: ${MYSQL_DATABASE:-docker_master}
      MYSQL_USER: ${MYSQL_USER:-mysql_user}
      MYSQL_PASSWORD: ${MYSQL_PASSWORD:-mysql_pass}
      MYSQL_ROOT_PASSWORD: ${MYSQL_ROOT_PASSWORD:-root_password}
    volumes:
      - mysql_data:/var/lib/mysql
      - ./config/database/mysql/my.cnf:/etc/mysql/conf.d/custom.cnf
      - ./config/database/mysql/init:/docker-entrypoint-initdb.d
    networks:
      - docker_master_network

  redis:
    image: redis:7-alpine
    container_name: ${REDIS_HOST:-redis_low_ram}
    restart: unless-stopped
    volumes:
      - redis_data:/data
      - ./config/database/redis/redis.conf:/usr/local/etc/redis/redis.conf
    command: redis-server /usr/local/etc/redis/redis.conf
    networks:
      - docker_master_network

networks:
  docker_master_network:
    driver: bridge
    name: ${COMPOSE_PROJECT_NAME:-docker_master}_network

volumes:
  postgres_data:
    driver: local
  mysql_data:
    driver: local
  redis_data:
    driver: local
```

#### Development Overrides
```yaml
# config/docker-compose/development.yml
version: '3.8'

services:
  postgres:
    ports:
      - "${POSTGRES_PORT:-5432}:5432"
    environment:
      POSTGRES_LOG_STATEMENT: all
      POSTGRES_LOG_MIN_DURATION_STATEMENT: 0
    volumes:
      - ./logs/postgres:/var/log/postgresql

  mysql:
    ports:
      - "${MYSQL_PORT:-3306}:3306"
    environment:
      MYSQL_GENERAL_LOG: 1
      MYSQL_GENERAL_LOG_FILE: /var/log/mysql/general.log
    volumes:
      - ./logs/mysql:/var/log/mysql

  redis:
    ports:
      - "${REDIS_PORT:-6379}:6379"
    command: >
      redis-server /usr/local/etc/redis/redis.conf
      --loglevel debug
      --logfile /var/log/redis/redis.log
    volumes:
      - ./logs/redis:/var/log/redis

  # Development tools
  phpmyadmin:
    image: phpmyadmin/phpmyadmin
    container_name: phpmyadmin_dev
    restart: unless-stopped
    ports:
      - "8080:80"
    environment:
      PMA_HOST: mysql
      PMA_USER: ${MYSQL_USER:-mysql_user}
      PMA_PASSWORD: ${MYSQL_PASSWORD:-mysql_pass}
    networks:
      - docker_master_network

  pgadmin:
    image: dpage/pgadmin4
    container_name: pgadmin_dev
    restart: unless-stopped
    ports:
      - "8081:80"
    environment:
      PGADMIN_DEFAULT_EMAIL: admin@docker-master.local
      PGADMIN_DEFAULT_PASSWORD: admin
    volumes:
      - pgadmin_data:/var/lib/pgadmin
    networks:
      - docker_master_network

  mailhog:
    image: mailhog/mailhog
    container_name: mailhog_dev
    restart: unless-stopped
    ports:
      - "8025:8025"
      - "1025:1025"
    networks:
      - docker_master_network

volumes:
  pgadmin_data:
    driver: local
```

## 🔄 Configuration Management Tools

### Configuration Validator
```javascript
// src/config/ConfigValidator.js
class ConfigValidator {
    validateEnvironment(env) {
        const required = [
            'NODE_ENV',
            'POSTGRES_HOST',
            'MYSQL_HOST',
            'REDIS_HOST'
        ];
        
        for (const key of required) {
            if (!env[key]) {
                throw new Error(`Missing required environment variable: ${key}`);
            }
        }
    }
    
    validatePorts(config) {
        const ports = [
            config.POSTGRES_PORT,
            config.MYSQL_PORT,
            config.REDIS_PORT
        ];
        
        // Check for port conflicts
        const duplicates = ports.filter((port, index) => ports.indexOf(port) !== index);
        if (duplicates.length > 0) {
            throw new Error(`Port conflicts detected: ${duplicates.join(', ')}`);
        }
    }
}
```

### Template Engine
```javascript
// src/config/TemplateEngine.js
class TemplateEngine {
    generateDockerCompose(platformConfig) {
        const template = this.loadTemplate('docker-compose/platform.yml');
        return this.substituteVariables(template, platformConfig);
    }
    
    generateNginxConfig(platformConfig) {
        const template = this.loadTemplate('nginx/default.conf.tpl');
        return this.substituteVariables(template, platformConfig);
    }
    
    substituteVariables(template, variables) {
        return template.replace(/\{\{(\w+)\}\}/g, (match, key) => {
            return variables[key] || match;
        });
    }
}
```

## 📊 Benefits của Configuration Management

### 1. Consistency
- **Standardized configurations** across environments
- **Version controlled** configuration changes
- **Reproducible deployments** với same configs

### 2. Flexibility
- **Environment-specific** optimizations
- **Easy customization** cho different use cases
- **Template-based** generation cho new platforms

### 3. Maintainability
- **Centralized configuration** management
- **Clear separation** of concerns
- **Easy troubleshooting** với structured configs

### 4. Security
- **Secrets management** với environment variables
- **Secure defaults** cho production
- **Configuration validation** trước khi apply

## 🚀 Usage Examples

### Load Configuration
```javascript
const ConfigManager = require('../src/config/ConfigManager');

// Load configuration for current environment
const config = new ConfigManager(process.env.NODE_ENV);
await config.load();

// Get database configuration
const dbConfig = config.getDatabaseConfig('postgres');
console.log(dbConfig);
```

### Generate Platform Configuration
```javascript
const TemplateEngine = require('../src/config/TemplateEngine');

const templateEngine = new TemplateEngine();
const platformConfig = {
    PLATFORM_NAME: 'my-shop',
    PLATFORM_PORT: 8015,
    PHP_VERSION: '84',
    DB_HOST: 'postgres_low_ram'
};

const dockerCompose = templateEngine.generateDockerCompose(platformConfig);
const nginxConfig = templateEngine.generateNginxConfig(platformConfig);
```

### Validate Configuration
```javascript
const ConfigValidator = require('../src/config/ConfigValidator');

const validator = new ConfigValidator();
try {
    validator.validateEnvironment(process.env);
    validator.validatePorts(config.getAll());
    console.log('✅ Configuration is valid');
} catch (error) {
    console.error('❌ Configuration error:', error.message);
}
```
