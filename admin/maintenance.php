<?php
$pageTitle = 'System Maintenance';
require_once __DIR__ . '/../includes/header.php';
requireAdmin();

require_once __DIR__ . '/../includes/sidebar.php';
?>

<div class="bg-white border border-gray-200 rounded-xl p-6 max-w-3xl space-y-4 text-sm text-gray-700">
    <p>Use this area as a checklist for your server environment. STEPS does not auto-install OS or PHP updates from the browser — apply patches on the host (WAMP/XAMPP/Linux) following your school IT policy.</p>
    <ul class="list-disc pl-5 space-y-2">
        <li>Review <a href="<?= BASE_URL ?>admin/activity_logs.php" class="text-blue-600 hover:underline">activity logs</a> for failed logins or unusual actions.</li>
        <li>Run <a href="<?= BASE_URL ?>backup/index.php" class="text-blue-600 hover:underline">backups</a> before major updates.</li>
        <li>Keep MySQL and PHP versions supported and apply security updates regularly.</li>
        <li>Restrict file permissions on <code class="bg-gray-100 px-1 rounded">config/database.php</code> and backup directories.</li>
    </ul>
</div>

<?php require_once __DIR__ . '/../includes/footer.php'; ?>
