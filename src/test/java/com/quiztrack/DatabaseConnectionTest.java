package com.quiztrack;

import com.quiztrack.util.DatabaseConnection;
import com.quiztrack.util.PasswordHasher;
import org.junit.jupiter.api.*;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import static org.junit.jupiter.api.Assertions.*;

@TestMethodOrder(MethodOrderer.OrderAnnotation.class)
public class DatabaseConnectionTest {

    @AfterAll
    public static void tearDown() {
        DatabaseConnection.closePool();
    }

    @Test
    @Order(1)
    @DisplayName("Verify Database Connection Acquisition from HikariCP Pool")
    public void testConnectionAcquisition() throws SQLException {
        try (Connection conn = DatabaseConnection.getConnection()) {
            assertNotNull(conn, "Connection should not be null");
            assertFalse(conn.isClosed(), "Connection should be open");
            assertTrue(conn.isValid(2), "Connection should be valid within 2 seconds");
            assertEquals("PostgreSQL", conn.getMetaData().getDatabaseProductName(), "Database product must be PostgreSQL");
        }
    }

    @Test
    @Order(2)
    @DisplayName("Verify Roles Table Seeded Correctly")
    public void testRolesSeeded() throws SQLException {
        String sql = "SELECT COUNT(*) AS total FROM roles WHERE role_name IN ('ADMIN', 'TEACHER', 'STUDENT')";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            assertTrue(rs.next(), "Result set should have a row");
            assertEquals(3, rs.getInt("total"), "There should be exactly 3 base roles");
        }
    }

    @Test
    @Order(3)
    @DisplayName("Verify Users Table Seeded & Passwords Verifiable with BCrypt")
    public void testUsersAndBCryptPassword() throws SQLException {
        String sql = "SELECT identifier, password_hash, full_name, role_id FROM users WHERE identifier = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            // Test Admin User
            ps.setString(1, "admin");
            try (ResultSet rs = ps.executeQuery()) {
                assertTrue(rs.next(), "Admin user must exist");
                assertEquals("System Administrator", rs.getString("full_name"));
                assertEquals(1, rs.getInt("role_id"));
                assertTrue(PasswordHasher.checkPassword("password123", rs.getString("password_hash")), 
                           "Admin password must verify with BCrypt");
            }

            // Test Teacher User
            ps.setString(1, "ronald.vance");
            try (ResultSet rs = ps.executeQuery()) {
                assertTrue(rs.next(), "Teacher user Prof. Ronald Vance must exist");
                assertEquals("Prof. Ronald Vance", rs.getString("full_name"));
                assertEquals(2, rs.getInt("role_id"));
                assertTrue(PasswordHasher.checkPassword("password123", rs.getString("password_hash")), 
                           "Teacher password must verify with BCrypt");
            }

            // Test Student User (Alex Mercer)
            ps.setString(1, "CS-2022-041");
            try (ResultSet rs = ps.executeQuery()) {
                assertTrue(rs.next(), "Student Alex Mercer must exist");
                assertEquals("Alex Mercer", rs.getString("full_name"));
                assertEquals(3, rs.getInt("role_id"));
                assertTrue(PasswordHasher.checkPassword("password123", rs.getString("password_hash")), 
                           "Student password must verify with BCrypt");
            }
        }
    }

    @Test
    @Order(4)
    @DisplayName("Verify Subjects and Active Quiz Configuration")
    public void testSubjectsAndQuizzes() throws SQLException {
        String sql = "SELECT q.title, q.duration_minutes, q.total_marks, q.status, s.subject_code " +
                     "FROM quizzes q JOIN subjects s ON q.subject_id = s.subject_id " +
                     "WHERE s.subject_code = 'CS402'";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            assertTrue(rs.next(), "CS402 Midterm Quiz must exist");
            assertEquals("CS402: Midterm Exam - Distributed Systems & Concurrency", rs.getString("title"));
            assertEquals(90, rs.getInt("duration_minutes"));
            assertEquals(140.0, rs.getDouble("total_marks"), 0.01);
            assertEquals("ACTIVE", rs.getString("status"));
        }
    }

    @Test
    @Order(5)
    @DisplayName("Verify Questions & Multiple-Choice Options")
    public void testQuestionsAndOptions() throws SQLException {
        String sql = "SELECT q.question_id, q.points, q.taxonomy_topic, COUNT(o.option_id) AS option_count " +
                     "FROM questions q JOIN question_options o ON q.question_id = o.question_id " +
                     "WHERE q.quiz_id = 1 GROUP BY q.question_id, q.points, q.taxonomy_topic";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            int questionCount = 0;
            while (rs.next()) {
                questionCount++;
                assertEquals(4, rs.getInt("option_count"), "Each MC question should have 4 options");
            }
            assertTrue(questionCount >= 5, "At least 5 questions should be seeded for Quiz 1");
        }
    }
}
