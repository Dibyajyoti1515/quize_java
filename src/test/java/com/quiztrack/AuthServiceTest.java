package com.quiztrack;

import com.quiztrack.dao.UserDao;
import com.quiztrack.dao.impl.UserDaoImpl;
import com.quiztrack.model.Role;
import com.quiztrack.model.User;
import com.quiztrack.service.AuthService;
import com.quiztrack.service.impl.AuthServiceImpl;
import com.quiztrack.util.DatabaseConnection;
import com.quiztrack.util.PasswordHasher;
import org.junit.jupiter.api.*;

import java.util.Optional;
import java.util.UUID;

import static org.junit.jupiter.api.Assertions.*;

@TestMethodOrder(MethodOrderer.OrderAnnotation.class)
public class AuthServiceTest {

    private static AuthService authService;
    private static UserDao userDao;

    @BeforeAll
    public static void setUp() {
        userDao = new UserDaoImpl();
        authService = new AuthServiceImpl(userDao);
    }

    @AfterAll
    public static void tearDown() {
        DatabaseConnection.closePool();
    }

    @Test
    @Order(1)
    @DisplayName("Test 1: Student Login with Roll Number (CS-2022-041)")
    public void testStudentLoginWithIdentifier() {
        AuthService.AuthResult result = authService.authenticate("CS-2022-041", "password123", "student");
        assertTrue(result.isSuccess(), "Student login should succeed with roll ID");
        assertNotNull(result.getUser());
        assertEquals("Alex Mercer", result.getUser().getFullName());
        assertEquals(Role.ROLE_STUDENT, result.getUser().getRoleName());
        assertEquals("/student/dashboard", result.getRedirectUrl());
    }

    @Test
    @Order(2)
    @DisplayName("Test 2: Student Login with Email (alex.mercer@university.edu)")
    public void testStudentLoginWithEmail() {
        AuthService.AuthResult result = authService.authenticate("alex.mercer@university.edu", "password123", "student");
        assertTrue(result.isSuccess(), "Student login should succeed with email");
        assertNotNull(result.getUser());
        assertEquals("CS-2022-041", result.getUser().getIdentifier());
        assertEquals("/student/dashboard", result.getRedirectUrl());
    }

    @Test
    @Order(3)
    @DisplayName("Test 3: Teacher Login with Faculty ID (ronald.vance)")
    public void testTeacherLogin() {
        AuthService.AuthResult result = authService.authenticate("ronald.vance", "password123", "teacher");
        assertTrue(result.isSuccess(), "Teacher login should succeed");
        assertNotNull(result.getUser());
        assertEquals("Prof. Ronald Vance", result.getUser().getFullName());
        assertEquals(Role.ROLE_TEACHER, result.getUser().getRoleName());
        assertEquals("/teacher/dashboard", result.getRedirectUrl());
    }

    @Test
    @Order(4)
    @DisplayName("Test 4: Admin Login (admin)")
    public void testAdminLogin() {
        AuthService.AuthResult result = authService.authenticate("admin", "password123", "admin");
        assertTrue(result.isSuccess(), "Admin login should succeed");
        assertNotNull(result.getUser());
        assertEquals("System Administrator", result.getUser().getFullName());
        assertEquals(Role.ROLE_ADMIN, result.getUser().getRoleName());
        assertEquals("/admin/dashboard", result.getRedirectUrl());
    }

    @Test
    @Order(5)
    @DisplayName("Test 5: Login Failure with Incorrect Password")
    public void testLoginFailureWrongPassword() {
        AuthService.AuthResult result = authService.authenticate("CS-2022-041", "wrongPassword999", "student");
        assertFalse(result.isSuccess(), "Login with wrong password must fail");
        assertNull(result.getUser());
        assertTrue(result.getMessage().toLowerCase().contains("failed") || result.getMessage().toLowerCase().contains("invalid"));
    }

    @Test
    @Order(6)
    @DisplayName("Test 6: Login Failure with Nonexistent Identifier")
    public void testLoginFailureNonexistentUser() {
        AuthService.AuthResult result = authService.authenticate("NON_EXISTENT_ID_9999", "password123", "student");
        assertFalse(result.isSuccess(), "Login with nonexistent user must fail");
        assertNull(result.getUser());
    }

