<?php
/**
 * PHP Information and Xdebug Status
 * Shows PHP configuration and Xdebug settings
 */

echo "<h1>🐘 PHP Information & Xdebug Status</h1>";

// PHP Version Info
echo "<div style='background: #e3f2fd; padding: 15px; border-radius: 5px; margin: 10px 0;'>";
echo "<h2>📋 PHP Version Information</h2>";
echo "<strong>PHP Version:</strong> " . PHP_VERSION . "<br>";
echo "<strong>PHP SAPI:</strong> " . php_sapi_name() . "<br>";
echo "<strong>Server:</strong> " . $_SERVER['SERVER_SOFTWARE'] . "<br>";
echo "<strong>Document Root:</strong> " . $_SERVER['DOCUMENT_ROOT'] . "<br>";
echo "</div>";

// Xdebug Status
echo "<div style='background: #f3e5f5; padding: 15px; border-radius: 5px; margin: 10px 0;'>";
echo "<h2>🐛 Xdebug Status</h2>";

if (extension_loaded('xdebug')) {
    echo "<strong style='color: green;'>✅ Xdebug is LOADED</strong><br>";
    echo "<strong>Xdebug Version:</strong> " . phpversion('xdebug') . "<br>";
    
    // Xdebug Configuration
    $xdebug_config = [
        'xdebug.mode' => ini_get('xdebug.mode'),
        'xdebug.start_with_request' => ini_get('xdebug.start_with_request'),
        'xdebug.client_host' => ini_get('xdebug.client_host'),
        'xdebug.client_port' => ini_get('xdebug.client_port'),
        'xdebug.idekey' => ini_get('xdebug.idekey'),
        'xdebug.log' => ini_get('xdebug.log'),
        'xdebug.remote_enable' => ini_get('xdebug.remote_enable'),
    ];
    
    echo "<h3>🔧 Xdebug Configuration:</h3>";
    echo "<table border='1' style='border-collapse: collapse; width: 100%;'>";
    echo "<tr><th style='padding: 8px; background: #f0f0f0;'>Setting</th><th style='padding: 8px; background: #f0f0f0;'>Value</th></tr>";
    
    foreach ($xdebug_config as $key => $value) {
        $display_value = $value ?: '<em>not set</em>';
        echo "<tr><td style='padding: 8px;'>$key</td><td style='padding: 8px;'>$display_value</td></tr>";
    }
    echo "</table>";
    
    // Debug Session Status
    echo "<h3>🎯 Debug Session Status:</h3>";
    if (isset($_GET['XDEBUG_SESSION_START']) || isset($_COOKIE['XDEBUG_SESSION'])) {
        echo "<strong style='color: green;'>✅ Debug session is ACTIVE</strong><br>";
        if (isset($_GET['XDEBUG_SESSION_START'])) {
            echo "Started via URL parameter: " . htmlspecialchars($_GET['XDEBUG_SESSION_START']) . "<br>";
        }
        if (isset($_COOKIE['XDEBUG_SESSION'])) {
            echo "Session cookie: " . htmlspecialchars($_COOKIE['XDEBUG_SESSION']) . "<br>";
        }
    } else {
        echo "<strong style='color: orange;'>⚠️ No debug session active</strong><br>";
        echo "To start debugging, add <code>?XDEBUG_SESSION_START=VSCODE</code> to URL<br>";
    }
    
} else {
    echo "<strong style='color: red;'>❌ Xdebug is NOT loaded</strong><br>";
    echo "Please check PHP configuration and ensure Xdebug extension is installed.";
}
echo "</div>";

// Quick Debug Test
echo "<div style='background: #fff3e0; padding: 15px; border-radius: 5px; margin: 10px 0;'>";
echo "<h2>🧪 Quick Debug Test</h2>";
echo "<p>Set a breakpoint on the line below and refresh with debug session:</p>";
echo "<code>http://localhost/phpinfo.php?XDEBUG_SESSION_START=VSCODE</code><br><br>";

// This line should trigger breakpoint when debugging
$debug_test_variable = "This is a test variable for debugging";
echo "<strong>Debug Test Variable:</strong> " . $debug_test_variable . "<br>";
echo "</div>";

// Navigation
echo "<div style='background: #e8f5e8; padding: 15px; border-radius: 5px; margin: 10px 0;'>";
echo "<h3>🔗 Quick Links</h3>";
echo "<a href='/'>← Back to Dashboard</a> | ";
echo "<a href='/test-db.php'>Database Test</a> | ";
echo "<a href='/ram-optimization.php'>RAM Monitor</a> | ";
echo "<a href='/phpinfo.php?XDEBUG_SESSION_START=VSCODE'>Start Debug Session</a>";
echo "</div>";

// Full phpinfo (collapsible)
echo "<details style='margin: 20px 0;'>";
echo "<summary style='cursor: pointer; font-size: 18px; font-weight: bold;'>📄 Full PHP Info (Click to expand)</summary>";
echo "<div style='margin-top: 10px; border: 1px solid #ddd; padding: 10px;'>";
phpinfo();
echo "</div>";
echo "</details>";
?>
