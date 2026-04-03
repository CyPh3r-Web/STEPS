<?php
$pageTitle = 'Add Student';
require_once __DIR__ . '/../includes/header.php';
requireRole('teacher');

$sections = $pdo->query("SELECT * FROM sections ORDER BY grade_level, section_name")->fetchAll();
$strands = $pdo->query("SELECT * FROM strands ORDER BY strand_name")->fetchAll();
$error = '';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $lrn = sanitize($_POST['lrn']);
    if ($lrn !== '' && preg_match('/^[0-9]+(?:\.[0-9]+)?[eE][+-]?[0-9]+$/', $lrn)) {
        $lrnFloat = (float)$lrn;
        $lrn = sprintf('%.0F', $lrnFloat);
    }
    $firstName = sanitize($_POST['first_name']);
    $lastName = sanitize($_POST['last_name']);
    $middleName = sanitize($_POST['middle_name']);
    $nameSuffix = sanitize($_POST['name_suffix'] ?? '');
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
            try {
                $stmt = $pdo->prepare("INSERT INTO students (lrn, first_name, last_name, middle_name, name_suffix, gender, birthdate, section_id, strand_id, school_year, created_by) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)");
                $stmt->execute([$lrn, $firstName, $lastName, $middleName, $nameSuffix, $gender, $birthdate ?: null, $sectionId, $strandId, $schoolYear, $_SESSION['user_id'] ?? null]);
                header('Location: ' . BASE_URL . 'students/index.php?msg=added');
                exit;
            } catch (PDOException $e) {
                $error = 'Database error: ' . $e->getMessage();
            }
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
                    <input type="text" name="lrn" class="form-input" required maxlength="20" inputmode="numeric" pattern="[0-9]*" oninput="this.value = this.value.replace(/[^0-9]/g, '')" placeholder="Learner Reference Number" value="<?= sanitize($lrn ?? '') ?>">
                </div>
                <div>
                    <label class="form-label">Last Name <span class="text-red-500">*</span></label>
                    <input type="text" name="last_name" class="form-input" required value="<?= sanitize($lastName ?? '') ?>" oninput="this.value = this.value.replace(/[^a-zA-Z\s]/g, '')" placeholder="Letters only">
                </div>
                <div>
                    <label class="form-label">First Name <span class="text-red-500">*</span></label>
                    <input type="text" name="first_name" class="form-input" required value="<?= sanitize($firstName ?? '') ?>" oninput="this.value = this.value.replace(/[^a-zA-Z\s]/g, '')" placeholder="Letters only">
                </div>
                <div>
                    <label class="form-label">Middle Name</label>
                    <input type="text" name="middle_name" class="form-input" value="<?= sanitize($middleName ?? '') ?>" oninput="this.value = this.value.replace(/[^a-zA-Z\s]/g, '')" placeholder="Optional">
                </div>
                <div>
                    <label class="form-label">Name Suffix <span class="text-gray-400 font-normal">(Optional)</span></label>
                    <select name="name_suffix" class="form-select">
                        <option value="">None</option>
                        <option value="Jr." <?= ($nameSuffix ?? '') === 'Jr.' ? 'selected' : '' ?>>Jr.</option>
                        <option value="Sr." <?= ($nameSuffix ?? '') === 'Sr.' ? 'selected' : '' ?>>Sr.</option>
                        <option value="II" <?= ($nameSuffix ?? '') === 'II' ? 'selected' : '' ?>>II</option>
                        <option value="III" <?= ($nameSuffix ?? '') === 'III' ? 'selected' : '' ?>>III</option>
                        <option value="IV" <?= ($nameSuffix ?? '') === 'IV' ? 'selected' : '' ?>>IV</option>
                        <option value="V" <?= ($nameSuffix ?? '') === 'V' ? 'selected' : '' ?>>V</option>
                    </select>
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
                    <select name="section_id" id="section_id" class="form-select" onchange="updateStrandField()">
                        <option value="">Select Section</option>
                        <?php foreach ($sections as $sec): ?>
                            <option value="<?= $sec['id'] ?>" data-grade="<?= $sec['grade_level'] ?>" <?= ($sectionId ?? '') == $sec['id'] ? 'selected' : '' ?>>
                                <?= sanitize($sec['section_name']) ?> (G<?= $sec['grade_level'] ?>)
                            </option>
                        <?php endforeach; ?>
                    </select>
                </div>
                <div id="strand_container">
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
                           value="<?= sanitize($schoolYear ?? effectiveSchoolYear()) ?>" placeholder="e.g., 2025-2026">
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

<script>
function updateStrandField() {
    const sectionSelect = document.getElementById('section_id');
    const strandContainer = document.getElementById('strand_container');
    if (!sectionSelect || !strandContainer) return;
    
    const selectedOption = sectionSelect.options[sectionSelect.selectedIndex];
    const gradeLevel = selectedOption ? parseInt(selectedOption.getAttribute('data-grade')) : 0;
    
    // Hide strand for JHS (Grades 7-10), show for SHS (Grades 11-12)
    if (gradeLevel >= 7 && gradeLevel <= 10) {
        strandContainer.style.display = 'none';
        strandContainer.querySelector('select').value = '';
    } else {
        strandContainer.style.display = 'block';
    }
}

// Initialize on page load
document.addEventListener('DOMContentLoaded', updateStrandField);
</script>
