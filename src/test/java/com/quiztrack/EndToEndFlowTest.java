package com.quiztrack;

import com.quiztrack.dao.*;
import com.quiztrack.dao.impl.*;
import com.quiztrack.model.*;
import com.quiztrack.service.ExamService;
import com.quiztrack.service.TeacherService;
import com.quiztrack.service.impl.ExamServiceImpl;
import com.quiztrack.service.impl.TeacherServiceImpl;
import com.quiztrack.util.DatabaseConnection;
import org.junit.jupiter.api.*;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.*;

import static org.junit.jupiter.api.Assertions.*;

/**
 * Complete End-to-End lifecycle integration test:
 * Teacher Quiz Creation -> Question Builder (Single, Multi, T/F) -> Auto Marks Sync
 * -> Cohort Assignment -> Validation & Publish -> Student Attempt -> Multi-choice Partial Credit
 * -> Exam Submission & Final Grading -> Itemized Review & Proctor Telemetry.
 */
@TestMethodOrder(MethodOrderer.OrderAnnotation.class)
public class EndToEndFlowTest {

    private static QuizDao quizDao;
    private static QuestionDao questionDao;
    private static QuizAssignmentDao assignmentDao;
    private static ExamDao examDao;
    private static ResultDao resultDao;
    private static ProctorDao proctorDao;
    private static AnalyticsDao analyticsDao;

    private static TeacherService teacherService;
    private static ExamService examService;

    private static int createdQuizId;
    private static int singleChoiceQId;
    private static int multiChoiceQId;
    private static int trueFalseQId;
    private static int attemptId;

    private static final int TEACHER_ID = 2; // Dr. Ronald Vance
    private static final int STUDENT_ID = 4; // Alex Mercer (CS-2022-041)

    @BeforeAll
    public static void setUp() {
        quizDao = new QuizDaoImpl();
        questionDao = new QuestionDaoImpl();
        assignmentDao = new QuizAssignmentDaoImpl();
        examDao = new ExamDaoImpl();
        resultDao = new ResultDaoImpl();
        proctorDao = new ProctorDaoImpl();
        analyticsDao = new AnalyticsDaoImpl();

        teacherService = new TeacherServiceImpl(quizDao, analyticsDao);
        examService = new ExamServiceImpl(examDao);
    }

    @AfterAll
    public static void tearDown() {
        if (createdQuizId > 0) {
            try (Connection conn = DatabaseConnection.getConnection()) {
                // Clean up attempt and quiz associations
                try (PreparedStatement ps = conn.prepareStatement(
                        "DELETE FROM student_answer_options WHERE answer_id IN (" +
                        "  SELECT answer_id FROM student_answers WHERE attempt_id IN (" +
                        "    SELECT attempt_id FROM quiz_attempts WHERE quiz_id = ?))")) {
                    ps.setInt(1, createdQuizId);
                    ps.executeUpdate();
                }
                try (PreparedStatement ps = conn.prepareStatement(
                        "DELETE FROM student_answers WHERE attempt_id IN (SELECT attempt_id FROM quiz_attempts WHERE quiz_id = ?)")) {
                    ps.setInt(1, createdQuizId);
                    ps.executeUpdate();
                }
                try (PreparedStatement ps = conn.prepareStatement("DELETE FROM activity_logs WHERE attempt_id IN (SELECT attempt_id FROM quiz_attempts WHERE quiz_id = ?)")) {
                    ps.setInt(1, createdQuizId);
                    ps.executeUpdate();
                }
                try (PreparedStatement ps = conn.prepareStatement("DELETE FROM results WHERE quiz_id = ?")) {
                    ps.setInt(1, createdQuizId);
                    ps.executeUpdate();
                }
                try (PreparedStatement ps = conn.prepareStatement("DELETE FROM quiz_attempts WHERE quiz_id = ?")) {
                    ps.setInt(1, createdQuizId);
                    ps.executeUpdate();
                }
                try (PreparedStatement ps = conn.prepareStatement("DELETE FROM quiz_assignments WHERE quiz_id = ?")) {
                    ps.setInt(1, createdQuizId);
                    ps.executeUpdate();
                }
                try (PreparedStatement ps = conn.prepareStatement("DELETE FROM quiz_questions WHERE quiz_id = ?")) {
                    ps.setInt(1, createdQuizId);
                    ps.executeUpdate();
                }
                try (PreparedStatement ps = conn.prepareStatement("DELETE FROM quizzes WHERE quiz_id = ?")) {
                    ps.setInt(1, createdQuizId);
                    ps.executeUpdate();
                }
            } catch (SQLException ignored) {
            }
        }
        DatabaseConnection.closePool();
    }

