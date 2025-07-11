# Configuration Management

This directory contains all configuration files for Docker Master Platform.

## Directory Structure

```
src/config/
├── environments/          # Environment-specific configurations
│   ├── docker-compose.low-ram.yml
│   └── docker-compose.monitoring.yml
├── templates/            # Configuration templates
│   └── platform-template.yml
└── defaults/             # Default configurations
    └── docker-defaults.yml
```

## Usage

### Environment Configurations
- `environments/` contains Docker Compose files for different environments
- Use `docker-compose.low-ram.yml` for development with memory optimization
- Use `docker-compose.monitoring.yml` for production with monitoring

### Templates
- `templates/platform-template.yml` is used by platform creation scripts
- Variables in `{{VARIABLE_NAME}}` format are replaced during platform creation

### Defaults
- `defaults/docker-defaults.yml` contains default settings for all services
- These settings are inherited by all platforms unless overridden

## Configuration Variables

### Platform Template Variables
- `{{PLATFORM_NAME}}` - Name of the platform
- `{{PHP_VERSION}}` - PHP version (74 or 84)
- `{{PLATFORM_PORT}}` - HTTP port for the platform
- `{{XDEBUG_PORT}}` - Xdebug port for debugging
- `{{DB_HOST}}` - Database host
- `{{DB_PORT}}` - Database port
- `{{DB_USERNAME}}` - Database username
- `{{DB_PASSWORD}}` - Database password
- `{{PLATFORM_TYPE}}` - Platform type (wordpress, laravel, etc.)

## Best Practices

1. Always use templates for creating new platforms
2. Keep environment-specific settings in `environments/`
3. Use defaults for common configurations
4. Document any custom variables in this README
