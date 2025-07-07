<?php
echo "Testing database connections...\n";

// Test MySQL
try {
    $mysql = new PDO('mysql:host=mysql_low_ram;port=3306;dbname=main_db', 'mysql_user', 'mysql_pass');
    echo "MySQL: SUCCESS\n";
} catch(Exception $e) {
    echo "MySQL: FAILED - " . $e->getMessage() . "\n";
}

// Test PostgreSQL
try {
    $pgsql = new PDO('pgsql:host=postgres_low_ram;port=5432;dbname=postgres', 'postgres_user', 'postgres_pass');
    echo "PostgreSQL: SUCCESS\n";
} catch(Exception $e) {
    echo "PostgreSQL: FAILED - " . $e->getMessage() . "\n";
}

// Test Redis
try {
    if (class_exists('Redis')) {
        $redis = new Redis();
        $redis->connect('redis_low_ram', 6379);
        echo "Redis: SUCCESS\n";
    } else {
        echo "Redis: Extension not loaded\n";
    }
} catch(Exception $e) {
    echo "Redis: FAILED - " . $e->getMessage() . "\n";
}
