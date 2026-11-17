package com.quiztrack.service.impl;

import com.quiztrack.dao.AdminDao;
import com.quiztrack.dao.UserDao;
import com.quiztrack.dao.impl.AdminDaoImpl;
import com.quiztrack.dao.impl.UserDaoImpl;
import com.quiztrack.model.*;
import com.quiztrack.service.AdminService;
import org.mindrot.jbcrypt.BCrypt;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.sql.Timestamp;
import java.util.List;
import java.util.Map;
import java.util.Optional;

/**
 * Service implementation for System Administration, User Roster Management,
 * Security Protections, System Configuration, and Audit Logs.
 */
public class AdminServiceImpl implements AdminService {

    private static final Logger logger = LoggerFactory.getLogger(AdminServiceImpl.class);

    private final AdminDao adminDao;
    private final UserDao userDao;

    public AdminServiceImpl() {
        this.adminDao = new AdminDaoImpl();
        this.userDao = new UserDaoImpl();
    }

    public AdminServiceImpl(AdminDao adminDao, UserDao userDao) {
        this.adminDao = adminDao;
        this.userDao = userDao;
    }

    @Override
    public AdminDashboardStats getDashboardStatistics() {
        return adminDao.getDashboardStatistics();
    }

    @Override
    public List<User> listUsers(String search, String role, String status, int page, int pageSize) {
        int limit = pageSize > 0 ? pageSize : 20;
        int offset = Math.max(page - 1, 0) * limit;
        return adminDao.findUsers(search, role, status, limit, offset);
    }

    @Override
    public int countUsers(String search, String role, String status) {
        return adminDao.countUsers(search, role, status);
    }

    @Override
    public User getUserDetails(int userId) {
        return adminDao.getUserById(userId)
                .orElseThrow(() -> new IllegalArgumentException("User not found with ID: " + userId));
    }

    @Override
    public boolean createUser(String fullName, String identifier, String email, String password,
                              String roleName, String department, String cohort, int actingAdminId) {

        if (fullName == null || fullName.trim().isEmpty()) {
            throw new IllegalArgumentException("Full name is required.");
        }
        if (identifier == null || identifier.trim().isEmpty()) {
            throw new IllegalArgumentException("User roll number or institutional ID is required.");
        }
        if (email == null || !email.matches("^[A-Za-z0-9+_.-]+@(.+)$")) {
            throw new IllegalArgumentException("A valid institutional email address is required.");
        }
        if (password == null || password.length() < 6) {
            throw new IllegalArgumentException("Password must contain at least 6 characters.");
        }

        String cleanIdentifier = identifier.trim();
        String cleanEmail = email.trim().toLowerCase();

        if (userDao.existsByIdentifier(cleanIdentifier)) {
            throw new IllegalArgumentException("User ID / Roll Number '" + cleanIdentifier + "' is already registered.");
        }
        if (userDao.existsByEmail(cleanEmail)) {
            throw new IllegalArgumentException("Email address '" + cleanEmail + "' is already registered.");
        }

        Optional<Role> roleOpt = adminDao.findRoleByName(roleName);
        if (roleOpt.isEmpty()) {
            throw new IllegalArgumentException("Invalid user role: " + roleName);
        }
        Role role = roleOpt.get();

        String passwordHash = BCrypt.hashpw(password, BCrypt.gensalt(12));

        User user = new User();
        user.setFullName(fullName.trim());
        user.setIdentifier(cleanIdentifier);
        user.setEmail(cleanEmail);
        user.setPasswordHash(passwordHash);
        user.setRoleId(role.getRoleId());
        user.setRoleName(role.getRoleName());
        user.setDepartment(department != null ? department.trim() : null);
        user.setCohort(cohort != null ? cohort.trim() : null);
        user.setStatus("ACTIVE");

        boolean created = adminDao.createUser(user, actingAdminId);
        if (created) {
            logger.info("Admin ID {} created new user account: {} ({}) with role {}",
                    actingAdminId, user.getFullName(), user.getIdentifier(), role.getRoleName());
        }
        return created;
    }

