<?php
/**
 * API Endpoint for syncing offline grades to server
 */
session_start();
require_once __DIR__ . '/../config/database.php';
require_once __DIR__ . '/../config/constants.php';

// Only allow POST requests
if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    http_response_code(405);
    echo json_encode(['error' => 'Method not allowed']);
    exit;
}

// Require authentication
if (!isset($_SESSION['user_id']) || $_SESSION['role'] !== 'teacher') {
    http_response_code(403);
    echo json_encode(['error' => 'Unauthorized']);
    exit;
}

// Get JSON input
$input = json_decode(file_get_contents('php://input'), true);

if (!$input || !isset($input['student_id'], $input['subject_id'], $input['grade'], $input['quarter'])) {
    http_response_code(400);
    echo json_encode(['error' => 'Missing required fields']);
    exit;
}

$studentId = (int)$input['student_id'];
$subjectId = (int)$input['subject_id'];
$grade = (float)$input['grade'];
$quarter = sanitize($input['quarter']);
$schoolYear = isset($input['school_year']) ? sanitize($input['school_year']) : effectiveSchoolYear();
$encodedBy = $_SESSION['user_id'];

try {
    // Validate grade range
    if ($grade < 60 || $grade > 100) {
        http_response_code(400);
        echo json_encode(['error' => 'Grade must be between 60 and 100']);
        exit;
    }
    
    // Check if student exists and is active
    $studentCheck = $pdo->prepare("SELECT id FROM students WHERE id = ? AND status = 'active'");
    $studentCheck->execute([$studentId]);
    if (!$studentCheck->fetch()) {
        http_response_code(404);
        echo json_encode(['error' => 'Student not found or inactive']);
        exit;
    }
    
    // Insert or update grade using upsert
    $stmt = $pdo->prepare("INSERT INTO grades (student_id, subject_id, quarter, grade, school_year, encoded_by)
        VALUES (?, ?, ?, ?, ?, ?)
        ON DUPLICATE KEY UPDATE grade = VALUES(grade), encoded_by = VALUES(encoded_by), updated_at = NOW()");
    
    $stmt->execute([$studentId, $subjectId, $quarter, $grade, $schoolYear, $encodedBy]);
    
    // Log the sync
    $logStmt = $pdo->prepare("INSERT INTO activity_logs (user_id, action, description, ip_address) VALUES (?, 'grade_sync', ?, ?)");
    $logStmt->execute([$encodedBy, "Synced grade for student $studentId", $_SERVER['REMOTE_ADDR'] ?? '']);
    
    echo json_encode([
        'success' => true,
        'message' => 'Grade synced successfully',
        'data' => [
            'student_id' => $studentId,
            'subject_id' => $subjectId,
            'grade' => $grade,
            'quarter' => $quarter
        ]
    ]);
    
} catch (PDOException $e) {
    error_log('Grade sync error: ' . $e->getMessage());
    http_response_code(500);
    echo json_encode(['error' => 'Database error occurred']);
}
