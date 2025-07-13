/**
 * Configuration Manager - Centralized configuration management
 * Handles environment-based configuration with validation and defaults
 */

const fs = require('fs').promises;
const path = require('path');

class ConfigManager {
    constructor(environment = 'development') {
        this.environment = environment;
        this.config = {};
        this.defaults = {};
        this.loaded = false;
    }

    /**
     * Load configuration from files
     * @returns {Promise<Object>} Loaded configuration
     */
    async load() {
        if (this.loaded) {
            return this.config;
        }

        try {
            // Load default configuration
            await this.loadDefaults();
            
            // Load environment-specific configuration
            await this.loadEnvironmentConfig();
            
            // Load local overrides if they exist
            await this.loadLocalConfig();
            
            // Validate configuration
            this.validateConfig();
            
            this.loaded = true;
            return this.config;
            
        } catch (error) {
            throw new Error(`Failed to load configuration: ${error.message}`);
        }
    }

    /**
     * Load default configuration
     */
    async loadDefaults() {
        const defaultsPath = path.join(__dirname, 'defaults', 'default.json');
        
        try {
            const defaultsContent = await fs.readFile(defaultsPath, 'utf8');
            this.defaults = JSON.parse(defaultsContent);
            this.config = { ...this.defaults };
        } catch (error) {
            // If defaults file doesn't exist, use hardcoded defaults
            this.defaults = this.getHardcodedDefaults();
            this.config = { ...this.defaults };
        }
    }

    /**
     * Load environment-specific configuration
     */
    async loadEnvironmentConfig() {
        const envConfigPath = path.join(__dirname, 'environments', `${this.environment}.json`);
        
        try {
            const envContent = await fs.readFile(envConfigPath, 'utf8');
            const envConfig = JSON.parse(envContent);
            this.config = this.mergeConfig(this.config, envConfig);
        } catch (error) {
            // Environment config is optional
            console.warn(`Environment config not found: ${envConfigPath}`);
        }
    }

    /**
     * Load local configuration overrides
     */
    async loadLocalConfig() {
        const localConfigPath = path.join(__dirname, 'local.json');
        
        try {
            const localContent = await fs.readFile(localConfigPath, 'utf8');
            const localConfig = JSON.parse(localContent);
            this.config = this.mergeConfig(this.config, localConfig);
        } catch (error) {
            // Local config is optional
        }
    }

    /**
     * Get hardcoded default configuration
     * @returns {Object} Default configuration
     */
    getHardcodedDefaults() {
        return {
            docker: {
                composeFile: 'docker-compose.low-ram.yml',
                network: 'low-ram-network',
                defaultMemoryLimit: '128M',
                defaultCpuLimit: '0.5'
            },
            database: {
                postgres: {
                    host: 'postgres_low_ram',
                    port: 5432,
                    username: 'postgres_user',
                    password: 'postgres_pass',
                    defaultDatabase: 'docker_master'
                },
                mysql: {
                    host: 'mysql_low_ram',
                    port: 3306,
                    username: 'mysql_user',
                    password: 'mysql_pass',
                    defaultDatabase: 'docker_master'
                },
                redis: {
                    host: 'redis_low_ram',
                    port: 6379
                }
            },
            platform: {
                defaultPort: 8015,
                portRange: {
                    start: 8015,
                    end: 8100
                },
                xdebugPortOffset: 1000,
                supportedTypes: ['wordpress', 'laravel74', 'laravel84', 'ecommerce'],
                defaultType: 'laravel74'
            },
            nginx: {
                configPath: './nginx/conf.d',
                sitesPath: './nginx/sites',
                defaultDomain: 'localhost'
            },
            logging: {
                level: 'info',
                console: true,
                file: './logs/docker-master.log',
                format: 'json'
            },
            paths: {
                projects: './projects',
                platforms: './platforms',
                logs: './logs',
                data: './data',
                docker: './docker'
            }
        };
    }

    /**
     * Merge configuration objects deeply
     * @param {Object} target - Target configuration
     * @param {Object} source - Source configuration
     * @returns {Object} Merged configuration
     */
    mergeConfig(target, source) {
        const result = { ...target };
        
        for (const key in source) {
            if (source.hasOwnProperty(key)) {
                if (typeof source[key] === 'object' && source[key] !== null && !Array.isArray(source[key])) {
                    result[key] = this.mergeConfig(result[key] || {}, source[key]);
                } else {
                    result[key] = source[key];
                }
            }
        }
        
        return result;
    }

