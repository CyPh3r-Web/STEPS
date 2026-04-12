<?php
$pageTitle = 'Students';
require_once __DIR__ . '/../includes/header.php';
requireRole(['teacher', 'guidance']);

$sections = $pdo->query("SELECT * FROM sections ORDER BY grade_level, section_name")->fetchAll();
$strands = $pdo->query("SELECT * FROM strands ORDER BY strand_name")->fetchAll();

$search = $_GET['search'] ?? '';
$sectionFilter = $_GET['section'] ?? '';
$strandFilter = $_GET['strand'] ?? '';
$editId = $_GET['edit_id'] ?? '';

$success = '';
$error = '';
$openModal = '';
$isGuidance = (($_SESSION['role'] ?? '') === 'guidance');

// Handle Add Student
if (!$isGuidance && $_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['action']) && $_POST['action'] === 'add') {
    $lrn = sanitize($_POST['lrn']);
    $firstName = sanitize($_POST['first_name']);
    $lastName = sanitize($_POST['last_name']);
    $middleName = sanitize($_POST['middle_name']);
    $nameSuffix = sanitize($_POST['name_suffix'] ?? '');
    $gender = sanitize($_POST['gender']);
    $birthdate = sanitize($_POST['birthdate']);
    $sectionId = $_POST['section_id'] ?: null;
    $strandId = $_POST['strand_id'] ?: null;
    $schoolYear = sanitize($_POST['school_year']);

    // Auto-determine strand based on section's grade level (JHS = no strand)
    if ($sectionId) {
        $secCheck = $pdo->prepare("SELECT grade_level FROM sections WHERE id = ?");
        $secCheck->execute([$sectionId]);
        $secData = $secCheck->fetch();
        if ($secData && $secData['grade_level'] >= 7 && $secData['grade_level'] <= 10) {
            $strandId = null; // Force no strand for JHS
        }
    }

    if (empty($lrn) || empty($firstName) || empty($lastName) || empty($gender)) {
        $error = 'Please fill in all required fields.';
        $openModal = 'add';
    } else {
        $check = $pdo->prepare("SELECT id FROM students WHERE lrn = ?");
        $check->execute([$lrn]);
        if ($check->fetch()) {
            $error = 'A student with this LRN already exists.';
            $openModal = 'add';
        } else {
            try {
                $stmt = $pdo->prepare("INSERT INTO students (lrn, first_name, last_name, middle_name, name_suffix, gender, birthdate, section_id, strand_id, school_year, created_by) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)");
                $stmt->execute([$lrn, $firstName, $lastName, $middleName, $nameSuffix, $gender, $birthdate ?: null, $sectionId, $strandId, $schoolYear, $_SESSION['user_id'] ?? null]);
                header('Location: ' . BASE_URL . 'students/index.php?msg=added');
                exit;
            } catch (PDOException $e) {
                $error = 'Database error: ' . $e->getMessage();
                $openModal = 'add';
            }
        }
    }
}

// Handle Edit Student
if (!$isGuidance && $_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['action']) && $_POST['action'] === 'edit') {
    $id = (int)$_POST['student_id'];
    $lrn = sanitize($_POST['lrn']);
    $firstName = sanitize($_POST['first_name']);
    $lastName = sanitize($_POST['last_name']);
    $middleName = sanitize($_POST['middle_name']);
    $nameSuffix = sanitize($_POST['name_suffix'] ?? '');
    $gender = sanitize($_POST['gender']);
    $birthdate = sanitize($_POST['birthdate']);
    $sectionId = $_POST['section_id'] ?: null;
    $strandId = $_POST['strand_id'] ?: null;
    $schoolYear = sanitize($_POST['school_year']);

    // Auto-determine strand based on section's grade level (JHS = no strand)
    if ($sectionId) {
        $secCheck = $pdo->prepare("SELECT grade_level FROM sections WHERE id = ?");
        $secCheck->execute([$sectionId]);
        $secData = $secCheck->fetch();
        if ($secData && $secData['grade_level'] >= 7 && $secData['grade_level'] <= 10) {
            $strandId = null; // Force no strand for JHS
        }
    }

    if (empty($lrn) || empty($firstName) || empty($lastName) || empty($gender)) {
        $error = 'Please fill in all required fields.';
        $editId = $id;
        $openModal = 'edit';
    } else {
        $check = $pdo->prepare("SELECT id FROM students WHERE lrn = ? AND id != ?");
        $check->execute([$lrn, $id]);
        if ($check->fetch()) {
            $error = 'A different student with this LRN already exists.';
            $editId = $id;
            $openModal = 'edit';
        } else {
            $stmt = $pdo->prepare("UPDATE students SET lrn=?, first_name=?, last_name=?, middle_name=?, name_suffix=?, gender=?, birthdate=?, section_id=?, strand_id=?, school_year=? WHERE id=?");
            $stmt->execute([$lrn, $firstName, $lastName, $middleName, $nameSuffix, $gender, $birthdate ?: null, $sectionId, $strandId, $schoolYear, $id]);
            header('Location: ' . BASE_URL . 'students/index.php?msg=updated');
            exit;
        }
    }
}

// Handle Delete
if (!$isGuidance && $_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['delete_id'])) {
    $deleteId = $_POST['delete_id'];
    $currentUserId = $_SESSION['user_id'] ?? 0;
    $userRole = $_SESSION['role'] ?? '';
    
    // Teachers can only delete students they created
    if ($userRole === 'teacher') {
        $delStmt = $pdo->prepare("UPDATE students SET status = 'inactive' WHERE id = ? AND created_by = ?");
        $delStmt->execute([$deleteId, $currentUserId]);
    } else {
        $delStmt = $pdo->prepare("UPDATE students SET status = 'inactive' WHERE id = ?");
        $delStmt->execute([$deleteId]);
    }
    header('Location: ' . BASE_URL . 'students/index.php?msg=deleted');
    exit;
}

