<?php
define('BASE_URL', '/');
define('SITE_NAME', 'STEPS');
define('SITE_FULL_NAME', 'System for Tracking Educational Progress of Students with Career Evaluation');
define('SCHOOL_YEAR', '2025-2026');

define('COMP_WEAK_THRESHOLD', 75);
define('COMP_AT_RISK_MIN', 75);
define('COMP_AT_RISK_MAX', 79);
define('COMP_PROFICIENT_MIN', 80);

define('BACKUP_DIR', __DIR__ . '/../backup/files/');

function effectiveSchoolYear() {
    $s = $GLOBALS['steps_settings'] ?? [];
    return !empty($s['school_year']) ? $s['school_year'] : SCHOOL_YEAR;
}

function getCompetencyLevel($grade) {
    $s = $GLOBALS['steps_settings'] ?? [];
    $w = (float)($s['comp_weak_threshold'] ?? COMP_WEAK_THRESHOLD);
    $arMin = (float)($s['comp_at_risk_min'] ?? COMP_AT_RISK_MIN);
    $arMax = (float)($s['comp_at_risk_max'] ?? COMP_AT_RISK_MAX);
    if ($grade < $w) {
        return ['level' => 'weak', 'label' => 'Did Not Meet Expectations', 'color' => 'red'];
    }
    if ($grade >= $arMin && $grade <= $arMax) {
        return ['level' => 'at_risk', 'label' => 'Needs Reinforcement', 'color' => 'amber'];
    }
    return ['level' => 'proficient', 'label' => 'Meets Expectations', 'color' => 'emerald'];
}

function getEmployabilityLevel($score) {
    $s = $GLOBALS['steps_settings'] ?? [];
    $mod = (float)($s['emp_moderate_min'] ?? 75);
    $high = (float)($s['emp_high_min'] ?? 80);
    $vh = (float)($s['emp_very_high_min'] ?? 90);
    if ($score < $mod) {
        return ['level' => 'low', 'label' => 'Low Readiness', 'color' => 'red'];
    }
    if ($score >= $mod && $score < $high) {
        return ['level' => 'moderate', 'label' => 'Moderate Readiness', 'color' => 'amber'];
    }
    if ($score >= $high && $score < $vh) {
        return ['level' => 'high', 'label' => 'High Readiness', 'color' => 'blue'];
    }
    return ['level' => 'very_high', 'label' => 'Very High Readiness', 'color' => 'emerald'];
}

function requireLogin() {
    if (session_status() === PHP_SESSION_NONE) {
        session_start();
    }
    if (!isset($_SESSION['user_id'])) {
        header('Location: ' . BASE_URL . 'auth/login.php');
        exit;
    }
}

function requireRole($roles) {
    requireLogin();
    if (!in_array($_SESSION['role'], (array)$roles)) {
        header('Location: ' . BASE_URL . 'dashboard/index.php');
        exit;
    }
}

function requireAdmin() {
    requireLogin();
    if (($_SESSION['role'] ?? '') !== 'admin') {
        header('Location: ' . BASE_URL . 'dashboard/index.php');
        exit;
    }
}

function sanitize($data) {
    return htmlspecialchars(strip_tags(trim($data)), ENT_QUOTES, 'UTF-8');
}

function formatNumber($num, $decimals = 2) {
    return number_format((float)$num, $decimals);
}

function getUnreadNotifications($pdo, $userId) {
    try {
        $stmt = $pdo->prepare("SELECT * FROM notifications WHERE user_id = ? AND is_read = 0 ORDER BY created_at DESC LIMIT 10");
        $stmt->execute([$userId]);
        return $stmt->fetchAll();
    } catch (PDOException $e) {
        return [];
    }
}

function getUnreadNotificationCount($pdo, $userId) {
    try {
        $stmt = $pdo->prepare("SELECT COUNT(*) FROM notifications WHERE user_id = ? AND is_read = 0");
        $stmt->execute([$userId]);
        return (int)$stmt->fetchColumn();
    } catch (PDOException $e) {
        return 0;
    }
}

function markNotificationsAsRead($pdo, $userId) {
    try {
        $stmt = $pdo->prepare("UPDATE notifications SET is_read = 1 WHERE user_id = ? AND is_read = 0");
        $stmt->execute([$userId]);
    } catch (PDOException $e) {
        // Silently fail
    }
}
