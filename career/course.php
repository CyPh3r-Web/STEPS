<?php
$pageTitle = 'Course Recommendation';
require_once __DIR__ . '/../includes/header.php';
require_once __DIR__ . '/../includes/RandomForestRecommender.php';
requireRole('guidance');

$sectionFilter = $_GET['section'] ?? '';
$searchQuery   = $_GET['search'] ?? '';

// Only Grade 12 sections
$allSections = $pdo->query("
    SELECT * FROM sections WHERE grade_level = 12
    ORDER BY section_name
")->fetchAll();

// Summary
$totalSHS = $pdo->query("
    SELECT COUNT(*) FROM students s
    JOIN sections sec ON s.section_id = sec.id
    WHERE s.status = 'active' AND sec.grade_level = 12
")->fetchColumn();

$generatedCount = $pdo->query("
    SELECT COUNT(DISTINCT cr.student_id) FROM career_recommendations cr
    JOIN students s ON cr.student_id = s.id
    JOIN sections sec ON s.section_id = sec.id
    WHERE cr.recommendation_type = 'course' AND sec.grade_level = 12
")->fetchColumn();

$avgEmpRaw = $pdo->query("
    SELECT AVG(cr.employability_score) FROM career_recommendations cr
    JOIN students s ON cr.student_id = s.id
    JOIN sections sec ON s.section_id = sec.id
    WHERE cr.recommendation_type = 'course' AND sec.grade_level = 12
")->fetchColumn();
$avgEmp = $avgEmpRaw ? (float)$avgEmpRaw : 0;
$empLvl = getEmployabilityLevel($avgEmp);

// Student list
$listQuery = "
    SELECT s.id, s.first_name, s.last_name, s.lrn,
           sec.section_name, sec.grade_level,
           st.strand_code, st.strand_name,
           nai.entrance_exam_score, nai.skills,
           cr.top_course_1, cr.top_course_2, cr.top_course_3,
           cr.employability_score, cr.employability_level,
           cr.strand_match, cr.recommended_strand,
           cr.created_at AS rec_generated_at
    FROM students s
    JOIN sections sec ON s.section_id = sec.id
    LEFT JOIN strands st ON s.strand_id = st.id
    LEFT JOIN non_academic_indicators nai ON nai.student_id = s.id
    LEFT JOIN career_recommendations cr
        ON cr.student_id = s.id AND cr.recommendation_type = 'course'
    WHERE s.status = 'active' AND sec.grade_level = 12
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

$mismatchCount = count(array_filter($students, fn($s) => isset($s['strand_match']) && $s['strand_match'] === '0'));

require_once __DIR__ . '/../includes/sidebar.php';
?>

<!-- Summary Cards -->
<div class="grid grid-cols-1 md:grid-cols-4 gap-5 mb-6">
    <div class="stat-card" style="background:#f0fdf4;">
        <div class="flex items-center justify-between mb-2">
            <span class="text-sm font-medium text-gray-600">Grade 12 Students</span>
            <div class="w-10 h-10 rounded-lg flex items-center justify-center" style="background:#dcfce7;">
                <i class="fas fa-user-graduate" style="color:#166534;"></i>
            </div>
        </div>
        <p class="text-3xl font-bold text-gray-800"><?= $totalSHS ?></p>
    </div>
    <div class="stat-card" style="background:#eff6ff;">
        <div class="flex items-center justify-between mb-2">
            <span class="text-sm font-medium text-gray-600">Recommendations Generated</span>
            <div class="w-10 h-10 rounded-lg flex items-center justify-center" style="background:#dbeafe;">
                <i class="fas fa-check-circle" style="color:#1d4ed8;"></i>
            </div>
        </div>
        <p class="text-3xl font-bold text-gray-800"><?= $generatedCount ?></p>
    </div>
    <div class="stat-card" style="background:#fef2f2;">
        <div class="flex items-center justify-between mb-2">
            <span class="text-sm font-medium text-gray-600">Strand Mismatches</span>
            <div class="w-10 h-10 rounded-lg flex items-center justify-center" style="background:#fee2e2;">
                <i class="fas fa-exclamation-circle" style="color:#b91c1c;"></i>
            </div>
        </div>
        <p class="text-3xl font-bold text-gray-800"><?= $mismatchCount ?></p>
    </div>
    <div class="stat-card" style="background:#fefce8;">
        <div class="flex items-center justify-between mb-2">
            <span class="text-sm font-medium text-gray-600">Avg. readiness (WI)</span>
            <div class="w-10 h-10 rounded-lg flex items-center justify-center" style="background:#fef08a;">
                <i class="fas fa-briefcase" style="color:#854d0e;"></i>
            </div>
        </div>
        <p class="text-3xl font-bold text-gray-800"><?= $avgEmp > 0 ? formatNumber($avgEmp) : '—' ?></p>
        <?php if ($avgEmp > 0): ?>
        <span class="badge badge-<?= $empLvl['color'] === 'emerald' ? 'green' : $empLvl['color'] ?> mt-1"><?= $empLvl['label'] ?></span>
        <?php endif; ?>
    </div>
</div>

<!-- Info Banner -->
<div class="bg-green-50 border border-green-100 rounded-xl p-4 mb-6 flex gap-3 items-start">
    <i class="fas fa-route text-green-500 mt-0.5 text-lg flex-shrink-0"></i>
    <div class="text-sm text-green-800">
        <p class="font-semibold mb-1">Course Recommendation Module — Grade 12</p>
        <p class="text-xs text-green-700"><strong>Random Forest</strong> ranks <strong>Top 3 courses</strong> using SHS Q4, work immersion (in the model), skills, interests, technical level, entrance exam, and career preference. <strong>Employability readiness</strong> in this table equals the <strong>Work Immersion subject grade</strong> (0–100) for counseling—not a blended formula.</p>
    </div>
</div>

<!-- Filters -->
<div class="flex flex-wrap items-center gap-3 mb-5">
    <form method="GET" class="flex flex-wrap items-center gap-3 flex-1">
        <input type="text" name="search" value="<?= sanitize($searchQuery) ?>"
               placeholder="Search name or LRN..."
               class="form-input w-52" onchange="this.form.submit()">
        <select name="section" class="form-select w-48" onchange="this.form.submit()">
            <option value="">All Grade 12 Sections</option>
            <?php foreach ($allSections as $sec): ?>
                <option value="<?= $sec['id'] ?>" <?= $sectionFilter == $sec['id'] ? 'selected' : '' ?>>
                    G<?= $sec['grade_level'] ?> — <?= sanitize($sec['section_name']) ?>
                    <?php if ($sec['strand']): ?>(<?= sanitize($sec['strand']) ?>)<?php endif; ?>
                </option>
            <?php endforeach; ?>
        </select>
        <?php if ($searchQuery || $sectionFilter): ?>
        <a href="<?= BASE_URL ?>career/course.php" class="btn btn-secondary btn-sm">
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
                    <th>Section</th>
                    <th>Current Strand</th>
                    <th>Readiness (WI)</th>
                    <th>Top 3 Recommended Courses</th>
                    <th>Strand Match</th>
                    <th>Status</th>
                    <th class="no-print">Action</th>
                </tr>
            </thead>
            <tbody>
                <?php foreach ($students as $stu): ?>
                <?php $el = $stu['employability_score'] ? getEmployabilityLevel($stu['employability_score']) : null; ?>
                <tr>
                    <td>
                        <div class="font-medium text-gray-900"><?= sanitize($stu['last_name'] . ', ' . $stu['first_name']) ?></div>
                        <div class="text-xs text-gray-400"><?= sanitize($stu['lrn']) ?></div>
                    </td>
                    <td>
                        <div><?= sanitize($stu['section_name']) ?></div>
                        <span class="text-xs text-gray-400">Grade <?= $stu['grade_level'] ?></span>
                    </td>
                    <td>
                        <?php if ($stu['strand_code']): ?>
                            <span class="badge badge-blue"><?= sanitize($stu['strand_code']) ?></span>
                        <?php else: ?>
                            <span class="text-xs text-gray-400">—</span>
                        <?php endif; ?>
                    </td>
                    <td>
                        <?php if ($stu['employability_score'] && $el): ?>
                            <div class="font-semibold text-sm"><?= formatNumber($stu['employability_score']) ?></div>
                            <span class="badge badge-<?= $el['color'] === 'emerald' ? 'green' : $el['color'] ?> mt-1 text-[10px]"><?= $el['label'] ?></span>
                        <?php else: ?>
                            <span class="text-xs text-gray-400">—</span>
                        <?php endif; ?>
                    </td>
                    <td>
                        <?php if (!empty($stu['top_course_1'])): ?>
                            <div class="space-y-1">
                                <div class="flex items-center gap-1.5 text-xs">
                                    <span class="w-5 h-5 bg-green-600 text-white rounded-full text-center leading-5 font-bold flex-shrink-0">1</span>
                                    <span class="font-medium text-gray-900"><?= sanitize($stu['top_course_1']) ?></span>
                                </div>
                                <?php if ($stu['top_course_2']): ?>
                                <div class="flex items-center gap-1.5 text-xs text-gray-500">
                                    <span class="w-5 h-5 bg-green-400 text-white rounded-full text-center leading-5 font-bold flex-shrink-0">2</span>
                                    <?= sanitize($stu['top_course_2']) ?>
                                </div>
                                <?php endif; ?>
                                <?php if ($stu['top_course_3']): ?>
                                <div class="flex items-center gap-1.5 text-xs text-gray-400">
                                    <span class="w-5 h-5 bg-green-100 text-green-700 rounded-full text-center leading-5 font-bold flex-shrink-0">3</span>
                                    <?= sanitize($stu['top_course_3']) ?>
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
                        <?php if ($stu['top_course_1']): ?>
                            <?php if ($stu['strand_match']): ?>
                                <span class="badge badge-green"><i class="fas fa-check mr-1"></i>Match</span>
                            <?php else: ?>
                                <span class="badge badge-red"><i class="fas fa-times mr-1"></i>Mismatch</span>
                                <?php if ($stu['recommended_strand']): ?>
                                <div class="text-[10px] text-gray-500 mt-1">Suggested: <?= sanitize($stu['recommended_strand']) ?></div>
                                <?php endif; ?>
                            <?php endif; ?>
                        <?php else: ?>
                            <span class="text-xs text-gray-400">—</span>
                        <?php endif; ?>
                    </td>
                    <td>
                        <?php if (!empty($stu['top_course_1'])): ?>
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
                        <i class="fas fa-route text-3xl mb-2 block text-gray-300"></i>
                        No Grade 12 students found.
                        <?php if (!$sectionFilter && !$searchQuery): ?>
                        <br><span class="text-xs">Add Grade 12 sections and students to use this module.</span>
                        <?php endif; ?>
                    </td>
                </tr>
                <?php endif; ?>
            </tbody>
        </table>
    </div>
</div>

<?php require_once __DIR__ . '/../includes/footer.php'; ?>
