<?php
$pageTitle = 'Work Immersion';
require_once __DIR__ . '/../includes/header.php';
requireRole(['teacher', 'guidance']);

$sectionFilter = $_GET['section'] ?? '';
$schoolYearFilter = $_GET['school_year'] ?? effectiveSchoolYear();

$where = ["s.status = 'active'", "sec.grade_level IN (11, 12)"];
$params = [];
if ($sectionFilter) {
    $where[] = 's.section_id = ?';
    $params[] = $sectionFilter;
}

$sql = "SELECT s.id, s.lrn, s.first_name, s.last_name, sec.section_name, sec.grade_level, st.strand_code
        FROM students s
        INNER JOIN sections sec ON s.section_id = sec.id
        LEFT JOIN strands st ON s.strand_id = st.id
        WHERE " . implode(' AND ', $where) . "
        ORDER BY sec.grade_level, sec.section_name, s.last_name, s.first_name";
$stmt = $pdo->prepare($sql);
$stmt->execute($params);
$rows = $stmt->fetchAll();

$sections = $pdo->query("SELECT * FROM sections WHERE grade_level IN (11,12) ORDER BY grade_level, section_name")->fetchAll();

$msg = $_GET['msg'] ?? '';

require_once __DIR__ . '/../includes/sidebar.php';
?>

<?php if ($msg === 'added' || $msg === 'updated'): ?>
<script>
document.addEventListener('DOMContentLoaded', function() {
    Swal.fire({ ...swalDefaults, icon: 'success', title: 'Saved', text: 'Work immersion record <?= $msg === 'added' ? 'added' : 'updated' ?> successfully.', confirmButtonColor: '#2563eb' });
});
</script>
<?php endif; ?>

<div class="flex flex-wrap items-center justify-between gap-4 mb-6">
    <div>
        <h2 class="text-lg font-semibold text-gray-900">Work Immersion module removed</h2>
        <p class="text-sm text-gray-500">This page is no longer used because the Work Immersion feature has been removed from the system.</p>
    </div>
    <a href="<?= BASE_URL ?>work_immersion/add.php" class="btn btn-primary">
        <i class="fas fa-plus"></i> Add Work Immersion
    </a>
</div>

<form method="GET" class="flex flex-wrap gap-3 mb-6">
    <select name="section" class="form-select w-auto">
        <option value="">All Sections</option>
        <?php foreach ($sections as $sec): ?>
            <option value="<?= $sec['id'] ?>" <?= $sectionFilter == $sec['id'] ? 'selected' : '' ?>>
                <?= sanitize($sec['section_name']) ?> (G<?= $sec['grade_level'] ?>)
            </option>
        <?php endforeach; ?>
    </select>
    <input type="text" name="school_year" class="form-input w-32" value="<?= sanitize($schoolYearFilter) ?>" placeholder="S.Y.">
    <button type="submit" class="btn btn-secondary"><i class="fas fa-filter"></i> Filter</button>
</form>

<div class="bg-white border border-gray-200 rounded-xl overflow-hidden">
    <div class="overflow-x-auto">
        <table class="steps-table">
            <thead>
                <tr>
                    <th>Student</th>
                    <th>Section</th>
                    <th>Student</th>
                </tr>
            </thead>
            <tbody>
                <?php foreach ($rows as $r): ?>
                    <tr>
                        <td>
                            <a href="<?= BASE_URL ?>students/view.php?id=<?= $r['id'] ?>" class="text-blue-600 hover:underline font-medium">
                                <?= sanitize($r['last_name'] . ', ' . $r['first_name']) ?>
                            </a>
                            <span class="text-xs text-gray-400 block"><?= sanitize($r['lrn']) ?></span>
                        </td>
                        <td><?= sanitize($r['section_name'] ?? '-') ?> (<?= $r['grade_level'] ?? '-' ?>)</td>
                        <td><?= sanitize($r['company_name'] ?? '-') ?></td>
                        <td class="font-semibold"><?= $r['rating'] !== null ? formatNumber($r['rating']) : '-' ?></td>
                        <td><?= $r['hours_completed'] ?? '-' ?></td>
                        <td class="max-w-xs truncate" title="<?= sanitize($r['performance_remarks'] ?? '') ?>"><?= sanitize($r['performance_remarks'] ?? '-') ?></td>
                        <td class="no-print">
                            <?php if ($r['wi_id']): ?>
                                <a href="<?= BASE_URL ?>work_immersion/edit.php?id=<?= $r['wi_id'] ?>" class="text-blue-600 hover:underline text-sm">Edit</a>
                            <?php else: ?>
                                <a href="<?= BASE_URL ?>work_immersion/add.php?student_id=<?= $r['id'] ?>" class="text-green-600 hover:underline text-sm">Add</a>
                            <?php endif; ?>
                        </td>
                    </tr>
                <?php endforeach; ?>
                <?php if (empty($rows)): ?>
                    <tr><td colspan="7" class="text-center text-gray-400 py-8">No SHS students found. Add work immersion from student profile or use Add button.</td></tr>
                <?php endif; ?>
            </tbody>
        </table>
    </div>
</div>

<?php require_once __DIR__ . '/../includes/footer.php'; ?>
