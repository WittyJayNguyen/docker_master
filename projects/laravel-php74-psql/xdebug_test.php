<?php
/**
 * Xdebug Test File for PHP 7.4
 * Access: http://localhost:8011/xdebug_test.php
 */

echo "<h1>🐛 Xdebug Test - PHP 7.4</h1>";

// Test 1: Check if Xdebug is loaded
echo "<h2>1. Xdebug Extension Status</h2>";
if (extension_loaded('xdebug')) {
    echo "✅ <strong>Xdebug is loaded!</strong><br>";
    echo "📋 Xdebug version: " . phpversion('xdebug') . "<br>";
} else {
    echo "❌ <strong>Xdebug is NOT loaded</strong><br>";
}

// Test 2: Xdebug configuration
echo "<h2>2. Xdebug Configuration</h2>";
if (function_exists('xdebug_info')) {
    echo "✅ <strong>Xdebug functions available</strong><br>";
    
    // Get Xdebug settings
    $settings = [
        'xdebug.mode' => ini_get('xdebug.mode'),
        'xdebug.client_host' => ini_get('xdebug.client_host'),
        'xdebug.client_port' => ini_get('xdebug.client_port'),
        'xdebug.idekey' => ini_get('xdebug.idekey'),
        'xdebug.start_with_request' => ini_get('xdebug.start_with_request'),
    ];
    
    echo "<table border='1' cellpadding='5'>";
    echo "<tr><th>Setting</th><th>Value</th></tr>";
    foreach ($settings as $key => $value) {
        echo "<tr><td>$key</td><td>" . ($value ?: 'Not set') . "</td></tr>";
    }
    echo "</table>";
} else {
    echo "❌ <strong>Xdebug functions not available</strong><br>";
}

// Test 3: Debug test with breakpoint
echo "<h2>3. Debug Test</h2>";
echo "🔍 <strong>Set a breakpoint on the next line in your IDE:</strong><br>";

$test_variable = "Hello from PHP 7.4 with Xdebug!"; // <- Set breakpoint here
$array_data = [
    'framework' => 'Laravel',
    'php_version' => PHP_VERSION,
    'xdebug_version' => extension_loaded('xdebug') ? phpversion('xdebug') : 'Not loaded',
    'timestamp' => date('Y-m-d H:i:s')
];

echo "📝 Test variable: " . $test_variable . "<br>";
echo "📊 Array data: <pre>" . print_r($array_data, true) . "</pre>";

// Test 4: Function call stack
echo "<h2>4. Function Call Stack Test</h2>";

function test_function_a() {
    return test_function_b();
}

function test_function_b() {
    return test_function_c();
}

function test_function_c() {
    $result = "Function call stack test completed!"; // <- Set breakpoint here too
    return $result;
}

$stack_result = test_function_a();
echo "🔄 " . $stack_result . "<br>";

// Test 5: Show phpinfo for Xdebug section
echo "<h2>5. Full PHP Info</h2>";
echo "<a href='?phpinfo=1' target='_blank'>📋 View Full PHP Info</a><br>";

if (isset($_GET['phpinfo'])) {
    phpinfo();
    exit;
}

echo "<hr>";
echo "<p><strong>🎯 How to test debugging:</strong></p>";
echo "<ol>";
echo "<li>Set breakpoints on lines marked with comments</li>";
echo "<li>Configure your IDE to listen on port <strong>9074</strong></li>";
echo "<li>Refresh this page</li>";
echo "<li>Your IDE should stop at the breakpoints</li>";
echo "</ol>";

echo "<p><strong>🔧 IDE Configuration:</strong></p>";
echo "<ul>";
echo "<li><strong>Host:</strong> localhost</li>";
echo "<li><strong>Port:</strong> 8011 (web) / 9074 (debug)</li>";
echo "<li><strong>Path mapping:</strong> /app/laravel-php74-psql → your local project path</li>";
echo "</ul>";
?>
