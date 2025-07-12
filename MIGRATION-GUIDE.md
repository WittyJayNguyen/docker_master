# 🔄 Docker Master Migration Guide

> **Hướng dẫn migration từ cấu trúc cũ sang cấu trúc mới tối ưu**

## 📋 Tổng Quan Migration

### Mục Tiêu Migration
- **Tối ưu hóa cấu trúc** code và configuration
- **Cải thiện maintainability** và scalability
- **Giữ nguyên functionality** hiện tại
- **Backward compatibility** cho existing workflows

### Cấu Trúc Trước và Sau

#### Trước Migration
```
docker_master/
├── bin/                     # Batch scripts
├── scripts/                 # Automation scripts (mixed)
├── docs/                    # Flat documentation
├── docker/                  # Docker images (mixed)
├── config/                  # Limited configuration
├── platforms/               # ✅ Giữ nguyên
├── nginx/                   # ✅ Giữ nguyên
├── projects/                # ✅ Giữ nguyên
└── tools/                   # Basic tools
```

#### Sau Migration
```
docker_master/
├── src/                     # 🆕 Core source code
├── cli/                     # 🆕 Modern CLI tools
├── automation/              # 🆕 Organized automation
├── config/                  # 🔄 Enhanced configuration
├── docker/                  # 🔄 Optimized structure
├── docs/                    # 🔄 Structured documentation
├── tools/                   # 🔄 Professional tools
├── platforms/               # ✅ Giữ nguyên
├── nginx/                   # ✅ Giữ nguyên
└── projects/                # ✅ Giữ nguyên
```

## 🚀 Migration Steps

### Phase 1: Backup và Preparation

#### 1.1 Backup Existing System
```bash
# Tạo backup complete system
cp -r docker_master docker_master_backup_$(date +%Y%m%d)

# Backup databases
automation/backup/database-backup.js --all --compress

# Export current configurations
node tools/migration/config-exporter.js --output config_backup.json
```

#### 1.2 Verify Current State
```bash
# Check running platforms
docker ps --filter "name=_php"

# List current projects
ls -la projects/

# Verify database connections
automation/monitoring/health-check.sh
```

### Phase 2: Install New Structure

#### 2.1 Create New Directories
```bash
# Create new directory structure
mkdir -p src/{core,services,utils,config}
mkdir -p cli/{commands,templates}
mkdir -p automation/{platform-management,database-operations,monitoring,maintenance,shared}
mkdir -p config/{docker-compose,nginx,environments,database,platform-templates}
mkdir -p tools/{monitoring,backup,migration,development,security,maintenance}
mkdir -p docs/{getting-started,user-guide,advanced,api,development,migration,examples}
```

#### 2.2 Install Dependencies
```bash
# Install Node.js dependencies for new CLI
npm install commander chalk inquirer ora

# Install additional tools
npm install node-cron pg mysql2 redis ioredis
```

### Phase 3: Migrate Core Components

#### 3.1 Migrate Configuration
```bash
# Run configuration migrator
node tools/migration/config-migrator.js \
  --source docker-compose.low-ram.yml \
  --target config/docker-compose/base.yml

# Migrate environment settings
node tools/migration/env-migrator.js \
  --source .env \
  --target config/environments/
```

#### 3.2 Migrate Scripts
```bash
# Migrate automation scripts
node tools/migration/script-migrator.js \
  --source scripts/ \
  --target automation/

# Update script references
node tools/migration/reference-updater.js \
  --update-batch-files \
  --update-documentation
```

#### 3.3 Migrate Docker Configuration
```bash
# Migrate Docker images
node tools/migration/docker-migrator.js \
  --source docker/ \
  --target docker/ \
  --restructure

# Update Dockerfiles
node tools/migration/dockerfile-updater.js \
  --optimize \
  --add-health-checks
```

### Phase 4: Update Existing Platforms

#### 4.1 Platform Configuration Update
```bash
# Update existing platforms to use new structure
for platform in $(ls projects/); do
  node tools/migration/platform-migrator.js \
    --platform $platform \
    --update-config \
    --preserve-data
done
```

#### 4.2 Database Migration
```bash
# Migrate database configurations
node tools/migration/database-migrator.js \
  --update-connections \
  --optimize-settings \
  --preserve-data
```

### Phase 5: Documentation Migration

#### 5.1 Restructure Documentation
```bash
# Migrate existing docs to new structure
node tools/migration/docs-migrator.js \
  --source docs/ \
  --target docs/ \
  --restructure \
  --update-links
```

#### 5.2 Generate New Documentation
```bash
# Generate API documentation
node tools/development/docs-generator.js \
  --source src/ \
  --output docs/api/

# Generate CLI documentation
node cli/docker-master.js --generate-docs > docs/api/cli-reference.md
```

## 🔧 Migration Tools

### Configuration Migrator
```javascript
// tools/migration/config-migrator.js
class ConfigMigrator {
    async migrateDockerCompose(sourcePath, targetPath) {
        const sourceConfig = await this.loadYaml(sourcePath);
        const migratedConfig = this.transformConfig(sourceConfig);
        
        // Split into base and environment-specific configs
        const baseConfig = this.extractBaseConfig(migratedConfig);
        const devConfig = this.extractDevConfig(migratedConfig);
        const prodConfig = this.extractProdConfig(migratedConfig);
        
        await this.saveYaml(path.join(targetPath, 'base.yml'), baseConfig);
        await this.saveYaml(path.join(targetPath, 'development.yml'), devConfig);
        await this.saveYaml(path.join(targetPath, 'production.yml'), prodConfig);
        
        this.logger.info('Docker Compose configuration migrated successfully');
    }
    
    transformConfig(config) {
        // Transform old structure to new optimized structure
        const transformed = { ...config };
        
        // Update service definitions
        for (const [serviceName, service] of Object.entries(transformed.services)) {
            service.deploy = this.addResourceLimits(service);
            service.healthcheck = this.addHealthCheck(serviceName, service);
            service.networks = [this.getNetworkName()];
        }
        
        return transformed;
    }
}
```

