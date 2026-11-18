package com.quiztrack.service.impl;

import com.quiztrack.dao.ExamDao;
import com.quiztrack.dao.impl.ExamDaoImpl;
import com.quiztrack.model.*;
import com.quiztrack.service.ExamService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Map;
import java.util.Optional;

/**
 * Business logic implementation of Candidate Examination Engine.
 * Enforces server-authoritative timer, candidate access boundaries, and response integrity.
 */
public class ExamServiceImpl implements ExamService {

    private static final Logger logger = LoggerFactory.getLogger(ExamServiceImpl.class);
    private final ExamDao examDao;

    public ExamServiceImpl() {
        this.examDao = new ExamDaoImpl();
    }

    public ExamServiceImpl(ExamDao examDao) {
        this.examDao = examDao;
    }

    @Override
    public QuizAttempt startOrResumeExam(int quizId, int studentId, String ipAddress, String userAgent) {
        long now = System.currentTimeMillis();

        // 1. Check for existing in-flight attempt (allow resuming even if entry window has closed, as long as attempt is not expired!)
        Optional<QuizAttempt> activeOpt = examDao.findActiveAttempt(quizId, studentId);
        if (activeOpt.isPresent()) {
            QuizAttempt active = activeOpt.get();
            // Validate server-side timer expiration
            if (active.isExpired(now)) {
                logger.info("Attempt {} has expired on server. Finalizing automatic submission.", active.getAttemptId());
                examDao.finalizeSubmission(active.getAttemptId(), studentId);
                return examDao.findAttemptById(active.getAttemptId()).orElse(active);
            }
            logger.info("Resuming active examination attempt {} for student {}", active.getAttemptId(), studentId);
            return active;
        }

        // 2. Check for previously submitted attempt
        Optional<QuizAttempt> submittedOpt = examDao.findSubmittedAttempt(quizId, studentId);
        if (submittedOpt.isPresent()) {
            logger.warn("Student {} has already submitted an attempt for quiz {}", studentId, quizId);
            throw new IllegalStateException("Examination already completed and submitted. Duplicate attempts forbidden.");
        }

        // 3. Verify eligibility and quiz entry window for starting a new attempt
        if (!examDao.isStudentEligible(quizId, studentId)) {
            logger.warn("Student {} is not eligible or quiz {} entry window is closed.", studentId, quizId);
            throw new SecurityException("Candidate not enrolled or examination entry window is closed.");
        }

        // 4. Create new attempt
        QuizAttempt created = examDao.createAttempt(quizId, studentId, ipAddress, userAgent);
        if (created == null) {
            throw new RuntimeException("Failed to allocate new examination attempt record.");
        }
        logger.info("Allocated new examination attempt {} for student {}", created.getAttemptId(), studentId);
        return created;
    }

    @Override
    public Optional<QuizAttempt> getAttemptById(int attemptId, int studentId) {
        Optional<QuizAttempt> opt = examDao.findAttemptById(attemptId);
        if (opt.isPresent()) {
            if (opt.get().getStudentId() != studentId) {
                logger.warn("Access violation: attempt {} requested by unauthorized student {}", attemptId, studentId);
                return Optional.empty();
            }
        }
        return opt;
    }

