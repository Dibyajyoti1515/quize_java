package com.quiztrack.dao;

import com.quiztrack.model.HistoryQuizDto;
import com.quiztrack.model.QuestionReviewDto;
import com.quiztrack.model.StudentResultDto;
import com.quiztrack.model.TopicPerformanceDto;

import java.math.BigDecimal;
import java.util.List;
import java.util.Optional;

/**
 * Data Access Object for Examination Results, Detailed Review, and Cohort Analytics.
 */
public interface ResultDao {

    Optional<StudentResultDto> getResultByAttemptId(int attemptId, int studentId);

    Optional<StudentResultDto> getLatestResultByStudentId(int studentId);

    List<QuestionReviewDto> getQuestionReviews(int attemptId);

    List<TopicPerformanceDto> getTopicPerformances(int attemptId);

    double getCohortAveragePercentage(int quizId);

    int getCohortTotalParticipants(int quizId);

    int calculateCohortRank(int quizId, BigDecimal score);

    List<HistoryQuizDto> getHistoricalResults(int studentId);

    List<StudentResultDto> getAllResultsForStudent(int studentId);

    List<StudentResultDto> getResultsByQuizId(int quizId);
}
