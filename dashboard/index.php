<?php
$pageTitle = 'Dashboard';
require_once __DIR__ . '/../includes/header.php';
requireLogin();

$role = $_SESSION['role'];
$userId = $_SESSION['user_id'];

$sectionFilter = $_GET['section'] ?? '';
$sections = $pdo->query("SELECT * FROM sections ORDER BY grade_level, section_name")->fetchAll();

// Total students
$studentQuery = "SELECT COUNT(*) as total FROM students WHERE status = 'active'";
$studentParams = [];
if ($sectionFilter) {
    $studentQuery .= " AND section_id = ?";
    $studentParams[] = $sectionFilter;
}
$stmt = $pdo->prepare($studentQuery);
$stmt->execute($studentParams);
$totalStudents = $stmt->fetch()['total'];

// Class average performance
$avgQuery = "SELECT AVG(g.grade) as avg_grade FROM grades g
             JOIN students s ON g.student_id = s.id WHERE s.status = 'active'";
$avgParams = [];
if ($sectionFilter) {
    $avgQuery .= " AND s.section_id = ?";
    $avgParams[] = $sectionFilter;
}
$stmt = $pdo->prepare($avgQuery);
$stmt->execute($avgParams);
$classAvg = $stmt->fetch()['avg_grade'] ?? 0;

// Students at risk (avg grade 75-79)
$atRiskQuery = "SELECT COUNT(DISTINCT g.student_id) as cnt FROM (
    SELECT student_id, AVG(grade) as avg_g FROM grades
    JOIN students ON grades.student_id = students.id
    WHERE students.status = 'active'";
$atRiskParams = [];
if ($sectionFilter) {
    $atRiskQuery .= " AND students.section_id = ?";
    $atRiskParams[] = $sectionFilter;
}
$atRiskQuery .= " GROUP BY student_id HAVING avg_g >= 75 AND avg_g < 80) g";
$stmt = $pdo->prepare($atRiskQuery);
$stmt->execute($atRiskParams);
$atRiskCount = $stmt->fetch()['cnt'];

// Students weak (avg grade below 75)
$weakQuery = "SELECT COUNT(DISTINCT g.student_id) as cnt FROM (
    SELECT student_id, AVG(grade) as avg_g FROM grades
    JOIN students ON grades.student_id = students.id
    WHERE students.status = 'active'";
$weakParams = [];
if ($sectionFilter) {
    $weakQuery .= " AND students.section_id = ?";
    $weakParams[] = $sectionFilter;
}
$weakQuery .= " GROUP BY student_id HAVING avg_g < 75) g";
$stmt = $pdo->prepare($weakQuery);
$stmt->execute($weakParams);
$weakCount = $stmt->fetch()['cnt'];

// Students proficient (avg grade 80+)
$excelQuery = "SELECT COUNT(DISTINCT g.student_id) as cnt FROM (
    SELECT student_id, AVG(grade) as avg_g FROM grades
    JOIN students ON grades.student_id = students.id
    WHERE students.status = 'active'";
$excelParams = [];
if ($sectionFilter) {
    $excelQuery .= " AND students.section_id = ?";
    $excelParams[] = $sectionFilter;
}
$excelQuery .= " GROUP BY student_id HAVING avg_g >= 80) g";
$stmt = $pdo->prepare($excelQuery);
$stmt->execute($excelParams);
$excelCount = $stmt->fetch()['cnt'];

$atRiskPct = $totalStudents > 0 ? round(($atRiskCount / $totalStudents) * 100, 1) : 0;
$weakPct = $totalStudents > 0 ? round(($weakCount / $totalStudents) * 100, 1) : 0;
$excelPct = $totalStudents > 0 ? round(($excelCount / $totalStudents) * 100, 1) : 0;

// Guidance data
if ($role === 'guidance' || $role === 'admin') {
    $empStmt = $pdo->query("SELECT AVG(employability_score) as avg_score FROM career_recommendations");
    $avgEmployability = $empStmt->fetch()['avg_score'] ?? 0;

    $recentRecs = $pdo->query("SELECT cr.*, CONCAT(s.first_name, ' ', s.last_name) as student_name, st.strand_name
        FROM career_recommendations cr
        JOIN students s ON cr.student_id = s.id
        LEFT JOIN strands st ON s.strand_id = st.id
        ORDER BY cr.created_at DESC LIMIT 5")->fetchAll();
}

// Recent student grades for quick view
$recentGrades = $pdo->prepare("SELECT s.first_name, s.last_name, sec.section_name, AVG(g.grade) as avg_grade
    FROM students s
    JOIN grades g ON s.id = g.student_id
    LEFT JOIN sections sec ON s.section_id = sec.id
    WHERE s.status = 'active'
    GROUP BY s.id ORDER BY avg_grade ASC LIMIT 10");
$recentGrades->execute();
$lowPerformers = $recentGrades->fetchAll();

// Strand Top Performers — top 5 across all strands
$dashTopPerformers = $pdo->query("SELECT ranked.* FROM (
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
    WHERE s.status = 'active'
      AND sub.subject_type = 'specialized'
      AND sub.strand_id = s.strand_id
    GROUP BY s.id, s.section_id
    HAVING AVG(g.grade) >= 80
) ranked
WHERE ranked.section_rank <= 3
ORDER BY ranked.specialized_avg DESC
LIMIT 5")->fetchAll();

require_once __DIR__ . '/../includes/sidebar.php';
?>

<!-- Section Filter -->
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

<?php if ($role === 'teacher' || $role === 'admin'): ?>
<!-- Teacher Dashboard -->
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

<!-- Quick Summary Color Indicators -->
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

<!-- Low Performers Table -->
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

<!-- Strand Top Performers -->
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
<?php endif; ?>

<?php if ($role === 'guidance' || $role === 'admin'): ?>
<!-- Guidance Dashboard -->
<div class="grid grid-cols-1 md:grid-cols-2 gap-5 mb-8 <?= $role === 'admin' ? 'mt-8' : '' ?>">
    <div class="stat-card" style="background:#eff6ff;">
        <div class="flex items-center justify-between mb-3">
            <span class="text-sm font-medium text-gray-600">Avg. Employability Readiness</span>
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
        $totalRecs = $pdo->query("SELECT COUNT(*) as cnt FROM career_recommendations")->fetch()['cnt'];
        ?>
        <p class="text-3xl font-bold text-gray-800"><?= $totalRecs ?></p>
        <p class="text-xs text-gray-500 mt-1">Generated recommendations</p>
    </div>
</div>

<!-- Recent Career Recommendations -->
<div class="bg-white border border-gray-200 rounded-xl overflow-hidden <?= $role === 'admin' ? '' : '' ?>">
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
                        <td class="font-semibold"><?= formatNumber($rec['employability_score']) ?></td>
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
                <tr><td colspan="5" class="text-center text-gray-400 py-8">No recommendations yet. <a href="<?= BASE_URL ?>career/index.php" class="text-blue-600 hover:underline">Generate now</a></td></tr>
            <?php endif; ?>
        </tbody>
    </table>
</div>
<?php endif; ?>

<?php require_once __DIR__ . '/../includes/footer.php'; ?>
