<?php
$role = $_SESSION['role'] ?? 'teacher';
$fullName = $_SESSION['full_name'] ?? 'User';
$initials = '';
$nameParts = explode(' ', $fullName);
foreach ($nameParts as $part) {
    $initials .= strtoupper(substr($part, 0, 1));
}

// Handle Change Password POST
$pwdSuccess = '';
$pwdError = '';
if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['action']) && $_POST['action'] === 'change_password') {
    $currentPassword = $_POST['current_password'] ?? '';
    $newPassword = $_POST['new_password'] ?? '';
    $confirmPassword = $_POST['confirm_password'] ?? '';

    if (empty($currentPassword) || empty($newPassword) || empty($confirmPassword)) {
        $pwdError = 'Please fill in all fields.';
    } elseif (strlen($newPassword) < 6) {
        $pwdError = 'New password must be at least 6 characters.';
    } elseif ($newPassword !== $confirmPassword) {
        $pwdError = 'New password and confirmation do not match.';
    } else {
        $stmt = $pdo->prepare("SELECT password FROM users WHERE id = ?");
        $stmt->execute([$_SESSION['user_id']]);
        $pwUser = $stmt->fetch();

        if (!password_verify($currentPassword, $pwUser['password'])) {
            $pwdError = 'Current password is incorrect.';
        } else {
            $hashedPassword = password_hash($newPassword, PASSWORD_DEFAULT);
            $updateStmt = $pdo->prepare("UPDATE users SET password = ? WHERE id = ?");
            $updateStmt->execute([$hashedPassword, $_SESSION['user_id']]);

            $logStmt = $pdo->prepare("INSERT INTO activity_logs (user_id, action, description, ip_address) VALUES (?, 'password_change', 'User changed password', ?)");
            $logStmt->execute([$_SESSION['user_id'], $_SERVER['REMOTE_ADDR']]);

            $pwdSuccess = 'Your password has been changed successfully.';
        }
    }
}

