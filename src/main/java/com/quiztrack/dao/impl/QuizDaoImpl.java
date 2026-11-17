package com.quiztrack.dao.impl;

import com.quiztrack.dao.QuizDao;
import com.quiztrack.model.Quiz;
import com.quiztrack.util.DatabaseConnection;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

/**
 * JDBC implementation of QuizDao with PreparedStatements and HikariCP connection pooling.
 */
public class QuizDaoImpl implements QuizDao {

    private static final Logger logger = LoggerFactory.getLogger(QuizDaoImpl.class);

    private static final String SELECT_BASE =
            "SELECT q.quiz_id, q.title, q.description, q.subject_id, s.subject_code, s.subject_name, " +
            "       q.teacher_id, u.full_name AS teacher_name, q.duration_minutes, q.total_marks, " +
            "       q.pass_percentage, q.negative_marking, q.negative_mark_value, q.max_tab_switches, " +
            "       q.fullscreen_required, q.webcam_required, q.shuffle_questions, q.start_time, q.end_time, " +
            "       q.status, q.created_at, q.updated_at, " +
            "       (SELECT COUNT(*) FROM quiz_questions WHERE quiz_id = q.quiz_id) AS total_questions, " +
            "       (SELECT COUNT(*) FROM quiz_attempts WHERE quiz_id = q.quiz_id AND status = 'SUBMITTED') AS total_submissions, " +
            "       (SELECT COUNT(*) FROM quiz_attempts WHERE quiz_id = q.quiz_id AND status = 'IN_PROGRESS') AS active_examinees, " +
            "       (SELECT COALESCE(AVG(percentage), 0.0) FROM results WHERE quiz_id = q.quiz_id) AS avg_score, " +
            "       (SELECT COUNT(*) FROM activity_logs al JOIN quiz_attempts qa ON al.attempt_id = qa.attempt_id WHERE qa.quiz_id = q.quiz_id AND al.severity IN ('CAUTION', 'CRITICAL')) AS flagged_count " +
            "FROM quizzes q " +
            "JOIN subjects s ON q.subject_id = s.subject_id " +
            "JOIN users u ON q.teacher_id = u.user_id ";