    @Override
    public boolean editUserProfile(int targetUserId, String fullName, String email,
                                   String department, String cohort, int actingAdminId) {

        if (fullName == null || fullName.trim().isEmpty()) {
            throw new IllegalArgumentException("Full name is required.");
        }
        if (email == null || !email.matches("^[A-Za-z0-9+_.-]+@(.+)$")) {
            throw new IllegalArgumentException("Valid institutional email address is required.");
        }

        User existing = getUserDetails(targetUserId);
        String cleanEmail = email.trim().toLowerCase();

        if (!cleanEmail.equalsIgnoreCase(existing.getEmail())) {
            if (userDao.existsByEmail(cleanEmail)) {
                throw new IllegalArgumentException("Email address '" + cleanEmail + "' is already in use by another user.");
            }
        }

        return adminDao.updateUserProfile(targetUserId, fullName.trim(), cleanEmail,
                department != null ? department.trim() : null,
                cohort != null ? cohort.trim() : null,
                actingAdminId);
    }

    @Override
    public boolean setUserStatus(int targetUserId, String newStatus, int actingAdminId) {
        if (newStatus == null || (!"ACTIVE".equalsIgnoreCase(newStatus) && !"INACTIVE".equalsIgnoreCase(newStatus) && !"SUSPENDED".equalsIgnoreCase(newStatus))) {
            throw new IllegalArgumentException("Invalid status value: " + newStatus);
        }

        String targetStatus = newStatus.toUpperCase().trim();

        // 1. Self-deactivation prevention
        if (targetUserId == actingAdminId && !"ACTIVE".equalsIgnoreCase(targetStatus)) {
            logger.warn("Admin {} attempted self-deactivation", actingAdminId);
            throw new SecurityException("Administrators are prevented from deactivating their own administrative account.");
        }

        // 2. Last-admin protection
        User target = getUserDetails(targetUserId);
        if (target.isAdmin() && !"ACTIVE".equalsIgnoreCase(targetStatus)) {
            int activeAdmins = adminDao.countActiveAdmins();
            if (activeAdmins <= 1) {
                logger.warn("Attempt to deactivate the last remaining active administrator (User ID {}) by Admin {}",
                        targetUserId, actingAdminId);
                throw new SecurityException("Operation prohibited: Cannot deactivate the last remaining active Administrator in the system.");
            }
        }

        return adminDao.updateUserStatus(targetUserId, targetStatus, actingAdminId);
    }

    @Override
    public boolean changeUserRole(int targetUserId, String newRoleName, int actingAdminId) {
        if (newRoleName == null || newRoleName.trim().isEmpty()) {
            throw new IllegalArgumentException("Role name cannot be empty.");
        }

        Optional<Role> roleOpt = adminDao.findRoleByName(newRoleName);
        if (roleOpt.isEmpty()) {
            throw new IllegalArgumentException("Invalid role specified: " + newRoleName);
        }
        Role targetRole = roleOpt.get();

        // 1. Self-role-change prevention
        if (targetUserId == actingAdminId) {
            logger.warn("Admin {} attempted to alter their own administrative role", actingAdminId);
            throw new SecurityException("Administrators cannot modify their own administrative role.");
        }

        // 2. Last-admin protection
        User target = getUserDetails(targetUserId);
        if (target.isAdmin() && !"ADMIN".equalsIgnoreCase(targetRole.getRoleName())) {
            int activeAdmins = adminDao.countActiveAdmins();
            if (activeAdmins <= 1) {
                logger.warn("Attempt to demote the last remaining active administrator (User ID {}) by Admin {}",
                        targetUserId, actingAdminId);
                throw new SecurityException("Operation prohibited: Cannot remove or demote the last remaining active Administrator in the system.");
            }
        }

        return adminDao.updateUserRole(targetUserId, targetRole.getRoleId(), actingAdminId);
    }

    @Override
    public boolean resetUserPassword(int targetUserId, String newPassword, int actingAdminId) {
        if (newPassword == null || newPassword.length() < 6) {
            throw new IllegalArgumentException("New password must be at least 6 characters long.");
        }

        // Verify target exists
        getUserDetails(targetUserId);

        String passwordHash = BCrypt.hashpw(newPassword, BCrypt.gensalt(12));
        return adminDao.updateUserPassword(targetUserId, passwordHash, actingAdminId);
    }

    @Override
    public List<Role> getAllRoles() {
        return adminDao.getAllRoles();
    }

    @Override
    public List<SystemSetting> getSystemSettings() {
        return adminDao.getAllSettings();
    }

