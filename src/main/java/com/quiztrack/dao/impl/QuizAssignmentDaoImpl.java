package com.quiztrack.dao.impl;

import com.quiztrack.dao.QuizAssignmentDao;
import com.quiztrack.model.Cohort;
import com.quiztrack.model.QuizAssignment;
import com.quiztrack.model.User;
import com.quiztrack.util.DatabaseConnection;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

/**
 * JDBC implementation of QuizAssignmentDao using HikariCP and PreparedStatements.
 */
public class QuizAssignmentDaoImpl implements QuizAssignmentDao {

    private static final Logger logger = LoggerFactory.getLogger(QuizAssignmentDaoImpl.class);

    @Override
    public List<QuizAssignment> findByQuizId(int quizId) {
        List<QuizAssignment> list = new ArrayList<>();
        String sql =
                "SELECT qa.assignment_id, qa.quiz_id, qa.cohort_id, c.cohort_name, " +
                "       qa.student_id, u.full_name AS student_name, u.identifier AS student_identifier, " +
                "       qa.assigned_at, qa.due_at, " +
                "       (SELECT COUNT(*) FROM cohort_students cs WHERE cs.cohort_id = qa.cohort_id) AS enrolled_students_count " +
                "FROM quiz_assignments qa " +
                "LEFT JOIN cohorts c ON qa.cohort_id = c.cohort_id " +
                "LEFT JOIN users u ON qa.student_id = u.user_id " +
                "WHERE qa.quiz_id = ? " +
                "ORDER BY qa.cohort_id ASC NULLS LAST, qa.assigned_at ASC";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, quizId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    QuizAssignment qa = new QuizAssignment();
                    qa.setAssignmentId(rs.getInt("assignment_id"));
                    qa.setQuizId(rs.getInt("quiz_id"));
                    int cId = rs.getInt("cohort_id");
                    if (!rs.wasNull()) {
                        qa.setCohortId(cId);
                        qa.setCohortName(rs.getString("cohort_name"));
                    }
                    int sId = rs.getInt("student_id");
                    if (!rs.wasNull()) {
                        qa.setStudentId(sId);
                        qa.setStudentName(rs.getString("student_name"));
                        qa.setStudentIdentifier(rs.getString("student_identifier"));
                    }
                    qa.setAssignedAt(rs.getTimestamp("assigned_at"));
                    qa.setDueAt(rs.getTimestamp("due_at"));
                    qa.setEnrolledStudentsCount(rs.getInt("enrolled_students_count"));
                    list.add(qa);
                }
            }
        } catch (SQLException e) {
            logger.error("Error finding assignments for quiz ID: {}", quizId, e);
        }
        return list;
    }

    @Override
    public int countAssignmentsForQuiz(int quizId) {
        String sql = "SELECT COUNT(*) FROM quiz_assignments WHERE quiz_id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, quizId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            logger.error("Error counting assignments for quiz ID: {}", quizId, e);
        }
        return 0;
    }

    @Override
    public boolean assignQuizToCohort(int quizId, int cohortId, Timestamp dueAt) {
        if (isCohortAssigned(quizId, cohortId)) {
            logger.info("Cohort ID {} is already assigned to quiz ID {}", cohortId, quizId);
            return true;
        }

        String sql = "INSERT INTO quiz_assignments (quiz_id, cohort_id, student_id, due_at, assigned_at) VALUES (?, ?, NULL, ?, CURRENT_TIMESTAMP)";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, quizId);
            ps.setInt(2, cohortId);
            ps.setTimestamp(3, dueAt);
            int affected = ps.executeUpdate();
            return affected > 0;
        } catch (SQLException e) {
            logger.error("Error assigning quiz ID {} to cohort ID {}", quizId, cohortId, e);
        }
        return false;
    }

    @Override
    public boolean assignQuizToStudent(int quizId, int studentId, Timestamp dueAt) {
        if (isStudentAssigned(quizId, studentId)) {
            logger.info("Student ID {} is already assigned to quiz ID {}", studentId, quizId);
            return true;
        }

        String sql = "INSERT INTO quiz_assignments (quiz_id, cohort_id, student_id, due_at, assigned_at) VALUES (?, NULL, ?, ?, CURRENT_TIMESTAMP)";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, quizId);
            ps.setInt(2, studentId);
            ps.setTimestamp(3, dueAt);
            int affected = ps.executeUpdate();
            return affected > 0;
        } catch (SQLException e) {
            logger.error("Error assigning quiz ID {} to student ID {}", quizId, studentId, e);
        }
        return false;
    }

    @Override
    public boolean removeAssignment(int assignmentId, int quizId) {
        String sql = "DELETE FROM quiz_assignments WHERE assignment_id = ? AND quiz_id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, assignmentId);
            ps.setInt(2, quizId);
            int affected = ps.executeUpdate();
            return affected > 0;
        } catch (SQLException e) {
            logger.error("Error removing assignment ID {} for quiz ID {}", assignmentId, quizId, e);
        }
        return false;
    }

    @Override
    public boolean isCohortAssigned(int quizId, int cohortId) {
        String sql = "SELECT 1 FROM quiz_assignments WHERE quiz_id = ? AND cohort_id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, quizId);
            ps.setInt(2, cohortId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (SQLException e) {
            logger.error("Error checking cohort assignment for quiz ID {} cohort ID {}", quizId, cohortId, e);
        }
        return false;
    }

    @Override
    public boolean isStudentAssigned(int quizId, int studentId) {
        String sql = "SELECT 1 FROM quiz_assignments WHERE quiz_id = ? AND student_id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, quizId);
            ps.setInt(2, studentId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (SQLException e) {
            logger.error("Error checking student assignment for quiz ID {} student ID {}", quizId, studentId, e);
        }
        return false;
    }

    @Override
    public List<Cohort> findAvailableCohorts(String department) {
        List<Cohort> list = new ArrayList<>();
        String sql =
                "SELECT c.cohort_id, c.cohort_name, c.department, c.academic_year, c.created_at, " +
                "       (SELECT COUNT(*) FROM cohort_students cs WHERE cs.cohort_id = c.cohort_id) AS student_count " +
                "FROM cohorts c " +
                "WHERE (? IS NULL OR ? = '' OR c.department ILIKE ?) " +
                "ORDER BY c.cohort_name ASC";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, department);
            ps.setString(2, department);
            ps.setString(3, department);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Cohort c = new Cohort();
                    c.setCohortId(rs.getInt("cohort_id"));
                    c.setCohortName(rs.getString("cohort_name"));
                    c.setDepartment(rs.getString("department"));
                    c.setAcademicYear(rs.getString("academic_year"));
                    c.setCreatedAt(rs.getTimestamp("created_at"));
                    c.setStudentCount(rs.getInt("student_count"));
                    list.add(c);
                }
            }
        } catch (SQLException e) {
            logger.error("Error finding available cohorts for department: {}", department, e);
        }
        return list;
    }

    @Override
    public List<User> findAvailableStudents(String department) {
        List<User> list = new ArrayList<>();
        String sql =
                "SELECT u.user_id, u.identifier, u.email, u.full_name, u.role_id, u.department, u.cohort, u.status " +
                "FROM users u " +
                "WHERE u.role_id = 3 AND u.status = 'ACTIVE' " +
                "  AND (? IS NULL OR ? = '' OR u.department ILIKE ?) " +
                "ORDER BY u.full_name ASC";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, department);
            ps.setString(2, department);
            ps.setString(3, department);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    User u = new User();
                    u.setUserId(rs.getInt("user_id"));
                    u.setIdentifier(rs.getString("identifier"));
                    u.setEmail(rs.getString("email"));
                    u.setFullName(rs.getString("full_name"));
                    u.setRoleId(rs.getInt("role_id"));
                    u.setDepartment(rs.getString("department"));
                    u.setCohort(rs.getString("cohort"));
                    u.setStatus(rs.getString("status"));
                    list.add(u);
                }
            }
        } catch (SQLException e) {
            logger.error("Error finding available students for department: {}", department, e);
        }
        return list;
    }
}
