<?php
/**
 * WordPress PHP 7.4 + PostgreSQL Example
 * Demo application showing WordPress-style setup with PostgreSQL connection
 */

// Display PHP version and loaded extensions
echo "<h1>📝 WordPress PHP 7.4 + PostgreSQL Example</h1>";
echo "<div style='font-family: Arial, sans-serif; max-width: 800px; margin: 0 auto; padding: 20px;'>";

// PHP Information
echo "<h2>📋 PHP Information</h2>";
echo "<p><strong>PHP Version:</strong> " . phpversion() . "</p>";
echo "<p><strong>Server:</strong> " . $_SERVER['SERVER_SOFTWARE'] . "</p>";
echo "<p><strong>Document Root:</strong> " . $_SERVER['DOCUMENT_ROOT'] . "</p>";

// Database Connection Test
echo "<h2>🗄️ PostgreSQL Connection Test</h2>";

$host = $_ENV['DB_HOST'] ?? 'postgres_low_ram';
$dbname = $_ENV['DB_DATABASE'] ?? 'wordpress_php74';
$username = $_ENV['DB_USERNAME'] ?? 'postgres_user';
$password = $_ENV['DB_PASSWORD'] ?? 'postgres_pass';

try {
    // Connect to PostgreSQL server
    $dsn = "pgsql:host=$host;port=5432;dbname=$dbname";
    $pdo = new PDO($dsn, $username, $password);
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

    echo "<p>✅ Connected to PostgreSQL database '$dbname'</p>";
    
    // Create WordPress-style tables for PostgreSQL
    $pdo->exec("
        CREATE TABLE IF NOT EXISTS wp_posts (
            ID SERIAL PRIMARY KEY,
            post_title TEXT NOT NULL,
            post_content TEXT NOT NULL,
            post_status VARCHAR(20) NOT NULL DEFAULT 'publish',
            post_type VARCHAR(20) NOT NULL DEFAULT 'post',
            post_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
        )
    ");

    $pdo->exec("
        CREATE TABLE IF NOT EXISTS wp_users (
            ID SERIAL PRIMARY KEY,
            user_login VARCHAR(60) NOT NULL UNIQUE,
            user_email VARCHAR(100) NOT NULL UNIQUE,
            user_registered TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
            display_name VARCHAR(250) NOT NULL
        )
    ");
    
    // Insert sample data (PostgreSQL style)
    $stmt = $pdo->prepare("INSERT INTO wp_users (user_login, user_email, display_name) VALUES (?, ?, ?) ON CONFLICT (user_login) DO NOTHING");
    $stmt->execute(['admin', 'admin@example.com', 'Administrator']);
    $stmt->execute(['editor', 'editor@example.com', 'Content Editor']);

    $stmt = $pdo->prepare("INSERT INTO wp_posts (post_title, post_content, post_type) VALUES (?, ?, ?) ON CONFLICT DO NOTHING");
    $stmt->execute(['Welcome to WordPress', 'This is your first post. Edit or delete it, then start writing!', 'post']);
    $stmt->execute(['Sample Page', 'This is an example page. Unlike posts, pages are better suited for more timeless content.', 'page']);
    
    // Fetch data
    $stmt = $pdo->query("SELECT * FROM wp_posts ORDER BY ID");
    $posts = $stmt->fetchAll(PDO::FETCH_ASSOC);
    
    $stmt = $pdo->query("SELECT * FROM wp_users ORDER BY ID");
    $users = $stmt->fetchAll(PDO::FETCH_ASSOC);
    
    echo "<p>✅ PostgreSQL connection successful!</p>";
    echo "<p><strong>Database:</strong> $dbname</p>";
    echo "<p><strong>Host:</strong> $host:5432</p>";
    
    echo "<h3>👥 WordPress Users:</h3>";
    echo "<table border='1' style='border-collapse: collapse; width: 100%; margin-bottom: 20px;'>";
    echo "<tr><th>ID</th><th>Username</th><th>Email</th><th>Display Name</th><th>Registered</th></tr>";
    foreach ($users as $user) {
        echo "<tr>";
        echo "<td>" . htmlspecialchars($user['ID']) . "</td>";
        echo "<td>" . htmlspecialchars($user['user_login']) . "</td>";
        echo "<td>" . htmlspecialchars($user['user_email']) . "</td>";
        echo "<td>" . htmlspecialchars($user['display_name']) . "</td>";
        echo "<td>" . htmlspecialchars($user['user_registered']) . "</td>";
        echo "</tr>";
    }
    echo "</table>";
    
    echo "<h3>📝 WordPress Posts:</h3>";
    echo "<table border='1' style='border-collapse: collapse; width: 100%;'>";
    echo "<tr><th>ID</th><th>Title</th><th>Type</th><th>Status</th><th>Date</th></tr>";
    foreach ($posts as $post) {
        echo "<tr>";
        echo "<td>" . htmlspecialchars($post['ID']) . "</td>";
        echo "<td>" . htmlspecialchars($post['post_title']) . "</td>";
        echo "<td>" . htmlspecialchars($post['post_type']) . "</td>";
        echo "<td>" . htmlspecialchars($post['post_status']) . "</td>";
        echo "<td>" . htmlspecialchars($post['post_date']) . "</td>";
        echo "</tr>";
    }
    echo "</table>";
    
} catch (PDOException $e) {
    echo "<p>❌ Database connection failed: " . htmlspecialchars($e->getMessage()) . "</p>";
}

// WordPress Constants Demo
echo "<h2>⚙️ WordPress-style Configuration</h2>";

define('WP_DEBUG', true);
define('WP_DEBUG_LOG', true);
define('ABSPATH', __DIR__ . '/');

echo "<p><strong>WP_DEBUG:</strong> " . (WP_DEBUG ? 'Enabled' : 'Disabled') . "</p>";
echo "<p><strong>ABSPATH:</strong> " . ABSPATH . "</p>";

// PHP 7.4 Features for WordPress
echo "<h2>✨ PHP 7.4 Features for WordPress</h2>";

// WordPress-style options array
$wp_options = [
    'blogname' => 'My WordPress Site',
    'blogdescription' => 'Just another WordPress site',
    'admin_email' => 'admin@example.com'
];

// Null coalescing assignment for options
$wp_options['timezone_string'] ??= 'UTC';
$wp_options['date_format'] ??= 'F j, Y';

echo "<p><strong>Site Options:</strong></p>";
echo "<ul>";
foreach ($wp_options as $key => $value) {
    echo "<li><strong>$key:</strong> " . htmlspecialchars($value) . "</li>";
}
echo "</ul>";

// Loaded Extensions
echo "<h2>🔧 Loaded Extensions</h2>";
$extensions = get_loaded_extensions();
sort($extensions);

echo "<div style='columns: 3; column-gap: 20px;'>";
foreach ($extensions as $ext) {
    echo "<p>• " . htmlspecialchars($ext) . "</p>";
}
echo "</div>";

echo "<hr>";
echo "<p><em>🐳 Running in Docker container with PHP " . phpversion() . " and PostgreSQL</em></p>";
echo "<p><em>📝 Ready for WordPress installation with PostgreSQL!</em></p>";
echo "</div>";
?>
