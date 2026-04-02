<?php
$pageTitle = 'User Management';
require_once __DIR__ . '/../includes/header.php';
requireRole('admin');

$success = '';
$error = '';
$openModal = '';
$editId = $_GET['edit_id'] ?? '';

// Handle Add User
if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['action']) && $_POST['action'] === 'add') {
    $fullName = sanitize($_POST['full_name']);
    $email = sanitize($_POST['email']);
    $role = sanitize($_POST['role']);
    $customUsername = sanitize($_POST['custom_username'] ?? '');

    if (empty($fullName) || empty($role)) {
        $error = 'Please fill in all required fields.';
        $openModal = 'add';
    } elseif (!in_array($role, ['teacher', 'guidance'], true)) {
        $error = 'You can only create Teacher or Guidance Counselor accounts.';
        $openModal = 'add';
    } else {
        $nameParts = explode(' ', trim($fullName));
        $lastName = strtolower(preg_replace('/[^a-zA-Z]/', '', end($nameParts)));

        if (!empty($customUsername)) {
            $username = strtolower(preg_replace('/[^a-zA-Z0-9_]/', '', $customUsername));
        } else {
            $prefix = ($role === 'guidance') ? 'guidance' : 'teacher';
            $username = $prefix . '_' . $lastName;
        }

        $baseUsername = $username;
        $counter = 1;
        while (true) {
            $check = $pdo->prepare("SELECT id FROM users WHERE username = ?");
            $check->execute([$username]);
            if (!$check->fetch()) break;
            $username = $baseUsername . $counter;
            $counter++;
        }

        $defaultPassword = password_hash('password', PASSWORD_DEFAULT);
        $stmt = $pdo->prepare("INSERT INTO users (username, password, full_name, email, role) VALUES (?, ?, ?, ?, ?)");
        $stmt->execute([$username, $defaultPassword, $fullName, $email ?: null, $role]);

        $success = 'created';
        $createdUsername = $username;
    }
}

// Handle Edit User
if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['action']) && $_POST['action'] === 'edit') {
    $id = (int)$_POST['user_id'];
    $fullName = sanitize($_POST['full_name']);
    $email = sanitize($_POST['email']);
    $role = sanitize($_POST['role']);
    $usernameEdit = sanitize($_POST['username']);

    if (empty($fullName) || empty($role) || empty($usernameEdit)) {
        $error = 'Please fill in all required fields.';
        $editId = $id;
        $openModal = 'edit';
    } else {
        $check = $pdo->prepare("SELECT id FROM users WHERE username = ? AND id != ?");
        $check->execute([$usernameEdit, $id]);
        if ($check->fetch()) {
            $error = 'This username is already taken.';
            $editId = $id;
            $openModal = 'edit';
        } else {
            $stmt = $pdo->prepare("UPDATE users SET full_name = ?, email = ?, role = ?, username = ? WHERE id = ?");
            $stmt->execute([$fullName, $email ?: null, $role, $usernameEdit, $id]);
            header('Location: ' . BASE_URL . 'users/index.php?msg=updated');
            exit;
        }
    }
}

// Handle Status Toggle
if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['toggle_id'])) {
    $toggleId = (int)$_POST['toggle_id'];
    if ($toggleId !== (int)$_SESSION['user_id']) {
        $stmt = $pdo->prepare("UPDATE users SET status = IF(status='active','inactive','active') WHERE id = ?");
        $stmt->execute([$toggleId]);
        header('Location: ' . BASE_URL . 'users/index.php?msg=status');
        exit;
    } else {
        $error = 'You cannot deactivate your own account.';
    }
}

// Handle Password Reset
if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['reset_id'])) {
    $resetId = (int)$_POST['reset_id'];
    $defaultPass = password_hash('password', PASSWORD_DEFAULT);
    $stmt = $pdo->prepare("UPDATE users SET password = ? WHERE id = ?");
    $stmt->execute([$defaultPass, $resetId]);
    header('Location: ' . BASE_URL . 'users/index.php?msg=reset');
    exit;
}

