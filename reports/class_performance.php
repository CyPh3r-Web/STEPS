<?php
$pageTitle = 'Class Performance Summary';
require_once __DIR__ . '/../includes/header.php';
requireLogin();

$sectionFilter = $_GET['section'] ?? '';
$sections = $pdo->query("SELECT * FROM sections ORDER BY grade_level, section_name")->fetchAll();

// Section performance summary
$sectionQuery = "SELECT sec.id, sec.section_name, sec.grade_level, sec.strand,
    COUNT(DISTINCT s.id) as student_count,
    AVG(g.grade) as avg_grade,
    MIN(g.grade) as min_grade,
    MAX(g.grade) as max_grade
    FROM sections sec
    LEFT JOIN students s ON s.section_id = sec.id AND s.status = 'active'
    LEFT JOIN grades g ON g.student_id = s.id";
$sectionParams = [];
if ($sectionFilter) {
    $sectionQuery .= " WHERE sec.id = ?";
    $sectionParams[] = $sectionFilter;
}
$sectionQuery .= " GROUP BY sec.id ORDER BY sec.grade_level, sec.section_name";
$sectionPerf = $pdo->prepare($sectionQuery);
$sectionPerf->execute($sectionParams);
$sectionPerformance = $sectionPerf->fetchAll();

// Subject performance
$subQuery = "SELECT sub.subject_name, sub.subject_code,
    AVG(g.grade) as avg_grade,
    COUNT(DISTINCT g.student_id) as student_count,
    SUM(CASE WHEN g.grade < 75 THEN 1 ELSE 0 END) as weak_count,
    SUM(CASE WHEN g.grade >= 75 AND g.grade < 80 THEN 1 ELSE 0 END) as at_risk_count,
    SUM(CASE WHEN g.grade >= 80 THEN 1 ELSE 0 END) as prof_count
    FROM grades g
    JOIN subjects sub ON g.subject_id = sub.id
    JOIN students s ON g.student_id = s.id
    WHERE s.status = 'active'";
$subParams = [];
if ($sectionFilter) {
    $subQuery .= " AND s.section_id = ?";
    $subParams[] = $sectionFilter;
}
$subQuery .= " GROUP BY sub.id ORDER BY avg_grade ASC";
$subPerf = $pdo->prepare($subQuery);
$subPerf->execute($subParams);
$subjectPerformance = $subPerf->fetchAll();

// Quarter comparison
$quarterQuery = "SELECT g.quarter, AVG(g.grade) as avg_grade, COUNT(DISTINCT g.student_id) as students
    FROM grades g JOIN students s ON g.student_id = s.id WHERE s.status = 'active'";
$quarterParams = [];
if ($sectionFilter) {
    $quarterQuery .= " AND s.section_id = ?";
    $quarterParams[] = $sectionFilter;
}
$quarterQuery .= " GROUP BY g.quarter ORDER BY g.quarter";
$quarterPerf = $pdo->prepare($quarterQuery);
$quarterPerf->execute($quarterParams);
$quarterData = $quarterPerf->fetchAll();

if ($sectionFilter) {
    $reportData = json_encode(['section' => $sectionFilter, 'type' => 'class_performance', 'date' => date('Y-m-d')]);
    $save = $pdo->prepare("INSERT INTO diagnostic_reports (section_id, report_type, report_data, generated_by, school_year) VALUES (?, 'class_performance', ?, ?, ?)");
    $save->execute([$sectionFilter, $reportData, $_SESSION['user_id'], SCHOOL_YEAR]);
}

require_once __DIR__ . '/../includes/sidebar.php';
?>

<!-- Filters -->
<div class="flex flex-wrap items-center justify-between gap-4 mb-6">
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
    <div class="flex gap-2 no-print">
        <button onclick="window.print()" class="btn btn-secondary btn-sm"><i class="fas fa-print"></i> Print</button>
        <button onclick="exportTableToCSV('subjectPerfTable', 'class_performance.csv')" class="btn btn-secondary btn-sm">
            <i class="fas fa-download"></i> Export
        </button>
    </div>
</div>

<!-- Section Overview -->
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
                            <?php else: ?>
                                -
                            <?php endif; ?>
                        </td>
                    </tr>
                <?php endforeach; ?>
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
<div class="bg-white border border-gray-200 rounded-xl overflow-hidden">
    <div class="px-6 py-4 border-b border-gray-200">
        <h3 class="text-sm font-semibold text-gray-900">Subject Performance Breakdown</h3>
        <p class="text-xs text-gray-400 mt-1">Sorted by lowest average (identifies weak competency areas)</p>
    </div>
    <div class="overflow-x-auto">
        <table class="steps-table" id="subjectPerfTable">
            <thead>
                <tr>
                    <th>Subject</th><th>Code</th><th>Students</th><th>Avg. Grade</th>
                    <th>Weak (&lt;75)</th><th>At Risk (75-79)</th><th>Proficient (80+)</th><th>Status</th>
                </tr>
            </thead>
            <tbody>
                <?php foreach ($subjectPerformance as $sp): ?>
                    <?php $comp = getCompetencyLevel($sp['avg_grade']); ?>
                    <tr>
                        <td class="font-medium"><?= sanitize($sp['subject_name']) ?></td>
                        <td class="text-xs font-mono"><?= sanitize($sp['subject_code']) ?></td>
                        <td><?= $sp['student_count'] ?></td>
                        <td class="font-semibold"><?= formatNumber($sp['avg_grade']) ?></td>
                        <td><span class="text-red-600 font-medium"><?= $sp['weak_count'] ?></span></td>
                        <td><span class="text-amber-600 font-medium"><?= $sp['at_risk_count'] ?></span></td>
                        <td><span class="text-emerald-600 font-medium"><?= $sp['prof_count'] ?></span></td>
                        <td><span class="badge badge-<?= $comp['color'] === 'emerald' ? 'green' : $comp['color'] ?>"><?= $comp['label'] ?></span></td>
                    </tr>
                <?php endforeach; ?>
                <?php if (empty($subjectPerformance)): ?>
                    <tr><td colspan="8" class="text-center text-gray-400 py-8">No grade data available.</td></tr>
                <?php endif; ?>
            </tbody>
        </table>
    </div>
</div>

<?php require_once __DIR__ . '/../includes/footer.php'; ?>
