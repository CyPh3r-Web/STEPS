<?php
$pageTitle = 'Dashboard';
require_once __DIR__ . '/../includes/header.php';
requireLogin();

$role = $_SESSION['role'];

$sections = [];
$sectionFilter = $_GET['section'] ?? '';
$totalStudents = 0;
$classAvg = 0;
$atRiskCount = 0;
$weakCount = 0;
$excelCount = 0;
$atRiskPct = 0;
$weakPct = 0;
$excelPct = 0;
$lowPerformers = [];
$dashTopPerformers = [];
$avgEmployability = 0;
$recentRecs = [];

if ($role === 'teacher') {
    $currentUserId = $_SESSION['user_id'] ?? 0;
    $sections = $pdo->query('SELECT * FROM sections ORDER BY grade_level, section_name')->fetchAll();

    $studentQuery = "SELECT COUNT(*) as total FROM students WHERE status = 'active' AND created_by = ?";
    $studentParams = [$currentUserId];
    if ($sectionFilter) {
        $studentQuery .= ' AND section_id = ?';
        $studentParams[] = $sectionFilter;
    }
    $stmt = $pdo->prepare($studentQuery);
    $stmt->execute($studentParams);
    $totalStudents = $stmt->fetch()['total'];

    $avgQuery = "SELECT AVG(g.grade) as avg_grade FROM grades g
                 JOIN students s ON g.student_id = s.id WHERE s.status = 'active' AND s.created_by = ?";
    $avgParams = [$currentUserId];
    if ($sectionFilter) {
        $avgQuery .= ' AND s.section_id = ?';
        $avgParams[] = $sectionFilter;
    }
    $stmt = $pdo->prepare($avgQuery);
    $stmt->execute($avgParams);
    $classAvg = $stmt->fetch()['avg_grade'] ?? 0;

    $atRiskQuery = "SELECT COUNT(DISTINCT g.student_id) as cnt FROM (
        SELECT student_id, AVG(grade) as avg_g FROM grades
        JOIN students ON grades.student_id = students.id
        WHERE students.status = 'active' AND students.created_by = ?";
    $atRiskParams = [$currentUserId];
    if ($sectionFilter) {
        $atRiskQuery .= ' AND students.section_id = ?';
        $atRiskParams[] = $sectionFilter;
    }
    $atRiskQuery .= ' GROUP BY student_id HAVING avg_g >= 75 AND avg_g < 80) g';
    $stmt = $pdo->prepare($atRiskQuery);
    $stmt->execute($atRiskParams);
    $atRiskCount = $stmt->fetch()['cnt'];

    $weakQuery = "SELECT COUNT(DISTINCT g.student_id) as cnt FROM (
        SELECT student_id, AVG(grade) as avg_g FROM grades
        JOIN students ON grades.student_id = students.id
        WHERE students.status = 'active' AND students.created_by = ?";
    $weakParams = [$currentUserId];
    if ($sectionFilter) {
        $weakQuery .= ' AND students.section_id = ?';
        $weakParams[] = $sectionFilter;
    }
    $weakQuery .= ' GROUP BY student_id HAVING avg_g < 75) g';
    $stmt = $pdo->prepare($weakQuery);
    $stmt->execute($weakParams);
    $weakCount = $stmt->fetch()['cnt'];

    $excelQuery = "SELECT COUNT(DISTINCT g.student_id) as cnt FROM (
        SELECT student_id, AVG(grade) as avg_g FROM grades
        JOIN students ON grades.student_id = students.id
        WHERE students.status = 'active' AND students.created_by = ?";
    $excelParams = [$currentUserId];
    if ($sectionFilter) {
        $excelQuery .= ' AND students.section_id = ?';
        $excelParams[] = $sectionFilter;
    }
    $excelQuery .= ' GROUP BY student_id HAVING avg_g >= 80) g';
    $stmt = $pdo->prepare($excelQuery);
    $stmt->execute($excelParams);
    $excelCount = $stmt->fetch()['cnt'];

    $atRiskPct = $totalStudents > 0 ? round(($atRiskCount / $totalStudents) * 100, 1) : 0;
    $weakPct = $totalStudents > 0 ? round(($weakCount / $totalStudents) * 100, 1) : 0;
    $excelPct = $totalStudents > 0 ? round(($excelCount / $totalStudents) * 100, 1) : 0;

    $recentGrades = $pdo->prepare("SELECT s.first_name, s.last_name, sec.section_name, AVG(g.grade) as avg_grade
        FROM students s
        JOIN grades g ON s.id = g.student_id
        LEFT JOIN sections sec ON s.section_id = sec.id
        WHERE s.status = 'active' AND s.created_by = ?
        GROUP BY s.id ORDER BY avg_grade ASC LIMIT 10");
    $recentGrades->execute([$currentUserId]);
    $lowPerformers = $recentGrades->fetchAll();

    $dashTopPerformersStmt = $pdo->prepare("SELECT ranked.* FROM (
        SELECT
            s.id as student_id,
            CONCAT(s.first_name, ' ', s.last_name) as student_name,
            sec.section_name,
            st.strand_code,
            AVG(g.grade) as specialized_avg,
            RANK() OVER (PARTITION BY s.section_id ORDER BY AVG(g.grade) DESC) as section_rank
        FROM students s
        JOIN sections sec ON s.section_id = sec.id
        JOIN strands st ON s.strand_id = st.id
        JOIN grades g ON s.id = g.student_id
        JOIN subjects sub ON g.subject_id = sub.id
        WHERE s.status = 'active' AND s.created_by = ?
          AND sub.subject_type = 'specialized'
          AND sub.strand_id = s.strand_id
        GROUP BY s.id, s.section_id
        HAVING AVG(g.grade) >= 80
    ) ranked
    WHERE ranked.section_rank <= 3
    ORDER BY ranked.specialized_avg DESC
    LIMIT 5");
    $dashTopPerformersStmt->execute([$currentUserId]);
    $dashTopPerformers = $dashTopPerformersStmt->fetchAll();

    // Section Performance - only for teacher's created students
    $sectionQuery = "SELECT sec.id, sec.section_name, sec.grade_level, st.strand_code as strand,
        COUNT(DISTINCT s.id) as student_count,
        AVG(g.grade) as avg_grade,
        MIN(g.grade) as min_grade,
        MAX(g.grade) as max_grade
        FROM sections sec
        LEFT JOIN students s ON s.section_id = sec.id AND s.status = 'active' AND s.created_by = ?
        LEFT JOIN grades g ON g.student_id = s.id
        LEFT JOIN strands st ON s.strand_id = st.id
        GROUP BY sec.id, sec.section_name, sec.grade_level, st.strand_code
        HAVING student_count > 0
        ORDER BY sec.grade_level, sec.section_name";
    $sectionPerfStmt = $pdo->prepare($sectionQuery);
    $sectionPerfStmt->execute([$currentUserId]);
    $sectionPerformance = $sectionPerfStmt->fetchAll();

    // Quarter Performance - only for teacher's created students
    $quarterQuery = "SELECT g.quarter,
        AVG(g.grade) as avg_grade,
        COUNT(DISTINCT g.student_id) as students
        FROM grades g
        JOIN students s ON g.student_id = s.id
        WHERE s.status = 'active' AND s.created_by = ?
        GROUP BY g.quarter
        ORDER BY g.quarter";
    $quarterStmt = $pdo->prepare($quarterQuery);
    $quarterStmt->execute([$currentUserId]);
    $quarterData = $quarterStmt->fetchAll();

    // Subject Performance - only for teacher's created students
    $subQuery = "SELECT sub.id as subject_id, sub.subject_name, sub.subject_code,
        AVG(g.grade) as avg_grade,
        COUNT(DISTINCT g.student_id) as student_count,
        SUM(CASE WHEN g.grade < 75 THEN 1 ELSE 0 END) as weak_count,
        SUM(CASE WHEN g.grade >= 75 AND g.grade < 80 THEN 1 ELSE 0 END) as at_risk_count,
        SUM(CASE WHEN g.grade >= 80 THEN 1 ELSE 0 END) as prof_count
        FROM subjects sub
        JOIN grades g ON g.subject_id = sub.id
        JOIN students s ON g.student_id = s.id
        WHERE s.status = 'active' AND s.created_by = ?
        GROUP BY sub.id, sub.subject_name, sub.subject_code
        ORDER BY avg_grade ASC";
    $subPerfStmt = $pdo->prepare($subQuery);
    $subPerfStmt->execute([$currentUserId]);
    $subjectPerformance = $subPerfStmt->fetchAll();
}

if ($role === 'guidance') {
    $empStmt = $pdo->query("SELECT AVG(employability_score) as avg_score FROM career_recommendations WHERE recommendation_type = 'course' AND employability_score IS NOT NULL");
    $avgEmployability = $empStmt->fetch()['avg_score'] ?? 0;

    $recentRecs = $pdo->query("SELECT cr.*, CONCAT(s.first_name, ' ', s.last_name) as student_name, st.strand_name
        FROM career_recommendations cr
        JOIN students s ON cr.student_id = s.id
        LEFT JOIN strands st ON s.strand_id = st.id
        ORDER BY cr.created_at DESC LIMIT 5")->fetchAll();
}

$adminStats = null;
if ($role === 'admin') {
    $roleCounts = $pdo->query("SELECT role, COUNT(*) as c FROM users GROUP BY role")->fetchAll(PDO::FETCH_KEY_PAIR);
    $adminStats = [
        'users' => array_sum($roleCounts),
        'role_counts' => $roleCounts,
        'logins_week' => (int)$pdo->query("SELECT COUNT(*) FROM activity_logs WHERE action = 'login' AND created_at >= DATE_SUB(NOW(), INTERVAL 7 DAY)")->fetchColumn(),
        'tickets_open' => 0,
        'backups' => 0,
    ];
    try {
        $adminStats['tickets_open'] = (int)$pdo->query("SELECT COUNT(*) FROM support_tickets WHERE status IN ('open','in_progress')")->fetchColumn();
    } catch (PDOException $e) {
    }
    try {
        $adminStats['backups'] = (int)$pdo->query('SELECT COUNT(*) FROM backup_logs')->fetchColumn();
    } catch (PDOException $e) {
    }
}

require_once __DIR__ . '/../includes/sidebar.php';
?>

<?php if ($role === 'admin'): ?>
<div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-5 mb-8">
    <div class="stat-card" style="background:#f8fafc;">
        <span class="text-sm font-medium text-gray-600">User accounts</span>
        <p class="text-3xl font-bold text-gray-800 mt-2"><?= (int)$adminStats['users'] ?></p>
        <p class="text-xs text-gray-500 mt-1">Teachers, counselors, admins</p>
    </div>
    <div class="stat-card" style="background:#eff6ff;">
        <span class="text-sm font-medium text-gray-600">Logins (7 days)</span>
        <p class="text-3xl font-bold text-gray-800 mt-2"><?= (int)$adminStats['logins_week'] ?></p>
        <p class="text-xs text-gray-500 mt-1">From activity log</p>
    </div>
    <div class="stat-card" style="background:#fffbeb;">
        <span class="text-sm font-medium text-gray-600">Open support tickets</span>
        <p class="text-3xl font-bold text-gray-800 mt-2"><?= (int)$adminStats['tickets_open'] ?></p>
        <p class="text-xs text-gray-500 mt-1"><a href="<?= BASE_URL ?>admin/support.php" class="text-blue-600 hover:underline">Manage</a></p>
    </div>
    <div class="stat-card" style="background:#f0fdf4;">
        <span class="text-sm font-medium text-gray-600">Backups on record</span>
        <p class="text-3xl font-bold text-gray-800 mt-2"><?= (int)$adminStats['backups'] ?></p>
        <p class="text-xs text-gray-500 mt-1"><a href="<?= BASE_URL ?>backup/index.php" class="text-blue-600 hover:underline">Backup &amp; recovery</a></p>
    </div>
</div>
<div class="bg-white border border-gray-200 rounded-xl p-6 mb-6">
    <h3 class="text-sm font-semibold text-gray-900 mb-3">Administrator</h3>
    <p class="text-sm text-gray-600 mb-4">You manage accounts, settings, logs, and backups. Student grades and academic analytics are not shown here.</p>
    <div class="flex flex-wrap gap-2">
        <a href="<?= BASE_URL ?>admin/system_reports.php" class="btn btn-primary btn-sm"><i class="fas fa-chart-pie"></i> System reports</a>
        <a href="<?= BASE_URL ?>admin/activity_logs.php" class="btn btn-secondary btn-sm"><i class="fas fa-list"></i> Activity logs</a>
        <a href="<?= BASE_URL ?>admin/settings.php" class="btn btn-secondary btn-sm"><i class="fas fa-cog"></i> Settings</a>
    </div>
</div>
<?php endif; ?>

<?php if ($role === 'teacher'): ?>
<div class="mb-6 flex flex-wrap items-center justify-between gap-4">
    <form method="GET" class="flex items-center gap-3">
        <label class="text-sm font-medium text-gray-600">Filter by Section:</label>
        <select name="section" class="form-select w-48" onchange="this.form.submit()">
            <option value="">All Sections</option>
            <?php foreach ($sections as $sec): ?>
                <option value="<?= $sec['id'] ?>" <?= $sectionFilter == $sec['id'] ? 'selected' : '' ?>>
                    <?= sanitize($sec['section_name']) ?> (G<?= $sec['grade_level'] ?>)
                </option>
            <?php endforeach; ?>
        </select>
    </form>
    <a href="<?= BASE_URL ?>reports/export.php?type=dashboard" class="btn btn-secondary btn-sm no-print">
        <i class="fas fa-download"></i> Export Report
    </a>
</div>

<div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-5 mb-8">
    <div class="stat-card" style="background:#f8fafc;">
        <div class="flex items-center justify-between mb-3">
            <span class="text-sm font-medium text-gray-600">Total Students</span>
            <div class="w-10 h-10 rounded-lg flex items-center justify-center" style="background:#e2e8f0;">
                <i class="fas fa-user-graduate" style="color:#475569;"></i>
            </div>
        </div>
        <p class="text-3xl font-bold text-gray-800"><?= $totalStudents ?></p>
        <p class="text-xs text-gray-500 mt-1">Active enrollees</p>
    </div>

    <div class="stat-card" style="background:#eff6ff;">
        <div class="flex items-center justify-between mb-3">
            <span class="text-sm font-medium text-gray-600">Class Average</span>
            <div class="w-10 h-10 rounded-lg flex items-center justify-center" style="background:#dbeafe;">
                <i class="fas fa-chart-line" style="color:#1d4ed8;"></i>
            </div>
        </div>
        <p class="text-3xl font-bold text-gray-800"><?= formatNumber($classAvg) ?></p>
        <p class="text-xs text-gray-500 mt-1">Overall performance</p>
    </div>

    <div class="stat-card" style="background:#fef2f2;">
        <div class="flex items-center justify-between mb-3">
            <span class="text-sm font-medium text-gray-600">At Risk / Weak</span>
            <div class="w-10 h-10 rounded-lg flex items-center justify-center" style="background:#fee2e2;">
                <i class="fas fa-exclamation-triangle" style="color:#b91c1c;"></i>
            </div>
        </div>
        <p class="text-3xl font-bold text-gray-800"><?= $weakCount + $atRiskCount ?></p>
        <p class="text-xs text-gray-500 mt-1"><?= $weakPct + $atRiskPct ?>% of students</p>
    </div>

    <div class="stat-card" style="background:#f0fdf4;">
        <div class="flex items-center justify-between mb-3">
            <span class="text-sm font-medium text-gray-600">Proficient / Excel</span>
            <div class="w-10 h-10 rounded-lg flex items-center justify-center" style="background:#dcfce7;">
                <i class="fas fa-award" style="color:#166534;"></i>
            </div>
        </div>
        <p class="text-3xl font-bold text-gray-800"><?= $excelCount ?></p>
        <p class="text-xs text-gray-500 mt-1"><?= $excelPct ?>% of students</p>
    </div>
</div>

<div class="bg-white border border-gray-200 rounded-xl p-6 mb-8">
    <h3 class="text-sm font-semibold text-gray-900 mb-4">Quick Summary</h3>
    <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
        <div class="flex items-center gap-4 p-4 rounded-lg" style="background:#fef2f2;">
            <div class="w-3 h-3 rounded-full" style="background:#b91c1c;"></div>
            <div>
                <p class="text-sm font-medium text-gray-800">Weak (Below 75)</p>
                <p class="text-2xl font-bold text-gray-800"><?= $weakPct ?>%</p>
                <p class="text-xs text-gray-500"><?= $weakCount ?> student(s) — Did Not Meet Expectations</p>
            </div>
        </div>
        <div class="flex items-center gap-4 p-4 rounded-lg" style="background:#fffbeb;">
            <div class="w-3 h-3 rounded-full" style="background:#92400e;"></div>
            <div>
                <p class="text-sm font-medium text-gray-800">At Risk (75-79)</p>
                <p class="text-2xl font-bold text-gray-800"><?= $atRiskPct ?>%</p>
                <p class="text-xs text-gray-500"><?= $atRiskCount ?> student(s) — Needs Reinforcement</p>
            </div>
        </div>
        <div class="flex items-center gap-4 p-4 rounded-lg" style="background:#f0fdf4;">
            <div class="w-3 h-3 rounded-full" style="background:#166534;"></div>
            <div>
                <p class="text-sm font-medium text-gray-800">Proficient (80+)</p>
                <p class="text-2xl font-bold text-gray-800"><?= $excelPct ?>%</p>
                <p class="text-xs text-gray-500"><?= $excelCount ?> student(s) — Meets Expectations</p>
            </div>
        </div>
    </div>
</div>

<div class="bg-white border border-gray-200 rounded-xl overflow-hidden">
    <div class="px-6 py-4 border-b border-gray-200 flex items-center justify-between">
        <h3 class="text-sm font-semibold text-gray-900">Students Needing Attention</h3>
        <a href="<?= BASE_URL ?>competency/index.php" class="text-xs text-blue-600 hover:underline font-medium">View All</a>
    </div>
    <table class="steps-table" id="lowPerformersTable">
        <thead>
            <tr>
                <th>Student Name</th>
                <th>Section</th>
                <th>Average Grade</th>
                <th>Status</th>
            </tr>
        </thead>
        <tbody>
            <?php foreach ($lowPerformers as $student): ?>
                <?php $comp = getCompetencyLevel($student['avg_grade']); ?>
                <tr>
                    <td class="font-medium"><?= sanitize($student['first_name'] . ' ' . $student['last_name']) ?></td>
                    <td><?= sanitize($student['section_name'] ?? 'N/A') ?></td>
                    <td class="font-semibold"><?= formatNumber($student['avg_grade']) ?></td>
                    <td>
                        <span class="badge badge-<?= $comp['color'] === 'emerald' ? 'green' : $comp['color'] ?>">
                            <?= $comp['label'] ?>
                        </span>
                    </td>
                </tr>
            <?php endforeach; ?>
            <?php if (empty($lowPerformers)): ?>
                <tr><td colspan="4" class="text-center text-gray-400 py-8">No grade data available.</td></tr>
            <?php endif; ?>
        </tbody>
    </table>
</div>

<div class="bg-white border border-gray-200 rounded-xl overflow-hidden mt-6">
    <div class="px-6 py-4 border-b border-gray-200 flex items-center justify-between">
        <div class="flex items-center gap-2">
            <i class="fas fa-star text-amber-500"></i>
            <h3 class="text-sm font-semibold text-gray-900">Strand Top Performers</h3>
        </div>
        <a href="<?= BASE_URL ?>competency/index.php" class="text-xs text-blue-600 hover:underline font-medium">View All</a>
    </div>
    <table class="steps-table">
        <thead>
            <tr><th>Rank</th><th>Student</th><th>Section</th><th>Strand</th><th>Specialized Avg</th></tr>
        </thead>
        <tbody>
            <?php foreach ($dashTopPerformers as $tp): ?>
                <?php
                $rankIcon = $tp['section_rank'] == 1 ? '<i class="fas fa-trophy text-amber-500"></i>' : '<i class="fas fa-medal text-gray-400"></i>';
                ?>
                <tr>
                    <td><?= $rankIcon ?> <span class="font-semibold text-sm">#<?= $tp['section_rank'] ?></span></td>
                    <td><a href="<?= BASE_URL ?>students/view.php?id=<?= $tp['student_id'] ?>" class="font-medium text-blue-600 hover:underline"><?= sanitize($tp['student_name']) ?></a></td>
                    <td><?= sanitize($tp['section_name']) ?></td>
                    <td><span class="badge badge-blue"><?= sanitize($tp['strand_code']) ?></span></td>
                    <td class="font-semibold"><?= formatNumber($tp['specialized_avg']) ?></td>
                </tr>
            <?php endforeach; ?>
            <?php if (empty($dashTopPerformers)): ?>
                <tr><td colspan="5" class="text-center text-gray-400 py-6">No top performers detected yet.</td></tr>
            <?php endif; ?>
        </tbody>
    </table>
</div>

<!-- Class Performance Module -->
<div class="mb-6 mt-8 flex items-center justify-between">
    <h3 class="text-lg font-semibold text-gray-900"><i class="fas fa-chart-bar text-blue-600 mr-2"></i>Class Performance Summary</h3>
    <div class="flex gap-2 no-print">
        <button onclick="window.print()" class="btn btn-secondary btn-sm"><i class="fas fa-print"></i> Print</button>
        <a href="<?= BASE_URL ?>reports/class_performance.php" class="btn btn-primary btn-sm"><i class="fas fa-expand"></i> Full View</a>
    </div>
</div>

<!-- Section Performance Overview -->
<div class="bg-white border border-gray-200 rounded-xl overflow-hidden mb-6">
    <div class="px-6 py-4 border-b border-gray-200">
        <h3 class="text-sm font-semibold text-gray-900">Section Performance Overview</h3>
    </div>
    <div class="overflow-x-auto">
        <table class="steps-table">
            <thead>
                <tr>
                    <th>Section</th><th>Grade Level</th><th>Strand</th><th>Students</th><th>Avg. Grade</th><th>Min</th><th>Max</th><th>Status</th>
                </tr>
            </thead>
            <tbody>
                <?php foreach ($sectionPerformance as $sp): ?>
                    <?php $comp = $sp['avg_grade'] ? getCompetencyLevel($sp['avg_grade']) : null; ?>
                    <tr>
                        <td class="font-medium"><?= sanitize($sp['section_name']) ?></td>
                        <td><?= $sp['grade_level'] ?></td>
                        <td><?= sanitize($sp['strand'] ?? 'N/A') ?></td>
                        <td><?= $sp['student_count'] ?></td>
                        <td class="font-semibold"><?= $sp['avg_grade'] ? formatNumber($sp['avg_grade']) : 'N/A' ?></td>
                        <td><?= $sp['min_grade'] ? formatNumber($sp['min_grade']) : '-' ?></td>
                        <td><?= $sp['max_grade'] ? formatNumber($sp['max_grade']) : '-' ?></td>
                        <td>
                            <?php if ($comp): ?>
                                <span class="badge badge-<?= $comp['color'] === 'emerald' ? 'green' : $comp['color'] ?>"><?= $comp['label'] ?></span>
                            <?php else: ?>-<?php endif; ?>
                        </td>
                    </tr>
                <?php endforeach; ?>
                <?php if (empty($sectionPerformance)): ?>
                    <tr><td colspan="8" class="text-center text-gray-400 py-6">No performance data available.</td></tr>
                <?php endif; ?>
            </tbody>
        </table>
    </div>
</div>

<!-- Quarter Comparison -->
<?php if (!empty($quarterData)): ?>
<div class="grid grid-cols-2 md:grid-cols-4 gap-5 mb-6">
    <?php foreach ($quarterData as $qd): ?>
        <?php $qComp = getCompetencyLevel($qd['avg_grade']); ?>
        <div class="stat-card text-center" style="background:#f8fafc;">
            <p class="text-sm font-semibold text-gray-600"><?= $qd['quarter'] ?></p>
            <p class="text-3xl font-bold text-gray-800 my-2"><?= formatNumber($qd['avg_grade']) ?></p>
            <p class="text-xs text-gray-500"><?= $qd['students'] ?> student(s)</p>
        </div>
    <?php endforeach; ?>
</div>
<?php endif; ?>

<!-- Subject Performance -->
<div class="bg-white border border-gray-200 rounded-xl overflow-hidden mb-8">
    <div class="px-6 py-4 border-b border-gray-200">
        <h3 class="text-sm font-semibold text-gray-900">Subject Performance Breakdown</h3>
        <p class="text-xs text-gray-400 mt-1">Sorted by lowest average (identifies weak competency areas)</p>
    </div>
    <div class="overflow-x-auto">
        <table class="steps-table" id="subjectPerfTable">
            <thead>
                <tr>
                    <th>Subject</th><th>Code</th><th>Avg Grade</th><th>Students</th><th>Weak</th><th>At Risk</th><th>Proficient</th><th>Status</th>
                </tr>
            </thead>
            <tbody>
                <?php foreach ($subjectPerformance as $subp): ?>
                    <?php $subComp = getCompetencyLevel($subp['avg_grade']); ?>
                    <tr>
                        <td class="font-medium"><?= sanitize($subp['subject_name']) ?></td>
                        <td class="text-xs text-gray-500"><?= sanitize($subp['subject_code']) ?></td>
                        <td class="font-semibold"><?= formatNumber($subp['avg_grade']) ?></td>
                        <td><?= $subp['student_count'] ?></td>
                        <td class="text-red-600"><?= $subp['weak_count'] ?></td>
                        <td class="text-amber-600"><?= $subp['at_risk_count'] ?></td>
                        <td class="text-emerald-600"><?= $subp['prof_count'] ?></td>
                        <td>
                            <span class="badge badge-<?= $subComp['color'] === 'emerald' ? 'green' : $subComp['color'] ?>"><?= $subComp['label'] ?></span>
                        </td>
                    </tr>
                <?php endforeach; ?>
                <?php if (empty($subjectPerformance)): ?>
                    <tr><td colspan="8" class="text-center text-gray-400 py-6">No subject data available.</td></tr>
                <?php endif; ?>
            </tbody>
        </table>
    </div>
</div>
<?php endif; ?>

<?php if ($role === 'guidance'): ?>
<div class="grid grid-cols-1 md:grid-cols-2 gap-5 mb-8">
    <div class="stat-card" style="background:#eff6ff;">
        <div class="flex items-center justify-between mb-3">
            <span class="text-sm font-medium text-gray-600">Avg. employability (WI)</span>
            <div class="w-10 h-10 rounded-lg flex items-center justify-center" style="background:#dbeafe;">
                <i class="fas fa-briefcase" style="color:#1d4ed8;"></i>
            </div>
        </div>
        <?php $empLevel = getEmployabilityLevel($avgEmployability); ?>
        <p class="text-3xl font-bold text-gray-800"><?= formatNumber($avgEmployability) ?></p>
        <span class="badge badge-<?= $empLevel['color'] === 'emerald' ? 'green' : $empLevel['color'] ?> mt-2">
            <?= $empLevel['label'] ?>
        </span>
    </div>

    <div class="stat-card" style="background:#f0fdf4;">
        <div class="flex items-center justify-between mb-3">
            <span class="text-sm font-medium text-gray-600">Career Recommendations</span>
            <div class="w-10 h-10 rounded-lg flex items-center justify-center" style="background:#dcfce7;">
                <i class="fas fa-route" style="color:#166534;"></i>
            </div>
        </div>
        <?php
        $totalRecs = $pdo->query('SELECT COUNT(*) as cnt FROM career_recommendations')->fetch()['cnt'];
        ?>
        <p class="text-3xl font-bold text-gray-800"><?= $totalRecs ?></p>
        <p class="text-xs text-gray-500 mt-1">Generated recommendations</p>
    </div>
</div>

<div class="bg-white border border-gray-200 rounded-xl overflow-hidden">
    <div class="px-6 py-4 border-b border-gray-200 flex items-center justify-between">
        <h3 class="text-sm font-semibold text-gray-900">Recent Career Recommendations</h3>
        <a href="<?= BASE_URL ?>career/index.php" class="text-xs text-blue-600 hover:underline font-medium">View All</a>
    </div>
    <table class="steps-table">
        <thead>
            <tr>
                <th>Student</th>
                <th>Current Strand</th>
                <th>Recommended Strand</th>
                <th>Employability Score</th>
                <th>Match</th>
            </tr>
        </thead>
        <tbody>
            <?php if (!empty($recentRecs)): ?>
                <?php foreach ($recentRecs as $rec): ?>
                    <tr>
                        <td class="font-medium"><?= sanitize($rec['student_name']) ?></td>
                        <td><?= sanitize($rec['strand_name'] ?? 'N/A') ?></td>
                        <td><?= sanitize($rec['recommended_strand'] ?? 'N/A') ?></td>
                        <td class="font-semibold"><?= $rec['employability_score'] !== null && $rec['employability_score'] !== '' ? formatNumber($rec['employability_score']) : '—' ?></td>
                        <td>
                            <?php if ($rec['strand_match']): ?>
                                <span class="badge badge-green"><i class="fas fa-check mr-1"></i> Match</span>
                            <?php else: ?>
                                <span class="badge badge-red"><i class="fas fa-times mr-1"></i> Mismatch</span>
                            <?php endif; ?>
                        </td>
                    </tr>
                <?php endforeach; ?>
            <?php else: ?>
                <tr><td colspan="5" class="text-center text-gray-400 py-8">No recommendations yet. <a href="<?= BASE_URL ?>career/index.php" class="text-blue-600 hover:underline">Open career pathway</a></td></tr>
            <?php endif; ?>
        </tbody>
    </table>
</div>
<?php endif; ?>

<?php require_once __DIR__ . '/../includes/footer.php'; ?>
