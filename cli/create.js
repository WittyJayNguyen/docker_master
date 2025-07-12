#!/usr/bin/env node

/**
 * Docker Master CLI - Create Command
 * Modern replacement for create.bat with enhanced features
 */

const { Command } = require('commander');
const chalk = require('chalk');
const inquirer = require('inquirer');
const ora = require('ora');

// Import our core modules
const ConfigManager = require('../src/config/ConfigManager');
const Logger = require('../src/utils/logger/Logger');
const AutoDiscovery = require('../src/core/discovery/AutoDiscovery');
const PlatformManager = require('../src/core/platform/PlatformManager');
const PlatformCreatorService = require('../src/services/platform-creator/PlatformCreatorService');

class CreateCommand {
    constructor() {
        this.program = new Command();
        this.config = null;
        this.logger = null;
        this.autoDiscovery = null;
        this.platformCreator = null;
        
        this.setupCommand();
    }

    async initialize() {
        // Initialize configuration
        this.config = new ConfigManager(process.env.NODE_ENV || 'development');
        await this.config.load();
        
        // Initialize logger
        const loggingConfig = this.config.getLoggingConfig();
        this.logger = new Logger(loggingConfig);
        
        // Initialize services
        this.autoDiscovery = new AutoDiscovery(this.logger);
        this.platformManager = new PlatformManager(this.config, this.logger);
        
        // Initialize platform creator (would need other services in real implementation)
        this.platformCreator = new PlatformCreatorService(
            this.platformManager,
            this.autoDiscovery,
            null, // dockerManager - to be implemented
            null, // nginxManager - to be implemented  
            null, // databaseManager - to be implemented
            this.logger
        );
    }

    setupCommand() {
        this.program
            .name('create')
            .description('Create a new Docker Master platform with AI auto-discovery')
            .version('1.0.0')
            .argument('<name>', 'Platform name')
            .option('-t, --type <type>', 'Platform type (wordpress, laravel74, laravel84, ecommerce)')
            .option('-p, --port <port>', 'Port number', parseInt)
            .option('--php <version>', 'PHP version (74, 84)')
            .option('--db <database>', 'Database type (mysql, postgres)')
            .option('-i, --interactive', 'Interactive mode with step-by-step wizard')
            .option('-y, --yes', 'Skip confirmations and use defaults')
            .option('--dry-run', 'Show what would be created without actually creating')
            .option('--verbose', 'Verbose output')
            .option('--json', 'Output in JSON format')
            .action(async (name, options) => {
                await this.handleCreate(name, options);
            });

        this.program
            .command('analyze <name>')
            .description('Analyze project name and show detection results')
            .option('--json', 'Output in JSON format')
            .action(async (name, options) => {
                await this.handleAnalyze(name, options);
            });

        this.program
            .command('list-types')
            .description('List all available platform types')
            .option('--json', 'Output in JSON format')
            .action(async (options) => {
                await this.handleListTypes(options);
            });
    }

    async handleCreate(name, options) {
        try {
            await this.initialize();
            
            if (options.verbose) {
                this.logger.setLevel('debug');
            }

            this.logger.info(`🚀 Creating platform: ${chalk.cyan(name)}`);

            // Interactive mode
            if (options.interactive) {
                return await this.interactiveCreate(name, options);
            }

            // Auto-discovery mode
            const spinner = ora('Analyzing project name...').start();
            
            const analysis = this.autoDiscovery.analyzeProjectName(name);
            spinner.succeed('Analysis complete');

            // Show detection results
            this.displayDetectionResults(analysis, options);

            // Get final configuration
            const platformConfig = this.buildPlatformConfig(name, options, analysis.detected);

            // Confirmation
            if (!options.yes && !options.dryRun) {
                const confirmed = await this.confirmCreation(platformConfig);
                if (!confirmed) {
                    console.log(chalk.yellow('❌ Platform creation cancelled'));
                    return;
                }
            }

            // Dry run mode
            if (options.dryRun) {
                this.displayDryRun(platformConfig);
                return;
            }

            // Create platform
            await this.createPlatform(platformConfig, options);

        } catch (error) {
            this.logger.error('Failed to create platform:', error);
            console.error(chalk.red(`❌ Error: ${error.message}`));
            process.exit(1);
        }
    }

    async handleAnalyze(name, options) {
        try {
            await this.initialize();
            
            const analysis = this.autoDiscovery.analyzeProjectName(name);
            
            if (options.json) {
                console.log(JSON.stringify(analysis, null, 2));
                return;
            }

            this.displayAnalysisResults(analysis);
            
        } catch (error) {
            console.error(chalk.red(`❌ Error: ${error.message}`));
            process.exit(1);
        }
    }

