<?php
$pageTitle = 'Add Work Immersion';
require_once __DIR__ . '/../includes/header.php';
requireRole(['admin', 'teacher', 'guidance']);

$studentId = $_GET['student_id'] ?? 0;
$student = null;
if ($studentId) {
    $stmt = $pdo->prepare("SELECT s.*, sec.section_name, sec.grade_level, st.strand_code FROM students s
        LEFT JOIN sections sec ON s.section_id = sec.id
        LEFT JOIN strands st ON s.strand_id = st.id
        WHERE s.id = ?");
    $stmt->execute([$studentId]);
    $student = $stmt->fetch();
}

$students = $pdo->query("SELECT s.id, s.lrn, s.first_name, s.last_name, sec.section_name, sec.grade_level
    FROM students s
    LEFT JOIN sections sec ON s.section_id = sec.id
    WHERE s.status = 'active' AND sec.grade_level IN (11, 12)
    ORDER BY s.last_name, s.first_name")->fetchAll();

$error = '';
$success = '';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $studentId = (int)($_POST['student_id'] ?? 0);
    $companyName = sanitize($_POST['company_name'] ?? '');
    $rating = $_POST['rating'] ?? '';
    $hoursCompleted = (int)($_POST['hours_completed'] ?? 0);
    $performanceRemarks = sanitize($_POST['performance_remarks'] ?? '');
    $schoolYear = sanitize($_POST['school_year'] ?? SCHOOL_YEAR);

    if (!$studentId) {
        $error = 'Please select a student.';
    } elseif ($rating === '' || !is_numeric($rating)) {
        $error = 'Please enter a valid rating (0-100).';
    } elseif ((float)$rating < 0 || (float)$rating > 100) {
        $error = 'Rating must be between 0 and 100.';
    } else {
        $check = $pdo->prepare("SELECT id FROM work_immersion WHERE student_id = ? AND school_year = ?");
        $check->execute([$studentId, $schoolYear]);
        if ($check->fetch()) {
            $error = 'This student already has a work immersion record for ' . $schoolYear . '. Use Edit instead.';
        } else {
            $ins = $pdo->prepare("INSERT INTO work_immersion (student_id, company_name, rating, hours_completed, performance_remarks, school_year)
                VALUES (?, ?, ?, ?, ?, ?)");
            $ins->execute([$studentId, $companyName ?: null, $rating, $hoursCompleted ?: 0, $performanceRemarks ?: null, $schoolYear]);
            header('Location: ' . BASE_URL . 'work_immersion/index.php?msg=added');
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
        <h3 class="text-base font-semibold text-gray-900 mb-2">Add Work Immersion Record</h3>
        <p class="text-sm text-gray-500 mb-6">The rating is used in the employability score for career recommendations (40% weight).</p>

        <form method="POST">
            <div class="space-y-5">
                <div>
                    <label class="form-label">Student <span class="text-red-500">*</span></label>
                    <select name="student_id" class="form-select" required>
                        <option value="">Select Student</option>
                        <?php foreach ($students as $s): ?>
                            <option value="<?= $s['id'] ?>" <?= ($studentId ?? 0) == $s['id'] ? 'selected' : '' ?>>
                                <?= sanitize($s['last_name'] . ', ' . $s['first_name']) ?> — <?= sanitize($s['section_name'] ?? '') ?> (G<?= $s['grade_level'] ?? '' ?>)
                            </option>
                        <?php endforeach; ?>
                    </select>
                </div>
                <div>
                    <label class="form-label">Company / Organization</label>
                    <input type="text" name="company_name" class="form-input" maxlength="150"
                           value="<?= sanitize($_POST['company_name'] ?? '') ?>" placeholder="e.g., Tech Solutions Inc.">
                </div>
                <div>
                    <label class="form-label">Rating (Employability) <span class="text-red-500">*</span></label>
                    <input type="number" name="rating" class="form-input" required min="0" max="100" step="0.01"
                           value="<?= sanitize($_POST['rating'] ?? '') ?>" placeholder="0-100">
                    <p class="text-xs text-gray-500 mt-1">Work immersion grade from the company (0-100). Feeds into employability score.</p>
                </div>
                <div>
                    <label class="form-label">Hours Completed</label>
                    <input type="number" name="hours_completed" class="form-input" min="0"
                           value="<?= sanitize($_POST['hours_completed'] ?? '320') ?>" placeholder="e.g., 320">
                </div>
                <div>
                    <label class="form-label">Performance Remarks</label>
                    <textarea name="performance_remarks" class="form-input" rows="3" placeholder="Notes from supervisor..."><?= sanitize($_POST['performance_remarks'] ?? '') ?></textarea>
                </div>
                <div>
                    <label class="form-label">School Year <span class="text-red-500">*</span></label>
                    <input type="text" name="school_year" class="form-input" required
                           value="<?= sanitize($_POST['school_year'] ?? SCHOOL_YEAR) ?>" placeholder="e.g., 2025-2026">
                </div>
            </div>

            <div class="flex items-center gap-3 mt-8 pt-6 border-t border-gray-200">
                <button type="submit" class="btn btn-primary"><i class="fas fa-save"></i> Save</button>
                <a href="<?= BASE_URL ?>work_immersion/index.php" class="btn btn-secondary">Cancel</a>
            </div>
        </form>
    </div>
</div>

<?php require_once __DIR__ . '/../includes/footer.php'; ?>
