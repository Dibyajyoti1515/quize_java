package com.quiztrack.service.impl;

import com.quiztrack.dao.UserDao;
import com.quiztrack.dao.impl.UserDaoImpl;
import com.quiztrack.model.Role;
import com.quiztrack.model.User;
import com.quiztrack.service.AuthService;
import com.quiztrack.util.PasswordHasher;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.Optional;
import java.util.regex.Pattern;

/**
 * Business logic implementation for Authentication and Account Registration.
 */
public class AuthServiceImpl implements AuthService {

    private static final Logger logger = LoggerFactory.getLogger(AuthServiceImpl.class);

    private static final Pattern EMAIL_PATTERN = Pattern.compile("^[A-Za-z0-9+_.-]+@(.+)$");

    private final UserDao userDao;

    public AuthServiceImpl() {
        this.userDao = new UserDaoImpl();
    }

    public AuthServiceImpl(UserDao userDao) {
        this.userDao = userDao;
    }

    @Override
    public AuthResult authenticate(String identifier, String password, String expectedRole) {
        if (identifier == null || identifier.trim().isEmpty()) {
            return AuthResult.failure("Please provide your institutional identifier or email.");
        }
        if (password == null || password.isEmpty()) {
            return AuthResult.failure("Please enter your account password.");
        }

        String searchKey = identifier.trim();
        Optional<User> userOpt = userDao.findByIdentifierOrEmail(searchKey);

        if (userOpt.isEmpty()) {
            logger.warn("Authentication failed: Identifier '{}' not found", searchKey);
            return AuthResult.failure("Invalid credentials. Please verify your identifier or email.");
        }

        User user = userOpt.get();

        if (!user.isActive()) {
            logger.warn("Authentication blocked for non-active user: {} (Status: {})", user.getIdentifier(), user.getStatus());
            return AuthResult.failure("Account is inactive or suspended. Please contact your examination proctor or administrator.");
        }

        // Enforce max_login_attempts system setting
        int maxAttempts = com.quiztrack.util.SystemSettingsHelper.getIntSetting("max_login_attempts", 5);
        int recentFailures = userDao.countRecentFailedLogins(user.getUserId(), 15);
        if (recentFailures >= maxAttempts) {
            userDao.logActivity(user.getUserId(), "ACCOUNT_LOCKED", "CRITICAL",
                    "Login rejected: exceeded " + maxAttempts + " consecutive failed attempts within 15 minutes");
            logger.warn("User '{}' account temporarily locked due to {} failed attempts", user.getIdentifier(), recentFailures);
            return AuthResult.failure("Account temporarily locked due to excessive failed attempts (" + maxAttempts + "). Please wait 15 minutes or contact support.");
        }

        boolean passwordValid = PasswordHasher.checkPassword(password, user.getPasswordHash());
        if (!passwordValid) {
            userDao.logActivity(user.getUserId(), "LOGIN_FAILED", "CAUTION", "Failed login attempt from gateway");
            logger.warn("Authentication failed: Incorrect password for user '{}'", user.getIdentifier());
            return AuthResult.failure("Invalid credentials. Password verification failed.");
        }

        // Validate role context if specified
        if (expectedRole != null && !expectedRole.trim().isEmpty()) {
            String exp = expectedRole.trim().toUpperCase();
            String actual = user.getRoleName().toUpperCase();

            if ("STUDENT".equals(exp) && !"STUDENT".equals(actual)) {
                // User is a faculty or admin trying to log in on student mode - redirect to faculty hub with notice
                logger.info("User {} (Role: {}) authenticated via student mode; rerouting to dedicated console", user.getIdentifier(), actual);
            } else if ("TEACHER".equals(exp) && "STUDENT".equals(actual)) {
                userDao.logActivity(user.getUserId(), "UNAUTHORIZED_ROLE_ACCESS", "CAUTION", "Candidate attempted faculty gateway login");
                logger.warn("Student {} attempted unauthorized faculty access", user.getIdentifier());
                return AuthResult.failure("Access Restricted: This account is a Candidate credential. Please switch to Candidate Mode.");
            } else if ("ADMIN".equals(exp) && !"ADMIN".equals(actual)) {
                userDao.logActivity(user.getUserId(), "UNAUTHORIZED_ROLE_ACCESS", "CRITICAL", "Non-admin attempted admin gateway login");
                logger.warn("Non-admin {} attempted unauthorized admin access", user.getIdentifier());
                return AuthResult.failure("Access Restricted: Administrator privileges required.");
            }
        }

        userDao.logActivity(user.getUserId(), "USER_LOGIN", "INFO", "Successful login as " + user.getRoleName());
        logger.info("User '{}' ({}) authenticated successfully", user.getIdentifier(), user.getRoleName());

        String targetUrl = determineDashboardUrl(user.getRoleName());
        return AuthResult.success(user, targetUrl);
    }

