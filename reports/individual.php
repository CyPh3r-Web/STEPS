<?php
$pageTitle = 'Individual Diagnostic Report';
require_once __DIR__ . '/../includes/header.php';
requireLogin();

$studentId = $_GET['student_id'] ?? '';
$students = $pdo->query("SELECT s.id, s.first_name, s.last_name, s.lrn, sec.section_name
    FROM students s LEFT JOIN sections sec ON s.section_id = sec.id
    WHERE s.status = 'active' ORDER BY s.last_name, s.first_name")->fetchAll();

$student = null;
$grades = [];
$workImmersion = null;
$careerRec = null;

if ($studentId) {
    $stmt = $pdo->prepare("SELECT s.*, sec.section_name, sec.grade_level, st.strand_code, st.strand_name
        FROM students s
        LEFT JOIN sections sec ON s.section_id = sec.id
        LEFT JOIN strands st ON s.strand_id = st.id WHERE s.id = ?");
    $stmt->execute([$studentId]);
    $student = $stmt->fetch();

    if ($student) {
        $gradeStmt = $pdo->prepare("SELECT g.*, sub.subject_name, sub.subject_code
            FROM grades g JOIN subjects sub ON g.subject_id = sub.id
            WHERE g.student_id = ? ORDER BY sub.subject_name, g.quarter");
        $gradeStmt->execute([$studentId]);
        $grades = $gradeStmt->fetchAll();

        $wiStmt = $pdo->prepare("SELECT * FROM work_immersion WHERE student_id = ? ORDER BY school_year DESC LIMIT 1");
        $wiStmt->execute([$studentId]);
        $workImmersion = $wiStmt->fetch();

        $crStmt = $pdo->prepare("SELECT * FROM career_recommendations WHERE student_id = ? ORDER BY created_at DESC LIMIT 1");
        $crStmt->execute([$studentId]);
        $careerRec = $crStmt->fetch();

        // Save to diagnostic reports
        $avgStmt = $pdo->prepare("SELECT AVG(grade) as avg_grade FROM grades WHERE student_id = ?");
        $avgStmt->execute([$studentId]);
        $avgGrade = $avgStmt->fetch()['avg_grade'] ?? 0;

        $reportData = json_encode([
            'student_name' => $student['first_name'] . ' ' . $student['last_name'],
            'avg_grade' => $avgGrade,
            'competency' => getCompetencyLevel($avgGrade),
            'work_immersion' => $workImmersion ? $workImmersion['rating'] : null,
            'career_recommendation' => $careerRec ? $careerRec['recommended_strand'] : null
        ]);

        $saveReport = $pdo->prepare("INSERT INTO diagnostic_reports (student_id, report_type, report_data, generated_by, school_year) VALUES (?, 'individual', ?, ?, ?)");
        $saveReport->execute([$studentId, $reportData, $_SESSION['user_id'], SCHOOL_YEAR]);
    }
}

require_once __DIR__ . '/../includes/sidebar.php';
?>

<a href="<?= BASE_URL ?>reports/index.php" class="inline-flex items-center gap-2 text-sm text-gray-500 hover:text-gray-700 mb-6">
    <i class="fas fa-arrow-left"></i> Back to Reports
</a>

<!-- Student Selector -->
<div class="bg-white border border-gray-200 rounded-xl p-5 mb-6">
    <form method="GET" class="flex flex-wrap items-end gap-4">
        <div class="flex-1 min-w-[250px]">
            <label class="form-label">Select Student</label>
            <select name="student_id" class="form-select">
                <option value="">Choose a student...</option>
                <?php foreach ($students as $s): ?>
                    <option value="<?= $s['id'] ?>" <?= $studentId == $s['id'] ? 'selected' : '' ?>>
                        <?= sanitize($s['last_name'] . ', ' . $s['first_name']) ?> (<?= sanitize($s['section_name'] ?? 'N/A') ?>)
                    </option>
                <?php endforeach; ?>
            </select>
        </div>
        <button type="submit" class="btn btn-primary btn-sm"><i class="fas fa-file-alt"></i> Generate Report</button>
        <?php if ($student): ?>
            <button type="button" onclick="window.print()" class="btn btn-secondary btn-sm no-print">
                <i class="fas fa-print"></i> Print
            </button>
        <?php endif; ?>
    </form>
</div>

<?php if ($student): ?>
    <?php
    $subjectGrades = [];
    foreach ($grades as $g) {
        $subjectGrades[$g['subject_name']]['code'] = $g['subject_code'];
        $subjectGrades[$g['subject_name']][$g['quarter']] = $g['grade'];
    }
    $avgStmt = $pdo->prepare("SELECT AVG(grade) as avg FROM grades WHERE student_id = ?");
    $avgStmt->execute([$studentId]);
    $overallAvg = $avgStmt->fetch()['avg'] ?? 0;
    $compLevel = getCompetencyLevel($overallAvg);
    ?>

    <!-- Report Header -->
    <div class="bg-white border border-gray-200 rounded-xl p-8 mb-6">
        <div class="text-center mb-6 pb-6 border-b border-gray-200">
            <h2 class="text-xl font-bold text-gray-900">INDIVIDUAL DIAGNOSTIC REPORT</h2>
            <p class="text-sm text-gray-500"><?= SITE_FULL_NAME ?> | S.Y. <?= SCHOOL_YEAR ?></p>
        </div>

        <div class="grid grid-cols-2 md:grid-cols-4 gap-4 mb-6">
            <div>
                <p class="text-xs text-gray-400">Full Name</p>
                <p class="text-sm font-semibold"><?= sanitize($student['last_name'] . ', ' . $student['first_name'] . ' ' . ($student['middle_name'] ?? '')) ?></p>
            </div>
            <div>
                <p class="text-xs text-gray-400">LRN</p>
                <p class="text-sm font-medium font-mono"><?= sanitize($student['lrn']) ?></p>
            </div>
            <div>
                <p class="text-xs text-gray-400">Section / Grade</p>
                <p class="text-sm font-medium"><?= sanitize(($student['section_name'] ?? 'N/A') . ' / G' . ($student['grade_level'] ?? 'N/A')) ?></p>
            </div>
            <div>
                <p class="text-xs text-gray-400">Strand</p>
                <p class="text-sm font-medium"><?= sanitize($student['strand_code'] ?? 'N/A') ?></p>
            </div>
        </div>

        <!-- Academic Performance -->
        <h4 class="text-sm font-semibold text-gray-900 mb-3 pb-2 border-b border-gray-100">Academic Performance</h4>
        <table class="steps-table mb-6">
            <thead>
                <tr>
                    <th>Subject</th><th>Q1</th><th>Q2</th><th>Q3</th><th>Q4</th><th>Average</th><th>Competency</th>
                </tr>
            </thead>
            <tbody>
                <?php foreach ($subjectGrades as $subName => $data): ?>
                    <?php
                    $q1 = $data['Q1'] ?? null; $q2 = $data['Q2'] ?? null;
                    $q3 = $data['Q3'] ?? null; $q4 = $data['Q4'] ?? null;
                    $vals = array_filter([$q1,$q2,$q3,$q4], fn($v) => $v !== null);
                    $subAvg = count($vals) > 0 ? array_sum($vals)/count($vals) : 0;
                    $sc = getCompetencyLevel($subAvg);
                    ?>
                    <tr>
                        <td class="font-medium"><?= sanitize($subName) ?></td>
                        <td><?= $q1 !== null ? formatNumber($q1) : '-' ?></td>
                        <td><?= $q2 !== null ? formatNumber($q2) : '-' ?></td>
                        <td><?= $q3 !== null ? formatNumber($q3) : '-' ?></td>
                        <td><?= $q4 !== null ? formatNumber($q4) : '-' ?></td>
                        <td class="font-semibold"><?= count($vals) > 0 ? formatNumber($subAvg) : '-' ?></td>
                        <td><span class="badge badge-<?= $sc['color'] === 'emerald' ? 'green' : $sc['color'] ?>"><?= $sc['label'] ?></span></td>
                    </tr>
                <?php endforeach; ?>
            </tbody>
            <tfoot>
                <tr class="bg-gray-50 font-semibold">
                    <td colspan="5">General Average</td>
                    <td><?= formatNumber($overallAvg) ?></td>
                    <td><span class="badge badge-<?= $compLevel['color'] === 'emerald' ? 'green' : $compLevel['color'] ?>"><?= $compLevel['label'] ?></span></td>
                </tr>
            </tfoot>
        </table>

        <!-- Work Immersion -->
        <h4 class="text-sm font-semibold text-gray-900 mb-3 pb-2 border-b border-gray-100">Work Immersion</h4>
        <?php if ($workImmersion): ?>
            <div class="grid grid-cols-2 md:grid-cols-4 gap-4 mb-6">
                <div><p class="text-xs text-gray-400">Company</p><p class="text-sm font-medium"><?= sanitize($workImmersion['company_name']) ?></p></div>
                <div><p class="text-xs text-gray-400">Rating</p><p class="text-sm font-bold"><?= formatNumber($workImmersion['rating']) ?></p></div>
                <div><p class="text-xs text-gray-400">Hours</p><p class="text-sm font-medium"><?= $workImmersion['hours_completed'] ?> hrs</p></div>
                <div><p class="text-xs text-gray-400">Remarks</p><p class="text-sm"><?= sanitize($workImmersion['performance_remarks'] ?? 'N/A') ?></p></div>
            </div>
        <?php else: ?>
            <p class="text-sm text-gray-400 mb-6">No work immersion data available.</p>
        <?php endif; ?>

        <!-- Employability & Career -->
        <?php if ($careerRec): ?>
            <?php $empLvl = getEmployabilityLevel($careerRec['employability_score']); ?>
            <h4 class="text-sm font-semibold text-gray-900 mb-3 pb-2 border-b border-gray-100">Employability & Career Recommendation</h4>
            <div class="grid grid-cols-2 md:grid-cols-3 gap-4 mb-4">
                <div>
                    <p class="text-xs text-gray-400">Employability Score</p>
                    <p class="text-lg font-bold"><?= formatNumber($careerRec['employability_score']) ?></p>
                    <span class="badge badge-<?= $empLvl['color'] === 'emerald' ? 'green' : $empLvl['color'] ?>"><?= $empLvl['label'] ?></span>
                </div>
                <div>
                    <p class="text-xs text-gray-400">Recommended Strand</p>
                    <p class="text-sm font-semibold"><?= sanitize($careerRec['recommended_strand']) ?></p>
                </div>
                <div>
                    <p class="text-xs text-gray-400">Strand Match</p>
                    <?php if ($careerRec['strand_match']): ?>
                        <span class="badge badge-green"><i class="fas fa-check mr-1"></i> Match</span>
                    <?php else: ?>
                        <span class="badge badge-red"><i class="fas fa-times mr-1"></i> Mismatch</span>
                    <?php endif; ?>
                </div>
            </div>
            <div class="mb-4">
                <p class="text-xs text-gray-400">Recommended Courses</p>
                <p class="text-sm"><?= sanitize($careerRec['recommended_courses'] ?? 'N/A') ?></p>
            </div>
            <div>
                <p class="text-xs text-gray-400">Career Pathways</p>
                <p class="text-sm"><?= sanitize($careerRec['career_pathways'] ?? 'N/A') ?></p>
            </div>
        <?php endif; ?>

        <div class="mt-8 pt-6 border-t border-gray-200 text-center text-xs text-gray-400">
            Generated on <?= date('F d, Y h:i A') ?> by <?= sanitize($_SESSION['full_name']) ?>
        </div>
    </div>
<?php endif; ?>

<?php require_once __DIR__ . '/../includes/footer.php'; ?>
