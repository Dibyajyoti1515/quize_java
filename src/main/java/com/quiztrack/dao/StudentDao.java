package com.quiztrack.dao;

import com.quiztrack.model.StudentDashboardData;
import java.util.List;
import java.util.Optional;

/**
 * Data Access Object interface for Student portal data retrieval.
 */
public interface StudentDao {

    /**
     * Retrieves all quizzes assigned to the student (either directly or via enrolled cohorts).
     */
    List<StudentDashboardData.StudentQuizCard> getAssignedQuizzes(int studentId);

    /**
     * Retrieves the latest verified result and certificate record for the student.
     */
    Optional<StudentDashboardData.LatestResult> getLatestResult(int studentId);

    /**
     * Retrieves curricular subject mastery progress for the student.
     */
    List<StudentDashboardData.SubjectMastery> getSubjectMastery(int studentId);

    /**
     * Counts unread notifications for the student.
     */
    int countUnreadNotifications(int studentId);

    /**
     * Populates diagnostic KPIs (attempts count, cumulative score, cohort standing, integrity index) for the student.
     */
    void populateStudentKPIs(int studentId, StudentDashboardData data);
}
