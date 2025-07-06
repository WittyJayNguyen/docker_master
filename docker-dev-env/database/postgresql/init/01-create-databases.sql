-- Create additional databases for development
-- This script runs automatically when PostgreSQL container starts for the first time

-- Create databases for common projects
CREATE DATABASE wordpress_php74;
CREATE DATABASE laravel_php84;
CREATE DATABASE test_db;

-- Connect to test_db to create sample table
\c test_db;

-- Create sample table for testing
CREATE TABLE IF NOT EXISTS users (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Insert sample data
INSERT INTO users (name, email) VALUES 
('John Doe', 'john@example.com'),
('Jane Smith', 'jane@example.com'),
('Bob Johnson', 'bob@example.com')
ON CONFLICT (email) DO NOTHING;
