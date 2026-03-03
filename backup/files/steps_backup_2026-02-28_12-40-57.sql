-- STEPS Database Backup
-- Date: February 28, 2026 12:40:57 PM
-- Database: steps_db

SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS `activity_logs`;
CREATE TABLE `activity_logs` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int DEFAULT NULL,
  `action` varchar(100) NOT NULL,
  `description` text,
  `ip_address` varchar(45) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `activity_logs_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=41 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('1', '1', 'logout', 'User logged out', '::1', '2026-02-27 20:25:35');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('2', '1', 'login', 'User logged in', '::1', '2026-02-27 20:25:42');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('3', '1', 'logout', 'User logged out', '::1', '2026-02-27 20:26:53');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('4', '1', 'login', 'User logged in', '::1', '2026-02-27 20:27:00');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('5', '1', 'logout', 'User logged out', '::1', '2026-02-27 20:43:28');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('6', '1', 'login', 'User logged in', '::1', '2026-02-27 20:52:41');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('7', '1', 'logout', 'User logged out', '::1', '2026-02-27 20:52:47');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('8', '1', 'login', 'User logged in', '::1', '2026-02-27 20:52:52');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('9', '1', 'logout', 'User logged out', '::1', '2026-02-27 20:57:57');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('10', '1', 'login', 'User logged in', '::1', '2026-02-27 21:07:35');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('11', '1', 'logout', 'User logged out', '::1', '2026-02-27 21:07:43');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('12', '1', 'login', 'User logged in', '::1', '2026-02-27 21:10:22');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('13', '1', 'logout', 'User logged out', '::1', '2026-02-27 21:10:27');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('14', '1', 'login', 'User logged in', '::1', '2026-02-27 21:10:33');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('15', '1', 'logout', 'User logged out', '::1', '2026-02-27 21:10:58');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('16', '1', 'login', 'User logged in', '::1', '2026-02-27 21:11:15');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('17', '1', 'backup', 'Created backup: steps_backup_2026-02-27_13-12-29.sql', '::1', '2026-02-27 21:12:29');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('18', '1', 'logout', 'User logged out', '::1', '2026-02-27 21:12:36');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('19', '1', 'login', 'User logged in', '::1', '2026-02-27 21:14:00');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('20', '1', 'bulk_import', 'Bulk import: 1 inserted, 2 skipped from student_import_template.csv', '::1', '2026-02-27 21:15:30');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('21', '1', 'bulk_import', 'Bulk import: 1 inserted, 2 skipped from student_import_template.csv', '::1', '2026-02-27 21:20:54');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('22', '1', 'bulk_import', 'Bulk import: 0 inserted, 3 skipped from student_import_template.csv', '::1', '2026-02-27 21:22:07');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('23', '1', 'bulk_import', 'Bulk import: 1 inserted, 2 skipped from student_import_template.csv', '::1', '2026-02-27 21:23:50');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('24', '1', 'bulk_import', 'Bulk import: 2 inserted, 1 skipped from student_import_template.csv', '::1', '2026-02-27 21:24:24');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('25', '1', 'bulk_import', 'Bulk import: 2 inserted, 1 skipped from student_import_template.csv', '::1', '2026-02-27 21:26:19');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('26', '1', 'bulk_import', 'Bulk import: 2 inserted, 1 skipped from student_import_template.csv', '::1', '2026-02-27 21:31:24');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('27', '1', 'bulk_import', 'Bulk import: 2 inserted, 1 skipped from student_import_template.csv', '::1', '2026-02-27 21:37:52');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('28', '1', 'login', 'User logged in', '::1', '2026-02-28 19:45:54');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('29', '1', 'logout', 'User logged out', '::1', '2026-02-28 19:46:07');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('30', '1', 'login', 'User logged in', '::1', '2026-02-28 19:46:25');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('31', '1', 'logout', 'User logged out', '::1', '2026-02-28 19:46:53');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('32', '7', 'login', 'User logged in', '::1', '2026-02-28 19:46:58');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('33', '7', 'bulk_import_grades', 'Bulk grade import: 0 inserted, 0 updated, 3 skipped from grade_import_template.csv', '::1', '2026-02-28 19:51:52');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('34', '7', 'bulk_import_grades', 'Bulk grade import: 3 inserted, 0 updated, 0 skipped from grade_import_template.csv', '::1', '2026-02-28 19:53:41');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('35', '7', 'logout', 'User logged out', '::1', '2026-02-28 20:18:25');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('36', '1', 'login', 'User logged in', '::1', '2026-02-28 20:18:30');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('37', '1', 'logout', 'User logged out', '::1', '2026-02-28 20:19:06');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('38', '8', 'login', 'User logged in', '::1', '2026-02-28 20:19:34');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('39', '8', 'logout', 'User logged out', '::1', '2026-02-28 20:40:49');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('40', '1', 'login', 'User logged in', '::1', '2026-02-28 20:40:53');

DROP TABLE IF EXISTS `backup_logs`;
CREATE TABLE `backup_logs` (
  `id` int NOT NULL AUTO_INCREMENT,
  `backup_file` varchar(255) NOT NULL,
  `file_size` varchar(50) DEFAULT NULL,
  `backup_type` enum('full','partial') NOT NULL DEFAULT 'full',
  `created_by` int DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `created_by` (`created_by`),
  CONSTRAINT `backup_logs_ibfk_1` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO `backup_logs` (`id`, `backup_file`, `file_size`, `backup_type`, `created_by`, `created_at`) VALUES ('1', 'steps_backup_2026-02-27_13-12-29.sql', '53.54 KB', 'full', '1', '2026-02-27 21:12:29');

DROP TABLE IF EXISTS `career_recommendations`;
CREATE TABLE `career_recommendations` (
  `id` int NOT NULL AUTO_INCREMENT,
  `student_id` int NOT NULL,
  `recommended_strand` varchar(100) DEFAULT NULL,
  `recommended_courses` text,
  `employability_score` decimal(5,2) DEFAULT NULL,
  `employability_level` enum('low','moderate','high','very_high') NOT NULL DEFAULT 'moderate',
  `strand_match` tinyint(1) DEFAULT '1',
  `mismatch_remarks` text,
  `career_pathways` text,
  `generated_by` int DEFAULT NULL,
  `school_year` varchar(20) NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `student_id` (`student_id`),
  KEY `generated_by` (`generated_by`),
  CONSTRAINT `career_recommendations_ibfk_1` FOREIGN KEY (`student_id`) REFERENCES `students` (`id`) ON DELETE CASCADE,
  CONSTRAINT `career_recommendations_ibfk_2` FOREIGN KEY (`generated_by`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO `career_recommendations` (`id`, `student_id`, `recommended_strand`, `recommended_courses`, `employability_score`, `employability_level`, `strand_match`, `mismatch_remarks`, `career_pathways`, `generated_by`, `school_year`, `created_at`) VALUES ('3', '8', 'Science, Technology, Engineering and Mathematics', 'BS Computer Science, BS Information Technology, BS Civil Engineering, BS Mechanical Engineering, BS Electrical Engineering, BS Nursing, BS Mathematics', '94.60', 'very_high', '1', NULL, 'Software Development / IT Industry, Systems Administration / Web Development, Construction / Infrastructure, Manufacturing / Automotive, Power / Electronics Industry, Healthcare / Medical, Education / Research / Data Science', '1', '2025-2026', '2026-02-27 20:53:03');

DROP TABLE IF EXISTS `competency_records`;
CREATE TABLE `competency_records` (
  `id` int NOT NULL AUTO_INCREMENT,
  `student_id` int NOT NULL,
  `subject_id` int NOT NULL,
  `average_grade` decimal(5,2) NOT NULL,
  `competency_level` enum('weak','at_risk','proficient') NOT NULL,
  `remarks` varchar(100) DEFAULT NULL,
  `school_year` varchar(20) NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `student_id` (`student_id`),
  KEY `subject_id` (`subject_id`),
  CONSTRAINT `competency_records_ibfk_1` FOREIGN KEY (`student_id`) REFERENCES `students` (`id`) ON DELETE CASCADE,
  CONSTRAINT `competency_records_ibfk_2` FOREIGN KEY (`subject_id`) REFERENCES `subjects` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS `diagnostic_reports`;
CREATE TABLE `diagnostic_reports` (
  `id` int NOT NULL AUTO_INCREMENT,
  `student_id` int DEFAULT NULL,
  `section_id` int DEFAULT NULL,
  `report_type` enum('individual','section','class_performance','competency') NOT NULL,
  `report_data` json DEFAULT NULL,
  `generated_by` int DEFAULT NULL,
  `school_year` varchar(20) NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `student_id` (`student_id`),
  KEY `section_id` (`section_id`),
  KEY `generated_by` (`generated_by`),
  CONSTRAINT `diagnostic_reports_ibfk_1` FOREIGN KEY (`student_id`) REFERENCES `students` (`id`) ON DELETE CASCADE,
  CONSTRAINT `diagnostic_reports_ibfk_2` FOREIGN KEY (`section_id`) REFERENCES `sections` (`id`) ON DELETE CASCADE,
  CONSTRAINT `diagnostic_reports_ibfk_3` FOREIGN KEY (`generated_by`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO `diagnostic_reports` (`id`, `student_id`, `section_id`, `report_type`, `report_data`, `generated_by`, `school_year`, `created_at`) VALUES ('1', '6', NULL, 'individual', '{\"avg_grade\": \"91.333333\", \"competency\": {\"color\": \"emerald\", \"label\": \"Meets Expectations\", \"level\": \"proficient\"}, \"student_name\": \"Sofia Villanueva\", \"work_immersion\": \"93.00\", \"career_recommendation\": null}', '1', '2025-2026', '2026-02-27 19:57:39');
INSERT INTO `diagnostic_reports` (`id`, `student_id`, `section_id`, `report_type`, `report_data`, `generated_by`, `school_year`, `created_at`) VALUES ('2', NULL, '1', 'section', '{\"date\": \"2026-02-28 12:33:00\", \"section\": \"Section A\", \"total_students\": 4}', '8', '2025-2026', '2026-02-28 20:33:00');

DROP TABLE IF EXISTS `grades`;
CREATE TABLE `grades` (
  `id` int NOT NULL AUTO_INCREMENT,
  `student_id` int NOT NULL,
  `subject_id` int NOT NULL,
  `quarter` enum('Q1','Q2','Q3','Q4') NOT NULL,
  `grade` decimal(5,2) NOT NULL,
  `school_year` varchar(20) NOT NULL,
  `encoded_by` int DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_grade` (`student_id`,`subject_id`,`quarter`,`school_year`),
  KEY `subject_id` (`subject_id`),
  KEY `encoded_by` (`encoded_by`),
  CONSTRAINT `grades_ibfk_1` FOREIGN KEY (`student_id`) REFERENCES `students` (`id`) ON DELETE CASCADE,
  CONSTRAINT `grades_ibfk_2` FOREIGN KEY (`subject_id`) REFERENCES `subjects` (`id`) ON DELETE CASCADE,
  CONSTRAINT `grades_ibfk_3` FOREIGN KEY (`encoded_by`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=59 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('1', '1', '4', 'Q1', '88.00', '2025-2026', '2', '2026-02-27 18:39:34', '2026-02-27 18:39:34');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('2', '1', '4', 'Q2', '90.00', '2025-2026', '2', '2026-02-27 18:39:34', '2026-02-27 18:39:34');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('3', '1', '21', 'Q1', '85.00', '2025-2026', '2', '2026-02-27 18:39:34', '2026-02-27 18:39:34');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('4', '1', '21', 'Q2', '87.00', '2025-2026', '2', '2026-02-27 18:39:34', '2026-02-27 18:39:34');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('5', '1', '23', 'Q1', '92.00', '2025-2026', '2', '2026-02-27 18:39:34', '2026-02-27 18:39:34');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('6', '1', '23', 'Q2', '91.00', '2025-2026', '2', '2026-02-27 18:39:34', '2026-02-27 18:39:34');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('7', '1', '1', 'Q1', '86.00', '2025-2026', '2', '2026-02-27 18:39:34', '2026-02-27 18:39:34');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('8', '1', '1', 'Q2', '88.00', '2025-2026', '2', '2026-02-27 18:39:34', '2026-02-27 18:39:34');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('9', '2', '4', 'Q1', '78.00', '2025-2026', '2', '2026-02-27 18:39:34', '2026-02-27 18:39:34');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('10', '2', '4', 'Q2', '76.00', '2025-2026', '2', '2026-02-27 18:39:34', '2026-02-27 18:39:34');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('11', '2', '21', 'Q1', '74.00', '2025-2026', '2', '2026-02-27 18:39:34', '2026-02-27 18:39:34');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('12', '2', '21', 'Q2', '73.00', '2025-2026', '2', '2026-02-27 18:39:34', '2026-02-27 18:39:34');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('13', '2', '23', 'Q1', '80.00', '2025-2026', '2', '2026-02-27 18:39:34', '2026-02-27 18:39:34');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('14', '2', '23', 'Q2', '79.00', '2025-2026', '2', '2026-02-27 18:39:34', '2026-02-27 18:39:34');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('15', '2', '1', 'Q1', '82.00', '2025-2026', '2', '2026-02-27 18:39:34', '2026-02-27 18:39:34');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('16', '2', '1', 'Q2', '81.00', '2025-2026', '2', '2026-02-27 18:39:34', '2026-02-27 18:39:34');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('17', '3', '4', 'Q1', '72.00', '2025-2026', '2', '2026-02-27 18:39:34', '2026-02-27 18:39:34');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('18', '3', '4', 'Q2', '70.00', '2025-2026', '2', '2026-02-27 18:39:34', '2026-02-27 18:39:34');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('19', '3', '21', 'Q1', '68.00', '2025-2026', '2', '2026-02-27 18:39:34', '2026-02-27 18:39:34');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('20', '3', '21', 'Q2', '71.00', '2025-2026', '2', '2026-02-27 18:39:34', '2026-02-27 18:39:34');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('21', '3', '23', 'Q1', '74.00', '2025-2026', '2', '2026-02-27 18:39:34', '2026-02-27 18:39:34');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('22', '3', '23', 'Q2', '73.00', '2025-2026', '2', '2026-02-27 18:39:34', '2026-02-27 18:39:34');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('23', '3', '1', 'Q1', '75.00', '2025-2026', '2', '2026-02-27 18:39:34', '2026-02-27 18:39:34');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('24', '3', '1', 'Q2', '76.00', '2025-2026', '2', '2026-02-27 18:39:34', '2026-02-27 18:39:34');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('25', '4', '30', 'Q1', '89.00', '2025-2026', '2', '2026-02-27 18:39:34', '2026-02-27 18:39:34');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('26', '4', '30', 'Q2', '91.00', '2025-2026', '2', '2026-02-27 18:39:34', '2026-02-27 18:39:34');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('27', '4', '33', 'Q1', '87.00', '2025-2026', '2', '2026-02-27 18:39:34', '2026-02-27 18:39:34');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('28', '4', '33', 'Q2', '90.00', '2025-2026', '2', '2026-02-27 18:39:34', '2026-02-27 18:39:34');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('29', '4', '1', 'Q1', '85.00', '2025-2026', '2', '2026-02-27 18:39:34', '2026-02-27 18:39:34');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('30', '4', '1', 'Q2', '88.00', '2025-2026', '2', '2026-02-27 18:39:34', '2026-02-27 18:39:34');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('31', '5', '30', 'Q1', '76.00', '2025-2026', '2', '2026-02-27 18:39:34', '2026-02-27 18:39:34');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('32', '5', '30', 'Q2', '78.00', '2025-2026', '2', '2026-02-27 18:39:34', '2026-02-27 18:39:34');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('33', '5', '33', 'Q1', '74.00', '2025-2026', '2', '2026-02-27 18:39:34', '2026-02-27 18:39:34');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('34', '5', '33', 'Q2', '77.00', '2025-2026', '2', '2026-02-27 18:39:34', '2026-02-27 18:39:34');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('35', '5', '1', 'Q1', '79.00', '2025-2026', '2', '2026-02-27 18:39:34', '2026-02-27 18:39:34');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('36', '5', '1', 'Q2', '80.00', '2025-2026', '2', '2026-02-27 18:39:34', '2026-02-27 18:39:34');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('37', '6', '38', 'Q1', '90.00', '2025-2026', '2', '2026-02-27 18:39:34', '2026-02-27 18:39:34');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('38', '6', '38', 'Q2', '92.00', '2025-2026', '2', '2026-02-27 18:39:34', '2026-02-27 18:39:34');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('39', '6', '39', 'Q1', '88.00', '2025-2026', '2', '2026-02-27 18:39:34', '2026-02-27 18:39:34');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('40', '6', '39', 'Q2', '91.00', '2025-2026', '2', '2026-02-27 18:39:34', '2026-02-27 18:39:34');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('41', '6', '1', 'Q1', '93.00', '2025-2026', '2', '2026-02-27 18:39:34', '2026-02-27 18:39:34');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('42', '6', '1', 'Q2', '94.00', '2025-2026', '2', '2026-02-27 18:39:34', '2026-02-27 18:39:34');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('43', '7', '38', 'Q1', '77.00', '2025-2026', '2', '2026-02-27 18:39:34', '2026-02-27 18:39:34');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('44', '7', '38', 'Q2', '75.00', '2025-2026', '2', '2026-02-27 18:39:34', '2026-02-27 18:39:34');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('45', '7', '39', 'Q1', '79.00', '2025-2026', '2', '2026-02-27 18:39:34', '2026-02-27 18:39:34');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('46', '7', '39', 'Q2', '78.00', '2025-2026', '2', '2026-02-27 18:39:34', '2026-02-27 18:39:34');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('47', '7', '1', 'Q1', '76.00', '2025-2026', '2', '2026-02-27 18:39:34', '2026-02-27 18:39:34');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('48', '7', '1', 'Q2', '77.00', '2025-2026', '2', '2026-02-27 18:39:34', '2026-02-27 18:39:34');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('49', '8', '4', 'Q1', '95.00', '2025-2026', '2', '2026-02-27 18:39:34', '2026-02-27 18:39:34');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('50', '8', '4', 'Q2', '96.00', '2025-2026', '2', '2026-02-27 18:39:34', '2026-02-27 18:39:34');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('51', '8', '21', 'Q1', '93.00', '2025-2026', '2', '2026-02-27 18:39:34', '2026-02-27 18:39:34');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('52', '8', '21', 'Q2', '94.00', '2025-2026', '2', '2026-02-27 18:39:34', '2026-02-27 18:39:34');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('53', '8', '23', 'Q1', '91.00', '2025-2026', '2', '2026-02-27 18:39:34', '2026-02-27 18:39:34');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('54', '8', '23', 'Q2', '93.00', '2025-2026', '2', '2026-02-27 18:39:34', '2026-02-27 18:39:34');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('55', '1', '12', 'Q1', '89.00', '2025-2026', '1', '2026-02-27 21:11:53', '2026-02-27 21:11:53');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('56', '13', '4', 'Q1', '88.00', '2025-2026', '7', '2026-02-28 19:53:41', '2026-02-28 19:53:41');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('57', '13', '4', 'Q2', '90.00', '2025-2026', '7', '2026-02-28 19:53:41', '2026-02-28 19:53:41');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('58', '13', '21', 'Q1', '85.00', '2025-2026', '7', '2026-02-28 19:53:41', '2026-02-28 19:53:41');

DROP TABLE IF EXISTS `import_logs`;
CREATE TABLE `import_logs` (
  `id` int NOT NULL AUTO_INCREMENT,
  `file_name` varchar(255) NOT NULL,
  `total_rows` int DEFAULT '0',
  `inserted` int DEFAULT '0',
  `skipped` int DEFAULT '0',
  `errors` text,
  `imported_by` int DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `imported_by` (`imported_by`),
  CONSTRAINT `import_logs_ibfk_1` FOREIGN KEY (`imported_by`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO `import_logs` (`id`, `file_name`, `total_rows`, `inserted`, `skipped`, `errors`, `imported_by`, `created_at`) VALUES ('1', 'student_import_template.csv', '3', '1', '2', '[\"Row 3: Missing required fields (LRN, name, gender, or school year), skipped.\",\"Row 4: Missing required fields (LRN, name, gender, or school year), skipped.\"]', '1', '2026-02-27 21:15:30');
INSERT INTO `import_logs` (`id`, `file_name`, `total_rows`, `inserted`, `skipped`, `errors`, `imported_by`, `created_at`) VALUES ('2', 'student_import_template.csv', '3', '1', '2', '[\"Row 3: Missing required fields (LRN, name, gender, or school year), skipped.\",\"Row 4: Missing required fields (LRN, name, gender, or school year), skipped.\"]', '1', '2026-02-27 21:20:54');
INSERT INTO `import_logs` (`id`, `file_name`, `total_rows`, `inserted`, `skipped`, `errors`, `imported_by`, `created_at`) VALUES ('3', 'student_import_template.csv', '3', '0', '3', '[\"Row 2 (100100000000): LRN already exists, skipped.\",\"Row 3 (176588000000): Invalid gender \\\"Femal\\\", skipped.\",\"Row 4: Missing required fields (LRN, name, gender, or school year), skipped.\"]', '1', '2026-02-27 21:22:07');
INSERT INTO `import_logs` (`id`, `file_name`, `total_rows`, `inserted`, `skipped`, `errors`, `imported_by`, `created_at`) VALUES ('4', 'student_import_template.csv', '3', '1', '2', '[\"Row 3 (176588000000): Invalid gender \\\"Femal\\\", skipped.\",\"Row 4: Missing required fields (LRN, name, gender, or school year), skipped.\"]', '1', '2026-02-27 21:23:50');
INSERT INTO `import_logs` (`id`, `file_name`, `total_rows`, `inserted`, `skipped`, `errors`, `imported_by`, `created_at`) VALUES ('5', 'student_import_template.csv', '3', '2', '1', '[\"Row 3 (176588000000): Strand \\\"humms\\\" not found, student added without strand.\",\"Row 4: Missing required fields (LRN, name, gender, or school year), skipped.\"]', '1', '2026-02-27 21:24:24');
INSERT INTO `import_logs` (`id`, `file_name`, `total_rows`, `inserted`, `skipped`, `errors`, `imported_by`, `created_at`) VALUES ('6', 'student_import_template.csv', '3', '2', '1', '[\"Row 3 (176588429111): Strand \\\"humms\\\" not found, student added without strand.\",\"Row 4: Missing required fields (LRN, name, gender, or school year), skipped.\"]', '1', '2026-02-27 21:26:19');
INSERT INTO `import_logs` (`id`, `file_name`, `total_rows`, `inserted`, `skipped`, `errors`, `imported_by`, `created_at`) VALUES ('7', 'student_import_template.csv', '3', '2', '1', '[\"Row 3 (176588429111): Strand \\\"humms\\\" not found, student added without strand.\",\"Row 4: Missing required fields (LRN, name, gender, or school year), skipped.\"]', '1', '2026-02-27 21:31:24');
INSERT INTO `import_logs` (`id`, `file_name`, `total_rows`, `inserted`, `skipped`, `errors`, `imported_by`, `created_at`) VALUES ('8', 'student_import_template.csv', '3', '2', '1', '[\"Row 3 (176588429111): Strand \\\"humms\\\" not found, student added without strand.\",\"Row 4: Missing required fields (LRN, name, gender, or school year), skipped.\"]', '1', '2026-02-27 21:37:52');
INSERT INTO `import_logs` (`id`, `file_name`, `total_rows`, `inserted`, `skipped`, `errors`, `imported_by`, `created_at`) VALUES ('9', 'grade_import_template.csv', '3', '0', '3', '[\"Row 2: LRN \\\"123456\\\" not found in the system, skipped.\",\"Row 3: LRN \\\"123456\\\" not found in the system, skipped.\",\"Row 4: LRN \\\"123456\\\" not found in the system, skipped.\"]', '7', '2026-02-28 19:51:52');
INSERT INTO `import_logs` (`id`, `file_name`, `total_rows`, `inserted`, `skipped`, `errors`, `imported_by`, `created_at`) VALUES ('10', 'grade_import_template.csv', '3', '3', '0', NULL, '7', '2026-02-28 19:53:41');

DROP TABLE IF EXISTS `sections`;
CREATE TABLE `sections` (
  `id` int NOT NULL AUTO_INCREMENT,
  `section_name` varchar(50) NOT NULL,
  `grade_level` int NOT NULL,
  `strand` varchar(50) DEFAULT NULL,
  `adviser_id` int DEFAULT NULL,
  `school_year` varchar(20) NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `adviser_id` (`adviser_id`),
  CONSTRAINT `sections_ibfk_1` FOREIGN KEY (`adviser_id`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO `sections` (`id`, `section_name`, `grade_level`, `strand`, `adviser_id`, `school_year`, `created_at`) VALUES ('1', 'Section A', '11', 'STEM', '2', '2025-2026', '2026-02-27 18:39:34');
INSERT INTO `sections` (`id`, `section_name`, `grade_level`, `strand`, `adviser_id`, `school_year`, `created_at`) VALUES ('2', 'Section B', '11', 'ABM', '3', '2025-2026', '2026-02-27 18:39:34');
INSERT INTO `sections` (`id`, `section_name`, `grade_level`, `strand`, `adviser_id`, `school_year`, `created_at`) VALUES ('3', 'Section C', '11', 'HUMSS', '4', '2025-2026', '2026-02-27 18:39:34');
INSERT INTO `sections` (`id`, `section_name`, `grade_level`, `strand`, `adviser_id`, `school_year`, `created_at`) VALUES ('4', 'Section D', '11', 'GAS', '2', '2025-2026', '2026-02-27 18:39:34');
INSERT INTO `sections` (`id`, `section_name`, `grade_level`, `strand`, `adviser_id`, `school_year`, `created_at`) VALUES ('5', 'Section E', '11', 'TVL-ICT', '3', '2025-2026', '2026-02-27 18:39:34');
INSERT INTO `sections` (`id`, `section_name`, `grade_level`, `strand`, `adviser_id`, `school_year`, `created_at`) VALUES ('6', 'Section F', '12', 'STEM', '2', '2025-2026', '2026-02-27 18:39:34');
INSERT INTO `sections` (`id`, `section_name`, `grade_level`, `strand`, `adviser_id`, `school_year`, `created_at`) VALUES ('7', 'Section G', '12', 'ABM', '4', '2025-2026', '2026-02-27 18:39:34');
INSERT INTO `sections` (`id`, `section_name`, `grade_level`, `strand`, `adviser_id`, `school_year`, `created_at`) VALUES ('8', 'Section H', '12', 'HUMSS', '3', '2025-2026', '2026-02-27 18:39:34');
INSERT INTO `sections` (`id`, `section_name`, `grade_level`, `strand`, `adviser_id`, `school_year`, `created_at`) VALUES ('9', 'Section I', '12', 'GAS', '2', '2025-2026', '2026-02-27 18:39:34');
INSERT INTO `sections` (`id`, `section_name`, `grade_level`, `strand`, `adviser_id`, `school_year`, `created_at`) VALUES ('10', 'Section J', '12', 'TVL-ICT', '4', '2025-2026', '2026-02-27 18:39:34');

DROP TABLE IF EXISTS `strand_course_mapping`;
CREATE TABLE `strand_course_mapping` (
  `id` int NOT NULL AUTO_INCREMENT,
  `strand_id` int NOT NULL,
  `course_name` varchar(150) NOT NULL,
  `career_pathway` varchar(200) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `strand_id` (`strand_id`),
  CONSTRAINT `strand_course_mapping_ibfk_1` FOREIGN KEY (`strand_id`) REFERENCES `strands` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=28 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO `strand_course_mapping` (`id`, `strand_id`, `course_name`, `career_pathway`, `created_at`) VALUES ('1', '1', 'BS Computer Science', 'Software Development / IT Industry', '2026-02-27 18:39:35');
INSERT INTO `strand_course_mapping` (`id`, `strand_id`, `course_name`, `career_pathway`, `created_at`) VALUES ('2', '1', 'BS Information Technology', 'Systems Administration / Web Development', '2026-02-27 18:39:35');
INSERT INTO `strand_course_mapping` (`id`, `strand_id`, `course_name`, `career_pathway`, `created_at`) VALUES ('3', '1', 'BS Civil Engineering', 'Construction / Infrastructure', '2026-02-27 18:39:35');
INSERT INTO `strand_course_mapping` (`id`, `strand_id`, `course_name`, `career_pathway`, `created_at`) VALUES ('4', '1', 'BS Mechanical Engineering', 'Manufacturing / Automotive', '2026-02-27 18:39:35');
INSERT INTO `strand_course_mapping` (`id`, `strand_id`, `course_name`, `career_pathway`, `created_at`) VALUES ('5', '1', 'BS Electrical Engineering', 'Power / Electronics Industry', '2026-02-27 18:39:35');
INSERT INTO `strand_course_mapping` (`id`, `strand_id`, `course_name`, `career_pathway`, `created_at`) VALUES ('6', '1', 'BS Nursing', 'Healthcare / Medical', '2026-02-27 18:39:35');
INSERT INTO `strand_course_mapping` (`id`, `strand_id`, `course_name`, `career_pathway`, `created_at`) VALUES ('7', '1', 'BS Mathematics', 'Education / Research / Data Science', '2026-02-27 18:39:35');
INSERT INTO `strand_course_mapping` (`id`, `strand_id`, `course_name`, `career_pathway`, `created_at`) VALUES ('8', '2', 'BS Accountancy', 'Auditing / Finance', '2026-02-27 18:39:35');
INSERT INTO `strand_course_mapping` (`id`, `strand_id`, `course_name`, `career_pathway`, `created_at`) VALUES ('9', '2', 'BS Business Administration', 'Corporate Management / Entrepreneurship', '2026-02-27 18:39:35');
INSERT INTO `strand_course_mapping` (`id`, `strand_id`, `course_name`, `career_pathway`, `created_at`) VALUES ('10', '2', 'BS Marketing Management', 'Advertising / Sales / Digital Marketing', '2026-02-27 18:39:35');
INSERT INTO `strand_course_mapping` (`id`, `strand_id`, `course_name`, `career_pathway`, `created_at`) VALUES ('11', '2', 'BS Customs Administration', 'Import-Export / Logistics', '2026-02-27 18:39:35');
INSERT INTO `strand_course_mapping` (`id`, `strand_id`, `course_name`, `career_pathway`, `created_at`) VALUES ('12', '2', 'BS Hospitality Management', 'Hotel / Restaurant Industry', '2026-02-27 18:39:35');
INSERT INTO `strand_course_mapping` (`id`, `strand_id`, `course_name`, `career_pathway`, `created_at`) VALUES ('13', '3', 'BA Communication', 'Media / Journalism / Public Relations', '2026-02-27 18:39:35');
INSERT INTO `strand_course_mapping` (`id`, `strand_id`, `course_name`, `career_pathway`, `created_at`) VALUES ('14', '3', 'BA Political Science', 'Law / Government / Diplomacy', '2026-02-27 18:39:35');
INSERT INTO `strand_course_mapping` (`id`, `strand_id`, `course_name`, `career_pathway`, `created_at`) VALUES ('15', '3', 'BA Psychology', 'Counseling / Human Resources', '2026-02-27 18:39:35');
INSERT INTO `strand_course_mapping` (`id`, `strand_id`, `course_name`, `career_pathway`, `created_at`) VALUES ('16', '3', 'BA Sociology', 'Social Work / Community Development', '2026-02-27 18:39:35');
INSERT INTO `strand_course_mapping` (`id`, `strand_id`, `course_name`, `career_pathway`, `created_at`) VALUES ('17', '3', 'AB English', 'Education / Writing / Translation', '2026-02-27 18:39:35');
INSERT INTO `strand_course_mapping` (`id`, `strand_id`, `course_name`, `career_pathway`, `created_at`) VALUES ('18', '4', 'Any Bachelor Degree', 'Flexible - Multiple Career Options', '2026-02-27 18:39:35');
INSERT INTO `strand_course_mapping` (`id`, `strand_id`, `course_name`, `career_pathway`, `created_at`) VALUES ('19', '5', 'BS Information Technology', 'Web Development / Systems Admin', '2026-02-27 18:39:35');
INSERT INTO `strand_course_mapping` (`id`, `strand_id`, `course_name`, `career_pathway`, `created_at`) VALUES ('20', '5', 'BS Computer Science', 'Software Engineering / Programming', '2026-02-27 18:39:35');
INSERT INTO `strand_course_mapping` (`id`, `strand_id`, `course_name`, `career_pathway`, `created_at`) VALUES ('21', '6', 'BS Hotel & Restaurant Management', 'Hospitality Industry', '2026-02-27 18:39:35');
INSERT INTO `strand_course_mapping` (`id`, `strand_id`, `course_name`, `career_pathway`, `created_at`) VALUES ('22', '6', 'BS Tourism Management', 'Travel / Tourism Industry', '2026-02-27 18:39:35');
INSERT INTO `strand_course_mapping` (`id`, `strand_id`, `course_name`, `career_pathway`, `created_at`) VALUES ('23', '7', 'BS Industrial Technology', 'Manufacturing / Technical Work', '2026-02-27 18:39:35');
INSERT INTO `strand_course_mapping` (`id`, `strand_id`, `course_name`, `career_pathway`, `created_at`) VALUES ('24', '8', 'BS Physical Education', 'Sports Management / Coaching', '2026-02-27 18:39:35');
INSERT INTO `strand_course_mapping` (`id`, `strand_id`, `course_name`, `career_pathway`, `created_at`) VALUES ('25', '8', 'BS Sports Science', 'Athletic Training / Fitness', '2026-02-27 18:39:35');
INSERT INTO `strand_course_mapping` (`id`, `strand_id`, `course_name`, `career_pathway`, `created_at`) VALUES ('26', '9', 'BFA Fine Arts', 'Visual Arts / Gallery Management', '2026-02-27 18:39:35');
INSERT INTO `strand_course_mapping` (`id`, `strand_id`, `course_name`, `career_pathway`, `created_at`) VALUES ('27', '9', 'BS Multimedia Arts', 'Digital Media / Animation / Graphic Design', '2026-02-27 18:39:35');

DROP TABLE IF EXISTS `strands`;
CREATE TABLE `strands` (
  `id` int NOT NULL AUTO_INCREMENT,
  `strand_code` varchar(20) NOT NULL,
  `strand_name` varchar(100) NOT NULL,
  `description` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `strand_code` (`strand_code`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO `strands` (`id`, `strand_code`, `strand_name`, `description`, `created_at`) VALUES ('1', 'STEM', 'Science, Technology, Engineering and Mathematics', 'Focus on advanced math, science, and technology subjects', '2026-02-27 18:39:34');
INSERT INTO `strands` (`id`, `strand_code`, `strand_name`, `description`, `created_at`) VALUES ('2', 'ABM', 'Accountancy, Business and Management', 'Focus on business, finance, and management subjects', '2026-02-27 18:39:34');
INSERT INTO `strands` (`id`, `strand_code`, `strand_name`, `description`, `created_at`) VALUES ('3', 'HUMSS', 'Humanities and Social Sciences', 'Focus on liberal arts, social sciences, and communication', '2026-02-27 18:39:34');
INSERT INTO `strands` (`id`, `strand_code`, `strand_name`, `description`, `created_at`) VALUES ('4', 'GAS', 'General Academic Strand', 'Broad academic foundation across disciplines', '2026-02-27 18:39:34');
INSERT INTO `strands` (`id`, `strand_code`, `strand_name`, `description`, `created_at`) VALUES ('5', 'TVL-ICT', 'Technical-Vocational-Livelihood: ICT', 'Focus on Information and Communications Technology', '2026-02-27 18:39:34');
INSERT INTO `strands` (`id`, `strand_code`, `strand_name`, `description`, `created_at`) VALUES ('6', 'TVL-HE', 'Technical-Vocational-Livelihood: Home Economics', 'Focus on Home Economics and hospitality', '2026-02-27 18:39:34');
INSERT INTO `strands` (`id`, `strand_code`, `strand_name`, `description`, `created_at`) VALUES ('7', 'TVL-IA', 'Technical-Vocational-Livelihood: Industrial Arts', 'Focus on Industrial Arts and technical skills', '2026-02-27 18:39:34');
INSERT INTO `strands` (`id`, `strand_code`, `strand_name`, `description`, `created_at`) VALUES ('8', 'SPORTS', 'Sports Track', 'Focus on sports science, fitness, and athletics', '2026-02-27 18:39:34');
INSERT INTO `strands` (`id`, `strand_code`, `strand_name`, `description`, `created_at`) VALUES ('9', 'ARTS', 'Arts and Design Track', 'Focus on creative arts, media, and design', '2026-02-27 18:39:34');

DROP TABLE IF EXISTS `students`;
CREATE TABLE `students` (
  `id` int NOT NULL AUTO_INCREMENT,
  `lrn` varchar(20) NOT NULL,
  `first_name` varchar(50) NOT NULL,
  `last_name` varchar(50) NOT NULL,
  `middle_name` varchar(50) DEFAULT NULL,
  `gender` enum('Male','Female') NOT NULL,
  `birthdate` date DEFAULT NULL,
  `section_id` int DEFAULT NULL,
  `strand_id` int DEFAULT NULL,
  `school_year` varchar(20) NOT NULL,
  `status` enum('active','inactive','graduated') NOT NULL DEFAULT 'active',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `lrn` (`lrn`),
  KEY `section_id` (`section_id`),
  KEY `strand_id` (`strand_id`),
  CONSTRAINT `students_ibfk_1` FOREIGN KEY (`section_id`) REFERENCES `sections` (`id`) ON DELETE SET NULL,
  CONSTRAINT `students_ibfk_2` FOREIGN KEY (`strand_id`) REFERENCES `strands` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO `students` (`id`, `lrn`, `first_name`, `last_name`, `middle_name`, `gender`, `birthdate`, `section_id`, `strand_id`, `school_year`, `status`, `created_at`, `updated_at`) VALUES ('1', '100100100001', 'Juan', 'Dela Cruz', 'Santos', 'Male', '2008-03-15', '1', '1', '2025-2026', 'active', '2026-02-27 18:39:34', '2026-02-27 18:39:34');
INSERT INTO `students` (`id`, `lrn`, `first_name`, `last_name`, `middle_name`, `gender`, `birthdate`, `section_id`, `strand_id`, `school_year`, `status`, `created_at`, `updated_at`) VALUES ('2', '100100100002', 'Maria', 'Garcia', 'Reyes', 'Female', '2008-06-21', '1', '1', '2025-2026', 'active', '2026-02-27 18:39:34', '2026-02-27 18:39:34');
INSERT INTO `students` (`id`, `lrn`, `first_name`, `last_name`, `middle_name`, `gender`, `birthdate`, `section_id`, `strand_id`, `school_year`, `status`, `created_at`, `updated_at`) VALUES ('3', '100100100003', 'Pedro', 'Ramos', 'Lim', 'Male', '2008-01-10', '1', '1', '2025-2026', 'active', '2026-02-27 18:39:34', '2026-02-27 18:39:34');
INSERT INTO `students` (`id`, `lrn`, `first_name`, `last_name`, `middle_name`, `gender`, `birthdate`, `section_id`, `strand_id`, `school_year`, `status`, `created_at`, `updated_at`) VALUES ('4', '100100100004', 'Ana', 'Lopez', 'Cruz', 'Female', '2008-09-05', '2', '2', '2025-2026', 'active', '2026-02-27 18:39:34', '2026-02-27 18:39:34');
INSERT INTO `students` (`id`, `lrn`, `first_name`, `last_name`, `middle_name`, `gender`, `birthdate`, `section_id`, `strand_id`, `school_year`, `status`, `created_at`, `updated_at`) VALUES ('5', '100100100005', 'Carlos', 'Mendoza', 'Bautista', 'Male', '2007-12-18', '2', '2', '2025-2026', 'active', '2026-02-27 18:39:34', '2026-02-27 18:39:34');
INSERT INTO `students` (`id`, `lrn`, `first_name`, `last_name`, `middle_name`, `gender`, `birthdate`, `section_id`, `strand_id`, `school_year`, `status`, `created_at`, `updated_at`) VALUES ('6', '100100100006', 'Sofia', 'Villanueva', 'Torres', 'Female', '2008-04-22', '3', '3', '2025-2026', 'active', '2026-02-27 18:39:34', '2026-02-27 18:39:34');
INSERT INTO `students` (`id`, `lrn`, `first_name`, `last_name`, `middle_name`, `gender`, `birthdate`, `section_id`, `strand_id`, `school_year`, `status`, `created_at`, `updated_at`) VALUES ('7', '100100100007', 'Miguel', 'Aquino', 'Santos', 'Male', '2007-08-30', '3', '3', '2025-2026', 'active', '2026-02-27 18:39:34', '2026-02-27 18:39:34');
INSERT INTO `students` (`id`, `lrn`, `first_name`, `last_name`, `middle_name`, `gender`, `birthdate`, `section_id`, `strand_id`, `school_year`, `status`, `created_at`, `updated_at`) VALUES ('8', '100100100008', 'Isabella', 'Fernandez', 'Reyes', 'Female', '2008-02-14', '6', '1', '2025-2026', 'active', '2026-02-27 18:39:34', '2026-02-27 18:39:34');
INSERT INTO `students` (`id`, `lrn`, `first_name`, `last_name`, `middle_name`, `gender`, `birthdate`, `section_id`, `strand_id`, `school_year`, `status`, `created_at`, `updated_at`) VALUES ('9', '0123456', 'Javy', 'Monsion', 'Daylusan', 'Male', '2026-02-27', '10', '1', '2025-2026', 'active', '2026-02-27 20:02:11', '2026-02-27 20:02:11');
INSERT INTO `students` (`id`, `lrn`, `first_name`, `last_name`, `middle_name`, `gender`, `birthdate`, `section_id`, `strand_id`, `school_year`, `status`, `created_at`, `updated_at`) VALUES ('12', '100100100100', 'Romel', 'Dumam-ag', 'Pamplona', 'Male', '2008-03-15', '10', '1', '2025-2026', 'active', '2026-02-27 21:37:52', '2026-02-27 21:37:52');
INSERT INTO `students` (`id`, `lrn`, `first_name`, `last_name`, `middle_name`, `gender`, `birthdate`, `section_id`, `strand_id`, `school_year`, `status`, `created_at`, `updated_at`) VALUES ('13', '176588429111', 'Kane Joy', 'Urbayo', 'Omero', 'Female', '2002-02-25', '1', NULL, '2025-2026', 'active', '2026-02-27 21:37:52', '2026-02-27 21:37:52');

DROP TABLE IF EXISTS `subjects`;
CREATE TABLE `subjects` (
  `id` int NOT NULL AUTO_INCREMENT,
  `subject_code` varchar(20) NOT NULL,
  `subject_name` varchar(100) NOT NULL,
  `strand_id` int DEFAULT NULL,
  `subject_type` enum('core','specialized','applied','immersion') NOT NULL DEFAULT 'core',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `strand_id` (`strand_id`),
  CONSTRAINT `subjects_ibfk_1` FOREIGN KEY (`strand_id`) REFERENCES `strands` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=56 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `strand_id`, `subject_type`, `created_at`) VALUES ('1', 'CORE01', 'Oral Communication', NULL, 'core', '2026-02-27 18:39:34');
INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `strand_id`, `subject_type`, `created_at`) VALUES ('2', 'CORE02', 'Reading and Writing', NULL, 'core', '2026-02-27 18:39:34');
INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `strand_id`, `subject_type`, `created_at`) VALUES ('3', 'CORE03', 'Komunikasyon at Pananaliksik', NULL, 'core', '2026-02-27 18:39:34');
INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `strand_id`, `subject_type`, `created_at`) VALUES ('4', 'CORE04', 'General Mathematics', NULL, 'core', '2026-02-27 18:39:34');
INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `strand_id`, `subject_type`, `created_at`) VALUES ('5', 'CORE05', 'Earth and Life Science', NULL, 'core', '2026-02-27 18:39:34');
INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `strand_id`, `subject_type`, `created_at`) VALUES ('6', 'CORE06', 'Physical Science', NULL, 'core', '2026-02-27 18:39:34');
INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `strand_id`, `subject_type`, `created_at`) VALUES ('7', 'CORE07', 'Personal Development', NULL, 'core', '2026-02-27 18:39:34');
INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `strand_id`, `subject_type`, `created_at`) VALUES ('8', 'CORE08', 'Understanding Culture, Society, and Politics', NULL, 'core', '2026-02-27 18:39:34');
INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `strand_id`, `subject_type`, `created_at`) VALUES ('9', 'CORE09', 'Introduction to Philosophy', NULL, 'core', '2026-02-27 18:39:34');
INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `strand_id`, `subject_type`, `created_at`) VALUES ('10', 'CORE10', 'Physical Education and Health', NULL, 'core', '2026-02-27 18:39:34');
INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `strand_id`, `subject_type`, `created_at`) VALUES ('11', 'CORE11', 'Media and Information Literacy', NULL, 'core', '2026-02-27 18:39:34');
INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `strand_id`, `subject_type`, `created_at`) VALUES ('12', 'CORE12', '21st Century Literature from the Philippines and the World', NULL, 'core', '2026-02-27 18:39:34');
INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `strand_id`, `subject_type`, `created_at`) VALUES ('13', 'CORE13', 'Contemporary Philippine Arts from the Regions', NULL, 'core', '2026-02-27 18:39:34');
INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `strand_id`, `subject_type`, `created_at`) VALUES ('14', 'APP01', 'English for Academic and Professional Purposes', NULL, 'applied', '2026-02-27 18:39:34');
INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `strand_id`, `subject_type`, `created_at`) VALUES ('15', 'APP02', 'Practical Research 1', NULL, 'applied', '2026-02-27 18:39:34');
INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `strand_id`, `subject_type`, `created_at`) VALUES ('16', 'APP03', 'Practical Research 2', NULL, 'applied', '2026-02-27 18:39:34');
INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `strand_id`, `subject_type`, `created_at`) VALUES ('17', 'APP04', 'Filipino sa Piling Larangan', NULL, 'applied', '2026-02-27 18:39:34');
INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `strand_id`, `subject_type`, `created_at`) VALUES ('18', 'APP05', 'Empowerment Technologies', NULL, 'applied', '2026-02-27 18:39:34');
INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `strand_id`, `subject_type`, `created_at`) VALUES ('19', 'APP06', 'Entrepreneurship', NULL, 'applied', '2026-02-27 18:39:34');
INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `strand_id`, `subject_type`, `created_at`) VALUES ('20', 'APP07', 'Inquiries, Investigations, and Immersion', NULL, 'applied', '2026-02-27 18:39:34');
INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `strand_id`, `subject_type`, `created_at`) VALUES ('21', 'STEM01', 'Pre-Calculus', '1', 'specialized', '2026-02-27 18:39:34');
INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `strand_id`, `subject_type`, `created_at`) VALUES ('22', 'STEM02', 'Basic Calculus', '1', 'specialized', '2026-02-27 18:39:34');
INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `strand_id`, `subject_type`, `created_at`) VALUES ('23', 'STEM03', 'General Biology 1', '1', 'specialized', '2026-02-27 18:39:34');
INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `strand_id`, `subject_type`, `created_at`) VALUES ('24', 'STEM04', 'General Biology 2', '1', 'specialized', '2026-02-27 18:39:34');
INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `strand_id`, `subject_type`, `created_at`) VALUES ('25', 'STEM05', 'General Chemistry 1', '1', 'specialized', '2026-02-27 18:39:34');
INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `strand_id`, `subject_type`, `created_at`) VALUES ('26', 'STEM06', 'General Chemistry 2', '1', 'specialized', '2026-02-27 18:39:34');
INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `strand_id`, `subject_type`, `created_at`) VALUES ('27', 'STEM07', 'General Physics 1', '1', 'specialized', '2026-02-27 18:39:34');
INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `strand_id`, `subject_type`, `created_at`) VALUES ('28', 'STEM08', 'General Physics 2', '1', 'specialized', '2026-02-27 18:39:34');
INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `strand_id`, `subject_type`, `created_at`) VALUES ('29', 'STEM09', 'Research/Capstone Project', '1', 'specialized', '2026-02-27 18:39:34');
INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `strand_id`, `subject_type`, `created_at`) VALUES ('30', 'ABM01', 'Fundamentals of ABM 1', '2', 'specialized', '2026-02-27 18:39:34');
INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `strand_id`, `subject_type`, `created_at`) VALUES ('31', 'ABM02', 'Fundamentals of ABM 2', '2', 'specialized', '2026-02-27 18:39:34');
INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `strand_id`, `subject_type`, `created_at`) VALUES ('32', 'ABM03', 'Business Mathematics', '2', 'specialized', '2026-02-27 18:39:34');
INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `strand_id`, `subject_type`, `created_at`) VALUES ('33', 'ABM04', 'Business Finance', '2', 'specialized', '2026-02-27 18:39:34');
INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `strand_id`, `subject_type`, `created_at`) VALUES ('34', 'ABM05', 'Organization and Management', '2', 'specialized', '2026-02-27 18:39:34');
INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `strand_id`, `subject_type`, `created_at`) VALUES ('35', 'ABM06', 'Principles of Marketing', '2', 'specialized', '2026-02-27 18:39:34');
INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `strand_id`, `subject_type`, `created_at`) VALUES ('36', 'ABM07', 'Business Ethics and Social Responsibility', '2', 'specialized', '2026-02-27 18:39:34');
INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `strand_id`, `subject_type`, `created_at`) VALUES ('37', 'ABM08', 'Applied Economics', '2', 'specialized', '2026-02-27 18:39:34');
INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `strand_id`, `subject_type`, `created_at`) VALUES ('38', 'HUM01', 'Introduction to World Religions', '3', 'specialized', '2026-02-27 18:39:34');
INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `strand_id`, `subject_type`, `created_at`) VALUES ('39', 'HUM02', 'Creative Writing', '3', 'specialized', '2026-02-27 18:39:34');
INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `strand_id`, `subject_type`, `created_at`) VALUES ('40', 'HUM03', 'Creative Nonfiction', '3', 'specialized', '2026-02-27 18:39:34');
INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `strand_id`, `subject_type`, `created_at`) VALUES ('41', 'HUM04', 'Trends, Networks, and Critical Thinking', '3', 'specialized', '2026-02-27 18:39:34');
INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `strand_id`, `subject_type`, `created_at`) VALUES ('42', 'HUM05', 'Philippine Politics and Governance', '3', 'specialized', '2026-02-27 18:39:34');
INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `strand_id`, `subject_type`, `created_at`) VALUES ('43', 'HUM06', 'Community Engagement', '3', 'specialized', '2026-02-27 18:39:34');
INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `strand_id`, `subject_type`, `created_at`) VALUES ('44', 'HUM07', 'Disciplines and Ideas in Social Sciences', '3', 'specialized', '2026-02-27 18:39:34');
INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `strand_id`, `subject_type`, `created_at`) VALUES ('45', 'GAS01', 'Humanities 1', '4', 'specialized', '2026-02-27 18:39:34');
INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `strand_id`, `subject_type`, `created_at`) VALUES ('46', 'GAS02', 'Humanities 2', '4', 'specialized', '2026-02-27 18:39:34');
INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `strand_id`, `subject_type`, `created_at`) VALUES ('47', 'GAS03', 'Social Science 1', '4', 'specialized', '2026-02-27 18:39:34');
INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `strand_id`, `subject_type`, `created_at`) VALUES ('48', 'GAS04', 'Applied Economics', '4', 'specialized', '2026-02-27 18:39:34');
INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `strand_id`, `subject_type`, `created_at`) VALUES ('49', 'GAS05', 'Organization and Management', '4', 'specialized', '2026-02-27 18:39:34');
INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `strand_id`, `subject_type`, `created_at`) VALUES ('50', 'GAS06', 'Disaster Readiness and Risk Reduction', '4', 'specialized', '2026-02-27 18:39:34');
INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `strand_id`, `subject_type`, `created_at`) VALUES ('51', 'ICT01', 'Computer Systems Servicing NC II', '5', 'specialized', '2026-02-27 18:39:34');
INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `strand_id`, `subject_type`, `created_at`) VALUES ('52', 'ICT02', 'Computer Programming', '5', 'specialized', '2026-02-27 18:39:34');
INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `strand_id`, `subject_type`, `created_at`) VALUES ('53', 'ICT03', 'Web Development', '5', 'specialized', '2026-02-27 18:39:34');
INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `strand_id`, `subject_type`, `created_at`) VALUES ('54', 'ICT04', 'Illustration and Animation', '5', 'specialized', '2026-02-27 18:39:34');
INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `strand_id`, `subject_type`, `created_at`) VALUES ('55', 'WI101', 'Work Immersion', NULL, 'immersion', '2026-02-27 18:39:34');