    @Test
    @Order(1)
    @DisplayName("Stage 1: Teacher creates initial draft quiz with system defaults")
    public void testStage1_TeacherCreatesQuiz() {
        Quiz quiz = new Quiz();
        quiz.setTitle("E2E Comprehensive Capstone Examination");
        quiz.setSubjectId(1); // CS402
        quiz.setDescription("Full lifecycle verification covering Single, Multi, and T/F questions.");
        quiz.setTeacherId(TEACHER_ID);
        quiz.setDurationMinutes(45);
        quiz.setPassPercentage(new BigDecimal("50.00"));
        quiz.setTotalMarks(BigDecimal.ZERO);
        quiz.setNegativeMarkValue(new BigDecimal("0.50"));
        quiz.setNegativeMarking(true);
        quiz.setWebcamRequired(true);
        quiz.setFullscreenRequired(true);
        quiz.setShuffleQuestions(true);
        quiz.setMaxTabSwitches(3);
        quiz.setStatus("DRAFT");

        Quiz created = teacherService.createQuiz(quiz, TEACHER_ID);
        assertNotNull(created);
        assertTrue(created.getQuizId() > 0);
        assertEquals("DRAFT", created.getStatus());
        createdQuizId = created.getQuizId();
    }

    @Test
    @Order(2)
    @DisplayName("Stage 2: Teacher authors Single Choice, Multi Choice, and True/False questions")
    public void testStage2_AddQuestionsAcrossAllTypes() {
        // 1. Single Choice Question (2.0 pts)
        Question sc = new Question();
        sc.setQuizId(createdQuizId);
        sc.setSubjectId(1);
        sc.setQuestionText("What is the consensus algorithm used by Raft to elect a leader?");
        sc.setQuestionType("SINGLE_CHOICE");
        sc.setPoints(new BigDecimal("2.00"));
        sc.setDifficultyLevel("MEDIUM");
        sc.setTaxonomyTopic("Consensus");

        List<QuestionOption> scOpts = new ArrayList<>();
        scOpts.add(new QuestionOption("A", "Randomized Election Timers", true, 1));
        scOpts.add(new QuestionOption("B", "Two-Phase Commit Locking", false, 2));
        scOpts.add(new QuestionOption("C", "Gossip Multicast Protocol", false, 3));
        scOpts.add(new QuestionOption("D", "Byzantine Fault Ring", false, 4));
        sc.setOptions(scOpts);

        Question createdSc = teacherService.createQuestion(sc, TEACHER_ID);
        assertNotNull(createdSc);
        singleChoiceQId = createdSc.getQuestionId();

        // 2. Multi Choice Question (4.0 pts) with 2 correct answers
        Question mc = new Question();
        mc.setQuizId(createdQuizId);
        mc.setSubjectId(1);
        mc.setQuestionText("Which properties are guaranteed by the CAP theorem in distributed systems?");
        mc.setQuestionType("MULTI_CHOICE");
        mc.setPoints(new BigDecimal("4.00"));
        mc.setDifficultyLevel("HARD");
        mc.setTaxonomyTopic("Distributed Theory");

        List<QuestionOption> mcOpts = new ArrayList<>();
        mcOpts.add(new QuestionOption("A", "Consistency", true, 1));
        mcOpts.add(new QuestionOption("B", "Availability", true, 2));
        mcOpts.add(new QuestionOption("C", "Linear Scalability", false, 3));
        mcOpts.add(new QuestionOption("D", "Quantum Invariance", false, 4));
        mc.setOptions(mcOpts);

        Question createdMc = teacherService.createQuestion(mc, TEACHER_ID);
        assertNotNull(createdMc);
        multiChoiceQId = createdMc.getQuestionId();

        // 3. True/False Question (1.0 pt)
        Question tf = new Question();
        tf.setQuizId(createdQuizId);
        tf.setSubjectId(1);
        tf.setQuestionText("Vector clocks can detect concurrent causal violations between distributed nodes.");
        tf.setQuestionType("TRUE_FALSE");
        tf.setPoints(new BigDecimal("1.00"));
        tf.setDifficultyLevel("EASY");
        tf.setTaxonomyTopic("Clocks");

        List<QuestionOption> tfOpts = new ArrayList<>();
        tfOpts.add(new QuestionOption("A", "True", true, 1));
        tfOpts.add(new QuestionOption("B", "False", false, 2));
        tf.setOptions(tfOpts);

        Question createdTf = teacherService.createQuestion(tf, TEACHER_ID);
        assertNotNull(createdTf);
        trueFalseQId = createdTf.getQuestionId();

        // Verify total marks auto-synchronized: 2.0 + 4.0 + 1.0 = 7.00
        quizDao.syncTotalMarks(createdQuizId);
        Optional<Quiz> qOpt = quizDao.findById(createdQuizId);
        assertTrue(qOpt.isPresent());
        assertEquals(0, new BigDecimal("7.00").compareTo(qOpt.get().getTotalMarks()),
                "Total marks must be auto-computed from sum of question points (7.00)");
        assertEquals(3, qOpt.get().getTotalQuestions(), "Must have exactly 3 questions attached via quiz_questions");
    }

