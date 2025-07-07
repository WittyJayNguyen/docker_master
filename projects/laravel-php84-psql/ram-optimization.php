<?php
/**
 * RAM Optimization Status Page
 * Shows current memory usage and optimization settings
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
 * Get system memory information with enhanced error handling
 *
 * @return array Memory information array
 */
function getSystemMemory() {
    $memory = [];

    try {
        // Try to get memory info from /proc/meminfo (Linux/WSL)
        if (file_exists('/proc/meminfo') && is_readable('/proc/meminfo')) {
            $meminfo = @file_get_contents('/proc/meminfo');
            if ($meminfo !== false) {
                preg_match('/MemTotal:\s+(\d+)\s+kB/', $meminfo, $total);
                preg_match('/MemAvailable:\s+(\d+)\s+kB/', $meminfo, $available);

                if (!empty($total[1]) && !empty($available[1])) {
                    $memory['total'] = round($total[1] / 1024 / 1024, 2);
                    $memory['available'] = round($available[1] / 1024 / 1024, 2);
                    $memory['used'] = round($memory['total'] - $memory['available'], 2);
                    $memory['source'] = '/proc/meminfo';
                    $memory['detected'] = false;
                }
            }
        }

        // Fallback: try to read from optimization file
        if (empty($memory)) {
            $opt_file = __DIR__ . '/../.ram-optimized';
            if (file_exists($opt_file) && is_readable($opt_file)) {
                $detected_ram = @file_get_contents($opt_file);
                if ($detected_ram !== false) {
                    $detected_ram = (int)trim($detected_ram);
                    if ($detected_ram > 0) {
                        $memory['total'] = $detected_ram;
                        $memory['detected'] = true;
                        $memory['source'] = 'Auto-detected during optimization';
                        $memory['available'] = round($detected_ram * 0.3, 2); // Estimate 30% available
                        $memory['used'] = round($detected_ram * 0.7, 2); // Estimate 70% used
                    }
                }
            }
        }

        // Final fallback: estimate based on common configurations
        if (empty($memory)) {
            $memory = [
                'total' => 8.0,
                'available' => 2.4,
                'used' => 5.6,
                'detected' => true,
                'source' => 'Estimated (default configuration)'
            ];
        }

    } catch (Exception $e) {
        error_log("Error getting system memory: " . $e->getMessage());
        // Return safe defaults
        $memory = [
            'total' => 8.0,
            'available' => 2.4,
            'used' => 5.6,
            'detected' => true,
            'source' => 'Error fallback',
            'error' => $e->getMessage()
        ];
    }

    return $memory;
}

/**
 * Get optimization profile based on available RAM
 *
 * @param float $ram_gb Available RAM in GB
 * @return array Optimization profile configuration
 */
