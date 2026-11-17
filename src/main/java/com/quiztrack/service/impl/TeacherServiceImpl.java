package com.quiztrack.service.impl;

import com.quiztrack.dao.AnalyticsDao;
import com.quiztrack.dao.QuestionDao;
import com.quiztrack.dao.QuizDao;
import com.quiztrack.dao.SubjectDao;
import com.quiztrack.dao.impl.AnalyticsDaoImpl;
import com.quiztrack.dao.impl.QuestionDaoImpl;
import com.quiztrack.dao.impl.QuizDaoImpl;
import com.quiztrack.dao.impl.SubjectDaoImpl;
import com.quiztrack.model.Question;
import com.quiztrack.model.QuestionOption;
import com.quiztrack.model.Quiz;
import com.quiztrack.model.Subject;
import com.quiztrack.model.TeacherDashboardData;
import com.quiztrack.service.TeacherService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.math.BigDecimal;
import java.util.List;
import java.util.Optional;

/**
 * Business logic implementation for Teacher operations:
 * - Academic Overview Dashboard
 * - Quiz Lifecycle & Parameter Management
 * - Question Bank Authoring, Editing, and Assignment
 */
public class TeacherServiceImpl implements TeacherService {

    private static final Logger logger = LoggerFactory.getLogger(TeacherServiceImpl.class);

    private final QuizDao quizDao;
    private final AnalyticsDao analyticsDao;
    private final QuestionDao questionDao;
    private final SubjectDao subjectDao;

    public TeacherServiceImpl() {
        this.quizDao = new QuizDaoImpl();
        this.analyticsDao = new AnalyticsDaoImpl();
        this.questionDao = new QuestionDaoImpl();
        this.subjectDao = new SubjectDaoImpl();
    }

    public TeacherServiceImpl(QuizDao quizDao, AnalyticsDao analyticsDao) {
        this.quizDao = quizDao;
        this.analyticsDao = analyticsDao;
        this.questionDao = new QuestionDaoImpl();
        this.subjectDao = new SubjectDaoImpl();
    }

    public TeacherServiceImpl(QuizDao quizDao, QuestionDao questionDao, SubjectDao subjectDao) {
        this.quizDao = quizDao;
        this.analyticsDao = new AnalyticsDaoImpl();
        this.questionDao = questionDao;
        this.subjectDao = subjectDao;
    }

    public TeacherServiceImpl(QuizDao quizDao, AnalyticsDao analyticsDao, QuestionDao questionDao, SubjectDao subjectDao) {
        this.quizDao = quizDao;
        this.analyticsDao = analyticsDao;
        this.questionDao = questionDao;
        this.subjectDao = subjectDao;
    }

    @Override
    public TeacherDashboardData getDashboardOverview(int teacherId) {
        TeacherDashboardData data = new TeacherDashboardData();

        try {
            // 1. Overview KPIs
            data.setTotalStudents(analyticsDao.countTotalStudents());
            data.setActiveQuizzesCount(quizDao.countQuizzesByStatus("ACTIVE"));
            data.setScheduledQuizzesCount(quizDao.countQuizzesByStatus("SCHEDULED"));
            data.setCompletedSessionsCount(analyticsDao.countTotalCompletedSessions());
            data.setAverageClassScore(analyticsDao.calculateAverageClassScore());
            data.setProctorTrustIndex(analyticsDao.getProctorTrustIndex());

            // 2. In-Flight Live Examination Banner
            Optional<Quiz> activeQuizOpt = quizDao.findActiveQuiz();
            if (activeQuizOpt.isPresent()) {
                Quiz activeQuiz = activeQuizOpt.get();
                data.setActiveQuiz(activeQuiz);

                int examinees = analyticsDao.countActiveExaminees(activeQuiz.getQuizId());
                int totalAssigned = analyticsDao.countTotalAssignedStudents(activeQuiz.getQuizId());
                int flagged = analyticsDao.countFlaggedEvents(activeQuiz.getQuizId());

                data.setActiveExaminees(examinees);
                data.setTotalAssignedExaminees(totalAssigned);
                int connectedPct = (totalAssigned > 0) ? (int) Math.round(((double) examinees / totalAssigned) * 100.0) : 93;
                data.setConnectedPercentage(Math.min(100, Math.max(0, connectedPct)));
                data.setLiveFlaggedIncidents(flagged);
                data.setRemainingTimeFormatted("52m remaining");
                data.setTotalFlaggedIncidents(flagged);
            }

            // 3. Concept Mastery Data for the Active Subject (CS402 = Subject ID 1)
            int subjectId = (data.getActiveQuiz() != null) ? data.getActiveQuiz().getSubjectId() : 1;
            data.setTopicMasteryList(analyticsDao.getTopicMasteryStats(subjectId));

            // 4. Cohort Comparisons
            data.setCohortComparisonList(analyticsDao.getCohortComparisonMetrics());

            // 5. Examination Schedule
            List<Quiz> schedule = quizDao.findAllQuizzes();
            data.setExaminationSchedule(schedule);

            // 6. Pending Proctor Audits
            data.setPendingAudits(analyticsDao.getPendingAudits());

            logger.info("Compiled TeacherDashboardData successfully for teacher ID: {}", teacherId);
        } catch (Exception e) {
            logger.error("Error assembling teacher dashboard overview for teacher ID: {}", teacherId, e);
        }

        return data;
    }

