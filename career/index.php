<?php
$pageTitle = 'Career Pathway';
require_once __DIR__ . '/../includes/header.php';
requireLogin();

$sectionFilter = $_GET['section'] ?? '';
$allSections = $pdo->query("SELECT * FROM sections ORDER BY grade_level, section_name")->fetchAll();
$g12Sections = array_filter($allSections, fn($s) => $s['grade_level'] == 12);
$success = '';
$error = '';

// Handle Generate — Grade 12 students only, 30/70 formula
if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['action']) && $_POST['action'] === 'generate') {
    $sectionId = $_POST['section_id'] ?? '';
    $schoolYear = sanitize($_POST['school_year'] ?? SCHOOL_YEAR);

    $studentQuery = "SELECT s.id, s.strand_id, st.strand_code, st.strand_name
        FROM students s
        JOIN sections sec ON s.section_id = sec.id
        LEFT JOIN strands st ON s.strand_id = st.id
        WHERE s.status = 'active' AND sec.grade_level = 12";
    $studentParams = [];
    if ($sectionId) { $studentQuery .= " AND s.section_id = ?"; $studentParams[] = $sectionId; }

    $studentStmt = $pdo->prepare($studentQuery);
    $studentStmt->execute($studentParams);
    $genStudents = $studentStmt->fetchAll();
    $generated = 0;

    foreach ($genStudents as $student) {
        // Only Grade 12 grades for this school year
        $gradeStmt = $pdo->prepare("SELECT AVG(g.grade) as avg_grade
            FROM grades g
            JOIN students s ON g.student_id = s.id
            JOIN sections sec ON s.section_id = sec.id
            WHERE g.student_id = ? AND sec.grade_level = 12 AND g.school_year = ?");
        $gradeStmt->execute([$student['id'], $schoolYear]);
        $avgGrade = $gradeStmt->fetch()['avg_grade'];
        if ($avgGrade === null) continue;

        // Work Immersion / Practicum rating
        $wiStmt = $pdo->prepare("SELECT rating FROM work_immersion WHERE student_id = ? ORDER BY school_year DESC LIMIT 1");
        $wiStmt->execute([$student['id']]);
        $wiRow = $wiStmt->fetch();
        $wiRating = $wiRow['rating'] ?? null;

        // Employability: 30% G12 grades + 70% Work Immersion
        if ($wiRating !== null) {
            $employabilityScore = ($avgGrade * 0.3) + ($wiRating * 0.7);
        } else {
            $employabilityScore = $avgGrade;
        }
        $empLevel = getEmployabilityLevel($employabilityScore);

        // Best strand based on G12 specialized subject performance
        $subjectPerf = $pdo->prepare("SELECT sub.strand_id, AVG(g.grade) as avg_sub_grade
            FROM grades g
            JOIN subjects sub ON g.subject_id = sub.id
            JOIN students s ON g.student_id = s.id
            JOIN sections sec ON s.section_id = sec.id
            WHERE g.student_id = ? AND sub.strand_id IS NOT NULL AND sec.grade_level = 12
            GROUP BY sub.strand_id ORDER BY avg_sub_grade DESC LIMIT 1");
        $subjectPerf->execute([$student['id']]);
        $bestStrand = $subjectPerf->fetch();
        $recommendedStrandId = $bestStrand ? $bestStrand['strand_id'] : $student['strand_id'];

        $strandStmt = $pdo->prepare("SELECT * FROM strands WHERE id = ?");
        $strandStmt->execute([$recommendedStrandId]);
        $recStrand = $strandStmt->fetch();

        $courseStmt = $pdo->prepare("SELECT course_name, career_pathway FROM strand_course_mapping WHERE strand_id = ?");
        $courseStmt->execute([$recommendedStrandId]);
        $courses = $courseStmt->fetchAll();
        $courseNames = array_column($courses, 'course_name');
        $careerPaths = array_unique(array_column($courses, 'career_pathway'));

        $strandMatch = ($recommendedStrandId == $student['strand_id']) ? 1 : 0;
        $mismatchRemarks = !$strandMatch
            ? "Student's current strand ({$student['strand_code']}) may not align with their strongest academic performance areas."
            : null;

        $delStmt = $pdo->prepare("DELETE FROM career_recommendations WHERE student_id = ? AND school_year = ?");
        $delStmt->execute([$student['id'], $schoolYear]);

        $insertStmt = $pdo->prepare("INSERT INTO career_recommendations
            (student_id, recommended_strand, recommended_courses, employability_score, employability_level, strand_match, mismatch_remarks, career_pathways, generated_by, school_year)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)");
        $insertStmt->execute([
            $student['id'], $recStrand['strand_name'] ?? 'General', implode(', ', $courseNames),
            $employabilityScore, $empLevel['level'], $strandMatch, $mismatchRemarks,
            implode(', ', $careerPaths), $_SESSION['user_id'], $schoolYear
        ]);
        $generated++;
    }
    $success = "Successfully generated recommendations for $generated Grade 12 student(s).";
}

$query = "SELECT cr.*, s.first_name, s.last_name, s.lrn,
          sec.section_name, sec.grade_level, st.strand_code, st.strand_name
          FROM career_recommendations cr
          JOIN students s ON cr.student_id = s.id
          LEFT JOIN sections sec ON s.section_id = sec.id
          LEFT JOIN strands st ON s.strand_id = st.id
          WHERE s.status = 'active'";
$params = [];
if ($sectionFilter) { $query .= " AND s.section_id = ?"; $params[] = $sectionFilter; }
$query .= " ORDER BY cr.created_at DESC";
$stmt = $pdo->prepare($query);
$stmt->execute($params);
$recommendations = $stmt->fetchAll();
$mismatchCount = count(array_filter($recommendations, fn($r) => !$r['strand_match']));

require_once __DIR__ . '/../includes/sidebar.php';
?>

<?php if ($success): ?>
<script>
document.addEventListener('DOMContentLoaded', function() {
    Swal.fire({ ...swalDefaults, icon: 'success', title: 'Recommendations Generated', text: <?= json_encode($success) ?>, confirmButtonColor: '#2563eb' });
});
</script>
<?php endif; ?>

<!-- Summary -->
<div class="grid grid-cols-1 md:grid-cols-4 gap-5 mb-6">
    <div class="stat-card" style="background:#f8fafc;">
        <div class="flex items-center justify-between mb-2">
            <span class="text-sm font-medium text-gray-600">Total Recommendations</span>
            <div class="w-10 h-10 rounded-lg flex items-center justify-center" style="background:#e2e8f0;">
                <i class="fas fa-list-check" style="color:#475569;"></i>
            </div>
        </div>
        <p class="text-3xl font-bold text-gray-800"><?= count($recommendations) ?></p>
    </div>
    <div class="stat-card" style="background:#f0fdf4;">
        <div class="flex items-center justify-between mb-2">
            <span class="text-sm font-medium text-gray-600">Strand Matches</span>
            <div class="w-10 h-10 rounded-lg flex items-center justify-center" style="background:#dcfce7;">
                <i class="fas fa-check-circle" style="color:#166534;"></i>
            </div>
        </div>
        <p class="text-3xl font-bold text-gray-800"><?= count($recommendations) - $mismatchCount ?></p>
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
    <div class="stat-card" style="background:#eff6ff;">
        <div class="flex items-center justify-between mb-2">
            <span class="text-sm font-medium text-gray-600">Avg. Employability</span>
            <div class="w-10 h-10 rounded-lg flex items-center justify-center" style="background:#dbeafe;">
                <i class="fas fa-briefcase" style="color:#1d4ed8;"></i>
            </div>
        </div>
        <?php
        $avgEmp = count($recommendations) > 0 ? array_sum(array_column($recommendations, 'employability_score')) / count($recommendations) : 0;
        $empLvl = getEmployabilityLevel($avgEmp);
        ?>
        <p class="text-3xl font-bold text-gray-800"><?= formatNumber($avgEmp) ?></p>
        <span class="badge badge-<?= $empLvl['color'] === 'emerald' ? 'green' : $empLvl['color'] ?> mt-1"><?= $empLvl['label'] ?></span>
    </div>
</div>

<!-- Actions -->
<div class="flex flex-wrap items-center justify-between gap-4 mb-6">
    <form method="GET" class="flex items-center gap-3">
        <select name="section" class="form-select w-48" onchange="this.form.submit()">
            <option value="">All Sections</option>
            <?php foreach ($allSections as $sec): ?>
                <option value="<?= $sec['id'] ?>" <?= $sectionFilter == $sec['id'] ? 'selected' : '' ?>><?= sanitize($sec['section_name']) ?> (G<?= $sec['grade_level'] ?>)</option>
            <?php endforeach; ?>
        </select>
    </form>
    <div class="flex gap-2">
        <button onclick="openModal('generateModal')" class="btn btn-primary btn-sm">
            <i class="fas fa-magic"></i> Generate Recommendations
        </button>
        <button onclick="exportTableToCSV('careerTable', 'career_recommendations.csv')" class="btn btn-secondary btn-sm no-print">
            <i class="fas fa-download"></i> Export
        </button>
    </div>
</div>

<!-- Table -->
<div class="bg-white border border-gray-200 rounded-xl overflow-hidden">
    <div class="overflow-x-auto">
        <table class="steps-table" id="careerTable">
            <thead>
                <tr>
                    <th>Student</th><th>Section</th><th>Current Strand</th><th>Recommended Strand</th>
                    <th>Employability Score</th><th>Level</th><th>Strand Match</th><th>Recommended Courses</th>
                </tr>
            </thead>
            <tbody>
                <?php foreach ($recommendations as $rec): ?>
                    <?php $empLevel = getEmployabilityLevel($rec['employability_score']); ?>
                    <tr>
                        <td><a href="<?= BASE_URL ?>students/view.php?id=<?= $rec['student_id'] ?>" class="font-medium text-blue-600 hover:underline"><?= sanitize($rec['last_name'] . ', ' . $rec['first_name']) ?></a></td>
                        <td><?= sanitize($rec['section_name'] ?? 'N/A') ?></td>
                        <td><span class="badge badge-blue"><?= sanitize($rec['strand_code'] ?? 'N/A') ?></span></td>
                        <td class="font-medium"><?= sanitize($rec['recommended_strand']) ?></td>
                        <td class="font-semibold"><?= formatNumber($rec['employability_score']) ?></td>
                        <td><span class="badge badge-<?= $empLevel['color'] === 'emerald' ? 'green' : $empLevel['color'] ?>"><?= $empLevel['label'] ?></span></td>
                        <td>
                            <?php if ($rec['strand_match']): ?>
                                <span class="badge badge-green"><i class="fas fa-check mr-1"></i> Match</span>
                            <?php else: ?>
                                <span class="badge badge-red"><i class="fas fa-times mr-1"></i> Mismatch</span>
                            <?php endif; ?>
                        </td>
                        <td class="text-[11px] leading-snug max-w-xs whitespace-normal break-words" title="<?= sanitize($rec['recommended_courses']) ?>">
                            <?= sanitize($rec['recommended_courses'] ?? 'N/A') ?>
                        </td>
                    </tr>
                <?php endforeach; ?>
                <?php if (empty($recommendations)): ?>
                    <tr><td colspan="8" class="text-center text-gray-400 py-8">No recommendations generated yet. Click "Generate Recommendations" to start.</td></tr>
                <?php endif; ?>
            </tbody>
        </table>
    </div>
</div>

<!-- GENERATE MODAL -->
<div class="modal-overlay" id="generateModal">
    <div class="modal-content" style="max-width:480px;">
        <div class="flex items-center justify-between mb-6">
            <div class="flex items-center gap-3">
                <div class="w-10 h-10 bg-blue-50 rounded-lg flex items-center justify-center modal-icon"><i class="fas fa-magic text-blue-600"></i></div>
                <h3 class="text-base font-semibold text-gray-900">Generate Recommendations</h3>
            </div>
            <button onclick="closeModal('generateModal')" class="modal-close"><i class="fas fa-times"></i></button>
        </div>

        <p class="text-sm text-gray-500 mb-4">Analyze <strong>Grade 12</strong> student performance and internship/practicum ratings to generate career pathway recommendations.</p>

        <div class="bg-blue-50 border border-blue-100 rounded-lg p-4 mb-5">
            <h4 class="text-xs font-semibold text-blue-800 mb-2">How It Works</h4>
            <ul class="text-xs text-blue-700 space-y-1">
                <li><i class="fas fa-check mr-2"></i>Only <strong>Grade 12</strong> students and their G12 grades are used</li>
                <li><i class="fas fa-check mr-2"></i>Employability = (G12 Avg Grades x 30%) + (Work Immersion/Practicum x 70%)</li>
                <li><i class="fas fa-check mr-2"></i>Best strand determined by highest specialized subject performance</li>
                <li><i class="fas fa-check mr-2"></i>Strand match flagged if current strand is misaligned</li>
            </ul>
        </div>

        <form method="POST" id="generateForm">
            <input type="hidden" name="action" value="generate">
            <div class="space-y-4">
                <div>
                    <label class="form-label">Grade 12 Section (Optional)</label>
                    <select name="section_id" class="form-select">
                        <option value="">All Grade 12 Sections</option>
                        <?php foreach ($g12Sections as $sec): ?>
                            <option value="<?= $sec['id'] ?>"><?= sanitize($sec['section_name']) ?> (G12 — <?= sanitize($sec['strand'] ?? 'General') ?>)</option>
                        <?php endforeach; ?>
                    </select>
                    <p class="text-xs text-gray-400 mt-1">Leave blank to generate for all Grade 12 students.</p>
                </div>
                <div>
                    <label class="form-label">School Year</label>
                    <input type="text" name="school_year" class="form-input" value="<?= SCHOOL_YEAR ?>">
                </div>
            </div>
            <div class="flex items-center justify-end gap-4 mt-6 pt-5 border-t border-gray-200">
                <button type="button" onclick="closeModal('generateModal')" class="btn btn-secondary">Cancel</button>
                <button type="button" class="btn btn-primary"
                        onclick="confirmSubmit(document.getElementById('generateForm'), 'Generate Recommendations?', 'This will regenerate career recommendations for Grade 12 students in the selected scope.', 'Yes, generate')">
                    <i class="fas fa-magic"></i> Generate
                </button>
            </div>
        </form>
    </div>
</div>

<?php require_once __DIR__ . '/../includes/footer.php'; ?>
