<?php
echo "Testing Database Connections...\n\n";

// Test PostgreSQL
echo "PostgreSQL Test:\n";
try {
    $pdo = new PDO('pgsql:host=postgres_low_ram;port=5432;dbname=docker_master', 'postgres_user', 'postgres_pass');
    echo "✅ PostgreSQL Connected Successfully!\n";
} catch(Exception $e) {
    echo "❌ PostgreSQL Error: " . $e->getMessage() . "\n";
}

echo "\n";

// Test MySQL
echo "MySQL Test:\n";
try {
    $pdo = new PDO('mysql:host=mysql_low_ram;port=3306;dbname=main_db', 'mysql_user', 'mysql_pass');
    echo "✅ MySQL Connected Successfully!\n";
} catch(Exception $e) {
    echo "❌ MySQL Error: " . $e->getMessage() . "\n";
}

echo "\n";

// Test Redis
echo "Redis Test:\n";
try {
    if (extension_loaded('redis')) {
        $redis = new Redis();
        $redis->connect('redis_low_ram', 6379);
        echo "✅ Redis Connected Successfully!\n";
    } else {
        echo "❌ Redis extension not loaded\n";
    }
} catch(Exception $e) {
    echo "❌ Redis Error: " . $e->getMessage() . "\n";
}

echo "\nDone!\n";
?>
