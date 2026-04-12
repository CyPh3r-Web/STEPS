<?php
$pageTitle = 'Manage Grades';
require_once __DIR__ . '/../includes/header.php';
requireRole('teacher');

$teacherId = $_SESSION['user_id'] ?? 0;

// Teachers only see sections where they are the adviser
$sectionsStmt = $pdo->prepare("SELECT * FROM sections WHERE adviser_id = ? ORDER BY grade_level, section_name");
$sectionsStmt->execute([$teacherId]);
$sections = $sectionsStmt->fetchAll();

$sectionFilter = $_GET['section'] ?? '';
$subjectFilter = $_GET['subject'] ?? '';
$quarterFilter = $_GET['quarter'] ?? '';

// Get teacher's assigned subjects
$teacherId = $_SESSION['user_id'] ?? 0;
$teacherSubjectIds = [];
try {
    $teacherSubjectsStmt = $pdo->prepare("SELECT subject_id FROM teacher_subjects WHERE teacher_id = ? AND school_year = ?");
    $teacherSubjectsStmt->execute([$teacherId, effectiveSchoolYear()]);
    $teacherSubjectIds = $teacherSubjectsStmt->fetchAll(PDO::FETCH_COLUMN);
} catch (PDOException $e) {
    // Table may not exist yet
}

// Filter subjects by grade level if a section is selected
// Also filter by teacher's assigned subjects
if ($sectionFilter) {
    $sectionStmt = $pdo->prepare("SELECT grade_level FROM sections WHERE id = ?");
    $sectionStmt->execute([$sectionFilter]);
    $selectedSection = $sectionStmt->fetch();
    
    if ($selectedSection) {
        $subjectParams = [$selectedSection['grade_level']];
        $subjectQuery = "SELECT * FROM subjects WHERE (grade_level = ? OR grade_level IS NULL)";
        
        // Filter by teacher's assigned subjects if any exist
        if (!empty($teacherSubjectIds)) {
            $placeholders = implode(',', array_fill(0, count($teacherSubjectIds), '?'));
            $subjectQuery .= " AND id IN ($placeholders)";
            $subjectParams = array_merge($subjectParams, $teacherSubjectIds);
        }
        
        $subjectQuery .= " ORDER BY subject_name";
        $subjects = $pdo->prepare($subjectQuery);
        $subjects->execute($subjectParams);
        $subjects = $subjects->fetchAll();
    } else {
        $subjects = [];
    }
} else {
    // When no section selected, still filter by teacher subjects if available
    if (!empty($teacherSubjectIds)) {
        $placeholders = implode(',', array_fill(0, count($teacherSubjectIds), '?'));
        $subjects = $pdo->prepare("SELECT * FROM subjects WHERE id IN ($placeholders) ORDER BY subject_name");
        $subjects->execute($teacherSubjectIds);
        $subjects = $subjects->fetchAll();
    } else {
        $subjects = $pdo->query("SELECT * FROM subjects ORDER BY subject_name")->fetchAll();
    }
}

$success = '';
$error = '';

// Handle grade import result from session
$gradeImportResult = null;
if (isset($_GET['msg']) && $_GET['msg'] === 'imported' && isset($_SESSION['grade_import_result'])) {
    $gradeImportResult = $_SESSION['grade_import_result'];
    unset($_SESSION['grade_import_result']);
}
if (isset($_GET['import_error'])) {
    $error = htmlspecialchars($_GET['import_error']);
}

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $action = $_POST['action'] ?? '';

    if ($action === 'save_grades') {
        $studentIds = $_POST['student_id'] ?? [];
        $gradeValues = $_POST['grade'] ?? [];
        $subjectId = $_POST['subject_id'];
        $quarter = $_POST['quarter'];
        $schoolYear = $_POST['school_year'];

        $upsertStmt = $pdo->prepare("INSERT INTO grades (student_id, subject_id, quarter, grade, school_year, encoded_by)
            VALUES (?, ?, ?, ?, ?, ?)
            ON DUPLICATE KEY UPDATE grade = VALUES(grade), encoded_by = VALUES(encoded_by)");

        $saved = 0;
        foreach ($studentIds as $i => $studentId) {
            $grade = $gradeValues[$i] ?? '';
            if ($grade !== '' && is_numeric($grade)) {
                $upsertStmt->execute([$studentId, $subjectId, $quarter, $grade, $schoolYear, $_SESSION['user_id']]);
                $saved++;
            }
        }
        $success = "$saved grade(s) saved successfully.";
    }
}

