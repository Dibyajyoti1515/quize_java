package com.quiztrack.dao.impl;

import com.quiztrack.dao.ProctorDao;
import com.quiztrack.model.*;
import com.quiztrack.util.DatabaseConnection;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.math.BigDecimal;
import java.sql.*;
import java.time.Duration;
import java.time.Instant;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

/**
 * JDBC implementation of ProctorDao for teacher monitoring, telemetry logs, and audit actions.
 */
public class ProctorDaoImpl implements ProctorDao {

    private static final Logger logger = LoggerFactory.getLogger(ProctorDaoImpl.class);
    private static final DateTimeFormatter TIME_FORMAT = DateTimeFormatter.ofPattern("HH:mm:ss");

    @Override
    public boolean isTeacherAuthorizedForQuiz(int quizId, int teacherId) {
        String sql = "SELECT 1 FROM quizzes q " +
                     "WHERE q.quiz_id = ? AND (q.teacher_id = ? OR EXISTS (SELECT 1 FROM users u WHERE u.user_id = ? AND u.role_id = 1))";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, quizId);
            ps.setInt(2, teacherId);
            ps.setInt(3, teacherId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (SQLException e) {
            logger.error("Error checking authorization for quiz {} and teacher {}", quizId, teacherId, e);
        }
        return false;
    }

