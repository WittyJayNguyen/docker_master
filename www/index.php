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
                <p><a href="http://localhost:8010/laravel.php">Laravel PHP 8.4</a></p>
                <p><a href="http://localhost:8020">Laravel PHP 7.4</a></p>
                <p><a href="http://localhost:8030">WordPress PHP 7.4</a></p>
            </div>

            <div class="card">
                <h3>🗄️ Database Status & Credentials</h3>
                <div style="background: rgba(0,0,0,0.2); padding: 10px; border-radius: 5px; margin-bottom: 15px; font-size: 12px;">
                    <p><strong>PostgreSQL:</strong> localhost:5432</p>
                    <p><strong>User:</strong> postgres_user | <strong>Pass:</strong> postgres_pass</p>
                    <p><strong>Import User:</strong> tg_retrieval | <strong>Pass:</strong> 123456</p>
                    <p><strong>MySQL:</strong> localhost:3306</p>
                    <p><strong>User:</strong> mysql_user | <strong>Pass:</strong> mysql_pass</p>
                    <p><a href="http://localhost:8080">📊 phpMyAdmin</a> | <a href="http://localhost:8081">🐘 pgAdmin</a></p>
                </div>
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

        <div style="text-align: center; margin-top: 30px;">
            <p>🚀 Ready for development! Create new platforms with: <code>bin\create.bat project-name</code></p>
        </div>
    </div>
</body>
</html>