// Load edit data
$editStudent = null;
if ($editId) {
    $stmt = $pdo->prepare("SELECT * FROM students WHERE id = ?");
    $stmt->execute([$editId]);
    $editStudent = $stmt->fetch();
    if ($editStudent && !$openModal) $openModal = 'edit';
}

$statusFilter = $_GET['status'] ?? '';
$currentUserId = $_SESSION['user_id'] ?? 0;
$userRole = $_SESSION['role'] ?? '';

// Query students list with average grade
$query = "SELECT s.*, sec.section_name, sec.grade_level as section_grade_level, st.strand_code, st.strand_name,
          (SELECT AVG(g.grade) FROM grades g WHERE g.student_id = s.id) as avg_grade,
          u.full_name as created_by_name
          FROM students s
          LEFT JOIN sections sec ON s.section_id = sec.id
          LEFT JOIN strands st ON s.strand_id = st.id
          LEFT JOIN users u ON s.created_by = u.id
          WHERE s.status = 'active'";
$params = [];

// For teachers: only show students they personally created
if ($userRole === 'teacher') {
    $query .= " AND s.created_by = ?";
    $params[] = $currentUserId;
}

if ($search) {
    $query .= " AND (s.first_name LIKE ? OR s.last_name LIKE ? OR s.lrn LIKE ?)";
    $searchTerm = "%$search%";
    $params = array_merge($params, [$searchTerm, $searchTerm, $searchTerm]);
}
if ($sectionFilter) { $query .= " AND s.section_id = ?"; $params[] = $sectionFilter; }
if ($strandFilter) { $query .= " AND s.strand_id = ?"; $params[] = $strandFilter; }

$query .= " ORDER BY s.last_name, s.first_name";
$stmt = $pdo->prepare($query);
$stmt->execute($params);
$students = $stmt->fetchAll();

// Preserve full list for status summary cards
$studentsForStats = $students;

// Filter by competency status after fetching (for table and "Total Students" count)
if ($statusFilter) {
    $students = array_filter($students, function($s) use ($statusFilter) {
        if ($s['avg_grade'] === null) return false;
        $level = getCompetencyLevel($s['avg_grade'])['level'];
        return $level === $statusFilter;
    });
}

// Counts for quick stats should always be based on the unfiltered list (respecting search/section/strand filters)
$studentsWithGrades = array_filter($studentsForStats, fn($s) => $s['avg_grade'] !== null);
$weakStudents = count(array_filter($studentsWithGrades, fn($s) => getCompetencyLevel($s['avg_grade'])['level'] === 'weak'));
$atRiskStudents = count(array_filter($studentsWithGrades, fn($s) => getCompetencyLevel($s['avg_grade'])['level'] === 'at_risk'));
$profStudents = count(array_filter($studentsWithGrades, fn($s) => getCompetencyLevel($s['avg_grade'])['level'] === 'proficient'));

// Gender statistics
$maleStudents = count(array_filter($studentsForStats, fn($s) => strtolower($s['gender']) === 'male'));
$femaleStudents = count(array_filter($studentsForStats, fn($s) => strtolower($s['gender']) === 'female'));

require_once __DIR__ . '/../includes/sidebar.php';
?>

<?php if (isset($_GET['msg']) && $_GET['msg'] !== 'imported'): ?>
<script>
document.addEventListener('DOMContentLoaded', function() {
    <?php
    $msgs = ['added' => 'Student added successfully.', 'updated' => 'Student updated successfully.', 'deleted' => 'Student removed successfully.'];
    $msgText = $msgs[$_GET['msg']] ?? 'Action completed.';
    ?>
    Toast.fire({ icon: 'success', title: <?= json_encode($msgText) ?> });
});
</script>
<?php endif; ?>

<?php if (isset($_GET['msg']) && $_GET['msg'] === 'imported' && isset($_SESSION['import_result'])): ?>
<?php $ir = $_SESSION['import_result']; unset($_SESSION['import_result']); ?>
<script>
document.addEventListener('DOMContentLoaded', function() {
    <?php $errHtml = ''; if (!empty($ir['errors'])): ?>
        <?php $errHtml = '<div style=\"max-height:150px;overflow-y:auto;text-align:left;margin-top:12px;padding:12px;background:#f8fafc;border-radius:8px;border:1px solid #e2e8f0;\"><p style=\"font-size:12px;font-weight:600;color:#64748b;margin-bottom:6px;\">Details:</p>'; ?>
        <?php foreach (array_slice($ir['errors'], 0, 20) as $err): ?>
            <?php $errHtml .= '<p style=\"font-size:11px;color:#94a3b8;margin-bottom:2px;\">' . htmlspecialchars($err) . '</p>'; ?>
        <?php endforeach; ?>
        <?php if (count($ir['errors']) > 20) $errHtml .= '<p style=\"font-size:11px;color:#94a3b8;font-style:italic;\">...and ' . (count($ir['errors']) - 20) . ' more</p>'; ?>
        <?php $errHtml .= '</div>'; ?>
    <?php endif; ?>

    Swal.fire({
        ...swalDefaults,
        icon: <?= $ir['inserted'] > 0 ? "'success'" : "'warning'" ?>,
        title: 'Import Complete',
        html: '<div style="font-family:Poppins,sans-serif;text-align:center;">' +
              '<p style="font-size:14px;color:#64748b;margin-bottom:16px;">File: <strong><?= htmlspecialchars($ir['filename']) ?></strong></p>' +
              '<div style="display:flex;gap:12px;justify-content:center;margin-bottom:8px;">' +
              '<div style="background:#f0fdf4;border:1px solid #bbf7d0;border-radius:8px;padding:12px 20px;"><p style="font-size:24px;font-weight:700;color:#16a34a;"><?= $ir['inserted'] ?></p><p style="font-size:11px;color:#166534;">Inserted</p></div>' +
              '<div style="background:#fef2f2;border:1px solid #fecaca;border-radius:8px;padding:12px 20px;"><p style="font-size:24px;font-weight:700;color:#dc2626;"><?= $ir['skipped'] ?></p><p style="font-size:11px;color:#991b1b;">Skipped</p></div>' +
              '</div>' +
              '<?= $errHtml ?>' +
              '</div>',
        confirmButtonColor: '#2563eb',
        width: 460
    });
});
</script>
<?php endif; ?>

