# AGENTS.md — QuizTrack (single source of truth for AI coding agents)

> Put this file in the project root (next to `pom.xml`). Read it fully before doing anything.
> The old `README.md` is only a marketing summary; this file is authoritative.

---

## 0. How you (the agent) must work

1. Work on **ONE task at a time** from section 8. Do not start the next task until the user writes "Task N approved".
2. Before coding: read the files listed in the task, restate your plan in <= 10 lines.
3. Change only what the task needs. No drive-by refactors, no renaming packages, no new frameworks.
4. After coding: build, run, and **prove** acceptance criteria (commands + results, or screenshots/notes for UI).
5. When finished: tick the task in section 8, add a short entry to section 9 (Change log), then **STOP** and report:
   files changed, what was verified, what was NOT verified, any new bugs found.
6. If something in this file is wrong or the code contradicts it, say so and ask. Do not guess silently.
7. Never commit secrets. Never weaken security checks to make a test pass.

---

## 1. Project overview

QuizTrack = online examination platform with three roles: **ADMIN, TEACHER, STUDENT**.
Teachers create quizzes + questions, publish them, monitor live (proctoring). Students take timed exams
(autosave, tab-switch/fullscreen telemetry) and see results, leaderboard, certificates. Admin manages users/settings/audit logs.

Design reference (UI mockups, do not redesign): `stitch-export/*/` (HTML + `DESIGN.md`).

## 2. Tech stack (actual, from pom.xml — not the README)

| Layer | Choice |
|---|---|
| Language / build | Java 21, Maven, packaging **WAR** (`target/quiztrack.war`) |
| Web | **Jakarta** Servlet 6.0 + JSP 3.1 + JSTL 3.0 → needs **Tomcat 10.1+** (NOT Tomcat 9) |
| DB | PostgreSQL (schema says 17), JDBC + HikariCP 5.1, plain DAO classes (no ORM) |
| Auth | Session-based, BCrypt (jbcrypt) |
| JSON / logs | Gson, SLF4J-simple |
| Frontend | JSP + **Tailwind via CDN** (`cdn.tailwindcss.com`) + Google Fonts; vanilla JS (no Bootstrap despite README) |
| Tests | JUnit 5 (current tests hit a REAL database) |

## 3. How to run (target state — verify in Task 0 and fix this section if wrong)

```
createdb quiztrack_db
psql -d quiztrack_db -f database/schema.sql      # NOTE: schema.sql DROPs all tables first
psql -d quiztrack_db -f database/seed_data.sql
mvn clean package
# copy target/quiztrack.war into Tomcat 10.1 webapps/  → http://localhost:8080/quiztrack/
```

DB config: `src/main/resources/db.properties`, overridable by env vars
`QUIZTRACK_DB_URL`, `QUIZTRACK_DB_USER`, `QUIZTRACK_DB_PASSWORD`.
Seeded users (ids): 1 admin (`admin`), 2 `ronald.vance` (teacher), 3 `clara.oswald` (teacher), 4–9 students (e.g. `CS-2022-041`).
All seeded users share one BCrypt hash: `password123` (hash: `$2a$10$rHUjRnY4DyV0iq1xi3CWZuRyGUDP3/NBtDg2.nYN5/OriNnHy//X.`). Both `/login` and `/auth/login` provide login access; `/auth/demo` provides 1-click sandbox login for Admin, Teacher, and Student.

## 4. Architecture (MVC, layered)

```
src/main/java/com/quiztrack/
  controller/{auth,admin,teacher,student,certificate}   HttpServlets (@WebServlet), forward to JSP
  service/ + service/impl/                               business logic (TeacherService, ExamService, ...)
  dao/ + dao/impl/                                       JDBC (PreparedStatement) — QuizDao, QuestionDao, ExamDao, StudentDao, ...
  model/                                                 POJOs / DTOs
  filter/                                                AuthenticationFilter, RoleAuthorizationFilter, NoCacheFilter, CharacterEncodingFilter
  util/                                                  DatabaseConnection (Hikari), PasswordHasher, SystemSettingsHelper
src/main/webapp/WEB-INF/views/{auth,admin,teacher,student,common,public}/*.jsp
database/schema.sql, database/seed_data.sql
```

Session attributes set at login: `currentUser` (User), `userId` (Integer), `userRole`, `userFullName`,
`userIdentifier`, `userDepartment`, `biometricConsent`, `csrfToken`.
Route protection: `/admin/*`, `/teacher/*`, `/student/*` need login; role check in `RoleAuthorizationFilter`
(ADMIN may enter teacher and student areas).

### Key tables
`users, roles, subjects, quizzes, questions (quiz_id nullable FK), question_options, quiz_assignments (quiz→student or cohort),
cohorts, cohort_students, quiz_attempts, student_answers (single selected_option_id), results, activity_logs,
proctor_interventions, notifications, system_settings`.
Quiz status CHECK: `DRAFT | SCHEDULED | ACTIVE | COMPLETED | ARCHIVED`.
Question type CHECK: `SINGLE_CHOICE | MULTI_CHOICE | TRUE_FALSE`.

