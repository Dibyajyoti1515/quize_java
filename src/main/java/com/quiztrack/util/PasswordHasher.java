package com.quiztrack.util;

import org.mindrot.jbcrypt.BCrypt;

/**
 * Utility class for secure password hashing and verification using BCrypt.
 */
public class PasswordHasher {

    private static final int BCRYPT_LOG_ROUNDS = 10;

    /**
     * Hashes a plaintext password using BCrypt with a secure salt.
     *
     * @param plainPassword The plain text password.
     * @return The 60-character BCrypt hash string.
     */
    public static String hashPassword(String plainPassword) {
        if (plainPassword == null || plainPassword.isEmpty()) {
            throw new IllegalArgumentException("Password cannot be null or empty");
        }
        return BCrypt.hashpw(plainPassword, BCrypt.gensalt(BCRYPT_LOG_ROUNDS));
    }

    /**
     * Verifies a plain text password against a stored BCrypt hash.
     *
     * @param plainPassword  The candidate plaintext password.
     * @param hashedPassword The stored BCrypt hash.
     * @return true if matches, false otherwise.
     */
    public static boolean checkPassword(String plainPassword, String hashedPassword) {
        if (plainPassword == null || hashedPassword == null) {
            return false;
        }
        try {
            return BCrypt.checkpw(plainPassword, hashedPassword);
        } catch (Exception e) {
            return false;
        }
    }

    public static void main(String[] args) {
        String testPass = "password123";
        String hash = hashPassword(testPass);
        System.out.println("Password: " + testPass);
        System.out.println("BCrypt Hash: " + hash);
        System.out.println("Verified: " + checkPassword(testPass, hash));
    }
}
