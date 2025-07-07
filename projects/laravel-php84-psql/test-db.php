<?php
/**
 * Database Connection Test - Updated for Docker Master Platform
 */

echo "<h1>🗄️ Database Connection Test</h1>";
echo "<p><strong>Testing all database connections...</strong></p>";

// MySQL Connection Test
echo "<h2>🐬 MySQL Connection</h2>";
try {
    $mysql_pdo = new PDO(
        "mysql:host=mysql_low_ram;port=3306;dbname=main_db;charset=utf8mb4",
        'mysql_user',
        'mysql_pass',
        [PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION]
    );

    // Test query
    $stmt = $mysql_pdo->query("SELECT VERSION() as version");
    $result = $stmt->fetch(PDO::FETCH_ASSOC);

    echo "<div style='background: #d4edda; padding: 15px; border-radius: 5px; margin: 10px 0;'>";
    echo "<strong>✅ MySQL Connected Successfully!</strong><br>";
    echo "Version: " . htmlspecialchars($result['version']) . "<br>";
    echo "Host: mysql_low_ram:3306<br>";
    echo "Database: main_db<br>";
    echo "Status: <span style='color: green;'>CONNECTED</span>";
    echo "</div>";

} catch (Exception $e) {
    echo "<div style='background: #f8d7da; padding: 15px; border-radius: 5px; margin: 10px 0;'>";
    echo "<strong>❌ MySQL Connection Failed</strong><br>";
    echo "Error: " . htmlspecialchars($e->getMessage());
    echo "</div>";
}

// PostgreSQL Connection Test
echo "<h2>🐘 PostgreSQL Connection</h2>";
try {
    $pgsql_pdo = new PDO(
        "pgsql:host=postgres_low_ram;port=5432;dbname=postgres;sslmode=disable",
        'postgres_user',
        'postgres_pass',
        [PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION]
    );

    // Test query
    $stmt = $pgsql_pdo->query("SELECT version()");
    $result = $stmt->fetch(PDO::FETCH_ASSOC);

    echo "<div style='background: #d4edda; padding: 15px; border-radius: 5px; margin: 10px 0;'>";
    echo "<strong>✅ PostgreSQL Connected Successfully!</strong><br>";
    echo "Version: " . htmlspecialchars(substr($result['version'], 0, 60)) . "...<br>";
    echo "Host: postgres_low_ram:5432<br>";
    echo "Database: postgres<br>";
    echo "Status: <span style='color: green;'>CONNECTED</span>";
    echo "</div>";

} catch (Exception $e) {
    echo "<div style='background: #f8d7da; padding: 15px; border-radius: 5px; margin: 10px 0;'>";
    echo "<strong>❌ PostgreSQL Connection Failed</strong><br>";
    echo "Error: " . htmlspecialchars($e->getMessage());
    echo "</div>";
}

// Redis Connection Test
echo "<h2>🔴 Redis Connection</h2>";
try {
    if (class_exists('Redis')) {
        $redis = new Redis();
        $redis->connect('redis_low_ram', 6379);

        // Test set/get
        $test_key = 'docker_master_test_' . time();
        $test_value = 'Connection test successful at ' . date('Y-m-d H:i:s');
        $redis->set($test_key, $test_value);
        $retrieved_value = $redis->get($test_key);

        echo "<div style='background: #d4edda; padding: 15px; border-radius: 5px; margin: 10px 0;'>";
        echo "<strong>✅ Redis Connected Successfully!</strong><br>";
        echo "Host: redis_low_ram:6379<br>";
        echo "Test Key: " . htmlspecialchars($test_key) . "<br>";
        echo "Test Value: " . htmlspecialchars($retrieved_value) . "<br>";
        echo "Status: <span style='color: green;'>CONNECTED</span>";
        echo "</div>";

        // Cleanup
        $redis->del($test_key);
    } else {
        throw new Exception('Redis extension not loaded in PHP');
    }
} catch (Exception $e) {
    echo "<div style='background: #f8d7da; padding: 15px; border-radius: 5px; margin: 10px 0;'>";
    echo "<strong>❌ Redis Connection Failed</strong><br>";
    echo "Error: " . htmlspecialchars($e->getMessage());
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
