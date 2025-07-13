/**
 * Platform Creator Service - Orchestrates platform creation process
 * Coordinates between auto-discovery, platform management, and infrastructure setup
 */

const path = require('path');
const fs = require('fs').promises;

class PlatformCreatorService {
    constructor(platformManager, autoDiscovery, dockerManager, nginxManager, databaseManager, logger) {
        this.platformManager = platformManager;
        this.autoDiscovery = autoDiscovery;
        this.dockerManager = dockerManager;
        this.nginxManager = nginxManager;
        this.databaseManager = databaseManager;
        this.logger = logger;
    }

    /**
     * Create a complete platform with auto-discovery
     * @param {string} projectName - Name of the project
     * @param {Object} options - Additional options
     * @returns {Promise<Object>} Created platform information
     */
    async createPlatform(projectName, options = {}) {
        this.logger.info(`Starting platform creation for: ${projectName}`);
        
        try {
            // Step 1: Auto-detect platform configuration
            const detectedConfig = this.autoDiscovery.detectPlatform(projectName);
            const platformConfig = { ...detectedConfig, ...options };
            
            this.logger.info(`Detected configuration:`, platformConfig);
            
            // Step 2: Validate and prepare configuration
            await this.validateConfiguration(platformConfig);
            
            // Step 3: Create platform structure
            const platform = await this.platformManager.createPlatform(platformConfig);
            
            // Step 4: Setup infrastructure
            await this.setupInfrastructure(platform);
            
            // Step 5: Create project files
            await this.createProjectFiles(platform);
            
            // Step 6: Configure services
            await this.configureServices(platform);
            
            // Step 7: Start platform
            await this.startPlatform(platform);
            
            // Step 8: Verify platform
            await this.verifyPlatform(platform);
            
            this.logger.info(`Platform ${projectName} created successfully`);
            return platform;
            
        } catch (error) {
            this.logger.error(`Failed to create platform ${projectName}:`, error);
            await this.cleanupFailedCreation(projectName);
            throw error;
        }
    }

    /**
     * Validate platform configuration
     * @param {Object} config - Platform configuration
     * @throws {Error} If configuration is invalid
     */
    async validateConfiguration(config) {
        // Check if port is available
        const isPortAvailable = await this.checkPortAvailability(config.port);
        if (!isPortAvailable) {
            throw new Error(`Port ${config.port} is already in use`);
        }
        
        // Check if platform name is unique
        const existingPlatform = this.platformManager.getPlatform(config.name);
        if (existingPlatform) {
            throw new Error(`Platform ${config.name} already exists`);
        }
        
        // Validate platform type
        const availablePlatforms = this.autoDiscovery.getAvailablePlatforms();
        const validType = availablePlatforms.some(p => p.type === config.type);
        if (!validType) {
            throw new Error(`Invalid platform type: ${config.type}`);
        }
    }

    /**
     * Setup infrastructure (directories, volumes, etc.)
     * @param {Object} platform - Platform object
     */
    async setupInfrastructure(platform) {
        this.logger.info(`Setting up infrastructure for: ${platform.name}`);
        
        // Create project directories
        const projectDir = path.join('projects', platform.name);
        const logsDir = path.join('logs', 'apache', platform.name);
        const uploadsDir = path.join('data', 'uploads', platform.name);
        
        await fs.mkdir(projectDir, { recursive: true });
        await fs.mkdir(logsDir, { recursive: true });
        await fs.mkdir(uploadsDir, { recursive: true });
        
        this.logger.info(`Created directories for: ${platform.name}`);
    }

    /**
     * Create project files based on platform type
     * @param {Object} platform - Platform object
     */
    async createProjectFiles(platform) {
        this.logger.info(`Creating project files for: ${platform.name}`);
        
        const projectDir = path.join('projects', platform.name);
        
        // Create index.php based on platform type
        const indexContent = this.generateIndexFile(platform);
        await fs.writeFile(path.join(projectDir, 'index.php'), indexContent);
        
        // Create README.md
        const readmeContent = this.generateReadmeFile(platform);
        await fs.writeFile(path.join(projectDir, 'README.md'), readmeContent);
        
        // Create platform-specific files
        await this.createPlatformSpecificFiles(platform);
        
        this.logger.info(`Project files created for: ${platform.name}`);
    }

    /**
     * Configure services (Docker, Nginx, Database)
     * @param {Object} platform - Platform object
     */
    async configureServices(platform) {
        this.logger.info(`Configuring services for: ${platform.name}`);
        
        // Configure Docker service
        await this.dockerManager.addService(platform);
        
        // Configure Nginx
        await this.nginxManager.addVirtualHost(platform);
        
        // Create database
        await this.databaseManager.createDatabase(platform);
        
        this.logger.info(`Services configured for: ${platform.name}`);
    }

    /**
     * Start platform services
     * @param {Object} platform - Platform object
     */
    async startPlatform(platform) {
        this.logger.info(`Starting platform: ${platform.name}`);
        
        // Build and start Docker service
        await this.dockerManager.buildService(platform.name);
        await this.dockerManager.startService(platform.name);
        
        // Reload Nginx
        await this.nginxManager.reload();
        
        // Update platform status
        platform.status = 'running';
        platform.startedAt = new Date();
        
        this.logger.info(`Platform ${platform.name} started successfully`);
    }

