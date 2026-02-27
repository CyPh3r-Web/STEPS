<?php
$pageTitle = 'Student Profile';
require_once __DIR__ . '/../includes/header.php';
requireLogin();

$id = $_GET['id'] ?? 0;
$stmt = $pdo->prepare("SELECT s.*, sec.section_name, sec.grade_level, st.strand_code, st.strand_name
    FROM students s
    LEFT JOIN sections sec ON s.section_id = sec.id
    LEFT JOIN strands st ON s.strand_id = st.id
    WHERE s.id = ?");
$stmt->execute([$id]);
$student = $stmt->fetch();

if (!$student) {
    header('Location: ' . BASE_URL . 'students/index.php');
    exit;
}

$gradesStmt = $pdo->prepare("SELECT g.*, sub.subject_name, sub.subject_code
    FROM grades g
    JOIN subjects sub ON g.subject_id = sub.id
    WHERE g.student_id = ? ORDER BY sub.subject_name, g.quarter");
$gradesStmt->execute([$id]);
$grades = $gradesStmt->fetchAll();

$subjectGrades = [];
foreach ($grades as $g) {
    $subjectGrades[$g['subject_name']]['code'] = $g['subject_code'];
    $subjectGrades[$g['subject_name']][$g['quarter']] = $g['grade'];
}

$avgStmt = $pdo->prepare("SELECT AVG(grade) as avg_grade FROM grades WHERE student_id = ?");
$avgStmt->execute([$id]);
$avgGrade = $avgStmt->fetch()['avg_grade'] ?? 0;

$wiStmt = $pdo->prepare("SELECT * FROM work_immersion WHERE student_id = ? ORDER BY school_year DESC LIMIT 1");
$wiStmt->execute([$id]);
$workImmersion = $wiStmt->fetch();

$crStmt = $pdo->prepare("SELECT * FROM career_recommendations WHERE student_id = ? ORDER BY created_at DESC LIMIT 1");
$crStmt->execute([$id]);
$careerRec = $crStmt->fetch();

$compLevel = getCompetencyLevel($avgGrade);

// Check if student is a top performer in their strand
$topPerformerCheck = $pdo->prepare("SELECT ranked.section_rank, ranked.specialized_avg, st.strand_code FROM (
    SELECT
        s2.id,
        s2.strand_id,
        AVG(g2.grade) as specialized_avg,
        RANK() OVER (PARTITION BY s2.section_id ORDER BY AVG(g2.grade) DESC) as section_rank
    FROM students s2
    JOIN grades g2 ON s2.id = g2.student_id
    JOIN subjects sub2 ON g2.subject_id = sub2.id
    WHERE s2.status = 'active'
      AND sub2.subject_type = 'specialized'
      AND sub2.strand_id = s2.strand_id
      AND s2.section_id = ?
    GROUP BY s2.id
    HAVING AVG(g2.grade) >= 80
) ranked
JOIN strands st ON ranked.strand_id = st.id
WHERE ranked.id = ? AND ranked.section_rank <= 3");
$topPerformerCheck->execute([$student['section_id'], $id]);
$topPerformer = $topPerformerCheck->fetch();

require_once __DIR__ . '/../includes/sidebar.php';
?>

<a href="<?= BASE_URL ?>students/index.php" class="inline-flex items-center gap-2 text-sm text-gray-500 hover:text-gray-700 mb-6">
    <i class="fas fa-arrow-left"></i> Back to Students
</a>

<!-- Student Info Card -->
<div class="bg-white border border-gray-200 rounded-xl p-6 mb-6">
    <div class="flex flex-wrap items-start justify-between gap-4">
        <div class="flex items-center gap-4">
            <div class="w-16 h-16 bg-blue-50 rounded-full flex items-center justify-center">
                <i class="fas fa-user-graduate text-blue-600 text-2xl"></i>
            </div>
            <div>
                <h3 class="text-xl font-bold text-gray-900">
                    <?= sanitize($student['last_name'] . ', ' . $student['first_name'] . ' ' . ($student['middle_name'] ?? '')) ?>
                </h3>
                <p class="text-sm text-gray-500">LRN: <?= sanitize($student['lrn']) ?></p>
                <div class="flex flex-wrap gap-2 mt-2">
                    <span class="badge badge-blue"><?= sanitize($student['strand_code'] ?? 'No Strand') ?></span>
                    <span class="badge badge-<?= $compLevel['color'] === 'emerald' ? 'green' : $compLevel['color'] ?>"><?= $compLevel['label'] ?></span>
                    <?php if ($topPerformer): ?>
                        <span class="inline-flex items-center gap-1 px-2.5 py-0.5 rounded-full text-xs font-semibold bg-amber-50 text-amber-700 border border-amber-200">
                            <i class="fas fa-star text-amber-500"></i>
                            Top <?= $topPerformer['section_rank'] == 1 ? '1st' : ($topPerformer['section_rank'] == 2 ? '2nd' : '3rd') ?> in <?= sanitize($topPerformer['strand_code']) ?>
                        </span>
                    <?php endif; ?>
                </div>
            </div>
        </div>
        <div class="flex gap-2 no-print">
            <a href="<?= BASE_URL ?>students/index.php?edit_id=<?= $student['id'] ?>" class="btn btn-secondary btn-sm">
                <i class="fas fa-edit"></i> Edit
            </a>
            <a href="<?= BASE_URL ?>reports/individual.php?student_id=<?= $student['id'] ?>" class="btn btn-primary btn-sm">
                <i class="fas fa-file-alt"></i> Report
            </a>
        </div>
    </div>

    <div class="grid grid-cols-2 md:grid-cols-4 gap-4 mt-6 pt-6 border-t border-gray-100">
        <div>
            <p class="text-xs text-gray-400">Gender</p>
            <p class="text-sm font-medium"><?= $student['gender'] ?></p>
        </div>
        <div>
            <p class="text-xs text-gray-400">Section</p>
            <p class="text-sm font-medium"><?= sanitize($student['section_name'] ?? 'N/A') ?></p>
        </div>
        <div>
            <p class="text-xs text-gray-400">Grade Level</p>
            <p class="text-sm font-medium"><?= $student['grade_level'] ?? 'N/A' ?></p>
        </div>
        <div>
            <p class="text-xs text-gray-400">School Year</p>
            <p class="text-sm font-medium"><?= sanitize($student['school_year']) ?></p>
        </div>
    </div>
</div>

<!-- Stats Row -->
<div class="grid grid-cols-1 md:grid-cols-3 gap-5 mb-6">
    <div class="stat-card" style="background:#f8fafc;">
        <div class="flex items-center justify-between mb-2">
            <span class="text-sm font-medium text-gray-600">General Average</span>
            <div class="w-10 h-10 rounded-lg flex items-center justify-center" style="background:#e2e8f0;">
                <i class="fas fa-chart-line" style="color:#475569;"></i>
            </div>
        </div>
        <p class="text-3xl font-bold text-gray-800"><?= formatNumber($avgGrade) ?></p>
    </div>
    <div class="stat-card" style="background:#fffbeb;">
        <div class="flex items-center justify-between mb-2">
            <span class="text-sm font-medium text-gray-600">Work Immersion Rating</span>
            <div class="w-10 h-10 rounded-lg flex items-center justify-center" style="background:#fef3c7;">
                <i class="fas fa-briefcase" style="color:#92400e;"></i>
            </div>
        </div>
        <p class="text-3xl font-bold text-gray-800"><?= $workImmersion ? formatNumber($workImmersion['rating']) : 'N/A' ?></p>
    </div>
    <div class="stat-card" style="background:#f0fdf4;">
        <div class="flex items-center justify-between mb-2">
            <span class="text-sm font-medium text-gray-600">Employability Score</span>
            <div class="w-10 h-10 rounded-lg flex items-center justify-center" style="background:#dcfce7;">
                <i class="fas fa-user-graduate" style="color:#166534;"></i>
            </div>
        </div>
        <?php if ($careerRec): ?>
            <?php $empLvl = getEmployabilityLevel($careerRec['employability_score']); ?>
            <p class="text-3xl font-bold text-gray-800"><?= formatNumber($careerRec['employability_score']) ?></p>
            <span class="badge badge-<?= $empLvl['color'] === 'emerald' ? 'green' : $empLvl['color'] ?> mt-1"><?= $empLvl['label'] ?></span>
        <?php else: ?>
            <p class="text-3xl font-bold text-gray-400">N/A</p>
        <?php endif; ?>
    </div>
</div>

<!-- Grades Table -->
<div class="bg-white border border-gray-200 rounded-xl overflow-hidden mb-6">
    <div class="px-6 py-4 border-b border-gray-200">
        <h3 class="text-sm font-semibold text-gray-900">Subject Grades</h3>
    </div>
    <div class="overflow-x-auto">
        <table class="steps-table">
            <thead>
                <tr>
                    <th>Subject</th>
                    <th>Q1</th>
                    <th>Q2</th>
                    <th>Q3</th>
                    <th>Q4</th>
                    <th>Average</th>
                    <th>Status</th>
                </tr>
            </thead>
            <tbody>
                <?php foreach ($subjectGrades as $subName => $data): ?>
                    <?php
                    $q1 = $data['Q1'] ?? null;
                    $q2 = $data['Q2'] ?? null;
                    $q3 = $data['Q3'] ?? null;
                    $q4 = $data['Q4'] ?? null;
                    $vals = array_filter([$q1, $q2, $q3, $q4], fn($v) => $v !== null);
                    $subAvg = count($vals) > 0 ? array_sum($vals) / count($vals) : 0;
                    $subComp = getCompetencyLevel($subAvg);
                    ?>
                    <tr>
                        <td>
                            <span class="font-medium"><?= sanitize($subName) ?></span>
                            <span class="text-xs text-gray-400 ml-1">(<?= sanitize($data['code']) ?>)</span>
                        </td>
                        <td><?= $q1 !== null ? formatNumber($q1) : '-' ?></td>
                        <td><?= $q2 !== null ? formatNumber($q2) : '-' ?></td>
                        <td><?= $q3 !== null ? formatNumber($q3) : '-' ?></td>
                        <td><?= $q4 !== null ? formatNumber($q4) : '-' ?></td>
                        <td class="font-semibold"><?= count($vals) > 0 ? formatNumber($subAvg) : '-' ?></td>
                        <td>
                            <?php if (count($vals) > 0): ?>
                                <span class="badge badge-<?= $subComp['color'] === 'emerald' ? 'green' : $subComp['color'] ?>"><?= $subComp['label'] ?></span>
                            <?php else: ?>
                                -
                            <?php endif; ?>
                        </td>
                    </tr>
                <?php endforeach; ?>
                <?php if (empty($subjectGrades)): ?>
                    <tr><td colspan="7" class="text-center text-gray-400 py-6">No grades recorded.</td></tr>
                <?php endif; ?>
            </tbody>
        </table>
    </div>
</div>

<!-- Career Recommendation -->
<?php if ($careerRec): ?>
<div class="bg-white border border-gray-200 rounded-xl p-6">
    <h3 class="text-sm font-semibold text-gray-900 mb-4">Career Recommendation</h3>
    <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
        <div>
            <p class="text-xs text-gray-400">Recommended Strand</p>
            <p class="text-sm font-medium"><?= sanitize($careerRec['recommended_strand'] ?? 'N/A') ?></p>
        </div>
        <div>
            <p class="text-xs text-gray-400">Recommended Courses</p>
            <p class="text-sm font-medium"><?= sanitize($careerRec['recommended_courses'] ?? 'N/A') ?></p>
        </div>
        <div>
            <p class="text-xs text-gray-400">Career Pathways</p>
            <p class="text-sm font-medium"><?= sanitize($careerRec['career_pathways'] ?? 'N/A') ?></p>
        </div>
        <div>
            <p class="text-xs text-gray-400">Strand Match</p>
            <?php if ($careerRec['strand_match']): ?>
                <span class="badge badge-green"><i class="fas fa-check mr-1"></i> Strand matches recommendation</span>
            <?php else: ?>
                <span class="badge badge-red"><i class="fas fa-exclamation-triangle mr-1"></i> Strand mismatch</span>
                <?php if ($careerRec['mismatch_remarks']): ?>
                    <p class="text-xs text-gray-500 mt-1"><?= sanitize($careerRec['mismatch_remarks']) ?></p>
                <?php endif; ?>
            <?php endif; ?>
        </div>
    </div>
</div>
<?php endif; ?>

<?php require_once __DIR__ . '/../includes/footer.php'; ?>
