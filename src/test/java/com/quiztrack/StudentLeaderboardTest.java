package com.quiztrack;

import com.quiztrack.dao.LeaderboardDao;
import com.quiztrack.dao.impl.LeaderboardDaoImpl;
import com.quiztrack.model.*;
import com.quiztrack.service.LeaderboardService;
import com.quiztrack.service.impl.LeaderboardServiceImpl;
import org.junit.jupiter.api.*;

import java.math.BigDecimal;
import java.util.List;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;

@TestMethodOrder(MethodOrderer.OrderAnnotation.class)
public class StudentLeaderboardTest {

    private static LeaderboardDao leaderboardDao;
    private static LeaderboardService leaderboardService;

    private static final int ACTIVE_QUIZ_ID = 1;
    private static final int ALEX_MERCER_STUDENT_ID = 4;
    private static final int JORDAN_LEE_STUDENT_ID = 5;
    private static final int MARCUS_CHEN_STUDENT_ID = 7;
    private static final int PRIYA_SHARMA_STUDENT_ID = 8;
    private static final int UNATTEMPTED_STUDENT_ID = 10;

    @BeforeAll
    static void setUp() {
        leaderboardDao = new LeaderboardDaoImpl();
        leaderboardService = new LeaderboardServiceImpl(leaderboardDao);
    }

    @Test
    @Order(1)
    @DisplayName("Verify Leaderboard Dao returns ranked entries in descending order")
    void testLeaderboardDaoRankingOrder() {
        List<LeaderboardEntryDto> entries = leaderboardDao.getLeaderboardEntries(ACTIVE_QUIZ_ID);
        assertNotNull(entries);
        assertFalse(entries.isEmpty(), "Leaderboard should contain examinee entries");
        assertTrue(entries.size() >= 5, "Leaderboard should have at least 5 seeded student entries");

        // Verify strictly decreasing or equal scores according to rank
        BigDecimal previousScore = new BigDecimal("999999");
        int previousRank = 0;
        for (LeaderboardEntryDto entry : entries) {
            assertTrue(entry.getScore().compareTo(previousScore) <= 0, "Scores must be in descending order");
            assertTrue(entry.getRank() >= previousRank, "Rank numbers must be ascending");
            previousScore = entry.getScore();
            previousRank = entry.getRank();
        }

        // Verify podium positions
        LeaderboardEntryDto first = entries.get(0);
        assertEquals(1, first.getRank());
        assertEquals(PRIYA_SHARMA_STUDENT_ID, first.getStudentId());
        assertEquals(new BigDecimal("136.00"), first.getScore());

        LeaderboardEntryDto third = entries.get(2);
        assertEquals(3, third.getRank());
        assertEquals(ALEX_MERCER_STUDENT_ID, third.getStudentId());
        assertEquals(new BigDecimal("118.00"), third.getScore());
    }

    @Test
    @Order(2)
    @DisplayName("Verify tie handling: examinees with tied scores are correctly ranked and flagged")
    void testTieHandlingMechanism() {
        List<LeaderboardEntryDto> entries = leaderboardDao.getLeaderboardEntries(ACTIVE_QUIZ_ID);
        assertNotNull(entries);

        // Verification of tie-breaker sorting:
        // Rank ordering uses RANK() OVER (ORDER BY score DESC, duration ASC, attempt_id ASC)
        for (int i = 0; i < entries.size() - 1; i++) {
            LeaderboardEntryDto current = entries.get(i);
            LeaderboardEntryDto next = entries.get(i + 1);
            if (current.getScore().compareTo(next.getScore()) == 0) {
                assertTrue(current.isTied(), "Current entry should be marked as tied");
                assertTrue(next.isTied(), "Next entry should be marked as tied");
                assertTrue(current.getDurationMinutes() <= next.getDurationMinutes(),
                        "Faster completion time takes precedence in tie-breaking");
            }
        }
    }

    @Test
    @Order(3)
    @DisplayName("Verify Student Service compiles Leaderboard View with correct Podium assignments")
    void testLeaderboardViewPodiumAssignments() {
        LeaderboardViewDto view = leaderboardService.getLeaderboardView(ACTIVE_QUIZ_ID, null, "ALL", ALEX_MERCER_STUDENT_ID);
        assertNotNull(view);
        assertEquals(ACTIVE_QUIZ_ID, view.getSelectedQuizId());

        // Gold Laureate (#1)
        assertNotNull(view.getPodiumGold(), "Gold podium must be assigned");
        assertEquals(1, view.getPodiumGold().getRank());
        assertEquals(PRIYA_SHARMA_STUDENT_ID, view.getPodiumGold().getStudentId());

        // Silver Laureate (#2)
        assertNotNull(view.getPodiumSilver(), "Silver podium must be assigned");
        assertEquals(2, view.getPodiumSilver().getRank());
        assertEquals(MARCUS_CHEN_STUDENT_ID, view.getPodiumSilver().getStudentId());

        // Bronze Laureate (#3)
        assertNotNull(view.getPodiumBronze(), "Bronze podium must be assigned");
        assertEquals(3, view.getPodiumBronze().getRank());
        assertEquals(ALEX_MERCER_STUDENT_ID, view.getPodiumBronze().getStudentId());

        // Alex Mercer is the current logged-in user
        assertNotNull(view.getCurrentUserEntry());
        assertEquals(ALEX_MERCER_STUDENT_ID, view.getCurrentUserEntry().getStudentId());
        assertTrue(view.getCurrentUserEntry().isCurrentUser());
        assertEquals(3, view.getCurrentUserEntry().getRank());
    }