    /**
     * Verify platform is working correctly
     * @param {Object} platform - Platform object
     */
    async verifyPlatform(platform) {
        this.logger.info(`Verifying platform: ${platform.name}`);
        
        // Wait for service to be ready
        await this.waitForService(platform);
        
        // Test HTTP response
        const isResponding = await this.testHttpResponse(platform);
        if (!isResponding) {
            throw new Error(`Platform ${platform.name} is not responding`);
        }
        
        // Test database connection
        const dbConnected = await this.testDatabaseConnection(platform);
        if (!dbConnected) {
            this.logger.warn(`Database connection test failed for: ${platform.name}`);
        }
        
        this.logger.info(`Platform ${platform.name} verified successfully`);
    }

    /**
     * Generate index.php content based on platform type
     * @param {Object} platform - Platform object
     * @returns {string} PHP content
     */
    generateIndexFile(platform) {
        const templates = {
            wordpress: this.getWordPressTemplate(platform),
            laravel74: this.getLaravel74Template(platform),
            laravel84: this.getLaravel84Template(platform),
            ecommerce: this.getEcommerceTemplate(platform)
        };
        
        return templates[platform.type] || templates.laravel74;
    }

    /**
     * Generate README.md content
     * @param {Object} platform - Platform object
     * @returns {string} Markdown content
     */
    generateReadmeFile(platform) {
        return `# ${platform.name}

## Platform Information
- **Type**: ${platform.type}
- **PHP Version**: ${platform.config.phpVersion}
- **Database**: ${platform.config.database}
- **Port**: ${platform.port}
- **Xdebug Port**: ${platform.config.xdebugPort}

## Quick Commands
\`\`\`bash
# View logs
docker logs ${platform.name}_php${platform.config.phpVersion}

# Shell access
docker exec -it ${platform.name}_php${platform.config.phpVersion} bash

# Stop service
docker-compose -f docker-compose.low-ram.yml stop ${platform.name}
\`\`\`

## URLs
- **Application**: http://localhost:${platform.port}
- **Xdebug**: localhost:${platform.config.xdebugPort}

Created by Docker Master Platform on ${new Date().toISOString()}
`;
    }

    /**
     * Create platform-specific files
     * @param {Object} platform - Platform object
     */
    async createPlatformSpecificFiles(platform) {
        // Implementation for creating platform-specific files
        // (composer.json, package.json, etc.)
    }

    /**
     * Check if port is available
     * @param {number} port - Port number to check
     * @returns {Promise<boolean>} True if available
     */
    async checkPortAvailability(port) {
        // Implementation for checking port availability
        return true; // Placeholder
    }

    /**
     * Wait for service to be ready
     * @param {Object} platform - Platform object
     */
    async waitForService(platform) {
        // Implementation for waiting for service readiness
        await new Promise(resolve => setTimeout(resolve, 10000));
    }

    /**
     * Test HTTP response
     * @param {Object} platform - Platform object
     * @returns {Promise<boolean>} True if responding
     */
    async testHttpResponse(platform) {
        // Implementation for testing HTTP response
        return true; // Placeholder
    }

    /**
     * Test database connection
     * @param {Object} platform - Platform object
     * @returns {Promise<boolean>} True if connected
     */
    async testDatabaseConnection(platform) {
        // Implementation for testing database connection
        return true; // Placeholder
    }

    /**
     * Cleanup failed platform creation
     * @param {string} projectName - Project name
     */
    async cleanupFailedCreation(projectName) {
        this.logger.info(`Cleaning up failed creation: ${projectName}`);
        // Implementation for cleanup
    }

    // Template methods for different platform types
    getWordPressTemplate(platform) {
        return `<?php
/**
 * ${platform.name} - WordPress Platform
 * Auto-generated by Docker Master Platform
 */

echo "<h1>📝 ${platform.name} - WordPress Platform</h1>";
echo "<p>WordPress platform ready for development!</p>";
?>`;
    }

    getLaravel74Template(platform) {
        return `<?php
/**
 * ${platform.name} - Laravel PHP 7.4 Platform
 * Auto-generated by Docker Master Platform
 */

echo "<h1>🚀 ${platform.name} - Laravel PHP 7.4</h1>";
echo "<p>Laravel 7.4 platform ready for development!</p>";
?>`;
    }

    getLaravel84Template(platform) {
        return `<?php
/**
 * ${platform.name} - Laravel PHP 8.4 Platform
 * Auto-generated by Docker Master Platform
 */

echo "<h1>🚀 ${platform.name} - Laravel PHP 8.4</h1>";
echo "<p>Modern Laravel platform ready for development!</p>";
?>`;
    }

    getEcommerceTemplate(platform) {
        return `<?php
/**
 * ${platform.name} - E-commerce Platform
 * Auto-generated by Docker Master Platform
 */

echo "<h1>🛒 ${platform.name} - E-commerce Platform</h1>";
echo "<p>E-commerce platform with full stack ready!</p>";
?>`;
    }
}

module.exports = PlatformCreatorService;
