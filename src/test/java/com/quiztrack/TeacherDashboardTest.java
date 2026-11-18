package com.quiztrack;

import com.quiztrack.dao.AnalyticsDao;
import com.quiztrack.dao.QuizDao;
import com.quiztrack.dao.impl.AnalyticsDaoImpl;
import com.quiztrack.dao.impl.QuizDaoImpl;
import com.quiztrack.model.Quiz;
import com.quiztrack.model.TeacherDashboardData;
import com.quiztrack.service.TeacherService;
import com.quiztrack.service.impl.TeacherServiceImpl;
import com.quiztrack.util.DatabaseConnection;
import org.junit.jupiter.api.*;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;

@TestMethodOrder(MethodOrderer.OrderAnnotation.class)
public class TeacherDashboardTest {

    private static QuizDao quizDao;
    private static AnalyticsDao analyticsDao;
    private static TeacherService teacherService;

    @BeforeAll
    public static void setUp() {
        quizDao = new QuizDaoImpl();
        analyticsDao = new AnalyticsDaoImpl();
        teacherService = new TeacherServiceImpl(quizDao, analyticsDao);
    }

    @AfterAll
    public static void tearDown() {
        DatabaseConnection.closePool();
    }

    @Test
    @Order(1)
    @DisplayName("Test 1: QuizDao Find Active Quiz Returns CS402 Midterm")
    public void testFindActiveQuiz() {
        Optional<Quiz> activeQuizOpt = quizDao.findActiveQuiz();
        assertTrue(activeQuizOpt.isPresent(), "An active quiz must be present from seed data");
        Quiz activeQuiz = activeQuizOpt.get();
        assertEquals("ACTIVE", activeQuiz.getStatus(), "Status must be ACTIVE");
        assertTrue(activeQuiz.getTitle().contains("CS402"), "Title should reference CS402");
        assertEquals("CS402", activeQuiz.getSubjectCode());
        assertEquals(90, activeQuiz.getDurationMinutes());
        assertTrue(activeQuiz.getTotalQuestions() >= 5, "Quiz should have questions attached");
    }

    @Test
    @Order(2)
    @DisplayName("Test 2: QuizDao Find All Quizzes Returns Complete Course Schedule")
    public void testFindAllQuizzes() {
        List<Quiz> quizzes = quizDao.findAllQuizzes();
        assertNotNull(quizzes);
        assertTrue(quizzes.size() >= 3, "There should be at least 3 quizzes in database");
        
        // First quiz in list must be the active one
        assertEquals("ACTIVE", quizzes.get(0).getStatus(), "Active quiz should be prioritized at top");
    }

    @Test
    @Order(3)
    @DisplayName("Test 3: Quiz Status Counts")
    public void testQuizStatusCounts() {
        int active = quizDao.countQuizzesByStatus("ACTIVE");
        int scheduled = quizDao.countQuizzesByStatus("SCHEDULED");
        int total = quizDao.countTotalQuizzes();

        assertTrue(active >= 1, "At least 1 active quiz required");
        assertTrue(scheduled >= 1, "At least 1 scheduled quiz required");
        assertTrue(total >= active + scheduled, "Total quizzes must be greater than or equal to active + scheduled");
    }

    @Test
    @Order(4)
    @DisplayName("Test 4: AnalyticsDao Student Count & Average Class Score")
    public void testAnalyticsDaoMetrics() {
        int students = analyticsDao.countTotalStudents();
        assertTrue(students >= 6, "Seeded student count must be at least 6");

        double avgScore = analyticsDao.calculateAverageClassScore();
        assertTrue(avgScore >= 50.0 && avgScore <= 100.0, "Average class score should fall within realistic range");

        double trustIndex = analyticsDao.getProctorTrustIndex();
        assertTrue(trustIndex >= 90.0 && trustIndex <= 100.0, "Proctor trust index should be within high integrity range");
    }

    @Test
    @Order(5)
    @DisplayName("Test 5: Concept Mastery Taxonomy Stats for CS402")
    public void testTopicMasteryStats() {
        List<TeacherDashboardData.TopicMastery> topics = analyticsDao.getTopicMasteryStats(1);
        assertNotNull(topics);
        assertFalse(topics.isEmpty(), "Topic mastery list must not be empty");

        boolean hasRaft = false;
        boolean hasLamport = false;

        for (TeacherDashboardData.TopicMastery t : topics) {
            if (t.getTopicName().contains("Raft") || t.getTopicName().contains("Consensus")) {
                hasRaft = true;
                assertTrue(t.getMasteryPercentage() > 80.0, "Raft consensus mastery should be high");
            }
            if (t.getTopicName().contains("Lamport") || t.getTopicName().contains("Logical")) {
                hasLamport = true;
                assertTrue(t.isReviewNeeded(), "Lamport clocks should be marked review needed");
            }
        }

        assertTrue(hasRaft, "Raft topic mastery must be tracked");
        assertTrue(hasLamport, "Lamport topic mastery must be tracked");
    }