    @Test
    @Order(3)
    @DisplayName("Stage 3: Teacher assigns academic cohort and attempts publish without targets")
    public void testStage3_CohortAssignmentAndValidation() {
        // Publish without assignment must fail
        IllegalArgumentException ex = assertThrows(IllegalArgumentException.class, () ->
                teacherService.validateQuizForPublish(createdQuizId, TEACHER_ID));
        assertTrue(ex.getMessage().contains("at least one cohort or student"),
                "Publish checklist must enforce target assignment requirement");

        // Assign Cohort 1 (CS-2022) to quiz
        boolean assigned = teacherService.assignQuizToCohort(createdQuizId, 1, null, TEACHER_ID);
        assertTrue(assigned, "Cohort assignment should succeed");
        assertTrue(assignmentDao.isCohortAssigned(createdQuizId, 1));

        // Now publish validation should pass
        assertDoesNotThrow(() -> teacherService.validateQuizForPublish(createdQuizId, TEACHER_ID));

        // Publish to ACTIVE
        boolean statusUpdated = quizDao.updateStatus(createdQuizId, "ACTIVE");
        assertTrue(statusUpdated);
    }

    @Test
    @Order(4)
    @DisplayName("Stage 4: Student starts exam, autosaves answers, and submits with partial credit")
    public void testStage4_StudentTakesAndSubmitsExam() {
        // Verify student eligibility (quizId, studentId)
        assertTrue(examDao.isStudentEligible(createdQuizId, STUDENT_ID),
                "Alex Mercer enrolled in Cohort 1 must be eligible to take active quiz");

        // Start exam attempt
        QuizAttempt attempt = examService.startOrResumeExam(createdQuizId, STUDENT_ID, "127.0.0.1", "JUnit Client");
        assertNotNull(attempt, "Attempt must be successfully started");
        attemptId = attempt.getAttemptId();
        assertTrue(attemptId > 0);

        // Load quiz questions and retrieve option IDs
        List<Question> examQuestions = examDao.getQuizQuestions(createdQuizId, false);
        assertEquals(3, examQuestions.size());

        Question scDto = examQuestions.stream().filter(q -> q.getQuestionId() == singleChoiceQId).findFirst().orElseThrow();
        Question mcDto = examQuestions.stream().filter(q -> q.getQuestionId() == multiChoiceQId).findFirst().orElseThrow();
        Question tfDto = examQuestions.stream().filter(q -> q.getQuestionId() == trueFalseQId).findFirst().orElseThrow();

        // 1. Single Choice: Select option A (Correct -> +2.0 pts)
        int scCorrectOptId = scDto.getOptions().stream().filter(o -> "A".equals(o.getOptionLetter())).findFirst().orElseThrow().getOptionId();
        examService.saveAnswer(attemptId, STUDENT_ID, singleChoiceQId, scCorrectOptId, false);

        // 2. Multi Choice: Select only option A (Consistency) out of A and B
        // Total correct = 2. Correct selected = 1. Wrong selected = 0.
        // Partial credit formula: 4.0 * (1 - 0) / 2 = +2.0 pts out of 4.0 pts
        int mcOptAId = mcDto.getOptions().stream().filter(o -> "A".equals(o.getOptionLetter())).findFirst().orElseThrow().getOptionId();
        examService.saveAnswer(attemptId, STUDENT_ID, multiChoiceQId, List.of(mcOptAId), false);

        // 3. True/False: Select option A (True -> Correct -> +1.0 pt)
        int tfCorrectOptId = tfDto.getOptions().stream().filter(o -> "A".equals(o.getOptionLetter())).findFirst().orElseThrow().getOptionId();
        examService.saveAnswer(attemptId, STUDENT_ID, trueFalseQId, tfCorrectOptId, false);

        // Submit exam
        QuizAttempt submitted = examService.submitExam(attemptId, STUDENT_ID);
        assertNotNull(submitted, "Attempt should be marked submitted");
        assertEquals("SUBMITTED", submitted.getStatus());

        // Expected score: 2.0 (SC) + 2.0 (MC partial credit) + 1.0 (TF) = 5.00
        BigDecimal expectedScore = new BigDecimal("5.00");
        assertEquals(0, expectedScore.compareTo(submitted.getTotalScore().setScale(2, RoundingMode.HALF_UP)),
                "Score must exactly match 5.00 (Single: 2.0, Multi partial: 2.0, TF: 1.0)");

        // Total marks = 7.00. Percentage: 5.00 / 7.00 * 100 = 71.43%
        BigDecimal expectedPercentage = expectedScore.divide(new BigDecimal("7.00"), 4, RoundingMode.HALF_UP)
                .multiply(new BigDecimal("100")).setScale(2, RoundingMode.HALF_UP);
        assertEquals(0, expectedPercentage.compareTo(submitted.getPercentage().setScale(2, RoundingMode.HALF_UP)),
                "Percentage must be calculated against total question points: " + expectedPercentage);

        assertTrue(submitted.isPassed(), "71.43% must exceed the 50.00% pass benchmark");

        // Verify result persisted in results table
        Optional<StudentResultDto> resultDtoOpt = resultDao.getResultByAttemptId(attemptId, STUDENT_ID);
        assertTrue(resultDtoOpt.isPresent());
        StudentResultDto resultDto = resultDtoOpt.get();
        assertEquals(0, expectedScore.compareTo(resultDto.getScore().setScale(2, RoundingMode.HALF_UP)));
    }