### Script Migrator
```javascript
// tools/migration/script-migrator.js
class ScriptMigrator {
    async migrateScripts(sourceDir, targetDir) {
        const scripts = await this.findScripts(sourceDir);
        const migrationMap = this.createMigrationMap();
        
        for (const script of scripts) {
            const targetLocation = this.getTargetLocation(script, migrationMap);
            const migratedContent = await this.migrateScript(script);
            
            await this.writeScript(targetLocation, migratedContent);
            await this.createWrapper(script, targetLocation);
        }
        
        this.logger.info(`Migrated ${scripts.length} scripts successfully`);
    }
    
    async migrateScript(scriptPath) {
        const content = await fs.readFile(scriptPath, 'utf8');
        
        // Convert batch to shell script
        if (scriptPath.endsWith('.bat')) {
            return this.convertBatchToShell(content);
        }
        
        // Update shell script with new functions
        if (scriptPath.endsWith('.sh')) {
            return this.updateShellScript(content);
        }
        
        return content;
    }
    
    createMigrationMap() {
        return {
            'scripts/create-platform.bat': 'automation/platform-management/create-platform.sh',
            'scripts/start.bat': 'automation/platform-management/start-platforms.sh',
            'scripts/stop.bat': 'automation/platform-management/stop-platforms.sh',
            'scripts/monitor-ram.bat': 'automation/monitoring/resource-monitor.sh',
            'scripts/cleanup.bat': 'automation/maintenance/cleanup-docker.sh',
            // ... more mappings
        };
    }
}
```

## ⚠️ Important Considerations

### Backward Compatibility

#### Wrapper Scripts
Tạo wrapper scripts để maintain compatibility:

```bash
# bin/create.bat (wrapper)
@echo off
echo [DEPRECATED] Using legacy create.bat
echo [INFO] Consider using: node cli/create.js %*
echo.
call automation\platform-management\create-platform.sh %*
```

#### Environment Variables
Maintain existing environment variables:

```bash
# config/environments/legacy.env
# Legacy environment variables for backward compatibility
DOCKER_COMPOSE_FILE=docker-compose.low-ram.yml
POSTGRES_HOST=postgres_low_ram
MYSQL_HOST=mysql_low_ram
REDIS_HOST=redis_low_ram
```

### Data Preservation

#### Platform Data
```bash
# Ensure no data loss during migration
- projects/ directory remains unchanged
- Database data preserved
- Nginx configurations maintained
- SSL certificates preserved
```

#### Configuration Backup
```bash
# Backup all configurations before migration
cp docker-compose.low-ram.yml docker-compose.low-ram.yml.backup
cp -r nginx/ nginx_backup/
cp -r config/ config_backup/
```

## ✅ Verification Steps

### Post-Migration Verification

#### 1. System Health Check
```bash
# Verify all services are running
node cli/monitor.js status

# Check platform functionality
for platform in $(ls projects/); do
  curl -f http://localhost:$(node tools/platform-info.js $platform --port) || echo "❌ $platform failed"
done
```

#### 2. Feature Verification
```bash
# Test platform creation
node cli/create.js test-migration-platform --type laravel84

# Test database connections
node tools/monitoring/health-checker.js --databases

# Test monitoring
node tools/monitoring/resource-monitor.js --once
```

#### 3. Performance Comparison
```bash
# Compare performance before/after
node tools/monitoring/performance-profiler.js --compare-with-baseline

# Check resource usage
docker stats --no-stream
```

## 🔄 Rollback Plan

### Emergency Rollback
```bash
# Stop new system
docker-compose -f config/docker-compose/base.yml down

# Restore backup
rm -rf docker_master
mv docker_master_backup_$(date +%Y%m%d) docker_master
cd docker_master

# Start old system
docker-compose -f docker-compose.low-ram.yml up -d
```

### Selective Rollback
```bash
# Rollback specific components
node tools/migration/rollback-manager.js \
  --component configuration \
  --to-backup config_backup/

# Rollback scripts only
node tools/migration/rollback-manager.js \
  --component scripts \
  --preserve-data
```

## 📈 Benefits After Migration

### 1. Improved Maintainability
- **Modular architecture** dễ maintain và extend
- **Clear separation** of concerns
- **Consistent coding standards** across codebase

### 2. Enhanced Performance
- **Optimized Docker images** với smaller size
- **Better resource management** với proper limits
- **Improved caching** strategies

### 3. Better Developer Experience
- **Modern CLI tools** với rich features
- **Comprehensive documentation** với clear navigation
- **Professional error handling** và debugging

### 4. Operational Excellence
- **Automated monitoring** và alerting
- **Comprehensive backup** strategies
- **Security scanning** và compliance

## 🎯 Next Steps After Migration

### 1. Team Training
- **CLI usage** training sessions
- **New documentation** walkthrough
- **Best practices** guidelines

### 2. Continuous Improvement
- **Performance monitoring** setup
- **Security scanning** automation
- **Regular updates** và maintenance

### 3. Advanced Features
- **Multi-environment** deployment
- **CI/CD integration** setup
- **Advanced monitoring** và alerting

---

**🎉 Migration Complete!**

Your Docker Master platform is now running on the optimized architecture. Enjoy the improved performance, maintainability, and developer experience!
