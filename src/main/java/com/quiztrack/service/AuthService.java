package com.quiztrack.service;

import com.quiztrack.model.User;
import java.io.Serializable;

/**
 * Service handling authentication, registration, password verification, and access routing.
 */
public interface AuthService {

    /**
     * Authenticates candidate, faculty or admin credentials with BCrypt verification.
     *
     * @param identifier   Roll number, faculty ID, username, or email.
     * @param password     Candidate plaintext password.
     * @param expectedRole Requested role context ('student', 'teacher', 'admin', or null for auto-detect).
     * @return AuthResult containing success flag, authenticated User, target URL or error reason.
     */
    AuthResult authenticate(String identifier, String password, String expectedRole);

    /**
     * Registers a new student or faculty account.
     *
     * @param user          User model populated with profile fields.
     * @param plainPassword Raw plaintext password to be hashed.
     * @return AuthResult indicating success or specific validation failure.
     */
    AuthResult register(User user, String plainPassword);

    /**
     * Processes a password reset request.
     *
     * @param email Account email address.
     * @return true if account located and reset token queued, false otherwise.
     */
    boolean requestPasswordReset(String email);

    /**
     * Result value object returned from authentication and registration workflows.
     */
    class AuthResult implements Serializable {
        private static final long serialVersionUID = 1L;

        private final boolean success;
        private final User user;
        private final String message;
        private final String redirectUrl;

        public AuthResult(boolean success, User user, String message, String redirectUrl) {
            this.success = success;
            this.user = user;
            this.message = message;
            this.redirectUrl = redirectUrl;
        }

        public static AuthResult success(User user, String redirectUrl) {
            return new AuthResult(true, user, "Authentication successful", redirectUrl);
        }

        public static AuthResult failure(String errorMessage) {
            return new AuthResult(false, null, errorMessage, null);
        }

        public boolean isSuccess() {
            return success;
        }

        public User getUser() {
            return user;
        }

        public String getMessage() {
            return message;
        }

        public String getRedirectUrl() {
            return redirectUrl;
        }
    }
}
