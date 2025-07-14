<?php
echo "Testing Redis Connection...\n";

if (!extension_loaded('redis')) {
    echo "❌ Redis extension not loaded\n";
    exit(1);
}

echo "✅ Redis extension is loaded\n";

try {
    $redis = new Redis();
    $redis->connect('redis_low_ram', 6379);
    echo "✅ Redis Connected Successfully!\n";
    
    // Test set/get
    $redis->set('test_key', 'Hello Redis!');
    $value = $redis->get('test_key');
    echo "✅ Redis Test Value: $value\n";
    
    // Get Redis info
    $info = $redis->info();
    echo "✅ Redis Version: " . $info['redis_version'] . "\n";
    
} catch(Exception $e) {
    echo "❌ Redis Error: " . $e->getMessage() . "\n";
}
?>
