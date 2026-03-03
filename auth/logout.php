<?php
session_start();
require_once __DIR__ . '/../config/database.php';
require_once __DIR__ . '/../config/constants.php';

if (isset($_SESSION['user_id'])) {
    // Ensure user still exists to satisfy FK; otherwise log with NULL user_id
    $userId = (int)$_SESSION['user_id'];
    $check = $pdo->prepare("SELECT id FROM users WHERE id = ? LIMIT 1");
    $check->execute([$userId]);
    $valid = $check->fetchColumn();

    $stmt = $pdo->prepare("INSERT INTO activity_logs (user_id, action, description, ip_address) VALUES (?, 'logout', 'User logged out', ?)");
    $stmt->execute([$valid ? $userId : null, $_SERVER['REMOTE_ADDR']]);
}

session_unset();
session_destroy();

header('Location: ' . BASE_URL . 'auth/login.php');
exit;
