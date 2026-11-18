-- ====================================================================
-- QUIZTRACK SEED DATA (PostgreSQL 17)
-- All default passwords are: password123
-- BCrypt Hash: $2a$10$rHUjRnY4DyV0iq1xi3CWZuRyGUDP3/NBtDg2.nYN5/OriNnHy//X.
-- ====================================================================

-- 1. ROLES
INSERT INTO roles (role_id, role_name, description) VALUES
(1, 'ADMIN', 'System Administrator with full access to accounts, subjects and system logs'),
(2, 'TEACHER', 'Faculty instructor who authors quizzes, sets proctoring rules, and monitors live exams'),
(3, 'STUDENT', 'Enrolled candidate who takes exams, views results, and tracks cohort standing')
ON CONFLICT (role_name) DO NOTHING;

-- 2. USERS
-- Admin
INSERT INTO users (user_id, identifier, email, password_hash, full_name, role_id, department, cohort, status)
VALUES (1, 'admin', 'admin@quiztrack.edu', '$2a$10$rHUjRnY4DyV0iq1xi3CWZuRyGUDP3/NBtDg2.nYN5/OriNnHy//X.', 'System Administrator', 1, 'Administration', 'Staff', 'ACTIVE')
ON CONFLICT (identifier) DO NOTHING;

-- Teachers
INSERT INTO users (user_id, identifier, email, password_hash, full_name, role_id, department, cohort, status)
VALUES 
(2, 'ronald.vance', 'ronald.vance@university.edu', '$2a$10$rHUjRnY4DyV0iq1xi3CWZuRyGUDP3/NBtDg2.nYN5/OriNnHy//X.', 'Prof. Ronald Vance', 2, 'Computer Science', 'Faculty', 'ACTIVE'),
(3, 'clara.oswald', 'clara.oswald@university.edu', '$2a$10$rHUjRnY4DyV0iq1xi3CWZuRyGUDP3/NBtDg2.nYN5/OriNnHy//X.', 'Dr. Clara Oswald', 2, 'Computer Science', 'Faculty', 'ACTIVE')
ON CONFLICT (identifier) DO NOTHING;

-- Students (matching Stitch screens)
INSERT INTO users (user_id, identifier, email, password_hash, full_name, role_id, department, cohort, biometric_consent, status)
VALUES 
(4, 'CS-2022-041', 'alex.mercer@university.edu', '$2a$10$rHUjRnY4DyV0iq1xi3CWZuRyGUDP3/NBtDg2.nYN5/OriNnHy//X.', 'Alex Mercer', 3, 'Computer Science', 'Class of 2026', TRUE, 'ACTIVE'),
(5, 'CS-2022-028', 'jordan.lee@university.edu', '$2a$10$rHUjRnY4DyV0iq1xi3CWZuRyGUDP3/NBtDg2.nYN5/OriNnHy//X.', 'Jordan Lee', 3, 'Computer Science', 'Class of 2026', TRUE, 'ACTIVE'),
(6, 'CS-2022-019', 'elena.rostova@university.edu', '$2a$10$rHUjRnY4DyV0iq1xi3CWZuRyGUDP3/NBtDg2.nYN5/OriNnHy//X.', 'Elena Rostova', 3, 'Computer Science', 'Class of 2026', TRUE, 'ACTIVE'),
(7, 'CS-2022-012', 'marcus.chen@university.edu', '$2a$10$rHUjRnY4DyV0iq1xi3CWZuRyGUDP3/NBtDg2.nYN5/OriNnHy//X.', 'Marcus Chen', 3, 'Computer Science', 'Class of 2026', TRUE, 'ACTIVE'),
(8, 'CS-2022-033', 'priya.sharma@university.edu', '$2a$10$rHUjRnY4DyV0iq1xi3CWZuRyGUDP3/NBtDg2.nYN5/OriNnHy//X.', 'Priya Sharma', 3, 'Computer Science', 'Class of 2026', TRUE, 'ACTIVE'),
(9, 'CS-2022-005', 'jordan.vance@university.edu', '$2a$10$rHUjRnY4DyV0iq1xi3CWZuRyGUDP3/NBtDg2.nYN5/OriNnHy//X.', 'Jordan Vance', 3, 'Computer Science', 'Class of 2026', TRUE, 'ACTIVE')
ON CONFLICT (identifier) DO NOTHING;

