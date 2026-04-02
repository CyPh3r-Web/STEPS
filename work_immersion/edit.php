<?php
$pageTitle = 'Edit Work Immersion';
require_once __DIR__ . '/../includes/header.php';
requireRole(['teacher', 'guidance']);

$id = $_GET['id'] ?? 0;
$stmt = $pdo->prepare("SELECT wi.*, s.first_name, s.last_name, s.lrn, sec.section_name, sec.grade_level
    FROM work_immersion wi
    JOIN students s ON wi.student_id = s.id
    LEFT JOIN sections sec ON s.section_id = sec.id
    WHERE wi.id = ?");
$stmt->execute([$id]);
$record = $stmt->fetch();

if (!$record) {
    header('Location: ' . BASE_URL . 'work_immersion/index.php');
    exit;
}

$error = '';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $companyName = sanitize($_POST['company_name'] ?? '');
    $rating = $_POST['rating'] ?? '';
    $hoursCompleted = (int)($_POST['hours_completed'] ?? 0);
    $performanceRemarks = sanitize($_POST['performance_remarks'] ?? '');
    $schoolYear = sanitize($_POST['school_year'] ?? effectiveSchoolYear());

    if ($rating === '' || !is_numeric($rating)) {
        $error = 'Please enter a valid rating (0-100).';
    } elseif ((float)$rating < 0 || (float)$rating > 100) {
        $error = 'Rating must be between 0 and 100.';
    } else {
        $dup = $pdo->prepare("SELECT id FROM work_immersion WHERE student_id = ? AND school_year = ? AND id != ?");
        $dup->execute([$record['student_id'], $schoolYear, $id]);
        if ($dup->fetch()) {
            $error = 'Another work immersion record already exists for this student in ' . $schoolYear . '.';
        } else {
            $upd = $pdo->prepare("UPDATE work_immersion SET company_name=?, rating=?, hours_completed=?, performance_remarks=?, school_year=? WHERE id=?");
            $upd->execute([$companyName ?: null, $rating, $hoursCompleted ?: 0, $performanceRemarks ?: null, $schoolYear, $id]);
            header('Location: ' . BASE_URL . 'work_immersion/index.php?msg=updated');
            exit;
        }
    }
}

require_once __DIR__ . '/../includes/sidebar.php';
?>

<div class="max-w-2xl">
    <a href="<?= BASE_URL ?>work_immersion/index.php" class="inline-flex items-center gap-2 text-sm text-gray-500 hover:text-gray-700 mb-6">
        <i class="fas fa-arrow-left"></i> Back to Work Immersion
    </a>

    <?php if ($error): ?>
    <script>
    document.addEventListener('DOMContentLoaded', function() {
        Swal.fire({ ...swalDefaults, icon: 'error', title: 'Error', text: <?= json_encode($error) ?>, confirmButtonColor: '#2563eb' });
    });
    </script>
    <?php endif; ?>

    <div class="bg-white border border-gray-200 rounded-xl p-6">
        <h3 class="text-base font-semibold text-gray-900 mb-2">Edit Work Immersion</h3>
        <p class="text-sm text-gray-500 mb-6">
            Student: <strong><?= sanitize($record['last_name'] . ', ' . $record['first_name']) ?></strong>
            (<?= sanitize($record['section_name'] ?? '') ?> G<?= $record['grade_level'] ?? '' ?>)
        </p>
        <p class="text-sm text-gray-500 mb-6">This rating drives <strong>employability readiness</strong> for guidance (SHS course pathway); it is not shown as a composite score to teachers on the student profile.</p>

        <form method="POST">
            <div class="space-y-5">
                <div>
                    <label class="form-label">Company / Organization</label>
                    <input type="text" name="company_name" class="form-input" maxlength="150"
                           value="<?= sanitize($_POST['company_name'] ?? $record['company_name'] ?? '') ?>">
                </div>
                <div>
                    <label class="form-label">Rating (Employability) <span class="text-red-500">*</span></label>
                    <input type="number" name="rating" class="form-input" required min="0" max="100" step="0.01"
                           value="<?= sanitize($_POST['rating'] ?? $record['rating'] ?? '') ?>">
                </div>
                <div>
                    <label class="form-label">Hours Completed</label>
                    <input type="number" name="hours_completed" class="form-input" min="0"
                           value="<?= sanitize($_POST['hours_completed'] ?? $record['hours_completed'] ?? '') ?>">
                </div>
                <div>
                    <label class="form-label">Performance Remarks</label>
                    <textarea name="performance_remarks" class="form-input" rows="3"><?= sanitize($_POST['performance_remarks'] ?? $record['performance_remarks'] ?? '') ?></textarea>
                </div>
                <div>
                    <label class="form-label">School Year <span class="text-red-500">*</span></label>
                    <input type="text" name="school_year" class="form-input" required
                           value="<?= sanitize($_POST['school_year'] ?? $record['school_year'] ?? effectiveSchoolYear()) ?>">
                </div>
            </div>

            <div class="flex items-center gap-3 mt-8 pt-6 border-t border-gray-200">
                <button type="submit" class="btn btn-primary"><i class="fas fa-save"></i> Update</button>
                <a href="<?= BASE_URL ?>students/view.php?id=<?= $record['student_id'] ?>" class="btn btn-secondary">View Student</a>
            </div>
        </form>
    </div>
</div>

<?php require_once __DIR__ . '/../includes/footer.php'; ?>
