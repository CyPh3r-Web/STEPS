<?php
$pageTitle = 'Subjects';
require_once __DIR__ . '/../includes/header.php';
requireRole(['teacher', 'admin']);

$isAdmin = ($_SESSION['role'] ?? '') === 'admin';
$currentUserId = $_SESSION['user_id'] ?? 0;

$strands = $pdo->query("SELECT * FROM strands ORDER BY strand_name")->fetchAll();

$success = '';
$error = '';
$openModal = '';
$editId = $_GET['edit_id'] ?? '';
$strandFilter = $_GET['strand'] ?? '';
$typeFilter = $_GET['type'] ?? '';

// Handle Add
if ($_SERVER['REQUEST_METHOD'] === 'POST' && ($_POST['action'] ?? '') === 'add') {
    $subjectCode = sanitize($_POST['subject_code']);
    $subjectName = sanitize($_POST['subject_name']);
    $strandId = $_POST['strand_id'] ?: null;
    $subjectType = sanitize($_POST['subject_type']);

    if (empty($subjectCode) || empty($subjectName) || empty($subjectType)) {
        $error = 'Please fill in all required fields.';
        $openModal = 'add';
    } else {
        $check = $pdo->prepare("SELECT id FROM subjects WHERE subject_code = ?");
        $check->execute([$subjectCode]);
        if ($check->fetch()) {
            $error = 'A subject with this code already exists.';
            $openModal = 'add';
        } else {
            $stmt = $pdo->prepare("INSERT INTO subjects (subject_code, subject_name, strand_id, subject_type) VALUES (?, ?, ?, ?)");
            $stmt->execute([$subjectCode, $subjectName, $strandId, $subjectType]);
            header('Location: ' . BASE_URL . 'subjects/index.php?msg=added');
            exit;
        }
    }
}

// Handle Edit
if ($_SERVER['REQUEST_METHOD'] === 'POST' && ($_POST['action'] ?? '') === 'edit') {
    $id = (int)$_POST['subject_id'];
    $subjectCode = sanitize($_POST['subject_code']);
    $subjectName = sanitize($_POST['subject_name']);
    $strandId = $_POST['strand_id'] ?: null;
    $subjectType = sanitize($_POST['subject_type']);

    if (empty($subjectCode) || empty($subjectName) || empty($subjectType)) {
        $error = 'Please fill in all required fields.';
        $editId = $id;
        $openModal = 'edit';
    } else {
        $check = $pdo->prepare("SELECT id FROM subjects WHERE subject_code = ? AND id != ?");
        $check->execute([$subjectCode, $id]);
        if ($check->fetch()) {
            $error = 'A different subject with this code already exists.';
            $editId = $id;
            $openModal = 'edit';
        } else {
            $stmt = $pdo->prepare("UPDATE subjects SET subject_code=?, subject_name=?, strand_id=?, subject_type=? WHERE id=?");
            $stmt->execute([$subjectCode, $subjectName, $strandId, $subjectType, $id]);
            header('Location: ' . BASE_URL . 'subjects/index.php?msg=updated');
            exit;
        }
    }
}

// Handle Delete
if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['delete_id'])) {
    $gradeCount = $pdo->prepare("SELECT COUNT(*) as cnt FROM grades WHERE subject_id = ?");
    $gradeCount->execute([$_POST['delete_id']]);
    if ($gradeCount->fetch()['cnt'] > 0) {
        $error = 'Cannot delete this subject — it has grades recorded against it.';
    } else {
        $pdo->prepare("DELETE FROM subjects WHERE id = ?")->execute([$_POST['delete_id']]);
        header('Location: ' . BASE_URL . 'subjects/index.php?msg=deleted');
        exit;
    }
}

// Load edit data
$editSubject = null;
if ($editId) {
    $stmt = $pdo->prepare("SELECT * FROM subjects WHERE id = ?");
    $stmt->execute([$editId]);
    $editSubject = $stmt->fetch();
    if ($editSubject && !$openModal) $openModal = 'edit';
}

