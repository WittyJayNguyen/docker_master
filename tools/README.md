# 🛠️ Docker Master Tools & Utilities

## 📁 Cấu Trúc Tools Mới

```
tools/
├── monitoring/              # Monitoring và health check tools
│   ├── health-checker.js    # Comprehensive health checking
│   ├── resource-monitor.js  # System resource monitoring
│   ├── log-analyzer.js      # Log analysis và parsing
│   ├── performance-profiler.js # Performance profiling
│   └── alert-manager.js     # Alert management system
├── backup/                  # Backup và restore utilities
│   ├── database-backup.js   # Database backup automation
│   ├── file-backup.js       # File system backup
│   ├── restore-manager.js   # Restore operations
│   └── backup-scheduler.js  # Scheduled backup management
├── migration/               # Migration và upgrade tools
│   ├── version-migrator.js  # Version migration scripts
│   ├── config-migrator.js   # Configuration migration
│   ├── data-migrator.js     # Data migration utilities
│   └── platform-migrator.js # Platform migration tools
├── development/             # Development utilities
│   ├── code-generator.js    # Code generation tools
│   ├── template-manager.js  # Template management
│   ├── test-runner.js       # Test execution utilities
│   └── dev-server.js        # Development server tools
├── security/                # Security tools
│   ├── vulnerability-scanner.js # Security scanning
│   ├── ssl-manager.js       # SSL certificate management
│   ├── access-control.js    # Access control utilities
│   └── audit-logger.js      # Security audit logging
└── maintenance/             # System maintenance tools
    ├── cleanup-manager.js   # System cleanup utilities
    ├── update-manager.js    # Update management
    ├── optimization-tool.js # Performance optimization
    └── diagnostic-tool.js   # System diagnostics
```

## 🎯 Tool Categories

### 1. Monitoring Tools
**Mục đích**: Theo dõi và giám sát hệ thống real-time

#### Health Checker
```javascript
// tools/monitoring/health-checker.js
class HealthChecker {
    async checkSystemHealth() {
        const results = {
            docker: await this.checkDockerHealth(),
            databases: await this.checkDatabaseHealth(),
            platforms: await this.checkPlatformHealth(),
            resources: await this.checkResourceHealth(),
            network: await this.checkNetworkHealth()
        };
        
        return {
            status: this.calculateOverallStatus(results),
            timestamp: new Date().toISOString(),
            details: results
        };
    }
    
    async checkDockerHealth() {
        // Check Docker daemon, containers, images
        return {
            daemon: await this.isDockerRunning(),
            containers: await this.getContainerStatus(),
            images: await this.getImageStatus(),
            volumes: await this.getVolumeStatus(),
            networks: await this.getNetworkStatus()
        };
    }
    
    async checkDatabaseHealth() {
        // Check database connections and performance
        return {
            postgres: await this.checkPostgresHealth(),
            mysql: await this.checkMysqlHealth(),
            redis: await this.checkRedisHealth()
        };
    }
}
```

#### Resource Monitor
```javascript
// tools/monitoring/resource-monitor.js
class ResourceMonitor {
    async getSystemMetrics() {
        return {
            cpu: await this.getCpuUsage(),
            memory: await this.getMemoryUsage(),
            disk: await this.getDiskUsage(),
            network: await this.getNetworkUsage(),
            docker: await this.getDockerMetrics()
        };
    }
    
    async startMonitoring(interval = 30000) {
        setInterval(async () => {
            const metrics = await this.getSystemMetrics();
            await this.logMetrics(metrics);
            await this.checkThresholds(metrics);
        }, interval);
    }
    
    async checkThresholds(metrics) {
        const alerts = [];
        
        if (metrics.memory.usage > 80) {
            alerts.push({
                type: 'memory',
                level: 'warning',
                message: `High memory usage: ${metrics.memory.usage}%`
            });
        }
        
        if (alerts.length > 0) {
            await this.sendAlerts(alerts);
        }
    }
}
```

### 2. Backup Tools
**Mục đích**: Tự động hóa backup và restore operations

