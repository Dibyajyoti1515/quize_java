package com.quiztrack.service;

import com.quiztrack.model.StudentDashboardData;
import java.util.List;
import java.util.Optional;

/**
 * Service interface for Student Portal business logic.
 */
public interface StudentService {

    /**
     * Loads aggregated dashboard data for the authenticated student.
     */
    StudentDashboardData getStudentDashboardData(int studentId);

    /**
     * Retrieves assigned quizzes for the student.
     */
    List<StudentDashboardData.StudentQuizCard> getAvailableQuizzes(int studentId);

    /**
     * Retrieves details for a specific quiz pre-flight verification.
     */
    Optional<StudentDashboardData.StudentQuizCard> getQuizDetails(int quizId, int studentId);
}