    @Override
    public List<Quiz> findAllQuizzes() {
        List<Quiz> list = new ArrayList<>();
        String sql = SELECT_BASE + "ORDER BY CASE WHEN q.status = 'ACTIVE' THEN 1 WHEN q.status = 'SCHEDULED' THEN 2 ELSE 3 END, q.start_time ASC";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapResultSetToQuiz(rs));
            }
        } catch (SQLException e) {
            logger.error("Error finding all quizzes", e);
        }
        return list;
    }

    @Override
    public List<Quiz> findQuizzesByTeacher(int teacherId) {
        List<Quiz> list = new ArrayList<>();
        String sql = SELECT_BASE + "WHERE q.teacher_id = ? ORDER BY q.created_at DESC";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, teacherId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapResultSetToQuiz(rs));
                }
            }
        } catch (SQLException e) {
            logger.error("Error finding quizzes by teacher: {}", teacherId, e);
        }
        return list;
    }

    @Override
    public Optional<Quiz> findActiveQuiz() {
        String sql = SELECT_BASE + "WHERE q.status = 'ACTIVE' ORDER BY q.start_time ASC LIMIT 1";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return Optional.of(mapResultSetToQuiz(rs));
            }
        } catch (SQLException e) {
            logger.error("Error finding active quiz", e);
        }
        return Optional.empty();
    }

    @Override
    public Optional<Quiz> findById(int quizId) {
        String sql = SELECT_BASE + "WHERE q.quiz_id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, quizId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return Optional.of(mapResultSetToQuiz(rs));
                }
            }
        } catch (SQLException e) {
            logger.error("Error finding quiz by id: {}", quizId, e);
        }
        return Optional.empty();
    }

    @Override
    public int countQuizzesByStatus(String status) {
        String sql = "SELECT COUNT(*) FROM quizzes WHERE UPPER(status) = UPPER(?)";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            logger.error("Error counting quizzes by status: {}", status, e);
        }
        return 0;
    }

    @Override
    public int countTotalQuizzes() {
        String sql = "SELECT COUNT(*) FROM quizzes";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            logger.error("Error counting total quizzes", e);
        }
        return 0;
    }

    @Override
    public int create(Quiz quiz) {
        String sql =
                "INSERT INTO quizzes (" +
                "    title, description, subject_id, teacher_id, duration_minutes, total_marks, pass_percentage, " +
                "    negative_marking, negative_mark_value, max_tab_switches, fullscreen_required, webcam_required, " +
                "    shuffle_questions, start_time, end_time, status, created_at, updated_at" +
                ") VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP) " +
                "RETURNING quiz_id";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, quiz.getTitle());
            ps.setString(2, quiz.getDescription());
            ps.setInt(3, quiz.getSubjectId());
            ps.setInt(4, quiz.getTeacherId());
            ps.setInt(5, quiz.getDurationMinutes());
            ps.setBigDecimal(6, quiz.getTotalMarks());
            ps.setBigDecimal(7, quiz.getPassPercentage());
            ps.setBoolean(8, quiz.isNegativeMarking());
            ps.setBigDecimal(9, quiz.getNegativeMarkValue());
            ps.setInt(10, quiz.getMaxTabSwitches());
            ps.setBoolean(11, quiz.isFullscreenRequired());
            ps.setBoolean(12, quiz.isWebcamRequired());
            ps.setBoolean(13, quiz.isShuffleQuestions());
            ps.setTimestamp(14, quiz.getStartTime());
            ps.setTimestamp(15, quiz.getEndTime());
            ps.setString(16, quiz.getStatus() != null ? quiz.getStatus() : "DRAFT");

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    int id = rs.getInt(1);
                    quiz.setQuizId(id);
                    logger.info("Created quiz ID: {} for teacher: {}", id, quiz.getTeacherId());
                    return id;
                }
            }
        } catch (SQLException e) {
            logger.error("Error creating quiz: {}", quiz.getTitle(), e);
        }
        return -1;
    }

    @Override
    public boolean update(Quiz quiz) {
        String sql =
                "UPDATE quizzes SET " +
                "    title = ?, description = ?, subject_id = ?, duration_minutes = ?, total_marks = ?, " +
                "    pass_percentage = ?, negative_marking = ?, negative_mark_value = ?, max_tab_switches = ?, " +
                "    fullscreen_required = ?, webcam_required = ?, shuffle_questions = ?, start_time = ?, " +
                "    end_time = ?, status = ?, updated_at = CURRENT_TIMESTAMP " +
                "WHERE quiz_id = ? AND (teacher_id = ? OR ? = 1)";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, quiz.getTitle());
            ps.setString(2, quiz.getDescription());
            ps.setInt(3, quiz.getSubjectId());
            ps.setInt(4, quiz.getDurationMinutes());
            ps.setBigDecimal(5, quiz.getTotalMarks());
            ps.setBigDecimal(6, quiz.getPassPercentage());
            ps.setBoolean(7, quiz.isNegativeMarking());
            ps.setBigDecimal(8, quiz.getNegativeMarkValue());
            ps.setInt(9, quiz.getMaxTabSwitches());
            ps.setBoolean(10, quiz.isFullscreenRequired());
            ps.setBoolean(11, quiz.isWebcamRequired());
            ps.setBoolean(12, quiz.isShuffleQuestions());
            ps.setTimestamp(13, quiz.getStartTime());
            ps.setTimestamp(14, quiz.getEndTime());
            ps.setString(15, quiz.getStatus());
            ps.setInt(16, quiz.getQuizId());
            ps.setInt(17, quiz.getTeacherId());
            ps.setInt(18, quiz.getTeacherId()); // allows admin bypass if teacherId=1

            int affected = ps.executeUpdate();
            return affected > 0;
        } catch (SQLException e) {
            logger.error("Error updating quiz ID: {}", quiz.getQuizId(), e);
        }
        return false;
    }

    @Override
    public boolean delete(int quizId, int teacherId) {
        String sql = "DELETE FROM quizzes WHERE quiz_id = ? AND (teacher_id = ? OR ? = 1)";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, quizId);
            ps.setInt(2, teacherId);
            ps.setInt(3, teacherId);

            int affected = ps.executeUpdate();
            return affected > 0;
        } catch (SQLException e) {
            logger.error("Error deleting quiz ID: {} for teacher: {}", quizId, teacherId, e);
        }
        return false;
    }

    @Override
    public boolean updateStatus(int quizId, int teacherId, String status) {
        String sql = "UPDATE quizzes SET status = ?, updated_at = CURRENT_TIMESTAMP WHERE quiz_id = ? AND (teacher_id = ? OR ? = 1)";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, quizId);
            ps.setInt(3, teacherId);
            ps.setInt(4, teacherId);

            int affected = ps.executeUpdate();
            return affected > 0;
        } catch (SQLException e) {
            logger.error("Error updating status of quiz ID: {} to {}", quizId, status, e);
        }
        return false;
    }

    @Override
    public boolean isOwnedBy(int quizId, int teacherId) {
        String sql = "SELECT 1 FROM quizzes WHERE quiz_id = ? AND (teacher_id = ? OR ? = 1)";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, quizId);
            ps.setInt(2, teacherId);
            ps.setInt(3, teacherId);

            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (SQLException e) {
            logger.error("Error checking ownership for quiz ID: {}", quizId, e);
        }
        return false;
    }

    private Quiz mapResultSetToQuiz(ResultSet rs) throws SQLException {
        Quiz q = new Quiz();
        q.setQuizId(rs.getInt("quiz_id"));
        q.setTitle(rs.getString("title"));
        q.setDescription(rs.getString("description"));
        q.setSubjectId(rs.getInt("subject_id"));
        q.setSubjectCode(rs.getString("subject_code"));
        q.setSubjectName(rs.getString("subject_name"));
        q.setTeacherId(rs.getInt("teacher_id"));
        q.setTeacherName(rs.getString("teacher_name"));
        q.setDurationMinutes(rs.getInt("duration_minutes"));
        q.setTotalMarks(rs.getBigDecimal("total_marks"));
        q.setPassPercentage(rs.getBigDecimal("pass_percentage"));
        q.setNegativeMarking(rs.getBoolean("negative_marking"));
        q.setNegativeMarkValue(rs.getBigDecimal("negative_mark_value"));
        q.setMaxTabSwitches(rs.getInt("max_tab_switches"));
        q.setFullscreenRequired(rs.getBoolean("fullscreen_required"));
        q.setWebcamRequired(rs.getBoolean("webcam_required"));
        q.setShuffleQuestions(rs.getBoolean("shuffle_questions"));
        q.setStartTime(rs.getTimestamp("start_time"));
        q.setEndTime(rs.getTimestamp("end_time"));
        q.setStatus(rs.getString("status"));
        q.setCreatedAt(rs.getTimestamp("created_at"));
        q.setUpdatedAt(rs.getTimestamp("updated_at"));

        q.setTotalQuestions(rs.getInt("total_questions"));
        q.setTotalSubmissions(rs.getInt("total_submissions"));
        q.setActiveExaminees(rs.getInt("active_examinees"));
        q.setAverageScore(rs.getDouble("avg_score"));
        q.setFlaggedCount(rs.getInt("flagged_count"));

        return q;
    }
}
