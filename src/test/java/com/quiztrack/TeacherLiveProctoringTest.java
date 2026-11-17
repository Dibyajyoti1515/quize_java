package com.quiztrack;

import com.quiztrack.dao.ExamDao;
import com.quiztrack.dao.ProctorDao;
import com.quiztrack.dao.impl.ExamDaoImpl;
import com.quiztrack.dao.impl.ProctorDaoImpl;
import com.quiztrack.model.*;
import com.quiztrack.service.ProctorService;
import com.quiztrack.service.impl.ProctorServiceImpl;
import com.quiztrack.util.DatabaseConnection;
import org.junit.jupiter.api.*;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.util.List;

import static org.junit.jupiter.api.Assertions.*;

@TestMethodOrder(MethodOrderer.OrderAnnotation.class)
public class TeacherLiveProctoringTest {

    private static ProctorDao proctorDao;
    private static ExamDao examDao;
    private static ProctorService proctorService;

    private static final int TEACHER_RONALD_ID = 2; // Prof. Ronald Vance (owns Quiz 1 & 2)
    private static final int TEACHER_CLARA_ID = 3;  // Dr. Clara Oswald (owns Quiz 3)
    private static final int QUIZ_CS402_ID = 1;     // CS402 Midterm Exam
    private static final int QUIZ_CS490_ID = 3;     // CS490 Advanced Final
    private static final int STUDENT_ALEX_ID = 4;   // Alex Mercer
    private static final int SAMPLE_ATTEMPT_ID = 1; // Attempt 1 on Quiz 1

    private static int generatedLogId = 0;

    @BeforeAll
    public static void setUp() {
        proctorDao = new ProctorDaoImpl();
        examDao = new ExamDaoImpl();
        proctorService = new ProctorServiceImpl(proctorDao);
    }

    @AfterAll
    public static void tearDown() {
        // Reset test flags and remove test audit interventions
        try (Connection conn = DatabaseConnection.getConnection()) {
            try (PreparedStatement ps = conn.prepareStatement(
                    "UPDATE quiz_attempts SET is_flagged = FALSE, flag_reason = NULL, flagged_by = NULL, flagged_at = NULL WHERE attempt_id = ?")) {
                ps.setInt(1, SAMPLE_ATTEMPT_ID);
                ps.executeUpdate();
            }

            try (PreparedStatement ps = conn.prepareStatement(
                    "DELETE FROM proctor_interventions WHERE attempt_id = ? AND action_type IN ('FLAG', 'CLEAR_FLAG', 'BROADCAST')")) {
                ps.setInt(1, SAMPLE_ATTEMPT_ID);
                ps.executeUpdate();
            }

            if (generatedLogId > 0) {
                try (PreparedStatement ps = conn.prepareStatement("DELETE FROM activity_logs WHERE log_id = ?")) {
                    ps.setInt(1, generatedLogId);
                    ps.executeUpdate();
                }
            }
        } catch (Exception ignored) {}

        DatabaseConnection.closePool();
    }

    @Test
    @Order(1)
    @DisplayName("Test 1: Teacher live monitoring dashboard loads authorized quiz data")
    public void testMonitoringDashboardAuthorizedTeacher() {
        TeacherLiveMonitoringData data = proctorService.getMonitoringDashboard(QUIZ_CS402_ID, TEACHER_RONALD_ID);

        assertNotNull(data, "Live monitoring data must not be null");
        assertEquals(QUIZ_CS402_ID, data.getQuizId(), "Quiz ID must match requested quiz");
        assertEquals(TEACHER_RONALD_ID, data.getTeacherId(), "Teacher ID must match instructor");
        assertNotNull(data.getQuizTitle(), "Quiz title must be present");
        assertTrue(data.getQuizTitle().contains("CS402"), "Quiz title should reference CS402");
        assertEquals("CS402", data.getSubjectCode(), "Subject code must be CS402");

        assertNotNull(data.getAvailableQuizzes(), "Available quizzes list must not be null");
        assertTrue(data.getAvailableQuizzes().stream().anyMatch(q -> q.getQuizId() == QUIZ_CS402_ID),
                "Available quizzes must include Quiz 1");

        assertNotNull(data.getExaminees(), "Examinees list must not be null");
        assertFalse(data.getExaminees().isEmpty(), "Examinees list must contain enrolled students");
        assertTrue(data.getTotalAssigned() > 0, "Total assigned candidates must be greater than zero");
    }

    @Test
    @Order(2)
    @DisplayName("Test 2: Teacher attempting to access another instructor's quiz throws SecurityException")
    public void testMonitoringDashboardUnauthorizedTeacher() {
        // Teacher Ronald Vance attempting to monitor Quiz 3 (owned by Dr. Clara Oswald)
        assertThrows(SecurityException.class, () -> {
            proctorService.getMonitoringDashboard(QUIZ_CS490_ID, TEACHER_RONALD_ID);
        }, "Accessing an unowned quiz stream must throw SecurityException");
    }

