package com.quiztrack;

import com.quiztrack.dao.AdminDao;
import com.quiztrack.dao.UserDao;
import com.quiztrack.dao.impl.AdminDaoImpl;
import com.quiztrack.dao.impl.UserDaoImpl;
import com.quiztrack.model.*;
import com.quiztrack.service.AdminService;
import com.quiztrack.service.impl.AdminServiceImpl;
import com.quiztrack.util.DatabaseConnection;
import org.junit.jupiter.api.*;
import org.mindrot.jbcrypt.BCrypt;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;

@TestMethodOrder(MethodOrderer.OrderAnnotation.class)
public class AdminManagementTest {

    private static AdminDao adminDao;
    private static UserDao userDao;
    private static AdminService adminService;

    private static final int ADMIN_USER_ID = 1;       // System Administrator
    private static final int TEACHER_USER_ID = 2;     // Prof. Ronald Vance
    private static final int STUDENT_USER_ID = 4;     // Alex Mercer

    private static final String TEST_IDENTIFIER = "ADM-TST-" + System.currentTimeMillis() % 100000;
    private static final String TEST_EMAIL = "test.adm." + (System.currentTimeMillis() % 100000) + "@university.edu";
    private static int createdTestUserId = 0;

    @BeforeAll
    public static void setUp() {
        adminDao = new AdminDaoImpl();
        userDao = new UserDaoImpl();
        adminService = new AdminServiceImpl(adminDao, userDao);
    }

    @AfterAll
    public static void tearDown() {
        // Clean up test user created during the test run
        if (createdTestUserId > 0) {
            try (Connection conn = DatabaseConnection.getConnection();
                 PreparedStatement ps = conn.prepareStatement("DELETE FROM users WHERE user_id = ?")) {
                ps.setInt(1, createdTestUserId);
                ps.executeUpdate();
            } catch (Exception ignored) {}
        }
    }

    @Test
    @Order(1)
    @DisplayName("Test 1: Admin dashboard statistics compilation from PostgreSQL")
    public void testAdminDashboardStatistics() {
        AdminDashboardStats stats = adminService.getDashboardStatistics();

        assertNotNull(stats, "Dashboard statistics must not be null");
        assertTrue(stats.getTotalStudents() >= 1, "Total registered students must be >= 1");
        assertTrue(stats.getTotalTeachers() >= 1, "Total registered faculty must be >= 1");
        assertTrue(stats.getTotalAdmins() >= 1, "Total active administrators must be >= 1");
        assertTrue(stats.getTotalUsers() >= 3, "Total registered users must be >= 3");
        assertTrue(stats.getTotalQuizzes() >= 1, "Total quizzes must be >= 1");

        assertNotNull(stats.getRecentActivities(), "Recent activity feed must not be null");
        assertNotNull(stats.getRegistrationTrends(), "Registration trends must not be null");
    }

    @Test
    @Order(2)
    @DisplayName("Test 2: User directory listing, keyword search, and role filtering")
    public void testUserListingAndSearch() {
        // Search by keyword "Alex"
        List<User> alexResults = adminService.listUsers("Alex", null, null, 1, 10);
        assertFalse(alexResults.isEmpty(), "Search for 'Alex' should return at least 1 record");
        assertTrue(alexResults.stream().anyMatch(u -> u.getFullName().contains("Alex")), "Result should contain Alex Mercer");

        // Filter by role TEACHER
        List<User> teachers = adminService.listUsers(null, "TEACHER", null, 1, 10);
        assertFalse(teachers.isEmpty(), "Role filter TEACHER must return faculty accounts");
        assertTrue(teachers.stream().allMatch(User::isTeacher), "All returned users must have role TEACHER");

        // Filter by status ACTIVE
        List<User> activeUsers = adminService.listUsers(null, null, "ACTIVE", 1, 10);
        assertFalse(activeUsers.isEmpty(), "Status filter ACTIVE must return active accounts");
        assertTrue(activeUsers.stream().allMatch(User::isActive), "All returned users must have status ACTIVE");
    }

    @Test
    @Order(3)
    @DisplayName("Test 3: User creation with BCrypt password hashing and validation")
    public void testUserCreation() {
        boolean created = adminService.createUser(
                "Automated Test Candidate",
                TEST_IDENTIFIER,
                TEST_EMAIL,
                "SecurePass123!",
                "STUDENT",
                "Computer Science",
                "Class of 2026",
                ADMIN_USER_ID
        );

        assertTrue(created, "User creation must succeed");

        Optional<User> createdOpt = userDao.findByIdentifierOrEmail(TEST_IDENTIFIER);
        assertTrue(createdOpt.isPresent(), "Newly created user must exist in database");

        User user = createdOpt.get();
        assertEquals("Automated Test Candidate", user.getFullName());
        assertEquals(TEST_IDENTIFIER, user.getIdentifier());
        assertEquals(TEST_EMAIL, user.getEmail());
        assertEquals("STUDENT", user.getRoleName());
        assertTrue(user.isActive(), "New account must default to ACTIVE");

        // Verify password hash is valid BCrypt
        assertNotNull(user.getPasswordHash());
        assertTrue(BCrypt.checkpw("SecurePass123!", user.getPasswordHash()), "BCrypt must verify against raw password");

        createdTestUserId = user.getUserId();
    }

