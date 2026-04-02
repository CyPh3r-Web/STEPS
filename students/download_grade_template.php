<?php
session_start();
require_once __DIR__ . '/../config/database.php';
require_once __DIR__ . '/../config/constants.php';
requireRole('teacher');

$file = __DIR__ . '/templates/grade_import_template.csv';

if (!file_exists($file)) {
    header('HTTP/1.0 404 Not Found');
    echo 'Template file not found.';
    exit;
}

header('Content-Type: text/csv');
header('Content-Disposition: attachment; filename="grade_import_template.csv"');
header('Content-Length: ' . filesize($file));
readfile($file);
exit;
