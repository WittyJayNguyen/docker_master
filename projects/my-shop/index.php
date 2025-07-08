<?php
echo "^<h1^>🛒 my-shop - E-commerce Platform^</h1^>";
echo "^<div style='font-family: Arial, sans-serif; max-width: 800px; margin: 0 auto; padding: 20px;'^>";
echo "^<h2^>🗄️ Database Connection^</h2^>";
$pdo = new PDO("mysql:host=mysql_low_ram;dbname=my_shop_db", "mysql_user", "mysql_pass");
echo "<p>✅ mysql connection successful</p>";
echo "<p>E-commerce platform ready</p>";
echo "^</div^>";
?>
