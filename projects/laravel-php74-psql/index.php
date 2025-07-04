<?php
/**
 * Laravel PHP 7.4 + PostgreSQL Example
 * Demo application showing PHP 7.4 features with PostgreSQL connection
 */

// Display PHP version and loaded extensions
echo "<h1>🔧 Laravel PHP 7.4 + PostgreSQL Example</h1>";
echo "<div style='font-family: Arial, sans-serif; max-width: 800px; margin: 0 auto; padding: 20px;'>";

// PHP Information
echo "<h2>📋 PHP Information</h2>";
echo "<p><strong>PHP Version:</strong> " . phpversion() . "</p>";
echo "<p><strong>Server:</strong> " . $_SERVER['SERVER_SOFTWARE'] . "</p>";
echo "<p><strong>Document Root:</strong> " . $_SERVER['DOCUMENT_ROOT'] . "</p>";

// Database Connection Test
echo "<h2>🗄️ PostgreSQL Connection Test</h2>";

$host = $_ENV['DB_HOST'] ?? 'postgres_server';
$port = $_ENV['DB_PORT'] ?? '5432';
$dbname = $_ENV['DB_DATABASE'] ?? 'laravel_php74_psql';
$username = $_ENV['DB_USERNAME'] ?? 'postgres_user';
$password = $_ENV['DB_PASSWORD'] ?? 'postgres_pass';

try {
    $dsn = "pgsql:host=$host;port=$port;dbname=postgres"; // Connect to default DB first
    $pdo = new PDO($dsn, $username, $password);
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    
    // Create database if not exists
    $pdo->exec("CREATE DATABASE $dbname");
    echo "<p>✅ Database '$dbname' created or already exists</p>";
    
    // Connect to our database
    $dsn = "pgsql:host=$host;port=$port;dbname=$dbname";
    $pdo = new PDO($dsn, $username, $password);
    
    // Create sample table
    $pdo->exec("
        CREATE TABLE IF NOT EXISTS products (
            id SERIAL PRIMARY KEY,
            name VARCHAR(100) NOT NULL,
            price DECIMAL(10,2) NOT NULL,
            category VARCHAR(50),
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        )
    ");
    
    // Insert sample data
    $stmt = $pdo->prepare("INSERT INTO products (name, price, category) VALUES (?, ?, ?) ON CONFLICT DO NOTHING");
    $stmt->execute(['Laptop', 999.99, 'Electronics']);
    $stmt->execute(['Coffee Mug', 15.50, 'Kitchen']);
    $stmt->execute(['Book', 25.00, 'Education']);
    
    // Fetch data
    $stmt = $pdo->query("SELECT * FROM products ORDER BY id");
    $products = $stmt->fetchAll(PDO::FETCH_ASSOC);
    
    echo "<p>✅ PostgreSQL connection successful!</p>";
    echo "<p><strong>Database:</strong> $dbname</p>";
    echo "<p><strong>Host:</strong> $host:$port</p>";
    
    echo "<h3>🛍️ Sample Products:</h3>";
    echo "<table border='1' style='border-collapse: collapse; width: 100%;'>";
    echo "<tr><th>ID</th><th>Name</th><th>Price</th><th>Category</th><th>Created At</th></tr>";
    foreach ($products as $product) {
        echo "<tr>";
        echo "<td>" . htmlspecialchars($product['id']) . "</td>";
        echo "<td>" . htmlspecialchars($product['name']) . "</td>";
        echo "<td>$" . htmlspecialchars($product['price']) . "</td>";
        echo "<td>" . htmlspecialchars($product['category']) . "</td>";
        echo "<td>" . htmlspecialchars($product['created_at']) . "</td>";
        echo "</tr>";
    }
    echo "</table>";
    
} catch (PDOException $e) {
    echo "<p>❌ Database connection failed: " . htmlspecialchars($e->getMessage()) . "</p>";
}

// Redis Connection Test
echo "<h2>🔴 Redis Connection Test</h2>";

$redis_host = $_ENV['REDIS_HOST'] ?? 'redis_server';
$redis_port = $_ENV['REDIS_PORT'] ?? '6379';

if (extension_loaded('redis')) {
    try {
        $redis = new Redis();
        $redis->connect($redis_host, $redis_port);
        $redis->set('php74_test', 'Hello from Laravel PHP 7.4!');
        $value = $redis->get('php74_test');
        
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

// Arrow functions
$numbers = [1, 2, 3, 4, 5];
$squared = array_map(fn($n) => $n * $n, $numbers);
echo "<p><strong>Arrow Functions:</strong> [" . implode(', ', $squared) . "]</p>";

// Typed properties (class example)
class User {
    public string $name;
    public int $age;
    public ?string $email = null;
    
    public function __construct(string $name, int $age) {
        $this->name = $name;
        $this->age = $age;
    }
}

$user = new User("John Doe", 30);
$user->email = "john@example.com";

echo "<p><strong>Typed Properties:</strong> {$user->name}, {$user->age}, {$user->email}</p>";

// Null coalescing assignment
$config = [];
$config['timeout'] ??= 30;
$config['retries'] ??= 3;

echo "<p><strong>Null Coalescing Assignment:</strong> timeout={$config['timeout']}, retries={$config['retries']}</p>";

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
