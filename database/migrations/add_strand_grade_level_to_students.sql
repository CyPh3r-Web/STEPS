-- Migration: Add strand and grade_level columns to students table
-- This allows storing strand code and grade level directly from import
-- Date: 2026-04-10

ALTER TABLE `students` 
ADD COLUMN `strand` VARCHAR(50) NULL COMMENT 'Strand code (e.g., STEM, ABM, HUMSS)' AFTER `strand_id`,
ADD COLUMN `grade_level` INT NULL COMMENT 'Grade level (11 or 12 for SHS)' AFTER `strand`;

-- Add index for grade_level filtering
ALTER TABLE `students` ADD INDEX `idx_grade_level` (`grade_level`);
