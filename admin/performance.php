<?php
$pageTitle = 'System Performance';
require_once __DIR__ . '/../includes/header.php';
requireAdmin();

$t0 = microtime(true);
$pdo->query('SELECT 1')->fetchColumn();
$dbPingMs = round((microtime(true) - $t0) * 1000, 2);

$phpVer = PHP_VERSION;
$memoryLimit = ini_get('memory_limit');
$maxUpload = ini_get('upload_max_filesize');

$tables = ['users', 'students', 'grades', 'activity_logs', 'system_settings', 'support_tickets', 'backup_logs'];
$counts = [];
foreach ($tables as $t) {
    try {
        $counts[$t] = (int)$pdo->query("SELECT COUNT(*) FROM `$t`")->fetchColumn();
    } catch (PDOException $e) {
        $counts[$t] = null;
    }
}

$backupDir = realpath(__DIR__ . '/../backup/files');
$diskFree = $backupDir && function_exists('disk_free_space') ? disk_free_space(dirname($backupDir)) : null;

require_once __DIR__ . '/../includes/sidebar.php';
?>

<div class="grid grid-cols-1 md:grid-cols-3 gap-5 mb-8">
    <div class="stat-card" style="background:#eff6ff;">
        <span class="text-sm font-medium text-gray-600">DB ping</span>
        <p class="text-3xl font-bold text-gray-800 mt-2"><?= $dbPingMs ?> ms</p>
        <p class="text-xs text-gray-500 mt-1">Simple query round-trip</p>
    </div>
    <div class="stat-card" style="background:#f0fdf4;">
        <span class="text-sm font-medium text-gray-600">PHP</span>
        <p class="text-lg font-bold text-gray-800 mt-2"><?= sanitize($phpVer) ?></p>
        <p class="text-xs text-gray-500 mt-1">Memory limit: <?= sanitize($memoryLimit) ?></p>
    </div>
    <div class="stat-card" style="background:#fffbeb;">
        <span class="text-sm font-medium text-gray-600">Upload limit</span>
        <p class="text-2xl font-bold text-gray-800 mt-2"><?= sanitize($maxUpload) ?></p>
        <?php if ($diskFree !== null): ?>
            <p class="text-xs text-gray-500 mt-1">Free disk (volume): <?= number_format($diskFree / 1073741824, 2) ?> GB</p>
        <?php endif; ?>
    </div>
</div>

<div class="bg-white border border-gray-200 rounded-xl overflow-hidden">
    <div class="px-6 py-4 border-b border-gray-200">
        <h3 class="text-sm font-semibold text-gray-900">Table row counts</h3>
        <p class="text-xs text-gray-500 mt-1">Operational snapshot — not student grade detail.</p>
    </div>
    <table class="steps-table">
        <thead><tr><th>Table</th><th>Rows</th></tr></thead>
        <tbody>
            <?php foreach ($counts as $tbl => $c): ?>
                <tr>
                    <td class="font-mono text-sm"><?= sanitize($tbl) ?></td>
                    <td><?= $c === null ? '—' : (int)$c ?></td>
                </tr>
            <?php endforeach; ?>
        </tbody>
    </table>
</div>

<?php require_once __DIR__ . '/../includes/footer.php'; ?>
