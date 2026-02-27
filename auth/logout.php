<?php
session_start();
require_once __DIR__ . '/../config/database.php';
require_once __DIR__ . '/../config/constants.php';

if (isset($_SESSION['user_id'])) {
    $stmt = $pdo->prepare("INSERT INTO activity_logs (user_id, action, description, ip_address) VALUES (?, 'logout', 'User logged out', ?)");
    $stmt->execute([$_SESSION['user_id'], $_SERVER['REMOTE_ADDR']]);
}

session_unset();
session_destroy();

header('Location: ' . BASE_URL . 'auth/login.php');
exit;
