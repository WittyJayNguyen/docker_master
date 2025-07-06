<?php
echo "^<h1^>🚀 laravel74-api-example - Laravel Platform^</h1^>";
echo "^<div style='font-family: Arial, sans-serif; max-width: 800px; margin: 0 auto; padding: 20px;'^>";
echo "^<h2^>🗄️ Database Connection^</h2^>";
$pdo = new PDO("pgsql:host=postgres_low_ram;dbname=laravel74_api_example_db", "postgres_user", "postgres_pass");
echo "<p>✅ postgresql connection successful</p>";
echo "<p>Laravel platform ready</p>";
echo "^</div^>";
?>