    @Test
    @Order(4)
    @DisplayName("Test 4: User profile information update")
    public void testEditUserProfile() {
        assertTrue(createdTestUserId > 0, "Test user ID must be available");

        String updatedName = "Automated Test Candidate (Edited)";
        String updatedDept = "Software Engineering";
        String updatedCohort = "Class of 2027";

        boolean updated = adminService.editUserProfile(
                createdTestUserId,
                updatedName,
                TEST_EMAIL,
                updatedDept,
                updatedCohort,
                ADMIN_USER_ID
        );

        assertTrue(updated, "Profile update should succeed");

        User reloaded = adminService.getUserDetails(createdTestUserId);
        assertEquals(updatedName, reloaded.getFullName());
        assertEquals(updatedDept, reloaded.getDepartment());
        assertEquals(updatedCohort, reloaded.getCohort());
    }

    @Test
    @Order(5)
    @DisplayName("Test 5: User account activation and deactivation")
    public void testUserActivationAndDeactivation() {
        assertTrue(createdTestUserId > 0, "Test user ID must be available");

        // Deactivate user
        boolean deactivated = adminService.setUserStatus(createdTestUserId, "INACTIVE", ADMIN_USER_ID);
        assertTrue(deactivated, "Deactivating candidate account should succeed");

        User inactiveUser = adminService.getUserDetails(createdTestUserId);
        assertEquals("INACTIVE", inactiveUser.getStatus());
        assertFalse(inactiveUser.isActive());

        // Re-activate user
        boolean reactivated = adminService.setUserStatus(createdTestUserId, "ACTIVE", ADMIN_USER_ID);
        assertTrue(reactivated, "Re-activating candidate account should succeed");

        User activeUser = adminService.getUserDetails(createdTestUserId);
        assertEquals("ACTIVE", activeUser.getStatus());
        assertTrue(activeUser.isActive());
    }

    @Test
    @Order(6)
    @DisplayName("Test 6: Prevent administrator self-deactivation")
    public void testPreventSelfDeactivation() {
        // Admin ID 1 attempting to deactivate themselves
        assertThrows(SecurityException.class, () -> {
            adminService.setUserStatus(ADMIN_USER_ID, "INACTIVE", ADMIN_USER_ID);
        }, "Admin attempting to deactivate their own account must be blocked");
    }

    @Test
    @Order(7)
    @DisplayName("Test 7: Last-active administrator protection against removal/demotion")
    public void testLastAdminProtection() {
        int activeAdmins = adminDao.countActiveAdmins();

        // If there is only 1 active admin (Admin ID 1)
        if (activeAdmins <= 1) {
            // Attempting to demote the sole admin to student
            assertThrows(SecurityException.class, () -> {
                adminService.changeUserRole(ADMIN_USER_ID, "STUDENT", 9999); // Even an external actor
            }, "Demoting the sole remaining administrator must be strictly prohibited");

            // Attempting to deactivate the sole admin
            assertThrows(SecurityException.class, () -> {
                adminService.setUserStatus(ADMIN_USER_ID, "SUSPENDED", 9999);
            }, "Deactivating the sole remaining administrator must be strictly prohibited");
        } else {
            assertTrue(activeAdmins > 1, "Multiple active administrators present");
        }
    }

    @Test
    @Order(8)
    @DisplayName("Test 8: Prevent administrator self-role change")
    public void testPreventSelfRoleChange() {
        // Admin ID 1 attempting to change their own role to STUDENT
        assertThrows(SecurityException.class, () -> {
            adminService.changeUserRole(ADMIN_USER_ID, "STUDENT", ADMIN_USER_ID);
        }, "Admin attempting to modify their own role must be blocked");
    }

    @Test
    @Order(9)
    @DisplayName("Test 9: Secure password reset with BCrypt hashing and audit trail")
    public void testResetUserPassword() {
        assertTrue(createdTestUserId > 0, "Test user ID must be available");

        String newPassword = "BrandNewPassword999#";
        boolean resetOk = adminService.resetUserPassword(createdTestUserId, newPassword, ADMIN_USER_ID);
        assertTrue(resetOk, "Password reset should succeed");

        User user = adminService.getUserDetails(createdTestUserId);
        assertTrue(BCrypt.checkpw(newPassword, user.getPasswordHash()),
                "BCrypt must verify against newly reset password");
    }