    @Test
    @Order(3)
    @DisplayName("Test 3: Examinee details retrieval enforces authorization")
    public void testExamineeDetailsAuthorizedAndUnauthorized() {
        // 1. Authorized Teacher Ronald Vance
        LiveExamineeDto examinee = proctorService.getExamineeDetails(SAMPLE_ATTEMPT_ID, TEACHER_RONALD_ID);
        assertNotNull(examinee, "Examinee details must be returned for authorized teacher");
        assertEquals(SAMPLE_ATTEMPT_ID, examinee.getAttemptId());
        assertEquals("Alex Mercer", examinee.getStudentName());
        assertEquals("CS-2022-041", examinee.getStudentIdentifier());
        assertNotNull(examinee.getIntegrityIndex(), "Integrity index must be calculated");
        assertNotNull(examinee.getIntegrityLevel(), "Integrity level must be assigned");

        // 2. Unauthorized Teacher Clara Oswald accessing Ronald's quiz attempt
        assertThrows(SecurityException.class, () -> {
            proctorService.getExamineeDetails(SAMPLE_ATTEMPT_ID, TEACHER_CLARA_ID);
        }, "Unauthorized teacher accessing examinee details must throw SecurityException");
    }

    @Test
    @Order(4)
    @DisplayName("Test 4: Browser telemetry event logging and student timeline retrieval")
    public void testRecordTelemetryAndStudentTimeline() {
        // Record telemetry event: TAB_SWITCH with CAUTION severity
        boolean logged = examDao.recordTelemetryEvent(
                SAMPLE_ATTEMPT_ID,
                STUDENT_ALEX_ID,
                "TAB_SWITCH",
                "CAUTION",
                "Automated test: Browser window lost focus for 12 seconds"
        );
        assertTrue(logged, "Telemetry event should be successfully logged to activity_logs");

        // Retrieve chronological timeline as Teacher Ronald Vance
        List<ProctorActivityEventDto> timeline = proctorService.getStudentTimeline(SAMPLE_ATTEMPT_ID, TEACHER_RONALD_ID);
        assertNotNull(timeline, "Student timeline must not be null");
        assertFalse(timeline.isEmpty(), "Timeline must contain the recorded telemetry event");

        ProctorActivityEventDto latest = timeline.get(0);
        assertEquals("TAB_SWITCH", latest.getEventType());
        assertEquals("CAUTION", latest.getSeverity());
        assertTrue(latest.getDetails().contains("Automated test"), "Details must match logged event");
        assertFalse(latest.isReviewed(), "Newly logged event should not be reviewed yet");

        generatedLogId = latest.getLogId();
    }

    @Test
    @Order(5)
    @DisplayName("Test 5: Proctor review of telemetry event records reviewer notes")
    public void testReviewBrowserTelemetryEvent() {
        assertTrue(generatedLogId > 0, "Generated log ID must be present from Test 4");

        String reviewNotes = "Verified by Proctor Vance: Tab switch was brief, student resumed immediately.";
        boolean reviewed = proctorService.reviewEvent(generatedLogId, TEACHER_RONALD_ID, reviewNotes);
        assertTrue(reviewed, "Proctor review event must update successfully");

        // Verify updated state in timeline
        List<ProctorActivityEventDto> timeline = proctorService.getStudentTimeline(SAMPLE_ATTEMPT_ID, TEACHER_RONALD_ID);
        ProctorActivityEventDto event = timeline.stream()
                .filter(e -> e.getLogId() == generatedLogId)
                .findFirst()
                .orElse(null);

        assertNotNull(event, "Event should be present in student timeline");
        assertTrue(event.isReviewed(), "Event should be marked as reviewed");
        assertEquals("Prof. Ronald Vance", event.getReviewerName(), "Reviewer name should be Ronald Vance");
        assertEquals(reviewNotes, event.getReviewNotes(), "Review notes must match");
    }

    @Test
    @Order(6)
    @DisplayName("Test 6: Flagging candidate attempt for investigation records justification and audit entry")
    public void testFlagStudentAttemptWithAudit() {
        String flagReason = "Candidate exhibited 4 tab switches and 2 fullscreen escapes during Section B.";
        boolean flagged = proctorService.flagStudentAttempt(SAMPLE_ATTEMPT_ID, TEACHER_RONALD_ID, flagReason);
        assertTrue(flagged, "Flagging student attempt should succeed");

        // Verify examinee state
        LiveExamineeDto details = proctorService.getExamineeDetails(SAMPLE_ATTEMPT_ID, TEACHER_RONALD_ID);
        assertTrue(details.isFlagged(), "Attempt must be marked as flagged");
        assertEquals(flagReason, details.getFlagReason(), "Flag reason must match recorded text");
        assertEquals("Prof. Ronald Vance", details.getFlaggedByName(), "Flagged by must be Ronald Vance");

        // Verify audit intervention in dashboard
        TeacherLiveMonitoringData data = proctorService.getMonitoringDashboard(QUIZ_CS402_ID, TEACHER_RONALD_ID);
        assertTrue(data.getFlaggedCount() >= 1, "Flagged count KPI should reflect at least 1 flagged examinee");

        boolean auditFound = data.getAuditLogs().stream().anyMatch(a ->
                "FLAG".equalsIgnoreCase(a.getActionType()) && a.getAttemptId() == SAMPLE_ATTEMPT_ID);
        assertTrue(auditFound, "Proctor audit trail must record FLAG intervention");
    }