function sidebarLinkClass($active) {
    return $active ? 'sidebar-link-active' : 'text-gray-600 hover:bg-gray-100 hover:text-gray-900';
}
?>
<aside id="sidebar" class="sidebar-aside w-64 bg-white border-r border-gray-200 min-h-screen flex flex-col fixed left-0 top-0 z-30 transition-all duration-300 lg:translate-x-0 -translate-x-full">
    <div class="sidebar-header flex-shrink-0 flex items-center justify-between gap-2 p-4 border-b border-gray-200">
        <div class="flex items-center gap-3 min-w-0 flex-1">
            <div class="w-10 h-10 flex-shrink-0 sidebar-logo flex items-center justify-center">
                <img src="<?= BASE_URL ?>assets/img/seait.png" alt="<?= htmlspecialchars(SITE_FULL_NAME, ENT_QUOTES, 'UTF-8') ?> logo" class="sidebar-logo-img w-full h-full object-contain">
            </div>
            <div class="sidebar-brand min-w-0 overflow-hidden transition-all duration-300">
                <h1 class="font-bold text-lg text-gray-900 tracking-tight truncate"><?= SITE_NAME ?></h1>
            </div>
        </div>
        <button type="button" onclick="toggleSidebarCollapse()" class="sidebar-collapse-btn flex-shrink-0 w-8 h-8 rounded-lg flex items-center justify-center text-gray-500 hover:bg-gray-100 hover:text-gray-700 transition-colors hidden lg:flex" title="Collapse sidebar">
            <i class="fas fa-chevron-left text-sm transition-transform duration-300"></i>
        </button>
    </div>

    <nav class="sidebar-nav flex-1 min-h-0 p-4 space-y-1 overflow-y-auto overscroll-contain">
        <p class="sidebar-label text-xs font-semibold text-gray-400 uppercase tracking-wider mb-3 px-3">Main Menu</p>

        <a href="<?= BASE_URL ?>dashboard/index.php"
           class="sidebar-link flex items-center gap-3 px-3 py-2.5 rounded-lg text-sm font-medium transition-colors <?= sidebarLinkClass($currentDir === 'dashboard') ?>" title="Dashboard">
            <i class="fas fa-th-large w-5 flex-shrink-0 text-center"></i><span class="sidebar-link-text">Dashboard</span>
        </a>
        <a href="<?= BASE_URL ?>students/index.php"
           class="sidebar-link flex items-center gap-3 px-3 py-2.5 rounded-lg text-sm font-medium transition-colors <?= sidebarLinkClass($currentDir === 'students' && $currentPage !== 'grades') ?>" title="Students">
            <i class="fas fa-user-graduate w-5 flex-shrink-0 text-center"></i><span class="sidebar-link-text">Students</span>
        </a>
        <?php if ($role === 'admin' || $role === 'teacher'): ?>
        <a href="<?= BASE_URL ?>sections/index.php"
           class="sidebar-link flex items-center gap-3 px-3 py-2.5 rounded-lg text-sm font-medium transition-colors <?= sidebarLinkClass($currentDir === 'sections') ?>" title="Sections">
            <i class="fas fa-layer-group w-5 flex-shrink-0 text-center"></i><span class="sidebar-link-text">Sections</span>
        </a>
        <a href="<?= BASE_URL ?>subjects/index.php"
           class="sidebar-link flex items-center gap-3 px-3 py-2.5 rounded-lg text-sm font-medium transition-colors <?= sidebarLinkClass($currentDir === 'subjects') ?>" title="Subjects">
            <i class="fas fa-book w-5 flex-shrink-0 text-center"></i><span class="sidebar-link-text">Subjects</span>
        </a>
        <a href="<?= BASE_URL ?>students/grades.php"
           class="sidebar-link flex items-center gap-3 px-3 py-2.5 rounded-lg text-sm font-medium transition-colors <?= sidebarLinkClass($currentPage === 'grades') ?>" title="Grades">
            <i class="fas fa-clipboard-list w-5 flex-shrink-0 text-center"></i><span class="sidebar-link-text">Grades</span>
        </a>
        <!-- Work Immersion module removed -->
        <?php endif; ?>
        <?php if ($role === 'guidance'): ?>
        <!-- Work Immersion module removed -->
        <?php endif; ?>

        <p class="sidebar-label text-xs font-semibold text-gray-400 uppercase tracking-wider mt-6 mb-3 px-3">Analysis</p>

        <?php if ($role === 'admin' || $role === 'teacher'): ?>
        <a href="<?= BASE_URL ?>competency/index.php"
           class="sidebar-link flex items-center gap-3 px-3 py-2.5 rounded-lg text-sm font-medium transition-colors <?= sidebarLinkClass($currentDir === 'competency') ?>" title="Competency">
            <i class="fas fa-chart-bar w-5 flex-shrink-0 text-center"></i><span class="sidebar-link-text">Competency</span>
        </a>
        <?php endif; ?>
        <?php if ($role === 'admin' || $role === 'guidance'): ?>
        <div class="sidebar-group">
            <button type="button" onclick="toggleSidebarGroup('careerGroup')"
                class="sidebar-link w-full flex items-center gap-3 px-3 py-2.5 rounded-lg text-sm font-medium transition-colors <?= sidebarLinkClass($currentDir === 'career') ?>"
                title="Career Pathway">
                <i class="fas fa-route w-5 flex-shrink-0 text-center"></i>
                <span class="sidebar-link-text flex-1 text-left">Career Pathway</span>
                <i class="fas fa-chevron-down sidebar-link-text text-xs transition-transform duration-200" id="careerGroupChevron"></i>
            </button>
            <div id="careerGroup" class="pl-8 mt-1 space-y-0.5 <?= $currentDir === 'career' ? '' : 'hidden' ?>">
                <a href="<?= BASE_URL ?>career/strand.php"
                   class="sidebar-link flex items-center gap-2 px-3 py-2 rounded-lg text-sm font-medium transition-colors <?= sidebarLinkClass($currentPage === 'strand') ?>" title="Strand Recommendation">
                    <i class="fas fa-graduation-cap w-4 flex-shrink-0 text-center text-xs"></i>
                    <span class="sidebar-link-text">Strand Recommendation</span>
                </a>
                <a href="<?= BASE_URL ?>career/course.php"
                   class="sidebar-link flex items-center gap-2 px-3 py-2 rounded-lg text-sm font-medium transition-colors <?= sidebarLinkClass($currentPage === 'course') ?>" title="Course Recommendation">
                    <i class="fas fa-university w-4 flex-shrink-0 text-center text-xs"></i>
                    <span class="sidebar-link-text">Course Recommendation</span>
                </a>
            </div>
        </div>
        <?php endif; ?>

        <p class="sidebar-label text-xs font-semibold text-gray-400 uppercase tracking-wider mt-6 mb-3 px-3">Reports</p>

        <a href="<?= BASE_URL ?>reports/index.php"
           class="sidebar-link flex items-center gap-3 px-3 py-2.5 rounded-lg text-sm font-medium transition-colors <?= sidebarLinkClass($currentDir === 'reports' && $currentPage === 'index') ?>" title="Diagnostic Reports">
            <i class="fas fa-file-alt w-5 flex-shrink-0 text-center"></i><span class="sidebar-link-text">Diagnostic Reports</span>
        </a>
        <?php if ($role === 'admin' || $role === 'teacher'): ?>
        <a href="<?= BASE_URL ?>reports/class_performance.php"
           class="sidebar-link flex items-center gap-3 px-3 py-2.5 rounded-lg text-sm font-medium transition-colors <?= sidebarLinkClass($currentPage === 'class_performance') ?>" title="Class Performance">
            <i class="fas fa-chart-line w-5 flex-shrink-0 text-center"></i><span class="sidebar-link-text">Class Performance</span>
        </a>
        <?php endif; ?>

        <?php if ($role === 'admin'): ?>
        <p class="sidebar-label text-xs font-semibold text-gray-400 uppercase tracking-wider mt-6 mb-3 px-3">System</p>

        <a href="<?= BASE_URL ?>users/index.php"
           class="sidebar-link flex items-center gap-3 px-3 py-2.5 rounded-lg text-sm font-medium transition-colors <?= sidebarLinkClass($currentDir === 'users') ?>" title="User Management">
            <i class="fas fa-users-cog w-5 flex-shrink-0 text-center"></i><span class="sidebar-link-text">User Management</span>
        </a>
        <a href="<?= BASE_URL ?>backup/index.php"
           class="sidebar-link flex items-center gap-3 px-3 py-2.5 rounded-lg text-sm font-medium transition-colors <?= sidebarLinkClass($currentDir === 'backup') ?>" title="Backup & Recovery">
            <i class="fas fa-database w-5 flex-shrink-0 text-center"></i><span class="sidebar-link-text">Backup & Recovery</span>
        </a>
        <?php endif; ?>
    </nav>

    <div class="sidebar-footer flex-shrink-0 p-4 border-t border-gray-200 mt-auto">
        <div class="flex items-center gap-3 mb-3">
            <div class="w-9 h-9 flex-shrink-0 bg-gray-200 rounded-full flex items-center justify-center">
                <span class="text-gray-600 text-xs font-semibold"><?= $initials ?></span>
            </div>
            <div class="sidebar-user-info flex-1 min-w-0 overflow-hidden transition-opacity duration-300">
                <p class="text-sm font-medium text-gray-900 truncate"><?= sanitize($fullName) ?></p>
                <p class="text-xs text-gray-500 capitalize"><?= $role ?></p>
            </div>
        </div>
        <a href="<?= BASE_URL ?>auth/logout.php"
           class="sidebar-link flex items-center gap-2 px-3 py-2 rounded-lg text-sm text-red-600 hover:bg-red-50 transition-colors font-medium" title="Sign Out">
            <i class="fas fa-sign-out-alt w-5 flex-shrink-0 text-center"></i><span class="sidebar-link-text">Sign Out</span>
        </a>
    </div>