// Fetch subjects - all subjects for both admins and teachers
$query = "SELECT sub.*, st.strand_code, st.strand_name,
    (SELECT COUNT(*) FROM grades g WHERE g.subject_id = sub.id) as grade_count
    FROM subjects sub
    LEFT JOIN strands st ON sub.strand_id = st.id WHERE 1=1";
$params = [];
if ($strandFilter) { $query .= " AND sub.strand_id = ?"; $params[] = $strandFilter; }
if ($typeFilter) { $query .= " AND sub.subject_type = ?"; $params[] = $typeFilter; }
$query .= " ORDER BY sub.subject_type, sub.subject_name";
$stmt = $pdo->prepare($query);
$stmt->execute($params);
$subjects = $stmt->fetchAll();

// Stats for all subjects (both admins and teachers)
$totalCore = $pdo->query("SELECT COUNT(*) as cnt FROM subjects WHERE subject_type='core'")->fetch()['cnt'];
$totalSpecialized = $pdo->query("SELECT COUNT(*) as cnt FROM subjects WHERE subject_type='specialized'")->fetch()['cnt'];
$totalApplied = $pdo->query("SELECT COUNT(*) as cnt FROM subjects WHERE subject_type='applied'")->fetch()['cnt'];
$totalImmersion = $pdo->query("SELECT COUNT(*) as cnt FROM subjects WHERE subject_type='immersion'")->fetch()['cnt'];

require_once __DIR__ . '/../includes/sidebar.php';
?>

