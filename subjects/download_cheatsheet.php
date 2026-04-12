<?php
session_start();
require_once __DIR__ . '/../config/database.php';
require_once __DIR__ . '/../config/constants.php';
requireRole(['teacher', 'admin']);

$grade = $_GET['grade'] ?? '';

// Define grade level groups
$gradeGroups = [
    '7' => ['7'],
    '8' => ['8'],
    '9' => ['9'],
    '10' => ['10'],
    '11' => ['11'],
    '12' => ['12']
];

if (!isset($gradeGroups[$grade])) {
    header('HTTP/1.0 400 Bad Request');
    echo 'Invalid grade level.';
    exit;
}

$gradeLevels = $gradeGroups[$grade];
$gradeLabel = "Grade $grade";

// Fetch subjects for the selected grade levels
$placeholders = implode(',', array_fill(0, count($gradeLevels), '?'));
$stmt = $pdo->prepare("
    SELECT sub.subject_code, sub.subject_name, sub.subject_type, sub.grade_level,
           st.strand_code
    FROM subjects sub
    LEFT JOIN strands st ON sub.strand_id = st.id
    WHERE sub.grade_level IN ($placeholders)
    ORDER BY sub.grade_level, sub.subject_type, sub.subject_code
");
$stmt->execute($gradeLevels);
$subjects = $stmt->fetchAll();

if (empty($subjects)) {
    header('HTTP/1.0 404 Not Found');
    echo 'No subjects found for this grade level.';
    exit;
}

// Generate CSV file (Excel-compatible)
$filename = 'subject_codes_' . str_replace('-', '_', $grade) . '_' . date('Y-m-d') . '.csv';
header('Content-Type: text/csv; charset=utf-8');
header('Content-Disposition: attachment; filename="' . $filename . '"');
header('Cache-Control: must-revalidate, post-check=0, pre-check=0');
header('Pragma: public');

$output = fopen('php://output', 'w');

// Add BOM for Excel UTF-8 compatibility
fprintf($output, chr(0xEF) . chr(0xBB) . chr(0xBF));

// Header row
fputcsv($output, ['STEPS - Subject Codes Cheatsheet', $gradeLabel, 'Generated: ' . date('F d, Y')]);
fputcsv($output, []);

// JHS (7-10) doesn't have strands, SHS (11-12) has strands
$isSHS = in_array($grade, ['11', '12']);
$headers = ['Subject Code', 'Subject Name', 'Type', 'Grade Level'];
if ($isSHS) {
    $headers[] = 'Strand';
}
fputcsv($output, $headers);

// Subject type labels
$typeLabels = [
    'core' => 'Core',
    'specialized' => 'Specialized',
    'applied' => 'Applied',
    'immersion' => 'Immersion',
    'jhs_core' => 'JHS Core',
    'jhs_mapeh' => 'MAPEH',
    'jhs_tle' => 'TLE',
    'jhs_esp' => 'ESP'
];

foreach ($subjects as $sub) {
    $row = [
        $sub['subject_code'],
        $sub['subject_name'],
        $typeLabels[$sub['subject_type']] ?? ucfirst($sub['subject_type']),
        'Grade ' . $sub['grade_level']
    ];
    if ($isSHS) {
        $row[] = $sub['strand_code'] ?? 'All Strands';
    }
    fputcsv($output, $row);
}

// Add summary
fputcsv($output, []);
fputcsv($output, ['Total Subjects: ' . count($subjects)]);

fclose($output);
exit;