$students = [];
$gradedCount = 0;
$ungradedCount = 0;

if ($sectionFilter && $subjectFilter && $quarterFilter) {
    $currentUserId = $_SESSION['user_id'] ?? 0;
    $userRole = $_SESSION['role'] ?? '';
    
    $gradesSql = "SELECT s.id, s.lrn, s.first_name, s.last_name,
            g.id        AS grade_id,
            g.grade     AS existing_grade,
            g.updated_at AS graded_at,
            u.full_name  AS encoded_by_name
         FROM students s
         LEFT JOIN grades g
            ON g.student_id = s.id
            AND g.subject_id = ?
            AND g.quarter    = ?
            AND g.school_year = ?
         LEFT JOIN users u ON u.id = g.encoded_by
         WHERE s.section_id = ? AND s.status = 'active'";
    $gradesParams = [$subjectFilter, $quarterFilter, effectiveSchoolYear(), $sectionFilter];
    
    // Teachers only see students they created
    if ($userRole === 'teacher') {
        $gradesSql .= " AND s.created_by = ?";
        $gradesParams[] = $currentUserId;
    }
    $gradesSql .= " ORDER BY s.last_name, s.first_name";
    
    $stmt = $pdo->prepare($gradesSql);
    $stmt->execute($gradesParams);
    $students = $stmt->fetchAll();

    foreach ($students as $s) {
        if ($s['existing_grade'] !== null) $gradedCount++;
        else $ungradedCount++;
    }
}

// For the overview table: fetch ALL graded records for the selected section (any subject/quarter)
// scoped to current school year so teacher sees the full picture
$overviewGrades = [];
if ($sectionFilter) {
    $overviewSql = "SELECT s.last_name, s.first_name, s.lrn,
                sub.subject_code, sub.subject_name,
                g.quarter, g.grade, g.school_year, g.updated_at,
                u.full_name AS encoded_by_name
         FROM grades g
         JOIN students s   ON s.id = g.student_id
         JOIN subjects sub ON sub.id = g.subject_id
         LEFT JOIN users u ON u.id = g.encoded_by
         WHERE s.section_id = ? AND g.school_year = ?";
    $overviewParams = [$sectionFilter, effectiveSchoolYear()];
    
    // Teachers only see students they created
    if ($userRole === 'teacher') {
        $overviewSql .= " AND s.created_by = ?";
        $overviewParams[] = $currentUserId;
    }
    $overviewSql .= " ORDER BY s.last_name, s.first_name, sub.subject_name, g.quarter";
    
    $ovStmt = $pdo->prepare($overviewSql);
    $ovStmt->execute($overviewParams);
    $overviewGrades = $ovStmt->fetchAll();
}

require_once __DIR__ . '/../includes/sidebar.php';
?>

<?php if ($success): ?>
<script>
document.addEventListener('DOMContentLoaded', function() {
    Swal.fire({
        ...swalDefaults,
        icon: 'success',
        title: 'Grades Saved',
        text: <?= json_encode($success) ?>,
        confirmButtonColor: '#2563eb'
    });
});
</script>
<?php endif; ?>
<?php if ($error): ?>
<script>
document.addEventListener('DOMContentLoaded', function() {
    Swal.fire({
        ...swalDefaults,
        icon: 'error',
        title: 'Error',
        text: <?= json_encode($error) ?>,
        confirmButtonColor: '#2563eb'
    });
});
</script>
<?php endif; ?>

