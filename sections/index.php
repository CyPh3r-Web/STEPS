<?php
$pageTitle = 'Sections';
require_once __DIR__ . '/../includes/header.php';
requireRole('teacher');

$strands = $pdo->query("SELECT * FROM strands ORDER BY strand_name")->fetchAll();
$teachers = $pdo->query("SELECT id, full_name FROM users WHERE role IN ('teacher','admin') AND status = 'active' ORDER BY full_name")->fetchAll();

$success = '';
$error = '';
$openModal = '';
$editId = $_GET['edit_id'] ?? '';

// Handle Add
if ($_SERVER['REQUEST_METHOD'] === 'POST' && ($_POST['action'] ?? '') === 'add') {
    $sectionName = sanitize($_POST['section_name']);
    $gradeLevel = (int)$_POST['grade_level'];
    $strand = sanitize($_POST['strand']);
    $adviserId = $_POST['adviser_id'] ?: null;
    $schoolYear = sanitize($_POST['school_year']);

    if (empty($sectionName) || empty($gradeLevel) || empty($schoolYear)) {
        $error = 'Please fill in all required fields.';
        $openModal = 'add';
    } else {
        $check = $pdo->prepare("SELECT id FROM sections WHERE section_name = ? AND grade_level = ? AND school_year = ?");
        $check->execute([$sectionName, $gradeLevel, $schoolYear]);
        if ($check->fetch()) {
            $error = 'This section already exists for the selected grade level and school year.';
            $openModal = 'add';
        } else {
            $stmt = $pdo->prepare("INSERT INTO sections (section_name, grade_level, strand, adviser_id, school_year) VALUES (?, ?, ?, ?, ?)");
            $stmt->execute([$sectionName, $gradeLevel, $strand ?: null, $adviserId, $schoolYear]);
            header('Location: ' . BASE_URL . 'sections/index.php?msg=added');
            exit;
        }
    }
}

// Handle Edit
if ($_SERVER['REQUEST_METHOD'] === 'POST' && ($_POST['action'] ?? '') === 'edit') {
    $id = (int)$_POST['section_id'];
    $sectionName = sanitize($_POST['section_name']);
    $gradeLevel = (int)$_POST['grade_level'];
    $strand = sanitize($_POST['strand']);
    $adviserId = $_POST['adviser_id'] ?: null;
    $schoolYear = sanitize($_POST['school_year']);

    if (empty($sectionName) || empty($gradeLevel) || empty($schoolYear)) {
        $error = 'Please fill in all required fields.';
        $editId = $id;
        $openModal = 'edit';
    } else {
        $check = $pdo->prepare("SELECT id FROM sections WHERE section_name = ? AND grade_level = ? AND school_year = ? AND id != ?");
        $check->execute([$sectionName, $gradeLevel, $schoolYear, $id]);
        if ($check->fetch()) {
            $error = 'This section already exists for the selected grade level and school year.';
            $editId = $id;
            $openModal = 'edit';
        } else {
            $stmt = $pdo->prepare("UPDATE sections SET section_name=?, grade_level=?, strand=?, adviser_id=?, school_year=? WHERE id=?");
            $stmt->execute([$sectionName, $gradeLevel, $strand ?: null, $adviserId, $schoolYear, $id]);
            header('Location: ' . BASE_URL . 'sections/index.php?msg=updated');
            exit;
        }
    }
}

// Handle Delete
if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['delete_id'])) {
    $studentCount = $pdo->prepare("SELECT COUNT(*) as cnt FROM students WHERE section_id = ? AND status = 'active'");
    $studentCount->execute([$_POST['delete_id']]);
    if ($studentCount->fetch()['cnt'] > 0) {
        $error = 'Cannot delete this section — it still has active students assigned.';
    } else {
        $pdo->prepare("DELETE FROM sections WHERE id = ?")->execute([$_POST['delete_id']]);
        header('Location: ' . BASE_URL . 'sections/index.php?msg=deleted');
        exit;
    }
}

// Load edit data
$editSection = null;
if ($editId) {
    $stmt = $pdo->prepare("SELECT * FROM sections WHERE id = ?");
    $stmt->execute([$editId]);
    $editSection = $stmt->fetch();
    if ($editSection && !$openModal) $openModal = 'edit';
}

