<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>PostgreSQL Complete Guide - Docker Master Platform</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { 
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; 
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: #333;
            line-height: 1.6;
        }
        .container { 
            max-width: 1200px; 
            margin: 0 auto; 
            padding: 20px;
        }
        .header {
            background: rgba(255,255,255,0.95);
            padding: 30px;
            border-radius: 15px;
            margin-bottom: 30px;
            text-align: center;
            backdrop-filter: blur(10px);
            box-shadow: 0 8px 32px rgba(0,0,0,0.1);
        }
        .header h1 {
            color: #2c3e50;
            font-size: 2.5em;
            margin-bottom: 10px;
        }
        .header p {
            color: #7f8c8d;
            font-size: 1.2em;
        }
        .grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(350px, 1fr));
            gap: 25px;
            margin-bottom: 30px;
        }
        .card {
            background: rgba(255,255,255,0.95);
            padding: 25px;
            border-radius: 15px;
            backdrop-filter: blur(10px);
            box-shadow: 0 8px 32px rgba(0,0,0,0.1);
            transition: transform 0.3s ease;
        }
        .card:hover {
            transform: translateY(-5px);
        }
        .card h3 {
            color: #2c3e50;
            margin-bottom: 15px;
            font-size: 1.4em;
            border-bottom: 2px solid #3498db;
            padding-bottom: 8px;
        }
        .status {
            padding: 12px;
            margin: 15px 0;
            border-radius: 8px;
            font-weight: bold;
        }
        .success { background: #d4edda; color: #155724; border-left: 4px solid #28a745; }
        .error { background: #f8d7da; color: #721c24; border-left: 4px solid #dc3545; }
        .info { background: #d1ecf1; color: #0c5460; border-left: 4px solid #17a2b8; }
        .warning { background: #fff3cd; color: #856404; border-left: 4px solid #ffc107; }
        .code-block {
            background: #2c3e50;
            color: #ecf0f1;
            padding: 20px;
            border-radius: 8px;
            margin: 15px 0;
            overflow-x: auto;
            font-family: 'Courier New', monospace;
            position: relative;
        }
        .code-block::before {
            content: "💻 Command";
            position: absolute;
            top: -10px;
            left: 15px;
            background: #3498db;
            color: white;
            padding: 2px 8px;
            border-radius: 4px;
            font-size: 0.8em;
        }
        .copy-btn {
            position: absolute;
            top: 10px;
            right: 10px;
            background: #3498db;
            color: white;
            border: none;
            padding: 5px 10px;
            border-radius: 4px;
            cursor: pointer;
            font-size: 0.8em;
        }
        .copy-btn:hover { background: #2980b9; }
        .nav-links {
            background: rgba(255,255,255,0.95);
            padding: 20px;
            border-radius: 15px;
            text-align: center;
            backdrop-filter: blur(10px);
            box-shadow: 0 8px 32px rgba(0,0,0,0.1);
        }
        .nav-links a {
            display: inline-block;
            margin: 0 15px;
            padding: 10px 20px;
            background: #3498db;
            color: white;
            text-decoration: none;
            border-radius: 25px;
            transition: all 0.3s ease;
        }
        .nav-links a:hover {
            background: #2980b9;
            transform: translateY(-2px);
        }
        .credentials {
            background: linear-gradient(45deg, #2c3e50, #34495e);
            color: white;
            padding: 20px;
            border-radius: 10px;
            margin: 15px 0;
        }
        .credentials h4 {
            color: #3498db;
            margin-bottom: 10px;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin: 15px 0;
        }
        th, td {
            padding: 12px;
            text-align: left;
            border-bottom: 1px solid #ddd;
        }
        th {
            background: #3498db;
            color: white;
        }
        tr:hover { background: #f5f5f5; }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>🐘 PostgreSQL Complete Guide</h1>
            <p>Docker Master Platform - Professional Database Management</p>
            <p><strong>Current Time:</strong> <?= date('Y-m-d H:i:s') ?></p>
        </div>

        <!-- Connection Status -->
        <div class="card">
            <h3>🔌 Connection Status</h3>
            <?php
            try {
                $pdo = new PDO('pgsql:host=postgres_low_ram;port=5432;dbname=docker_master', 'postgres_user', 'postgres_pass');
                echo '<div class="status success">✅ PostgreSQL Connected Successfully!</div>';
                
                $stmt = $pdo->query("SELECT version()");
                $version = $stmt->fetchColumn();
                echo '<div class="info">📊 ' . htmlspecialchars($version) . '</div>';
                
                $stmt = $pdo->query("SELECT current_database(), current_user, inet_server_addr(), inet_server_port()");
                $info = $stmt->fetch(PDO::FETCH_ASSOC);
                echo '<div class="info">';
                echo '🗄️ <strong>Database:</strong> ' . $info['current_database'] . '<br>';
                echo '👤 <strong>User:</strong> ' . $info['current_user'] . '<br>';
                echo '🌐 <strong>Server:</strong> ' . ($info['inet_server_addr'] ?: 'localhost') . ':' . ($info['inet_server_port'] ?: '5432');
                echo '</div>';
                
            } catch (Exception $e) {
                echo '<div class="status error">❌ PostgreSQL Connection Failed: ' . htmlspecialchars($e->getMessage()) . '</div>';
            }
            ?>
        </div>

        <div class="grid">
            <!-- Credentials -->
            <div class="card">
                <h3>🔑 Connection Credentials</h3>
                <div class="credentials">
                    <h4>Main Database</h4>
                    <strong>Host:</strong> localhost<br>
                    <strong>Port:</strong> 5432<br>
                    <strong>Database:</strong> docker_master<br>
                    <strong>Username:</strong> postgres_user<br>
                    <strong>Password:</strong> postgres_pass<br>
                </div>
                
                <div class="credentials">
                    <h4>Laravel PHP 8.4 Database</h4>
                    <strong>Database:</strong> laravel_php84_psql<br>
                    <strong>Username:</strong> postgres_user<br>
                    <strong>Password:</strong> postgres_pass<br>
                </div>
                
                <div class="credentials">
                    <h4>Laravel PHP 7.4 Database</h4>
                    <strong>Database:</strong> laravel_php74_psql<br>
                    <strong>Username:</strong> postgres_user<br>
                    <strong>Password:</strong> postgres_pass<br>
                </div>
            </div>

            <!-- Quick Commands -->
            <div class="card">
                <h3>⚡ Quick Commands</h3>
                
                <h4>Connect to PostgreSQL</h4>
                <div class="code-block">
                    <button class="copy-btn" onclick="copyToClipboard(this)">Copy</button>
docker exec -it postgres_low_ram psql -U postgres_user -d docker_master
                </div>
                
                <h4>List All Databases</h4>
                <div class="code-block">
                    <button class="copy-btn" onclick="copyToClipboard(this)">Copy</button>
docker exec postgres_low_ram psql -U postgres_user -l
                </div>
                
                <h4>Execute SQL Query</h4>
                <div class="code-block">
                    <button class="copy-btn" onclick="copyToClipboard(this)">Copy</button>
docker exec postgres_low_ram psql -U postgres_user -d docker_master -c "SELECT version();"
                </div>
            </div>
        </div>

        <div class="grid">
            <!-- Database Operations -->
            <div class="card">
                <h3>🗄️ Database Operations</h3>
                
                <h4>Create New Database</h4>
                <div class="code-block">
                    <button class="copy-btn" onclick="copyToClipboard(this)">Copy</button>
docker exec postgres_low_ram createdb -U postgres_user your_database_name
                </div>
                
                <h4>Drop Database</h4>
                <div class="code-block">
                    <button class="copy-btn" onclick="copyToClipboard(this)">Copy</button>
docker exec postgres_low_ram dropdb -U postgres_user your_database_name
                </div>
                
                <h4>Create User</h4>
                <div class="code-block">
                    <button class="copy-btn" onclick="copyToClipboard(this)">Copy</button>
docker exec postgres_low_ram psql -U postgres_user -c "CREATE USER newuser WITH PASSWORD 'password';"
                </div>
                
                <h4>Grant Privileges</h4>
                <div class="code-block">
                    <button class="copy-btn" onclick="copyToClipboard(this)">Copy</button>
docker exec postgres_low_ram psql -U postgres_user -c "GRANT ALL PRIVILEGES ON DATABASE your_db TO newuser;"
                </div>
            </div>

            <!-- Backup & Restore -->
            <div class="card">
                <h3>💾 Backup & Restore</h3>
                
                <h4>Full Database Backup</h4>
                <div class="code-block">
                    <button class="copy-btn" onclick="copyToClipboard(this)">Copy</button>
docker exec postgres_low_ram pg_dump -U postgres_user docker_master > backup_$(date +%Y%m%d_%H%M%S).sql
                </div>
                
                <h4>Backup with Custom Format</h4>
                <div class="code-block">
                    <button class="copy-btn" onclick="copyToClipboard(this)">Copy</button>
docker exec postgres_low_ram pg_dump -U postgres_user -Fc docker_master > backup.dump
                </div>
                
                <h4>Restore from SQL File</h4>
                <div class="code-block">
                    <button class="copy-btn" onclick="copyToClipboard(this)">Copy</button>
docker exec -i postgres_low_ram psql -U postgres_user docker_master < backup.sql
                </div>
                
                <h4>Restore from Custom Format</h4>
                <div class="code-block">
                    <button class="copy-btn" onclick="copyToClipboard(this)">Copy</button>
docker exec postgres_low_ram pg_restore -U postgres_user -d docker_master backup.dump
                </div>
            </div>
        </div>

        <div class="grid">
            <!-- Monitoring -->
            <div class="card">
                <h3>📊 Monitoring & Performance</h3>
                
                <h4>Show Active Connections</h4>
                <div class="code-block">
                    <button class="copy-btn" onclick="copyToClipboard(this)">Copy</button>
docker exec postgres_low_ram psql -U postgres_user -c "SELECT * FROM pg_stat_activity;"
                </div>
                
                <h4>Database Size</h4>
                <div class="code-block">
                    <button class="copy-btn" onclick="copyToClipboard(this)">Copy</button>
docker exec postgres_low_ram psql -U postgres_user -c "SELECT pg_size_pretty(pg_database_size('docker_master'));"
                </div>
                
                <h4>Table Sizes</h4>
                <div class="code-block">
                    <button class="copy-btn" onclick="copyToClipboard(this)">Copy</button>
docker exec postgres_low_ram psql -U postgres_user -d docker_master -c "SELECT schemaname,tablename,pg_size_pretty(pg_total_relation_size(schemaname||'.'||tablename)) as size FROM pg_tables ORDER BY pg_total_relation_size(schemaname||'.'||tablename) DESC;"
                </div>
            </div>

            <!-- Laravel Integration -->
            <div class="card">
                <h3>🚀 Laravel Integration</h3>
                
                <h4>Laravel .env Configuration</h4>
                <div class="code-block">
                    <button class="copy-btn" onclick="copyToClipboard(this)">Copy</button>
DB_CONNECTION=pgsql
DB_HOST=localhost
DB_PORT=5432
DB_DATABASE=laravel_php84_psql
DB_USERNAME=postgres_user
DB_PASSWORD=postgres_pass
                </div>
                
                <h4>Laravel Migration Commands</h4>
                <div class="code-block">
                    <button class="copy-btn" onclick="copyToClipboard(this)">Copy</button>
# Run migrations
php artisan migrate

# Fresh migration with seeding
php artisan migrate:fresh --seed

# Rollback migrations
php artisan migrate:rollback
                </div>
            </div>
        </div>

        <!-- Available Databases -->
        <div class="card">
            <h3>🗃️ Available Databases</h3>
            <?php
            try {
                $pdo = new PDO('pgsql:host=postgres_low_ram;port=5432;dbname=docker_master', 'postgres_user', 'postgres_pass');
                $stmt = $pdo->query("SELECT datname, pg_size_pretty(pg_database_size(datname)) as size FROM pg_database WHERE datistemplate = false ORDER BY datname;");
                $databases = $stmt->fetchAll(PDO::FETCH_ASSOC);
                
                echo '<table>';
                echo '<tr><th>Database Name</th><th>Size</th><th>Purpose</th></tr>';
                
                foreach ($databases as $db) {
                    $purpose = '';
                    switch ($db['datname']) {
                        case 'docker_master':
                            $purpose = 'Main platform database';
                            break;
                        case 'laravel_php84_psql':
                            $purpose = 'Laravel PHP 8.4 projects';
                            break;
                        case 'laravel_php74_psql':
                            $purpose = 'Laravel PHP 7.4 projects';
                            break;
                        default:
                            $purpose = 'System/User database';
                    }
                    
                    echo '<tr>';
                    echo '<td><strong>' . htmlspecialchars($db['datname']) . '</strong></td>';
                    echo '<td>' . htmlspecialchars($db['size']) . '</td>';
                    echo '<td>' . $purpose . '</td>';
                    echo '</tr>';
                }
                echo '</table>';
                
            } catch (Exception $e) {
                echo '<div class="status error">❌ Could not fetch database list: ' . htmlspecialchars($e->getMessage()) . '</div>';
            }
            ?>
        </div>

        <!-- Navigation -->
        <div class="nav-links">
            <a href="/">🏠 Dashboard</a>
            <a href="/db-status.php">📊 Database Status</a>
            <a href="http://localhost:8081" target="_blank">🐘 pgAdmin</a>
            <a href="http://localhost:8080" target="_blank">📊 phpMyAdmin</a>
            <a href="/redis-test.php">🔴 Redis Test</a>
        </div>
    </div>

    <script>
        function copyToClipboard(button) {
            const codeBlock = button.parentElement;
            const text = codeBlock.textContent.replace('Copy', '').trim();
            
            navigator.clipboard.writeText(text).then(function() {
                button.textContent = 'Copied!';
                button.style.background = '#27ae60';
                
                setTimeout(function() {
                    button.textContent = 'Copy';
                    button.style.background = '#3498db';
                }, 2000);
            });
        }
    </script>
</body>
</html>
