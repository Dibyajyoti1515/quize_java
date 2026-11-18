package com.quiztrack;

import com.quiztrack.dao.ExamDao;
import com.quiztrack.dao.QuestionDao;
import com.quiztrack.dao.QuizAssignmentDao;
import com.quiztrack.dao.QuizDao;
import com.quiztrack.dao.impl.ExamDaoImpl;
import com.quiztrack.dao.impl.QuestionDaoImpl;
import com.quiztrack.dao.impl.QuizAssignmentDaoImpl;
import com.quiztrack.dao.impl.QuizDaoImpl;
import com.quiztrack.model.*;
import com.quiztrack.service.ExamService;
import com.quiztrack.service.TeacherService;
import com.quiztrack.service.impl.ExamServiceImpl;
import com.quiztrack.service.impl.TeacherServiceImpl;
import com.quiztrack.util.DatabaseConnection;
import org.junit.jupiter.api.*;

import java.lang.reflect.Field;
import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Map;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;

@TestMethodOrder(MethodOrderer.OrderAnnotation.class)
public class StudentExamEngineTest {

    private static ExamDao examDao;
    private static QuizDao quizDao;
    private static QuestionDao questionDao;
    private static QuizAssignmentDao quizAssignmentDao;
    private static ExamService examService;
    private static TeacherService teacherService;

    private static final int ELIGIBLE_STUDENT_ID = 6; // David Kim (CS-2022-088)
    private static final int UNRELATED_STUDENT_ID = 5; // Marcus Vance
    private static final int INELIGIBLE_STUDENT_ID = 9999;
    private static final int ACTIVE_QUIZ_ID = 1; // CS402 Midterm Exam
    private static int createdAttemptId = 0;

    @BeforeAll
    public static void setUp() {
        examDao = new ExamDaoImpl();
        quizDao = new QuizDaoImpl();
        questionDao = new QuestionDaoImpl();
        quizAssignmentDao = new QuizAssignmentDaoImpl();
        examService = new ExamServiceImpl(examDao);
        teacherService = new TeacherServiceImpl();

        // Clean up any lingering active attempts for student 4 on quiz 1 before test run
        cleanUpAttempts();
    }

    @AfterAll
    public static void tearDown() {
        cleanUpAttempts();
        DatabaseConnection.closePool();
    }

