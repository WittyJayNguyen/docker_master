<?php
try {
    $pdo = new PDO('pgsql:host=postgres_low_ram;port=5432;dbname=postgres', 'postgres_user', 'postgres_pass');
    echo "PostgreSQL: SUCCESS\n";
    echo "Version: " . $pdo->getAttribute(PDO::ATTR_SERVER_VERSION) . "\n";
} catch(Exception $e) {
    echo "PostgreSQL: ERROR - " . $e->getMessage() . "\n";
}
