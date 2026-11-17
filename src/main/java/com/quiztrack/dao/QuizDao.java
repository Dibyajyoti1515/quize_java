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

    Optional<Quiz> findById(int quizId);

    int countQuizzesByStatus(String status);

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
     * Updates the lifecycle status of a quiz ('DRAFT', 'SCHEDULED', 'ACTIVE', 'COMPLETED', 'ARCHIVED').
     */
    boolean updateStatus(int quizId, int teacherId, String status);

    /**
     * Verifies whether a quiz belongs to the specified teacher.
     */
    boolean isOwnedBy(int quizId, int teacherId);
}
