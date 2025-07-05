<?php
echo "^<h1^>🛒 my-coffee-shop - E-commerce Platform^</h1^>";
echo "^<div style='font-family: Arial, sans-serif; max-width: 800px; margin: 0 auto; padding: 20px;'^>";
echo "^<h2^>🗄️ Database Connection^</h2^>";
$pdo = new PDO("pgsql:host=postgres_low_ram;dbname=my_coffee_shop_db", "postgres_user", "postgres_pass");
echo "<p>✅ PostgreSQL connection successful</p>";
echo "<p>E-commerce platform ready</p>";
echo "^</div^>";
?>