    @Override
    public ExamSessionDto getExamSession(int attemptId, int studentId, Integer questionIndex) {
        Optional<QuizAttempt> opt = examDao.findAttemptById(attemptId);
        if (opt.isEmpty() || opt.get().getStudentId() != studentId) {
            throw new SecurityException("Unauthorized access to examination session.");
        }

        QuizAttempt attempt = opt.get();
        long now = System.currentTimeMillis();

        // Check if expired
        if ("IN_PROGRESS".equalsIgnoreCase(attempt.getStatus()) && attempt.isExpired(now)) {
            logger.info("Attempt {} expired during session poll. Finalizing submission.", attemptId);
            examDao.finalizeSubmission(attemptId, studentId);
            attempt = examDao.findAttemptById(attemptId).orElse(attempt);
        }

        // Retrieve questions
        List<Question> rawQuestions = examDao.getQuizQuestions(attempt.getQuizId(), false);
        Map<Integer, StudentAnswer> answersMap = examDao.getStudentAnswersForAttempt(attemptId);

        List<ExamQuestionDto> examQuestions = new ArrayList<>();
        int qNum = 1;

        for (Question q : rawQuestions) {
            ExamQuestionDto dto = new ExamQuestionDto();
            dto.setQuestionId(q.getQuestionId());
            dto.setQuestionNumber(qNum++);
            dto.setQuestionText(q.getQuestionText());
            dto.setQuestionType(q.getQuestionType());
            dto.setPoints(q.getPoints());
            dto.setNegativeMarks(attempt.isNegativeMarking() ? attempt.getNegativeMarkValue() : null);
            dto.setTaxonomyTopic(q.getTaxonomyTopic());
            dto.setCodeSnippet(q.getCodeSnippet());

            // Convert options - CRUCIAL: never pass isCorrect to student!
            List<ExamOptionDto> optDtos = new ArrayList<>();
            for (QuestionOption o : q.getOptions()) {
                optDtos.add(new ExamOptionDto(o.getOptionId(), o.getOptionLetter(), o.getOptionText(), o.getSortOrder()));
            }
            dto.setOptions(optDtos);

            // Populate student's saved state
            StudentAnswer ans = answersMap.get(q.getQuestionId());
            if (ans != null) {
                dto.setSelectedOptionId(ans.getSelectedOptionId());
                dto.setSelectedOptionIds(ans.getSelectedOptionIds());
                dto.setFlaggedForReview(ans.isFlaggedForReview());
            }
            dto.updateStatus();
            examQuestions.add(dto);
        }

        int targetIndex = 0;
        if (questionIndex != null) {
            targetIndex = Math.max(0, Math.min(questionIndex, examQuestions.size() - 1));
        }

        ExamSessionDto session = new ExamSessionDto();
        session.setAttempt(attempt);
        session.setQuestions(examQuestions);
        session.setCurrentQuestionIndex(targetIndex);
        if (!examQuestions.isEmpty()) {
            session.setCurrentQuestion(examQuestions.get(targetIndex));
        }
        session.calculateMetrics(now);

        return session;
    }

    @Override
    public boolean saveAnswer(int attemptId, int studentId, int questionId, Integer selectedOptionId, boolean isFlagged) {
        List<Integer> list = (selectedOptionId != null && selectedOptionId > 0) ? Collections.singletonList(selectedOptionId) : Collections.emptyList();
        return saveAnswer(attemptId, studentId, questionId, list, isFlagged);
    }

    @Override
    public boolean saveAnswer(int attemptId, int studentId, int questionId, List<Integer> selectedOptionIds, boolean isFlagged) {
        Optional<QuizAttempt> opt = examDao.findAttemptById(attemptId);
        if (opt.isEmpty() || opt.get().getStudentId() != studentId) {
            logger.warn("Security rejection: student {} attempted to save answer on attempt {}", studentId, attemptId);
            return false;
        }

        QuizAttempt attempt = opt.get();
        if (!"IN_PROGRESS".equalsIgnoreCase(attempt.getStatus())) {
            logger.warn("Rejected answer save: attempt {} is not IN_PROGRESS (status: {})", attemptId, attempt.getStatus());
            return false;
        }

        long now = System.currentTimeMillis();
        if (attempt.isExpired(now)) {
            logger.info("Attempt {} expired. Finalizing submission instead of saving answer.", attemptId);
            examDao.finalizeSubmission(attemptId, studentId);
            return false;
        }

        return examDao.saveOrUpdateAnswer(attemptId, questionId, selectedOptionIds, null, isFlagged);
    }

    @Override
    public boolean toggleFlag(int attemptId, int studentId, int questionId, boolean isFlagged) {
        Optional<QuizAttempt> opt = examDao.findAttemptById(attemptId);
        if (opt.isEmpty() || opt.get().getStudentId() != studentId) {
            return false;
        }
        return examDao.toggleFlagForReview(attemptId, questionId, isFlagged);
    }

    @Override
    public QuizAttempt submitExam(int attemptId, int studentId) {
        Optional<QuizAttempt> opt = examDao.findAttemptById(attemptId);
        if (opt.isEmpty() || opt.get().getStudentId() != studentId) {
            throw new SecurityException("Unauthorized attempt to submit exam.");
        }

        boolean ok = examDao.finalizeSubmission(attemptId, studentId);
        if (!ok) {
            throw new RuntimeException("Failed to evaluate and finalize examination submission.");
        }
        return examDao.findAttemptById(attemptId).orElse(null);
    }

    @Override
    public boolean recordTelemetry(int attemptId, int studentId, String eventType, String severity, String details) {
        Optional<QuizAttempt> opt = examDao.findAttemptById(attemptId);
        if (opt.isEmpty() || opt.get().getStudentId() != studentId) {
            return false;
        }
        return examDao.recordTelemetryEvent(attemptId, studentId, eventType, severity, details);
    }
}
