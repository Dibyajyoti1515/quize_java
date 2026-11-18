# QuizTrack — Project Report Screenshots & Code Captures

This directory contains the verified application and source code screenshots for the Academic Java Project Report.

## Screenshot Index

### Application UI Screenshots
| Filename | Feature | Role | URL to View in Live System |
|---|---|---|---|
| `01_admin_dashboard.jpg` | **Admin Executive System Console** | Admin | `http://localhost:8080/quiztrack/auth/demo?role=admin` |
| `02_teacher_dashboard.jpg` | **Teacher Academic Overview & Live Banner** | Teacher | `http://localhost:8080/quiztrack/auth/demo?role=teacher` |
| `03_student_dashboard.jpg` | **Student Portal Dashboard & Assessments** | Student | `http://localhost:8080/quiztrack/auth/demo?role=student` |
| `04_exam_engine.png` | **Live Exam Engine & Question Palette** | Student | `http://localhost:8080/quiztrack/student/exam?attemptId=...` |
| `05_teacher_quiz_creation.jpg` | **Teacher Quiz Builder & Question Drafting** | Teacher | `http://localhost:8080/quiztrack/teacher/quiz/builder?quizId=...` |

### IDE Source Code Screenshots
| Filename | Component | File Path in Project |
|---|---|---|
| `06_code_admin_dao.jpg` | **Admin Metrics Aggregation (`getDashboardStatistics`)** | `src/main/java/com/quiztrack/dao/impl/AdminDaoImpl.java` |
| `07_code_teacher_service.jpg` | **Teacher Service & DAO Declarations (`TeacherServiceImpl`)** | `src/main/java/com/quiztrack/service/impl/TeacherServiceImpl.java` |

---

## Detailed Visual Descriptions

1. **`01_admin_dashboard.jpg` (Admin Executive Dashboard):**
   - Clean, light UI theme with Executive System Console header and "System Operational" badge.
   - 6 KPI metric cards: Enrolled Students (35), Academic Instructors (4), Active Administrators (1), Created Quizzes (8), Active Exams Now (2), Certified Submissions (5).
   - Institutional Examination Performance panel: 76.6% Average Exam Score, 80.0% Overall Pass Rate, 35 Questions Seeded.
   - Real-time Live System Audit log stream.

2. **`02_teacher_dashboard.jpg` (Teacher Academic Overview Dashboard):**
   - Faculty console header with AI Sentinel Active badge and user profile.
   - Active "Examination in Session" banner for CS402 Midterm Exam with 42/6 (100% Connected) stream status, 3 pending AI Sentinel reviews, and countdown timer.
   - 5 Faculty KPIs: Enrolled Students (35), Active Quizzes (2), Completed Sessions (5), Class Average (76.6%), and Proctor Trust Index (90.0%).

3. **`03_student_dashboard.jpg` (Student Examination Dashboard):**
   - Personalized hero banner: "Welcome back, Alex!" with Live Exam Portal notification and closing countdown timer.
   - 4 Candidate Diagnostic KPIs: Quizzes Attempted (1/4 Scheduled), Cumulative Score (84.3% Grade B+), Cohort Standing (94.2th Percentile, Rank #3), Integrity Index (99.1% Tier 1, 0 security incidents).
   - Filterable Active & Scheduled Assessments list (All, Live, Upcoming, Completed).
   - Candidate station Hardware Pre-Flight checks (Primary Camera, Microphone, Browser Lockdown API, Latency).

4. **`04_exam_engine.png` (Live Exam Engine Chamber):**
   - Head HUD with Examination Title, Seat ID, synchronized remaining countdown timer (19:42), last synced timestamp, security strikes (0/3), and Level-3 Guard indicator.
   - Question #1 workspace: Single Choice, prompt equation, option choices (A, B, C, D) with active selection badge.
   - Interactive Question Palette with status indicators: Answered (1), Review (0), Current Focus (1), and Not Visited (4).
   - Cryptographic session lock notice confirming PostgreSQL autosave.

5. **`05_teacher_quiz_creation.jpg` (Teacher Question Builder Studio):**
   - Interactive question drafting form: Question type selector pills (MCQ Single, Multi-Correct, True/False).
   - Correct weight allocation (4.00), cognitive depth level (Medium Application), topic tagging.
   - Rich Markdown and KaTeX formula toolbar.
   - Problem statement textarea and responsive option choice slots with radio answer selectors.

6. **`06_code_admin_dao.jpg` (VS Code Editor — `AdminDaoImpl.java`):**
   - File explorer tree showing `src/main/java/com/quiztrack/dao/impl/AdminDaoImpl.java`.
   - Implementation of `getDashboardStatistics()` executing the multi-subquery SQL metric compilation.

7. **`07_code_teacher_service.jpg` (VS Code Editor — `TeacherServiceImpl.java`):**
   - File explorer tree showing `src/main/java/com/quiztrack/service/impl/TeacherServiceImpl.java`.
   - Dependency injection setup and class constructors for `QuizDao`, `AnalyticsDao`, `QuestionDao`, `SubjectDao`, `QuizAssignmentDao`, `UserDao`, and `ResultDao`.
