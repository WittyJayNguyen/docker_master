<?php
/**
 * Laravel PHP 7.4 + PostgreSQL Example
 * Demo application showing PHP 7.4 features with PostgreSQL connection
 */

// Display PHP version and loaded extensions
echo "<h1>🚀 Laravel PHP 7.4 + PostgreSQL Example</h1>";
echo "<div style='font-family: Arial, sans-serif; max-width: 800px; margin: 0 auto; padding: 20px;'>";

// PHP Information
echo "<h2>📋 PHP Information</h2>";
echo "<p><strong>PHP Version:</strong> " . phpversion() . "</p>";
echo "<p><strong>Server:</strong> " . $_SERVER['SERVER_SOFTWARE'] . "</p>";
echo "<p><strong>Document Root:</strong> " . $_SERVER['DOCUMENT_ROOT'] . "</p>";

// Database Connection Test
echo "<h2>🗄️ PostgreSQL Connection Test</h2>";

$host = $_ENV['DB_HOST'] ?? 'postgres_low_ram';
$port = $_ENV['DB_PORT'] ?? '5432';
$dbname = $_ENV['DB_DATABASE'] ?? 'laravel_php74_psql';
$username = $_ENV['DB_USERNAME'] ?? 'postgres_user';
$password = $_ENV['DB_PASSWORD'] ?? 'postgres_pass';

try {
    // Connect directly to our database (no CREATE DATABASE)
    $dsn = "pgsql:host=$host;port=$port;dbname=$dbname";
    $pdo = new PDO($dsn, $username, $password);
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

    // Create sample table
    $pdo->exec("
        CREATE TABLE IF NOT EXISTS users (
            id SERIAL PRIMARY KEY,
            name VARCHAR(100) NOT NULL,
            email VARCHAR(100) UNIQUE NOT NULL,
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        )
    ");

    // Insert sample data
    $stmt = $pdo->prepare("INSERT INTO users (name, email) VALUES (?, ?) ON CONFLICT (email) DO NOTHING");
    $stmt->execute(['John Doe', 'john@example.com']);
    $stmt->execute(['Jane Smith', 'jane@example.com']);

    // Fetch data
    $stmt = $pdo->query("SELECT * FROM users ORDER BY id");
    $users = $stmt->fetchAll(PDO::FETCH_ASSOC);

    echo "<p>✅ PostgreSQL connection successful!</p>";
    echo "<p><strong>Database:</strong> $dbname</p>";
    echo "<p><strong>Host:</strong> $host:$port</p>";

    echo "<h3>👥 Sample Users:</h3>";
    echo "<table border='1' style='border-collapse: collapse; width: 100%;'>";
    echo "<tr><th>ID</th><th>Name</th><th>Email</th><th>Created At</th></tr>";
    foreach ($users as $user) {
        echo "<tr>";
        echo "<td>" . htmlspecialchars($user['id']) . "</td>";
        echo "<td>" . htmlspecialchars($user['name']) . "</td>";
        echo "<td>" . htmlspecialchars($user['email']) . "</td>";
        echo "<td>" . htmlspecialchars($user['created_at']) . "</td>";
        echo "</tr>";
    }
    echo "</table>";

} catch (PDOException $e) {
    echo "<p>❌ Database connection failed: " . htmlspecialchars($e->getMessage()) . "</p>";
}

// Redis Connection Test
echo "<h2>🔴 Redis Connection Test</h2>";

$redis_host = $_ENV['REDIS_HOST'] ?? 'redis_low_ram';
$redis_port = $_ENV['REDIS_PORT'] ?? '6379';

if (extension_loaded('redis')) {
    try {
        $redis = new Redis();
        $redis->connect($redis_host, $redis_port);
        $redis->set('test_key', 'Hello from Laravel PHP 7.4!');
        $value = $redis->get('test_key');

        echo "<p>✅ Redis connection successful!</p>";
        echo "<p><strong>Host:</strong> $redis_host:$redis_port</p>";
        echo "<p><strong>Test Value:</strong> " . htmlspecialchars($value) . "</p>";

    } catch (Exception $e) {
        echo "<p>❌ Redis connection failed: " . htmlspecialchars($e->getMessage()) . "</p>";
    }
} else {
    echo "<p>⚠️ Redis extension not loaded</p>";
}

// PHP 7.4 Features Demo
echo "<h2>✨ PHP 7.4 Features Demo</h2>";

// Class constants (PHP 7.4 compatible)
class Status {
    const ACTIVE = 'active';
    const INACTIVE = 'inactive';
    const PENDING = 'pending';
}

echo "<p><strong>Class Constants:</strong> " . Status::ACTIVE . "</p>";

// Arrow functions (PHP 7.4 feature)
$numbers = [1, 2, 3, 4, 5];
$squared = array_map(fn($n) => $n * $n, $numbers);
echo "<p><strong>Arrow Functions:</strong> [" . implode(', ', $squared) . "]</p>";

// Null coalescing assignment (PHP 7.4 feature)
$config = [];
$config['timeout'] ??= 30;
echo "<p><strong>Null Coalescing Assignment:</strong> timeout = " . $config['timeout'] . "</p>";

// Typed properties (PHP 7.4 feature)
class User {
    public string $name;
    public int $age;
    
    public function __construct(string $name, int $age) {
        $this->name = $name;
        $this->age = $age;
    }
}

$user = new User("John Doe", 30);
echo "<p><strong>Typed Properties:</strong> {$user->name} is {$user->age} years old</p>";

// Spread operator in array expressions (PHP 7.4 feature)
$parts = ['apple', 'pear'];
$fruits = ['banana', ...$parts, 'cherry'];
echo "<p><strong>Spread Operator:</strong> [" . implode(', ', $fruits) . "]</p>";

// Loaded Extensions
echo "<h2>🔧 Loaded Extensions</h2>";
$extensions = get_loaded_extensions();
sort($extensions);

echo "<div style='columns: 3; column-gap: 20px;'>";
foreach ($extensions as $ext) {
    echo "<p>• " . htmlspecialchars($ext) . "</p>";
}
echo "</div>";

echo "<hr>";
echo "<p><em>🐳 Running in Docker container with PHP " . phpversion() . " and PostgreSQL</em></p>";
echo "</div>";
?>
