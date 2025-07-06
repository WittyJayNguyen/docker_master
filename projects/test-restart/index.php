<?php
echo "<h1>🚀 test-restart - Laravel Platform</h1>";
echo "<div style='font-family: Arial, sans-serif; max-width: 800px; margin: 0 auto; padding: 20px;'>";
echo "<h2>🗄️ Database Connection</h2>";

try {
    $pdo = new PDO("pgsql:host=postgres_low_ram;dbname=test_restart_db", "postgres_user", "postgres_pass");
    echo "<p>✅ PostgreSQL connection successful!</p>";
    echo "<p>✅ Laravel platform ready!</p>";
    
    echo "<h2>📊 System Information</h2>";
    echo "<p><strong>Platform:</strong> test-restart</p>";
    echo "<p><strong>Type:</strong> Laravel application</p>";
    echo "<p><strong>Database:</strong> test_restart_db</p>";
    echo "<p><strong>PHP Version:</strong> " . PHP_VERSION . "</p>";
    echo "<p><strong>Server Time:</strong> " . date('Y-m-d H:i:s') . "</p>";
    
    echo "<h2>🔧 Quick Actions</h2>";
    echo "<ul>";
    echo "<li><a href='http://localhost:8010'>Laravel PHP 8.4</a></li>";
    echo "<li><a href='http://localhost:8020'>Laravel PHP 7.4</a></li>";
    echo "<li><a href='http://localhost:8030'>WordPress PHP 7.4</a></li>";
    echo "<li><a href='http://localhost:8025'>Mailhog</a></li>";
    echo "</ul>";
    
} catch (Exception $e) {
    echo "<p>❌ Database connection failed: " . $e->getMessage() . "</p>";
}

echo "</div>";
?>
