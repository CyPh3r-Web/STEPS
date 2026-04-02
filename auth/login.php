<?php
session_start();
require_once __DIR__ . '/../config/database.php';
require_once __DIR__ . '/../config/constants.php';

if (isset($_SESSION['user_id'])) {
    header('Location: ' . BASE_URL . 'dashboard/index.php');
    exit;
}

$error = '';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $username = sanitize($_POST['username'] ?? '');
    $password = $_POST['password'] ?? '';

    if (empty($username) || empty($password)) {
        $error = 'Please enter both username and password.';
    } else {
        $stmt = $pdo->prepare("SELECT * FROM users WHERE username = ? AND status = 'active'");
        $stmt->execute([$username]);
        $user = $stmt->fetch();

        if ($user && password_verify($password, $user['password'])) {
            $_SESSION['user_id'] = $user['id'];
            $_SESSION['username'] = $user['username'];
            $_SESSION['full_name'] = $user['full_name'];
            $_SESSION['role'] = $user['role'];

            $logStmt = $pdo->prepare("INSERT INTO activity_logs (user_id, action, description, ip_address) VALUES (?, 'login', 'User logged in', ?)");
            $logStmt->execute([$user['id'], $_SERVER['REMOTE_ADDR']]);

            header('Location: ' . BASE_URL . 'dashboard/index.php');
            exit;
        } else {
            $error = 'Invalid username or password.';
        }
    }
}
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sign In - <?= SITE_FULL_NAME ?></title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <link rel="stylesheet" href="<?= BASE_URL ?>assets/css/style.css">
    <script>
        tailwind.config = {
            theme: { extend: { fontFamily: { 'poppins': ['Poppins', 'sans-serif'] } } }
        }
    </script>
    <script>
        (function() {
            var t = localStorage.getItem('steps_theme') || 'blue';
            var m = localStorage.getItem('steps_mode') || 'light';
            document.documentElement.setAttribute('data-theme', t);
            document.documentElement.setAttribute('data-mode', m);
        })();
    </script>
</head>
<body class="font-poppins login-container">
    <button type="button" id="modeToggle" onclick="toggleMode()" class="mode-toggle-btn login-mode-btn fixed top-4 right-4 w-10 h-10 rounded-xl flex items-center justify-center z-10 bg-white/80 hover:bg-white border border-gray-200/80 text-gray-600 hover:text-gray-800 transition-colors" title="Toggle dark mode">
        <i class="fas fa-moon" id="modeIcon"></i>
    </button>
    <div class="login-bg" aria-hidden="true"></div>
    <div class="login-card">
        <div class="text-center mb-8">
            <div class="login-logo-wrap mb-4">
                <img src="<?= BASE_URL ?>assets/img/seait.png" alt="<?= SITE_FULL_NAME ?> logo" class="login-logo-img">
            </div>
            <h1 class="text-2xl font-bold text-gray-900"><?= SITE_NAME ?></h1>
            <p class="text-sm text-gray-500 mt-1"><?= SITE_FULL_NAME ?></p>
        </div>

        <form method="POST" action="">
            <div class="mb-5">
                <label class="form-label" for="username">Username</label>
                <input type="text" id="username" name="username" class="form-input"
                       placeholder="Enter your username" value="<?= sanitize($username ?? '') ?>" required autofocus>
            </div>
            <div class="mb-6">
                <label class="form-label" for="password">Password</label>
                <div class="relative">
                    <input type="password" id="password" name="password" class="form-input pr-10"
                           placeholder="Enter your password" required>
                    <button type="button" onclick="togglePassword()" class="absolute right-3 top-1/2 -translate-y-1/2 text-gray-400 hover:text-gray-600">
                        <i class="fas fa-eye" id="toggleIcon"></i>
                    </button>
                </div>
            </div>
            <button type="submit" class="btn btn-primary w-full justify-center py-3">
                <i class="fas fa-sign-in-alt"></i>
                Sign In
            </button>
        </form>

        <p class="text-center text-xs text-gray-400 mt-6">S.Y. <?= sanitize(effectiveSchoolYear()) ?></p>
    </div>

    <script>
        function toggleMode() {
            var el = document.documentElement;
            var current = el.getAttribute('data-mode') || 'light';
            var next = current === 'light' ? 'dark' : 'light';
            el.setAttribute('data-mode', next);
            localStorage.setItem('steps_mode', next);
            var icon = document.getElementById('modeIcon');
            if (icon) {
                icon.classList.remove('fa-moon', 'fa-sun');
                icon.classList.add(next === 'dark' ? 'fa-sun' : 'fa-moon');
            }
        }
        (function initModeIcon() {
            var m = localStorage.getItem('steps_mode') || 'light';
            var icon = document.getElementById('modeIcon');
            if (icon) {
                icon.classList.remove('fa-moon', 'fa-sun');
                icon.classList.add(m === 'dark' ? 'fa-sun' : 'fa-moon');
            }
        })();
        function togglePassword() {
            const pwd = document.getElementById('password');
            const icon = document.getElementById('toggleIcon');
            if (pwd.type === 'password') {
                pwd.type = 'text';
                icon.classList.replace('fa-eye', 'fa-eye-slash');
            } else {
                pwd.type = 'password';
                icon.classList.replace('fa-eye-slash', 'fa-eye');
            }
        }

        <?php if ($error): ?>
        document.addEventListener('DOMContentLoaded', function() {
            Swal.fire({
                icon: 'error',
                title: 'Login Failed',
                text: <?= json_encode($error) ?>,
                confirmButtonColor: '#2563eb',
                customClass: {
                    popup: 'swal-poppins',
                    title: 'swal-title',
                    htmlContainer: 'swal-text'
                }
            });
        });
        <?php endif; ?>
    </script>
</body>
</html>
