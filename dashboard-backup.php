<?php
/**
 * Docker Master Platform - Main Dashboard
 *
 * @author Docker Master Platform
 * @version 2.0.0
 * @since 2024-07-07
 */

// Error reporting for development
error_reporting(E_ALL);
ini_set('display_errors', 1);

// Security headers
header('X-Content-Type-Options: nosniff');
header('X-Frame-Options: DENY');
header('X-XSS-Protection: 1; mode=block');

/**
 * Get system information
 */
function getSystemInfo() {
    return [
        'php_version' => PHP_VERSION,
        'server_time' => date('Y-m-d H:i:s'),
        'timezone' => date_default_timezone_get(),
        'server_software' => $_SERVER['SERVER_SOFTWARE'] ?? 'Unknown',
        'document_root' => $_SERVER['DOCUMENT_ROOT'] ?? 'Unknown',
        'server_name' => $_SERVER['SERVER_NAME'] ?? 'localhost',
        'server_port' => $_SERVER['SERVER_PORT'] ?? '80'
    ];
}

/**
 * Check PHP extensions
 */
function checkExtensions() {
    $required_extensions = [
        'pdo' => 'Database abstraction layer',
        'pdo_mysql' => 'MySQL database support',
        'pdo_pgsql' => 'PostgreSQL database support',
        'redis' => 'Redis cache support',
        'gd' => 'Image processing',
        'zip' => 'Archive handling',
        'mbstring' => 'Multibyte string support',
        'json' => 'JSON data handling',
        'curl' => 'HTTP client library',
        'openssl' => 'SSL/TLS support',
        'fileinfo' => 'File type detection',
        'intl' => 'Internationalization'
    ];

    $results = [];
    foreach ($required_extensions as $ext => $description) {
        $results[$ext] = [
            'loaded' => extension_loaded($ext),
            'description' => $description
        ];
    }

    return $results;
}

/**
 * Get available services
 */
function getAvailableServices() {
    return [
        'Database Management' => [
            'Adminer' => 'http://localhost:8080',
            'phpMyAdmin' => 'http://localhost:8081',
            'pgAdmin' => 'http://localhost:8082'
        ],
        'Development Tools' => [
            'Mailhog (Email Testing)' => 'http://localhost:8025',
            'RAM Optimization Status' => '/ram-optimization.php',
            'Database Test' => '/test-db.php'
        ],
        'Platform URLs' => [
            'Laravel PHP 8.4' => 'http://localhost:8010',
            'Laravel PHP 7.4' => 'http://localhost:8020',
            'WordPress PHP 7.4' => 'http://localhost:8030'
        ]
    ];
}

/**
 * Test database connections
 */
function testDatabaseConnections() {
    $connections = [];

    // Test MySQL
    try {
        $mysql_host = 'mysql_low_ram';
        $mysql_port = 3306;
        $mysql_user = 'mysql_user';
        $mysql_pass = 'mysql_pass';

        $pdo = new PDO("mysql:host=$mysql_host;port=$mysql_port", $mysql_user, $mysql_pass);
        $connections['MySQL'] = [
            'status' => 'Connected',
            'host' => "$mysql_host:$mysql_port",
            'version' => $pdo->getAttribute(PDO::ATTR_SERVER_VERSION)
        ];
    } catch (Exception $e) {
        $connections['MySQL'] = [
            'status' => 'Failed',
            'error' => $e->getMessage()
        ];
    }

    // Test PostgreSQL
    try {
        $pgsql_host = 'postgres_low_ram';
        $pgsql_port = 5432;
        $pgsql_user = 'postgres_user';
        $pgsql_pass = 'postgres_pass';

        $pdo = new PDO("pgsql:host=$pgsql_host;port=$pgsql_port;dbname=postgres", $pgsql_user, $pgsql_pass);
        $connections['PostgreSQL'] = [
            'status' => 'Connected',
            'host' => "$pgsql_host:$pgsql_port",
            'version' => $pdo->getAttribute(PDO::ATTR_SERVER_VERSION)
        ];
    } catch (Exception $e) {
        $connections['PostgreSQL'] = [
            'status' => 'Failed',
            'error' => $e->getMessage()
        ];
    }

    // Test Redis
    try {
        if (extension_loaded('redis')) {
            $redis = new Redis();
            $redis->connect('redis_low_ram', 6379);
            $info = $redis->info();
            $connections['Redis'] = [
                'status' => 'Connected',
                'host' => 'redis_low_ram:6379',
                'version' => $info['redis_version'] ?? 'Unknown'
            ];
            $redis->close();
        } else {
            $connections['Redis'] = [
                'status' => 'Extension not loaded',
                'error' => 'Redis PHP extension not available'
            ];
        }
    } catch (Exception $e) {
        $connections['Redis'] = [
            'status' => 'Failed',
            'error' => $e->getMessage()
        ];
    }

    return $connections;
}

