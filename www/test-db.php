<?php
/**
 * Database Connection Test
 * Test MySQL and PostgreSQL connections without SSL
 */

echo "<h1>🗄️ Database Connection Test</h1>";

// MySQL Connection Test
echo "<h2>MySQL Connection</h2>";
try {
    $mysql_options = [
        PDO::MYSQL_ATTR_SSL_VERIFY_SERVER_CERT => false,
        PDO::MYSQL_ATTR_SSL_CA => null,
        PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION
    ];
    
    $mysql_dsn = "mysql:host=mysql;port=3306;dbname=dev_db;charset=utf8mb4";
    $mysql_pdo = new PDO($mysql_dsn, 'dev_user', 'dev_pass', $mysql_options);
    
    // Test query
    $stmt = $mysql_pdo->query("SELECT VERSION() as version, @@have_ssl as have_ssl");
    $result = $stmt->fetch(PDO::FETCH_ASSOC);

    echo "<div style='background: #d4edda; padding: 15px; border-radius: 5px; margin: 10px 0;'>";
    echo "<strong>✅ MySQL Connected Successfully!</strong><br>";
    echo "Version: " . $result['version'] . "<br>";
    echo "SSL Available: " . $result['have_ssl'] . "<br>";
    echo "Connection: mysql:3306<br>";
    echo "Database: dev_db";
    echo "</div>";
    
    // Test table creation
    $mysql_pdo->exec("CREATE TABLE IF NOT EXISTS test_connection (
        id INT AUTO_INCREMENT PRIMARY KEY,
        message VARCHAR(255),
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    )");
    
    $mysql_pdo->exec("INSERT INTO test_connection (message) VALUES ('Connection test successful')");
    echo "<p>✅ Table creation and insert test passed</p>";
    
} catch (Exception $e) {
    echo "<div style='background: #f8d7da; padding: 15px; border-radius: 5px; margin: 10px 0;'>";
    echo "<strong>❌ MySQL Connection Failed</strong><br>";
    echo "Error: " . $e->getMessage();
    echo "</div>";
}

// PostgreSQL Connection Test
echo "<h2>PostgreSQL Connection</h2>";
try {
    $pgsql_options = [
        PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
        PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC
    ];
    
    $pgsql_dsn = "pgsql:host=postgresql;port=5432;dbname=dev_db;sslmode=disable";
    $pgsql_pdo = new PDO($pgsql_dsn, 'dev_user', 'dev_pass', $pgsql_options);
    
    // Test query
    $stmt = $pgsql_pdo->query("SELECT version()");
    $result = $stmt->fetch();
    
    echo "<div style='background: #d4edda; padding: 15px; border-radius: 5px; margin: 10px 0;'>";
    echo "<strong>✅ PostgreSQL Connected Successfully!</strong><br>";
    echo "Version: " . substr($result['version'], 0, 50) . "...<br>";
    echo "Connection: postgresql:5432<br>";
    echo "Database: dev_db<br>";
    echo "SSL Mode: disabled";
    echo "</div>";
    
    // Test table creation
    $pgsql_pdo->exec("CREATE TABLE IF NOT EXISTS test_connection (
        id SERIAL PRIMARY KEY,
        message VARCHAR(255),
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    )");
    
    $pgsql_pdo->exec("INSERT INTO test_connection (message) VALUES ('Connection test successful')");
    echo "<p>✅ Table creation and insert test passed</p>";
    
} catch (Exception $e) {
    echo "<div style='background: #f8d7da; padding: 15px; border-radius: 5px; margin: 10px 0;'>";
    echo "<strong>❌ PostgreSQL Connection Failed</strong><br>";
    echo "Error: " . $e->getMessage();
    echo "</div>";
}

// Redis Connection Test
echo "<h2>Redis Connection</h2>";
try {
    if (class_exists('Redis')) {
        $redis = new Redis();
        $redis->connect('redis', 6379);
        
        // Test set/get
        $redis->set('test_key', 'Hello from Docker Dev Environment!');
        $value = $redis->get('test_key');
        
        echo "<div style='background: #d4edda; padding: 15px; border-radius: 5px; margin: 10px 0;'>";
        echo "<strong>✅ Redis Connected Successfully!</strong><br>";
        echo "Connection: redis:6379<br>";
        echo "Test Value: $value";
        echo "</div>";
    } else {
        throw new Exception('Redis extension not loaded');
    }
} catch (Exception $e) {
    echo "<div style='background: #f8d7da; padding: 15px; border-radius: 5px; margin: 10px 0;'>";
    echo "<strong>❌ Redis Connection Failed</strong><br>";
    echo "Error: " . $e->getMessage();
    echo "</div>";
}

echo "<h2>📋 Connection Information</h2>";
echo "<div style='background: #d1ecf1; padding: 15px; border-radius: 5px; margin: 10px 0;'>";
echo "<h3>For External Tools (Navicat, etc.):</h3>";
echo "<strong>MySQL:</strong><br>";
echo "Host: localhost<br>";
echo "Port: 3306<br>";
echo "Username: dev_user<br>";
echo "Password: dev_pass<br>";
echo "Database: dev_db<br>";
echo "SSL: Disabled<br><br>";

echo "<strong>PostgreSQL:</strong><br>";
echo "Host: localhost<br>";
echo "Port: 5432<br>";
echo "Username: dev_user<br>";
echo "Password: dev_pass<br>";
echo "Database: dev_db<br>";
echo "SSL Mode: Disable<br><br>";

echo "<strong>Redis:</strong><br>";
echo "Host: localhost<br>";
echo "Port: 6379<br>";
echo "Password: (none)<br>";
echo "</div>";

echo "<p><a href='/'>← Back to main page</a></p>";
?>
