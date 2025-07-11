-- Create databases for different projects
CREATE DATABASE wordpress_db;
CREATE DATABASE laravel_db;
CREATE DATABASE main_db;

-- Create users for different projects
CREATE USER wp_user WITH PASSWORD 'wp_password123';
CREATE USER laravel_user WITH PASSWORD 'laravel_password123';
CREATE USER dbuser WITH PASSWORD 'dbpassword123';

-- Grant privileges
GRANT ALL PRIVILEGES ON DATABASE wordpress_db TO wp_user;
GRANT ALL PRIVILEGES ON DATABASE laravel_db TO laravel_user;
GRANT ALL PRIVILEGES ON DATABASE main_db TO dbuser;

-- Connect to main_db to create sample tables
\c main_db;

-- Create sample tables for testing
CREATE TABLE IF NOT EXISTS test_table (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO test_table (name, email) VALUES 
('Test User 1', 'test1@example.com'),
('Test User 2', 'test2@example.com');

-- Connect to laravel_db for Laravel specific setup
\c laravel_db;

-- Create Laravel specific tables (example)
CREATE TABLE IF NOT EXISTS migrations (
    id SERIAL PRIMARY KEY,
    migration VARCHAR(255) NOT NULL,
    batch INTEGER NOT NULL
);

-- Connect to wordpress_db for WordPress specific setup
\c wordpress_db;

-- WordPress tables will be created automatically by WordPress installation
-- But we can create some basic structure if needed
