<?php
$pageTitle = 'Edit User';
require_once __DIR__ . '/../includes/header.php';
requireRole('admin');

$id = $_GET['id'] ?? 0;
$stmt = $pdo->prepare("SELECT * FROM users WHERE id = ?");
$stmt->execute([$id]);
$user = $stmt->fetch();

if (!$user) {
    header('Location: ' . BASE_URL . 'users/index.php');
    exit;
}

$error = '';
$success = '';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $fullName = sanitize($_POST['full_name']);
    $email = sanitize($_POST['email']);
    $role = sanitize($_POST['role']);
    $username = sanitize($_POST['username']);

    if (empty($fullName) || empty($role) || empty($username)) {
        $error = 'Please fill in all required fields.';
    } else {
        $check = $pdo->prepare("SELECT id FROM users WHERE username = ? AND id != ?");
        $check->execute([$username, $id]);
        if ($check->fetch()) {
            $error = 'This username is already taken.';
        } else {
            $stmt = $pdo->prepare("UPDATE users SET full_name = ?, email = ?, role = ?, username = ? WHERE id = ?");
            $stmt->execute([$fullName, $email ?: null, $role, $username, $id]);
            $success = 'User updated successfully.';

            $stmt = $pdo->prepare("SELECT * FROM users WHERE id = ?");
            $stmt->execute([$id]);
            $user = $stmt->fetch();
        }
    }
} else {
    $fullName = $user['full_name'];
    $email = $user['email'];
    $role = $user['role'];
    $username = $user['username'];
}

require_once __DIR__ . '/../includes/sidebar.php';
?>

<a href="<?= BASE_URL ?>users/index.php" class="inline-flex items-center gap-2 text-sm text-gray-500 hover:text-gray-700 mb-6">
    <i class="fas fa-arrow-left"></i> Back to Users
</a>

<?php if ($success): ?>
<script>
document.addEventListener('DOMContentLoaded', function() {
    Toast.fire({ icon: 'success', title: <?= json_encode($success) ?> });
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

<div class="max-w-xl">
    <div class="bg-white border border-gray-200 rounded-xl p-6">
        <h3 class="text-base font-semibold text-gray-900 mb-6">Edit User Information</h3>

        <form method="POST">
            <div class="space-y-5">
                <div>
                    <label class="form-label">Username <span class="text-red-500">*</span></label>
                    <input type="text" name="username" class="form-input font-mono" required value="<?= sanitize($username) ?>">
                </div>
                <div>
                    <label class="form-label">Full Name <span class="text-red-500">*</span></label>
                    <input type="text" name="full_name" class="form-input" required value="<?= sanitize($fullName) ?>">
                </div>
                <div>
                    <label class="form-label">Email</label>
                    <input type="email" name="email" class="form-input" value="<?= sanitize($email) ?>">
                </div>
                <div>
                    <label class="form-label">Role <span class="text-red-500">*</span></label>
                    <select name="role" class="form-select" required>
                        <option value="teacher" <?= $role === 'teacher' ? 'selected' : '' ?>>Teacher</option>
                        <option value="guidance" <?= $role === 'guidance' ? 'selected' : '' ?>>Guidance Counselor</option>
                        <option value="admin" <?= $role === 'admin' ? 'selected' : '' ?>>Administrator</option>
                    </select>
                </div>
            </div>

            <div class="flex items-center gap-3 mt-8 pt-6 border-t border-gray-200">
                <button type="submit" class="btn btn-primary"><i class="fas fa-save"></i> Update User</button>
                <a href="<?= BASE_URL ?>users/index.php" class="btn btn-secondary">Cancel</a>
            </div>
        </form>
    </div>
</div>

<?php require_once __DIR__ . '/../includes/footer.php'; ?>
