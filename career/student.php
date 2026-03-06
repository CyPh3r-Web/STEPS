<?php
$pageTitle = 'Career Pathway — Student';
require_once __DIR__ . '/../includes/header.php';
requireRole(['admin', 'guidance']);

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
    $skills           = sanitize($_POST['skills'] ?? '');
    $hobbies          = sanitize($_POST['hobbies'] ?? '');
    $fatherFullname   = sanitize($_POST['father_fullname'] ?? '');
    $fatherOccupation = sanitize($_POST['father_occupation'] ?? '');
    $motherFullname   = sanitize($_POST['mother_fullname'] ?? '');
    $motherOccupation = sanitize($_POST['mother_occupation'] ?? '');
    $income           = $_POST['annual_income'] ?? 'below_100k';
    $examScore        = $_POST['entrance_exam_score'] !== '' ? (float)$_POST['entrance_exam_score'] : null;
    $examDate         = $_POST['entrance_exam_date'] ?: null;

    $validIncome = ['below_100k', '100k_300k', '300k_500k', '500k_above'];
    if (!in_array($income, $validIncome)) $income = 'below_100k';

    if (empty($nai)) {
        $ins = $pdo->prepare("INSERT INTO non_academic_indicators
            (student_id, skills, hobbies, father_fullname, father_occupation, mother_fullname, mother_occupation, annual_income, entrance_exam_score, entrance_exam_date, updated_by)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)");
        $ins->execute([$studentId, $skills, $hobbies, $fatherFullname, $fatherOccupation, $motherFullname, $motherOccupation, $income, $examScore, $examDate, $_SESSION['user_id']]);
    } else {
        $upd = $pdo->prepare("UPDATE non_academic_indicators
            SET skills=?, hobbies=?, father_fullname=?, father_occupation=?, mother_fullname=?, mother_occupation=?,
                annual_income=?, entrance_exam_score=?, entrance_exam_date=?, updated_by=?
            WHERE student_id=?");
        $upd->execute([$skills, $hobbies, $fatherFullname, $fatherOccupation, $motherFullname, $motherOccupation, $income, $examScore, $examDate, $_SESSION['user_id'], $studentId]);
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

    // ── Validate Non-Academic Indicators (required for both strand and course) ─
    $naiRequired = !empty($nai) && trim($nai['skills'] ?? '') !== '' && trim($nai['hobbies'] ?? '') !== ''
        && (trim($nai['father_fullname'] ?? '') !== '' || trim($nai['father_occupation'] ?? '') !== ''
            || trim($nai['mother_fullname'] ?? '') !== '' || trim($nai['mother_occupation'] ?? '') !== '')
        && ($nai['entrance_exam_score'] ?? '') !== '' && (float)($nai['entrance_exam_score'] ?? 0) > 0;
    if (!$naiRequired) {
        $genError = 'Please fill in all required Non-Academic Indicators first: Skills, Hobbies, Father\'s/Mother\'s name & occupation, and Entrance Exam Score.';
    }

    // ── STRAND RECOMMENDATION (G7-G10) ───────────────────────────────────────
    if ($isJHS && $naiRequired) {
        // 4th quarter grades for G7–G10
        $gradeStmt = $pdo->prepare("
            SELECT sub.strand_id, st2.strand_code, st2.strand_name,
                   AVG(g.grade) as avg_grade, COUNT(g.id) as subject_count
            FROM grades g
            JOIN subjects sub ON g.subject_id = sub.id
            LEFT JOIN strands st2 ON sub.strand_id = st2.id
            WHERE g.student_id = ? AND g.quarter = 'Q4'
            GROUP BY sub.strand_id
            ORDER BY avg_grade DESC
        ");
        $gradeStmt->execute([$studentId]);
        $strandGrades = $gradeStmt->fetchAll();

        // Overall Q4 average
        $q4AvgStmt = $pdo->prepare("SELECT AVG(grade) FROM grades WHERE student_id = ? AND quarter = 'Q4'");
        $q4AvgStmt->execute([$studentId]);
        $q4Avg = (float)($q4AvgStmt->fetchColumn() ?? 0);

        if ($q4Avg == 0) {
            $genError = 'No 4th quarter grades found for this student. Please encode Q4 grades first.';
        } else {
            // Score per strand from subject performance
            $allStrands = $pdo->query("SELECT * FROM strands ORDER BY id")->fetchAll();
            $strandScores = [];

            foreach ($allStrands as $str) {
                $score = 0;
                $gradeWeight = 0.5;
                $examWeight  = 0.2;
                $naiWeight   = 0.3;

                // Academic component: avg Q4 grade in strand-aligned subjects (or overall Q4 if no specialized)
                $matched = array_filter($strandGrades, fn($g) => $g['strand_id'] == $str['id']);
                $academicScore = $matched ? array_sum(array_column($matched, 'avg_grade')) / count($matched) : $q4Avg;

                // Entrance exam component
                $examScore = (float)($nai['entrance_exam_score'] ?? 0);
                $examComponent = $examScore > 0 ? $examScore : $q4Avg;

                // Non-academic indicators component (heuristic scoring)
                $familyText = trim(($nai['father_occupation'] ?? '') . ' ' . ($nai['mother_occupation'] ?? ''));
                $naiScore = calcNAIScore(
                    $nai['skills'] ?? '',
                    $nai['hobbies'] ?? '',
                    $familyText,
                    $nai['annual_income'] ?? 'below_100k',
                    $str['strand_code']
                );

                $score = ($academicScore * $gradeWeight) + ($examComponent * $examWeight) + ($naiScore * $naiWeight);
                $strandScores[$str['id']] = [
                    'strand_id'      => $str['id'],
                    'strand_code'    => $str['strand_code'],
                    'strand_name'    => $str['strand_name'],
                    'score'          => $score,
                    'academic_score' => $academicScore,
                    'exam_component' => $examComponent,
                    'nai_score'      => $naiScore,
                ];
            }
            usort($strandScores, fn($a, $b) => $b['score'] <=> $a['score']);

            $top3 = array_slice($strandScores, 0, 3);
            $breakdown = json_encode([
                'q4_average'        => $q4Avg,
                'entrance_exam'     => $nai['entrance_exam_score'] ?? null,
                'top_strands'       => $top3,
                'generated_at'      => date('Y-m-d H:i:s'),
            ]);

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
                $breakdown,
                $generatedBy,
                SCHOOL_YEAR,
            ]);
            $genSuccess = 'Strand recommendation generated successfully.';
        }
    }

    // ── COURSE RECOMMENDATION (G11-G12) ──────────────────────────────────────
    if ($isSHS && $naiRequired) {
        // Q4 grades in Senior HS (still used for academic fit)
        $q4Stmt = $pdo->prepare("
            SELECT AVG(g.grade) as avg_grade
            FROM grades g
            JOIN students s ON g.student_id = s.id
            JOIN sections sec ON s.section_id = sec.id
            WHERE g.student_id = ? AND g.quarter = 'Q4' AND sec.grade_level IN (11,12)
        ");
        $q4Stmt->execute([$studentId]);
        $q4ShsAvg = (float)($q4Stmt->fetchColumn() ?? 0);

        // Employability based on Work Immersion subject grade (from grades table)
        $wiStmt = $pdo->prepare("
            SELECT AVG(g.grade) as wi_grade
            FROM grades g
            JOIN subjects sub ON g.subject_id = sub.id
            WHERE g.student_id = ? AND sub.subject_type = 'immersion' AND g.school_year = ?
        ");
        $wiStmt->execute([$studentId, SCHOOL_YEAR]);
        $wiRating = (float)($wiStmt->fetchColumn() ?? 0);

        if ($wiRating == 0) {
            $genError = 'No Work Immersion subject grade found. Please encode the Work Immersion grade in Grades first.';
        } else {
            $baseGrade = $q4ShsAvg ?: $wiRating;
            $employabilityScore = $wiRating;
            $empLevel = getEmployabilityLevel($employabilityScore);

            // Score per course/strand
            $allStrands = $pdo->query("SELECT * FROM strands ORDER BY id")->fetchAll();
            $courseRankings = [];

            foreach ($allStrands as $str) {
                // Q4 performance in this strand's specialized subjects
                $specStmt = $pdo->prepare("
                    SELECT AVG(g.grade) as avg
                    FROM grades g
                    JOIN subjects sub ON g.subject_id = sub.id
                    WHERE g.student_id = ? AND sub.strand_id = ? AND g.quarter = 'Q4'
                ");
                $specStmt->execute([$studentId, $str['id']]);
                $specAvg = (float)($specStmt->fetchColumn() ?? 0);
                $academicScore = $specAvg > 0 ? $specAvg : $baseGrade;

                $familyText = trim(($nai['father_occupation'] ?? '') . ' ' . ($nai['mother_occupation'] ?? ''));
                $naiScore = calcNAIScore(
                    $nai['skills'] ?? '',
                    $nai['hobbies'] ?? '',
                    $familyText,
                    $nai['annual_income'] ?? 'below_100k',
                    $str['strand_code']
                );

                $strandFitScore = ($academicScore * 0.35) + ($employabilityScore * 0.35) + ($naiScore * 0.30);

                $courseRows = $pdo->prepare("SELECT course_name, career_pathway FROM strand_course_mapping WHERE strand_id = ? ORDER BY id LIMIT 5");
                $courseRows->execute([$str['id']]);
                $courses = $courseRows->fetchAll();

                foreach ($courses as $course) {
                    $courseRankings[] = [
                        'course_name'    => $course['course_name'],
                        'career_pathway' => $course['career_pathway'],
                        'strand_name'    => $str['strand_name'],
                        'strand_code'    => $str['strand_code'],
                        'score'          => $strandFitScore,
                    ];
                }
            }
            usort($courseRankings, fn($a, $b) => $b['score'] <=> $a['score']);
            $top3Courses = array_slice($courseRankings, 0, 3);

            // Determine recommended strand (strand of top course)
            $topStrandName = $top3Courses[0]['strand_name'] ?? ($student['strand_name'] ?? 'General');
            $strandMatch   = ($topStrandName === ($student['strand_name'] ?? '')) ? 1 : 0;
            $mismatchRem   = !$strandMatch && !empty($student['strand_code'])
                ? "Student's current strand ({$student['strand_code']}) may not align with strongest academic areas."
                : null;

            $breakdown = json_encode([
                'q4_shs_average'    => $q4ShsAvg,
                'employability'     => $employabilityScore,
                'top_courses'       => $top3Courses,
                'generated_at'      => date('Y-m-d H:i:s'),
            ]);

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
                $breakdown,
                $generatedBy,
                SCHOOL_YEAR,
            ]);
            $genSuccess = 'Course recommendation generated successfully.';
        }
    }
}

// ── NAI scoring heuristic ─────────────────────────────────────────────────────
function calcNAIScore($skills, $hobbies, $familyBg, $income, $strandCode) {
    $text = strtolower("$skills $hobbies $familyBg");

    $keywordMap = [
        'STEM'     => ['science', 'math', 'technology', 'engineering', 'computer', 'coding', 'programming', 'research', 'biology', 'physics', 'chemistry', 'robot', 'gadget'],
        'ABM'      => ['business', 'accounting', 'finance', 'economics', 'marketing', 'management', 'entrepreneur', 'trade', 'commerce', 'sales'],
        'HUMSS'    => ['writing', 'literature', 'social', 'politics', 'history', 'arts', 'communication', 'journalism', 'philosophy', 'language', 'culture'],
        'GAS'      => ['general', 'undecided', 'multiple', 'flexible', 'broad'],
        'TVL-ICT'  => ['computer', 'coding', 'web', 'internet', 'tech', 'software', 'hardware', 'network', 'digital'],
        'TVL-HE'   => ['cooking', 'baking', 'food', 'hospitality', 'housekeeping', 'hotel', 'restaurant', 'sewing', 'home'],
        'TVL-IA'   => ['welding', 'electrical', 'carpentry', 'automotive', 'mechanical', 'construction', 'building', 'industrial'],
        'SPORTS'   => ['sports', 'athlete', 'basketball', 'volleyball', 'football', 'swimming', 'running', 'fitness', 'gym'],
        'ARTS'     => ['art', 'drawing', 'painting', 'design', 'music', 'theater', 'photography', 'animation', 'media', 'creative'],
    ];

    $keywords = $keywordMap[$strandCode] ?? [];
    $hits = 0;
    foreach ($keywords as $kw) {
        if (str_contains($text, $kw)) $hits++;
    }

    // Income factor: lower income benefits from TVL/technical strands
    $incomeBoost = 0;
    if (in_array($strandCode, ['TVL-ICT', 'TVL-HE', 'TVL-IA', 'SPORTS'])) {
        if ($income === 'below_100k') $incomeBoost = 5;
        elseif ($income === '100k_300k') $incomeBoost = 3;
    }

    $base = min(80, 60 + ($hits * 4));
    return $base + $incomeBoost;
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
            <?= $isJHS ? 'Based on G7–G10 4th quarter grades' : 'Based on Senior HS 4th quarter grades and entrance exam' ?>
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
                        <h3 class="text-sm font-semibold text-gray-900">Non-Academic Indicators</h3>
                        <p class="text-xs text-gray-400">Required for strand/course recommendation. Fill all fields before generating.</p>
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
                        <label class="form-label">Hobbies / Interests <span class="text-red-500">*</span>
                            <span class="text-xs text-gray-400 font-normal ml-1">(e.g. reading, sports, music, technology)</span>
                        </label>
                        <textarea name="hobbies" rows="2" class="form-input resize-none" placeholder="List student's hobbies and interests..."><?= sanitize($nai['hobbies'] ?? '') ?></textarea>
                    </div>
                    <div class="md:col-span-2">
                        <p class="text-xs text-amber-600 font-medium mb-2"><i class="fas fa-info-circle mr-1"></i> At least one parent field (name or occupation) is required</p>
                    </div>
                    <div>
                        <label class="form-label">Father's Full Name</label>
                        <input type="text" name="father_fullname" class="form-input" placeholder="e.g. Juan Dela Cruz"
                               value="<?= sanitize($nai['father_fullname'] ?? '') ?>">
                    </div>
                    <div>
                        <label class="form-label">Father's Occupation</label>
                        <input type="text" name="father_occupation" class="form-input" placeholder="e.g. Engineer, OFW, Teacher"
                               value="<?= sanitize($nai['father_occupation'] ?? '') ?>">
                    </div>
                    <div>
                        <label class="form-label">Mother's Full Name</label>
                        <input type="text" name="mother_fullname" class="form-input" placeholder="e.g. Maria Santos"
                               value="<?= sanitize($nai['mother_fullname'] ?? '') ?>">
                    </div>
                    <div>
                        <label class="form-label">Mother's Occupation</label>
                        <input type="text" name="mother_occupation" class="form-input" placeholder="e.g. Nurse, Dressmaker, Housewife"
                               value="<?= sanitize($nai['mother_occupation'] ?? '') ?>">
                    </div>
                    <div>
                        <label class="form-label">Annual Family Income</label>
                        <select name="annual_income" class="form-select">
                            <option value="below_100k" <?= ($nai['annual_income'] ?? '') === 'below_100k' ? 'selected' : '' ?>>Below ₱100,000</option>
                            <option value="100k_300k"  <?= ($nai['annual_income'] ?? '') === '100k_300k'  ? 'selected' : '' ?>>₱100,000 – ₱300,000</option>
                            <option value="300k_500k"  <?= ($nai['annual_income'] ?? '') === '300k_500k'  ? 'selected' : '' ?>>₱300,000 – ₱500,000</option>
                            <option value="500k_above" <?= ($nai['annual_income'] ?? '') === '500k_above' ? 'selected' : '' ?>>Above ₱500,000</option>
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
            <p class="text-sm text-amber-800">Recommendation is based on Senior HS grades and entrance exam score.</p>
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
                    <?php if ($isJHS): ?>
                    <p class="font-semibold text-gray-700 mb-2">Strand Recommendation Formula:</p>
                    <div class="flex items-center gap-2"><span class="w-6 h-6 bg-blue-100 text-blue-700 rounded-full text-center leading-6 font-bold text-[10px]">50%</span> 4th Quarter Grades (G7–G10)</div>
                    <div class="flex items-center gap-2"><span class="w-6 h-6 bg-purple-100 text-purple-700 rounded-full text-center leading-6 font-bold text-[10px]">20%</span> Entrance Exam Score</div>
                    <div class="flex items-center gap-2"><span class="w-6 h-6 bg-green-100 text-green-700 rounded-full text-center leading-6 font-bold text-[10px]">30%</span> Non-Academic Indicators</div>
                    <p class="text-gray-500 mt-2 pt-2 border-t border-gray-200">Output: <strong>Top 3 Recommended Strands</strong></p>
                    <?php else: ?>
                    <p class="font-semibold text-gray-700 mb-2">Course Recommendation Formula:</p>
                    <div class="flex items-center gap-2"><span class="w-5 h-5 bg-blue-100 text-blue-700 rounded-full text-center text-[9px] leading-5 font-bold">40%</span> 4th Qtr SHS Grades</div>
                    <div class="flex items-center gap-2"><span class="w-5 h-5 bg-green-100 text-green-700 rounded-full text-center text-[9px] leading-5 font-bold">40%</span> Work Immersion Grade</div>
                    <div class="flex items-center gap-2"><span class="w-5 h-5 bg-amber-100 text-amber-700 rounded-full text-center text-[9px] leading-5 font-bold">20%</span> Entrance Exam Score</div>
                    <p class="text-gray-400 mt-1 italic text-[10px]">Employability = above formula</p>
                    <p class="text-gray-500 mt-2 pt-2 border-t border-gray-200">Course fit = Employability + Strand Grades + Exam + Non-Academic</p>
                    <p class="text-gray-500">Output: <strong>Top 3 Recommended Courses</strong></p>
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
                        if (!empty($strandBreakdown['top_strands'])) {
                            foreach ($strandBreakdown['top_strands'] as $ts2) {
                                if ($ts2['strand_name'] === $ts['name']) {
                                    $strandCode = $ts2['strand_code'];
                                    $sc = number_format($ts2['score'], 1);
                                    break;
                                }
                            }
                        }
                        ?>
                        <?php if ($strandCode): ?>
                        <p class="text-xs text-gray-400"><?= sanitize($strandCode) ?> · Score: <?= $sc ?? '' ?></p>
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

                <!-- Employability Score -->
                <?php if ($courseRec['employability_score']): 
                    $el = getEmployabilityLevel($courseRec['employability_score']); ?>
                <div class="mt-4 p-4 bg-gray-50 rounded-lg border border-gray-100">
                    <p class="text-xs font-semibold text-gray-600 mb-2">Employability Score</p>
                    <div class="flex items-end gap-2">
                        <span class="text-2xl font-bold text-gray-900"><?= formatNumber($courseRec['employability_score']) ?></span>
                        <span class="badge badge-<?= $el['color'] === 'emerald' ? 'green' : $el['color'] ?> mb-1"><?= $el['label'] ?></span>
                    </div>
                    <?php if (!empty($courseBreakdown)): ?>
                    <div class="mt-3 text-xs text-gray-500 space-y-1 border-t border-gray-200 pt-2">
                        <?php if ($courseBreakdown['q4_shs_average'] ?? 0): ?>
                        <div class="flex justify-between"><span>Q4 SHS Average</span><span class="font-medium"><?= number_format($courseBreakdown['q4_shs_average'], 2) ?></span></div>
                        <?php endif; ?>
                        <?php if ($courseBreakdown['entrance_exam'] ?? null): ?>
                        <div class="flex justify-between"><span>Entrance Exam</span><span class="font-medium"><?= number_format($courseBreakdown['entrance_exam'], 2) ?></span></div>
                        <?php endif; ?>
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

<?php require_once __DIR__ . '/../includes/footer.php'; ?>
