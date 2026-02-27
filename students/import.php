<?php
session_start();
require_once __DIR__ . '/../config/database.php';
require_once __DIR__ . '/../config/constants.php';
requireRole(['admin', 'teacher']);

if ($_SERVER['REQUEST_METHOD'] !== 'POST' || !isset($_FILES['csv_file'])) {
    header('Location: ' . BASE_URL . 'students/index.php');
    exit;
}

$file = $_FILES['csv_file'];

if ($file['error'] !== UPLOAD_ERR_OK) {
    header('Location: ' . BASE_URL . 'students/index.php?import_error=' . urlencode('File upload failed. Please try again.'));
    exit;
}

$ext = strtolower(pathinfo($file['name'], PATHINFO_EXTENSION));
if (!in_array($ext, ['csv', 'txt'])) {
    header('Location: ' . BASE_URL . 'students/index.php?import_error=' . urlencode('Invalid file type. Please upload a CSV file.'));
    exit;
}

$handle = fopen($file['tmp_name'], 'r');
if (!$handle) {
    header('Location: ' . BASE_URL . 'students/index.php?import_error=' . urlencode('Could not read the uploaded file.'));
    exit;
}

// Build lookup maps for section names and strand codes
$sectionMap = [];
$sectionRows = $pdo->query("SELECT id, section_name FROM sections")->fetchAll();
foreach ($sectionRows as $r) {
    $sectionMap[strtolower(trim($r['section_name']))] = $r['id'];
}

$strandMap = [];
$strandRows = $pdo->query("SELECT id, strand_code FROM strands")->fetchAll();
foreach ($strandRows as $r) {
    $strandMap[strtolower(trim($r['strand_code']))] = $r['id'];
}

$header = fgetcsv($handle);
if (!$header) {
    fclose($handle);
    header('Location: ' . BASE_URL . 'students/index.php?import_error=' . urlencode('CSV file is empty or has no header row.'));
    exit;
}

// Normalize header
$header = array_map(fn($h) => strtolower(trim(str_replace(["\xEF\xBB\xBF", '"'], '', $h))), $header);

$requiredCols = ['lrn', 'last name', 'first name', 'gender', 'school year'];
foreach ($requiredCols as $col) {
    if (!in_array($col, $header)) {
        fclose($handle);
        header('Location: ' . BASE_URL . 'students/index.php?import_error=' . urlencode("Missing required column: \"$col\". Please use the provided template."));
        exit;
    }
}

$colIndex = array_flip($header);
$inserted = 0;
$skipped = 0;
$errors = [];
$rowNum = 1;

$insertStmt = $pdo->prepare("INSERT INTO students (lrn, first_name, last_name, middle_name, gender, birthdate, section_id, strand_id, school_year) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)");
$checkStmt = $pdo->prepare("SELECT id FROM students WHERE lrn = ?");