    @Override
    public AuthResult register(User user, String plainPassword) {
        if (user == null) {
            return AuthResult.failure("Registration payload cannot be empty.");
        }
        if (user.getFullName() == null || user.getFullName().trim().length() < 2) {
            return AuthResult.failure("Full legal name must contain at least 2 characters.");
        }
        if (user.getIdentifier() == null || user.getIdentifier().trim().length() < 3) {
            return AuthResult.failure("Institutional identifier/roll number must be at least 3 characters.");
        }
        if (user.getEmail() == null || !EMAIL_PATTERN.matcher(user.getEmail().trim()).matches()) {
            return AuthResult.failure("Please enter a valid academic email address.");
        }
        if (plainPassword == null || plainPassword.length() < 6) {
            return AuthResult.failure("Password must be at least 6 characters in length.");
        }

        String identifier = user.getIdentifier().trim();
        String email = user.getEmail().trim().toLowerCase();

        if (userDao.existsByIdentifier(identifier)) {
            return AuthResult.failure("Institutional ID '" + identifier + "' is already registered. Please sign in or reset credentials.");
        }

        if (userDao.existsByEmail(email)) {
            return AuthResult.failure("Email address '" + email + "' is already in use.");
        }

        // Map role
        if (user.getRoleId() <= 0) {
            if ("TEACHER".equalsIgnoreCase(user.getRoleName())) {
                user.setRoleId(2);
                user.setRoleName(Role.ROLE_TEACHER);
            } else {
                user.setRoleId(3);
                user.setRoleName(Role.ROLE_STUDENT);
            }
        }

        // Secure password hashing
        String hash = PasswordHasher.hashPassword(plainPassword);
        user.setPasswordHash(hash);
        user.setStatus("ACTIVE");

        boolean created = userDao.create(user);
        if (!created) {
            return AuthResult.failure("Database error occurred while creating user account. Please try again.");
        }

        userDao.logActivity(user.getUserId(), "USER_REGISTERED", "INFO", "Account created as " + user.getRoleName());
        logger.info("New user account registered: {} ({})", user.getIdentifier(), user.getRoleName());

        String targetUrl = determineDashboardUrl(user.getRoleName());
        return AuthResult.success(user, targetUrl);
    }

    @Override
    public boolean requestPasswordReset(String email) {
        if (email == null || email.trim().isEmpty()) {
            return false;
        }
        Optional<User> userOpt = userDao.findByIdentifierOrEmail(email.trim());
        if (userOpt.isPresent()) {
            User user = userOpt.get();
            userDao.logActivity(user.getUserId(), "PASSWORD_RESET_REQUESTED", "INFO", "Password reset initiated for " + email);
            logger.info("Password reset request logged for user ID: {}", user.getUserId());
            return true;
        }
        return false;
    }

    private String determineDashboardUrl(String roleName) {
        if (roleName == null) return "/student/dashboard";
        switch (roleName.toUpperCase()) {
            case Role.ROLE_ADMIN:
                return "/admin/dashboard";
            case Role.ROLE_TEACHER:
                return "/teacher/dashboard";
            case Role.ROLE_STUDENT:
            default:
                return "/student/dashboard";
        }
    }
}
