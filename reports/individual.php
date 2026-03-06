<?php
$pageTitle = 'Individual Diagnostic Report';
require_once __DIR__ . '/../includes/header.php';
requireLogin();

$strandGradeRaw = $_GET['strand_grade'] ?? '';
$sectionIdFilter = $_GET['section_id'] ?? '';
$studentId = $_GET['student_id'] ?? '';

// Strand/grade options: only combinations that have sections with active students
$strandGradeOptions = $pdo->query("
    SELECT DISTINCT sec.grade_level, sec.strand
    FROM sections sec
    INNER JOIN students s ON s.section_id = sec.id AND s.status = 'active' AND s.school_year = " . $pdo->quote(SCHOOL_YEAR) . "
    WHERE sec.school_year = " . $pdo->quote(SCHOOL_YEAR) . "
    ORDER BY sec.grade_level, COALESCE(sec.strand, '')
")->fetchAll();

$sectionsFiltered = [];
$studentsFiltered = [];
$gradeLevel = null;
$strandFilter = null;

if ($strandGradeRaw !== '') {
    $parts = explode('|', $strandGradeRaw, 2);
    $gradeLevel = (int) $parts[0];
    $strandFilter = isset($parts[1]) ? $parts[1] : '';
    $secSql = "SELECT sec.id, sec.section_name, sec.grade_level, sec.strand
        FROM sections sec
        INNER JOIN students s ON s.section_id = sec.id AND s.status = 'active' AND s.school_year = " . $pdo->quote(SCHOOL_YEAR) . "
        WHERE sec.grade_level = ? AND sec.school_year = " . $pdo->quote(SCHOOL_YEAR);
    $secParams = [$gradeLevel];
    if ($strandFilter === '' || $strandFilter === null) {
        $secSql .= " AND (sec.strand IS NULL OR sec.strand = '')";
    } else {
        $secSql .= " AND sec.strand = ?";
        $secParams[] = $strandFilter;
    }
    $secSql .= " GROUP BY sec.id ORDER BY sec.section_name";
    $stmtSec = $pdo->prepare($secSql);
    $stmtSec->execute($secParams);
    $sectionsFiltered = $stmtSec->fetchAll();
}

$sectionIdsFiltered = array_column($sectionsFiltered, 'id');
if ($sectionIdFilter !== '' && in_array((int)$sectionIdFilter, array_map('intval', $sectionIdsFiltered))) {
    $stmtSt = $pdo->prepare("SELECT s.id, s.first_name, s.last_name, s.lrn FROM students s WHERE s.section_id = ? AND s.status = 'active' ORDER BY s.last_name, s.first_name");
    $stmtSt->execute([$sectionIdFilter]);
    $studentsFiltered = $stmtSt->fetchAll();
}

// If student_id is set but filters aren't, derive strand_grade and section from student for UX
if ($studentId && ($strandGradeRaw === '' || $sectionIdFilter === '')) {
    $rowStmt = $pdo->prepare("SELECT s.section_id, sec.grade_level, sec.strand FROM students s LEFT JOIN sections sec ON s.section_id = sec.id WHERE s.id = ?");
    $rowStmt->execute([$studentId]);
    $studentSection = $rowStmt->fetch();
    if ($studentSection && $studentSection['section_id']) {
        if ($sectionIdFilter === '') $sectionIdFilter = $studentSection['section_id'];
        if ($strandGradeRaw === '' && $studentSection['grade_level'] !== null) {
            $gradeLevel = (int) $studentSection['grade_level'];
            $strandFilter = $studentSection['strand'] ?? '';
            $strandGradeRaw = $gradeLevel . '|' . $strandFilter;
            if (!$sectionsFiltered && $gradeLevel) {
                $secSql = "SELECT sec.id, sec.section_name, sec.grade_level, sec.strand
                    FROM sections sec
                    INNER JOIN students st ON st.section_id = sec.id AND st.status = 'active' AND st.school_year = " . $pdo->quote(SCHOOL_YEAR) . "
                    WHERE sec.grade_level = ? AND sec.school_year = " . $pdo->quote(SCHOOL_YEAR);
                $secParams = [$gradeLevel];
                if ($strandFilter === '' || $strandFilter === null) {
                    $secSql .= " AND (sec.strand IS NULL OR sec.strand = '')";
                } else {
                    $secSql .= " AND sec.strand = ?";
                    $secParams[] = $strandFilter;
                }
                $secSql .= " GROUP BY sec.id ORDER BY sec.section_name";
                $stmtSec = $pdo->prepare($secSql);
                $stmtSec->execute($secParams);
                $sectionsFiltered = $stmtSec->fetchAll();
            }
            if (empty($studentsFiltered) && $sectionIdFilter) {
                $stmtSt = $pdo->prepare("SELECT s.id, s.first_name, s.last_name, s.lrn FROM students s WHERE s.section_id = ? AND s.status = 'active' ORDER BY s.last_name, s.first_name");
                $stmtSt->execute([$sectionIdFilter]);
                $studentsFiltered = $stmtSt->fetchAll();
            }
        }
    }
}

$student = null;
$grades = [];
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

<!-- Filters: Strand/Grade → Section → Student (auto-fetch on select) -->
<div class="bg-white border border-gray-200 rounded-xl p-5 mb-6">
    <form method="GET" id="reportFilterForm" class="space-y-4">
        <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
            <div>
                <label class="form-label">Strand / Grade</label>
                <select name="strand_grade" id="strand_grade" class="form-select">
                    <option value="">Select strand/grade...</option>
                    <?php foreach ($strandGradeOptions as $sg): ?>
                        <?php
                        $val = (int)$sg['grade_level'] . '|' . ($sg['strand'] ?? '');
                        $label = 'Grade ' . $sg['grade_level'];
                        if (!empty($sg['strand'])) $label .= ' - ' . $sg['strand'];
                        ?>
                        <option value="<?= htmlspecialchars($val) ?>" <?= $strandGradeRaw === $val ? 'selected' : '' ?>><?= sanitize($label) ?></option>
                    <?php endforeach; ?>
                </select>
            </div>
            <div>
                <label class="form-label">Section</label>
                <select name="section_id" id="section_id" class="form-select" <?= empty($sectionsFiltered) ? 'disabled' : '' ?>>
                    <option value="">Select section...</option>
                    <?php foreach ($sectionsFiltered as $sec): ?>
                        <option value="<?= (int)$sec['id'] ?>" <?= $sectionIdFilter == $sec['id'] ? 'selected' : '' ?>>
                            <?= sanitize($sec['section_name']) ?>
                        </option>
                    <?php endforeach; ?>
                </select>
            </div>
            <div>
                <label class="form-label">Student</label>
                <select name="student_id" id="student_id" class="form-select" <?= empty($studentsFiltered) ? 'disabled' : '' ?>>
                    <option value="">Select student...</option>
                    <?php foreach ($studentsFiltered as $s): ?>
                        <option value="<?= (int)$s['id'] ?>" <?= $studentId == $s['id'] ? 'selected' : '' ?>>
                            <?= sanitize($s['last_name'] . ', ' . $s['first_name']) ?>
                        </option>
                    <?php endforeach; ?>
                </select>
            </div>
        </div>
        <div class="flex flex-wrap items-center gap-2">
            <?php if ($student): ?>
                <button type="button" onclick="window.print()" class="btn btn-secondary btn-sm no-print">
                    <i class="fas fa-print"></i> Print
                </button>
            <?php endif; ?>
        </div>
    </form>
</div>

<script>
document.addEventListener('DOMContentLoaded', function() {
    var form = document.getElementById('reportFilterForm');
    var strandGrade = document.getElementById('strand_grade');
    var sectionId = document.getElementById('section_id');
    var studentId = document.getElementById('student_id');

    strandGrade.addEventListener('change', function() {
        sectionId.value = '';
        studentId.value = '';
        form.submit();
    });
    sectionId.addEventListener('change', function() {
        studentId.value = '';
        form.submit();
    });
    studentId.addEventListener('change', function() {
        form.submit();
    });
});
</script>

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