DROP TABLE IF EXISTS `users`;
CREATE TABLE `users` (
  `id` int NOT NULL AUTO_INCREMENT,
  `username` varchar(50) NOT NULL,
  `password` varchar(255) NOT NULL,
  `full_name` varchar(100) NOT NULL,
  `email` varchar(100) DEFAULT NULL,
  `role` enum('admin','teacher','guidance') NOT NULL DEFAULT 'teacher',
  `status` enum('active','inactive') NOT NULL DEFAULT 'active',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO `users` (`id`, `username`, `password`, `full_name`, `email`, `role`, `status`, `created_at`, `updated_at`) VALUES ('1', 'admin', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'System Administrator', 'admin@steps.edu', 'admin', 'active', '2026-02-27 18:39:34', '2026-02-27 18:39:34');
INSERT INTO `users` (`id`, `username`, `password`, `full_name`, `email`, `role`, `status`, `created_at`, `updated_at`) VALUES ('2', 'teacher_santos', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Maria Santos', 'maria@steps.edu', 'teacher', 'active', '2026-02-27 18:39:34', '2026-02-27 18:39:34');
INSERT INTO `users` (`id`, `username`, `password`, `full_name`, `email`, `role`, `status`, `created_at`, `updated_at`) VALUES ('3', 'teacher_delos_reyes', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Carlos Delos Reyes', 'carlos@steps.edu', 'teacher', 'active', '2026-02-27 18:39:34', '2026-02-27 18:39:34');
INSERT INTO `users` (`id`, `username`, `password`, `full_name`, `email`, `role`, `status`, `created_at`, `updated_at`) VALUES ('4', 'teacher_cruz', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Ana Cruz', 'ana@steps.edu', 'teacher', 'inactive', '2026-02-27 18:39:34', '2026-02-27 19:54:07');
INSERT INTO `users` (`id`, `username`, `password`, `full_name`, `email`, `role`, `status`, `created_at`, `updated_at`) VALUES ('5', 'guidance_reyes', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Jose Reyes', 'jose@steps.edu', 'guidance', 'active', '2026-02-27 18:39:34', '2026-02-27 18:39:34');
INSERT INTO `users` (`id`, `username`, `password`, `full_name`, `email`, `role`, `status`, `created_at`, `updated_at`) VALUES ('6', 'guidance_mendoza', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Sofia Mendoza', 'sofia@steps.edu', 'guidance', 'active', '2026-02-27 18:39:34', '2026-02-27 18:39:34');
INSERT INTO `users` (`id`, `username`, `password`, `full_name`, `email`, `role`, `status`, `created_at`, `updated_at`) VALUES ('7', 'teacher_monsion', '$2y$10$WijLqFlwa3azHgJxDMdabewjF6B6G5akfVuorFpQid12IBexLXUQe', 'Javidec Monsion', 'monsionjav@gmail.com', 'teacher', 'active', '2026-02-28 19:46:49', '2026-02-28 19:46:49');
INSERT INTO `users` (`id`, `username`, `password`, `full_name`, `email`, `role`, `status`, `created_at`, `updated_at`) VALUES ('8', 'guidance_doe', '$2y$10$MVLf.4auBiGuQpScMAwJGucdFIgVsG2pg9nK0iymVsqTHkaiwykLy', 'John Doe', 'john@gmail.com', 'guidance', 'active', '2026-02-28 20:19:01', '2026-02-28 20:19:01');

DROP TABLE IF EXISTS `work_immersion`;
CREATE TABLE `work_immersion` (
  `id` int NOT NULL AUTO_INCREMENT,
  `student_id` int NOT NULL,
  `company_name` varchar(150) DEFAULT NULL,
  `rating` decimal(5,2) NOT NULL,
  `hours_completed` int DEFAULT '0',
  `performance_remarks` text,
  `school_year` varchar(20) NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `student_id` (`student_id`),
  CONSTRAINT `work_immersion_ibfk_1` FOREIGN KEY (`student_id`) REFERENCES `students` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO `work_immersion` (`id`, `student_id`, `company_name`, `rating`, `hours_completed`, `performance_remarks`, `school_year`, `created_at`) VALUES ('1', '1', 'Tech Solutions Inc.', '88.50', '320', 'Good performance in technical tasks', '2025-2026', '2026-02-27 18:39:35');
INSERT INTO `work_immersion` (`id`, `student_id`, `company_name`, `rating`, `hours_completed`, `performance_remarks`, `school_year`, `created_at`) VALUES ('2', '2', 'Tech Solutions Inc.', '75.00', '300', 'Needs improvement in initiative', '2025-2026', '2026-02-27 18:39:35');
INSERT INTO `work_immersion` (`id`, `student_id`, `company_name`, `rating`, `hours_completed`, `performance_remarks`, `school_year`, `created_at`) VALUES ('3', '3', 'DataCore Systems', '70.50', '280', 'Below average performance', '2025-2026', '2026-02-27 18:39:35');
INSERT INTO `work_immersion` (`id`, `student_id`, `company_name`, `rating`, `hours_completed`, `performance_remarks`, `school_year`, `created_at`) VALUES ('4', '4', 'BusinessFirst Corp.', '91.00', '320', 'Excellent business acumen', '2025-2026', '2026-02-27 18:39:35');
INSERT INTO `work_immersion` (`id`, `student_id`, `company_name`, `rating`, `hours_completed`, `performance_remarks`, `school_year`, `created_at`) VALUES ('5', '5', 'BusinessFirst Corp.', '77.00', '310', 'Average performance', '2025-2026', '2026-02-27 18:39:35');
INSERT INTO `work_immersion` (`id`, `student_id`, `company_name`, `rating`, `hours_completed`, `performance_remarks`, `school_year`, `created_at`) VALUES ('6', '6', 'Community Center', '93.00', '320', 'Outstanding communication skills', '2025-2026', '2026-02-27 18:39:35');
INSERT INTO `work_immersion` (`id`, `student_id`, `company_name`, `rating`, `hours_completed`, `performance_remarks`, `school_year`, `created_at`) VALUES ('7', '7', 'Community Center', '76.00', '290', 'Satisfactory performance', '2025-2026', '2026-02-27 18:39:35');
INSERT INTO `work_immersion` (`id`, `student_id`, `company_name`, `rating`, `hours_completed`, `performance_remarks`, `school_year`, `created_at`) VALUES ('8', '8', 'InnoTech Labs', '95.00', '320', 'Exceptional technical ability', '2025-2026', '2026-02-27 18:39:35');

SET FOREIGN_KEY_CHECKS = 1;
