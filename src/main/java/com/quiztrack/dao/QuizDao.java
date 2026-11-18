package com.quiztrack.dao;

import com.quiztrack.model.Quiz;
import java.util.List;
import java.util.Optional;

/**
 * Data Access Object interface for Quizzes.
 */
public interface QuizDao {

    List<Quiz> findAllQuizzes();

    List<Quiz> findQuizzesByTeacher(int teacherId);

    Optional<Quiz> findActiveQuiz();

    Optional<Quiz> findActiveQuizByTeacher(int teacherId);

    Optional<Quiz> findById(int quizId);

    int countQuizzesByStatus(String status);

    int countQuizzesByStatusAndTeacher(String status, int teacherId);

    int countTotalQuizzes();

    /**
     * Creates a new quiz record in PostgreSQL and returns the generated quiz_id.
     */
    int create(Quiz quiz);

    /**
     * Updates quiz metadata, scheduling, scoring, and proctoring rules.
     */
    boolean update(Quiz quiz);

    /**
     * Deletes a quiz if owned by the specified teacher.
     */
    boolean delete(int quizId, int teacherId);

    /**
     * Administratively deletes a quiz regardless of author.
     */
    boolean delete(int quizId);

    /**
     * Updates the lifecycle status of a quiz ('DRAFT', 'SCHEDULED', 'ACTIVE', 'COMPLETED', 'ARCHIVED').
     */
    boolean updateStatus(int quizId, int teacherId, String status);

    /**
     * Administratively updates the lifecycle status of a quiz.
     */
    boolean updateStatus(int quizId, String status);

    /**
     * Automatically synchronizes time-driven status lifecycle across all quizzes:
     * - Transitions SCHEDULED to ACTIVE when start_time has arrived.
     * - Transitions ACTIVE/SCHEDULED to COMPLETED when end_time has passed.
     * Returns the total count of transitioned quiz records.
     */
    int syncQuizStatusLifecycle();

    /**
     * Synchronizes quizzes.total_marks with the sum of question points from quiz_questions.
     */
    boolean syncTotalMarks(int quizId);

    /**
     * Verifies whether a quiz belongs to the specified teacher.
     */
    boolean isOwnedBy(int quizId, int teacherId);
}