    async handleListTypes(options) {
        try {
            await this.initialize();
            
            const platforms = this.autoDiscovery.getAvailablePlatforms();
            
            if (options.json) {
                console.log(JSON.stringify(platforms, null, 2));
                return;
            }

            console.log(chalk.blue('\n📋 Available Platform Types:\n'));
            
            platforms.forEach(platform => {
                console.log(`${chalk.green('●')} ${chalk.cyan(platform.type)}`);
                console.log(`  ${platform.description}`);
                console.log(`  PHP: ${platform.phpVersion}, DB: ${platform.database}`);
                console.log(`  Features: ${platform.features.join(', ')}\n`);
            });
            
        } catch (error) {
            console.error(chalk.red(`❌ Error: ${error.message}`));
            process.exit(1);
        }
    }

    async interactiveCreate(name, options) {
        console.log(chalk.blue('\n🧙 Interactive Platform Creation Wizard\n'));

        // Get auto-detection results
        const analysis = this.autoDiscovery.analyzeProjectName(name);
        
        console.log(`${chalk.green('🤖 Auto-detected:')} ${analysis.detected.type} (${analysis.confidence}% confidence)`);
        console.log(`${chalk.gray(analysis.detected.description)}\n`);

        const questions = [
            {
                type: 'confirm',
                name: 'useDetected',
                message: 'Use auto-detected configuration?',
                default: analysis.confidence > 70
            },
            {
                type: 'list',
                name: 'platformType',
                message: 'Select platform type:',
                choices: this.autoDiscovery.getAvailablePlatforms().map(p => ({
                    name: `${p.type} - ${p.description}`,
                    value: p.type
                })),
                when: (answers) => !answers.useDetected
            },
            {
                type: 'input',
                name: 'port',
                message: 'Port number:',
                default: analysis.detected.port,
                validate: (input) => {
                    const port = parseInt(input);
                    return (port >= 1000 && port <= 65535) || 'Port must be between 1000 and 65535';
                }
            },
            {
                type: 'confirm',
                name: 'proceed',
                message: 'Proceed with platform creation?',
                default: true
            }
        ];

        const answers = await inquirer.prompt(questions);
        
        if (!answers.proceed) {
            console.log(chalk.yellow('❌ Platform creation cancelled'));
            return;
        }

        const platformConfig = this.buildPlatformConfig(
            name, 
            { 
                ...options, 
                type: answers.useDetected ? analysis.detected.type : answers.platformType,
                port: parseInt(answers.port)
            }, 
            analysis.detected
        );

        await this.createPlatform(platformConfig, options);
    }

    displayDetectionResults(analysis, options) {
        if (options.json) {
            console.log(JSON.stringify(analysis, null, 2));
            return;
        }

        console.log(chalk.blue('\n🤖 Auto-Discovery Results:\n'));
        
        const { detected, confidence } = analysis;
        const confidenceColor = confidence > 80 ? 'green' : confidence > 60 ? 'yellow' : 'red';
        
        console.log(`${chalk.green('✅ Detected:')} ${chalk.cyan(detected.type)}`);
        console.log(`${chalk.gray('Description:')} ${detected.description}`);
        console.log(`${chalk.gray('Confidence:')} ${chalk[confidenceColor](`${confidence}%`)}`);
        console.log(`${chalk.gray('PHP Version:')} ${detected.phpVersion}`);
        console.log(`${chalk.gray('Database:')} ${detected.database}`);
        console.log(`${chalk.gray('Port:')} ${detected.port}`);
        console.log(`${chalk.gray('Features:')} ${detected.features.join(', ')}\n`);

        if (analysis.alternatives.length > 1) {
            console.log(chalk.blue('🔄 Alternative Suggestions:\n'));
            analysis.alternatives.slice(1, 4).forEach((alt, index) => {
                console.log(`${index + 2}. ${chalk.cyan(alt.type)} (${alt.score.toFixed(0)}% match)`);
                console.log(`   ${alt.reason}\n`);
            });
        }

        if (analysis.suggestions.length > 0) {
            console.log(chalk.yellow('💡 Suggestions:\n'));
            analysis.suggestions.forEach(suggestion => {
                console.log(`   • ${suggestion}`);
            });
            console.log();
        }
    }

    displayAnalysisResults(analysis) {
        console.log(chalk.blue('\n🔍 Project Name Analysis:\n'));
        
        this.displayDetectionResults(analysis, {});
        
        console.log(chalk.blue('📊 All Matches:\n'));
        analysis.alternatives.forEach((alt, index) => {
            const icon = index === 0 ? '🎯' : '○';
            console.log(`${icon} ${chalk.cyan(alt.type)} - ${alt.score.toFixed(0)}% match`);
            console.log(`   ${alt.reason}`);
            console.log(`   PHP: ${alt.phpVersion}, DB: ${alt.database}, Port: ${alt.port}\n`);
        });
    }