<?php if (isset($_GET['import_error'])): ?>
<script>
document.addEventListener('DOMContentLoaded', function() {
    Swal.fire({ ...swalDefaults, icon: 'error', title: 'Import Failed', text: <?= json_encode($_GET['import_error']) ?>, confirmButtonColor: '#2563eb' });
});
</script>
<?php endif; ?>

<?php if ($error): ?>
<script>
document.addEventListener('DOMContentLoaded', function() {
    Swal.fire({ ...swalDefaults, icon: 'error', title: 'Error', text: <?= json_encode($error) ?>, confirmButtonColor: '#2563eb' });
});
</script>
<?php endif; ?>

<!-- Filters -->
<div class="bg-white border border-gray-200 rounded-xl p-5 mb-6">
    <form method="GET" class="flex flex-wrap items-end gap-4">
        <div class="flex-1 min-w-[200px]">
            <label class="form-label">Search</label>
            <input type="text" name="search" class="form-input" placeholder="Name or LRN..." value="<?= sanitize($search) ?>">
        </div>
        <div class="w-48">
            <label class="form-label">Section</label>
            <select name="section" class="form-select">
                <option value="">All Sections</option>
                <?php foreach ($sections as $sec): ?>
                    <option value="<?= $sec['id'] ?>" <?= $sectionFilter == $sec['id'] ? 'selected' : '' ?>><?= sanitize($sec['section_name']) ?></option>
                <?php endforeach; ?>
            </select>
        </div>
        <div class="w-48">
            <label class="form-label">Strand</label>
            <input type="text" name="strand_search" id="strand_search" class="form-input" placeholder="Type to search strands..." value="<?= isset($_GET['strand_search']) ? sanitize($_GET['strand_search']) : '' ?>" list="strandList" autocomplete="off">
            <datalist id="strandList">
                <option value="">All Strands</option>
                <?php foreach ($strands as $st): ?>
                    <option value="<?= sanitize($st['strand_code']) ?>"><?= sanitize($st['strand_code'] . ' - ' . $st['strand_name']) ?></option>
                <?php endforeach; ?>
            </datalist>
            <select name="strand" id="strand_select" class="form-select mt-2" onchange="document.getElementById('strand_search').value = this.options[this.selectedIndex].text.split(' - ')[0]">
                <option value="">Or select from list</option>
                <?php foreach ($strands as $st): ?>
                    <option value="<?= $st['id'] ?>" <?= $strandFilter == $st['id'] ? 'selected' : '' ?>><?= sanitize($st['strand_code']) ?></option>
                <?php endforeach; ?>
            </select>
        </div>
        <div class="w-48">
            <label class="form-label">Status</label>
            <select name="status" class="form-select">
                <option value="">All Status</option>
                <option value="weak" <?= $statusFilter === 'weak' ? 'selected' : '' ?>>Weak (Below 75)</option>
                <option value="at_risk" <?= $statusFilter === 'at_risk' ? 'selected' : '' ?>>At Risk (75-79)</option>
                <option value="proficient" <?= $statusFilter === 'proficient' ? 'selected' : '' ?>>Proficient (80+)</option>
            </select>
        </div>
        <div class="flex gap-2">
            <button type="submit" class="btn btn-primary btn-sm"><i class="fas fa-search"></i> Filter</button>
            <a href="<?= BASE_URL ?>students/index.php" class="btn btn-secondary btn-sm"><i class="fas fa-redo"></i> Reset</a>
        </div>
    </form>
</div>

<!-- Quick Status Summary -->
<?php
$filterBase = array_filter(['search' => $search, 'section' => $sectionFilter, 'strand' => $strandFilter]);
?>
<div class="grid grid-cols-1 md:grid-cols-4 gap-5 mb-6">
    <a href="?<?= http_build_query($filterBase) ?>" class="stat-card <?= !$statusFilter ? 'ring-2 ring-gray-300' : '' ?>" style="background:#f8fafc;">
        <div class="flex items-center justify-between mb-3">
            <span class="text-sm font-medium text-gray-600">Total Students</span>
            <div class="w-10 h-10 rounded-lg flex items-center justify-center" style="background:#e2e8f0;">
                <i class="fas fa-users" style="color:#475569;"></i>
            </div>
        </div>
        <p class="text-3xl font-bold text-gray-800"><?= count($students) ?></p>
        <p class="text-xs text-gray-400 mt-1">Active enrollees</p>
    </a>
    <a href="?<?= http_build_query(array_merge($filterBase, ['status' => 'weak'])) ?>" class="stat-card <?= $statusFilter === 'weak' ? 'ring-2 ring-gray-300' : '' ?>" style="background:#fef2f2;">
        <div class="flex items-center justify-between mb-3">
            <span class="text-sm font-medium text-gray-600">Weak</span>
            <div class="w-10 h-10 rounded-lg flex items-center justify-center" style="background:#fee2e2;">
                <i class="fas fa-exclamation-circle" style="color:#b91c1c;"></i>
            </div>
        </div>
        <p class="text-3xl font-bold text-gray-800"><?= $weakStudents ?></p>
        <p class="text-xs text-gray-500 mt-1">Below 75 — Did Not Meet Expectations</p>
    </a>
    <a href="?<?= http_build_query(array_merge($filterBase, ['status' => 'at_risk'])) ?>" class="stat-card <?= $statusFilter === 'at_risk' ? 'ring-2 ring-gray-300' : '' ?>" style="background:#fffbeb;">
        <div class="flex items-center justify-between mb-3">
            <span class="text-sm font-medium text-gray-600">At Risk</span>
            <div class="w-10 h-10 rounded-lg flex items-center justify-center" style="background:#fef3c7;">
                <i class="fas fa-exclamation-triangle" style="color:#92400e;"></i>
            </div>
        </div>
        <p class="text-3xl font-bold text-gray-800"><?= $atRiskStudents ?></p>
        <p class="text-xs text-gray-500 mt-1">75-79 — Needs Reinforcement</p>
    </a>
    <a href="?<?= http_build_query(array_merge($filterBase, ['status' => 'proficient'])) ?>" class="stat-card <?= $statusFilter === 'proficient' ? 'ring-2 ring-gray-300' : '' ?>" style="background:#f0fdf4;">
        <div class="flex items-center justify-between mb-3">
            <span class="text-sm font-medium text-gray-600">Proficient</span>
            <div class="w-10 h-10 rounded-lg flex items-center justify-center" style="background:#dcfce7;">
                <i class="fas fa-check-circle" style="color:#166534;"></i>
            </div>
        </div>
        <p class="text-3xl font-bold text-gray-800"><?= $profStudents ?></p>
        <p class="text-xs text-gray-500 mt-1">80 and above — Meets Expectations</p>
    </a>