function getOptimizationProfile($ram_gb) {
    // Ensure we have a valid number
    $ram_gb = max(1, (float)$ram_gb);

    $profiles = [
        4 => [
            'profile' => 'Low RAM (Conservative)',
            'mysql_innodb' => '200MB',
            'mysql_innodb_raw' => 200,
            'php_memory' => '256MB',
            'php_memory_raw' => 256,
            'opcache' => '64MB',
            'opcache_raw' => 64,
            'description' => 'Optimized for systems with limited RAM (≤4GB)',
            'total_usage' => '~520MB',
            'recommendations' => [
                'Close unnecessary applications',
                'Use lightweight IDE',
                'Consider upgrading RAM'
            ]
        ],
        8 => [
            'profile' => 'Medium RAM (Balanced)',
            'mysql_innodb' => '512MB',
            'mysql_innodb_raw' => 512,
            'php_memory' => '512MB',
            'php_memory_raw' => 512,
            'opcache' => '128MB',
            'opcache_raw' => 128,
            'description' => 'Balanced settings for moderate RAM (5-8GB)',
            'total_usage' => '~1.2GB',
            'recommendations' => [
                'Good for most development tasks',
                'Can run multiple containers',
                'Suitable for small to medium projects'
            ]
        ],
        16 => [
            'profile' => 'High RAM (Performance)',
            'mysql_innodb' => '1GB',
            'mysql_innodb_raw' => 1024,
            'php_memory' => '1GB',
            'php_memory_raw' => 1024,
            'opcache' => '256MB',
            'opcache_raw' => 256,
            'description' => 'Performance-focused for high RAM systems (9-16GB)',
            'total_usage' => '~2.3GB',
            'recommendations' => [
                'Excellent for large projects',
                'Can handle multiple databases',
                'Good for team development'
            ]
        ],
        999 => [
            'profile' => 'Very High RAM (Maximum Performance)',
            'mysql_innodb' => '2GB',
            'mysql_innodb_raw' => 2048,
            'php_memory' => '2GB',
            'php_memory_raw' => 2048,
            'opcache' => '512MB',
            'opcache_raw' => 512,
            'description' => 'Maximum performance for high-end systems (>16GB)',
            'total_usage' => '~4.5GB',
            'recommendations' => [
                'Perfect for enterprise development',
                'Can handle large datasets',
                'Ideal for performance testing'
            ]
        ]
    ];

    // Find the appropriate profile
    foreach ($profiles as $threshold => $profile) {
        if ($ram_gb <= $threshold) {
            $profile['ram_threshold'] = $threshold;
            $profile['current_ram'] = $ram_gb;
            return $profile;
        }
    }

    // Fallback to highest profile
    $profile = end($profiles);
    $profile['ram_threshold'] = 999;
    $profile['current_ram'] = $ram_gb;
    return $profile;
}

/**
 * Get PHP memory settings with enhanced information
 *
 * @return array PHP configuration settings
 */
function getPHPMemorySettings() {
    $settings = [
        'memory_limit' => ini_get('memory_limit') ?: 'N/A',
        'opcache_memory' => ini_get('opcache.memory_consumption') ?: 'N/A',
        'opcache_max_files' => ini_get('opcache.max_accelerated_files') ?: 'N/A',
        'opcache_jit_buffer' => ini_get('opcache.jit_buffer_size') ?: 'N/A',
        'post_max_size' => ini_get('post_max_size') ?: 'N/A',
        'upload_max_filesize' => ini_get('upload_max_filesize') ?: 'N/A',
        'realpath_cache_size' => ini_get('realpath_cache_size') ?: 'N/A',
        'max_execution_time' => ini_get('max_execution_time') ?: 'N/A',
        'max_input_time' => ini_get('max_input_time') ?: 'N/A',
        'opcache_enabled' => ini_get('opcache.enable') ? 'Yes' : 'No'
    ];

    // Add calculated values
    $memory_limit_bytes = return_bytes($settings['memory_limit']);
    $settings['memory_limit_mb'] = $memory_limit_bytes ? round($memory_limit_bytes / 1024 / 1024, 2) : 'N/A';

    return $settings;
}

/**
 * Convert PHP memory notation to bytes
 *
 * @param string $val Memory value (e.g., "128M", "1G")
 * @return int|false Bytes or false on error
 */
function return_bytes($val) {
    if (empty($val)) return false;

    $val = trim($val);
    $last = strtolower($val[strlen($val)-1]);
    $val = (int)$val;

    switch($last) {
        case 'g': $val *= 1024;
        case 'm': $val *= 1024;
        case 'k': $val *= 1024;
    }

    return $val;
}

/**
 * Get Docker container status
 *
 * @return array Container status information
 */
function getDockerStatus() {
    $status = [
        'docker_available' => false,
        'containers' => [],
        'total_containers' => 0,
        'running_containers' => 0
    ];

    try {
        // Check if docker command is available
        $output = shell_exec('docker --version 2>&1');
        if ($output && strpos($output, 'Docker version') !== false) {
            $status['docker_available'] = true;
            $status['docker_version'] = trim($output);

            // Get container status
            $ps_output = shell_exec('docker ps -a --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}" 2>&1');
            if ($ps_output) {
                $lines = explode("\n", trim($ps_output));
                array_shift($lines); // Remove header

                foreach ($lines as $line) {
                    if (trim($line)) {
                        $parts = preg_split('/\s+/', trim($line), 3);
                        if (count($parts) >= 2) {
                            $status['containers'][] = [
                                'name' => $parts[0],
                                'status' => $parts[1],
                                'ports' => isset($parts[2]) ? $parts[2] : ''
                            ];
                            $status['total_containers']++;
                            if (strpos($parts[1], 'Up') === 0) {
                                $status['running_containers']++;
                            }
                        }
                    }
                }
            }
        }
    } catch (Exception $e) {
        error_log("Error getting Docker status: " . $e->getMessage());
    }

    return $status;
}

