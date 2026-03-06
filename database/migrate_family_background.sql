-- Migration: Replace family_background with structured Father/Mother fields
-- Run this if you have an existing database with the old schema

USE steps_db;

ALTER TABLE non_academic_indicators
    ADD COLUMN father_fullname VARCHAR(100) AFTER hobbies,
    ADD COLUMN father_occupation VARCHAR(100) AFTER father_fullname,
    ADD COLUMN mother_fullname VARCHAR(100) AFTER father_occupation,
    ADD COLUMN mother_occupation VARCHAR(100) AFTER mother_fullname,
    DROP COLUMN family_background;
