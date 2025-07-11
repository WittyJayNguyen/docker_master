-- Create database if not exists
CREATE DATABASE IF NOT EXISTS main_db;

-- Create user for MySQL 5.7 (no need for WITH mysql_native_password)
CREATE USER IF NOT EXISTS 'dbuser'@'%' IDENTIFIED BY 'dbpassword';
GRANT ALL PRIVILEGES ON *.* TO 'dbuser'@'%';

-- Create user for localhost access
CREATE USER IF NOT EXISTS 'dbuser'@'localhost' IDENTIFIED BY 'dbpassword';
GRANT ALL PRIVILEGES ON *.* TO 'dbuser'@'localhost';

-- Create users for specific container IPs
CREATE USER IF NOT EXISTS 'dbuser'@'172.18.0.7' IDENTIFIED BY 'dbpassword';
GRANT ALL PRIVILEGES ON *.* TO 'dbuser'@'172.18.0.7';

CREATE USER IF NOT EXISTS 'dbuser'@'172.18.0.8' IDENTIFIED BY 'dbpassword';
GRANT ALL PRIVILEGES ON *.* TO 'dbuser'@'172.18.0.8';

-- Create user for entire Docker network
CREATE USER IF NOT EXISTS 'dbuser'@'172.18.%' IDENTIFIED BY 'dbpassword';
GRANT ALL PRIVILEGES ON *.* TO 'dbuser'@'172.18.%';

-- Flush privileges
FLUSH PRIVILEGES;

-- Show created users
SELECT User, Host FROM mysql.user WHERE User = 'dbuser';
