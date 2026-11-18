-- ====================================================================
-- QUIZTRACK DATABASE SCHEMA (PostgreSQL 17)
-- Architecture: Relational, 3NF Normalized
-- ====================================================================

-- Clean up existing tables in reverse dependency order
DROP TABLE IF EXISTS notifications CASCADE;
DROP TABLE IF EXISTS results CASCADE;
DROP TABLE IF EXISTS proctor_interventions CASCADE;
DROP TABLE IF EXISTS activity_logs CASCADE;
DROP TABLE IF EXISTS student_answer_options CASCADE;
DROP TABLE IF EXISTS student_answers CASCADE;
DROP TABLE IF EXISTS quiz_attempts CASCADE;
DROP TABLE IF EXISTS quiz_assignments CASCADE;
DROP TABLE IF EXISTS quiz_questions CASCADE;
DROP TABLE IF EXISTS question_options CASCADE;
DROP TABLE IF EXISTS questions CASCADE;
DROP TABLE IF EXISTS quizzes CASCADE;
DROP TABLE IF EXISTS cohort_students CASCADE;
DROP TABLE IF EXISTS cohorts CASCADE;
DROP TABLE IF EXISTS courses CASCADE;
DROP TABLE IF EXISTS subjects CASCADE;
DROP TABLE IF EXISTS users CASCADE;
DROP TABLE IF EXISTS roles CASCADE;

-- 1. ROLES
CREATE TABLE roles (
    role_id SERIAL PRIMARY KEY,
    role_name VARCHAR(50) UNIQUE NOT NULL, -- 'ADMIN', 'TEACHER', 'STUDENT'
    description TEXT
);

