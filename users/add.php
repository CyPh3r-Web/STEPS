<?php
$pageTitle = 'Add User';
require_once __DIR__ . '/../includes/header.php';
requireRole('admin');

$error = '';
$generatedUsername = '';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $fullName = sanitize($_POST['full_name']);
    $email = sanitize($_POST['email']);
    $role = sanitize($_POST['role']);
    $customUsername = sanitize($_POST['custom_username'] ?? '');

    if (empty($fullName) || empty($role)) {
        $error = 'Please fill in all required fields.';
    } elseif (!in_array($role, ['teacher', 'guidance'], true)) {
        $error = 'Only Teacher or Guidance Counselor accounts can be created here.';
    } else {
        // Generate username: role_lastname (lowercase, no spaces)
        $nameParts = explode(' ', trim($fullName));
        $lastName = strtolower(preg_replace('/[^a-zA-Z]/', '', end($nameParts)));

        if (!empty($customUsername)) {
            $username = strtolower(preg_replace('/[^a-zA-Z0-9_]/', '', $customUsername));
        } else {
            $prefix = ($role === 'guidance') ? 'guidance' : 'teacher';
            $username = $prefix . '_' . $lastName;
        }

        // Check for exact duplicate username - prevent creation if exists
        $check = $pdo->prepare("SELECT id FROM users WHERE username = ?");
        $check->execute([$username]);
        if ($check->fetch()) {
            $error = 'A user with this username already exists. Please use a different name or custom username.';
        } else {
            // Check for duplicate with auto-increment
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

            $generatedUsername = $username;
        }
    }
}

require_once __DIR__ . '/../includes/sidebar.php';
?>

<a href="<?= BASE_URL ?>users/index.php" class="inline-flex items-center gap-2 text-sm text-gray-500 hover:text-gray-700 mb-6">
    <i class="fas fa-arrow-left"></i> Back to Users
</a>

<?php if ($error): ?>
<script>
document.addEventListener('DOMContentLoaded', function() {
    Swal.fire({
        ...swalDefaults,
        icon: 'error',
        title: 'Validation Error',
        text: <?= json_encode($error) ?>,
        confirmButtonColor: '#2563eb'
    });
});
</script>
<?php endif; ?>

<?php if ($generatedUsername): ?>
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
              '<p style="font-size:16px; font-weight:600; color:#1e293b; font-family:monospace;"><?= $generatedUsername ?></p>' +
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
    }).then(() => {
        window.location.href = '<?= BASE_URL ?>users/index.php';
    });
});
</script>
<?php endif; ?>

<div class="max-w-xl">
    <div class="bg-white border border-gray-200 rounded-xl p-6">
        <h3 class="text-base font-semibold text-gray-900 mb-2">Add New User</h3>
        <p class="text-sm text-gray-500 mb-6">The username will be auto-generated based on the role and last name. Default password is <span class="font-mono font-semibold text-gray-700">password</span>.</p>

        <div class="bg-blue-50 border border-blue-100 rounded-lg p-4 mb-6">
            <h4 class="text-sm font-semibold text-blue-800 mb-2">Username Format</h4>
            <ul class="text-xs text-blue-700 space-y-1">
                <li><i class="fas fa-check mr-2"></i>Teacher: <span class="font-mono font-semibold">teacher_lastname</span></li>
                <li><i class="fas fa-check mr-2"></i>Guidance: <span class="font-mono font-semibold">guidance_lastname</span></li>
                <li><i class="fas fa-check mr-2"></i>If duplicate, a number is appended automatically (e.g., teacher_santos1)</li>
            </ul>
        </div>

        <form method="POST">
            <div class="space-y-5">
                <div>
                    <label class="form-label">Full Name <span class="text-red-500">*</span></label>
                    <input type="text" name="full_name" class="form-input" required
                           value="<?= sanitize($fullName ?? '') ?>" placeholder="e.g., Maria Santos"
                           id="fullNameInput">
                </div>
                <div>
                    <label class="form-label">Email</label>
                    <input type="email" name="email" class="form-input"
                           value="<?= sanitize($email ?? '') ?>" placeholder="e.g., maria@school.edu">
                </div>
                <div>
                    <label class="form-label">Role <span class="text-red-500">*</span></label>
                    <select name="role" class="form-select" required id="roleSelect">
                        <option value="">Select Role</option>
                        <option value="teacher" <?= ($role ?? '') === 'teacher' ? 'selected' : '' ?>>Teacher</option>
                        <option value="guidance" <?= ($role ?? '') === 'guidance' ? 'selected' : '' ?>>Guidance Counselor</option>
                    </select>
                </div>
                <div>
                    <label class="form-label">Custom Username <span class="text-gray-400 font-normal">(optional, overrides auto-generated)</span></label>
                    <input type="text" name="custom_username" class="form-input"
                           value="<?= sanitize($customUsername ?? '') ?>" placeholder="Leave blank to auto-generate">
                </div>

                <div class="bg-gray-50 border border-gray-200 rounded-lg p-4">
                    <p class="text-xs text-gray-400 mb-1">Preview Username</p>
                    <p class="text-sm font-mono font-semibold text-gray-700" id="usernamePreview">—</p>
                </div>
            </div>

            <div class="flex items-center gap-3 mt-8 pt-6 border-t border-gray-200">
                <button type="submit" class="btn btn-primary"><i class="fas fa-user-plus"></i> Create User</button>
                <a href="<?= BASE_URL ?>users/index.php" class="btn btn-secondary">Cancel</a>
            </div>
        </form>
    </div>
</div>

<script>
const fullNameInput = document.getElementById('fullNameInput');
const roleSelect = document.getElementById('roleSelect');
const preview = document.getElementById('usernamePreview');
const customInput = document.querySelector('input[name="custom_username"]');

function updatePreview() {
    const custom = customInput.value.trim();
    if (custom) {
        preview.textContent = custom.toLowerCase().replace(/[^a-z0-9_]/g, '');
        return;
    }

    const name = fullNameInput.value.trim();
    const role = roleSelect.value;

    if (!name || !role) {
        preview.textContent = '—';
        return;
    }

    const parts = name.split(' ').filter(p => p.length > 0);
    const lastName = parts[parts.length - 1].toLowerCase().replace(/[^a-z]/g, '');
    const prefix = role === 'guidance' ? 'guidance' : 'teacher';
    preview.textContent = prefix + '_' + lastName;
}

fullNameInput.addEventListener('input', updatePreview);
roleSelect.addEventListener('change', updatePreview);
customInput.addEventListener('input', updatePreview);
updatePreview();
</script>

<?php require_once __DIR__ . '/../includes/footer.php'; ?>
