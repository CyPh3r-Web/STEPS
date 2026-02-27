<?php
define('BASE_URL', '/STEPS/');
define('SITE_NAME', 'STEPS');
define('SITE_FULL_NAME', 'System for Tracking Educational Progress of Students with Career Evaluation');
define('SCHOOL_YEAR', '2025-2026');

define('COMP_WEAK_THRESHOLD', 75);
define('COMP_AT_RISK_MIN', 75);
define('COMP_AT_RISK_MAX', 79);
define('COMP_PROFICIENT_MIN', 80);

define('BACKUP_DIR', __DIR__ . '/../backup/files/');

function getCompetencyLevel($grade) {
    if ($grade < COMP_WEAK_THRESHOLD) {
        return ['level' => 'weak', 'label' => 'Did Not Meet Expectations', 'color' => 'red'];
    } elseif ($grade >= COMP_AT_RISK_MIN && $grade <= COMP_AT_RISK_MAX) {
        return ['level' => 'at_risk', 'label' => 'Needs Reinforcement', 'color' => 'amber'];
    } else {
        return ['level' => 'proficient', 'label' => 'Meets Expectations', 'color' => 'emerald'];
    }
}

function getEmployabilityLevel($score) {
    if ($score < 75) {
        return ['level' => 'low', 'label' => 'Low Readiness', 'color' => 'red'];
    } elseif ($score >= 75 && $score < 80) {
        return ['level' => 'moderate', 'label' => 'Moderate Readiness', 'color' => 'amber'];
    } elseif ($score >= 80 && $score < 90) {
        return ['level' => 'high', 'label' => 'High Readiness', 'color' => 'blue'];
    } else {
        return ['level' => 'very_high', 'label' => 'Very High Readiness', 'color' => 'emerald'];
    }
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

function sanitize($data) {
    return htmlspecialchars(strip_tags(trim($data)), ENT_QUOTES, 'UTF-8');
}

function formatNumber($num, $decimals = 2) {
    return number_format((float)$num, $decimals);
}