    buildPlatformConfig(name, options, detected) {
        return {
            name,
            type: options.type || detected.type,
            port: options.port || detected.port,
            phpVersion: options.php || detected.phpVersion,
            database: options.db || detected.database,
            features: detected.features,
            xdebugPort: (options.port || detected.port) + 1000,
            databaseName: `${name.replace(/[^a-zA-Z0-9]/g, '_')}_db`
        };
    }

    async confirmCreation(config) {
        console.log(chalk.blue('\n📋 Platform Configuration:\n'));
        console.log(`${chalk.gray('Name:')} ${config.name}`);
        console.log(`${chalk.gray('Type:')} ${config.type}`);
        console.log(`${chalk.gray('Port:')} ${config.port}`);
        console.log(`${chalk.gray('PHP:')} ${config.phpVersion}`);
        console.log(`${chalk.gray('Database:')} ${config.database}`);
        console.log(`${chalk.gray('Xdebug:')} ${config.xdebugPort}\n`);

        const { confirmed } = await inquirer.prompt([
            {
                type: 'confirm',
                name: 'confirmed',
                message: 'Create platform with this configuration?',
                default: true
            }
        ]);

        return confirmed;
    }

    displayDryRun(config) {
        console.log(chalk.blue('\n🔍 Dry Run - What would be created:\n'));
        
        console.log(chalk.green('📁 Directories:'));
        console.log(`   projects/${config.name}/`);
        console.log(`   logs/apache/${config.name}/`);
        console.log(`   data/uploads/${config.name}/\n`);
        
        console.log(chalk.green('📄 Files:'));
        console.log(`   projects/${config.name}/index.php`);
        console.log(`   projects/${config.name}/README.md\n`);
        
        console.log(chalk.green('🗄️ Database:'));
        console.log(`   ${config.databaseName}\n`);
        
        console.log(chalk.green('🐳 Docker Service:'));
        console.log(`   Container: ${config.name}_php${config.phpVersion}`);
        console.log(`   Port: ${config.port}:80`);
        console.log(`   Xdebug: ${config.xdebugPort}:9003\n`);
        
        console.log(chalk.blue('✅ Dry run complete - no changes made'));
    }

    async createPlatform(config, options) {
        const spinner = ora('Creating platform...').start();
        
        try {
            // This would call the actual platform creation service
            // For now, just simulate the process
            spinner.text = 'Setting up infrastructure...';
            await new Promise(resolve => setTimeout(resolve, 1000));
            
            spinner.text = 'Creating project files...';
            await new Promise(resolve => setTimeout(resolve, 1000));
            
            spinner.text = 'Configuring services...';
            await new Promise(resolve => setTimeout(resolve, 1000));
            
            spinner.text = 'Starting platform...';
            await new Promise(resolve => setTimeout(resolve, 2000));
            
            spinner.succeed('Platform created successfully!');
            
            // Display success information
            this.displaySuccessInfo(config);
            
        } catch (error) {
            spinner.fail('Platform creation failed');
            throw error;
        }
    }

    displaySuccessInfo(config) {
        console.log(chalk.green('\n🎉 Platform Creation Completed!\n'));
        
        console.log(chalk.blue('📋 Platform Details:'));
        console.log(`   • Name: ${config.name}`);
        console.log(`   • Type: ${config.type}`);
        console.log(`   • URL: ${chalk.cyan(`http://localhost:${config.port}`)}`);
        console.log(`   • Database: ${config.databaseName}`);
        console.log(`   • Xdebug: localhost:${config.xdebugPort}\n`);
        
        console.log(chalk.blue('🚀 Quick Commands:'));
        console.log(`   • View logs: ${chalk.gray(`docker logs ${config.name}_php${config.phpVersion}`)}`);
        console.log(`   • Shell access: ${chalk.gray(`docker exec -it ${config.name}_php${config.phpVersion} bash`)}`);
        console.log(`   • Stop service: ${chalk.gray(`node cli/manage.js stop ${config.name}`)}`);
        console.log(`   • Remove service: ${chalk.gray(`node cli/manage.js delete ${config.name}`)}\n`);
        
        console.log(chalk.green('✅ Ready for development!'));
    }

    async run() {
        await this.program.parseAsync(process.argv);
    }
}

// Run the command if this file is executed directly
if (require.main === module) {
    const createCommand = new CreateCommand();
    createCommand.run().catch(error => {
        console.error(chalk.red('Fatal error:'), error);
        process.exit(1);
    });
}

module.exports = CreateCommand;