    private static void cleanUpAttempts() {
        String sql = "DELETE FROM quiz_attempts WHERE quiz_id = ? AND student_id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, ACTIVE_QUIZ_ID);
            ps.setInt(2, ELIGIBLE_STUDENT_ID);
            ps.executeUpdate();
        } catch (Exception ignored) {}
    }

    @Test
    @Order(1)
    @DisplayName("Test 1: Ineligible student cannot start the quiz")
    public void testIneligibleStudentCannotStartQuiz() {
        assertThrows(SecurityException.class, () -> {
            examService.startOrResumeExam(ACTIVE_QUIZ_ID, INELIGIBLE_STUDENT_ID, "127.0.0.1", "JUnit Client");
        }, "Ineligible student must be blocked from starting quiz");
    }

    @Test
    @Order(2)
    @DisplayName("Test 2: Eligible student starts an available quiz")
    public void testEligibleStudentStartsQuiz() {
        QuizAttempt attempt = examService.startOrResumeExam(ACTIVE_QUIZ_ID, ELIGIBLE_STUDENT_ID, "127.0.0.1", "JUnit Client");
        assertNotNull(attempt, "Attempt record must be created");
        assertTrue(attempt.getAttemptId() > 0, "Attempt ID must be generated");
        createdAttemptId = attempt.getAttemptId();

        assertEquals(ACTIVE_QUIZ_ID, attempt.getQuizId());
        assertEquals(ELIGIBLE_STUDENT_ID, attempt.getStudentId());
        assertEquals("IN_PROGRESS", attempt.getStatus());
        assertNotNull(attempt.getStartTime());
        assertEquals(90, attempt.getDurationMinutes());
    }

    @Test
    @Order(3)
    @DisplayName("Test 3: Student cannot retrieve correct answers before submission")
    public void testExamSecrecyNoCorrectAnswersExposed() {
        ExamSessionDto session = examService.getExamSession(createdAttemptId, ELIGIBLE_STUDENT_ID, 0);
        assertNotNull(session);
        assertNotNull(session.getQuestions());
        assertFalse(session.getQuestions().isEmpty(), "Session questions must be populated");

        // Verify that ExamOptionDto does NOT have isCorrect property via reflection
        ExamQuestionDto firstQ = session.getQuestions().get(0);
        assertFalse(firstQ.getOptions().isEmpty());
        ExamOptionDto firstOpt = firstQ.getOptions().get(0);

        Field[] fields = ExamOptionDto.class.getDeclaredFields();
        for (Field f : fields) {
            assertNotEquals("isCorrect", f.getName(), "ExamOptionDto MUST NOT expose isCorrect");
            assertNotEquals("correct", f.getName(), "ExamOptionDto MUST NOT expose correct field");
        }
    }

    @Test
    @Order(4)
    @DisplayName("Test 4: Student selects and changes answers with persistence")
    public void testSelectAndChangeAnswer() {
        ExamSessionDto session = examService.getExamSession(createdAttemptId, ELIGIBLE_STUDENT_ID, 0);
        ExamQuestionDto q1 = session.getQuestions().get(0);
        int q1Id = q1.getQuestionId();
        int optAId = q1.getOptions().get(0).getOptionId();
        int optBId = q1.getOptions().get(1).getOptionId();

        // 1. Select Option A
        boolean savedA = examService.saveAnswer(createdAttemptId, ELIGIBLE_STUDENT_ID, q1Id, optAId, false);
        assertTrue(savedA, "Saving Option A should succeed");

        // Verify in session
        ExamSessionDto refreshedSession1 = examService.getExamSession(createdAttemptId, ELIGIBLE_STUDENT_ID, 0);
        assertEquals(optAId, refreshedSession1.getQuestions().get(0).getSelectedOptionId());
        assertEquals("ANSWERED", refreshedSession1.getQuestions().get(0).getStatus());

        // 2. Change answer to Option B
        boolean savedB = examService.saveAnswer(createdAttemptId, ELIGIBLE_STUDENT_ID, q1Id, optBId, false);
        assertTrue(savedB, "Changing answer to Option B should succeed");

        // Verify updated in session
        ExamSessionDto refreshedSession2 = examService.getExamSession(createdAttemptId, ELIGIBLE_STUDENT_ID, 0);
        assertEquals(optBId, refreshedSession2.getQuestions().get(0).getSelectedOptionId());
    }

    @Test
    @Order(5)
    @DisplayName("Test 5: Answers and state remain saved after refresh / reconnection")
    public void testAnswersRemainSavedAfterRefresh() {
        // Fetch new session instance simulating a browser refresh
        ExamSessionDto session = examService.getExamSession(createdAttemptId, ELIGIBLE_STUDENT_ID, 0);
        assertNotNull(session);

        ExamQuestionDto q1 = session.getQuestions().get(0);
        assertNotNull(q1.getSelectedOptionId(), "Saved option must be restored after refresh");
        assertEquals("ANSWERED", q1.getStatus());
        assertTrue(session.getAnsweredCount() >= 1, "Answered count should reflect persisted answers");
    }

    @Test
    @Order(6)
    @DisplayName("Test 6: Mark for Review flag works and toggles state")
    public void testMarkForReviewFlag() {
        ExamSessionDto session = examService.getExamSession(createdAttemptId, ELIGIBLE_STUDENT_ID, 1);
        ExamQuestionDto q2 = session.getQuestions().get(1);
        int q2Id = q2.getQuestionId();

        // Toggle flag ON
        boolean flagged = examService.toggleFlag(createdAttemptId, ELIGIBLE_STUDENT_ID, q2Id, true);
        assertTrue(flagged, "Flagging question should succeed");

        ExamSessionDto sessionFlagged = examService.getExamSession(createdAttemptId, ELIGIBLE_STUDENT_ID, 1);
        assertTrue(sessionFlagged.getQuestions().get(1).isFlaggedForReview());
        assertEquals("REVIEW", sessionFlagged.getQuestions().get(1).getStatus());
        assertTrue(sessionFlagged.getFlaggedCount() >= 1);

        // Toggle flag OFF
        boolean unflagged = examService.toggleFlag(createdAttemptId, ELIGIBLE_STUDENT_ID, q2Id, false);
        assertTrue(unflagged, "Unflagging question should succeed");

        ExamSessionDto sessionUnflagged = examService.getExamSession(createdAttemptId, ELIGIBLE_STUDENT_ID, 1);
        assertFalse(sessionUnflagged.getQuestions().get(1).isFlaggedForReview());
    }

    @Test
    @Order(7)
    @DisplayName("Test 7: Navigation between questions maintains position and bounds")
    public void testPreviousAndNextNavigation() {
        ExamSessionDto sessionAt0 = examService.getExamSession(createdAttemptId, ELIGIBLE_STUDENT_ID, 0);
        assertEquals(0, sessionAt0.getCurrentQuestionIndex());
        assertEquals(1, sessionAt0.getCurrentQuestion().getQuestionNumber());

        ExamSessionDto sessionAt2 = examService.getExamSession(createdAttemptId, ELIGIBLE_STUDENT_ID, 2);
        assertEquals(2, sessionAt2.getCurrentQuestionIndex());
        assertEquals(3, sessionAt2.getCurrentQuestion().getQuestionNumber());

        // Out of bounds test (negative clamped to 0)
        ExamSessionDto sessionNeg = examService.getExamSession(createdAttemptId, ELIGIBLE_STUDENT_ID, -5);
        assertEquals(0, sessionNeg.getCurrentQuestionIndex());
    }

    @Test
    @Order(8)
    @DisplayName("Test 8: Timer continues correctly and reflects server-authoritative time")
    public void testServerAuthoritativeTimer() {
        ExamSessionDto session = examService.getExamSession(createdAttemptId, ELIGIBLE_STUDENT_ID, 0);
        long remainingSec = session.getRemainingSeconds();

        // Duration is 90 min (5400 sec), so remaining time should be close to 5400 sec
        assertTrue(remainingSec > 5300 && remainingSec <= 5400, "Remaining seconds should be around 5400s");
        assertNotNull(session.getFormattedRemainingTime());
        assertTrue(session.getFormattedRemainingTime().startsWith("01:") || session.getFormattedRemainingTime().startsWith("00:"));
    }

    @Test
    @Order(9)
    @DisplayName("Test 9: Student cannot access another student's examination attempt")
    public void testAttemptIsolationAndAccessControl() {
        // Unrelated student 5 attempts to read or mutate Student 4's attempt
        assertThrows(SecurityException.class, () -> {
            examService.getExamSession(createdAttemptId, UNRELATED_STUDENT_ID, 0);
        }, "Accessing another student's exam session must be forbidden");

        boolean saveAttempt = examService.saveAnswer(createdAttemptId, UNRELATED_STUDENT_ID, 1, 1, false);
        assertFalse(saveAttempt, "Mutating another student's answers must fail");

        assertThrows(SecurityException.class, () -> {
            examService.submitExam(createdAttemptId, UNRELATED_STUDENT_ID);
        }, "Submitting another student's exam must be forbidden");
    }

    @Test
    @Order(10)
    @DisplayName("Test 10: Manual submission evaluates answers and transitions status to SUBMITTED")
    public void testManualSubmissionAndScoring() {
        // Answer Q1 with Option B (Correct answer for Q1: Raft quorum partition {S2, S3, S5})
        ExamSessionDto session = examService.getExamSession(createdAttemptId, ELIGIBLE_STUDENT_ID, 0);
        int q1Id = session.getQuestions().get(0).getQuestionId();
        int q1CorrectOptId = session.getQuestions().get(0).getOptions().get(1).getOptionId(); // Option B
        examService.saveAnswer(createdAttemptId, ELIGIBLE_STUDENT_ID, q1Id, q1CorrectOptId, false);

        // Submit exam
        QuizAttempt submitted = examService.submitExam(createdAttemptId, ELIGIBLE_STUDENT_ID);
        assertNotNull(submitted);
        assertEquals("SUBMITTED", submitted.getStatus(), "Status must transition to SUBMITTED");
        assertNotNull(submitted.getEndTime(), "End time must be recorded upon submission");
        assertTrue(submitted.getTotalScore().compareTo(BigDecimal.ZERO) >= 0, "Score must be non-negative");
        assertNotNull(submitted.getGrade());
    }

    @Test
    @Order(11)
    @DisplayName("Test 11: Duplicate submissions and duplicate exam starts are strictly prevented")
    public void testPreventDuplicateSubmissionAndStart() {
        // Idempotent submit call on already submitted attempt
        QuizAttempt resubmitted = examService.submitExam(createdAttemptId, ELIGIBLE_STUDENT_ID);
        assertNotNull(resubmitted);
        assertEquals("SUBMITTED", resubmitted.getStatus());

        // Attempting to start a new exam for the same student on the same quiz must fail
        assertThrows(IllegalStateException.class, () -> {
            examService.startOrResumeExam(ACTIVE_QUIZ_ID, ELIGIBLE_STUDENT_ID, "127.0.0.1", "JUnit Client");
        }, "Starting a second attempt after submission must throw IllegalStateException");
    }

    @Test
    @Order(12)
    @DisplayName("Test 12: Automatic submission when examination time expires")
    public void testAutoSubmitWhenTimeExpires() throws Exception {
        // Create a temporary attempt with start_time 2 hours in the past
        String insertSql = "INSERT INTO quiz_attempts (quiz_id, student_id, start_time, status, ip_address, user_agent) " +
                           "VALUES (?, ?, CURRENT_TIMESTAMP - INTERVAL '2 hours', 'IN_PROGRESS', '127.0.0.1', 'AutoExpire Test') " +
                           "RETURNING attempt_id";

        int expiredAttemptId = 0;
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(insertSql)) {
            ps.setInt(1, ACTIVE_QUIZ_ID);
            ps.setInt(2, UNRELATED_STUDENT_ID); // Marcus Vance
            try (var rs = ps.executeQuery()) {
                if (rs.next()) {
                    expiredAttemptId = rs.getInt("attempt_id");
                }
            }
        }

        assertTrue(expiredAttemptId > 0);

        try {
            // Invoking getExamSession on expired attempt triggers auto-finalize
            ExamSessionDto session = examService.getExamSession(expiredAttemptId, UNRELATED_STUDENT_ID, 0);
            assertNotNull(session);
            assertEquals("SUBMITTED", session.getAttempt().getStatus(), "Expired attempt must automatically finalize to SUBMITTED");
        } finally {
            // Clean up temporary test attempt
            String delSql = "DELETE FROM quiz_attempts WHERE attempt_id = ?";
            try (Connection conn = DatabaseConnection.getConnection();
                 PreparedStatement ps = conn.prepareStatement(delSql)) {
                ps.setInt(1, expiredAttemptId);
                ps.executeUpdate();
            } catch (Exception ignored) {}
        }
    }

    @Test
    @Order(13)
    @DisplayName("Test 13: Multi-choice question evaluation & partial credit (B6)")
    public void testMultiChoicePartialCreditScoring() {
        // 1. Create a test quiz with a MULTI_CHOICE question (6.00 pts, correct: A and C)
        Quiz mcQuiz = new Quiz();
        mcQuiz.setTitle("CS402: Multi-Choice Partial Credit Test");
        mcQuiz.setSubjectId(1);
        mcQuiz.setTeacherId(2);
        mcQuiz.setDurationMinutes(45);
        mcQuiz.setTotalMarks(new BigDecimal("6.00"));
        mcQuiz.setStatus("ACTIVE");
        Quiz created = teacherService.createQuiz(mcQuiz, 2);
        assertNotNull(created);
        int quizId = created.getQuizId();

        try {
            // Assign to Cohort 1
            teacherService.assignQuizToCohort(quizId, 1, null, 2);

            // Add multi-choice question: 6 points, Options: A (correct), B (wrong), C (correct), D (wrong)
            Question q = new Question();
            q.setSubjectId(1);
            q.setQuizId(quizId);
            q.setQuestionText("Which protocols operate at the Application Layer? (Select all that apply)");
            q.setQuestionType("MULTI_CHOICE");
            q.setPoints(new BigDecimal("6.00"));
            q.addOption(new QuestionOption("A", "HTTP", true, 1));
            q.addOption(new QuestionOption("B", "TCP", false, 2));
            q.addOption(new QuestionOption("C", "DNS", true, 3));
            q.addOption(new QuestionOption("D", "IP", false, 4));
            Question createdQ = teacherService.createQuestion(q, 2);
            assertNotNull(createdQ);
            int qId = createdQ.getQuestionId();

            List<QuestionOption> options = createdQ.getOptions();
            int optA = options.get(0).getOptionId();
            int optB = options.get(1).getOptionId();
            int optC = options.get(2).getOptionId();

            // Case A: Full Credit (Select A and C)
            QuizAttempt attemptFull = examService.startOrResumeExam(quizId, 4, "127.0.0.1", "JUnit Client");
            assertNotNull(attemptFull);
            examService.saveAnswer(attemptFull.getAttemptId(), 4, qId, Arrays.asList(optA, optC), false);
            QuizAttempt subFull = examService.submitExam(attemptFull.getAttemptId(), 4);
            assertEquals(0, new BigDecimal("6.00").compareTo(subFull.getTotalScore()), "Full correct selection must receive full 6.00 points");
            assertTrue(subFull.isPassed());

            // Case B: Partial Credit (Select only A -> 1 of 2 correct = 3.00 points)
            QuizAttempt attemptPart = examService.startOrResumeExam(quizId, 5, "127.0.0.1", "JUnit Client");
            assertNotNull(attemptPart);
            examService.saveAnswer(attemptPart.getAttemptId(), 5, qId, Arrays.asList(optA), false);
            QuizAttempt subPart = examService.submitExam(attemptPart.getAttemptId(), 5);
            assertEquals(0, new BigDecimal("3.00").compareTo(subPart.getTotalScore()), "1 of 2 correct must receive 3.00 partial credit points");

            // Case C: Partial Credit with Wrong Option (Select A, B, and C -> 2 correct, 1 wrong = net 1/2 = 3.00 points)
            QuizAttempt attemptPen = examService.startOrResumeExam(quizId, 7, "127.0.0.1", "JUnit Client");
            assertNotNull(attemptPen);
            examService.saveAnswer(attemptPen.getAttemptId(), 7, qId, Arrays.asList(optA, optB, optC), false);
            QuizAttempt subPen = examService.submitExam(attemptPen.getAttemptId(), 7);
            assertEquals(0, new BigDecimal("3.00").compareTo(subPen.getTotalScore()), "2 correct and 1 wrong must receive net partial credit");

            // Case D: Wrong Option Only (Select B -> 0.00 points)
            QuizAttempt attemptWrong = examService.startOrResumeExam(quizId, 8, "127.0.0.1", "JUnit Client");
            assertNotNull(attemptWrong);
            examService.saveAnswer(attemptWrong.getAttemptId(), 8, qId, Arrays.asList(optB), false);
            QuizAttempt subWrong = examService.submitExam(attemptWrong.getAttemptId(), 8);
            assertEquals(0, BigDecimal.ZERO.compareTo(subWrong.getTotalScore()), "Only wrong options selected must receive 0.00 points");

            // Clean up question
            teacherService.removeQuestionFromQuiz(qId, quizId, 2);
            teacherService.deleteQuestion(qId, 2);
        } finally {
            // Clean up attempts and quiz
            try (Connection conn = DatabaseConnection.getConnection();
                 PreparedStatement ps = conn.prepareStatement("DELETE FROM quiz_attempts WHERE quiz_id = ?")) {
                ps.setInt(1, quizId);
                ps.executeUpdate();
            } catch (Exception ignored) {}
            teacherService.deleteQuiz(quizId, 2);
        }
    }

    @Test
    @Order(14)
    @DisplayName("Test 14: Unanswered questions recording and accuracy (B6)")
    public void testUnansweredQuestionsRecording() {
        Quiz testQuiz = new Quiz();
        testQuiz.setTitle("CS402: Unanswered Questions Test");
        testQuiz.setSubjectId(1);
        testQuiz.setTeacherId(2);
        testQuiz.setDurationMinutes(30);
        testQuiz.setStatus("ACTIVE");
        Quiz created = teacherService.createQuiz(testQuiz, 2);
        int quizId = created.getQuizId();

        try {
            teacherService.assignQuizToCohort(quizId, 1, null, 2);

            // Add Q1 (4 points)
            Question q1 = new Question();
            q1.setSubjectId(1);
            q1.setQuizId(quizId);
            q1.setQuestionText("Q1: Primary Protocol Question?");
            q1.setQuestionType("SINGLE_CHOICE");
            q1.setPoints(new BigDecimal("4.00"));
            q1.addOption(new QuestionOption("A", "Correct Ans", true, 1));
            q1.addOption(new QuestionOption("B", "Wrong Ans", false, 2));
            Question createdQ1 = teacherService.createQuestion(q1, 2);

            // Add Q2 (4 points)
            Question q2 = new Question();
            q2.setSubjectId(1);
            q2.setQuizId(quizId);
            q2.setQuestionText("Q2: Secondary Architecture Question?");
            q2.setQuestionType("SINGLE_CHOICE");
            q2.setPoints(new BigDecimal("4.00"));
            q2.addOption(new QuestionOption("A", "Correct Ans", true, 1));
            q2.addOption(new QuestionOption("B", "Wrong Ans", false, 2));
            Question createdQ2 = teacherService.createQuestion(q2, 2);

            // Start attempt for student 4
            QuizAttempt attempt = examService.startOrResumeExam(quizId, 4, "127.0.0.1", "JUnit Client");
            assertNotNull(attempt);

            // Answer ONLY Q1; leave Q2 completely untouched (unanswered)
            int optA = createdQ1.getOptions().get(0).getOptionId();
            examService.saveAnswer(attempt.getAttemptId(), 4, createdQ1.getQuestionId(), optA, false);

            // Submit exam
            QuizAttempt submitted = examService.submitExam(attempt.getAttemptId(), 4);
            assertNotNull(submitted);
            assertEquals(0, new BigDecimal("4.00").compareTo(submitted.getTotalScore()));

            // Verify student_answers table: BOTH questions must have records
            Map<Integer, StudentAnswer> answersMap = examDao.getStudentAnswersForAttempt(attempt.getAttemptId());
            assertEquals(2, answersMap.size(), "Both answered and unanswered questions must have records in student_answers");

            StudentAnswer ans1 = answersMap.get(createdQ1.getQuestionId());
            assertNotNull(ans1);
            assertTrue(ans1.getIsCorrect(), "Q1 answered correctly");
            assertEquals(0, new BigDecimal("4.00").compareTo(ans1.getMarksAwarded()));

            StudentAnswer ans2 = answersMap.get(createdQ2.getQuestionId());
            assertNotNull(ans2);
            assertFalse(ans2.getIsCorrect(), "Unanswered Q2 must be evaluated as not correct");
            assertEquals(0, BigDecimal.ZERO.compareTo(ans2.getMarksAwarded()), "Unanswered Q2 must be awarded 0.00 marks");
            assertNull(ans2.getSelectedOptionId(), "Unanswered Q2 must have null selected_option_id");

            teacherService.removeQuestionFromQuiz(createdQ1.getQuestionId(), quizId, 2);
            teacherService.deleteQuestion(createdQ1.getQuestionId(), 2);
            teacherService.removeQuestionFromQuiz(createdQ2.getQuestionId(), quizId, 2);
            teacherService.deleteQuestion(createdQ2.getQuestionId(), 2);
        } finally {
            try (Connection conn = DatabaseConnection.getConnection();
                 PreparedStatement ps = conn.prepareStatement("DELETE FROM quiz_attempts WHERE quiz_id = ?")) {
                ps.setInt(1, quizId);
                ps.executeUpdate();
            } catch (Exception ignored) {}
            teacherService.deleteQuiz(quizId, 2);
        }
    }

    @Test
    @Order(15)
    @DisplayName("Test 15: Authored quiz percentage calculation from sum of points (B6)")
    public void testAuthoredQuizPercentageFromSumOfPoints() {
        Quiz testQuiz = new Quiz();
        testQuiz.setTitle("CS402: Total Marks Sum Calculation Test");
        testQuiz.setSubjectId(1);
        testQuiz.setTeacherId(2);
        testQuiz.setDurationMinutes(30);
        testQuiz.setStatus("ACTIVE");
        Quiz created = teacherService.createQuiz(testQuiz, 2);
        int quizId = created.getQuizId();

        try {
            teacherService.assignQuizToCohort(quizId, 1, null, 2);

            // Add Q1 (4 points) + Q2 (6 points) = 10 points total
            Question q1 = new Question();
            q1.setSubjectId(1);
            q1.setQuizId(quizId);
            q1.setQuestionText("Q1: 4 Points Question?");
            q1.setQuestionType("SINGLE_CHOICE");
            q1.setPoints(new BigDecimal("4.00"));
            q1.addOption(new QuestionOption("A", "Correct", true, 1));
            q1.addOption(new QuestionOption("B", "Wrong", false, 2));
            Question createdQ1 = teacherService.createQuestion(q1, 2);

            Question q2 = new Question();
            q2.setSubjectId(1);
            q2.setQuizId(quizId);
            q2.setQuestionText("Q2: 6 Points Question?");
            q2.setQuestionType("SINGLE_CHOICE");
            q2.setPoints(new BigDecimal("6.00"));
            q2.addOption(new QuestionOption("A", "Correct", true, 1));
            q2.addOption(new QuestionOption("B", "Wrong", false, 2));
            Question createdQ2 = teacherService.createQuestion(q2, 2);

            // Start attempt for student 4
            QuizAttempt attempt = examService.startOrResumeExam(quizId, 4, "127.0.0.1", "JUnit Client");
            assertNotNull(attempt);

            // Answer Q1 correctly (4.00 pts) and Q2 incorrectly (0.00 pts)
            int q1Correct = createdQ1.getOptions().get(0).getOptionId();
            int q2Wrong = createdQ2.getOptions().get(1).getOptionId();
            examService.saveAnswer(attempt.getAttemptId(), 4, createdQ1.getQuestionId(), q1Correct, false);
            examService.saveAnswer(attempt.getAttemptId(), 4, createdQ2.getQuestionId(), q2Wrong, false);

            // Submit exam
            QuizAttempt submitted = examService.submitExam(attempt.getAttemptId(), 4);
            assertNotNull(submitted);
            assertEquals(0, new BigDecimal("4.00").compareTo(submitted.getTotalScore()), "Total score must be 4.00");

            // Percentage: 4.00 / 10.00 = 40.00%
            assertEquals(0, new BigDecimal("40.00").compareTo(submitted.getPercentage()), "Percentage must be 40.00% based on sum of question points (4/10)");

            teacherService.removeQuestionFromQuiz(createdQ1.getQuestionId(), quizId, 2);
            teacherService.deleteQuestion(createdQ1.getQuestionId(), 2);
            teacherService.removeQuestionFromQuiz(createdQ2.getQuestionId(), quizId, 2);
            teacherService.deleteQuestion(createdQ2.getQuestionId(), 2);
        } finally {
            try (Connection conn = DatabaseConnection.getConnection();
                 PreparedStatement ps = conn.prepareStatement("DELETE FROM quiz_attempts WHERE quiz_id = ?")) {
                ps.setInt(1, quizId);
                ps.executeUpdate();
            } catch (Exception ignored) {}
            teacherService.deleteQuiz(quizId, 2);
        }
    }
}
