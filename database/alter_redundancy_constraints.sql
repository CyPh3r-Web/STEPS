-- Apply on existing steps_db databases (not needed for fresh import of steps_db.sql).
-- Run in MySQL/phpMyAdmin against steps_db. If a step fails due to duplicates, run the
-- matching DELETE block first, then retry that ALTER.

USE steps_db;

-- Subjects: one row per subject code (matches subjects/index.php)
ALTER TABLE subjects ADD UNIQUE KEY unique_subject_code (subject_code);

-- Sections: one row per section name + grade + school year (matches sections/index.php)
ALTER TABLE sections ADD UNIQUE KEY unique_section (section_name, grade_level, school_year);

-- Competency snapshots: at most one per student, subject, school year
-- DELETE duplicates first if needed:
-- DELETE c1 FROM competency_records c1
-- INNER JOIN competency_records c2 ON c1.student_id = c2.student_id AND c1.subject_id = c2.subject_id AND c1.school_year = c2.school_year AND c1.id < c2.id;
ALTER TABLE competency_records ADD UNIQUE KEY unique_competency (student_id, subject_id, school_year);

-- Strand–course mapping: no duplicate course name per strand
-- DELETE duplicates first if needed:
-- DELETE m1 FROM strand_course_mapping m1
-- INNER JOIN strand_course_mapping m2 ON m1.strand_id = m2.strand_id AND m1.course_name = m2.course_name AND m1.id < m2.id;
ALTER TABLE strand_course_mapping ADD UNIQUE KEY unique_strand_course (strand_id, course_name);

-- Career recommendations: one active row per student, type, school year (matches career/student.php delete-then-insert)
-- DELETE duplicates first if needed (keeps newest id):
DELETE cr1 FROM career_recommendations cr1
INNER JOIN career_recommendations cr2
  ON cr1.student_id = cr2.student_id
  AND cr1.recommendation_type = cr2.recommendation_type
  AND cr1.school_year = cr2.school_year
  AND cr1.id < cr2.id;
ALTER TABLE career_recommendations ADD UNIQUE KEY unique_career_rec (student_id, recommendation_type, school_year);

-- Work immersion table (if created manually without schema file)
CREATE TABLE IF NOT EXISTS work_immersion (
    id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT NOT NULL,
    company_name VARCHAR(150),
    rating DECIMAL(5,2) NOT NULL,
    hours_completed INT NOT NULL DEFAULT 0,
    performance_remarks TEXT,
    school_year VARCHAR(20) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (student_id) REFERENCES students(id) ON DELETE CASCADE,
    UNIQUE KEY unique_work_immersion_student_year (student_id, school_year)
) ENGINE=InnoDB;

-- If work_immersion already existed without UNIQUE, dedupe then:
-- DELETE w1 FROM work_immersion w1 INNER JOIN work_immersion w2 ON w1.student_id = w2.student_id AND w1.school_year = w2.school_year AND w1.id < w2.id;
-- ALTER TABLE work_immersion ADD UNIQUE KEY unique_work_immersion_student_year (student_id, school_year);