    // ==================== QUIZ MANAGEMENT ====================

    @Override
    public Quiz createQuiz(Quiz quiz, int teacherId) {
        validateQuizParameters(quiz);
        quiz.setTeacherId(teacherId);
        int generatedId = quizDao.create(quiz);
        if (generatedId > 0) {
            quiz.setQuizId(generatedId);
            return quiz;
        }
        return null;
    }

    private void validateQuizParameters(Quiz quiz) {
        if (quiz == null) {
            throw new IllegalArgumentException("Quiz payload cannot be null.");
        }
        if (quiz.getTitle() == null || quiz.getTitle().trim().length() < 3) {
            throw new IllegalArgumentException("Quiz title must contain at least 3 characters.");
        }
        if (quiz.getTitle().trim().length() > 255) {
            throw new IllegalArgumentException("Quiz title cannot exceed 255 characters.");
        }
        if (quiz.getSubjectId() <= 0) {
            throw new IllegalArgumentException("A valid course subject must be selected.");
        }
        int maxAllowedDuration = com.quiztrack.util.SystemSettingsHelper.getIntSetting("max_quiz_duration", 180);
        if (quiz.getDurationMinutes() < 1 || quiz.getDurationMinutes() > maxAllowedDuration) {
            throw new IllegalArgumentException("Duration must be between 1 and " + maxAllowedDuration + " minutes.");
        }
        if (quiz.getPassPercentage() != null) {
            double pass = quiz.getPassPercentage().doubleValue();
            if (pass < 0.0 || pass > 100.0) {
                throw new IllegalArgumentException("Passing percentage must be between 0% and 100%.");
            }
        }
        if (quiz.isNegativeMarking() && quiz.getNegativeMarkValue() != null) {
            if (quiz.getNegativeMarkValue().compareTo(BigDecimal.ZERO) < 0) {
                throw new IllegalArgumentException("Negative mark deduction value cannot be negative.");
            }
        }
        if ("SCHEDULED".equalsIgnoreCase(quiz.getStatus())) {
            if (quiz.getStartTime() == null || quiz.getEndTime() == null) {
                throw new IllegalArgumentException("Both start time and end time are required for scheduled examinations.");
            }
        }
        if (quiz.getStartTime() != null && quiz.getEndTime() != null) {
            if (!quiz.getStartTime().before(quiz.getEndTime())) {
                throw new IllegalArgumentException("Examination window start time must be before end time.");
            }
            long windowMinutes = (quiz.getEndTime().getTime() - quiz.getStartTime().getTime()) / (60 * 1000L);
            if (windowMinutes < quiz.getDurationMinutes()) {
                throw new IllegalArgumentException("Schedule window (" + windowMinutes + " min) cannot be shorter than quiz duration (" + quiz.getDurationMinutes() + " min).");
            }
        }
    }

    @Override
    public boolean updateQuiz(Quiz quiz, int teacherId) {
        if (!quizDao.isOwnedBy(quiz.getQuizId(), teacherId)) {
            logger.warn("Unauthorized attempt to update quiz ID: {} by teacher ID: {}", quiz.getQuizId(), teacherId);
            return false;
        }
        quiz.setTeacherId(teacherId);
        return quizDao.update(quiz);
    }

    @Override
    public boolean deleteQuiz(int quizId, int teacherId) {
        if (!quizDao.isOwnedBy(quizId, teacherId)) {
            logger.warn("Unauthorized attempt to delete quiz ID: {} by teacher ID: {}", quizId, teacherId);
            return false;
        }
        return quizDao.delete(quizId, teacherId);
    }

    @Override
    public boolean setQuizStatus(int quizId, int teacherId, String status) {
        if (!quizDao.isOwnedBy(quizId, teacherId)) {
            logger.warn("Unauthorized attempt to change status of quiz ID: {} by teacher ID: {}", quizId, teacherId);
            return false;
        }
        return quizDao.updateStatus(quizId, teacherId, status);
    }

    @Override
    public Optional<Quiz> getQuizById(int quizId) {
        return quizDao.findById(quizId);
    }

    @Override
    public List<Quiz> getQuizzesByTeacher(int teacherId) {
        return quizDao.findQuizzesByTeacher(teacherId);
    }