</aside>

<div id="sidebar-overlay" class="fixed inset-0 bg-black/30 z-20 hidden lg:hidden" onclick="toggleSidebar()"></div>

<div id="main-wrapper" class="main-content-area flex-1 min-h-screen flex flex-col transition-[margin] duration-300">
    <header class="bg-white border-b border-gray-200 sticky top-0 z-10">
        <div class="flex items-center justify-between px-6 py-4">
            <div class="flex items-center gap-4">
                <button onclick="toggleSidebar()" class="lg:hidden text-gray-500 hover:text-gray-700" title="Menu">
                    <i class="fas fa-bars text-lg"></i>
                </button>
                <button id="expand-sidebar-btn" onclick="toggleSidebarCollapse()" class="expand-sidebar-btn hidden items-center justify-center w-9 h-9 rounded-lg text-gray-500 hover:bg-gray-100 hover:text-gray-700 transition-colors" title="Expand sidebar">
                    <i class="fas fa-bars text-lg"></i>
                </button>
                <div>
                    <h2 class="text-lg font-semibold text-gray-900"><?= $pageTitle ?? 'Dashboard' ?></h2>
                    <p class="text-xs text-gray-500">S.Y. <?= SCHOOL_YEAR ?></p>
                </div>
            </div>
            <div class="flex items-center gap-2">
                <span class="text-xs text-gray-400 hidden sm:inline mr-2"><?= date('F d, Y') ?></span>

                <!-- Light/Dark Mode Toggle -->
                <button type="button" id="modeToggle" onclick="toggleMode()" class="mode-toggle-btn w-9 h-9 rounded-lg flex items-center justify-center transition-colors" title="Toggle dark mode">
                    <i class="fas fa-moon text-gray-500 hover:text-gray-700" id="modeIcon"></i>
                </button>
                <!-- Theme Picker -->
                <div class="theme-picker">
                    <button class="theme-picker-btn" onclick="toggleThemeDropdown()" title="Change Theme">
                        <div class="swatch-dot"></div>
                    </button>
                    <div class="theme-dropdown" id="themeDropdown">
                        <p class="theme-dropdown-title">Theme Color</p>
                        <div class="theme-grid">
                            <div>
                                <button class="theme-swatch" data-theme="blue" style="background:#2563eb;" onclick="setTheme('blue')" title="Blue"></button>
                                <p class="theme-swatch-label">Blue</p>
                            </div>
                            <div>
                                <button class="theme-swatch" data-theme="indigo" style="background:#4f46e5;" onclick="setTheme('indigo')" title="Indigo"></button>
                                <p class="theme-swatch-label">Indigo</p>
                            </div>
                            <div>
                                <button class="theme-swatch" data-theme="violet" style="background:#7c3aed;" onclick="setTheme('violet')" title="Violet"></button>
                                <p class="theme-swatch-label">Violet</p>
                            </div>
                            <div>
                                <button class="theme-swatch" data-theme="emerald" style="background:#059669;" onclick="setTheme('emerald')" title="Emerald"></button>
                                <p class="theme-swatch-label">Emerald</p>
                            </div>
                            <div>
                                <button class="theme-swatch" data-theme="teal" style="background:#0d9488;" onclick="setTheme('teal')" title="Teal"></button>
                                <p class="theme-swatch-label">Teal</p>
                            </div>
                            <div>
                                <button class="theme-swatch" data-theme="rose" style="background:#e11d48;" onclick="setTheme('rose')" title="Rose"></button>
                                <p class="theme-swatch-label">Rose</p>
                            </div>
                            <div>
                                <button class="theme-swatch" data-theme="amber" style="background:#d97706;" onclick="setTheme('amber')" title="Amber"></button>
                                <p class="theme-swatch-label">Amber</p>
                            </div>
                            <div>
                                <button class="theme-swatch" data-theme="slate" style="background:#475569;" onclick="setTheme('slate')" title="Slate"></button>
                                <p class="theme-swatch-label">Slate</p>
                            </div>
                        </div>
                    </div>
                </div>

                <a href="<?= BASE_URL ?>auth/logout.php"
                   class="hidden sm:inline-flex items-center gap-1 px-3 py-1.5 rounded-lg text-xs font-medium text-red-600 border border-red-100 hover:bg-red-50 hover:border-red-200 transition-colors"
                   title="Logout">
                    <i class="fas fa-sign-out-alt"></i><span>Logout</span>
                </a>

                <button onclick="openModal('changePasswordModal')" class="w-9 h-9 rounded-lg bg-gray-100 hover:bg-gray-200 flex items-center justify-center transition-colors" title="Change Password">
                    <i class="fas fa-lock text-gray-500 text-sm"></i>
                </button>
                <div class="w-9 h-9 navbar-avatar rounded-lg flex items-center justify-center">
                    <span class="text-white text-xs font-semibold"><?= $initials ?></span>
                </div>
            </div>
        </div>
    </header>

    <main class="p-6 flex-1">

