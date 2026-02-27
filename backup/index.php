<?php
$pageTitle = 'Backup & Recovery';
require_once __DIR__ . '/../includes/header.php';
requireRole('admin');

$backupDir = __DIR__ . '/files/';
if (!is_dir($backupDir)) {
    mkdir($backupDir, 0755, true);
}

$success = '';
$error = '';

// Create backup
if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['action'])) {
    if ($_POST['action'] === 'create_backup') {
        $timestamp = date('Y-m-d_H-i-s');
        $filename = "steps_backup_{$timestamp}.sql";
        $filepath = $backupDir . $filename;

        $tables = $pdo->query("SHOW TABLES")->fetchAll(PDO::FETCH_COLUMN);
        $sql = "-- STEPS Database Backup\n";
        $sql .= "-- Date: " . date('F d, Y h:i:s A') . "\n";
        $sql .= "-- Database: " . DB_NAME . "\n\n";
        $sql .= "SET FOREIGN_KEY_CHECKS = 0;\n\n";

        foreach ($tables as $table) {
            $createStmt = $pdo->query("SHOW CREATE TABLE `{$table}`")->fetch();
            $sql .= "DROP TABLE IF EXISTS `{$table}`;\n";
            $sql .= $createStmt['Create Table'] . ";\n\n";

            $rows = $pdo->query("SELECT * FROM `{$table}`")->fetchAll();
            if (!empty($rows)) {
                $cols = array_keys($rows[0]);
                $colNames = '`' . implode('`, `', $cols) . '`';

                foreach ($rows as $row) {
                    $values = array_map(function($val) use ($pdo) {
                        return $val === null ? 'NULL' : $pdo->quote($val);
                    }, array_values($row));
                    $sql .= "INSERT INTO `{$table}` ({$colNames}) VALUES (" . implode(', ', $values) . ");\n";
                }
                $sql .= "\n";
            }
        }

        $sql .= "SET FOREIGN_KEY_CHECKS = 1;\n";

        if (file_put_contents($filepath, $sql)) {
            $fileSize = round(filesize($filepath) / 1024, 2) . ' KB';
            $logStmt = $pdo->prepare("INSERT INTO backup_logs (backup_file, file_size, backup_type, created_by) VALUES (?, ?, 'full', ?)");
            $logStmt->execute([$filename, $fileSize, $_SESSION['user_id']]);

            $actLog = $pdo->prepare("INSERT INTO activity_logs (user_id, action, description, ip_address) VALUES (?, 'backup', ?, ?)");
            $actLog->execute([$_SESSION['user_id'], "Created backup: $filename", $_SERVER['REMOTE_ADDR']]);

            $success = "Backup created successfully: {$filename} ({$fileSize})";
        } else {
            $error = "Failed to create backup file. Check directory permissions.";
        }
    }

    if ($_POST['action'] === 'restore' && isset($_POST['backup_file'])) {
        $restoreFile = $backupDir . basename($_POST['backup_file']);
        if (file_exists($restoreFile)) {
            $sql = file_get_contents($restoreFile);
            try {
                $pdo->exec($sql);
                $actLog = $pdo->prepare("INSERT INTO activity_logs (user_id, action, description, ip_address) VALUES (?, 'restore', ?, ?)");
                $actLog->execute([$_SESSION['user_id'], "Restored from: " . basename($restoreFile), $_SERVER['REMOTE_ADDR']]);
                $success = "Database restored successfully from: " . basename($restoreFile);
            } catch (PDOException $e) {
                $error = "Restore failed: " . $e->getMessage();
            }
        } else {
            $error = "Backup file not found.";
        }
    }

    if ($_POST['action'] === 'delete' && isset($_POST['backup_file'])) {
        $deleteFile = $backupDir . basename($_POST['backup_file']);
        if (file_exists($deleteFile) && unlink($deleteFile)) {
            $success = "Backup file deleted: " . basename($_POST['backup_file']);
        } else {
            $error = "Could not delete the backup file.";
        }
    }
}

