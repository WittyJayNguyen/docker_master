<?php
echo "^<h1^>📝 nginx-test-blog - WordPress Platform^</h1^>";
echo "^<div style='font-family: Arial, sans-serif; max-width: 800px; margin: 0 auto; padding: 20px;'^>";
echo "^<h2^>🗄️ Database Connection^</h2^>";
$pdo = new PDO("mysql:host=mysql_low_ram;dbname=nginx_test_blog_db", "mysql_user", "mysql_pass");
echo "<p>✅ mysql connection successful</p>";
echo "<p>Ready for WordPress installation</p>";
echo "^</div^>";
?>
