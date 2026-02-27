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
    strand_id INT,
    subject_type ENUM('core', 'specialized', 'applied', 'immersion') NOT NULL DEFAULT 'core',
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
-- WORK IMMERSION TABLE
-- ============================================
CREATE TABLE IF NOT EXISTS work_immersion (
    id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT NOT NULL,
    company_name VARCHAR(150),
    rating DECIMAL(5,2) NOT NULL,
    hours_completed INT DEFAULT 0,
    performance_remarks TEXT,
    school_year VARCHAR(20) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (student_id) REFERENCES students(id) ON DELETE CASCADE
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
-- CAREER RECOMMENDATIONS TABLE
-- ============================================
CREATE TABLE IF NOT EXISTS career_recommendations (
    id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT NOT NULL,
    recommended_strand VARCHAR(100),
    recommended_courses TEXT,
    employability_score DECIMAL(5,2),
    employability_level ENUM('low', 'moderate', 'high', 'very_high') NOT NULL DEFAULT 'moderate',
    strand_match TINYINT(1) DEFAULT 1,
    mismatch_remarks TEXT,
    career_pathways TEXT,
    generated_by INT,
    school_year VARCHAR(20) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
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

INSERT INTO subjects (subject_code, subject_name, strand_id, subject_type) VALUES
-- Core Subjects (shared across all strands)
('CORE01', 'Oral Communication', NULL, 'core'),
('CORE02', 'Reading and Writing', NULL, 'core'),
('CORE03', 'Komunikasyon at Pananaliksik', NULL, 'core'),
('CORE04', 'General Mathematics', NULL, 'core'),
('CORE05', 'Earth and Life Science', NULL, 'core'),
('CORE06', 'Physical Science', NULL, 'core'),
('CORE07', 'Personal Development', NULL, 'core'),
('CORE08', 'Understanding Culture, Society, and Politics', NULL, 'core'),
('CORE09', 'Introduction to Philosophy', NULL, 'core'),
('CORE10', 'Physical Education and Health', NULL, 'core'),
('CORE11', 'Media and Information Literacy', NULL, 'core'),
('CORE12', '21st Century Literature from the Philippines and the World', NULL, 'core'),
('CORE13', 'Contemporary Philippine Arts from the Regions', NULL, 'core'),
-- Applied Subjects
('APP01', 'English for Academic and Professional Purposes', NULL, 'applied'),
('APP02', 'Practical Research 1', NULL, 'applied'),
('APP03', 'Practical Research 2', NULL, 'applied'),
('APP04', 'Filipino sa Piling Larangan', NULL, 'applied'),
('APP05', 'Empowerment Technologies', NULL, 'applied'),
('APP06', 'Entrepreneurship', NULL, 'applied'),
('APP07', 'Inquiries, Investigations, and Immersion', NULL, 'applied'),
-- STEM Specialized Subjects
('STEM01', 'Pre-Calculus', 1, 'specialized'),
('STEM02', 'Basic Calculus', 1, 'specialized'),
('STEM03', 'General Biology 1', 1, 'specialized'),
('STEM04', 'General Biology 2', 1, 'specialized'),
('STEM05', 'General Chemistry 1', 1, 'specialized'),
('STEM06', 'General Chemistry 2', 1, 'specialized'),
('STEM07', 'General Physics 1', 1, 'specialized'),
('STEM08', 'General Physics 2', 1, 'specialized'),
('STEM09', 'Research/Capstone Project', 1, 'specialized'),
-- ABM Specialized Subjects
('ABM01', 'Fundamentals of ABM 1', 2, 'specialized'),
('ABM02', 'Fundamentals of ABM 2', 2, 'specialized'),
('ABM03', 'Business Mathematics', 2, 'specialized'),
('ABM04', 'Business Finance', 2, 'specialized'),
('ABM05', 'Organization and Management', 2, 'specialized'),
('ABM06', 'Principles of Marketing', 2, 'specialized'),
('ABM07', 'Business Ethics and Social Responsibility', 2, 'specialized'),
('ABM08', 'Applied Economics', 2, 'specialized'),
-- HUMSS Specialized Subjects
('HUM01', 'Introduction to World Religions', 3, 'specialized'),
('HUM02', 'Creative Writing', 3, 'specialized'),
('HUM03', 'Creative Nonfiction', 3, 'specialized'),
('HUM04', 'Trends, Networks, and Critical Thinking', 3, 'specialized'),
('HUM05', 'Philippine Politics and Governance', 3, 'specialized'),
('HUM06', 'Community Engagement', 3, 'specialized'),
('HUM07', 'Disciplines and Ideas in Social Sciences', 3, 'specialized'),
-- GAS Specialized Subjects
('GAS01', 'Humanities 1', 4, 'specialized'),
('GAS02', 'Humanities 2', 4, 'specialized'),
('GAS03', 'Social Science 1', 4, 'specialized'),
('GAS04', 'Applied Economics', 4, 'specialized'),
('GAS05', 'Organization and Management', 4, 'specialized'),
('GAS06', 'Disaster Readiness and Risk Reduction', 4, 'specialized'),
-- TVL-ICT Specialized Subjects
('ICT01', 'Computer Systems Servicing NC II', 5, 'specialized'),
('ICT02', 'Computer Programming', 5, 'specialized'),
('ICT03', 'Web Development', 5, 'specialized'),
('ICT04', 'Illustration and Animation', 5, 'specialized'),
-- Work Immersion
('WI101', 'Work Immersion', NULL, 'immersion');

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

INSERT INTO work_immersion (student_id, company_name, rating, hours_completed, performance_remarks, school_year) VALUES
(1, 'Tech Solutions Inc.', 88.5, 320, 'Good performance in technical tasks', '2025-2026'),
(2, 'Tech Solutions Inc.', 75.0, 300, 'Needs improvement in initiative', '2025-2026'),
(3, 'DataCore Systems', 70.5, 280, 'Below average performance', '2025-2026'),
(4, 'BusinessFirst Corp.', 91.0, 320, 'Excellent business acumen', '2025-2026'),
(5, 'BusinessFirst Corp.', 77.0, 310, 'Average performance', '2025-2026'),
(6, 'Community Center', 93.0, 320, 'Outstanding communication skills', '2025-2026'),
(7, 'Community Center', 76.0, 290, 'Satisfactory performance', '2025-2026'),
(8, 'InnoTech Labs', 95.0, 320, 'Exceptional technical ability', '2025-2026');

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