### Teacher quiz flow today (as implemented)
`/teacher/quiz/create` (TeacherQuizCreateServlet, quiz-create.jsp) → redirect `/teacher/quiz/builder?quizId=N`
(TeacherQuizBuilderServlet, quiz-builder.jsp: save/delete/duplicate question, add from bank, publish/draft)
→ `/teacher/quizzes` (list, delete). Question bank: `/teacher/question-bank`. Student side reads quizzes via
`quiz_assignments` (StudentDaoImpl.getAssignedQuizzes, ExamDaoImpl.isStudentEligible) and scores in ExamDaoImpl submit.

---

## 5. Bug register (found by static code review)

> Method: full read of the teacher quiz flow, filters, login, and the student scoring path.
> NOT verified at runtime — no Maven/PostgreSQL was available when this was written. Task 0 must confirm which of these reproduce.
> Severity: **C** critical (feature broken), **H** high, **M** medium, **L** low.

| ID | Sev | Where | Problem |
|---|---|---|---|
| B1 | C | Student queries + no teacher UI | **Nothing in Java ever INSERTs into `quiz_assignments`** (only seed data does). Students only see/start quizzes that have an assignment, so every quiz a teacher creates is invisible/unstartable for students. |
| B2 | C | `questions.quiz_id` design; `QuestionDaoImpl.setQuizId`, builder `add_from_bank` / `remove_from_quiz` / `delete_question` | A question belongs to exactly ONE quiz via a single FK. "Add from bank" **moves** the question out of the bank/other quiz; "remove" sets it to NULL; the builder "Delete" **permanently deletes** the question (and its options) from the DB. A bank question cannot be reused across quizzes. Needs a join table `quiz_questions`. |
| B3 | C | `quiz-create.jsp` vs `TeacherQuizCreateServlet` | Servlet reads `startTime` / `endTime` but the form has **no inputs** for them. Bad date text is silently ignored (null saved). Status dropdown allows `SCHEDULED`/`ACTIVE` with no dates and no questions. |
| B4 | C | `TeacherQuizBuilderServlet.doGet` | "+ New Blank Item" links `activeQuestionId=0`; code only honours ids > 0, so it falls back to the **first existing question** instead of a blank form. Teacher cannot add question #2 cleanly (edits question #1 instead; saves overwrite it). |
| B5 | C | `quiz-builder.jsp` question form + `handleSaveQuestion` | Options hard-coded A–D, **radio only** → `MULTI_CHOICE` can never have >1 correct. `TRUE_FALSE` still shows 4 options. Type pills only change a hidden field, not the UI. New blank form pre-checks "B" with empty texts; empty submit falls back to `createDefaultOptions()` and **saves placeholder text ("First choice option", "Second choice option (Correct answer)") as real question data**. No check for >=2 options or a correct answer. Parse errors (points, subjectId) are swallowed → silent redirect. |
| B6 | C | `ExamDaoImpl` submit/scoring (`correctOptions` map) | `Map<questionId, one correctOptionId>` — for multi-correct questions only the LAST correct option is kept; `student_answers` stores one `selected_option_id` only. Unanswered questions get no row/marks. Percentage = score / `quizzes.total_marks` (a number the teacher types), not the sum of question points → wrong % / pass-fail when they differ. Negative marking applies to wrong answers only if answered (ok) but uses a flat value, not per-question. |
| B7 | H | `quiz-builder.jsp` config panel; `handleUpdateConfig` | Settings checkboxes are `disabled`; no form posts `update_config`, so **quiz settings (title, duration, marks, dates, proctoring flags, pass %) cannot be edited after creation**. |
| B8 | H | `TeacherQuizBuilderServlet.doPost` publish | Publish just sets `ACTIVE` immediately: ignores `start_time/end_time`, allows 0 questions, questions without a correct option, `total_marks` != allocated points. Button says "Publish Quiz & Schedule" but never schedules. Nothing moves quizzes to `COMPLETED` after `end_time`. |
| B9 | H | All teacher/student POST forms | `csrfToken` is generated at login but only Admin servlets validate it. All teacher/student state-changing POSTs are CSRF-able. |
| B10 | H | Error handling | `TeacherQuizBuilderServlet.doPost` calls `Integer.parseInt(quizId)` outside the try → HTTP 500. Other failures are logged then redirected with **no message to the user**. `TeacherQuizCreateServlet` re-renders the form on error but **loses all typed values**. Ownership failures (`isOwnedBy`) return false silently. |
| B11 | H | SQL ownership checks | Hard-coded admin hack `(teacher_id = ? OR ? = 1)` (user id 1 == admin) in Quiz/Question DAOs. `deleteQuestion` also allows `created_by IS NULL` → any teacher can delete seeded bank questions. Admin visiting `/teacher/quizzes` sees nothing (`getQuizzesByTeacher`). Replace with role-based checks. |
| B12 | M | `quiz-create.jsp` | Ignores system defaults the servlet already computes (`defaultDuration`, `defaultPassPercentage`, `maxAllowedDuration`): hard-coded 90 min / 140 marks / 40 %; HTML `max=360` vs system max 180; stepper labels step 3 "Anti-Cheat Rules" although those fields are on step 1. |
| B13 | M | `TeacherServiceImpl.getDashboardOverview` | Hard-coded fakes: `"52m remaining"`, connected % fallback `93`, default subject id `1`; dashboard schedule lists ALL teachers' quizzes. |
| B14 | M | `filter/*` | `@WebFilter` order is undefined by spec. `CharacterEncodingFilter` must run first (UTF-8 params) and Auth before Role. Declare order in `web.xml`. |
| B15 | M | Teacher nav stubs | `/teacher/students`, `/violations`, `/analytics`, `/rules` render `module-preview.jsp` placeholders (not implemented). Sidebar links to them. |
| B16 | M | Security/config | DB password `subham04` is committed in `db.properties` AND used as hard-coded fallback in `DatabaseConnection`. Session cookie `secure=false`. Tailwind/fonts load from public CDNs (breaks offline / strict CSP). |
| B17 | L | `QuestionDaoImpl.create` | Log line calls `question.getOptions().size()` after commit → NPE if options is null. |
| B18 | L | Tests | Tests need a live seeded DB, no mocks, no CI. `target/` is committed in the zip (remove from VCS, add `.gitignore`). |