<!-- CHANGE PASSWORD MODAL -->
<div class="modal-overlay" id="changePasswordModal">
    <div class="modal-content" style="max-width:420px;">
        <div class="flex items-center justify-between mb-6">
            <div class="flex items-center gap-3">
                <div class="w-10 h-10 bg-blue-50 rounded-lg flex items-center justify-center modal-icon">
                    <i class="fas fa-lock text-blue-600"></i>
                </div>
                <div>
                    <h3 class="text-base font-semibold text-gray-900">Change Password</h3>
                    <p class="text-xs text-gray-500">Update your account password</p>
                </div>
            </div>
            <button onclick="closeModal('changePasswordModal')" class="modal-close"><i class="fas fa-times"></i></button>
        </div>
        <form method="POST" id="changePwdForm">
            <input type="hidden" name="action" value="change_password">
            <div class="space-y-4">
                <div>
                    <label class="form-label">Current Password <span class="text-red-500">*</span></label>
                    <div class="relative">
                        <input type="password" name="current_password" class="form-input pr-10" required placeholder="Enter current password" id="cpCurrentPwd">
                        <button type="button" onclick="togglePwdField('cpCurrentPwd','cpIcon1')" class="absolute right-3 top-1/2 -translate-y-1/2 text-gray-400 hover:text-gray-600">
                            <i class="fas fa-eye" id="cpIcon1"></i>
                        </button>
                    </div>
                </div>
                <hr class="border-gray-100">
                <div>
                    <label class="form-label">New Password <span class="text-red-500">*</span></label>
                    <div class="relative">
                        <input type="password" name="new_password" class="form-input pr-10" required placeholder="Minimum 6 characters" minlength="6" id="cpNewPwd">
                        <button type="button" onclick="togglePwdField('cpNewPwd','cpIcon2')" class="absolute right-3 top-1/2 -translate-y-1/2 text-gray-400 hover:text-gray-600">
                            <i class="fas fa-eye" id="cpIcon2"></i>
                        </button>
                    </div>
                </div>
                <div>
                    <label class="form-label">Confirm New Password <span class="text-red-500">*</span></label>
                    <div class="relative">
                        <input type="password" name="confirm_password" class="form-input pr-10" required placeholder="Re-enter new password" minlength="6" id="cpConfirmPwd">
                        <button type="button" onclick="togglePwdField('cpConfirmPwd','cpIcon3')" class="absolute right-3 top-1/2 -translate-y-1/2 text-gray-400 hover:text-gray-600">
                            <i class="fas fa-eye" id="cpIcon3"></i>
                        </button>
                    </div>
                </div>
            </div>
            <div class="flex items-center justify-end gap-4 mt-6 pt-5 border-t border-gray-200">
                <button type="button" onclick="closeModal('changePasswordModal')" class="btn btn-secondary">Cancel</button>
                <button type="submit" class="btn btn-primary"><i class="fas fa-save"></i> Update Password</button>
            </div>
        </form>
    </div>
