<?php
/**
 * Laravel PHP 8.4 Platform - Welcome Page
 */
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>⚡ Laravel PHP 8.4 Platform</title>
    <style>
        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; margin: 0; padding: 20px; background: linear-gradient(135deg, #ff6b6b 0%, #ee5a24 50%, #ff9ff3 100%); color: white; min-height: 100vh; }
        .container { max-width: 900px; margin: 0 auto; background: rgba(255,255,255,0.1); padding: 40px; border-radius: 20px; backdrop-filter: blur(15px); box-shadow: 0 8px 32px rgba(0,0,0,0.3); }
        .header { text-align: center; margin-bottom: 40px; }
        .laravel-logo { font-size: 64px; margin-bottom: 15px; animation: pulse 2s infinite; }
        @keyframes pulse { 0%, 100% { transform: scale(1); } 50% { transform: scale(1.05); } }
        .info-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(280px, 1fr)); gap: 25px; margin: 30px 0; }
        .info-card { background: rgba(255,255,255,0.2); padding: 25px; border-radius: 15px; transition: transform 0.3s ease; border: 1px solid rgba(255,255,255,0.3); }
        .info-card:hover { transform: translateY(-5px); background: rgba(255,255,255,0.25); }
        .status { display: inline-block; padding: 8px 15px; border-radius: 25px; font-size: 14px; font-weight: bold; margin: 10px 0; }
        .status.active { background: #27ae60; box-shadow: 0 0 20px rgba(39, 174, 96, 0.5); }
        .status.modern { background: #e74c3c; box-shadow: 0 0 20px rgba(231, 76, 60, 0.5); }
        .links { margin-top: 40px; text-align: center; }
        .links a { display: inline-block; margin: 12px; padding: 15px 25px; background: rgba(255,255,255,0.3); color: white; text-decoration: none; border-radius: 30px; transition: all 0.3s ease; font-weight: 600; border: 2px solid rgba(255,255,255,0.4); }
        .links a:hover { background: rgba(255,255,255,0.5); transform: translateY(-3px); box-shadow: 0 5px 15px rgba(0,0,0,0.3); }
        .feature-highlight { background: linear-gradient(45deg, rgba(255,255,255,0.2), rgba(255,255,255,0.1)); padding: 20px; border-radius: 15px; margin: 20px 0; border-left: 5px solid #f39c12; }
        .version-badge { background: #8e44ad; padding: 5px 12px; border-radius: 20px; font-size: 12px; margin-left: 10px; }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <div class="laravel-logo">⚡</div>
            <h1>Laravel PHP 8.4 Platform</h1>
            <p>Modern development environment with latest PHP features</p>
            <span class="status active">ACTIVE</span>
            <span class="status modern">MODERN</span>
        </div>

        <div class="feature-highlight">
            <h3>🚀 Latest Technology Stack</h3>
            <p>This platform runs the newest PHP 8.4 with all modern features including JIT compilation, improved performance, and latest Laravel compatibility.</p>
        </div>

        <div class="info-grid">
            <div class="info-card">
                <h3>🐘 PHP Information</h3>
                <p><strong>Version:</strong> <?= PHP_VERSION ?> <span class="version-badge">LATEST</span></p>
                <p><strong>SAPI:</strong> <?= php_sapi_name() ?></p>
                <p><strong>JIT:</strong> <?= function_exists('opcache_get_status') && opcache_get_status()['jit']['enabled'] ? '✅ Enabled' : '⚠️ Check Config' ?></p>
                <p><strong>Xdebug:</strong> <?= extension_loaded('xdebug') ? '✅ Enabled' : '❌ Disabled' ?></p>
                <?php if (extension_loaded('xdebug')): ?>
                <p><strong>Xdebug Port:</strong> 9084</p>
                <?php endif; ?>
            </div>

            <div class="info-card">
                <h3>🗄️ Database Connections</h3>
                <p><strong>MySQL:</strong> mysql_low_ram:3306</p>
                <p><strong>PostgreSQL:</strong> postgres_low_ram:5432</p>
                <p><strong>Redis:</strong> redis_low_ram:6379</p>
                <p><strong>Database:</strong> main_db / postgres</p>
            </div>

            <div class="info-card">
                <h3>🌐 Platform Access</h3>
                <p><strong>This Platform:</strong> :8010</p>
                <p><strong>Main Dashboard:</strong> :80</p>
                <p><strong>Mailhog:</strong> :8025</p>
                <p><strong>Direct Access:</strong> Primary platform</p>
            </div>

            <div class="info-card">
                <h3>⚡ Laravel Features</h3>
                <p><strong>Framework:</strong> Laravel Ready</p>
                <p><strong>Composer:</strong> Available</p>
                <p><strong>Artisan:</strong> Command line ready</p>
                <p><strong>Queue Workers:</strong> Supported</p>
            </div>

            <div class="info-card">
                <h3>🔧 Development Tools</h3>
                <p><strong>Xdebug:</strong> Step debugging ready</p>
                <p><strong>Error Reporting:</strong> Full development mode</p>
                <p><strong>Hot Reload:</strong> File watching enabled</p>
                <p><strong>Performance:</strong> Optimized for speed</p>
            </div>

            <div class="info-card">
                <h3>📁 Project Structure</h3>
                <p><strong>Document Root:</strong> /var/www/html/</p>
                <p><strong>Platform Type:</strong> Laravel PHP 8.4</p>
                <p><strong>Purpose:</strong> Modern web applications</p>
                <p><strong>Recommended:</strong> New projects</p>
            </div>
        </div>

        <div class="feature-highlight">
            <h3>🎯 Quick Laravel Setup</h3>
            <p>Ready to create a new Laravel project? Use these commands:</p>
            <code style="background: rgba(0,0,0,0.3); padding: 10px; border-radius: 5px; display: block; margin: 10px 0;">
                composer create-project laravel/laravel my-project<br>
                cd my-project && php artisan serve
            </code>
        </div>

        <div class="links">
            <a href="/">🏠 Main Dashboard</a>
            <a href="/test-db.php">🧪 Database Test</a>
            <a href="/phpinfo.php">📋 PHP Info</a>
            <a href="/phpinfo.php?XDEBUG_SESSION_START=VSCODE">🐛 Start Debug</a>
            <a href="/ram-optimization.php">📊 RAM Monitor</a>
        </div>

        <div style="text-align: center; margin-top: 40px; opacity: 0.9;">
            <p>🐳 Docker Master Platform - Laravel PHP 8.4 Environment</p>
            <p>The most advanced PHP development environment for modern applications!</p>
        </div>
    </div>
</body>
</html>
