<?php
// Redirect to the main career pathway page — individual generation is now done via student.php
require_once __DIR__ . '/../config/constants.php';
header('Location: ' . BASE_URL . 'career/index.php');
exit;