    /**
     * Validate configuration
     * @throws {Error} If configuration is invalid
     */
    validateConfig() {
        const required = [
            'docker.composeFile',
            'database.postgres.host',
            'database.mysql.host',
            'platform.defaultPort',
            'paths.projects'
        ];
        
        for (const path of required) {
            if (!this.getConfigValue(path)) {
                throw new Error(`Missing required configuration: ${path}`);
            }
        }
        
        // Validate port range
        const portRange = this.config.platform.portRange;
        if (portRange.start >= portRange.end) {
            throw new Error('Invalid port range: start must be less than end');
        }
        
        // Validate supported platform types
        if (!Array.isArray(this.config.platform.supportedTypes) || this.config.platform.supportedTypes.length === 0) {
            throw new Error('At least one platform type must be supported');
        }
    }

    /**
     * Get configuration value by path
     * @param {string} path - Dot-separated path (e.g., 'database.postgres.host')
     * @param {any} defaultValue - Default value if not found
     * @returns {any} Configuration value
     */
    get(path, defaultValue = null) {
        return this.getConfigValue(path) || defaultValue;
    }

    /**
     * Set configuration value by path
     * @param {string} path - Dot-separated path
     * @param {any} value - Value to set
     */
    set(path, value) {
        const keys = path.split('.');
        let current = this.config;
        
        for (let i = 0; i < keys.length - 1; i++) {
            const key = keys[i];
            if (!current[key] || typeof current[key] !== 'object') {
                current[key] = {};
            }
            current = current[key];
        }
        
        current[keys[keys.length - 1]] = value;
    }

    /**
     * Get configuration value by dot-separated path
     * @param {string} path - Dot-separated path
     * @returns {any} Configuration value
     */
    getConfigValue(path) {
        const keys = path.split('.');
        let current = this.config;
        
        for (const key of keys) {
            if (current && typeof current === 'object' && current.hasOwnProperty(key)) {
                current = current[key];
            } else {
                return null;
            }
        }
        
        return current;
    }

    /**
     * Get database configuration for a specific type
     * @param {string} type - Database type (postgres, mysql, redis)
     * @returns {Object} Database configuration
     */
    getDatabaseConfig(type) {
        const dbConfig = this.get(`database.${type}`);
        if (!dbConfig) {
            throw new Error(`Database configuration not found for type: ${type}`);
        }
        return dbConfig;
    }

    /**
     * Get platform configuration
     * @returns {Object} Platform configuration
     */
    getPlatformConfig() {
        return this.get('platform');
    }

    /**
     * Get Docker configuration
     * @returns {Object} Docker configuration
     */
    getDockerConfig() {
        return this.get('docker');
    }

    /**
     * Get Nginx configuration
     * @returns {Object} Nginx configuration
     */
    getNginxConfig() {
        return this.get('nginx');
    }

    /**
     * Get logging configuration
     * @returns {Object} Logging configuration
     */
    getLoggingConfig() {
        return this.get('logging');
    }

    /**
     * Get paths configuration
     * @returns {Object} Paths configuration
     */
    getPathsConfig() {
        return this.get('paths');
    }

    /**
     * Check if a platform type is supported
     * @param {string} type - Platform type
     * @returns {boolean} True if supported
     */
    isPlatformTypeSupported(type) {
        const supportedTypes = this.get('platform.supportedTypes', []);
        return supportedTypes.includes(type);
    }

    /**
     * Get next available port
     * @param {Array} usedPorts - Array of currently used ports
     * @returns {number} Next available port
     */
    getNextAvailablePort(usedPorts = []) {
        const portRange = this.get('platform.portRange');
        
        for (let port = portRange.start; port <= portRange.end; port++) {
            if (!usedPorts.includes(port)) {
                return port;
            }
        }
        
        throw new Error('No available ports in the configured range');
    }

    /**
     * Get environment name
     * @returns {string} Current environment
     */
    getEnvironment() {
        return this.environment;
    }

    /**
     * Check if running in development mode
     * @returns {boolean} True if development
     */
    isDevelopment() {
        return this.environment === 'development';
    }

    /**
     * Check if running in production mode
     * @returns {boolean} True if production
     */
    isProduction() {
        return this.environment === 'production';
    }

    /**
     * Get full configuration object
     * @returns {Object} Complete configuration
     */
    getAll() {
        return { ...this.config };
    }
}

module.exports = ConfigManager;
