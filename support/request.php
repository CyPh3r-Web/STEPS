<?php
$pageTitle = 'Help & Support';
require_once __DIR__ . '/../includes/header.php';
requireLogin();

if (($_SESSION['role'] ?? '') === 'admin') {
    header('Location: ' . BASE_URL . 'admin/support.php');
    exit;
}

$success = '';
$error = '';

// Fetch user's tickets
$userTickets = [];
try {
    $stmt = $pdo->prepare('SELECT id, subject, status, admin_reply, created_at FROM support_tickets WHERE user_id = ? ORDER BY created_at DESC');
    $stmt->execute([$_SESSION['user_id']]);
    $userTickets = $stmt->fetchAll();
} catch (PDOException $e) {
    $userTickets = [];
}

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $subject = sanitize($_POST['subject'] ?? '');
    $message = trim($_POST['message'] ?? '');
    if ($subject === '' || $message === '') {
        $error = 'Please enter subject and message.';
    } else {
        try {
            $ins = $pdo->prepare('INSERT INTO support_tickets (user_id, subject, message) VALUES (?, ?, ?)');
            $ins->execute([$_SESSION['user_id'], $subject, $message]);
            $success = 'Your request was submitted. An administrator will follow up.';
        } catch (PDOException $e) {
            $error = 'Could not submit ticket. Ensure the database includes the support_tickets table.';
        }
    }
}

require_once __DIR__ . '/../includes/sidebar.php';
?>

<?php if ($success): ?>
<script>document.addEventListener('DOMContentLoaded', function() { 
    Swal.fire({ ...swalDefaults, icon: 'success', title: <?= json_encode($success) ?> }).then(() => {
    });
});</script>
<?php endif; ?>
<?php if ($error): ?>
<script>document.addEventListener('DOMContentLoaded', function() { Swal.fire({ ...swalDefaults, icon: 'error', title: <?= json_encode($error) ?> }); });</script>
<?php endif; ?>

<div class="bg-white border border-gray-200 rounded-xl p-6 max-w-xl mb-6">
    <p class="text-sm text-gray-600 mb-6">Describe the issue (login, import, reports, etc.). This does not share student grades with the message — only your account is recorded.</p>
    <form method="post" class="space-y-4">
        <div>
            <label class="form-label">Subject</label>
            <input type="text" name="subject" class="form-input" required maxlength="200" value="<?= $success ? '' : sanitize($_POST['subject'] ?? '') ?>">
        </div>
        <div>
            <label class="form-label">Message</label>
            <textarea name="message" class="form-input" rows="5" required><?= $success ? '' : sanitize($_POST['message'] ?? '') ?></textarea>
        </div>
        <button type="submit" class="btn btn-primary"><i class="fas fa-paper-plane"></i> Submit</button>
    </form>
</div>

<?php if (!empty($userTickets)): ?>
<div class="bg-white border border-gray-200 rounded-xl p-6 max-w-xl">
    <h3 class="text-sm font-semibold text-gray-900 mb-4"><i class="fas fa-ticket-alt text-blue-600 mr-2"></i>Your Support Tickets</h3>
    <div class="space-y-3">
        <?php foreach ($userTickets as $ticket): ?>
            <?php
           if ($ticket['status'] === 'resolved') {
                $statusLabel = 'Resolved';
                $statusClass  = 'badge-green';
                $statusIcon   = 'fa-check-circle';
            } elseif ($ticket['status'] === 'in_progress') {
                $statusLabel = 'In Progress';
                $statusClass  = 'badge-blue';
                $statusIcon   = 'fa-spinner';
            } else {
                $statusLabel = 'Pending';
                $statusClass  = 'badge-amber';
                $statusIcon   = 'fa-clock';
            }
            ?>
            <div class="border border-gray-200 rounded-lg p-4">
                <div class="flex items-start justify-between gap-3">
                    <div class="flex-1 min-w-0">
                        <p class="font-medium text-gray-900 truncate"><?= sanitize($ticket['subject']) ?></p>
                        <p class="text-xs text-gray-500 mt-1">Ticket #<?= (int)$ticket['id'] ?> • <?= date('M d, Y', strtotime($ticket['created_at'])) ?></p>
                    </div>
                    <span class="badge <?= $statusClass ?> flex-shrink-0">
                        <i class="fas <?= $statusIcon ?> mr-1"></i><?= $statusLabel ?>
                    </span>
                </div>
                <?php if (!empty($ticket['admin_reply'])): ?>
                    <div class="mt-3 pt-3 border-t border-gray-100">
                        <p class="text-xs font-semibold text-gray-500 mb-1">Admin Response:</p>
                        <p class="text-sm text-gray-700"><?= nl2br(sanitize($ticket['admin_reply'])) ?></p>
                    </div>
                <?php endif; ?>
            </div>
        <?php endforeach; ?>
    </div>
</div>
<?php endif; ?>

<?php require_once __DIR__ . '/../includes/footer.php'; ?>
