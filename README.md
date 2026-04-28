# STEPS

System for Tracking Educational Progress of Students with Career Evaluation.

## Overview

STEPS is a PHP and MySQL web application for managing student records, tracking academic progress, and supporting career evaluation workflows in a school setting.

Main capabilities include:
- Student profile and grade management
- Competency and employability evaluation support
- Career recommendation modules
- Work immersion tracking
- Section and user management
- Academic and performance reporting

## Tech Stack

- PHP 8.2+
- MySQL 8+
- HTML/CSS/JavaScript
- Tailwind CSS (CDN)
- SweetAlert2 (CDN)

## Project Structure

- `auth/` - Login/logout and authentication pages
- `dashboard/` - Main dashboard
- `students/` - Student and grade management
- `career/` - Career evaluation and recommendation views
- `reports/` - Report generation and exports
- `admin/` - System settings, maintenance, and admin tools
- `config/` - Database and application constants
- `database/` - SQL schema and migration files
- `assets/` - CSS, JS, images, and templates

## Requirements

1. WAMP/XAMPP/LAMP stack with Apache and MySQL running
2. PHP PDO MySQL extension enabled
3. A MySQL database user with access to create/import `steps_db`

## Local Setup

1. Place/clone this project inside your web root (example: `C:/wamp64/www/STEPS`).
2. Create a database named `steps_db` in phpMyAdmin (or MySQL CLI).
3. Import `database/steps_db.sql` into `steps_db`.
4. Open `config/database.php` and confirm your DB credentials:
   - Host: `localhost`
   - Database: `steps_db`
   - User: `root`
   - Password: `` (empty by default in local WAMP installs)
5. Start Apache and MySQL.
6. Open the app in your browser:
   - `http://localhost/STEPS/`

## Default Login (Seed Data)

The SQL seed includes sample users such as:
- `admin`
- `teacher_santos`
- `teacher_delos_reyes`
- `teacher_cruz`
- `guidance_reyes`
- `guidance_mendoza`

All seeded passwords use the same bcrypt hash commonly mapped to `password`.

For safety, change default credentials immediately after first login.

## Configuration Notes

- Base URL and app constants are in `config/constants.php`.
- School year and grading thresholds can be adjusted through admin settings.
- Runtime settings are loaded from the `system_settings` table.

## Database

- Main schema dump: `database/steps_db.sql`
- Additional incremental SQL updates: `database/migrations/`

If you are upgrading an existing installation, apply migration files in order after backing up your database.

## Security and Deployment Notes

- Do not use default/local DB credentials in production.
- Use HTTPS and secure session settings in production.
- Restrict access to backup and admin endpoints at the server level.
- Keep PHP, MySQL, and dependencies updated.

## License

No license file is currently included in this repository. Add a license if you plan to distribute this project publicly.
