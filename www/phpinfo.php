<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>PHP Information - Docker Master Platform</title>
    <style>
        body { 
            font-family: Arial, sans-serif; 
            margin: 0; 
            padding: 20px; 
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        }
        .header {
            background: rgba(255,255,255,0.95);
            padding: 20px;
            border-radius: 15px;
            margin-bottom: 20px;
            text-align: center;
            backdrop-filter: blur(10px);
        }
        .nav-links {
            background: rgba(255,255,255,0.95);
            padding: 15px;
            border-radius: 15px;
            text-align: center;
            margin-bottom: 20px;
            backdrop-filter: blur(10px);
        }
        .nav-links a {
            display: inline-block;
            margin: 0 10px;
            padding: 8px 16px;
            background: #3498db;
            color: white;
            text-decoration: none;
            border-radius: 20px;
        }
        .nav-links a:hover { background: #2980b9; }
        .phpinfo-container {
            background: rgba(255,255,255,0.95);
            border-radius: 15px;
            overflow: hidden;
            backdrop-filter: blur(10px);
        }
    </style>
</head>
<body>
    <div class="header">
        <h1>🐘 PHP Information</h1>
        <p>Docker Master Platform - PHP <?= phpversion() ?></p>
        <p><strong>Server:</strong> <?= $_SERVER['SERVER_SOFTWARE'] ?? 'Unknown' ?></p>
    </div>
    
    <div class="nav-links">
        <a href="/">🏠 Dashboard</a>
        <a href="/db-status.php">📊 Database Status</a>
        <a href="/postgresql-guide.php">🐘 PostgreSQL Guide</a>
        <a href="/redis-test.php">🔴 Redis Test</a>
    </div>
    
    <div class="phpinfo-container">
        <?php phpinfo(); ?>
    </div>
</body>
</html>
