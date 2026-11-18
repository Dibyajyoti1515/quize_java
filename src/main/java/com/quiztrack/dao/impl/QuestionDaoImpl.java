package com.quiztrack.dao.impl;

import com.quiztrack.dao.QuestionDao;
import com.quiztrack.model.Question;
import com.quiztrack.model.QuestionOption;
import com.quiztrack.util.DatabaseConnection;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

/**
 * JDBC implementation of QuestionDao with PreparedStatements and HikariCP connection pooling.
 */
public class QuestionDaoImpl implements QuestionDao {

    private static final Logger logger = LoggerFactory.getLogger(QuestionDaoImpl.class);

    private static final String SELECT_BASE =
            "SELECT q.question_id, q.quiz_id, q.subject_id, s.subject_code, s.subject_name, " +
            "       q.question_text, q.question_type, q.points, q.difficulty_level, " +
            "       q.taxonomy_topic, q.explanation, q.code_snippet, q.created_by, " +
            "       u.full_name AS created_by_name, q.created_at " +
            "FROM questions q " +
            "JOIN subjects s ON q.subject_id = s.subject_id " +
            "LEFT JOIN users u ON q.created_by = u.user_id ";

    @Override
    public int create(Question question) {
        String sql =
                "INSERT INTO questions (" +
                "    quiz_id, subject_id, question_text, question_type, points, difficulty_level, " +
                "    taxonomy_topic, explanation, code_snippet, created_by, created_at" +
                ") VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, CURRENT_TIMESTAMP) " +
                "RETURNING question_id";

        try (Connection conn = DatabaseConnection.getConnection()) {
            conn.setAutoCommit(false);
            int questionId = -1;

            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                if (question.getQuizId() != null && question.getQuizId() > 0) {
                    ps.setInt(1, question.getQuizId());
                } else {
                    ps.setNull(1, Types.INTEGER);
                }
                ps.setInt(2, question.getSubjectId());
                ps.setString(3, question.getQuestionText());
                ps.setString(4, question.getQuestionType() != null ? question.getQuestionType() : "SINGLE_CHOICE");
                ps.setBigDecimal(5, question.getPoints());
                ps.setString(6, question.getDifficultyLevel() != null ? question.getDifficultyLevel() : "MEDIUM");
                ps.setString(7, question.getTaxonomyTopic());
                ps.setString(8, question.getExplanation());
                ps.setString(9, question.getCodeSnippet());
                if (question.getCreatedBy() != null) {
                    ps.setInt(10, question.getCreatedBy());
                } else {
                    ps.setNull(10, Types.INTEGER);
                }

                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        questionId = rs.getInt(1);
                        question.setQuestionId(questionId);
                    }
                }
            }

            // Insert Options
            if (questionId > 0 && question.getOptions() != null && !question.getOptions().isEmpty()) {
                insertOptions(conn, questionId, question.getOptions());
                question.setOptions(findOptionsByQuestionId(conn, questionId));
            }

            // Link into quiz_questions if quizId is provided
            if (questionId > 0 && question.getQuizId() != null && question.getQuizId() > 0) {
                String joinSql =
                        "INSERT INTO quiz_questions (quiz_id, question_id, sort_order, points_override) " +
                        "VALUES (?, ?, (SELECT COALESCE(MAX(sort_order), 0) + 1 FROM quiz_questions WHERE quiz_id = ?), ?) " +
                        "ON CONFLICT (quiz_id, question_id) DO NOTHING";
                try (PreparedStatement joinPs = conn.prepareStatement(joinSql)) {
                    joinPs.setInt(1, question.getQuizId());
                    joinPs.setInt(2, questionId);
                    joinPs.setInt(3, question.getQuizId());
                    joinPs.setBigDecimal(4, question.getPoints());
                    joinPs.executeUpdate();
                }
            }

            conn.commit();
            int optionCount = (question.getOptions() != null) ? question.getOptions().size() : 0;
            logger.info("Successfully created question ID: {} with {} options", questionId, optionCount);
            return questionId;
        } catch (SQLException e) {
            logger.error("Error creating question", e);
        }
        return -1;
    }

    @Override
    public boolean update(Question question) {
        String sql =
                "UPDATE questions SET " +
                "    subject_id = ?, question_text = ?, question_type = ?, points = ?, " +
                "    difficulty_level = ?, taxonomy_topic = ?, explanation = ?, code_snippet = ? " +
                "WHERE question_id = ?";

        try (Connection conn = DatabaseConnection.getConnection()) {
            conn.setAutoCommit(false);

            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, question.getSubjectId());
                ps.setString(2, question.getQuestionText());
                ps.setString(3, question.getQuestionType());
                ps.setBigDecimal(4, question.getPoints());
                ps.setString(5, question.getDifficultyLevel());
                ps.setString(6, question.getTaxonomyTopic());
                ps.setString(7, question.getExplanation());
                ps.setString(8, question.getCodeSnippet());
                ps.setInt(9, question.getQuestionId());

                int affected = ps.executeUpdate();
                if (affected == 0) {
                    conn.rollback();
                    return false;
                }
            }

            // Replace options if provided
            if (question.getOptions() != null && !question.getOptions().isEmpty()) {
                String delSql = "DELETE FROM question_options WHERE question_id = ?";
                try (PreparedStatement delPs = conn.prepareStatement(delSql)) {
                    delPs.setInt(1, question.getQuestionId());
                    delPs.executeUpdate();
                }
                insertOptions(conn, question.getQuestionId(), question.getOptions());
            }

            conn.commit();
            return true;
        } catch (SQLException e) {
            logger.error("Error updating question ID: {}", question.getQuestionId(), e);
        }
        return false;
    }

    @Override
    public boolean delete(int questionId, int teacherId) {
        String sql = "DELETE FROM questions WHERE question_id = ? AND created_by = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, questionId);
            ps.setInt(2, teacherId);

            int affected = ps.executeUpdate();
            return affected > 0;
        } catch (SQLException e) {
            logger.error("Error deleting question ID: {}", questionId, e);
        }
        return false;
    }

    @Override
    public boolean delete(int questionId) {
        String sql = "DELETE FROM questions WHERE question_id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, questionId);

            int affected = ps.executeUpdate();
            return affected > 0;
        } catch (SQLException e) {
            logger.error("Error administratively deleting question ID: {}", questionId, e);
        }
        return false;
    }

    @Override
    public Optional<Question> findById(int questionId) {
        String sql = SELECT_BASE + "WHERE q.question_id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, questionId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Question q = mapResultSetToQuestion(rs);
                    q.setOptions(findOptionsByQuestionId(conn, questionId));
                    return Optional.of(q);
                }
            }
        } catch (SQLException e) {
            logger.error("Error finding question by ID: {}", questionId, e);
        }
        return Optional.empty();
    }

    @Override
    public List<Question> findByQuizId(int quizId) {
        List<Question> list = new ArrayList<>();
        String sql =
                "SELECT q.question_id, qq.quiz_id, q.subject_id, s.subject_code, s.subject_name, " +
                "       q.question_text, q.question_type, COALESCE(qq.points_override, q.points) AS points, q.difficulty_level, " +
                "       q.taxonomy_topic, q.explanation, q.code_snippet, q.created_by, " +
                "       u.full_name AS created_by_name, q.created_at " +
                "FROM quiz_questions qq " +
                "JOIN questions q ON qq.question_id = q.question_id " +
                "JOIN subjects s ON q.subject_id = s.subject_id " +
                "LEFT JOIN users u ON q.created_by = u.user_id " +
                "WHERE qq.quiz_id = ? " +
                "ORDER BY qq.sort_order ASC, q.question_id ASC";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, quizId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Question q = mapResultSetToQuestion(rs);
                    q.setOptions(findOptionsByQuestionId(conn, q.getQuestionId()));
                    list.add(q);
                }
            }
        } catch (SQLException e) {
            logger.error("Error finding questions for quiz ID: {}", quizId, e);
        }
        return list;
    }

    @Override
    public List<Question> findQuestionBank(Integer subjectId, String difficulty, String topic, String searchQuery, int limit, int offset) {
        List<Question> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(SELECT_BASE);
        sql.append("WHERE 1=1 ");

        List<Object> params = new ArrayList<>();

        if (subjectId != null && subjectId > 0) {
            sql.append("AND q.subject_id = ? ");
            params.add(subjectId);
        }
        if (difficulty != null && !difficulty.trim().isEmpty() && !"ALL".equalsIgnoreCase(difficulty)) {
            sql.append("AND q.difficulty_level = ? ");
            params.add(difficulty.toUpperCase());
        }
        if (topic != null && !topic.trim().isEmpty() && !"ALL".equalsIgnoreCase(topic)) {
            sql.append("AND q.taxonomy_topic ILIKE ? ");
            params.add("%" + topic.trim() + "%");
        }
        if (searchQuery != null && !searchQuery.trim().isEmpty()) {
            sql.append("AND (q.question_text ILIKE ? OR q.taxonomy_topic ILIKE ? OR q.explanation ILIKE ?) ");
            String wild = "%" + searchQuery.trim() + "%";
            params.add(wild);
            params.add(wild);
            params.add(wild);
        }

        sql.append("ORDER BY q.created_at DESC LIMIT ? OFFSET ?");
        params.add(limit > 0 ? limit : 50);
        params.add(offset >= 0 ? offset : 0);

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Question q = mapResultSetToQuestion(rs);
                    q.setOptions(findOptionsByQuestionId(conn, q.getQuestionId()));
                    list.add(q);
                }
            }
        } catch (SQLException e) {
            logger.error("Error searching Question Bank", e);
        }
        return list;
    }

    @Override
    public int countQuestionBank(Integer subjectId, String difficulty, String topic, String searchQuery) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM questions q WHERE 1=1 ");
        List<Object> params = new ArrayList<>();

        if (subjectId != null && subjectId > 0) {
            sql.append("AND q.subject_id = ? ");
            params.add(subjectId);
        }
        if (difficulty != null && !difficulty.trim().isEmpty() && !"ALL".equalsIgnoreCase(difficulty)) {
            sql.append("AND q.difficulty_level = ? ");
            params.add(difficulty.toUpperCase());
        }
        if (topic != null && !topic.trim().isEmpty() && !"ALL".equalsIgnoreCase(topic)) {
            sql.append("AND q.taxonomy_topic ILIKE ? ");
            params.add("%" + topic.trim() + "%");
        }
        if (searchQuery != null && !searchQuery.trim().isEmpty()) {
            sql.append("AND (q.question_text ILIKE ? OR q.taxonomy_topic ILIKE ? OR q.explanation ILIKE ?) ");
            String wild = "%" + searchQuery.trim() + "%";
            params.add(wild);
            params.add(wild);
            params.add(wild);
        }

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            logger.error("Error counting question bank items", e);
        }
        return 0;
    }

    @Override
    public boolean setQuizId(int questionId, Integer quizId) {
        String sql = "UPDATE questions SET quiz_id = ? WHERE question_id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            if (quizId != null && quizId > 0) {
                ps.setInt(1, quizId);
            } else {
                ps.setNull(1, Types.INTEGER);
            }
            ps.setInt(2, questionId);

            int affected = ps.executeUpdate();
            if (quizId != null && quizId > 0) {
                addQuestionToQuiz(questionId, quizId, 0, null);
            }
            return affected > 0;
        } catch (SQLException e) {
            logger.error("Error updating quiz_id for question: {}", questionId, e);
        }
        return false;
    }

    @Override
    public boolean addQuestionToQuiz(int questionId, int quizId, int sortOrder, java.math.BigDecimal pointsOverride) {
        String sql =
                "INSERT INTO quiz_questions (quiz_id, question_id, sort_order, points_override) " +
                "VALUES (?, ?, CASE WHEN ? > 0 THEN ? ELSE (SELECT COALESCE(MAX(sort_order), 0) + 1 FROM quiz_questions WHERE quiz_id = ?) END, ?) " +
                "ON CONFLICT (quiz_id, question_id) DO UPDATE SET " +
                "    sort_order = CASE WHEN EXCLUDED.sort_order > 0 THEN EXCLUDED.sort_order ELSE quiz_questions.sort_order END, " +
                "    points_override = COALESCE(EXCLUDED.points_override, quiz_questions.points_override)";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, quizId);
            ps.setInt(2, questionId);
            ps.setInt(3, sortOrder);
            ps.setInt(4, sortOrder);
            ps.setInt(5, quizId);
            if (pointsOverride != null) {
                ps.setBigDecimal(6, pointsOverride);
            } else {
                ps.setNull(6, Types.DECIMAL);
            }

            int affected = ps.executeUpdate();
            return affected > 0;
        } catch (SQLException e) {
            logger.error("Error adding question ID: {} to quiz ID: {}", questionId, quizId, e);
        }
        return false;
    }

    @Override
    public boolean removeQuestionFromQuiz(int questionId, int quizId) {
        String sql = "DELETE FROM quiz_questions WHERE quiz_id = ? AND question_id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, quizId);
            ps.setInt(2, questionId);

            int affected = ps.executeUpdate();
            return affected > 0;
        } catch (SQLException e) {
            logger.error("Error removing question ID: {} from quiz ID: {}", questionId, quizId, e);
        }
        return false;
    }

    @Override
    public boolean isQuestionInQuiz(int questionId, int quizId) {
        String sql = "SELECT 1 FROM quiz_questions WHERE quiz_id = ? AND question_id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, quizId);
            ps.setInt(2, questionId);

            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (SQLException e) {
            logger.error("Error checking if question ID: {} is in quiz ID: {}", questionId, quizId, e);
        }
        return false;
    }

    @Override
    public int countQuestionsInQuiz(int quizId) {
        String sql = "SELECT COUNT(*) FROM quiz_questions WHERE quiz_id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, quizId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            logger.error("Error counting questions in quiz ID: {}", quizId, e);
        }
        return 0;
    }

    @Override
    public int duplicateQuestion(int sourceQuestionId, Integer targetQuizId, int teacherId) {
        Optional<Question> srcOpt = findById(sourceQuestionId);
        if (srcOpt.isEmpty()) {
            return -1;
        }

        Question src = srcOpt.get();
        Question copy = new Question();
        copy.setQuizId(targetQuizId);
        copy.setSubjectId(src.getSubjectId());
        copy.setQuestionText(src.getQuestionText() + " (Copy)");
        copy.setQuestionType(src.getQuestionType());
        copy.setPoints(src.getPoints());
        copy.setDifficultyLevel(src.getDifficultyLevel());
        copy.setTaxonomyTopic(src.getTaxonomyTopic());
        copy.setExplanation(src.getExplanation());
        copy.setCodeSnippet(src.getCodeSnippet());
        copy.setCreatedBy(teacherId);

        for (QuestionOption opt : src.getOptions()) {
            copy.addOption(new QuestionOption(opt.getOptionLetter(), opt.getOptionText(), opt.isCorrect(), opt.getSortOrder()));
        }

        return create(copy);
    }

    @Override
    public boolean isOwnedBy(int questionId, int teacherId) {
        String sql = "SELECT 1 FROM questions WHERE question_id = ? AND created_by = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, questionId);
            ps.setInt(2, teacherId);

            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (SQLException e) {
            logger.error("Error checking question ownership", e);
        }
        return false;
    }

    private void insertOptions(Connection conn, int questionId, List<QuestionOption> options) throws SQLException {
        String optSql =
                "INSERT INTO question_options (question_id, option_letter, option_text, is_correct, sort_order) " +
                "VALUES (?, ?, ?, ?, ?)";

        try (PreparedStatement optPs = conn.prepareStatement(optSql)) {
            for (QuestionOption opt : options) {
                optPs.setInt(1, questionId);
                optPs.setString(2, opt.getOptionLetter());
                optPs.setString(3, opt.getOptionText());
                optPs.setBoolean(4, opt.isCorrect());
                optPs.setInt(5, opt.getSortOrder());
                optPs.addBatch();
            }
            optPs.executeBatch();
        }
    }

    private List<QuestionOption> findOptionsByQuestionId(Connection conn, int questionId) throws SQLException {
        List<QuestionOption> options = new ArrayList<>();
        String sql = "SELECT option_id, question_id, option_letter, option_text, is_correct, sort_order " +
                     "FROM question_options WHERE question_id = ? ORDER BY sort_order ASC, option_letter ASC";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
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
        }
        return options;
    }

    private Question mapResultSetToQuestion(ResultSet rs) throws SQLException {
        Question q = new Question();
        q.setQuestionId(rs.getInt("question_id"));
        int qId = rs.getInt("quiz_id");
        q.setQuizId(rs.wasNull() ? null : qId);
        q.setSubjectId(rs.getInt("subject_id"));
        q.setSubjectCode(rs.getString("subject_code"));
        q.setSubjectName(rs.getString("subject_name"));
        q.setQuestionText(rs.getString("question_text"));
        q.setQuestionType(rs.getString("question_type"));
        q.setPoints(rs.getBigDecimal("points"));
        q.setDifficultyLevel(rs.getString("difficulty_level"));
        q.setTaxonomyTopic(rs.getString("taxonomy_topic"));
        q.setExplanation(rs.getString("explanation"));
        q.setCodeSnippet(rs.getString("code_snippet"));
        int cBy = rs.getInt("created_by");
        q.setCreatedBy(rs.wasNull() ? null : cBy);
        q.setCreatedByName(rs.getString("created_by_name"));
        q.setCreatedAt(rs.getTimestamp("created_at"));
        return q;
    }
}
