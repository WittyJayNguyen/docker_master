/**
 * Auto Discovery - AI-powered platform detection
 * Analyzes project names to determine optimal platform configuration
 */

class AutoDiscovery {
    constructor(logger) {
        this.logger = logger;
        this.detectionRules = this.initializeDetectionRules();
    }

    /**
     * Detect platform type based on project name
     * @param {string} projectName - Name of the project
     * @returns {Object} Detected platform configuration
     */
    detectPlatform(projectName) {
        this.logger.info(`Analyzing project name: ${projectName}`);
        
        const normalizedName = projectName.toLowerCase();
        
        // Check each detection rule
        for (const rule of this.detectionRules) {
            if (this.matchesRule(normalizedName, rule)) {
                this.logger.info(`Detected platform type: ${rule.type} (matched: ${rule.keywords.join(', ')})`);
                return this.buildPlatformConfig(projectName, rule);
            }
        }
        
        // Default fallback
        this.logger.info(`No specific pattern detected, using default: laravel74`);
        return this.buildPlatformConfig(projectName, this.getDefaultRule());
    }

    /**
     * Check if project name matches a detection rule
     * @param {string} name - Normalized project name
     * @param {Object} rule - Detection rule
     * @returns {boolean} True if matches
     */
    matchesRule(name, rule) {
        return rule.keywords.some(keyword => name.includes(keyword));
    }

    /**
     * Build platform configuration from detection rule
     * @param {string} projectName - Original project name
     * @param {Object} rule - Matched detection rule
     * @returns {Object} Platform configuration
     */
    buildPlatformConfig(projectName, rule) {
        const config = {
            name: projectName,
            type: rule.type,
            phpVersion: rule.phpVersion,
            database: rule.database,
            features: [...rule.features],
            port: this.findAvailablePort(),
            xdebugPort: null
        };
        
        // Calculate Xdebug port
        config.xdebugPort = config.port + 1000;
        
        // Add database name
        config.databaseName = `${projectName.replace(/[^a-zA-Z0-9]/g, '_')}_db`;
        
        return config;
    }

    /**
     * Find next available port
     * @returns {number} Available port number
     */
    findAvailablePort() {
        // This would check actual port availability
        // For now, return a base port (will be implemented with actual port checking)
        return 8015;
    }

    /**
     * Initialize detection rules
     * @returns {Array} Array of detection rules
     */
    initializeDetectionRules() {
        return [
            {
                type: 'ecommerce',
                keywords: ['shop', 'store', 'ecommerce', 'commerce', 'market', 'cart', 'buy', 'sell'],
                phpVersion: '84',
                database: 'mysql',
                features: ['redis', 'queue', 'storage'],
                description: 'E-commerce platform with Laravel 8.4 + MySQL + Redis'
            },
            {
                type: 'wordpress',
                keywords: ['blog', 'cms', 'news', 'article', 'post', 'content', 'wordpress'],
                phpVersion: '74',
                database: 'mysql',
                features: ['uploads', 'media'],
                description: 'WordPress CMS with PHP 7.4 + MySQL'
            },
            {
                type: 'laravel84',
                keywords: ['api', 'service', 'micro', 'backend', 'rest', 'graphql'],
                phpVersion: '84',
                database: 'postgres',
                features: ['redis', 'queue', 'cache'],
                description: 'Laravel 8.4 API service with PostgreSQL + Redis'
            },
            {
                type: 'laravel74',
                keywords: ['app', 'web', 'portal', 'dashboard', 'admin'],
                phpVersion: '74',
                database: 'postgres',
                features: ['session', 'auth'],
                description: 'Laravel 7.4 web application with PostgreSQL'
            }
        ];
    }

    /**
     * Get default detection rule
     * @returns {Object} Default rule
     */
    getDefaultRule() {
        return {
            type: 'laravel74',
            phpVersion: '74',
            database: 'postgres',
            features: ['session'],
            description: 'Default Laravel 7.4 application'
        };
    }

    /**
     * Get all available platform types
     * @returns {Array} Array of platform type information
     */
    getAvailablePlatforms() {
        return this.detectionRules.map(rule => ({
            type: rule.type,
            description: rule.description,
            phpVersion: rule.phpVersion,
            database: rule.database,
            features: rule.features
        }));
    }

    /**
     * Analyze project name and provide suggestions
     * @param {string} projectName - Project name to analyze
     * @returns {Object} Analysis results with suggestions
     */
    analyzeProjectName(projectName) {
        const detected = this.detectPlatform(projectName);
        const alternatives = this.getAlternativeSuggestions(projectName);
        
        return {
            detected,
            alternatives,
            confidence: this.calculateConfidence(projectName, detected),
            suggestions: this.generateSuggestions(projectName)
        };
    }

    /**
     * Get alternative platform suggestions
     * @param {string} projectName - Project name
     * @returns {Array} Array of alternative configurations
     */
    getAlternativeSuggestions(projectName) {
        const normalizedName = projectName.toLowerCase();
        const matches = [];
        
        for (const rule of this.detectionRules) {
            const score = this.calculateMatchScore(normalizedName, rule);
            if (score > 0) {
                matches.push({
                    ...this.buildPlatformConfig(projectName, rule),
                    score,
                    reason: `Matched keywords: ${rule.keywords.filter(k => normalizedName.includes(k)).join(', ')}`
                });
            }
        }
        
        return matches.sort((a, b) => b.score - a.score);
    }

    /**
     * Calculate match score for a rule
     * @param {string} name - Normalized project name
     * @param {Object} rule - Detection rule
     * @returns {number} Match score (0-100)
     */
    calculateMatchScore(name, rule) {
        const matches = rule.keywords.filter(keyword => name.includes(keyword));
        return (matches.length / rule.keywords.length) * 100;
    }

    /**
     * Calculate detection confidence
     * @param {string} projectName - Project name
     * @param {Object} detected - Detected configuration
     * @returns {number} Confidence score (0-100)
     */
    calculateConfidence(projectName, detected) {
        const normalizedName = projectName.toLowerCase();
        const rule = this.detectionRules.find(r => r.type === detected.type);
        
        if (!rule) return 50; // Default confidence
        
        return this.calculateMatchScore(normalizedName, rule);
    }

    /**
     * Generate improvement suggestions
     * @param {string} projectName - Project name
     * @returns {Array} Array of suggestions
     */
    generateSuggestions(projectName) {
        const suggestions = [];
        
        if (projectName.length < 3) {
            suggestions.push('Consider using a more descriptive project name for better auto-detection');
        }
        
        if (!/[a-z]/.test(projectName)) {
            suggestions.push('Include descriptive keywords in your project name (e.g., shop, blog, api)');
        }
        
        return suggestions;
    }
}

module.exports = AutoDiscovery;