// List backup logs
$backupLogs = $pdo->query("SELECT bl.*, u.full_name FROM backup_logs bl
    LEFT JOIN users u ON bl.created_by = u.id
    ORDER BY bl.created_at DESC")->fetchAll();

// List physical files
$backupFiles = glob($backupDir . '*.sql');
usort($backupFiles, fn($a, $b) => filemtime($b) - filemtime($a));

require_once __DIR__ . '/../includes/sidebar.php';
?>

<?php if ($success): ?>
<script>
document.addEventListener('DOMContentLoaded', function() {
    Swal.fire({
        ...swalDefaults,
        icon: 'success',
        title: 'Success',
        text: <?= json_encode($success) ?>,
        confirmButtonColor: '#2563eb'
    });
});
</script>
<?php endif; ?>
<?php if ($error): ?>
<script>
document.addEventListener('DOMContentLoaded', function() {
    Swal.fire({
        ...swalDefaults,
        icon: 'error',
        title: 'Error',
        text: <?= json_encode($error) ?>,
        confirmButtonColor: '#2563eb'
    });
});
</script>
<?php endif; ?>

<!-- Create Backup -->
<div class="bg-white border border-gray-200 rounded-xl p-6 mb-6">
    <div class="flex flex-wrap items-center justify-between gap-4">
        <div>
            <h3 class="text-base font-semibold text-gray-900">Database Backup</h3>
            <p class="text-sm text-gray-500 mt-1">Create a full backup of the STEPS database.</p>
        </div>
        <form method="POST" id="backupForm">
            <input type="hidden" name="action" value="create_backup">
            <button type="button" class="btn btn-primary" onclick="confirmSubmit(document.getElementById('backupForm'), 'Create Backup?', 'A full backup of the STEPS database will be created.', 'Yes, create backup')">
                <i class="fas fa-download"></i> Create Backup Now
            </button>
        </form>
    </div>
</div>

<!-- Backup Files -->
<div class="bg-white border border-gray-200 rounded-xl overflow-hidden mb-6">
    <div class="px-6 py-4 border-b border-gray-200">
        <h3 class="text-sm font-semibold text-gray-900">Available Backup Files</h3>
    </div>
    <div class="overflow-x-auto">
        <table class="steps-table">
            <thead>
                <tr>
                    <th>Filename</th>
                    <th>Size</th>
                    <th>Date Created</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <?php foreach ($backupFiles as $file): ?>
                    <?php $fname = basename($file); ?>
                    <tr>
                        <td class="font-medium text-sm">
                            <i class="fas fa-file-code text-gray-400 mr-2"></i><?= sanitize($fname) ?>
                        </td>
                        <td class="text-sm"><?= round(filesize($file) / 1024, 2) ?> KB</td>
                        <td class="text-sm"><?= date('M d, Y h:i A', filemtime($file)) ?></td>
                        <td>
                            <div class="flex items-center gap-2">
                                <a href="<?= BASE_URL ?>backup/download.php?file=<?= urlencode($fname) ?>" class="btn btn-secondary btn-sm">
                                    <i class="fas fa-download"></i> Download
                                </a>
                                <form method="POST" class="inline">
                                    <input type="hidden" name="action" value="restore">
                                    <input type="hidden" name="backup_file" value="<?= $fname ?>">
                                    <button type="button" class="btn btn-primary btn-sm"
                                            onclick="confirmDanger(this.closest('form'), 'Restore Database?', 'WARNING: This will overwrite the current database with the selected backup. This cannot be undone.')">
                                        <i class="fas fa-undo"></i> Restore
                                    </button>
                                </form>
                                <form method="POST" class="inline">
                                    <input type="hidden" name="action" value="delete">
                                    <input type="hidden" name="backup_file" value="<?= $fname ?>">
                                    <button type="button" class="btn btn-danger btn-sm"
                                            onclick="confirmDelete(this.closest('form'), 'this backup file')">
                                        <i class="fas fa-trash"></i>
                                    </button>
                                </form>
                            </div>
                        </td>
                    </tr>
                <?php endforeach; ?>
                <?php if (empty($backupFiles)): ?>
                    <tr><td colspan="4" class="text-center text-gray-400 py-8">No backup files found. Create your first backup above.</td></tr>
                <?php endif; ?>
            </tbody>
        </table>
    </div>
</div>

<!-- Backup History -->
<div class="bg-white border border-gray-200 rounded-xl overflow-hidden">
    <div class="px-6 py-4 border-b border-gray-200">
        <h3 class="text-sm font-semibold text-gray-900">Backup History</h3>
    </div>
    <div class="overflow-x-auto">
        <table class="steps-table">
            <thead>
                <tr>
                    <th>File</th><th>Size</th><th>Type</th><th>Created By</th><th>Date</th>
                </tr>
            </thead>
            <tbody>
                <?php foreach ($backupLogs as $log): ?>
                    <tr>
                        <td class="text-sm font-mono"><?= sanitize($log['backup_file']) ?></td>
                        <td><?= sanitize($log['file_size']) ?></td>
                        <td><span class="badge badge-blue capitalize"><?= $log['backup_type'] ?></span></td>
                        <td><?= sanitize($log['full_name'] ?? 'System') ?></td>
                        <td class="text-sm"><?= date('M d, Y h:i A', strtotime($log['created_at'])) ?></td>
                    </tr>
                <?php endforeach; ?>
                <?php if (empty($backupLogs)): ?>
                    <tr><td colspan="5" class="text-center text-gray-400 py-8">No backup history.</td></tr>
                <?php endif; ?>
            </tbody>
        </table>
    </div>
</div>

<?php require_once __DIR__ . '/../includes/footer.php'; ?>
