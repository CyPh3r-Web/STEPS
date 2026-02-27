<?php
session_start();
require_once __DIR__ . '/../config/constants.php';
requireRole('admin');

$filename = basename($_GET['file'] ?? '');
$filepath = __DIR__ . '/files/' . $filename;

if (empty($filename) || !file_exists($filepath) || pathinfo($filepath, PATHINFO_EXTENSION) !== 'sql') {
    header('HTTP/1.0 404 Not Found');
    echo 'File not found.';
    exit;
}

header('Content-Type: application/octet-stream');
header('Content-Disposition: attachment; filename="' . $filename . '"');
header('Content-Length: ' . filesize($filepath));
readfile($filepath);
exit;
