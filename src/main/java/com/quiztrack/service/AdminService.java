package com.quiztrack.service;

import com.quiztrack.model.*;

import java.sql.Timestamp;
import java.util.List;
import java.util.Map;

/**
 * Service interface for System Administration, User Roster Management,
 * Role Assignments, System Settings, and Audit Trail Oversight.
 */
public interface AdminService {

    /**
     * Compiles aggregate statistics for the System Administrator Dashboard.
     */
    AdminDashboardStats getDashboardStatistics();

    /**
     * Retrieves paginated users matching optional search keyword, role, and status filters.
     */
    List<User> listUsers(String search, String role, String status, int page, int pageSize);

    /**
     * Returns total count of users matching filter criteria.
     */
    int countUsers(String search, String role, String status);

    /**
     * Retrieves detailed profile for a specific user ID.
     */
    User getUserDetails(int userId);

    /**
     * Creates a new user account with BCrypt password hashing and audit logging.
     */
    boolean createUser(String fullName, String identifier, String email, String password,
                       String roleName, String department, String cohort, int actingAdminId);

    /**
     * Updates permitted user profile fields (full name, email, department, cohort).
     */
    boolean editUserProfile(int targetUserId, String fullName, String email,
                            String department, String cohort, int actingAdminId);

    /**
     * Activates or deactivates a user account with self-deactivation and last-admin protections.
     */
    boolean setUserStatus(int targetUserId, String newStatus, int actingAdminId);

    /**
     * Modifies a user's system role with self-role change and last-admin protections.
     */
    boolean changeUserRole(int targetUserId, String newRoleName, int actingAdminId);

    /**
     * Securely resets a user's password using BCrypt hashing.
     */
    boolean resetUserPassword(int targetUserId, String newPassword, int actingAdminId);

    /**
     * Retrieves all available system roles.
     */
    List<Role> getAllRoles();

    /**
     * Retrieves all current system configuration parameters.
     */
    List<SystemSetting> getSystemSettings();

    /**
     * Validates and updates system configuration settings in PostgreSQL.
     */
    boolean updateSystemSettings(Map<String, String> settings, int actingAdminId);

    /**
     * Retrieves filtered and paginated system audit trail entries with secret redaction.
     */
    List<AuditLogEntryDto> getAuditLogs(String eventType, String userQuery, String severity,
                                       Timestamp startDate, Timestamp endDate, int page, int pageSize);

    /**
     * Returns total count of audit logs matching criteria.
     */
    int countAuditLogs(String eventType, String userQuery, String severity,
                       Timestamp startDate, Timestamp endDate);
}
