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
        document.querySelector('form').reset();
    });
});</script>
<?php endif; ?>
<?php if ($error): ?>
<script>document.addEventListener('DOMContentLoaded', function() { Swal.fire({ ...swalDefaults, icon: 'error', title: <?= json_encode($error) ?> }); });</script>
<?php endif; ?>

<div class="bg-white border border-gray-200 rounded-xl p-6 max-w-xl">
    <p class="text-sm text-gray-600 mb-6">Describe the issue (login, import, reports, etc.). This does not share student grades with the message — only your account is recorded.</p>
    <form method="post" class="space-y-4">
        <div>
            <label class="form-label">Subject</label>
            <input type="text" name="subject" class="form-input" required maxlength="200" value="<?= sanitize($_POST['subject'] ?? '') ?>">
        </div>
        <div>
            <label class="form-label">Message</label>
            <textarea name="message" class="form-input" rows="5" required><?= sanitize($_POST['message'] ?? '') ?></textarea>
        </div>
        <button type="submit" class="btn btn-primary"><i class="fas fa-paper-plane"></i> Submit</button>
    </form>
</div>

<?php require_once __DIR__ . '/../includes/footer.php'; ?>