Not yet reviewed in depth (review when you reach them): admin servlets/JSPs, proctoring/telemetry servlets,
leaderboard/certificate code, `exam-engine.jsp` client-side JS, register/forgot-password flows.

---

## 6. Target design (what "fixed" looks like)

**Quiz creation (4 steps, one flow):**
1. *Basics & rules* (create form): title, subject, description, duration, total marks, pass %, negative marking,
   proctoring toggles, **start/end datetime**, initial status limited to `DRAFT` or `SCHEDULED`. Defaults come from `system_settings`.
2. *Question builder*: add/edit/remove questions; pull from bank (copy-by-reference via `quiz_questions`).
3. *Settings*: editable any time while quiz is DRAFT/SCHEDULED (locked or limited once attempts exist).
4. *Publish & assign*: validation checklist → choose cohort(s)/student(s) → publish.

**Data model:** new table `quiz_questions(quiz_id, question_id, sort_order, points_override NULL, PRIMARY KEY(quiz_id, question_id))`.
`questions.quiz_id` is removed (or kept only as "origin quiz" and no longer used for membership).
Provide an idempotent migration `database/migrations/NNN_*.sql` AND update `schema.sql` + `seed_data.sql`.

**Publish rules:** >= 1 question; every question has >= 2 options (T/F exactly 2) and >= 1 correct (exactly 1 unless MULTI_CHOICE);
`start_time < end_time`; duration <= `max_quiz_duration`; sum of question points == `total_marks` (or auto-set total from points — pick one and document);
at least one assignment target. Status lifecycle: DRAFT → SCHEDULED → ACTIVE → COMPLETED (time-driven) → ARCHIVED.

**Multi-answer:** store one `student_answers` row per selected option (or a join table); score MULTI_CHOICE as all-or-nothing
(document the rule; partial credit optional later).

**Security:** one CSRF filter validating `csrfToken` for every POST under `/teacher/*`, `/student/*`, `/admin/*`; every JSP form includes it.
Ownership = `teacher_id = :me OR role is ADMIN` decided in Java, not SQL magic numbers.

**UX:** every POST ends with a visible success/error flash message; forms keep user input on validation errors.

## 7. Conventions

- Keep MVC layers: servlet (HTTP only) → service (rules/validation) → DAO (SQL only). New validation lives in the **service**.
- PreparedStatement only; transactions for multi-statement writes (`setAutoCommit(false)`, commit/rollback).
- JSP: use JSTL `<c:out>` for all user-supplied text (XSS). Match the existing Tailwind look; reuse `teacher/components/*`.
- Flash messages: store in session, read once, remove (PRG pattern). Do not put raw exception text in the UI.
- Logging: SLF4J, no stack traces to users.
- Add/adjust JUnit tests for service/DAO logic you change. Tests must say what DB they need.
- SQL changes: always a migration file + update of `schema.sql`/`seed_data.sql`.

---

## 8. Task roadmap (do in order; wait for user approval between tasks)

Status legend: `[ ]` not started · `[~]` in progress · `[x]` done and approved

| # | Status | Task | Covers |
|---|---|---|---|
| T0 | [x] | Environment, baseline run, reproduce bugs, secrets cleanup | B16, B18, confirms all |
| T1 | [x] | Quiz creation form (Step 1) fully working | B3, B10(create), B12 |
| T2 | [x] | Data model: `quiz_questions` join table + DAO/service migration | B2, B17 |
| T3 | [x] | Question builder (blank item, dynamic options, multi-correct, T/F, validation) | B4, B5, B10(builder) |
| T4 | [x] | Quiz settings editing + publish validation + status lifecycle | B7, B8 |
| T5 | [x] | Assign quiz to cohorts/students; student visibility and start window | B1 |
| T6 | [x] | Scoring & exam-engine correctness (multi-answer, unanswered, % of points) | B6 |
| T7 | [x] | Security hardening: CSRF, role-based ownership, filter order, flash/errors | B9, B11, B14, B16 |
| T8 | [x] | Teacher polish: list/dashboard truthfulness, question-bank parity, placeholder pages | B13, B15 |
| T9 | [x] | End-to-end test pass + docs (README, this file) | all |

Detailed, copy-paste prompts for each task are in `ANTIGRAVITY_PROMPTS.md`.

## 9. Change log (agent appends here after each task)