<?php if ($gradeImportResult): ?>
<script>
document.addEventListener('DOMContentLoaded', function() {
    const r = <?= json_encode($gradeImportResult) ?>;
    let html = `<div class="text-left text-sm space-y-1">
        <p><span class="font-semibold text-green-600">${r.inserted}</span> grade(s) inserted</p>
        <p><span class="font-semibold text-blue-600">${r.updated}</span> grade(s) updated</p>
        <p><span class="font-semibold text-gray-500">${r.skipped}</span> row(s) skipped</p>`;
    if (r.errors && r.errors.length > 0) {
        html += `<details class="mt-3"><summary class="cursor-pointer text-red-500 font-medium">${r.errors.length} warning(s)</summary>
            <ul class="mt-1 text-xs text-red-500 space-y-0.5 max-h-40 overflow-y-auto">`;
        r.errors.forEach(e => { html += `<li>${e}</li>`; });
        html += `</ul></details>`;
    }
    html += `</div>`;
    Swal.fire({
        ...swalDefaults,
        icon: r.inserted + r.updated > 0 ? 'success' : 'warning',
        title: 'Import Complete',
        html: html,
        confirmButtonColor: '#2563eb'
    });
});
</script>
<?php endif; ?>

<?php if (empty($sections)): ?>
<div class="bg-amber-50 border border-amber-200 rounded-xl p-4 mb-6">
    <div class="flex items-start gap-3">
        <i class="fas fa-exclamation-triangle text-amber-600 mt-0.5"></i>
        <div>
            <p class="text-sm font-medium text-amber-800">No Sections Assigned</p>
            <p class="text-xs text-amber-700 mt-1">You are not assigned as an adviser to any section. Please contact the administrator to be assigned to a section.</p>
        </div>
    </div>
</div>
<?php elseif (empty($teacherSubjectIds) && empty($subjects)): ?>
<div class="bg-amber-50 border border-amber-200 rounded-xl p-4 mb-6">
    <div class="flex items-start gap-3">
        <i class="fas fa-exclamation-triangle text-amber-600 mt-0.5"></i>
        <div>
            <p class="text-sm font-medium text-amber-800">No Subject Assignments</p>
            <p class="text-xs text-amber-700 mt-1">You currently have no subjects assigned. Please contact the administrator to be assigned to subjects.</p>
        </div>
    </div>
</div>
<?php endif; ?>

<!-- Filters -->
<div class="bg-white border border-gray-200 rounded-xl p-5 mb-6">
    <form method="GET" class="flex flex-wrap items-end gap-4">
        <div class="w-48">
            <label class="form-label">Section</label>
            <select name="section" id="sectionSelect" class="form-select" required onchange="filterBySection()">
                <option value="">Select Section</option>
                <?php foreach ($sections as $sec): ?>
                    <option value="<?= $sec['id'] ?>" <?= $sectionFilter == $sec['id'] ? 'selected' : '' ?>>
                        <?= sanitize($sec['section_name']) ?> (G<?= $sec['grade_level'] ?>)
                    </option>
                <?php endforeach; ?>
            </select>
        </div>
        <div class="w-56">
            <label class="form-label">Subject</label>
            <select name="subject" id="subjectSelect" class="form-select" required>
                <option value="">Select Subject</option>
                <?php foreach ($subjects as $sub): ?>
                    <option value="<?= $sub['id'] ?>" <?= $subjectFilter == $sub['id'] ? 'selected' : '' ?>>
                        <?= sanitize($sub['subject_name']) ?>
                    </option>
                <?php endforeach; ?>
            </select>
        </div>
        <div class="w-36">
            <label class="form-label">Quarter</label>
            <select name="quarter" class="form-select" required>
                <option value="">Select</option>
                <?php foreach (['Q1','Q2','Q3','Q4'] as $q): ?>
                    <option value="<?= $q ?>" <?= $quarterFilter === $q ? 'selected' : '' ?>><?= $q ?></option>
                <?php endforeach; ?>
            </select>
        </div>
        <button type="submit" class="btn btn-primary btn-sm"><i class="fas fa-search"></i> Load Students</button>
        <button type="button" onclick="openModal('gradeImportModal')" class="btn btn-secondary btn-sm ml-auto">
            <i class="fas fa-file-upload"></i> Bulk Import Grades
        </button>
    </form>
</div>

<?php if (!empty($students)): ?>

