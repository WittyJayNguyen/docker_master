-- Create E-commerce database and grant permissions
CREATE DATABASE IF NOT EXISTS ecommerce_db;

-- Create user for ecommerce container network if not exists
CREATE USER IF NOT EXISTS 'dbuser'@'172.19.%' IDENTIFIED BY 'dbpassword';

-- Grant permissions
GRANT ALL PRIVILEGES ON ecommerce_db.* TO 'dbuser'@'%';
GRANT ALL PRIVILEGES ON ecommerce_db.* TO 'dbuser'@'172.19.%';
GRANT ALL PRIVILEGES ON main_db.* TO 'dbuser'@'172.19.%';
FLUSH PRIVILEGES;

-- Create sample tables for e-commerce
USE ecommerce_db;

CREATE TABLE IF NOT EXISTS products (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    price DECIMAL(10,2) NOT NULL,
    stock_quantity INT DEFAULT 0,
    category_id INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS categories (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(100) UNIQUE NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS orders (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    total_amount DECIMAL(10,2) NOT NULL,
    status ENUM('pending', 'processing', 'shipped', 'delivered', 'cancelled') DEFAULT 'pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id)
);

-- Insert sample data
INSERT INTO categories (name, description) VALUES 
('Electronics', 'Electronic devices and gadgets'),
('Clothing', 'Fashion and apparel'),
('Books', 'Books and educational materials'),
('Home & Garden', 'Home improvement and garden supplies');

INSERT INTO products (name, description, price, stock_quantity, category_id) VALUES 
('Smartphone', 'Latest model smartphone with advanced features', 699.99, 50, 1),
('Laptop', 'High-performance laptop for work and gaming', 1299.99, 25, 1),
('T-Shirt', 'Comfortable cotton t-shirt', 19.99, 100, 2),
('Programming Book', 'Learn PHP and MySQL development', 49.99, 30, 3),
('Garden Tools Set', 'Complete set of garden tools', 89.99, 15, 4);