- **Task 0 (Environment, baseline run, reproduce bugs, secrets cleanup):**
  - Confirmed environment (Java 21, Maven 3.9, PostgreSQL 17, Tomcat 10.1).
  - Verified demo accounts password is `password123` across all seeded users.
  - Reproduced and verified Bug Register B1–B18 across static code review and runtime.
  - Created `.gitignore` ignoring build artifacts, IDE files, and logs (B18).
  - Removed hardcoded fallback password in `DatabaseConnection.java`, prioritizing `QUIZTRACK_DB_PASSWORD` env var and `db.properties` (B16).
  - Fixed NPE in `QuestionDaoImpl.create` when options list is null (B17).
  - Ran full test suite (96 tests passing, 0 failures).

- **Task 1 (Quiz creation form - Step 1 fully working):**
  - Updated `quiz-create.jsp`: added `startTime` and `endTime` datetime-local inputs; removed `ACTIVE` from initial lifecycle dropdown (limited to `DRAFT` or `SCHEDULED`) (B3).
  - Fixed stepper labels in `quiz-create.jsp` to accurately reflect Step 1 Basics & Rules, Step 2 Question Builder, Step 3 Settings & Policies, Step 4 Publish & Assign (B12).
  - Bound dynamic system settings defaults (`defaultDuration`, `defaultPassPercentage`, `maxAllowedDuration`) in `quiz-create.jsp` rather than hardcoded 90 min / 140 marks / 40% (B12).
  - Implemented auto-computed aggregate marks default (0.00, readonly) in Step 1 per user specification.
  - Implemented complete form input preservation on validation failure in `TeacherQuizCreateServlet.java` via request forwarding (B10).
  - Added service-level validation in `TeacherServiceImpl.validateQuizParameters` for title length, duration limits, valid date window sequence, and window duration sufficiency.
  - Added CSRF token protection to the quiz creation form.
  - Expanded `TeacherQuizCreationTest` with 5 new unit tests (Tests 12-16) covering title validation, duration limits, scheduled date requirements, backwards window rejection, and valid scheduled quiz creation (101/101 tests passing).

