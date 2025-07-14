<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Database Test - Docker Master Platform</title>
    <style>
        body { 
            font-family: Arial, sans-serif; 
            margin: 0; 
            padding: 20px; 
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }
        .container { max-width: 1000px; margin: 0 auto; }
        .header {
            background: rgba(255,255,255,0.1);
            padding: 30px;
            border-radius: 15px;
            margin-bottom: 30px;
            text-align: center;
            backdrop-filter: blur(10px);
        }
        .grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }
        .card {
            background: rgba(255,255,255,0.1);
            padding: 25px;
            border-radius: 15px;
            backdrop-filter: blur(10px);
        }
        .status {
            padding: 15px;
            margin: 15px 0;
            border-radius: 8px;
            font-weight: bold;
        }
        .success { background: rgba(40, 167, 69, 0.8); }
        .error { background: rgba(220, 53, 69, 0.8); }
        .info { background: rgba(23, 162, 184, 0.8); }
        .nav-links {
            background: rgba(255,255,255,0.1);
            padding: 20px;
            border-radius: 15px;
            text-align: center;
            backdrop-filter: blur(10px);
        }
        .nav-links a {
            display: inline-block;
            margin: 0 10px;
            padding: 10px 20px;
            background: rgba(255,255,255,0.2);
            color: white;
            text-decoration: none;
            border-radius: 25px;
            transition: all 0.3s ease;
        }
        .nav-links a:hover {
            background: rgba(255,255,255,0.3);
            transform: translateY(-2px);
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin: 15px 0;
        }
        th, td {
            padding: 10px;
            text-align: left;
            border-bottom: 1px solid rgba(255,255,255,0.2);
        }
        th {
            background: rgba(255,255,255,0.2);
            font-weight: bold;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>🧪 Database Connection Test</h1>
            <p>Comprehensive testing of all database connections</p>
            <p><strong>Time:</strong> <?= date('Y-m-d H:i:s') ?></p>
        </div>

        <div class="grid">
            <!-- PostgreSQL Test -->
            <div class="card">
                <h3>🐘 PostgreSQL Test</h3>
                <?php
                try {
                    $pdo = new PDO('pgsql:host=postgres_low_ram;port=5432;dbname=docker_master', 'postgres_user', 'postgres_pass');
                    echo '<div class="status success">✅ PostgreSQL Connected Successfully!</div>';
                    
                    // Get version
                    $stmt = $pdo->query("SELECT version()");
                    $version = $stmt->fetchColumn();
                    echo '<div class="info">Version: ' . htmlspecialchars(substr($version, 0, 50)) . '...</div>';
                    
                    // Test query
                    $stmt = $pdo->query("SELECT current_database(), current_user, now()");
                    $info = $stmt->fetch(PDO::FETCH_ASSOC);
                    echo '<div class="info">';
                    echo 'Database: ' . $info['current_database'] . '<br>';
                    echo 'User: ' . $info['current_user'] . '<br>';
                    echo 'Time: ' . $info['now'];
                    echo '</div>';
                    
                    // List databases
                    $stmt = $pdo->query("SELECT datname FROM pg_database WHERE datistemplate = false ORDER BY datname");
                    $databases = $stmt->fetchAll(PDO::FETCH_COLUMN);
                    echo '<div class="info">Available Databases: ' . implode(', ', $databases) . '</div>';
                    
                } catch (Exception $e) {
                    echo '<div class="status error">❌ PostgreSQL Error: ' . htmlspecialchars($e->getMessage()) . '</div>';
                }
                ?>
            </div>

            <!-- MySQL Test -->
            <div class="card">
                <h3>🐬 MySQL Test</h3>
                <?php
                try {
                    $pdo = new PDO('mysql:host=mysql_low_ram;port=3306;dbname=main_db', 'mysql_user', 'mysql_pass');
                    echo '<div class="status success">✅ MySQL Connected Successfully!</div>';
                    
                    // Get version
                    $stmt = $pdo->query("SELECT VERSION()");
                    $version = $stmt->fetchColumn();
                    echo '<div class="info">Version: ' . htmlspecialchars($version) . '</div>';
                    
                    // Test query
                    $stmt = $pdo->query("SELECT DATABASE(), USER(), NOW()");
                    $info = $stmt->fetch(PDO::FETCH_ASSOC);
                    echo '<div class="info">';
                    echo 'Database: ' . $info['DATABASE()'] . '<br>';
                    echo 'User: ' . $info['USER()'] . '<br>';
                    echo 'Time: ' . $info['NOW()'];
                    echo '</div>';
                    
                    // List databases
                    $stmt = $pdo->query("SHOW DATABASES");
                    $databases = $stmt->fetchAll(PDO::FETCH_COLUMN);
                    echo '<div class="info">Available Databases: ' . implode(', ', $databases) . '</div>';
                    
                } catch (Exception $e) {
                    echo '<div class="status error">❌ MySQL Error: ' . htmlspecialchars($e->getMessage()) . '</div>';
                }
                ?>
            </div>

            <!-- Redis Test -->
            <div class="card">
                <h3>🔴 Redis Test</h3>
                <?php
                try {
                    if (extension_loaded('redis')) {
                        $redis = new Redis();
                        $redis->connect('redis_low_ram', 6379);
                        echo '<div class="status success">✅ Redis Connected Successfully!</div>';
                        
                        // Test operations
                        $testKey = 'test_' . time();
                        $redis->set($testKey, 'Hello from Database Test!');
                        $value = $redis->get($testKey);
                        echo '<div class="info">Test Value: ' . htmlspecialchars($value) . '</div>';
                        
                        // Get info
                        $info = $redis->info();
                        echo '<div class="info">';
                        echo 'Version: ' . ($info['redis_version'] ?? 'Unknown') . '<br>';
                        echo 'Connected Clients: ' . ($info['connected_clients'] ?? 'Unknown') . '<br>';
                        echo 'Used Memory: ' . ($info['used_memory_human'] ?? 'Unknown');
                        echo '</div>';
                        
                        // Clean up
                        $redis->del($testKey);
                        
                    } else {
                        echo '<div class="status error">❌ Redis extension not loaded</div>';
                    }
                } catch (Exception $e) {
                    echo '<div class="status error">❌ Redis Error: ' . htmlspecialchars($e->getMessage()) . '</div>';
                }
                ?>
            </div>

            <!-- PHP Extensions -->
            <div class="card">
                <h3>🔧 PHP Extensions</h3>
                <div class="info">
                    <strong>Database Extensions:</strong><br>
                    <?php
                    $extensions = ['pdo', 'pdo_mysql', 'pdo_pgsql', 'mysqli', 'redis'];
                    foreach ($extensions as $ext) {
                        $status = extension_loaded($ext) ? '✅' : '❌';
                        echo "$status $ext<br>";
                    }
                    ?>
                </div>
                
                <div class="info">
                    <strong>System Info:</strong><br>
                    PHP Version: <?= phpversion() ?><br>
                    Server: <?= $_SERVER['SERVER_SOFTWARE'] ?? 'Unknown' ?><br>
                    OS: <?= PHP_OS ?><br>
                    Memory Limit: <?= ini_get('memory_limit') ?>
                </div>
            </div>
        </div>

        <!-- Performance Test -->
        <div class="card">
            <h3>⚡ Performance Test</h3>
            <?php
            $startTime = microtime(true);
            
            // PostgreSQL performance test
            try {
                $pdo = new PDO('pgsql:host=postgres_low_ram;port=5432;dbname=docker_master', 'postgres_user', 'postgres_pass');
                $pgStart = microtime(true);
                $stmt = $pdo->query("SELECT 1");
                $pgTime = (microtime(true) - $pgStart) * 1000;
                echo '<div class="info">PostgreSQL Query Time: ' . number_format($pgTime, 2) . ' ms</div>';
            } catch (Exception $e) {
                echo '<div class="error">PostgreSQL Performance Test Failed</div>';
            }
            
            // MySQL performance test
            try {
                $pdo = new PDO('mysql:host=mysql_low_ram;port=3306;dbname=main_db', 'mysql_user', 'mysql_pass');
                $mysqlStart = microtime(true);
                $stmt = $pdo->query("SELECT 1");
                $mysqlTime = (microtime(true) - $mysqlStart) * 1000;
                echo '<div class="info">MySQL Query Time: ' . number_format($mysqlTime, 2) . ' ms</div>';
            } catch (Exception $e) {
                echo '<div class="error">MySQL Performance Test Failed</div>';
            }
            
            // Redis performance test
            try {
                if (extension_loaded('redis')) {
                    $redis = new Redis();
                    $redis->connect('redis_low_ram', 6379);
                    $redisStart = microtime(true);
                    $redis->ping();
                    $redisTime = (microtime(true) - $redisStart) * 1000;
                    echo '<div class="info">Redis Ping Time: ' . number_format($redisTime, 2) . ' ms</div>';
                }
            } catch (Exception $e) {
                echo '<div class="error">Redis Performance Test Failed</div>';
            }
            
            $totalTime = (microtime(true) - $startTime) * 1000;
            echo '<div class="info"><strong>Total Test Time: ' . number_format($totalTime, 2) . ' ms</strong></div>';
            ?>
        </div>

        <div class="nav-links">
            <a href="/">🏠 Dashboard</a>
            <a href="/db-status.php">📊 Database Status</a>
            <a href="/postgresql-guide.php">🐘 PostgreSQL Guide</a>
            <a href="/phpinfo.php">📋 PHP Info</a>
            <a href="/redis-test.php">🔴 Redis Test</a>
        </div>
    </div>
</body>
</html>