</div>

<script>
function toggleSidebarGroup(groupId) {
    const el = document.getElementById(groupId);
    const chevron = document.getElementById(groupId + 'Chevron');
    if (!el) return;
    el.classList.toggle('hidden');
    if (chevron) chevron.style.transform = el.classList.contains('hidden') ? '' : 'rotate(180deg)';
}
document.addEventListener('DOMContentLoaded', function() {
    const careerGroup = document.getElementById('careerGroup');
    const chevron = document.getElementById('careerGroupChevron');
    if (careerGroup && chevron) {
        chevron.style.transform = careerGroup.classList.contains('hidden') ? '' : 'rotate(180deg)';
    }
});

function togglePwdField(inputId, iconId) {
    const input = document.getElementById(inputId);
    const icon = document.getElementById(iconId);
    if (input.type === 'password') { input.type = 'text'; icon.classList.replace('fa-eye', 'fa-eye-slash'); }
    else { input.type = 'password'; icon.classList.replace('fa-eye-slash', 'fa-eye'); }
}

<?php if ($pwdSuccess): ?>
document.addEventListener('DOMContentLoaded', function() {
    Swal.fire({ ...swalDefaults, icon: 'success', title: 'Password Changed', text: <?= json_encode($pwdSuccess) ?>, confirmButtonColor: '#2563eb' });
});
<?php elseif ($pwdError): ?>
document.addEventListener('DOMContentLoaded', function() {
    Swal.fire({ ...swalDefaults, icon: 'error', title: 'Error', text: <?= json_encode($pwdError) ?>, confirmButtonColor: '#2563eb' })
    .then(() => { openModal('changePasswordModal'); });
});
<?php endif; ?>
</script>