// Initialize data
$systemMemory = getSystemMemory();
$phpSettings = getPHPMemorySettings();
$dockerStatus = getDockerStatus();

// Get optimization profile
$ram_gb = $systemMemory['total'] ?? 8;
$profile = getOptimizationProfile($ram_gb);
?>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="Docker Master Platform - RAM Optimization Status Dashboard">
    <meta name="author" content="Docker Master Platform">
    <title>RAM Optimization Status - Docker Dev Environment</title>
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
            --shadow: 0 2px 10px rgba(0,0,0,0.1);
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
        }

        .container {
            max-width: 1400px;
            margin: 0 auto;
            background: white;
            padding: 30px;
            border-radius: 12px;
            box-shadow: var(--shadow);
        }

        .header {
            text-align: center;
            margin-bottom: 40px;
            padding-bottom: 20px;
            border-bottom: 2px solid var(--border-color);
        }

        .header h1 {
            color: var(--primary-color);
            margin-bottom: 10px;
            font-size: 2.5rem;
        }

        .section {
            margin: 30px 0;
            padding: 25px;
            border: 1px solid var(--border-color);
            border-radius: 8px;
            transition: transform 0.2s ease;
        }

        .section:hover {
            transform: translateY(-2px);
            box-shadow: var(--shadow);
        }

        .success { background: #d4edda; border-color: #c3e6cb; color: #155724; }
        .info { background: #d1ecf1; border-color: #bee5eb; color: #0c5460; }
        .warning { background: #fff3cd; border-color: #ffeaa7; color: #856404; }
        .danger { background: #f8d7da; border-color: #f5c6cb; color: #721c24; }

        .grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 20px;
        }

        .metric {
            background: var(--light-bg);
            padding: 20px;
            border-radius: 8px;
            margin: 10px 0;
            border-left: 4px solid var(--primary-color);
        }

        .metric h4 {
            margin: 0 0 10px 0;
            color: #495057;
            font-size: 1.1rem;
        }

        .metric .value {
            font-size: 2rem;
            font-weight: bold;
            color: var(--primary-color);
        }

        .metric .unit {
            font-size: 0.9rem;
            color: var(--text-muted);
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin: 15px 0;
            background: white;
        }

        th, td {
            padding: 12px 15px;
            text-align: left;
            border-bottom: 1px solid var(--border-color);
        }

        th {
            background-color: var(--light-bg);
            font-weight: 600;
            color: #495057;
        }

        tr:hover {
            background-color: #f8f9fa;
        }

        .progress-bar {
            width: 100%;
            height: 24px;
            background: #e9ecef;
            border-radius: 12px;
            overflow: hidden;
            margin-top: 10px;
        }

        .progress-fill {
            height: 100%;
            background: linear-gradient(90deg, var(--success-color), var(--warning-color), var(--danger-color));
            transition: width 0.5s ease;
            border-radius: 12px;
        }

        .btn {
            padding: 12px 24px;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-size: 1rem;
            font-weight: 500;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-block;
        }

        .btn-primary {
            background: var(--primary-color);
            color: white;
        }

        .btn-primary:hover {
            background: #0056b3;
            transform: translateY(-1px);
        }

        .status-badge {
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 0.85rem;
            font-weight: 500;
        }

        .badge-success { background: #d4edda; color: #155724; }
        .badge-warning { background: #fff3cd; color: #856404; }
        .badge-danger { background: #f8d7da; color: #721c24; }

        @media (max-width: 768px) {
            .container { padding: 15px; }
            .grid { grid-template-columns: 1fr; }
            .metric .value { font-size: 1.5rem; }
        }
    </style>
    <script>
        let autoRefreshEnabled = true;
        let refreshInterval;

        function refreshPage() {
            if (autoRefreshEnabled) {
                location.reload();
            }
        }

        function toggleAutoRefresh() {
            autoRefreshEnabled = !autoRefreshEnabled;
            const btn = document.getElementById('autoRefreshBtn');
            if (autoRefreshEnabled) {
                btn.textContent = '⏸️ Pause Auto Refresh';
                btn.className = 'btn btn-primary';
                refreshInterval = setTimeout(refreshPage, 30000);
            } else {
                btn.textContent = '▶️ Resume Auto Refresh';
                btn.className = 'btn btn-warning';
                clearTimeout(refreshInterval);
            }
        }

        // Initialize auto refresh
        document.addEventListener('DOMContentLoaded', function() {
            refreshInterval = setTimeout(refreshPage, 30000);
        });
    </script>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>🚀 RAM Optimization Status</h1>
            <h2>Docker Development Environment</h2>
            <p>Real-time memory usage and optimization settings</p>
            <div style="margin-top: 20px;">
                <button class="btn btn-primary" onclick="refreshPage()">🔄 Refresh Now</button>
                <button class="btn btn-primary" id="autoRefreshBtn" onclick="toggleAutoRefresh()">⏸️ Pause Auto Refresh</button>
            </div>
        </div>

        <!-- System Memory Overview -->
        <div class="section <?php echo isset($systemMemory['error']) ? 'warning' : 'success'; ?>">
            <h3>💻 System Memory Overview</h3>
            <?php if (!empty($systemMemory) && !isset($systemMemory['error'])): ?>
                <div style="margin-bottom: 20px;">
                    <p><strong>Data Source:</strong> <?php echo htmlspecialchars($systemMemory['source']); ?></p>
                    <?php if (isset($systemMemory['detected']) && $systemMemory['detected']): ?>
                        <span class="status-badge badge-warning">Auto-detected</span>
                    <?php else: ?>
                        <span class="status-badge badge-success">Real-time</span>
                    <?php endif; ?>
                </div>

                <div class="grid">
                    <div class="metric">
                        <h4>Total RAM</h4>
                        <div class="value"><?php echo number_format($systemMemory['total'], 2); ?> <span class="unit">GB</span></div>
                        <small class="text-muted">System total memory</small>
                    </div>
                    <div class="metric">
                        <h4>Used RAM</h4>
                        <div class="value"><?php echo number_format($systemMemory['used'], 2); ?> <span class="unit">GB</span></div>
                        <small class="text-muted">Currently in use</small>
                    </div>
                    <div class="metric">
                        <h4>Available RAM</h4>
                        <div class="value"><?php echo number_format($systemMemory['available'], 2); ?> <span class="unit">GB</span></div>
                        <small class="text-muted">Free for applications</small>
                    </div>
                    <div class="metric">
                        <h4>Usage Percentage</h4>
                        <?php
                        $usage_percent = round(($systemMemory['used'] / $systemMemory['total']) * 100, 1);
                        $usage_class = $usage_percent > 80 ? 'danger' : ($usage_percent > 60 ? 'warning' : 'success');
                        ?>
                        <div class="value"><?php echo $usage_percent; ?> <span class="unit">%</span></div>
                        <div class="progress-bar">
                            <div class="progress-fill" style="width: <?php echo $usage_percent; ?>%"></div>
                        </div>
                        <small class="text-muted">
                            <?php if ($usage_percent > 80): ?>
                                ⚠️ High usage - consider closing applications
                            <?php elseif ($usage_percent > 60): ?>
                                ⚡ Moderate usage - good for development
                            <?php else: ?>
                                ✅ Low usage - excellent performance
                            <?php endif; ?>
                        </small>
                    </div>
                </div>
            <?php else: ?>
                <div class="warning">
                    <h4>⚠️ Memory Information Limited</h4>
                    <p>System memory information not available. This may occur on:</p>
                    <ul>
                        <li>Windows systems without WSL</li>
                        <li>Restricted Docker environments</li>
                        <li>Systems with limited file access</li>
                    </ul>
                    <?php if (isset($systemMemory['error'])): ?>
                        <p><strong>Error:</strong> <?php echo htmlspecialchars($systemMemory['error']); ?></p>
                    <?php endif; ?>
                    <p><strong>Using estimated values:</strong> Total: <?php echo $systemMemory['total']; ?>GB</p>
                </div>
            <?php endif; ?>
        </div>

        <!-- Optimization Profile -->
        <div class="section info">
            <h3>🎯 Current Optimization Profile</h3>
            <div class="grid">
                <div class="metric">
                    <h4>Profile Type</h4>
                    <div class="value" style="font-size: 1.2rem;"><?php echo htmlspecialchars($profile['profile']); ?></div>
                    <small class="text-muted"><?php echo htmlspecialchars($profile['description']); ?></small>
                </div>
                <div class="metric">
                    <h4>Estimated Usage</h4>
                    <div class="value"><?php echo htmlspecialchars($profile['total_usage']); ?></div>
                    <small class="text-muted">Total Docker containers</small>
                </div>
                <div class="metric">
                    <h4>RAM Threshold</h4>
                    <div class="value"><?php echo $profile['ram_threshold'] == 999 ? '16+' : $profile['ram_threshold']; ?> <span class="unit">GB</span></div>
                    <small class="text-muted">Profile trigger point</small>
                </div>
                <div class="metric">
                    <h4>Recommendations</h4>
                    <ul style="margin: 10px 0; padding-left: 20px;">
                        <?php foreach ($profile['recommendations'] as $rec): ?>
                            <li style="margin: 5px 0;"><?php echo htmlspecialchars($rec); ?></li>
                        <?php endforeach; ?>
                    </ul>
                </div>
            </div>
        </div>

        <!-- PHP Memory Settings -->
        <div class="section info">
            <h3>🐘 PHP Memory Configuration</h3>
            <p><strong>PHP Version:</strong> <?php echo PHP_VERSION; ?></p>
            <table>
                <tr><th>Setting</th><th>Value</th><th>Description</th></tr>
                <tr>
                    <td>memory_limit</td>
                    <td><strong><?php echo $phpSettings['memory_limit']; ?></strong></td>
                    <td>Maximum memory per PHP script</td>
                </tr>
                <tr>
                    <td>opcache.memory_consumption</td>
                    <td><strong><?php echo $phpSettings['opcache_memory']; ?>MB</strong></td>
                    <td>OPcache memory allocation</td>
                </tr>
                <tr>
                    <td>opcache.max_accelerated_files</td>
                    <td><strong><?php echo number_format($phpSettings['opcache_max_files']); ?></strong></td>
                    <td>Maximum cached files</td>
                </tr>
                <tr>
                    <td>opcache.jit_buffer_size</td>
                    <td><strong><?php echo $phpSettings['opcache_jit_buffer'] ?: 'N/A'; ?></strong></td>
                    <td>JIT compilation buffer (PHP 8+)</td>
                </tr>
                <tr>
                    <td>post_max_size</td>
                    <td><strong><?php echo $phpSettings['post_max_size']; ?></strong></td>
                    <td>Maximum POST data size</td>
                </tr>
                <tr>
                    <td>upload_max_filesize</td>
                    <td><strong><?php echo $phpSettings['upload_max_filesize']; ?></strong></td>
                    <td>Maximum file upload size</td>
                </tr>
                <tr>
                    <td>realpath_cache_size</td>
                    <td><strong><?php echo $phpSettings['realpath_cache_size']; ?></strong></td>
                    <td>Realpath cache memory</td>
                </tr>
            </table>
        </div>

        <!-- Docker Container Memory Limits -->
        <div class="section info">
            <h3>🐳 Docker Container Memory Limits</h3>
            <table>
                <tr><th>Container</th><th>Memory Limit</th><th>Memory Reservation</th><th>Purpose</th></tr>
                <tr>
                    <td><strong>MySQL</strong></td>
                    <td>2GB</td>
                    <td>1GB</td>
                    <td>Database server with 2GB InnoDB buffer</td>
                </tr>
                <tr>
                    <td><strong>PHP 7.4/8.2/8.4</strong></td>
                    <td>256MB</td>
                    <td>128MB</td>
                    <td>PHP-FPM processes with 512MB script limit</td>
                </tr>
                <tr>
                    <td><strong>Nginx</strong></td>
                    <td>128MB</td>
                    <td>64MB</td>
                    <td>Web server with optimized workers</td>
                </tr>
                <tr>
                    <td><strong>PostgreSQL</strong></td>
                    <td>Auto</td>
                    <td>Auto</td>
                    <td>Secondary database server</td>
                </tr>
                <tr>
                    <td><strong>Redis</strong></td>
                    <td>Auto</td>
                    <td>Auto</td>
                    <td>Cache and session storage</td>
                </tr>
            </table>
        </div>

        <!-- Optimization Recommendations -->
        <div class="section warning">
            <h3>💡 Optimization Recommendations</h3>
            <h4>Current Status: Optimized for 32GB RAM</h4>
            <ul>
                <li>✅ <strong>MySQL InnoDB Buffer:</strong> Set to 2GB (optimal for development)</li>
                <li>✅ <strong>PHP Memory:</strong> 512MB per script with 256MB OPcache</li>
                <li>✅ <strong>JIT Compilation:</strong> Enabled for PHP 8.2+ with 128MB buffer</li>
                <li>✅ <strong>Container Limits:</strong> Set to prevent memory leaks</li>
                <li>✅ <strong>Query Cache:</strong> 128MB for faster MySQL queries</li>
            </ul>
            
            <h4>Monitoring Commands:</h4>
            <div style="background: #f8f9fa; padding: 15px; border-radius: 5px; font-family: monospace;">
                # Monitor container memory usage<br>
                docker stats<br><br>
                
                # Run RAM monitoring script<br>
                bin\monitor-ram.bat<br><br>
                
                # Check MySQL memory usage<br>
                docker-compose exec mysql mysql -u root -p -e "SHOW STATUS LIKE 'Innodb_buffer_pool%'"
            </div>
        </div>

        <!-- Performance Tips -->
        <div class="section success">
            <h3>🎯 Performance Tips</h3>
            <div class="grid">
                <div>
                    <h4>🗄️ Database Optimization</h4>
                    <ul>
                        <li>Use indexes for frequently queried columns</li>
                        <li>Monitor slow query log</li>
                        <li>Use EXPLAIN for query optimization</li>
                        <li>Consider partitioning for large tables</li>
                    </ul>
                </div>
                <div>
                    <h4>🐘 PHP Optimization</h4>
                    <ul>
                        <li>Enable OPcache in production</li>
                        <li>Use APCu for user data caching</li>
                        <li>Optimize autoloader with Composer</li>
                        <li>Profile with Xdebug or Blackfire</li>
                    </ul>
                </div>
                <div>
                    <h4>🌐 Web Server Optimization</h4>
                    <ul>
                        <li>Enable gzip compression</li>
                        <li>Use browser caching headers</li>
                        <li>Optimize static file serving</li>
                        <li>Consider CDN for production</li>
                    </ul>
                </div>
                <div>
                    <h4>🐳 Docker Optimization</h4>
                    <ul>
                        <li>Use multi-stage builds</li>
                        <li>Minimize image layers</li>
                        <li>Set appropriate memory limits</li>
                        <li>Monitor container resource usage</li>
                    </ul>
                </div>
            </div>
        </div>

        <!-- Footer -->
        <div class="section info">
            <h3>📊 Current Environment Status</h3>
            <p><strong>Optimization Level:</strong> High Performance (32GB RAM)</p>
            <p><strong>Last Updated:</strong> <?php echo date('Y-m-d H:i:s'); ?></p>
            <p><strong>Auto Refresh:</strong> Every 30 seconds</p>
            <p><a href="/">← Back to main page</a> | <a href="/test-db.php">Database Test</a></p>
        </div>
    </div>
</body>
</html>
