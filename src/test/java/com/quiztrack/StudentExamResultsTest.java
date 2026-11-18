package com.quiztrack;

import com.quiztrack.dao.ResultDao;
import com.quiztrack.dao.impl.ResultDaoImpl;
import com.quiztrack.model.*;
import com.quiztrack.service.ResultService;
import com.quiztrack.service.impl.ResultServiceImpl;
import org.junit.jupiter.api.*;

import java.math.BigDecimal;
import java.util.List;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;

@TestMethodOrder(MethodOrderer.OrderAnnotation.class)
public class StudentExamResultsTest {

    private static ResultService resultService;
    private static ResultDao resultDao;
    private static final int ALEX_MERCER_STUDENT_ID = 4;
    private static final int MARCUS_VANCE_STUDENT_ID = 5;
    private static final int SEEDED_ATTEMPT_ID = 1;
    private static final int SEEDED_QUIZ_ID = 1;

    @BeforeAll
    static void setUp() {
        resultDao = new ResultDaoImpl();
        resultService = new ResultServiceImpl(resultDao);
    }

    @Test
    @Order(1)
    @DisplayName("Verify ResultDao retrieves published attempt 1 for student 4")
    void testGetResultByAttemptIdDao() {
        Optional<StudentResultDto> opt = resultDao.getResultByAttemptId(SEEDED_ATTEMPT_ID, ALEX_MERCER_STUDENT_ID);
        assertTrue(opt.isPresent(), "Attempt 1 should be found for student 4");

        StudentResultDto dto = opt.get();
        assertEquals(SEEDED_ATTEMPT_ID, dto.getAttemptId());
        assertEquals(ALEX_MERCER_STUDENT_ID, dto.getStudentId());
        assertEquals("CS-2022-041", dto.getStudentIdentifier());
        assertEquals(SEEDED_QUIZ_ID, dto.getQuizId());
        assertEquals("CS402", dto.getSubjectCode());
        assertEquals(new BigDecimal("118.00"), dto.getScore());
        assertEquals(new BigDecimal("140.00"), dto.getMaxScore());
        assertTrue(dto.isPassed(), "Student score 118 exceeds passing cutoff");
    }

    @Test
    @Order(2)
    @DisplayName("Verify Question-by-Question Review DAO retrieves all questions with options")
    void testGetQuestionReviewsDao() {
        List<QuestionReviewDto> reviews = resultDao.getQuestionReviews(SEEDED_ATTEMPT_ID);
        assertNotNull(reviews, "Question reviews list should not be null");
        assertEquals(5, reviews.size(), "Seeded attempt 1 should have 5 question reviews");

        for (QuestionReviewDto review : reviews) {
            assertTrue(review.getQuestionId() > 0);
            assertNotNull(review.getQuestionText(), "Question text should not be null");
            assertNotNull(review.getOptions(), "Options should not be null");
            assertTrue(review.getOptions().size() >= 4, "Every question should have at least 4 options");
            assertNotNull(review.getExplanation(), "Pedagogical explanation should be provided");
            assertNotNull(review.getTopicName(), "Question topic should be defined");
        }

        // Verify specific question details (Question 1: Raft partition quorum)
        QuestionReviewDto q1 = reviews.get(0);
        assertTrue(q1.isCorrect(), "Question 1 should be marked correct");
        assertEquals("B", q1.getSelectedOptionLetter());
        assertEquals("B", q1.getCorrectOptionLetter());
        assertEquals(new BigDecimal("4.00"), q1.getMarksAwarded());
    }

    @Test
    @Order(3)
    @DisplayName("Verify Topic Performance Breakdown DAO calculations")
    void testGetTopicPerformancesDao() {
        List<TopicPerformanceDto> topics = resultDao.getTopicPerformances(SEEDED_ATTEMPT_ID);
        assertNotNull(topics, "Topic performance list should not be null");
        assertFalse(topics.isEmpty(), "Should contain topic breakdown records");

        for (TopicPerformanceDto topic : topics) {
            assertNotNull(topic.getTopicName());
            assertTrue(topic.getTotalQuestions() > 0);
            assertTrue(topic.getMasteryPercentage() >= 0.0 && topic.getMasteryPercentage() <= 100.0);
        }
    }

    @Test
    @Order(4)
    @DisplayName("Verify Cohort Performance Metrics DAO (Average, Participants, Rank)")
    void testCohortMetricsDao() {
        double avgPct = resultDao.getCohortAveragePercentage(SEEDED_QUIZ_ID);
        assertTrue(avgPct >= 0.0 && avgPct <= 100.0, "Cohort average percentage must be valid percentage");

        int participants = resultDao.getCohortTotalParticipants(SEEDED_QUIZ_ID);
        assertTrue(participants >= 1, "There should be at least 1 participant in quiz 1");

        int rank = resultDao.calculateCohortRank(SEEDED_QUIZ_ID, new BigDecimal("118.00"));
        assertTrue(rank >= 1 && rank <= participants, "Rank must be between 1 and total participants");
    }