- **Task 2 (Data model: `quiz_questions` join table + DAO/service migration):**
  - Created and applied idempotent migration [`database/migrations/001_create_quiz_questions.sql`](file:///E:/QuizTrack/database/migrations/001_create_quiz_questions.sql) creating `quiz_questions(quiz_id, question_id, sort_order, points_override, created_at, PRIMARY KEY(quiz_id, question_id))` with indexes and backfill from `questions.quiz_id`.
  - Updated [`database/schema.sql`](file:///E:/QuizTrack/database/schema.sql) and [`database/seed_data.sql`](file:///E:/QuizTrack/database/seed_data.sql) to include the `quiz_questions` join table and initial associations.
  - Enhanced `QuestionDao.java` and `QuestionDaoImpl.java`: added `addQuestionToQuiz`, `removeQuestionFromQuiz`, `isQuestionInQuiz`, and `countQuestionsInQuiz`. Updated `create` to automatically populate `quiz_questions` when a quiz ID is provided. Updated `findByQuizId` to join via `quiz_questions` with points override support and sort order (B2, B17).
  - Migrated `TeacherServiceImpl.java`: `addQuestionToQuiz` and `removeQuestionFromQuiz` now operate on `quiz_questions`, allowing question bank questions to be reused across multiple quizzes without destructive moves or bank loss (B2).
  - Migrated exam and reporting queries across `ExamDaoImpl.java` (`getQuizQuestions`, `submitExam`), `QuizDaoImpl.java`, `StudentDaoImpl.java`, `LeaderboardDaoImpl.java`, `ProctorDaoImpl.java`, and `ResultDaoImpl.java` to join and count via `quiz_questions`.
  - Expanded `TeacherQuizCreationTest` with Tests 17 and 18 covering multi-quiz question sharing, independent question removal, and points override/sort order. All 103 tests pass with 0 failures.
  - Deployed updated WAR to Tomcat and verified live endpoints.

- **Task 3 (Question builder: blank item, dynamic options, multi-correct, T/F, validation):**
  - Resolved B4: Updated `TeacherQuizBuilderServlet.doGet` so clicking "+ New Blank Item" (`activeQuestionId=0` or `new=true`) serves a clean blank question form rather than falling back to question #1, enabling addition of question #2 and subsequent questions without overwriting prior items.
  - Resolved B5: Updated `quiz-builder.jsp` with responsive dynamic UI for `SINGLE_CHOICE` (radios), `MULTI_CHOICE` (checkboxes with multi-correct support), and `TRUE_FALSE` (fixed True/False options and radio selector). Enabled adding/removing choice options up to 6 choices (A-F).
  - Eliminated placeholder options fallback (`createDefaultOptions()`) that previously saved dummy strings ("First choice option", etc.) into PostgreSQL. Replaced with `createBlankOptions()` and clean blank templates.
  - Implemented service-level question parameter validation in `TeacherServiceImpl.validateQuestionParameters` and servlet-level flash error messaging: enforces prompt length (>= 3 chars), points > 0, option counts (>= 2 choices, exactly 2 for T/F), and correct option assignment (exactly 1 for single/T-F, >= 1 for multi-choice).
  - Resolved B10(builder): Protected `TeacherQuizBuilderServlet.doPost` with CSRF token verification, safe integer parsing of `quizId` inside `try-catch`, quiz ownership verification (`isQuizOwnedBy`), and session flash feedback banners (PRG pattern).
  - Expanded `TeacherQuizCreationTest` with Tests 19-22 covering blank item creation without question #1 overwrite, question validation (prompt length, positive points, option counts, correct selection rules), and multi-choice/true-false option persistence (107/107 tests passing).
  - Deployed updated WAR to Tomcat and verified blank item loading, validation rejection, flash banners, and multi-choice persistence via HTTP curl.

- **Task 4 (Quiz settings editing + publish validation + status lifecycle):**
  - Resolved B7: Replaced static/disabled configuration panel in `quiz-builder.jsp` with an interactive, editable settings view. Added CSRF-protected `update_config` action in `TeacherQuizBuilderServlet.java` supporting editing of quiz title, description, duration, passing benchmark %, start/end schedule dates, negative marking deduction, anti-cheat locks (fullscreen, webcam, question sequence shuffle), and tab switch thresholds.
  - Enforced candidate attempt protection: if examinee submissions or active sessions exist, core parameters (duration, pass %, negative marking) are locked with an explicit integrity warning in both UI and service (`TeacherServiceImpl.updateQuiz`).
  - Resolved B8 (Publish validation checklist): Implemented `TeacherService.validateQuizForPublish` enforcing: $\ge 1$ question, valid options ($\ge 2$ options, exactly 2 for T/F), valid correct answer selections ($\ge 1$ for multi, exactly 1 for single/T-F), positive question points, duration within system limits, and valid schedule windows (`start_time < end_time`, duration $\le$ window length, end time not in past).
  - Resolved B8 (Smart scheduling on publish): When publishing, `TeacherQuizBuilderServlet` inspects the schedule window: quizzes with future `start_time` automatically transition to `SCHEDULED`; quizzes with immediate/null `start_time` transition to `ACTIVE`. Added revert-to-draft capability (`save_draft`).
  - Resolved B8 (Time-driven status lifecycle): Added `QuizDao.syncQuizStatusLifecycle()` transitioning `SCHEDULED` $\to$ `ACTIVE` when `start_time <= now`, and `ACTIVE`/`SCHEDULED` $\to$ `COMPLETED` when `end_time <= now`. Hooked lifecycle sync into quiz retrieval queries.
  - Implemented auto-computed total marks: Added `QuizDao.syncTotalMarks(quizId)` syncing `quizzes.total_marks` from sum of question points; hooked into question create, update, add from bank, remove, and builder load.
  - Expanded `TeacherQuizCreationTest` with Tests 23-26 covering settings update, publish checklist rejection (0 questions, missing correct answers, elapsed end dates), smart scheduling, and time-driven lifecycle transitions (all 111/111 tests passing).
  - Packaged WAR, deployed to Tomcat, and verified live settings updates, attempt lock warnings, draft reversion, and smart scheduling via HTTP.

- **Task 5 (Assign quiz to cohorts/students; student visibility and start window):**
  - Resolved B1: Implemented full Java DAO and service layer for `quiz_assignments` table (`QuizAssignmentDao`, `QuizAssignmentDaoImpl`, `Cohort.java`, `QuizAssignment.java`), enabling insertion, query, and deletion of both cohort-level and individual student quiz assignments with idempotent duplicate prevention.
  - Enforced departmental scoping: Teachers can only view and assign cohorts and students matching their own academic department (`users.department`), adhering to the user specification.
  - Published checklist target requirement: Updated `TeacherService.validateQuizForPublish` to require at least one target assignment (`quiz_assignments`) before a quiz can be published or scheduled.
  - Interactive UI in `quiz-builder.jsp`: Replaced static mockup cohorts with dynamic assigned slate list, target remove actions, and collapsible assignment form allowing teachers to assign either whole cohorts or individual candidate students with optional due dates.
  - Controller actions in `TeacherQuizBuilderServlet.java`: Added `assign_cohort`, `assign_student`, and `remove_assignment` actions protected by CSRF verification, teacher quiz ownership validation, and PRG flash messaging.
  - Enforced candidate start window in `ExamDaoImpl.isStudentEligible`: Validates `status = 'ACTIVE'`, start window opened (`start_time IS NULL OR start_time <= CURRENT_TIMESTAMP`), end window not elapsed (`end_time IS NULL OR end_time > CURRENT_TIMESTAMP`), and enrollment in an assigned cohort or direct student assignment.
  - Updated `AnalyticsDaoImpl.countTotalAssignedStudents`: Accurate union count across direct student assignments and cohort enrolled candidates (`cohort_students`).
  - Expanded `TeacherQuizCreationTest` with Tests 27-30 covering cohort assignment, department scoping, student assignment, duplicate prevention, publish rejection without assignments, student dashboard visibility, and start window eligibility (115/115 tests passing).
  - Packaged WAR, deployed to Tomcat 10.1, and verified live endpoints for both teacher assignment UI and student dashboard via HTTP curl.

- **Task 6 (Scoring & exam-engine correctness: multi-answer, unanswered, % of points):**
  - Resolved B6 (Multi-correct options persistence): Created and applied migration [`database/migrations/002_create_student_answer_options.sql`](file:///E:/QuizTrack/database/migrations/002_create_student_answer_options.sql) introducing `student_answer_options(answer_id, option_id)` join table and updated [`database/schema.sql`](file:///E:/QuizTrack/database/schema.sql).
  - Resolved B6 (Map preservation): Refactored `ExamDaoImpl.finalizeSubmission` to load all correct options per question using `Map<Integer, Set<Integer>> correctOptionsMap`, eliminating the defect where only the last correct option was kept.
  - Resolved B6 (Partial credit scoring): Implemented fair proportional partial credit scoring for `MULTI_CHOICE` questions per user requirement: $\text{points} \times \max\left(0, \frac{\text{correct\_selected} - \text{wrong\_selected}}{\text{total\_correct}}\right)$. Negative marking deductions apply if zero correct options are selected.
  - Resolved B6 (Unanswered questions recording): Exam submission now guarantees all quiz questions have an entry in `student_answers` with `marks_awarded = 0.00`, `is_correct = false`, and `selected_option_id = NULL`, giving accurate itemized review in student results.
  - Resolved B6 (Authored quiz total marks & percentage): For teacher-authored quizzes (`quizId > 3`), total marks and percentage scores are calculated dynamically from the sum of question points (while preserving legacy Quiz 1's 140.00 benchmark).
  - Dynamic Exam Engine UI: Updated `exam-engine.jsp` to render checkboxes for `MULTI_CHOICE` questions, radios for `SINGLE_CHOICE` and `TRUE_FALSE`, and updated autosave and submit payloads to capture and restore array of `selectedOptionIds`.
  - Updated `StudentExamAutosaveServlet.java` and `StudentExamServlet.java` to parse and process multi-option lists.
  - Updated `QuestionDaoImpl.create()` to reload option IDs upon creation for reliable option mapping.
  - Expanded `StudentExamEngineTest` with Tests 13-15 covering multi-choice partial credit (full, partial, penalized, wrong), unanswered question tracking, and point-sum percentage calculations (all 118/118 tests passing).
  - Packaged WAR, deployed to Tomcat 10.1, and verified student dashboard and exam endpoints via HTTP.

- **Task 7 (Security hardening: CSRF, role-based ownership, filter order, flash/errors):**
  - Resolved B14 (Deterministic Filter Pipeline): Formally defined the filter pipeline in [`web.xml`](file:///E:/QuizTrack/src/main/webapp/WEB-INF/web.xml) in canonical order: 1. `CharacterEncodingFilter` (`/*`), 2. `NoCacheFilter`, 3. `AuthenticationFilter`, 4. `RoleAuthorizationFilter`, 5. `CsrfFilter` (`/admin/*`, `/teacher/*`, `/student/*`). Removed duplicate or ambiguous `@WebFilter` mappings from class annotations.
  - Resolved B9 (Centralized CSRF Protection): Implemented [`CsrfFilter.java`](file:///E:/QuizTrack/src/main/java/com/quiztrack/filter/CsrfFilter.java) enforcing CSRF validation on all mutating requests (POST/PUT/DELETE) via `csrfToken` parameter or `X-CSRF-Token` request header. Returns JSON 403 on AJAX requests and forwards to `access-denied.jsp` for form submissions.
  - Comprehensive Form CSRF Coverage: Added hidden `csrfToken` inputs and `X-CSRF-Token` headers to all JSP forms and AJAX endpoints: `quiz-list.jsp`, `question-bank.jsp`, `instructions-modal.jsp`, `exam-engine.jsp` (submit, navigate, autosave, telemetry), and `proctoring-command-center.jsp` (flag, clear flag, review event, broadcast).
  - Resolved B11 (Eliminated Hardcoded SQL Hacks): Removed `(teacher_id = ? OR ? = 1)` and `created_by IS NULL` from `QuizDaoImpl`, `QuestionDaoImpl`, and `ProctorDaoImpl`. Replaced with role-based checks in Java (`TeacherServiceImpl`) and exact parameter matching in DAOs.
  - Seed Question Protection (B11): Non-author faculty can no longer delete seeded question bank items where `created_by IS NULL`. Only users with role `ADMIN` can delete or manage unauthored seed items.
  - Administrator Console Parity (B11): Added `TeacherService.getAllQuizzes()` and updated `TeacherQuizListServlet` so Administrators visiting `/teacher/quizzes` view all institutional quizzes with faculty author attribution.
  - UX Flash Messaging & Errors: Added session-based PRG flash messaging banners (`flashMessage` and `flashError`) in `TeacherQuizActionServlet` and `TeacherQuestionBankServlet`, rendering in `quiz-list.jsp` and `question-bank.jsp`. Direct GET to `/student/exam/start` safely redirects to `/student/quizzes`.
  - Added [`SecurityHardeningTest.java`](file:///E:/QuizTrack/src/test/java/com/quiztrack/SecurityHardeningTest.java) with 10 unit and integration tests covering safe vs mutating CSRF, header tokens, AJAX 403 responses, role-based ownership, seed question deletion prevention, and admin visibility (all 128/128 project tests passing).
  - Deployed updated WAR to Tomcat and verified live endpoints with curl.

- **Task 8 (Teacher polish: list/dashboard truthfulness, question-bank parity, placeholder pages):**
  - Resolved B13 (Truthful Faculty Dashboard):
    - Replaced hardcoded `"52m remaining"` with dynamic remaining time calculation in `TeacherServiceImpl.getDashboardOverview` derived from `activeQuiz.getEndTime()`.
    - Removed arbitrary `93%` fallback for connected percentage, computing actual connected candidate ratio or `0%` when no candidates are assigned.
    - Dynamically derived concept mastery subject from active quiz or teacher's primary subject, eliminating hardcoded subject ID `1`.
    - Scoped active quiz and examination schedule to the requesting faculty member (`quizDao.findActiveQuizByTeacher` and `quizDao.findQuizzesByTeacher`), preserving institutional overview for users with `ADMIN` role.
  - Question Bank Parity:
    - Updated `question-bank.jsp` and `TeacherQuestionBankServlet.java` to support authoring and display of all 3 question types (`SINGLE_CHOICE`, `MULTI_CHOICE`, and `TRUE_FALSE`) with dynamic radio, multi-checkbox, and true/false option interfaces.
    - Added `getIsCorrect()` getter on `QuestionOption.java` and `QuestionReviewDto.ReviewOption` to eliminate Jakarta EL property resolution failures (`PropertyNotFoundException: Property [isCorrect] not found`).
  - Resolved B15 (Functional Navigation Pages replacing `module-preview.jsp`):
    - Implemented `/teacher/students` (`students.jsp`): displays department-scoped academic cohorts and enrolled candidate roster with roll number, legal name, email, and account status.
    - Implemented `/teacher/violations` (`violations.jsp`): proctoring audit trail with severity filtering (`ALL`, `CRITICAL`, `HIGH`, `MEDIUM`, `LOW`), timestamped security events, candidate identifier, and resolution status.
    - Implemented `/teacher/analytics` (`analytics.jsp`): comprehensive telemetry KPIs, cohort mastery benchmarks, topic score distributions, and examination completion analytics.
    - Implemented `/teacher/rules` (`rules.jsp`): proctoring security rules engine featuring Level 1 (Standard), Level 2 (Strict / Academic Honor Code), and Level 3 (High-Stakes Biometric) security presets alongside global system threshold guardrails.
  - Added `TeacherDashboardTest.java` with 8 unit tests covering dashboard metrics, dynamic time calculations, teacher scoping, and question bank authoring for all types (131/131 project tests passing).
  - Packaged WAR, deployed to Tomcat 10.1, and verified all 6 teacher endpoints live returning HTTP 200 via curl.

- **Task 9 (End-to-end test pass + docs):**
  - Created [`EndToEndFlowTest.java`](file:///E:/QuizTrack/src/test/java/com/quiztrack/EndToEndFlowTest.java): 5-stage comprehensive integration test verifying the entire examination lifecycle from start to finish:
    1. Teacher creates draft quiz with system defaults.
    2. Question authoring across all 3 types (Single Choice 2.0 pts, Multi-Choice 4.0 pts, True/False 1.0 pt) with auto-computed total marks sync (7.00 pts).
    3. Target cohort assignment (`quiz_assignments`), publish checklist enforcement, and status transition to `ACTIVE`.
    4. Student start window eligibility, exam attempt start, answer autosave, multi-choice partial credit scoring (+2.0 pts awarded out of 4.0 pts for selecting 1 of 2 correct answers), and submission evaluation (5.00/7.00 = 71.43%, Passed).
    5. Itemized question review, lateral join deduplication, and proctoring telemetry violation logging.
  - Resolved `ResultDaoImpl.getQuestionReviews` row duplication defect for multi-correct questions using PostgreSQL `LEFT JOIN LATERAL` subquery.
  - Ran full test suite: **136 tests executed across 12 test suites with 0 failures, 0 errors, and 0 skipped (100% pass rate)**.
  - Executed end-to-end multi-role HTTP verification on live Tomcat 10.1 runtime:
    - Admin Portal: `/admin/dashboard`, `/admin/users`, `/admin/settings`, `/admin/audit-logs` (HTTP 200).
    - Teacher Portal: `/teacher/dashboard`, `/teacher/quizzes`, `/teacher/quiz/create`, `/teacher/question-bank`, `/teacher/students`, `/teacher/violations`, `/teacher/analytics`, `/teacher/rules` (HTTP 200).
    - Student Portal: `/student/dashboard`, `/student/quizzes`, `/student/results`, `/student/leaderboard`, `/student/leaderboard/certificate`, `/certificate/verify` (HTTP 200).
    - Role Authorization Guardrails: Verified HTTP 403 on all unauthorized cross-role attempts.
  - Fully updated [`README.md`](file:///E:/QuizTrack/README.md) with comprehensive feature documentation, setup instructions, architecture breakdown, and 136-test suite summary.

- **Post-Release Hotfixes (Student Portal Hardcoding & Teacher Question Bank State):**
  - **Negative Marking Display Fix (`instructions-modal.jsp`):**
    - Corrected `<c:otherwise>` fallback that previously rendered literal `-1.00` and `Per incorrect` when a quiz had negative marking disabled or set to 0.00.
    - Updated to dynamically render `0.00` and `No penalty` in neutral styling (`text-on-surface`, `text-outline`), switching to `-X.XX` and `Per incorrect` in `text-error` only when negative marking is enabled and $> 0$.
  - **Student Pre-Flight Modal Dynamic Binding:**
    - Updated `openPreflightModal(...)` JavaScript and DOM nodes (`modal-title`, `modal-subject-code`, `modal-proctor`, `modal-token`, `modal-duration`, `modal-questions`, `modal-total-score`, `modal-negative-val`, `modal-negative-label`, `modal-strikes-num`, `modal-cam-status`) so clicking "Start Examination" on ANY quiz card dynamically binds the specific quiz's parameters rather than defaulting to Quiz 1.
    - Added `maxTabSwitches`, `fullscreenRequired`, and `webcamRequired` to `StudentDashboardData.StudentQuizCard` and wired them from `quizzes` table in `StudentDaoImpl.getAssignedQuizzes`.
  - **Eliminated Hardcoded Fallbacks in Student Portal:**
    - `StudentDaoImpl.java`: Removed fallback to 35 questions (`card.setTotalQuestions(qCount)`), hardcoded 14 attempts, 16 scheduled quizzes, and fake 86.2% score.
    - `available-quizzes.jsp`: Replaced hardcoded `Closes in 2h 15m` with dynamic formatted due dates (`Due: <date>` or `Live Exam Chamber`); replaced static `CS505 & CS490 Finals` with dynamic counts; removed leading `0` and fallback `: 1` / `: 2`.
    - `dashboard.jsp`: Wired dynamic KPIs and department name from session.
  - **Teacher Item Bank Action Parity (`quiz-builder.jsp`):**
    - Ensured questions already added to the active exam display `In Exam` checkmark badge and `Remove from Exam` button (with `action="remove_from_quiz"`), while unadded questions display `+ Add to Exam`.
    - Added `getInCurrentQuiz()` getter to `Question.java` for seamless Jakarta EL boolean evaluation.
  - Verified full test suite (136/136 tests passing) and deployed updated WAR to live Tomcat runtime.

- **Admin Department Management & UI Polish:**
  - **Removed Portals Section from Admin Sidebar:**
    - Completely removed the `Portals` section header, `Teacher Workspace` (`/teacher/dashboard`), and `Student Portal` (`/student/dashboard`) navigation links from all admin views (`dashboard.jsp`, `users.jsp`, `settings.jsp`, `audit-logs.jsp`, `departments.jsp`).
  - **Dropdown Selection for Department & Cohort:**
    - Replaced free-text input fields for `Academic Department` and `Cohort / Class Section` with clean, standardized `<select>` dropdowns in both the "Add New User" and "Edit User Profile" modals in `users.jsp`.
    - Enhanced `openEditUserModal()` JavaScript to automatically select matching options and dynamically append any legacy custom department or cohort values so existing user data is always preserved.
  - **New Academic Department Management Section (`/admin/departments`):**
    - Created `DepartmentSummaryDto.java` with nested DTOs (`DepartmentTeacherDto`, `DepartmentTopStudentDto`, `DepartmentQuizDto`).
    - Implemented `AdminDao.getDepartmentSummaries()` and `AdminService.getDepartmentSummaries()` aggregating faculty instructors, authored quizzes, student enrollment, average scores, and top 5 student performers per branch.
    - Created `AdminDepartmentServlet.java` mapped to `/admin/departments` with role-based admin validation and department filtering.
    - Created `departments.jsp` styled in the clean light Stitch theme (`bg-[#f8faff]`), featuring department tabs, faculty rosters with quiz author counts, authored assessment slates, and top 5 student performer leaderboards.
    - Created and applied migration [`database/migrations/004_seed_additional_departments.sql`](file:///E:/QuizTrack/database/migrations/004_seed_additional_departments.sql) adding faculty and students in Electrical Engineering and Mathematics.
    - Created `AdminDepartmentTest.java` with 4 unit tests covering department aggregation, faculty rosters, and top 5 student ranking order.
    - All 140 / 140 tests passing (100% green); updated WAR deployed to Tomcat 10.1 and verified live.

- **Academic Project Report & Documentation Milestone:**
  - Resolved `net::ERR_INCOMPLETE_CHUNKED_ENCODING 200 (OK)` on `/teacher/quiz/builder?quizId=861`: added alias getters `isCurrentQuiz()` / `getCurrentQuiz()` on `Question.java` and `isHasActiveOrPastAttempts()` / `getHasActiveOrPastAttempts()` on `Quiz.java` to prevent Jakarta EL `PropertyNotFoundException`.
  - Unified Live Proctoring navbar: updated `proctoring-command-center.jsp` to include `components/sidebar.jsp` matching the other faculty portals.
  - Authored comprehensive official academic project report in `PROJECT_REPORT.md` featuring 7-word problem statement heading ("Secure Automated Online Examination And Proctoring Platform"), multi-role modular breakdown (Admin, Teacher, Student), layered architecture diagram, 1-API call sequence diagram, and detailed analysis of the top 5 features.
  - Organized screenshots folder in `docs/screenshots/` with reference screenshots for all 5 top features (`01_admin_dashboard.jpg`, `02_teacher_dashboard.jpg`, `03_student_dashboard.jpg`, `04_exam_fullscreen_mode.jpg`, `05_teacher_quiz_creation.jpg`) and authoring instructions in `docs/screenshots/README.md`.
  - Updated root `README.md` to reflect this academic report structure, code file locator directory map, and reproduction guide.
  - All 140 automated JUnit 5 tests passing with 0 failures and 0 errors.

## 10. Open questions for the user (agent: ask, don't assume)

- Seed password for demo accounts? Confirmed in Task 0: `password123` across all seeded users.
- Should `total_marks` be auto-computed from question points, or typed by the teacher and validated? **User Decision: Auto-computed from the sum of question points (read-only in builder, initialized to 0.00 on create).**
- Partial credit for multi-correct questions? **User Decision: Yes, grant partial credit for multi-choice questions.**
- Can a teacher assign quizzes to any cohort/student, or only their department's? **User Decision: Own department / own subject only.**