    @Test
    @Order(5)
    @DisplayName("Stage 5: Verification of Itemized Review, Multi-Option Storage, and Telemetry")
    public void testStage5_ItemizedReviewAndTelemetry() {
        // Verify itemized questions review
        List<QuestionReviewDto> reviews = resultDao.getQuestionReviews(attemptId);
        assertEquals(3, reviews.size());

        // Check Multi-Choice review
        QuestionReviewDto mcReview = reviews.stream().filter(r -> r.getQuestionId() == multiChoiceQId).findFirst().orElseThrow();
        assertEquals(0, new BigDecimal("2.00").compareTo(mcReview.getMarksAwarded().setScale(2, RoundingMode.HALF_UP)),
                "Marks awarded for multi-choice with partial credit must be 2.00");

        // Verify proctoring violation telemetry recording
        boolean logged = examDao.recordTelemetryEvent(attemptId, STUDENT_ID, "TAB_SWITCH", "CRITICAL",
                "Browser blur event detected: candidate navigated to external reference window");
        assertTrue(logged, "Proctor telemetry event should be logged in activity logs");

        // Fetch violation logs for teacher 2
        List<ProctorActivityEventDto> violations = proctorDao.getViolationLogs(TEACHER_ID, "ALL", 10);
        assertNotNull(violations);
        assertFalse(violations.isEmpty(), "Violation logs should contain recorded proctoring events");
    }
}
