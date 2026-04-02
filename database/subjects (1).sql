-- phpMyAdmin SQL Dump
-- version 5.2.2
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1:3306
-- Generation Time: Apr 02, 2026 at 03:35 AM
-- Server version: 11.8.6-MariaDB-log
-- PHP Version: 7.2.34

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `u177927810_steps_db`
--

-- --------------------------------------------------------

--
-- Table structure for table `subjects`
--

CREATE TABLE `subjects` (
  `id` int(11) NOT NULL,
  `subject_code` varchar(20) NOT NULL,
  `subject_name` varchar(150) NOT NULL,
  `grade_level` int(11) DEFAULT NULL COMMENT 'NULL = all grade levels; 7-10 = JHS; 11-12 = SHS',
  `strand_id` int(11) DEFAULT NULL COMMENT 'NULL = applies to all strands',
  `subject_type` enum('core','specialized','applied','immersion','jhs_core','jhs_mapeh','jhs_tle','jhs_esp') NOT NULL DEFAULT 'core',
  `created_at` timestamp NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `subjects`
--

INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `grade_level`, `strand_id`, `subject_type`, `created_at`) VALUES
(1, 'G7-ENG', 'English 7', 7, NULL, 'jhs_core', '2026-04-02 03:28:59'),
(2, 'G7-FIL', 'Filipino 7', 7, NULL, 'jhs_core', '2026-04-02 03:28:59'),
(3, 'G7-MAT', 'Mathematics 7', 7, NULL, 'jhs_core', '2026-04-02 03:28:59'),
(4, 'G7-SCI', 'Science 7', 7, NULL, 'jhs_core', '2026-04-02 03:28:59'),
(5, 'G7-AP', 'Araling Panlipunan 7', 7, NULL, 'jhs_core', '2026-04-02 03:28:59'),
(6, 'G7-ESP', 'Edukasyon sa Pagpapakatao 7', 7, NULL, 'jhs_esp', '2026-04-02 03:28:59'),
(7, 'G7-MAPEH', 'MAPEH 7', 7, NULL, 'jhs_mapeh', '2026-04-02 03:28:59'),
(8, 'G7-TLE', 'Technology and Livelihood Education 7', 7, NULL, 'jhs_tle', '2026-04-02 03:28:59'),
(9, 'G8-ENG', 'English 8', 8, NULL, 'jhs_core', '2026-04-02 03:28:59'),
(10, 'G8-FIL', 'Filipino 8', 8, NULL, 'jhs_core', '2026-04-02 03:28:59'),
(11, 'G8-MAT', 'Mathematics 8', 8, NULL, 'jhs_core', '2026-04-02 03:28:59'),
(12, 'G8-SCI', 'Science 8', 8, NULL, 'jhs_core', '2026-04-02 03:28:59'),
(13, 'G8-AP', 'Araling Panlipunan 8', 8, NULL, 'jhs_core', '2026-04-02 03:28:59'),
(14, 'G8-ESP', 'Edukasyon sa Pagpapakatao 8', 8, NULL, 'jhs_esp', '2026-04-02 03:28:59'),
(15, 'G8-MAPEH', 'MAPEH 8', 8, NULL, 'jhs_mapeh', '2026-04-02 03:28:59'),
(16, 'G8-TLE', 'Technology and Livelihood Education 8', 8, NULL, 'jhs_tle', '2026-04-02 03:28:59'),
(17, 'G9-ENG', 'English 9', 9, NULL, 'jhs_core', '2026-04-02 03:28:59'),
(18, 'G9-FIL', 'Filipino 9', 9, NULL, 'jhs_core', '2026-04-02 03:28:59'),
(19, 'G9-MAT', 'Mathematics 9', 9, NULL, 'jhs_core', '2026-04-02 03:28:59'),
(20, 'G9-SCI', 'Science 9', 9, NULL, 'jhs_core', '2026-04-02 03:28:59'),
(21, 'G9-AP', 'Araling Panlipunan 9', 9, NULL, 'jhs_core', '2026-04-02 03:28:59'),
(22, 'G9-ESP', 'Edukasyon sa Pagpapakatao 9', 9, NULL, 'jhs_esp', '2026-04-02 03:28:59'),
(23, 'G9-MAPEH', 'MAPEH 9', 9, NULL, 'jhs_mapeh', '2026-04-02 03:28:59'),
(24, 'G9-TLE', 'Technology and Livelihood Education 9', 9, NULL, 'jhs_tle', '2026-04-02 03:28:59'),
(25, 'G10-ENG', 'English 10', 10, NULL, 'jhs_core', '2026-04-02 03:28:59'),
(26, 'G10-FIL', 'Filipino 10', 10, NULL, 'jhs_core', '2026-04-02 03:28:59'),
(27, 'G10-MAT', 'Mathematics 10', 10, NULL, 'jhs_core', '2026-04-02 03:28:59'),
(28, 'G10-SCI', 'Science 10', 10, NULL, 'jhs_core', '2026-04-02 03:28:59'),
(29, 'G10-AP', 'Araling Panlipunan 10', 10, NULL, 'jhs_core', '2026-04-02 03:28:59'),
(30, 'G10-ESP', 'Edukasyon sa Pagpapakatao 10', 10, NULL, 'jhs_esp', '2026-04-02 03:28:59'),
(31, 'G10-MAPEH', 'MAPEH 10', 10, NULL, 'jhs_mapeh', '2026-04-02 03:28:59'),
(32, 'G10-TLE', 'Technology and Livelihood Education 10', 10, NULL, 'jhs_tle', '2026-04-02 03:28:59'),
(33, 'CORE-ORALCOM', 'Oral Communication', 11, NULL, 'core', '2026-04-02 03:28:59'),
(34, 'CORE-RW', 'Reading and Writing', 11, NULL, 'core', '2026-04-02 03:28:59'),
(35, 'CORE-KOMFIL', 'Komunikasyon at Pananaliksik sa Wika at Kulturang Pilipino', 11, NULL, 'core', '2026-04-02 03:28:59'),
(36, 'CORE-GENMATH', 'General Mathematics', 11, NULL, 'core', '2026-04-02 03:28:59'),
(37, 'CORE-STATPROB', 'Statistics and Probability', 11, NULL, 'core', '2026-04-02 03:28:59'),
(38, 'CORE-ELS', 'Earth and Life Science', 11, NULL, 'core', '2026-04-02 03:28:59'),
(39, 'CORE-PHYSCI', 'Physical Science', 11, NULL, 'core', '2026-04-02 03:28:59'),
(40, 'CORE-PERDEV', 'Personal Development', 11, NULL, 'core', '2026-04-02 03:28:59'),
(41, 'CORE-PHILO', 'Introduction to the Philosophy of the Human Person', 11, NULL, 'core', '2026-04-02 03:28:59'),
(42, 'CORE-PEH1', 'Physical Education and Health 1', 11, NULL, 'core', '2026-04-02 03:28:59'),
(43, 'CORE-21LIT', '21st Century Literature from the Philippines and the World', 11, NULL, 'core', '2026-04-02 03:28:59'),
(44, 'CORE-MIL', 'Media and Information Literacy', 12, NULL, 'core', '2026-04-02 03:28:59'),
(45, 'CORE-CPAR', 'Contemporary Philippine Arts from the Regions', 12, NULL, 'core', '2026-04-02 03:28:59'),
(46, 'CORE-UCSP', 'Understanding Culture, Society and Politics', 12, NULL, 'core', '2026-04-02 03:28:59'),
(47, 'CORE-PAGBASA', 'Pagbasa at Pagsusuri ng Iba\'t Ibang Teksto Tungo sa Pananaliksik', 12, NULL, 'core', '2026-04-02 03:28:59'),
(48, 'CORE-PEH2', 'Physical Education and Health 2', 12, NULL, 'core', '2026-04-02 03:28:59'),
(49, 'APP-ETECH', 'Empowerment Technologies', 11, NULL, 'applied', '2026-04-02 03:28:59'),
(50, 'APP-EAPP', 'English for Academic and Professional Purposes', 11, NULL, 'applied', '2026-04-02 03:28:59'),
(51, 'APP-PR1', 'Practical Research 1', 12, NULL, 'applied', '2026-04-02 03:28:59'),
(52, 'APP-PR2', 'Practical Research 2', 12, NULL, 'applied', '2026-04-02 03:28:59'),
(53, 'APP-FIL', 'Filipino sa Piling Larangan', 12, NULL, 'applied', '2026-04-02 03:28:59'),
(54, 'APP-ENTREP', 'Entrepreneurship', 12, NULL, 'applied', '2026-04-02 03:28:59'),
(55, 'STEM-PRECAL', 'Pre-Calculus', 11, 1, 'specialized', '2026-04-02 03:28:59'),
(56, 'STEM-BIO1', 'General Biology 1', 11, 1, 'specialized', '2026-04-02 03:28:59'),
(57, 'STEM-CHEM1', 'General Chemistry 1', 11, 1, 'specialized', '2026-04-02 03:28:59'),
(58, 'STEM-PHYS1', 'General Physics 1', 11, 1, 'specialized', '2026-04-02 03:28:59'),
(59, 'STEM-BASCAL', 'Basic Calculus', 12, 1, 'specialized', '2026-04-02 03:28:59'),
(60, 'STEM-BIO2', 'General Biology 2', 12, 1, 'specialized', '2026-04-02 03:28:59'),
(61, 'STEM-CHEM2', 'General Chemistry 2', 12, 1, 'specialized', '2026-04-02 03:28:59'),
(62, 'STEM-PHYS2', 'General Physics 2', 12, 1, 'specialized', '2026-04-02 03:28:59'),
(63, 'STEM-CAPSTONE', 'Research/Capstone Project', 12, 1, 'specialized', '2026-04-02 03:28:59'),
(64, 'ABM-FABM1', 'Fundamentals of ABM 1', 11, 2, 'specialized', '2026-04-02 03:28:59'),
(65, 'ABM-BMATH', 'Business Mathematics', 11, 2, 'specialized', '2026-04-02 03:28:59'),
(66, 'ABM-ORGMGMT', 'Organization and Management', 11, 2, 'specialized', '2026-04-02 03:28:59'),
(67, 'ABM-FABM2', 'Fundamentals of ABM 2', 12, 2, 'specialized', '2026-04-02 03:28:59'),
(68, 'ABM-BFIN', 'Business Finance', 12, 2, 'specialized', '2026-04-02 03:28:59'),
(69, 'ABM-MKTG', 'Principles of Marketing', 12, 2, 'specialized', '2026-04-02 03:28:59'),
(70, 'ABM-AE', 'Applied Economics', 12, 2, 'specialized', '2026-04-02 03:28:59'),
(71, 'ABM-BESR', 'Business Ethics and Social Responsibility', 12, 2, 'specialized', '2026-04-02 03:28:59'),
(72, 'HUM-DISS', 'Disciplines and Ideas in the Social Sciences', 11, 3, 'specialized', '2026-04-02 03:28:59'),
(73, 'HUM-PPG', 'Philippine Politics and Governance', 11, 3, 'specialized', '2026-04-02 03:28:59'),
(74, 'HUM-IWRBS', 'Introduction to World Religions and Belief Systems', 11, 3, 'specialized', '2026-04-02 03:28:59'),
(75, 'HUM-DIASS', 'Disciplines and Ideas in Applied Social Sciences', 12, 3, 'specialized', '2026-04-02 03:28:59'),
(76, 'HUM-CNF', 'Creative Nonfiction', 12, 3, 'specialized', '2026-04-02 03:28:59'),
(77, 'HUM-CW', 'Creative Writing / Malikhaing Pagsulat', 12, 3, 'specialized', '2026-04-02 03:28:59'),
(78, 'HUM-TNCT', 'Trends, Networks and Critical Thinking', 12, 3, 'specialized', '2026-04-02 03:28:59'),
(79, 'HUM-CESC', 'Community Engagement, Solidarity and Citizenship', 12, 3, 'specialized', '2026-04-02 03:28:59'),
(80, 'ICT-CP1', 'Computer Programming 1', 11, 5, 'specialized', '2026-04-02 03:28:59'),
(81, 'ICT-CSS', 'Computer Systems Servicing NC II', 11, 5, 'specialized', '2026-04-02 03:28:59'),
(82, 'ICT-CP2', 'Computer Programming 2', 12, 5, 'specialized', '2026-04-02 03:28:59'),
(83, 'ICT-WEBDEV', 'Web Development', 12, 5, 'specialized', '2026-04-02 03:28:59'),
(84, 'ICT-JAVA', 'Programming (Java / .Net)', 12, 5, 'specialized', '2026-04-02 03:28:59'),
(85, 'HE-COOKERY1', 'Basic Cookery NC II', 11, 6, 'specialized', '2026-04-02 03:28:59'),
(86, 'HE-BPP', 'Bread and Pastry Production NC II', 11, 6, 'specialized', '2026-04-02 03:28:59'),
(87, 'HE-COOKERY2', 'Advanced Cookery NC II', 12, 6, 'specialized', '2026-04-02 03:28:59'),
(88, 'HE-FBS', 'Food and Beverage Services NC II', 12, 6, 'specialized', '2026-04-02 03:28:59'),
(89, 'IA-AUTO1', 'Automotive Servicing NC I', 11, 7, 'specialized', '2026-04-02 03:28:59'),
(90, 'IA-PM', 'Preventive Maintenance', 11, 7, 'specialized', '2026-04-02 03:28:59'),
(91, 'IA-AUTO2', 'Automotive Servicing NC II', 12, 7, 'specialized', '2026-04-02 03:28:59'),
(92, 'IA-ESS', 'Engine System Servicing', 12, 7, 'specialized', '2026-04-02 03:28:59'),
(93, 'WI-G12', 'Work Immersion', 12, NULL, 'immersion', '2026-04-02 03:28:59');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `subjects`
--
ALTER TABLE `subjects`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_subject_code` (`subject_code`),
  ADD KEY `strand_id` (`strand_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `subjects`
--
ALTER TABLE `subjects`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=94;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `subjects`
--
ALTER TABLE `subjects`
  ADD CONSTRAINT `subjects_ibfk_1` FOREIGN KEY (`strand_id`) REFERENCES `strands` (`id`) ON DELETE SET NULL;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
