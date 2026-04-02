<?php
$pageTitle = 'System Settings';
require_once __DIR__ . '/../includes/header.php';
requireAdmin();

$success = '';
$error = '';

$keys = [
    'school_year' => ['label' => 'Academic year (display & defaults)', 'type' => 'text', 'placeholder' => '2025-2026'],
    'comp_weak_threshold' => ['label' => 'Competency: below this grade = weak', 'type' => 'number', 'step' => '0.01'],
    'comp_at_risk_min' => ['label' => 'Competency: at-risk range (min)', 'type' => 'number', 'step' => '0.01'],
    'comp_at_risk_max' => ['label' => 'Competency: at-risk range (max)', 'type' => 'number', 'step' => '0.01'],
    'comp_proficient_min' => ['label' => 'Competency: proficient from (min grade)', 'type' => 'number', 'step' => '0.01'],
    'emp_moderate_min' => ['label' => 'Employability: moderate band starts at', 'type' => 'number', 'step' => '0.01'],
    'emp_high_min' => ['label' => 'Employability: high band starts at', 'type' => 'number', 'step' => '0.01'],
    'emp_very_high_min' => ['label' => 'Employability: very high band starts at', 'type' => 'number', 'step' => '0.01'],
    'framework_notes' => ['label' => 'Competency framework / DepEd alignment notes', 'type' => 'textarea'],
];

if ($_SERVER['REQUEST_METHOD'] === 'POST' && ($_POST['action'] ?? '') === 'save_settings') {
    try {
        $pdo->beginTransaction();
        $ins = $pdo->prepare('INSERT INTO system_settings (setting_key, setting_value) VALUES (?, ?) ON DUPLICATE KEY UPDATE setting_value = VALUES(setting_value)');
        foreach ($keys as $k => $meta) {
            $val = $_POST['setting'][$k] ?? '';
            if ($meta['type'] === 'textarea') {
                $val = trim((string)$val);
            } else {
                $val = trim(sanitize((string)$val));
            }
            $ins->execute([$k, $val]);
        }
        $pdo->commit();
        $GLOBALS['steps_settings'] = $pdo->query('SELECT setting_key, setting_value FROM system_settings')->fetchAll(PDO::FETCH_KEY_PAIR);
        $logStmt = $pdo->prepare('INSERT INTO activity_logs (user_id, action, description, ip_address) VALUES (?, ?, ?, ?)');
        $logStmt->execute([$_SESSION['user_id'], 'settings_update', 'System settings updated', $_SERVER['REMOTE_ADDR'] ?? '']);
        $success = 'Settings saved.';
    } catch (Exception $e) {
        if ($pdo->inTransaction()) {
            $pdo->rollBack();
        }
        $error = 'Could not save settings.';
    }
}

$current = $GLOBALS['steps_settings'] ?? [];
foreach (array_keys($keys) as $k) {
    if (!isset($current[$k])) {
        $current[$k] = '';
    }
}

require_once __DIR__ . '/../includes/sidebar.php';
?>

<?php if ($success): ?>
<script>document.addEventListener('DOMContentLoaded', function() { Toast.fire({ icon: 'success', title: <?= json_encode($success) ?> }); });</script>
<?php endif; ?>
<?php if ($error): ?>
<script>document.addEventListener('DOMContentLoaded', function() { Swal.fire({ ...swalDefaults, icon: 'error', title: <?= json_encode($error) ?> }); });</script>
<?php endif; ?>

<div class="bg-white border border-gray-200 rounded-xl p-6 max-w-3xl">
    <p class="text-sm text-gray-600 mb-6">These values drive competency labels and employability readiness bands across the system. Teachers and counselors use encoded data; this screen does not show student records.</p>
    <form method="post">
        <input type="hidden" name="action" value="save_settings">
        <div class="space-y-4">
            <?php foreach ($keys as $k => $meta): ?>
                <div>
                    <label class="form-label"><?= sanitize($meta['label']) ?></label>
                    <?php if ($meta['type'] === 'textarea'): ?>
                        <textarea name="setting[<?= htmlspecialchars($k) ?>]" class="form-input" rows="4"><?= htmlspecialchars($current[$k]) ?></textarea>
                    <?php else: ?>
                        <input type="<?= $meta['type'] === 'number' ? 'number' : 'text' ?>"
                               name="setting[<?= htmlspecialchars($k) ?>]"
                               class="form-input"
                               value="<?= htmlspecialchars($current[$k]) ?>"
                               <?= !empty($meta['step']) ? 'step="' . htmlspecialchars($meta['step']) . '"' : '' ?>
                               <?= !empty($meta['placeholder']) ? 'placeholder="' . htmlspecialchars($meta['placeholder']) . '"' : '' ?>>
                    <?php endif; ?>
                </div>
            <?php endforeach; ?>
        </div>
        <div class="mt-8 pt-6 border-t border-gray-200">
            <button type="submit" class="btn btn-primary"><i class="fas fa-save"></i> Save settings</button>
        </div>
    </form>
</div>

<?php require_once __DIR__ . '/../includes/footer.php'; ?>