#### Database Backup
```javascript
// tools/backup/database-backup.js
class DatabaseBackup {
    async backupPostgres(database, options = {}) {
        const timestamp = new Date().toISOString().replace(/[:.]/g, '-');
        const backupFile = `${database}_${timestamp}.sql`;
        const backupPath = path.join(this.backupDir, 'postgres', backupFile);
        
        const command = [
            'pg_dump',
            `-h ${this.config.postgres.host}`,
            `-p ${this.config.postgres.port}`,
            `-U ${this.config.postgres.user}`,
            `-d ${database}`,
            `--file=${backupPath}`,
            '--verbose',
            '--no-password'
        ].join(' ');
        
        await this.executeCommand(command);
        
        if (options.compress) {
            await this.compressFile(backupPath);
        }
        
        return {
            database,
            file: backupFile,
            path: backupPath,
            size: await this.getFileSize(backupPath),
            timestamp: new Date().toISOString()
        };
    }
    
    async scheduleBackups(schedule) {
        const cron = require('node-cron');
        
        cron.schedule(schedule, async () => {
            try {
                const databases = await this.getActiveDatabases();
                for (const db of databases) {
                    await this.backupPostgres(db, { compress: true });
                }
                
                await this.cleanupOldBackups();
                this.logger.info('Scheduled backup completed successfully');
            } catch (error) {
                this.logger.error('Scheduled backup failed:', error);
            }
        });
    }
}
```

### 3. Migration Tools
**Mục đích**: Hỗ trợ migration giữa các versions và configurations

#### Version Migrator
```javascript
// tools/migration/version-migrator.js
class VersionMigrator {
    async migrateToVersion(targetVersion) {
        const currentVersion = await this.getCurrentVersion();
        const migrationPath = this.getMigrationPath(currentVersion, targetVersion);
        
        this.logger.info(`Migrating from ${currentVersion} to ${targetVersion}`);
        
        for (const migration of migrationPath) {
            await this.runMigration(migration);
        }
        
        await this.updateVersion(targetVersion);
        this.logger.info('Migration completed successfully');
    }
    
    async runMigration(migration) {
        this.logger.info(`Running migration: ${migration.name}`);
        
        try {
            // Create backup before migration
            await this.createBackup(`pre_${migration.name}`);
            
            // Run migration
            await migration.up();
            
            // Verify migration
            await migration.verify();
            
            this.logger.info(`Migration ${migration.name} completed`);
        } catch (error) {
            this.logger.error(`Migration ${migration.name} failed:`, error);
            
            // Rollback if possible
            if (migration.down) {
                await migration.down();
            }
            
            throw error;
        }
    }
}
```

### 4. Development Tools
**Mục đích**: Hỗ trợ development workflow và code generation

#### Code Generator
```javascript
// tools/development/code-generator.js
class CodeGenerator {
    async generatePlatform(platformConfig) {
        const templates = {
            dockerCompose: 'docker-compose/platform.yml',
            nginxConfig: 'nginx/default.conf.tpl',
            phpConfig: 'php/platform.ini',
            readme: 'platform/README.md'
        };
        
        const generatedFiles = {};
        
        for (const [type, template] of Object.entries(templates)) {
            const content = await this.renderTemplate(template, platformConfig);
            const filePath = this.getOutputPath(type, platformConfig);
            
            await this.writeFile(filePath, content);
            generatedFiles[type] = filePath;
        }
        
        return generatedFiles;
    }
    
    async renderTemplate(templatePath, variables) {
        const template = await this.loadTemplate(templatePath);
        return this.templateEngine.render(template, variables);
    }
    
    async generateDocumentation(platformConfig) {
        const docTemplate = await this.loadTemplate('docs/platform.md');
        const content = this.templateEngine.render(docTemplate, {
            ...platformConfig,
            generatedAt: new Date().toISOString(),
            commands: this.generateCommands(platformConfig)
        });
        
        const docPath = path.join('docs', 'platforms', `${platformConfig.name}.md`);
        await this.writeFile(docPath, content);
        
        return docPath;
    }
}
```

### 5. Security Tools
**Mục đích**: Bảo mật và audit hệ thống

#### Vulnerability Scanner
```javascript
// tools/security/vulnerability-scanner.js
class VulnerabilityScanner {
    async scanSystem() {
        const results = {
            docker: await this.scanDockerImages(),
            dependencies: await this.scanDependencies(),
            configuration: await this.scanConfiguration(),
            network: await this.scanNetwork(),
            files: await this.scanFiles()
        };
        
        return {
            summary: this.generateSummary(results),
            details: results,
            recommendations: this.generateRecommendations(results),
            scannedAt: new Date().toISOString()
        };
    }
    
    async scanDockerImages() {
        const images = await this.getDockerImages();
        const vulnerabilities = [];
        
        for (const image of images) {
            const scan = await this.scanImage(image);
            if (scan.vulnerabilities.length > 0) {
                vulnerabilities.push({
                    image: image.name,
                    tag: image.tag,
                    vulnerabilities: scan.vulnerabilities
                });
            }
        }
        
        return vulnerabilities;
    }
    
    async generateReport(scanResults) {
        const report = {
            executive_summary: this.generateExecutiveSummary(scanResults),
            detailed_findings: scanResults.details,
            risk_assessment: this.assessRisk(scanResults),
            remediation_plan: this.generateRemediationPlan(scanResults),
            generated_at: new Date().toISOString()
        };
        
        const reportPath = path.join('reports', 'security', `scan_${Date.now()}.json`);
        await this.writeFile(reportPath, JSON.stringify(report, null, 2));
        
        return reportPath;
    }
}
```

