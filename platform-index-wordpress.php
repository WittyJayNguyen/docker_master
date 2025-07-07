<?php
/**
 * WordPress PHP 7.4 Platform - Welcome Page
 */
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>📝 WordPress PHP 7.4 Platform</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 0; padding: 20px; background: linear-gradient(135deg, #21759b 0%, #0073aa 100%); color: white; }
        .container { max-width: 800px; margin: 0 auto; background: rgba(255,255,255,0.1); padding: 30px; border-radius: 15px; backdrop-filter: blur(10px); }
        .header { text-align: center; margin-bottom: 30px; }
        .info-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(250px, 1fr)); gap: 20px; margin: 20px 0; }
        .info-card { background: rgba(255,255,255,0.2); padding: 20px; border-radius: 10px; }
        .status { display: inline-block; padding: 5px 10px; border-radius: 20px; font-size: 12px; font-weight: bold; }
        .status.active { background: #4CAF50; }
        .links { margin-top: 30px; text-align: center; }
        .links a { display: inline-block; margin: 10px; padding: 10px 20px; background: rgba(255,255,255,0.3); color: white; text-decoration: none; border-radius: 25px; transition: all 0.3s; }
        .links a:hover { background: rgba(255,255,255,0.5); transform: translateY(-2px); }
        .wp-logo { font-size: 48px; margin-bottom: 10px; }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <div class="wp-logo">📝</div>
            <h1>WordPress PHP 7.4 Platform</h1>
            <p>Optimized for WordPress development with Xdebug</p>
            <span class="status active">ACTIVE</span>
        </div>

        <div class="info-grid">
            <div class="info-card">
                <h3>🐘 PHP Information</h3>
                <p><strong>Version:</strong> <?= PHP_VERSION ?></p>
                <p><strong>SAPI:</strong> <?= php_sapi_name() ?></p>
                <p><strong>Xdebug:</strong> <?= extension_loaded('xdebug') ? '✅ Enabled' : '❌ Disabled' ?></p>
                <?php if (extension_loaded('xdebug')): ?>
                <p><strong>Xdebug Port:</strong> 9075</p>
                <?php endif; ?>
            </div>

            <div class="info-card">
                <h3>🗄️ Database Access</h3>
                <p><strong>MySQL:</strong> mysql_low_ram:3306</p>
                <p><strong>Database:</strong> main_db</p>
                <p><strong>User:</strong> mysql_user</p>
                <p><strong>Redis:</strong> redis_low_ram:6379</p>
            </div>

            <div class="info-card">
                <h3>🌐 Platform URLs</h3>
                <p><strong>This Platform:</strong> :8030</p>
                <p><strong>Main Dashboard:</strong> :80</p>
                <p><strong>Mailhog:</strong> :8025</p>
            </div>

            <div class="info-card">
                <h3>📁 WordPress Setup</h3>
                <p><strong>Document Root:</strong> /var/www/html/</p>
                <p><strong>Platform:</strong> WordPress PHP 7.4</p>
                <p><strong>Purpose:</strong> WordPress sites, plugins, themes</p>
                <p><strong>Recommended:</strong> WP-CLI ready</p>
            </div>
        </div>

        <div class="info-card" style="margin: 20px 0;">
            <h3>🚀 Quick WordPress Setup</h3>
            <p>To install WordPress on this platform:</p>
            <ol style="text-align: left; margin: 10px 0;">
                <li>Download WordPress: <code>wget https://wordpress.org/latest.tar.gz</code></li>
                <li>Extract: <code>tar -xzf latest.tar.gz</code></li>
                <li>Configure database connection</li>
                <li>Run WordPress installer</li>
            </ol>
        </div>

        <div class="links">
            <a href="/">🏠 Main Dashboard</a>
            <a href="/test-db.php">🧪 Database Test</a>
            <a href="/phpinfo.php">📋 PHP Info</a>
            <a href="/phpinfo.php?XDEBUG_SESSION_START=VSCODE">🐛 Start Debug</a>
        </div>

        <div style="text-align: center; margin-top: 30px; opacity: 0.8;">
            <p>🐳 Docker Master Platform - WordPress PHP 7.4 Environment</p>
            <p>Perfect for WordPress development and testing!</p>
        </div>
    </div>
</body>
</html>