</div>

<!-- Gender Statistics Summary -->
<div class="grid grid-cols-1 md:grid-cols-2 gap-5 mb-6">
    <div class="stat-card bg-blue-50">
        <div class="flex items-center justify-between mb-3">
            <span class="text-sm font-medium text-gray-600">Male Students</span>
            <div class="w-10 h-10 rounded-lg flex items-center justify-center bg-blue-100">
                <i class="fas fa-male text-blue-600"></i>
            </div>
        </div>
        <p class="text-3xl font-bold text-gray-800"><?= $maleStudents ?></p>
        <p class="text-xs text-gray-400 mt-1"><?= count($studentsForStats) > 0 ? round(($maleStudents / count($studentsForStats)) * 100, 1) : 0 ?>% of total</p>
    </div>
    <div class="stat-card bg-pink-50">
        <div class="flex items-center justify-between mb-3">
            <span class="text-sm font-medium text-gray-600">Female Students</span>
            <div class="w-10 h-10 rounded-lg flex items-center justify-center bg-pink-100">
                <i class="fas fa-female text-pink-600"></i>
            </div>
        </div>
        <p class="text-3xl font-bold text-gray-800"><?= $femaleStudents ?></p>
        <p class="text-xs text-gray-400 mt-1"><?= count($studentsForStats) > 0 ? round(($femaleStudents / count($studentsForStats)) * 100, 1) : 0 ?>% of total</p>
    </div>
</div>

<div class="flex items-center justify-between mb-4">
    <div class="flex items-center gap-3">
        <p class="text-sm text-gray-500"><?= count($students) ?> student(s) found</p>
        <?php if ($statusFilter): ?>
            <a href="?<?= http_build_query(array_filter(['search' => $search, 'section' => $sectionFilter, 'strand' => $strandFilter])) ?>" class="btn btn-secondary btn-sm">
                <i class="fas fa-times"></i> Clear Status Filter
            </a>
        <?php endif; ?>
    </div>
    <?php if (!$isGuidance): ?>
    <div class="flex gap-2">
        <button onclick="openModal('importModal')" class="btn btn-secondary btn-sm">
            <i class="fas fa-file-upload"></i> Bulk Import
        </button>
        <button onclick="openModal('addStudentModal')" class="btn btn-primary btn-sm">
            <i class="fas fa-plus"></i> Add Student
        </button>
    </div>
    <?php endif; ?>
</div>

<!-- Students Table -->
<div class="bg-white border border-gray-200 rounded-xl overflow-hidden">
    <div class="overflow-x-auto">
        <table class="steps-table" id="studentsTable">
            <thead>
                <tr>
                    <th>LRN</th>
                    <th>Full Name</th>
                    <th>Gender</th>
                    <th>Section</th>
                    <th>Grade Level</th>
                    <th>Strand</th>
                    <th>Added By</th>
                    <?php if (!$isGuidance): ?>
                    <th>Avg</th>
                    <th>Status</th>
                    <?php endif; ?>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <?php foreach ($students as $s): ?>
                    <?php $comp = $s['avg_grade'] !== null ? getCompetencyLevel($s['avg_grade']) : null; ?>
                    <tr>
                        <td class="text-xs font-mono"><?= sanitize($s['lrn']) ?></td>
                        <td class="font-medium"><?= sanitize($s['last_name'] . ', ' . $s['first_name'] . ' ' . ($s['middle_name'] ?? '')) ?></td>
                        <td><?= $s['gender'] ?></td>
                        <td><?= sanitize($s['section_name'] ?? 'N/A') ?></td>
                        <td><?= $s['grade_level'] ?? $s['section_grade_level'] ?? 'N/A' ?></td>
                        <td><span class="badge badge-blue"><?= sanitize($s['strand'] ?? $s['strand_code'] ?? 'N/A') ?></span></td>
                        <td class="text-xs text-gray-500"><?= sanitize($s['created_by_name'] ?? 'Unknown') ?></td>
                        <?php if (!$isGuidance): ?>
                        <td class="font-semibold"><?= $s['avg_grade'] !== null ? formatNumber($s['avg_grade']) : '<span class="text-gray-300">—</span>' ?></td>
                        <td>
                            <?php if ($comp): ?>
                                <span class="badge badge-<?= $comp['color'] === 'emerald' ? 'green' : $comp['color'] ?>">
                                    <?= $comp['label'] ?>
                                </span>
                            <?php else: ?>
                                <span class="text-gray-300 text-xs">No grades</span>
                            <?php endif; ?>
                        </td>
                        <?php endif; ?>
                        <td>
                            <div class="flex items-center gap-2">
                                <a href="<?= BASE_URL ?>students/view.php?id=<?= $s['id'] ?>" class="text-blue-600 hover:text-blue-800" title="View"><i class="fas fa-eye"></i></a>
                                <?php if (!$isGuidance): ?>
                                <button onclick="loadEditStudent(<?= $s['id'] ?>)" class="text-gray-500 hover:text-gray-700" title="Edit"><i class="fas fa-edit"></i></button>
                                <form method="POST" class="inline" onsubmit="event.preventDefault(); confirmDelete(this, 'this student');">
                                    <input type="hidden" name="delete_id" value="<?= $s['id'] ?>">
                                    <button type="submit" class="text-red-500 hover:text-red-700" title="Remove"><i class="fas fa-trash"></i></button>
                                </form>
                                <?php endif; ?>
                            </div>
                        </td>
                    </tr>
                <?php endforeach; ?>
                <?php if (empty($students)): ?>
                    <tr><td colspan="<?= $isGuidance ? 8 : 10 ?>" class="text-center py-8">
                        <?php if ($userRole === 'teacher'): ?>
                            <div class="text-gray-500">
                                <i class="fas fa-users text-4xl mb-3 text-gray-300"></i>
                                <p class="font-medium">No students found.</p>
                                <p class="text-sm mt-1">Start by adding a new student using the button above.</p>
                            </div>
                        <?php else: ?>
                            <span class="text-gray-400">No students found.</span>
                        <?php endif; ?>
                    </td></tr>
                <?php endif; ?>
            </tbody>
        </table>
    </div>
