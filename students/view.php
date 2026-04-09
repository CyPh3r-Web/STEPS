<?php
$pageTitle = 'Student Profile';
require_once __DIR__ . '/../includes/header.php';
requireRole(['teacher', 'guidance']);

$role = $_SESSION['role'] ?? '';
$currentUserId = $_SESSION['user_id'] ?? 0;

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

// Enforce ownership for teachers
if ($role === 'teacher' && $student['created_by'] != $currentUserId) {
    header('Location: ' . BASE_URL . 'students/index.php?error=unauthorized');
    exit;
}

$cleanRemarkField = static function (?string $s): ?string {
    $s = trim((string) $s);
    if ($s === '') {
        return null;
    }
    return mb_substr(strip_tags($s), 0, 16000);
};

if ($_SERVER['REQUEST_METHOD'] === 'POST' && ($_POST['action'] ?? '') === 'save_subject_remarks' && $role === 'teacher') {
    $subjectId = (int) ($_POST['subject_id'] ?? 0);
    $learningGaps = $cleanRemarkField($_POST['learning_gaps'] ?? '');
    $reinforcementReason = $cleanRemarkField($_POST['reinforcement_reason'] ?? '');
    $sy = effectiveSchoolYear();

    if ($subjectId > 0) {
        $avgStmt = $pdo->prepare('SELECT AVG(grade) AS a FROM grades WHERE student_id = ? AND subject_id = ? AND school_year = ?');
        $avgStmt->execute([$id, $subjectId, $sy]);
        $rowAvg = $avgStmt->fetch();
        $subAvgForSubject = isset($rowAvg['a']) && $rowAvg['a'] !== null ? (float) $rowAvg['a'] : null;

        if ($subAvgForSubject !== null) {
            $subCompCheck = getCompetencyLevel($subAvgForSubject);
            if ($subCompCheck['level'] === 'at_risk' && ($learningGaps === null || $reinforcementReason === null)) {
                header('Location: ' . BASE_URL . 'students/view.php?id=' . (int) $id . '&remarks_error=required');
                exit;
            }

            $del = $pdo->prepare('DELETE FROM grade_subject_remarks WHERE student_id = ? AND subject_id = ? AND school_year = ?');
            if ($learningGaps === null && $reinforcementReason === null) {
                $del->execute([$id, $subjectId, $sy]);
            } else {
                $ins = $pdo->prepare('INSERT INTO grade_subject_remarks (student_id, subject_id, school_year, learning_gaps, reinforcement_reason, updated_by)
                    VALUES (?, ?, ?, ?, ?, ?)
                    ON DUPLICATE KEY UPDATE learning_gaps = VALUES(learning_gaps), reinforcement_reason = VALUES(reinforcement_reason), updated_by = VALUES(updated_by)');
                $ins->execute([$id, $subjectId, $sy, $learningGaps, $reinforcementReason, $_SESSION['user_id'] ?? null]);
            }
        }
    }
    header('Location: ' . BASE_URL . 'students/view.php?id=' . (int) $id . '&remarks_saved=1');
    exit;
}

$gradesStmt = $pdo->prepare("SELECT g.*, sub.subject_name, sub.subject_code
    FROM grades g
    JOIN subjects sub ON g.subject_id = sub.id
    WHERE g.student_id = ? ORDER BY sub.subject_name, g.quarter");
$gradesStmt->execute([$id]);
$grades = $gradesStmt->fetchAll();

$subjectGradesById = [];
foreach ($grades as $g) {
    $sid = (int) $g['subject_id'];
    if (!isset($subjectGradesById[$sid])) {
        $subjectGradesById[$sid] = [
            'subject_name' => $g['subject_name'],
            'subject_code' => $g['subject_code'],
            'Q1' => null,
            'Q2' => null,
            'Q3' => null,
            'Q4' => null,
        ];
    }
    $subjectGradesById[$sid][$g['quarter']] = $g['grade'];
}

$remarksBySubject = [];
$rStmt = $pdo->prepare('SELECT subject_id, learning_gaps, reinforcement_reason FROM grade_subject_remarks WHERE student_id = ? AND school_year = ?');
$rStmt->execute([$id, effectiveSchoolYear()]);
foreach ($rStmt->fetchAll(PDO::FETCH_ASSOC) as $rr) {
    $remarksBySubject[(int) $rr['subject_id']] = $rr;
}

$avgStmt = $pdo->prepare("SELECT AVG(grade) as avg_grade FROM grades WHERE student_id = ?");
$avgStmt->execute([$id]);
$avgGrade = $avgStmt->fetch()['avg_grade'] ?? 0;

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
<div class="grid grid-cols-1 <?= $role === 'guidance' ? 'md:grid-cols-2' : '' ?> gap-5 mb-6">
    <div class="stat-card" style="background:#f8fafc;">
        <div class="flex items-center justify-between mb-2">
            <span class="text-sm font-medium text-gray-600">General Average</span>
            <div class="w-10 h-10 rounded-lg flex items-center justify-center" style="background:#e2e8f0;">
                <i class="fas fa-chart-line" style="color:#475569;"></i>
            </div>
        </div>
        <p class="text-3xl font-bold text-gray-800"><?= formatNumber($avgGrade) ?></p>
    </div>
    <?php if ($role === 'guidance' && $careerRec && $careerRec['employability_score'] !== null && $careerRec['employability_score'] !== ''): ?>
    <div class="stat-card" style="background:#f0fdf4;">
        <div class="flex items-center justify-between mb-2">
            <span class="text-sm font-medium text-gray-600">Employability readiness <span class="text-xs font-normal text-gray-400">(WI)</span></span>
            <div class="w-10 h-10 rounded-lg flex items-center justify-center" style="background:#dcfce7;">
                <i class="fas fa-user-graduate" style="color:#166534;"></i>
            </div>
        </div>
        <?php $empLvl = getEmployabilityLevel((float) $careerRec['employability_score']); ?>
        <p class="text-3xl font-bold text-gray-800"><?= formatNumber($careerRec['employability_score']) ?></p>
        <span class="badge badge-<?= $empLvl['color'] === 'emerald' ? 'green' : $empLvl['color'] ?> mt-1"><?= $empLvl['label'] ?></span>
        <p class="text-xs text-gray-500 mt-2">From Work Immersion grade (course recommendations).</p>
    </div>
    <?php endif; ?>
</div>

<!-- Grades Table -->
<div class="bg-white border border-gray-200 rounded-xl overflow-hidden mb-6">
    <div class="px-6 py-4 border-b border-gray-200 flex flex-wrap items-center justify-between gap-3">
        <h3 class="text-sm font-semibold text-gray-900">Subject Grades</h3>
        <input type="search" id="subjectGradesSearch" placeholder="Search table…" autocomplete="off"
               class="form-input text-sm py-2 max-w-xs w-full sm:w-64"
               aria-label="Filter subjects">
    </div>
    <?php if ($role === 'teacher'): ?>
    <p class="px-6 py-2 text-xs text-gray-500 bg-amber-50/80 border-b border-amber-100">
        For <strong>Needs Reinforcement</strong> or <strong>Did Not Meet Expectations</strong>, add remarks: learning gaps and why reinforcement is needed.
        Both fields are <strong>required</strong> when the status is <strong>Needs Reinforcement</strong>.
    </p>
    <?php endif; ?>
    <div class="overflow-x-auto">
        <table class="steps-table" id="subjectGradesTable">
            <thead>
                <tr>
                    <th>Subject</th>
                    <th>Q1</th>
                    <th>Q2</th>
                    <th>Q3</th>
                    <th>Q4</th>
                    <th>Average</th>
                    <th>Status</th>
                    <th class="min-w-[140px]">Remarks</th>
                </tr>
            </thead>
            <tbody>
                <?php foreach ($subjectGradesById as $subjectId => $data): ?>
                    <?php
                    $q1 = $data['Q1'] ?? null;
                    $q2 = $data['Q2'] ?? null;
                    $q3 = $data['Q3'] ?? null;
                    $q4 = $data['Q4'] ?? null;
                    $vals = array_filter([$q1, $q2, $q3, $q4], fn ($v) => $v !== null);
                    $subAvg = count($vals) > 0 ? array_sum($vals) / count($vals) : 0;
                    $subComp = getCompetencyLevel($subAvg);
                    $needsRemarks = count($vals) > 0 && $subComp['level'] !== 'proficient';
                    $rem = $remarksBySubject[$subjectId] ?? null;
                    $hasRem = $rem && (trim((string) ($rem['learning_gaps'] ?? '')) !== '' || trim((string) ($rem['reinforcement_reason'] ?? '')) !== '');
                    $searchBlob = mb_strtolower($data['subject_name'] . ' ' . $data['subject_code']);
                    $remarksPayload = htmlspecialchars(json_encode([
                        'learning_gaps' => (string) (is_array($rem) ? ($rem['learning_gaps'] ?? '') : ''),
                        'reinforcement_reason' => (string) (is_array($rem) ? ($rem['reinforcement_reason'] ?? '') : ''),
                    ], JSON_HEX_TAG | JSON_HEX_APOS | JSON_HEX_QUOT | JSON_UNESCAPED_UNICODE), ENT_QUOTES, 'UTF-8');
                    ?>
                    <tr class="subject-grade-row" data-subject-search="<?= htmlspecialchars($searchBlob, ENT_QUOTES, 'UTF-8') ?>">
                        <td>
                            <span class="font-medium"><?= sanitize($data['subject_name']) ?></span>
                            <span class="text-xs text-gray-400 ml-1">(<?= sanitize($data['subject_code']) ?>)</span>
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
                        <td class="text-sm align-top">
                            <?php if (!$needsRemarks): ?>
                                <span class="text-gray-400">—</span>
                            <?php elseif ($role === 'teacher'): ?>
                                <div class="flex flex-col gap-1">
                                    <?php if ($subComp['level'] === 'at_risk' && !$hasRem): ?>
                                        <span class="text-[10px] font-semibold text-amber-700">Required</span>
                                    <?php elseif ($hasRem): ?>
                                        <span class="text-[10px] text-green-600"><i class="fas fa-check"></i> Saved</span>
                                    <?php endif; ?>
                                    <button type="button" class="btn btn-secondary btn-xs w-full sm:w-auto open-remarks-modal"
                                        data-subject-id="<?= (int) $subjectId ?>"
                                        data-subject-name="<?= htmlspecialchars($data['subject_name'], ENT_QUOTES, 'UTF-8') ?>"
                                        data-subject-code="<?= htmlspecialchars($data['subject_code'], ENT_QUOTES, 'UTF-8') ?>"
                                        data-level="<?= htmlspecialchars($subComp['level'], ENT_QUOTES, 'UTF-8') ?>"
                                        data-remarks="<?= $remarksPayload ?>">
                                        <i class="fas fa-comment-alt"></i> <?= $hasRem ? 'Edit' : 'Add' ?>
                                    </button>
                                </div>
                            <?php else: ?>
                                <?php if ($hasRem): ?>
                                    <button type="button" class="text-xs text-blue-600 hover:underline open-remarks-readonly"
                                        data-remarks="<?= $remarksPayload ?>"
                                        data-subject-name="<?= htmlspecialchars($data['subject_name'], ENT_QUOTES, 'UTF-8') ?>">
                                        View
                                    </button>
                                <?php else: ?>
                                    <span class="text-gray-400 text-xs">—</span>
                                <?php endif; ?>
                            <?php endif; ?>
                        </td>
                    </tr>
                <?php endforeach; ?>
                <?php if (empty($subjectGradesById)): ?>
                    <tr><td colspan="8" class="text-center text-gray-400 py-6">No grades recorded.</td></tr>
                <?php endif; ?>
            </tbody>
        </table>
    </div>
</div>

<?php if ($role === 'teacher'): ?>
<div id="remarksModal" class="fixed inset-0 z-50 hidden items-center justify-center p-4 bg-black/40" aria-hidden="true">
    <div class="bg-white rounded-xl shadow-xl max-w-lg w-full max-h-[90vh] overflow-y-auto p-6 relative">
        <button type="button" class="absolute top-3 right-3 text-gray-400 hover:text-gray-600 close-remarks-modal" aria-label="Close">&times;</button>
        <h4 class="text-sm font-semibold text-gray-900 mb-1">Subject remarks</h4>
        <p class="text-xs text-gray-500 mb-4" id="remarksModalSubject"></p>
        <form method="POST" id="remarksForm">
            <input type="hidden" name="action" value="save_subject_remarks">
            <input type="hidden" name="subject_id" id="remarks_subject_id" value="">
            <div class="space-y-4">
                <div>
                    <label class="form-label text-xs">What are the learning gaps?</label>
                    <textarea name="learning_gaps" id="remarks_learning_gaps" class="form-input text-sm" rows="3" placeholder="Describe learning gaps…"></textarea>
                </div>
                <div>
                    <label class="form-label text-xs">Why does this status need reinforcement?</label>
                    <textarea name="reinforcement_reason" id="remarks_reinforcement_reason" class="form-input text-sm" rows="3" placeholder="Explain why reinforcement is needed…"></textarea>
                </div>
            </div>
            <p class="text-[10px] text-amber-700 mt-3 hidden" id="remarks_required_hint">Both fields are required when status is <strong>Needs Reinforcement</strong>.</p>
            <div class="flex justify-end gap-2 mt-6 pt-4 border-t border-gray-100">
                <button type="button" class="btn btn-secondary btn-sm close-remarks-modal">Cancel</button>
                <button type="submit" class="btn btn-primary btn-sm"><i class="fas fa-save"></i> Save</button>
            </div>
        </form>
    </div>
</div>
<?php endif; ?>

<script>
document.addEventListener('DOMContentLoaded', function () {
    var search = document.getElementById('subjectGradesSearch');
    if (search) {
        search.addEventListener('input', function () {
            var q = this.value.trim().toLowerCase();
            document.querySelectorAll('.subject-grade-row').forEach(function (row) {
                var blob = (row.getAttribute('data-subject-search') || '').toLowerCase();
                row.style.display = !q || blob.indexOf(q) !== -1 ? '' : 'none';
            });
        });
    }

    var modal = document.getElementById('remarksModal');
    if (modal) {
        function openModal() { modal.classList.remove('hidden'); modal.classList.add('flex'); document.body.style.overflow = 'hidden'; }
        function closeModal() { modal.classList.add('hidden'); modal.classList.remove('flex'); document.body.style.overflow = ''; }

        document.querySelectorAll('.open-remarks-modal').forEach(function (btn) {
            btn.addEventListener('click', function () {
                var payload = {};
                try { payload = JSON.parse(btn.getAttribute('data-remarks') || '{}'); } catch (e) {}
                document.getElementById('remarks_subject_id').value = btn.getAttribute('data-subject-id') || '';
                document.getElementById('remarksModalSubject').textContent =
                    (btn.getAttribute('data-subject-name') || '') + ' (' + (btn.getAttribute('data-subject-code') || '') + ')';
                document.getElementById('remarks_learning_gaps').value = payload.learning_gaps || '';
                document.getElementById('remarks_reinforcement_reason').value = payload.reinforcement_reason || '';
                var level = btn.getAttribute('data-level') || '';
                var hint = document.getElementById('remarks_required_hint');
                var lg = document.getElementById('remarks_learning_gaps');
                var rr = document.getElementById('remarks_reinforcement_reason');
                if (level === 'at_risk') {
                    hint.classList.remove('hidden');
                    lg.setAttribute('required', 'required');
                    rr.setAttribute('required', 'required');
                } else {
                    hint.classList.add('hidden');
                    lg.removeAttribute('required');
                    rr.removeAttribute('required');
                }
                openModal();
            });
        });

        modal.querySelectorAll('.close-remarks-modal').forEach(function (b) { b.addEventListener('click', closeModal); });
        modal.addEventListener('click', function (e) { if (e.target === modal) closeModal(); });
    }

    function escapeHtml(s) {
        var d = document.createElement('div');
        d.textContent = s;
        return d.innerHTML;
    }
    document.querySelectorAll('.open-remarks-readonly').forEach(function (btn) {
        btn.addEventListener('click', function () {
            var name = btn.getAttribute('data-subject-name') || 'Subject';
            var payload = {};
            try { payload = JSON.parse(btn.getAttribute('data-remarks') || '{}'); } catch (e) {}
            var lg = payload.learning_gaps || '';
            var rr = payload.reinforcement_reason || '';
            if (typeof Swal !== 'undefined') {
                Swal.fire({
                    title: name,
                    html: '<div class="text-left text-sm space-y-3"><div><strong class="text-gray-600">Learning gaps</strong><p class="mt-1 text-gray-700 whitespace-pre-wrap">' + escapeHtml(lg) + '</p></div><div><strong class="text-gray-600">Why reinforcement is needed</strong><p class="mt-1 text-gray-700 whitespace-pre-wrap">' + escapeHtml(rr) + '</p></div></div>',
                    width: 520,
                    confirmButtonColor: '#2563eb'
                });
            } else {
                alert(name + '\n\nLearning gaps:\n' + lg + '\n\nWhy reinforcement:\n' + rr);
            }
        });
    });
});
</script>

<?php if (isset($_GET['remarks_saved'])): ?>
<script>
document.addEventListener('DOMContentLoaded', function () {
    if (typeof Swal !== 'undefined') {
        Swal.fire({ ...swalDefaults, icon: 'success', title: 'Saved', text: 'Subject remarks saved.', confirmButtonColor: '#2563eb' });
    }
});
</script>
<?php endif; ?>
<?php if (isset($_GET['remarks_error']) && $_GET['remarks_error'] === 'required'): ?>
<script>
document.addEventListener('DOMContentLoaded', function () {
    if (typeof Swal !== 'undefined') {
        Swal.fire({ ...swalDefaults, icon: 'warning', title: 'Remarks required', text: 'For Needs Reinforcement, please complete both learning gaps and why reinforcement is needed.', confirmButtonColor: '#2563eb' });
    }
});
</script>
<?php endif; ?>

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