    @Test
    @Order(5)
    @DisplayName("Verify ResultService successfully enriches complete exam scorecard")
    void testGetExamResultServiceSuccess() {
        StudentResultDto result = resultService.getExamResult(SEEDED_ATTEMPT_ID, ALEX_MERCER_STUDENT_ID);
        assertNotNull(result, "Enriched result should not be null");

        // KPI and Scoring validations
        assertEquals(SEEDED_ATTEMPT_ID, result.getAttemptId());
        assertEquals("CS-2022-041", result.getStudentIdentifier());
        assertEquals(new BigDecimal("118.00"), result.getScore());
        assertEquals(new BigDecimal("140.00"), result.getMaxScore());
        assertTrue(result.getGrade().contains("A"), "Grade should be Grade A or A");
        assertTrue(result.isPassed());

        // Question Counts
        assertEquals(5, result.getTotalQuestions());
        assertEquals(4, result.getCorrectCount());
        assertEquals(1, result.getIncorrectCount());
        assertEquals(0, result.getUnansweredCount());
        assertEquals(80.0, result.getAccuracyPercentage(), 0.01);

        // Verification of Enriched Collections
        assertNotNull(result.getQuestionReviews());
        assertEquals(5, result.getQuestionReviews().size());
        assertNotNull(result.getTopicBreakdowns());
        assertFalse(result.getTopicBreakdowns().isEmpty());
        assertNotNull(result.getStrongTopics());
        assertNotNull(result.getWeakTopics());

        // Verification of Cohort Analytics
        assertTrue(result.getCohortAveragePercentage() > 0);
        assertTrue(result.getCohortTotalStudents() >= 1);
        assertTrue(result.getCohortRank() >= 1);
    }

    @Test
    @Order(6)
    @DisplayName("Verify Cross-Student Security: Student cannot view another student's exam result")
    void testCrossStudentResultAccessDenied() {
        // Marcus Vance (ID 5) attempts to access Alex Mercer's (ID 4) attempt 1
        SecurityException ex = assertThrows(SecurityException.class, () -> {
            resultService.getExamResult(SEEDED_ATTEMPT_ID, MARCUS_VANCE_STUDENT_ID);
        }, "Accessing another student's exam result must throw SecurityException");

        assertTrue(ex.getMessage().contains("Unauthorized access") || ex.getMessage().contains("not submitted"));
    }

    @Test
    @Order(7)
    @DisplayName("Verify Access to Non-Existent Attempt is Denied")
    void testNonExistentAttemptAccessDenied() {
        SecurityException ex = assertThrows(SecurityException.class, () -> {
            resultService.getExamResult(99999, ALEX_MERCER_STUDENT_ID);
        }, "Accessing non-existent attempt must throw SecurityException");

        assertNotNull(ex);
    }

    @Test
    @Order(8)
    @DisplayName("Verify ResultService getLatestResult for student with completed attempts")
    void testGetLatestResult() {
        StudentResultDto latest = resultService.getLatestResult(ALEX_MERCER_STUDENT_ID);
        assertNotNull(latest, "Alex Mercer should have a latest result record");
        assertTrue(latest.getAttemptId() > 0, "Latest attempt ID should be positive");
        assertNotNull(latest.getScore(), "Latest score should not be null");
        assertNotNull(latest.getQuizTitle(), "Latest quiz title should not be null");
    }

    @Test
    @Order(9)
    @DisplayName("Verify ResultService getLatestResult returns null for student with no attempts")
    void testGetLatestResultForStudentWithoutAttempts() {
        // ID 999 does not exist
        StudentResultDto latest = resultService.getLatestResult(99999);
        assertNull(latest, "Student without attempts should return null");
    }

    @Test
    @Order(10)
    @DisplayName("Verify Results History retrieval for student")
    void testGetResultsHistory() {
        List<StudentResultDto> history = resultService.getResultsHistory(ALEX_MERCER_STUDENT_ID);
        assertNotNull(history, "History list should not be null");
        assertFalse(history.isEmpty(), "Student 4 should have at least 1 historical result");

        boolean hasSeeded = history.stream().anyMatch(h -> h.getAttemptId() == SEEDED_ATTEMPT_ID);
        assertTrue(hasSeeded, "History should include seeded attempt 1");
    }
}
