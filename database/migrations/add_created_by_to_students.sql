-- Migration: Add created_by column to students table for teacher data isolation
-- Run this SQL if you already have an existing database without the created_by column
-- Date: 2026-01-15

-- Add created_by column to students table
ALTER TABLE `students` 
ADD COLUMN `created_by` int DEFAULT NULL COMMENT 'User ID who created this student record' AFTER `status`,
ADD KEY `created_by` (`created_by`);

-- Optional: Add foreign key constraint (uncomment if you want strict referential integrity)
-- ALTER TABLE `students` 
-- ADD CONSTRAINT `fk_students_created_by` 
-- FOREIGN KEY (`created_by`) REFERENCES `users` (`id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- Update existing students to assign them to teachers based on their section's adviser
-- This assigns students to the teacher who advises their section
UPDATE students s
JOIN sections sec ON s.section_id = sec.id
SET s.created_by = sec.adviser_id
WHERE sec.adviser_id IS NOT NULL AND s.created_by IS NULL;

-- Note: Students without a section or whose section has no adviser will have created_by = NULL
-- These students will be visible to all users (guidance, admin) but not isolated to any teacher
-- You may want to manually assign these students or have teachers re-add them
