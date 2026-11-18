package com.quiztrack.dao;

import com.quiztrack.model.Cohort;
import com.quiztrack.model.QuizAssignment;
import com.quiztrack.model.User;
import java.sql.Timestamp;
import java.util.List;

/**
 * Data Access Object interface for Quiz Assignments, Cohorts, and Target Slates.
 */
public interface QuizAssignmentDao {

    List<QuizAssignment> findByQuizId(int quizId);

    int countAssignmentsForQuiz(int quizId);

    boolean assignQuizToCohort(int quizId, int cohortId, Timestamp dueAt);

    boolean assignQuizToStudent(int quizId, int studentId, Timestamp dueAt);

    boolean removeAssignment(int assignmentId, int quizId);

    boolean isCohortAssigned(int quizId, int cohortId);

    boolean isStudentAssigned(int quizId, int studentId);

    List<Cohort> findAvailableCohorts(String department);

    List<User> findAvailableStudents(String department);
}