</div>

<?php if (!$isGuidance): ?>
<!-- ADD STUDENT MODAL -->
<div class="modal-overlay" id="addStudentModal">
    <div class="modal-content" style="max-width:620px;">
        <div class="flex items-center justify-between mb-6">
            <div class="flex items-center gap-3">
                <div class="w-10 h-10 bg-blue-50 rounded-lg flex items-center justify-center modal-icon">
                    <i class="fas fa-user-plus text-blue-600"></i>
                </div>
                <h3 class="text-base font-semibold text-gray-900">Add New Student</h3>
            </div>
            <button onclick="closeModal('addStudentModal')" class="modal-close"><i class="fas fa-times"></i></button>
        </div>
        <form method="POST">
            <input type="hidden" name="action" value="add">
            <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                <div class="md:col-span-2">
                    <label class="form-label">LRN <span class="text-red-500">*</span></label>
                    <input type="text" name="lrn" class="form-input" required maxlength="20" inputmode="numeric" pattern="[0-9]*" oninput="this.value = this.value.replace(/[^0-9]/g, '')" placeholder="Learner Reference Number" value="<?= $openModal === 'add' ? sanitize($lrn ?? '') : '' ?>">
                </div>
                <div>
                    <label class="form-label">Last Name <span class="text-red-500">*</span></label>
                    <input type="text" name="last_name" class="form-input" required value="<?= $openModal === 'add' ? sanitize($lastName ?? '') : '' ?>" oninput="this.value = this.value.replace(/[^a-zA-Z\s]/g, '')" placeholder="Letters only">
                </div>
                <div>
                    <label class="form-label">First Name <span class="text-red-500">*</span></label>
                    <input type="text" name="first_name" class="form-input" required value="<?= $openModal === 'add' ? sanitize($firstName ?? '') : '' ?>" oninput="this.value = this.value.replace(/[^a-zA-Z\s]/g, '')" placeholder="Letters only">
                </div>
                <div>
                    <label class="form-label">Middle Name</label>
                    <input type="text" name="middle_name" class="form-input" value="<?= $openModal === 'add' ? sanitize($middleName ?? '') : '' ?>" oninput="this.value = this.value.replace(/[^a-zA-Z\s]/g, '')" placeholder="Optional">
                </div>
                <div>
                    <label class="form-label">Name Suffix <span class="text-gray-400 font-normal">(Optional)</span></label>
                    <select name="name_suffix" class="form-select">
                        <option value="">None</option>
                        <option value="Jr." <?= ($openModal === 'add' && ($nameSuffix ?? '') === 'Jr.') ? 'selected' : '' ?>>Jr.</option>
                        <option value="Sr." <?= ($openModal === 'add' && ($nameSuffix ?? '') === 'Sr.') ? 'selected' : '' ?>>Sr.</option>
                        <option value="II" <?= ($openModal === 'add' && ($nameSuffix ?? '') === 'II') ? 'selected' : '' ?>>II</option>
                        <option value="III" <?= ($openModal === 'add' && ($nameSuffix ?? '') === 'III') ? 'selected' : '' ?>>III</option>
                        <option value="IV" <?= ($openModal === 'add' && ($nameSuffix ?? '') === 'IV') ? 'selected' : '' ?>>IV</option>
                        <option value="V" <?= ($openModal === 'add' && ($nameSuffix ?? '') === 'V') ? 'selected' : '' ?>>V</option>
                    </select>
                </div>
                <div>
                    <label class="form-label">Gender <span class="text-red-500">*</span></label>
                    <select name="gender" class="form-select" required>
                        <option value="">Select</option>
                        <option value="Male" <?= ($openModal === 'add' && ($gender ?? '') === 'Male') ? 'selected' : '' ?>>Male</option>
                        <option value="Female" <?= ($openModal === 'add' && ($gender ?? '') === 'Female') ? 'selected' : '' ?>>Female</option>
                    </select>
                </div>
                <div>
                    <label class="form-label">Birthdate</label>
                    <input type="date" name="birthdate" class="form-input" value="<?= $openModal === 'add' ? sanitize($birthdate ?? '') : '' ?>">
                </div>
                <div>
                    <label class="form-label">Section</label>
                    <select name="section_id" id="add_section_id" class="form-select" onchange="updateStrandField('add_section_id', 'add_strand_container')">
                        <option value="">Select Section</option>
                        <?php foreach ($sections as $sec): ?>
                            <option value="<?= $sec['id'] ?>" data-grade="<?= $sec['grade_level'] ?>"><?= sanitize($sec['section_name']) ?> (G<?= $sec['grade_level'] ?>)</option>
                        <?php endforeach; ?>
                    </select>
                </div>
                <div id="add_strand_container">
                    <label class="form-label">Strand</label>
                    <select name="strand_id" class="form-select">
                        <option value="">Select Strand</option>
                        <?php foreach ($strands as $st): ?>
                            <option value="<?= $st['id'] ?>"><?= sanitize($st['strand_code'] . ' - ' . $st['strand_name']) ?></option>
                        <?php endforeach; ?>
                    </select>
                </div>
                <div>
                    <label class="form-label">School Year <span class="text-red-500">*</span></label>
                    <input type="text" name="school_year" class="form-input" required value="<?= effectiveSchoolYear() ?>" placeholder="e.g., 2025-2026">
                </div>
            </div>
            <div class="flex items-center justify-end gap-4 mt-6 pt-5 border-t border-gray-200">
                <button type="button" onclick="closeModal('addStudentModal')" class="btn btn-secondary">Cancel</button>
                <button type="submit" class="btn btn-primary"><i class="fas fa-save"></i> Save Student</button>
            </div>
        </form>
    </div>
