<?php
$pageTitle = 'System Reports';
require_once __DIR__ . '/../includes/header.php';
requireAdmin();

$sy = effectiveSchoolYear();

$roleCounts = $pdo->query("SELECT role, COUNT(*) as c FROM users GROUP BY role")->fetchAll(PDO::FETCH_KEY_PAIR);
$totalUsers = array_sum($roleCounts);

$loginWeek = $pdo->query("SELECT COUNT(*) FROM activity_logs WHERE action = 'login' AND created_at >= DATE_SUB(NOW(), INTERVAL 7 DAY)")->fetchColumn();
$loginToday = $pdo->query("SELECT COUNT(*) FROM activity_logs WHERE action = 'login' AND DATE(created_at) = CURDATE()")->fetchColumn();
$totalLogs = $pdo->query('SELECT COUNT(*) FROM activity_logs')->fetchColumn();

$backupCount = 0;
try {
    $backupCount = (int)$pdo->query('SELECT COUNT(*) FROM backup_logs')->fetchColumn();
} catch (PDOException $e) {
}

$ticketOpen = 0;
try {
    $ticketOpen = (int)$pdo->query("SELECT COUNT(*) FROM support_tickets WHERE status IN ('open','in_progress')")->fetchColumn();
} catch (PDOException $e) {
}

$actionBreakdown = $pdo->query("SELECT action, COUNT(*) as c FROM activity_logs WHERE created_at >= DATE_SUB(NOW(), INTERVAL 30 DAY) GROUP BY action ORDER BY c DESC LIMIT 15")->fetchAll();

require_once __DIR__ . '/../includes/sidebar.php';
?>

<div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-5 mb-8">
    <div class="stat-card" style="background:#f8fafc;">
        <span class="text-sm font-medium text-gray-600">Total user accounts</span>
        <p class="text-3xl font-bold text-gray-800 mt-2"><?= (int)$totalUsers ?></p>
        <p class="text-xs text-gray-500 mt-1">All roles</p>
    </div>
    <div class="stat-card" style="background:#eff6ff;">
        <span class="text-sm font-medium text-gray-600">Logins (7 days)</span>
        <p class="text-3xl font-bold text-gray-800 mt-2"><?= (int)$loginWeek ?></p>
        <p class="text-xs text-gray-500 mt-1">Today: <?= (int)$loginToday ?></p>
    </div>
    <div class="stat-card" style="background:#f0fdf4;">
        <span class="text-sm font-medium text-gray-600">Activity log rows</span>
        <p class="text-3xl font-bold text-gray-800 mt-2"><?= (int)$totalLogs ?></p>
        <p class="text-xs text-gray-500 mt-1">All time</p>
    </div>
    <div class="stat-card" style="background:#fffbeb;">
        <span class="text-sm font-medium text-gray-600">Backups recorded</span>
        <p class="text-3xl font-bold text-gray-800 mt-2"><?= $backupCount ?></p>
        <p class="text-xs text-gray-500 mt-1">Open tickets: <?= $ticketOpen ?></p>
    </div>
</div>

<div class="grid grid-cols-1 lg:grid-cols-2 gap-6 mb-8">
    <div class="bg-white border border-gray-200 rounded-xl p-6">
        <h3 class="text-sm font-semibold text-gray-900 mb-4">Users by role</h3>
        <ul class="space-y-2 text-sm">
            <?php foreach (['admin' => 'Administrator', 'teacher' => 'Teacher', 'guidance' => 'Guidance counselor'] as $rk => $label): ?>
                <li class="flex justify-between border-b border-gray-100 pb-2">
                    <span class="text-gray-600"><?= $label ?></span>
                    <span class="font-semibold"><?= (int)($roleCounts[$rk] ?? 0) ?></span>
                </li>
            <?php endforeach; ?>
        </ul>
    </div>
    <div class="bg-white border border-gray-200 rounded-xl p-6">
        <h3 class="text-sm font-semibold text-gray-900 mb-4">Configured school year</h3>
        <p class="text-2xl font-bold text-gray-800"><?= sanitize($sy) ?></p>
        <p class="text-xs text-gray-500 mt-2">Change under <a href="<?= BASE_URL ?>admin/settings.php" class="text-blue-600 hover:underline">System settings</a>.</p>
    </div>
</div>

<div class="bg-white border border-gray-200 rounded-xl overflow-hidden">
    <div class="px-6 py-4 border-b border-gray-200">
        <h3 class="text-sm font-semibold text-gray-900">Logged actions (last 30 days)</h3>
        <p class="text-xs text-gray-500 mt-1">Aggregated by action type — no student academic data.</p>
    </div>
    <div class="overflow-x-auto">
        <table class="steps-table">
            <thead>
                <tr><th>Action</th><th>Count</th></tr>
            </thead>
            <tbody>
                <?php foreach ($actionBreakdown as $row): ?>
                    <tr>
                        <td class="font-mono text-sm"><?= sanitize($row['action']) ?></td>
                        <td><?= (int)$row['c'] ?></td>
                    </tr>
                <?php endforeach; ?>
                <?php if (empty($actionBreakdown)): ?>
                    <tr><td colspan="2" class="text-center text-gray-400 py-8">No activity in the last 30 days.</td></tr>
                <?php endif; ?>
            </tbody>
        </table>
    </div>
</div>

<?php require_once __DIR__ . '/../includes/footer.php'; ?>
