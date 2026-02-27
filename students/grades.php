<?php
$pageTitle = 'Manage Grades';
require_once __DIR__ . '/../includes/header.php';
requireRole(['teacher', 'admin']);

$sections = $pdo->query("SELECT * FROM sections ORDER BY grade_level, section_name")->fetchAll();
$subjects = $pdo->query("SELECT * FROM subjects ORDER BY subject_name")->fetchAll();

$sectionFilter = $_GET['section'] ?? '';
$subjectFilter = $_GET['subject'] ?? '';
$quarterFilter = $_GET['quarter'] ?? '';

$success = '';
$error = '';

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
if ($sectionFilter && $subjectFilter && $quarterFilter) {
    $stmt = $pdo->prepare("SELECT s.*, 
        (SELECT g.grade FROM grades g WHERE g.student_id = s.id AND g.subject_id = ? AND g.quarter = ? AND g.school_year = ? LIMIT 1) as existing_grade
        FROM students s WHERE s.section_id = ? AND s.status = 'active' ORDER BY s.last_name, s.first_name");
    $stmt->execute([$subjectFilter, $quarterFilter, SCHOOL_YEAR, $sectionFilter]);
    $students = $stmt->fetchAll();
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

<!-- Filters -->
<div class="bg-white border border-gray-200 rounded-xl p-5 mb-6">
    <form method="GET" class="flex flex-wrap items-end gap-4">
        <div class="w-48">
            <label class="form-label">Section</label>
            <select name="section" class="form-select" required>
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
            <select name="subject" class="form-select" required>
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
    </form>
</div>

<?php if (!empty($students)): ?>
<div class="bg-white border border-gray-200 rounded-xl overflow-hidden">
    <form method="POST">
        <input type="hidden" name="action" value="save_grades">
        <input type="hidden" name="subject_id" value="<?= $subjectFilter ?>">
        <input type="hidden" name="quarter" value="<?= $quarterFilter ?>">
        <input type="hidden" name="school_year" value="<?= SCHOOL_YEAR ?>">

        <div class="px-6 py-4 border-b border-gray-200 flex items-center justify-between">
            <h3 class="text-sm font-semibold text-gray-900">
                Enter Grades — <?= $quarterFilter ?>
                <span class="text-gray-400 font-normal">(<?= count($students) ?> students)</span>
            </h3>
            <button type="submit" class="btn btn-primary btn-sm"><i class="fas fa-save"></i> Save All Grades</button>
        </div>

        <table class="steps-table">
            <thead>
                <tr>
                    <th>#</th>
                    <th>Student Name</th>
                    <th>LRN</th>
                    <th>Grade</th>
                </tr>
            </thead>
            <tbody>
                <?php foreach ($students as $i => $s): ?>
                    <tr>
                        <td class="text-gray-400"><?= $i + 1 ?></td>
                        <td class="font-medium">
                            <input type="hidden" name="student_id[]" value="<?= $s['id'] ?>">
                            <?= sanitize($s['last_name'] . ', ' . $s['first_name']) ?>
                        </td>
                        <td class="text-xs font-mono text-gray-500"><?= sanitize($s['lrn']) ?></td>
                        <td>
                            <input type="number" name="grade[]" class="form-input w-28" min="60" max="100" step="0.01"
                                   value="<?= $s['existing_grade'] ?? '' ?>" placeholder="0.00">
                        </td>
                    </tr>
                <?php endforeach; ?>
            </tbody>
        </table>
    </form>
</div>
<?php elseif ($sectionFilter && $subjectFilter && $quarterFilter): ?>
    <div class="bg-white border border-gray-200 rounded-xl p-8 text-center">
        <i class="fas fa-users text-gray-300 text-4xl mb-3"></i>
        <p class="text-gray-500">No students found in this section.</p>
    </div>
<?php endif; ?>

<?php require_once __DIR__ . '/../includes/footer.php'; ?>
