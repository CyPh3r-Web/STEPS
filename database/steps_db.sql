-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1:3306
-- Generation Time: Apr 02, 2026 at 04:34 AM
-- Server version: 8.0.31
-- PHP Version: 8.2.0

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `steps_db`
--

-- --------------------------------------------------------

--
-- Table structure for table `activity_logs`
--

DROP TABLE IF EXISTS `activity_logs`;
CREATE TABLE IF NOT EXISTS `activity_logs` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int DEFAULT NULL,
  `action` varchar(100) NOT NULL,
  `description` text,
  `ip_address` varchar(45) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  KEY `idx_activity_created` (`created_at`),
  KEY `idx_activity_action` (`action`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `activity_logs`
--

INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES
(1, 1, 'logout', 'User logged out', '::1', '2026-04-02 04:27:11'),
(2, 2, 'login', 'User logged in', '::1', '2026-04-02 04:27:42'),
(3, 2, 'logout', 'User logged out', '::1', '2026-04-02 04:29:19'),
(4, 1, 'login', 'User logged in', '::1', '2026-04-02 04:29:23'),
(5, 1, 'support_ticket_update', 'Ticket #1 updated', '::1', '2026-04-02 04:29:33'),
(6, 1, 'support_ticket_update', 'Ticket #1 updated', '::1', '2026-04-02 04:31:02'),
(7, 1, 'support_ticket_update', 'Ticket #1 updated', '::1', '2026-04-02 04:31:11'),
(8, 1, 'support_ticket_update', 'Ticket #1 updated', '::1', '2026-04-02 04:31:21'),
(9, 1, 'support_ticket_update', 'Ticket #1 updated', '::1', '2026-04-02 04:31:24'),
(10, 1, 'logout', 'User logged out', '::1', '2026-04-02 04:31:44'),
(11, 2, 'login', 'User logged in', '::1', '2026-04-02 04:31:49'),
(12, 2, 'logout', 'User logged out', '::1', '2026-04-02 04:31:56'),
(13, 1, 'login', 'User logged in', '::1', '2026-04-02 04:32:02');

-- --------------------------------------------------------

--
-- Table structure for table `backup_logs`
--

DROP TABLE IF EXISTS `backup_logs`;
CREATE TABLE IF NOT EXISTS `backup_logs` (
  `id` int NOT NULL AUTO_INCREMENT,
  `backup_file` varchar(255) NOT NULL,
  `file_size` varchar(50) DEFAULT NULL,
  `backup_type` enum('full','partial') NOT NULL DEFAULT 'full',
  `created_by` int DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `created_by` (`created_by`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `career_recommendations`
--

DROP TABLE IF EXISTS `career_recommendations`;
CREATE TABLE IF NOT EXISTS `career_recommendations` (
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
  UNIQUE KEY `unique_career_rec` (`student_id`,`recommendation_type`,`school_year`),
  KEY `generated_by` (`generated_by`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `competency_records`
--

DROP TABLE IF EXISTS `competency_records`;
CREATE TABLE IF NOT EXISTS `competency_records` (
  `id` int NOT NULL AUTO_INCREMENT,
  `student_id` int NOT NULL,
  `subject_id` int NOT NULL,
  `average_grade` decimal(5,2) NOT NULL,
  `competency_level` enum('weak','at_risk','proficient') NOT NULL,
  `remarks` varchar(100) DEFAULT NULL,
  `school_year` varchar(20) NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_competency` (`student_id`,`subject_id`,`school_year`),
  KEY `subject_id` (`subject_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `diagnostic_reports`
--

DROP TABLE IF EXISTS `diagnostic_reports`;
CREATE TABLE IF NOT EXISTS `diagnostic_reports` (
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
  KEY `generated_by` (`generated_by`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `grades`
--

DROP TABLE IF EXISTS `grades`;
CREATE TABLE IF NOT EXISTS `grades` (
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
  KEY `encoded_by` (`encoded_by`)
) ENGINE=InnoDB AUTO_INCREMENT=215 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `grades`
--

INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES
(1, 1, 4, 'Q1', '88.00', '2025-2026', 2, '2026-04-02 04:20:11', '2026-04-02 04:20:11'),
(2, 1, 4, 'Q2', '90.00', '2025-2026', 2, '2026-04-02 04:20:11', '2026-04-02 04:20:11'),
(3, 1, 21, 'Q1', '85.00', '2025-2026', 2, '2026-04-02 04:20:11', '2026-04-02 04:20:11'),
(4, 1, 21, 'Q2', '87.00', '2025-2026', 2, '2026-04-02 04:20:11', '2026-04-02 04:20:11'),
(5, 1, 23, 'Q1', '92.00', '2025-2026', 2, '2026-04-02 04:20:11', '2026-04-02 04:20:11'),
(6, 1, 23, 'Q2', '91.00', '2025-2026', 2, '2026-04-02 04:20:11', '2026-04-02 04:20:11'),
(7, 1, 1, 'Q1', '86.00', '2025-2026', 2, '2026-04-02 04:20:11', '2026-04-02 04:20:11'),
(8, 1, 1, 'Q2', '88.00', '2025-2026', 2, '2026-04-02 04:20:11', '2026-04-02 04:20:11'),
(9, 2, 4, 'Q1', '78.00', '2025-2026', 2, '2026-04-02 04:20:11', '2026-04-02 04:20:11'),
(10, 2, 4, 'Q2', '76.00', '2025-2026', 2, '2026-04-02 04:20:11', '2026-04-02 04:20:11'),
(11, 2, 21, 'Q1', '74.00', '2025-2026', 2, '2026-04-02 04:20:11', '2026-04-02 04:20:11'),
(12, 2, 21, 'Q2', '73.00', '2025-2026', 2, '2026-04-02 04:20:11', '2026-04-02 04:20:11'),
(13, 2, 23, 'Q1', '80.00', '2025-2026', 2, '2026-04-02 04:20:11', '2026-04-02 04:20:11'),
(14, 2, 23, 'Q2', '79.00', '2025-2026', 2, '2026-04-02 04:20:11', '2026-04-02 04:20:11'),
(15, 2, 1, 'Q1', '82.00', '2025-2026', 2, '2026-04-02 04:20:11', '2026-04-02 04:20:11'),
(16, 2, 1, 'Q2', '81.00', '2025-2026', 2, '2026-04-02 04:20:11', '2026-04-02 04:20:11'),
(17, 3, 4, 'Q1', '72.00', '2025-2026', 2, '2026-04-02 04:20:11', '2026-04-02 04:20:11'),
(18, 3, 4, 'Q2', '70.00', '2025-2026', 2, '2026-04-02 04:20:11', '2026-04-02 04:20:11'),
(19, 3, 21, 'Q1', '68.00', '2025-2026', 2, '2026-04-02 04:20:11', '2026-04-02 04:20:11'),
(20, 3, 21, 'Q2', '71.00', '2025-2026', 2, '2026-04-02 04:20:11', '2026-04-02 04:20:11'),
(21, 3, 23, 'Q1', '74.00', '2025-2026', 2, '2026-04-02 04:20:11', '2026-04-02 04:20:11'),
(22, 3, 23, 'Q2', '73.00', '2025-2026', 2, '2026-04-02 04:20:11', '2026-04-02 04:20:11'),
(23, 3, 1, 'Q1', '75.00', '2025-2026', 2, '2026-04-02 04:20:11', '2026-04-02 04:20:11'),
(24, 3, 1, 'Q2', '76.00', '2025-2026', 2, '2026-04-02 04:20:11', '2026-04-02 04:20:11'),
(25, 4, 30, 'Q1', '89.00', '2025-2026', 2, '2026-04-02 04:20:11', '2026-04-02 04:20:11'),
(26, 4, 30, 'Q2', '91.00', '2025-2026', 2, '2026-04-02 04:20:11', '2026-04-02 04:20:11'),
(27, 4, 33, 'Q1', '87.00', '2025-2026', 2, '2026-04-02 04:20:11', '2026-04-02 04:20:11'),
(28, 4, 33, 'Q2', '90.00', '2025-2026', 2, '2026-04-02 04:20:11', '2026-04-02 04:20:11'),
(29, 4, 1, 'Q1', '85.00', '2025-2026', 2, '2026-04-02 04:20:11', '2026-04-02 04:20:11'),
(30, 4, 1, 'Q2', '88.00', '2025-2026', 2, '2026-04-02 04:20:11', '2026-04-02 04:20:11'),
(31, 5, 30, 'Q1', '76.00', '2025-2026', 2, '2026-04-02 04:20:11', '2026-04-02 04:20:11'),
(32, 5, 30, 'Q2', '78.00', '2025-2026', 2, '2026-04-02 04:20:11', '2026-04-02 04:20:11'),
(33, 5, 33, 'Q1', '74.00', '2025-2026', 2, '2026-04-02 04:20:11', '2026-04-02 04:20:11'),
(34, 5, 33, 'Q2', '77.00', '2025-2026', 2, '2026-04-02 04:20:11', '2026-04-02 04:20:11'),
(35, 5, 1, 'Q1', '79.00', '2025-2026', 2, '2026-04-02 04:20:11', '2026-04-02 04:20:11'),
(36, 5, 1, 'Q2', '80.00', '2025-2026', 2, '2026-04-02 04:20:11', '2026-04-02 04:20:11'),
(37, 6, 38, 'Q1', '90.00', '2025-2026', 2, '2026-04-02 04:20:11', '2026-04-02 04:20:11'),
(38, 6, 38, 'Q2', '92.00', '2025-2026', 2, '2026-04-02 04:20:11', '2026-04-02 04:20:11'),
(39, 6, 39, 'Q1', '88.00', '2025-2026', 2, '2026-04-02 04:20:11', '2026-04-02 04:20:11'),
(40, 6, 39, 'Q2', '91.00', '2025-2026', 2, '2026-04-02 04:20:11', '2026-04-02 04:20:11'),
(41, 6, 1, 'Q1', '93.00', '2025-2026', 2, '2026-04-02 04:20:11', '2026-04-02 04:20:11'),
(42, 6, 1, 'Q2', '94.00', '2025-2026', 2, '2026-04-02 04:20:11', '2026-04-02 04:20:11'),
(43, 7, 38, 'Q1', '77.00', '2025-2026', 2, '2026-04-02 04:20:11', '2026-04-02 04:20:11'),
(44, 7, 38, 'Q2', '75.00', '2025-2026', 2, '2026-04-02 04:20:11', '2026-04-02 04:20:11'),
(45, 7, 39, 'Q1', '79.00', '2025-2026', 2, '2026-04-02 04:20:11', '2026-04-02 04:20:11'),
(46, 7, 39, 'Q2', '78.00', '2025-2026', 2, '2026-04-02 04:20:11', '2026-04-02 04:20:11'),
(47, 7, 1, 'Q1', '76.00', '2025-2026', 2, '2026-04-02 04:20:11', '2026-04-02 04:20:11'),
(48, 7, 1, 'Q2', '77.00', '2025-2026', 2, '2026-04-02 04:20:11', '2026-04-02 04:20:11'),
(49, 8, 4, 'Q1', '95.00', '2025-2026', 2, '2026-04-02 04:20:11', '2026-04-02 04:20:11'),
(50, 8, 4, 'Q2', '96.00', '2025-2026', 2, '2026-04-02 04:20:11', '2026-04-02 04:20:11'),
(51, 8, 21, 'Q1', '93.00', '2025-2026', 2, '2026-04-02 04:20:11', '2026-04-02 04:20:11'),
(52, 8, 21, 'Q2', '94.00', '2025-2026', 2, '2026-04-02 04:20:11', '2026-04-02 04:20:11'),
(53, 8, 23, 'Q1', '91.00', '2025-2026', 2, '2026-04-02 04:20:11', '2026-04-02 04:20:11'),
(54, 8, 23, 'Q2', '93.00', '2025-2026', 2, '2026-04-02 04:20:11', '2026-04-02 04:20:11'),
(55, 9, 1, 'Q1', '85.00', '2025-2026', 2, '2026-04-02 04:20:12', '2026-04-02 04:20:12'),
(56, 9, 1, 'Q2', '86.00', '2025-2026', 2, '2026-04-02 04:20:12', '2026-04-02 04:20:12'),
(57, 9, 1, 'Q3', '87.00', '2025-2026', 2, '2026-04-02 04:20:12', '2026-04-02 04:20:12'),
(58, 9, 1, 'Q4', '88.00', '2025-2026', 2, '2026-04-02 04:20:12', '2026-04-02 04:20:12'),
(59, 9, 2, 'Q1', '82.00', '2025-2026', 2, '2026-04-02 04:20:12', '2026-04-02 04:20:12'),
(60, 9, 2, 'Q2', '83.00', '2025-2026', 2, '2026-04-02 04:20:12', '2026-04-02 04:20:12'),
(61, 9, 2, 'Q3', '84.00', '2025-2026', 2, '2026-04-02 04:20:12', '2026-04-02 04:20:12'),
(62, 9, 2, 'Q4', '85.00', '2025-2026', 2, '2026-04-02 04:20:12', '2026-04-02 04:20:12'),
(63, 9, 3, 'Q1', '93.00', '2025-2026', 2, '2026-04-02 04:20:12', '2026-04-02 04:20:12'),
(64, 9, 3, 'Q2', '95.00', '2025-2026', 2, '2026-04-02 04:20:12', '2026-04-02 04:20:12'),
(65, 9, 3, 'Q3', '94.00', '2025-2026', 2, '2026-04-02 04:20:12', '2026-04-02 04:20:12'),
(66, 9, 3, 'Q4', '96.00', '2025-2026', 2, '2026-04-02 04:20:12', '2026-04-02 04:20:12'),
(67, 9, 4, 'Q1', '91.00', '2025-2026', 2, '2026-04-02 04:20:12', '2026-04-02 04:20:12'),
(68, 9, 4, 'Q2', '92.00', '2025-2026', 2, '2026-04-02 04:20:12', '2026-04-02 04:20:12'),
(69, 9, 4, 'Q3', '93.00', '2025-2026', 2, '2026-04-02 04:20:12', '2026-04-02 04:20:12'),
(70, 9, 4, 'Q4', '95.00', '2025-2026', 2, '2026-04-02 04:20:12', '2026-04-02 04:20:12'),
(71, 9, 5, 'Q1', '80.00', '2025-2026', 2, '2026-04-02 04:20:12', '2026-04-02 04:20:12'),
(72, 9, 5, 'Q2', '81.00', '2025-2026', 2, '2026-04-02 04:20:12', '2026-04-02 04:20:12'),
(73, 9, 5, 'Q3', '82.00', '2025-2026', 2, '2026-04-02 04:20:12', '2026-04-02 04:20:12'),
(74, 9, 5, 'Q4', '83.00', '2025-2026', 2, '2026-04-02 04:20:12', '2026-04-02 04:20:12'),
(75, 9, 6, 'Q1', '84.00', '2025-2026', 2, '2026-04-02 04:20:12', '2026-04-02 04:20:12'),
(76, 9, 6, 'Q2', '85.00', '2025-2026', 2, '2026-04-02 04:20:12', '2026-04-02 04:20:12'),
(77, 9, 6, 'Q3', '86.00', '2025-2026', 2, '2026-04-02 04:20:12', '2026-04-02 04:20:12'),
(78, 9, 6, 'Q4', '87.00', '2025-2026', 2, '2026-04-02 04:20:12', '2026-04-02 04:20:12'),
(79, 9, 7, 'Q1', '80.00', '2025-2026', 2, '2026-04-02 04:20:12', '2026-04-02 04:20:12'),
(80, 9, 7, 'Q2', '82.00', '2025-2026', 2, '2026-04-02 04:20:12', '2026-04-02 04:20:12'),
(81, 9, 7, 'Q3', '83.00', '2025-2026', 2, '2026-04-02 04:20:12', '2026-04-02 04:20:12'),
(82, 9, 7, 'Q4', '84.00', '2025-2026', 2, '2026-04-02 04:20:12', '2026-04-02 04:20:12'),
(83, 9, 8, 'Q1', '78.00', '2025-2026', 2, '2026-04-02 04:20:12', '2026-04-02 04:20:12'),
(84, 9, 8, 'Q2', '79.00', '2025-2026', 2, '2026-04-02 04:20:12', '2026-04-02 04:20:12'),
(85, 9, 8, 'Q3', '80.00', '2025-2026', 2, '2026-04-02 04:20:12', '2026-04-02 04:20:12'),
(86, 9, 8, 'Q4', '81.00', '2025-2026', 2, '2026-04-02 04:20:12', '2026-04-02 04:20:12'),
(87, 10, 9, 'Q1', '80.00', '2025-2026', 2, '2026-04-02 04:20:12', '2026-04-02 04:20:12'),
(88, 10, 9, 'Q2', '81.00', '2025-2026', 2, '2026-04-02 04:20:12', '2026-04-02 04:20:12'),
(89, 10, 9, 'Q3', '82.00', '2025-2026', 2, '2026-04-02 04:20:12', '2026-04-02 04:20:12'),
(90, 10, 9, 'Q4', '83.00', '2025-2026', 2, '2026-04-02 04:20:12', '2026-04-02 04:20:12'),
(91, 10, 10, 'Q1', '83.00', '2025-2026', 2, '2026-04-02 04:20:12', '2026-04-02 04:20:12'),
(92, 10, 10, 'Q2', '84.00', '2025-2026', 2, '2026-04-02 04:20:12', '2026-04-02 04:20:12'),
(93, 10, 10, 'Q3', '85.00', '2025-2026', 2, '2026-04-02 04:20:12', '2026-04-02 04:20:12'),
(94, 10, 10, 'Q4', '86.00', '2025-2026', 2, '2026-04-02 04:20:12', '2026-04-02 04:20:12'),
(95, 10, 11, 'Q1', '72.00', '2025-2026', 2, '2026-04-02 04:20:12', '2026-04-02 04:20:12'),
(96, 10, 11, 'Q2', '74.00', '2025-2026', 2, '2026-04-02 04:20:12', '2026-04-02 04:20:12'),
(97, 10, 11, 'Q3', '75.00', '2025-2026', 2, '2026-04-02 04:20:12', '2026-04-02 04:20:12'),
(98, 10, 11, 'Q4', '76.00', '2025-2026', 2, '2026-04-02 04:20:12', '2026-04-02 04:20:12'),
(99, 10, 12, 'Q1', '74.00', '2025-2026', 2, '2026-04-02 04:20:12', '2026-04-02 04:20:12'),
(100, 10, 12, 'Q2', '75.00', '2025-2026', 2, '2026-04-02 04:20:12', '2026-04-02 04:20:12'),
(101, 10, 12, 'Q3', '76.00', '2025-2026', 2, '2026-04-02 04:20:12', '2026-04-02 04:20:12'),
(102, 10, 12, 'Q4', '77.00', '2025-2026', 2, '2026-04-02 04:20:12', '2026-04-02 04:20:12'),
(103, 10, 13, 'Q1', '82.00', '2025-2026', 2, '2026-04-02 04:20:12', '2026-04-02 04:20:12'),
(104, 10, 13, 'Q2', '83.00', '2025-2026', 2, '2026-04-02 04:20:12', '2026-04-02 04:20:12'),
(105, 10, 13, 'Q3', '84.00', '2025-2026', 2, '2026-04-02 04:20:12', '2026-04-02 04:20:12'),
(106, 10, 13, 'Q4', '85.00', '2025-2026', 2, '2026-04-02 04:20:12', '2026-04-02 04:20:12'),
(107, 10, 14, 'Q1', '85.00', '2025-2026', 2, '2026-04-02 04:20:12', '2026-04-02 04:20:12'),
(108, 10, 14, 'Q2', '86.00', '2025-2026', 2, '2026-04-02 04:20:12', '2026-04-02 04:20:12'),
(109, 10, 14, 'Q3', '87.00', '2025-2026', 2, '2026-04-02 04:20:12', '2026-04-02 04:20:12'),
(110, 10, 14, 'Q4', '88.00', '2025-2026', 2, '2026-04-02 04:20:12', '2026-04-02 04:20:12'),
(111, 10, 15, 'Q1', '90.00', '2025-2026', 2, '2026-04-02 04:20:12', '2026-04-02 04:20:12'),
(112, 10, 15, 'Q2', '91.00', '2025-2026', 2, '2026-04-02 04:20:12', '2026-04-02 04:20:12'),
(113, 10, 15, 'Q3', '92.00', '2025-2026', 2, '2026-04-02 04:20:12', '2026-04-02 04:20:12'),
(114, 10, 15, 'Q4', '93.00', '2025-2026', 2, '2026-04-02 04:20:12', '2026-04-02 04:20:12'),
(115, 10, 16, 'Q1', '93.00', '2025-2026', 2, '2026-04-02 04:20:12', '2026-04-02 04:20:12'),
(116, 10, 16, 'Q2', '94.00', '2025-2026', 2, '2026-04-02 04:20:12', '2026-04-02 04:20:12'),
(117, 10, 16, 'Q3', '95.00', '2025-2026', 2, '2026-04-02 04:20:12', '2026-04-02 04:20:12'),
(118, 10, 16, 'Q4', '96.00', '2025-2026', 2, '2026-04-02 04:20:12', '2026-04-02 04:20:12'),
(119, 11, 17, 'Q1', '92.00', '2025-2026', 2, '2026-04-02 04:20:12', '2026-04-02 04:20:12'),
(120, 11, 17, 'Q2', '93.00', '2025-2026', 2, '2026-04-02 04:20:12', '2026-04-02 04:20:12'),
(121, 11, 17, 'Q3', '94.00', '2025-2026', 2, '2026-04-02 04:20:12', '2026-04-02 04:20:12'),
(122, 11, 17, 'Q4', '95.00', '2025-2026', 2, '2026-04-02 04:20:12', '2026-04-02 04:20:12'),
(123, 11, 18, 'Q1', '91.00', '2025-2026', 2, '2026-04-02 04:20:12', '2026-04-02 04:20:12'),
(124, 11, 18, 'Q2', '92.00', '2025-2026', 2, '2026-04-02 04:20:12', '2026-04-02 04:20:12'),
(125, 11, 18, 'Q3', '93.00', '2025-2026', 2, '2026-04-02 04:20:12', '2026-04-02 04:20:12'),
(126, 11, 18, 'Q4', '94.00', '2025-2026', 2, '2026-04-02 04:20:12', '2026-04-02 04:20:12'),
(127, 11, 19, 'Q1', '75.00', '2025-2026', 2, '2026-04-02 04:20:12', '2026-04-02 04:20:12'),
(128, 11, 19, 'Q2', '76.00', '2025-2026', 2, '2026-04-02 04:20:12', '2026-04-02 04:20:12'),
(129, 11, 19, 'Q3', '77.00', '2025-2026', 2, '2026-04-02 04:20:12', '2026-04-02 04:20:12'),
(130, 11, 19, 'Q4', '78.00', '2025-2026', 2, '2026-04-02 04:20:12', '2026-04-02 04:20:12'),
(131, 11, 20, 'Q1', '76.00', '2025-2026', 2, '2026-04-02 04:20:12', '2026-04-02 04:20:12'),
(132, 11, 20, 'Q2', '77.00', '2025-2026', 2, '2026-04-02 04:20:12', '2026-04-02 04:20:12'),
(133, 11, 20, 'Q3', '78.00', '2025-2026', 2, '2026-04-02 04:20:12', '2026-04-02 04:20:12'),
(134, 11, 20, 'Q4', '79.00', '2025-2026', 2, '2026-04-02 04:20:12', '2026-04-02 04:20:12'),
(135, 11, 21, 'Q1', '93.00', '2025-2026', 2, '2026-04-02 04:20:12', '2026-04-02 04:20:12'),
(136, 11, 21, 'Q2', '94.00', '2025-2026', 2, '2026-04-02 04:20:12', '2026-04-02 04:20:12'),
(137, 11, 21, 'Q3', '95.00', '2025-2026', 2, '2026-04-02 04:20:12', '2026-04-02 04:20:12'),
(138, 11, 21, 'Q4', '96.00', '2025-2026', 2, '2026-04-02 04:20:12', '2026-04-02 04:20:12'),
(139, 11, 22, 'Q1', '90.00', '2025-2026', 2, '2026-04-02 04:20:12', '2026-04-02 04:20:12'),
(140, 11, 22, 'Q2', '91.00', '2025-2026', 2, '2026-04-02 04:20:12', '2026-04-02 04:20:12'),
(141, 11, 22, 'Q3', '92.00', '2025-2026', 2, '2026-04-02 04:20:12', '2026-04-02 04:20:12'),
(142, 11, 22, 'Q4', '93.00', '2025-2026', 2, '2026-04-02 04:20:12', '2026-04-02 04:20:12'),
(143, 11, 23, 'Q1', '85.00', '2025-2026', 2, '2026-04-02 04:20:12', '2026-04-02 04:20:12'),
(144, 11, 23, 'Q2', '86.00', '2025-2026', 2, '2026-04-02 04:20:12', '2026-04-02 04:20:12'),
(145, 11, 23, 'Q3', '87.00', '2025-2026', 2, '2026-04-02 04:20:12', '2026-04-02 04:20:12'),
(146, 11, 23, 'Q4', '88.00', '2025-2026', 2, '2026-04-02 04:20:12', '2026-04-02 04:20:12'),
(147, 11, 24, 'Q1', '80.00', '2025-2026', 2, '2026-04-02 04:20:12', '2026-04-02 04:20:12'),
(148, 11, 24, 'Q2', '81.00', '2025-2026', 2, '2026-04-02 04:20:12', '2026-04-02 04:20:12'),
(149, 11, 24, 'Q3', '82.00', '2025-2026', 2, '2026-04-02 04:20:12', '2026-04-02 04:20:12'),
(150, 11, 24, 'Q4', '83.00', '2025-2026', 2, '2026-04-02 04:20:12', '2026-04-02 04:20:12'),
(151, 12, 25, 'Q1', '85.00', '2025-2026', 2, '2026-04-02 04:20:12', '2026-04-02 04:20:12'),
(152, 12, 25, 'Q2', '86.00', '2025-2026', 2, '2026-04-02 04:20:12', '2026-04-02 04:20:12'),
(153, 12, 25, 'Q3', '87.00', '2025-2026', 2, '2026-04-02 04:20:12', '2026-04-02 04:20:12'),
(154, 12, 25, 'Q4', '88.00', '2025-2026', 2, '2026-04-02 04:20:12', '2026-04-02 04:20:12'),
(155, 12, 26, 'Q1', '84.00', '2025-2026', 2, '2026-04-02 04:20:12', '2026-04-02 04:20:12'),
(156, 12, 26, 'Q2', '85.00', '2025-2026', 2, '2026-04-02 04:20:12', '2026-04-02 04:20:12'),
(157, 12, 26, 'Q3', '86.00', '2025-2026', 2, '2026-04-02 04:20:12', '2026-04-02 04:20:12'),
(158, 12, 26, 'Q4', '87.00', '2025-2026', 2, '2026-04-02 04:20:12', '2026-04-02 04:20:12'),
(159, 12, 27, 'Q1', '83.00', '2025-2026', 2, '2026-04-02 04:20:12', '2026-04-02 04:20:12'),
(160, 12, 27, 'Q2', '84.00', '2025-2026', 2, '2026-04-02 04:20:12', '2026-04-02 04:20:12'),
(161, 12, 27, 'Q3', '85.00', '2025-2026', 2, '2026-04-02 04:20:12', '2026-04-02 04:20:12'),
(162, 12, 27, 'Q4', '86.00', '2025-2026', 2, '2026-04-02 04:20:12', '2026-04-02 04:20:12'),
(163, 12, 28, 'Q1', '84.00', '2025-2026', 2, '2026-04-02 04:20:12', '2026-04-02 04:20:12'),
(164, 12, 28, 'Q2', '85.00', '2025-2026', 2, '2026-04-02 04:20:12', '2026-04-02 04:20:12'),
(165, 12, 28, 'Q3', '86.00', '2025-2026', 2, '2026-04-02 04:20:12', '2026-04-02 04:20:12'),
(166, 12, 28, 'Q4', '87.00', '2025-2026', 2, '2026-04-02 04:20:12', '2026-04-02 04:20:12'),
(167, 12, 29, 'Q1', '85.00', '2025-2026', 2, '2026-04-02 04:20:12', '2026-04-02 04:20:12'),
(168, 12, 29, 'Q2', '86.00', '2025-2026', 2, '2026-04-02 04:20:12', '2026-04-02 04:20:12'),
(169, 12, 29, 'Q3', '87.00', '2025-2026', 2, '2026-04-02 04:20:12', '2026-04-02 04:20:12'),
(170, 12, 29, 'Q4', '88.00', '2025-2026', 2, '2026-04-02 04:20:12', '2026-04-02 04:20:12'),
(171, 12, 30, 'Q1', '86.00', '2025-2026', 2, '2026-04-02 04:20:12', '2026-04-02 04:20:12'),
(172, 12, 30, 'Q2', '87.00', '2025-2026', 2, '2026-04-02 04:20:12', '2026-04-02 04:20:12'),
(173, 12, 30, 'Q3', '88.00', '2025-2026', 2, '2026-04-02 04:20:12', '2026-04-02 04:20:12'),
(174, 12, 30, 'Q4', '89.00', '2025-2026', 2, '2026-04-02 04:20:12', '2026-04-02 04:20:12'),
(175, 12, 31, 'Q1', '83.00', '2025-2026', 2, '2026-04-02 04:20:12', '2026-04-02 04:20:12'),
(176, 12, 31, 'Q2', '84.00', '2025-2026', 2, '2026-04-02 04:20:12', '2026-04-02 04:20:12'),
(177, 12, 31, 'Q3', '85.00', '2025-2026', 2, '2026-04-02 04:20:12', '2026-04-02 04:20:12'),
(178, 12, 31, 'Q4', '86.00', '2025-2026', 2, '2026-04-02 04:20:12', '2026-04-02 04:20:12'),
(179, 12, 32, 'Q1', '84.00', '2025-2026', 2, '2026-04-02 04:20:12', '2026-04-02 04:20:12'),
(180, 12, 32, 'Q2', '85.00', '2025-2026', 2, '2026-04-02 04:20:12', '2026-04-02 04:20:12'),
(181, 12, 32, 'Q3', '86.00', '2025-2026', 2, '2026-04-02 04:20:12', '2026-04-02 04:20:12'),
(182, 12, 32, 'Q4', '87.00', '2025-2026', 2, '2026-04-02 04:20:12', '2026-04-02 04:20:12'),
(183, 13, 25, 'Q1', '80.00', '2025-2026', 2, '2026-04-02 04:20:12', '2026-04-02 04:20:12'),
(184, 13, 25, 'Q2', '81.00', '2025-2026', 2, '2026-04-02 04:20:12', '2026-04-02 04:20:12'),
(185, 13, 25, 'Q3', '82.00', '2025-2026', 2, '2026-04-02 04:20:12', '2026-04-02 04:20:12'),
(186, 13, 25, 'Q4', '83.00', '2025-2026', 2, '2026-04-02 04:20:12', '2026-04-02 04:20:12'),
(187, 13, 26, 'Q1', '82.00', '2025-2026', 2, '2026-04-02 04:20:12', '2026-04-02 04:20:12'),
(188, 13, 26, 'Q2', '83.00', '2025-2026', 2, '2026-04-02 04:20:12', '2026-04-02 04:20:12'),
(189, 13, 26, 'Q3', '84.00', '2025-2026', 2, '2026-04-02 04:20:12', '2026-04-02 04:20:12'),
(190, 13, 26, 'Q4', '85.00', '2025-2026', 2, '2026-04-02 04:20:12', '2026-04-02 04:20:12'),
(191, 13, 27, 'Q1', '78.00', '2025-2026', 2, '2026-04-02 04:20:12', '2026-04-02 04:20:12'),
(192, 13, 27, 'Q2', '79.00', '2025-2026', 2, '2026-04-02 04:20:12', '2026-04-02 04:20:12'),
(193, 13, 27, 'Q3', '80.00', '2025-2026', 2, '2026-04-02 04:20:12', '2026-04-02 04:20:12'),
(194, 13, 27, 'Q4', '81.00', '2025-2026', 2, '2026-04-02 04:20:12', '2026-04-02 04:20:12'),
(195, 13, 28, 'Q1', '76.00', '2025-2026', 2, '2026-04-02 04:20:12', '2026-04-02 04:20:12'),
(196, 13, 28, 'Q2', '77.00', '2025-2026', 2, '2026-04-02 04:20:12', '2026-04-02 04:20:12'),
(197, 13, 28, 'Q3', '78.00', '2025-2026', 2, '2026-04-02 04:20:12', '2026-04-02 04:20:12'),
(198, 13, 28, 'Q4', '79.00', '2025-2026', 2, '2026-04-02 04:20:12', '2026-04-02 04:20:12'),
(199, 13, 29, 'Q1', '89.00', '2025-2026', 2, '2026-04-02 04:20:12', '2026-04-02 04:20:12'),
(200, 13, 29, 'Q2', '90.00', '2025-2026', 2, '2026-04-02 04:20:12', '2026-04-02 04:20:12'),
(201, 13, 29, 'Q3', '91.00', '2025-2026', 2, '2026-04-02 04:20:12', '2026-04-02 04:20:12'),
(202, 13, 29, 'Q4', '92.00', '2025-2026', 2, '2026-04-02 04:20:12', '2026-04-02 04:20:12'),
(203, 13, 30, 'Q1', '87.00', '2025-2026', 2, '2026-04-02 04:20:12', '2026-04-02 04:20:12'),
(204, 13, 30, 'Q2', '88.00', '2025-2026', 2, '2026-04-02 04:20:12', '2026-04-02 04:20:12'),
(205, 13, 30, 'Q3', '89.00', '2025-2026', 2, '2026-04-02 04:20:12', '2026-04-02 04:20:12'),
(206, 13, 30, 'Q4', '90.00', '2025-2026', 2, '2026-04-02 04:20:12', '2026-04-02 04:20:12'),
(207, 13, 31, 'Q1', '82.00', '2025-2026', 2, '2026-04-02 04:20:12', '2026-04-02 04:20:12'),
(208, 13, 31, 'Q2', '83.00', '2025-2026', 2, '2026-04-02 04:20:12', '2026-04-02 04:20:12'),
(209, 13, 31, 'Q3', '84.00', '2025-2026', 2, '2026-04-02 04:20:12', '2026-04-02 04:20:12'),
(210, 13, 31, 'Q4', '85.00', '2025-2026', 2, '2026-04-02 04:20:12', '2026-04-02 04:20:12'),
(211, 13, 32, 'Q1', '92.00', '2025-2026', 2, '2026-04-02 04:20:12', '2026-04-02 04:20:12'),
(212, 13, 32, 'Q2', '93.00', '2025-2026', 2, '2026-04-02 04:20:12', '2026-04-02 04:20:12'),
(213, 13, 32, 'Q3', '94.00', '2025-2026', 2, '2026-04-02 04:20:12', '2026-04-02 04:20:12'),
(214, 13, 32, 'Q4', '95.00', '2025-2026', 2, '2026-04-02 04:20:12', '2026-04-02 04:20:12');

-- --------------------------------------------------------

--
-- Table structure for table `grade_subject_remarks`
--

DROP TABLE IF EXISTS `grade_subject_remarks`;
CREATE TABLE IF NOT EXISTS `grade_subject_remarks` (
  `id` int NOT NULL AUTO_INCREMENT,
  `student_id` int NOT NULL,
  `subject_id` int NOT NULL,
  `school_year` varchar(20) NOT NULL,
  `learning_gaps` text COMMENT 'What are the learning gaps?',
  `reinforcement_reason` text COMMENT 'Why does the status need reinforcement?',
  `updated_by` int DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_grade_subject_remark` (`student_id`,`subject_id`,`school_year`),
  KEY `subject_id` (`subject_id`),
  KEY `updated_by` (`updated_by`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `import_logs`
--

DROP TABLE IF EXISTS `import_logs`;
CREATE TABLE IF NOT EXISTS `import_logs` (
  `id` int NOT NULL AUTO_INCREMENT,
  `file_name` varchar(255) NOT NULL,
  `total_rows` int DEFAULT '0',
  `inserted` int DEFAULT '0',
  `skipped` int DEFAULT '0',
  `errors` text,
  `imported_by` int DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `imported_by` (`imported_by`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `non_academic_indicators`
--

DROP TABLE IF EXISTS `non_academic_indicators`;
CREATE TABLE IF NOT EXISTS `non_academic_indicators` (
  `id` int NOT NULL AUTO_INCREMENT,
  `student_id` int NOT NULL,
  `skills` text COMMENT 'Skills assessment (free text)',
  `hobbies` text COMMENT 'Student interests / hobbies',
  `career_preference` varchar(255) DEFAULT NULL COMMENT 'Stated career or college preference',
  `first_choice_strand_course` varchar(255) DEFAULT NULL COMMENT 'Student 1st choice strand or course (guidance: mismatch vs Top 3)',
  `technical_skill_level` enum('beginner','developing','proficient','advanced') NOT NULL DEFAULT 'developing',
  `entrance_exam_score` decimal(5,2) DEFAULT NULL,
  `entrance_exam_date` date DEFAULT NULL,
  `updated_by` int DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `student_id` (`student_id`),
  KEY `updated_by` (`updated_by`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `non_academic_indicators`
--

INSERT INTO `non_academic_indicators` (`id`, `student_id`, `skills`, `hobbies`, `career_preference`, `first_choice_strand_course`, `technical_skill_level`, `entrance_exam_score`, `entrance_exam_date`, `updated_by`, `created_at`, `updated_at`) VALUES
(1, 9, 'coding, robotics, math problem solving', 'science fair, programming, gadgets', 'Engineering or IT in college', 'STEM', 'proficient', '88.50', NULL, NULL, '2026-04-02 04:20:12', '2026-04-02 04:20:12'),
(2, 10, 'cooking, sewing, handicrafts', 'baking, crafts, cooking experiments, gardening', 'Hospitality or culinary arts', 'TVL - Cookery', 'developing', '76.00', NULL, NULL, '2026-04-02 04:20:12', '2026-04-02 04:20:12'),
(3, 11, 'creative writing, public speaking, debating', 'reading, journalism, theater, social media', 'Law, communication, or education', 'HUMSS', 'proficient', '85.00', NULL, NULL, '2026-04-02 04:20:12', '2026-04-02 04:20:12'),
(4, 12, 'drawing, music, research, organizing', 'painting, playing guitar, reading, volunteering', 'Flexible / undecided college program', NULL, 'developing', '80.00', NULL, NULL, '2026-04-02 04:20:12', '2026-04-02 04:20:12'),
(5, 13, 'selling, negotiating, organizing events', 'business, trading, basketball, cooking', 'Business or entrepreneurship', 'ABM', 'proficient', '79.50', NULL, NULL, '2026-04-02 04:20:12', '2026-04-02 04:20:12');

-- --------------------------------------------------------

--
-- Table structure for table `notifications`
--

DROP TABLE IF EXISTS `notifications`;
CREATE TABLE IF NOT EXISTS `notifications` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `title` varchar(200) NOT NULL,
  `message` text NOT NULL,
  `type` varchar(50) DEFAULT 'info',
  `is_read` tinyint(1) DEFAULT '0',
  `related_id` int DEFAULT NULL,
  `related_type` varchar(50) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_notifications_user` (`user_id`,`is_read`),
  KEY `idx_notifications_created` (`created_at`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `notifications`
--

INSERT INTO `notifications` (`id`, `user_id`, `title`, `message`, `type`, `is_read`, `related_id`, `related_type`, `created_at`) VALUES
(1, 2, 'Support Ticket Resolved', 'Your support ticket #1 has been marked as resolved. Admin reply: No additional comments.', 'success', 0, 1, 'support_ticket', '2026-04-02 04:29:33'),
(2, 2, 'Support Ticket Resolved', 'Your support ticket #1 has been marked as resolved. Admin reply: No additional comments.', 'success', 0, 1, 'support_ticket', '2026-04-02 04:31:24');

-- --------------------------------------------------------

--
-- Table structure for table `sections`
--

DROP TABLE IF EXISTS `sections`;
CREATE TABLE IF NOT EXISTS `sections` (
  `id` int NOT NULL AUTO_INCREMENT,
  `section_name` varchar(50) NOT NULL,
  `grade_level` int NOT NULL,
  `strand` varchar(50) DEFAULT NULL,
  `adviser_id` int DEFAULT NULL,
  `school_year` varchar(20) NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_section` (`section_name`,`grade_level`,`school_year`),
  KEY `adviser_id` (`adviser_id`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `sections`
--

INSERT INTO `sections` (`id`, `section_name`, `grade_level`, `strand`, `adviser_id`, `school_year`, `created_at`) VALUES
(1, 'Section A', 11, 'STEM', 2, '2025-2026', '2026-04-02 04:20:11'),
(2, 'Section B', 11, 'ABM', 3, '2025-2026', '2026-04-02 04:20:11'),
(3, 'Section C', 11, 'HUMSS', 4, '2025-2026', '2026-04-02 04:20:11'),
(4, 'Section D', 11, 'GAS', 2, '2025-2026', '2026-04-02 04:20:11'),
(5, 'Section E', 11, 'TVL-ICT', 3, '2025-2026', '2026-04-02 04:20:11'),
(6, 'Section F', 12, 'STEM', 2, '2025-2026', '2026-04-02 04:20:11'),
(7, 'Section G', 12, 'ABM', 4, '2025-2026', '2026-04-02 04:20:11'),
(8, 'Section H', 12, 'HUMSS', 3, '2025-2026', '2026-04-02 04:20:11'),
(9, 'Section I', 12, 'GAS', 2, '2025-2026', '2026-04-02 04:20:11'),
(10, 'Section J', 12, 'TVL-ICT', 4, '2025-2026', '2026-04-02 04:20:11'),
(11, 'Rizal', 7, NULL, 2, '2025-2026', '2026-04-02 04:20:11'),
(12, 'Bonifacio', 8, NULL, 3, '2025-2026', '2026-04-02 04:20:11'),
(13, 'Mabini', 9, NULL, 4, '2025-2026', '2026-04-02 04:20:11'),
(14, 'Aguinaldo', 10, NULL, 2, '2025-2026', '2026-04-02 04:20:11');

-- --------------------------------------------------------

--
-- Table structure for table `strands`
--

DROP TABLE IF EXISTS `strands`;
CREATE TABLE IF NOT EXISTS `strands` (
  `id` int NOT NULL AUTO_INCREMENT,
  `strand_code` varchar(20) NOT NULL,
  `strand_name` varchar(100) NOT NULL,
  `description` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `strand_code` (`strand_code`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `strands`
--

INSERT INTO `strands` (`id`, `strand_code`, `strand_name`, `description`, `created_at`) VALUES
(1, 'STEM', 'Science, Technology, Engineering and Mathematics', 'Focus on advanced math, science, and technology subjects', '2026-04-02 04:20:11'),
(2, 'ABM', 'Accountancy, Business and Management', 'Focus on business, finance, and management subjects', '2026-04-02 04:20:11'),
(3, 'HUMSS', 'Humanities and Social Sciences', 'Focus on liberal arts, social sciences, and communication', '2026-04-02 04:20:11'),
(4, 'GAS', 'General Academic Strand', 'Broad academic foundation across disciplines', '2026-04-02 04:20:11'),
(5, 'TVL-ICT', 'Technical-Vocational-Livelihood: ICT', 'Focus on Information and Communications Technology', '2026-04-02 04:20:11'),
(6, 'TVL-HE', 'Technical-Vocational-Livelihood: Home Economics', 'Focus on Home Economics and hospitality', '2026-04-02 04:20:11'),
(7, 'TVL-IA', 'Technical-Vocational-Livelihood: Industrial Arts', 'Focus on Industrial Arts and technical skills', '2026-04-02 04:20:11'),
(8, 'SPORTS', 'Sports Track', 'Focus on sports science, fitness, and athletics', '2026-04-02 04:20:11'),
(9, 'ARTS', 'Arts and Design Track', 'Focus on creative arts, media, and design', '2026-04-02 04:20:11');

-- --------------------------------------------------------

--
-- Table structure for table `strand_course_mapping`
--

DROP TABLE IF EXISTS `strand_course_mapping`;
CREATE TABLE IF NOT EXISTS `strand_course_mapping` (
  `id` int NOT NULL AUTO_INCREMENT,
  `strand_id` int NOT NULL,
  `course_name` varchar(150) NOT NULL,
  `career_pathway` varchar(200) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_strand_course` (`strand_id`,`course_name`)
) ENGINE=InnoDB AUTO_INCREMENT=28 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `strand_course_mapping`
--

INSERT INTO `strand_course_mapping` (`id`, `strand_id`, `course_name`, `career_pathway`, `created_at`) VALUES
(1, 1, 'BS Computer Science', 'Software Development / IT Industry', '2026-04-02 04:20:11'),
(2, 1, 'BS Information Technology', 'Systems Administration / Web Development', '2026-04-02 04:20:11'),
(3, 1, 'BS Civil Engineering', 'Construction / Infrastructure', '2026-04-02 04:20:11'),
(4, 1, 'BS Mechanical Engineering', 'Manufacturing / Automotive', '2026-04-02 04:20:11'),
(5, 1, 'BS Electrical Engineering', 'Power / Electronics Industry', '2026-04-02 04:20:11'),
(6, 1, 'BS Nursing', 'Healthcare / Medical', '2026-04-02 04:20:11'),
(7, 1, 'BS Mathematics', 'Education / Research / Data Science', '2026-04-02 04:20:11'),
(8, 2, 'BS Accountancy', 'Auditing / Finance', '2026-04-02 04:20:11'),
(9, 2, 'BS Business Administration', 'Corporate Management / Entrepreneurship', '2026-04-02 04:20:11'),
(10, 2, 'BS Marketing Management', 'Advertising / Sales / Digital Marketing', '2026-04-02 04:20:11'),
(11, 2, 'BS Customs Administration', 'Import-Export / Logistics', '2026-04-02 04:20:11'),
(12, 2, 'BS Hospitality Management', 'Hotel / Restaurant Industry', '2026-04-02 04:20:11'),
(13, 3, 'BA Communication', 'Media / Journalism / Public Relations', '2026-04-02 04:20:11'),
(14, 3, 'BA Political Science', 'Law / Government / Diplomacy', '2026-04-02 04:20:11'),
(15, 3, 'BA Psychology', 'Counseling / Human Resources', '2026-04-02 04:20:11'),
(16, 3, 'BA Sociology', 'Social Work / Community Development', '2026-04-02 04:20:11'),
(17, 3, 'AB English', 'Education / Writing / Translation', '2026-04-02 04:20:11'),
(18, 4, 'Any Bachelor Degree', 'Flexible - Multiple Career Options', '2026-04-02 04:20:11'),
(19, 5, 'BS Information Technology', 'Web Development / Systems Admin', '2026-04-02 04:20:11'),
(20, 5, 'BS Computer Science', 'Software Engineering / Programming', '2026-04-02 04:20:11'),
(21, 6, 'BS Hotel & Restaurant Management', 'Hospitality Industry', '2026-04-02 04:20:11'),
(22, 6, 'BS Tourism Management', 'Travel / Tourism Industry', '2026-04-02 04:20:11'),
(23, 7, 'BS Industrial Technology', 'Manufacturing / Technical Work', '2026-04-02 04:20:11'),
(24, 8, 'BS Physical Education', 'Sports Management / Coaching', '2026-04-02 04:20:11'),
(25, 8, 'BS Sports Science', 'Athletic Training / Fitness', '2026-04-02 04:20:11'),
(26, 9, 'BFA Fine Arts', 'Visual Arts / Gallery Management', '2026-04-02 04:20:11'),
(27, 9, 'BS Multimedia Arts', 'Digital Media / Animation / Graphic Design', '2026-04-02 04:20:11');

-- --------------------------------------------------------

--
-- Table structure for table `students`
--

DROP TABLE IF EXISTS `students`;
CREATE TABLE IF NOT EXISTS `students` (
  `id` int NOT NULL AUTO_INCREMENT,
  `lrn` varchar(20) NOT NULL,
  `first_name` varchar(50) NOT NULL,
  `last_name` varchar(50) NOT NULL,
  `middle_name` varchar(50) DEFAULT NULL,
  `name_suffix` varchar(10) DEFAULT NULL,
  `gender` enum('Male','Female') NOT NULL,
  `birthdate` date DEFAULT NULL,
  `section_id` int DEFAULT NULL,
  `strand_id` int DEFAULT NULL,
  `school_year` varchar(20) NOT NULL,
  `status` enum('active','inactive','graduated') NOT NULL DEFAULT 'active',
  `created_by` int DEFAULT NULL COMMENT 'User ID who created this student record',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `lrn` (`lrn`),
  KEY `section_id` (`section_id`),
  KEY `strand_id` (`strand_id`),
  KEY `created_by` (`created_by`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `students`
--

INSERT INTO `students` (`id`, `lrn`, `first_name`, `last_name`, `middle_name`, `name_suffix`, `gender`, `birthdate`, `section_id`, `strand_id`, `school_year`, `status`, `created_at`, `updated_at`) VALUES
(1, '100100100001', 'Juan', 'Dela Cruz', 'Santos', NULL, 'Male', '2008-03-15', 1, 1, '2025-2026', 'active', '2026-04-02 04:20:11', '2026-04-02 04:20:11'),
(2, '100100100002', 'Maria', 'Garcia', 'Reyes', NULL, 'Female', '2008-06-21', 1, 1, '2025-2026', 'active', '2026-04-02 04:20:11', '2026-04-02 04:20:11'),
(3, '100100100003', 'Pedro', 'Ramos', 'Lim', NULL, 'Male', '2008-01-10', 1, 1, '2025-2026', 'active', '2026-04-02 04:20:11', '2026-04-02 04:20:11'),
(4, '100100100004', 'Ana', 'Lopez', 'Cruz', NULL, 'Female', '2008-09-05', 2, 2, '2025-2026', 'active', '2026-04-02 04:20:11', '2026-04-02 04:20:11'),
(5, '100100100005', 'Carlos', 'Mendoza', 'Bautista', NULL, 'Male', '2007-12-18', 2, 2, '2025-2026', 'active', '2026-04-02 04:20:11', '2026-04-02 04:20:11'),
(6, '100100100006', 'Sofia', 'Villanueva', 'Torres', NULL, 'Female', '2008-04-22', 3, 3, '2025-2026', 'active', '2026-04-02 04:20:11', '2026-04-02 04:20:11'),
(7, '100100100007', 'Miguel', 'Aquino', 'Santos', NULL, 'Male', '2007-08-30', 3, 3, '2025-2026', 'active', '2026-04-02 04:20:11', '2026-04-02 04:20:11'),
(8, '100100100008', 'Isabella', 'Fernandez', 'Reyes', NULL, 'Female', '2008-02-14', 6, 1, '2025-2026', 'active', '2026-04-02 04:20:11', '2026-04-02 04:20:11'),
(9, '200200200001', 'Liam', 'Reyes', 'Cruz', NULL, 'Male', '2012-04-10', 11, NULL, '2025-2026', 'active', '2026-04-02 04:20:11', '2026-04-02 04:20:11'),
(10, '200200200002', 'Chloe', 'Santos', 'Lim', NULL, 'Female', '2011-07-22', 12, NULL, '2025-2026', 'active', '2026-04-02 04:20:11', '2026-04-02 04:20:11'),
(11, '200200200003', 'Marco', 'Villanueva', 'Bautista', NULL, 'Male', '2010-09-15', 13, NULL, '2025-2026', 'active', '2026-04-02 04:20:11', '2026-04-02 04:20:11'),
(12, '200200200004', 'Sophia', 'Dela Torre', 'Ramos', NULL, 'Female', '2009-11-03', 14, NULL, '2025-2026', 'active', '2026-04-02 04:20:11', '2026-04-02 04:20:11'),
(13, '200200200005', 'Nathan', 'Buenaventura', 'Garcia', NULL, 'Male', '2009-03-18', 14, NULL, '2025-2026', 'active', '2026-04-02 04:20:11', '2026-04-02 04:20:11');

-- --------------------------------------------------------

--
-- Table structure for table `subjects`
--

DROP TABLE IF EXISTS `subjects`;
CREATE TABLE IF NOT EXISTS `subjects` (
  `id` int NOT NULL AUTO_INCREMENT,
  `subject_code` varchar(20) NOT NULL,
  `subject_name` varchar(100) NOT NULL,
  `grade_level` int DEFAULT NULL COMMENT 'NULL = all grade levels; 7-10 = JHS; 11-12 = SHS',
  `strand_id` int DEFAULT NULL,
  `subject_type` enum('core','specialized','applied','immersion','jhs_core','jhs_mapeh','jhs_tle','jhs_esp') NOT NULL DEFAULT 'core',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_subject_code` (`subject_code`),
  KEY `strand_id` (`strand_id`)
) ENGINE=InnoDB AUTO_INCREMENT=94 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `subjects`
--

INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `grade_level`, `strand_id`, `subject_type`, `created_at`) VALUES
(1, 'G7-ENG', 'English 7', 7, NULL, 'jhs_core', '2026-04-01 19:28:59'),
(2, 'G7-FIL', 'Filipino 7', 7, NULL, 'jhs_core', '2026-04-01 19:28:59'),
(3, 'G7-MAT', 'Mathematics 7', 7, NULL, 'jhs_core', '2026-04-01 19:28:59'),
(4, 'G7-SCI', 'Science 7', 7, NULL, 'jhs_core', '2026-04-01 19:28:59'),
(5, 'G7-AP', 'Araling Panlipunan 7', 7, NULL, 'jhs_core', '2026-04-01 19:28:59'),
(6, 'G7-ESP', 'Edukasyon sa Pagpapakatao 7', 7, NULL, 'jhs_esp', '2026-04-01 19:28:59'),
(7, 'G7-MAPEH', 'MAPEH 7', 7, NULL, 'jhs_mapeh', '2026-04-01 19:28:59'),
(8, 'G7-TLE', 'Technology and Livelihood Education 7', 7, NULL, 'jhs_tle', '2026-04-01 19:28:59'),
(9, 'G8-ENG', 'English 8', 8, NULL, 'jhs_core', '2026-04-01 19:28:59'),
(10, 'G8-FIL', 'Filipino 8', 8, NULL, 'jhs_core', '2026-04-01 19:28:59'),
(11, 'G8-MAT', 'Mathematics 8', 8, NULL, 'jhs_core', '2026-04-01 19:28:59'),
(12, 'G8-SCI', 'Science 8', 8, NULL, 'jhs_core', '2026-04-01 19:28:59'),
(13, 'G8-AP', 'Araling Panlipunan 8', 8, NULL, 'jhs_core', '2026-04-01 19:28:59'),
(14, 'G8-ESP', 'Edukasyon sa Pagpapakatao 8', 8, NULL, 'jhs_esp', '2026-04-01 19:28:59'),
(15, 'G8-MAPEH', 'MAPEH 8', 8, NULL, 'jhs_mapeh', '2026-04-01 19:28:59'),
(16, 'G8-TLE', 'Technology and Livelihood Education 8', 8, NULL, 'jhs_tle', '2026-04-01 19:28:59'),
(17, 'G9-ENG', 'English 9', 9, NULL, 'jhs_core', '2026-04-01 19:28:59'),
(18, 'G9-FIL', 'Filipino 9', 9, NULL, 'jhs_core', '2026-04-01 19:28:59'),
(19, 'G9-MAT', 'Mathematics 9', 9, NULL, 'jhs_core', '2026-04-01 19:28:59'),
(20, 'G9-SCI', 'Science 9', 9, NULL, 'jhs_core', '2026-04-01 19:28:59'),
(21, 'G9-AP', 'Araling Panlipunan 9', 9, NULL, 'jhs_core', '2026-04-01 19:28:59'),
(22, 'G9-ESP', 'Edukasyon sa Pagpapakatao 9', 9, NULL, 'jhs_esp', '2026-04-01 19:28:59'),
(23, 'G9-MAPEH', 'MAPEH 9', 9, NULL, 'jhs_mapeh', '2026-04-01 19:28:59'),
(24, 'G9-TLE', 'Technology and Livelihood Education 9', 9, NULL, 'jhs_tle', '2026-04-01 19:28:59'),
(25, 'G10-ENG', 'English 10', 10, NULL, 'jhs_core', '2026-04-01 19:28:59'),
(26, 'G10-FIL', 'Filipino 10', 10, NULL, 'jhs_core', '2026-04-01 19:28:59'),
(27, 'G10-MAT', 'Mathematics 10', 10, NULL, 'jhs_core', '2026-04-01 19:28:59'),
(28, 'G10-SCI', 'Science 10', 10, NULL, 'jhs_core', '2026-04-01 19:28:59'),
(29, 'G10-AP', 'Araling Panlipunan 10', 10, NULL, 'jhs_core', '2026-04-01 19:28:59'),
(30, 'G10-ESP', 'Edukasyon sa Pagpapakatao 10', 10, NULL, 'jhs_esp', '2026-04-01 19:28:59'),
(31, 'G10-MAPEH', 'MAPEH 10', 10, NULL, 'jhs_mapeh', '2026-04-01 19:28:59'),
(32, 'G10-TLE', 'Technology and Livelihood Education 10', 10, NULL, 'jhs_tle', '2026-04-01 19:28:59'),
(33, 'CORE-ORALCOM', 'Oral Communication', 11, NULL, 'core', '2026-04-01 19:28:59'),
(34, 'CORE-RW', 'Reading and Writing', 11, NULL, 'core', '2026-04-01 19:28:59'),
(35, 'CORE-KOMFIL', 'Komunikasyon at Pananaliksik sa Wika at Kulturang Pilipino', 11, NULL, 'core', '2026-04-01 19:28:59'),
(36, 'CORE-GENMATH', 'General Mathematics', 11, NULL, 'core', '2026-04-01 19:28:59'),
(37, 'CORE-STATPROB', 'Statistics and Probability', 11, NULL, 'core', '2026-04-01 19:28:59'),
(38, 'CORE-ELS', 'Earth and Life Science', 11, NULL, 'core', '2026-04-01 19:28:59'),
(39, 'CORE-PHYSCI', 'Physical Science', 11, NULL, 'core', '2026-04-01 19:28:59'),
(40, 'CORE-PERDEV', 'Personal Development', 11, NULL, 'core', '2026-04-01 19:28:59'),
(41, 'CORE-PHILO', 'Introduction to the Philosophy of the Human Person', 11, NULL, 'core', '2026-04-01 19:28:59'),
(42, 'CORE-PEH1', 'Physical Education and Health 1', 11, NULL, 'core', '2026-04-01 19:28:59'),
(43, 'CORE-21LIT', '21st Century Literature from the Philippines and the World', 11, NULL, 'core', '2026-04-01 19:28:59'),
(44, 'CORE-MIL', 'Media and Information Literacy', 12, NULL, 'core', '2026-04-01 19:28:59'),
(45, 'CORE-CPAR', 'Contemporary Philippine Arts from the Regions', 12, NULL, 'core', '2026-04-01 19:28:59'),
(46, 'CORE-UCSP', 'Understanding Culture, Society and Politics', 12, NULL, 'core', '2026-04-01 19:28:59'),
(47, 'CORE-PAGBASA', 'Pagbasa at Pagsusuri ng Iba\'t Ibang Teksto Tungo sa Pananaliksik', 12, NULL, 'core', '2026-04-01 19:28:59'),
(48, 'CORE-PEH2', 'Physical Education and Health 2', 12, NULL, 'core', '2026-04-01 19:28:59'),
(49, 'APP-ETECH', 'Empowerment Technologies', 11, NULL, 'applied', '2026-04-01 19:28:59'),
(50, 'APP-EAPP', 'English for Academic and Professional Purposes', 11, NULL, 'applied', '2026-04-01 19:28:59'),
(51, 'APP-PR1', 'Practical Research 1', 12, NULL, 'applied', '2026-04-01 19:28:59'),
(52, 'APP-PR2', 'Practical Research 2', 12, NULL, 'applied', '2026-04-01 19:28:59'),
(53, 'APP-FIL', 'Filipino sa Piling Larangan', 12, NULL, 'applied', '2026-04-01 19:28:59'),
(54, 'APP-ENTREP', 'Entrepreneurship', 12, NULL, 'applied', '2026-04-01 19:28:59'),
(55, 'STEM-PRECAL', 'Pre-Calculus', 11, 1, 'specialized', '2026-04-01 19:28:59'),
(56, 'STEM-BIO1', 'General Biology 1', 11, 1, 'specialized', '2026-04-01 19:28:59'),
(57, 'STEM-CHEM1', 'General Chemistry 1', 11, 1, 'specialized', '2026-04-01 19:28:59'),
(58, 'STEM-PHYS1', 'General Physics 1', 11, 1, 'specialized', '2026-04-01 19:28:59'),
(59, 'STEM-BASCAL', 'Basic Calculus', 12, 1, 'specialized', '2026-04-01 19:28:59'),
(60, 'STEM-BIO2', 'General Biology 2', 12, 1, 'specialized', '2026-04-01 19:28:59'),
(61, 'STEM-CHEM2', 'General Chemistry 2', 12, 1, 'specialized', '2026-04-01 19:28:59'),
(62, 'STEM-PHYS2', 'General Physics 2', 12, 1, 'specialized', '2026-04-01 19:28:59'),
(63, 'STEM-CAPSTONE', 'Research/Capstone Project', 12, 1, 'specialized', '2026-04-01 19:28:59'),
(64, 'ABM-FABM1', 'Fundamentals of ABM 1', 11, 2, 'specialized', '2026-04-01 19:28:59'),
(65, 'ABM-BMATH', 'Business Mathematics', 11, 2, 'specialized', '2026-04-01 19:28:59'),
(66, 'ABM-ORGMGMT', 'Organization and Management', 11, 2, 'specialized', '2026-04-01 19:28:59'),
(67, 'ABM-FABM2', 'Fundamentals of ABM 2', 12, 2, 'specialized', '2026-04-01 19:28:59'),
(68, 'ABM-BFIN', 'Business Finance', 12, 2, 'specialized', '2026-04-01 19:28:59'),
(69, 'ABM-MKTG', 'Principles of Marketing', 12, 2, 'specialized', '2026-04-01 19:28:59'),
(70, 'ABM-AE', 'Applied Economics', 12, 2, 'specialized', '2026-04-01 19:28:59'),
(71, 'ABM-BESR', 'Business Ethics and Social Responsibility', 12, 2, 'specialized', '2026-04-01 19:28:59'),
(72, 'HUM-DISS', 'Disciplines and Ideas in the Social Sciences', 11, 3, 'specialized', '2026-04-01 19:28:59'),
(73, 'HUM-PPG', 'Philippine Politics and Governance', 11, 3, 'specialized', '2026-04-01 19:28:59'),
(74, 'HUM-IWRBS', 'Introduction to World Religions and Belief Systems', 11, 3, 'specialized', '2026-04-01 19:28:59'),
(75, 'HUM-DIASS', 'Disciplines and Ideas in Applied Social Sciences', 12, 3, 'specialized', '2026-04-01 19:28:59'),
(76, 'HUM-CNF', 'Creative Nonfiction', 12, 3, 'specialized', '2026-04-01 19:28:59'),
(77, 'HUM-CW', 'Creative Writing / Malikhaing Pagsulat', 12, 3, 'specialized', '2026-04-01 19:28:59'),
(78, 'HUM-TNCT', 'Trends, Networks and Critical Thinking', 12, 3, 'specialized', '2026-04-01 19:28:59'),
(79, 'HUM-CESC', 'Community Engagement, Solidarity and Citizenship', 12, 3, 'specialized', '2026-04-01 19:28:59'),
(80, 'ICT-CP1', 'Computer Programming 1', 11, 5, 'specialized', '2026-04-01 19:28:59'),
(81, 'ICT-CSS', 'Computer Systems Servicing NC II', 11, 5, 'specialized', '2026-04-01 19:28:59'),
(82, 'ICT-CP2', 'Computer Programming 2', 12, 5, 'specialized', '2026-04-01 19:28:59'),
(83, 'ICT-WEBDEV', 'Web Development', 12, 5, 'specialized', '2026-04-01 19:28:59'),
(84, 'ICT-JAVA', 'Programming (Java / .Net)', 12, 5, 'specialized', '2026-04-01 19:28:59'),
(85, 'HE-COOKERY1', 'Basic Cookery NC II', 11, 6, 'specialized', '2026-04-01 19:28:59'),
(86, 'HE-BPP', 'Bread and Pastry Production NC II', 11, 6, 'specialized', '2026-04-01 19:28:59'),
(87, 'HE-COOKERY2', 'Advanced Cookery NC II', 12, 6, 'specialized', '2026-04-01 19:28:59'),
(88, 'HE-FBS', 'Food and Beverage Services NC II', 12, 6, 'specialized', '2026-04-01 19:28:59'),
(89, 'IA-AUTO1', 'Automotive Servicing NC I', 11, 7, 'specialized', '2026-04-01 19:28:59'),
(90, 'IA-PM', 'Preventive Maintenance', 11, 7, 'specialized', '2026-04-01 19:28:59'),
(91, 'IA-AUTO2', 'Automotive Servicing NC II', 12, 7, 'specialized', '2026-04-01 19:28:59'),
(92, 'IA-ESS', 'Engine System Servicing', 12, 7, 'specialized', '2026-04-01 19:28:59'),
(93, 'WI-G12', 'Work Immersion', 12, NULL, 'immersion', '2026-04-01 19:28:59');

-- --------------------------------------------------------

--
-- Table structure for table `support_tickets`
--

DROP TABLE IF EXISTS `support_tickets`;
CREATE TABLE IF NOT EXISTS `support_tickets` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `subject` varchar(200) NOT NULL,
  `message` text NOT NULL,
  `status` enum('open','in_progress','resolved') NOT NULL DEFAULT 'open',
  `admin_reply` text,
  `replied_by` int DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  KEY `replied_by` (`replied_by`),
  KEY `idx_support_status` (`status`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `support_tickets`
--

INSERT INTO `support_tickets` (`id`, `user_id`, `subject`, `message`, `status`, `admin_reply`, `replied_by`, `created_at`, `updated_at`) VALUES
(1, 2, 'mapeh', 'hello', 'resolved', NULL, 1, '2026-04-02 04:29:16', '2026-04-02 04:31:24');

-- --------------------------------------------------------

--
-- Table structure for table `system_settings`
--

DROP TABLE IF EXISTS `system_settings`;
CREATE TABLE IF NOT EXISTS `system_settings` (
  `id` int NOT NULL AUTO_INCREMENT,
  `setting_key` varchar(100) NOT NULL,
  `setting_value` text,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `setting_key` (`setting_key`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `system_settings`
--

INSERT INTO `system_settings` (`id`, `setting_key`, `setting_value`, `updated_at`) VALUES
(1, 'school_year', '2025-2026', '2026-04-02 04:20:11'),
(2, 'comp_weak_threshold', '75', '2026-04-02 04:20:11'),
(3, 'comp_at_risk_min', '75', '2026-04-02 04:20:11'),
(4, 'comp_at_risk_max', '79', '2026-04-02 04:20:11'),
(5, 'comp_proficient_min', '80', '2026-04-02 04:20:11'),
(6, 'emp_moderate_min', '75', '2026-04-02 04:20:11'),
(7, 'emp_high_min', '80', '2026-04-02 04:20:11'),
(8, 'emp_very_high_min', '90', '2026-04-02 04:20:11'),
(9, 'framework_notes', 'Maintain DepEd K to 12 alignment. Update strand descriptions when curriculum changes. Teachers encode grades; administrators do not access student academic records.', '2026-04-02 04:20:11');

-- --------------------------------------------------------

--
-- Table structure for table `teacher_sections`
--

DROP TABLE IF EXISTS `teacher_sections`;
CREATE TABLE IF NOT EXISTS `teacher_sections` (
  `id` int NOT NULL AUTO_INCREMENT,
  `teacher_id` int NOT NULL,
  `section_id` int NOT NULL,
  `school_year` varchar(20) NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_teacher_section` (`teacher_id`,`section_id`,`school_year`),
  KEY `section_id` (`section_id`),
  KEY `idx_teacher_sections` (`teacher_id`,`school_year`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `teacher_subjects`
--

DROP TABLE IF EXISTS `teacher_subjects`;
CREATE TABLE IF NOT EXISTS `teacher_subjects` (
  `id` int NOT NULL AUTO_INCREMENT,
  `teacher_id` int NOT NULL,
  `subject_id` int NOT NULL,
  `school_year` varchar(20) NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_teacher_subject` (`teacher_id`,`subject_id`,`school_year`),
  KEY `subject_id` (`subject_id`),
  KEY `idx_teacher_subjects` (`teacher_id`,`school_year`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
CREATE TABLE IF NOT EXISTS `users` (
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
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `username`, `password`, `full_name`, `email`, `role`, `status`, `created_at`, `updated_at`) VALUES
(1, 'admin', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'System Administrator', 'admin@steps.edu', 'admin', 'active', '2026-04-02 04:20:11', '2026-04-02 04:20:11'),
(2, 'teacher_santos', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Maria Santos', 'maria@steps.edu', 'teacher', 'active', '2026-04-02 04:20:11', '2026-04-02 04:20:11'),
(3, 'teacher_delos_reyes', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Carlos Delos Reyes', 'carlos@steps.edu', 'teacher', 'active', '2026-04-02 04:20:11', '2026-04-02 04:20:11'),
(4, 'teacher_cruz', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Ana Cruz', 'ana@steps.edu', 'teacher', 'active', '2026-04-02 04:20:11', '2026-04-02 04:20:11'),
(5, 'guidance_reyes', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Jose Reyes', 'jose@steps.edu', 'guidance', 'active', '2026-04-02 04:20:11', '2026-04-02 04:20:11'),
(6, 'guidance_mendoza', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Sofia Mendoza', 'sofia@steps.edu', 'guidance', 'active', '2026-04-02 04:20:11', '2026-04-02 04:20:11');

-- --------------------------------------------------------

--
-- Table structure for table `work_immersion`
--

DROP TABLE IF EXISTS `work_immersion`;
CREATE TABLE IF NOT EXISTS `work_immersion` (
  `id` int NOT NULL AUTO_INCREMENT,
  `student_id` int NOT NULL,
  `company_name` varchar(150) DEFAULT NULL,
  `rating` decimal(5,2) NOT NULL,
  `hours_completed` int NOT NULL DEFAULT '0',
  `performance_remarks` text,
  `school_year` varchar(20) NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_work_immersion_student_year` (`student_id`,`school_year`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `activity_logs`
--
ALTER TABLE `activity_logs`
  ADD CONSTRAINT `activity_logs_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `backup_logs`
--
ALTER TABLE `backup_logs`
  ADD CONSTRAINT `backup_logs_ibfk_1` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `career_recommendations`
--
ALTER TABLE `career_recommendations`
  ADD CONSTRAINT `career_recommendations_ibfk_1` FOREIGN KEY (`student_id`) REFERENCES `students` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `career_recommendations_ibfk_2` FOREIGN KEY (`generated_by`) REFERENCES `users` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `competency_records`
--
ALTER TABLE `competency_records`
  ADD CONSTRAINT `competency_records_ibfk_1` FOREIGN KEY (`student_id`) REFERENCES `students` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `competency_records_ibfk_2` FOREIGN KEY (`subject_id`) REFERENCES `subjects` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `diagnostic_reports`
--
ALTER TABLE `diagnostic_reports`
  ADD CONSTRAINT `diagnostic_reports_ibfk_1` FOREIGN KEY (`student_id`) REFERENCES `students` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `diagnostic_reports_ibfk_2` FOREIGN KEY (`section_id`) REFERENCES `sections` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `diagnostic_reports_ibfk_3` FOREIGN KEY (`generated_by`) REFERENCES `users` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `grades`
--
ALTER TABLE `grades`
  ADD CONSTRAINT `grades_ibfk_1` FOREIGN KEY (`student_id`) REFERENCES `students` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `grades_ibfk_2` FOREIGN KEY (`subject_id`) REFERENCES `subjects` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `grades_ibfk_3` FOREIGN KEY (`encoded_by`) REFERENCES `users` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `grade_subject_remarks`
--
ALTER TABLE `grade_subject_remarks`
  ADD CONSTRAINT `grade_subject_remarks_ibfk_1` FOREIGN KEY (`student_id`) REFERENCES `students` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `grade_subject_remarks_ibfk_2` FOREIGN KEY (`subject_id`) REFERENCES `subjects` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `grade_subject_remarks_ibfk_3` FOREIGN KEY (`updated_by`) REFERENCES `users` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `import_logs`
--
ALTER TABLE `import_logs`
  ADD CONSTRAINT `import_logs_ibfk_1` FOREIGN KEY (`imported_by`) REFERENCES `users` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `non_academic_indicators`
--
ALTER TABLE `non_academic_indicators`
  ADD CONSTRAINT `non_academic_indicators_ibfk_1` FOREIGN KEY (`student_id`) REFERENCES `students` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `non_academic_indicators_ibfk_2` FOREIGN KEY (`updated_by`) REFERENCES `users` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `notifications`
--
ALTER TABLE `notifications`
  ADD CONSTRAINT `notifications_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `sections`
--
ALTER TABLE `sections`
  ADD CONSTRAINT `sections_ibfk_1` FOREIGN KEY (`adviser_id`) REFERENCES `users` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `strand_course_mapping`
--
ALTER TABLE `strand_course_mapping`
  ADD CONSTRAINT `strand_course_mapping_ibfk_1` FOREIGN KEY (`strand_id`) REFERENCES `strands` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `students`
--
ALTER TABLE `students`
  ADD CONSTRAINT `students_ibfk_1` FOREIGN KEY (`section_id`) REFERENCES `sections` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `students_ibfk_2` FOREIGN KEY (`strand_id`) REFERENCES `strands` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `subjects`
--
ALTER TABLE `subjects`
  ADD CONSTRAINT `subjects_ibfk_1` FOREIGN KEY (`strand_id`) REFERENCES `strands` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `support_tickets`
--
ALTER TABLE `support_tickets`
  ADD CONSTRAINT `support_tickets_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `support_tickets_ibfk_2` FOREIGN KEY (`replied_by`) REFERENCES `users` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `teacher_sections`
--
ALTER TABLE `teacher_sections`
  ADD CONSTRAINT `teacher_sections_ibfk_1` FOREIGN KEY (`teacher_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `teacher_sections_ibfk_2` FOREIGN KEY (`section_id`) REFERENCES `sections` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `teacher_subjects`
--
ALTER TABLE `teacher_subjects`
  ADD CONSTRAINT `teacher_subjects_ibfk_1` FOREIGN KEY (`teacher_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `teacher_subjects_ibfk_2` FOREIGN KEY (`subject_id`) REFERENCES `subjects` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `work_immersion`
--
ALTER TABLE `work_immersion`
  ADD CONSTRAINT `work_immersion_ibfk_1` FOREIGN KEY (`student_id`) REFERENCES `students` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