// Fetch sections with counts
$sections = $pdo->query("SELECT sec.*, u.full_name as adviser_name,
    (SELECT COUNT(*) FROM students s WHERE s.section_id = sec.id AND s.status = 'active') as student_count
    FROM sections sec
    LEFT JOIN users u ON sec.adviser_id = u.id
    ORDER BY sec.school_year DESC, sec.grade_level, sec.section_name")->fetchAll();

require_once __DIR__ . '/../includes/sidebar.php';
?>

<?php if (isset($_GET['msg'])): ?>
<script>
document.addEventListener('DOMContentLoaded', function() {
    <?php
    $msgs = ['added' => 'Section added successfully.', 'updated' => 'Section updated successfully.', 'deleted' => 'Section deleted successfully.'];
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

<?php
$jhsCount = count(array_filter($sections, fn($s) => $s['grade_level'] >= 7 && $s['grade_level'] <= 10));
$shsCount = count(array_filter($sections, fn($s) => $s['grade_level'] >= 11));
?>
<!-- Stats -->
<div class="grid grid-cols-1 md:grid-cols-3 gap-5 mb-6">
    <div class="stat-card" style="background:#f8fafc;">
        <div class="flex items-center justify-between mb-2">
            <span class="text-sm font-medium text-gray-600">Total Sections</span>
            <div class="w-10 h-10 rounded-lg flex items-center justify-center" style="background:#e2e8f0;">
                <i class="fas fa-layer-group" style="color:#475569;"></i>
            </div>
        </div>
        <p class="text-3xl font-bold text-gray-800"><?= count($sections) ?></p>
    </div>
    <div class="stat-card" style="background:#eff6ff;">
        <div class="flex items-center justify-between mb-2">
            <span class="text-sm font-medium text-gray-600">JHS Sections <span class="text-xs font-normal">(G7–G10)</span></span>
            <div class="w-10 h-10 rounded-lg flex items-center justify-center" style="background:#dbeafe;">
                <i class="fas fa-users" style="color:#1d4ed8;"></i>
            </div>
        </div>
        <p class="text-3xl font-bold text-gray-800"><?= $jhsCount ?></p>
        <span class="text-xs text-gray-400">Strand Recommendation</span>
    </div>
    <div class="stat-card" style="background:#f0fdf4;">
        <div class="flex items-center justify-between mb-2">
            <span class="text-sm font-medium text-gray-600">SHS Sections <span class="text-xs font-normal">(G11–G12)</span></span>
            <div class="w-10 h-10 rounded-lg flex items-center justify-center" style="background:#dcfce7;">
                <i class="fas fa-users" style="color:#166534;"></i>
            </div>
        </div>
        <p class="text-3xl font-bold text-gray-800"><?= $shsCount ?></p>
        <span class="text-xs text-gray-400">Course Recommendation</span>
    </div>
</div>

<div class="flex items-center justify-between mb-4">
    <p class="text-sm text-gray-500"><?= count($sections) ?> section(s)</p>
    <button onclick="openModal('addSectionModal')" class="btn btn-primary btn-sm"><i class="fas fa-plus"></i> Add Section</button>
</div>

<!-- Table -->
<div class="bg-white border border-gray-200 rounded-xl overflow-hidden">
    <div class="overflow-x-auto">
        <table class="steps-table" id="sectionsTable">
            <thead>
                <tr><th>Section Name</th><th>Grade Level</th><th>Strand</th><th>Adviser</th><th>Students</th><th>School Year</th><th>Actions</th></tr>
            </thead>
            <tbody>
                <?php foreach ($sections as $sec): ?>
                    <tr>
                        <td class="font-medium"><?= sanitize($sec['section_name']) ?></td>
                        <td>
                            Grade <?= $sec['grade_level'] ?>
                            <?php if ($sec['grade_level'] >= 7 && $sec['grade_level'] <= 10): ?>
                                <span class="badge badge-blue ml-1 text-[10px]">JHS</span>
                            <?php else: ?>
                                <span class="badge badge-green ml-1 text-[10px]">SHS</span>
                            <?php endif; ?>
                        </td>
                        <td><?php if ($sec['strand']): ?><span class="badge badge-blue"><?= sanitize($sec['strand']) ?></span><?php else: ?><span class="text-gray-400">—</span><?php endif; ?></td>
                        <td><?= sanitize($sec['adviser_name'] ?? '—') ?></td>
                        <td><span class="font-semibold"><?= $sec['student_count'] ?></span></td>
                        <td class="text-sm text-gray-500"><?= sanitize($sec['school_year']) ?></td>
                        <td>
                            <div class="flex items-center gap-2">
                                <button onclick="loadEditSection(<?= $sec['id'] ?>)" class="text-gray-500 hover:text-gray-700" title="Edit"><i class="fas fa-edit"></i></button>
                                <form method="POST" class="inline" onsubmit="event.preventDefault(); confirmDelete(this, 'this section');">
                                    <input type="hidden" name="delete_id" value="<?= $sec['id'] ?>">
                                    <button type="submit" class="text-red-500 hover:text-red-700" title="Delete"><i class="fas fa-trash"></i></button>
                                </form>
                            </div>
                        </td>
                    </tr>
                <?php endforeach; ?>
                <?php if (empty($sections)): ?>
                    <tr><td colspan="7" class="text-center text-gray-400 py-8">No sections found.</td></tr>
                <?php endif; ?>
            </tbody>
        </table>
    </div>
</div>

<!-- ADD SECTION MODAL -->
<div class="modal-overlay" id="addSectionModal">
    <div class="modal-content" style="max-width:520px;">
        <div class="flex items-center justify-between mb-6">
            <div class="flex items-center gap-3">
                <div class="w-10 h-10 bg-blue-50 rounded-lg flex items-center justify-center modal-icon"><i class="fas fa-layer-group text-blue-600"></i></div>
                <h3 class="text-base font-semibold text-gray-900">Add New Section</h3>
            </div>
            <button onclick="closeModal('addSectionModal')" class="modal-close"><i class="fas fa-times"></i></button>
        </div>
        <form method="POST">
            <input type="hidden" name="action" value="add">
            <div class="space-y-4">
                <div>
                    <label class="form-label">Section Name <span class="text-red-500">*</span></label>
                    <input type="text" name="section_name" class="form-input" required placeholder="e.g., Section A" value="<?= $openModal === 'add' ? sanitize($sectionName ?? '') : '' ?>">
                </div>
                <div>
                    <label class="form-label">Grade Level <span class="text-red-500">*</span></label>
                    <select name="grade_level" id="add_grade_level" class="form-select" required onchange="toggleStrandField('add_grade_level','add_strand_wrap')">
                        <option value="">Select Grade Level</option>
                        <optgroup label="Junior High School (JHS)">
                            <option value="7"  <?= ($openModal === 'add' && ($gradeLevel ?? '') == 7)  ? 'selected' : '' ?>>Grade 7</option>
                            <option value="8"  <?= ($openModal === 'add' && ($gradeLevel ?? '') == 8)  ? 'selected' : '' ?>>Grade 8</option>
                            <option value="9"  <?= ($openModal === 'add' && ($gradeLevel ?? '') == 9)  ? 'selected' : '' ?>>Grade 9</option>
                            <option value="10" <?= ($openModal === 'add' && ($gradeLevel ?? '') == 10) ? 'selected' : '' ?>>Grade 10</option>
                        </optgroup>
                        <optgroup label="Senior High School (SHS)">
                            <option value="11" <?= ($openModal === 'add' && ($gradeLevel ?? '') == 11) ? 'selected' : '' ?>>Grade 11</option>
                            <option value="12" <?= ($openModal === 'add' && ($gradeLevel ?? '') == 12) ? 'selected' : '' ?>>Grade 12</option>
                        </optgroup>
                    </select>
                    <p class="text-xs text-gray-400 mt-1">G7–G10 sections are used for Strand Recommendations; G11–G12 for Course Recommendations.</p>
                </div>
                <div id="add_strand_wrap">
                    <label class="form-label">Strand <span class="text-xs text-gray-400 font-normal">(SHS only)</span></label>
                    <select name="strand" class="form-select">
                        <option value="">No Strand</option>
                        <?php foreach ($strands as $st): ?>
                            <option value="<?= sanitize($st['strand_code']) ?>"><?= sanitize($st['strand_code'] . ' — ' . $st['strand_name']) ?></option>
                        <?php endforeach; ?>
                    </select>
                </div>
                <div>
                    <label class="form-label">Adviser</label>
                    <select name="adviser_id" class="form-select">
                        <option value="">No Adviser</option>
                        <?php foreach ($teachers as $t): ?>
                            <option value="<?= $t['id'] ?>"><?= sanitize($t['full_name']) ?></option>
                        <?php endforeach; ?>
                    </select>
                </div>
                <div>
                    <label class="form-label">School Year <span class="text-red-500">*</span></label>
                    <input type="text" name="school_year" class="form-input" required value="<?= effectiveSchoolYear() ?>" placeholder="e.g., 2025-2026">
                </div>
            </div>
            <div class="flex items-center justify-end gap-4 mt-6 pt-5 border-t border-gray-200">
                <button type="button" onclick="closeModal('addSectionModal')" class="btn btn-secondary">Cancel</button>
                <button type="submit" class="btn btn-primary"><i class="fas fa-save"></i> Save Section</button>
            </div>
        </form>
    </div>
</div>

<!-- EDIT SECTION MODAL -->
<div class="modal-overlay" id="editSectionModal">
    <div class="modal-content" style="max-width:520px;">
        <div class="flex items-center justify-between mb-6">
            <div class="flex items-center gap-3">
                <div class="w-10 h-10 bg-amber-50 rounded-lg flex items-center justify-center modal-icon"><i class="fas fa-edit text-amber-600"></i></div>
                <h3 class="text-base font-semibold text-gray-900">Edit Section</h3>
            </div>
            <button onclick="closeModal('editSectionModal')" class="modal-close"><i class="fas fa-times"></i></button>
        </div>
        <form method="POST" id="editSectionForm">
            <input type="hidden" name="action" value="edit">
            <input type="hidden" name="section_id" id="edit_sec_id" value="">
            <div class="space-y-4">
                <div>
                    <label class="form-label">Section Name <span class="text-red-500">*</span></label>
                    <input type="text" name="section_name" id="edit_sec_name" class="form-input" required>
                </div>
                <div>
                    <label class="form-label">Grade Level <span class="text-red-500">*</span></label>
                    <select name="grade_level" id="edit_sec_grade" class="form-select" required onchange="toggleStrandField('edit_sec_grade','edit_strand_wrap')">
                        <option value="">Select Grade Level</option>
                        <optgroup label="Junior High School (JHS)">
                            <option value="7">Grade 7</option>
                            <option value="8">Grade 8</option>
                            <option value="9">Grade 9</option>
                            <option value="10">Grade 10</option>
                        </optgroup>
                        <optgroup label="Senior High School (SHS)">
                            <option value="11">Grade 11</option>
                            <option value="12">Grade 12</option>
                        </optgroup>
                    </select>
                </div>
                <div id="edit_strand_wrap">
                    <label class="form-label">Strand <span class="text-xs text-gray-400 font-normal">(SHS only)</span></label>
                    <select name="strand" id="edit_sec_strand" class="form-select">
                        <option value="">No Strand</option>
                        <?php foreach ($strands as $st): ?>
                            <option value="<?= sanitize($st['strand_code']) ?>"><?= sanitize($st['strand_code'] . ' — ' . $st['strand_name']) ?></option>
                        <?php endforeach; ?>
                    </select>
                </div>
                <div>
                    <label class="form-label">Adviser</label>
                    <select name="adviser_id" id="edit_sec_adviser" class="form-select">
                        <option value="">No Adviser</option>
                        <?php foreach ($teachers as $t): ?>
                            <option value="<?= $t['id'] ?>"><?= sanitize($t['full_name']) ?></option>
                        <?php endforeach; ?>
                    </select>
                </div>
                <div>
                    <label class="form-label">School Year <span class="text-red-500">*</span></label>
                    <input type="text" name="school_year" id="edit_sec_sy" class="form-input" required>
                </div>
            </div>
            <div class="flex items-center justify-end gap-4 mt-6 pt-5 border-t border-gray-200">
                <button type="button" onclick="closeModal('editSectionModal')" class="btn btn-secondary">Cancel</button>
                <button type="submit" class="btn btn-primary"><i class="fas fa-save"></i> Update Section</button>
            </div>
        </form>
    </div>
</div>

<script>
<?php
$sectionDataMap = [];
foreach ($sections as $sec) {
    $sectionDataMap[$sec['id']] = [
        'id' => $sec['id'], 'section_name' => $sec['section_name'],
        'grade_level' => $sec['grade_level'], 'strand' => $sec['strand'] ?? '',
        'adviser_id' => $sec['adviser_id'] ?? '', 'school_year' => $sec['school_year']
    ];
}
?>
const sectionData = <?= json_encode($sectionDataMap) ?>;

function toggleStrandField(selectId, wrapId) {
    const grade = parseInt(document.getElementById(selectId).value);
    const wrap  = document.getElementById(wrapId);
    if (!wrap) return;
    if (grade >= 7 && grade <= 10) {
        wrap.style.display = 'none';
        const sel = wrap.querySelector('select');
        if (sel) sel.value = '';
    } else {
        wrap.style.display = '';
    }
}

function loadEditSection(id) {
    const s = sectionData[id];
    if (!s) return;
    document.getElementById('edit_sec_id').value = s.id;
    document.getElementById('edit_sec_name').value = s.section_name;
    document.getElementById('edit_sec_grade').value = s.grade_level;
    document.getElementById('edit_sec_strand').value = s.strand;
    document.getElementById('edit_sec_adviser').value = s.adviser_id;
    document.getElementById('edit_sec_sy').value = s.school_year;
    toggleStrandField('edit_sec_grade', 'edit_strand_wrap');
    openModal('editSectionModal');
}

document.addEventListener('DOMContentLoaded', function() {
    // Set initial state for add modal strand visibility
    toggleStrandField('add_grade_level', 'add_strand_wrap');

    <?php if ($openModal === 'add'): ?>
    openModal('addSectionModal');
    <?php elseif ($openModal === 'edit'): ?>
    openModal('editSectionModal');
    <?php endif; ?>
});
</script>

<?php require_once __DIR__ . '/../includes/footer.php'; ?>
