package com.quiztrack.dao;

import com.quiztrack.model.Question;
import com.quiztrack.model.QuestionOption;
import com.quiztrack.model.QuizAttempt;
import com.quiztrack.model.StudentAnswer;

import java.util.List;
import java.util.Map;
import java.util.Optional;

/**
 * Data Access Object for Active Examination Engine operations.
 */
public interface ExamDao {

    Optional<QuizAttempt> findActiveAttempt(int quizId, int studentId);

    Optional<QuizAttempt> findAttemptById(int attemptId);

    Optional<QuizAttempt> findSubmittedAttempt(int quizId, int studentId);

    QuizAttempt createAttempt(int quizId, int studentId, String ipAddress, String userAgent);

    boolean isStudentEligible(int quizId, int studentId);

    List<Question> getQuizQuestions(int quizId, boolean shuffle);

    List<QuestionOption> getQuestionOptions(int questionId);

    Map<Integer, StudentAnswer> getStudentAnswersForAttempt(int attemptId);

    boolean saveOrUpdateAnswer(int attemptId, int questionId, Integer selectedOptionId, String textResponse, boolean isFlagged);

    boolean saveOrUpdateAnswer(int attemptId, int questionId, List<Integer> selectedOptionIds, String textResponse, boolean isFlagged);

    boolean toggleFlagForReview(int attemptId, int questionId, boolean isFlagged);

    boolean recordTelemetryEvent(int attemptId, int userId, String eventType, String severity, String details);

    boolean finalizeSubmission(int attemptId, int studentId);
}