// Load edit data
$editUser = null;
if ($editId) {
    $stmt = $pdo->prepare("SELECT * FROM users WHERE id = ?");
    $stmt->execute([$editId]);
    $editUser = $stmt->fetch();
    if ($editUser && !$openModal) $openModal = 'edit';
}

$roleFilter = $_GET['role'] ?? '';

$query = "SELECT * FROM users WHERE 1=1";
$params = [];
if ($roleFilter) { $query .= " AND role = ?"; $params[] = $roleFilter; }
$query .= " ORDER BY role, full_name";
$stmt = $pdo->prepare($query);
$stmt->execute($params);
$users = $stmt->fetchAll();

$totalTeachers = $pdo->query("SELECT COUNT(*) as cnt FROM users WHERE role='teacher'")->fetch()['cnt'];
$totalGuidance = $pdo->query("SELECT COUNT(*) as cnt FROM users WHERE role='guidance'")->fetch()['cnt'];
$totalAdmin = $pdo->query("SELECT COUNT(*) as cnt FROM users WHERE role='admin'")->fetch()['cnt'];

require_once __DIR__ . '/../includes/sidebar.php';
?>

<?php if (isset($_GET['msg'])): ?>
<script>
document.addEventListener('DOMContentLoaded', function() {
    <?php
    $msgs = ['updated' => 'User updated successfully.', 'status' => 'User status updated.', 'reset' => 'Password has been reset to default (password).'];
    $msgText = $msgs[$_GET['msg']] ?? 'Action completed.';
    ?>
    Toast.fire({ icon: 'success', title: <?= json_encode($msgText) ?> });
});
</script>
<?php endif; ?>

<?php if ($success === 'created'): ?>
<script>
document.addEventListener('DOMContentLoaded', function() {
    Swal.fire({
        ...swalDefaults,
        icon: 'success',
        title: 'User Created Successfully',
        html: '<div style="text-align:left; font-family:Poppins,sans-serif;">' +
              '<p style="margin-bottom:12px; color:#64748b; font-size:14px;">The account has been created with the following credentials:</p>' +
              '<div style="background:#f8fafc; border:1px solid #e2e8f0; border-radius:8px; padding:16px; margin-bottom:8px;">' +
              '<p style="font-size:13px; color:#64748b; margin-bottom:4px;">Username</p>' +
              '<p style="font-size:16px; font-weight:600; color:#1e293b; font-family:monospace;"><?= $createdUsername ?? '' ?></p>' +
              '</div>' +
              '<div style="background:#f8fafc; border:1px solid #e2e8f0; border-radius:8px; padding:16px;">' +
              '<p style="font-size:13px; color:#64748b; margin-bottom:4px;">Default Password</p>' +
              '<p style="font-size:16px; font-weight:600; color:#1e293b; font-family:monospace;">password</p>' +
              '</div>' +
              '<p style="margin-top:12px; color:#94a3b8; font-size:12px;"><i class="fas fa-info-circle"></i> The user should change their password after first login.</p>' +
              '</div>',
        confirmButtonColor: '#2563eb',
        confirmButtonText: 'Done',
        width: 420
    });
});
</script>
<?php elseif ($error): ?>
<script>
document.addEventListener('DOMContentLoaded', function() {
    Swal.fire({ ...swalDefaults, icon: 'error', title: 'Error', text: <?= json_encode($error) ?>, confirmButtonColor: '#2563eb' });
});
</script>
<?php endif; ?>

