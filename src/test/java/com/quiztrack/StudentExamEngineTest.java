package com.quiztrack;

import com.quiztrack.dao.ExamDao;
import com.quiztrack.dao.QuizDao;
import com.quiztrack.dao.impl.ExamDaoImpl;
import com.quiztrack.dao.impl.QuizDaoImpl;
import com.quiztrack.model.*;
import com.quiztrack.service.ExamService;
import com.quiztrack.service.impl.ExamServiceImpl;
import com.quiztrack.util.DatabaseConnection;
import org.junit.jupiter.api.*;

import java.lang.reflect.Field;
import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.util.List;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;

@TestMethodOrder(MethodOrderer.OrderAnnotation.class)
public class StudentExamEngineTest {

    private static ExamDao examDao;
    private static QuizDao quizDao;
    private static ExamService examService;

    private static final int ELIGIBLE_STUDENT_ID = 6; // David Kim (CS-2022-088)
    private static final int UNRELATED_STUDENT_ID = 5; // Marcus Vance
    private static final int INELIGIBLE_STUDENT_ID = 9999;
    private static final int ACTIVE_QUIZ_ID = 1; // CS402 Midterm Exam
    private static int createdAttemptId = 0;

    @BeforeAll
    public static void setUp() {
        examDao = new ExamDaoImpl();
        quizDao = new QuizDaoImpl();
        examService = new ExamServiceImpl(examDao);

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
}