    @Override
    public boolean updateSystemSettings(Map<String, String> settings, int actingAdminId) {
        if (settings == null || settings.isEmpty()) {
            return false;
        }

        // Validate each setting against server rules
        for (Map.Entry<String, String> entry : settings.entrySet()) {
            String key = entry.getKey();
            String val = entry.getValue() != null ? entry.getValue().trim() : "";

            switch (key) {
                case "app_name":
                    if (val.isEmpty()) throw new IllegalArgumentException("Application name cannot be empty.");
                    break;
                case "default_quiz_duration":
                    try {
                        int dur = Integer.parseInt(val);
                        if (dur < 5 || dur > 300) {
                            throw new IllegalArgumentException("Default quiz duration must be between 5 and 300 minutes.");
                        }
                    } catch (NumberFormatException e) {
                        throw new IllegalArgumentException("Default quiz duration must be a valid integer.");
                    }
                    break;
                case "max_quiz_duration":
                    try {
                        int maxDur = Integer.parseInt(val);
                        if (maxDur < 10 || maxDur > 600) {
                            throw new IllegalArgumentException("Maximum quiz duration must be between 10 and 600 minutes.");
                        }
                    } catch (NumberFormatException e) {
                        throw new IllegalArgumentException("Maximum quiz duration must be a valid integer.");
                    }
                    break;
                case "default_passing_percentage":
                    try {
                        double pass = Double.parseDouble(val);
                        if (pass < 0.0 || pass > 100.0) {
                            throw new IllegalArgumentException("Passing percentage must be between 0.0% and 100.0%.");
                        }
                    } catch (NumberFormatException e) {
                        throw new IllegalArgumentException("Default passing percentage must be a valid number.");
                    }
                    break;
                case "max_login_attempts":
                    try {
                        int attempts = Integer.parseInt(val);
                        if (attempts < 1 || attempts > 20) {
                            throw new IllegalArgumentException("Maximum login attempts must be between 1 and 20.");
                        }
                    } catch (NumberFormatException e) {
                        throw new IllegalArgumentException("Maximum login attempts must be an integer.");
                    }
                    break;
                case "session_timeout":
                    try {
                        int timeout = Integer.parseInt(val);
                        if (timeout < 5 || timeout > 480) {
                            throw new IllegalArgumentException("Session timeout must be between 5 and 480 minutes.");
                        }
                    } catch (NumberFormatException e) {
                        throw new IllegalArgumentException("Session timeout must be an integer.");
                    }
                    break;
                case "maintenance_mode":
                case "registration_enabled":
                    if (!"true".equalsIgnoreCase(val) && !"false".equalsIgnoreCase(val)) {
                        throw new IllegalArgumentException(key + " must be either 'true' or 'false'.");
                    }
                    break;
            }
        }

        // Cross-field validation: default duration cannot exceed max duration
        if (settings.containsKey("default_quiz_duration") && settings.containsKey("max_quiz_duration")) {
            int defDur = Integer.parseInt(settings.get("default_quiz_duration").trim());
            int maxDur = Integer.parseInt(settings.get("max_quiz_duration").trim());
            if (defDur > maxDur) {
                throw new IllegalArgumentException("Default quiz duration (" + defDur + "m) cannot exceed maximum quiz duration (" + maxDur + "m).");
            }
        }

        // Save each validated setting
        for (Map.Entry<String, String> entry : settings.entrySet()) {
            adminDao.updateSetting(entry.getKey(), entry.getValue(), actingAdminId);
        }

        return true;
    }

    @Override
    public List<AuditLogEntryDto> getAuditLogs(String eventType, String userQuery, String severity,
                                              Timestamp startDate, Timestamp endDate, int page, int pageSize) {
        int limit = pageSize > 0 ? pageSize : 25;
        int offset = Math.max(page - 1, 0) * limit;

        List<AuditLogEntryDto> logs = adminDao.getAuditLogs(eventType, userQuery, severity, startDate, endDate, limit, offset);

        // Security requirement: Ensure secrets/hashes are never exposed
        for (AuditLogEntryDto log : logs) {
            if (log.getDetails() != null) {
                String d = log.getDetails();
                if (d.contains("$2a$") || d.contains("$2b$") || d.contains("$2y$")) {
                    log.setDetails(d.replaceAll("\\$2[aby]\\$\\d{2}\\$[A-Za-z0-9./]{53}", "[REDACTED_BCRYPT_HASH]"));
                }
            }
        }

        return logs;
    }

    @Override
    public int countAuditLogs(String eventType, String userQuery, String severity,
                              Timestamp startDate, Timestamp endDate) {
        return adminDao.countAuditLogs(eventType, userQuery, severity, startDate, endDate);
    }
}
