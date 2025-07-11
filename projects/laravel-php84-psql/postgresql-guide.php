<?php
/**
 * PostgreSQL Import/Export Complete Guide
 */
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>🐘 PostgreSQL Import/Export Guide - Docker Master</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 0; padding: 20px; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; }
        .container { max-width: 1000px; margin: 0 auto; }
        .header { text-align: center; margin-bottom: 30px; }
        .section { background: rgba(255,255,255,0.1); padding: 20px; border-radius: 10px; backdrop-filter: blur(10px); margin-bottom: 20px; }
        .command { background: rgba(0,0,0,0.4); padding: 15px; border-radius: 5px; margin: 10px 0; font-family: monospace; font-size: 13px; border-left: 4px solid #4CAF50; }
        .error-fix { border-left-color: #f44336; }
        .warning { border-left-color: #FF9800; }
        .success { border-left-color: #4CAF50; }
        .step { background: rgba(255,255,255,0.05); padding: 15px; border-radius: 5px; margin: 10px 0; }
        .step-number { background: #4CAF50; color: white; border-radius: 50%; width: 25px; height: 25px; display: inline-flex; align-items: center; justify-content: center; margin-right: 10px; font-weight: bold; }
        a { color: #FFD700; text-decoration: none; }
        a:hover { text-decoration: underline; }
        .back-btn { background: rgba(255,255,255,0.2); padding: 10px 20px; border-radius: 5px; display: inline-block; margin-bottom: 20px; }
        .credentials { background: rgba(255,215,0,0.1); border: 1px solid #FFD700; padding: 15px; border-radius: 5px; margin: 15px 0; }
        .grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(450px, 1fr)); gap: 20px; }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <a href="/" class="back-btn">← Back to Dashboard</a>
            <h1>🐘 PostgreSQL Import/Export Complete Guide</h1>
            <p>Comprehensive guide for PostgreSQL database operations in Docker Master Platform</p>
        </div>

        <div class="credentials">
            <h3>🔑 Database Credentials</h3>
            <div class="grid">
                <div>
                    <p><strong>PostgreSQL Container:</strong> postgres_low_ram</p>
                    <p><strong>Host:</strong> localhost:5432</p>
                    <p><strong>Admin User:</strong> postgres_user</p>
                    <p><strong>Admin Password:</strong> postgres_pass</p>
                </div>
                <div>
                    <p><strong>Import User:</strong> tg_retrieval</p>
                    <p><strong>Import Password:</strong> 123456</p>
                    <p><strong>Note:</strong> Use tg_retrieval for data imports</p>
                    <p><strong>pgAdmin:</strong> <a href="http://localhost:8081">http://localhost:8081</a></p>
                </div>
            </div>
        </div>

        <div class="grid">
            <div class="section">
                <h2>📥 Import Operations</h2>
                
                <div class="step">
                    <span class="step-number">1</span>
                    <strong>Copy file to container</strong>
                    <div class="command">
docker cp "D:\path\to\your\file.dump" postgres_low_ram:/tmp/backup.dump
                    </div>
                </div>

                <div class="step">
                    <span class="step-number">2</span>
                    <strong>Import PostgreSQL dump file</strong>
                    <div class="command">
docker exec -i postgres_low_ram pg_restore -U postgres_user -d postgres -C -v /tmp/backup.dump
                    </div>
                </div>

                <div class="step">
                    <span class="step-number">3</span>
                    <strong>Import SQL file (PowerShell)</strong>
                    <div class="command">
Get-Content "D:\path\to\file.sql" | docker exec -i postgres_low_ram psql -U postgres_user -d database_name
                    </div>
                </div>

                <div class="step">
                    <span class="step-number">4</span>
                    <strong>Create database with specific owner</strong>
                    <div class="command">
docker exec -i postgres_low_ram psql -U postgres_user -d postgres -c "CREATE DATABASE db_name OWNER tg_retrieval;"
                    </div>
                </div>

                <div class="step">
                    <span class="step-number">5</span>
                    <strong>Import to specific database</strong>
                    <div class="command">
docker exec -i postgres_low_ram psql -U tg_retrieval -d database_name -f /tmp/backup.sql
                    </div>
                </div>
            </div>

            <div class="section">
                <h2>💾 Export Operations</h2>
                
                <div class="step">
                    <span class="step-number">1</span>
                    <strong>Dump database to SQL file</strong>
                    <div class="command">
docker exec -i postgres_low_ram pg_dump -U postgres_user -d database_name -f /tmp/backup.sql
                    </div>
                </div>

                <div class="step">
                    <span class="step-number">2</span>
                    <strong>Dump with custom format</strong>
                    <div class="command">
docker exec -i postgres_low_ram pg_dump -U postgres_user -d database_name -Fc -f /tmp/backup.dump
                    </div>
                </div>

                <div class="step">
                    <span class="step-number">3</span>
                    <strong>Copy dump file from container</strong>
                    <div class="command">
docker cp postgres_low_ram:/tmp/backup.sql "D:\path\to\save\backup.sql"
                    </div>
                </div>

                <div class="step">
                    <span class="step-number">4</span>
                    <strong>Dump only schema (no data)</strong>
                    <div class="command">
docker exec -i postgres_low_ram pg_dump -U postgres_user -d database_name --schema-only -f /tmp/schema.sql
                    </div>
                </div>

                <div class="step">
                    <span class="step-number">5</span>
                    <strong>Dump only data (no schema)</strong>
                    <div class="command">
docker exec -i postgres_low_ram pg_dump -U postgres_user -d database_name --data-only -f /tmp/data.sql
                    </div>
                </div>
            </div>
        </div>

        <div class="section">
            <h2>🔧 Common Issues & Fixes</h2>
            
            <h3>❌ Version Incompatibility Error</h3>
            <p>When dump file is from newer PostgreSQL version:</p>
            <div class="command error-fix">
# Use PostgreSQL 17 container temporarily
docker run --rm --name temp_pg17 -e POSTGRES_PASSWORD=temp -d postgres:17-alpine

# Copy file and restore in newer version
docker cp "D:\path\to\file.dump" temp_pg17:/tmp/backup.dump
docker exec -i temp_pg17 pg_restore -U postgres -d postgres -C -v /tmp/backup.dump

# Create compatible dump
docker exec -i temp_pg17 pg_dump -U postgres -d database_name --no-owner --no-privileges -f /tmp/compatible.sql
docker cp temp_pg17:/tmp/compatible.sql "D:\compatible.sql"

# Import to main container
docker cp "D:\compatible.sql" postgres_low_ram:/tmp/compatible.sql
docker exec -i postgres_low_ram psql -U postgres_user -d database_name -f /tmp/compatible.sql

# Cleanup
docker stop temp_pg17
            </div>

            <h3>❌ Password Authentication Failed</h3>
            <p>Reset user password:</p>
            <div class="command error-fix">
docker exec -i postgres_low_ram psql -U postgres_user -d postgres -c "ALTER USER tg_retrieval WITH PASSWORD '123456';"
            </div>

            <h3>❌ User 'tg_retrieval' does not exist</h3>
            <p>Create the required user:</p>
            <div class="command error-fix">
docker exec -i postgres_low_ram psql -U postgres_user -d postgres -c "CREATE USER tg_retrieval WITH PASSWORD '123456' CREATEDB SUPERUSER;"
            </div>

            <h3>✅ Test Connection</h3>
            <div class="command success">
docker exec -i postgres_low_ram psql -U tg_retrieval -d database_name -c "SELECT current_user, current_database();"
            </div>

            <h3>📋 List Databases</h3>
            <div class="command">
docker exec -i postgres_low_ram psql -U postgres_user -d postgres -c "\l"
            </div>

            <h3>📋 List Tables in Database</h3>
            <div class="command">
docker exec -i postgres_low_ram psql -U postgres_user -d database_name -c "\dt"
            </div>
        </div>

        <div class="section">
            <h2>⚡ Quick Examples</h2>
            
            <h3>Example 1: Import AWS Order System</h3>
            <div class="command">
# Copy file
docker cp "D:\Data\aws_order_system_20250603_120501" postgres_low_ram:/tmp/aws_order.dump

# Import (if version compatible)
docker exec -i postgres_low_ram pg_restore -U postgres_user -d postgres -C -v /tmp/aws_order.dump

# If version incompatible, use PostgreSQL 17 method above
            </div>

            <h3>Example 2: Import Project Management</h3>
            <div class="command">
# Create database with tg_retrieval owner
docker exec -i postgres_low_ram psql -U postgres_user -d postgres -c "CREATE DATABASE aws_project_management_20250703 OWNER tg_retrieval;"

# Import using compatible method
docker cp "D:\compatible.sql" postgres_low_ram:/tmp/pm.sql
docker exec -i postgres_low_ram psql -U tg_retrieval -d aws_project_management_20250703 -f /tmp/pm.sql
            </div>

            <h3>Example 3: Backup Current Database</h3>
            <div class="command">
# Create backup
docker exec -i postgres_low_ram pg_dump -U postgres_user -d database_name -Fc -f /tmp/backup_$(date +%Y%m%d).dump

# Copy to host
docker cp postgres_low_ram:/tmp/backup_$(date +%Y%m%d).dump "D:\Backups\"
            </div>
        </div>

        <div style="text-align: center; margin-top: 30px;">
            <a href="/" class="back-btn">← Back to Dashboard</a>
            <p>🐳 Docker Master Platform - PostgreSQL Guide</p>
        </div>
    </div>
</body>
</html>