<?php if (isset($_GET['msg'])): ?>
<script>
document.addEventListener('DOMContentLoaded', function() {
    <?php
    $msgs = ['added' => 'Subject added successfully.', 'updated' => 'Subject updated successfully.', 'deleted' => 'Subject deleted successfully.'];
    ?>
    Toast.fire({ icon: 'success', title: <?= json_encode($msgs[$_GET['msg']] ?? 'Done.') ?> });
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

<!-- Stats -->
<div class="grid grid-cols-2 md:grid-cols-4 gap-5 mb-6">
    <div class="stat-card" style="background:#f8fafc;">
        <div class="flex items-center justify-between mb-2">
            <span class="text-sm font-medium text-gray-600">Core</span>
            <div class="w-10 h-10 rounded-lg flex items-center justify-center" style="background:#e2e8f0;">
                <i class="fas fa-book" style="color:#475569;"></i>
            </div>
        </div>
        <p class="text-3xl font-bold text-gray-800"><?= $totalCore ?></p>
    </div>
    <div class="stat-card" style="background:#f0fdf4;">
        <div class="flex items-center justify-between mb-2">
            <span class="text-sm font-medium text-gray-600">Specialized</span>
            <div class="w-10 h-10 rounded-lg flex items-center justify-center" style="background:#dcfce7;">
                <i class="fas fa-star" style="color:#166534;"></i>
            </div>
        </div>
        <p class="text-3xl font-bold text-gray-800"><?= $totalSpecialized ?></p>
    </div>
    <div class="stat-card" style="background:#fffbeb;">
        <div class="flex items-center justify-between mb-2">
            <span class="text-sm font-medium text-gray-600">Applied</span>
            <div class="w-10 h-10 rounded-lg flex items-center justify-center" style="background:#fef3c7;">
                <i class="fas fa-tools" style="color:#92400e;"></i>
            </div>
        </div>
        <p class="text-3xl font-bold text-gray-800"><?= $totalApplied ?></p>
    </div>
    <div class="stat-card" style="background:#fef2f2;">
        <div class="flex items-center justify-between mb-2">
            <span class="text-sm font-medium text-gray-600">Immersion</span>
            <div class="w-10 h-10 rounded-lg flex items-center justify-center" style="background:#fee2e2;">
                <i class="fas fa-briefcase" style="color:#b91c1c;"></i>
            </div>
        </div>
        <p class="text-3xl font-bold text-gray-800"><?= $totalImmersion ?></p>
    </div>
</div>

<!-- Filters -->
<div class="flex flex-wrap items-center justify-between gap-4 mb-4">
    <form method="GET" class="flex items-center gap-3">
        <select name="strand" class="form-select w-48" onchange="this.form.submit()">
            <option value="">All Strands</option>
            <?php foreach ($strands as $st): ?>
                <option value="<?= $st['id'] ?>" <?= $strandFilter == $st['id'] ? 'selected' : '' ?>><?= sanitize($st['strand_code']) ?></option>
            <?php endforeach; ?>
        </select>
        <select name="type" class="form-select w-44" onchange="this.form.submit()">
            <option value="">All Types</option>
            <option value="core" <?= $typeFilter === 'core' ? 'selected' : '' ?>>Core</option>
            <option value="specialized" <?= $typeFilter === 'specialized' ? 'selected' : '' ?>>Specialized</option>
            <option value="applied" <?= $typeFilter === 'applied' ? 'selected' : '' ?>>Applied</option>
            <option value="immersion" <?= $typeFilter === 'immersion' ? 'selected' : '' ?>>Immersion</option>
        </select>
    </form>
    <div class="flex items-center gap-2">
        <div class="relative" id="cheatsheetDropdown">
            <button onclick="toggleCheatsheetDropdown()" class="btn btn-secondary btn-sm">
                <i class="fas fa-download"></i> Download Cheatsheet
                <i class="fas fa-chevron-down text-xs ml-1"></i>
            </button>
            <div id="cheatsheetMenu" class="absolute right-0 mt-2 w-48 bg-white rounded-lg shadow-lg border border-gray-200 py-2 z-50 hidden">
                <a href="download_cheatsheet.php?grade=7" class="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100">Grade 7</a>
                <a href="download_cheatsheet.php?grade=8" class="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100">Grade 8</a>
                <a href="download_cheatsheet.php?grade=9" class="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100">Grade 9</a>
                <a href="download_cheatsheet.php?grade=10" class="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100">Grade 10</a>
                <div class="border-t border-gray-100 my-1"></div>
                <a href="download_cheatsheet.php?grade=11" class="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100">Grade 11 (SHS)</a>
                <a href="download_cheatsheet.php?grade=12" class="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100">Grade 12 (SHS)</a>
            </div>
        </div>
        <button onclick="openModal('addSubjectModal')" class="btn btn-primary btn-sm"><i class="fas fa-plus"></i> Add Subject</button>
    </div>
</div>

<p class="text-sm text-gray-500 mb-4"><?= count($subjects) ?> subject(s) found</p>

<!-- Table -->
<div class="bg-white border border-gray-200 rounded-xl overflow-hidden">
    <div class="overflow-x-auto">
        <table class="steps-table" id="subjectsTable">
            <thead>
                <tr><th>Code</th><th>Subject Name</th><th>Strand</th><th>Type</th><th>Grades Recorded</th><th>Actions</th></tr>
            </thead>
            <tbody>
                <?php foreach ($subjects as $sub): ?>
                    <?php
                    $typeBadge = ['core' => 'badge-blue', 'specialized' => 'badge-green', 'applied' => 'badge-amber', 'immersion' => 'badge-red'];
                    ?>
                    <tr>
                        <td class="font-mono text-sm font-semibold"><?= sanitize($sub['subject_code']) ?></td>
                        <td class="font-medium"><?= sanitize($sub['subject_name']) ?></td>
                        <td><?php if ($sub['strand_code']): ?><span class="badge badge-blue"><?= sanitize($sub['strand_code']) ?></span><?php else: ?><span class="text-gray-400">General</span><?php endif; ?></td>
                        <td><span class="badge <?= $typeBadge[$sub['subject_type']] ?? 'badge-blue' ?> capitalize"><?= $sub['subject_type'] ?></span></td>
                        <td class="text-sm text-gray-500"><?= $sub['grade_count'] ?></td>
                        <td>
                            <div class="flex items-center gap-2">
                                <button onclick="loadEditSubject(<?= $sub['id'] ?>)" class="text-gray-500 hover:text-gray-700" title="Edit"><i class="fas fa-edit"></i></button>
                                <form method="POST" class="inline" onsubmit="event.preventDefault(); confirmDelete(this, 'this subject');">
                                    <input type="hidden" name="delete_id" value="<?= $sub['id'] ?>">
                                    <button type="submit" class="text-red-500 hover:text-red-700" title="Delete"><i class="fas fa-trash"></i></button>
                                </form>
                            </div>
                        </td>
                    </tr>
                <?php endforeach; ?>
                <?php if (empty($subjects)): ?>
                    <tr><td colspan="6" class="text-center text-gray-400 py-8">No subjects found.</td></tr>
                <?php endif; ?>
            </tbody>
        </table>
    </div>
</div>

<!-- ADD SUBJECT MODAL -->
<div class="modal-overlay" id="addSubjectModal">
    <div class="modal-content" style="max-width:520px;">
        <div class="flex items-center justify-between mb-6">
            <div class="flex items-center gap-3">
                <div class="w-10 h-10 bg-blue-50 rounded-lg flex items-center justify-center modal-icon"><i class="fas fa-book text-blue-600"></i></div>
                <h3 class="text-base font-semibold text-gray-900">Add New Subject</h3>
            </div>
            <button onclick="closeModal('addSubjectModal')" class="modal-close"><i class="fas fa-times"></i></button>
        </div>
        <form method="POST">
            <input type="hidden" name="action" value="add">
            <div class="space-y-4">
                <div>
                    <label class="form-label">Subject Code <span class="text-red-500">*</span></label>
                    <input type="text" name="subject_code" class="form-input font-mono" required placeholder="e.g., MATH101" value="<?= $openModal === 'add' ? sanitize($subjectCode ?? '') : '' ?>">
                </div>
                <div>
                    <label class="form-label">Subject Name <span class="text-red-500">*</span></label>
                    <input type="text" name="subject_name" class="form-input" required placeholder="e.g., General Mathematics" value="<?= $openModal === 'add' ? sanitize($subjectName ?? '') : '' ?>">
                </div>
                <div>
                    <label class="form-label">Strand</label>
                    <select name="strand_id" class="form-select">
                        <option value="">General (No specific strand)</option>
                        <?php foreach ($strands as $st): ?>
                            <option value="<?= $st['id'] ?>"><?= sanitize($st['strand_code'] . ' — ' . $st['strand_name']) ?></option>
                        <?php endforeach; ?>
                    </select>
                    <p class="text-xs text-gray-400 mt-1">Leave as General for core subjects shared across strands.</p>
                </div>
                <div>
                    <label class="form-label">Subject Type <span class="text-red-500">*</span></label>
                    <select name="subject_type" class="form-select" required>
                        <option value="">Select Type</option>
                        <option value="core">Core</option>
                        <option value="specialized">Specialized</option>
                        <option value="applied">Applied</option>
                        <option value="immersion">Immersion</option>
                    </select>
                </div>
            </div>
            <div class="flex items-center justify-end gap-4 mt-6 pt-5 border-t border-gray-200">
                <button type="button" onclick="closeModal('addSubjectModal')" class="btn btn-secondary">Cancel</button>
                <button type="submit" class="btn btn-primary"><i class="fas fa-save"></i> Save Subject</button>
            </div>
        </form>
    </div>
</div>

<!-- EDIT SUBJECT MODAL -->
<div class="modal-overlay" id="editSubjectModal">
    <div class="modal-content" style="max-width:520px;">
        <div class="flex items-center justify-between mb-6">
            <div class="flex items-center gap-3">
                <div class="w-10 h-10 bg-amber-50 rounded-lg flex items-center justify-center modal-icon"><i class="fas fa-edit text-amber-600"></i></div>
                <h3 class="text-base font-semibold text-gray-900">Edit Subject</h3>
            </div>
            <button onclick="closeModal('editSubjectModal')" class="modal-close"><i class="fas fa-times"></i></button>
        </div>
        <form method="POST" id="editSubjectForm">
            <input type="hidden" name="action" value="edit">
            <input type="hidden" name="subject_id" id="edit_sub_id" value="">
            <div class="space-y-4">
                <div>
                    <label class="form-label">Subject Code <span class="text-red-500">*</span></label>
                    <input type="text" name="subject_code" id="edit_sub_code" class="form-input font-mono" required>
                </div>
                <div>
                    <label class="form-label">Subject Name <span class="text-red-500">*</span></label>
                    <input type="text" name="subject_name" id="edit_sub_name" class="form-input" required>
                </div>
                <div>
                    <label class="form-label">Strand</label>
                    <select name="strand_id" id="edit_sub_strand" class="form-select">
                        <option value="">General (No specific strand)</option>
                        <?php foreach ($strands as $st): ?>
                            <option value="<?= $st['id'] ?>"><?= sanitize($st['strand_code'] . ' — ' . $st['strand_name']) ?></option>
                        <?php endforeach; ?>
                    </select>
                </div>
                <div>
                    <label class="form-label">Subject Type <span class="text-red-500">*</span></label>
                    <select name="subject_type" id="edit_sub_type" class="form-select" required>
                        <option value="core">Core</option>
                        <option value="specialized">Specialized</option>
                        <option value="applied">Applied</option>
                        <option value="immersion">Immersion</option>
                    </select>
                </div>
            </div>
            <div class="flex items-center justify-end gap-4 mt-6 pt-5 border-t border-gray-200">
                <button type="button" onclick="closeModal('editSubjectModal')" class="btn btn-secondary">Cancel</button>
                <button type="submit" class="btn btn-primary"><i class="fas fa-save"></i> Update Subject</button>
            </div>
        </form>
    </div>
</div>

<script>
<?php
$subjectDataMap = [];
foreach ($subjects as $sub) {
    $subjectDataMap[$sub['id']] = [
        'id' => $sub['id'], 'subject_code' => $sub['subject_code'],
        'subject_name' => $sub['subject_name'], 'strand_id' => $sub['strand_id'] ?? '',
        'subject_type' => $sub['subject_type']
    ];
}
?>
const subjectData = <?= json_encode($subjectDataMap) ?>;

function loadEditSubject(id) {
    const s = subjectData[id];
    if (!s) return;
    document.getElementById('edit_sub_id').value = s.id;
    document.getElementById('edit_sub_code').value = s.subject_code;
    document.getElementById('edit_sub_name').value = s.subject_name;
    document.getElementById('edit_sub_strand').value = s.strand_id;
    document.getElementById('edit_sub_type').value = s.subject_type;
    openModal('editSubjectModal');
}

<?php if ($openModal === 'add'): ?>
document.addEventListener('DOMContentLoaded', function() { openModal('addSubjectModal'); });
<?php elseif ($openModal === 'edit'): ?>
document.addEventListener('DOMContentLoaded', function() { openModal('editSubjectModal'); });
<?php endif; ?>

function toggleCheatsheetDropdown() {
    const menu = document.getElementById('cheatsheetMenu');
    menu.classList.toggle('hidden');
}

// Close dropdown when clicking outside
document.addEventListener('click', function(e) {
    const dropdown = document.getElementById('cheatsheetDropdown');
    const menu = document.getElementById('cheatsheetMenu');
    if (dropdown && menu && !dropdown.contains(e.target)) {
        menu.classList.add('hidden');
    }
});
</script>

<?php require_once __DIR__ . '/../includes/footer.php'; ?>