-- 2. USERS
CREATE TABLE users (
    user_id SERIAL PRIMARY KEY,
    identifier VARCHAR(100) UNIQUE NOT NULL, -- Student Roll Number (e.g. CS-2022-041) or Employee ID
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    full_name VARCHAR(150) NOT NULL,
    role_id INT NOT NULL REFERENCES roles(role_id) ON DELETE RESTRICT,
    department VARCHAR(100),
    cohort VARCHAR(50),                     -- e.g. 'Class of 2026', 'Section A'
    biometric_consent BOOLEAN DEFAULT FALSE,
    status VARCHAR(20) DEFAULT 'ACTIVE' CHECK (status IN ('ACTIVE', 'INACTIVE', 'SUSPENDED', 'PENDING')),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_users_identifier ON users(identifier);
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_role_id ON users(role_id);

-- 3. SUBJECTS
CREATE TABLE subjects (
    subject_id SERIAL PRIMARY KEY,
    subject_code VARCHAR(50) UNIQUE NOT NULL, -- e.g. 'CS402'
    subject_name VARCHAR(200) NOT NULL,        -- e.g. 'Distributed Systems & Concurrency'
    department VARCHAR(100) NOT NULL,
    description TEXT,
    created_by INT REFERENCES users(user_id) ON DELETE SET NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_subjects_code ON subjects(subject_code);

-- 4. COURSES
CREATE TABLE courses (
    course_id SERIAL PRIMARY KEY,
    course_code VARCHAR(50) UNIQUE NOT NULL,
    course_name VARCHAR(200) NOT NULL,
    department VARCHAR(100) NOT NULL,
    credits INT DEFAULT 3,
    description TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 5. CLASSES / COHORTS
CREATE TABLE cohorts (
    cohort_id SERIAL PRIMARY KEY,
    cohort_name VARCHAR(100) NOT NULL,         -- e.g. 'CS Senior Cohort 2026'
    department VARCHAR(100) NOT NULL,
    academic_year VARCHAR(20) NOT NULL,        -- e.g. '2024-2026'
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE cohort_students (
    cohort_id INT NOT NULL REFERENCES cohorts(cohort_id) ON DELETE CASCADE,
    student_id INT NOT NULL REFERENCES users(user_id) ON DELETE CASCADE,
    enrolled_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (cohort_id, student_id)
);

-- 6. QUIZZES
CREATE TABLE quizzes (
    quiz_id SERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    subject_id INT NOT NULL REFERENCES subjects(subject_id) ON DELETE CASCADE,
    teacher_id INT NOT NULL REFERENCES users(user_id) ON DELETE RESTRICT,
    duration_minutes INT NOT NULL CHECK (duration_minutes > 0),
    total_marks DECIMAL(6, 2) NOT NULL DEFAULT 100.00,
    pass_percentage DECIMAL(5, 2) NOT NULL DEFAULT 40.00,
    negative_marking BOOLEAN DEFAULT FALSE,
    negative_mark_value DECIMAL(4, 2) DEFAULT 0.00,
    max_tab_switches INT DEFAULT 3,
    fullscreen_required BOOLEAN DEFAULT TRUE,
    webcam_required BOOLEAN DEFAULT TRUE,
    shuffle_questions BOOLEAN DEFAULT FALSE,
    start_time TIMESTAMP WITH TIME ZONE,
    end_time TIMESTAMP WITH TIME ZONE,
    status VARCHAR(20) DEFAULT 'DRAFT' CHECK (status IN ('DRAFT', 'SCHEDULED', 'ACTIVE', 'COMPLETED', 'ARCHIVED')),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_quizzes_subject ON quizzes(subject_id);
CREATE INDEX idx_quizzes_teacher ON quizzes(teacher_id);
CREATE INDEX idx_quizzes_status ON quizzes(status);

-- 7. QUESTIONS (QUESTION BANK & QUIZ ASSIGNED)
CREATE TABLE questions (
    question_id SERIAL PRIMARY KEY,
    quiz_id INT REFERENCES quizzes(quiz_id) ON DELETE CASCADE, -- NULL if standalone item in Question Bank
    subject_id INT NOT NULL REFERENCES subjects(subject_id) ON DELETE CASCADE,
    question_text TEXT NOT NULL,
    question_type VARCHAR(30) DEFAULT 'SINGLE_CHOICE' CHECK (question_type IN ('SINGLE_CHOICE', 'MULTI_CHOICE', 'TRUE_FALSE')),
    points DECIMAL(5, 2) NOT NULL DEFAULT 1.00,
    difficulty_level VARCHAR(20) DEFAULT 'MEDIUM' CHECK (difficulty_level IN ('EASY', 'MEDIUM', 'HARD')),
    taxonomy_topic VARCHAR(100), -- e.g. 'Consensus Protocols', 'Logical Clocks & Ordering'
    explanation TEXT,
    code_snippet TEXT,
    created_by INT REFERENCES users(user_id) ON DELETE SET NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_questions_quiz ON questions(quiz_id);
CREATE INDEX idx_questions_subject ON questions(subject_id);
CREATE INDEX idx_questions_difficulty ON questions(difficulty_level);

-- 8. QUESTION OPTIONS
CREATE TABLE question_options (
    option_id SERIAL PRIMARY KEY,
    question_id INT NOT NULL REFERENCES questions(question_id) ON DELETE CASCADE,
    option_letter CHAR(1) NOT NULL, -- 'A', 'B', 'C', 'D'
    option_text TEXT NOT NULL,
    is_correct BOOLEAN DEFAULT FALSE,
    sort_order INT DEFAULT 1,
    CONSTRAINT uq_question_option UNIQUE (question_id, option_letter)
);

CREATE INDEX idx_question_options_q ON question_options(question_id);

-- 9. QUIZ QUESTIONS (MANY-TO-MANY JOIN TABLE FOR QUIZ MEMBERSHIP & REUSE)
CREATE TABLE quiz_questions (
    quiz_id INT NOT NULL REFERENCES quizzes(quiz_id) ON DELETE CASCADE,
    question_id INT NOT NULL REFERENCES questions(question_id) ON DELETE CASCADE,
    sort_order INT DEFAULT 1,
    points_override DECIMAL(5, 2),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (quiz_id, question_id)
);

CREATE INDEX idx_quiz_questions_quiz ON quiz_questions(quiz_id);
CREATE INDEX idx_quiz_questions_question ON quiz_questions(question_id);

-- 10. QUIZ ASSIGNMENTS
CREATE TABLE quiz_assignments (
    assignment_id SERIAL PRIMARY KEY,
    quiz_id INT NOT NULL REFERENCES quizzes(quiz_id) ON DELETE CASCADE,
    cohort_id INT REFERENCES cohorts(cohort_id) ON DELETE CASCADE,
    student_id INT REFERENCES users(user_id) ON DELETE CASCADE,
    assigned_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    due_at TIMESTAMP WITH TIME ZONE
);

CREATE INDEX idx_quiz_assignments_quiz ON quiz_assignments(quiz_id);
CREATE INDEX idx_quiz_assignments_cohort ON quiz_assignments(cohort_id);
CREATE INDEX idx_quiz_assignments_student ON quiz_assignments(student_id);

-- 10. QUIZ ATTEMPTS (STUDENT EXAM SESSIONS)
CREATE TABLE quiz_attempts (
    attempt_id SERIAL PRIMARY KEY,
    quiz_id INT NOT NULL REFERENCES quizzes(quiz_id) ON DELETE CASCADE,
    student_id INT NOT NULL REFERENCES users(user_id) ON DELETE CASCADE,
    start_time TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    end_time TIMESTAMP WITH TIME ZONE,
    status VARCHAR(30) DEFAULT 'IN_PROGRESS' CHECK (status IN ('IN_PROGRESS', 'SUBMITTED', 'PAUSED', 'TERMINATED', 'FLAGGED')),
    total_score DECIMAL(6, 2) DEFAULT 0.00,
    percentage DECIMAL(5, 2) DEFAULT 0.00,
    grade VARCHAR(10),
    passed BOOLEAN DEFAULT FALSE,
    tab_switch_count INT DEFAULT 0,
    blur_count INT DEFAULT 0,
    fullscreen_exit_count INT DEFAULT 0,
    integrity_index DECIMAL(5, 2) DEFAULT 100.00,
    ip_address VARCHAR(50),
    user_agent TEXT,
    is_flagged BOOLEAN DEFAULT FALSE,
    flag_reason TEXT,
    flagged_by INT REFERENCES users(user_id) ON DELETE SET NULL,
    flagged_at TIMESTAMP WITH TIME ZONE,
    CONSTRAINT uq_student_active_attempt UNIQUE (quiz_id, student_id, start_time)
);

CREATE INDEX idx_quiz_attempts_student ON quiz_attempts(student_id);
CREATE INDEX idx_quiz_attempts_quiz ON quiz_attempts(quiz_id);
CREATE INDEX idx_quiz_attempts_status ON quiz_attempts(status);

-- 11. STUDENT ANSWERS (AUTOSAVED DURING EXAM)
CREATE TABLE student_answers (
    answer_id SERIAL PRIMARY KEY,
    attempt_id INT NOT NULL REFERENCES quiz_attempts(attempt_id) ON DELETE CASCADE,
    question_id INT NOT NULL REFERENCES questions(question_id) ON DELETE CASCADE,
    selected_option_id INT REFERENCES question_options(option_id) ON DELETE SET NULL,
    text_response TEXT,
    is_flagged_for_review BOOLEAN DEFAULT FALSE,
    is_correct BOOLEAN,
    marks_awarded DECIMAL(5, 2) DEFAULT 0.00,
    answered_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    last_updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT uq_attempt_question UNIQUE (attempt_id, question_id)
);

CREATE INDEX idx_student_answers_attempt ON student_answers(attempt_id);
CREATE INDEX idx_student_answers_question ON student_answers(question_id);

-- 11b. MULTI-ANSWER SELECTIONS (JOIN TABLE FOR MULTI-CHOICE QUESTIONS)
CREATE TABLE student_answer_options (
    answer_id INT NOT NULL REFERENCES student_answers(answer_id) ON DELETE CASCADE,
    option_id INT NOT NULL REFERENCES question_options(option_id) ON DELETE CASCADE,
    PRIMARY KEY (answer_id, option_id)
);

CREATE INDEX idx_student_answer_options_ans ON student_answer_options(answer_id);
CREATE INDEX idx_student_answer_options_opt ON student_answer_options(option_id);

-- 12. PROCTORING & TELEMETRY ACTIVITY LOGS
CREATE TABLE activity_logs (
    log_id SERIAL PRIMARY KEY,
    attempt_id INT REFERENCES quiz_attempts(attempt_id) ON DELETE CASCADE,
    user_id INT NOT NULL REFERENCES users(user_id) ON DELETE CASCADE,
    event_type VARCHAR(50) NOT NULL, -- 'TAB_SWITCH', 'FULLSCREEN_EXIT', 'FOCUS_LOST', 'AUDIO_ANOMALY', 'WEBCAM_DISCONNECT', 'HEARTBEAT'
    severity VARCHAR(20) DEFAULT 'INFO' CHECK (severity IN ('INFO', 'CAUTION', 'CRITICAL')),
    details TEXT,
    event_timestamp TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    is_reviewed BOOLEAN DEFAULT FALSE,
    reviewed_by INT REFERENCES users(user_id) ON DELETE SET NULL,
    reviewed_at TIMESTAMP WITH TIME ZONE,
    review_notes TEXT,
    target_user_id INT REFERENCES users(user_id) ON DELETE SET NULL,
    ip_address VARCHAR(45)
);

CREATE INDEX idx_activity_logs_attempt ON activity_logs(attempt_id);
CREATE INDEX idx_activity_logs_type ON activity_logs(event_type);
CREATE INDEX idx_activity_logs_time ON activity_logs(event_timestamp);
CREATE INDEX idx_activity_logs_target_user ON activity_logs(target_user_id);

-- 13. PROCTOR INTERVENTIONS (TEACHER LIVE ACTIONS & AUDIT TRAIL)
CREATE TABLE proctor_interventions (
    intervention_id SERIAL PRIMARY KEY,
    attempt_id INT NOT NULL REFERENCES quiz_attempts(attempt_id) ON DELETE CASCADE,
    teacher_id INT NOT NULL REFERENCES users(user_id) ON DELETE RESTRICT,
    action_type VARCHAR(50) NOT NULL CHECK (action_type IN ('WARNING', 'PAUSE', 'RESUME', 'TERMINATE', 'MANUAL_SUBMIT', 'FLAG', 'CLEAR_FLAG', 'REVIEW', 'NOTE', 'BROADCAST')),
    message TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_interventions_attempt ON proctor_interventions(attempt_id);

-- 14. RESULTS & VERIFIED DIGITAL CERTIFICATES
CREATE TABLE results (
    result_id SERIAL PRIMARY KEY,
    attempt_id INT UNIQUE NOT NULL REFERENCES quiz_attempts(attempt_id) ON DELETE CASCADE,
    student_id INT NOT NULL REFERENCES users(user_id) ON DELETE CASCADE,
    quiz_id INT NOT NULL REFERENCES quizzes(quiz_id) ON DELETE CASCADE,
    score DECIMAL(6, 2) NOT NULL,
    max_score DECIMAL(6, 2) NOT NULL,
    percentage DECIMAL(5, 2) NOT NULL,
    grade VARCHAR(10) NOT NULL,
    cohort_rank INT,
    cohort_percentile DECIMAL(5, 2),
    certificate_hash VARCHAR(128) UNIQUE, -- SHA-256 cryptographic verification token
    certified_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_results_student ON results(student_id);
CREATE INDEX idx_results_quiz ON results(quiz_id);
CREATE INDEX idx_results_hash ON results(certificate_hash);

-- 15. NOTIFICATIONS
CREATE TABLE notifications (
    notification_id SERIAL PRIMARY KEY,
    user_id INT NOT NULL REFERENCES users(user_id) ON DELETE CASCADE,
    title VARCHAR(150) NOT NULL,
    message TEXT NOT NULL,
    type VARCHAR(30) DEFAULT 'INFO' CHECK (type IN ('INFO', 'WARNING', 'ALERT', 'EXAM')),
    is_read BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_notifications_user ON notifications(user_id);

-- 16. SYSTEM CONFIGURATION & SETTINGS
CREATE TABLE system_settings (
    setting_key VARCHAR(100) PRIMARY KEY,
    setting_value TEXT NOT NULL,
    setting_group VARCHAR(50) DEFAULT 'GENERAL',
    data_type VARCHAR(20) DEFAULT 'STRING', -- 'STRING', 'INTEGER', 'BOOLEAN', 'DECIMAL'
    description TEXT,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_by INT REFERENCES users(user_id) ON DELETE SET NULL
);
