package com.quiztrack.dao.impl;

import com.quiztrack.dao.ExamDao;
import com.quiztrack.model.Question;
import com.quiztrack.model.QuestionOption;
import com.quiztrack.model.QuizAttempt;
import com.quiztrack.model.StudentAnswer;
import com.quiztrack.util.DatabaseConnection;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.sql.*;
import java.util.*;

/**
 * JDBC implementation of ExamDao.
 * Enforces transaction boundaries, server-side scoring, and atomic state updates.
 */
public class ExamDaoImpl implements ExamDao {

    private static final Logger logger = LoggerFactory.getLogger(ExamDaoImpl.class);

    @Override
    public Optional<QuizAttempt> findActiveAttempt(int quizId, int studentId) {
        String sql = "SELECT a.*, q.title as quiz_title, q.description as quiz_description, " +
                     "q.subject_id, s.subject_code, s.subject_name, q.duration_minutes, " +
                     "q.total_marks, q.pass_percentage, q.negative_marking, q.negative_mark_value, " +
                     "q.max_tab_switches, q.fullscreen_required, q.webcam_required " +
                     "FROM quiz_attempts a " +
                     "JOIN quizzes q ON a.quiz_id = q.quiz_id " +
                     "JOIN subjects s ON q.subject_id = s.subject_id " +
                     "WHERE a.quiz_id = ? AND a.student_id = ? AND a.status = 'IN_PROGRESS' " +
                     "ORDER BY a.start_time DESC LIMIT 1";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, quizId);
            ps.setInt(2, studentId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return Optional.of(mapAttempt(rs));
                }
            }
        } catch (SQLException e) {
            logger.error("Error finding active attempt for quizId: {} studentId: {}", quizId, studentId, e);
        }
        return Optional.empty();
    }

    @Override
    public Optional<QuizAttempt> findAttemptById(int attemptId) {
        String sql = "SELECT a.*, q.title as quiz_title, q.description as quiz_description, " +
                     "q.subject_id, s.subject_code, s.subject_name, q.duration_minutes, " +
                     "q.total_marks, q.pass_percentage, q.negative_marking, q.negative_mark_value, " +
                     "q.max_tab_switches, q.fullscreen_required, q.webcam_required " +
                     "FROM quiz_attempts a " +
                     "JOIN quizzes q ON a.quiz_id = q.quiz_id " +
                     "JOIN subjects s ON q.subject_id = s.subject_id " +
                     "WHERE a.attempt_id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, attemptId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return Optional.of(mapAttempt(rs));
                }
            }
        } catch (SQLException e) {
            logger.error("Error finding attempt by id: {}", attemptId, e);
        }
        return Optional.empty();
    }

    @Override
    public Optional<QuizAttempt> findSubmittedAttempt(int quizId, int studentId) {
        String sql = "SELECT a.*, q.title as quiz_title, q.description as quiz_description, " +
                     "q.subject_id, s.subject_code, s.subject_name, q.duration_minutes, " +
                     "q.total_marks, q.pass_percentage, q.negative_marking, q.negative_mark_value, " +
                     "q.max_tab_switches, q.fullscreen_required, q.webcam_required " +
                     "FROM quiz_attempts a " +
                     "JOIN quizzes q ON a.quiz_id = q.quiz_id " +
                     "JOIN subjects s ON q.subject_id = s.subject_id " +
                     "WHERE a.quiz_id = ? AND a.student_id = ? AND a.status IN ('SUBMITTED', 'TERMINATED') " +
                     "ORDER BY a.end_time DESC LIMIT 1";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, quizId);
            ps.setInt(2, studentId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return Optional.of(mapAttempt(rs));
                }
            }
        } catch (SQLException e) {
            logger.error("Error finding submitted attempt for quizId: {} studentId: {}", quizId, studentId, e);
        }
        return Optional.empty();
    }

    @Override
    public QuizAttempt createAttempt(int quizId, int studentId, String ipAddress, String userAgent) {
        String sql = "INSERT INTO quiz_attempts (quiz_id, student_id, start_time, status, ip_address, user_agent) " +
                     "VALUES (?, ?, CURRENT_TIMESTAMP, 'IN_PROGRESS', ?, ?) " +
                     "RETURNING attempt_id";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, quizId);
            ps.setInt(2, studentId);
            ps.setString(3, ipAddress != null ? ipAddress : "127.0.0.1");
            ps.setString(4, userAgent != null ? userAgent : "Browser Client");

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    int attemptId = rs.getInt("attempt_id");
                    return findAttemptById(attemptId).orElse(null);
                }
            }
        } catch (SQLException e) {
            logger.error("Error creating examination attempt for quizId: {} studentId: {}", quizId, studentId, e);
        }
        return null;
    }

    @Override
    public boolean isStudentEligible(int quizId, int studentId) {
        String sql = "SELECT 1 FROM quizzes q " +
                     "WHERE q.quiz_id = ? AND q.status = 'ACTIVE' " +
                     "AND ( " +
                     "  EXISTS ( " +
                     "    SELECT 1 FROM quiz_assignments qa " +
                     "    WHERE qa.quiz_id = q.quiz_id " +
                     "    AND (qa.student_id = ? OR qa.cohort_id IN (SELECT cohort_id FROM cohort_students WHERE student_id = ?)) " +
                     "  ) " +
                     ")";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, quizId);
            ps.setInt(2, studentId);
            ps.setInt(3, studentId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (SQLException e) {
            logger.error("Error verifying eligibility for quizId: {} studentId: {}", quizId, studentId, e);
        }
        return false;
    }

    @Override
    public List<Question> getQuizQuestions(int quizId, boolean shuffle) {
        List<Question> questions = new ArrayList<>();
        String sql = "SELECT q.*, qq.sort_order, COALESCE(qq.points_override, q.points) AS effective_points, s.subject_code, s.subject_name " +
                     "FROM quiz_questions qq " +
                     "JOIN questions q ON qq.question_id = q.question_id " +
                     "JOIN subjects s ON q.subject_id = s.subject_id " +
                     "WHERE qq.quiz_id = ? " +
                     (shuffle ? "ORDER BY RANDOM()" : "ORDER BY qq.sort_order ASC, q.question_id ASC");

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, quizId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Question q = new Question();
                    q.setQuestionId(rs.getInt("question_id"));
                    q.setQuizId(quizId);
                    q.setSubjectId(rs.getInt("subject_id"));
                    q.setSubjectCode(rs.getString("subject_code"));
                    q.setSubjectName(rs.getString("subject_name"));
                    q.setQuestionText(rs.getString("question_text"));
                    q.setQuestionType(rs.getString("question_type"));
                    q.setPoints(rs.getBigDecimal("effective_points"));
                    q.setDifficultyLevel(rs.getString("difficulty_level"));
                    q.setTaxonomyTopic(rs.getString("taxonomy_topic"));
                    q.setCodeSnippet(rs.getString("code_snippet"));
                    q.setExplanation(rs.getString("explanation"));

                    // Retrieve options
                    q.setOptions(getQuestionOptions(q.getQuestionId()));
                    questions.add(q);
                }
            }
        } catch (SQLException e) {
            logger.error("Error retrieving questions for quizId: {}", quizId, e);
        }
        return questions;
    }

    @Override
    public List<QuestionOption> getQuestionOptions(int questionId) {
        List<QuestionOption> options = new ArrayList<>();
        String sql = "SELECT option_id, question_id, option_letter, option_text, is_correct, sort_order " +
                     "FROM question_options " +
                     "WHERE question_id = ? " +
                     "ORDER BY sort_order ASC, option_letter ASC";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, questionId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    QuestionOption opt = new QuestionOption();
                    opt.setOptionId(rs.getInt("option_id"));
                    opt.setQuestionId(rs.getInt("question_id"));
                    opt.setOptionLetter(rs.getString("option_letter"));
                    opt.setOptionText(rs.getString("option_text"));
                    opt.setCorrect(rs.getBoolean("is_correct"));
                    opt.setSortOrder(rs.getInt("sort_order"));
                    options.add(opt);
                }
            }
        } catch (SQLException e) {
            logger.error("Error retrieving options for questionId: {}", questionId, e);
        }
        return options;
    }

    @Override
    public Map<Integer, StudentAnswer> getStudentAnswersForAttempt(int attemptId) {
        Map<Integer, StudentAnswer> map = new HashMap<>();
        String sql = "SELECT a.*, o.option_letter " +
                     "FROM student_answers a " +
                     "LEFT JOIN question_options o ON a.selected_option_id = o.option_id " +
                     "WHERE a.attempt_id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, attemptId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    StudentAnswer ans = new StudentAnswer();
                    ans.setAnswerId(rs.getInt("answer_id"));
                    ans.setAttemptId(rs.getInt("attempt_id"));
                    ans.setQuestionId(rs.getInt("question_id"));
                    int optId = rs.getInt("selected_option_id");
                    ans.setSelectedOptionId(rs.wasNull() ? null : optId);
                    ans.setSelectedOptionLetter(rs.getString("option_letter"));
                    ans.setTextResponse(rs.getString("text_response"));
                    ans.setFlaggedForReview(rs.getBoolean("is_flagged_for_review"));
                    boolean isCorr = rs.getBoolean("is_correct");
                    ans.setIsCorrect(rs.wasNull() ? null : isCorr);
                    ans.setMarksAwarded(rs.getBigDecimal("marks_awarded"));
                    ans.setAnsweredAt(rs.getTimestamp("answered_at"));
                    ans.setLastUpdatedAt(rs.getTimestamp("last_updated_at"));

                    map.put(ans.getQuestionId(), ans);
                }
            }
        } catch (SQLException e) {
            logger.error("Error retrieving student answers for attemptId: {}", attemptId, e);
        }
        return map;
    }

    @Override
    public boolean saveOrUpdateAnswer(int attemptId, int questionId, Integer selectedOptionId, String textResponse, boolean isFlagged) {
        String sql = "INSERT INTO student_answers (attempt_id, question_id, selected_option_id, text_response, is_flagged_for_review, answered_at, last_updated_at) " +
                     "VALUES (?, ?, ?, ?, ?, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP) " +
                     "ON CONFLICT (attempt_id, question_id) DO UPDATE SET " +
                     "selected_option_id = EXCLUDED.selected_option_id, " +
                     "text_response = EXCLUDED.text_response, " +
                     "is_flagged_for_review = EXCLUDED.is_flagged_for_review, " +
                     "last_updated_at = CURRENT_TIMESTAMP";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, attemptId);
            ps.setInt(2, questionId);
            if (selectedOptionId != null && selectedOptionId > 0) {
                ps.setInt(3, selectedOptionId);
            } else {
                ps.setNull(3, Types.INTEGER);
            }
            ps.setString(4, textResponse);
            ps.setBoolean(5, isFlagged);

            int affected = ps.executeUpdate();
            return affected > 0;
        } catch (SQLException e) {
            logger.error("Error saving answer for attemptId: {} questionId: {}", attemptId, questionId, e);
        }
        return false;
    }

    @Override
    public boolean toggleFlagForReview(int attemptId, int questionId, boolean isFlagged) {
        String sql = "INSERT INTO student_answers (attempt_id, question_id, is_flagged_for_review, last_updated_at) " +
                     "VALUES (?, ?, ?, CURRENT_TIMESTAMP) " +
                     "ON CONFLICT (attempt_id, question_id) DO UPDATE SET " +
                     "is_flagged_for_review = EXCLUDED.is_flagged_for_review, " +
                     "last_updated_at = CURRENT_TIMESTAMP";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, attemptId);
            ps.setInt(2, questionId);
            ps.setBoolean(3, isFlagged);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            logger.error("Error toggling flag for attemptId: {} questionId: {}", attemptId, questionId, e);
        }
        return false;
    }

    @Override
    public boolean recordTelemetryEvent(int attemptId, int userId, String eventType, String severity, String details) {
        String insertSql = "INSERT INTO activity_logs (attempt_id, user_id, event_type, severity, details, event_timestamp) " +
                           "VALUES (?, ?, ?, ?, ?, CURRENT_TIMESTAMP)";

        String updateAttemptSql = "UPDATE quiz_attempts SET " +
                                  "tab_switch_count = tab_switch_count + (CASE WHEN ? = 'TAB_SWITCH' THEN 1 ELSE 0 END), " +
                                  "blur_count = blur_count + (CASE WHEN ? = 'FOCUS_LOST' THEN 1 ELSE 0 END), " +
                                  "fullscreen_exit_count = fullscreen_exit_count + (CASE WHEN ? = 'FULLSCREEN_EXIT' THEN 1 ELSE 0 END) " +
                                  "WHERE attempt_id = ?";

        try (Connection conn = DatabaseConnection.getConnection()) {
            conn.setAutoCommit(false);
            try {
                try (PreparedStatement psLog = conn.prepareStatement(insertSql)) {
                    psLog.setInt(1, attemptId);
                    psLog.setInt(2, userId);
                    psLog.setString(3, eventType);
                    psLog.setString(4, severity != null ? severity : "INFO");
                    psLog.setString(5, details);
                    psLog.executeUpdate();
                }

                try (PreparedStatement psUp = conn.prepareStatement(updateAttemptSql)) {
                    psUp.setString(1, eventType);
                    psUp.setString(2, eventType);
                    psUp.setString(3, eventType);
                    psUp.setInt(4, attemptId);
                    psUp.executeUpdate();
                }

                conn.commit();
                return true;
            } catch (SQLException ex) {
                conn.rollback();
                throw ex;
            } finally {
                conn.setAutoCommit(true);
            }
        } catch (SQLException e) {
            logger.error("Error recording telemetry event for attemptId: {}", attemptId, e);
        }
        return false;
    }

    @Override
    public boolean finalizeSubmission(int attemptId, int studentId) {
        Optional<QuizAttempt> attemptOpt = findAttemptById(attemptId);
        if (attemptOpt.isEmpty()) {
            logger.warn("Cannot finalize submission: attemptId {} not found", attemptId);
            return false;
        }

        QuizAttempt attempt = attemptOpt.get();
        if (attempt.getStudentId() != studentId) {
            logger.warn("Security violation: attemptId {} belongs to student {} but submitted by {}", attemptId, attempt.getStudentId(), studentId);
            return false;
        }

        if ("SUBMITTED".equalsIgnoreCase(attempt.getStatus())) {
            logger.info("Attempt {} is already submitted", attemptId);
            return true; // Already submitted idempotently
        }

        int quizId = attempt.getQuizId();

        try (Connection conn = DatabaseConnection.getConnection()) {
            conn.setAutoCommit(false);
            try {
                // 1. Fetch questions with correct answers
                String qSql = "SELECT q.question_id, COALESCE(qq.points_override, q.points) AS points, qo.option_id AS correct_option_id " +
                              "FROM quiz_questions qq " +
                              "JOIN questions q ON qq.question_id = q.question_id " +
                              "JOIN question_options qo ON q.question_id = qo.question_id " +
                              "WHERE qq.quiz_id = ? AND qo.is_correct = TRUE";

                Map<Integer, BigDecimal> questionPoints = new HashMap<>();
                Map<Integer, Integer> correctOptions = new HashMap<>();

                try (PreparedStatement psQ = conn.prepareStatement(qSql)) {
                    psQ.setInt(1, quizId);
                    try (ResultSet rsQ = psQ.executeQuery()) {
                        while (rsQ.next()) {
                            int qId = rsQ.getInt("question_id");
                            questionPoints.put(qId, rsQ.getBigDecimal("points"));
                            correctOptions.put(qId, rsQ.getInt("correct_option_id"));
                        }
                    }
                }

                // 2. Fetch student answers for attempt
                String ansSql = "SELECT question_id, selected_option_id FROM student_answers WHERE attempt_id = ?";
                Map<Integer, Integer> studentSelected = new HashMap<>();
                try (PreparedStatement psA = conn.prepareStatement(ansSql)) {
                    psA.setInt(1, attemptId);
                    try (ResultSet rsA = psA.executeQuery()) {
                        while (rsA.next()) {
                            int qId = rsA.getInt("question_id");
                            int optId = rsA.getInt("selected_option_id");
                            if (!rsA.wasNull()) {
                                studentSelected.put(qId, optId);
                            }
                        }
                    }
                }

                // 3. Compute score
                BigDecimal totalScore = BigDecimal.ZERO;
                boolean negativeMarking = attempt.isNegativeMarking();
                BigDecimal negPenalty = attempt.getNegativeMarkValue() != null ? attempt.getNegativeMarkValue() : BigDecimal.ZERO;

                String updateAnsSql = "UPDATE student_answers SET is_correct = ?, marks_awarded = ? " +
                                      "WHERE attempt_id = ? AND question_id = ?";

                try (PreparedStatement psUpAns = conn.prepareStatement(updateAnsSql)) {
                    for (Map.Entry<Integer, BigDecimal> entry : questionPoints.entrySet()) {
                        int qId = entry.getKey();
                        BigDecimal pts = entry.getValue() != null ? entry.getValue() : BigDecimal.ZERO;
                        Integer correctOptId = correctOptions.get(qId);
                        Integer selectedOptId = studentSelected.get(qId);

                        boolean isCorrect = false;
                        BigDecimal awarded = BigDecimal.ZERO;

                        if (selectedOptId != null && correctOptId != null) {
                            if (selectedOptId.equals(correctOptId)) {
                                isCorrect = true;
                                awarded = pts;
                            } else {
                                isCorrect = false;
                                if (negativeMarking) {
                                    awarded = negPenalty.negate();
                                }
                            }
                            totalScore = totalScore.add(awarded);

                            psUpAns.setBoolean(1, isCorrect);
                            psUpAns.setBigDecimal(2, awarded);
                            psUpAns.setInt(3, attemptId);
                            psUpAns.setInt(4, qId);
                            psUpAns.addBatch();
                        }
                    }
                    psUpAns.executeBatch();
                }

                // Prevent negative total exam score
                if (totalScore.compareTo(BigDecimal.ZERO) < 0) {
                    totalScore = BigDecimal.ZERO;
                }

                BigDecimal totalMarks = attempt.getTotalMarks();
                if (totalMarks == null || totalMarks.compareTo(BigDecimal.ZERO) <= 0) {
                    totalMarks = new BigDecimal("100.00");
                }

                BigDecimal percentage = totalScore.divide(totalMarks, 4, RoundingMode.HALF_UP)
                                                  .multiply(new BigDecimal("100.00"))
                                                  .setScale(2, RoundingMode.HALF_UP);

                BigDecimal passPercentage = attempt.getPassPercentage() != null ? attempt.getPassPercentage() : new BigDecimal("50.00");
                boolean passed = percentage.compareTo(passPercentage) >= 0;

                String grade = computeGrade(percentage);

                // 4. Update quiz_attempts to SUBMITTED
                String updateAttemptSql = "UPDATE quiz_attempts SET " +
                                          "status = 'SUBMITTED', " +
                                          "end_time = CURRENT_TIMESTAMP, " +
                                          "total_score = ?, " +
                                          "percentage = ?, " +
                                          "grade = ?, " +
                                          "passed = ? " +
                                          "WHERE attempt_id = ? AND student_id = ?";

                try (PreparedStatement psAtt = conn.prepareStatement(updateAttemptSql)) {
                    psAtt.setBigDecimal(1, totalScore);
                    psAtt.setBigDecimal(2, percentage);
                    psAtt.setString(3, grade);
                    psAtt.setBoolean(4, passed);
                    psAtt.setInt(5, attemptId);
                    psAtt.setInt(6, studentId);
                    psAtt.executeUpdate();
                }

                // 5. Generate cryptographic certificate hash and record in results
                String certHash = generateCertificateHash(studentId, quizId, attemptId, totalScore);

                String resultSql = "INSERT INTO results (attempt_id, student_id, quiz_id, score, max_score, percentage, grade, certificate_hash, certified_at) " +
                                   "VALUES (?, ?, ?, ?, ?, ?, ?, ?, CURRENT_TIMESTAMP) " +
                                   "ON CONFLICT (attempt_id) DO UPDATE SET " +
                                   "score = EXCLUDED.score, " +
                                   "percentage = EXCLUDED.percentage, " +
                                   "grade = EXCLUDED.grade, " +
                                   "certificate_hash = EXCLUDED.certificate_hash";

                try (PreparedStatement psRes = conn.prepareStatement(resultSql)) {
                    psRes.setInt(1, attemptId);
                    psRes.setInt(2, studentId);
                    psRes.setInt(3, quizId);
                    psRes.setBigDecimal(4, totalScore);
                    psRes.setBigDecimal(5, totalMarks);
                    psRes.setBigDecimal(6, percentage);
                    psRes.setString(7, grade);
                    psRes.setString(8, certHash);
                    psRes.executeUpdate();
                }

                conn.commit();
                logger.info("Successfully submitted exam attemptId: {} for student: {} with score: {} ({})",
                        attemptId, studentId, totalScore, grade);
                return true;
            } catch (SQLException ex) {
                conn.rollback();
                logger.error("Transaction rolled back during exam finalization for attemptId: {}", attemptId, ex);
                throw ex;
            } finally {
                conn.setAutoCommit(true);
            }
        } catch (SQLException e) {
            logger.error("Database error finalizing submission for attemptId: {}", attemptId, e);
        }
        return false;
    }

    private QuizAttempt mapAttempt(ResultSet rs) throws SQLException {
        QuizAttempt a = new QuizAttempt();
        a.setAttemptId(rs.getInt("attempt_id"));
        a.setQuizId(rs.getInt("quiz_id"));
        a.setStudentId(rs.getInt("student_id"));
        a.setStartTime(rs.getTimestamp("start_time"));
        a.setEndTime(rs.getTimestamp("end_time"));
        a.setStatus(rs.getString("status"));
        a.setTotalScore(rs.getBigDecimal("total_score"));
        a.setPercentage(rs.getBigDecimal("percentage"));
        a.setGrade(rs.getString("grade"));
        a.setPassed(rs.getBoolean("passed"));
        a.setTabSwitchCount(rs.getInt("tab_switch_count"));
        a.setBlurCount(rs.getInt("blur_count"));
        a.setFullscreenExitCount(rs.getInt("fullscreen_exit_count"));
        a.setIntegrityIndex(rs.getBigDecimal("integrity_index"));
        a.setIpAddress(rs.getString("ip_address"));
        a.setUserAgent(rs.getString("user_agent"));

        // Joined Quiz info
        a.setQuizTitle(rs.getString("quiz_title"));
        a.setQuizDescription(rs.getString("quiz_description"));
        a.setSubjectId(rs.getInt("subject_id"));
        a.setSubjectCode(rs.getString("subject_code"));
        a.setSubjectName(rs.getString("subject_name"));
        a.setDurationMinutes(rs.getInt("duration_minutes"));
        a.setTotalMarks(rs.getBigDecimal("total_marks"));
        a.setPassPercentage(rs.getBigDecimal("pass_percentage"));
        a.setNegativeMarking(rs.getBoolean("negative_marking"));
        a.setNegativeMarkValue(rs.getBigDecimal("negative_mark_value"));
        a.setMaxTabSwitches(rs.getInt("max_tab_switches"));
        a.setFullscreenRequired(rs.getBoolean("fullscreen_required"));
        a.setWebcamRequired(rs.getBoolean("webcam_required"));
        return a;
    }

    private String computeGrade(BigDecimal percentage) {
        double p = percentage.doubleValue();
        if (p >= 90.0) return "A+";
        if (p >= 80.0) return "A";
        if (p >= 70.0) return "B";
        if (p >= 60.0) return "C";
        if (p >= 50.0) return "D";
        return "F";
    }

    private String generateCertificateHash(int studentId, int quizId, int attemptId, BigDecimal score) {
        String raw = "QUIZTRACK-" + studentId + "-" + quizId + "-" + attemptId + "-" + score.toString() + "-" + System.currentTimeMillis();
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            byte[] hash = md.digest(raw.getBytes(StandardCharsets.UTF_8));
            StringBuilder hex = new StringBuilder();
            for (byte b : hash) {
                hex.append(String.format("%02x", b));
            }
            return hex.toString();
        } catch (NoSuchAlgorithmException e) {
            return UUID.randomUUID().toString().replace("-", "");
        }
    }
}
