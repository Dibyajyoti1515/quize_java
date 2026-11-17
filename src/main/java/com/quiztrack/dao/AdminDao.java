package com.quiztrack.dao;

import com.quiztrack.model.*;

import java.sql.Timestamp;
import java.util.List;
import java.util.Optional;

/**
 * Data Access Object interface for Administrator Management, System Configuration, and Audit Operations.
 */
public interface AdminDao {

    /**
     * Compiles aggregate statistics for the System Administrator Dashboard.
     */
    AdminDashboardStats getDashboardStatistics();

    /**
     * Retrieves paginated users matching optional search keyword, role, and status filters.
     */
    List<User> findUsers(String search, String role, String status, int limit, int offset);

    /**
     * Counts total users matching search, role, and status filters.
     */
    int countUsers(String search, String role, String status);

    /**
     * Retrieves a single user's detailed profile by user ID.
     */
    Optional<User> getUserById(int userId);

    /**
     * Creates a new user in the database and records an audit log entry.
     */
    boolean createUser(User user, int actingAdminId);

    /**
     * Updates editable user fields (full name, email, department, cohort).
     */
    boolean updateUserProfile(int userId, String fullName, String email, String department, String cohort, int actingAdminId);

    /**
     * Updates a user's account status ('ACTIVE', 'INACTIVE', 'SUSPENDED').
     */
    boolean updateUserStatus(int userId, String newStatus, int actingAdminId);

    /**
     * Updates a user's role and logs the transition.
     */
    boolean updateUserRole(int userId, int newRoleId, int actingAdminId);

    /**
     * Securely updates a user's BCrypt password hash.
     */
    boolean updateUserPassword(int userId, String passwordHash, int actingAdminId);

    /**
     * Returns the count of currently active administrators (used to prevent removing the last admin).
     */
    int countActiveAdmins();

    /**
     * Retrieves all available system roles.
     */
    List<Role> getAllRoles();

    /**
     * Finds a role by name ('ADMIN', 'TEACHER', 'STUDENT').
     */
    Optional<Role> findRoleByName(String roleName);

    /**
     * Finds a role by role ID.
     */
    Optional<Role> findRoleById(int roleId);

    /**
     * Retrieves all system configuration parameters.
     */
    List<SystemSetting> getAllSettings();

    /**
     * Retrieves a specific system setting by key.
     */
    Optional<SystemSetting> getSetting(String key);

    /**
     * Updates an individual configuration setting value.
     */
    boolean updateSetting(String key, String value, int actingAdminId);

    /**
     * Retrieves filtered and paginated system audit logs.
     */
    List<AuditLogEntryDto> getAuditLogs(String eventType, String userQuery, String severity, Timestamp startDate, Timestamp endDate, int limit, int offset);

    /**
     * Counts total audit logs matching the given filters.
     */
    int countAuditLogs(String eventType, String userQuery, String severity, Timestamp startDate, Timestamp endDate);

    /**
     * Inserts an administrative or security audit trail record into activity_logs.
     */
    void logAdminAudit(int actingAdminId, Integer targetUserId, String eventType, String severity, String details, String ipAddress);
}