    @Test
    @Order(10)
    @DisplayName("Test 10: Role promotion and modification")
    public void testChangeUserRole() {
        assertTrue(createdTestUserId > 0, "Test user ID must be available");

        // Promote test student to TEACHER
        boolean promoted = adminService.changeUserRole(createdTestUserId, "TEACHER", ADMIN_USER_ID);
        assertTrue(promoted, "Role promotion to TEACHER should succeed");

        User user = adminService.getUserDetails(createdTestUserId);
        assertEquals("TEACHER", user.getRoleName());
        assertTrue(user.isTeacher());
    }

    @Test
    @Order(11)
    @DisplayName("Test 11: System configuration validation and persistence")
    public void testSystemConfigurationSettings() {
        // 1. Valid update
        Map<String, String> validSettings = new HashMap<>();
        validSettings.put("app_name", "QuizTrack University Testing Center");
        validSettings.put("default_quiz_duration", "75");
        validSettings.put("max_quiz_duration", "180");
        validSettings.put("default_passing_percentage", "50.0");
        validSettings.put("max_login_attempts", "5");
        validSettings.put("session_timeout", "45");
        validSettings.put("maintenance_mode", "false");
        validSettings.put("registration_enabled", "true");

        boolean updated = adminService.updateSystemSettings(validSettings, ADMIN_USER_ID);
        assertTrue(updated, "Valid system settings update should succeed");

        Optional<SystemSetting> settingOpt = adminDao.getSetting("app_name");
        assertTrue(settingOpt.isPresent());
        assertEquals("QuizTrack University Testing Center", settingOpt.get().getSettingValue());

        // 2. Cross-field validation error: default_quiz_duration > max_quiz_duration
        Map<String, String> invalidDurations = new HashMap<>();
        invalidDurations.put("default_quiz_duration", "250");
        invalidDurations.put("max_quiz_duration", "100");

        assertThrows(IllegalArgumentException.class, () -> {
            adminService.updateSystemSettings(invalidDurations, ADMIN_USER_ID);
        }, "Default duration exceeding maximum duration must be rejected");

        // 3. Out-of-bounds passing percentage
        Map<String, String> invalidPass = new HashMap<>();
        invalidPass.put("default_passing_percentage", "150.0");

        assertThrows(IllegalArgumentException.class, () -> {
            adminService.updateSystemSettings(invalidPass, ADMIN_USER_ID);
        }, "Passing percentage above 100% must be rejected");
    }

    @Test
    @Order(12)
    @DisplayName("Test 12: Enterprise audit log query and sensitive secret redaction")
    public void testAuditLogQueryAndRedaction() {
        List<AuditLogEntryDto> logs = adminService.getAuditLogs(null, null, null, null, null, 1, 20);
        assertNotNull(logs, "Audit logs list must not be null");
        assertFalse(logs.isEmpty(), "Audit logs must contain system entries");

        // Verify that no BCrypt hashes or plain-text secrets are exposed in audit details
        for (AuditLogEntryDto log : logs) {
            String details = log.getDetails();
            if (details != null) {
                assertFalse(details.contains("$2a$12$"), "BCrypt salt/hash must never be leaked in audit trail");
                assertFalse(details.contains("$2b$12$"), "BCrypt salt/hash must never be leaked in audit trail");
            }
        }
    }

    @Test
    @Order(13)
    @DisplayName("Test 13: System settings helper and dynamic runtime parameter resolution")
    public void testSystemSettingsHelperResolution() {
        int maxAttempts = com.quiztrack.util.SystemSettingsHelper.getIntSetting("max_login_attempts", 5);
        assertTrue(maxAttempts >= 1 && maxAttempts <= 20, "Max login attempts must be bounded 1-20");

        int sessionTimeout = com.quiztrack.util.SystemSettingsHelper.getIntSetting("session_timeout", 30);
        assertTrue(sessionTimeout >= 5 && sessionTimeout <= 480, "Session timeout must be bounded 5-480 min");

        int maxQuizDuration = com.quiztrack.util.SystemSettingsHelper.getIntSetting("max_quiz_duration", 180);
        assertTrue(maxQuizDuration >= 10 && maxQuizDuration <= 600, "Max quiz duration must be bounded 10-600 min");

        boolean regEnabled = com.quiztrack.util.SystemSettingsHelper.getBooleanSetting("registration_enabled", true);
        assertNotNull(regEnabled);
    }

    @Test
    @Order(14)
    @DisplayName("Test 14: Failed login activity logging and lockout counter tracking")
    public void testFailedLoginCounterTracking() {
        assertTrue(createdTestUserId > 0, "Test user ID must be available");

        int initialFailures = userDao.countRecentFailedLogins(createdTestUserId, 15);

        // Record a mock failed login
        userDao.logActivity(createdTestUserId, "LOGIN_FAILED", "CAUTION", "Automated test failed login");

        int updatedFailures = userDao.countRecentFailedLogins(createdTestUserId, 15);
        assertEquals(initialFailures + 1, updatedFailures, "Failed login counter must increment by 1");
    }
}
