-- ============================================
-- STEPS - Student Tracking & Evaluation Performance System
-- Database Schema
-- ============================================

CREATE DATABASE IF NOT EXISTS steps_db;
USE steps_db;

-- ============================================
-- USERS TABLE
-- ============================================
CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100),
    role ENUM('admin', 'teacher', 'guidance') NOT NULL DEFAULT 'teacher',
    status ENUM('active', 'inactive') NOT NULL DEFAULT 'active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- ============================================
-- SECTIONS TABLE
-- ============================================
CREATE TABLE IF NOT EXISTS sections (
    id INT AUTO_INCREMENT PRIMARY KEY,
    section_name VARCHAR(50) NOT NULL,
    grade_level INT NOT NULL,
    strand VARCHAR(50),
    adviser_id INT,
    school_year VARCHAR(20) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (adviser_id) REFERENCES users(id) ON DELETE SET NULL
) ENGINE=InnoDB;

-- ============================================
-- STRANDS TABLE
-- ============================================
CREATE TABLE IF NOT EXISTS strands (
    id INT AUTO_INCREMENT PRIMARY KEY,
    strand_code VARCHAR(20) NOT NULL UNIQUE,
    strand_name VARCHAR(100) NOT NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- ============================================
-- STUDENTS TABLE
-- ============================================
CREATE TABLE IF NOT EXISTS students (
    id INT AUTO_INCREMENT PRIMARY KEY,
    lrn VARCHAR(20) NOT NULL UNIQUE,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    middle_name VARCHAR(50),
    gender ENUM('Male', 'Female') NOT NULL,
    birthdate DATE,
    section_id INT,
    strand_id INT,
    school_year VARCHAR(20) NOT NULL,
    status ENUM('active', 'inactive', 'graduated') NOT NULL DEFAULT 'active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (section_id) REFERENCES sections(id) ON DELETE SET NULL,
    FOREIGN KEY (strand_id) REFERENCES strands(id) ON DELETE SET NULL
) ENGINE=InnoDB;

-- ============================================
-- SUBJECTS TABLE
-- ============================================
CREATE TABLE IF NOT EXISTS subjects (
    id INT AUTO_INCREMENT PRIMARY KEY,
    subject_code VARCHAR(20) NOT NULL,
    subject_name VARCHAR(100) NOT NULL,
    grade_level INT DEFAULT NULL COMMENT 'NULL = all grade levels; 7-10 = JHS; 11-12 = SHS',
    strand_id INT,
    subject_type ENUM('core', 'specialized', 'applied', 'immersion', 'jhs_core', 'jhs_mapeh', 'jhs_tle', 'jhs_esp') NOT NULL DEFAULT 'core',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (strand_id) REFERENCES strands(id) ON DELETE SET NULL
) ENGINE=InnoDB;

-- ============================================
-- GRADES TABLE
-- ============================================
CREATE TABLE IF NOT EXISTS grades (
    id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT NOT NULL,
    subject_id INT NOT NULL,
    quarter ENUM('Q1', 'Q2', 'Q3', 'Q4') NOT NULL,
    grade DECIMAL(5,2) NOT NULL,
    school_year VARCHAR(20) NOT NULL,
    encoded_by INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (student_id) REFERENCES students(id) ON DELETE CASCADE,
    FOREIGN KEY (subject_id) REFERENCES subjects(id) ON DELETE CASCADE,
    FOREIGN KEY (encoded_by) REFERENCES users(id) ON DELETE SET NULL,
    UNIQUE KEY unique_grade (student_id, subject_id, quarter, school_year)
) ENGINE=InnoDB;

-- ============================================
-- COMPETENCY RECORDS TABLE
-- ============================================
CREATE TABLE IF NOT EXISTS competency_records (
    id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT NOT NULL,
    subject_id INT NOT NULL,
    average_grade DECIMAL(5,2) NOT NULL,
    competency_level ENUM('weak', 'at_risk', 'proficient') NOT NULL,
    remarks VARCHAR(100),
    school_year VARCHAR(20) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (student_id) REFERENCES students(id) ON DELETE CASCADE,
    FOREIGN KEY (subject_id) REFERENCES subjects(id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- ============================================
-- NON-ACADEMIC INDICATORS TABLE
-- ============================================
CREATE TABLE IF NOT EXISTS non_academic_indicators (
    id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT NOT NULL UNIQUE,
    skills TEXT,
    hobbies TEXT,
    family_background TEXT,
    annual_income ENUM('below_100k', '100k_300k', '300k_500k', '500k_above') DEFAULT 'below_100k',
    entrance_exam_score DECIMAL(5,2),
    entrance_exam_date DATE,
    updated_by INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (student_id) REFERENCES students(id) ON DELETE CASCADE,
    FOREIGN KEY (updated_by) REFERENCES users(id) ON DELETE SET NULL
) ENGINE=InnoDB;

-- ============================================
-- CAREER RECOMMENDATIONS TABLE
-- ============================================
CREATE TABLE IF NOT EXISTS career_recommendations (
    id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT NOT NULL,
    recommendation_type ENUM('strand', 'course') NOT NULL DEFAULT 'strand',
    top_strand_1 VARCHAR(100),
    top_strand_2 VARCHAR(100),
    top_strand_3 VARCHAR(100),
    top_course_1 VARCHAR(150),
    top_course_2 VARCHAR(150),
    top_course_3 VARCHAR(150),
    recommended_strand VARCHAR(100),
    recommended_courses TEXT,
    employability_score DECIMAL(5,2),
    employability_level ENUM('low', 'moderate', 'high', 'very_high') NOT NULL DEFAULT 'moderate',
    strand_match TINYINT(1) DEFAULT 1,
    mismatch_remarks TEXT,
    career_pathways TEXT,
    score_breakdown JSON,
    generated_by INT,
    school_year VARCHAR(20) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (student_id) REFERENCES students(id) ON DELETE CASCADE,
    FOREIGN KEY (generated_by) REFERENCES users(id) ON DELETE SET NULL
) ENGINE=InnoDB;

-- ============================================
-- DIAGNOSTIC REPORTS TABLE
-- ============================================
CREATE TABLE IF NOT EXISTS diagnostic_reports (
    id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT,
    section_id INT,
    report_type ENUM('individual', 'section', 'class_performance', 'competency') NOT NULL,
    report_data JSON,
    generated_by INT,
    school_year VARCHAR(20) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (student_id) REFERENCES students(id) ON DELETE CASCADE,
    FOREIGN KEY (section_id) REFERENCES sections(id) ON DELETE CASCADE,
    FOREIGN KEY (generated_by) REFERENCES users(id) ON DELETE SET NULL
) ENGINE=InnoDB;

-- ============================================
-- BACKUP LOGS TABLE
-- ============================================
CREATE TABLE IF NOT EXISTS backup_logs (
    id INT AUTO_INCREMENT PRIMARY KEY,
    backup_file VARCHAR(255) NOT NULL,
    file_size VARCHAR(50),
    backup_type ENUM('full', 'partial') NOT NULL DEFAULT 'full',
    created_by INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (created_by) REFERENCES users(id) ON DELETE SET NULL
) ENGINE=InnoDB;

-- ============================================
-- ACTIVITY LOGS TABLE
-- ============================================
CREATE TABLE IF NOT EXISTS activity_logs (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    action VARCHAR(100) NOT NULL,
    description TEXT,
    ip_address VARCHAR(45),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL
) ENGINE=InnoDB;

-- ============================================
-- IMPORT LOGS TABLE
-- ============================================
CREATE TABLE IF NOT EXISTS import_logs (
    id INT AUTO_INCREMENT PRIMARY KEY,
    file_name VARCHAR(255) NOT NULL,
    total_rows INT DEFAULT 0,
    inserted INT DEFAULT 0,
    skipped INT DEFAULT 0,
    errors TEXT,
    imported_by INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (imported_by) REFERENCES users(id) ON DELETE SET NULL
) ENGINE=InnoDB;

-- ============================================
-- STRAND-COURSE MAPPING TABLE
-- ============================================
CREATE TABLE IF NOT EXISTS strand_course_mapping (
    id INT AUTO_INCREMENT PRIMARY KEY,
    strand_id INT NOT NULL,
    course_name VARCHAR(150) NOT NULL,
    career_pathway VARCHAR(200),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (strand_id) REFERENCES strands(id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- ============================================
-- DEFAULT DATA
-- ============================================

-- Default password for all users: "password"
-- Username format: teacher_lastname / guidance_lastname
INSERT INTO users (username, password, full_name, email, role) VALUES
('admin', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'System Administrator', 'admin@steps.edu', 'admin'),
('teacher_santos', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Maria Santos', 'maria@steps.edu', 'teacher'),
('teacher_delos_reyes', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Carlos Delos Reyes', 'carlos@steps.edu', 'teacher'),
('teacher_cruz', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Ana Cruz', 'ana@steps.edu', 'teacher'),
('guidance_reyes', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Jose Reyes', 'jose@steps.edu', 'guidance'),
('guidance_mendoza', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Sofia Mendoza', 'sofia@steps.edu', 'guidance');

INSERT INTO strands (strand_code, strand_name, description) VALUES
('STEM', 'Science, Technology, Engineering and Mathematics', 'Focus on advanced math, science, and technology subjects'),
('ABM', 'Accountancy, Business and Management', 'Focus on business, finance, and management subjects'),
('HUMSS', 'Humanities and Social Sciences', 'Focus on liberal arts, social sciences, and communication'),
('GAS', 'General Academic Strand', 'Broad academic foundation across disciplines'),
('TVL-ICT', 'Technical-Vocational-Livelihood: ICT', 'Focus on Information and Communications Technology'),
('TVL-HE', 'Technical-Vocational-Livelihood: Home Economics', 'Focus on Home Economics and hospitality'),
('TVL-IA', 'Technical-Vocational-Livelihood: Industrial Arts', 'Focus on Industrial Arts and technical skills'),
('SPORTS', 'Sports Track', 'Focus on sports science, fitness, and athletics'),
('ARTS', 'Arts and Design Track', 'Focus on creative arts, media, and design');

INSERT INTO sections (section_name, grade_level, strand, adviser_id, school_year) VALUES
('Section A', 11, 'STEM', 2, '2025-2026'),
('Section B', 11, 'ABM', 3, '2025-2026'),
('Section C', 11, 'HUMSS', 4, '2025-2026'),
('Section D', 11, 'GAS', 2, '2025-2026'),
('Section E', 11, 'TVL-ICT', 3, '2025-2026'),
('Section F', 12, 'STEM', 2, '2025-2026'),
('Section G', 12, 'ABM', 4, '2025-2026'),
('Section H', 12, 'HUMSS', 3, '2025-2026'),
('Section I', 12, 'GAS', 2, '2025-2026'),
('Section J', 12, 'TVL-ICT', 4, '2025-2026');

-- ============================================
-- JHS SUBJECTS (Grade 7 - Grade 10, DepEd K-12)
-- subject_type reference:
--   jhs_core  = Academic core subjects
--   jhs_mapeh = Music, Arts, Physical Education, Health
--   jhs_tle   = Technology & Livelihood Education
--   jhs_esp   = Edukasyon sa Pagpapakatao
-- ============================================
INSERT INTO subjects (subject_code, subject_name, grade_level, strand_id, subject_type) VALUES

-- ── GRADE 7 ──────────────────────────────────────────────────────────────────
('G7-ENG',   'English 7',                            7,  NULL, 'jhs_core'),
('G7-FIL',   'Filipino 7',                           7,  NULL, 'jhs_core'),
('G7-MAT',   'Mathematics 7',                        7,  NULL, 'jhs_core'),
('G7-SCI',   'Science 7',                            7,  NULL, 'jhs_core'),
('G7-AP',    'Araling Panlipunan 7',                 7,  NULL, 'jhs_core'),
('G7-ESP',   'Edukasyon sa Pagpapakatao 7',          7,  NULL, 'jhs_esp'),
('G7-MAPEH', 'MAPEH 7',                              7,  NULL, 'jhs_mapeh'),
('G7-TLE',   'Technology & Livelihood Education 7',  7,  NULL, 'jhs_tle'),

-- ── GRADE 8 ──────────────────────────────────────────────────────────────────
('G8-ENG',   'English 8',                            8,  NULL, 'jhs_core'),
('G8-FIL',   'Filipino 8',                           8,  NULL, 'jhs_core'),
('G8-MAT',   'Mathematics 8',                        8,  NULL, 'jhs_core'),
('G8-SCI',   'Science 8',                            8,  NULL, 'jhs_core'),
('G8-AP',    'Araling Panlipunan 8',                 8,  NULL, 'jhs_core'),
('G8-ESP',   'Edukasyon sa Pagpapakatao 8',          8,  NULL, 'jhs_esp'),
('G8-MAPEH', 'MAPEH 8',                              8,  NULL, 'jhs_mapeh'),
('G8-TLE',   'Technology & Livelihood Education 8',  8,  NULL, 'jhs_tle'),

-- ── GRADE 9 ──────────────────────────────────────────────────────────────────
('G9-ENG',   'English 9',                            9,  NULL, 'jhs_core'),
('G9-FIL',   'Filipino 9',                           9,  NULL, 'jhs_core'),
('G9-MAT',   'Mathematics 9',                        9,  NULL, 'jhs_core'),
('G9-SCI',   'Science 9',                            9,  NULL, 'jhs_core'),
('G9-AP',    'Araling Panlipunan 9',                 9,  NULL, 'jhs_core'),
('G9-ESP',   'Edukasyon sa Pagpapakatao 9',          9,  NULL, 'jhs_esp'),
('G9-MAPEH', 'MAPEH 9',                              9,  NULL, 'jhs_mapeh'),
('G9-TLE',   'Technology & Livelihood Education 9',  9,  NULL, 'jhs_tle'),

-- ── GRADE 10 ─────────────────────────────────────────────────────────────────
('G10-ENG',   'English 10',                           10, NULL, 'jhs_core'),
('G10-FIL',   'Filipino 10',                          10, NULL, 'jhs_core'),
('G10-MAT',   'Mathematics 10',                       10, NULL, 'jhs_core'),
('G10-SCI',   'Science 10',                           10, NULL, 'jhs_core'),
('G10-AP',    'Araling Panlipunan 10',                10, NULL, 'jhs_core'),
('G10-ESP',   'Edukasyon sa Pagpapakatao 10',         10, NULL, 'jhs_esp'),
('G10-MAPEH', 'MAPEH 10',                             10, NULL, 'jhs_mapeh'),
('G10-TLE',   'Technology & Livelihood Education 10', 10, NULL, 'jhs_tle');

-- ============================================
-- SHS SUBJECTS (Grade 11 - Grade 12, DepEd K-12)
-- ============================================
INSERT INTO subjects (subject_code, subject_name, grade_level, strand_id, subject_type) VALUES
-- Core Subjects (shared across all SHS strands)
('CORE01', 'Oral Communication',                                          11, NULL, 'core'),
('CORE02', 'Reading and Writing',                                         11, NULL, 'core'),
('CORE03', 'Komunikasyon at Pananaliksik sa Wika at Kulturang Pilipino',  11, NULL, 'core'),
('CORE04', 'General Mathematics',                                         11, NULL, 'core'),
('CORE05', 'Earth and Life Science',                                      11, NULL, 'core'),
('CORE06', 'Physical Science',                                            11, NULL, 'core'),
('CORE07', 'Personal Development',                                        11, NULL, 'core'),
('CORE08', 'Understanding Culture, Society, and Politics',                11, NULL, 'core'),
('CORE09', 'Introduction to Philosophy',                                  11, NULL, 'core'),
('CORE10', 'Physical Education and Health',                               11, NULL, 'core'),
('CORE11', 'Media and Information Literacy',                              11, NULL, 'core'),
('CORE12', '21st Century Literature from the Philippines and the World',  11, NULL, 'core'),
('CORE13', 'Contemporary Philippine Arts from the Regions',               11, NULL, 'core'),
-- Applied Subjects
('APP01', 'English for Academic and Professional Purposes', 12, NULL, 'applied'),
('APP02', 'Practical Research 1',                          11, NULL, 'applied'),
('APP03', 'Practical Research 2',                          12, NULL, 'applied'),
('APP04', 'Filipino sa Piling Larangan',                   12, NULL, 'applied'),
('APP05', 'Empowerment Technologies',                      11, NULL, 'applied'),
('APP06', 'Entrepreneurship',                              12, NULL, 'applied'),
('APP07', 'Inquiries, Investigations, and Immersion',      12, NULL, 'applied'),
-- STEM Specialized Subjects
('STEM01', 'Pre-Calculus',              11, 1, 'specialized'),
('STEM02', 'Basic Calculus',            12, 1, 'specialized'),
('STEM03', 'General Biology 1',         11, 1, 'specialized'),
('STEM04', 'General Biology 2',         12, 1, 'specialized'),
('STEM05', 'General Chemistry 1',       11, 1, 'specialized'),
('STEM06', 'General Chemistry 2',       12, 1, 'specialized'),
('STEM07', 'General Physics 1',         11, 1, 'specialized'),
('STEM08', 'General Physics 2',         12, 1, 'specialized'),
('STEM09', 'Research/Capstone Project', 12, 1, 'specialized'),
-- ABM Specialized Subjects
('ABM01', 'Fundamentals of ABM 1',                    11, 2, 'specialized'),
('ABM02', 'Fundamentals of ABM 2',                    12, 2, 'specialized'),
('ABM03', 'Business Mathematics',                     11, 2, 'specialized'),
('ABM04', 'Business Finance',                         12, 2, 'specialized'),
('ABM05', 'Organization and Management',              11, 2, 'specialized'),
('ABM06', 'Principles of Marketing',                  12, 2, 'specialized'),
('ABM07', 'Business Ethics and Social Responsibility',12, 2, 'specialized'),
('ABM08', 'Applied Economics',                        12, 2, 'specialized'),
-- HUMSS Specialized Subjects
('HUM01', 'Introduction to World Religions and Belief Systems', 11, 3, 'specialized'),
('HUM02', 'Creative Writing / Malikhaing Pagsulat',             11, 3, 'specialized'),
('HUM03', 'Creative Nonfiction',                                12, 3, 'specialized'),
('HUM04', 'Trends, Networks, and Critical Thinking',            12, 3, 'specialized'),
('HUM05', 'Philippine Politics and Governance',                 12, 3, 'specialized'),
('HUM06', 'Community Engagement, Solidarity, and Citizenship',  12, 3, 'specialized'),
('HUM07', 'Disciplines and Ideas in the Social Sciences',       11, 3, 'specialized'),
-- GAS Specialized Subjects
('GAS01', 'Humanities 1',                       11, 4, 'specialized'),
('GAS02', 'Humanities 2',                       12, 4, 'specialized'),
('GAS03', 'Social Science 1',                   11, 4, 'specialized'),
('GAS04', 'Applied Economics',                  12, 4, 'specialized'),
('GAS05', 'Organization and Management',        11, 4, 'specialized'),
('GAS06', 'Disaster Readiness and Risk Reduction', 12, 4, 'specialized'),
-- TVL-ICT Specialized Subjects
('ICT01', 'Computer Systems Servicing NC II', 11, 5, 'specialized'),
('ICT02', 'Computer Programming (Java)',       11, 5, 'specialized'),
('ICT03', 'Web Development',                  12, 5, 'specialized'),
('ICT04', 'Illustration and Animation',        12, 5, 'specialized'),
-- TVL-HE Specialized Subjects
('HE01', 'Bread and Pastry Production NC II',        11, 6, 'specialized'),
('HE02', 'Cookery NC II',                            11, 6, 'specialized'),
('HE03', 'Housekeeping NC II',                       12, 6, 'specialized'),
('HE04', 'Food and Beverage Services NC II',         12, 6, 'specialized'),
-- TVL-IA Specialized Subjects
('IA01', 'Electrical Installation and Maintenance NC II', 11, 7, 'specialized'),
('IA02', 'Welding NC I',                                  11, 7, 'specialized'),
('IA03', 'Carpentry NC II',                               12, 7, 'specialized'),
('IA04', 'Automotive Servicing NC I',                     12, 7, 'specialized'),
-- Sports Track Specialized Subjects
('SPT01', 'Physical Fitness',                   11, 8, 'specialized'),
('SPT02', 'Team Sports',                        11, 8, 'specialized'),
('SPT03', 'Individual/Dual Sports',             12, 8, 'specialized'),
('SPT04', 'Sports Officiating and Journalism',  12, 8, 'specialized'),
-- Arts and Design Track Specialized Subjects
('ART01', 'Drawing and Painting',               11, 9, 'specialized'),
('ART02', 'Photography and Film',               11, 9, 'specialized'),
('ART03', 'Graphic Design',                     12, 9, 'specialized'),
('ART04', 'Creative Industry Immersion',        12, 9, 'specialized'),
-- Work Immersion subject removed

INSERT INTO students (lrn, first_name, last_name, middle_name, gender, birthdate, section_id, strand_id, school_year) VALUES
-- Section A (G11 STEM)
('100100100001', 'Juan', 'Dela Cruz', 'Santos', 'Male', '2008-03-15', 1, 1, '2025-2026'),
('100100100002', 'Maria', 'Garcia', 'Reyes', 'Female', '2008-06-21', 1, 1, '2025-2026'),
('100100100003', 'Pedro', 'Ramos', 'Lim', 'Male', '2008-01-10', 1, 1, '2025-2026'),
-- Section B (G11 ABM)
('100100100004', 'Ana', 'Lopez', 'Cruz', 'Female', '2008-09-05', 2, 2, '2025-2026'),
('100100100005', 'Carlos', 'Mendoza', 'Bautista', 'Male', '2007-12-18', 2, 2, '2025-2026'),
-- Section C (G11 HUMSS)
('100100100006', 'Sofia', 'Villanueva', 'Torres', 'Female', '2008-04-22', 3, 3, '2025-2026'),
('100100100007', 'Miguel', 'Aquino', 'Santos', 'Male', '2007-08-30', 3, 3, '2025-2026'),
-- Section F (G12 STEM)
('100100100008', 'Isabella', 'Fernandez', 'Reyes', 'Female', '2008-02-14', 6, 1, '2025-2026');

-- Subject IDs reference:
-- 1=CORE01(Oral Comm), 4=CORE04(Gen Math), 21=STEM01(Pre-Calc), 23=STEM03(Gen Bio 1),
-- 25=STEM05(Gen Chem 1), 30=ABM01(Fund ABM1), 31=ABM02(Fund ABM2), 33=ABM03(Bus Math),
-- 38=HUM01(World Religions), 39=HUM02(Creative Writing), 55=WI101(Work Immersion)

INSERT INTO grades (student_id, subject_id, quarter, grade, school_year, encoded_by) VALUES
-- Juan Dela Cruz (STEM): Gen Math, Pre-Calc, Gen Bio, Oral Comm
(1, 4, 'Q1', 88, '2025-2026', 2),  (1, 4, 'Q2', 90, '2025-2026', 2),
(1, 21, 'Q1', 85, '2025-2026', 2), (1, 21, 'Q2', 87, '2025-2026', 2),
(1, 23, 'Q1', 92, '2025-2026', 2), (1, 23, 'Q2', 91, '2025-2026', 2),
(1, 1, 'Q1', 86, '2025-2026', 2),  (1, 1, 'Q2', 88, '2025-2026', 2),
-- Maria Garcia (STEM)
(2, 4, 'Q1', 78, '2025-2026', 2),  (2, 4, 'Q2', 76, '2025-2026', 2),
(2, 21, 'Q1', 74, '2025-2026', 2), (2, 21, 'Q2', 73, '2025-2026', 2),
(2, 23, 'Q1', 80, '2025-2026', 2), (2, 23, 'Q2', 79, '2025-2026', 2),
(2, 1, 'Q1', 82, '2025-2026', 2),  (2, 1, 'Q2', 81, '2025-2026', 2),
-- Pedro Ramos (STEM)
(3, 4, 'Q1', 72, '2025-2026', 2),  (3, 4, 'Q2', 70, '2025-2026', 2),
(3, 21, 'Q1', 68, '2025-2026', 2), (3, 21, 'Q2', 71, '2025-2026', 2),
(3, 23, 'Q1', 74, '2025-2026', 2), (3, 23, 'Q2', 73, '2025-2026', 2),
(3, 1, 'Q1', 75, '2025-2026', 2),  (3, 1, 'Q2', 76, '2025-2026', 2),
-- Ana Lopez (ABM): Fund ABM1, Bus Math, Oral Comm
(4, 30, 'Q1', 89, '2025-2026', 2), (4, 30, 'Q2', 91, '2025-2026', 2),
(4, 33, 'Q1', 87, '2025-2026', 2), (4, 33, 'Q2', 90, '2025-2026', 2),
(4, 1, 'Q1', 85, '2025-2026', 2),  (4, 1, 'Q2', 88, '2025-2026', 2),
-- Carlos Mendoza (ABM)
(5, 30, 'Q1', 76, '2025-2026', 2), (5, 30, 'Q2', 78, '2025-2026', 2),
(5, 33, 'Q1', 74, '2025-2026', 2), (5, 33, 'Q2', 77, '2025-2026', 2),
(5, 1, 'Q1', 79, '2025-2026', 2),  (5, 1, 'Q2', 80, '2025-2026', 2),
-- Sofia Villanueva (HUMSS): World Religions, Creative Writing, Oral Comm
(6, 38, 'Q1', 90, '2025-2026', 2), (6, 38, 'Q2', 92, '2025-2026', 2),
(6, 39, 'Q1', 88, '2025-2026', 2), (6, 39, 'Q2', 91, '2025-2026', 2),
(6, 1, 'Q1', 93, '2025-2026', 2),  (6, 1, 'Q2', 94, '2025-2026', 2),
-- Miguel Aquino (HUMSS)
(7, 38, 'Q1', 77, '2025-2026', 2), (7, 38, 'Q2', 75, '2025-2026', 2),
(7, 39, 'Q1', 79, '2025-2026', 2), (7, 39, 'Q2', 78, '2025-2026', 2),
(7, 1, 'Q1', 76, '2025-2026', 2),  (7, 1, 'Q2', 77, '2025-2026', 2),
-- Isabella Fernandez (G12 STEM)
(8, 4, 'Q1', 95, '2025-2026', 2),  (8, 4, 'Q2', 96, '2025-2026', 2),
(8, 21, 'Q1', 93, '2025-2026', 2), (8, 21, 'Q2', 94, '2025-2026', 2),
(8, 23, 'Q1', 91, '2025-2026', 2), (8, 23, 'Q2', 93, '2025-2026', 2);

INSERT INTO strand_course_mapping (strand_id, course_name, career_pathway) VALUES
(1, 'BS Computer Science', 'Software Development / IT Industry'),
(1, 'BS Information Technology', 'Systems Administration / Web Development'),
(1, 'BS Civil Engineering', 'Construction / Infrastructure'),
(1, 'BS Mechanical Engineering', 'Manufacturing / Automotive'),
(1, 'BS Electrical Engineering', 'Power / Electronics Industry'),
(1, 'BS Nursing', 'Healthcare / Medical'),
(1, 'BS Mathematics', 'Education / Research / Data Science'),
(2, 'BS Accountancy', 'Auditing / Finance'),
(2, 'BS Business Administration', 'Corporate Management / Entrepreneurship'),
(2, 'BS Marketing Management', 'Advertising / Sales / Digital Marketing'),
(2, 'BS Customs Administration', 'Import-Export / Logistics'),
(2, 'BS Hospitality Management', 'Hotel / Restaurant Industry'),
(3, 'BA Communication', 'Media / Journalism / Public Relations'),
(3, 'BA Political Science', 'Law / Government / Diplomacy'),
(3, 'BA Psychology', 'Counseling / Human Resources'),
(3, 'BA Sociology', 'Social Work / Community Development'),
(3, 'AB English', 'Education / Writing / Translation'),
(4, 'Any Bachelor Degree', 'Flexible - Multiple Career Options'),
(5, 'BS Information Technology', 'Web Development / Systems Admin'),
(5, 'BS Computer Science', 'Software Engineering / Programming'),
(6, 'BS Hotel & Restaurant Management', 'Hospitality Industry'),
(6, 'BS Tourism Management', 'Travel / Tourism Industry'),
(7, 'BS Industrial Technology', 'Manufacturing / Technical Work'),
(8, 'BS Physical Education', 'Sports Management / Coaching'),
(8, 'BS Sports Science', 'Athletic Training / Fitness'),
(9, 'BFA Fine Arts', 'Visual Arts / Gallery Management'),
(9, 'BS Multimedia Arts', 'Digital Media / Animation / Graphic Design');

-- ============================================
-- TEST DATA — JHS Students (G7–G10)
-- For testing the Strand Recommendation module
-- ============================================
-- Subject ID reference (JHS subjects inserted first):
--   G7:  1=Eng7, 2=Fil7, 3=Math7, 4=Sci7, 5=AP7, 6=ESP7, 7=MAPEH7, 8=TLE7
--   G8:  9=Eng8, 10=Fil8, 11=Math8, 12=Sci8, 13=AP8, 14=ESP8, 15=MAPEH8, 16=TLE8
--   G9: 17=Eng9, 18=Fil9, 19=Math9, 20=Sci9, 21=AP9, 22=ESP9, 23=MAPEH9, 24=TLE9
--  G10: 25=Eng10,26=Fil10,27=Math10,28=Sci10,29=AP10,30=ESP10,31=MAPEH10,32=TLE10
-- Sections used: IDs 11–14 (new JHS sections added below)
-- Students will be IDs 9–13
-- ============================================

-- JHS Sections (grade_level 7–10, no strand)
INSERT INTO sections (section_name, grade_level, strand, adviser_id, school_year) VALUES
('Rizal',    7,  NULL, 2, '2025-2026'),   -- id: 11
('Bonifacio', 8,  NULL, 3, '2025-2026'),  -- id: 12
('Mabini',   9,  NULL, 4, '2025-2026'),   -- id: 13
('Aguinaldo',10, NULL, 2, '2025-2026');   -- id: 14

-- JHS Test Students (strand_id = NULL for JHS)
-- Profile: diverse academic strengths to produce varied strand recommendations
INSERT INTO students (lrn, first_name, last_name, middle_name, gender, birthdate, section_id, strand_id, school_year) VALUES
-- Strong in Math & Science → expected STEM recommendation
('200200200001', 'Liam',    'Reyes',     'Cruz',    'Male',   '2012-04-10', 11, NULL, '2025-2026'),  -- id: 9  (G7)
-- Strong in TLE & practical subjects → expected TVL recommendation
('200200200002', 'Chloe',   'Santos',    'Lim',     'Female', '2011-07-22', 12, NULL, '2025-2026'),  -- id: 10 (G8)
-- Strong in English, AP, ESP → expected HUMSS recommendation
('200200200003', 'Marco',   'Villanueva','Bautista', 'Male',   '2010-09-15', 13, NULL, '2025-2026'),  -- id: 11 (G9)
-- Balanced/good across all → expected GAS recommendation
('200200200004', 'Sophia',  'Dela Torre','Ramos',   'Female', '2009-11-03', 14, NULL, '2025-2026'),  -- id: 12 (G10)
-- Strong in AP, ESP, TLE → expected ABM or TVL recommendation
('200200200005', 'Nathan',  'Buenaventura','Garcia', 'Male',  '2009-03-18', 14, NULL, '2025-2026');  -- id: 13 (G10)

-- ── Grades: Liam Reyes (G7) — STEM profile (high Math & Science) ─────────────
INSERT INTO grades (student_id, subject_id, quarter, grade, school_year, encoded_by) VALUES
(9, 1,  'Q1', 85, '2025-2026', 2), (9, 1,  'Q2', 86, '2025-2026', 2), (9, 1,  'Q3', 87, '2025-2026', 2), (9, 1,  'Q4', 88, '2025-2026', 2),  -- English 7
(9, 2,  'Q1', 82, '2025-2026', 2), (9, 2,  'Q2', 83, '2025-2026', 2), (9, 2,  'Q3', 84, '2025-2026', 2), (9, 2,  'Q4', 85, '2025-2026', 2),  -- Filipino 7
(9, 3,  'Q1', 93, '2025-2026', 2), (9, 3,  'Q2', 95, '2025-2026', 2), (9, 3,  'Q3', 94, '2025-2026', 2), (9, 3,  'Q4', 96, '2025-2026', 2),  -- Math 7 ★
(9, 4,  'Q1', 91, '2025-2026', 2), (9, 4,  'Q2', 92, '2025-2026', 2), (9, 4,  'Q3', 93, '2025-2026', 2), (9, 4,  'Q4', 95, '2025-2026', 2),  -- Science 7 ★
(9, 5,  'Q1', 80, '2025-2026', 2), (9, 5,  'Q2', 81, '2025-2026', 2), (9, 5,  'Q3', 82, '2025-2026', 2), (9, 5,  'Q4', 83, '2025-2026', 2),  -- AP 7
(9, 6,  'Q1', 84, '2025-2026', 2), (9, 6,  'Q2', 85, '2025-2026', 2), (9, 6,  'Q3', 86, '2025-2026', 2), (9, 6,  'Q4', 87, '2025-2026', 2),  -- ESP 7
(9, 7,  'Q1', 80, '2025-2026', 2), (9, 7,  'Q2', 82, '2025-2026', 2), (9, 7,  'Q3', 83, '2025-2026', 2), (9, 7,  'Q4', 84, '2025-2026', 2),  -- MAPEH 7
(9, 8,  'Q1', 78, '2025-2026', 2), (9, 8,  'Q2', 79, '2025-2026', 2), (9, 8,  'Q3', 80, '2025-2026', 2), (9, 8,  'Q4', 81, '2025-2026', 2);  -- TLE 7

-- ── Grades: Chloe Santos (G8) — TVL profile (high TLE & MAPEH) ───────────────
INSERT INTO grades (student_id, subject_id, quarter, grade, school_year, encoded_by) VALUES
(10, 9,  'Q1', 80, '2025-2026', 2), (10, 9,  'Q2', 81, '2025-2026', 2), (10, 9,  'Q3', 82, '2025-2026', 2), (10, 9,  'Q4', 83, '2025-2026', 2),  -- English 8
(10, 10, 'Q1', 83, '2025-2026', 2), (10, 10, 'Q2', 84, '2025-2026', 2), (10, 10, 'Q3', 85, '2025-2026', 2), (10, 10, 'Q4', 86, '2025-2026', 2),  -- Filipino 8
(10, 11, 'Q1', 72, '2025-2026', 2), (10, 11, 'Q2', 74, '2025-2026', 2), (10, 11, 'Q3', 75, '2025-2026', 2), (10, 11, 'Q4', 76, '2025-2026', 2),  -- Math 8
(10, 12, 'Q1', 74, '2025-2026', 2), (10, 12, 'Q2', 75, '2025-2026', 2), (10, 12, 'Q3', 76, '2025-2026', 2), (10, 12, 'Q4', 77, '2025-2026', 2),  -- Science 8
(10, 13, 'Q1', 82, '2025-2026', 2), (10, 13, 'Q2', 83, '2025-2026', 2), (10, 13, 'Q3', 84, '2025-2026', 2), (10, 13, 'Q4', 85, '2025-2026', 2),  -- AP 8
(10, 14, 'Q1', 85, '2025-2026', 2), (10, 14, 'Q2', 86, '2025-2026', 2), (10, 14, 'Q3', 87, '2025-2026', 2), (10, 14, 'Q4', 88, '2025-2026', 2),  -- ESP 8
(10, 15, 'Q1', 90, '2025-2026', 2), (10, 15, 'Q2', 91, '2025-2026', 2), (10, 15, 'Q3', 92, '2025-2026', 2), (10, 15, 'Q4', 93, '2025-2026', 2),  -- MAPEH 8 ★
(10, 16, 'Q1', 93, '2025-2026', 2), (10, 16, 'Q2', 94, '2025-2026', 2), (10, 16, 'Q3', 95, '2025-2026', 2), (10, 16, 'Q4', 96, '2025-2026', 2);  -- TLE 8 ★

-- ── Grades: Marco Villanueva (G9) — HUMSS profile (high English, AP, ESP) ─────
INSERT INTO grades (student_id, subject_id, quarter, grade, school_year, encoded_by) VALUES
(11, 17, 'Q1', 92, '2025-2026', 2), (11, 17, 'Q2', 93, '2025-2026', 2), (11, 17, 'Q3', 94, '2025-2026', 2), (11, 17, 'Q4', 95, '2025-2026', 2),  -- English 9 ★
(11, 18, 'Q1', 91, '2025-2026', 2), (11, 18, 'Q2', 92, '2025-2026', 2), (11, 18, 'Q3', 93, '2025-2026', 2), (11, 18, 'Q4', 94, '2025-2026', 2),  -- Filipino 9 ★
(11, 19, 'Q1', 75, '2025-2026', 2), (11, 19, 'Q2', 76, '2025-2026', 2), (11, 19, 'Q3', 77, '2025-2026', 2), (11, 19, 'Q4', 78, '2025-2026', 2),  -- Math 9
(11, 20, 'Q1', 76, '2025-2026', 2), (11, 20, 'Q2', 77, '2025-2026', 2), (11, 20, 'Q3', 78, '2025-2026', 2), (11, 20, 'Q4', 79, '2025-2026', 2),  -- Science 9
(11, 21, 'Q1', 93, '2025-2026', 2), (11, 21, 'Q2', 94, '2025-2026', 2), (11, 21, 'Q3', 95, '2025-2026', 2), (11, 21, 'Q4', 96, '2025-2026', 2),  -- AP 9 ★
(11, 22, 'Q1', 90, '2025-2026', 2), (11, 22, 'Q2', 91, '2025-2026', 2), (11, 22, 'Q3', 92, '2025-2026', 2), (11, 22, 'Q4', 93, '2025-2026', 2),  -- ESP 9 ★
(11, 23, 'Q1', 85, '2025-2026', 2), (11, 23, 'Q2', 86, '2025-2026', 2), (11, 23, 'Q3', 87, '2025-2026', 2), (11, 23, 'Q4', 88, '2025-2026', 2),  -- MAPEH 9
(11, 24, 'Q1', 80, '2025-2026', 2), (11, 24, 'Q2', 81, '2025-2026', 2), (11, 24, 'Q3', 82, '2025-2026', 2), (11, 24, 'Q4', 83, '2025-2026', 2);  -- TLE 9

-- ── Grades: Sophia Dela Torre (G10) — GAS/balanced profile ───────────────────
INSERT INTO grades (student_id, subject_id, quarter, grade, school_year, encoded_by) VALUES
(12, 25, 'Q1', 85, '2025-2026', 2), (12, 25, 'Q2', 86, '2025-2026', 2), (12, 25, 'Q3', 87, '2025-2026', 2), (12, 25, 'Q4', 88, '2025-2026', 2),  -- English 10
(12, 26, 'Q1', 84, '2025-2026', 2), (12, 26, 'Q2', 85, '2025-2026', 2), (12, 26, 'Q3', 86, '2025-2026', 2), (12, 26, 'Q4', 87, '2025-2026', 2),  -- Filipino 10
(12, 27, 'Q1', 83, '2025-2026', 2), (12, 27, 'Q2', 84, '2025-2026', 2), (12, 27, 'Q3', 85, '2025-2026', 2), (12, 27, 'Q4', 86, '2025-2026', 2),  -- Math 10
(12, 28, 'Q1', 84, '2025-2026', 2), (12, 28, 'Q2', 85, '2025-2026', 2), (12, 28, 'Q3', 86, '2025-2026', 2), (12, 28, 'Q4', 87, '2025-2026', 2),  -- Science 10
(12, 29, 'Q1', 85, '2025-2026', 2), (12, 29, 'Q2', 86, '2025-2026', 2), (12, 29, 'Q3', 87, '2025-2026', 2), (12, 29, 'Q4', 88, '2025-2026', 2),  -- AP 10
(12, 30, 'Q1', 86, '2025-2026', 2), (12, 30, 'Q2', 87, '2025-2026', 2), (12, 30, 'Q3', 88, '2025-2026', 2), (12, 30, 'Q4', 89, '2025-2026', 2),  -- ESP 10
(12, 31, 'Q1', 83, '2025-2026', 2), (12, 31, 'Q2', 84, '2025-2026', 2), (12, 31, 'Q3', 85, '2025-2026', 2), (12, 31, 'Q4', 86, '2025-2026', 2),  -- MAPEH 10
(12, 32, 'Q1', 84, '2025-2026', 2), (12, 32, 'Q2', 85, '2025-2026', 2), (12, 32, 'Q3', 86, '2025-2026', 2), (12, 32, 'Q4', 87, '2025-2026', 2);  -- TLE 10

-- ── Grades: Nathan Buenaventura (G10) — ABM/TVL profile (high AP, TLE) ────────
INSERT INTO grades (student_id, subject_id, quarter, grade, school_year, encoded_by) VALUES
(13, 25, 'Q1', 80, '2025-2026', 2), (13, 25, 'Q2', 81, '2025-2026', 2), (13, 25, 'Q3', 82, '2025-2026', 2), (13, 25, 'Q4', 83, '2025-2026', 2),  -- English 10
(13, 26, 'Q1', 82, '2025-2026', 2), (13, 26, 'Q2', 83, '2025-2026', 2), (13, 26, 'Q3', 84, '2025-2026', 2), (13, 26, 'Q4', 85, '2025-2026', 2),  -- Filipino 10
(13, 27, 'Q1', 78, '2025-2026', 2), (13, 27, 'Q2', 79, '2025-2026', 2), (13, 27, 'Q3', 80, '2025-2026', 2), (13, 27, 'Q4', 81, '2025-2026', 2),  -- Math 10
(13, 28, 'Q1', 76, '2025-2026', 2), (13, 28, 'Q2', 77, '2025-2026', 2), (13, 28, 'Q3', 78, '2025-2026', 2), (13, 28, 'Q4', 79, '2025-2026', 2),  -- Science 10
(13, 29, 'Q1', 89, '2025-2026', 2), (13, 29, 'Q2', 90, '2025-2026', 2), (13, 29, 'Q3', 91, '2025-2026', 2), (13, 29, 'Q4', 92, '2025-2026', 2),  -- AP 10 ★
(13, 30, 'Q1', 87, '2025-2026', 2), (13, 30, 'Q2', 88, '2025-2026', 2), (13, 30, 'Q3', 89, '2025-2026', 2), (13, 30, 'Q4', 90, '2025-2026', 2),  -- ESP 10 ★
(13, 31, 'Q1', 82, '2025-2026', 2), (13, 31, 'Q2', 83, '2025-2026', 2), (13, 31, 'Q3', 84, '2025-2026', 2), (13, 31, 'Q4', 85, '2025-2026', 2),  -- MAPEH 10
(13, 32, 'Q1', 92, '2025-2026', 2), (13, 32, 'Q2', 93, '2025-2026', 2), (13, 32, 'Q3', 94, '2025-2026', 2), (13, 32, 'Q4', 95, '2025-2026', 2);  -- TLE 10 ★

-- Non-academic indicators for JHS test students
INSERT INTO non_academic_indicators (student_id, skills, hobbies, family_background, annual_income, entrance_exam_score) VALUES
(9,  'coding, robotics, math problem solving',         'science fair, programming, gadgets',            'father is an engineer, mother is a nurse',               '300k_500k',  88.50),
(10, 'cooking, sewing, handicrafts',                   'baking, crafts, cooking experiments, gardening', 'family runs a small eatery, mother is a dressmaker',     '100k_300k',  76.00),
(11, 'creative writing, public speaking, debating',    'reading, journalism, theater, social media',     'parents are both teachers, community-oriented family',   '300k_500k',  85.00),
(12, 'drawing, music, research, organizing',           'painting, playing guitar, reading, volunteering','parents have mixed occupations, well-rounded background', '100k_300k',  80.00),
(13, 'selling, negotiating, organizing events',        'business, trading, basketball, cooking',         'family has a small business, father is an OFW',          '100k_300k',  79.50);
