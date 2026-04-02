<?php
$pageTitle = 'Competency Analysis';
require_once __DIR__ . '/../includes/header.php';
requireRole('teacher');

$sectionFilter = $_GET['section'] ?? '';
$levelFilter = $_GET['level'] ?? '';

$sections = $pdo->query("SELECT * FROM sections ORDER BY grade_level, section_name")->fetchAll();

$query = "SELECT s.id, s.first_name, s.last_name, s.lrn,
          sec.section_name, sec.grade_level,
          st.strand_code,
          AVG(g.grade) as avg_grade
          FROM students s
          JOIN grades g ON s.id = g.student_id
          LEFT JOIN sections sec ON s.section_id = sec.id
          LEFT JOIN strands st ON s.strand_id = st.id
          WHERE s.status = 'active'";
$params = [];

if ($sectionFilter) {
    $query .= " AND s.section_id = ?";
    $params[] = $sectionFilter;
}

$query .= " GROUP BY s.id ORDER BY avg_grade ASC";
$stmt = $pdo->prepare($query);
$stmt->execute($params);
$students = $stmt->fetchAll();

if ($levelFilter) {
    $students = array_filter($students, function($s) use ($levelFilter) {
        $comp = getCompetencyLevel($s['avg_grade']);
        return $comp['level'] === $levelFilter;
    });
}

$weakCount = count(array_filter($students, fn($s) => getCompetencyLevel($s['avg_grade'])['level'] === 'weak'));
$atRiskCount = count(array_filter($students, fn($s) => getCompetencyLevel($s['avg_grade'])['level'] === 'at_risk'));
$profCount = count(array_filter($students, fn($s) => getCompetencyLevel($s['avg_grade'])['level'] === 'proficient'));

