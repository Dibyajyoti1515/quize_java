package com.quiztrack;

import com.quiztrack.dao.StudentDao;
import com.quiztrack.dao.UserDao;
import com.quiztrack.dao.impl.StudentDaoImpl;
import com.quiztrack.dao.impl.UserDaoImpl;
import com.quiztrack.model.StudentDashboardData;
import com.quiztrack.model.StudentDashboardData.LatestResult;
import com.quiztrack.model.StudentDashboardData.StudentQuizCard;
import com.quiztrack.model.StudentDashboardData.SubjectMastery;
import com.quiztrack.model.User;
import com.quiztrack.service.StudentService;
import com.quiztrack.service.impl.StudentServiceImpl;
import org.junit.jupiter.api.*;

import java.util.List;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;

@TestMethodOrder(MethodOrderer.OrderAnnotation.class)
public class StudentDashboardTest {

    private static StudentService studentService;
    private static StudentDao studentDao;
    private static UserDao userDao;
    private static final int ALEX_MERCER_STUDENT_ID = 4;

    @BeforeAll
    static void setUp() {
        studentService = new StudentServiceImpl();
        studentDao = new StudentDaoImpl();
        userDao = new UserDaoImpl();
    }

    @Test
    @Order(1)
    @DisplayName("Verify Alex Mercer Student Profile Exists in Database")
    void testStudentProfileExists() {
        Optional<User> userOpt = userDao.findById(ALEX_MERCER_STUDENT_ID);
        assertTrue(userOpt.isPresent(), "Student with ID 4 (Alex Mercer) should exist");
        User user = userOpt.get();
        assertEquals("CS-2022-041", user.getIdentifier());
        assertEquals("Alex Mercer", user.getFullName());
        assertEquals("STUDENT", user.getRoleName());
    }

    @Test
    @Order(2)
    @DisplayName("Verify Student Assigned Quizzes Retrieval (CS402 Active, CS505 & CS490 Scheduled)")
    void testAssignedQuizzesRetrieval() {
        List<StudentQuizCard> cards = studentDao.getAssignedQuizzes(ALEX_MERCER_STUDENT_ID);
        assertNotNull(cards, "Assigned quizzes should not be null");
        assertTrue(cards.size() >= 3, "Alex Mercer should have at least 3 assigned quizzes");

        boolean hasActive = false;
        boolean hasScheduled = false;
        for (StudentQuizCard card : cards) {
            if ("ACTIVE".equalsIgnoreCase(card.getStatus())) {
                hasActive = true;
                assertEquals("CS402", card.getQuizCode());
                assertTrue(card.isCanStart() || "SUBMITTED".equals(card.getAttemptStatus()));
                assertEquals(90, card.getDurationMinutes());
                assertEquals(140.00, card.getTotalMarks(), 0.01);
            }
            if ("SCHEDULED".equalsIgnoreCase(card.getStatus())) {
                hasScheduled = true;
                assertFalse(card.isCanStart());
            }
        }
        assertTrue(hasActive, "Student should have an ACTIVE quiz assigned (CS402)");
        assertTrue(hasScheduled, "Student should have SCHEDULED quizzes assigned");
    }

    @Test
    @Order(3)
    @DisplayName("Verify Student Latest Verified Result and Cryptographic Certificate Hash")
    void testLatestVerifiedResult() {
        Optional<LatestResult> resultOpt = studentDao.getLatestResult(ALEX_MERCER_STUDENT_ID);
        assertTrue(resultOpt.isPresent(), "Student should have a verified result record");
        LatestResult res = resultOpt.get();
        assertEquals(118.00, res.getScore(), 0.01, "Score should match Stitch seed 118 pts");
        assertEquals(140.00, res.getMaxScore(), 0.01, "Max score should match Stitch seed 140 pts");
        assertEquals(3, res.getCohortRank(), "Cohort rank should match Stitch seed #3");
        assertEquals(94.20, res.getCohortPercentile(), 0.1, "Cohort percentile should match Stitch seed 94.2%");
        assertNotNull(res.getCertificateHash(), "Certificate hash must exist");
        assertEquals(64, res.getCertificateHash().length(), "SHA-256 hash must be 64 characters");
    }

    @Test
    @Order(4)
    @DisplayName("Verify Student Curricular Subject Mastery Progress")
    void testSubjectMasteryRetrieval() {
        List<SubjectMastery> masteryList = studentDao.getSubjectMastery(ALEX_MERCER_STUDENT_ID);
        assertNotNull(masteryList, "Subject mastery list should not be null");
        assertFalse(masteryList.isEmpty(), "Subject mastery list should not be empty");

        for (SubjectMastery sm : masteryList) {
            assertTrue(sm.getMasteryPercentage() >= 0 && sm.getMasteryPercentage() <= 100,
                    "Mastery percentage should be within 0-100 range");
            assertNotNull(sm.getMasteryLevel());
            assertNotNull(sm.getProgressColor());
        }
    }

    @Test
    @Order(5)
    @DisplayName("Verify Full StudentDashboardData Aggregation via StudentService")
    void testStudentDashboardDataAggregation() {
        StudentDashboardData data = studentService.getStudentDashboardData(ALEX_MERCER_STUDENT_ID);
        assertNotNull(data, "Dashboard data DTO should not be null");
        assertNotNull(data.getStudent(), "Student user should be populated");
        assertEquals("Alex Mercer", data.getStudent().getFullName());

        // KPIs
        assertTrue(data.getQuizzesAttemptedCount() >= 1, "Attempted quizzes should be at least 1");
        assertTrue(data.getCumulativeScore() >= 80.0, "Cumulative score should be >= 80%");
        assertEquals(3, data.getCohortRank());
        assertTrue(data.getIntegrityIndex() >= 95.0, "Integrity index should be >= 95%");

        // Active Banner Quiz
        assertNotNull(data.getActiveQuiz(), "Active banner quiz should be identified");
        assertEquals(1, data.getActiveQuiz().getQuizId());

        // Assigned quizzes deck
        assertTrue(data.getAssignedQuizzes().size() >= 3);
        assertTrue(data.getReadyToLaunchCount() >= 1);
        assertTrue(data.getScheduledAheadCount() >= 2);
    }

    @Test
    @Order(6)
    @DisplayName("Verify Individual Quiz Details for Pre-Flight Modal")
    void testQuizDetailsForPreflight() {
        Optional<StudentQuizCard> cardOpt = studentService.getQuizDetails(1, ALEX_MERCER_STUDENT_ID);
        assertTrue(cardOpt.isPresent(), "Quiz 1 should be found for student 4");
        StudentQuizCard card = cardOpt.get();
        assertEquals("CS402", card.getQuizCode());
        assertEquals("Strict Level-3 HUD Proctoring (Webcam + Audio + Tab-lock)", card.getProctorLevel());
    }

    @Test
    @Order(7)
    @DisplayName("Verify Student Unread Notifications Retrieval")
    void testUnreadNotificationsCount() {
        int count = studentDao.countUnreadNotifications(ALEX_MERCER_STUDENT_ID);
        assertTrue(count >= 1, "Student should have unread notifications in seed data");
    }
}
