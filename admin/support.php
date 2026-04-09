<?php
// Start session and load config BEFORE any output (required for header redirects)
if (session_status() === PHP_SESSION_NONE) session_start();
require_once __DIR__ . '/../config/constants.php';
require_once __DIR__ . '/../config/database.php';

// Check admin access early
if (!isset($_SESSION['user_id']) || ($_SESSION['role'] ?? '') !== 'admin') {
    header('Location: ' . BASE_URL . 'dashboard/index.php');
    exit;
}

$success = '';
$error = '';

// Handle POST with PRG pattern (Post-Redirect-Get) to prevent white page issues
// MUST be done BEFORE any HTML output
if ($_SERVER['REQUEST_METHOD'] === 'POST' && ($_POST['action'] ?? '') === 'reply') {
    $id = (int)($_POST['ticket_id'] ?? 0);
    $status = htmlspecialchars(strip_tags(trim($_POST['status'] ?? 'open')), ENT_QUOTES, 'UTF-8');
    $reply = trim($_POST['admin_reply'] ?? '');
    if (!in_array($status, ['open', 'in_progress', 'resolved'], true)) {
        $status = 'open';
    }
    if ($id > 0) {
        try {
            // Get previous status and subject to check if transitioning
            $prevStmt = $pdo->prepare('SELECT status, user_id, subject FROM support_tickets WHERE id = ?');
            $prevStmt->execute([$id]);
            $prevData = $prevStmt->fetch();
            
            $u = $pdo->prepare('UPDATE support_tickets SET status = ?, admin_reply = ?, replied_by = ?, updated_at = NOW() WHERE id = ?');
            $u->execute([$status, $reply !== '' ? $reply : null, $_SESSION['user_id'], $id]);
            
            // Create notification for status changes
            if ($prevData && $prevData['status'] !== $status) {
                $notifTitle = '';
                $notifMessage = '';
                $notifType = 'info';
                
                $ticketSubject = $prevData['subject'] ?? 'your support ticket';
                if ($status === 'resolved') {
                    $notifTitle = 'Support Ticket Resolved';
                    $notifMessage = 'Your support ticket "' . $ticketSubject . '" has been marked as resolved.';
                    if ($reply) {
                        $notifMessage .= ' Admin reply: ' . $reply;
                    }
                    $notifType = 'success';
                } elseif ($status === 'in_progress') {
                    $notifTitle = 'Support Ticket In Progress';
                    $notifMessage = 'Your support ticket "' . $ticketSubject . '" is now being reviewed by an administrator.';
                    $notifType = 'info';
                }
                
                if ($notifTitle) {
                    try {
                        $notifyStmt = $pdo->prepare("INSERT INTO notifications (user_id, title, message, type, related_id, related_type) VALUES (?, ?, ?, ?, ?, 'support_ticket')");
                        $notifyStmt->execute([
                            $prevData['user_id'],
                            $notifTitle,
                            $notifMessage,
                            $notifType,
                            $id
                        ]);
                    } catch (PDOException $notifE) {
                        error_log('Notification insert failed: ' . $notifE->getMessage());
                    }
                }
            }
            
            $logStmt = $pdo->prepare('INSERT INTO activity_logs (user_id, action, description, ip_address) VALUES (?, ?, ?, ?)');
            $logStmt->execute([$_SESSION['user_id'], 'support_ticket_update', "Ticket #$id updated", $_SERVER['REMOTE_ADDR'] ?? '']);
            
            // Redirect to prevent form resubmission and white page
            $_SESSION['support_success'] = 'Ticket updated successfully.';
            header('Location: ' . BASE_URL . 'admin/support.php');
            exit;
        } catch (PDOException $e) {
            $_SESSION['support_error'] = 'Failed to update ticket: ' . $e->getMessage();
            header('Location: ' . BASE_URL . 'admin/support.php');
            exit;
        }
    }
}

// Check for success/error messages from redirect
if (isset($_SESSION['support_success'])) {
    $success = $_SESSION['support_success'];
    unset($_SESSION['support_success']);
}
if (isset($_SESSION['support_error'])) {
    $error = $_SESSION['support_error'];
    unset($_SESSION['support_error']);
}

// Now load header (which outputs HTML)
$pageTitle = 'Support Tickets';
require_once __DIR__ . '/../includes/header.php';

