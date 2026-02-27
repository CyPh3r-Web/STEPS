<?php
$pageTitle = 'Generate Career Recommendations';
require_once __DIR__ . '/../includes/header.php';
requireLogin();

$sections = $pdo->query("SELECT * FROM sections ORDER BY grade_level, section_name")->fetchAll();
$success = '';
$error = '';
$generated = 0;

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $sectionId = $_POST['section_id'] ?? '';
    $schoolYear = sanitize($_POST['school_year'] ?? SCHOOL_YEAR);

    $studentQuery = "SELECT s.id, s.strand_id, st.strand_code, st.strand_name FROM students s
                     LEFT JOIN strands st ON s.strand_id = st.id
                     WHERE s.status = 'active'";
    $studentParams = [];
    if ($sectionId) {
        $studentQuery .= " AND s.section_id = ?";
        $studentParams[] = $sectionId;
    }

    $studentStmt = $pdo->prepare($studentQuery);
    $studentStmt->execute($studentParams);
    $students = $studentStmt->fetchAll();

    foreach ($students as $student) {
        // Calculate average grade
        $gradeStmt = $pdo->prepare("SELECT AVG(grade) as avg_grade FROM grades WHERE student_id = ?");
        $gradeStmt->execute([$student['id']]);
        $avgGrade = $gradeStmt->fetch()['avg_grade'];

        if ($avgGrade === null) continue;

        // Get work immersion rating
        $wiStmt = $pdo->prepare("SELECT rating FROM work_immersion WHERE student_id = ? ORDER BY school_year DESC LIMIT 1");
        $wiStmt->execute([$student['id']]);
        $wiRating = $wiStmt->fetch()['rating'] ?? $avgGrade;

        // Employability score = weighted average of grades and work immersion
        $employabilityScore = ($avgGrade * 0.6) + ($wiRating * 0.4);
        $empLevel = getEmployabilityLevel($employabilityScore);

        // Determine best strand based on subject performance
        $subjectPerf = $pdo->prepare("SELECT sub.strand_id, AVG(g.grade) as avg_sub_grade
            FROM grades g JOIN subjects sub ON g.subject_id = sub.id
            WHERE g.student_id = ? AND sub.strand_id IS NOT NULL
            GROUP BY sub.strand_id ORDER BY avg_sub_grade DESC LIMIT 1");
        $subjectPerf->execute([$student['id']]);
        $bestStrand = $subjectPerf->fetch();

        $recommendedStrandId = $bestStrand ? $bestStrand['strand_id'] : $student['strand_id'];

        // Get recommended strand info
        $strandStmt = $pdo->prepare("SELECT * FROM strands WHERE id = ?");
        $strandStmt->execute([$recommendedStrandId]);
        $recStrand = $strandStmt->fetch();

        // Get courses for recommended strand
        $courseStmt = $pdo->prepare("SELECT course_name, career_pathway FROM strand_course_mapping WHERE strand_id = ?");
        $courseStmt->execute([$recommendedStrandId]);
        $courses = $courseStmt->fetchAll();

        $courseNames = array_column($courses, 'course_name');
        $careerPaths = array_unique(array_column($courses, 'career_pathway'));

        // Check strand match
        $strandMatch = ($recommendedStrandId == $student['strand_id']) ? 1 : 0;
        $mismatchRemarks = !$strandMatch
            ? "Student's current strand ({$student['strand_code']}) may not align with their strongest academic performance areas."
            : null;

        // Delete existing recommendation for this student and school year
        $delStmt = $pdo->prepare("DELETE FROM career_recommendations WHERE student_id = ? AND school_year = ?");
        $delStmt->execute([$student['id'], $schoolYear]);

        // Insert new recommendation
        $insertStmt = $pdo->prepare("INSERT INTO career_recommendations
            (student_id, recommended_strand, recommended_courses, employability_score, employability_level, strand_match, mismatch_remarks, career_pathways, generated_by, school_year)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)");
        $insertStmt->execute([
            $student['id'],
            $recStrand['strand_name'] ?? 'General',
            implode(', ', $courseNames),
            $employabilityScore,
            $empLevel['level'],
            $strandMatch,
            $mismatchRemarks,
            implode(', ', $careerPaths),
            $_SESSION['user_id'],
            $schoolYear
        ]);

        $generated++;
    }

    $success = "Successfully generated recommendations for $generated student(s).";
}

require_once __DIR__ . '/../includes/sidebar.php';
?>

<a href="<?= BASE_URL ?>career/index.php" class="inline-flex items-center gap-2 text-sm text-gray-500 hover:text-gray-700 mb-6">
    <i class="fas fa-arrow-left"></i> Back to Career Pathway
</a>

<?php if ($success): ?>
<script>
document.addEventListener('DOMContentLoaded', function() {
    Swal.fire({
        ...swalDefaults,
        icon: 'success',
        title: 'Recommendations Generated',
        text: <?= json_encode($success) ?>,
        confirmButtonColor: '#2563eb'
    });
});
</script>
<?php endif; ?>
<?php if ($error): ?>
<script>
document.addEventListener('DOMContentLoaded', function() {
    Swal.fire({
        ...swalDefaults,
        icon: 'error',
        title: 'Error',
        text: <?= json_encode($error) ?>,
        confirmButtonColor: '#2563eb'
    });
});
</script>
<?php endif; ?>

<div class="max-w-xl">
    <div class="bg-white border border-gray-200 rounded-xl p-6">
        <h3 class="text-base font-semibold text-gray-900 mb-2">Generate Career Recommendations</h3>
        <p class="text-sm text-gray-500 mb-6">
            This will analyze each student's grades and work immersion performance to calculate their
            employability readiness score and generate strand/course recommendations.
        </p>

        <div class="bg-blue-50 border border-blue-100 rounded-lg p-4 mb-6">
            <h4 class="text-sm font-semibold text-blue-800 mb-2">How It Works</h4>
            <ul class="text-xs text-blue-700 space-y-1">
                <li><i class="fas fa-check mr-2"></i>Employability Score = (Avg Grades × 60%) + (Work Immersion × 40%)</li>
                <li><i class="fas fa-check mr-2"></i>Best strand is determined by highest subject area performance</li>
                <li><i class="fas fa-check mr-2"></i>Strand match checks if current strand aligns with recommendation</li>
                <li><i class="fas fa-check mr-2"></i>Course recommendations are mapped from the strand-course database</li>
            </ul>
        </div>

        <form method="POST">
            <div class="mb-5">
                <label class="form-label">Section (Optional)</label>
                <select name="section_id" class="form-select">
                    <option value="">All Sections</option>
                    <?php foreach ($sections as $sec): ?>
                        <option value="<?= $sec['id'] ?>">
                            <?= sanitize($sec['section_name']) ?> (G<?= $sec['grade_level'] ?>)
                        </option>
                    <?php endforeach; ?>
                </select>
                <p class="text-xs text-gray-400 mt-1">Leave blank to generate for all students.</p>
            </div>
            <div class="mb-6">
                <label class="form-label">School Year</label>
                <input type="text" name="school_year" class="form-input" value="<?= SCHOOL_YEAR ?>">
            </div>
            <button type="button" class="btn btn-primary"
                    onclick="confirmSubmit(this.closest('form'), 'Generate Recommendations?', 'This will regenerate all recommendations for the selected scope.', 'Yes, generate')">
                <i class="fas fa-magic"></i> Generate Recommendations
            </button>
        </form>
    </div>
</div>

<?php require_once __DIR__ . '/../includes/footer.php'; ?>