    @Test
    @Order(7)
    @DisplayName("Test 7: Role Protection - Student Attempting Faculty Access")
    public void testStudentBlockedFromFacultyRole() {
        // Candidate CS-2022-041 attempts to log in specifying 'teacher' role
        AuthService.AuthResult result = authService.authenticate("CS-2022-041", "password123", "teacher");
        assertFalse(result.isSuccess(), "Student should be blocked when attempting faculty mode login");
        assertTrue(result.getMessage().contains("Candidate credential") || result.getMessage().contains("Access Restricted"));
    }

    @Test
    @Order(8)
    @DisplayName("Test 8: Role Protection - Non-Admin Attempting Admin Access")
    public void testStudentBlockedFromAdminRole() {
        AuthService.AuthResult result = authService.authenticate("CS-2022-041", "password123", "admin");
        assertFalse(result.isSuccess(), "Student should be blocked when attempting admin mode login");
        assertTrue(result.getMessage().contains("Administrator privileges required") || result.getMessage().contains("Access Restricted"));
    }

    @Test
    @Order(9)
    @DisplayName("Test 9: Account Registration with BCrypt Password Hashing")
    public void testAccountRegistration() {
        String uniqueSuffix = UUID.randomUUID().toString().substring(0, 6);
        String testRollId = "CS-TEST-" + uniqueSuffix;
        String testEmail = "test." + uniqueSuffix + "@university.edu";

        User newUser = new User();
        newUser.setFullName("Automated Test Student");
        newUser.setIdentifier(testRollId);
        newUser.setEmail(testEmail);
        newUser.setDepartment("Computer Science");
        newUser.setCohort("Class of 2026");
        newUser.setRoleId(3);
        newUser.setRoleName(Role.ROLE_STUDENT);
        newUser.setBiometricConsent(true);

        AuthService.AuthResult regResult = authService.register(newUser, "SecurePass2026!");
        assertTrue(regResult.isSuccess(), "New student registration should succeed");
        assertNotNull(regResult.getUser());
        assertTrue(regResult.getUser().getUserId() > 0, "Registered user must receive a generated primary key");

        // Verify password in database is NOT plaintext and validates with BCrypt
        Optional<User> persistedOpt = userDao.findById(regResult.getUser().getUserId());
        assertTrue(persistedOpt.isPresent());
        User persisted = persistedOpt.get();
        assertNotEquals("SecurePass2026!", persisted.getPasswordHash(), "Password must NEVER be stored in plaintext");
        assertTrue(persisted.getPasswordHash().startsWith("$2a$") || persisted.getPasswordHash().startsWith("$2b$"),
                   "Password must be hashed with BCrypt algorithm");
        assertTrue(PasswordHasher.checkPassword("SecurePass2026!", persisted.getPasswordHash()),
                   "BCrypt verification of candidate password must succeed");

        // Now verify login with the newly registered user
        AuthService.AuthResult loginResult = authService.authenticate(testRollId, "SecurePass2026!", "student");
        assertTrue(loginResult.isSuccess(), "Login with newly registered credentials must succeed");
    }

    @Test
    @Order(10)
    @DisplayName("Test 10: Duplicate Registration Prevention (Unique Identifier & Email)")
    public void testDuplicateRegistrationBlocked() {
        User duplicateUser = new User();
        duplicateUser.setFullName("Duplicate Test");
        duplicateUser.setIdentifier("CS-2022-041"); // Already exists
        duplicateUser.setEmail("brandnewemail@university.edu");

        AuthService.AuthResult result1 = authService.register(duplicateUser, "password123");
        assertFalse(result1.isSuccess(), "Duplicate identifier must be rejected");
        assertTrue(result1.getMessage().contains("already registered"));

        User duplicateEmailUser = new User();
        duplicateEmailUser.setFullName("Duplicate Email Test");
        duplicateEmailUser.setIdentifier("CS-UNIQUE-ROLL-1234");
        duplicateEmailUser.setEmail("alex.mercer@university.edu"); // Already exists

        AuthService.AuthResult result2 = authService.register(duplicateEmailUser, "password123");
        assertFalse(result2.isSuccess(), "Duplicate email must be rejected");
        assertTrue(result2.getMessage().contains("already in use"));
    }

    @Test
    @Order(11)
    @DisplayName("Test 11: Password Reset Request Initiation")
    public void testPasswordResetRequest() {
        boolean requested = authService.requestPasswordReset("alex.mercer@university.edu");
        assertTrue(requested, "Password reset request for existing user should succeed");

        boolean nonexistentRequested = authService.requestPasswordReset("nonexistent.random@university.edu");
        assertFalse(nonexistentRequested, "Password reset for nonexistent user should return false");
    }
}
