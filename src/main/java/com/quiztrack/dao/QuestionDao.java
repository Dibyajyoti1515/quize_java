package com.quiztrack.dao;

import com.quiztrack.model.Question;
import com.quiztrack.model.QuestionOption;
import java.math.BigDecimal;
import java.util.List;
import java.util.Optional;

/**
 * Data Access Object interface for Questions and Question Bank management.
 */
public interface QuestionDao {

    /**
     * Creates a question along with its options, returning generated question_id.
     */
    int create(Question question);

    /**
     * Updates an existing question and its options.
     */
    boolean update(Question question);

    /**
     * Deletes a question and its options if created by the teacher.
     */
    boolean delete(int questionId, int teacherId);

    /**
     * Administratively deletes a question and its options regardless of author.
     */
    boolean delete(int questionId);

    /**
     * Finds a single question with its options by ID.
     */
    Optional<Question> findById(int questionId);

    /**
     * Retrieves all questions assigned to a specific quiz, populated with options.
     */
    List<Question> findByQuizId(int quizId);

    /**
     * Retrieves questions from the Question Bank (both standalone and shared) matching filters.
     */
    List<Question> findQuestionBank(Integer subjectId, String difficulty, String topic, String searchQuery, int limit, int offset);

    /**
     * Counts Question Bank items matching filters.
     */
    int countQuestionBank(Integer subjectId, String difficulty, String topic, String searchQuery);

    /**
     * Assigns or detaches a question to/from a quiz.
     */
    boolean setQuizId(int questionId, Integer quizId);

    /**
     * Adds a question to a quiz via the quiz_questions join table.
     */
    boolean addQuestionToQuiz(int questionId, int quizId, int sortOrder, BigDecimal pointsOverride);

    /**
     * Removes a question from a quiz via the quiz_questions join table.
     */
    boolean removeQuestionFromQuiz(int questionId, int quizId);

    /**
     * Checks if a question is linked to a quiz in quiz_questions.
     */
    boolean isQuestionInQuiz(int questionId, int quizId);

    /**
     * Counts questions linked to a quiz in quiz_questions.
     */
    int countQuestionsInQuiz(int quizId);

    /**
     * Duplicates an existing question and options into a new standalone item or for a quiz.
     */
    int duplicateQuestion(int sourceQuestionId, Integer targetQuizId, int teacherId);

    /**
     * Checks if a question was created by the teacher (or admin).
     */
    boolean isOwnedBy(int questionId, int teacherId);
}