    @Test
    @Order(4)
    @DisplayName("Verify Student outside top positions still sees their own standing card")
    void testStudentOutsideTopStanding() {
        // Jordan Lee (ID 5) is Rank 5 (outside top 3)
        LeaderboardViewDto view = leaderboardService.getLeaderboardView(ACTIVE_QUIZ_ID, null, "ALL", JORDAN_LEE_STUDENT_ID);
        assertNotNull(view);
        assertNotNull(view.getCurrentUserEntry(), "User standing must be present even when outside top positions");
        assertEquals(JORDAN_LEE_STUDENT_ID, view.getCurrentUserEntry().getStudentId());
        assertEquals(5, view.getCurrentUserEntry().getRank());
        assertFalse(view.getCurrentUserEntry().isCertificateEligible(), "Failing examinee is not certificate eligible");
    }

    @Test
    @Order(5)
    @DisplayName("Verify Student with no completed attempts has null user standing")
    void testStudentWithNoAttempts() {
        // User 10 has not completed quiz 1
        LeaderboardViewDto view = leaderboardService.getLeaderboardView(ACTIVE_QUIZ_ID, null, "ALL", UNATTEMPTED_STUDENT_ID);
        assertNotNull(view);
        assertNull(view.getCurrentUserEntry(), "Candidate without attempts must have null user standing");
    }

    @Test
    @Order(6)
    @DisplayName("Verify Certificate Eligibility: Eligible candidate has valid certificate")
    void testEligibleCandidateCertificate() {
        // Alex Mercer (ID 4) passed with Grade A
        CertificateDto cert = leaderboardService.getVerifiedCertificate(ACTIVE_QUIZ_ID, ALEX_MERCER_STUDENT_ID, ALEX_MERCER_STUDENT_ID, "STUDENT");
        assertNotNull(cert);
        assertEquals("VALID", cert.getStatus());
        assertEquals("QT-CERT-2025-CS402-0841X", cert.getCertificateId());
        assertEquals("e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855", cert.getCertificateHash());
        assertEquals("Alex Mercer", cert.getStudentName());
        assertTrue(cert.isPassed());
    }

    @Test
    @Order(7)
    @DisplayName("Verify Certificate Ineligibility: Failed student has REVOKED or absent certificate")
    void testIneligibleCandidateCertificate() {
        // Jordan Lee (ID 5) failed quiz 1
        CertificateDto cert = leaderboardService.getVerifiedCertificate(ACTIVE_QUIZ_ID, JORDAN_LEE_STUDENT_ID, JORDAN_LEE_STUDENT_ID, "STUDENT");
        assertNotNull(cert);
        assertEquals("REVOKED", cert.getStatus());
        assertFalse(cert.isPassed());
    }

    @Test
    @Order(8)
    @DisplayName("Verify Security: Student cannot access another student's certificate")
    void testCrossStudentCertificateAccessDenied() {
        // Jordan Lee (ID 5) attempts to access Alex Mercer's (ID 4) certificate
        assertThrows(SecurityException.class, () -> {
            leaderboardService.getVerifiedCertificate(ACTIVE_QUIZ_ID, ALEX_MERCER_STUDENT_ID, JORDAN_LEE_STUDENT_ID, "STUDENT");
        }, "Student must be forbidden from accessing another candidate's certificate");
    }

    @Test
    @Order(9)
    @DisplayName("Verify Public Certificate Verification for Valid, Invalid, and Revoked IDs")
    void testPublicCertificateVerification() {
        // 1. Valid certificate by formatted ID
        CertificateDto validCert = leaderboardService.verifyCertificatePublic("QT-CERT-2025-CS402-0841X");
        assertNotNull(validCert);
        assertEquals("VALID", validCert.getStatus());
        assertEquals("Alex Mercer", validCert.getStudentName());

        // 2. Valid certificate by SHA-256 hash
        CertificateDto validHash = leaderboardService.verifyCertificatePublic("e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855");
        assertNotNull(validHash);
        assertEquals("VALID", validHash.getStatus());
        assertEquals("Alex Mercer", validHash.getStudentName());

        // 3. Invalid non-existent token
        CertificateDto notFound = leaderboardService.verifyCertificatePublic("NON_EXISTENT_TOKEN_12345");
        assertNotNull(notFound);
        assertEquals("NOT_FOUND", notFound.getStatus());

        // 4. Blank token
        CertificateDto invalid = leaderboardService.verifyCertificatePublic("  ");
        assertNotNull(invalid);
        assertEquals("INVALID", invalid.getStatus());
    }

    @Test
    @Order(10)
    @DisplayName("Verify Cohort Statistical Distribution Calculations (Quartiles & Average)")
    void testCohortDistributionCalculations() {
        LeaderboardViewDto view = leaderboardService.getLeaderboardView(ACTIVE_QUIZ_ID, null, "ALL", ALEX_MERCER_STUDENT_ID);
        assertNotNull(view);
        assertTrue(view.getClassAveragePercentage() > 50.0 && view.getClassAveragePercentage() <= 100.0,
                "Class average percentage must fall within realistic boundary");
        assertTrue(view.getTopScore().compareTo(BigDecimal.ZERO) > 0);
        assertTrue(view.getLowerQuartileScore().compareTo(BigDecimal.ZERO) > 0);
        assertTrue(view.getMedianScore().compareTo(BigDecimal.ZERO) > 0);
        assertTrue(view.getUpperQuartileScore().compareTo(BigDecimal.ZERO) > 0);
        assertTrue(view.getLowerQuartileScore().compareTo(view.getMedianScore()) <= 0);
        assertTrue(view.getMedianScore().compareTo(view.getUpperQuartileScore()) <= 0);
    }
}