<!-- Stats bar -->
<div class="flex items-center gap-3 mb-4">
    <div class="flex items-center gap-2 bg-white border border-gray-200 rounded-lg px-4 py-2 text-sm">
        <span class="w-2 h-2 rounded-full bg-emerald-400 inline-block"></span>
        <span class="font-semibold text-gray-800"><?= $gradedCount ?></span>
        <span class="text-gray-500">graded</span>
    </div>
    <div class="flex items-center gap-2 bg-white border border-gray-200 rounded-lg px-4 py-2 text-sm">
        <span class="w-2 h-2 rounded-full bg-amber-400 inline-block"></span>
        <span class="font-semibold text-gray-800"><?= $ungradedCount ?></span>
        <span class="text-gray-500">pending</span>
    </div>
    <div class="flex items-center gap-2 bg-white border border-gray-200 rounded-lg px-4 py-2 text-sm">
        <span class="font-semibold text-gray-800"><?= count($students) ?></span>
        <span class="text-gray-500">total students</span>
    </div>
</div>

<div class="bg-white border border-gray-200 rounded-xl overflow-hidden mb-6">
    <form method="POST">
        <input type="hidden" name="action" value="save_grades">
        <input type="hidden" name="subject_id" value="<?= $subjectFilter ?>">
        <input type="hidden" name="quarter" value="<?= $quarterFilter ?>">
        <input type="hidden" name="school_year" value="<?= effectiveSchoolYear() ?>">

        <div class="px-6 py-4 border-b border-gray-200 flex items-center justify-between">
            <div>
                <h3 class="text-sm font-semibold text-gray-900">
                    Enter Grades
                    <span class="ml-1 text-xs font-medium px-2 py-0.5 bg-blue-50 text-blue-700 rounded-full"><?= $quarterFilter ?></span>
                </h3>
                <p class="text-xs text-gray-400 mt-0.5">Rows with an existing grade are pre-filled. Leave blank to skip.</p>
            </div>
            <button type="submit" class="btn btn-primary btn-sm"><i class="fas fa-save"></i> Save All Grades</button>
        </div>

        <table class="steps-table">
            <thead>
                <tr>
                    <th class="w-8">#</th>
                    <th>Student Name</th>
                    <th>LRN</th>
                    <th>Status</th>
                    <th>Grade</th>
                    <th>Last Encoded By</th>
                </tr>
            </thead>
            <tbody>
                <?php foreach ($students as $i => $s):
                    $hasGrade = $s['existing_grade'] !== null;
                ?>
                    <tr class="<?= $hasGrade ? 'bg-emerald-50/40' : '' ?>">
                        <td class="text-gray-400"><?= $i + 1 ?></td>
                        <td class="font-medium">
                            <input type="hidden" name="student_id[]" value="<?= $s['id'] ?>">
                            <?= sanitize($s['last_name'] . ', ' . $s['first_name']) ?>
                        </td>
                        <td class="text-xs font-mono text-gray-500"><?= sanitize($s['lrn']) ?></td>
                        <td>
                            <?php if ($hasGrade): ?>
                                <span class="inline-flex items-center gap-1 text-xs font-medium text-emerald-700 bg-emerald-50 border border-emerald-200 px-2 py-0.5 rounded-full">
                                    <i class="fas fa-check-circle text-emerald-500"></i> Graded
                                </span>
                            <?php else: ?>
                                <span class="inline-flex items-center gap-1 text-xs font-medium text-amber-700 bg-amber-50 border border-amber-200 px-2 py-0.5 rounded-full">
                                    <i class="fas fa-clock text-amber-500"></i> Pending
                                </span>
                            <?php endif; ?>
                        </td>
                        <td>
                            <input type="number" name="grade[]" class="form-input w-28" min="60" max="100" step="0.01"
                                   value="<?= $hasGrade ? htmlspecialchars($s['existing_grade']) : '' ?>"
                                   placeholder="<?= $hasGrade ? '' : '—' ?>">
                        </td>
                        <td class="text-xs text-gray-400">
                            <?php if ($hasGrade && $s['encoded_by_name']): ?>
                                <span class="text-gray-600"><?= sanitize($s['encoded_by_name']) ?></span>
                                <?php if ($s['graded_at']): ?>
                                    <br><span class="text-gray-400"><?= date('M j, Y', strtotime($s['graded_at'])) ?></span>
                                <?php endif; ?>
                            <?php else: ?>
                                <span class="text-gray-300">—</span>
                            <?php endif; ?>
                        </td>
                    </tr>
                <?php endforeach; ?>
            </tbody>
        </table>
    </form>