</div>

<!-- EDIT STUDENT MODAL -->
<div class="modal-overlay" id="editStudentModal">
    <div class="modal-content" style="max-width:620px;">
        <div class="flex items-center justify-between mb-6">
            <div class="flex items-center gap-3">
                <div class="w-10 h-10 bg-amber-50 rounded-lg flex items-center justify-center modal-icon">
                    <i class="fas fa-edit text-amber-600"></i>
                </div>
                <h3 class="text-base font-semibold text-gray-900">Edit Student</h3>
            </div>
            <button onclick="closeModal('editStudentModal')" class="modal-close"><i class="fas fa-times"></i></button>
        </div>
        <form method="POST" id="editStudentForm">
            <input type="hidden" name="action" value="edit">
            <input type="hidden" name="student_id" id="edit_student_id" value="<?= $editStudent['id'] ?? '' ?>">
            <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                <div class="md:col-span-2">
                    <label class="form-label">LRN <span class="text-red-500">*</span></label>
                    <input type="text" name="lrn" id="edit_lrn" class="form-input" required maxlength="20" inputmode="numeric" pattern="[0-9]*" oninput="this.value = this.value.replace(/[^0-9]/g, '')" value="<?= sanitize($editStudent['lrn'] ?? '') ?>">
                </div>
                <div>
                    <label class="form-label">Last Name <span class="text-red-500">*</span></label>
                    <input type="text" name="last_name" id="edit_last_name" class="form-input" required value="<?= sanitize($editStudent['last_name'] ?? '') ?>" oninput="this.value = this.value.replace(/[^a-zA-Z\s]/g, '')">
                </div>
                <div>
                    <label class="form-label">First Name <span class="text-red-500">*</span></label>
                    <input type="text" name="first_name" id="edit_first_name" class="form-input" required value="<?= sanitize($editStudent['first_name'] ?? '') ?>" oninput="this.value = this.value.replace(/[^a-zA-Z\s]/g, '')">
                </div>
                <div>
                    <label class="form-label">Middle Name</label>
                    <input type="text" name="middle_name" id="edit_middle_name" class="form-input" value="<?= sanitize($editStudent['middle_name'] ?? '') ?>" oninput="this.value = this.value.replace(/[^a-zA-Z\s]/g, '')" placeholder="Optional">
                </div>
                <div>
                    <label class="form-label">Name Suffix <span class="text-gray-400 font-normal">(Optional)</span></label>
                    <select name="name_suffix" id="edit_name_suffix" class="form-select">
                        <option value="">None</option>
                        <option value="Jr." <?= ($editStudent['name_suffix'] ?? '') === 'Jr.' ? 'selected' : '' ?>>Jr.</option>
                        <option value="Sr." <?= ($editStudent['name_suffix'] ?? '') === 'Sr.' ? 'selected' : '' ?>>Sr.</option>
                        <option value="II" <?= ($editStudent['name_suffix'] ?? '') === 'II' ? 'selected' : '' ?>>II</option>
                        <option value="III" <?= ($editStudent['name_suffix'] ?? '') === 'III' ? 'selected' : '' ?>>III</option>
                        <option value="IV" <?= ($editStudent['name_suffix'] ?? '') === 'IV' ? 'selected' : '' ?>>IV</option>
                        <option value="V" <?= ($editStudent['name_suffix'] ?? '') === 'V' ? 'selected' : '' ?>>V</option>
                    </select>
                </div>
                <div>
                    <label class="form-label">Gender <span class="text-red-500">*</span></label>
                    <select name="gender" id="edit_gender" class="form-select" required>
                        <option value="Male" <?= ($editStudent['gender'] ?? '') === 'Male' ? 'selected' : '' ?>>Male</option>
                        <option value="Female" <?= ($editStudent['gender'] ?? '') === 'Female' ? 'selected' : '' ?>>Female</option>
                    </select>
                </div>
                <div>
                    <label class="form-label">Birthdate</label>
                    <input type="date" name="birthdate" id="edit_birthdate" class="form-input" value="<?= sanitize($editStudent['birthdate'] ?? '') ?>">
                </div>
                <div>
                    <label class="form-label">Section</label>
                    <select name="section_id" id="edit_section_id" class="form-select" onchange="updateStrandField('edit_section_id', 'edit_strand_container')">
                        <option value="">Select Section</option>
                        <?php foreach ($sections as $sec): ?>
                            <option value="<?= $sec['id'] ?>" data-grade="<?= $sec['grade_level'] ?>" <?= ($editStudent['section_id'] ?? '') == $sec['id'] ? 'selected' : '' ?>><?= sanitize($sec['section_name']) ?> (G<?= $sec['grade_level'] ?>)</option>
                        <?php endforeach; ?>
                    </select>
                </div>
                <div id="edit_strand_container">
                    <label class="form-label">Strand</label>
                    <select name="strand_id" id="edit_strand_id" class="form-select">
                        <option value="">Select Strand</option>
                        <?php foreach ($strands as $st): ?>
                            <option value="<?= $st['id'] ?>" <?= ($editStudent['strand_id'] ?? '') == $st['id'] ? 'selected' : '' ?>><?= sanitize($st['strand_code'] . ' - ' . $st['strand_name']) ?></option>
                        <?php endforeach; ?>
                    </select>
                </div>
                <div>
                    <label class="form-label">School Year <span class="text-red-500">*</span></label>
                    <input type="text" name="school_year" id="edit_school_year" class="form-input" required value="<?= sanitize($editStudent['school_year'] ?? effectiveSchoolYear()) ?>">
                </div>
            </div>
            <div class="flex items-center justify-end gap-4 mt-6 pt-5 border-t border-gray-200">
                <button type="button" onclick="closeModal('editStudentModal')" class="btn btn-secondary">Cancel</button>
                <button type="submit" class="btn btn-primary"><i class="fas fa-save"></i> Update Student</button>
            </div>
        </form>
    </div>
