<?php
echo "<h1>🎉 Welcome to Docker Development Environment</h1>";
echo "^<p^>PHP Version: " . PHP_VERSION . "^</p^>";
echo "^<p^>Server Time: " . date('Y-m-d H:i:s') . "^</p^>";
echo "^<h2^>Quick Links:^</h2^>";
echo "^<ul^>";
echo "^<li^>^<a href='http://localhost/test-db.php'^>Database Test^</a^>^</li^>";
echo "^<li^>^<a href='http://localhost/ram-optimization.php'^>RAM Optimization Status^</a^>^</li^>";
echo "^<li^>^<a href='http://localhost:8080'^>Adminer (Database Management^)^</a^>^</li^>";
echo "^<li^>^<a href='http://localhost:8081'^>phpMyAdmin^</a^>^</li^>";
echo "^</ul^>";
phpinfo();
?>