</div>
<?php elseif ($sectionFilter && $subjectFilter && $quarterFilter): ?>
    <div class="bg-white border border-gray-200 rounded-xl p-8 text-center mb-6">
        <i class="fas fa-users text-gray-300 text-4xl mb-3"></i>
        <p class="text-gray-500">No students found in this section.</p>
    </div>
<?php endif; ?>

<?php if ($sectionFilter): ?>
<!-- Current Grades Overview -->
<div class="bg-white border border-gray-200 rounded-xl overflow-hidden">
    <div class="px-6 py-4 border-b border-gray-200 flex items-center justify-between">
        <div>
            <h3 class="text-sm font-semibold text-gray-900">Current Grades Overview</h3>
            <p class="text-xs text-gray-400 mt-0.5">All recorded grades for this section — School Year <?= effectiveSchoolYear() ?></p>
        </div>
        <?php if (!empty($overviewGrades)): ?>
            <span class="text-xs text-gray-400"><?= count($overviewGrades) ?> record(s)</span>
        <?php endif; ?>
    </div>

    <?php if (!empty($overviewGrades)): ?>
    <div class="overflow-x-auto">
        <table class="steps-table">
            <thead>
                <tr>
                    <th>Student</th>
                    <th>LRN</th>
                    <th>Subject</th>
                    <th>Quarter</th>
                    <th>Grade</th>
                    <th>Remarks</th>
                    <th>Encoded By</th>
                    <th>Date</th>
                </tr>
            </thead>
            <tbody>
                <?php foreach ($overviewGrades as $og):
                    $g = (float)$og['grade'];
                    if ($g >= 90)      { $rem = 'Outstanding';   $remClass = 'text-emerald-700 bg-emerald-50 border-emerald-200'; }
                    elseif ($g >= 85)  { $rem = 'Very Satisfactory'; $remClass = 'text-blue-700 bg-blue-50 border-blue-200'; }
                    elseif ($g >= 80)  { $rem = 'Satisfactory';  $remClass = 'text-indigo-700 bg-indigo-50 border-indigo-200'; }
                    elseif ($g >= 75)  { $rem = 'Fairly Satisfactory'; $remClass = 'text-amber-700 bg-amber-50 border-amber-200'; }
                    else               { $rem = 'Did Not Meet';  $remClass = 'text-red-700 bg-red-50 border-red-200'; }
                ?>
                    <tr>
                        <td class="font-medium"><?= sanitize($og['last_name'] . ', ' . $og['first_name']) ?></td>
                        <td class="text-xs font-mono text-gray-500"><?= sanitize($og['lrn']) ?></td>
                        <td>
                            <span class="font-medium text-gray-800"><?= sanitize($og['subject_name']) ?></span>
                            <span class="text-xs text-gray-400 ml-1">(<?= sanitize($og['subject_code']) ?>)</span>
                        </td>
                        <td>
                            <span class="text-xs font-semibold px-2 py-0.5 rounded bg-gray-100 text-gray-700"><?= $og['quarter'] ?></span>
                        </td>
                        <td>
                            <span class="font-semibold text-gray-900"><?= number_format($g, 2) ?></span>
                        </td>
                        <td>
                            <span class="inline-block text-xs font-medium px-2 py-0.5 rounded-full border <?= $remClass ?>">
                                <?= $rem ?>
                            </span>
                        </td>
                        <td class="text-xs text-gray-500"><?= $og['encoded_by_name'] ? sanitize($og['encoded_by_name']) : '—' ?></td>
                        <td class="text-xs text-gray-400"><?= $og['updated_at'] ? date('M j, Y', strtotime($og['updated_at'])) : '—' ?></td>
                    </tr>
                <?php endforeach; ?>
            </tbody>
        </table>
    </div>
    <?php else: ?>
        <div class="px-6 py-10 text-center">
            <i class="fas fa-clipboard-list text-gray-200 text-4xl mb-3"></i>
            <p class="text-sm text-gray-400">No grades recorded for this section yet.</p>
        </div>
    <?php endif; ?>