    @Override
    public List<Quiz> getMonitorableQuizzesForTeacher(int teacherId) {
        String sql = "SELECT q.quiz_id, q.title, q.description, q.subject_id, q.teacher_id, q.duration_minutes, " +
                     "       q.total_marks, q.status, q.start_time, q.end_time, s.subject_code, s.subject_name " +
                     "FROM quizzes q " +
                     "JOIN subjects s ON q.subject_id = s.subject_id " +
                     "WHERE (q.teacher_id = ? OR EXISTS (SELECT 1 FROM users u WHERE u.user_id = ? AND u.role_id = 1)) " +
                     "ORDER BY (CASE WHEN q.status = 'ACTIVE' THEN 1 WHEN q.status = 'SCHEDULED' THEN 2 ELSE 3 END), q.quiz_id ASC";

        List<Quiz> quizzes = new ArrayList<>();
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, teacherId);
            ps.setInt(2, teacherId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Quiz q = new Quiz();
                    q.setQuizId(rs.getInt("quiz_id"));
                    q.setTitle(rs.getString("title"));
                    q.setDescription(rs.getString("description"));
                    q.setSubjectId(rs.getInt("subject_id"));
                    q.setSubjectCode(rs.getString("subject_code"));
                    q.setSubjectName(rs.getString("subject_name"));
                    q.setTeacherId(rs.getInt("teacher_id"));
                    q.setDurationMinutes(rs.getInt("duration_minutes"));
                    q.setTotalMarks(rs.getBigDecimal("total_marks"));
                    q.setStatus(rs.getString("status"));
                    quizzes.add(q);
                }
            }
        } catch (SQLException e) {
            logger.error("Error retrieving monitorable quizzes for teacher {}", teacherId, e);
        }
        return quizzes;
    }

    @Override
    public List<LiveExamineeDto> getExamineesForQuiz(int quizId) {
        String sql = "SELECT qa.attempt_id, qa.quiz_id, qa.student_id, qa.start_time, qa.end_time, qa.status, " +
                     "       qa.total_score, qa.percentage, qa.grade, qa.passed, " +
                     "       qa.tab_switch_count, qa.blur_count, qa.fullscreen_exit_count, qa.integrity_index, " +
                     "       qa.ip_address, qa.user_agent, qa.is_flagged, qa.flag_reason, qa.flagged_at, " +
                     "       u.full_name, u.identifier, q.duration_minutes, " +
                     "       COALESCE((SELECT COUNT(*) FROM student_answers sa WHERE sa.attempt_id = qa.attempt_id AND sa.selected_option_id IS NOT NULL), 0) AS answered_count, " +
                     "       COALESCE((SELECT COUNT(*) FROM quiz_questions qu WHERE qu.quiz_id = qa.quiz_id), 0) AS total_questions, " +
                     "       (SELECT MAX(al.event_timestamp) FROM activity_logs al WHERE al.attempt_id = qa.attempt_id) AS last_activity, " +
                     "       u_flag.full_name AS flagged_by_name " +
                     "FROM quiz_attempts qa " +
                     "JOIN users u ON qa.student_id = u.user_id " +
                     "JOIN quizzes q ON qa.quiz_id = q.quiz_id " +
                     "LEFT JOIN users u_flag ON qa.flagged_by = u_flag.user_id " +
                     "WHERE qa.quiz_id = ? " +
                     "ORDER BY (CASE WHEN qa.is_flagged = TRUE THEN 1 WHEN qa.status = 'IN_PROGRESS' THEN 2 ELSE 3 END), qa.attempt_id ASC";

        List<LiveExamineeDto> list = new ArrayList<>();
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, quizId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapLiveExaminee(rs));
                }
            }
        } catch (SQLException e) {
            logger.error("Error retrieving examinees for quiz {}", quizId, e);
        }
        return list;
    }

    @Override
    public Optional<LiveExamineeDto> getExamineeDetails(int attemptId) {
        String sql = "SELECT qa.attempt_id, qa.quiz_id, qa.student_id, qa.start_time, qa.end_time, qa.status, " +
                     "       qa.total_score, qa.percentage, qa.grade, qa.passed, " +
                     "       qa.tab_switch_count, qa.blur_count, qa.fullscreen_exit_count, qa.integrity_index, " +
                     "       qa.ip_address, qa.user_agent, qa.is_flagged, qa.flag_reason, qa.flagged_at, " +
                     "       u.full_name, u.identifier, q.duration_minutes, " +
                     "       COALESCE((SELECT COUNT(*) FROM student_answers sa WHERE sa.attempt_id = qa.attempt_id AND sa.selected_option_id IS NOT NULL), 0) AS answered_count, " +
                     "       COALESCE((SELECT COUNT(*) FROM quiz_questions qu WHERE qu.quiz_id = qa.quiz_id), 0) AS total_questions, " +
                     "       (SELECT MAX(al.event_timestamp) FROM activity_logs al WHERE al.attempt_id = qa.attempt_id) AS last_activity, " +
                     "       u_flag.full_name AS flagged_by_name " +
                     "FROM quiz_attempts qa " +
                     "JOIN users u ON qa.student_id = u.user_id " +
                     "JOIN quizzes q ON qa.quiz_id = q.quiz_id " +
                     "LEFT JOIN users u_flag ON qa.flagged_by = u_flag.user_id " +
                     "WHERE qa.attempt_id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, attemptId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return Optional.of(mapLiveExaminee(rs));
                }
            }
        } catch (SQLException e) {
            logger.error("Error retrieving examinee details for attempt {}", attemptId, e);
        }
        return Optional.empty();
    }

    @Override
    public List<ProctorActivityEventDto> getRecentEventsForQuiz(int quizId, int limit) {
        String sql = "SELECT al.log_id, al.attempt_id, al.user_id, al.event_type, al.severity, al.details, al.event_timestamp, " +
                     "       al.is_reviewed, al.reviewed_by, al.reviewed_at, al.review_notes, " +
                     "       u.full_name, u.identifier, u_rev.full_name AS reviewer_name " +
                     "FROM activity_logs al " +
                     "JOIN quiz_attempts qa ON al.attempt_id = qa.attempt_id " +
                     "JOIN users u ON al.user_id = u.user_id " +
                     "LEFT JOIN users u_rev ON al.reviewed_by = u_rev.user_id " +
                     "WHERE qa.quiz_id = ? " +
                     "ORDER BY al.event_timestamp DESC " +
                     "LIMIT ?";

        List<ProctorActivityEventDto> events = new ArrayList<>();
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, quizId);
            ps.setInt(2, limit > 0 ? limit : 50);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    events.add(mapActivityEvent(rs));
                }
            }
        } catch (SQLException e) {
            logger.error("Error retrieving recent events for quiz {}", quizId, e);
        }
        return events;
    }

    @Override
    public List<ProctorActivityEventDto> getStudentEventsTimeline(int attemptId) {
        String sql = "SELECT al.log_id, al.attempt_id, al.user_id, al.event_type, al.severity, al.details, al.event_timestamp, " +
                     "       al.is_reviewed, al.reviewed_by, al.reviewed_at, al.review_notes, " +
                     "       u.full_name, u.identifier, u_rev.full_name AS reviewer_name " +
                     "FROM activity_logs al " +
                     "JOIN users u ON al.user_id = u.user_id " +
                     "LEFT JOIN users u_rev ON al.reviewed_by = u_rev.user_id " +
                     "WHERE al.attempt_id = ? " +
                     "ORDER BY al.event_timestamp DESC";

        List<ProctorActivityEventDto> timeline = new ArrayList<>();
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, attemptId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    timeline.add(mapActivityEvent(rs));
                }
            }
        } catch (SQLException e) {
            logger.error("Error retrieving student events timeline for attempt {}", attemptId, e);
        }
        return timeline;
    }

    @Override
    public boolean markEventReviewed(int logId, int teacherId, String reviewNotes) {
        String sql = "UPDATE activity_logs SET is_reviewed = TRUE, reviewed_by = ?, reviewed_at = CURRENT_TIMESTAMP, review_notes = ? " +
                     "WHERE log_id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, teacherId);
            ps.setString(2, reviewNotes != null ? reviewNotes : "Reviewed by proctor.");
            ps.setInt(3, logId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            logger.error("Error marking event {} as reviewed by teacher {}", logId, teacherId, e);
        }
        return false;
    }

    @Override
    public boolean flagAttempt(int attemptId, int teacherId, String reason) {
        String sql = "UPDATE quiz_attempts SET is_flagged = TRUE, flag_reason = ?, flagged_by = ?, flagged_at = CURRENT_TIMESTAMP " +
                     "WHERE attempt_id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, reason != null ? reason : "Flagged for teacher review");
            ps.setInt(2, teacherId);
            ps.setInt(3, attemptId);
            boolean updated = ps.executeUpdate() > 0;
            if (updated) {
                recordTeacherIntervention(attemptId, teacherId, "FLAG", "Attempt flagged: " + reason);
            }
            return updated;
        } catch (SQLException e) {
            logger.error("Error flagging attempt {} by teacher {}", attemptId, teacherId, e);
        }
        return false;
    }

    @Override
    public boolean clearAttemptFlag(int attemptId, int teacherId, String clearReason) {
        String sql = "UPDATE quiz_attempts SET is_flagged = FALSE, flag_reason = NULL, flagged_by = ?, flagged_at = CURRENT_TIMESTAMP " +
                     "WHERE attempt_id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, teacherId);
            ps.setInt(2, attemptId);
            boolean updated = ps.executeUpdate() > 0;
            if (updated) {
                recordTeacherIntervention(attemptId, teacherId, "CLEAR_FLAG", "Flag cleared: " + (clearReason != null ? clearReason : "Cleared after proctor review"));
            }
            return updated;
        } catch (SQLException e) {
            logger.error("Error clearing flag for attempt {} by teacher {}", attemptId, teacherId, e);
        }
        return false;
    }

    @Override
    public boolean recordTeacherIntervention(int attemptId, int teacherId, String actionType, String message) {
        String sql = "INSERT INTO proctor_interventions (attempt_id, teacher_id, action_type, message, created_at) " +
                     "VALUES (?, ?, ?, ?, CURRENT_TIMESTAMP)";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, attemptId);
            ps.setInt(2, teacherId);
            ps.setString(3, actionType);
            ps.setString(4, message != null ? message : "");
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            logger.error("Error recording proctor intervention for attempt {}", attemptId, e);
        }
        return false;
    }

    @Override
    public List<ProctorInterventionDto> getInterventionAuditLogs(int quizId, int limit) {
        String sql = "SELECT pi.intervention_id, pi.attempt_id, pi.teacher_id, pi.action_type, pi.message, pi.created_at, " +
                     "       u.full_name AS teacher_name " +
                     "FROM proctor_interventions pi " +
                     "JOIN quiz_attempts qa ON pi.attempt_id = qa.attempt_id " +
                     "JOIN users u ON pi.teacher_id = u.user_id " +
                     "WHERE qa.quiz_id = ? " +
                     "ORDER BY pi.created_at DESC " +
                     "LIMIT ?";

        List<ProctorInterventionDto> list = new ArrayList<>();
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, quizId);
            ps.setInt(2, limit > 0 ? limit : 50);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    ProctorInterventionDto dto = new ProctorInterventionDto();
                    dto.setInterventionId(rs.getInt("intervention_id"));
                    dto.setAttemptId(rs.getInt("attempt_id"));
                    dto.setTeacherId(rs.getInt("teacher_id"));
                    dto.setTeacherName(rs.getString("teacher_name"));
                    dto.setActionType(rs.getString("action_type"));
                    dto.setMessage(rs.getString("message"));
                    dto.setCreatedAt(rs.getTimestamp("created_at"));
                    if (dto.getCreatedAt() != null) {
                        dto.setCreatedAtFormatted(dto.getCreatedAt().toLocalDateTime().format(TIME_FORMAT));
                    }
                    list.add(dto);
                }
            }
        } catch (SQLException e) {
            logger.error("Error retrieving intervention audit logs for quiz {}", quizId, e);
        }
        return list;
    }

    private LiveExamineeDto mapLiveExaminee(ResultSet rs) throws SQLException {
        LiveExamineeDto dto = new LiveExamineeDto();
        dto.setAttemptId(rs.getInt("attempt_id"));
        dto.setQuizId(rs.getInt("quiz_id"));
        dto.setStudentId(rs.getInt("student_id"));
        dto.setStudentName(rs.getString("full_name"));
        dto.setStudentIdentifier(rs.getString("identifier"));
        dto.setStatus(rs.getString("status"));
        dto.setStartTime(rs.getTimestamp("start_time"));
        dto.setEndTime(rs.getTimestamp("end_time"));
        dto.setDurationMinutes(rs.getInt("duration_minutes"));
        dto.setCurrentScore(rs.getBigDecimal("total_score"));

        dto.setTabSwitchCount(rs.getInt("tab_switch_count"));
        dto.setBlurCount(rs.getInt("blur_count"));
        dto.setFullscreenExitCount(rs.getInt("fullscreen_exit_count"));
        dto.setTotalViolations(dto.getTabSwitchCount() + dto.getBlurCount() + dto.getFullscreenExitCount());

        BigDecimal integrity = rs.getBigDecimal("integrity_index");
        dto.setIntegrityIndex(integrity != null ? integrity : new BigDecimal("100.00"));

        dto.setIpAddress(rs.getString("ip_address"));
        dto.setUserAgent(rs.getString("user_agent"));

        dto.setFlagged(rs.getBoolean("is_flagged"));
        dto.setFlagReason(rs.getString("flag_reason"));
        dto.setFlaggedAt(rs.getTimestamp("flagged_at"));
        dto.setFlaggedByName(rs.getString("flagged_by_name"));

        dto.setAnsweredCount(rs.getInt("answered_count"));
        dto.setTotalQuestions(rs.getInt("total_questions"));
        if (dto.getTotalQuestions() > 0) {
            double prog = ((double) dto.getAnsweredCount() / (double) dto.getTotalQuestions()) * 100.0;
            dto.setProgressPercentage(Math.round(prog * 10.0) / 10.0);
        }

        // Remaining time calculation
        if ("SUBMITTED".equalsIgnoreCase(dto.getStatus())) {
            dto.setRemainingSeconds(0);
            dto.setRemainingFormatted("Submitted");
        } else if (dto.getStartTime() != null && dto.getDurationMinutes() > 0) {
            Instant examEnd = dto.getStartTime().toInstant().plusSeconds((long) dto.getDurationMinutes() * 60);
            long rem = Duration.between(Instant.now(), examEnd).getSeconds();
            if (rem <= 0) {
                dto.setRemainingSeconds(0);
                dto.setRemainingFormatted("00:00 (Time Expired)");
            } else {
                dto.setRemainingSeconds(rem);
                long mins = rem / 60;
                long secs = rem % 60;
                dto.setRemainingFormatted(String.format("%02d:%02d", mins, secs));
            }
        } else {
            dto.setRemainingFormatted("--:--");
        }

        // Last activity formatted
        Timestamp lastAct = rs.getTimestamp("last_activity");
        dto.setLastActivityTime(lastAct);
        if (lastAct != null) {
            long secAgo = Duration.between(lastAct.toInstant(), Instant.now()).getSeconds();
            if (secAgo < 5) {
                dto.setLastActivityFormatted("Active now");
            } else if (secAgo < 60) {
                dto.setLastActivityFormatted(secAgo + "s ago");
            } else {
                dto.setLastActivityFormatted((secAgo / 60) + "m ago");
            }
        } else {
            dto.setLastActivityFormatted("Session started");
        }

        // Severity level
        if (dto.isFlagged() || dto.getFullscreenExitCount() >= 2 || dto.getTabSwitchCount() >= 3 || dto.getIntegrityIndex().compareTo(new BigDecimal("75.00")) < 0) {
            dto.setIntegrityLevel("CRITICAL");
        } else if (dto.getTotalViolations() > 0 || dto.getIntegrityIndex().compareTo(new BigDecimal("90.00")) < 0) {
            dto.setIntegrityLevel("CAUTION");
        } else {
            dto.setIntegrityLevel("NORMAL");
        }

        return dto;
    }

    private ProctorActivityEventDto mapActivityEvent(ResultSet rs) throws SQLException {
        ProctorActivityEventDto dto = new ProctorActivityEventDto();
        dto.setLogId(rs.getInt("log_id"));
        dto.setAttemptId(rs.getInt("attempt_id"));
        dto.setStudentId(rs.getInt("user_id"));
        dto.setStudentName(rs.getString("full_name"));
        dto.setStudentIdentifier(rs.getString("identifier"));
        dto.setEventType(rs.getString("event_type"));
        dto.setSeverity(rs.getString("severity"));
        dto.setDetails(rs.getString("details"));
        dto.setEventTimestamp(rs.getTimestamp("event_timestamp"));
        if (dto.getEventTimestamp() != null) {
            dto.setTimestampFormatted(dto.getEventTimestamp().toLocalDateTime().format(TIME_FORMAT));
        }

        dto.setReviewed(rs.getBoolean("is_reviewed"));
        int revBy = rs.getInt("reviewed_by");
        if (!rs.wasNull()) {
            dto.setReviewedBy(revBy);
        }
        dto.setReviewerName(rs.getString("reviewer_name"));
        dto.setReviewedAt(rs.getTimestamp("reviewed_at"));
        dto.setReviewNotes(rs.getString("review_notes"));

        return dto;
    }
}
