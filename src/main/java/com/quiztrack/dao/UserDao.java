package com.quiztrack.dao;

import com.quiztrack.model.User;
import java.util.List;
import java.util.Optional;

/**
 * Data Access Object interface for User operations.
 */
public interface UserDao {

    /**
     * Finds a user by roll number, employee ID, username, or institutional email.
     */
    Optional<User> findByIdentifierOrEmail(String identifierOrEmail);

    /**
     * Finds a user by primary key ID.
     */
    Optional<User> findById(int userId);

    /**
     * Creates a new user record.
     */
    boolean create(User user);

    /**
     * Checks if an identifier already exists.
     */
    boolean existsByIdentifier(String identifier);

    /**
     * Checks if an email already exists.
     */
    boolean existsByEmail(String email);

    /**
     * Updates user's BCrypt password hash.
     */
    boolean updatePassword(int userId, String passwordHash);

    /**
     * Updates user's account status ('ACTIVE', 'SUSPENDED').
     */
    boolean updateStatus(int userId, String status);

    /**
     * Records an authentication or system event in activity_logs.
     */
    void logActivity(int userId, String eventType, String severity, String details);

    /**
     * Retrieves all users by role.
     */
    List<User> findByRole(String roleName);

    /**
     * Counts recent failed login attempts for a user within a time window in minutes.
     */
    int countRecentFailedLogins(int userId, int minutes);
}