</div>
<?php endif; ?>

<!-- BULK IMPORT GRADES MODAL -->
<div class="modal-overlay" id="gradeImportModal">
    <div class="modal-content" style="max-width:540px;">
        <div class="flex items-center justify-between mb-6">
            <div class="flex items-center gap-3">
                <div class="w-10 h-10 bg-emerald-50 rounded-lg flex items-center justify-center modal-icon">
                    <i class="fas fa-file-upload text-emerald-600"></i>
                </div>
                <div>
                    <h3 class="text-base font-semibold text-gray-900">Bulk Import Grades</h3>
                    <p class="text-xs text-gray-500">Upload a CSV file to add or update multiple grades</p>
                </div>
            </div>
            <button onclick="closeModal('gradeImportModal')" class="modal-close"><i class="fas fa-times"></i></button>
        </div>

        <!-- Step 1: Download template -->
        <div class="bg-blue-50 border border-blue-100 rounded-lg p-4 mb-5">
            <h4 class="text-xs font-semibold text-blue-800 mb-2">Step 1: Download the Template</h4>
            <p class="text-xs text-blue-700 mb-3">Download the CSV template, fill it with grade data, then save as CSV.</p>
            <a href="<?= BASE_URL ?>students/download_grade_template.php" class="btn btn-primary btn-sm">
                <i class="fas fa-download"></i> Download Template (.csv)
            </a>
        </div>

        <!-- Format guide -->
        <div class="bg-gray-50 border border-gray-200 rounded-lg p-4 mb-5">
            <h4 class="text-xs font-semibold text-gray-700 mb-3">Required Columns</h4>
            <div class="overflow-x-auto">
                <table class="w-full text-xs">
                    <thead>
                        <tr class="text-left text-gray-400 border-b border-gray-200">
                            <th class="pb-2 pr-3">Column</th>
                            <th class="pb-2 pr-3">Required</th>
                            <th class="pb-2">Example</th>
                        </tr>
                    </thead>
                    <tbody class="text-gray-600">
                        <tr class="border-b border-gray-100"><td class="py-1.5 pr-3 font-mono font-semibold">LRN</td><td class="pr-3"><span class="text-red-500">Yes</span></td><td>100100100001</td></tr>
                        <tr class="border-b border-gray-100"><td class="py-1.5 pr-3 font-mono font-semibold">Subject Code</td><td class="pr-3"><span class="text-red-500">Yes</span></td><td>CORE04, STEM01</td></tr>
                        <tr class="border-b border-gray-100"><td class="py-1.5 pr-3 font-mono font-semibold">Q1</td><td class="pr-3"><span class="text-blue-500">Optional*</span></td><td>85.50 (60-100)</td></tr>
                        <tr class="border-b border-gray-100"><td class="py-1.5 pr-3 font-mono font-semibold">Q2</td><td class="pr-3"><span class="text-blue-500">Optional*</span></td><td>90</td></tr>
                        <tr class="border-b border-gray-100"><td class="py-1.5 pr-3 font-mono font-semibold">Q3</td><td class="pr-3"><span class="text-blue-500">Optional*</span></td><td>88</td></tr>
                        <tr class="border-b border-gray-100"><td class="py-1.5 pr-3 font-mono font-semibold">Q4</td><td class="pr-3"><span class="text-blue-500">Optional*</span></td><td>92</td></tr>
                        <tr><td class="py-1.5 pr-3 font-mono font-semibold">School Year</td><td class="pr-3"><span class="text-red-500">Yes</span></td><td>2025-2026</td></tr>
                    </tbody>
                </table>
            </div>
            <p class="text-xs text-gray-400 mt-3"><i class="fas fa-info-circle mr-1"></i>*At least one quarter column (Q1-Q4) must have a grade. Leave empty quarters blank. Existing grades will be <strong>updated</strong>.</p>
        </div>

        <!-- Step 2: Upload -->
        <form method="POST" action="<?= BASE_URL ?>students/import_grades.php" enctype="multipart/form-data" id="gradeImportForm">
            <div>
                <h4 class="text-xs font-semibold text-gray-700 mb-2">Step 2: Upload Your File</h4>
                <label class="flex flex-col items-center justify-center w-full h-32 border-2 border-gray-200 border-dashed rounded-xl cursor-pointer hover:border-blue-400 hover:bg-blue-50/30 transition-colors" id="gradeDropZone">
                    <div class="flex flex-col items-center justify-center pt-5 pb-6" id="gradeUploadPlaceholder">
                        <i class="fas fa-cloud-upload-alt text-gray-300 text-2xl mb-2"></i>
                        <p class="text-sm text-gray-500">Click to select or drag & drop</p>
                        <p class="text-xs text-gray-400 mt-1">CSV files only</p>
                    </div>
                    <div class="flex items-center gap-3 hidden" id="gradeUploadFileInfo">
                        <i class="fas fa-file-csv text-emerald-500 text-xl"></i>
                        <div>
                            <p class="text-sm font-medium text-gray-700" id="gradeUploadFileName"></p>
                            <p class="text-xs text-gray-400" id="gradeUploadFileSize"></p>
                        </div>
                    </div>
                    <input type="file" name="csv_file" class="hidden" accept=".csv,.txt" id="gradeCsvFileInput" required>
                </label>
            </div>

            <div class="flex items-center justify-end gap-4 mt-6 pt-5 border-t border-gray-200">
                <button type="button" onclick="closeModal('gradeImportModal')" class="btn btn-secondary">Cancel</button>
                <button type="button" class="btn btn-primary" id="gradeImportSubmitBtn" disabled
                        onclick="confirmSubmit(document.getElementById('gradeImportForm'), 'Import Grades?', 'Grades from the uploaded file will be inserted or updated. Rows with invalid LRN or Subject Code will be skipped.', 'Yes, import')">
                    <i class="fas fa-upload"></i> Import Grades
                </button>
            </div>
        </form>
    </div>
