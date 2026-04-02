<?php
$pageTitle = 'Competency Framework (Strands)';
require_once __DIR__ . '/../includes/header.php';
requireAdmin();

$success = '';
$error = '';

if ($_SERVER['REQUEST_METHOD'] === 'POST' && ($_POST['action'] ?? '') === 'save_strand') {
    $id = (int)($_POST['strand_id'] ?? 0);
    $code = strtoupper(sanitize($_POST['strand_code'] ?? ''));
    $name = sanitize($_POST['strand_name'] ?? '');
    $desc = trim($_POST['description'] ?? '');
    if ($id > 0 && $code !== '' && $name !== '') {
        $chk = $pdo->prepare('SELECT id FROM strands WHERE strand_code = ? AND id != ?');
        $chk->execute([$code, $id]);
        if ($chk->fetch()) {
            $error = 'Another strand already uses this code.';
        } else {
            $pdo->prepare('UPDATE strands SET strand_code = ?, strand_name = ?, description = ? WHERE id = ?')->execute([$code, $name, $desc ?: null, $id]);
            $logStmt = $pdo->prepare('INSERT INTO activity_logs (user_id, action, description, ip_address) VALUES (?, ?, ?, ?)');
            $logStmt->execute([$_SESSION['user_id'], 'framework_update', "Strand updated: $code", $_SERVER['REMOTE_ADDR'] ?? '']);
            $success = 'Strand saved.';
        }
    }
}

if ($_SERVER['REQUEST_METHOD'] === 'POST' && ($_POST['action'] ?? '') === 'add_strand') {
    $code = strtoupper(sanitize($_POST['new_strand_code'] ?? ''));
    $name = sanitize($_POST['new_strand_name'] ?? '');
    $desc = trim($_POST['new_description'] ?? '');
    if ($code !== '' && $name !== '') {
        try {
            $pdo->prepare('INSERT INTO strands (strand_code, strand_name, description) VALUES (?, ?, ?)')->execute([$code, $name, $desc ?: null]);
            $logStmt = $pdo->prepare('INSERT INTO activity_logs (user_id, action, description, ip_address) VALUES (?, ?, ?, ?)');
            $logStmt->execute([$_SESSION['user_id'], 'framework_add', "Strand added: $code", $_SERVER['REMOTE_ADDR'] ?? '']);
            $success = 'Strand added.';
        } catch (PDOException $e) {
            $error = 'Could not add strand (duplicate code?).';
        }
    }
}

$strands = $pdo->query('SELECT * FROM strands ORDER BY strand_name')->fetchAll();
$notes = $GLOBALS['steps_settings']['framework_notes'] ?? '';

require_once __DIR__ . '/../includes/sidebar.php';
?>

<?php if ($success): ?>
<script>document.addEventListener('DOMContentLoaded', function() { Toast.fire({ icon: 'success', title: <?= json_encode($success) ?> }); });</script>
<?php endif; ?>
<?php if ($error): ?>
<script>document.addEventListener('DOMContentLoaded', function() { Swal.fire({ ...swalDefaults, icon: 'error', title: <?= json_encode($error) ?> }); });</script>
<?php endif; ?>

<div class="bg-blue-50 border border-blue-100 rounded-xl p-5 mb-6 text-sm text-gray-700">
    <p class="font-medium text-gray-900 mb-1">DepEd alignment</p>
    <p class="text-gray-600"><?= nl2br(sanitize($notes)) ?: 'Add framework notes under System settings.' ?></p>
</div>

<div class="bg-white border border-gray-200 rounded-xl p-6 mb-8">
    <h3 class="text-sm font-semibold text-gray-900 mb-4">Add strand</h3>
    <form method="post" class="grid grid-cols-1 md:grid-cols-3 gap-4 items-end">
        <input type="hidden" name="action" value="add_strand">
        <div>
            <label class="form-label">Code</label>
            <input type="text" name="new_strand_code" class="form-input" maxlength="20" required placeholder="e.g. STEM">
        </div>
        <div class="md:col-span-2">
            <label class="form-label">Name</label>
            <input type="text" name="new_strand_name" class="form-input" required placeholder="Full strand name">
        </div>
        <div class="md:col-span-3">
            <label class="form-label">Description</label>
            <textarea name="new_description" class="form-input" rows="2" placeholder="Curriculum notes"></textarea>
        </div>
        <div>
            <button type="submit" class="btn btn-secondary btn-sm"><i class="fas fa-plus"></i> Add</button>
        </div>
    </form>
</div>

<div class="space-y-6">
    <?php foreach ($strands as $st): ?>
        <form method="post" class="bg-white border border-gray-200 rounded-xl p-6">
            <input type="hidden" name="action" value="save_strand">
            <input type="hidden" name="strand_id" value="<?= (int)$st['id'] ?>">
            <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                <div>
                    <label class="form-label">Code</label>
                    <input type="text" name="strand_code" class="form-input" value="<?= sanitize($st['strand_code']) ?>" required maxlength="20">
                </div>
                <div>
                    <label class="form-label">Name</label>
                    <input type="text" name="strand_name" class="form-input" value="<?= sanitize($st['strand_name']) ?>" required>
                </div>
                <div class="md:col-span-2">
                    <label class="form-label">Description</label>
                    <textarea name="description" class="form-input" rows="3"><?= sanitize($st['description'] ?? '') ?></textarea>
                </div>
            </div>
            <button type="submit" class="btn btn-primary btn-sm mt-4"><i class="fas fa-save"></i> Save</button>
        </form>
    <?php endforeach; ?>
</div>

<?php require_once __DIR__ . '/../includes/footer.php'; ?>
