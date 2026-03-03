-- STEPS Database Backup
-- Date: March 03, 2026 02:45:08 PM
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
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('2', '1', 'logout', 'User logged out', '::1', '2026-03-03 21:46:07');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('3', '1', 'login', 'User logged in', '::1', '2026-03-03 21:46:20');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('4', '1', 'logout', 'User logged out', '::1', '2026-03-03 21:46:40');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('5', '7', 'login', 'User logged in', '::1', '2026-03-03 21:46:58');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('6', '7', 'logout', 'User logged out', '::1', '2026-03-03 22:00:27');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('7', '1', 'login', 'User logged in', '::1', '2026-03-03 22:05:04');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('8', '1', 'logout', 'User logged out', '::1', '2026-03-03 22:05:26');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('9', '1', 'login', 'User logged in', '::1', '2026-03-03 22:05:41');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('10', '1', 'logout', 'User logged out', '::1', '2026-03-03 22:06:41');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('11', '1', 'login', 'User logged in', '::1', '2026-03-03 22:06:54');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('12', NULL, 'logout', 'User logged out', '::1', '2026-03-03 22:13:52');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('13', '1', 'login', 'User logged in', '::1', '2026-03-03 22:14:07');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('14', '1', 'logout', 'User logged out', '::1', '2026-03-03 22:19:34');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('15', '1', 'login', 'User logged in', '::1', '2026-03-03 22:19:45');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('16', '1', 'logout', 'User logged out', '::1', '2026-03-03 22:34:06');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('17', '1', 'login', 'User logged in', '::1', '2026-03-03 22:34:13');

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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS `career_recommendations`;
CREATE TABLE `career_recommendations` (
  `id` int NOT NULL AUTO_INCREMENT,
  `student_id` int NOT NULL,
  `recommendation_type` enum('strand','course') NOT NULL DEFAULT 'strand',
  `top_strand_1` varchar(100) DEFAULT NULL,
  `top_strand_2` varchar(100) DEFAULT NULL,
  `top_strand_3` varchar(100) DEFAULT NULL,
  `top_course_1` varchar(150) DEFAULT NULL,
  `top_course_2` varchar(150) DEFAULT NULL,
  `top_course_3` varchar(150) DEFAULT NULL,
  `recommended_strand` varchar(100) DEFAULT NULL,
  `recommended_courses` text,
  `employability_score` decimal(5,2) DEFAULT NULL,
  `employability_level` enum('low','moderate','high','very_high') NOT NULL DEFAULT 'moderate',
  `strand_match` tinyint(1) DEFAULT '1',
  `mismatch_remarks` text,
  `career_pathways` text,
  `score_breakdown` json DEFAULT NULL,
  `generated_by` int DEFAULT NULL,
  `school_year` varchar(20) NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `student_id` (`student_id`),
  KEY `generated_by` (`generated_by`),
  CONSTRAINT `career_recommendations_ibfk_1` FOREIGN KEY (`student_id`) REFERENCES `students` (`id`) ON DELETE CASCADE,
  CONSTRAINT `career_recommendations_ibfk_2` FOREIGN KEY (`generated_by`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO `career_recommendations` (`id`, `student_id`, `recommendation_type`, `top_strand_1`, `top_strand_2`, `top_strand_3`, `top_course_1`, `top_course_2`, `top_course_3`, `recommended_strand`, `recommended_courses`, `employability_score`, `employability_level`, `strand_match`, `mismatch_remarks`, `career_pathways`, `score_breakdown`, `generated_by`, `school_year`, `created_at`, `updated_at`) VALUES ('2', '9', 'strand', 'Science, Technology, Engineering and Mathematics', 'Technical-Vocational-Livelihood: ICT', 'Accountancy, Business and Management', NULL, NULL, NULL, 'Science, Technology, Engineering and Mathematics', NULL, NULL, 'moderate', '1', NULL, NULL, '{\"q4_average\": 87.375, \"top_strands\": [{\"score\": 85.3875, \"nai_score\": 80, \"strand_id\": 1, \"strand_code\": \"STEM\", \"strand_name\": \"Science, Technology, Engineering and Mathematics\", \"academic_score\": 87.375, \"exam_component\": 88.5}, {\"score\": 80.5875, \"nai_score\": 64, \"strand_id\": 5, \"strand_code\": \"TVL-ICT\", \"strand_name\": \"Technical-Vocational-Livelihood: ICT\", \"academic_score\": 87.375, \"exam_component\": 88.5}, {\"score\": 79.3875, \"nai_score\": 60, \"strand_id\": 2, \"strand_code\": \"ABM\", \"strand_name\": \"Accountancy, Business and Management\", \"academic_score\": 87.375, \"exam_component\": 88.5}], \"generated_at\": \"2026-03-03 13:08:05\", \"entrance_exam\": \"88.50\"}', '1', '2025-2026', '2026-03-03 21:08:05', '2026-03-03 21:08:05');
INSERT INTO `career_recommendations` (`id`, `student_id`, `recommendation_type`, `top_strand_1`, `top_strand_2`, `top_strand_3`, `top_course_1`, `top_course_2`, `top_course_3`, `recommended_strand`, `recommended_courses`, `employability_score`, `employability_level`, `strand_match`, `mismatch_remarks`, `career_pathways`, `score_breakdown`, `generated_by`, `school_year`, `created_at`, `updated_at`) VALUES ('3', '12', 'strand', 'Arts and Design Track', 'Science, Technology, Engineering and Mathematics', 'Technical-Vocational-Livelihood: ICT', NULL, NULL, NULL, 'Arts and Design Track', NULL, NULL, 'moderate', '1', NULL, NULL, '{\"q4_average\": 87.25, \"top_strands\": [{\"score\": 81.225, \"nai_score\": 72, \"strand_id\": 9, \"strand_code\": \"ARTS\", \"strand_name\": \"Arts and Design Track\", \"academic_score\": 87.25, \"exam_component\": 80}, {\"score\": 78.825, \"nai_score\": 64, \"strand_id\": 1, \"strand_code\": \"STEM\", \"strand_name\": \"Science, Technology, Engineering and Mathematics\", \"academic_score\": 87.25, \"exam_component\": 80}, {\"score\": 78.525, \"nai_score\": 63, \"strand_id\": 5, \"strand_code\": \"TVL-ICT\", \"strand_name\": \"Technical-Vocational-Livelihood: ICT\", \"academic_score\": 87.25, \"exam_component\": 80}], \"generated_at\": \"2026-03-03 13:08:24\", \"entrance_exam\": \"80.00\"}', '1', '2025-2026', '2026-03-03 21:08:24', '2026-03-03 21:08:24');
INSERT INTO `career_recommendations` (`id`, `student_id`, `recommendation_type`, `top_strand_1`, `top_strand_2`, `top_strand_3`, `top_course_1`, `top_course_2`, `top_course_3`, `recommended_strand`, `recommended_courses`, `employability_score`, `employability_level`, `strand_match`, `mismatch_remarks`, `career_pathways`, `score_breakdown`, `generated_by`, `school_year`, `created_at`, `updated_at`) VALUES ('4', '13', 'strand', 'Technical-Vocational-Livelihood: Home Economics', 'Sports Track', 'Accountancy, Business and Management', NULL, NULL, NULL, 'Technical-Vocational-Livelihood: Home Economics', NULL, NULL, 'moderate', '1', NULL, NULL, '{\"q4_average\": 86.25, \"top_strands\": [{\"score\": 79.125, \"nai_score\": 67, \"strand_id\": 6, \"strand_code\": \"TVL-HE\", \"strand_name\": \"Technical-Vocational-Livelihood: Home Economics\", \"academic_score\": 86.25, \"exam_component\": 79.5}, {\"score\": 79.125, \"nai_score\": 67, \"strand_id\": 8, \"strand_code\": \"SPORTS\", \"strand_name\": \"Sports Track\", \"academic_score\": 86.25, \"exam_component\": 79.5}, {\"score\": 78.225, \"nai_score\": 64, \"strand_id\": 2, \"strand_code\": \"ABM\", \"strand_name\": \"Accountancy, Business and Management\", \"academic_score\": 86.25, \"exam_component\": 79.5}], \"generated_at\": \"2026-03-03 13:08:38\", \"entrance_exam\": \"79.50\"}', '1', '2025-2026', '2026-03-03 21:08:38', '2026-03-03 21:08:38');
INSERT INTO `career_recommendations` (`id`, `student_id`, `recommendation_type`, `top_strand_1`, `top_strand_2`, `top_strand_3`, `top_course_1`, `top_course_2`, `top_course_3`, `recommended_strand`, `recommended_courses`, `employability_score`, `employability_level`, `strand_match`, `mismatch_remarks`, `career_pathways`, `score_breakdown`, `generated_by`, `school_year`, `created_at`, `updated_at`) VALUES ('5', '10', 'strand', 'Technical-Vocational-Livelihood: Home Economics', 'Technical-Vocational-Livelihood: ICT', 'Technical-Vocational-Livelihood: Industrial Arts', NULL, NULL, NULL, 'Technical-Vocational-Livelihood: Home Economics', NULL, NULL, 'moderate', '1', NULL, NULL, '{\"q4_average\": 85.5, \"top_strands\": [{\"score\": 80.45, \"nai_score\": 75, \"strand_id\": 6, \"strand_code\": \"TVL-HE\", \"strand_name\": \"Technical-Vocational-Livelihood: Home Economics\", \"academic_score\": 85.5, \"exam_component\": 76}, {\"score\": 76.85, \"nai_score\": 63, \"strand_id\": 5, \"strand_code\": \"TVL-ICT\", \"strand_name\": \"Technical-Vocational-Livelihood: ICT\", \"academic_score\": 85.5, \"exam_component\": 76}, {\"score\": 76.85, \"nai_score\": 63, \"strand_id\": 7, \"strand_code\": \"TVL-IA\", \"strand_name\": \"Technical-Vocational-Livelihood: Industrial Arts\", \"academic_score\": 85.5, \"exam_component\": 76}], \"generated_at\": \"2026-03-03 13:08:53\", \"entrance_exam\": \"76.00\"}', '1', '2025-2026', '2026-03-03 21:08:53', '2026-03-03 21:08:53');
INSERT INTO `career_recommendations` (`id`, `student_id`, `recommendation_type`, `top_strand_1`, `top_strand_2`, `top_strand_3`, `top_course_1`, `top_course_2`, `top_course_3`, `recommended_strand`, `recommended_courses`, `employability_score`, `employability_level`, `strand_match`, `mismatch_remarks`, `career_pathways`, `score_breakdown`, `generated_by`, `school_year`, `created_at`, `updated_at`) VALUES ('8', '11', 'strand', 'Humanities and Social Sciences', 'Arts and Design Track', 'Science, Technology, Engineering and Mathematics', NULL, NULL, NULL, 'Humanities and Social Sciences', NULL, NULL, 'moderate', '1', NULL, NULL, '{\"q4_average\": 88.25, \"top_strands\": [{\"score\": 82.725, \"nai_score\": 72, \"strand_id\": 3, \"strand_code\": \"HUMSS\", \"strand_name\": \"Humanities and Social Sciences\", \"academic_score\": 88.25, \"exam_component\": 85}, {\"score\": 82.725, \"nai_score\": 72, \"strand_id\": 9, \"strand_code\": \"ARTS\", \"strand_name\": \"Arts and Design Track\", \"academic_score\": 88.25, \"exam_component\": 85}, {\"score\": 79.125, \"nai_score\": 60, \"strand_id\": 1, \"strand_code\": \"STEM\", \"strand_name\": \"Science, Technology, Engineering and Mathematics\", \"academic_score\": 88.25, \"exam_component\": 85}], \"generated_at\": \"2026-03-03 13:12:37\", \"entrance_exam\": \"85.00\"}', NULL, '2025-2026', '2026-03-03 21:12:37', '2026-03-03 21:12:37');
INSERT INTO `career_recommendations` (`id`, `student_id`, `recommendation_type`, `top_strand_1`, `top_strand_2`, `top_strand_3`, `top_course_1`, `top_course_2`, `top_course_3`, `recommended_strand`, `recommended_courses`, `employability_score`, `employability_level`, `strand_match`, `mismatch_remarks`, `career_pathways`, `score_breakdown`, `generated_by`, `school_year`, `created_at`, `updated_at`) VALUES ('9', '6', 'course', NULL, NULL, NULL, 'BS Information Technology', 'BS Computer Science', 'BS Hotel & Restaurant Management', 'Technical-Vocational-Livelihood: ICT', 'BS Information Technology, BS Computer Science, BS Hotel & Restaurant Management', '87.60', 'high', '0', 'Student\'s current strand (HUMSS) may not align with strongest academic areas.', 'Web Development / Systems Admin, Software Engineering / Programming, Hospitality Industry', '{\"top_courses\": [{\"score\": 82.50999999999999, \"course_name\": \"BS Information Technology\", \"strand_code\": \"TVL-ICT\", \"strand_name\": \"Technical-Vocational-Livelihood: ICT\", \"career_pathway\": \"Web Development / Systems Admin\"}, {\"score\": 82.50999999999999, \"course_name\": \"BS Computer Science\", \"strand_code\": \"TVL-ICT\", \"strand_name\": \"Technical-Vocational-Livelihood: ICT\", \"career_pathway\": \"Software Engineering / Programming\"}, {\"score\": 82.50999999999999, \"course_name\": \"BS Hotel & Restaurant Management\", \"strand_code\": \"TVL-HE\", \"strand_name\": \"Technical-Vocational-Livelihood: Home Economics\", \"career_pathway\": \"Hospitality Industry\"}], \"generated_at\": \"2026-03-03 13:29:50\", \"employability\": 87.6, \"entrance_exam\": \"80.00\", \"q4_shs_average\": 86, \"work_immersion\": 93}', '1', '2025-2026', '2026-03-03 21:29:50', '2026-03-03 21:29:50');
INSERT INTO `career_recommendations` (`id`, `student_id`, `recommendation_type`, `top_strand_1`, `top_strand_2`, `top_strand_3`, `top_course_1`, `top_course_2`, `top_course_3`, `recommended_strand`, `recommended_courses`, `employability_score`, `employability_level`, `strand_match`, `mismatch_remarks`, `career_pathways`, `score_breakdown`, `generated_by`, `school_year`, `created_at`, `updated_at`) VALUES ('10', '8', 'course', NULL, NULL, NULL, 'BS Hotel & Restaurant Management', 'BS Tourism Management', 'BS Information Technology', 'Technical-Vocational-Livelihood: Home Economics', 'BS Hotel & Restaurant Management, BS Tourism Management, BS Information Technology', '87.40', 'high', '0', 'Student\'s current strand (STEM) may not align with strongest academic areas.', 'Hospitality Industry, Travel / Tourism Industry, Web Development / Systems Admin', '{\"top_courses\": [{\"score\": 84.63999999999999, \"course_name\": \"BS Hotel & Restaurant Management\", \"strand_code\": \"TVL-HE\", \"strand_name\": \"Technical-Vocational-Livelihood: Home Economics\", \"career_pathway\": \"Hospitality Industry\"}, {\"score\": 84.63999999999999, \"course_name\": \"BS Tourism Management\", \"strand_code\": \"TVL-HE\", \"strand_name\": \"Technical-Vocational-Livelihood: Home Economics\", \"career_pathway\": \"Travel / Tourism Industry\"}, {\"score\": 84.03999999999999, \"course_name\": \"BS Information Technology\", \"strand_code\": \"TVL-ICT\", \"strand_name\": \"Technical-Vocational-Livelihood: ICT\", \"career_pathway\": \"Web Development / Systems Admin\"}], \"generated_at\": \"2026-03-03 13:41:21\", \"employability\": 87.39999999999999, \"entrance_exam\": \"86.00\", \"q4_shs_average\": 88}', '1', '2025-2026', '2026-03-03 21:41:21', '2026-03-03 21:41:21');

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

INSERT INTO `diagnostic_reports` (`id`, `student_id`, `section_id`, `report_type`, `report_data`, `generated_by`, `school_year`, `created_at`) VALUES ('1', '3', NULL, 'individual', '{\"avg_grade\": \"72.375000\", \"competency\": {\"color\": \"red\", \"label\": \"Did Not Meet Expectations\", \"level\": \"weak\"}, \"student_name\": \"Pedro Ramos\", \"work_immersion\": \"70.50\", \"career_recommendation\": null}', '1', '2025-2026', '2026-03-03 21:31:50');
INSERT INTO `diagnostic_reports` (`id`, `student_id`, `section_id`, `report_type`, `report_data`, `generated_by`, `school_year`, `created_at`) VALUES ('2', '3', NULL, 'individual', '{\"avg_grade\": \"72.375000\", \"competency\": {\"color\": \"red\", \"label\": \"Did Not Meet Expectations\", \"level\": \"weak\"}, \"student_name\": \"Pedro Ramos\", \"career_recommendation\": null}', '1', '2025-2026', '2026-03-03 21:37:13');

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
) ENGINE=InnoDB AUTO_INCREMENT=219 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('1', '1', '4', 'Q1', '88.00', '2025-2026', '2', '2026-03-03 20:53:34', '2026-03-03 20:53:34');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('2', '1', '4', 'Q2', '90.00', '2025-2026', '2', '2026-03-03 20:53:34', '2026-03-03 20:53:34');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('3', '1', '21', 'Q1', '85.00', '2025-2026', '2', '2026-03-03 20:53:34', '2026-03-03 20:53:34');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('4', '1', '21', 'Q2', '87.00', '2025-2026', '2', '2026-03-03 20:53:34', '2026-03-03 20:53:34');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('5', '1', '23', 'Q1', '92.00', '2025-2026', '2', '2026-03-03 20:53:34', '2026-03-03 20:53:34');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('6', '1', '23', 'Q2', '91.00', '2025-2026', '2', '2026-03-03 20:53:34', '2026-03-03 20:53:34');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('7', '1', '1', 'Q1', '86.00', '2025-2026', '2', '2026-03-03 20:53:34', '2026-03-03 20:53:34');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('8', '1', '1', 'Q2', '88.00', '2025-2026', '2', '2026-03-03 20:53:34', '2026-03-03 20:53:34');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('9', '2', '4', 'Q1', '78.00', '2025-2026', '2', '2026-03-03 20:53:34', '2026-03-03 20:53:34');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('10', '2', '4', 'Q2', '76.00', '2025-2026', '2', '2026-03-03 20:53:34', '2026-03-03 20:53:34');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('11', '2', '21', 'Q1', '74.00', '2025-2026', '2', '2026-03-03 20:53:34', '2026-03-03 20:53:34');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('12', '2', '21', 'Q2', '73.00', '2025-2026', '2', '2026-03-03 20:53:34', '2026-03-03 20:53:34');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('13', '2', '23', 'Q1', '80.00', '2025-2026', '2', '2026-03-03 20:53:34', '2026-03-03 20:53:34');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('14', '2', '23', 'Q2', '79.00', '2025-2026', '2', '2026-03-03 20:53:34', '2026-03-03 20:53:34');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('15', '2', '1', 'Q1', '82.00', '2025-2026', '2', '2026-03-03 20:53:34', '2026-03-03 20:53:34');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('16', '2', '1', 'Q2', '81.00', '2025-2026', '2', '2026-03-03 20:53:34', '2026-03-03 20:53:34');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('17', '3', '4', 'Q1', '72.00', '2025-2026', '2', '2026-03-03 20:53:34', '2026-03-03 20:53:34');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('18', '3', '4', 'Q2', '70.00', '2025-2026', '2', '2026-03-03 20:53:34', '2026-03-03 20:53:34');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('19', '3', '21', 'Q1', '68.00', '2025-2026', '2', '2026-03-03 20:53:34', '2026-03-03 20:53:34');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('20', '3', '21', 'Q2', '71.00', '2025-2026', '2', '2026-03-03 20:53:34', '2026-03-03 20:53:34');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('21', '3', '23', 'Q1', '74.00', '2025-2026', '2', '2026-03-03 20:53:34', '2026-03-03 20:53:34');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('22', '3', '23', 'Q2', '73.00', '2025-2026', '2', '2026-03-03 20:53:34', '2026-03-03 20:53:34');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('23', '3', '1', 'Q1', '75.00', '2025-2026', '2', '2026-03-03 20:53:34', '2026-03-03 20:53:34');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('24', '3', '1', 'Q2', '76.00', '2025-2026', '2', '2026-03-03 20:53:34', '2026-03-03 20:53:34');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('25', '4', '30', 'Q1', '89.00', '2025-2026', '2', '2026-03-03 20:53:34', '2026-03-03 20:53:34');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('26', '4', '30', 'Q2', '91.00', '2025-2026', '2', '2026-03-03 20:53:34', '2026-03-03 20:53:34');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('27', '4', '33', 'Q1', '87.00', '2025-2026', '2', '2026-03-03 20:53:34', '2026-03-03 20:53:34');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('28', '4', '33', 'Q2', '90.00', '2025-2026', '2', '2026-03-03 20:53:34', '2026-03-03 20:53:34');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('29', '4', '1', 'Q1', '85.00', '2025-2026', '2', '2026-03-03 20:53:34', '2026-03-03 20:53:34');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('30', '4', '1', 'Q2', '88.00', '2025-2026', '2', '2026-03-03 20:53:34', '2026-03-03 20:53:34');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('31', '5', '30', 'Q1', '76.00', '2025-2026', '2', '2026-03-03 20:53:34', '2026-03-03 20:53:34');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('32', '5', '30', 'Q2', '78.00', '2025-2026', '2', '2026-03-03 20:53:34', '2026-03-03 20:53:34');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('33', '5', '33', 'Q1', '74.00', '2025-2026', '2', '2026-03-03 20:53:34', '2026-03-03 20:53:34');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('34', '5', '33', 'Q2', '77.00', '2025-2026', '2', '2026-03-03 20:53:34', '2026-03-03 20:53:34');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('35', '5', '1', 'Q1', '79.00', '2025-2026', '2', '2026-03-03 20:53:34', '2026-03-03 20:53:34');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('36', '5', '1', 'Q2', '80.00', '2025-2026', '2', '2026-03-03 20:53:34', '2026-03-03 20:53:34');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('37', '6', '38', 'Q1', '90.00', '2025-2026', '2', '2026-03-03 20:53:34', '2026-03-03 20:53:34');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('38', '6', '38', 'Q2', '92.00', '2025-2026', '2', '2026-03-03 20:53:34', '2026-03-03 20:53:34');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('39', '6', '39', 'Q1', '88.00', '2025-2026', '2', '2026-03-03 20:53:34', '2026-03-03 20:53:34');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('40', '6', '39', 'Q2', '91.00', '2025-2026', '2', '2026-03-03 20:53:34', '2026-03-03 20:53:34');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('41', '6', '1', 'Q1', '93.00', '2025-2026', '2', '2026-03-03 20:53:34', '2026-03-03 20:53:34');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('42', '6', '1', 'Q2', '94.00', '2025-2026', '2', '2026-03-03 20:53:34', '2026-03-03 20:53:34');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('43', '7', '38', 'Q1', '77.00', '2025-2026', '2', '2026-03-03 20:53:34', '2026-03-03 20:53:34');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('44', '7', '38', 'Q2', '75.00', '2025-2026', '2', '2026-03-03 20:53:34', '2026-03-03 20:53:34');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('45', '7', '39', 'Q1', '79.00', '2025-2026', '2', '2026-03-03 20:53:34', '2026-03-03 20:53:34');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('46', '7', '39', 'Q2', '78.00', '2025-2026', '2', '2026-03-03 20:53:34', '2026-03-03 20:53:34');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('47', '7', '1', 'Q1', '76.00', '2025-2026', '2', '2026-03-03 20:53:34', '2026-03-03 20:53:34');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('48', '7', '1', 'Q2', '77.00', '2025-2026', '2', '2026-03-03 20:53:34', '2026-03-03 20:53:34');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('49', '8', '4', 'Q1', '95.00', '2025-2026', '2', '2026-03-03 20:53:34', '2026-03-03 20:53:34');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('50', '8', '4', 'Q2', '96.00', '2025-2026', '2', '2026-03-03 20:53:34', '2026-03-03 20:53:34');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('51', '8', '21', 'Q1', '93.00', '2025-2026', '2', '2026-03-03 20:53:34', '2026-03-03 20:53:34');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('52', '8', '21', 'Q2', '94.00', '2025-2026', '2', '2026-03-03 20:53:34', '2026-03-03 20:53:34');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('53', '8', '23', 'Q1', '91.00', '2025-2026', '2', '2026-03-03 20:53:34', '2026-03-03 20:53:34');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('54', '8', '23', 'Q2', '93.00', '2025-2026', '2', '2026-03-03 20:53:34', '2026-03-03 20:53:34');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('55', '9', '1', 'Q1', '85.00', '2025-2026', '2', '2026-03-03 20:57:35', '2026-03-03 20:57:35');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('56', '9', '1', 'Q2', '86.00', '2025-2026', '2', '2026-03-03 20:57:35', '2026-03-03 20:57:35');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('57', '9', '1', 'Q3', '87.00', '2025-2026', '2', '2026-03-03 20:57:35', '2026-03-03 20:57:35');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('58', '9', '1', 'Q4', '88.00', '2025-2026', '2', '2026-03-03 20:57:35', '2026-03-03 20:57:35');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('59', '9', '2', 'Q1', '82.00', '2025-2026', '2', '2026-03-03 20:57:35', '2026-03-03 20:57:35');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('60', '9', '2', 'Q2', '83.00', '2025-2026', '2', '2026-03-03 20:57:35', '2026-03-03 20:57:35');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('61', '9', '2', 'Q3', '84.00', '2025-2026', '2', '2026-03-03 20:57:35', '2026-03-03 20:57:35');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('62', '9', '2', 'Q4', '85.00', '2025-2026', '2', '2026-03-03 20:57:35', '2026-03-03 20:57:35');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('63', '9', '3', 'Q1', '93.00', '2025-2026', '2', '2026-03-03 20:57:35', '2026-03-03 20:57:35');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('64', '9', '3', 'Q2', '95.00', '2025-2026', '2', '2026-03-03 20:57:35', '2026-03-03 20:57:35');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('65', '9', '3', 'Q3', '94.00', '2025-2026', '2', '2026-03-03 20:57:35', '2026-03-03 20:57:35');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('66', '9', '3', 'Q4', '96.00', '2025-2026', '2', '2026-03-03 20:57:35', '2026-03-03 20:57:35');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('67', '9', '4', 'Q1', '91.00', '2025-2026', '2', '2026-03-03 20:57:35', '2026-03-03 20:57:35');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('68', '9', '4', 'Q2', '92.00', '2025-2026', '2', '2026-03-03 20:57:35', '2026-03-03 20:57:35');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('69', '9', '4', 'Q3', '93.00', '2025-2026', '2', '2026-03-03 20:57:35', '2026-03-03 20:57:35');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('70', '9', '4', 'Q4', '95.00', '2025-2026', '2', '2026-03-03 20:57:35', '2026-03-03 20:57:35');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('71', '9', '5', 'Q1', '80.00', '2025-2026', '2', '2026-03-03 20:57:35', '2026-03-03 20:57:35');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('72', '9', '5', 'Q2', '81.00', '2025-2026', '2', '2026-03-03 20:57:35', '2026-03-03 20:57:35');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('73', '9', '5', 'Q3', '82.00', '2025-2026', '2', '2026-03-03 20:57:35', '2026-03-03 20:57:35');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('74', '9', '5', 'Q4', '83.00', '2025-2026', '2', '2026-03-03 20:57:35', '2026-03-03 20:57:35');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('75', '9', '6', 'Q1', '84.00', '2025-2026', '2', '2026-03-03 20:57:35', '2026-03-03 20:57:35');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('76', '9', '6', 'Q2', '85.00', '2025-2026', '2', '2026-03-03 20:57:35', '2026-03-03 20:57:35');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('77', '9', '6', 'Q3', '86.00', '2025-2026', '2', '2026-03-03 20:57:35', '2026-03-03 20:57:35');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('78', '9', '6', 'Q4', '87.00', '2025-2026', '2', '2026-03-03 20:57:35', '2026-03-03 20:57:35');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('79', '9', '7', 'Q1', '80.00', '2025-2026', '2', '2026-03-03 20:57:35', '2026-03-03 20:57:35');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('80', '9', '7', 'Q2', '82.00', '2025-2026', '2', '2026-03-03 20:57:35', '2026-03-03 20:57:35');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('81', '9', '7', 'Q3', '83.00', '2025-2026', '2', '2026-03-03 20:57:35', '2026-03-03 20:57:35');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('82', '9', '7', 'Q4', '84.00', '2025-2026', '2', '2026-03-03 20:57:35', '2026-03-03 20:57:35');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('83', '9', '8', 'Q1', '78.00', '2025-2026', '2', '2026-03-03 20:57:35', '2026-03-03 20:57:35');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('84', '9', '8', 'Q2', '79.00', '2025-2026', '2', '2026-03-03 20:57:35', '2026-03-03 20:57:35');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('85', '9', '8', 'Q3', '80.00', '2025-2026', '2', '2026-03-03 20:57:35', '2026-03-03 20:57:35');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('86', '9', '8', 'Q4', '81.00', '2025-2026', '2', '2026-03-03 20:57:35', '2026-03-03 20:57:35');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('87', '10', '9', 'Q1', '80.00', '2025-2026', '2', '2026-03-03 20:57:35', '2026-03-03 20:57:35');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('88', '10', '9', 'Q2', '81.00', '2025-2026', '2', '2026-03-03 20:57:35', '2026-03-03 20:57:35');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('89', '10', '9', 'Q3', '82.00', '2025-2026', '2', '2026-03-03 20:57:35', '2026-03-03 20:57:35');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('90', '10', '9', 'Q4', '83.00', '2025-2026', '2', '2026-03-03 20:57:35', '2026-03-03 20:57:35');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('91', '10', '10', 'Q1', '83.00', '2025-2026', '2', '2026-03-03 20:57:35', '2026-03-03 20:57:35');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('92', '10', '10', 'Q2', '84.00', '2025-2026', '2', '2026-03-03 20:57:35', '2026-03-03 20:57:35');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('93', '10', '10', 'Q3', '85.00', '2025-2026', '2', '2026-03-03 20:57:35', '2026-03-03 20:57:35');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('94', '10', '10', 'Q4', '86.00', '2025-2026', '2', '2026-03-03 20:57:35', '2026-03-03 20:57:35');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('95', '10', '11', 'Q1', '72.00', '2025-2026', '2', '2026-03-03 20:57:35', '2026-03-03 20:57:35');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('96', '10', '11', 'Q2', '74.00', '2025-2026', '2', '2026-03-03 20:57:35', '2026-03-03 20:57:35');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('97', '10', '11', 'Q3', '75.00', '2025-2026', '2', '2026-03-03 20:57:35', '2026-03-03 20:57:35');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('98', '10', '11', 'Q4', '76.00', '2025-2026', '2', '2026-03-03 20:57:35', '2026-03-03 20:57:35');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('99', '10', '12', 'Q1', '74.00', '2025-2026', '2', '2026-03-03 20:57:35', '2026-03-03 20:57:35');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('100', '10', '12', 'Q2', '75.00', '2025-2026', '2', '2026-03-03 20:57:35', '2026-03-03 20:57:35');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('101', '10', '12', 'Q3', '76.00', '2025-2026', '2', '2026-03-03 20:57:35', '2026-03-03 20:57:35');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('102', '10', '12', 'Q4', '77.00', '2025-2026', '2', '2026-03-03 20:57:35', '2026-03-03 20:57:35');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('103', '10', '13', 'Q1', '82.00', '2025-2026', '2', '2026-03-03 20:57:35', '2026-03-03 20:57:35');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('104', '10', '13', 'Q2', '83.00', '2025-2026', '2', '2026-03-03 20:57:35', '2026-03-03 20:57:35');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('105', '10', '13', 'Q3', '84.00', '2025-2026', '2', '2026-03-03 20:57:35', '2026-03-03 20:57:35');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('106', '10', '13', 'Q4', '85.00', '2025-2026', '2', '2026-03-03 20:57:35', '2026-03-03 20:57:35');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('107', '10', '14', 'Q1', '85.00', '2025-2026', '2', '2026-03-03 20:57:35', '2026-03-03 20:57:35');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('108', '10', '14', 'Q2', '86.00', '2025-2026', '2', '2026-03-03 20:57:35', '2026-03-03 20:57:35');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('109', '10', '14', 'Q3', '87.00', '2025-2026', '2', '2026-03-03 20:57:35', '2026-03-03 20:57:35');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('110', '10', '14', 'Q4', '88.00', '2025-2026', '2', '2026-03-03 20:57:35', '2026-03-03 20:57:35');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('111', '10', '15', 'Q1', '90.00', '2025-2026', '2', '2026-03-03 20:57:35', '2026-03-03 20:57:35');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('112', '10', '15', 'Q2', '91.00', '2025-2026', '2', '2026-03-03 20:57:35', '2026-03-03 20:57:35');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('113', '10', '15', 'Q3', '92.00', '2025-2026', '2', '2026-03-03 20:57:35', '2026-03-03 20:57:35');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('114', '10', '15', 'Q4', '93.00', '2025-2026', '2', '2026-03-03 20:57:35', '2026-03-03 20:57:35');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('115', '10', '16', 'Q1', '93.00', '2025-2026', '2', '2026-03-03 20:57:35', '2026-03-03 20:57:35');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('116', '10', '16', 'Q2', '94.00', '2025-2026', '2', '2026-03-03 20:57:35', '2026-03-03 20:57:35');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('117', '10', '16', 'Q3', '95.00', '2025-2026', '2', '2026-03-03 20:57:35', '2026-03-03 20:57:35');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('118', '10', '16', 'Q4', '96.00', '2025-2026', '2', '2026-03-03 20:57:35', '2026-03-03 20:57:35');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('119', '11', '17', 'Q1', '92.00', '2025-2026', '2', '2026-03-03 20:57:35', '2026-03-03 20:57:35');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('120', '11', '17', 'Q2', '93.00', '2025-2026', '2', '2026-03-03 20:57:35', '2026-03-03 20:57:35');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('121', '11', '17', 'Q3', '94.00', '2025-2026', '2', '2026-03-03 20:57:35', '2026-03-03 20:57:35');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('122', '11', '17', 'Q4', '95.00', '2025-2026', '2', '2026-03-03 20:57:35', '2026-03-03 20:57:35');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('123', '11', '18', 'Q1', '91.00', '2025-2026', '2', '2026-03-03 20:57:35', '2026-03-03 20:57:35');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('124', '11', '18', 'Q2', '92.00', '2025-2026', '2', '2026-03-03 20:57:35', '2026-03-03 20:57:35');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('125', '11', '18', 'Q3', '93.00', '2025-2026', '2', '2026-03-03 20:57:35', '2026-03-03 20:57:35');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('126', '11', '18', 'Q4', '94.00', '2025-2026', '2', '2026-03-03 20:57:35', '2026-03-03 20:57:35');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('127', '11', '19', 'Q1', '75.00', '2025-2026', '2', '2026-03-03 20:57:35', '2026-03-03 20:57:35');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('128', '11', '19', 'Q2', '76.00', '2025-2026', '2', '2026-03-03 20:57:35', '2026-03-03 20:57:35');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('129', '11', '19', 'Q3', '77.00', '2025-2026', '2', '2026-03-03 20:57:35', '2026-03-03 20:57:35');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('130', '11', '19', 'Q4', '78.00', '2025-2026', '2', '2026-03-03 20:57:35', '2026-03-03 20:57:35');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('131', '11', '20', 'Q1', '76.00', '2025-2026', '2', '2026-03-03 20:57:35', '2026-03-03 20:57:35');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('132', '11', '20', 'Q2', '77.00', '2025-2026', '2', '2026-03-03 20:57:35', '2026-03-03 20:57:35');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('133', '11', '20', 'Q3', '78.00', '2025-2026', '2', '2026-03-03 20:57:35', '2026-03-03 20:57:35');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('134', '11', '20', 'Q4', '79.00', '2025-2026', '2', '2026-03-03 20:57:35', '2026-03-03 20:57:35');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('135', '11', '21', 'Q1', '93.00', '2025-2026', '2', '2026-03-03 20:57:35', '2026-03-03 20:57:35');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('136', '11', '21', 'Q2', '94.00', '2025-2026', '2', '2026-03-03 20:57:35', '2026-03-03 20:57:35');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('137', '11', '21', 'Q3', '95.00', '2025-2026', '2', '2026-03-03 20:57:35', '2026-03-03 20:57:35');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('138', '11', '21', 'Q4', '96.00', '2025-2026', '2', '2026-03-03 20:57:35', '2026-03-03 20:57:35');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('139', '11', '22', 'Q1', '90.00', '2025-2026', '2', '2026-03-03 20:57:35', '2026-03-03 20:57:35');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('140', '11', '22', 'Q2', '91.00', '2025-2026', '2', '2026-03-03 20:57:35', '2026-03-03 20:57:35');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('141', '11', '22', 'Q3', '92.00', '2025-2026', '2', '2026-03-03 20:57:35', '2026-03-03 20:57:35');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('142', '11', '22', 'Q4', '93.00', '2025-2026', '2', '2026-03-03 20:57:35', '2026-03-03 20:57:35');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('143', '11', '23', 'Q1', '85.00', '2025-2026', '2', '2026-03-03 20:57:35', '2026-03-03 20:57:35');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('144', '11', '23', 'Q2', '86.00', '2025-2026', '2', '2026-03-03 20:57:35', '2026-03-03 20:57:35');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('145', '11', '23', 'Q3', '87.00', '2025-2026', '2', '2026-03-03 20:57:35', '2026-03-03 20:57:35');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('146', '11', '23', 'Q4', '88.00', '2025-2026', '2', '2026-03-03 20:57:35', '2026-03-03 20:57:35');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('147', '11', '24', 'Q1', '80.00', '2025-2026', '2', '2026-03-03 20:57:35', '2026-03-03 20:57:35');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('148', '11', '24', 'Q2', '81.00', '2025-2026', '2', '2026-03-03 20:57:35', '2026-03-03 20:57:35');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('149', '11', '24', 'Q3', '82.00', '2025-2026', '2', '2026-03-03 20:57:35', '2026-03-03 20:57:35');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('150', '11', '24', 'Q4', '83.00', '2025-2026', '2', '2026-03-03 20:57:35', '2026-03-03 20:57:35');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('151', '12', '25', 'Q1', '85.00', '2025-2026', '2', '2026-03-03 20:57:35', '2026-03-03 20:57:35');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('152', '12', '25', 'Q2', '86.00', '2025-2026', '2', '2026-03-03 20:57:35', '2026-03-03 20:57:35');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('153', '12', '25', 'Q3', '87.00', '2025-2026', '2', '2026-03-03 20:57:35', '2026-03-03 20:57:35');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('154', '12', '25', 'Q4', '88.00', '2025-2026', '2', '2026-03-03 20:57:35', '2026-03-03 20:57:35');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('155', '12', '26', 'Q1', '84.00', '2025-2026', '2', '2026-03-03 20:57:35', '2026-03-03 20:57:35');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('156', '12', '26', 'Q2', '85.00', '2025-2026', '2', '2026-03-03 20:57:35', '2026-03-03 20:57:35');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('157', '12', '26', 'Q3', '86.00', '2025-2026', '2', '2026-03-03 20:57:35', '2026-03-03 20:57:35');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('158', '12', '26', 'Q4', '87.00', '2025-2026', '2', '2026-03-03 20:57:35', '2026-03-03 20:57:35');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('159', '12', '27', 'Q1', '83.00', '2025-2026', '2', '2026-03-03 20:57:35', '2026-03-03 20:57:35');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('160', '12', '27', 'Q2', '84.00', '2025-2026', '2', '2026-03-03 20:57:35', '2026-03-03 20:57:35');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('161', '12', '27', 'Q3', '85.00', '2025-2026', '2', '2026-03-03 20:57:35', '2026-03-03 20:57:35');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('162', '12', '27', 'Q4', '86.00', '2025-2026', '2', '2026-03-03 20:57:35', '2026-03-03 20:57:35');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('163', '12', '28', 'Q1', '84.00', '2025-2026', '2', '2026-03-03 20:57:35', '2026-03-03 20:57:35');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('164', '12', '28', 'Q2', '85.00', '2025-2026', '2', '2026-03-03 20:57:35', '2026-03-03 20:57:35');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('165', '12', '28', 'Q3', '86.00', '2025-2026', '2', '2026-03-03 20:57:35', '2026-03-03 20:57:35');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('166', '12', '28', 'Q4', '87.00', '2025-2026', '2', '2026-03-03 20:57:35', '2026-03-03 20:57:35');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('167', '12', '29', 'Q1', '85.00', '2025-2026', '2', '2026-03-03 20:57:35', '2026-03-03 20:57:35');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('168', '12', '29', 'Q2', '86.00', '2025-2026', '2', '2026-03-03 20:57:35', '2026-03-03 20:57:35');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('169', '12', '29', 'Q3', '87.00', '2025-2026', '2', '2026-03-03 20:57:35', '2026-03-03 20:57:35');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('170', '12', '29', 'Q4', '88.00', '2025-2026', '2', '2026-03-03 20:57:35', '2026-03-03 20:57:35');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('171', '12', '30', 'Q1', '86.00', '2025-2026', '2', '2026-03-03 20:57:35', '2026-03-03 20:57:35');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('172', '12', '30', 'Q2', '87.00', '2025-2026', '2', '2026-03-03 20:57:35', '2026-03-03 20:57:35');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('173', '12', '30', 'Q3', '88.00', '2025-2026', '2', '2026-03-03 20:57:35', '2026-03-03 20:57:35');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('174', '12', '30', 'Q4', '89.00', '2025-2026', '2', '2026-03-03 20:57:35', '2026-03-03 20:57:35');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('175', '12', '31', 'Q1', '83.00', '2025-2026', '2', '2026-03-03 20:57:35', '2026-03-03 20:57:35');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('176', '12', '31', 'Q2', '84.00', '2025-2026', '2', '2026-03-03 20:57:35', '2026-03-03 20:57:35');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('177', '12', '31', 'Q3', '85.00', '2025-2026', '2', '2026-03-03 20:57:35', '2026-03-03 20:57:35');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('178', '12', '31', 'Q4', '86.00', '2025-2026', '2', '2026-03-03 20:57:35', '2026-03-03 20:57:35');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('179', '12', '32', 'Q1', '84.00', '2025-2026', '2', '2026-03-03 20:57:35', '2026-03-03 20:57:35');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('180', '12', '32', 'Q2', '85.00', '2025-2026', '2', '2026-03-03 20:57:35', '2026-03-03 20:57:35');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('181', '12', '32', 'Q3', '86.00', '2025-2026', '2', '2026-03-03 20:57:35', '2026-03-03 20:57:35');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('182', '12', '32', 'Q4', '87.00', '2025-2026', '2', '2026-03-03 20:57:35', '2026-03-03 20:57:35');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('183', '13', '25', 'Q1', '80.00', '2025-2026', '2', '2026-03-03 20:57:35', '2026-03-03 20:57:35');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('184', '13', '25', 'Q2', '81.00', '2025-2026', '2', '2026-03-03 20:57:35', '2026-03-03 20:57:35');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('185', '13', '25', 'Q3', '82.00', '2025-2026', '2', '2026-03-03 20:57:35', '2026-03-03 20:57:35');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('186', '13', '25', 'Q4', '83.00', '2025-2026', '2', '2026-03-03 20:57:35', '2026-03-03 20:57:35');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('187', '13', '26', 'Q1', '82.00', '2025-2026', '2', '2026-03-03 20:57:35', '2026-03-03 20:57:35');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('188', '13', '26', 'Q2', '83.00', '2025-2026', '2', '2026-03-03 20:57:35', '2026-03-03 20:57:35');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('189', '13', '26', 'Q3', '84.00', '2025-2026', '2', '2026-03-03 20:57:35', '2026-03-03 20:57:35');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('190', '13', '26', 'Q4', '85.00', '2025-2026', '2', '2026-03-03 20:57:35', '2026-03-03 20:57:35');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('191', '13', '27', 'Q1', '78.00', '2025-2026', '2', '2026-03-03 20:57:35', '2026-03-03 20:57:35');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('192', '13', '27', 'Q2', '79.00', '2025-2026', '2', '2026-03-03 20:57:35', '2026-03-03 20:57:35');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('193', '13', '27', 'Q3', '80.00', '2025-2026', '2', '2026-03-03 20:57:35', '2026-03-03 20:57:35');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('194', '13', '27', 'Q4', '81.00', '2025-2026', '2', '2026-03-03 20:57:35', '2026-03-03 20:57:35');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('195', '13', '28', 'Q1', '76.00', '2025-2026', '2', '2026-03-03 20:57:35', '2026-03-03 20:57:35');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('196', '13', '28', 'Q2', '77.00', '2025-2026', '2', '2026-03-03 20:57:35', '2026-03-03 20:57:35');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('197', '13', '28', 'Q3', '78.00', '2025-2026', '2', '2026-03-03 20:57:35', '2026-03-03 20:57:35');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('198', '13', '28', 'Q4', '79.00', '2025-2026', '2', '2026-03-03 20:57:35', '2026-03-03 20:57:35');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('199', '13', '29', 'Q1', '89.00', '2025-2026', '2', '2026-03-03 20:57:35', '2026-03-03 20:57:35');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('200', '13', '29', 'Q2', '90.00', '2025-2026', '2', '2026-03-03 20:57:35', '2026-03-03 20:57:35');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('201', '13', '29', 'Q3', '91.00', '2025-2026', '2', '2026-03-03 20:57:35', '2026-03-03 20:57:35');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('202', '13', '29', 'Q4', '92.00', '2025-2026', '2', '2026-03-03 20:57:35', '2026-03-03 20:57:35');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('203', '13', '30', 'Q1', '87.00', '2025-2026', '2', '2026-03-03 20:57:35', '2026-03-03 20:57:35');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('204', '13', '30', 'Q2', '88.00', '2025-2026', '2', '2026-03-03 20:57:35', '2026-03-03 20:57:35');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('205', '13', '30', 'Q3', '89.00', '2025-2026', '2', '2026-03-03 20:57:35', '2026-03-03 20:57:35');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('206', '13', '30', 'Q4', '90.00', '2025-2026', '2', '2026-03-03 20:57:35', '2026-03-03 20:57:35');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('207', '13', '31', 'Q1', '82.00', '2025-2026', '2', '2026-03-03 20:57:35', '2026-03-03 20:57:35');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('208', '13', '31', 'Q2', '83.00', '2025-2026', '2', '2026-03-03 20:57:35', '2026-03-03 20:57:35');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('209', '13', '31', 'Q3', '84.00', '2025-2026', '2', '2026-03-03 20:57:35', '2026-03-03 20:57:35');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('210', '13', '31', 'Q4', '85.00', '2025-2026', '2', '2026-03-03 20:57:35', '2026-03-03 20:57:35');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('211', '13', '32', 'Q1', '92.00', '2025-2026', '2', '2026-03-03 20:57:35', '2026-03-03 20:57:35');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('212', '13', '32', 'Q2', '93.00', '2025-2026', '2', '2026-03-03 20:57:35', '2026-03-03 20:57:35');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('213', '13', '32', 'Q3', '94.00', '2025-2026', '2', '2026-03-03 20:57:35', '2026-03-03 20:57:35');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('214', '13', '32', 'Q4', '95.00', '2025-2026', '2', '2026-03-03 20:57:35', '2026-03-03 20:57:35');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('215', '6', '103', 'Q4', '86.00', '2025-2026', '1', '2026-03-03 21:12:26', '2026-03-03 21:12:26');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('216', '1', '103', 'Q4', '88.00', '2025-2026', '1', '2026-03-03 21:26:12', '2026-03-03 21:26:12');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('218', '8', '103', 'Q4', '88.00', '2025-2026', '1', '2026-03-03 21:41:06', '2026-03-03 21:41:06');

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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS `non_academic_indicators`;
CREATE TABLE `non_academic_indicators` (
  `id` int NOT NULL AUTO_INCREMENT,
  `student_id` int NOT NULL,
  `skills` text,
  `hobbies` text,
  `family_background` text,
  `annual_income` enum('below_100k','100k_300k','300k_500k','500k_above') DEFAULT 'below_100k',
  `entrance_exam_score` decimal(5,2) DEFAULT NULL,
  `entrance_exam_date` date DEFAULT NULL,
  `updated_by` int DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `student_id` (`student_id`),
  KEY `updated_by` (`updated_by`),
  CONSTRAINT `non_academic_indicators_ibfk_1` FOREIGN KEY (`student_id`) REFERENCES `students` (`id`) ON DELETE CASCADE,
  CONSTRAINT `non_academic_indicators_ibfk_2` FOREIGN KEY (`updated_by`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO `non_academic_indicators` (`id`, `student_id`, `skills`, `hobbies`, `family_background`, `annual_income`, `entrance_exam_score`, `entrance_exam_date`, `updated_by`, `created_at`, `updated_at`) VALUES ('1', '9', 'coding, robotics, math problem solving', 'science fair, programming, gadgets', 'father is an engineer, mother is a nurse', '300k_500k', '88.50', NULL, '1', '2026-03-03 20:57:36', '2026-03-03 21:07:58');
INSERT INTO `non_academic_indicators` (`id`, `student_id`, `skills`, `hobbies`, `family_background`, `annual_income`, `entrance_exam_score`, `entrance_exam_date`, `updated_by`, `created_at`, `updated_at`) VALUES ('2', '10', 'cooking, sewing, handicrafts', 'baking, crafts, cooking experiments, gardening', 'family runs a small eatery, mother is a dressmaker', '100k_300k', '76.00', NULL, NULL, '2026-03-03 20:57:36', '2026-03-03 20:57:36');
INSERT INTO `non_academic_indicators` (`id`, `student_id`, `skills`, `hobbies`, `family_background`, `annual_income`, `entrance_exam_score`, `entrance_exam_date`, `updated_by`, `created_at`, `updated_at`) VALUES ('3', '11', 'creative writing, public speaking, debating', 'reading, journalism, theater, social media', 'parents are both teachers, community-oriented family', '300k_500k', '85.00', NULL, NULL, '2026-03-03 20:57:36', '2026-03-03 20:57:36');
INSERT INTO `non_academic_indicators` (`id`, `student_id`, `skills`, `hobbies`, `family_background`, `annual_income`, `entrance_exam_score`, `entrance_exam_date`, `updated_by`, `created_at`, `updated_at`) VALUES ('4', '12', 'drawing, music, research, organizing', 'painting, playing guitar, reading, volunteering', 'parents have mixed occupations, well-rounded background', '100k_300k', '80.00', NULL, NULL, '2026-03-03 20:57:36', '2026-03-03 20:57:36');
INSERT INTO `non_academic_indicators` (`id`, `student_id`, `skills`, `hobbies`, `family_background`, `annual_income`, `entrance_exam_score`, `entrance_exam_date`, `updated_by`, `created_at`, `updated_at`) VALUES ('5', '13', 'selling, negotiating, organizing events', 'business, trading, basketball, cooking', 'family has a small business, father is an OFW', '100k_300k', '79.50', NULL, NULL, '2026-03-03 20:57:36', '2026-03-03 20:57:36');
INSERT INTO `non_academic_indicators` (`id`, `student_id`, `skills`, `hobbies`, `family_background`, `annual_income`, `entrance_exam_score`, `entrance_exam_date`, `updated_by`, `created_at`, `updated_at`) VALUES ('6', '8', 'cooking', 'pastries', 'business', 'below_100k', '86.00', NULL, '1', '2026-03-03 21:10:25', '2026-03-03 21:10:25');
INSERT INTO `non_academic_indicators` (`id`, `student_id`, `skills`, `hobbies`, `family_background`, `annual_income`, `entrance_exam_score`, `entrance_exam_date`, `updated_by`, `created_at`, `updated_at`) VALUES ('7', '6', 'singing', 'music', 'business', 'below_100k', '80.00', NULL, '1', '2026-03-03 21:29:46', '2026-03-03 21:29:46');

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
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO `sections` (`id`, `section_name`, `grade_level`, `strand`, `adviser_id`, `school_year`, `created_at`) VALUES ('1', 'Section A', '11', 'STEM', '2', '2025-2026', '2026-03-03 20:53:33');
INSERT INTO `sections` (`id`, `section_name`, `grade_level`, `strand`, `adviser_id`, `school_year`, `created_at`) VALUES ('2', 'Section B', '11', 'ABM', '3', '2025-2026', '2026-03-03 20:53:33');
INSERT INTO `sections` (`id`, `section_name`, `grade_level`, `strand`, `adviser_id`, `school_year`, `created_at`) VALUES ('3', 'Section C', '11', 'HUMSS', '4', '2025-2026', '2026-03-03 20:53:33');
INSERT INTO `sections` (`id`, `section_name`, `grade_level`, `strand`, `adviser_id`, `school_year`, `created_at`) VALUES ('4', 'Section D', '11', 'GAS', '2', '2025-2026', '2026-03-03 20:53:33');
INSERT INTO `sections` (`id`, `section_name`, `grade_level`, `strand`, `adviser_id`, `school_year`, `created_at`) VALUES ('5', 'Section E', '11', 'TVL-ICT', '3', '2025-2026', '2026-03-03 20:53:33');
INSERT INTO `sections` (`id`, `section_name`, `grade_level`, `strand`, `adviser_id`, `school_year`, `created_at`) VALUES ('6', 'Section F', '12', 'STEM', '2', '2025-2026', '2026-03-03 20:53:33');
INSERT INTO `sections` (`id`, `section_name`, `grade_level`, `strand`, `adviser_id`, `school_year`, `created_at`) VALUES ('7', 'Section G', '12', 'ABM', '4', '2025-2026', '2026-03-03 20:53:33');
INSERT INTO `sections` (`id`, `section_name`, `grade_level`, `strand`, `adviser_id`, `school_year`, `created_at`) VALUES ('8', 'Section H', '12', 'HUMSS', '3', '2025-2026', '2026-03-03 20:53:33');
INSERT INTO `sections` (`id`, `section_name`, `grade_level`, `strand`, `adviser_id`, `school_year`, `created_at`) VALUES ('9', 'Section I', '12', 'GAS', '2', '2025-2026', '2026-03-03 20:53:33');
INSERT INTO `sections` (`id`, `section_name`, `grade_level`, `strand`, `adviser_id`, `school_year`, `created_at`) VALUES ('10', 'Section J', '12', 'TVL-ICT', '4', '2025-2026', '2026-03-03 20:53:33');
INSERT INTO `sections` (`id`, `section_name`, `grade_level`, `strand`, `adviser_id`, `school_year`, `created_at`) VALUES ('11', 'Blaze', '10', NULL, '4', '2025-2026', '2026-03-03 20:54:34');
INSERT INTO `sections` (`id`, `section_name`, `grade_level`, `strand`, `adviser_id`, `school_year`, `created_at`) VALUES ('12', 'Rizal', '7', NULL, '2', '2025-2026', '2026-03-03 20:57:34');
INSERT INTO `sections` (`id`, `section_name`, `grade_level`, `strand`, `adviser_id`, `school_year`, `created_at`) VALUES ('13', 'Bonifacio', '8', NULL, '3', '2025-2026', '2026-03-03 20:57:34');
INSERT INTO `sections` (`id`, `section_name`, `grade_level`, `strand`, `adviser_id`, `school_year`, `created_at`) VALUES ('14', 'Mabini', '9', NULL, '4', '2025-2026', '2026-03-03 20:57:34');
INSERT INTO `sections` (`id`, `section_name`, `grade_level`, `strand`, `adviser_id`, `school_year`, `created_at`) VALUES ('15', 'Aguinaldo', '10', NULL, '2', '2025-2026', '2026-03-03 20:57:34');

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

INSERT INTO `strand_course_mapping` (`id`, `strand_id`, `course_name`, `career_pathway`, `created_at`) VALUES ('1', '1', 'BS Computer Science', 'Software Development / IT Industry', '2026-03-03 20:53:34');
INSERT INTO `strand_course_mapping` (`id`, `strand_id`, `course_name`, `career_pathway`, `created_at`) VALUES ('2', '1', 'BS Information Technology', 'Systems Administration / Web Development', '2026-03-03 20:53:34');
INSERT INTO `strand_course_mapping` (`id`, `strand_id`, `course_name`, `career_pathway`, `created_at`) VALUES ('3', '1', 'BS Civil Engineering', 'Construction / Infrastructure', '2026-03-03 20:53:34');
INSERT INTO `strand_course_mapping` (`id`, `strand_id`, `course_name`, `career_pathway`, `created_at`) VALUES ('4', '1', 'BS Mechanical Engineering', 'Manufacturing / Automotive', '2026-03-03 20:53:34');
INSERT INTO `strand_course_mapping` (`id`, `strand_id`, `course_name`, `career_pathway`, `created_at`) VALUES ('5', '1', 'BS Electrical Engineering', 'Power / Electronics Industry', '2026-03-03 20:53:34');
INSERT INTO `strand_course_mapping` (`id`, `strand_id`, `course_name`, `career_pathway`, `created_at`) VALUES ('6', '1', 'BS Nursing', 'Healthcare / Medical', '2026-03-03 20:53:34');
INSERT INTO `strand_course_mapping` (`id`, `strand_id`, `course_name`, `career_pathway`, `created_at`) VALUES ('7', '1', 'BS Mathematics', 'Education / Research / Data Science', '2026-03-03 20:53:34');
INSERT INTO `strand_course_mapping` (`id`, `strand_id`, `course_name`, `career_pathway`, `created_at`) VALUES ('8', '2', 'BS Accountancy', 'Auditing / Finance', '2026-03-03 20:53:34');
INSERT INTO `strand_course_mapping` (`id`, `strand_id`, `course_name`, `career_pathway`, `created_at`) VALUES ('9', '2', 'BS Business Administration', 'Corporate Management / Entrepreneurship', '2026-03-03 20:53:34');
INSERT INTO `strand_course_mapping` (`id`, `strand_id`, `course_name`, `career_pathway`, `created_at`) VALUES ('10', '2', 'BS Marketing Management', 'Advertising / Sales / Digital Marketing', '2026-03-03 20:53:34');
INSERT INTO `strand_course_mapping` (`id`, `strand_id`, `course_name`, `career_pathway`, `created_at`) VALUES ('11', '2', 'BS Customs Administration', 'Import-Export / Logistics', '2026-03-03 20:53:34');
INSERT INTO `strand_course_mapping` (`id`, `strand_id`, `course_name`, `career_pathway`, `created_at`) VALUES ('12', '2', 'BS Hospitality Management', 'Hotel / Restaurant Industry', '2026-03-03 20:53:34');
INSERT INTO `strand_course_mapping` (`id`, `strand_id`, `course_name`, `career_pathway`, `created_at`) VALUES ('13', '3', 'BA Communication', 'Media / Journalism / Public Relations', '2026-03-03 20:53:34');
INSERT INTO `strand_course_mapping` (`id`, `strand_id`, `course_name`, `career_pathway`, `created_at`) VALUES ('14', '3', 'BA Political Science', 'Law / Government / Diplomacy', '2026-03-03 20:53:34');
INSERT INTO `strand_course_mapping` (`id`, `strand_id`, `course_name`, `career_pathway`, `created_at`) VALUES ('15', '3', 'BA Psychology', 'Counseling / Human Resources', '2026-03-03 20:53:34');
INSERT INTO `strand_course_mapping` (`id`, `strand_id`, `course_name`, `career_pathway`, `created_at`) VALUES ('16', '3', 'BA Sociology', 'Social Work / Community Development', '2026-03-03 20:53:34');
INSERT INTO `strand_course_mapping` (`id`, `strand_id`, `course_name`, `career_pathway`, `created_at`) VALUES ('17', '3', 'AB English', 'Education / Writing / Translation', '2026-03-03 20:53:34');
INSERT INTO `strand_course_mapping` (`id`, `strand_id`, `course_name`, `career_pathway`, `created_at`) VALUES ('18', '4', 'Any Bachelor Degree', 'Flexible - Multiple Career Options', '2026-03-03 20:53:34');
INSERT INTO `strand_course_mapping` (`id`, `strand_id`, `course_name`, `career_pathway`, `created_at`) VALUES ('19', '5', 'BS Information Technology', 'Web Development / Systems Admin', '2026-03-03 20:53:34');
INSERT INTO `strand_course_mapping` (`id`, `strand_id`, `course_name`, `career_pathway`, `created_at`) VALUES ('20', '5', 'BS Computer Science', 'Software Engineering / Programming', '2026-03-03 20:53:34');
INSERT INTO `strand_course_mapping` (`id`, `strand_id`, `course_name`, `career_pathway`, `created_at`) VALUES ('21', '6', 'BS Hotel & Restaurant Management', 'Hospitality Industry', '2026-03-03 20:53:34');
INSERT INTO `strand_course_mapping` (`id`, `strand_id`, `course_name`, `career_pathway`, `created_at`) VALUES ('22', '6', 'BS Tourism Management', 'Travel / Tourism Industry', '2026-03-03 20:53:34');
INSERT INTO `strand_course_mapping` (`id`, `strand_id`, `course_name`, `career_pathway`, `created_at`) VALUES ('23', '7', 'BS Industrial Technology', 'Manufacturing / Technical Work', '2026-03-03 20:53:34');
INSERT INTO `strand_course_mapping` (`id`, `strand_id`, `course_name`, `career_pathway`, `created_at`) VALUES ('24', '8', 'BS Physical Education', 'Sports Management / Coaching', '2026-03-03 20:53:34');
INSERT INTO `strand_course_mapping` (`id`, `strand_id`, `course_name`, `career_pathway`, `created_at`) VALUES ('25', '8', 'BS Sports Science', 'Athletic Training / Fitness', '2026-03-03 20:53:34');
INSERT INTO `strand_course_mapping` (`id`, `strand_id`, `course_name`, `career_pathway`, `created_at`) VALUES ('26', '9', 'BFA Fine Arts', 'Visual Arts / Gallery Management', '2026-03-03 20:53:34');
INSERT INTO `strand_course_mapping` (`id`, `strand_id`, `course_name`, `career_pathway`, `created_at`) VALUES ('27', '9', 'BS Multimedia Arts', 'Digital Media / Animation / Graphic Design', '2026-03-03 20:53:34');

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

INSERT INTO `strands` (`id`, `strand_code`, `strand_name`, `description`, `created_at`) VALUES ('1', 'STEM', 'Science, Technology, Engineering and Mathematics', 'Focus on advanced math, science, and technology subjects', '2026-03-03 20:53:33');
INSERT INTO `strands` (`id`, `strand_code`, `strand_name`, `description`, `created_at`) VALUES ('2', 'ABM', 'Accountancy, Business and Management', 'Focus on business, finance, and management subjects', '2026-03-03 20:53:33');
INSERT INTO `strands` (`id`, `strand_code`, `strand_name`, `description`, `created_at`) VALUES ('3', 'HUMSS', 'Humanities and Social Sciences', 'Focus on liberal arts, social sciences, and communication', '2026-03-03 20:53:33');
INSERT INTO `strands` (`id`, `strand_code`, `strand_name`, `description`, `created_at`) VALUES ('4', 'GAS', 'General Academic Strand', 'Broad academic foundation across disciplines', '2026-03-03 20:53:33');
INSERT INTO `strands` (`id`, `strand_code`, `strand_name`, `description`, `created_at`) VALUES ('5', 'TVL-ICT', 'Technical-Vocational-Livelihood: ICT', 'Focus on Information and Communications Technology', '2026-03-03 20:53:33');
INSERT INTO `strands` (`id`, `strand_code`, `strand_name`, `description`, `created_at`) VALUES ('6', 'TVL-HE', 'Technical-Vocational-Livelihood: Home Economics', 'Focus on Home Economics and hospitality', '2026-03-03 20:53:33');
INSERT INTO `strands` (`id`, `strand_code`, `strand_name`, `description`, `created_at`) VALUES ('7', 'TVL-IA', 'Technical-Vocational-Livelihood: Industrial Arts', 'Focus on Industrial Arts and technical skills', '2026-03-03 20:53:33');
INSERT INTO `strands` (`id`, `strand_code`, `strand_name`, `description`, `created_at`) VALUES ('8', 'SPORTS', 'Sports Track', 'Focus on sports science, fitness, and athletics', '2026-03-03 20:53:33');
INSERT INTO `strands` (`id`, `strand_code`, `strand_name`, `description`, `created_at`) VALUES ('9', 'ARTS', 'Arts and Design Track', 'Focus on creative arts, media, and design', '2026-03-03 20:53:33');

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

INSERT INTO `students` (`id`, `lrn`, `first_name`, `last_name`, `middle_name`, `gender`, `birthdate`, `section_id`, `strand_id`, `school_year`, `status`, `created_at`, `updated_at`) VALUES ('1', '100100100001', 'Juan', 'Dela Cruz', 'Santos', 'Male', '2008-03-15', '1', '1', '2025-2026', 'active', '2026-03-03 20:53:34', '2026-03-03 20:53:34');
INSERT INTO `students` (`id`, `lrn`, `first_name`, `last_name`, `middle_name`, `gender`, `birthdate`, `section_id`, `strand_id`, `school_year`, `status`, `created_at`, `updated_at`) VALUES ('2', '100100100002', 'Maria', 'Garcia', 'Reyes', 'Female', '2008-06-21', '1', '1', '2025-2026', 'active', '2026-03-03 20:53:34', '2026-03-03 20:53:34');
INSERT INTO `students` (`id`, `lrn`, `first_name`, `last_name`, `middle_name`, `gender`, `birthdate`, `section_id`, `strand_id`, `school_year`, `status`, `created_at`, `updated_at`) VALUES ('3', '100100100003', 'Pedro', 'Ramos', 'Lim', 'Male', '2008-01-10', '1', '1', '2025-2026', 'active', '2026-03-03 20:53:34', '2026-03-03 20:53:34');
INSERT INTO `students` (`id`, `lrn`, `first_name`, `last_name`, `middle_name`, `gender`, `birthdate`, `section_id`, `strand_id`, `school_year`, `status`, `created_at`, `updated_at`) VALUES ('4', '100100100004', 'Ana', 'Lopez', 'Cruz', 'Female', '2008-09-05', '2', '2', '2025-2026', 'active', '2026-03-03 20:53:34', '2026-03-03 20:53:34');
INSERT INTO `students` (`id`, `lrn`, `first_name`, `last_name`, `middle_name`, `gender`, `birthdate`, `section_id`, `strand_id`, `school_year`, `status`, `created_at`, `updated_at`) VALUES ('5', '100100100005', 'Carlos', 'Mendoza', 'Bautista', 'Male', '2007-12-18', '2', '2', '2025-2026', 'active', '2026-03-03 20:53:34', '2026-03-03 20:53:34');
INSERT INTO `students` (`id`, `lrn`, `first_name`, `last_name`, `middle_name`, `gender`, `birthdate`, `section_id`, `strand_id`, `school_year`, `status`, `created_at`, `updated_at`) VALUES ('6', '100100100006', 'Sofia', 'Villanueva', 'Torres', 'Female', '2008-04-22', '8', '3', '2025-2026', 'active', '2026-03-03 20:53:34', '2026-03-03 21:11:40');
INSERT INTO `students` (`id`, `lrn`, `first_name`, `last_name`, `middle_name`, `gender`, `birthdate`, `section_id`, `strand_id`, `school_year`, `status`, `created_at`, `updated_at`) VALUES ('7', '100100100007', 'Miguel', 'Aquino', 'Santos', 'Male', '2007-08-30', '3', '3', '2025-2026', 'active', '2026-03-03 20:53:34', '2026-03-03 20:53:34');
INSERT INTO `students` (`id`, `lrn`, `first_name`, `last_name`, `middle_name`, `gender`, `birthdate`, `section_id`, `strand_id`, `school_year`, `status`, `created_at`, `updated_at`) VALUES ('8', '100100100008', 'Isabella', 'Fernandez', 'Reyes', 'Female', '2008-02-14', '6', '1', '2025-2026', 'active', '2026-03-03 20:53:34', '2026-03-03 20:53:34');
INSERT INTO `students` (`id`, `lrn`, `first_name`, `last_name`, `middle_name`, `gender`, `birthdate`, `section_id`, `strand_id`, `school_year`, `status`, `created_at`, `updated_at`) VALUES ('9', '200200200001', 'Liam', 'Reyes', 'Cruz', 'Male', '2012-04-10', '11', NULL, '2025-2026', 'active', '2026-03-03 20:57:35', '2026-03-03 20:57:35');
INSERT INTO `students` (`id`, `lrn`, `first_name`, `last_name`, `middle_name`, `gender`, `birthdate`, `section_id`, `strand_id`, `school_year`, `status`, `created_at`, `updated_at`) VALUES ('10', '200200200002', 'Chloe', 'Santos', 'Lim', 'Female', '2011-07-22', '12', NULL, '2025-2026', 'active', '2026-03-03 20:57:35', '2026-03-03 20:57:35');
INSERT INTO `students` (`id`, `lrn`, `first_name`, `last_name`, `middle_name`, `gender`, `birthdate`, `section_id`, `strand_id`, `school_year`, `status`, `created_at`, `updated_at`) VALUES ('11', '200200200003', 'Marco', 'Villanueva', 'Bautista', 'Male', '2010-09-15', '13', NULL, '2025-2026', 'active', '2026-03-03 20:57:35', '2026-03-03 20:57:35');
INSERT INTO `students` (`id`, `lrn`, `first_name`, `last_name`, `middle_name`, `gender`, `birthdate`, `section_id`, `strand_id`, `school_year`, `status`, `created_at`, `updated_at`) VALUES ('12', '200200200004', 'Sophia', 'Dela Torre', 'Ramos', 'Female', '2009-11-03', '14', NULL, '2025-2026', 'active', '2026-03-03 20:57:35', '2026-03-03 20:57:35');
INSERT INTO `students` (`id`, `lrn`, `first_name`, `last_name`, `middle_name`, `gender`, `birthdate`, `section_id`, `strand_id`, `school_year`, `status`, `created_at`, `updated_at`) VALUES ('13', '200200200005', 'Nathan', 'Buenaventura', 'Garcia', 'Male', '2009-03-18', '14', NULL, '2025-2026', 'active', '2026-03-03 20:57:35', '2026-03-03 20:57:35');

DROP TABLE IF EXISTS `subjects`;
CREATE TABLE `subjects` (
  `id` int NOT NULL AUTO_INCREMENT,
  `subject_code` varchar(20) NOT NULL,
  `subject_name` varchar(100) NOT NULL,
  `grade_level` int DEFAULT NULL COMMENT 'NULL = all grade levels; 7-10 = JHS; 11-12 = SHS',
  `strand_id` int DEFAULT NULL,
  `subject_type` enum('core','specialized','applied','immersion','jhs_core','jhs_mapeh','jhs_tle','jhs_esp') NOT NULL DEFAULT 'core',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `strand_id` (`strand_id`),
  CONSTRAINT `subjects_ibfk_1` FOREIGN KEY (`strand_id`) REFERENCES `strands` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=104 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `grade_level`, `strand_id`, `subject_type`, `created_at`) VALUES ('1', 'G7-ENG', 'English 7', '7', NULL, 'jhs_core', '2026-03-03 20:53:34');
INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `grade_level`, `strand_id`, `subject_type`, `created_at`) VALUES ('2', 'G7-FIL', 'Filipino 7', '7', NULL, 'jhs_core', '2026-03-03 20:53:34');
INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `grade_level`, `strand_id`, `subject_type`, `created_at`) VALUES ('3', 'G7-MAT', 'Mathematics 7', '7', NULL, 'jhs_core', '2026-03-03 20:53:34');
INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `grade_level`, `strand_id`, `subject_type`, `created_at`) VALUES ('4', 'G7-SCI', 'Science 7', '7', NULL, 'jhs_core', '2026-03-03 20:53:34');
INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `grade_level`, `strand_id`, `subject_type`, `created_at`) VALUES ('5', 'G7-AP', 'Araling Panlipunan 7', '7', NULL, 'jhs_core', '2026-03-03 20:53:34');
INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `grade_level`, `strand_id`, `subject_type`, `created_at`) VALUES ('6', 'G7-ESP', 'Edukasyon sa Pagpapakatao 7', '7', NULL, 'jhs_esp', '2026-03-03 20:53:34');
INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `grade_level`, `strand_id`, `subject_type`, `created_at`) VALUES ('7', 'G7-MAPEH', 'MAPEH 7', '7', NULL, 'jhs_mapeh', '2026-03-03 20:53:34');
INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `grade_level`, `strand_id`, `subject_type`, `created_at`) VALUES ('8', 'G7-TLE', 'Technology & Livelihood Education 7', '7', NULL, 'jhs_tle', '2026-03-03 20:53:34');
INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `grade_level`, `strand_id`, `subject_type`, `created_at`) VALUES ('9', 'G8-ENG', 'English 8', '8', NULL, 'jhs_core', '2026-03-03 20:53:34');
INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `grade_level`, `strand_id`, `subject_type`, `created_at`) VALUES ('10', 'G8-FIL', 'Filipino 8', '8', NULL, 'jhs_core', '2026-03-03 20:53:34');
INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `grade_level`, `strand_id`, `subject_type`, `created_at`) VALUES ('11', 'G8-MAT', 'Mathematics 8', '8', NULL, 'jhs_core', '2026-03-03 20:53:34');
INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `grade_level`, `strand_id`, `subject_type`, `created_at`) VALUES ('12', 'G8-SCI', 'Science 8', '8', NULL, 'jhs_core', '2026-03-03 20:53:34');
INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `grade_level`, `strand_id`, `subject_type`, `created_at`) VALUES ('13', 'G8-AP', 'Araling Panlipunan 8', '8', NULL, 'jhs_core', '2026-03-03 20:53:34');
INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `grade_level`, `strand_id`, `subject_type`, `created_at`) VALUES ('14', 'G8-ESP', 'Edukasyon sa Pagpapakatao 8', '8', NULL, 'jhs_esp', '2026-03-03 20:53:34');
INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `grade_level`, `strand_id`, `subject_type`, `created_at`) VALUES ('15', 'G8-MAPEH', 'MAPEH 8', '8', NULL, 'jhs_mapeh', '2026-03-03 20:53:34');
INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `grade_level`, `strand_id`, `subject_type`, `created_at`) VALUES ('16', 'G8-TLE', 'Technology & Livelihood Education 8', '8', NULL, 'jhs_tle', '2026-03-03 20:53:34');
INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `grade_level`, `strand_id`, `subject_type`, `created_at`) VALUES ('17', 'G9-ENG', 'English 9', '9', NULL, 'jhs_core', '2026-03-03 20:53:34');
INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `grade_level`, `strand_id`, `subject_type`, `created_at`) VALUES ('18', 'G9-FIL', 'Filipino 9', '9', NULL, 'jhs_core', '2026-03-03 20:53:34');
INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `grade_level`, `strand_id`, `subject_type`, `created_at`) VALUES ('19', 'G9-MAT', 'Mathematics 9', '9', NULL, 'jhs_core', '2026-03-03 20:53:34');
INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `grade_level`, `strand_id`, `subject_type`, `created_at`) VALUES ('20', 'G9-SCI', 'Science 9', '9', NULL, 'jhs_core', '2026-03-03 20:53:34');
INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `grade_level`, `strand_id`, `subject_type`, `created_at`) VALUES ('21', 'G9-AP', 'Araling Panlipunan 9', '9', NULL, 'jhs_core', '2026-03-03 20:53:34');
INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `grade_level`, `strand_id`, `subject_type`, `created_at`) VALUES ('22', 'G9-ESP', 'Edukasyon sa Pagpapakatao 9', '9', NULL, 'jhs_esp', '2026-03-03 20:53:34');
INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `grade_level`, `strand_id`, `subject_type`, `created_at`) VALUES ('23', 'G9-MAPEH', 'MAPEH 9', '9', NULL, 'jhs_mapeh', '2026-03-03 20:53:34');
INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `grade_level`, `strand_id`, `subject_type`, `created_at`) VALUES ('24', 'G9-TLE', 'Technology & Livelihood Education 9', '9', NULL, 'jhs_tle', '2026-03-03 20:53:34');
INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `grade_level`, `strand_id`, `subject_type`, `created_at`) VALUES ('25', 'G10-ENG', 'English 10', '10', NULL, 'jhs_core', '2026-03-03 20:53:34');
INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `grade_level`, `strand_id`, `subject_type`, `created_at`) VALUES ('26', 'G10-FIL', 'Filipino 10', '10', NULL, 'jhs_core', '2026-03-03 20:53:34');
INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `grade_level`, `strand_id`, `subject_type`, `created_at`) VALUES ('27', 'G10-MAT', 'Mathematics 10', '10', NULL, 'jhs_core', '2026-03-03 20:53:34');
INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `grade_level`, `strand_id`, `subject_type`, `created_at`) VALUES ('28', 'G10-SCI', 'Science 10', '10', NULL, 'jhs_core', '2026-03-03 20:53:34');
INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `grade_level`, `strand_id`, `subject_type`, `created_at`) VALUES ('29', 'G10-AP', 'Araling Panlipunan 10', '10', NULL, 'jhs_core', '2026-03-03 20:53:34');
INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `grade_level`, `strand_id`, `subject_type`, `created_at`) VALUES ('30', 'G10-ESP', 'Edukasyon sa Pagpapakatao 10', '10', NULL, 'jhs_esp', '2026-03-03 20:53:34');
INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `grade_level`, `strand_id`, `subject_type`, `created_at`) VALUES ('31', 'G10-MAPEH', 'MAPEH 10', '10', NULL, 'jhs_mapeh', '2026-03-03 20:53:34');
INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `grade_level`, `strand_id`, `subject_type`, `created_at`) VALUES ('32', 'G10-TLE', 'Technology & Livelihood Education 10', '10', NULL, 'jhs_tle', '2026-03-03 20:53:34');
INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `grade_level`, `strand_id`, `subject_type`, `created_at`) VALUES ('33', 'CORE01', 'Oral Communication', '11', NULL, 'core', '2026-03-03 20:53:34');
INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `grade_level`, `strand_id`, `subject_type`, `created_at`) VALUES ('34', 'CORE02', 'Reading and Writing', '11', NULL, 'core', '2026-03-03 20:53:34');
INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `grade_level`, `strand_id`, `subject_type`, `created_at`) VALUES ('35', 'CORE03', 'Komunikasyon at Pananaliksik sa Wika at Kulturang Pilipino', '11', NULL, 'core', '2026-03-03 20:53:34');
INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `grade_level`, `strand_id`, `subject_type`, `created_at`) VALUES ('36', 'CORE04', 'General Mathematics', '11', NULL, 'core', '2026-03-03 20:53:34');
INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `grade_level`, `strand_id`, `subject_type`, `created_at`) VALUES ('37', 'CORE05', 'Earth and Life Science', '11', NULL, 'core', '2026-03-03 20:53:34');
INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `grade_level`, `strand_id`, `subject_type`, `created_at`) VALUES ('38', 'CORE06', 'Physical Science', '11', NULL, 'core', '2026-03-03 20:53:34');
INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `grade_level`, `strand_id`, `subject_type`, `created_at`) VALUES ('39', 'CORE07', 'Personal Development', '11', NULL, 'core', '2026-03-03 20:53:34');
INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `grade_level`, `strand_id`, `subject_type`, `created_at`) VALUES ('40', 'CORE08', 'Understanding Culture, Society, and Politics', '11', NULL, 'core', '2026-03-03 20:53:34');
INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `grade_level`, `strand_id`, `subject_type`, `created_at`) VALUES ('41', 'CORE09', 'Introduction to Philosophy', '11', NULL, 'core', '2026-03-03 20:53:34');
INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `grade_level`, `strand_id`, `subject_type`, `created_at`) VALUES ('42', 'CORE10', 'Physical Education and Health', '11', NULL, 'core', '2026-03-03 20:53:34');
INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `grade_level`, `strand_id`, `subject_type`, `created_at`) VALUES ('43', 'CORE11', 'Media and Information Literacy', '11', NULL, 'core', '2026-03-03 20:53:34');
INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `grade_level`, `strand_id`, `subject_type`, `created_at`) VALUES ('44', 'CORE12', '21st Century Literature from the Philippines and the World', '11', NULL, 'core', '2026-03-03 20:53:34');
INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `grade_level`, `strand_id`, `subject_type`, `created_at`) VALUES ('45', 'CORE13', 'Contemporary Philippine Arts from the Regions', '11', NULL, 'core', '2026-03-03 20:53:34');
INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `grade_level`, `strand_id`, `subject_type`, `created_at`) VALUES ('46', 'APP01', 'English for Academic and Professional Purposes', '12', NULL, 'applied', '2026-03-03 20:53:34');
INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `grade_level`, `strand_id`, `subject_type`, `created_at`) VALUES ('47', 'APP02', 'Practical Research 1', '11', NULL, 'applied', '2026-03-03 20:53:34');
INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `grade_level`, `strand_id`, `subject_type`, `created_at`) VALUES ('48', 'APP03', 'Practical Research 2', '12', NULL, 'applied', '2026-03-03 20:53:34');
INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `grade_level`, `strand_id`, `subject_type`, `created_at`) VALUES ('49', 'APP04', 'Filipino sa Piling Larangan', '12', NULL, 'applied', '2026-03-03 20:53:34');
INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `grade_level`, `strand_id`, `subject_type`, `created_at`) VALUES ('50', 'APP05', 'Empowerment Technologies', '11', NULL, 'applied', '2026-03-03 20:53:34');
INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `grade_level`, `strand_id`, `subject_type`, `created_at`) VALUES ('51', 'APP06', 'Entrepreneurship', '12', NULL, 'applied', '2026-03-03 20:53:34');
INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `grade_level`, `strand_id`, `subject_type`, `created_at`) VALUES ('52', 'APP07', 'Inquiries, Investigations, and Immersion', '12', NULL, 'applied', '2026-03-03 20:53:34');
INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `grade_level`, `strand_id`, `subject_type`, `created_at`) VALUES ('53', 'STEM01', 'Pre-Calculus', '11', '1', 'specialized', '2026-03-03 20:53:34');
INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `grade_level`, `strand_id`, `subject_type`, `created_at`) VALUES ('54', 'STEM02', 'Basic Calculus', '12', '1', 'specialized', '2026-03-03 20:53:34');
INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `grade_level`, `strand_id`, `subject_type`, `created_at`) VALUES ('55', 'STEM03', 'General Biology 1', '11', '1', 'specialized', '2026-03-03 20:53:34');
INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `grade_level`, `strand_id`, `subject_type`, `created_at`) VALUES ('56', 'STEM04', 'General Biology 2', '12', '1', 'specialized', '2026-03-03 20:53:34');
INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `grade_level`, `strand_id`, `subject_type`, `created_at`) VALUES ('57', 'STEM05', 'General Chemistry 1', '11', '1', 'specialized', '2026-03-03 20:53:34');
INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `grade_level`, `strand_id`, `subject_type`, `created_at`) VALUES ('58', 'STEM06', 'General Chemistry 2', '12', '1', 'specialized', '2026-03-03 20:53:34');
INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `grade_level`, `strand_id`, `subject_type`, `created_at`) VALUES ('59', 'STEM07', 'General Physics 1', '11', '1', 'specialized', '2026-03-03 20:53:34');
INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `grade_level`, `strand_id`, `subject_type`, `created_at`) VALUES ('60', 'STEM08', 'General Physics 2', '12', '1', 'specialized', '2026-03-03 20:53:34');
INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `grade_level`, `strand_id`, `subject_type`, `created_at`) VALUES ('61', 'STEM09', 'Research/Capstone Project', '12', '1', 'specialized', '2026-03-03 20:53:34');
INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `grade_level`, `strand_id`, `subject_type`, `created_at`) VALUES ('62', 'ABM01', 'Fundamentals of ABM 1', '11', '2', 'specialized', '2026-03-03 20:53:34');
INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `grade_level`, `strand_id`, `subject_type`, `created_at`) VALUES ('63', 'ABM02', 'Fundamentals of ABM 2', '12', '2', 'specialized', '2026-03-03 20:53:34');
INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `grade_level`, `strand_id`, `subject_type`, `created_at`) VALUES ('64', 'ABM03', 'Business Mathematics', '11', '2', 'specialized', '2026-03-03 20:53:34');
INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `grade_level`, `strand_id`, `subject_type`, `created_at`) VALUES ('65', 'ABM04', 'Business Finance', '12', '2', 'specialized', '2026-03-03 20:53:34');
INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `grade_level`, `strand_id`, `subject_type`, `created_at`) VALUES ('66', 'ABM05', 'Organization and Management', '11', '2', 'specialized', '2026-03-03 20:53:34');
INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `grade_level`, `strand_id`, `subject_type`, `created_at`) VALUES ('67', 'ABM06', 'Principles of Marketing', '12', '2', 'specialized', '2026-03-03 20:53:34');
INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `grade_level`, `strand_id`, `subject_type`, `created_at`) VALUES ('68', 'ABM07', 'Business Ethics and Social Responsibility', '12', '2', 'specialized', '2026-03-03 20:53:34');
INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `grade_level`, `strand_id`, `subject_type`, `created_at`) VALUES ('69', 'ABM08', 'Applied Economics', '12', '2', 'specialized', '2026-03-03 20:53:34');
INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `grade_level`, `strand_id`, `subject_type`, `created_at`) VALUES ('70', 'HUM01', 'Introduction to World Religions and Belief Systems', '11', '3', 'specialized', '2026-03-03 20:53:34');
INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `grade_level`, `strand_id`, `subject_type`, `created_at`) VALUES ('71', 'HUM02', 'Creative Writing / Malikhaing Pagsulat', '11', '3', 'specialized', '2026-03-03 20:53:34');
INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `grade_level`, `strand_id`, `subject_type`, `created_at`) VALUES ('72', 'HUM03', 'Creative Nonfiction', '12', '3', 'specialized', '2026-03-03 20:53:34');
INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `grade_level`, `strand_id`, `subject_type`, `created_at`) VALUES ('73', 'HUM04', 'Trends, Networks, and Critical Thinking', '12', '3', 'specialized', '2026-03-03 20:53:34');
INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `grade_level`, `strand_id`, `subject_type`, `created_at`) VALUES ('74', 'HUM05', 'Philippine Politics and Governance', '12', '3', 'specialized', '2026-03-03 20:53:34');
INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `grade_level`, `strand_id`, `subject_type`, `created_at`) VALUES ('75', 'HUM06', 'Community Engagement, Solidarity, and Citizenship', '12', '3', 'specialized', '2026-03-03 20:53:34');
INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `grade_level`, `strand_id`, `subject_type`, `created_at`) VALUES ('76', 'HUM07', 'Disciplines and Ideas in the Social Sciences', '11', '3', 'specialized', '2026-03-03 20:53:34');
INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `grade_level`, `strand_id`, `subject_type`, `created_at`) VALUES ('77', 'GAS01', 'Humanities 1', '11', '4', 'specialized', '2026-03-03 20:53:34');
INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `grade_level`, `strand_id`, `subject_type`, `created_at`) VALUES ('78', 'GAS02', 'Humanities 2', '12', '4', 'specialized', '2026-03-03 20:53:34');
INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `grade_level`, `strand_id`, `subject_type`, `created_at`) VALUES ('79', 'GAS03', 'Social Science 1', '11', '4', 'specialized', '2026-03-03 20:53:34');
INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `grade_level`, `strand_id`, `subject_type`, `created_at`) VALUES ('80', 'GAS04', 'Applied Economics', '12', '4', 'specialized', '2026-03-03 20:53:34');
INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `grade_level`, `strand_id`, `subject_type`, `created_at`) VALUES ('81', 'GAS05', 'Organization and Management', '11', '4', 'specialized', '2026-03-03 20:53:34');
INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `grade_level`, `strand_id`, `subject_type`, `created_at`) VALUES ('82', 'GAS06', 'Disaster Readiness and Risk Reduction', '12', '4', 'specialized', '2026-03-03 20:53:34');
INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `grade_level`, `strand_id`, `subject_type`, `created_at`) VALUES ('83', 'ICT01', 'Computer Systems Servicing NC II', '11', '5', 'specialized', '2026-03-03 20:53:34');
INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `grade_level`, `strand_id`, `subject_type`, `created_at`) VALUES ('84', 'ICT02', 'Computer Programming (Java)', '11', '5', 'specialized', '2026-03-03 20:53:34');
INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `grade_level`, `strand_id`, `subject_type`, `created_at`) VALUES ('85', 'ICT03', 'Web Development', '12', '5', 'specialized', '2026-03-03 20:53:34');
INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `grade_level`, `strand_id`, `subject_type`, `created_at`) VALUES ('86', 'ICT04', 'Illustration and Animation', '12', '5', 'specialized', '2026-03-03 20:53:34');
INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `grade_level`, `strand_id`, `subject_type`, `created_at`) VALUES ('87', 'HE01', 'Bread and Pastry Production NC II', '11', '6', 'specialized', '2026-03-03 20:53:34');
INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `grade_level`, `strand_id`, `subject_type`, `created_at`) VALUES ('88', 'HE02', 'Cookery NC II', '11', '6', 'specialized', '2026-03-03 20:53:34');
INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `grade_level`, `strand_id`, `subject_type`, `created_at`) VALUES ('89', 'HE03', 'Housekeeping NC II', '12', '6', 'specialized', '2026-03-03 20:53:34');
INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `grade_level`, `strand_id`, `subject_type`, `created_at`) VALUES ('90', 'HE04', 'Food and Beverage Services NC II', '12', '6', 'specialized', '2026-03-03 20:53:34');
INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `grade_level`, `strand_id`, `subject_type`, `created_at`) VALUES ('91', 'IA01', 'Electrical Installation and Maintenance NC II', '11', '7', 'specialized', '2026-03-03 20:53:34');
INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `grade_level`, `strand_id`, `subject_type`, `created_at`) VALUES ('92', 'IA02', 'Welding NC I', '11', '7', 'specialized', '2026-03-03 20:53:34');
INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `grade_level`, `strand_id`, `subject_type`, `created_at`) VALUES ('93', 'IA03', 'Carpentry NC II', '12', '7', 'specialized', '2026-03-03 20:53:34');
INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `grade_level`, `strand_id`, `subject_type`, `created_at`) VALUES ('94', 'IA04', 'Automotive Servicing NC I', '12', '7', 'specialized', '2026-03-03 20:53:34');
INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `grade_level`, `strand_id`, `subject_type`, `created_at`) VALUES ('95', 'SPT01', 'Physical Fitness', '11', '8', 'specialized', '2026-03-03 20:53:34');
INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `grade_level`, `strand_id`, `subject_type`, `created_at`) VALUES ('96', 'SPT02', 'Team Sports', '11', '8', 'specialized', '2026-03-03 20:53:34');
INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `grade_level`, `strand_id`, `subject_type`, `created_at`) VALUES ('97', 'SPT03', 'Individual/Dual Sports', '12', '8', 'specialized', '2026-03-03 20:53:34');
INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `grade_level`, `strand_id`, `subject_type`, `created_at`) VALUES ('98', 'SPT04', 'Sports Officiating and Journalism', '12', '8', 'specialized', '2026-03-03 20:53:34');
INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `grade_level`, `strand_id`, `subject_type`, `created_at`) VALUES ('99', 'ART01', 'Drawing and Painting', '11', '9', 'specialized', '2026-03-03 20:53:34');
INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `grade_level`, `strand_id`, `subject_type`, `created_at`) VALUES ('100', 'ART02', 'Photography and Film', '11', '9', 'specialized', '2026-03-03 20:53:34');
INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `grade_level`, `strand_id`, `subject_type`, `created_at`) VALUES ('101', 'ART03', 'Graphic Design', '12', '9', 'specialized', '2026-03-03 20:53:34');
INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `grade_level`, `strand_id`, `subject_type`, `created_at`) VALUES ('102', 'ART04', 'Creative Industry Immersion', '12', '9', 'specialized', '2026-03-03 20:53:34');
INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `grade_level`, `strand_id`, `subject_type`, `created_at`) VALUES ('103', 'WI101', 'Work Immersion', '12', NULL, 'immersion', '2026-03-03 20:53:34');

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
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO `users` (`id`, `username`, `password`, `full_name`, `email`, `role`, `status`, `created_at`, `updated_at`) VALUES ('1', 'admin', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'System Administrator', 'admin@steps.edu', 'admin', 'active', '2026-03-03 20:53:33', '2026-03-03 20:53:33');
INSERT INTO `users` (`id`, `username`, `password`, `full_name`, `email`, `role`, `status`, `created_at`, `updated_at`) VALUES ('2', 'teacher_santos', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Maria Santos', 'maria@steps.edu', 'teacher', 'active', '2026-03-03 20:53:33', '2026-03-03 20:53:33');
INSERT INTO `users` (`id`, `username`, `password`, `full_name`, `email`, `role`, `status`, `created_at`, `updated_at`) VALUES ('3', 'teacher_delos_reyes', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Carlos Delos Reyes', 'carlos@steps.edu', 'teacher', 'active', '2026-03-03 20:53:33', '2026-03-03 20:53:33');
INSERT INTO `users` (`id`, `username`, `password`, `full_name`, `email`, `role`, `status`, `created_at`, `updated_at`) VALUES ('4', 'teacher_cruz', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Ana Cruz', 'ana@steps.edu', 'teacher', 'active', '2026-03-03 20:53:33', '2026-03-03 20:53:33');
INSERT INTO `users` (`id`, `username`, `password`, `full_name`, `email`, `role`, `status`, `created_at`, `updated_at`) VALUES ('5', 'guidance_reyes', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Jose Reyes', 'jose@steps.edu', 'guidance', 'active', '2026-03-03 20:53:33', '2026-03-03 20:53:33');
INSERT INTO `users` (`id`, `username`, `password`, `full_name`, `email`, `role`, `status`, `created_at`, `updated_at`) VALUES ('6', 'guidance_mendoza', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Sofia Mendoza', 'sofia@steps.edu', 'guidance', 'active', '2026-03-03 20:53:33', '2026-03-03 20:53:33');
INSERT INTO `users` (`id`, `username`, `password`, `full_name`, `email`, `role`, `status`, `created_at`, `updated_at`) VALUES ('7', 'teacher_monsion', '$2y$10$QTmLDnKb4TmgMAI7oPxoEe.0tjpVDjrR2W10KbFmJ8L7fx2d8DaGm', 'Javidec Monsion', 'javidecdaylusan@gmail.com', 'teacher', 'active', '2026-03-03 21:46:37', '2026-03-03 21:46:37');

SET FOREIGN_KEY_CHECKS = 1;