-- Seed additional departmental faculty and students
INSERT INTO users (identifier, email, password_hash, full_name, role_id, department, cohort, status)
VALUES 
('nikola.tesla', 'nikola.tesla@university.edu', '$2a$10$rHUjRnY4DyV0iq1xi3CWZuRyGUDP3/NBtDg2.nYN5/OriNnHy//X.', 'Prof. Nikola Tesla', 2, 'Electrical Engineering', 'Faculty', 'ACTIVE'),
('EE-2022-001', 'ben.franklin@university.edu', '$2a$10$rHUjRnY4DyV0iq1xi3CWZuRyGUDP3/NBtDg2.nYN5/OriNnHy//X.', 'Benjamin Franklin', 3, 'Electrical Engineering', 'Class of 2026', 'ACTIVE'),
('EE-2022-002', 'michael.faraday@university.edu', '$2a$10$rHUjRnY4DyV0iq1xi3CWZuRyGUDP3/NBtDg2.nYN5/OriNnHy//X.', 'Michael Faraday', 3, 'Electrical Engineering', 'Class of 2026', 'ACTIVE'),
('ada.lovelace', 'ada.lovelace@university.edu', '$2a$10$rHUjRnY4DyV0iq1xi3CWZuRyGUDP3/NBtDg2.nYN5/OriNnHy//X.', 'Dr. Ada Lovelace', 2, 'Mathematics', 'Faculty', 'ACTIVE'),
('MATH-2022-001', 'alan.turing@university.edu', '$2a$10$rHUjRnY4DyV0iq1xi3CWZuRyGUDP3/NBtDg2.nYN5/OriNnHy//X.', 'Alan Turing', 3, 'Mathematics', 'Class of 2026', 'ACTIVE'),
('MATH-2022-002', 'carl.gauss@university.edu', '$2a$10$rHUjRnY4DyV0iq1xi3CWZuRyGUDP3/NBtDg2.nYN5/OriNnHy//X.', 'Carl Gauss', 3, 'Mathematics', 'Class of 2026', 'ACTIVE')
ON CONFLICT (identifier) DO NOTHING;

-- Reset users sequence
SELECT setval('users_user_id_seq', (SELECT MAX(user_id) FROM users));

-- 3. SUBJECTS
INSERT INTO subjects (subject_id, subject_code, subject_name, department, description, created_by)
VALUES 
(1, 'CS402', 'Distributed Systems & Concurrency', 'Computer Science', 'Consensus protocols, Raft, Paxos, Vector Clocks, Byzantine fault tolerance, and CAP theorem', 2),
(2, 'CS301', 'Advanced Data Structures & Algorithms', 'Computer Science', 'B-trees, Red-Black Trees, amortized complexity, and graph algorithms', 2),
(3, 'MATH210', 'Discrete Probability & Stochastic Processes', 'Mathematics', 'Markov chains, Poisson processes, Bayesian inference, and randomized algorithms', 3),
(4, 'CS505', 'Cloud Infrastructure & Kubernetes Architecture', 'Computer Science', 'Container orchestration, etcd clusters, service mesh, and distributed storage', 2),
(5, 'CS490', 'Software Engineering Ethics, Governance & AI Law', 'Computer Science', 'Algorithmic accountability, IP law, privacy regulations, and responsible computing', 3)
ON CONFLICT (subject_code) DO NOTHING;

SELECT setval('subjects_subject_id_seq', (SELECT MAX(subject_id) FROM subjects));

-- 4. COURSES
INSERT INTO courses (course_id, course_code, course_name, department, credits, description)
VALUES 
(1, 'CS402-C', 'B.Tech Computer Science Core Course CS402', 'Computer Science', 4, 'Full semester distributed computing course'),
(2, 'CS301-C', 'Data Structures Specialization', 'Computer Science', 4, 'Algorithmic problem solving and data structures')
ON CONFLICT (course_code) DO NOTHING;

SELECT setval('courses_course_id_seq', (SELECT MAX(course_id) FROM courses));

-- 5. COHORTS
INSERT INTO cohorts (cohort_id, cohort_name, department, academic_year)
VALUES 
(1, 'CS Senior Cohort 2026', 'Computer Science', '2025-2026')
ON CONFLICT DO NOTHING;

SELECT setval('cohorts_cohort_id_seq', (SELECT MAX(cohort_id) FROM cohorts));

-- Enrol students in cohort
INSERT INTO cohort_students (cohort_id, student_id)
VALUES 
(1, 4), (1, 5), (1, 6), (1, 7), (1, 8), (1, 9)
ON CONFLICT DO NOTHING;

-- 6. QUIZZES
INSERT INTO quizzes (
    quiz_id, title, description, subject_id, teacher_id, duration_minutes, total_marks, pass_percentage,
    negative_marking, negative_mark_value, max_tab_switches, fullscreen_required, webcam_required,
    shuffle_questions, start_time, end_time, status
)
VALUES 
(1, 'CS402: Midterm Exam - Distributed Systems & Concurrency', 
 'Covers Consensus Protocols, Logical Clocks, Byzantine Fault Tolerance, and Replicated State Machines.',
 1, 2, 90, 140.00, 35.00, TRUE, 1.00, 3, TRUE, TRUE, FALSE,
 CURRENT_TIMESTAMP - INTERVAL '1 hour', CURRENT_TIMESTAMP + INTERVAL '3 days', 'ACTIVE'),

(2, 'CS505: Cloud Infrastructure & Kubernetes Architecture Quiz',
 'Covers Pod lifecycle, etcd quorum, Ingress controllers, and CNI networking.',
 4, 2, 45, 50.00, 40.00, FALSE, 0.00, 2, TRUE, TRUE, FALSE,
 CURRENT_TIMESTAMP + INTERVAL '2 days', CURRENT_TIMESTAMP + INTERVAL '5 days', 'SCHEDULED'),