// Get all information
$systemInfo = getSystemInfo();
$extensions = checkExtensions();
$services = getAvailableServices();
$dbConnections = testDatabaseConnections();

// Count loaded extensions
$loadedCount = count(array_filter($extensions, function($ext) { return $ext['loaded']; }));
$totalCount = count($extensions);
?>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="Docker Master Platform - Development Environment Dashboard">
    <title>🐳 Docker Master Platform - Development Dashboard</title>
    <style>
        :root {
            --primary-color: #007bff;
            --success-color: #28a745;
            --warning-color: #ffc107;
            --danger-color: #dc3545;
            --info-color: #17a2b8;
            --light-bg: #f8f9fa;
            --border-color: #dee2e6;
            --text-muted: #6c757d;
            --shadow: 0 4px 6px rgba(0,0,0,0.1);
        }

        * {
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            margin: 0;
            padding: 20px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            color: #333;
        }

        .container {
            max-width: 1400px;
            margin: 0 auto;
            background: white;
            border-radius: 12px;
            box-shadow: var(--shadow);
            overflow: hidden;
        }

        .header {
            background: linear-gradient(135deg, var(--primary-color), #0056b3);
            color: white;
            padding: 40px;
            text-align: center;
        }

        .header h1 {
            margin: 0 0 10px 0;
            font-size: 2.5rem;
        }

        .header p {
            margin: 0;
            opacity: 0.9;
            font-size: 1.1rem;
        }

        .content {
            padding: 30px;
        }

        .grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 25px;
            margin-bottom: 30px;
        }

        .card {
            background: white;
            border: 1px solid var(--border-color);
            border-radius: 8px;
            padding: 25px;
            box-shadow: var(--shadow);
            transition: transform 0.2s ease;
        }

        .card:hover {
            transform: translateY(-2px);
        }

        .card h3 {
            margin: 0 0 20px 0;
            color: var(--primary-color);
            font-size: 1.3rem;
            border-bottom: 2px solid var(--border-color);
            padding-bottom: 10px;
        }

        .status-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 10px 0;
            border-bottom: 1px solid #f0f0f0;
        }

        .status-item:last-child {
            border-bottom: none;
        }

        .status-badge {
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 0.85rem;
            font-weight: 500;
        }

        .badge-success { background: #d4edda; color: #155724; }
        .badge-danger { background: #f8d7da; color: #721c24; }
        .badge-warning { background: #fff3cd; color: #856404; }
        .badge-info { background: #d1ecf1; color: #0c5460; }

        .service-link {
            color: var(--primary-color);
            text-decoration: none;
            font-weight: 500;
        }

        .service-link:hover {
            text-decoration: underline;
        }

        .info-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 10px;
            margin: 15px 0;
        }

        .info-item {
            padding: 8px 0;
        }

        .info-label {
            font-weight: 600;
            color: var(--text-muted);
            font-size: 0.9rem;
        }

        .info-value {
            color: #333;
            font-size: 1rem;
        }

        .progress-bar {
            width: 100%;
            height: 20px;
            background: #e9ecef;
            border-radius: 10px;
            overflow: hidden;
            margin: 10px 0;
        }

        .progress-fill {
            height: 100%;
            background: linear-gradient(90deg, var(--success-color), var(--warning-color));
            transition: width 0.5s ease;
        }

        .btn {
            display: inline-block;
            padding: 10px 20px;
            background: var(--primary-color);
            color: white;
            text-decoration: none;
            border-radius: 5px;
            font-weight: 500;
            transition: background 0.3s ease;
            margin: 5px;
        }

        .btn:hover {
            background: #0056b3;
        }

        .btn-success { background: var(--success-color); }
        .btn-warning { background: var(--warning-color); color: #333; }
        .btn-danger { background: var(--danger-color); }

        .footer {
            background: var(--light-bg);
            padding: 20px;
            text-align: center;
            border-top: 1px solid var(--border-color);
        }

        @media (max-width: 768px) {
            .grid { grid-template-columns: 1fr; }
            .info-grid { grid-template-columns: 1fr; }
            .container { margin: 10px; }
            body { padding: 10px; }
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>🐳 Docker Master Platform</h1>
            <p>Development Environment Dashboard - Ready for Action!</p>
        </div>

        <div class="content">
            <!-- System Information -->
            <div class="grid">
                <div class="card">
                    <h3>🖥️ System Information</h3>
                    <div class="info-grid">
                        <div class="info-item">
                            <div class="info-label">PHP Version</div>
                            <div class="info-value"><?php echo htmlspecialchars($systemInfo['php_version']); ?></div>
                        </div>
                        <div class="info-item">
                            <div class="info-label">Server Time</div>
                            <div class="info-value"><?php echo htmlspecialchars($systemInfo['server_time']); ?></div>
                        </div>
                        <div class="info-item">
                            <div class="info-label">Timezone</div>
                            <div class="info-value"><?php echo htmlspecialchars($systemInfo['timezone']); ?></div>
                        </div>
                        <div class="info-item">
                            <div class="info-label">Server</div>
                            <div class="info-value"><?php echo htmlspecialchars($systemInfo['server_name'] . ':' . $systemInfo['server_port']); ?></div>
                        </div>
                    </div>
                </div>

                <div class="card">
                    <h3>🔌 PHP Extensions Status</h3>
                    <div style="margin-bottom: 15px;">
                        <strong><?php echo $loadedCount; ?> of <?php echo $totalCount; ?> extensions loaded</strong>
                        <div class="progress-bar">
                            <div class="progress-fill" style="width: <?php echo round(($loadedCount / $totalCount) * 100); ?>%"></div>
                        </div>
                    </div>
                    <div style="max-height: 200px; overflow-y: auto;">
                        <?php foreach ($extensions as $name => $info): ?>
                            <div class="status-item">
                                <span><?php echo htmlspecialchars($name); ?></span>
                                <span class="status-badge <?php echo $info['loaded'] ? 'badge-success' : 'badge-danger'; ?>">
                                    <?php echo $info['loaded'] ? '✅ Loaded' : '❌ Missing'; ?>
                                </span>
                            </div>
                        <?php endforeach; ?>
                    </div>
                </div>

                <div class="card">
                    <h3>🗄️ Database Connections</h3>
                    <?php foreach ($dbConnections as $dbName => $info): ?>
                        <div class="status-item">
                            <div>
                                <strong><?php echo htmlspecialchars($dbName); ?></strong>
                                <?php if (isset($info['host'])): ?>
                                    <br><small class="text-muted"><?php echo htmlspecialchars($info['host']); ?></small>
                                <?php endif; ?>
                                <?php if (isset($info['version'])): ?>
                                    <br><small class="text-muted">Version: <?php echo htmlspecialchars($info['version']); ?></small>
                                <?php endif; ?>
                            </div>
                            <span class="status-badge <?php echo $info['status'] === 'Connected' ? 'badge-success' : 'badge-danger'; ?>">
                                <?php echo htmlspecialchars($info['status']); ?>
                            </span>
                        </div>
                    <?php endforeach; ?>
                </div>
            </div>

            <!-- Services Grid -->
            <div class="grid">
                <?php foreach ($services as $category => $serviceList): ?>
                    <div class="card">
                        <h3><?php echo htmlspecialchars($category); ?></h3>
                        <?php foreach ($serviceList as $name => $url): ?>
                            <div class="status-item">
                                <span><?php echo htmlspecialchars($name); ?></span>
                                <a href="<?php echo htmlspecialchars($url); ?>" class="service-link" target="_blank">
                                    <?php echo strpos($url, 'http') === 0 ? '🌐 Open' : '📄 View'; ?>
                                </a>
                            </div>
                        <?php endforeach; ?>
                    </div>
                <?php endforeach; ?>
            </div>

            <!-- Quick Actions -->
            <div class="card">
                <h3>⚡ Quick Actions</h3>
                <div style="text-align: center; padding: 20px;">
                    <a href="/ram-optimization.php" class="btn btn-success">📊 RAM Status</a>
                    <a href="/test-db.php" class="btn">🧪 Test Databases</a>
                    <a href="http://localhost:8080" class="btn" target="_blank">🗄️ Adminer</a>
                    <a href="http://localhost:8025" class="btn" target="_blank">📧 Mailhog</a>
                    <a href="#" onclick="location.reload()" class="btn btn-warning">🔄 Refresh</a>
                </div>
            </div>
        </div>

        <div class="footer">
            <p><strong>Docker Master Platform</strong> - Optimized Development Environment</p>
            <p>Last updated: <?php echo date('Y-m-d H:i:s'); ?> |
               <a href="https://github.com/docker/docker" target="_blank">Docker Documentation</a> |
               <a href="/ram-optimization.php">System Status</a>
            </p>
        </div>
    </div>

    <script>
        // Auto-refresh every 5 minutes
        setTimeout(function() {
            location.reload();
        }, 300000);

        // Add click animations
        document.querySelectorAll('.card').forEach(card => {
            card.addEventListener('click', function(e) {
                if (e.target.tagName !== 'A') {
                    this.style.transform = 'scale(0.98)';
                    setTimeout(() => {
                        this.style.transform = '';
                    }, 150);
                }
            });
        });
    </script>
</body>
</html>