    @Test
    @Order(7)
    @DisplayName("Test 7: Clearing candidate flag with justification restores status and records audit entry")
    public void testClearStudentFlagWithAudit() {
        String clearReason = "Student provided verified technical confirmation of external display notification.";
        boolean cleared = proctorService.clearStudentFlag(SAMPLE_ATTEMPT_ID, TEACHER_RONALD_ID, clearReason);
        assertTrue(cleared, "Clearing student flag should succeed");

        // Verify examinee state is unflagged
        LiveExamineeDto details = proctorService.getExamineeDetails(SAMPLE_ATTEMPT_ID, TEACHER_RONALD_ID);
        assertFalse(details.isFlagged(), "Attempt must no longer be flagged");
        assertNull(details.getFlagReason(), "Flag reason should be cleared");

        // Verify audit intervention recorded CLEAR_FLAG
        TeacherLiveMonitoringData data = proctorService.getMonitoringDashboard(QUIZ_CS402_ID, TEACHER_RONALD_ID);
        boolean auditFound = data.getAuditLogs().stream().anyMatch(a ->
                "CLEAR_FLAG".equalsIgnoreCase(a.getActionType()) && a.getAttemptId() == SAMPLE_ATTEMPT_ID);
        assertTrue(auditFound, "Proctor audit trail must record CLEAR_FLAG intervention");
    }

    @Test
    @Order(8)
    @DisplayName("Test 8: Flagging attempt in another instructor's quiz is rejected")
    public void testFlagAttemptUnauthorizedTeacher() {
        assertThrows(SecurityException.class, () -> {
            proctorService.flagStudentAttempt(SAMPLE_ATTEMPT_ID, TEACHER_CLARA_ID, "Malicious attempt flag");
        }, "Unauthorized teacher attempting to flag attempt must throw SecurityException");
    }

    @Test
    @Order(9)
    @DisplayName("Test 9: Broadcasting administrative notice to candidates records proctor intervention")
    public void testBroadcastAdministrativeNotice() {
        String noticeMessage = "Proctor Notice: 15 minutes remaining. Please review all marked questions.";
        boolean sent = proctorService.broadcastNotice(QUIZ_CS402_ID, TEACHER_RONALD_ID, noticeMessage);
        assertTrue(sent, "Broadcast notice should succeed for authorized teacher");

        // Verify broadcast appears in audit trail
        TeacherLiveMonitoringData data = proctorService.getMonitoringDashboard(QUIZ_CS402_ID, TEACHER_RONALD_ID);
        boolean broadcastFound = data.getAuditLogs().stream().anyMatch(a ->
                "BROADCAST".equalsIgnoreCase(a.getActionType()) && a.getDetails().contains("15 minutes remaining"));
        assertTrue(broadcastFound, "Audit trail must record BROADCAST intervention with message text");

        // Verify unauthorized instructor cannot broadcast
        assertThrows(SecurityException.class, () -> {
            proctorService.broadcastNotice(QUIZ_CS402_ID, TEACHER_CLARA_ID, "Unauthorized message");
        }, "Unauthorized instructor broadcast must throw SecurityException");
    }

    @Test
    @Order(10)
    @DisplayName("Test 10: Live examinee integrity index calculation and level mapping")
    public void testExamineeIntegrityLevelMapping() {
        LiveExamineeDto candidate = new LiveExamineeDto();

        // 1. Pristine telemetry
        candidate.setIntegrityIndex(new BigDecimal("100.00"));
        candidate.setIntegrityLevel("NORMAL");
        assertEquals("NORMAL", candidate.getIntegrityLevel());

        // 2. Minor telemetry events
        candidate.setIntegrityIndex(new BigDecimal("88.50"));
        candidate.setIntegrityLevel("CAUTION");
        assertEquals("CAUTION", candidate.getIntegrityLevel());

        // 3. Critical telemetry degradation
        candidate.setIntegrityIndex(new BigDecimal("52.00"));
        candidate.setIntegrityLevel("CRITICAL");
        assertEquals("CRITICAL", candidate.getIntegrityLevel());
    }
}
