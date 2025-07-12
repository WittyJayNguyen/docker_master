/**
 * Logger Utility - Centralized logging system
 * Provides structured logging with different levels and outputs
 */

const fs = require('fs').promises;
const path = require('path');

class Logger {
    constructor(config = {}) {
        this.config = {
            level: config.level || 'info',
            console: config.console !== false,
            file: config.file || null,
            format: config.format || 'json',
            ...config
        };
        
        this.levels = {
            error: 0,
            warn: 1,
            info: 2,
            debug: 3
        };
        
        this.colors = {
            error: '\x1b[31m',   // Red
            warn: '\x1b[33m',    // Yellow
            info: '\x1b[36m',    // Cyan
            debug: '\x1b[37m',   // White
            reset: '\x1b[0m'     // Reset
        };
    }

    /**
     * Log an error message
     * @param {string} message - Error message
     * @param {Error|Object} error - Error object or additional data
     */
    error(message, error = null) {
        this.log('error', message, error);
    }

    /**
     * Log a warning message
     * @param {string} message - Warning message
     * @param {Object} data - Additional data
     */
    warn(message, data = null) {
        this.log('warn', message, data);
    }

    /**
     * Log an info message
     * @param {string} message - Info message
     * @param {Object} data - Additional data
     */
    info(message, data = null) {
        this.log('info', message, data);
    }

    /**
     * Log a debug message
     * @param {string} message - Debug message
     * @param {Object} data - Additional data
     */
    debug(message, data = null) {
        this.log('debug', message, data);
    }

    /**
     * Core logging method
     * @param {string} level - Log level
     * @param {string} message - Log message
     * @param {any} data - Additional data
     */
    async log(level, message, data = null) {
        // Check if level should be logged
        if (this.levels[level] > this.levels[this.config.level]) {
            return;
        }

        const logEntry = this.createLogEntry(level, message, data);

        // Console output
        if (this.config.console) {
            this.logToConsole(logEntry);
        }

        // File output
        if (this.config.file) {
            await this.logToFile(logEntry);
        }
    }

    /**
     * Create a structured log entry
     * @param {string} level - Log level
     * @param {string} message - Log message
     * @param {any} data - Additional data
     * @returns {Object} Log entry object
     */
    createLogEntry(level, message, data) {
        const entry = {
            timestamp: new Date().toISOString(),
            level: level.toUpperCase(),
            message,
            pid: process.pid
        };

        // Add data if provided
        if (data !== null) {
            if (data instanceof Error) {
                entry.error = {
                    name: data.name,
                    message: data.message,
                    stack: data.stack
                };
            } else {
                entry.data = data;
            }
        }

        return entry;
    }

    /**
     * Log to console with colors
     * @param {Object} logEntry - Log entry object
     */
    logToConsole(logEntry) {
        const color = this.colors[logEntry.level.toLowerCase()] || this.colors.reset;
        const timestamp = new Date(logEntry.timestamp).toLocaleTimeString();
        
        let output = `${color}[${timestamp}] ${logEntry.level}${this.colors.reset}: ${logEntry.message}`;
        
        if (logEntry.data) {
            output += `\n${JSON.stringify(logEntry.data, null, 2)}`;
        }
        
        if (logEntry.error) {
            output += `\n${logEntry.error.stack}`;
        }
        
        console.log(output);
    }

    /**
     * Log to file
     * @param {Object} logEntry - Log entry object
     */
    async logToFile(logEntry) {
        try {
            const logDir = path.dirname(this.config.file);
            await fs.mkdir(logDir, { recursive: true });
            
            let output;
            if (this.config.format === 'json') {
                output = JSON.stringify(logEntry) + '\n';
            } else {
                output = `[${logEntry.timestamp}] ${logEntry.level}: ${logEntry.message}\n`;
                if (logEntry.data) {
                    output += `Data: ${JSON.stringify(logEntry.data)}\n`;
                }
                if (logEntry.error) {
                    output += `Error: ${logEntry.error.stack}\n`;
                }
            }
            
            await fs.appendFile(this.config.file, output);
        } catch (error) {
            console.error('Failed to write to log file:', error);
        }
    }

    /**
     * Create a child logger with additional context
     * @param {Object} context - Additional context to include in all logs
     * @returns {Logger} Child logger instance
     */
    child(context) {
        const childLogger = new Logger(this.config);
        childLogger.context = { ...this.context, ...context };
        
        // Override createLogEntry to include context
        const originalCreateLogEntry = childLogger.createLogEntry.bind(childLogger);
        childLogger.createLogEntry = function(level, message, data) {
            const entry = originalCreateLogEntry(level, message, data);
            if (this.context) {
                entry.context = this.context;
            }
            return entry;
        };
        
        return childLogger;
    }

    /**
     * Set log level
     * @param {string} level - New log level
     */
    setLevel(level) {
        if (this.levels.hasOwnProperty(level)) {
            this.config.level = level;
        } else {
            throw new Error(`Invalid log level: ${level}`);
        }
    }

    /**
     * Get current log level
     * @returns {string} Current log level
     */
    getLevel() {
        return this.config.level;
    }

    /**
     * Log platform operation start
     * @param {string} operation - Operation name
     * @param {Object} details - Operation details
     */
    logOperationStart(operation, details = {}) {
        this.info(`🚀 Starting operation: ${operation}`, {
            operation,
            ...details,
            startTime: new Date().toISOString()
        });
    }

    /**
     * Log platform operation success
     * @param {string} operation - Operation name
     * @param {Object} result - Operation result
     */
    logOperationSuccess(operation, result = {}) {
        this.info(`✅ Operation completed: ${operation}`, {
            operation,
            status: 'success',
            ...result,
            endTime: new Date().toISOString()
        });
    }

    /**
     * Log platform operation failure
     * @param {string} operation - Operation name
     * @param {Error} error - Error that occurred
     */
    logOperationFailure(operation, error) {
        this.error(`❌ Operation failed: ${operation}`, {
            operation,
            status: 'failed',
            error: {
                name: error.name,
                message: error.message,
                stack: error.stack
            },
            endTime: new Date().toISOString()
        });
    }

    /**
     * Log Docker operation
     * @param {string} action - Docker action (build, start, stop, etc.)
     * @param {string} service - Service name
     * @param {Object} details - Additional details
     */
    logDockerOperation(action, service, details = {}) {
        this.info(`🐳 Docker ${action}: ${service}`, {
            docker: {
                action,
                service,
                ...details
            }
        });
    }

    /**
     * Log database operation
     * @param {string} action - Database action
     * @param {string} database - Database name
     * @param {Object} details - Additional details
     */
    logDatabaseOperation(action, database, details = {}) {
        this.info(`🗄️ Database ${action}: ${database}`, {
            database: {
                action,
                name: database,
                ...details
            }
        });
    }

    /**
     * Log Nginx operation
     * @param {string} action - Nginx action
     * @param {Object} details - Additional details
     */
    logNginxOperation(action, details = {}) {
        this.info(`🌐 Nginx ${action}`, {
            nginx: {
                action,
                ...details
            }
        });
    }
}

module.exports = Logger;
