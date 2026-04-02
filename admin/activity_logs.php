<?php
$pageTitle = 'Activity Logs';
require_once __DIR__ . '/../includes/header.php';
requireAdmin();

$page = max(1, (int)($_GET['page'] ?? 1));
$perPage = 50;
$offset = ($page - 1) * $perPage;

$actionFilter = sanitize($_GET['action'] ?? '');
$where = '1=1';
$params = [];
if ($actionFilter !== '') {
    $where .= ' AND al.action = ?';
    $params[] = $actionFilter;
}

$countStmt = $pdo->prepare("SELECT COUNT(*) FROM activity_logs al WHERE $where");
$countStmt->execute($params);
$totalRows = (int)$countStmt->fetchColumn();
$totalPages = max(1, (int)ceil($totalRows / $perPage));

$sql = "SELECT al.*, u.full_name, u.username
        FROM activity_logs al
        LEFT JOIN users u ON al.user_id = u.id
        WHERE $where
        ORDER BY al.created_at DESC
        LIMIT $perPage OFFSET $offset";
$stmt = $pdo->prepare($sql);
$stmt->execute($params);
$rows = $stmt->fetchAll();

$actions = $pdo->query('SELECT DISTINCT action FROM activity_logs ORDER BY action')->fetchAll(PDO::FETCH_COLUMN);

require_once __DIR__ . '/../includes/sidebar.php';
?>

<form method="get" class="mb-6 flex flex-wrap items-end gap-4">
    <div>
        <label class="form-label">Action</label>
        <select name="action" class="form-select w-56">
            <option value="">All</option>
            <?php foreach ($actions as $a): ?>
                <option value="<?= sanitize($a) ?>" <?= $actionFilter === $a ? 'selected' : '' ?>><?= sanitize($a) ?></option>
            <?php endforeach; ?>
        </select>
    </div>
    <button type="submit" class="btn btn-primary btn-sm"><i class="fas fa-filter"></i> Filter</button>
    <a href="<?= BASE_URL ?>admin/activity_logs.php" class="btn btn-secondary btn-sm">Reset</a>
</form>

<div class="bg-white border border-gray-200 rounded-xl overflow-hidden">
    <div class="overflow-x-auto">
        <table class="steps-table">
            <thead>
                <tr>
                    <th>When</th>
                    <th>User</th>
                    <th>Action</th>
                    <th>Description</th>
                    <th>IP</th>
                </tr>
            </thead>
            <tbody>
                <?php foreach ($rows as $r): ?>
                    <tr>
                        <td class="text-sm whitespace-nowrap"><?= date('M d, Y H:i', strtotime($r['created_at'])) ?></td>
                        <td class="text-sm"><?= $r['full_name'] ? sanitize($r['full_name']) : '<span class="text-gray-400">—</span>' ?></td>
                        <td class="font-mono text-xs"><?= sanitize($r['action']) ?></td>
                        <td class="text-sm max-w-md truncate" title="<?= sanitize($r['description'] ?? '') ?>"><?= sanitize($r['description'] ?? '') ?></td>
                        <td class="text-xs font-mono"><?= sanitize($r['ip_address'] ?? '') ?></td>
                    </tr>
                <?php endforeach; ?>
                <?php if (empty($rows)): ?>
                    <tr><td colspan="5" class="text-center text-gray-400 py-10">No log entries.</td></tr>
                <?php endif; ?>
            </tbody>
        </table>
    </div>
</div>

<?php if ($totalPages > 1): ?>
<div class="mt-4 flex justify-center gap-2">
    <?php if ($page > 1): ?>
        <a class="btn btn-secondary btn-sm" href="?page=<?= $page - 1 ?>&action=<?= urlencode($actionFilter) ?>">Previous</a>
    <?php endif; ?>
    <span class="text-sm text-gray-600 py-2">Page <?= $page ?> of <?= $totalPages ?></span>
    <?php if ($page < $totalPages): ?>
        <a class="btn btn-secondary btn-sm" href="?page=<?= $page + 1 ?>&action=<?= urlencode($actionFilter) ?>">Next</a>
    <?php endif; ?>
</div>
<?php endif; ?>

<?php require_once __DIR__ . '/../includes/footer.php'; ?>