<!-- Summary -->
<div class="grid grid-cols-1 md:grid-cols-3 gap-5 mb-6">
    <div class="stat-card" style="background:#eff6ff;">
        <div class="flex items-center justify-between mb-2">
            <span class="text-sm font-medium text-gray-600">Teachers</span>
            <div class="w-10 h-10 rounded-lg flex items-center justify-center" style="background:#dbeafe;">
                <i class="fas fa-chalkboard-teacher" style="color:#1d4ed8;"></i>
            </div>
        </div>
        <p class="text-3xl font-bold text-gray-800"><?= $totalTeachers ?></p>
    </div>
    <div class="stat-card" style="background:#f0fdf4;">
        <div class="flex items-center justify-between mb-2">
            <span class="text-sm font-medium text-gray-600">Guidance Counselors</span>
            <div class="w-10 h-10 rounded-lg flex items-center justify-center" style="background:#dcfce7;">
                <i class="fas fa-hands-helping" style="color:#166534;"></i>
            </div>
        </div>
        <p class="text-3xl font-bold text-gray-800"><?= $totalGuidance ?></p>
    </div>
    <div class="stat-card" style="background:#fffbeb;">
        <div class="flex items-center justify-between mb-2">
            <span class="text-sm font-medium text-gray-600">Administrators</span>
            <div class="w-10 h-10 rounded-lg flex items-center justify-center" style="background:#fef3c7;">
                <i class="fas fa-user-shield" style="color:#92400e;"></i>
            </div>
        </div>
        <p class="text-3xl font-bold text-gray-800"><?= $totalAdmin ?></p>
    </div>
</div>

<!-- Filters & Actions -->
<div class="flex flex-wrap items-center justify-between gap-4 mb-6">
    <form method="GET" class="flex items-center gap-3">
        <select name="role" class="form-select w-48" onchange="this.form.submit()">
            <option value="">All Roles</option>
            <option value="admin" <?= $roleFilter === 'admin' ? 'selected' : '' ?>>Admin</option>
            <option value="teacher" <?= $roleFilter === 'teacher' ? 'selected' : '' ?>>Teacher</option>
            <option value="guidance" <?= $roleFilter === 'guidance' ? 'selected' : '' ?>>Guidance</option>
        </select>
    </form>
    <button onclick="openModal('addUserModal')" class="btn btn-primary btn-sm">
        <i class="fas fa-plus"></i> Add User
    </button>
</div>

<!-- Users Table -->
<div class="bg-white border border-gray-200 rounded-xl overflow-hidden">
    <div class="overflow-x-auto">
        <table class="steps-table" id="usersTable">
            <thead>
                <tr><th>Full Name</th><th>Username</th><th>Email</th><th>Role</th><th>Status</th><th>Created</th><th>Actions</th></tr>
            </thead>
            <tbody>
                <?php foreach ($users as $u): ?>
                    <?php $roleBadge = ['admin' => 'badge-amber', 'teacher' => 'badge-blue', 'guidance' => 'badge-green']; ?>
                    <tr>
                        <td class="font-medium"><?= sanitize($u['full_name']) ?></td>
                        <td class="text-sm font-mono"><?= sanitize($u['username']) ?></td>
                        <td class="text-sm"><?= sanitize($u['email'] ?? '-') ?></td>
                        <td><span class="badge <?= $roleBadge[$u['role']] ?? 'badge-blue' ?> capitalize"><?= $u['role'] ?></span></td>
                        <td>
                            <?php if ($u['status'] === 'active'): ?>
                                <span class="badge badge-green">Active</span>
                            <?php else: ?>
                                <span class="badge badge-red">Inactive</span>
                            <?php endif; ?>
                        </td>
                        <td class="text-sm text-gray-500"><?= date('M d, Y', strtotime($u['created_at'])) ?></td>
                        <td>
                            <div class="flex items-center gap-2">
                                <button onclick="loadEditUser(<?= $u['id'] ?>)" class="text-gray-500 hover:text-gray-700" title="Edit"><i class="fas fa-edit"></i></button>
                                <form method="POST" class="inline">
                                    <input type="hidden" name="reset_id" value="<?= $u['id'] ?>">
                                    <button type="button" class="text-amber-500 hover:text-amber-700" title="Reset Password"
                                            onclick="confirmSubmit(this.closest('form'), 'Reset Password?', 'The password for <?= sanitize($u['full_name']) ?> will be reset to the default (password).', 'Yes, reset')">
                                        <i class="fas fa-key"></i>
                                    </button>
                                </form>
                                <?php if ((int)$u['id'] !== (int)$_SESSION['user_id']): ?>
                                <form method="POST" class="inline">
                                    <input type="hidden" name="toggle_id" value="<?= $u['id'] ?>">
                                    <button type="button" class="<?= $u['status'] === 'active' ? 'text-red-500 hover:text-red-700' : 'text-emerald-500 hover:text-emerald-700' ?>"
                                            title="<?= $u['status'] === 'active' ? 'Deactivate' : 'Activate' ?>"
                                            onclick="confirmSubmit(this.closest('form'), '<?= $u['status'] === 'active' ? 'Deactivate' : 'Activate' ?> User?', '<?= $u['status'] === 'active' ? 'This user will no longer be able to log in.' : 'This user will be able to log in again.' ?>', 'Yes, proceed')">
                                        <i class="fas fa-<?= $u['status'] === 'active' ? 'ban' : 'check-circle' ?>"></i>
                                    </button>
                                </form>
                                <?php endif; ?>
                            </div>
                        </td>
                    </tr>
                <?php endforeach; ?>
                <?php if (empty($users)): ?>
                    <tr><td colspan="7" class="text-center text-gray-400 py-8">No users found.</td></tr>
                <?php endif; ?>
            </tbody>
        </table>
    </div>