</div>

<script>
const gradeCsvInput   = document.getElementById('gradeCsvFileInput');
const gradeDropZone   = document.getElementById('gradeDropZone');
const gradePlaceholder = document.getElementById('gradeUploadPlaceholder');
const gradeFileInfo   = document.getElementById('gradeUploadFileInfo');
const gradeFileName   = document.getElementById('gradeUploadFileName');
const gradeFileSize   = document.getElementById('gradeUploadFileSize');
const gradeImportBtn  = document.getElementById('gradeImportSubmitBtn');

gradeCsvInput.addEventListener('change', function() {
    if (this.files.length > 0) {
        const f = this.files[0];
        gradeFileName.textContent = f.name;
        gradeFileSize.textContent = (f.size / 1024).toFixed(1) + ' KB';
        gradePlaceholder.classList.add('hidden');
        gradeFileInfo.classList.remove('hidden');
        gradeImportBtn.disabled = false;
        gradeImportBtn.classList.remove('opacity-50');
    }
});

gradeDropZone.addEventListener('dragover', function(e) {
    e.preventDefault();
    this.classList.add('border-blue-400', 'bg-blue-50/30');
});
gradeDropZone.addEventListener('dragleave', function(e) {
    e.preventDefault();
    this.classList.remove('border-blue-400', 'bg-blue-50/30');
});
gradeDropZone.addEventListener('drop', function(e) {
    e.preventDefault();
    this.classList.remove('border-blue-400', 'bg-blue-50/30');
    if (e.dataTransfer.files.length > 0) {
        gradeCsvInput.files = e.dataTransfer.files;
        gradeCsvInput.dispatchEvent(new Event('change'));
    }
});

function filterBySection() {
    const sectionSelect = document.getElementById('sectionSelect');
    const subjectSelect = document.getElementById('subjectSelect');
    const currentUrl = new URL(window.location);
    
    // Update the section parameter
    if (sectionSelect.value) {
        currentUrl.searchParams.set('section', sectionSelect.value);
    } else {
        currentUrl.searchParams.delete('section');
    }
    
    // Clear subject and quarter filters when section changes
    currentUrl.searchParams.delete('subject');
    currentUrl.searchParams.delete('quarter');
    
    // Reload the page
    window.location.href = currentUrl.toString();
}
</script>

<?php require_once __DIR__ . '/../includes/footer.php'; ?>
