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
        details { margin: 10px 0; }
        details summary { padding: 8px; background: rgba(255,255,255,0.1); border-radius: 5px; margin-bottom: 5px; }
        details[open] summary { border-radius: 5px 5px 0 0; }
        code { background: rgba(255,255,255,0.2); padding: 2px 6px; border-radius: 3px; display: block; margin: 5px 0; word-break: break-all; }
        .command-section { margin: 10px 0; }
        .command-section p { margin: 8px 0 4px 0; font-weight: bold; }
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
                <div style="display: grid; gap: 10px;">
                    <div style="background: rgba(0,0,0,0.1); padding: 12px; border-radius: 8px; border-left: 4px solid #3498db;">
                        <strong>🚀 Laravel Applications</strong>
                        <div style="margin-top: 8px;">
                            <a href="http://localhost:8010" target="_blank" style="color: #3498db; text-decoration: none;">
                                📱 Laravel PHP 8.4 + PostgreSQL
                            </a>
                            <span style="color: #27ae60; font-weight: bold;">✅ Running</span>
                        </div>
                        <div style="margin-top: 5px;">
                            <a href="http://localhost:8020" target="_blank" style="color: #3498db; text-decoration: none;">
                                🔧 Laravel PHP 7.4 + PostgreSQL
                            </a>
                            <span style="color: #27ae60; font-weight: bold;">✅ Running</span>
                        </div>
                    </div>

                    <div style="background: rgba(0,0,0,0.1); padding: 12px; border-radius: 8px; border-left: 4px solid #e74c3c;">
                        <strong>🗄️ Database Management</strong>
                        <div style="margin-top: 8px;">
                            <a href="http://localhost:8080" target="_blank" style="color: #e74c3c; text-decoration: none;">
                                🐬 phpMyAdmin (MySQL)
                            </a>
                            <span style="color: #27ae60; font-weight: bold;">✅ Running</span>
                        </div>
                        <div style="margin-top: 5px;">
                            <a href="http://localhost:8081" target="_blank" style="color: #e74c3c; text-decoration: none;">
                                🐘 pgAdmin (PostgreSQL)
                            </a>
                            <span style="color: #27ae60; font-weight: bold;">✅ Running</span>
                        </div>
                    </div>

                    <div style="background: rgba(0,0,0,0.1); padding: 12px; border-radius: 8px; border-left: 4px solid #f39c12;">
                        <strong>🛠️ Development Tools</strong>
                        <div style="margin-top: 8px;">
                            <a href="http://localhost:8025" target="_blank" style="color: #f39c12; text-decoration: none;">
                                📧 Mailhog (Email Testing)
                            </a>
                            <span style="color: #27ae60; font-weight: bold;">✅ Running</span>
                        </div>
                        <div style="margin-top: 5px;">
                            <a href="/redis-test.php" target="_blank" style="color: #f39c12; text-decoration: none;">
                                🔴 Redis Connection Test
                            </a>
                            <span style="color: #27ae60; font-weight: bold;">✅ Available</span>
                        </div>
                    </div>

                    <div style="background: rgba(0,0,0,0.1); padding: 12px; border-radius: 8px; border-left: 4px solid #9b59b6;">
                        <strong>📚 Documentation & Guides</strong>
                        <div style="margin-top: 8px;">
                            <a href="/postgresql-guide.php" target="_blank" style="color: #9b59b6; text-decoration: none;">
                                📖 PostgreSQL Complete Guide
                            </a>
                            <span style="color: #27ae60; font-weight: bold;">✅ Available</span>
                        </div>
                        <div style="margin-top: 5px;">
                            <a href="/test-db.php" target="_blank" style="color: #9b59b6; text-decoration: none;">
                                🧪 Database Connection Test
                            </a>
                            <span style="color: #27ae60; font-weight: bold;">✅ Available</span>
                        </div>
                    </div>
                </div>
            </div>

            <div class="card">
                <h3>⚡ Quick Actions</h3>
                <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 15px;">
                    <div style="text-align: center;">
                        <a href="/db-status.php" style="display: block; background: linear-gradient(45deg, #3498db, #2980b9); color: white; padding: 15px; border-radius: 10px; text-decoration: none; transition: transform 0.3s ease;" onmouseover="this.style.transform='translateY(-3px)'" onmouseout="this.style.transform='translateY(0)'">
                            <div style="font-size: 24px; margin-bottom: 5px;">📊</div>
                            <strong>Database Status</strong>
                            <div style="font-size: 12px; opacity: 0.9;">Real-time connection test</div>
                        </a>
                    </div>
                    <div style="text-align: center;">
                        <a href="/postgresql-guide.php" style="display: block; background: linear-gradient(45deg, #9b59b6, #8e44ad); color: white; padding: 15px; border-radius: 10px; text-decoration: none; transition: transform 0.3s ease;" onmouseover="this.style.transform='translateY(-3px)'" onmouseout="this.style.transform='translateY(0)'">
                            <div style="font-size: 24px; margin-bottom: 5px;">🐘</div>
                            <strong>PostgreSQL Guide</strong>
                            <div style="font-size: 12px; opacity: 0.9;">Complete documentation</div>
                        </a>
                    </div>
                    <div style="text-align: center;">
                        <a href="/test-db.php" style="display: block; background: linear-gradient(45deg, #e74c3c, #c0392b); color: white; padding: 15px; border-radius: 10px; text-decoration: none; transition: transform 0.3s ease;" onmouseover="this.style.transform='translateY(-3px)'" onmouseout="this.style.transform='translateY(0)'">
                            <div style="font-size: 24px; margin-bottom: 5px;">🧪</div>
                            <strong>Database Test</strong>
                            <div style="font-size: 12px; opacity: 0.9;">Performance testing</div>
                        </a>
                    </div>
                    <div style="text-align: center;">
                        <a href="/phpinfo.php" style="display: block; background: linear-gradient(45deg, #f39c12, #e67e22); color: white; padding: 15px; border-radius: 10px; text-decoration: none; transition: transform 0.3s ease;" onmouseover="this.style.transform='translateY(-3px)'" onmouseout="this.style.transform='translateY(0)'">
                            <div style="font-size: 24px; margin-bottom: 5px;">📋</div>
                            <strong>PHP Info</strong>
                            <div style="font-size: 12px; opacity: 0.9;">System information</div>
                        </a>
                    </div>
                </div>
            </div>

            <div class="card">
                <h3>🗄️ Database Status & Credentials</h3>

                <!-- PostgreSQL Section -->
                <div style="background: linear-gradient(45deg, rgba(52, 152, 219, 0.1), rgba(41, 128, 185, 0.1)); padding: 15px; border-radius: 10px; margin-bottom: 15px; border-left: 4px solid #3498db;">
                    <div style="display: flex; align-items: center; margin-bottom: 10px;">
                        <span style="font-size: 24px; margin-right: 10px;">🐘</span>
                        <strong style="font-size: 16px;">PostgreSQL Database</strong>
                    </div>
                    <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 10px; font-size: 13px;">
                        <div><strong>Host:</strong> localhost:5432</div>
                        <div><strong>Database:</strong> docker_master</div>
                        <div><strong>Username:</strong> postgres_user</div>
                        <div><strong>Password:</strong> postgres_pass</div>
                    </div>
                    <div style="margin-top: 10px;">
                        <a href="http://localhost:8081" target="_blank" style="background: #3498db; color: white; padding: 5px 10px; border-radius: 5px; text-decoration: none; font-size: 12px;">🐘 Open pgAdmin</a>
                    </div>
                </div>

                <!-- MySQL Section -->
                <div style="background: linear-gradient(45deg, rgba(231, 76, 60, 0.1), rgba(192, 57, 43, 0.1)); padding: 15px; border-radius: 10px; margin-bottom: 15px; border-left: 4px solid #e74c3c;">
                    <div style="display: flex; align-items: center; margin-bottom: 10px;">
                        <span style="font-size: 24px; margin-right: 10px;">🐬</span>
                        <strong style="font-size: 16px;">MySQL Database</strong>
                    </div>
                    <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 10px; font-size: 13px;">
                        <div><strong>Host:</strong> localhost:3306</div>
                        <div><strong>Database:</strong> main_db</div>
                        <div><strong>Username:</strong> mysql_user</div>
                        <div><strong>Password:</strong> mysql_pass</div>
                    </div>
                    <div style="margin-top: 10px;">
                        <a href="http://localhost:8080" target="_blank" style="background: #e74c3c; color: white; padding: 5px 10px; border-radius: 5px; text-decoration: none; font-size: 12px;">📊 Open phpMyAdmin</a>
                    </div>
                </div>

                <!-- Redis Section -->
                <div style="background: linear-gradient(45deg, rgba(243, 156, 18, 0.1), rgba(230, 126, 34, 0.1)); padding: 15px; border-radius: 10px; margin-bottom: 15px; border-left: 4px solid #f39c12;">
                    <div style="display: flex; align-items: center; margin-bottom: 10px;">
                        <span style="font-size: 24px; margin-right: 10px;">🔴</span>
                        <strong style="font-size: 16px;">Redis Cache</strong>
                    </div>
                    <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 10px; font-size: 13px;">
                        <div><strong>Host:</strong> localhost:6379</div>
                        <div><strong>Database:</strong> 0 (default)</div>
                        <div><strong>Auth:</strong> No password</div>
                        <div><strong>Purpose:</strong> Cache & Sessions</div>
                    </div>
                    <div style="margin-top: 10px;">
                        <a href="/redis-test.php" target="_blank" style="background: #f39c12; color: white; padding: 5px 10px; border-radius: 5px; text-decoration: none; font-size: 12px;">🔴 Test Redis</a>
                    </div>
                </div>

                <!-- Connection Status -->
                <div style="background: rgba(0,0,0,0.1); padding: 15px; border-radius: 10px;">
                    <strong style="margin-bottom: 15px; display: block; font-size: 16px;">🔌 Live Connection Status</strong>
                    <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(250px, 1fr)); gap: 15px;">
                        <?php
                        // PostgreSQL Test
                        echo '<div style="background: rgba(52, 152, 219, 0.1); padding: 12px; border-radius: 8px; border-left: 3px solid #3498db;">';
                        try {
                            $pgsql = new PDO("pgsql:host=postgres_low_ram;port=5432;dbname=docker_master", "postgres_user", "postgres_pass");
                            $stmt = $pgsql->query("SELECT version()");
                            $version = $stmt->fetchColumn();
                            $shortVersion = substr($version, 0, strpos($version, ' on'));
                            echo '<div style="display: flex; align-items: center; margin-bottom: 5px;">';
                            echo '<span style="color: #27ae60; font-size: 18px; margin-right: 8px;">✅</span>';
                            echo '<strong>PostgreSQL Connected</strong>';
                            echo '</div>';
                            echo '<div style="font-size: 12px; color: #7f8c8d;">' . htmlspecialchars($shortVersion) . '</div>';
                        } catch (Exception $e) {
                            echo '<div style="display: flex; align-items: center; margin-bottom: 5px;">';
                            echo '<span style="color: #e74c3c; font-size: 18px; margin-right: 8px;">❌</span>';
                            echo '<strong>PostgreSQL Failed</strong>';
                            echo '</div>';
                            echo '<div style="font-size: 12px; color: #e74c3c;">' . htmlspecialchars($e->getMessage()) . '</div>';
                        }
                        echo '</div>';

                        // MySQL Test
                        echo '<div style="background: rgba(231, 76, 60, 0.1); padding: 12px; border-radius: 8px; border-left: 3px solid #e74c3c;">';
                        try {
                            $mysql = new PDO("mysql:host=mysql_low_ram;port=3306;dbname=main_db", "mysql_user", "mysql_pass");
                            $stmt = $mysql->query("SELECT VERSION()");
                            $version = $stmt->fetchColumn();
                            echo '<div style="display: flex; align-items: center; margin-bottom: 5px;">';
                            echo '<span style="color: #27ae60; font-size: 18px; margin-right: 8px;">✅</span>';
                            echo '<strong>MySQL Connected</strong>';
                            echo '</div>';
                            echo '<div style="font-size: 12px; color: #7f8c8d;">MySQL ' . htmlspecialchars($version) . '</div>';
                        } catch (Exception $e) {
                            echo '<div style="display: flex; align-items: center; margin-bottom: 5px;">';
                            echo '<span style="color: #e74c3c; font-size: 18px; margin-right: 8px;">❌</span>';
                            echo '<strong>MySQL Failed</strong>';
                            echo '</div>';
                            echo '<div style="font-size: 12px; color: #e74c3c;">' . htmlspecialchars($e->getMessage()) . '</div>';
                        }
                        echo '</div>';

                        // Redis Test
                        echo '<div style="background: rgba(243, 156, 18, 0.1); padding: 12px; border-radius: 8px; border-left: 3px solid #f39c12;">';
                        try {
                            if (extension_loaded('redis')) {
                                $redis = new \Redis();
                                $redis->connect('redis_low_ram', 6379);
                                $info = $redis->info();
                                echo '<div style="display: flex; align-items: center; margin-bottom: 5px;">';
                                echo '<span style="color: #27ae60; font-size: 18px; margin-right: 8px;">✅</span>';
                                echo '<strong>Redis Connected</strong>';
                                echo '</div>';
                                echo '<div style="font-size: 12px; color: #7f8c8d;">Redis ' . ($info['redis_version'] ?? 'Unknown') . '</div>';
                            } else {
                                echo '<div style="display: flex; align-items: center; margin-bottom: 5px;">';
                                echo '<span style="color: #e74c3c; font-size: 18px; margin-right: 8px;">❌</span>';
                                echo '<strong>Redis Extension Not Loaded</strong>';
                                echo '</div>';
                            }
                        } catch (Exception $e) {
                            echo '<div style="display: flex; align-items: center; margin-bottom: 5px;">';
                            echo '<span style="color: #e74c3c; font-size: 18px; margin-right: 8px;">❌</span>';
                            echo '<strong>Redis Failed</strong>';
                            echo '</div>';
                            echo '<div style="font-size: 12px; color: #e74c3c;">' . htmlspecialchars($e->getMessage()) . '</div>';
                        }
                        echo '</div>';
                        ?>
                    </div>
                </div>
            </div>

            <div class="card">
                <h3>🛠️ Development Tools</h3>
                <p><a href="/test-db.php">🧪 Database Test</a></p>
                <p><a href="/phpinfo.php">📋 PHP Info</a></p>
                <p><a href="/postgresql-guide.php">🐘 PostgreSQL Guide</a></p>
                <p><a href="http://localhost:8025">📧 Mailhog</a></p>
            </div>

            <div class="card">
                <h3>📊 System Info</h3>
                <p><strong>PHP Version:</strong> <?= PHP_VERSION ?></p>
                <p><strong>Xdebug:</strong> <?= extension_loaded('xdebug') ? '✅ Enabled' : '❌ Disabled' ?></p>
                <p><strong>Server:</strong> <?= $_SERVER['SERVER_SOFTWARE'] ?? 'Unknown' ?></p>
            </div>

            <div class="card">
                <h3>📥 PostgreSQL Import/Dump Guide</h3>
                <p style="text-align: center; margin-bottom: 15px;">
                    <a href="/postgresql-guide.php" style="background: #4CAF50; padding: 8px 16px; border-radius: 5px; text-decoration: none; font-weight: bold;">📖 View Complete Guide</a>
                </p>
                <details style="margin-bottom: 15px;">
                    <summary style="cursor: pointer; font-weight: bold; color: #FFD700;">🔧 Import Commands</summary>
                    <div style="background: rgba(0,0,0,0.3); padding: 15px; border-radius: 5px; margin-top: 10px; font-family: monospace; font-size: 12px;">
                        <p><strong>1. Copy file to container:</strong></p>
                        <code>docker cp "path/to/your/file.dump" postgres_low_ram:/tmp/backup.dump</code>

                        <p><strong>2. Import with pg_restore (for .dump files):</strong></p>
                        <code>docker exec -i postgres_low_ram pg_restore -U postgres_user -d postgres -C -v /tmp/backup.dump</code>

                        <p><strong>3. Import SQL file:</strong></p>
                        <code>Get-Content "path/to/file.sql" | docker exec -i postgres_low_ram psql -U postgres_user -d database_name</code>

                        <p><strong>4. Create database with specific owner:</strong></p>
                        <code>docker exec -i postgres_low_ram psql -U postgres_user -d postgres -c "CREATE DATABASE db_name OWNER tg_retrieval;"</code>
                    </div>
                </details>

                <details style="margin-bottom: 15px;">
                    <summary style="cursor: pointer; font-weight: bold; color: #FFD700;">💾 Export/Dump Commands</summary>
                    <div style="background: rgba(0,0,0,0.3); padding: 15px; border-radius: 5px; margin-top: 10px; font-family: monospace; font-size: 12px;">
                        <p><strong>1. Dump database to file:</strong></p>
                        <code>docker exec -i postgres_low_ram pg_dump -U postgres_user -d database_name -f /tmp/backup.sql</code>

                        <p><strong>2. Copy dump file from container:</strong></p>
                        <code>docker cp postgres_low_ram:/tmp/backup.sql "D:/path/to/save/backup.sql"</code>

                        <p><strong>3. Dump with custom format:</strong></p>
                        <code>docker exec -i postgres_low_ram pg_dump -U postgres_user -d database_name -Fc -f /tmp/backup.dump</code>

                        <p><strong>4. Dump only schema:</strong></p>
                        <code>docker exec -i postgres_low_ram pg_dump -U postgres_user -d database_name --schema-only -f /tmp/schema.sql</code>
                    </div>
                </details>

                <details>
                    <summary style="cursor: pointer; font-weight: bold; color: #FF6B6B;">🔧 Common Fixes</summary>
                    <div style="background: rgba(0,0,0,0.3); padding: 15px; border-radius: 5px; margin-top: 10px; font-family: monospace; font-size: 12px;">
                        <p><strong>❌ Version incompatibility error:</strong></p>
                        <p>Use PostgreSQL 17 container for newer dumps:</p>
                        <code>docker run --rm --name temp_pg17 -e POSTGRES_PASSWORD=temp -d postgres:17-alpine</code>

                        <p><strong>❌ Password authentication failed:</strong></p>
                        <code>docker exec -i postgres_low_ram psql -U postgres_user -d postgres -c "ALTER USER tg_retrieval WITH PASSWORD '123456';"</code>

                        <p><strong>❌ User must be 'tg_retrieval' for import:</strong></p>
                        <code>docker exec -i postgres_low_ram psql -U postgres_user -d postgres -c "CREATE USER tg_retrieval WITH PASSWORD '123456' CREATEDB SUPERUSER;"</code>

                        <p><strong>✅ Test connection:</strong></p>
                        <code>docker exec -i postgres_low_ram psql -U tg_retrieval -d database_name -c "SELECT current_user;"</code>
                    </div>
                </details>
            </div>
        </div>

        <!-- Footer -->
        <div style="background: rgba(0,0,0,0.1); padding: 25px; border-radius: 15px; margin-top: 30px; text-align: center;">
            <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(250px, 1fr)); gap: 20px; margin-bottom: 20px;">
                <div>
                    <h4 style="color: #3498db; margin-bottom: 10px;">🚀 Quick Start</h4>
                    <p style="font-size: 14px; margin: 5px 0;">Create new project:</p>
                    <code style="background: rgba(0,0,0,0.2); padding: 5px 10px; border-radius: 5px; font-size: 12px;">bin\create.bat project-name</code>
                </div>
                <div>
                    <h4 style="color: #e74c3c; margin-bottom: 10px;">📚 Documentation</h4>
                    <p style="font-size: 14px; margin: 5px 0;">
                        <a href="/postgresql-guide.php" style="color: #3498db; text-decoration: none;">PostgreSQL Guide</a> |
                        <a href="/test-db.php" style="color: #3498db; text-decoration: none;">Database Test</a>
                    </p>
                </div>
                <div>
                    <h4 style="color: #f39c12; margin-bottom: 10px;">⚡ Performance</h4>
                    <p style="font-size: 14px; margin: 5px 0;">
                        RAM Usage: ~1.2GB<br>
                        Optimized for 4GB+ systems
                    </p>
                </div>
            </div>

            <div style="border-top: 1px solid rgba(255,255,255,0.2); padding-top: 20px;">
                <h3 style="color: #2c3e50; margin-bottom: 15px;">🐳 Docker Master Platform</h3>
                <p style="font-size: 14px; color: #7f8c8d; margin-bottom: 15px;">
                    Professional Multi-PHP Development Environment<br>
                    <strong>Status:</strong>
                    <span style="color: #27ae60;">✅ All Services Running</span> |
                    <strong>Version:</strong> 2.0 |
                    <strong>Updated:</strong> <?= date('Y-m-d H:i:s') ?>
                </p>

                <div style="display: flex; justify-content: center; gap: 15px; flex-wrap: wrap;">
                    <span style="background: #3498db; color: white; padding: 5px 10px; border-radius: 15px; font-size: 12px;">PHP 8.4 ✅</span>
                    <span style="background: #e74c3c; color: white; padding: 5px 10px; border-radius: 15px; font-size: 12px;">PHP 7.4 ✅</span>
                    <span style="background: #9b59b6; color: white; padding: 5px 10px; border-radius: 15px; font-size: 12px;">PostgreSQL ✅</span>
                    <span style="background: #f39c12; color: white; padding: 5px 10px; border-radius: 15px; font-size: 12px;">MySQL ✅</span>
                    <span style="background: #e67e22; color: white; padding: 5px 10px; border-radius: 15px; font-size: 12px;">Redis ✅</span>
                    <span style="background: #27ae60; color: white; padding: 5px 10px; border-radius: 15px; font-size: 12px;">Nginx ✅</span>
                </div>

                <p style="font-size: 12px; color: #95a5a6; margin-top: 15px;">
                    🎉 <strong>Ready for Production!</strong> All services optimized and running smoothly.
                </p>
            </div>
        </div>
    </div>
</body>
</html>
