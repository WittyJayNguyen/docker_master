-- Create additional databases for development
-- This script runs automatically when MySQL container starts for the first time

-- Create databases for common projects
CREATE DATABASE IF NOT EXISTS `wordpress_php74` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE DATABASE IF NOT EXISTS `laravel_php84` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE DATABASE IF NOT EXISTS `test_db` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- Grant privileges to dev_user for all databases
GRANT ALL PRIVILEGES ON `wordpress_php74`.* TO 'dev_user'@'%';
GRANT ALL PRIVILEGES ON `laravel_php84`.* TO 'dev_user'@'%';
GRANT ALL PRIVILEGES ON `test_db`.* TO 'dev_user'@'%';

-- Flush privileges
FLUSH PRIVILEGES;

-- Create sample table for testing
USE `test_db`;
CREATE TABLE IF NOT EXISTS `users` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `name` varchar(255) NOT NULL,
    `email` varchar(255) NOT NULL,
    `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Insert sample data
INSERT INTO `users` (`name`, `email`) VALUES 
('John Doe', 'john@example.com'),
('Jane Smith', 'jane@example.com'),
('Bob Johnson', 'bob@example.com')
ON DUPLICATE KEY UPDATE name=VALUES(name);
