package com.quiztrack;

import com.quiztrack.dao.AdminDao;
import com.quiztrack.dao.impl.AdminDaoImpl;
import com.quiztrack.model.DepartmentSummaryDto;
import com.quiztrack.model.User;
import com.quiztrack.service.AdminService;
import com.quiztrack.service.impl.AdminServiceImpl;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import java.util.List;

import static org.junit.jupiter.api.Assertions.*;

/**
 * Verification test suite for Academic Department Management,
 * branch faculty rosters, quiz totals, and top 5 student rankings.
 */
public class AdminDepartmentTest {

    private AdminDao adminDao;
    private AdminService adminService;

    @BeforeEach
    public void setUp() {
        adminDao = new AdminDaoImpl();
        adminService = new AdminServiceImpl(adminDao);
    }

    @Test
    @DisplayName("Test 1: Retrieve all department summaries from PostgreSQL")
    public void testGetDepartmentSummaries() {
        List<DepartmentSummaryDto> summaries = adminService.getDepartmentSummaries();
        assertNotNull(summaries, "Department summaries list should not be null");
        assertFalse(summaries.isEmpty(), "System should contain at least one academic department");

        boolean hasCS = false;
        for (DepartmentSummaryDto d : summaries) {
            assertNotNull(d.getDepartmentName(), "Department name must not be null");
            assertTrue(d.getTeacherCount() >= 0, "Teacher count cannot be negative");
            assertTrue(d.getStudentCount() >= 0, "Student count cannot be negative");
            assertTrue(d.getQuizCount() >= 0, "Quiz count cannot be negative");

            if ("Computer Science".equalsIgnoreCase(d.getDepartmentName())) {
                hasCS = true;
                assertTrue(d.getTeacherCount() >= 2, "Computer Science should have at least 2 faculty members");
                assertTrue(d.getStudentCount() >= 5, "Computer Science should have at least 5 enrolled students");
                assertTrue(d.getQuizCount() >= 1, "Computer Science should have at least 1 authored quiz");
            }
        }
        assertTrue(hasCS, "Computer Science department must be present in summaries");
    }

    @Test
    @DisplayName("Test 2: Verify Computer Science faculty teachers and quiz count")
    public void testDepartmentFacultyRoster() {
        List<DepartmentSummaryDto> summaries = adminService.getDepartmentSummaries();
        DepartmentSummaryDto csDept = summaries.stream()
                .filter(d -> "Computer Science".equalsIgnoreCase(d.getDepartmentName()))
                .findFirst()
                .orElse(null);

        assertNotNull(csDept, "Computer Science department must exist");
        assertNotNull(csDept.getTeachers(), "Teachers list must not be null");
        assertFalse(csDept.getTeachers().isEmpty(), "Computer Science must have faculty instructors");

        boolean foundProfVance = false;
        for (DepartmentSummaryDto.DepartmentTeacherDto teacher : csDept.getTeachers()) {
            assertNotNull(teacher.getFullName());
            assertNotNull(teacher.getEmail());
            assertNotNull(teacher.getIdentifier());
            assertEquals("ACTIVE", teacher.getStatus());

            if (teacher.getIdentifier().contains("ronald.vance")) {
                foundProfVance = true;
                assertTrue(teacher.getQuizCount() >= 1, "Prof. Ronald Vance should have authored quizzes");
            }
        }
        assertTrue(foundProfVance, "Prof. Ronald Vance must be in Computer Science faculty roster");
    }

    @Test
    @DisplayName("Test 3: Verify Top 5 students ranking in Computer Science branch")
    public void testDepartmentTopStudentsRanking() {
        List<DepartmentSummaryDto> summaries = adminService.getDepartmentSummaries();
        DepartmentSummaryDto csDept = summaries.stream()
                .filter(d -> "Computer Science".equalsIgnoreCase(d.getDepartmentName()))
                .findFirst()
                .orElse(null);

        assertNotNull(csDept, "Computer Science department must exist");
        assertNotNull(csDept.getTopStudents(), "Top students list must not be null");
        assertTrue(csDept.getTopStudents().size() <= 5, "Top students list cannot exceed 5 items");

        if (!csDept.getTopStudents().isEmpty()) {
            double prevPercentage = 1000.0;
            int expectedRank = 1;

            for (DepartmentSummaryDto.DepartmentTopStudentDto s : csDept.getTopStudents()) {
                assertEquals(expectedRank++, s.getRank(), "Ranks must be strictly sequential 1, 2, 3...");
                assertNotNull(s.getFullName(), "Student name must not be null");
                assertNotNull(s.getIdentifier(), "Student identifier must not be null");
                assertTrue(s.getAveragePercentage() <= prevPercentage + 0.001,
                        "Students must be ordered descending by average percentage");
                prevPercentage = s.getAveragePercentage();
            }
        }
    }

    @Test
    @DisplayName("Test 4: Verify Department Quizzes list")
    public void testDepartmentQuizzes() {
        List<DepartmentSummaryDto> summaries = adminService.getDepartmentSummaries();
        DepartmentSummaryDto csDept = summaries.stream()
                .filter(d -> "Computer Science".equalsIgnoreCase(d.getDepartmentName()))
                .findFirst()
                .orElse(null);

        assertNotNull(csDept, "Computer Science department must exist");
        assertNotNull(csDept.getQuizzes(), "Quizzes list must not be null");

        for (DepartmentSummaryDto.DepartmentQuizDto q : csDept.getQuizzes()) {
            assertTrue(q.getQuizId() > 0);
            assertNotNull(q.getTitle());
            assertNotNull(q.getTeacherName());
            assertNotNull(q.getStatus());
            assertTrue(q.getTotalMarks() >= 0, "Total marks should be non-negative");
        }
    }
}
