<?php
$pageTitle = 'Strand Recommendation';
require_once __DIR__ . '/../includes/header.php';
require_once __DIR__ . '/../includes/RandomForestRecommender.php';
requireRole('guidance');

$sectionFilter = $_GET['section'] ?? '';
$searchQuery   = $_GET['search'] ?? '';

// Only JHS sections (G7-G10)
$allSections = $pdo->query("
    SELECT * FROM sections WHERE grade_level BETWEEN 7 AND 10
    ORDER BY grade_level, section_name
")->fetchAll();

// Summary counts
$totalJHS = $pdo->query("
    SELECT COUNT(*) FROM students s
    JOIN sections sec ON s.section_id = sec.id
    WHERE s.status = 'active' AND sec.grade_level BETWEEN 7 AND 10
")->fetchColumn();

$generatedCount = $pdo->query("
    SELECT COUNT(DISTINCT cr.student_id) FROM career_recommendations cr
    JOIN students s ON cr.student_id = s.id
    JOIN sections sec ON s.section_id = sec.id
    WHERE cr.recommendation_type = 'strand' AND sec.grade_level BETWEEN 7 AND 10
")->fetchColumn();

$pendingCount = $totalJHS - $generatedCount;

// Student list
$listQuery = "
    SELECT s.id, s.first_name, s.last_name, s.lrn,
           sec.section_name, sec.grade_level,
           nai.entrance_exam_score, nai.skills,
           cr.top_strand_1, cr.top_strand_2, cr.top_strand_3,
           cr.score_breakdown, cr.created_at AS rec_generated_at
    FROM students s
    JOIN sections sec ON s.section_id = sec.id
    LEFT JOIN non_academic_indicators nai ON nai.student_id = s.id
    LEFT JOIN career_recommendations cr
        ON cr.student_id = s.id AND cr.recommendation_type = 'strand'
    WHERE s.status = 'active' AND sec.grade_level BETWEEN 7 AND 10
";
$params = [];
if ($sectionFilter) {
    $listQuery .= " AND s.section_id = ?";
    $params[] = $sectionFilter;
}
if ($searchQuery) {
    $listQuery .= " AND (s.first_name LIKE ? OR s.last_name LIKE ? OR s.lrn LIKE ?)";
    $like = "%$searchQuery%";
    $params[] = $like; $params[] = $like; $params[] = $like;
}
$listQuery .= " ORDER BY sec.grade_level, sec.section_name, s.last_name";
$stmt = $pdo->prepare($listQuery);
$stmt->execute($params);
$students = $stmt->fetchAll();

require_once __DIR__ . '/../includes/sidebar.php';
?>

<!-- Summary Cards -->
<div class="grid grid-cols-1 md:grid-cols-3 gap-5 mb-6">
    <div class="stat-card" style="background:#eff6ff;">
        <div class="flex items-center justify-between mb-2">
            <span class="text-sm font-medium text-gray-600">JHS Students (G7–G10)</span>
            <div class="w-10 h-10 rounded-lg flex items-center justify-center" style="background:#dbeafe;">
                <i class="fas fa-user-graduate" style="color:#1d4ed8;"></i>
            </div>
        </div>
        <p class="text-3xl font-bold text-gray-800"><?= $totalJHS ?></p>
    </div>
    <div class="stat-card" style="background:#f0fdf4;">
        <div class="flex items-center justify-between mb-2">
            <span class="text-sm font-medium text-gray-600">Recommendations Generated</span>
            <div class="w-10 h-10 rounded-lg flex items-center justify-center" style="background:#dcfce7;">
                <i class="fas fa-check-circle" style="color:#166534;"></i>
            </div>
        </div>
        <p class="text-3xl font-bold text-gray-800"><?= $generatedCount ?></p>
    </div>
    <div class="stat-card" style="background:#fefce8;">
        <div class="flex items-center justify-between mb-2">
            <span class="text-sm font-medium text-gray-600">Pending</span>
            <div class="w-10 h-10 rounded-lg flex items-center justify-center" style="background:#fef08a;">
                <i class="fas fa-clock" style="color:#854d0e;"></i>
            </div>
        </div>
        <p class="text-3xl font-bold text-gray-800"><?= $pendingCount ?></p>
    </div>
</div>

<!-- Info Banner -->
<div class="bg-indigo-50 border border-indigo-100 rounded-xl p-4 mb-6 flex gap-3 items-start">
    <i class="fas fa-graduation-cap text-indigo-500 mt-0.5 text-lg flex-shrink-0"></i>
    <div class="text-sm text-indigo-800">
        <p class="font-semibold mb-1">Strand Recommendation Module — Grade 7 to Grade 10</p>
        <p class="text-xs text-indigo-700">Uses a <strong>Random Forest</strong> model: academic competency (Q4), skills assessment, interests, technical skill level, entrance exam, and career preference. Parent fields are not used. Output: <strong>Top 3 strands</strong> by majority vote across <?= (int) RandomForestRecommender::N_TREES ?> decision trees — open a student for vote tallies.</p>
    </div>
</div>

<!-- Filters -->
<div class="flex flex-wrap items-center gap-3 mb-5">
    <form method="GET" class="flex flex-wrap items-center gap-3 flex-1">
        <input type="text" name="search" value="<?= sanitize($searchQuery) ?>"
               placeholder="Search name or LRN..."
               class="form-input w-52" onchange="this.form.submit()">
        <select name="section" class="form-select w-48" onchange="this.form.submit()">
            <option value="">All JHS Sections</option>
            <?php foreach ($allSections as $sec): ?>
                <option value="<?= $sec['id'] ?>" <?= $sectionFilter == $sec['id'] ? 'selected' : '' ?>>
                    G<?= $sec['grade_level'] ?> — <?= sanitize($sec['section_name']) ?>
                </option>
            <?php endforeach; ?>
        </select>
        <?php if ($searchQuery || $sectionFilter): ?>
        <a href="<?= BASE_URL ?>career/strand.php" class="btn btn-secondary btn-sm">
            <i class="fas fa-times"></i> Clear
        </a>
        <?php endif; ?>
    </form>
</div>

<!-- Table -->
<div class="bg-white border border-gray-200 rounded-xl overflow-hidden">
    <div class="overflow-x-auto">
        <table class="steps-table">
            <thead>
                <tr>
                    <th>Student</th>
                    <th>LRN</th>
                    <th>Section</th>
                    <th>Grade</th>
                    <th>Exam Score</th>
                    <th>Indicators</th>
                    <th>Top 3 Recommended Strands</th>
                    <th>Status</th>
                    <th class="no-print">Action</th>
                </tr>
            </thead>
            <tbody>
                <?php foreach ($students as $stu): ?>
                <tr>
                    <td class="font-medium text-gray-900"><?= sanitize($stu['last_name'] . ', ' . $stu['first_name']) ?></td>
                    <td class="text-xs text-gray-500"><?= sanitize($stu['lrn']) ?></td>
                    <td><?= sanitize($stu['section_name']) ?></td>
                    <td><span class="badge badge-blue">Grade <?= $stu['grade_level'] ?></span></td>
                    <td class="text-center">
                        <?php if ($stu['entrance_exam_score'] !== null): ?>
                            <span class="font-semibold text-gray-800"><?= number_format($stu['entrance_exam_score'], 1) ?></span>
                        <?php else: ?>
                            <span class="text-xs text-amber-500"><i class="fas fa-exclamation-triangle mr-1"></i>Not set</span>
                        <?php endif; ?>
                    </td>
                    <td class="text-center">
                        <?php if (!empty($stu['skills'])): ?>
                            <span class="badge badge-green text-[10px]"><i class="fas fa-check mr-1"></i>On record</span>
                        <?php else: ?>
                            <span class="badge badge-amber text-[10px]"><i class="fas fa-exclamation-triangle mr-1"></i>Incomplete</span>
                        <?php endif; ?>
                    </td>
                    <td>
                        <?php if (!empty($stu['top_strand_1'])): ?>
                            <div class="space-y-1">
                                <div class="flex items-center gap-1.5 text-xs">
                                    <span class="w-5 h-5 bg-indigo-600 text-white rounded-full text-center leading-5 font-bold flex-shrink-0">1</span>
                                    <span class="font-medium text-gray-900"><?= sanitize($stu['top_strand_1']) ?></span>
                                </div>
                                <?php if ($stu['top_strand_2']): ?>
                                <div class="flex items-center gap-1.5 text-xs text-gray-500">
                                    <span class="w-5 h-5 bg-indigo-300 text-white rounded-full text-center leading-5 font-bold flex-shrink-0">2</span>
                                    <?= sanitize($stu['top_strand_2']) ?>
                                </div>
                                <?php endif; ?>
                                <?php if ($stu['top_strand_3']): ?>
                                <div class="flex items-center gap-1.5 text-xs text-gray-400">
                                    <span class="w-5 h-5 bg-indigo-100 text-indigo-700 rounded-full text-center leading-5 font-bold flex-shrink-0">3</span>
                                    <?= sanitize($stu['top_strand_3']) ?>
                                </div>
                                <?php endif; ?>
                                <div class="text-[10px] text-gray-400 mt-1">
                                    <i class="fas fa-clock mr-1"></i><?= date('M d, Y', strtotime($stu['rec_generated_at'])) ?>
                                </div>
                            </div>
                        <?php else: ?>
                            <span class="text-xs text-gray-400 italic">Not yet generated</span>
                        <?php endif; ?>
                    </td>
                    <td>
                        <?php if (!empty($stu['top_strand_1'])): ?>
                            <span class="badge badge-green"><i class="fas fa-check mr-1"></i>Generated</span>
                        <?php else: ?>
                            <span class="badge badge-amber"><i class="fas fa-clock mr-1"></i>Pending</span>
                        <?php endif; ?>
                    </td>
                    <td class="no-print">
                        <a href="<?= BASE_URL ?>career/student.php?id=<?= $stu['id'] ?>"
                           class="btn btn-primary btn-sm">
                            <i class="fas fa-user-chart"></i> View / Generate
                        </a>
                    </td>
                </tr>
                <?php endforeach; ?>
                <?php if (empty($students)): ?>
                <tr>
                    <td colspan="9" class="text-center text-gray-400 py-10">
                        <i class="fas fa-graduation-cap text-3xl mb-2 block text-gray-300"></i>
                        No Grade 7–10 students found.
                        <?php if (!$sectionFilter && !$searchQuery): ?>
                        <br><span class="text-xs">Add JHS sections and students to use this module.</span>
                        <?php endif; ?>
                    </td>
                </tr>
                <?php endif; ?>
            </tbody>
        </table>
    </div>
</div>

<?php require_once __DIR__ . '/../includes/footer.php'; ?>
