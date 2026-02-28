<?php
session_start();
require_once __DIR__ . '/../config/database.php';
require_once __DIR__ . '/../config/constants.php';
requireRole(['admin', 'teacher']);

if ($_SERVER['REQUEST_METHOD'] !== 'POST' || !isset($_FILES['csv_file'])) {
    header('Location: ' . BASE_URL . 'students/grades.php');
    exit;
}

$file = $_FILES['csv_file'];

if ($file['error'] !== UPLOAD_ERR_OK) {
    header('Location: ' . BASE_URL . 'students/grades.php?import_error=' . urlencode('File upload failed. Please try again.'));
    exit;
}

$ext = strtolower(pathinfo($file['name'], PATHINFO_EXTENSION));
if (!in_array($ext, ['csv', 'txt'])) {
    header('Location: ' . BASE_URL . 'students/grades.php?import_error=' . urlencode('Invalid file type. Please upload a CSV file.'));
    exit;
}

$handle = fopen($file['tmp_name'], 'r');
if (!$handle) {
    header('Location: ' . BASE_URL . 'students/grades.php?import_error=' . urlencode('Could not read the uploaded file.'));
    exit;
}

// Build lookup maps
$studentMap = [];
$studentRows = $pdo->query("SELECT id, lrn FROM students WHERE status = 'active'")->fetchAll();
foreach ($studentRows as $r) {
    $studentMap[trim($r['lrn'])] = $r['id'];
}

$subjectMap = [];
$subjectRows = $pdo->query("SELECT id, subject_code FROM subjects")->fetchAll();
foreach ($subjectRows as $r) {
    $subjectMap[strtoupper(trim($r['subject_code']))] = $r['id'];
}

$header = fgetcsv($handle);
if (!$header) {
    fclose($handle);
    header('Location: ' . BASE_URL . 'students/grades.php?import_error=' . urlencode('CSV file is empty or has no header row.'));
    exit;
}

// Normalize header (strip BOM, quotes, whitespace)
$header = array_map(fn($h) => strtolower(trim(str_replace(["\xEF\xBB\xBF", '"'], '', $h))), $header);

$requiredCols = ['lrn', 'subject code', 'quarter', 'grade', 'school year'];
foreach ($requiredCols as $col) {
    if (!in_array($col, $header)) {
        fclose($handle);
        header('Location: ' . BASE_URL . 'students/grades.php?import_error=' . urlencode("Missing required column: \"$col\". Please use the provided template."));
        exit;
    }
}

$colIndex = array_flip($header);
$inserted = 0;
$updated  = 0;
$skipped  = 0;
$errors   = [];
$rowNum   = 1;

$upsertStmt = $pdo->prepare(
    "INSERT INTO grades (student_id, subject_id, quarter, grade, school_year, encoded_by)
     VALUES (?, ?, ?, ?, ?, ?)
     ON DUPLICATE KEY UPDATE grade = VALUES(grade), encoded_by = VALUES(encoded_by)"
);

$existsStmt = $pdo->prepare(
    "SELECT id FROM grades WHERE student_id = ? AND subject_id = ? AND quarter = ? AND school_year = ?"
);

while (($row = fgetcsv($handle)) !== false) {
    $rowNum++;

    // Skip completely blank rows
    if (count(array_filter($row, fn($v) => trim($v) !== '')) === 0) {
        continue;
    }

    if (count($row) < count($requiredCols)) {
        $errors[] = "Row $rowNum: Not enough columns, skipped.";
        $skipped++;
        continue;
    }

    $lrn         = trim($row[$colIndex['lrn']] ?? '');
    $subjectCode = strtoupper(trim($row[$colIndex['subject code']] ?? ''));
    $quarter     = strtoupper(trim($row[$colIndex['quarter']] ?? ''));
    $grade       = trim($row[$colIndex['grade']] ?? '');
    $schoolYear  = trim($row[$colIndex['school year']] ?? '');

    // Normalize LRN from scientific notation (e.g. 1.001E+11)
    if ($lrn !== '' && preg_match('/^[0-9]+(?:\.[0-9]+)?[eE][+-]?[0-9]+$/', $lrn)) {
        $lrn = sprintf('%.0F', (float)$lrn);
    }

    // Validate required fields
    if (empty($lrn) || empty($subjectCode) || empty($quarter) || $grade === '' || empty($schoolYear)) {
        $errors[] = "Row $rowNum: Missing required fields (LRN, Subject Code, Quarter, Grade, or School Year), skipped.";
        $skipped++;
        continue;
    }

    // Validate quarter
    if (!in_array($quarter, ['Q1', 'Q2', 'Q3', 'Q4'])) {
        $errors[] = "Row $rowNum (LRN: $lrn): Invalid quarter \"$quarter\". Must be Q1, Q2, Q3, or Q4, skipped.";
        $skipped++;
        continue;
    }

    // Validate grade range
    if (!is_numeric($grade) || (float)$grade < 60 || (float)$grade > 100) {
        $errors[] = "Row $rowNum (LRN: $lrn): Grade \"$grade\" must be a number between 60 and 100, skipped.";
        $skipped++;
        continue;
    }

    // Resolve student
    if (!isset($studentMap[$lrn])) {
        $errors[] = "Row $rowNum: LRN \"$lrn\" not found in the system, skipped.";
        $skipped++;
        continue;
    }
    $studentId = $studentMap[$lrn];

    // Resolve subject
    if (!isset($subjectMap[$subjectCode])) {
        $errors[] = "Row $rowNum (LRN: $lrn): Subject code \"$subjectCode\" not found in the system, skipped.";
        $skipped++;
        continue;
    }
    $subjectId = $subjectMap[$subjectCode];

    // Check if grade already exists (to distinguish insert vs update in counts)
    $existsStmt->execute([$studentId, $subjectId, $quarter, $schoolYear]);
    $exists = $existsStmt->fetch();

    try {
        $upsertStmt->execute([$studentId, $subjectId, $quarter, (float)$grade, $schoolYear, $_SESSION['user_id']]);
        if ($exists) {
            $updated++;
        } else {
            $inserted++;
        }
    } catch (PDOException $e) {
        $errors[] = "Row $rowNum (LRN: $lrn): Database error — " . $e->getMessage();
        $skipped++;
    }
}

fclose($handle);

// Activity log
$logStmt = $pdo->prepare("INSERT INTO activity_logs (user_id, action, description, ip_address) VALUES (?, 'bulk_import_grades', ?, ?)");
$logStmt->execute([
    $_SESSION['user_id'],
    "Bulk grade import: $inserted inserted, $updated updated, $skipped skipped from {$file['name']}",
    $_SERVER['REMOTE_ADDR']
]);

// Import log
$importLog = $pdo->prepare("INSERT INTO import_logs (file_name, total_rows, inserted, skipped, errors, imported_by) VALUES (?, ?, ?, ?, ?, ?)");
$importLog->execute([
    $file['name'],
    $inserted + $updated + $skipped,
    $inserted + $updated,
    $skipped,
    !empty($errors) ? json_encode($errors) : null,
    $_SESSION['user_id']
]);

$_SESSION['grade_import_result'] = [
    'inserted' => $inserted,
    'updated'  => $updated,
    'skipped'  => $skipped,
    'errors'   => $errors,
    'filename' => $file['name']
];

header('Location: ' . BASE_URL . 'students/grades.php?msg=imported');
exit;