$tickets = [];
try {
    $tickets = $pdo->query("SELECT t.*, u.full_name, u.username FROM support_tickets t JOIN users u ON t.user_id = u.id ORDER BY t.updated_at DESC")->fetchAll();
} catch (PDOException $e) {
    $tickets = [];
}

require_once __DIR__ . '/../includes/sidebar.php';
?>

<?php if ($success): ?>
<script>document.addEventListener('DOMContentLoaded', function() { Toast.fire({ icon: 'success', title: <?= json_encode($success) ?> }); });</script>
<?php endif; ?>
<?php if ($error): ?>
<script>document.addEventListener('DOMContentLoaded', function() { Swal.fire({ icon: 'error', title: 'Error', text: <?= json_encode($error) ?> }); });</script>
<?php endif; ?>

<div class="space-y-6">
    <?php foreach ($tickets as $t): ?>
        <div class="bg-white border border-gray-200 rounded-xl p-6">
            <div class="flex flex-wrap justify-between gap-2 mb-3">
                <div>
                    <span class="badge <?= $t['status'] === 'resolved' ? 'badge-green' : ($t['status'] === 'in_progress' ? 'badge-amber' : 'badge-blue') ?>"><?= sanitize($t['status']) ?></span>
                    <span class="text-sm text-gray-500 ml-2"><?= date('M d, Y H:i', strtotime($t['created_at'])) ?></span>
                </div>
                <span class="text-sm text-gray-600"><?= sanitize($t['full_name']) ?> (<?= sanitize($t['username']) ?>)</span>
            </div>
            <h3 class="font-semibold text-gray-900 mb-2"><?= sanitize($t['subject']) ?></h3>
            <p class="text-sm text-gray-700 whitespace-pre-wrap mb-4"><?= sanitize($t['message']) ?></p>
            <?php if (!empty($t['admin_reply'])): ?>
                <div class="bg-gray-50 rounded-lg p-4 mb-4 text-sm border border-gray-100">
                    <p class="text-xs font-semibold text-gray-500 mb-1">Previous reply</p>
                    <?= nl2br(sanitize($t['admin_reply'])) ?>
                </div>
            <?php endif; ?>
            <form method="post" class="space-y-3" <?= $t['status'] === 'resolved' ? 'onsubmit="return false;"' : '' ?>>
                <input type="hidden" name="action" value="reply">
                <input type="hidden" name="ticket_id" value="<?= (int)$t['id'] ?>">
                <div>
                    <label class="form-label">Status</label>
                    <select name="status" class="form-select max-w-xs" <?= $t['status'] === 'resolved' ? 'disabled' : '' ?>>
                        <option value="open" <?= $t['status'] === 'open' ? 'selected' : '' ?>>Open</option>
                        <option value="in_progress" <?= $t['status'] === 'in_progress' ? 'selected' : '' ?>>In progress</option>
                        <option value="resolved" <?= $t['status'] === 'resolved' ? 'selected' : '' ?>>Resolved</option>
                    </select>
                </div>
                <div>
                    <label class="form-label">Reply / notes</label>
                    <textarea name="admin_reply" class="form-input" rows="3" placeholder="Optional message for your records" <?= $t['status'] === 'resolved' ? 'disabled' : '' ?>><?= sanitize($t['admin_reply'] ?? '') ?></textarea>
                </div>
                <?php if ($t['status'] === 'resolved'): ?>
                    <div class="flex items-center justify-between gap-2 py-2">
                        <div class="flex items-center gap-2 text-sm text-gray-500">
                            <i class="fas fa-check-circle text-green-500"></i>
                            <span>This ticket is resolved.</span>
                        </div>
                        <button type="submit" name="status" value="open" class="btn btn-secondary btn-sm" onclick="this.form.status.value='open'; this.form.submit();"><i class="fas fa-redo"></i> Re-open</button>
                    </div>
                <?php else: ?>
                    <button type="submit" class="btn btn-primary btn-sm"><i class="fas fa-save"></i> Update ticket</button>
                <?php endif; ?>
            </form>
        </div>
    <?php endforeach; ?>
    <?php if (empty($tickets)): ?>
        <p class="text-gray-500 text-sm">No support tickets yet. Users can submit requests from <strong>Help &amp; Support</strong> in the menu.</p>
    <?php endif; ?>
</div>

<?php require_once __DIR__ . '/../includes/footer.php'; ?>