    @Override
    public boolean isQuizOwnedBy(int quizId, int teacherId) {
        return quizDao.isOwnedBy(quizId, teacherId);
    }

    @Override
    public List<Subject> getAllSubjects() {
        return subjectDao.findAll();
    }

    // ==================== QUESTION BANK & BUILDER ====================

    @Override
    public Question createQuestion(Question question, int teacherId) {
        validateQuestionParameters(question);
        question.setCreatedBy(teacherId);
        int generatedId = questionDao.create(question);
        if (generatedId > 0) {
            question.setQuestionId(generatedId);
            return question;
        }
        return null;
    }

    @Override
    public boolean updateQuestion(Question question, int teacherId) {
        if (!questionDao.isOwnedBy(question.getQuestionId(), teacherId)) {
            logger.warn("Unauthorized attempt to update question ID: {} by teacher ID: {}", question.getQuestionId(), teacherId);
            return false;
        }
        validateQuestionParameters(question);
        return questionDao.update(question);
    }

    private void validateQuestionParameters(Question question) {
        if (question == null) {
            throw new IllegalArgumentException("Question cannot be null");
        }
        if (question.getQuestionText() == null || question.getQuestionText().trim().length() < 3) {
            throw new IllegalArgumentException("Question prompt statement must be at least 3 characters long");
        }
        if (question.getPoints() == null || question.getPoints().compareTo(BigDecimal.ZERO) <= 0) {
            throw new IllegalArgumentException("Question points must be greater than 0");
        }
        String type = question.getQuestionType() != null ? question.getQuestionType() : "SINGLE_CHOICE";
        List<QuestionOption> options = question.getOptions();
        if (options == null || options.size() < 2) {
            throw new IllegalArgumentException("Question must have at least 2 answer choices");
        }
        long correctCount = options.stream().filter(QuestionOption::isCorrect).count();
        if ("SINGLE_CHOICE".equalsIgnoreCase(type) && correctCount != 1) {
            throw new IllegalArgumentException("Single-choice questions must have exactly one correct answer selected");
        }
        if ("TRUE_FALSE".equalsIgnoreCase(type) && (options.size() != 2 || correctCount != 1)) {
            throw new IllegalArgumentException("True/False questions must have exactly two options and one correct answer");
        }
        if ("MULTI_CHOICE".equalsIgnoreCase(type) && correctCount < 1) {
            throw new IllegalArgumentException("Multi-choice questions must have at least one correct answer selected");
        }
    }

    @Override
    public boolean deleteQuestion(int questionId, int teacherId) {
        if (!questionDao.isOwnedBy(questionId, teacherId)) {
            logger.warn("Unauthorized attempt to delete question ID: {} by teacher ID: {}", questionId, teacherId);
            return false;
        }
        return questionDao.delete(questionId, teacherId);
    }

    @Override
    public Optional<Question> getQuestionById(int questionId) {
        return questionDao.findById(questionId);
    }

    @Override
    public List<Question> getQuestionsForQuiz(int quizId) {
        return questionDao.findByQuizId(quizId);
    }

    @Override
    public List<Question> getQuestionBank(Integer subjectId, String difficulty, String topic, String searchQuery, int limit, int offset) {
        return questionDao.findQuestionBank(subjectId, difficulty, topic, searchQuery, limit, offset);
    }

    @Override
    public int countQuestionBank(Integer subjectId, String difficulty, String topic, String searchQuery) {
        return questionDao.countQuestionBank(subjectId, difficulty, topic, searchQuery);
    }

    @Override
    public boolean addQuestionToQuiz(int questionId, int quizId, int teacherId) {
        if (!quizDao.isOwnedBy(quizId, teacherId)) {
            logger.warn("Teacher ID {} cannot add question to quiz ID {} (ownership mismatch)", teacherId, quizId);
            return false;
        }
        return questionDao.addQuestionToQuiz(questionId, quizId, 0, null);
    }

    @Override
    public boolean removeQuestionFromQuiz(int questionId, int quizId, int teacherId) {
        if (!quizDao.isOwnedBy(quizId, teacherId)) {
            logger.warn("Teacher ID {} cannot remove question from quiz ID {} (ownership mismatch)", teacherId, quizId);
            return false;
        }
        return questionDao.removeQuestionFromQuiz(questionId, quizId);
    }

    @Override
    public int duplicateQuestion(int questionId, Integer targetQuizId, int teacherId) {
        if (targetQuizId != null && targetQuizId > 0 && !quizDao.isOwnedBy(targetQuizId, teacherId)) {
            logger.warn("Teacher ID {} cannot duplicate question into quiz ID {}", teacherId, targetQuizId);
            return -1;
        }
        return questionDao.duplicateQuestion(questionId, targetQuizId, teacherId);
    }
}