</div>

<!-- ADD USER MODAL -->
<div class="modal-overlay" id="addUserModal">
    <div class="modal-content" style="max-width:520px;">
        <div class="flex items-center justify-between mb-6">
            <div class="flex items-center gap-3">
                <div class="w-10 h-10 bg-blue-50 rounded-lg flex items-center justify-center modal-icon"><i class="fas fa-user-plus text-blue-600"></i></div>
                <div>
                    <h3 class="text-base font-semibold text-gray-900">Add New User</h3>
                    <p class="text-xs text-gray-500">Default password: <span class="font-mono font-semibold">password</span></p>
                </div>
            </div>
            <button onclick="closeModal('addUserModal')" class="modal-close"><i class="fas fa-times"></i></button>
        </div>
        <form method="POST">
            <input type="hidden" name="action" value="add">
            <div class="space-y-4">
                <div>
                    <label class="form-label">Full Name <span class="text-red-500">*</span></label>
                    <input type="text" name="full_name" class="form-input" required placeholder="e.g., Maria Santos" id="addFullName">
                </div>
                <div>
                    <label class="form-label">Email</label>
                    <input type="email" name="email" class="form-input" placeholder="e.g., maria@school.edu">
                </div>
                <div>
                    <label class="form-label">Role <span class="text-red-500">*</span></label>
                    <select name="role" class="form-select" required id="addRole">
                        <option value="">Select Role</option>
                        <option value="teacher">Teacher</option>
                        <option value="guidance">Guidance Counselor</option>
                    </select>
                </div>
                <div>
                    <label class="form-label">Custom Username <span class="text-gray-400 font-normal">(optional)</span></label>
                    <input type="text" name="custom_username" class="form-input" placeholder="Leave blank to auto-generate" id="addCustomUsername">
                </div>
                <div class="bg-gray-50 border border-gray-200 rounded-lg p-3">
                    <p class="text-xs text-gray-400 mb-1">Username Preview</p>
                    <p class="text-sm font-mono font-semibold text-gray-700" id="addUsernamePreview">—</p>
                </div>
            </div>
            <div class="flex items-center justify-end gap-4 mt-6 pt-5 border-t border-gray-200">
                <button type="button" onclick="closeModal('addUserModal')" class="btn btn-secondary">Cancel</button>
                <button type="submit" class="btn btn-primary"><i class="fas fa-user-plus"></i> Create User</button>
            </div>
        </form>
    </div>
</div>

