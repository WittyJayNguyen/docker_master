<?php
echo "<h1>🚀 Laravel Demo Project</h1>";
echo "<p>PHP Version: " . PHP_VERSION . "</p>";
echo "<p>This is a demo Laravel project running on PHP 8.4</p>";

echo "<h2>Database Connection Test</h2>";

// Test MySQL connection
try {
    $mysql_options = [
        PDO::MYSQL_ATTR_SSL_VERIFY_SERVER_CERT => false,
        PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION
    ];
    
    $mysql_pdo = new PDO("mysql:host=mysql;dbname=laravel_php84", "dev_user", "dev_pass", $mysql_options);
    echo "<p>✅ MySQL Connection: Success</p>";
} catch (Exception $e) {
    echo "<p>❌ MySQL Connection: " . $e->getMessage() . "</p>";
}

// Test PostgreSQL connection
try {
    $pgsql_pdo = new PDO("pgsql:host=postgresql;dbname=laravel_php84;sslmode=disable", "dev_user", "dev_pass");
    echo "<p>✅ PostgreSQL Connection: Success</p>";
} catch (Exception $e) {
    echo "<p>❌ PostgreSQL Connection: " . $e->getMessage() . "</p>";
}

echo "<h2>Next Steps</h2>";
echo "<ol>";
echo "<li>Install Laravel: <code>docker-compose exec php84 composer create-project laravel/laravel /var/www/html/laravel-demo --prefer-dist</code></li>";
echo "<li>Configure .env file</li>";
echo "<li>Run migrations</li>";
echo "<li>Add to hosts file: <code>127.0.0.1 laravel-demo.local</code></li>";
echo "</ol>";

echo "<p><a href='/'>← Back to main page</a></p>";
?>