</div>

<!-- BULK IMPORT MODAL -->
<div class="modal-overlay" id="importModal">
    <div class="modal-content" style="max-width:520px;">
        <div class="flex items-center justify-between mb-6">
            <div class="flex items-center gap-3">
                <div class="w-10 h-10 bg-emerald-50 rounded-lg flex items-center justify-center modal-icon">
                    <i class="fas fa-file-upload text-emerald-600"></i>
                </div>
                <div>
                    <h3 class="text-base font-semibold text-gray-900">Bulk Import Students</h3>
                    <p class="text-xs text-gray-500">Upload a CSV file to add multiple students</p>
                </div>
            </div>
            <button onclick="closeModal('importModal')" class="modal-close"><i class="fas fa-times"></i></button>
        </div>

        <!-- Step 1: Download template -->
        <div class="bg-blue-50 border border-blue-100 rounded-lg p-4 mb-5">
            <h4 class="text-xs font-semibold text-blue-800 mb-2">Step 1: Download the Template</h4>
            <p class="text-xs text-blue-700 mb-3">Download the CSV template, fill it with student data in Excel or any spreadsheet app, then save as CSV.</p>
            <a href="<?= BASE_URL ?>students/download_template.php" class="btn btn-primary btn-sm">
                <i class="fas fa-download"></i> Download Template (.csv)
            </a>
        </div>

        <!-- Format guide -->
        <div class="bg-gray-50 border border-gray-200 rounded-lg p-4 mb-5">
            <h4 class="text-xs font-semibold text-gray-700 mb-2">Required Columns</h4>
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
                        <tr class="border-b border-gray-100"><td class="py-1.5 pr-3 font-mono font-semibold">Last Name</td><td class="pr-3"><span class="text-red-500">Yes</span></td><td>Dela Cruz</td></tr>
                        <tr class="border-b border-gray-100"><td class="py-1.5 pr-3 font-mono font-semibold">First Name</td><td class="pr-3"><span class="text-red-500">Yes</span></td><td>Juan</td></tr>
                        <tr class="border-b border-gray-100"><td class="py-1.5 pr-3 font-mono font-semibold">Middle Name</td><td class="pr-3">No</td><td>Santos</td></tr>
                        <tr class="border-b border-gray-100"><td class="py-1.5 pr-3 font-mono font-semibold">Name Suffix</td><td class="pr-3">No</td><td>Jr., Sr., III</td></tr>
                        <tr class="border-b border-gray-100"><td class="py-1.5 pr-3 font-mono font-semibold">Gender</td><td class="pr-3"><span class="text-red-500">Yes</span></td><td>Male / Female</td></tr>
                        <tr class="border-b border-gray-100"><td class="py-1.5 pr-3 font-mono font-semibold">Birthdate</td><td class="pr-3">No</td><td>2008-03-15</td></tr>
                        <tr class="border-b border-gray-100"><td class="py-1.5 pr-3 font-mono font-semibold">Section Name</td><td class="pr-3">No</td><td>Section A</td></tr>
                        <tr class="border-b border-gray-100"><td class="py-1.5 pr-3 font-mono font-semibold">Strand Code</td><td class="pr-3">No</td><td>STEM-11, ABM-12</td></tr>
                        <tr><td colspan="3" class="py-2 text-xs text-gray-400 italic">Strand Code format: STRAND-GRADE (e.g., STEM-11, ABM-12). Grade must be 11 or 12.</td></tr>
                        <tr><td class="py-1.5 pr-3 font-mono font-semibold">School Year</td><td class="pr-3"><span class="text-red-500">Yes</span></td><td>2025-2026</td></tr>
                    </tbody>
                </table>
            </div>
        </div>

        <!-- Step 2: Upload -->
        <form method="POST" action="<?= BASE_URL ?>students/import.php" enctype="multipart/form-data" id="importForm">
            <div>
                <h4 class="text-xs font-semibold text-gray-700 mb-2">Step 2: Upload Your File</h4>
                <label class="flex flex-col items-center justify-center w-full h-32 border-2 border-gray-200 border-dashed rounded-xl cursor-pointer hover:border-blue-400 hover:bg-blue-50/30 transition-colors" id="dropZone">
                    <div class="flex flex-col items-center justify-center pt-5 pb-6" id="uploadPlaceholder">
                        <i class="fas fa-cloud-upload-alt text-gray-300 text-2xl mb-2"></i>
                        <p class="text-sm text-gray-500">Click to select or drag & drop</p>
                        <p class="text-xs text-gray-400 mt-1">CSV files only</p>
                    </div>
                    <div class="flex items-center gap-3 hidden" id="uploadFileInfo">
                        <i class="fas fa-file-csv text-emerald-500 text-xl"></i>
                        <div>
                            <p class="text-sm font-medium text-gray-700" id="uploadFileName"></p>
                            <p class="text-xs text-gray-400" id="uploadFileSize"></p>
                        </div>
                    </div>
                    <input type="file" name="csv_file" class="hidden" accept=".csv,.txt" id="csvFileInput" required>
                </label>
            </div>

            <div class="flex items-center justify-end gap-4 mt-6 pt-5 border-t border-gray-200">
                <button type="button" onclick="closeModal('importModal')" class="btn btn-secondary">Cancel</button>
                <button type="button" class="btn btn-primary" id="importSubmitBtn" disabled
                        onclick="confirmSubmit(document.getElementById('importForm'), 'Import Students?', 'Students from the uploaded file will be added to the system. Duplicate LRNs will be skipped.', 'Yes, import')">
                    <i class="fas fa-upload"></i> Import Students
                </button>
            </div>
        </form>
    </div>