## 🚀 CLI Integration

### Unified CLI Interface
```javascript
// tools/cli/docker-master-tools.js
class DockerMasterTools {
    constructor() {
        this.program = new Command();
        this.setupCommands();
    }
    
    setupCommands() {
        // Health checking
        this.program
            .command('health')
            .description('Check system health')
            .option('--detailed', 'Show detailed health information')
            .option('--json', 'Output in JSON format')
            .action(async (options) => {
                const healthChecker = new HealthChecker();
                const results = await healthChecker.checkSystemHealth();
                
                if (options.json) {
                    console.log(JSON.stringify(results, null, 2));
                } else {
                    this.displayHealthResults(results, options.detailed);
                }
            });
        
        // Backup operations
        this.program
            .command('backup')
            .description('Backup operations')
            .option('--type <type>', 'Backup type (database, files, full)')
            .option('--target <target>', 'Backup target')
            .option('--compress', 'Compress backup files')
            .action(async (options) => {
                const backupManager = new DatabaseBackup();
                await backupManager.performBackup(options);
            });
        
        // Migration tools
        this.program
            .command('migrate')
            .description('Migration operations')
            .option('--to <version>', 'Target version')
            .option('--dry-run', 'Show what would be migrated')
            .action(async (options) => {
                const migrator = new VersionMigrator();
                
                if (options.dryRun) {
                    await migrator.showMigrationPlan(options.to);
                } else {
                    await migrator.migrateToVersion(options.to);
                }
            });
        
        // Security scanning
        this.program
            .command('security')
            .description('Security operations')
            .option('--scan', 'Run security scan')
            .option('--report', 'Generate security report')
            .action(async (options) => {
                const scanner = new VulnerabilityScanner();
                
                if (options.scan) {
                    const results = await scanner.scanSystem();
                    
                    if (options.report) {
                        const reportPath = await scanner.generateReport(results);
                        console.log(`Security report generated: ${reportPath}`);
                    } else {
                        this.displaySecurityResults(results);
                    }
                }
            });
    }
}
```

## 📊 Benefits của Tools Optimization

### 1. Professional CLI Experience
- **Consistent interface** across all tools
- **Rich output formatting** với colors và progress bars
- **Comprehensive help** và documentation
- **Error handling** với meaningful messages

### 2. Automation Capabilities
- **Scheduled operations** với cron-like scheduling
- **Event-driven automation** based on system events
- **Pipeline integration** cho CI/CD workflows
- **Batch operations** cho multiple platforms

### 3. Monitoring & Observability
- **Real-time monitoring** của system resources
- **Health checks** với detailed diagnostics
- **Performance profiling** và bottleneck detection
- **Alert management** với multiple notification channels

### 4. Security & Compliance
- **Vulnerability scanning** của images và dependencies
- **Security audit logging** cho compliance
- **SSL certificate management** tự động
- **Access control** và permission management

### 5. Maintenance & Operations
- **Automated cleanup** của unused resources
- **Update management** với rollback capabilities
- **Backup automation** với retention policies
- **Diagnostic tools** cho troubleshooting

## 🔧 Usage Examples

### Health Monitoring
```bash
# Quick health check
node tools/cli/docker-master-tools.js health

# Detailed health check with JSON output
node tools/cli/docker-master-tools.js health --detailed --json

# Start continuous monitoring
node tools/monitoring/resource-monitor.js --interval 30 --alerts
```

### Backup Operations
```bash
# Backup all databases
node tools/cli/docker-master-tools.js backup --type database --compress

# Backup specific platform
node tools/cli/docker-master-tools.js backup --type files --target my-shop

# Schedule daily backups
node tools/backup/backup-scheduler.js --schedule "0 2 * * *" --type full
```

### Security Scanning
```bash
# Run security scan
node tools/cli/docker-master-tools.js security --scan

# Generate security report
node tools/cli/docker-master-tools.js security --scan --report

# Scan specific component
node tools/security/vulnerability-scanner.js --target docker-images
```

### Migration Operations
```bash
# Show migration plan
node tools/cli/docker-master-tools.js migrate --to 2.0.0 --dry-run

# Perform migration
node tools/cli/docker-master-tools.js migrate --to 2.0.0

# Rollback migration
node tools/migration/version-migrator.js --rollback --to 1.9.0
```
