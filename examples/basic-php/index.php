<?php
/**
 * Basic PHP Example
 * Demonstrates PHP functionality and database connections
 */

// Start session
session_start();

// Database configuration
$mysql_config = [
    'host' => 'mysql',
    'port' => 3306,
    'dbname' => 'dev_db',
    'username' => 'dev_user',
    'password' => 'dev_pass'
];

$pgsql_config = [
    'host' => 'postgresql',
    'port' => 5432,
    'dbname' => 'dev_db',
    'username' => 'dev_user',
    'password' => 'dev_pass'
];

$redis_config = [
    'host' => 'redis',
    'port' => 6379
];

?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Docker Dev Environment - Basic PHP Example</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 40px; background: #f5f5f5; }
        .container { max-width: 1200px; margin: 0 auto; background: white; padding: 30px; border-radius: 8px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
        .header { text-align: center; margin-bottom: 40px; }
        .section { margin: 30px 0; padding: 20px; border: 1px solid #ddd; border-radius: 5px; }
        .success { background: #d4edda; border-color: #c3e6cb; color: #155724; }
        .error { background: #f8d7da; border-color: #f5c6cb; color: #721c24; }
        .info { background: #d1ecf1; border-color: #bee5eb; color: #0c5460; }
        .code { background: #f8f9fa; padding: 15px; border-radius: 4px; font-family: monospace; margin: 10px 0; }
        table { width: 100%; border-collapse: collapse; margin: 15px 0; }
        th, td { padding: 12px; text-align: left; border-bottom: 1px solid #ddd; }
        th { background-color: #f8f9fa; }
        .grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(300px, 1fr)); gap: 20px; }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>🐳 Docker Development Environment</h1>
            <h2>Basic PHP Example</h2>
            <p>Testing PHP functionality and database connections</p>
        </div>

        <!-- PHP Information -->
        <div class="section info">
            <h3>📋 PHP Information</h3>
            <table>
                <tr><th>PHP Version</th><td><?php echo PHP_VERSION; ?></td></tr>
                <tr><th>Server Software</th><td><?php echo $_SERVER['SERVER_SOFTWARE'] ?? 'Unknown'; ?></td></tr>
                <tr><th>Document Root</th><td><?php echo $_SERVER['DOCUMENT_ROOT']; ?></td></tr>
                <tr><th>Current Time</th><td><?php echo date('Y-m-d H:i:s'); ?></td></tr>
                <tr><th>Timezone</th><td><?php echo date_default_timezone_get(); ?></td></tr>
                <tr><th>Memory Limit</th><td><?php echo ini_get('memory_limit'); ?></td></tr>
                <tr><th>Max Execution Time</th><td><?php echo ini_get('max_execution_time'); ?> seconds</td></tr>
            </table>
        </div>

        <!-- PHP Extensions -->
        <div class="section info">
            <h3>🔧 PHP Extensions</h3>
            <div class="grid">
                <?php
                $required_extensions = ['pdo', 'pdo_mysql', 'pdo_pgsql', 'redis', 'gd', 'zip', 'mbstring', 'json', 'curl', 'xdebug'];
                foreach ($required_extensions as $ext) {
                    $loaded = extension_loaded($ext);
                    $class = $loaded ? 'success' : 'error';
                    $status = $loaded ? '✅ Loaded' : '❌ Not Loaded';
                    echo "<div class='section $class'><strong>$ext:</strong> $status</div>";
                }
                ?>
            </div>
        </div>

        <!-- Database Connections -->
        <div class="section">
            <h3>🗄️ Database Connections</h3>
            
            <div class="grid">
                <!-- MySQL Connection -->
                <div>
                    <h4>MySQL Connection</h4>
                    <?php
                    try {
                        $mysql_dsn = "mysql:host={$mysql_config['host']};port={$mysql_config['port']};dbname={$mysql_config['dbname']}";
                        $mysql_pdo = new PDO($mysql_dsn, $mysql_config['username'], $mysql_config['password']);
                        $mysql_pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
                        
                        $stmt = $mysql_pdo->query("SELECT VERSION() as version");
                        $version = $stmt->fetch(PDO::FETCH_ASSOC);
                        
                        echo "<div class='section success'>";
                        echo "<strong>✅ MySQL Connected</strong><br>";
                        echo "Version: " . $version['version'] . "<br>";
                        echo "Host: {$mysql_config['host']}:{$mysql_config['port']}<br>";
                        echo "Database: {$mysql_config['dbname']}";
                        echo "</div>";
                    } catch (Exception $e) {
                        echo "<div class='section error'>";
                        echo "<strong>❌ MySQL Connection Failed</strong><br>";
                        echo "Error: " . $e->getMessage();
                        echo "</div>";
                    }
                    ?>
                </div>

                <!-- PostgreSQL Connection -->
                <div>
                    <h4>PostgreSQL Connection</h4>
                    <?php
                    try {
                        $pgsql_dsn = "pgsql:host={$pgsql_config['host']};port={$pgsql_config['port']};dbname={$pgsql_config['dbname']}";
                        $pgsql_pdo = new PDO($pgsql_dsn, $pgsql_config['username'], $pgsql_config['password']);
                        $pgsql_pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
                        
                        $stmt = $pgsql_pdo->query("SELECT version()");
                        $version = $stmt->fetch(PDO::FETCH_ASSOC);
                        
                        echo "<div class='section success'>";
                        echo "<strong>✅ PostgreSQL Connected</strong><br>";
                        echo "Version: " . substr($version['version'], 0, 50) . "...<br>";
                        echo "Host: {$pgsql_config['host']}:{$pgsql_config['port']}<br>";
                        echo "Database: {$pgsql_config['dbname']}";
                        echo "</div>";
                    } catch (Exception $e) {
                        echo "<div class='section error'>";
                        echo "<strong>❌ PostgreSQL Connection Failed</strong><br>";
                        echo "Error: " . $e->getMessage();
                        echo "</div>";
                    }
                    ?>
                </div>

                <!-- Redis Connection -->
                <div>
                    <h4>Redis Connection</h4>
                    <?php
                    try {
                        if (class_exists('Redis')) {
                            $redis = new Redis();
                            $redis->connect($redis_config['host'], $redis_config['port']);
                            
                            $redis->set('test_key', 'Hello from Docker Dev Environment!');
                            $value = $redis->get('test_key');
                            
                            echo "<div class='section success'>";
                            echo "<strong>✅ Redis Connected</strong><br>";
                            echo "Host: {$redis_config['host']}:{$redis_config['port']}<br>";
                            echo "Test Value: $value";
                            echo "</div>";
                        } else {
                            throw new Exception('Redis extension not loaded');
                        }
                    } catch (Exception $e) {
                        echo "<div class='section error'>";
                        echo "<strong>❌ Redis Connection Failed</strong><br>";
                        echo "Error: " . $e->getMessage();
                        echo "</div>";
                    }
                    ?>
                </div>
            </div>
        </div>

        <!-- Xdebug Information -->
        <div class="section info">
            <h3>🐛 Xdebug Information</h3>
            <?php if (extension_loaded('xdebug')): ?>
                <div class="section success">
                    <strong>✅ Xdebug is loaded</strong><br>
                    Version: <?php echo phpversion('xdebug'); ?><br>
                    Mode: <?php echo ini_get('xdebug.mode'); ?><br>
                    Client Host: <?php echo ini_get('xdebug.client_host'); ?><br>
                    Client Port: <?php echo ini_get('xdebug.client_port'); ?>
                </div>
            <?php else: ?>
                <div class="section error">
                    <strong>❌ Xdebug is not loaded</strong>
                </div>
            <?php endif; ?>
        </div>

        <!-- Environment Variables -->
        <div class="section info">
            <h3>🌍 Environment Variables</h3>
            <div class="code">
                <?php
                $env_vars = ['PHP_VERSION', 'XDEBUG_MODE', 'XDEBUG_CONFIG'];
                foreach ($env_vars as $var) {
                    $value = getenv($var) ?: 'Not set';
                    echo "$var = $value\n";
                }
                ?>
            </div>
        </div>

        <!-- File Upload Test -->
        <div class="section">
            <h3>📁 File Upload Configuration</h3>
            <table>
                <tr><th>file_uploads</th><td><?php echo ini_get('file_uploads') ? 'Enabled' : 'Disabled'; ?></td></tr>
                <tr><th>upload_max_filesize</th><td><?php echo ini_get('upload_max_filesize'); ?></td></tr>
                <tr><th>post_max_size</th><td><?php echo ini_get('post_max_size'); ?></td></tr>
                <tr><th>max_file_uploads</th><td><?php echo ini_get('max_file_uploads'); ?></td></tr>
            </table>
        </div>

        <!-- Footer -->
        <div class="section info">
            <h3>🎉 Success!</h3>
            <p>Your Docker development environment is working correctly!</p>
            <p><strong>Next steps:</strong></p>
            <ul>
                <li>Create your projects in the <code>www/</code> directory</li>
                <li>Use the management scripts to create virtual hosts</li>
                <li>Configure your IDE for Xdebug debugging</li>
                <li>Access database management tools at <a href="http://localhost:8080">Adminer</a> or <a href="http://localhost:8081">phpMyAdmin</a></li>
            </ul>
        </div>
    </div>
</body>
</html>