// Subject-level weak competency identification
$subjectCompetency = $pdo->query("SELECT sub.subject_name, sub.subject_code, AVG(g.grade) as avg_grade, COUNT(DISTINCT g.student_id) as student_count
    FROM grades g
    JOIN subjects sub ON g.subject_id = sub.id
    JOIN students s ON g.student_id = s.id
    WHERE s.status = 'active'
    GROUP BY sub.id ORDER BY avg_grade ASC")->fetchAll();

// Strand Top Performers — top 3 per section by specialized subject average (G11 & G12)
$topPerformers = $pdo->query("SELECT ranked.* FROM (
    SELECT
        s.id as student_id,
        CONCAT(s.first_name, ' ', s.last_name) as student_name,
        sec.section_name,
        sec.grade_level,
        st.strand_code,
        st.strand_name,
        s.section_id,
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
ORDER BY ranked.strand_code, ranked.section_rank ASC")->fetchAll();

require_once __DIR__ . '/../includes/sidebar.php';
?>

<!-- Summary Cards -->
<div class="grid grid-cols-1 md:grid-cols-3 gap-5 mb-6">
    <a href="?level=weak<?= $sectionFilter ? '&section='.$sectionFilter : '' ?>"
       class="stat-card <?= $levelFilter === 'weak' ? 'ring-2 ring-gray-300' : '' ?>" style="background:#fef2f2;">
        <div class="flex items-center justify-between mb-2">
            <span class="text-sm font-medium text-gray-600">Weak Competency</span>
            <div class="w-10 h-10 rounded-lg flex items-center justify-center" style="background:#fee2e2;">
                <i class="fas fa-exclamation-circle" style="color:#b91c1c;"></i>
            </div>
        </div>
        <p class="text-3xl font-bold text-gray-800"><?= $weakCount ?></p>
        <p class="text-xs text-gray-500 mt-1">Below 75 — Did Not Meet Expectations</p>
    </a>
    <a href="?level=at_risk<?= $sectionFilter ? '&section='.$sectionFilter : '' ?>"
       class="stat-card <?= $levelFilter === 'at_risk' ? 'ring-2 ring-gray-300' : '' ?>" style="background:#fffbeb;">
        <div class="flex items-center justify-between mb-2">
            <span class="text-sm font-medium text-gray-600">At Risk</span>
            <div class="w-10 h-10 rounded-lg flex items-center justify-center" style="background:#fef3c7;">
                <i class="fas fa-exclamation-triangle" style="color:#92400e;"></i>
            </div>
        </div>
        <p class="text-3xl font-bold text-gray-800"><?= $atRiskCount ?></p>
        <p class="text-xs text-gray-500 mt-1">75-79 — Needs Reinforcement</p>
    </a>
    <a href="?level=proficient<?= $sectionFilter ? '&section='.$sectionFilter : '' ?>"
       class="stat-card <?= $levelFilter === 'proficient' ? 'ring-2 ring-gray-300' : '' ?>" style="background:#f0fdf4;">
        <div class="flex items-center justify-between mb-2">
            <span class="text-sm font-medium text-gray-600">Proficient / Excel</span>
            <div class="w-10 h-10 rounded-lg flex items-center justify-center" style="background:#dcfce7;">
                <i class="fas fa-check-circle" style="color:#166534;"></i>
            </div>
        </div>
        <p class="text-3xl font-bold text-gray-800"><?= $profCount ?></p>
        <p class="text-xs text-gray-500 mt-1">80 and above — Meets Expectations</p>
    </a>
</div>

<!-- Filters -->
<div class="flex flex-wrap items-center gap-4 mb-6">
    <form method="GET" class="flex items-center gap-3">
        <?php if ($levelFilter): ?><input type="hidden" name="level" value="<?= $levelFilter ?>"><?php endif; ?>
        <select name="section" class="form-select w-48" onchange="this.form.submit()">
            <option value="">All Sections</option>
            <?php foreach ($sections as $sec): ?>
                <option value="<?= $sec['id'] ?>" <?= $sectionFilter == $sec['id'] ? 'selected' : '' ?>>
                    <?= sanitize($sec['section_name']) ?>
                </option>
            <?php endforeach; ?>
        </select>
    </form>
    <?php if ($levelFilter): ?>
        <a href="?<?= $sectionFilter ? 'section='.$sectionFilter : '' ?>" class="btn btn-secondary btn-sm">
            <i class="fas fa-times"></i> Clear Level Filter
        </a>
    <?php endif; ?>
    <button onclick="exportTableToCSV('competencyTable', 'competency_analysis.csv')" class="btn btn-secondary btn-sm no-print">
        <i class="fas fa-download"></i> Export CSV
    </button>
</div>

<!-- Students Competency Table -->
<div class="bg-white border border-gray-200 rounded-xl overflow-hidden mb-8">
    <div class="px-6 py-4 border-b border-gray-200">
        <h3 class="text-sm font-semibold text-gray-900">Student Competency Levels</h3>
    </div>
    <div class="overflow-x-auto">
        <table class="steps-table" id="competencyTable">
            <thead>
                <tr>
                    <th>Student Name</th>
                    <th>LRN</th>
                    <th>Section</th>
                    <th>Strand</th>
                    <th>Average Grade</th>
                    <th>Competency Level</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <?php foreach ($students as $s): ?>
                    <?php $comp = getCompetencyLevel($s['avg_grade']); ?>
                    <tr>
                        <td class="font-medium"><?= sanitize($s['last_name'] . ', ' . $s['first_name']) ?></td>
                        <td class="text-xs font-mono"><?= sanitize($s['lrn']) ?></td>
                        <td><?= sanitize($s['section_name'] ?? 'N/A') ?></td>
                        <td><span class="badge badge-blue"><?= sanitize($s['strand_code'] ?? 'N/A') ?></span></td>
                        <td class="font-semibold"><?= formatNumber($s['avg_grade']) ?></td>
                        <td>
                            <span class="badge badge-<?= $comp['color'] === 'emerald' ? 'green' : $comp['color'] ?>">
                                <?= $comp['label'] ?>
                            </span>
                        </td>
                        <td>
                            <a href="<?= BASE_URL ?>students/view.php?id=<?= $s['id'] ?>" class="text-blue-600 hover:underline text-sm">
                                View Profile
                            </a>
                        </td>
                    </tr>
                <?php endforeach; ?>
                <?php if (empty($students)): ?>
                    <tr><td colspan="7" class="text-center text-gray-400 py-8">No data available.</td></tr>
                <?php endif; ?>
            </tbody>
        </table>
    </div>
</div>

<!-- Subject-Level Analysis -->
<div class="bg-white border border-gray-200 rounded-xl overflow-hidden">
    <div class="px-6 py-4 border-b border-gray-200">
        <h3 class="text-sm font-semibold text-gray-900">Subject Competency Summary</h3>
        <p class="text-xs text-gray-400 mt-1">Identifies subjects with weak competency across all students</p>
    </div>
    <div class="overflow-x-auto">
        <table class="steps-table">
            <thead>
                <tr>
                    <th>Subject</th>
                    <th>Code</th>
                    <th>Avg. Grade</th>
                    <th>Students</th>
                    <th>Competency</th>
                </tr>
            </thead>
            <tbody>
                <?php foreach ($subjectCompetency as $sc): ?>
                    <?php $comp = getCompetencyLevel($sc['avg_grade']); ?>
                    <tr>
                        <td class="font-medium"><?= sanitize($sc['subject_name']) ?></td>
                        <td class="text-xs font-mono"><?= sanitize($sc['subject_code']) ?></td>
                        <td class="font-semibold"><?= formatNumber($sc['avg_grade']) ?></td>
                        <td><?= $sc['student_count'] ?></td>
                        <td>
                            <span class="badge badge-<?= $comp['color'] === 'emerald' ? 'green' : $comp['color'] ?>">
                                <?= $comp['label'] ?>
                            </span>
                        </td>
                    </tr>
                <?php endforeach; ?>
            </tbody>
        </table>
    </div>
</div>

<!-- Strand Top Performers -->
<div class="bg-white border border-gray-200 rounded-xl overflow-hidden mt-8">
    <div class="px-6 py-4 border-b border-gray-200">
        <div class="flex items-center gap-2">
            <i class="fas fa-star text-amber-500"></i>
            <h3 class="text-sm font-semibold text-gray-900">Strand Top Performers</h3>
        </div>
        <p class="text-xs text-gray-400 mt-1">Top 3 students per section based on specialized subject average (80+ and above)</p>
    </div>
    <div class="overflow-x-auto">
        <table class="steps-table">
            <thead>
                <tr>
                    <th>Rank</th>
                    <th>Student Name</th>
                    <th>Section</th>
                    <th>Grade Level</th>
                    <th>Strand</th>
                    <th>Specialized Avg</th>
                </tr>
            </thead>
            <tbody>
                <?php foreach ($topPerformers as $tp): ?>
                    <?php
                    $rankBadge = '';
                    if ($tp['section_rank'] == 1) $rankBadge = '<span class="inline-flex items-center gap-1 text-amber-600 font-semibold"><i class="fas fa-trophy text-amber-500"></i> 1st</span>';
                    elseif ($tp['section_rank'] == 2) $rankBadge = '<span class="inline-flex items-center gap-1 text-gray-500 font-semibold"><i class="fas fa-medal text-gray-400"></i> 2nd</span>';
                    else $rankBadge = '<span class="inline-flex items-center gap-1 text-amber-800 font-semibold"><i class="fas fa-medal text-amber-700"></i> 3rd</span>';
                    ?>
                    <tr>
                        <td><?= $rankBadge ?></td>
                        <td>
                            <a href="<?= BASE_URL ?>students/view.php?id=<?= $tp['student_id'] ?>" class="font-medium text-blue-600 hover:underline">
                                <?= sanitize($tp['student_name']) ?>
                            </a>
                        </td>
                        <td><?= sanitize($tp['section_name']) ?></td>
                        <td>Grade <?= $tp['grade_level'] ?></td>
                        <td><span class="badge badge-blue"><?= sanitize($tp['strand_code']) ?></span></td>
                        <td class="font-semibold"><?= formatNumber($tp['specialized_avg']) ?></td>
                    </tr>
                <?php endforeach; ?>
                <?php if (empty($topPerformers)): ?>
                    <tr><td colspan="6" class="text-center text-gray-400 py-8">No top performers detected yet. Students need specialized subject grades of 80+ to appear here.</td></tr>
                <?php endif; ?>
            </tbody>
        </table>
    </div>
</div>

<?php require_once __DIR__ . '/../includes/footer.php'; ?>
