<?php
$pageTitle = 'Change Password';
require_once __DIR__ . '/../includes/header.php';
requireLogin();

$success = '';
$error = '';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $currentPassword = $_POST['current_password'] ?? '';
    $newPassword = $_POST['new_password'] ?? '';
    $confirmPassword = $_POST['confirm_password'] ?? '';

    if (empty($currentPassword) || empty($newPassword) || empty($confirmPassword)) {
        $error = 'Please fill in all fields.';
    } elseif (strlen($newPassword) < 6) {
        $error = 'New password must be at least 6 characters.';
    } elseif ($newPassword !== $confirmPassword) {
        $error = 'New password and confirmation do not match.';
    } else {
        $stmt = $pdo->prepare("SELECT password FROM users WHERE id = ?");
        $stmt->execute([$_SESSION['user_id']]);
        $user = $stmt->fetch();

        if (!password_verify($currentPassword, $user['password'])) {
            $error = 'Current password is incorrect.';
        } else {
            $hashedPassword = password_hash($newPassword, PASSWORD_DEFAULT);
            $updateStmt = $pdo->prepare("UPDATE users SET password = ? WHERE id = ?");
            $updateStmt->execute([$hashedPassword, $_SESSION['user_id']]);

            $logStmt = $pdo->prepare("INSERT INTO activity_logs (user_id, action, description, ip_address) VALUES (?, 'password_change', 'User changed password', ?)");
            $logStmt->execute([$_SESSION['user_id'], $_SERVER['REMOTE_ADDR']]);

            $success = 'Your password has been changed successfully.';
        }
    }
}

require_once __DIR__ . '/../includes/sidebar.php';
?>

<?php if ($success): ?>
<script>
document.addEventListener('DOMContentLoaded', function() {
    Swal.fire({
        ...swalDefaults,
        icon: 'success',
        title: 'Password Changed',
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

<div class="max-w-md">
    <div class="bg-white border border-gray-200 rounded-xl p-6">
        <div class="flex items-center gap-3 mb-6">
            <div class="w-10 h-10 bg-blue-50 rounded-lg flex items-center justify-center">
                <i class="fas fa-lock text-blue-600"></i>
            </div>
            <div>
                <h3 class="text-base font-semibold text-gray-900">Change Password</h3>
                <p class="text-xs text-gray-500">Update your account password</p>
            </div>
        </div>

        <form method="POST">
            <div class="space-y-5">
                <div>
                    <label class="form-label">Current Password <span class="text-red-500">*</span></label>
                    <div class="relative">
                        <input type="password" name="current_password" class="form-input pr-10" required
                               placeholder="Enter current password" id="currentPwd">
                        <button type="button" onclick="togglePwd('currentPwd', 'icon1')" class="absolute right-3 top-1/2 -translate-y-1/2 text-gray-400 hover:text-gray-600">
                            <i class="fas fa-eye" id="icon1"></i>
                        </button>
                    </div>
                </div>

                <hr class="border-gray-100">

                <div>
                    <label class="form-label">New Password <span class="text-red-500">*</span></label>
                    <div class="relative">
                        <input type="password" name="new_password" class="form-input pr-10" required
                               placeholder="Minimum 6 characters" minlength="6" id="newPwd">
                        <button type="button" onclick="togglePwd('newPwd', 'icon2')" class="absolute right-3 top-1/2 -translate-y-1/2 text-gray-400 hover:text-gray-600">
                            <i class="fas fa-eye" id="icon2"></i>
                        </button>
                    </div>
                </div>
                <div>
                    <label class="form-label">Confirm New Password <span class="text-red-500">*</span></label>
                    <div class="relative">
                        <input type="password" name="confirm_password" class="form-input pr-10" required
                               placeholder="Re-enter new password" minlength="6" id="confirmPwd">
                        <button type="button" onclick="togglePwd('confirmPwd', 'icon3')" class="absolute right-3 top-1/2 -translate-y-1/2 text-gray-400 hover:text-gray-600">
                            <i class="fas fa-eye" id="icon3"></i>
                        </button>
                    </div>
                </div>
            </div>

            <div class="flex items-center gap-3 mt-8 pt-6 border-t border-gray-200">
                <button type="submit" class="btn btn-primary"><i class="fas fa-save"></i> Update Password</button>
                <a href="<?= BASE_URL ?>dashboard/index.php" class="btn btn-secondary">Cancel</a>
            </div>
        </form>
    </div>
</div>

<script>
function togglePwd(inputId, iconId) {
    const input = document.getElementById(inputId);
    const icon = document.getElementById(iconId);
    if (input.type === 'password') {
        input.type = 'text';
        icon.classList.replace('fa-eye', 'fa-eye-slash');
    } else {
        input.type = 'password';
        icon.classList.replace('fa-eye-slash', 'fa-eye');
    }
}
</script>

<?php require_once __DIR__ . '/../includes/footer.php'; ?>
