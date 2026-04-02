<?php
define('DB_HOST', 'localhost');
define('DB_NAME', 'steps_db');
define('DB_USER', 'root');
define('DB_PASS', '');

function getConnection() {
    try {
        $pdo = new PDO(
            "mysql:host=" . DB_HOST . ";dbname=" . DB_NAME . ";charset=utf8mb4",
            DB_USER,
            DB_PASS,
            [
                PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
                PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
                PDO::ATTR_EMULATE_PREPARES => false
            ]
        );
        return $pdo;
    } catch (PDOException $e) {
        die("Database connection failed: " . $e->getMessage());
    }
}

$pdo = getConnection();

$GLOBALS['steps_settings'] = [];
try {
    $GLOBALS['steps_settings'] = $pdo->query('SELECT setting_key, setting_value FROM system_settings')
        ->fetchAll(PDO::FETCH_KEY_PAIR);
} catch (PDOException $e) {
    $GLOBALS['steps_settings'] = [];
}
