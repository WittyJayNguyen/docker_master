<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Redis Connection Test</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; background: #f5f5f5; }
        .container { max-width: 600px; margin: 0 auto; background: white; padding: 20px; border-radius: 10px; }
        .status { padding: 15px; margin: 10px 0; border-radius: 5px; font-weight: bold; }
        .success { background: #d4edda; color: #155724; border: 1px solid #c3e6cb; }
        .error { background: #f8d7da; color: #721c24; border: 1px solid #f5c6cb; }
        .info { background: #d1ecf1; color: #0c5460; border: 1px solid #bee5eb; }
        pre { background: #f8f9fa; padding: 10px; border-radius: 5px; overflow-x: auto; }
    </style>
</head>
<body>
    <div class="container">
        <h1>🔴 Redis Connection Test</h1>
        <p><strong>Time:</strong> <?= date('Y-m-d H:i:s') ?></p>
        
        <h2>Extension Check</h2>
        <?php
        if (extension_loaded('redis')) {
            echo '<div class="status success">✅ Redis extension is loaded</div>';
        } else {
            echo '<div class="status error">❌ Redis extension is NOT loaded</div>';
            echo '<div class="info">Available extensions: ' . implode(', ', get_loaded_extensions()) . '</div>';
            exit;
        }
        ?>
        
        <h2>Connection Test</h2>
        <?php
        try {
            $redis = new Redis();
            $result = $redis->connect('redis_low_ram', 6379);
            
            if ($result) {
                echo '<div class="status success">✅ Redis Connected Successfully!</div>';
                
                // Test operations
                $redis->set('test_key_' . time(), 'Hello from Dashboard!');
                $keys = $redis->keys('test_key_*');
                echo '<div class="info">Test keys created: ' . count($keys) . '</div>';
                
                // Get Redis info
                $info = $redis->info();
                echo '<div class="info">';
                echo '<strong>Redis Version:</strong> ' . ($info['redis_version'] ?? 'Unknown') . '<br>';
                echo '<strong>Connected Clients:</strong> ' . ($info['connected_clients'] ?? 'Unknown') . '<br>';
                echo '<strong>Used Memory:</strong> ' . ($info['used_memory_human'] ?? 'Unknown') . '<br>';
                echo '</div>';
                
            } else {
                echo '<div class="status error">❌ Redis connection failed</div>';
            }
            
        } catch (Exception $e) {
            echo '<div class="status error">❌ Redis Error: ' . htmlspecialchars($e->getMessage()) . '</div>';
        }
        ?>
        
        <h2>PHP Info</h2>
        <div class="info">
            <strong>PHP Version:</strong> <?= phpversion() ?><br>
            <strong>Redis Extension Version:</strong> <?= extension_loaded('redis') ? phpversion('redis') : 'Not loaded' ?><br>
        </div>
        
        <p><a href="/">← Back to Dashboard</a></p>
    </div>
</body>
</html>
