<?php
session_start();
require_once __DIR__ . '/../config/database.php';
require_once __DIR__ . '/../config/constants.php';

if ($_SERVER['REQUEST_METHOD'] !== 'POST' || !isset($_SESSION['user_id'])) {
    http_response_code(403);
    exit;
}

markNotificationsAsRead($pdo, $_SESSION['user_id']);
echo json_encode(['success' => true]);
