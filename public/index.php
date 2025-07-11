<?php
/**
 * Docker Master Platform - Dashboard
 */
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>🐳 Docker Master Platform</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 0; padding: 20px; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; }
        .container { max-width: 1200px; margin: 0 auto; }
        .header { text-align: center; margin-bottom: 30px; }
        .grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(300px, 1fr)); gap: 20px; }
        .card { background: rgba(255,255,255,0.1); padding: 20px; border-radius: 10px; backdrop-filter: blur(10px); }
        .status { padding: 5px 10px; border-radius: 20px; font-size: 12px; font-weight: bold; }
        .status.success { background: #4CAF50; }
        .status.error { background: #f44336; }
        a { color: #fff; text-decoration: none; }
        a:hover { text-decoration: underline; }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>🐳 Docker Master Platform</h1>
            <p>Multi-PHP Development Environment</p>
        </div>

        <div class="grid">
            <div class="card">
                <h3>🌐 Platform URLs</h3>
                <p><a href="http://localhost:8010/laravel.php">Laravel PHP 8.4</a></p>
                <p><a href="http://localhost:8020">Laravel PHP 7.4</a></p>
                <p><a href="http://localhost:8030">WordPress PHP 7.4</a></p>
            </div>

            <div class="card">
                <h3>🗄️ Database Status</h3>
                <?php
                try {
                    $mysql = new PDO("mysql:host=mysql_low_ram;port=3306;dbname=main_db", "mysql_user", "mysql_pass");
                    echo "<p><span class='status success'>✅</span> MySQL Connected</p>";
                } catch (Exception $e) {
                    echo "<p><span class='status error'>❌</span> MySQL Failed</p>";
                }

                try {
                    $pgsql = new PDO("pgsql:host=postgres_low_ram;port=5432;dbname=postgres", "postgres_user", "postgres_pass");
                    echo "<p><span class='status success'>✅</span> PostgreSQL Connected</p>";
                } catch (Exception $e) {
                    echo "<p><span class='status error'>❌</span> PostgreSQL Failed</p>";
                }

                try {
                    if (extension_loaded('redis')) {
                        $redis = new Redis();
                        $redis->connect('redis_low_ram', 6379);
                        echo "<p><span class='status success'>✅</span> Redis Connected</p>";
                    }
                } catch (Exception $e) {
                    echo "<p><span class='status error'>❌</span> Redis Failed</p>";
                }
                ?>
            </div>

            <div class="card">
                <h3>🛠️ Development Tools</h3>
                <p><a href="/test-db.php">🧪 Database Test</a></p>
                <p><a href="/phpinfo.php">📋 PHP Info</a></p>
                <p><a href="http://localhost:8025">📧 Mailhog</a></p>
            </div>

            <div class="card">
                <h3>📊 System Info</h3>
                <p><strong>PHP Version:</strong> <?= PHP_VERSION ?></p>
                <p><strong>Xdebug:</strong> <?= extension_loaded('xdebug') ? '✅ Enabled' : '❌ Disabled' ?></p>
                <p><strong>Server:</strong> <?= $_SERVER['SERVER_SOFTWARE'] ?? 'Unknown' ?></p>
            </div>
        </div>

        <div style="text-align: center; margin-top: 30px;">
            <p>🚀 Ready for development! Create new platforms with: <code>bin\create.bat project-name</code></p>
        </div>
    </div>
</body>
</html>
