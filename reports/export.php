<?php
require_once __DIR__ . '/../config/database.php';
require_once __DIR__ . '/../config/constants.php';
requireRole(['teacher', 'guidance']);

$type = $_GET['type'] ?? 'dashboard';

switch ($type) {
    case 'dashboard':
        $filename = 'dashboard_report_' . date('Y-m-d') . '.csv';
        header('Content-Type: text/csv');
        header('Content-Disposition: attachment; filename="' . $filename . '"');

        $output = fopen('php://output', 'w');
        fputcsv($output, ['STEPS - Dashboard Report', 'Generated: ' . date('F d, Y h:i A'), 'S.Y. ' . effectiveSchoolYear()]);
        fputcsv($output, []);
        fputcsv($output, ['Student Name', 'LRN', 'Section', 'Strand', 'Average Grade', 'Competency Level']);

        $stmt = $pdo->query("SELECT s.first_name, s.last_name, s.lrn,
            sec.section_name, st.strand_code, AVG(g.grade) as avg_grade
            FROM students s
            LEFT JOIN sections sec ON s.section_id = sec.id
            LEFT JOIN strands st ON s.strand_id = st.id
            LEFT JOIN grades g ON s.id = g.student_id
            WHERE s.status = 'active'
            GROUP BY s.id ORDER BY s.last_name");

        while ($row = $stmt->fetch()) {
            $comp = $row['avg_grade'] ? getCompetencyLevel($row['avg_grade']) : ['label' => 'No Data'];
            fputcsv($output, [
                $row['last_name'] . ', ' . $row['first_name'],
                $row['lrn'],
                $row['section_name'] ?? 'N/A',
                $row['strand_code'] ?? 'N/A',
                $row['avg_grade'] ? number_format($row['avg_grade'], 2) : 'N/A',
                $comp['label']
            ]);
        }

        fclose($output);
        break;

    case 'competency':
        $filename = 'competency_report_' . date('Y-m-d') . '.csv';
        header('Content-Type: text/csv');
        header('Content-Disposition: attachment; filename="' . $filename . '"');

        $output = fopen('php://output', 'w');
        fputcsv($output, ['STEPS - Competency Report', 'Generated: ' . date('F d, Y h:i A')]);
        fputcsv($output, []);
        fputcsv($output, ['Subject', 'Code', 'Average Grade', 'Students', 'Competency Level']);

        $stmt = $pdo->query("SELECT sub.subject_name, sub.subject_code, AVG(g.grade) as avg_grade, COUNT(DISTINCT g.student_id) as cnt
            FROM grades g JOIN subjects sub ON g.subject_id = sub.id
            JOIN students s ON g.student_id = s.id WHERE s.status = 'active'
            GROUP BY sub.id ORDER BY avg_grade");

        while ($row = $stmt->fetch()) {
            $comp = getCompetencyLevel($row['avg_grade']);
            fputcsv($output, [
                $row['subject_name'], $row['subject_code'],
                number_format($row['avg_grade'], 2), $row['cnt'], $comp['label']
            ]);
        }

        fclose($output);
        break;

    case 'career':
        $filename = 'career_recommendations_' . date('Y-m-d') . '.csv';
        header('Content-Type: text/csv');
        header('Content-Disposition: attachment; filename="' . $filename . '"');

        $output = fopen('php://output', 'w');
        fputcsv($output, ['STEPS - Career Recommendations', 'Generated: ' . date('F d, Y h:i A')]);
        fputcsv($output, []);
        $isGuidance = ($_SESSION['role'] ?? '') === 'guidance';
        if ($isGuidance) {
            fputcsv($output, ['Student', 'Current Strand', 'Recommended Strand', 'Employability (WI)', 'Level', 'Strand Match', 'Courses']);
        } else {
            fputcsv($output, ['Student', 'Current Strand', 'Recommended Strand', 'Strand Match', 'Courses']);
        }

        $stmt = $pdo->query("SELECT cr.*, CONCAT(s.first_name, ' ', s.last_name) as name, st.strand_code
            FROM career_recommendations cr JOIN students s ON cr.student_id = s.id
            LEFT JOIN strands st ON s.strand_id = st.id ORDER BY s.last_name");

        while ($row = $stmt->fetch()) {
            $hasEmp = $row['employability_score'] !== null && $row['employability_score'] !== '';
            $empLvl = $hasEmp ? getEmployabilityLevel((float) $row['employability_score']) : ['label' => ''];
            if ($isGuidance) {
                fputcsv($output, [
                    $row['name'], $row['strand_code'] ?? 'N/A',
                    $row['recommended_strand'],
                    $hasEmp ? number_format((float) $row['employability_score'], 2) : '',
                    $empLvl['label'],
                    $row['strand_match'] ? 'Match' : 'Mismatch',
                    $row['recommended_courses'],
                ]);
            } else {
                fputcsv($output, [
                    $row['name'], $row['strand_code'] ?? 'N/A',
                    $row['recommended_strand'],
                    $row['strand_match'] ? 'Match' : 'Mismatch',
                    $row['recommended_courses'],
                ]);
            }
        }

        fclose($output);
        break;

    default:
        header('Location: ' . BASE_URL . 'dashboard/index.php');
        break;
}
exit;
