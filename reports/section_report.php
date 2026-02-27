<?php
$pageTitle = 'Section Report';
require_once __DIR__ . '/../includes/header.php';
requireLogin();

$sections = $pdo->query("SELECT * FROM sections ORDER BY grade_level, section_name")->fetchAll();
$sectionId = $_GET['section_id'] ?? '';
$section = null;
$students = [];

if ($sectionId) {
    $secStmt = $pdo->prepare("SELECT * FROM sections WHERE id = ?");
    $secStmt->execute([$sectionId]);
    $section = $secStmt->fetch();

    if ($section) {
        $stmt = $pdo->prepare("SELECT s.*, st.strand_code, AVG(g.grade) as avg_grade
            FROM students s
            LEFT JOIN strands st ON s.strand_id = st.id
            LEFT JOIN grades g ON s.id = g.student_id
            WHERE s.section_id = ? AND s.status = 'active'
            GROUP BY s.id ORDER BY s.last_name, s.first_name");
        $stmt->execute([$sectionId]);
        $students = $stmt->fetchAll();

        $reportData = json_encode([
            'section' => $section['section_name'],
            'total_students' => count($students),
            'date' => date('Y-m-d H:i:s')
        ]);
        $saveReport = $pdo->prepare("INSERT INTO diagnostic_reports (section_id, report_type, report_data, generated_by, school_year) VALUES (?, 'section', ?, ?, ?)");
        $saveReport->execute([$sectionId, $reportData, $_SESSION['user_id'], SCHOOL_YEAR]);
    }
}

require_once __DIR__ . '/../includes/sidebar.php';
?>

<a href="<?= BASE_URL ?>reports/index.php" class="inline-flex items-center gap-2 text-sm text-gray-500 hover:text-gray-700 mb-6">
    <i class="fas fa-arrow-left"></i> Back to Reports
</a>

<div class="bg-white border border-gray-200 rounded-xl p-5 mb-6">
    <form method="GET" class="flex flex-wrap items-end gap-4">
        <div class="flex-1 min-w-[250px]">
            <label class="form-label">Select Section</label>
            <select name="section_id" class="form-select">
                <option value="">Choose a section...</option>
                <?php foreach ($sections as $sec): ?>
                    <option value="<?= $sec['id'] ?>" <?= $sectionId == $sec['id'] ? 'selected' : '' ?>>
                        <?= sanitize($sec['section_name']) ?> (Grade <?= $sec['grade_level'] ?> - <?= $sec['strand'] ?? 'General' ?>)
                    </option>
                <?php endforeach; ?>
            </select>
        </div>
        <button type="submit" class="btn btn-primary btn-sm"><i class="fas fa-file-alt"></i> Generate</button>
        <?php if ($section): ?>
            <button type="button" onclick="window.print()" class="btn btn-secondary btn-sm no-print"><i class="fas fa-print"></i> Print</button>
            <button type="button" onclick="exportTableToCSV('sectionTable', 'section_report_<?= $section['section_name'] ?>.csv')" class="btn btn-secondary btn-sm no-print">
                <i class="fas fa-download"></i> Export CSV
            </button>
        <?php endif; ?>
    </form>
</div>

<?php if ($section && !empty($students)): ?>
    <?php
    $sectionAvg = count($students) > 0
        ? array_sum(array_map(fn($s) => (float)$s['avg_grade'], array_filter($students, fn($s) => $s['avg_grade'] !== null))) / max(1, count(array_filter($students, fn($s) => $s['avg_grade'] !== null)))
        : 0;
    $weakStudents = array_filter($students, fn($s) => $s['avg_grade'] !== null && $s['avg_grade'] < 75);
    $atRiskStudents = array_filter($students, fn($s) => $s['avg_grade'] !== null && $s['avg_grade'] >= 75 && $s['avg_grade'] < 80);
    $profStudents = array_filter($students, fn($s) => $s['avg_grade'] !== null && $s['avg_grade'] >= 80);
    ?>

    <div class="bg-white border border-gray-200 rounded-xl p-8">
        <div class="text-center mb-6 pb-6 border-b border-gray-200">
            <h2 class="text-xl font-bold text-gray-900">SECTION DIAGNOSTIC REPORT</h2>
            <p class="text-sm text-gray-500"><?= sanitize($section['section_name']) ?> — Grade <?= $section['grade_level'] ?> | S.Y. <?= SCHOOL_YEAR ?></p>
        </div>

        <div class="grid grid-cols-2 md:grid-cols-4 gap-5 mb-6">
            <div class="text-center p-4 rounded-lg" style="background:#f8fafc;">
                <p class="text-2xl font-bold text-gray-800"><?= count($students) ?></p>
                <p class="text-xs text-gray-500">Total Students</p>
            </div>
            <div class="text-center p-4 rounded-lg" style="background:#eff6ff;">
                <p class="text-2xl font-bold text-gray-800"><?= formatNumber($sectionAvg) ?></p>
                <p class="text-xs text-gray-500">Section Average</p>
            </div>
            <div class="text-center p-4 rounded-lg" style="background:#fef2f2;">
                <p class="text-2xl font-bold text-gray-800"><?= count($weakStudents) + count($atRiskStudents) ?></p>
                <p class="text-xs text-gray-500">Needs Attention</p>
            </div>
            <div class="text-center p-4 rounded-lg" style="background:#f0fdf4;">
                <p class="text-2xl font-bold text-gray-800"><?= count($profStudents) ?></p>
                <p class="text-xs text-gray-500">Proficient</p>
            </div>
        </div>

        <table class="steps-table" id="sectionTable">
            <thead>
                <tr>
                    <th>#</th><th>Name</th><th>LRN</th><th>Strand</th><th>Average</th><th>Status</th>
                </tr>
            </thead>
            <tbody>
                <?php foreach ($students as $i => $s): ?>
                    <?php $comp = $s['avg_grade'] ? getCompetencyLevel($s['avg_grade']) : null; ?>
                    <tr>
                        <td class="text-gray-400"><?= $i + 1 ?></td>
                        <td class="font-medium"><?= sanitize($s['last_name'] . ', ' . $s['first_name']) ?></td>
                        <td class="text-xs font-mono"><?= sanitize($s['lrn']) ?></td>
                        <td><span class="badge badge-blue"><?= sanitize($s['strand_code'] ?? 'N/A') ?></span></td>
                        <td class="font-semibold"><?= $s['avg_grade'] ? formatNumber($s['avg_grade']) : 'N/A' ?></td>
                        <td>
                            <?php if ($comp): ?>
                                <span class="badge badge-<?= $comp['color'] === 'emerald' ? 'green' : $comp['color'] ?>"><?= $comp['label'] ?></span>
                            <?php else: ?>
                                <span class="text-gray-400">No grades</span>
                            <?php endif; ?>
                        </td>
                    </tr>
                <?php endforeach; ?>
            </tbody>
        </table>

        <div class="mt-8 pt-6 border-t border-gray-200 text-center text-xs text-gray-400">
            Generated on <?= date('F d, Y h:i A') ?> by <?= sanitize($_SESSION['full_name']) ?>
        </div>
    </div>
<?php endif; ?>

<?php require_once __DIR__ . '/../includes/footer.php'; ?>