<!-- EDIT USER MODAL -->
<div class="modal-overlay" id="editUserModal">
    <div class="modal-content" style="max-width:520px;">
        <div class="flex items-center justify-between mb-6">
            <div class="flex items-center gap-3">
                <div class="w-10 h-10 bg-amber-50 rounded-lg flex items-center justify-center modal-icon"><i class="fas fa-edit text-amber-600"></i></div>
                <h3 class="text-base font-semibold text-gray-900">Edit User</h3>
            </div>
            <button onclick="closeModal('editUserModal')" class="modal-close"><i class="fas fa-times"></i></button>
        </div>
        <form method="POST" id="editUserForm">
            <input type="hidden" name="action" value="edit">
            <input type="hidden" name="user_id" id="edit_user_id" value="<?= $editUser['id'] ?? '' ?>">
            <div class="space-y-4">
                <div>
                    <label class="form-label">Username <span class="text-red-500">*</span></label>
                    <input type="text" name="username" id="edit_username" class="form-input font-mono" required value="<?= sanitize($editUser['username'] ?? '') ?>">
                </div>
                <div>
                    <label class="form-label">Full Name <span class="text-red-500">*</span></label>
                    <input type="text" name="full_name" id="edit_full_name" class="form-input" required value="<?= sanitize($editUser['full_name'] ?? '') ?>">
                </div>
                <div>
                    <label class="form-label">Email</label>
                    <input type="email" name="email" id="edit_email" class="form-input" value="<?= sanitize($editUser['email'] ?? '') ?>">
                </div>
                <div>
                    <label class="form-label">Role <span class="text-red-500">*</span></label>
                    <select name="role" id="edit_role" class="form-select" required>
                        <option value="teacher" <?= ($editUser['role'] ?? '') === 'teacher' ? 'selected' : '' ?>>Teacher</option>
                        <option value="guidance" <?= ($editUser['role'] ?? '') === 'guidance' ? 'selected' : '' ?>>Guidance Counselor</option>
                        <option value="admin" <?= ($editUser['role'] ?? '') === 'admin' ? 'selected' : '' ?>>Administrator</option>
                    </select>
                </div>
            </div>
            <div class="flex items-center justify-end gap-4 mt-6 pt-5 border-t border-gray-200">
                <button type="button" onclick="closeModal('editUserModal')" class="btn btn-secondary">Cancel</button>
                <button type="submit" class="btn btn-primary"><i class="fas fa-save"></i> Update User</button>
            </div>
        </form>
    </div>
</div>

<script>
<?php
$userDataMap = [];
foreach ($users as $u) {
    $userDataMap[$u['id']] = [
        'id' => $u['id'], 'username' => $u['username'],
        'full_name' => $u['full_name'], 'email' => $u['email'] ?? '',
        'role' => $u['role']
    ];
}
?>
const userData = <?= json_encode($userDataMap) ?>;

function loadEditUser(id) {
    const u = userData[id];
    if (!u) return;
    document.getElementById('edit_user_id').value = u.id;
    document.getElementById('edit_username').value = u.username;
    document.getElementById('edit_full_name').value = u.full_name;
    document.getElementById('edit_email').value = u.email;
    document.getElementById('edit_role').value = u.role;
    openModal('editUserModal');
}

// Username preview for Add modal
const addFullName = document.getElementById('addFullName');
const addRole = document.getElementById('addRole');
const addCustom = document.getElementById('addCustomUsername');
const addPreview = document.getElementById('addUsernamePreview');

function updateAddPreview() {
    const custom = addCustom.value.trim();
    if (custom) { addPreview.textContent = custom.toLowerCase().replace(/[^a-z0-9_]/g, ''); return; }
    const name = addFullName.value.trim();
    const role = addRole.value;
    if (!name || !role) { addPreview.textContent = '—'; return; }
    const parts = name.split(' ').filter(p => p.length > 0);
    const lastName = parts[parts.length - 1].toLowerCase().replace(/[^a-z]/g, '');
    const prefix = role === 'guidance' ? 'guidance' : 'teacher';
    addPreview.textContent = prefix + '_' + lastName;
}
addFullName.addEventListener('input', updateAddPreview);
addRole.addEventListener('change', updateAddPreview);
addCustom.addEventListener('input', updateAddPreview);

<?php if ($openModal === 'add'): ?>
document.addEventListener('DOMContentLoaded', function() { openModal('addUserModal'); });
<?php elseif ($openModal === 'edit'): ?>
document.addEventListener('DOMContentLoaded', function() { openModal('editUserModal'); });
<?php endif; ?>
</script>

<?php require_once __DIR__ . '/../includes/footer.php'; ?>
