<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Database Status Check</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; background: #f5f5f5; }
        .container { max-width: 800px; margin: 0 auto; background: white; padding: 20px; border-radius: 10px; }
        .status { padding: 10px; margin: 10px 0; border-radius: 5px; }
        .success { background: #d4edda; color: #155724; border: 1px solid #c3e6cb; }
        .error { background: #f8d7da; color: #721c24; border: 1px solid #f5c6cb; }
        .info { background: #d1ecf1; color: #0c5460; border: 1px solid #bee5eb; }
        pre { background: #f8f9fa; padding: 10px; border-radius: 5px; overflow-x: auto; }
    </style>
</head>
<body>
    <div class="container">
        <h1>🔍 Database Connection Status</h1>
        <p><strong>Time:</strong> <?= date('Y-m-d H:i:s') ?></p>
        
        <h2>PostgreSQL Test</h2>
        <?php
        try {
            $pgsql = new PDO("pgsql:host=postgres_low_ram;port=5432;dbname=docker_master", "postgres_user", "postgres_pass");
            echo '<div class="status success">✅ PostgreSQL Connected Successfully!</div>';
            echo '<div class="info">Host: postgres_low_ram:5432<br>Database: docker_master<br>User: postgres_user</div>';
            
            // Test query
            $stmt = $pgsql->query("SELECT version()");
            $version = $stmt->fetchColumn();
            echo '<div class="info">Version: ' . htmlspecialchars($version) . '</div>';
            
        } catch (Exception $e) {
            echo '<div class="status error">❌ PostgreSQL Failed: ' . htmlspecialchars($e->getMessage()) . '</div>';
        }
        ?>
        
        <h2>MySQL Test</h2>
        <?php
        try {
            $mysql = new PDO("mysql:host=mysql_low_ram;port=3306;dbname=main_db", "mysql_user", "mysql_pass");
            echo '<div class="status success">✅ MySQL Connected Successfully!</div>';
            echo '<div class="info">Host: mysql_low_ram:3306<br>Database: main_db<br>User: mysql_user</div>';
            
            // Test query
            $stmt = $mysql->query("SELECT VERSION()");
            $version = $stmt->fetchColumn();
            echo '<div class="info">Version: ' . htmlspecialchars($version) . '</div>';
            
        } catch (Exception $e) {
            echo '<div class="status error">❌ MySQL Failed: ' . htmlspecialchars($e->getMessage()) . '</div>';
        }
        ?>
        
        <h2>Redis Test</h2>
        <?php
        try {
            if (extension_loaded('redis')) {
                $redis = new Redis();
                $redis->connect('redis_low_ram', 6379);
                echo '<div class="status success">✅ Redis Connected Successfully!</div>';
                echo '<div class="info">Host: redis_low_ram:6379</div>';
            } else {
                echo '<div class="status error">❌ Redis extension not loaded</div>';
            }
        } catch (Exception $e) {
            echo '<div class="status error">❌ Redis Failed: ' . htmlspecialchars($e->getMessage()) . '</div>';
        }
        ?>
        
        <h2>PHP Extensions</h2>
        <div class="info">
            <strong>PDO Extensions:</strong><br>
            <?php
            $extensions = ['pdo', 'pdo_mysql', 'pdo_pgsql', 'redis'];
            foreach ($extensions as $ext) {
                $status = extension_loaded($ext) ? '✅' : '❌';
                echo "$status $ext<br>";
            }
            ?>
        </div>
        
        <p><a href="/">← Back to Dashboard</a></p>
    </div>
</body>
</html>
