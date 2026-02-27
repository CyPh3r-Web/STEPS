<?php
$pageTitle = 'Add Student';
require_once __DIR__ . '/../includes/header.php';
requireLogin();

$sections = $pdo->query("SELECT * FROM sections ORDER BY grade_level, section_name")->fetchAll();
$strands = $pdo->query("SELECT * FROM strands ORDER BY strand_name")->fetchAll();
$error = '';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $lrn = sanitize($_POST['lrn']);
    $firstName = sanitize($_POST['first_name']);
    $lastName = sanitize($_POST['last_name']);
    $middleName = sanitize($_POST['middle_name']);
    $gender = sanitize($_POST['gender']);
    $birthdate = sanitize($_POST['birthdate']);
    $sectionId = $_POST['section_id'] ?: null;
    $strandId = $_POST['strand_id'] ?: null;
    $schoolYear = sanitize($_POST['school_year']);

    if (empty($lrn) || empty($firstName) || empty($lastName) || empty($gender)) {
        $error = 'Please fill in all required fields.';
    } else {
        $check = $pdo->prepare("SELECT id FROM students WHERE lrn = ?");
        $check->execute([$lrn]);
        if ($check->fetch()) {
            $error = 'A student with this LRN already exists.';
        } else {
            $stmt = $pdo->prepare("INSERT INTO students (lrn, first_name, last_name, middle_name, gender, birthdate, section_id, strand_id, school_year) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)");
            $stmt->execute([$lrn, $firstName, $lastName, $middleName, $gender, $birthdate ?: null, $sectionId, $strandId, $schoolYear]);
            header('Location: ' . BASE_URL . 'students/index.php?msg=added');
            exit;
        }
    }
}

require_once __DIR__ . '/../includes/sidebar.php';
?>

<div class="max-w-2xl">
    <a href="<?= BASE_URL ?>students/index.php" class="inline-flex items-center gap-2 text-sm text-gray-500 hover:text-gray-700 mb-6">
        <i class="fas fa-arrow-left"></i> Back to Students
    </a>

    <?php if ($error): ?>
    <script>
    document.addEventListener('DOMContentLoaded', function() {
        Swal.fire({
            ...swalDefaults,
            icon: 'error',
            title: 'Validation Error',
            text: <?= json_encode($error) ?>,
            confirmButtonColor: '#2563eb'
        });
    });
    </script>
    <?php endif; ?>

    <div class="bg-white border border-gray-200 rounded-xl p-6">
        <h3 class="text-base font-semibold text-gray-900 mb-6">Student Information</h3>

        <form method="POST">
            <div class="grid grid-cols-1 md:grid-cols-2 gap-5">
                <div class="md:col-span-2">
                    <label class="form-label">LRN <span class="text-red-500">*</span></label>
                    <input type="text" name="lrn" class="form-input" required maxlength="20"
                           value="<?= sanitize($lrn ?? '') ?>" placeholder="Learner Reference Number">
                </div>
                <div>
                    <label class="form-label">Last Name <span class="text-red-500">*</span></label>
                    <input type="text" name="last_name" class="form-input" required value="<?= sanitize($lastName ?? '') ?>">
                </div>
                <div>
                    <label class="form-label">First Name <span class="text-red-500">*</span></label>
                    <input type="text" name="first_name" class="form-input" required value="<?= sanitize($firstName ?? '') ?>">
                </div>
                <div>
                    <label class="form-label">Middle Name</label>
                    <input type="text" name="middle_name" class="form-input" value="<?= sanitize($middleName ?? '') ?>">
                </div>
                <div>
                    <label class="form-label">Gender <span class="text-red-500">*</span></label>
                    <select name="gender" class="form-select" required>
                        <option value="">Select</option>
                        <option value="Male" <?= ($gender ?? '') === 'Male' ? 'selected' : '' ?>>Male</option>
                        <option value="Female" <?= ($gender ?? '') === 'Female' ? 'selected' : '' ?>>Female</option>
                    </select>
                </div>
                <div>
                    <label class="form-label">Birthdate</label>
                    <input type="date" name="birthdate" class="form-input" value="<?= sanitize($birthdate ?? '') ?>">
                </div>
                <div>
                    <label class="form-label">Section</label>
                    <select name="section_id" class="form-select">
                        <option value="">Select Section</option>
                        <?php foreach ($sections as $sec): ?>
                            <option value="<?= $sec['id'] ?>" <?= ($sectionId ?? '') == $sec['id'] ? 'selected' : '' ?>>
                                <?= sanitize($sec['section_name']) ?> (G<?= $sec['grade_level'] ?>)
                            </option>
                        <?php endforeach; ?>
                    </select>
                </div>
                <div>
                    <label class="form-label">Strand</label>
                    <select name="strand_id" class="form-select">
                        <option value="">Select Strand</option>
                        <?php foreach ($strands as $st): ?>
                            <option value="<?= $st['id'] ?>" <?= ($strandId ?? '') == $st['id'] ? 'selected' : '' ?>>
                                <?= sanitize($st['strand_code'] . ' - ' . $st['strand_name']) ?>
                            </option>
                        <?php endforeach; ?>
                    </select>
                </div>
                <div>
                    <label class="form-label">School Year <span class="text-red-500">*</span></label>
                    <input type="text" name="school_year" class="form-input" required
                           value="<?= sanitize($schoolYear ?? SCHOOL_YEAR) ?>" placeholder="e.g., 2025-2026">
                </div>
            </div>

            <div class="flex items-center gap-3 mt-8 pt-6 border-t border-gray-200">
                <button type="submit" class="btn btn-primary"><i class="fas fa-save"></i> Save Student</button>
                <a href="<?= BASE_URL ?>students/index.php" class="btn btn-secondary">Cancel</a>
            </div>
        </form>
    </div>
</div>

<?php require_once __DIR__ . '/../includes/footer.php'; ?>
