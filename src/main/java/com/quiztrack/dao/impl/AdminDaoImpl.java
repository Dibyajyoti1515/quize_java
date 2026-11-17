package com.quiztrack.dao.impl;

import com.quiztrack.dao.AdminDao;
import com.quiztrack.model.*;
import com.quiztrack.util.DatabaseConnection;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

/**
 * JDBC implementation of AdminDao using HikariCP connection pooling and PreparedStatements.
 */
public class AdminDaoImpl implements AdminDao {

    private static final Logger logger = LoggerFactory.getLogger(AdminDaoImpl.class);

    private static final String USER_SELECT_BASE =
            "SELECT u.user_id, u.identifier, u.email, u.password_hash, u.full_name, " +
            "       u.role_id, r.role_name, u.department, u.cohort, u.biometric_consent, " +
            "       u.status, u.created_at, u.updated_at " +
            "FROM users u " +
            "JOIN roles r ON u.role_id = r.role_id ";

    @Override
    public AdminDashboardStats getDashboardStatistics() {
        AdminDashboardStats stats = new AdminDashboardStats();

        String statsSql =
                "SELECT " +
                "  (SELECT COUNT(*) FROM users u JOIN roles r ON u.role_id = r.role_id WHERE r.role_name = 'STUDENT') AS student_count, " +
                "  (SELECT COUNT(*) FROM users u JOIN roles r ON u.role_id = r.role_id WHERE r.role_name = 'TEACHER') AS teacher_count, " +
                "  (SELECT COUNT(*) FROM users u JOIN roles r ON u.role_id = r.role_id WHERE r.role_name = 'ADMIN') AS admin_count, " +
                "  (SELECT COUNT(*) FROM users) AS total_users, " +
                "  (SELECT COUNT(*) FROM users WHERE status = 'ACTIVE') AS active_users, " +
                "  (SELECT COUNT(*) FROM users WHERE status = 'INACTIVE') AS inactive_users, " +
                "  (SELECT COUNT(*) FROM users WHERE status = 'SUSPENDED') AS suspended_users, " +
                "  (SELECT COUNT(*) FROM quizzes) AS total_quizzes, " +
                "  (SELECT COUNT(*) FROM quizzes WHERE status = 'ACTIVE') AS active_exams, " +
                "  (SELECT COUNT(*) FROM quiz_attempts WHERE status = 'SUBMITTED') AS completed_attempts, " +
                "  (SELECT COUNT(*) FROM questions) AS total_questions, " +
                "  (SELECT COALESCE(AVG(percentage), 0.0) FROM quiz_attempts WHERE status = 'SUBMITTED') AS avg_score, " +
                "  (SELECT COALESCE((COUNT(CASE WHEN passed = TRUE THEN 1 END) * 100.0 / NULLIF(COUNT(*), 0)), 0.0) FROM quiz_attempts WHERE status = 'SUBMITTED') AS pass_rate";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(statsSql);
             ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                stats.setTotalStudents(rs.getInt("student_count"));
                stats.setTotalTeachers(rs.getInt("teacher_count"));
                stats.setTotalAdmins(rs.getInt("admin_count"));
                stats.setTotalUsers(rs.getInt("total_users"));
                stats.setActiveUsers(rs.getInt("active_users"));
                stats.setInactiveUsers(rs.getInt("inactive_users"));
                stats.setSuspendedUsers(rs.getInt("suspended_users"));
                stats.setTotalQuizzes(rs.getInt("total_quizzes"));
                stats.setActiveExaminations(rs.getInt("active_exams"));
                stats.setCompletedAttempts(rs.getInt("completed_attempts"));
                stats.setTotalQuestions(rs.getInt("total_questions"));
                stats.setAverageScorePercentage(Math.round(rs.getDouble("avg_score") * 100.0) / 100.0);
                stats.setOverallPassRate(Math.round(rs.getDouble("pass_rate") * 100.0) / 100.0);
            }
        } catch (SQLException e) {
            logger.error("Error retrieving admin dashboard metrics", e);
        }

        // Fetch core system settings for dashboard badges
        String settingsSql = "SELECT setting_key, setting_value FROM system_settings WHERE setting_key IN ('app_name', 'maintenance_mode', 'registration_enabled')";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(settingsSql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                String k = rs.getString("setting_key");
                String v = rs.getString("setting_value");
                if ("app_name".equalsIgnoreCase(k)) stats.setApplicationName(v);
                else if ("maintenance_mode".equalsIgnoreCase(k)) stats.setMaintenanceMode("true".equalsIgnoreCase(v));
                else if ("registration_enabled".equalsIgnoreCase(k)) stats.setRegistrationEnabled("true".equalsIgnoreCase(v));
            }
        } catch (SQLException e) {
            logger.error("Error retrieving core system settings for dashboard", e);
        }

        // Fetch recent 12 audit activities
        stats.setRecentActivities(getAuditLogs(null, null, null, null, null, 12, 0));

        // Fetch user cohort breakdown / registration trends
        String trendSql = "SELECT COALESCE(cohort, 'Faculty & Staff') AS label, COUNT(*) AS count " +
                          "FROM users GROUP BY cohort ORDER BY count DESC LIMIT 5";
        List<AdminDashboardStats.UserTrendDto> trends = new ArrayList<>();
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(trendSql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                trends.add(new AdminDashboardStats.UserTrendDto(rs.getString("label"), rs.getInt("count")));
            }
        } catch (SQLException e) {
            logger.error("Error retrieving user registration trends", e);
        }
        stats.setRegistrationTrends(trends);

        return stats;
    }

    @Override
    public List<User> findUsers(String search, String role, String status, int limit, int offset) {
        StringBuilder sql = new StringBuilder(USER_SELECT_BASE).append("WHERE 1=1 ");
        List<Object> params = new ArrayList<>();

        buildUserFilterClauses(sql, params, search, role, status);

        sql.append("ORDER BY u.user_id ASC LIMIT ? OFFSET ?");
        params.add(limit > 0 ? limit : 50);
        params.add(Math.max(offset, 0));

        List<User> list = new ArrayList<>();
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapResultSetToUser(rs));
                }
            }
        } catch (SQLException e) {
            logger.error("Error finding users with filters [search={}, role={}, status={}]", search, role, status, e);
        }
        return list;
    }

    @Override
    public int countUsers(String search, String role, String status) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM users u JOIN roles r ON u.role_id = r.role_id WHERE 1=1 ");
        List<Object> params = new ArrayList<>();

        buildUserFilterClauses(sql, params, search, role, status);

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
            logger.error("Error counting users with filters", e);
        }
        return 0;
    }

    private void buildUserFilterClauses(StringBuilder sql, List<Object> params, String search, String role, String status) {
        if (search != null && !search.trim().isEmpty()) {
            String s = "%" + search.trim().toLowerCase() + "%";
            sql.append("AND (LOWER(u.full_name) LIKE ? OR LOWER(u.email) LIKE ? OR LOWER(u.identifier) LIKE ? OR LOWER(u.department) LIKE ?) ");
            params.add(s);
            params.add(s);
            params.add(s);
            params.add(s);
        }

        if (role != null && !role.trim().isEmpty() && !"ALL".equalsIgnoreCase(role.trim())) {
            sql.append("AND UPPER(r.role_name) = UPPER(?) ");
            params.add(role.trim());
        }

        if (status != null && !status.trim().isEmpty() && !"ALL".equalsIgnoreCase(status.trim())) {
            sql.append("AND UPPER(u.status) = UPPER(?) ");
            params.add(status.trim());
        }
    }

    @Override
    public Optional<User> getUserById(int userId) {
        String sql = USER_SELECT_BASE + "WHERE u.user_id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return Optional.of(mapResultSetToUser(rs));
                }
            }
        } catch (SQLException e) {
            logger.error("Error retrieving user by ID: {}", userId, e);
        }
        return Optional.empty();
    }

    @Override
    public boolean createUser(User user, int actingAdminId) {
        String sql = "INSERT INTO users (identifier, email, password_hash, full_name, role_id, department, cohort, status) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setString(1, user.getIdentifier().trim());
            ps.setString(2, user.getEmail().trim().toLowerCase());
            ps.setString(3, user.getPasswordHash());
            ps.setString(4, user.getFullName().trim());
            ps.setInt(5, user.getRoleId());
            ps.setString(6, user.getDepartment());
            ps.setString(7, user.getCohort());
            ps.setString(8, user.getStatus() != null ? user.getStatus() : "ACTIVE");

            int affected = ps.executeUpdate();
            if (affected > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        user.setUserId(rs.getInt(1));
                    }
                }

                logAdminAudit(actingAdminId, user.getUserId(), "USER_CREATED", "INFO",
                        "Created new " + user.getRoleName() + " account: " + user.getFullName() + " (" + user.getIdentifier() + ")", null);
                return true;
            }
        } catch (SQLException e) {
            logger.error("Error creating user: {}", user.getIdentifier(), e);
        }
        return false;
    }

    @Override
    public boolean updateUserProfile(int userId, String fullName, String email, String department, String cohort, int actingAdminId) {
        String sql = "UPDATE users SET full_name = ?, email = ?, department = ?, cohort = ?, updated_at = CURRENT_TIMESTAMP WHERE user_id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, fullName.trim());
            ps.setString(2, email.trim().toLowerCase());
            ps.setString(3, department != null ? department.trim() : null);
            ps.setString(4, cohort != null ? cohort.trim() : null);
            ps.setInt(5, userId);

            boolean updated = ps.executeUpdate() > 0;
            if (updated) {
                logAdminAudit(actingAdminId, userId, "USER_UPDATED", "INFO",
                        "Updated profile information for user ID " + userId + " (Name: " + fullName + ", Email: " + email + ")", null);
            }
            return updated;
        } catch (SQLException e) {
            logger.error("Error updating user profile for ID: {}", userId, e);
        }
        return false;
    }

    @Override
    public boolean updateUserStatus(int userId, String newStatus, int actingAdminId) {
        String sql = "UPDATE users SET status = ?, updated_at = CURRENT_TIMESTAMP WHERE user_id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, newStatus.toUpperCase().trim());
            ps.setInt(2, userId);

            boolean updated = ps.executeUpdate() > 0;
            if (updated) {
                String severity = "SUSPENDED".equalsIgnoreCase(newStatus) ? "CAUTION" : "INFO";
                logAdminAudit(actingAdminId, userId, "ACCOUNT_STATUS_CHANGED", severity,
                        "Changed account status of user ID " + userId + " to " + newStatus.toUpperCase().trim(), null);
            }
            return updated;
        } catch (SQLException e) {
            logger.error("Error updating user status for ID: {}", userId, e);
        }
        return false;
    }

    @Override
    public boolean updateUserRole(int userId, int newRoleId, int actingAdminId) {
        Optional<Role> roleOpt = findRoleById(newRoleId);
        String newRoleName = roleOpt.map(Role::getRoleName).orElse("UNKNOWN");

        String sql = "UPDATE users SET role_id = ?, updated_at = CURRENT_TIMESTAMP WHERE user_id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, newRoleId);
            ps.setInt(2, userId);

            boolean updated = ps.executeUpdate() > 0;
            if (updated) {
                logAdminAudit(actingAdminId, userId, "ROLE_CHANGED", "CAUTION",
                        "Elevated/modified user ID " + userId + " role to " + newRoleName, null);
            }
            return updated;
        } catch (SQLException e) {
            logger.error("Error updating role for user ID: {}", userId, e);
        }
        return false;
    }

    @Override
    public boolean updateUserPassword(int userId, String passwordHash, int actingAdminId) {
        String sql = "UPDATE users SET password_hash = ?, updated_at = CURRENT_TIMESTAMP WHERE user_id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, passwordHash);
            ps.setInt(2, userId);

            boolean updated = ps.executeUpdate() > 0;
            if (updated) {
                logAdminAudit(actingAdminId, userId, "PASSWORD_RESET", "CAUTION",
                        "Administrative password reset performed for user ID " + userId, null);
            }
            return updated;
        } catch (SQLException e) {
            logger.error("Error resetting password for user ID: {}", userId, e);
        }
        return false;
    }

    @Override
    public int countActiveAdmins() {
        String sql = "SELECT COUNT(*) FROM users u JOIN roles r ON u.role_id = r.role_id " +
                     "WHERE r.role_name = 'ADMIN' AND u.status = 'ACTIVE'";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            logger.error("Error counting active administrators", e);
        }
        return 0;
    }

    @Override
    public List<Role> getAllRoles() {
        List<Role> list = new ArrayList<>();
        String sql = "SELECT role_id, role_name, description FROM roles ORDER BY role_id ASC";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(new Role(rs.getInt("role_id"), rs.getString("role_name"), rs.getString("description")));
            }
        } catch (SQLException e) {
            logger.error("Error querying roles", e);
        }
        return list;
    }

    @Override
    public Optional<Role> findRoleByName(String roleName) {
        if (roleName == null) return Optional.empty();
        String sql = "SELECT role_id, role_name, description FROM roles WHERE UPPER(role_name) = UPPER(?)";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, roleName.trim());
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return Optional.of(new Role(rs.getInt("role_id"), rs.getString("role_name"), rs.getString("description")));
                }
            }
        } catch (SQLException e) {
            logger.error("Error finding role by name: {}", roleName, e);
        }
        return Optional.empty();
    }

    @Override
    public Optional<Role> findRoleById(int roleId) {
        String sql = "SELECT role_id, role_name, description FROM roles WHERE role_id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, roleId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return Optional.of(new Role(rs.getInt("role_id"), rs.getString("role_name"), rs.getString("description")));
                }
            }
        } catch (SQLException e) {
            logger.error("Error finding role by id: {}", roleId, e);
        }
        return Optional.empty();
    }

    @Override
    public List<SystemSetting> getAllSettings() {
        List<SystemSetting> list = new ArrayList<>();
        String sql = "SELECT s.setting_key, s.setting_value, s.setting_group, s.data_type, s.description, " +
                     "       s.updated_at, s.updated_by, u.full_name AS updated_by_name " +
                     "FROM system_settings s " +
                     "LEFT JOIN users u ON s.updated_by = u.user_id " +
                     "ORDER BY s.setting_group ASC, s.setting_key ASC";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                SystemSetting s = new SystemSetting();
                s.setSettingKey(rs.getString("setting_key"));
                s.setSettingValue(rs.getString("setting_value"));
                s.setSettingGroup(rs.getString("setting_group"));
                s.setDataType(rs.getString("data_type"));
                s.setDescription(rs.getString("description"));
                s.setUpdatedAt(rs.getTimestamp("updated_at"));
                s.setUpdatedBy((Integer) rs.getObject("updated_by"));
                s.setUpdatedByName(rs.getString("updated_by_name"));
                list.add(s);
            }
        } catch (SQLException e) {
            logger.error("Error querying system settings", e);
        }
        return list;
    }

    @Override
    public Optional<SystemSetting> getSetting(String key) {
        if (key == null) return Optional.empty();
        String sql = "SELECT s.setting_key, s.setting_value, s.setting_group, s.data_type, s.description, " +
                     "       s.updated_at, s.updated_by, u.full_name AS updated_by_name " +
                     "FROM system_settings s " +
                     "LEFT JOIN users u ON s.updated_by = u.user_id " +
                     "WHERE s.setting_key = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, key.trim());
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    SystemSetting s = new SystemSetting();
                    s.setSettingKey(rs.getString("setting_key"));
                    s.setSettingValue(rs.getString("setting_value"));
                    s.setSettingGroup(rs.getString("setting_group"));
                    s.setDataType(rs.getString("data_type"));
                    s.setDescription(rs.getString("description"));
                    s.setUpdatedAt(rs.getTimestamp("updated_at"));
                    s.setUpdatedBy((Integer) rs.getObject("updated_by"));
                    s.setUpdatedByName(rs.getString("updated_by_name"));
                    return Optional.of(s);
                }
            }
        } catch (SQLException e) {
            logger.error("Error retrieving setting: {}", key, e);
        }
        return Optional.empty();
    }

    @Override
    public boolean updateSetting(String key, String value, int actingAdminId) {
        String sql = "UPDATE system_settings SET setting_value = ?, updated_at = CURRENT_TIMESTAMP, updated_by = ? WHERE setting_key = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, value != null ? value.trim() : "");
            ps.setInt(2, actingAdminId);
            ps.setString(3, key.trim());

            boolean updated = ps.executeUpdate() > 0;
            if (updated) {
                logAdminAudit(actingAdminId, null, "SETTING_CHANGED", "INFO",
                        "System parameter '" + key + "' updated to '" + value + "'", null);
            }
            return updated;
        } catch (SQLException e) {
            logger.error("Error updating system setting: {}", key, e);
        }
        return false;
    }

    @Override
    public List<AuditLogEntryDto> getAuditLogs(String eventType, String userQuery, String severity, Timestamp startDate, Timestamp endDate, int limit, int offset) {
        StringBuilder sql = new StringBuilder(
                "SELECT al.log_id, al.attempt_id, al.user_id, al.target_user_id, al.event_type, al.severity, al.details, " +
                "       al.event_timestamp, al.ip_address, " +
                "       u.full_name AS user_name, u.identifier AS user_identifier, r.role_name AS user_role, " +
                "       u_tgt.full_name AS target_user_name, u_tgt.identifier AS target_user_identifier " +
                "FROM activity_logs al " +
                "JOIN users u ON al.user_id = u.user_id " +
                "JOIN roles r ON u.role_id = r.role_id " +
                "LEFT JOIN users u_tgt ON al.target_user_id = u_tgt.user_id " +
                "WHERE 1=1 ");

        List<Object> params = new ArrayList<>();
        buildAuditFilterClauses(sql, params, eventType, userQuery, severity, startDate, endDate);

        sql.append("ORDER BY al.event_timestamp DESC LIMIT ? OFFSET ?");
        params.add(limit > 0 ? limit : 50);
        params.add(Math.max(offset, 0));

        List<AuditLogEntryDto> list = new ArrayList<>();
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    AuditLogEntryDto dto = new AuditLogEntryDto();
                    dto.setLogId(rs.getInt("log_id"));
                    dto.setAttemptId((Integer) rs.getObject("attempt_id"));
                    dto.setUserId(rs.getInt("user_id"));
                    dto.setUserName(rs.getString("user_name"));
                    dto.setUserIdentifier(rs.getString("user_identifier"));
                    dto.setUserRole(rs.getString("user_role"));
                    dto.setTargetUserId((Integer) rs.getObject("target_user_id"));
                    dto.setTargetUserName(rs.getString("target_user_name"));
                    dto.setTargetUserIdentifier(rs.getString("target_user_identifier"));
                    dto.setEventType(rs.getString("event_type"));
                    dto.setSeverity(rs.getString("severity"));
                    dto.setDetails(rs.getString("details"));
                    dto.setEventTimestamp(rs.getTimestamp("event_timestamp"));
                    dto.setIpAddress(rs.getString("ip_address"));
                    list.add(dto);
                }
            }
        } catch (SQLException e) {
            logger.error("Error retrieving audit logs with filters", e);
        }
        return list;
    }

    @Override
    public int countAuditLogs(String eventType, String userQuery, String severity, Timestamp startDate, Timestamp endDate) {
        StringBuilder sql = new StringBuilder(
                "SELECT COUNT(*) " +
                "FROM activity_logs al " +
                "JOIN users u ON al.user_id = u.user_id " +
                "LEFT JOIN users u_tgt ON al.target_user_id = u_tgt.user_id " +
                "WHERE 1=1 ");

        List<Object> params = new ArrayList<>();
        buildAuditFilterClauses(sql, params, eventType, userQuery, severity, startDate, endDate);

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
            logger.error("Error counting audit logs with filters", e);
        }
        return 0;
    }

    private void buildAuditFilterClauses(StringBuilder sql, List<Object> params, String eventType, String userQuery, String severity, Timestamp startDate, Timestamp endDate) {
        if (eventType != null && !eventType.trim().isEmpty() && !"ALL".equalsIgnoreCase(eventType.trim())) {
            sql.append("AND UPPER(al.event_type) = UPPER(?) ");
            params.add(eventType.trim());
        }

        if (severity != null && !severity.trim().isEmpty() && !"ALL".equalsIgnoreCase(severity.trim())) {
            sql.append("AND UPPER(al.severity) = UPPER(?) ");
            params.add(severity.trim());
        }

        if (userQuery != null && !userQuery.trim().isEmpty()) {
            String u = "%" + userQuery.trim().toLowerCase() + "%";
            sql.append("AND (LOWER(u.full_name) LIKE ? OR LOWER(u.identifier) LIKE ? OR LOWER(u_tgt.full_name) LIKE ? OR LOWER(u_tgt.identifier) LIKE ?) ");
            params.add(u);
            params.add(u);
            params.add(u);
            params.add(u);
        }

        if (startDate != null) {
            sql.append("AND al.event_timestamp >= ? ");
            params.add(startDate);
        }

        if (endDate != null) {
            sql.append("AND al.event_timestamp <= ? ");
            params.add(endDate);
        }
    }

    @Override
    public void logAdminAudit(int actingAdminId, Integer targetUserId, String eventType, String severity, String details, String ipAddress) {
        String sql = "INSERT INTO activity_logs (user_id, target_user_id, event_type, severity, details, ip_address, event_timestamp) " +
                     "VALUES (?, ?, ?, ?, ?, ?, CURRENT_TIMESTAMP)";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, actingAdminId);
            if (targetUserId != null) {
                ps.setInt(2, targetUserId);
            } else {
                ps.setNull(2, Types.INTEGER);
            }
            ps.setString(3, eventType != null ? eventType : "ADMIN_ACTION");
            ps.setString(4, severity != null ? severity : "INFO");
            ps.setString(5, details);
            ps.setString(6, ipAddress);

            ps.executeUpdate();
        } catch (SQLException e) {
            logger.error("Error inserting admin audit log", e);
        }
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
