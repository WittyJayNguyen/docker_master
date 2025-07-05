<?php
/**
 * WordPress Database Configuration for PostgreSQL
 * Docker Master Platform - Low RAM Configuration
 */

// PostgreSQL Database settings
define( 'DB_NAME', 'wordpress_php74' );
define( 'DB_USER', 'postgres_user' );
define( 'DB_PASSWORD', 'postgres_pass' );
define( 'DB_HOST', 'postgres_low_ram:5432' );
define( 'DB_CHARSET', 'utf8' );
define( 'DB_COLLATE', '' );

// WordPress Security Keys (generate new ones)
define( 'AUTH_KEY',         'your-auth-key-here' );
define( 'SECURE_AUTH_KEY',  'your-secure-auth-key-here' );
define( 'LOGGED_IN_KEY',    'your-logged-in-key-here' );
define( 'NONCE_KEY',        'your-nonce-key-here' );
define( 'AUTH_SALT',        'your-auth-salt-here' );
define( 'SECURE_AUTH_SALT', 'your-secure-auth-salt-here' );
define( 'LOGGED_IN_SALT',   'your-logged-in-salt-here' );
define( 'NONCE_SALT',       'your-nonce-salt-here' );

$table_prefix = 'wp_';
define( 'WP_DEBUG', true );
define( 'WP_MEMORY_LIMIT', '96M' );
define( 'WP_HOME', 'http://localhost:8030' );
define( 'WP_SITEURL', 'http://localhost:8030' );

if (  defined( 'ABSPATH' ) ) {
    define( 'ABSPATH', __DIR__ . '/' );
}
require_once ABSPATH . 'wp-settings.php';