</div>
<?php endif; ?>

<script>
// File upload UX
<?php if (!$isGuidance): ?>
const csvInput = document.getElementById('csvFileInput');
const dropZone = document.getElementById('dropZone');
const placeholder = document.getElementById('uploadPlaceholder');
const fileInfo = document.getElementById('uploadFileInfo');
const fileName = document.getElementById('uploadFileName');
const fileSize = document.getElementById('uploadFileSize');
const importBtn = document.getElementById('importSubmitBtn');

csvInput.addEventListener('change', function() {
    if (this.files.length > 0) {
        const f = this.files[0];
        fileName.textContent = f.name;
        fileSize.textContent = (f.size / 1024).toFixed(1) + ' KB';
        placeholder.classList.add('hidden');
        fileInfo.classList.remove('hidden');
        importBtn.disabled = false;
        importBtn.classList.remove('opacity-50');
    }
});

dropZone.addEventListener('dragover', function(e) {
    e.preventDefault();
    this.classList.add('border-blue-400', 'bg-blue-50/30');
});
dropZone.addEventListener('dragleave', function(e) {
    e.preventDefault();
    this.classList.remove('border-blue-400', 'bg-blue-50/30');
});
dropZone.addEventListener('drop', function(e) {
    e.preventDefault();
    this.classList.remove('border-blue-400', 'bg-blue-50/30');
    if (e.dataTransfer.files.length > 0) {
        csvInput.files = e.dataTransfer.files;
        csvInput.dispatchEvent(new Event('change'));
    }
});
<?php endif; ?>
</script>

<?php if (!$isGuidance): ?>
<script>
<?php
$studentDataMap = [];
foreach ($students as $s) {
    $studentDataMap[$s['id']] = [
        'id' => $s['id'], 'lrn' => $s['lrn'],
        'first_name' => $s['first_name'], 'last_name' => $s['last_name'],
        'middle_name' => $s['middle_name'] ?? '', 'gender' => $s['gender'],
        'birthdate' => $s['birthdate'] ?? '', 'section_id' => $s['section_id'] ?? '',
        'strand_id' => $s['strand_id'] ?? '', 'school_year' => $s['school_year'],
        'name_suffix' => $s['name_suffix'] ?? ''
    ];
}
?>
const studentData = <?= json_encode($studentDataMap) ?>;

// Section grade levels for strand field visibility
const sectionGradeLevels = <?= json_encode(array_column($sections, 'grade_level', 'id')) ?>;

function updateStrandField(sectionSelectId, strandContainerId) {
    const sectionSelect = document.getElementById(sectionSelectId);
    const strandContainer = document.getElementById(strandContainerId);
    if (!sectionSelect || !strandContainer) return;
    
    const selectedOption = sectionSelect.options[sectionSelect.selectedIndex];
    const gradeLevel = selectedOption ? parseInt(selectedOption.getAttribute('data-grade')) : 0;
    
    // Hide strand for JHS (Grades 7-10), show for SHS (Grades 11-12)
    if (gradeLevel >= 7 && gradeLevel <= 10) {
        strandContainer.style.display = 'none';
        strandContainer.querySelector('select').value = ''; // Clear strand selection
    } else {
        strandContainer.style.display = 'block';
    }
}

function loadEditStudent(id) {
    const s = studentData[id];
    if (!s) return;
    document.getElementById('edit_student_id').value = s.id;
    document.getElementById('edit_lrn').value = s.lrn;
    document.getElementById('edit_last_name').value = s.last_name;
    document.getElementById('edit_first_name').value = s.first_name;
    document.getElementById('edit_middle_name').value = s.middle_name;
    document.getElementById('edit_gender').value = s.gender;
    document.getElementById('edit_birthdate').value = s.birthdate;
    document.getElementById('edit_section_id').value = s.section_id;
    document.getElementById('edit_strand_id').value = s.strand_id;
    document.getElementById('edit_school_year').value = s.school_year;
    document.getElementById('edit_name_suffix').value = s.name_suffix || '';
    updateStrandField('edit_section_id', 'edit_strand_container');
    openModal('editStudentModal');
}

<?php if ($openModal === 'add'): ?>
document.addEventListener('DOMContentLoaded', function() { openModal('addStudentModal'); updateStrandField('add_section_id', 'add_strand_container'); });
<?php elseif ($openModal === 'edit'): ?>
document.addEventListener('DOMContentLoaded', function() { openModal('editStudentModal'); updateStrandField('edit_section_id', 'edit_strand_container'); });
<?php endif; ?>
</script>
<?php endif; ?>

<?php require_once __DIR__ . '/../includes/footer.php'; ?>
