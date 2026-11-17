package com.quiztrack.dao.impl;

import com.quiztrack.dao.UserDao;
import com.quiztrack.model.User;
import com.quiztrack.util.DatabaseConnection;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

/**
 * JDBC Implementation of UserDao with PreparedStatements and HikariCP connection pool.
 */
public class UserDaoImpl implements UserDao {

    private static final Logger logger = LoggerFactory.getLogger(UserDaoImpl.class);

    private static final String SELECT_BASE =
            "SELECT u.user_id, u.identifier, u.email, u.password_hash, u.full_name, " +
            "       u.role_id, r.role_name, u.department, u.cohort, u.biometric_consent, " +
            "       u.status, u.created_at, u.updated_at " +
            "FROM users u " +
            "JOIN roles r ON u.role_id = r.role_id ";

    @Override
    public Optional<User> findByIdentifierOrEmail(String identifierOrEmail) {
        if (identifierOrEmail == null || identifierOrEmail.trim().isEmpty()) {
            return Optional.empty();
        }

        String sql = SELECT_BASE + "WHERE LOWER(u.identifier) = LOWER(?) OR LOWER(u.email) = LOWER(?)";
        String searchKey = identifierOrEmail.trim();

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, searchKey);
            ps.setString(2, searchKey);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return Optional.of(mapResultSetToUser(rs));
                }
            }
        } catch (SQLException e) {
            logger.error("Error finding user by identifier/email: {}", identifierOrEmail, e);
        }
        return Optional.empty();
    }

    @Override
    public Optional<User> findById(int userId) {
        String sql = SELECT_BASE + "WHERE u.user_id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return Optional.of(mapResultSetToUser(rs));
                }
            }
        } catch (SQLException e) {
            logger.error("Error finding user by id: {}", userId, e);
        }
        return Optional.empty();
    }

    @Override
    public boolean create(User user) {
        String sql = "INSERT INTO users (identifier, email, password_hash, full_name, role_id, department, cohort, biometric_consent, status) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setString(1, user.getIdentifier().trim());
            ps.setString(2, user.getEmail().trim().toLowerCase());
            ps.setString(3, user.getPasswordHash());
            ps.setString(4, user.getFullName().trim());
            ps.setInt(5, user.getRoleId());
            ps.setString(6, user.getDepartment());
            ps.setString(7, user.getCohort());
            ps.setBoolean(8, user.isBiometricConsent());
            ps.setString(9, user.getStatus() != null ? user.getStatus() : "ACTIVE");

            int affectedRows = ps.executeUpdate();
            if (affectedRows > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        user.setUserId(rs.getInt(1));
                    }
                }
                return true;
            }
        } catch (SQLException e) {
            logger.error("Error creating user: {}", user.getIdentifier(), e);
        }
        return false;
    }

    @Override
    public boolean existsByIdentifier(String identifier) {
        String sql = "SELECT 1 FROM users WHERE LOWER(identifier) = LOWER(?)";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, identifier.trim());
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (SQLException e) {
            logger.error("Error checking existence of identifier: {}", identifier, e);
        }
        return false;
    }

    @Override
    public boolean existsByEmail(String email) {
        String sql = "SELECT 1 FROM users WHERE LOWER(email) = LOWER(?)";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email.trim());
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (SQLException e) {
            logger.error("Error checking existence of email: {}", email, e);
        }
        return false;
    }

    @Override
    public boolean updatePassword(int userId, String passwordHash) {
        String sql = "UPDATE users SET password_hash = ?, updated_at = CURRENT_TIMESTAMP WHERE user_id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, passwordHash);
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            logger.error("Error updating password for userId: {}", userId, e);
        }
        return false;
    }

    @Override
    public boolean updateStatus(int userId, String status) {
        String sql = "UPDATE users SET status = ?, updated_at = CURRENT_TIMESTAMP WHERE user_id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            logger.error("Error updating status for userId: {}", userId, e);
        }
        return false;
    }

    @Override
    public void logActivity(int userId, String eventType, String severity, String details) {
        String sql = "INSERT INTO activity_logs (user_id, event_type, severity, details) VALUES (?, ?, ?, ?)";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setString(2, eventType);
            ps.setString(3, severity);
            ps.setString(4, details);
            ps.executeUpdate();
        } catch (SQLException e) {
            logger.error("Error logging activity for userId: {}", userId, e);
        }
    }

    @Override
    public List<User> findByRole(String roleName) {
        List<User> list = new ArrayList<>();
        String sql = SELECT_BASE + "WHERE UPPER(r.role_name) = UPPER(?) ORDER BY u.full_name ASC";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, roleName.trim());
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapResultSetToUser(rs));
                }
            }
        } catch (SQLException e) {
            logger.error("Error querying users by role: {}", roleName, e);
        }
        return list;
    }

    @Override
    public int countRecentFailedLogins(int userId, int minutes) {
        String sql = "SELECT COUNT(*) FROM activity_logs WHERE user_id = ? AND event_type = 'LOGIN_FAILED' " +
                     "AND event_timestamp >= (CURRENT_TIMESTAMP - (? || ' minutes')::INTERVAL)";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, minutes > 0 ? minutes : 15);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            logger.error("Error counting failed logins for user {}", userId, e);
        }
        return 0;
    }

    private User mapResultSetToUser(ResultSet rs) throws SQLException {
        User u = new User();
        u.setUserId(rs.getInt("user_id"));
        u.setIdentifier(rs.getString("identifier"));
        u.setEmail(rs.getString("email"));
        u.setPasswordHash(rs.getString("password_hash"));
        u.setFullName(rs.getString("full_name"));
        u.setRoleId(rs.getInt("role_id"));
        u.setRoleName(rs.getString("role_name"));
        u.setDepartment(rs.getString("department"));
        u.setCohort(rs.getString("cohort"));
        u.setBiometricConsent(rs.getBoolean("biometric_consent"));
        u.setStatus(rs.getString("status"));
        u.setCreatedAt(rs.getTimestamp("created_at"));
        u.setUpdatedAt(rs.getTimestamp("updated_at"));
        return u;
    }
}
