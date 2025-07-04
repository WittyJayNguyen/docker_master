-- Create databases for different projects
CREATE DATABASE IF NOT EXISTS wordpress_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE DATABASE IF NOT EXISTS laravel_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE DATABASE IF NOT EXISTS main_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- Create users for different projects
CREATE USER IF NOT EXISTS 'wp_user'@'%' IDENTIFIED BY 'wp_password123';
CREATE USER IF NOT EXISTS 'laravel_user'@'%' IDENTIFIED BY 'laravel_password123';
CREATE USER IF NOT EXISTS 'dbuser'@'%' IDENTIFIED BY 'dbpassword123';

-- Grant privileges
GRANT ALL PRIVILEGES ON wordpress_db.* TO 'wp_user'@'%';
GRANT ALL PRIVILEGES ON laravel_db.* TO 'laravel_user'@'%';
GRANT ALL PRIVILEGES ON main_db.* TO 'dbuser'@'%';
GRANT ALL PRIVILEGES ON *.* TO 'dbuser'@'%';

-- Flush privileges
FLUSH PRIVILEGES;

-- Create sample tables for testing
USE main_db;
CREATE TABLE IF NOT EXISTS test_table (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO test_table (name, email) VALUES 
('Test User 1', 'test1@example.com'),
('Test User 2', 'test2@example.com');

-- WordPress specific setup
USE wordpress_db;
-- WordPress tables will be created automatically by WordPress installation

-- Laravel specific setup  
USE laravel_db;
-- Laravel tables will be created by migrations
