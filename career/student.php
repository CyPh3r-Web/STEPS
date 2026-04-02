<?php
$pageTitle = 'Career Pathway — Student';
require_once __DIR__ . '/../includes/header.php';
require_once __DIR__ . '/../includes/RandomForestRecommender.php';
require_once __DIR__ . '/../includes/RecommendationHelpers.php';
requireRole('guidance');

$studentId = (int)($_GET['id'] ?? 0);
if (!$studentId) {
    header('Location: ' . BASE_URL . 'career/index.php');
    exit;
}

// ── Fetch student ─────────────────────────────────────────────────────────────
$stmt = $pdo->prepare("
    SELECT s.*, sec.section_name, sec.grade_level, sec.strand AS section_strand,
           st.strand_code, st.strand_name, st.id AS strand_db_id
    FROM students s
    LEFT JOIN sections sec ON s.section_id = sec.id
    LEFT JOIN strands st ON s.strand_id = st.id
    WHERE s.id = ? AND s.status = 'active'
");
$stmt->execute([$studentId]);
$student = $stmt->fetch();
if (!$student) {
    header('Location: ' . BASE_URL . 'career/index.php');
    exit;
}

$gradeLevel = (int)($student['grade_level'] ?? 0);
$isJHS   = $gradeLevel >= 7 && $gradeLevel <= 10;
$isSHS   = $gradeLevel >= 11;
$recType = $isJHS ? 'strand' : 'course';
$pageTitle = 'Career Pathway — ' . $student['first_name'] . ' ' . $student['last_name'];

// ── Fetch non-academic indicators ─────────────────────────────────────────────
$naiStmt = $pdo->prepare("SELECT * FROM non_academic_indicators WHERE student_id = ?");
$naiStmt->execute([$studentId]);
$nai = $naiStmt->fetch() ?: [];

// ── Handle save non-academic indicators ──────────────────────────────────────
$saveSuccess = '';
$saveError   = '';
if ($_SERVER['REQUEST_METHOD'] === 'POST' && ($_POST['action'] ?? '') === 'save_nai') {
    $skills            = sanitize($_POST['skills'] ?? '');
    $hobbies           = sanitize($_POST['hobbies'] ?? '');
    $careerPreference  = sanitize($_POST['career_preference'] ?? '');
    $technicalLevel    = sanitize($_POST['technical_skill_level'] ?? 'developing');
    $validTech = ['beginner', 'developing', 'proficient', 'advanced'];
    if (!in_array($technicalLevel, $validTech, true)) {
        $technicalLevel = 'developing';
    }
    $examScore = $_POST['entrance_exam_score'] !== '' ? (float) $_POST['entrance_exam_score'] : null;
    $examDate  = $_POST['entrance_exam_date'] ?: null;
    $firstChoice = sanitize($_POST['first_choice_strand_course'] ?? '');

    if (empty($nai)) {
        $ins = $pdo->prepare('INSERT INTO non_academic_indicators
            (student_id, skills, hobbies, career_preference, first_choice_strand_course, technical_skill_level, entrance_exam_score, entrance_exam_date, updated_by)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)');
        $ins->execute([$studentId, $skills, $hobbies, $careerPreference, $firstChoice ?: null, $technicalLevel, $examScore, $examDate, $_SESSION['user_id']]);
    } else {
        $upd = $pdo->prepare('UPDATE non_academic_indicators
            SET skills=?, hobbies=?, career_preference=?, first_choice_strand_course=?, technical_skill_level=?, entrance_exam_score=?, entrance_exam_date=?, updated_by=?
            WHERE student_id=?');
        $upd->execute([$skills, $hobbies, $careerPreference, $firstChoice ?: null, $technicalLevel, $examScore, $examDate, $_SESSION['user_id'], $studentId]);
    }
    // Re-fetch
    $naiStmt->execute([$studentId]);
    $nai = $naiStmt->fetch() ?: [];
    $saveSuccess = 'Non-academic indicators saved successfully.';
}

// ── Handle Generate Recommendation ───────────────────────────────────────────
$genSuccess = '';
$genError   = '';

// Validate generated_by user id against users table to avoid FK errors
$generatedBy = null;
if (isset($_SESSION['user_id'])) {
    $genCheck = $pdo->prepare("SELECT id FROM users WHERE id = ? LIMIT 1");
    $genCheck->execute([$_SESSION['user_id']]);
    if ($genCheck->fetch()) {
        $generatedBy = (int)$_SESSION['user_id'];
    }
}

if ($_SERVER['REQUEST_METHOD'] === 'POST' && ($_POST['action'] ?? '') === 'generate') {

    $naiRequired = !empty($nai)
        && trim($nai['skills'] ?? '') !== ''
        && trim($nai['hobbies'] ?? '') !== ''
        && trim($nai['career_preference'] ?? '') !== ''
        && trim($nai['technical_skill_level'] ?? '') !== ''
        && ($nai['entrance_exam_score'] ?? '') !== '' && (float) ($nai['entrance_exam_score'] ?? 0) > 0;
    if (!$naiRequired) {
        $genError = 'Please complete: Skills assessment, Interests, Career preference, Technical skill level, and Entrance exam score.';
    }

    // ── STRAND RECOMMENDATION (G7-G10) — Random Forest majority vote ───────────
    if ($isJHS && $naiRequired) {
        $q4AvgStmt = $pdo->prepare("SELECT AVG(grade) FROM grades WHERE student_id = ? AND quarter = 'Q4'");
        $q4AvgStmt->execute([$studentId]);
        $q4Avg = (float) ($q4AvgStmt->fetchColumn() ?? 0);

        if ($q4Avg == 0) {
            $genError = 'No 4th quarter grades found for this student. Please encode Q4 grades first.';
        } else {
            $allStrands = $pdo->query('SELECT * FROM strands ORDER BY id')->fetchAll();
            $fVec = RandomForestRecommender::buildFeatureVector($studentId, $nai, $gradeLevel, $q4Avg, 0, 0);
            $rf = RandomForestRecommender::recommendStrands($fVec, $allStrands, $studentId);
            $ranked = $rf['ranked'];
            $top3 = array_slice($ranked, 0, 3);

            $firstStr = trim($nai['first_choice_strand_course'] ?? '');
            $firstMismatch = $firstStr !== '' && !RecommendationHelpers::firstChoiceMatchesTop(
                $firstStr,
                RecommendationHelpers::strandTop3Labels($top3)
            );

            $breakdown = [
                'algorithm'       => 'random_forest_v1',
                'n_trees'         => RandomForestRecommender::N_TREES,
                'feature_vector'  => $fVec,
                'strand_votes'    => $rf['votes'],
                'top_strands'     => $top3,
                'first_choice'    => $firstStr,
                'first_choice_mismatch' => $firstStr === '' ? null : $firstMismatch,
                'recommendation_explanation' => RecommendationHelpers::explainStrandRecommendation(
                    $fVec,
                    $rf['votes'],
                    $top3,
                    RandomForestRecommender::N_TREES
                ),
                'analytics'       => [
                    'Academic competency (Q4 average)',
                    'Skills assessment (text vs strand keywords)',
                    'Student interests / hobbies',
                    'Technical skill level (self-rated)',
                    'Entrance examination score',
                    'Career preference (text vs strand keywords)',
                ],
                'input_process_output' => [
                    'input' => [
                        'Academic grades (Q4, per subject)',
                        'Skills assessment',
                        'Interest (hobbies)',
                        'Entrance exam score',
                        'Career preference',
                        'Technical skill level',
                    ],
                    'process' => 'Build 0–100 feature vector. Run ' . RandomForestRecommender::N_TREES . ' trees; each tree uses a random subset of features with jittered strand affinity weights; each tree predicts one strand; majority vote ranks Top 3.',
                    'output' => 'Top 3 SHS strands by vote count (tie-break by aggregate score).',
                ],
                'q4_average'    => $q4Avg,
                'entrance_exam' => $nai['entrance_exam_score'] ?? null,
                'generated_at'  => date('Y-m-d H:i:s'),
            ];

            $del = $pdo->prepare("DELETE FROM career_recommendations WHERE student_id=? AND recommendation_type='strand'");
            $del->execute([$studentId]);

            $ins = $pdo->prepare("INSERT INTO career_recommendations
                (student_id, recommendation_type, top_strand_1, top_strand_2, top_strand_3,
                 recommended_strand, score_breakdown, generated_by, school_year)
                VALUES (?, 'strand', ?, ?, ?, ?, ?, ?, ?)");
            $ins->execute([
                $studentId,
                $top3[0]['strand_name'] ?? null,
                $top3[1]['strand_name'] ?? null,
                $top3[2]['strand_name'] ?? null,
                $top3[0]['strand_name'] ?? null,
                json_encode($breakdown),
                $generatedBy,
                effectiveSchoolYear(),
            ]);
            $genSuccess = 'Strand recommendation generated successfully (Random Forest).';
        }
    }

    // ── COURSE RECOMMENDATION (G11-G12) — Random Forest on course pool ─────────
    if ($isSHS && $naiRequired) {
        $q4Stmt = $pdo->prepare("
            SELECT AVG(g.grade) as avg_grade
            FROM grades g
            JOIN students s ON g.student_id = s.id
            JOIN sections sec ON s.section_id = sec.id
            WHERE g.student_id = ? AND g.quarter = 'Q4' AND sec.grade_level IN (11,12)
        ");
        $q4Stmt->execute([$studentId]);
        $q4ShsAvg = (float) ($q4Stmt->fetchColumn() ?? 0);

        $wiStmt = $pdo->prepare("
            SELECT AVG(g.grade) as wi_grade
            FROM grades g
            JOIN subjects sub ON g.subject_id = sub.id
            WHERE g.student_id = ? AND sub.subject_type = 'immersion' AND g.school_year = ?
        ");
        $wiStmt->execute([$studentId, effectiveSchoolYear()]);
        $wiRating = (float) ($wiStmt->fetchColumn() ?? 0);

        if ($wiRating == 0) {
            $genError = 'No Work Immersion subject grade found. Please encode the Work Immersion grade in Grades first.';
        } else {
            $courseRows = $pdo->query("
                SELECT scm.course_name, scm.career_pathway, scm.strand_id, st.strand_code, st.strand_name
                FROM strand_course_mapping scm
                JOIN strands st ON scm.strand_id = st.id
            ")->fetchAll();
            $fVec = RandomForestRecommender::buildFeatureVector($studentId, $nai, $gradeLevel, 0, $q4ShsAvg, $wiRating);
            $rf = RandomForestRecommender::recommendCourses($fVec, $courseRows, $studentId);
            $ranked = $rf['ranked'];
            $top3Courses = array_slice($ranked, 0, 3);

            $employabilityScore = round(min(100, max(0, $wiRating)), 2);
            $empLevel = getEmployabilityLevel($employabilityScore);

            $topStrandName = $top3Courses[0]['strand_name'] ?? ($student['strand_name'] ?? 'General');
            $strandMatch = ($topStrandName === ($student['strand_name'] ?? '')) ? 1 : 0;
            $mismatchRem = !$strandMatch && !empty($student['strand_code'])
                ? "Student's current strand ({$student['strand_code']}) may not align with strongest academic areas."
                : null;

            $firstCourseStr = trim($nai['first_choice_strand_course'] ?? '');
            $firstCourseMismatch = $firstCourseStr !== '' && !RecommendationHelpers::firstChoiceMatchesTop(
                $firstCourseStr,
                RecommendationHelpers::courseTop3Labels($top3Courses)
            );

            $breakdown = [
                'algorithm'       => 'random_forest_v1',
                'n_trees'         => RandomForestRecommender::N_TREES,
                'feature_vector'  => $fVec,
                'course_votes'    => $rf['votes'],
                'top_courses'     => $top3Courses,
                'q4_shs_average'  => $q4ShsAvg,
                'work_immersion'  => $wiRating,
                'employability'   => $employabilityScore,
                'employability_readiness_basis' => 'work_immersion_grade',
                'first_choice'    => $firstCourseStr,
                'first_choice_mismatch' => $firstCourseStr === '' ? null : $firstCourseMismatch,
                'recommendation_explanation' => RecommendationHelpers::explainCourseRecommendation(
                    $fVec,
                    $rf['votes'],
                    $top3Courses,
                    RandomForestRecommender::N_TREES
                ),
                'analytics'       => [
                    'Academic competency (SHS Q4)',
                    'Work immersion performance (incoming college readiness)',
                    'Skills assessment',
                    'Student interests',
                    'Technical skill level',
                    'Entrance exam',
                    'Career preference',
                ],
                'input_process_output' => [
                    'input' => [
                        'Academic grades (SHS Q4)',
                        'Work immersion grade',
                        'Skills assessment',
                        'Interest',
                        'Entrance exam score',
                        'Career preference',
                        'Technical skill level',
                    ],
                    'process' => 'Feature vector (0–100) per factor. ' . RandomForestRecommender::N_TREES . ' trees each vote for one mapped college course; majority vote yields Top 3 courses.',
                    'output' => 'Top 3 college courses (with strand) by vote count.',
                ],
                'generated_at' => date('Y-m-d H:i:s'),
            ];

            $del = $pdo->prepare("DELETE FROM career_recommendations WHERE student_id=? AND recommendation_type='course'");
            $del->execute([$studentId]);

            $ins = $pdo->prepare("INSERT INTO career_recommendations
                (student_id, recommendation_type,
                 top_course_1, top_course_2, top_course_3,
                 recommended_strand, recommended_courses,
                 employability_score, employability_level,
                 strand_match, mismatch_remarks,
                 career_pathways, score_breakdown, generated_by, school_year)
                VALUES (?, 'course', ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)");
            $ins->execute([
                $studentId,
                $top3Courses[0]['course_name'] ?? null,
                $top3Courses[1]['course_name'] ?? null,
                $top3Courses[2]['course_name'] ?? null,
                $topStrandName,
                implode(', ', array_column($top3Courses, 'course_name')),
                $employabilityScore,
                $empLevel['level'],
                $strandMatch,
                $mismatchRem,
                implode(', ', array_unique(array_column($top3Courses, 'career_pathway'))),
                json_encode($breakdown),
                $generatedBy,
                effectiveSchoolYear(),
            ]);
            $genSuccess = 'Course recommendation generated successfully (Random Forest).';
        }
    }
}

// ── Fetch latest recommendations ─────────────────────────────────────────────
$recStmt = $pdo->prepare("SELECT * FROM career_recommendations WHERE student_id = ? ORDER BY recommendation_type, created_at DESC");
$recStmt->execute([$studentId]);
$recs = $recStmt->fetchAll();
$strandRec = null;
$courseRec = null;
foreach ($recs as $r) {
    if ($r['recommendation_type'] === 'strand' && !$strandRec) $strandRec = $r;
    if ($r['recommendation_type'] === 'course' && !$courseRec) $courseRec = $r;
}

$naiBreakdown = [];
if ($isJHS && $strandRec) {
    $naiBreakdown = json_decode($strandRec['score_breakdown'] ?? '{}', true) ?: [];
} elseif ($isSHS && $courseRec) {
    $naiBreakdown = json_decode($courseRec['score_breakdown'] ?? '{}', true) ?: [];
}

// Align mismatch banner with on-screen Top 3 (avoids stale first_choice_mismatch from older DB rows).
if (!empty($naiBreakdown)) {
    $fcSnap = trim((string) ($naiBreakdown['first_choice'] ?? ''));
    if ($fcSnap !== '') {
        if ($isJHS && !empty($naiBreakdown['top_strands']) && is_array($naiBreakdown['top_strands'])) {
            $naiBreakdown['first_choice_mismatch'] = !RecommendationHelpers::firstChoiceMatchesTop(
                $fcSnap,
                RecommendationHelpers::strandTop3Labels($naiBreakdown['top_strands'])
            );
        } elseif ($isSHS && !empty($naiBreakdown['top_courses']) && is_array($naiBreakdown['top_courses'])) {
            $naiBreakdown['first_choice_mismatch'] = !RecommendationHelpers::firstChoiceMatchesTop(
                $fcSnap,
                RecommendationHelpers::courseTop3Labels($naiBreakdown['top_courses'])
            );
        }
    }
}

// ── Grades summary ────────────────────────────────────────────────────────────
$gradesStmt = $pdo->prepare("
    SELECT sub.subject_name, sub.subject_type, sub.strand_id,
           st2.strand_code AS sub_strand_code,
           g.quarter, g.grade, g.school_year
    FROM grades g
    JOIN subjects sub ON g.subject_id = sub.id
    LEFT JOIN strands st2 ON sub.strand_id = st2.id
    WHERE g.student_id = ?
    ORDER BY g.school_year, sub.subject_type, g.quarter
");
$gradesStmt->execute([$studentId]);
$gradesAll = $gradesStmt->fetchAll();

// Group Q4 grades
$q4Grades = array_filter($gradesAll, fn($g) => $g['quarter'] === 'Q4');

require_once __DIR__ . '/../includes/sidebar.php';
?>

<?php if ($saveSuccess): ?>
<script>
document.addEventListener('DOMContentLoaded', function() {
    Swal.fire({ ...swalDefaults, icon: 'success', title: 'Saved', text: <?= json_encode($saveSuccess) ?>, confirmButtonColor: '#2563eb' });
});
</script>
<?php endif; ?>
<?php if ($genSuccess): ?>
<script>
document.addEventListener('DOMContentLoaded', function() {
    Swal.fire({ ...swalDefaults, icon: 'success', title: 'Generated!', text: <?= json_encode($genSuccess) ?>, confirmButtonColor: '#2563eb' });
});
</script>
<?php endif; ?>
<?php if ($genError): ?>
<script>
document.addEventListener('DOMContentLoaded', function() {
    Swal.fire({ ...swalDefaults, icon: 'error', title: 'Cannot Generate', text: <?= json_encode($genError) ?>, confirmButtonColor: '#2563eb' });
});
</script>
<?php endif; ?>

<!-- Back link -->
<a href="<?= BASE_URL ?>career/index.php" class="inline-flex items-center gap-2 text-sm text-gray-500 hover:text-gray-700 mb-5">
    <i class="fas fa-arrow-left"></i> Back to Career Pathway
</a>

<!-- Student Header -->
<div class="bg-white border border-gray-200 rounded-xl p-6 mb-6 flex flex-wrap gap-6 items-start">
    <div class="w-14 h-14 rounded-xl bg-blue-100 flex items-center justify-center flex-shrink-0">
        <span class="text-blue-700 font-bold text-xl"><?= strtoupper(substr($student['first_name'],0,1).substr($student['last_name'],0,1)) ?></span>
    </div>
    <div class="flex-1 min-w-0">
        <h2 class="text-xl font-bold text-gray-900"><?= sanitize($student['first_name'] . ' ' . $student['last_name']) ?></h2>
        <div class="flex flex-wrap gap-3 mt-2 text-sm text-gray-500">
            <span><i class="fas fa-id-card mr-1"></i><?= sanitize($student['lrn']) ?></span>
            <span><i class="fas fa-school mr-1"></i><?= sanitize($student['section_name'] ?? 'N/A') ?></span>
            <span><i class="fas fa-layer-group mr-1"></i>Grade <?= $gradeLevel ?></span>
            <?php if ($student['strand_code']): ?>
            <span class="badge badge-blue"><?= sanitize($student['strand_code']) ?> — <?= sanitize($student['strand_name']) ?></span>
            <?php endif; ?>
        </div>
    </div>
    <div class="text-right">
        <span class="badge <?= $isJHS ? 'badge-indigo' : 'badge-green' ?> text-sm px-3 py-1">
            <i class="fas <?= $isJHS ? 'fa-graduation-cap' : 'fa-route' ?> mr-1"></i>
            <?= $isJHS ? 'Strand Recommendation Module' : 'Course Recommendation Module' ?>
        </span>
        <p class="text-xs text-gray-400 mt-1">
            <?= $isJHS ? 'Random Forest strand model (grades + learner profile)' : 'Random Forest course model (SHS grades + WI + profile)' ?>
        </p>
    </div>
</div>

<div class="grid grid-cols-1 lg:grid-cols-3 gap-6">

    <!-- LEFT: Data inputs (2/3 width) -->
    <div class="lg:col-span-2 space-y-6">

        <!-- Non-Academic Indicators -->
        <div class="bg-white border border-gray-200 rounded-xl overflow-hidden">
            <div class="px-6 py-4 border-b border-gray-100 flex items-center justify-between">
                <div class="flex items-center gap-3">
                    <div class="w-9 h-9 bg-purple-50 rounded-lg flex items-center justify-center">
                        <i class="fas fa-user-circle text-purple-600"></i>
                    </div>
                    <div>
                        <h3 class="text-sm font-semibold text-gray-900">Learner profile (RF inputs)</h3>
                        <p class="text-xs text-gray-400">Required for Random Forest strand/course recommendation. No parent/guardian fields.</p>
                    </div>
                </div>
                <?php if (!empty($nai)): ?>
                <span class="badge badge-green text-xs"><i class="fas fa-check mr-1"></i>Data on record</span>
                <?php else: ?>
                <span class="badge badge-amber text-xs"><i class="fas fa-exclamation-triangle mr-1"></i>Not yet filled</span>
                <?php endif; ?>
            </div>
            <form method="POST" class="p-6 space-y-5">
                <input type="hidden" name="action" value="save_nai">
                <div class="grid grid-cols-1 md:grid-cols-2 gap-5">
                    <div class="md:col-span-2">
                        <label class="form-label">Skills <span class="text-red-500">*</span>
                            <span class="text-xs text-gray-400 font-normal ml-1">(e.g. coding, drawing, cooking, math)</span>
                        </label>
                        <textarea name="skills" rows="2" class="form-input resize-none" placeholder="List student's skills..."><?= sanitize($nai['skills'] ?? '') ?></textarea>
                    </div>
                    <div class="md:col-span-2">
                        <label class="form-label">Interests / hobbies <span class="text-red-500">*</span>
                            <span class="text-xs text-gray-400 font-normal ml-1">(student interest)</span>
                        </label>
                        <textarea name="hobbies" rows="2" class="form-input resize-none" placeholder="Reading, sports, music, technology..."><?= sanitize($nai['hobbies'] ?? '') ?></textarea>
                    </div>
                    <div class="md:col-span-2">
                        <label class="form-label">Career preference <span class="text-red-500">*</span>
                            <span class="text-xs text-gray-400 font-normal ml-1">(intended college path or field)</span>
                        </label>
                        <input type="text" name="career_preference" class="form-input" maxlength="255"
                               placeholder="e.g. Nursing, Computer Science, Business, undecided"
                               value="<?= sanitize($nai['career_preference'] ?? '') ?>">
                    </div>
                    <div class="md:col-span-2">
                        <label class="form-label">1st choice (strand or course) <span class="text-xs text-gray-400 font-normal">(optional)</span></label>
                        <input type="text" name="first_choice_strand_course" class="form-input" maxlength="255"
                               placeholder="<?= $isJHS ? 'e.g. STEM, HUMSS, TVL — ICT' : 'e.g. BS Computer Science, BS Accountancy' ?>"
                               value="<?= sanitize($nai['first_choice_strand_course'] ?? '') ?>">
                        <p class="text-xs text-gray-500 mt-1">Used for guidance: after Generate, we compare this to the Top 3 <?= $isJHS ? '(strand name or code, e.g. STEM)' : '(course title, strand such as STEM, or pathway)' ?>; if nothing lines up, a <strong>mismatch</strong> notice appears.</p>
                    </div>
                    <div>
                        <label class="form-label">Technical skill level <span class="text-red-500">*</span></label>
                        <select name="technical_skill_level" class="form-select" required>
                            <?php
                            $tl = $nai['technical_skill_level'] ?? 'developing';
                            foreach (['beginner' => 'Beginner', 'developing' => 'Developing', 'proficient' => 'Proficient', 'advanced' => 'Advanced'] as $tv => $tlab): ?>
                                <option value="<?= $tv ?>" <?= $tl === $tv ? 'selected' : '' ?>><?= $tlab ?></option>
                            <?php endforeach; ?>
                        </select>
                    </div>
                    <div>
                        <label class="form-label">Entrance Examination Score <span class="text-red-500">*</span>
                            <span class="text-xs text-gray-400 font-normal ml-1">(0–100)</span>
                        </label>
                        <input type="number" name="entrance_exam_score" class="form-input"
                               min="0" max="100" step="0.01"
                               value="<?= $nai['entrance_exam_score'] ?? '' ?>"
                               placeholder="e.g. 85.50">
                    </div>
                    <div>
                        <label class="form-label">Entrance Exam Date <span class="text-xs text-gray-400 font-normal ml-1">(optional)</span></label>
                        <input type="date" name="entrance_exam_date" class="form-input"
                               value="<?= $nai['entrance_exam_date'] ?? '' ?>">
                    </div>
                </div>
                <div class="flex justify-end pt-2 border-t border-gray-100">
                    <button type="submit" class="btn btn-primary btn-sm">
                        <i class="fas fa-save"></i> Save Indicators
                    </button>
                </div>
            </form>
        </div>

        <!-- Q4 Grades Summary -->
        <div class="bg-white border border-gray-200 rounded-xl overflow-hidden">
            <div class="px-6 py-4 border-b border-gray-100">
                <div class="flex items-center gap-3">
                    <div class="w-9 h-9 bg-blue-50 rounded-lg flex items-center justify-center">
                        <i class="fas fa-clipboard-list text-blue-600"></i>
                    </div>
                    <div>
                        <h3 class="text-sm font-semibold text-gray-900">4th Quarter Grades</h3>
                        <p class="text-xs text-gray-400">Used as primary academic input for recommendations</p>
                    </div>
                </div>
            </div>
            <div class="p-6">
                <?php if (empty($q4Grades)): ?>
                <div class="text-center py-6">
                    <i class="fas fa-exclamation-circle text-amber-400 text-3xl mb-2"></i>
                    <p class="text-sm text-gray-500">No 4th quarter grades on record.</p>
                    <a href="<?= BASE_URL ?>students/grades.php" class="text-sm text-blue-600 hover:underline mt-1 inline-block">Go to Grades Encoding</a>
                </div>
                <?php else: ?>
                <div class="overflow-x-auto">
                    <table class="w-full text-sm">
                        <thead>
                            <tr class="bg-gray-50 text-xs text-gray-500">
                                <th class="text-left py-2 px-3">Subject</th>
                                <th class="text-center py-2 px-3">Type</th>
                                <th class="text-center py-2 px-3">Strand</th>
                                <th class="text-center py-2 px-3">Q4 Grade</th>
                            </tr>
                        </thead>
                        <tbody>
                            <?php foreach ($q4Grades as $g):
                                $typeColorMap = ['specialized' => 'badge-indigo', 'immersion' => 'badge-green', 'applied' => 'badge-blue'];
                                $typeColor = $typeColorMap[$g['subject_type']] ?? 'badge-gray';
                            ?>
                            <tr class="border-t border-gray-50">
                                <td class="py-2 px-3 font-medium"><?= sanitize($g['subject_name']) ?></td>
                                <td class="py-2 px-3 text-center"><span class="badge <?= $typeColor ?> text-[10px]"><?= ucfirst($g['subject_type']) ?></span></td>
                                <td class="py-2 px-3 text-center text-xs text-gray-500"><?= $g['sub_strand_code'] ? sanitize($g['sub_strand_code']) : 'Core' ?></td>
                                <td class="py-2 px-3 text-center font-semibold <?= $g['grade'] >= 80 ? 'text-green-600' : ($g['grade'] >= 75 ? 'text-amber-600' : 'text-red-600') ?>"><?= formatNumber($g['grade'], 0) ?></td>
                            </tr>
                            <?php endforeach; ?>
                        </tbody>
                    </table>
                </div>
                <?php endif; ?>
            </div>
        </div>

        <?php if ($isSHS): ?>
        <div class="bg-amber-50 border border-amber-200 rounded-xl p-4 flex gap-3 items-start">
            <i class="fas fa-exclamation-triangle text-amber-500 mt-0.5"></i>
            <p class="text-sm text-amber-800">Course recommendation uses Random Forest over your Q4 SHS grades, work immersion, learner profile, and entrance exam.</p>
        </div>
        <?php endif; ?>

    </div>

    <!-- RIGHT: Generate + Results -->
    <div class="space-y-6">

        <!-- Generate Button Card -->
        <div class="bg-white border border-gray-200 rounded-xl overflow-hidden">
            <div class="px-5 py-4 border-b border-gray-100">
                <h3 class="text-sm font-semibold text-gray-900">
                    <i class="fas fa-magic text-blue-500 mr-2"></i>
                    Generate Recommendation
                </h3>
            </div>
            <div class="p-5">
                <div class="bg-gray-50 rounded-lg p-4 mb-4 text-xs text-gray-600 space-y-2">
                    <p class="font-semibold text-gray-800 mb-1"><i class="fas fa-tree text-green-600 mr-1"></i> Random Forest (ensemble)</p>
                    <p class="text-gray-600 leading-relaxed"><?= RandomForestRecommender::N_TREES ?> decision trees; each tree uses a <strong>random subset</strong> of normalized factors, compares against strand (or course) profiles, and casts one vote. <strong>Majority vote</strong> selects the final Top 3.</p>
                    <?php if ($isJHS): ?>
                    <p class="font-medium text-gray-700 mt-2">Inputs (JHS → SHS strand):</p>
                    <ul class="list-disc pl-4 space-y-0.5 text-gray-600">
                        <li>Academic competency (Q4 grades)</li>
                        <li>Skills assessment &amp; interests</li>
                        <li>Technical skill level</li>
                        <li>Entrance exam score</li>
                        <li>Career preference (text match)</li>
                    </ul>
                    <?php else: ?>
                    <p class="font-medium text-gray-700 mt-2">Inputs (SHS → college course):</p>
                    <ul class="list-disc pl-4 space-y-0.5 text-gray-600">
                        <li>Academic competency (SHS Q4)</li>
                        <li>Work immersion performance</li>
                        <li>Skills, interests, technical level</li>
                        <li>Entrance exam</li>
                        <li>Career preference</li>
                    </ul>
                    <p class="text-gray-500 mt-2">Employability readiness (SHS): guidance-only; score equals the <strong>Work Immersion</strong> subject grade (0–100).</p>
                    <?php endif; ?>
                </div>
                <form method="POST" id="genForm">
                    <input type="hidden" name="action" value="generate">
                    <button type="button" class="btn btn-primary w-full"
                        onclick="confirmSubmit(document.getElementById('genForm'),
                            'Generate Recommendation?',
                            'This will compute and save a personalized recommendation for this student.',
                            'Yes, Generate')">
                        <i class="fas fa-magic mr-2"></i>
                        <?= $isJHS ? 'Generate Strand Recommendation' : 'Generate Course Recommendation' ?>
                    </button>
                </form>
            </div>
        </div>

        <!-- Strand Recommendation Results -->
        <?php if ($strandRec): ?>
        <div class="bg-white border border-indigo-200 rounded-xl overflow-hidden">
            <div class="px-5 py-4 bg-indigo-50 border-b border-indigo-100 flex items-center justify-between">
                <div class="flex items-center gap-2">
                    <i class="fas fa-graduation-cap text-indigo-600"></i>
                    <h3 class="text-sm font-semibold text-indigo-900">Strand Recommendation</h3>
                </div>
                <span class="text-xs text-indigo-500"><?= date('M d, Y', strtotime($strandRec['created_at'])) ?></span>
            </div>
            <div class="p-5 space-y-3">
                <?php
                $strandBreakdown = json_decode($strandRec['score_breakdown'] ?? '{}', true);
                $topStrands = [
                    ['rank' => 1, 'name' => $strandRec['top_strand_1'], 'color' => 'bg-indigo-600 text-white'],
                    ['rank' => 2, 'name' => $strandRec['top_strand_2'], 'color' => 'bg-indigo-400 text-white'],
                    ['rank' => 3, 'name' => $strandRec['top_strand_3'], 'color' => 'bg-indigo-100 text-indigo-700'],
                ];
                foreach ($topStrands as $ts): if (empty($ts['name'])) continue; ?>
                <div class="flex items-center gap-3 p-3 rounded-lg border border-gray-100 bg-gray-50">
                    <span class="w-8 h-8 rounded-full <?= $ts['color'] ?> flex items-center justify-center font-bold text-sm flex-shrink-0"><?= $ts['rank'] ?></span>
                    <div class="flex-1 min-w-0">
                        <p class="font-semibold text-sm text-gray-900 truncate"><?= sanitize($ts['name']) ?></p>
                        <?php
                        $strandCode = '';
                        $voteLine = '';
                        if (!empty($strandBreakdown['top_strands'])) {
                            foreach ($strandBreakdown['top_strands'] as $ts2) {
                                if ($ts2['strand_name'] === $ts['name']) {
                                    $strandCode = $ts2['strand_code'];
                                    if (!empty($ts2['votes'])) {
                                        $voteLine = (int) $ts2['votes'] . ' / ' . (int) ($strandBreakdown['n_trees'] ?? RandomForestRecommender::N_TREES) . ' tree votes';
                                    }
                                    $sc = isset($ts2['score']) ? number_format((float) $ts2['score'], 1) . '%' : '';
                                    break;
                                }
                            }
                        }
                        ?>
                        <?php if ($strandCode): ?>
                        <p class="text-xs text-gray-400"><?= sanitize($strandCode) ?><?= $voteLine ? ' · ' . sanitize($voteLine) : '' ?><?= $sc ? ' · ' . $sc : '' ?></p>
                        <?php endif; ?>
                    </div>
                    <?php if ($ts['rank'] === 1): ?>
                    <span class="badge badge-indigo text-[10px]">Best Fit</span>
                    <?php endif; ?>
                </div>
                <?php endforeach; ?>

                <?php if (!empty($strandBreakdown['q4_average'])): ?>
                <div class="mt-3 pt-3 border-t border-gray-100 text-xs text-gray-500 space-y-1">
                    <div class="flex justify-between"><span>Q4 Average</span><span class="font-medium"><?= number_format($strandBreakdown['q4_average'], 2) ?></span></div>
                    <?php if ($strandBreakdown['entrance_exam'] !== null): ?>
                    <div class="flex justify-between"><span>Entrance Exam</span><span class="font-medium"><?= number_format($strandBreakdown['entrance_exam'], 2) ?></span></div>
                    <?php endif; ?>
                    <?php if (!empty($strandBreakdown['strand_votes'])): ?>
                    <div class="mt-2 pt-2 border-t border-gray-100">
                        <p class="text-[10px] font-semibold text-gray-600 mb-1">Vote tally (strand)</p>
                        <?php foreach ($strandBreakdown['strand_votes'] as $code => $cnt): ?>
                            <div class="flex justify-between"><span><?= sanitize($code) ?></span><span><?= (int) $cnt ?> votes</span></div>
                        <?php endforeach; ?>
                    </div>
                    <?php endif; ?>
                </div>
                <?php endif; ?>
            </div>
        </div>
        <?php endif; ?>

        <!-- Course Recommendation Results -->
        <?php if ($courseRec): ?>
        <div class="bg-white border border-green-200 rounded-xl overflow-hidden">
            <div class="px-5 py-4 bg-green-50 border-b border-green-100 flex items-center justify-between">
                <div class="flex items-center gap-2">
                    <i class="fas fa-route text-green-600"></i>
                    <h3 class="text-sm font-semibold text-green-900">Course Recommendation</h3>
                </div>
                <span class="text-xs text-green-500"><?= date('M d, Y', strtotime($courseRec['created_at'])) ?></span>
            </div>
            <div class="p-5 space-y-3">
                <?php
                $courseBreakdown = json_decode($courseRec['score_breakdown'] ?? '{}', true);
                $topCourses = [
                    ['rank' => 1, 'name' => $courseRec['top_course_1'], 'color' => 'bg-green-600 text-white'],
                    ['rank' => 2, 'name' => $courseRec['top_course_2'], 'color' => 'bg-green-400 text-white'],
                    ['rank' => 3, 'name' => $courseRec['top_course_3'], 'color' => 'bg-green-100 text-green-700'],
                ];
                foreach ($topCourses as $tc): if (empty($tc['name'])) continue;
                    $pathway = '';
                    if (!empty($courseBreakdown['top_courses'])) {
                        foreach ($courseBreakdown['top_courses'] as $tc2) {
                            if ($tc2['course_name'] === $tc['name']) { $pathway = $tc2['career_pathway']; break; }
                        }
                    }
                ?>
                <div class="flex items-start gap-3 p-3 rounded-lg border border-gray-100 bg-gray-50">
                    <span class="w-8 h-8 rounded-full <?= $tc['color'] ?> flex items-center justify-center font-bold text-sm flex-shrink-0 mt-0.5"><?= $tc['rank'] ?></span>
                    <div class="flex-1 min-w-0">
                        <p class="font-semibold text-sm text-gray-900"><?= sanitize($tc['name']) ?></p>
                        <?php if ($pathway): ?>
                        <p class="text-xs text-gray-400 mt-0.5"><i class="fas fa-compass mr-1"></i><?= sanitize($pathway) ?></p>
                        <?php endif; ?>
                    </div>
                    <?php if ($tc['rank'] === 1): ?>
                    <span class="badge badge-green text-[10px] flex-shrink-0">Best Fit</span>
                    <?php endif; ?>
                </div>
                <?php endforeach; ?>

                <!-- Employability readiness (Work Immersion — guidance) -->
                <?php if ($courseRec['employability_score'] !== null && $courseRec['employability_score'] !== ''):
                    $el = getEmployabilityLevel((float) $courseRec['employability_score']); ?>
                <div class="mt-4 p-4 bg-gray-50 rounded-lg border border-gray-100">
                    <p class="text-xs font-semibold text-gray-600 mb-1">Employability readiness (SHS)</p>
                    <p class="text-[10px] text-gray-500 mb-2">Based on Work Immersion subject grade (guidance view).</p>
                    <div class="flex items-end gap-2">
                        <span class="text-2xl font-bold text-gray-900"><?= formatNumber($courseRec['employability_score']) ?></span>
                        <span class="badge badge-<?= $el['color'] === 'emerald' ? 'green' : $el['color'] ?> mb-1"><?= $el['label'] ?></span>
                    </div>
                    <?php if (!empty($courseBreakdown)): ?>
                    <div class="mt-3 text-xs text-gray-500 space-y-1 border-t border-gray-200 pt-2">
                        <?php if (!empty($courseBreakdown['q4_shs_average'])): ?>
                        <div class="flex justify-between"><span>Q4 SHS Average</span><span class="font-medium"><?= number_format($courseBreakdown['q4_shs_average'], 2) ?></span></div>
                        <?php endif; ?>
                        <?php if (!empty($courseBreakdown['work_immersion'])): ?>
                        <div class="flex justify-between"><span>Work immersion (avg)</span><span class="font-medium"><?= number_format($courseBreakdown['work_immersion'], 2) ?></span></div>
                        <?php endif; ?>
                    </div>
                    <?php endif; ?>
                    <?php if (!empty($courseBreakdown['course_votes'])): ?>
                    <div class="mt-3 text-xs text-gray-500 border-t border-gray-200 pt-2">
                        <p class="text-[10px] font-semibold text-gray-600 mb-1">Vote tally (course)</p>
                        <?php
                        $cv = $courseBreakdown['course_votes'];
                        arsort($cv);
                        $shown = 0;
                        foreach ($cv as $cname => $cnt):
                            if ($shown++ >= 8) {
                                break;
                            } ?>
                        <div class="flex justify-between gap-2"><span class="truncate"><?= sanitize($cname) ?></span><span><?= (int) $cnt ?> votes</span></div>
                        <?php endforeach; ?>
                    </div>
                    <?php endif; ?>
                </div>
                <?php endif; ?>

                <?php if (!$courseRec['strand_match'] && $courseRec['mismatch_remarks']): ?>
                <div class="mt-3 p-3 bg-amber-50 border border-amber-200 rounded-lg flex gap-2 items-start">
                    <i class="fas fa-exclamation-triangle text-amber-500 text-xs mt-0.5 flex-shrink-0"></i>
                    <p class="text-xs text-amber-800"><?= sanitize($courseRec['mismatch_remarks']) ?></p>
                </div>
                <?php endif; ?>
            </div>
        </div>
        <?php endif; ?>

        <?php if (!$strandRec && !$courseRec): ?>
        <div class="bg-gray-50 border border-gray-200 rounded-xl p-6 text-center text-gray-400">
            <i class="fas fa-clock text-4xl mb-3"></i>
            <p class="text-sm">No recommendation generated yet.</p>
            <p class="text-xs mt-1">Fill in the indicators and click Generate above.</p>
        </div>
        <?php endif; ?>

    </div>
</div>

<?php if (!empty($naiBreakdown)): ?>
<div class="mt-6 space-y-4">
    <?php
    $fc = trim((string) ($naiBreakdown['first_choice'] ?? ''));
    $mm = $naiBreakdown['first_choice_mismatch'] ?? null;
    $expl = (string) ($naiBreakdown['recommendation_explanation'] ?? '');
    ?>
    <?php if ($fc !== '' && $mm === true): ?>
    <div class="bg-amber-50 border border-amber-200 rounded-xl p-5 flex gap-3 items-start">
        <i class="fas fa-exclamation-circle text-amber-600 mt-0.5"></i>
        <div>
            <p class="text-sm font-semibold text-amber-900">Mismatch: student 1st choice vs. Top 3</p>
            <p class="text-sm text-amber-800 mt-1">The student’s first choice is <strong><?= sanitize($fc) ?></strong>, which did not match any of the Top 3 <?= $isJHS ? 'strand names or strand codes' : 'course names, strand codes/names, or career pathways' ?> shown above. Use this in counseling to discuss alignment between preference and profile.</p>
        </div>
    </div>
    <?php elseif ($fc === ''): ?>
    <div class="bg-gray-50 border border-gray-200 rounded-xl p-4 text-sm text-gray-600">
        <i class="fas fa-info-circle text-gray-400 mr-1"></i> Enter the student’s <strong>1st choice</strong> in Non-Academic Indicators and save to enable automatic mismatch detection on the next generation.
    </div>
    <?php endif; ?>

    <?php if ($expl !== ''): ?>
    <div class="bg-white border border-gray-200 rounded-xl p-5">
        <h4 class="text-sm font-semibold text-gray-900 mb-2"><i class="fas fa-lightbulb text-amber-500 mr-1"></i> Why these Top 3?</h4>
        <p class="text-sm text-gray-600 leading-relaxed"><?= sanitize($expl) ?></p>
    </div>
    <?php endif; ?>

    <?php if ($isSHS && !empty($naiBreakdown['employability_readiness_basis'])): ?>
    <div class="bg-blue-50 border border-blue-100 rounded-xl p-5">
        <h4 class="text-sm font-semibold text-blue-900 mb-2"><i class="fas fa-user-tie text-blue-600 mr-1"></i> How this supports guidance (SHS employability)</h4>
        <p class="text-sm text-blue-900/90 leading-relaxed">For Senior High School, <strong>employability readiness</strong> is shown only on the guidance side. It is driven by the <strong>Work Immersion</strong> subject grade: workplace performance in immersion is used as a single readiness signal (0–100) so counselors can discuss strengths, gaps, and next steps before college or employment—separate from the Random Forest Top 3 courses, which still use the full learner profile.</p>
    </div>
    <?php endif; ?>
</div>
<?php endif; ?>

<?php require_once __DIR__ . '/../includes/footer.php'; ?>