    @Test
    @Order(6)
    @DisplayName("Test 6: TeacherService Aggregates Complete TeacherDashboardData DTO")
    public void testTeacherServiceDashboardOverview() {
        TeacherDashboardData data = teacherService.getDashboardOverview(2); // Prof. Ronald Vance
        assertNotNull(data, "Dashboard data must not be null");

        // Validate KPIs
        assertTrue(data.getTotalStudents() >= 6);
        assertTrue(data.getActiveQuizzesCount() >= 1);
        assertTrue(data.getAverageClassScore() > 0);
        assertTrue(data.getProctorTrustIndex() >= 90.0);

        // Validate Active Banner
        assertNotNull(data.getActiveQuiz(), "Active quiz banner must be populated");
        assertEquals("CS402: Midterm Exam - Distributed Systems & Concurrency", data.getActiveQuiz().getTitle());
        assertTrue(data.getActiveExaminees() > 0);
        assertTrue(data.getConnectedPercentage() > 0);

        // Validate Schedule & Comparisons
        assertFalse(data.getExaminationSchedule().isEmpty());
        assertFalse(data.getCohortComparisonList().isEmpty());
        assertFalse(data.getPendingAudits().isEmpty());
    }

    @Test
    @Order(7)
    @DisplayName("Test 7: Truthful Faculty Dashboard Metrics (B13)")
    public void testTruthfulFacultyDashboardMetrics() {
        // Prof. Clara Oswald (Teacher ID 3)
        TeacherDashboardData claraData = teacherService.getDashboardOverview(3);
        assertNotNull(claraData, "Clara dashboard data must not be null");

        // B13: Schedule must NOT leak Teacher Ronald's quizzes (teacher_id = 2)
        for (com.quiztrack.model.Quiz q : claraData.getExaminationSchedule()) {
            assertEquals(3, q.getTeacherId(), "Clara's schedule must only list quizzes authored by Clara");
        }

        // B13: Ronald's active banner remaining time must be dynamic and NOT hardcoded "52m remaining"
        TeacherDashboardData ronaldData = teacherService.getDashboardOverview(2);
        assertNotNull(ronaldData.getActiveQuiz());
        assertNotNull(ronaldData.getRemainingTimeFormatted());
        assertNotEquals("52m remaining", ronaldData.getRemainingTimeFormatted(), "Remaining time must be dynamically computed, not hardcoded 52m remaining");
    }

    @Test
    @Order(8)
    @DisplayName("Test 8: Question Bank Parity - Multi-Choice and True/False Item Creation")
    public void testQuestionBankMultiChoiceAndTrueFalseAuthoring() {
        // Multi-choice authoring in question bank
        com.quiztrack.model.Question mcq = new com.quiztrack.model.Question();
        mcq.setSubjectId(1);
        mcq.setQuestionText("Which protocols provide distributed consensus guarantees?");
        mcq.setQuestionType("MULTI_CHOICE");
        mcq.setPoints(new java.math.BigDecimal("2.0"));
        mcq.setDifficultyLevel("HARD");
        mcq.setTaxonomyTopic("Consensus");

        List<com.quiztrack.model.QuestionOption> mcqOpts = new ArrayList<>();
        mcqOpts.add(new com.quiztrack.model.QuestionOption("A", "Paxos", true, 1));
        mcqOpts.add(new com.quiztrack.model.QuestionOption("B", "Raft", true, 2));
        mcqOpts.add(new com.quiztrack.model.QuestionOption("C", "HTTP 1.1", false, 3));
        mcqOpts.add(new com.quiztrack.model.QuestionOption("D", "SMTP", false, 4));
        mcq.setOptions(mcqOpts);

        com.quiztrack.model.Question createdMcq = teacherService.createQuestion(mcq, 2);
        assertNotNull(createdMcq);
        assertTrue(createdMcq.getQuestionId() > 0);

        // True/False authoring in question bank
        com.quiztrack.model.Question tf = new com.quiztrack.model.Question();
        tf.setSubjectId(1);
        tf.setQuestionText("Vector clocks provide total causal ordering of concurrent events.");
        tf.setQuestionType("TRUE_FALSE");
        tf.setPoints(new java.math.BigDecimal("1.0"));
        tf.setDifficultyLevel("MEDIUM");
        tf.setTaxonomyTopic("Clocks");

        List<com.quiztrack.model.QuestionOption> tfOpts = new ArrayList<>();
        tfOpts.add(new com.quiztrack.model.QuestionOption("A", "True", true, 1));
        tfOpts.add(new com.quiztrack.model.QuestionOption("B", "False", false, 2));
        tf.setOptions(tfOpts);

        com.quiztrack.model.Question createdTf = teacherService.createQuestion(tf, 2);
        assertNotNull(createdTf);
        assertTrue(createdTf.getQuestionId() > 0);

        // Clean up
        teacherService.deleteQuestion(createdMcq.getQuestionId(), 2);
        teacherService.deleteQuestion(createdTf.getQuestionId(), 2);
    }

    @Test
    @Order(9)
    @DisplayName("Test 9: Violation Logs Audit Trail Retrieval")
    public void testViolationLogsAuditTrail() {
        com.quiztrack.dao.ProctorDao proctorDao = new com.quiztrack.dao.impl.ProctorDaoImpl();
        List<com.quiztrack.model.ProctorActivityEventDto> logs = proctorDao.getViolationLogs(null, "ALL", 50);
        assertNotNull(logs, "Violation logs list must not be null");
        assertFalse(logs.isEmpty(), "Violation logs should contain audit trail records from seed data");
    }
}