(3, 'CS490: Software Engineering Ethics, Governance & AI Law',
 'Assesses algorithmic fairness, privacy laws (GDPR/HIPAA), and autonomous agents liability.',
 5, 3, 60, 75.00, 40.00, FALSE, 0.00, 3, TRUE, FALSE, FALSE,
 CURRENT_TIMESTAMP + INTERVAL '4 days', CURRENT_TIMESTAMP + INTERVAL '7 days', 'SCHEDULED')
ON CONFLICT DO NOTHING;

SELECT setval('quizzes_quiz_id_seq', (SELECT MAX(quiz_id) FROM quizzes));

-- 7. QUESTIONS (for Quiz 1 - CS402 Midterm Exam)
INSERT INTO questions (question_id, quiz_id, subject_id, question_text, question_type, points, difficulty_level, taxonomy_topic, explanation, code_snippet, created_by)
VALUES 
(1, 1, 1, 
 'In a Raft consensus cluster with 5 nodes, if node S1 is the leader and experiences a network partition with nodes S2 and S3, which subset of nodes can successfully elect a new leader and commit new log entries?',
 'SINGLE_CHOICE', 4.00, 'HARD', 'Consensus Protocols',
 'In a 5-node Raft cluster, a majority quorum requires at least ceil((5+1)/2) = 3 nodes. Partition {S2, S3, S5} contains 3 nodes and therefore holds the quorum needed to elect a leader and commit log entries.',
 '// Node Cluster Topology:
// [S1(Leader)] ----x---- [S2]
//      |           x      |
//     [S4]        x     [S3]
//                  x
//                 [S5]', 2),

(2, 1, 1,
 'Under Lamport''s Logical Clocks, if event a occurs before event b in the same process, which relationship is guaranteed to hold for their respective timestamps L(a) and L(b)?',
 'SINGLE_CHOICE', 3.00, 'MEDIUM', 'Logical Clocks & Ordering',
 'The Clock Condition states that if a -> b (a happens before b), then L(a) < L(b). Note that the converse does not necessarily hold for scalar Lamport clocks, which is why Vector Clocks are required for causal precedence.',
 NULL, 2),

(3, 1, 1,
 'In the Paxos consensus algorithm, what does Phase 1b (Promise) guarantee to the Proposer?',
 'SINGLE_CHOICE', 4.00, 'HARD', 'Consensus Protocols',
 'Acceptors promise never to accept any future proposals with a proposal number less than n, and return the proposal with the highest number less than n that they have already accepted, if any.',
 NULL, 2),

(4, 1, 1,
 'What is the minimum number of total nodes required in a distributed system to safely tolerate f Byzantine failures under synchronous or asynchronous consensus?',
 'SINGLE_CHOICE', 3.00, 'MEDIUM', 'Byzantine Fault Tolerance',
 'Lamport, Shostak, and Pease proved that at least 3f + 1 nodes are strictly required to tolerate f Byzantine faulty nodes without cryptographic signatures.',
 NULL, 2),

(5, 1, 1,
 'In a distributed database governed by the CAP theorem, when a network partition occurs, what trade-off must the system architecture choose between?',
 'SINGLE_CHOICE', 3.00, 'EASY', 'Distributed Storage & CAP',
 'Under network partitioning (P), a distributed system must sacrifice either Consistency (C) to remain available, or Availability (A) to guarantee absolute consistency across all reachable nodes.',
 NULL, 2)
ON CONFLICT DO NOTHING;

SELECT setval('questions_question_id_seq', (SELECT MAX(question_id) FROM questions));

-- 8. QUESTION OPTIONS
-- Question 1 Options
INSERT INTO question_options (question_id, option_letter, option_text, is_correct, sort_order) VALUES
(1, 'A', 'Partition {S1, S4} because S1 was already the designated leader', FALSE, 1),
(1, 'B', 'Partition {S2, S3, S5} because it contains a majority quorum of 3 out of 5 nodes', TRUE, 2),
(1, 'C', 'Both partitions concurrently using dual-lease terms', FALSE, 3),
(1, 'D', 'Neither partition can proceed until the network heal is detected', FALSE, 4)
ON CONFLICT (question_id, option_letter) DO NOTHING;

-- Question 2 Options
INSERT INTO question_options (question_id, option_letter, option_text, is_correct, sort_order) VALUES
(2, 'A', 'L(a) > L(b)', FALSE, 1),
(2, 'B', 'L(a) == L(b)', FALSE, 2),
(2, 'C', 'L(a) < L(b)', TRUE, 3),
(2, 'D', 'L(a) and L(b) are mathematically incomparable', FALSE, 4)
ON CONFLICT (question_id, option_letter) DO NOTHING;

-- Question 3 Options
INSERT INTO question_options (question_id, option_letter, option_text, is_correct, sort_order) VALUES
(3, 'A', 'The acceptor immediately commits the value proposed', FALSE, 1),
(3, 'B', 'The acceptor promises not to accept proposals numbered less than n and returns highest accepted proposal', TRUE, 2),
(3, 'C', 'The acceptor rejects all subsequent client transactions', FALSE, 3),
(3, 'D', 'The acceptor promotes itself to learner', FALSE, 4)
ON CONFLICT (question_id, option_letter) DO NOTHING;

-- Question 4 Options
INSERT INTO question_options (question_id, option_letter, option_text, is_correct, sort_order) VALUES
(4, 'A', '2f + 1 nodes', FALSE, 1),
(4, 'B', '3f + 1 nodes', TRUE, 2),
(4, 'C', 'f + 1 nodes', FALSE, 3),
(4, 'D', '4f + 1 nodes', FALSE, 4)
ON CONFLICT (question_id, option_letter) DO NOTHING;

-- Question 5 Options
INSERT INTO question_options (question_id, option_letter, option_text, is_correct, sort_order) VALUES
(5, 'A', 'Consistency and Availability', TRUE, 1),
(5, 'B', 'Latency and Throughput', FALSE, 2),
(5, 'C', 'Security and Encryption', FALSE, 3),
(5, 'D', 'Durability and Atomicity', FALSE, 4)
ON CONFLICT (question_id, option_letter) DO NOTHING;

-- 8b. QUIZ QUESTIONS (MEMBER QUESTIONS)
INSERT INTO quiz_questions (quiz_id, question_id, sort_order, points_override) VALUES
(1, 1, 1, 4.00),
(1, 2, 2, 4.00),
(1, 3, 3, 4.00),
(1, 4, 4, 4.00),
(1, 5, 5, 4.00),
(2, 6, 1, 5.00),
(2, 7, 2, 5.00),
(3, 8, 1, 5.00),
(3, 9, 2, 5.00)
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- 9. QUIZ ASSIGNMENTS
INSERT INTO quiz_assignments (quiz_id, cohort_id, student_id, due_at) VALUES
(1, 1, 4, CURRENT_TIMESTAMP + INTERVAL '3 days'),
(1, 1, 5, CURRENT_TIMESTAMP + INTERVAL '3 days'),
(1, 1, 6, CURRENT_TIMESTAMP + INTERVAL '3 days'),
(1, 1, 7, CURRENT_TIMESTAMP + INTERVAL '3 days'),
(1, 1, 8, CURRENT_TIMESTAMP + INTERVAL '3 days'),
(1, 1, 9, CURRENT_TIMESTAMP + INTERVAL '3 days'),
(2, 1, 4, CURRENT_TIMESTAMP + INTERVAL '1 day'),
(3, 1, 4, CURRENT_TIMESTAMP + INTERVAL '4 days')
ON CONFLICT DO NOTHING;

-- 10. COMPLETED ATTEMPTS & RESULTS (Cohort Standings matching Stitch Leaderboard)
INSERT INTO quiz_attempts (
    attempt_id, quiz_id, student_id, start_time, end_time, status, total_score, percentage, grade,
    passed, tab_switch_count, blur_count, fullscreen_exit_count, integrity_index, ip_address, user_agent
)
VALUES 
    (1, 1, 4, CURRENT_TIMESTAMP - INTERVAL '2 hours', CURRENT_TIMESTAMP - INTERVAL '40 minutes',
     'SUBMITTED', 118.00, 84.28, 'Grade A', TRUE, 0, 0, 0, 99.10, '192.168.1.104', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64)'),
    (2, 1, 8, CURRENT_TIMESTAMP - INTERVAL '3 hours', CURRENT_TIMESTAMP - INTERVAL '2 hours 21 minutes 40 seconds',
     'SUBMITTED', 136.00, 97.14, 'Grade A', TRUE, 0, 0, 0, 99.80, '192.168.1.108', 'Mozilla/5.0'),
    (3, 1, 7, CURRENT_TIMESTAMP - INTERVAL '3 hours', CURRENT_TIMESTAMP - INTERVAL '2 hours 18 minutes 45 seconds',
     'SUBMITTED', 128.00, 91.43, 'Grade A', TRUE, 0, 0, 0, 99.40, '192.168.1.107', 'Mozilla/5.0'),
    (4, 1, 9, CURRENT_TIMESTAMP - INTERVAL '3 hours', CURRENT_TIMESTAMP - INTERVAL '2 hours 11 minutes 30 seconds',
     'SUBMITTED', 106.00, 75.71, 'Grade B', TRUE, 1, 0, 0, 97.50, '192.168.1.109', 'Mozilla/5.0'),
    (5, 1, 5, CURRENT_TIMESTAMP - INTERVAL '3 hours', CURRENT_TIMESTAMP - INTERVAL '2 hours 4 minutes 50 seconds',
     'SUBMITTED', 48.00, 34.29, 'Grade F', FALSE, 4, 2, 1, 82.00, '192.168.1.105', 'Mozilla/5.0')
ON CONFLICT (attempt_id) DO NOTHING;

SELECT setval('quiz_attempts_attempt_id_seq', (SELECT GREATEST(MAX(attempt_id), 10) FROM quiz_attempts));

-- Result records with cryptographic certificate hashes for eligible examinees
INSERT INTO results (
    result_id, attempt_id, student_id, quiz_id, score, max_score, percentage, grade,
    cohort_rank, cohort_percentile, certificate_hash
)
VALUES 
    (1, 1, 4, 1, 118.00, 140.00, 84.28, 'Grade A', 3, 94.20,
     'e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855'),
    (2, 2, 8, 1, 136.00, 140.00, 97.14, 'Grade A', 1, 99.00,
     'a1b2c3d4e5f67890123456789abcdef0123456789abcdef0123456789abcdef0'),
    (3, 3, 7, 1, 128.00, 140.00, 91.43, 'Grade A', 2, 96.50,
     'b2c3d4e5f67890123456789abcdef0123456789abcdef0123456789abcdef01'),
    (4, 4, 9, 1, 106.00, 140.00, 75.71, 'Grade B', 4, 82.00,
     'c3d4e5f67890123456789abcdef0123456789abcdef0123456789abcdef012'),
    (5, 5, 5, 1, 48.00, 140.00, 34.29, 'Grade F', 5, 20.00,
     NULL)
ON CONFLICT (attempt_id) DO NOTHING;

SELECT setval('results_result_id_seq', (SELECT GREATEST(MAX(result_id), 10) FROM results));

-- 11. SAMPLE NOTIFICATIONS
INSERT INTO notifications (user_id, title, message, type) VALUES
(4, 'Exam Ready: CS402 Midterm', 'CS402: Midterm Exam - Distributed Systems & Concurrency is now live. Complete your pre-flight check.', 'EXAM'),
(4, 'Transcript Ready', 'Official transcript for CS402 Midterm is now certified. Rank #3 achieved with 94.2 percentile.', 'INFO'),
(2, 'Proctor Alert: Active Session', '42 students currently active in CS402 Midterm Examination.', 'INFO');

-- 12. DEPARTMENTAL QUESTION BANK REPOSITORY (Stitch Referenced Items)
INSERT INTO questions (question_id, quiz_id, subject_id, question_text, question_type, points, difficulty_level, taxonomy_topic, explanation, code_snippet, created_by)
VALUES 
(6, NULL, 1, 
 'Under which coordinator failure circumstance does the classic Two-Phase Commit protocol incur synchronous blocking indefinitely?',
 'SINGLE_CHOICE', 4.00, 'MEDIUM', '2-Phase Commit',
 'If the coordinator crashes after sending Prepare but before broadcasting Global-Commit/Abort, participants who voted Yes must block indefinitely until the coordinator recovers.',
 NULL, 2),

(7, NULL, 1,
 'Given two timestamps V(a) and V(b) in an N-node system, which condition confirms that event A causally preceded event B?',
 'SINGLE_CHOICE', 3.00, 'EASY', 'Vector Clocks',
 'Event a -> b if and only if for all i, V(a)[i] <= V(b)[i] and there exists at least one component j where V(a)[j] < V(b)[j].',
 NULL, 2),

(8, NULL, 1,
 'In PACELC theorem, what does the system trade off in the absence of a network partition?',
 'SINGLE_CHOICE', 4.00, 'HARD', 'CAP Theorem',
 'In PACELC (If Partition: Availability or Consistency; Else: Latency or Consistency), when operating normally without partition, the architecture trades off between Latency (L) and Consistency (C).',
 NULL, 2),

(9, NULL, 1,
 'What is the minimum number of total nodes required to tolerate m Byzantine nodes in an unauthenticated message passing system?',
 'SINGLE_CHOICE', 4.00, 'HARD', 'Byzantine Generals',
 'Under the classic Byzantine Generals proof by Lamport, Shostak, and Pease, at least 3m + 1 nodes are strictly necessary.',
 NULL, 2)
ON CONFLICT DO NOTHING;

SELECT setval('questions_question_id_seq', (SELECT MAX(question_id) FROM questions));

-- Options for Question 6 (2-Phase Commit)
INSERT INTO question_options (question_id, option_letter, option_text, is_correct, sort_order) VALUES
(6, 'A', 'When all participants vote Abort simultaneously', FALSE, 1),
(6, 'B', 'When the coordinator crashes during Phase 2 after participants commit their local prepare state', TRUE, 2),
(6, 'C', 'When network latency exceeds TCP round-trip timeout', FALSE, 3),
(6, 'D', 'When a single participant sends a spurious negative acknowledgement', FALSE, 4)
ON CONFLICT DO NOTHING;

-- Options for Question 7 (Vector Clocks)
INSERT INTO question_options (question_id, option_letter, option_text, is_correct, sort_order) VALUES
(7, 'A', 'V(a)[i] <= V(b)[i] for all i and exists j such that V(a)[j] < V(b)[j]', TRUE, 1),
(7, 'B', 'Sum of all vector components in V(a) is strictly greater than V(b)', FALSE, 2),
(7, 'C', 'Only the coordinator clock timestamp incremented', FALSE, 3),
(7, 'D', 'Scalar wall-clock timestamps are strictly equal', FALSE, 4)
ON CONFLICT DO NOTHING;

-- Options for Question 8 (PACELC)
INSERT INTO question_options (question_id, option_letter, option_text, is_correct, sort_order) VALUES
(8, 'A', 'Throughput versus Fault Tolerance', FALSE, 1),
(8, 'B', 'Latency versus Consistency', TRUE, 2),
(8, 'C', 'Durability versus Atomicity', FALSE, 3),
(8, 'D', 'Encryption overhead versus Bandwidth', FALSE, 4)
ON CONFLICT DO NOTHING;

-- Options for Question 9 (Byzantine Generals)
INSERT INTO question_options (question_id, option_letter, option_text, is_correct, sort_order) VALUES
(9, 'A', '2m + 1 nodes', FALSE, 1),
(9, 'B', '3m + 1 nodes', TRUE, 2),
(9, 'C', 'm + 1 nodes', FALSE, 3),
(9, 'D', '4m nodes', FALSE, 4)
ON CONFLICT DO NOTHING;

-- 12b. COMPREHENSIVE QUESTION BANK (20 Items across all 5 Academic Disciplines)
INSERT INTO questions (question_id, quiz_id, subject_id, question_text, question_type, points, difficulty_level, taxonomy_topic, explanation, created_by)
VALUES 
(11, NULL, 1, 'In the Raft consensus algorithm, what state does a node transition to when an election timeout elapses without receiving heartbeats?', 'SINGLE_CHOICE', 3.00, 'MEDIUM', 'Consensus Protocols', 'When a follower election timer expires without receiving an AppendEntries RPC heartbeat from a valid leader, it transitions to Candidate state.', 2),
(12, NULL, 1, 'Which guarantees are provided by Vector Clocks that scalar Lamport timestamps cannot provide?', 'MULTI_CHOICE', 4.00, 'HARD', 'Logical Clocks & Ordering', 'Vector clocks can detect whether two events are causally related (a -> b) or concurrent (a || b). Scalar Lamport clocks cannot distinguish concurrency.', 2),
(13, NULL, 1, 'True or False: In a Byzantine fault tolerance model, signatures can prevent a traitor node from forging false messages under synchronous communications.', 'TRUE_FALSE', 2.00, 'EASY', 'Byzantine Fault Tolerance', 'Cryptographic digital signatures provide authentication and non-repudiation, preventing traitor generals from forging messages.', 2),
(14, NULL, 1, 'Under the CAP Theorem, which database architectures prioritize Availability and Partition Tolerance (AP) over strict Consistency?', 'MULTI_CHOICE', 4.00, 'MEDIUM', 'Distributed Storage & CAP', 'DynamoDB and Apache Cassandra are classical examples of AP systems utilizing eventual consistency and vector versioning.', 2),
(15, NULL, 2, 'What is the worst-case search time complexity in a Red-Black Tree with n nodes?', 'SINGLE_CHOICE', 3.00, 'MEDIUM', 'Balanced Trees', 'A Red-Black Tree maintains height logarithmic in n (h <= 2 * log2(n + 1)), ensuring worst-case search is O(log n).', 2),
(16, NULL, 2, 'Which of the following properties are strictly required for a valid Red-Black Tree?', 'MULTI_CHOICE', 4.00, 'HARD', 'Balanced Trees', 'Properties: Root is black, every leaf (NIL) is black, if a node is red then both its children are black, and all paths from a node to descendant leaves contain the same number of black nodes.', 2),
(17, NULL, 2, 'True or False: Dijkstra''s shortest path algorithm correctly computes shortest paths in graphs with negative weight edges.', 'TRUE_FALSE', 2.00, 'EASY', 'Graph Theory', 'Dijkstra assumes edge weights are non-negative. Bellman-Ford or Floyd-Warshall must be used when negative edges exist.', 2),
(18, NULL, 2, 'What is the amortized time complexity of an insert operation into a dynamic array that doubles in capacity when full?', 'SINGLE_CHOICE', 3.00, 'MEDIUM', 'Amortized Analysis', 'Doubling capacity costs O(n) rarely, but amortized over n insertions, each append costs O(1) amortized time.', 2),
(19, NULL, 3, 'In a discrete-time Markov Chain, what property guarantees that transition probabilities depend solely on the current state?', 'SINGLE_CHOICE', 3.00, 'MEDIUM', 'Markov Chains', 'The Markov Property states that P(X_{n+1} = j | X_n = i, ..., X_0 = i_0) = P(X_{n+1} = j | X_n = i).', 3),
(20, NULL, 3, 'Which conditions are necessary for a Markov chain to possess a unique stationary distribution?', 'MULTI_CHOICE', 4.00, 'HARD', 'Markov Chains', 'An irreducible, positive recurrent, and aperiodic Markov chain has a unique limiting stationary distribution.', 3),
(21, NULL, 3, 'True or False: The Poisson distribution can be derived as a limiting case of the Binomial distribution when n -> infinity and p -> 0 with lambda = np constant.', 'TRUE_FALSE', 2.00, 'EASY', 'Poisson Distribution', 'This is the Law of Rare Events (Poisson Limit Theorem).', 3),
(22, NULL, 3, 'If X ~ Exp(lambda), what is the memoryless property represented mathematically?', 'SINGLE_CHOICE', 3.00, 'MEDIUM', 'Exponential Distribution', 'P(X > s + t | X > s) = P(X > t) for all s, t >= 0.', 3),
(23, NULL, 4, 'Which Kubernetes component acts as the distributed key-value datastore for all cluster state and configurations?', 'SINGLE_CHOICE', 3.00, 'EASY', 'Kubernetes Core', 'etcd is the strongly consistent, distributed key-value store used as Kubernetes backing store.', 2),
(24, NULL, 4, 'Which mechanisms does Kubernetes use to ensure container health and automatic self-healing?', 'MULTI_CHOICE', 4.00, 'MEDIUM', 'Container Probes', 'Kubernetes provides Liveness probes (restarts container on failure), Readiness probes (gates traffic), and Startup probes (protects slow initialization).', 2),
(25, NULL, 4, 'True or False: A Kubernetes ClusterIP service is accessible directly from outside the physical cluster network by external clients without an Ingress or NodePort.', 'TRUE_FALSE', 2.00, 'EASY', 'Kubernetes Networking', 'ClusterIP only exposes the Service on an internal cluster-routable IP, reachable only from within the cluster.', 2),
(26, NULL, 4, 'What is the role of the Container Network Interface (CNI) in Kubernetes?', 'SINGLE_CHOICE', 3.00, 'MEDIUM', 'Kubernetes Networking', 'CNI plugins (e.g. Calico, Flannel, Cilium) allocate IP addresses to Pods and configure network routing across cluster nodes.', 2),
(27, NULL, 5, 'Under the EU AI Act, which risk category is assigned to AI systems deployed for biometric categorisation and emotion recognition in workplaces and educational institutions?', 'SINGLE_CHOICE', 3.00, 'MEDIUM', 'AI Governance & Law', 'Biometric categorisation and emotion recognition in employment or education are classified as High-Risk (or Prohibited in sensitive scenarios) with stringent conformity assessments.', 3),
(28, NULL, 5, 'Under the GDPR, what fundamental rights do data subjects hold regarding automated individual decision-making and profiling (Article 22)?', 'MULTI_CHOICE', 4.00, 'HARD', 'Data Privacy Regulations', 'Data subjects have the right not to be subject to a decision based solely on automated processing having legal effects, the right to obtain human intervention, and the right to contest the decision.', 3),
(29, NULL, 5, 'True or False: An open-source software license under MIT allows third-party commercial redistribution without requiring the source code of modifications to be made public.', 'TRUE_FALSE', 2.00, 'EASY', 'Intellectual Property Law', 'The MIT license is a permissive license that does not impose copyleft obligations (unlike GPL).', 3),
(30, NULL, 5, 'In algorithmic fairness, what metric ensures that the proportion of positive classification outcomes is identical across all demographic sub-populations?', 'SINGLE_CHOICE', 3.00, 'MEDIUM', 'Algorithmic Fairness', 'Demographic Parity (Statistical Parity) requires P(Y_hat = 1 | A = 0) = P(Y_hat = 1 | A = 1).', 3)
ON CONFLICT (question_id) DO NOTHING;

INSERT INTO question_options (question_id, option_letter, option_text, is_correct, sort_order) VALUES
(11, 'A', 'Candidate', TRUE, 1), (11, 'B', 'Leader', FALSE, 2), (11, 'C', 'Observer', FALSE, 3), (11, 'D', 'Pre-Vote Terminated', FALSE, 4),
(12, 'A', 'Detection of concurrent event execution', TRUE, 1), (12, 'B', 'Exact physical clock wall-time synchronization', FALSE, 2), (12, 'C', 'Exact causal precedence identification', TRUE, 3), (12, 'D', 'Zero-latency broadcast delivery', FALSE, 4),
(13, 'A', 'True', TRUE, 1), (13, 'B', 'False', FALSE, 2),
(14, 'A', 'Apache Cassandra', TRUE, 1), (14, 'B', 'Amazon DynamoDB (Default eventual consistency mode)', TRUE, 2), (14, 'C', 'Google Spanner (TrueTime synchronized)', FALSE, 3), (14, 'D', 'PostgreSQL with synchronous replication', FALSE, 4),
(15, 'A', 'O(1)', FALSE, 1), (15, 'B', 'O(log n)', TRUE, 2), (15, 'C', 'O(n)', FALSE, 3), (15, 'D', 'O(n log n)', FALSE, 4),
(16, 'A', 'The root node is always Black', TRUE, 1), (16, 'B', 'No two consecutive Red nodes appear on any path', TRUE, 2), (16, 'C', 'Every path from a node to NIL leaves has the same black-height', TRUE, 3), (16, 'D', 'Every Red node must have exactly two Red children', FALSE, 4),
(17, 'A', 'True', FALSE, 1), (17, 'B', 'False', TRUE, 2),
(18, 'A', 'O(n)', FALSE, 1), (18, 'B', 'O(log n)', FALSE, 2), (18, 'C', 'O(1) amortized', TRUE, 3), (18, 'D', 'O(n^2)', FALSE, 4),
(19, 'A', 'Memoryless / Markov Property', TRUE, 1), (19, 'B', 'Central Limit Theorem', FALSE, 2), (19, 'C', 'Martingale Equality', FALSE, 3), (19, 'D', 'Bayesian Conjugacy', FALSE, 4),
(20, 'A', 'Irreducibility (all states communicate)', TRUE, 1), (20, 'B', 'Positive Recurrence (finite expected return time)', TRUE, 2), (20, 'C', 'Aperiodicity', TRUE, 3), (20, 'D', 'Absorbing boundary conditions on all states', FALSE, 4),
(21, 'A', 'True', TRUE, 1), (21, 'B', 'False', FALSE, 2),
(22, 'A', 'P(X > s + t | X > s) = P(X > t)', TRUE, 1), (22, 'B', 'P(X > s + t) = P(X > s) * P(X > t)', FALSE, 2), (22, 'C', 'E[X | X > s] = E[X] - s', FALSE, 3), (22, 'D', 'Var(X | X > s) = 0', FALSE, 4),
(23, 'A', 'etcd', TRUE, 1), (23, 'B', 'kube-proxy', FALSE, 2), (23, 'C', 'CoreDNS', FALSE, 3), (23, 'D', 'kube-apiserver cache', FALSE, 4),
(24, 'A', 'Liveness Probes', TRUE, 1), (24, 'B', 'Readiness Probes', TRUE, 2), (24, 'C', 'Startup Probes', TRUE, 3), (24, 'D', 'Static IP Leasing', FALSE, 4),
(25, 'A', 'True', FALSE, 1), (25, 'B', 'False', TRUE, 2),
(26, 'A', 'Allocates IP addresses to pods and routes inter-pod cluster traffic', TRUE, 1), (26, 'B', 'Compiles Dockerfiles into OCI images', FALSE, 2), (26, 'C', 'Provides persistent block storage mounts', FALSE, 3), (26, 'D', 'Enforces kernel cgroups CPU quotas', FALSE, 4),
(27, 'A', 'High Risk', TRUE, 1), (27, 'B', 'Minimal / Low Risk', FALSE, 2), (27, 'C', 'Voluntary Code of Practice only', FALSE, 3), (27, 'D', 'Unregulated Tier', FALSE, 4),
(28, 'A', 'Right to obtain human intervention on the decision', TRUE, 1), (28, 'B', 'Right to express one''s point of view and contest the decision', TRUE, 2), (28, 'C', 'Right to receive meaningful information about the algorithmic logic involved', TRUE, 3), (28, 'D', 'Right to immediate monetary statutory damages upon any automated computation', FALSE, 4),
(29, 'A', 'True', TRUE, 1), (29, 'B', 'False', FALSE, 2),
(30, 'A', 'Demographic Parity (Statistical Parity)', TRUE, 1), (30, 'B', 'Equalized Odds', FALSE, 2), (30, 'C', 'Predictive Rate Parity', FALSE, 3), (30, 'D', 'Calibration within Groups', FALSE, 4)
ON CONFLICT (question_id, option_letter) DO NOTHING;

SELECT setval('questions_question_id_seq', (SELECT GREATEST(COALESCE(MAX(question_id), 0), 30) FROM questions));

-- 13. SYSTEM SETTINGS
INSERT INTO system_settings (setting_key, setting_value, setting_group, data_type, description)
VALUES 
('app_name', 'QuizTrack Online Examination Platform', 'GENERAL', 'STRING', 'Institutional branding and application title'),
('default_quiz_duration', '60', 'EXAMINATION', 'INTEGER', 'Default examination duration in minutes for new quizzes'),
('max_quiz_duration', '180', 'EXAMINATION', 'INTEGER', 'Maximum permitted examination duration in minutes'),
('default_passing_percentage', '40.0', 'ACADEMIC', 'DECIMAL', 'Default passing mark threshold percentage'),
('max_login_attempts', '5', 'SECURITY', 'INTEGER', 'Maximum failed login attempts before account lock'),
('session_timeout', '30', 'SECURITY', 'INTEGER', 'HTTP user session inactivity timeout in minutes'),
('maintenance_mode', 'false', 'SYSTEM', 'BOOLEAN', 'Toggle application maintenance mode for scheduled upgrades'),
('registration_enabled', 'true', 'AUTHENTICATION', 'BOOLEAN', 'Allow self-registration for new students')
ON CONFLICT (setting_key) DO NOTHING;