while (($row = fgetcsv($handle)) !== false) {
    $rowNum++;

    if (count($row) < count($requiredCols)) {
        $errors[] = "Row $rowNum: Not enough columns, skipped.";
        $skipped++;
        continue;
    }

    $lrn       = trim($row[$colIndex['lrn']] ?? '');
    $lastName  = trim($row[$colIndex['last name']] ?? '');
    $firstName = trim($row[$colIndex['first name']] ?? '');
    $middleName = trim($row[$colIndex['middle name']] ?? '');
    $gender    = trim($row[$colIndex['gender']] ?? '');
    $birthdate = array_key_exists('birthdate', $colIndex) ? trim($row[$colIndex['birthdate']] ?? '') : '';
    $sectionName = strtolower(trim($row[$colIndex['section name']] ?? ''));
    $strandCode  = strtolower(trim($row[$colIndex['strand code']] ?? ''));
    $schoolYear  = trim($row[$colIndex['school year']] ?? '');

    // Normalize LRNs that may have been saved in scientific notation (e.g. 1.001E+11)
    if ($lrn !== '' && preg_match('/^[0-9]+(?:\.[0-9]+)?[eE][+-]?[0-9]+$/', $lrn)) {
        $lrnFloat = (float)$lrn;
        // Convert to a whole-number string without scientific notation
        $lrn = sprintf('%.0F', $lrnFloat);
    }

    if (empty($lrn) || empty($lastName) || empty($firstName) || empty($gender) || empty($schoolYear)) {
        $errors[] = "Row $rowNum: Missing required fields (LRN, name, gender, or school year), skipped.";
        $skipped++;
        continue;
    }

    $gender = ucfirst(strtolower($gender));
    if (!in_array($gender, ['Male', 'Female'])) {
        $errors[] = "Row $rowNum ($lrn): Invalid gender \"$gender\", skipped.";
        $skipped++;
        continue;
    }

    // Check duplicate LRN
    $checkStmt->execute([$lrn]);
    if ($checkStmt->fetch()) {
        $errors[] = "Row $rowNum ($lrn): LRN already exists, skipped.";
        $skipped++;
        continue;
    }

    $sectionId = $sectionMap[$sectionName] ?? null;
    $strandId = $strandMap[$strandCode] ?? null;

    if ($sectionName && !$sectionId) {
        $errors[] = "Row $rowNum ($lrn): Section \"$sectionName\" not found, student added without section.";
    }
    if ($strandCode && !$strandId) {
        $errors[] = "Row $rowNum ($lrn): Strand \"$strandCode\" not found, student added without strand.";
    }

    $birthdateFormatted = null;
    if ($birthdate !== '') {
        // Excel exports dates as serial numbers (e.g. 39448); 25569 = 1970-01-01 in Excel
        if (is_numeric($birthdate)) {
            $serial = (float) $birthdate;
            if ($serial >= 1 && $serial <= 2958465) {
                $birthdateFormatted = date('Y-m-d', (int)(($serial - 25569) * 86400));
            }
        }
        // Use explicit formats only — prioritize DD/MM/YYYY (common in PH/Excel) before MM/DD/YYYY
        if (!$birthdateFormatted) {
            $formats = ['Y-m-d', 'd/m/Y', 'd-m-Y', 'd.m.Y', 'Y/m/d', 'm/d/Y', 'm-d-Y', 'j F Y', 'F j Y'];
            foreach ($formats as $fmt) {
                $dt = DateTime::createFromFormat($fmt, $birthdate);
                if ($dt && $dt->format($fmt) === $birthdate) {
                    $birthdateFormatted = $dt->format('Y-m-d');
                    break;
                }
            }
        }
        // Last resort: strtotime for any remaining text formats
        if (!$birthdateFormatted) {
            $parsed = strtotime($birthdate);
            if ($parsed && $parsed > 0) {
                $birthdateFormatted = date('Y-m-d', $parsed);
            }
        }
    }

    try {
        $insertStmt->execute([
            $lrn,
            sanitize($firstName),
            sanitize($lastName),
            sanitize($middleName) ?: null,
            $gender,
            $birthdateFormatted,
            $sectionId,
            $strandId,
            sanitize($schoolYear)
        ]);
        $inserted++;
    } catch (PDOException $e) {
        $errors[] = "Row $rowNum ($lrn): Database error — " . $e->getMessage();
        $skipped++;
    }
}

fclose($handle);

// Log the import
$logStmt = $pdo->prepare("INSERT INTO activity_logs (user_id, action, description, ip_address) VALUES (?, 'bulk_import', ?, ?)");
$logStmt->execute([
    $_SESSION['user_id'],
    "Bulk import: $inserted inserted, $skipped skipped from {$file['name']}",
    $_SERVER['REMOTE_ADDR']
]);

$importLog = $pdo->prepare("INSERT INTO import_logs (file_name, total_rows, inserted, skipped, errors, imported_by) VALUES (?, ?, ?, ?, ?, ?)");
$importLog->execute([
    $file['name'],
    $inserted + $skipped,
    $inserted,
    $skipped,
    !empty($errors) ? json_encode($errors) : null,
    $_SESSION['user_id']
]);

// Store results in session for display
$_SESSION['import_result'] = [
    'inserted' => $inserted,
    'skipped' => $skipped,
    'errors' => $errors,
    'filename' => $file['name']
];

header('Location: ' . BASE_URL . 'students/index.php?msg=imported');
exit;
