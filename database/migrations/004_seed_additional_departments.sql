-- Seed additional departmental faculty, students, and courses
INSERT INTO users (identifier, email, password_hash, full_name, role_id, department, cohort, status)
VALUES 
('nikola.tesla', 'nikola.tesla@university.edu', '$2a$10$rHUjRnY4DyV0iq1xi3CWZuRyGUDP3/NBtDg2.nYN5/OriNnHy//X.', 'Prof. Nikola Tesla', 2, 'Electrical Engineering', 'Faculty', 'ACTIVE'),
('EE-2022-001', 'ben.franklin@university.edu', '$2a$10$rHUjRnY4DyV0iq1xi3CWZuRyGUDP3/NBtDg2.nYN5/OriNnHy//X.', 'Benjamin Franklin', 3, 'Electrical Engineering', 'Class of 2026', 'ACTIVE'),
('EE-2022-002', 'michael.faraday@university.edu', '$2a$10$rHUjRnY4DyV0iq1xi3CWZuRyGUDP3/NBtDg2.nYN5/OriNnHy//X.', 'Michael Faraday', 3, 'Electrical Engineering', 'Class of 2026', 'ACTIVE'),
('ada.lovelace', 'ada.lovelace@university.edu', '$2a$10$rHUjRnY4DyV0iq1xi3CWZuRyGUDP3/NBtDg2.nYN5/OriNnHy//X.', 'Dr. Ada Lovelace', 2, 'Mathematics', 'Faculty', 'ACTIVE'),
('MATH-2022-001', 'alan.turing@university.edu', '$2a$10$rHUjRnY4DyV0iq1xi3CWZuRyGUDP3/NBtDg2.nYN5/OriNnHy//X.', 'Alan Turing', 3, 'Mathematics', 'Class of 2026', 'ACTIVE'),
('MATH-2022-002', 'carl.gauss@university.edu', '$2a$10$rHUjRnY4DyV0iq1xi3CWZuRyGUDP3/NBtDg2.nYN5/OriNnHy//X.', 'Carl Gauss', 3, 'Mathematics', 'Class of 2026', 'ACTIVE')
ON CONFLICT (identifier) DO NOTHING;

-- Seed cohorts for Electrical Engineering and Mathematics
INSERT INTO cohorts (cohort_name, department, academic_year)
VALUES
('EE Senior Cohort 2026', 'Electrical Engineering', '2025-2026'),
('MATH Senior Cohort 2026', 'Mathematics', '2025-2026')
ON CONFLICT DO NOTHING;
