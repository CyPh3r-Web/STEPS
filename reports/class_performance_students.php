<?php
if (session_status() === PHP_SESSION_NONE) session_start();

require_once __DIR__ . '/../config/constants.php';
require_once __DIR__ . '/../config/database.php';

requireRole('teacher');

header('Content-Type: text/html; charset=utf-8');

$subjectId = isset($_GET['subject_id']) ? (int)$_GET['subject_id'] : 0;
$category  = $_GET['category'] ?? '';
$sectionId = isset($_GET['section']) && $_GET['section'] !== '' ? (int)$_GET['section'] : null;

if ($subjectId <= 0 || !in_array($category, ['weak', 'at_risk', 'proficient'], true)) {
    http_response_code(400);
    echo '<p class="text-red-500 text-sm">Invalid request.</p>';
    exit;
}

$currentUserId = $_SESSION['user_id'] ?? 0;
$userRole = $_SESSION['role'] ?? '';

$conditions = ['g.subject_id = :subject_id', "s.status = 'active'"];
$params = ['subject_id' => $subjectId];

// Teachers only see students they created
if ($userRole === 'teacher') {
    $conditions[] = 's.created_by = :created_by';
    $params['created_by'] = $currentUserId;
}

if ($sectionId) {
    $conditions[] = 's.section_id = :section_id';
    $params['section_id'] = $sectionId;
}

switch ($category) {
    case 'weak':
        $conditions[] = 'g.grade < :weak_max';
        $params['weak_max'] = COMP_WEAK_THRESHOLD;
        break;
    case 'at_risk':
        $conditions[] = 'g.grade >= :ar_min AND g.grade <= :ar_max';
        $params['ar_min'] = COMP_AT_RISK_MIN;
        $params['ar_max'] = COMP_AT_RISK_MAX;
        break;
    case 'proficient':
        $conditions[] = 'g.grade >= :prof_min';
        $params['prof_min'] = COMP_PROFICIENT_MIN;
        break;
}

$whereSql = implode(' AND ', $conditions);

$sql = "SELECT
            s.id,
            s.lrn,
            s.first_name,
            s.last_name,
            sec.section_name,
            sec.grade_level,
            g.quarter,
            g.grade
        FROM grades g
        JOIN students s ON s.id = g.student_id
        LEFT JOIN sections sec ON sec.id = s.section_id
        WHERE $whereSql
        ORDER BY g.grade ASC, s.last_name ASC, s.first_name ASC, g.quarter ASC";

$stmt = $pdo->prepare($sql);
$stmt->execute($params);
$students = $stmt->fetchAll();

if (empty($students)) {
    echo '<p class="text-sm text-gray-500">No students found in this category for the selected subject.</p>';
    exit;
}

?>
<div class="mb-3 text-xs text-gray-500">
    Showing <span class="font-semibold text-gray-700"><?= count($students) ?></span> record(s).
</div>
<div class="overflow-x-auto">
    <table class="steps-table">
        <thead>
            <tr>
                <th>#</th>
                <th>Student</th>
                <th>LRN</th>
                <th>Section</th>
                <th>Quarter</th>
                <th>Grade</th>
            </tr>
        </thead>
        <tbody>
            <?php foreach ($students as $i => $stu): ?>
                <tr>
                    <td class="text-gray-400"><?= $i + 1 ?></td>
                    <td class="font-medium">
                        <?= sanitize($stu['last_name'] . ', ' . $stu['first_name']) ?>
                    </td>
                    <td class="text-xs font-mono text-gray-500">
                        <?= sanitize($stu['lrn'] ?? '') ?>
                    </td>
                    <td class="text-sm text-gray-600">
                        <?php if (!empty($stu['section_name'])): ?>
                            <?= sanitize($stu['section_name']) ?><?= $stu['grade_level'] ? ' (G' . (int)$stu['grade_level'] . ')' : '' ?>
                        <?php else: ?>
                            <span class="text-gray-400">N/A</span>
                        <?php endif; ?>
                    </td>
                    <td>
                        <span class="inline-flex items-center justify-center text-xs font-semibold px-2 py-0.5 rounded bg-gray-100 text-gray-700">
                            <?= htmlspecialchars($stu['quarter'] ?? '-') ?>
                        </span>
                    </td>
                    <td class="font-semibold text-gray-900">
                        <?= $stu['grade'] !== null ? formatNumber($stu['grade']) : '-' ?>
                    </td>
                </tr>
            <?php endforeach; ?>
        </tbody>
    </table>
</div>

