package com.quiztrack.service.impl;

import com.quiztrack.dao.ResultDao;
import com.quiztrack.dao.impl.ResultDaoImpl;
import com.quiztrack.model.*;
import com.quiztrack.service.ResultService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

/**
 * Service implementation for candidate scorecards, answer review authorization, and analytics aggregation.
 */
public class ResultServiceImpl implements ResultService {

    private static final Logger logger = LoggerFactory.getLogger(ResultServiceImpl.class);
    private final ResultDao resultDao;

    public ResultServiceImpl() {
        this.resultDao = new ResultDaoImpl();
    }

    public ResultServiceImpl(ResultDao resultDao) {
        this.resultDao = resultDao;
    }

    @Override
    public StudentResultDto getExamResult(int attemptId, int studentId) {
        Optional<StudentResultDto> opt = resultDao.getResultByAttemptId(attemptId, studentId);
        if (opt.isEmpty()) {
            logger.warn("Access denied or result not found: attemptId {} for studentId {}", attemptId, studentId);
            throw new SecurityException("Unauthorized access to examination result or session is not submitted.");
        }

        StudentResultDto dto = opt.get();
        enrichResultDetails(dto, studentId);
        return dto;
    }

    @Override
    public StudentResultDto getLatestResult(int studentId) {
        Optional<StudentResultDto> opt = resultDao.getLatestResultByStudentId(studentId);
        if (opt.isEmpty()) {
            return null;
        }

        StudentResultDto dto = opt.get();
        enrichResultDetails(dto, studentId);
        return dto;
    }

    @Override
    public List<StudentResultDto> getResultsHistory(int studentId) {
        return resultDao.getAllResultsForStudent(studentId);
    }

    private void enrichResultDetails(StudentResultDto dto, int studentId) {
        int attemptId = dto.getAttemptId();
        int quizId = dto.getQuizId();

        // 1. Question reviews
        List<QuestionReviewDto> reviews = resultDao.getQuestionReviews(attemptId);
        dto.setQuestionReviews(reviews);

        // 2. Topic performance breakdowns
        List<TopicPerformanceDto> topics = resultDao.getTopicPerformances(attemptId);
        dto.setTopicBreakdowns(topics);

        // Categorize strengths and weaknesses
        List<String> strong = new ArrayList<>();
        List<String> weak = new ArrayList<>();
        for (TopicPerformanceDto t : topics) {
            if (t.getMasteryPercentage() >= 80.0) {
                strong.add(t.getTopicName() + " (" + t.getMasteryPercentage() + "%)");
            } else if (t.getMasteryPercentage() < 60.0) {
                weak.add(t.getTopicName() + " (" + t.getMasteryPercentage() + "%)");
            }
        }
        dto.setStrongTopics(strong);
        dto.setWeakTopics(weak);

        // 3. Cohort comparisons
        double avgPct = resultDao.getCohortAveragePercentage(quizId);
        dto.setCohortAveragePercentage(avgPct);

        int totalParticipants = resultDao.getCohortTotalParticipants(quizId);
        dto.setCohortTotalStudents(totalParticipants);

        if (dto.getCohortRank() <= 0) {
            int calculatedRank = resultDao.calculateCohortRank(quizId, dto.getScore());
            dto.setCohortRank(calculatedRank);
            if (totalParticipants > 0) {
                double pctl = ((double) (totalParticipants - calculatedRank) / (double) totalParticipants) * 100.0;
                dto.setCohortPercentile(Math.round(pctl * 10.0) / 10.0);
            }
        }

        // 4. Historical exam performance
        List<HistoryQuizDto> history = resultDao.getHistoricalResults(studentId);
        dto.setHistoricalQuizzes(history);
    }
}
