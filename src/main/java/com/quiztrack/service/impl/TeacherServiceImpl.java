package com.quiztrack.service.impl;

import com.quiztrack.dao.AnalyticsDao;
import com.quiztrack.dao.QuestionDao;
import com.quiztrack.dao.QuizAssignmentDao;
import com.quiztrack.dao.QuizDao;
import com.quiztrack.dao.ResultDao;
import com.quiztrack.dao.SubjectDao;
import com.quiztrack.dao.UserDao;
import com.quiztrack.dao.impl.AnalyticsDaoImpl;
import com.quiztrack.dao.impl.QuestionDaoImpl;
import com.quiztrack.dao.impl.QuizAssignmentDaoImpl;
import com.quiztrack.dao.impl.QuizDaoImpl;
import com.quiztrack.dao.impl.ResultDaoImpl;
import com.quiztrack.dao.impl.SubjectDaoImpl;
import com.quiztrack.dao.impl.UserDaoImpl;
import com.quiztrack.model.Cohort;
import com.quiztrack.model.Question;
import com.quiztrack.model.QuestionOption;
import com.quiztrack.model.Quiz;
import com.quiztrack.model.QuizAssignment;
import com.quiztrack.model.StudentResultDto;
import com.quiztrack.model.Subject;
import com.quiztrack.model.TeacherDashboardData;
import com.quiztrack.model.User;
import com.quiztrack.service.TeacherService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.math.BigDecimal;
import java.sql.Timestamp;
import java.util.Collections;
import java.util.List;
import java.util.Optional;

/**
 * Business logic implementation for Teacher operations:
 * - Academic Overview Dashboard
 * - Quiz Lifecycle & Parameter Management
 * - Question Bank Authoring, Editing, and Assignment
 * - Cohort and Student Quiz Assignment (B1)
 */
public class TeacherServiceImpl implements TeacherService {

    private static final Logger logger = LoggerFactory.getLogger(TeacherServiceImpl.class);

    private final QuizDao quizDao;
    private final AnalyticsDao analyticsDao;
    private final QuestionDao questionDao;
    private final SubjectDao subjectDao;
    private final QuizAssignmentDao quizAssignmentDao;
    private final UserDao userDao;
    private final ResultDao resultDao;

    public TeacherServiceImpl() {
        this.quizDao = new QuizDaoImpl();
        this.analyticsDao = new AnalyticsDaoImpl();
        this.questionDao = new QuestionDaoImpl();
        this.subjectDao = new SubjectDaoImpl();
        this.quizAssignmentDao = new QuizAssignmentDaoImpl();
        this.userDao = new UserDaoImpl();
        this.resultDao = new ResultDaoImpl();
    }

    public TeacherServiceImpl(QuizDao quizDao, AnalyticsDao analyticsDao) {
        this.quizDao = quizDao;
        this.analyticsDao = analyticsDao;
        this.questionDao = new QuestionDaoImpl();
        this.subjectDao = new SubjectDaoImpl();
        this.quizAssignmentDao = new QuizAssignmentDaoImpl();
        this.userDao = new UserDaoImpl();
        this.resultDao = new ResultDaoImpl();
    }

    public TeacherServiceImpl(QuizDao quizDao, QuestionDao questionDao, SubjectDao subjectDao) {
        this.quizDao = quizDao;
        this.analyticsDao = new AnalyticsDaoImpl();
        this.questionDao = questionDao;
        this.subjectDao = subjectDao;
        this.quizAssignmentDao = new QuizAssignmentDaoImpl();
        this.userDao = new UserDaoImpl();
        this.resultDao = new ResultDaoImpl();
    }

    public TeacherServiceImpl(QuizDao quizDao, AnalyticsDao analyticsDao, QuestionDao questionDao, SubjectDao subjectDao) {
        this.quizDao = quizDao;
        this.analyticsDao = analyticsDao;
        this.questionDao = questionDao;
        this.subjectDao = subjectDao;
        this.quizAssignmentDao = new QuizAssignmentDaoImpl();
        this.userDao = new UserDaoImpl();
        this.resultDao = new ResultDaoImpl();
    }

    public TeacherServiceImpl(QuizDao quizDao, AnalyticsDao analyticsDao, QuestionDao questionDao, SubjectDao subjectDao, QuizAssignmentDao quizAssignmentDao, UserDao userDao) {
        this.quizDao = quizDao;
        this.analyticsDao = analyticsDao;
        this.questionDao = questionDao;
        this.subjectDao = subjectDao;
        this.quizAssignmentDao = quizAssignmentDao;
        this.userDao = userDao;
        this.resultDao = new ResultDaoImpl();
    }

    @Override
    public TeacherDashboardData getDashboardOverview(int teacherId) {
        TeacherDashboardData data = new TeacherDashboardData();

        try {
            Optional<User> userOpt = userDao.findById(teacherId);
            boolean isAdmin = userOpt.isPresent() && userOpt.get().isAdmin();

            // 1. Overview KPIs
            data.setTotalStudents(analyticsDao.countTotalStudents());
            data.setActiveQuizzesCount(isAdmin ? quizDao.countQuizzesByStatus("ACTIVE") : quizDao.countQuizzesByStatusAndTeacher("ACTIVE", teacherId));
            data.setScheduledQuizzesCount(isAdmin ? quizDao.countQuizzesByStatus("SCHEDULED") : quizDao.countQuizzesByStatusAndTeacher("SCHEDULED", teacherId));
            data.setCompletedSessionsCount(analyticsDao.countTotalCompletedSessions());
            data.setAverageClassScore(analyticsDao.calculateAverageClassScore());
            data.setProctorTrustIndex(analyticsDao.getProctorTrustIndex());

            // 2. In-Flight Live Examination Banner (truthful teacher-scoped or admin active quiz - B13)
            Optional<Quiz> activeQuizOpt = isAdmin ? quizDao.findActiveQuiz() : quizDao.findActiveQuizByTeacher(teacherId);
            if (activeQuizOpt.isPresent()) {
                Quiz activeQuiz = activeQuizOpt.get();
                data.setActiveQuiz(activeQuiz);

                int examinees = analyticsDao.countActiveExaminees(activeQuiz.getQuizId());
                int totalAssigned = analyticsDao.countTotalAssignedStudents(activeQuiz.getQuizId());
                int flagged = analyticsDao.countFlaggedEvents(activeQuiz.getQuizId());

                data.setActiveExaminees(examinees);
                data.setTotalAssignedExaminees(totalAssigned);

                // Connected %: truthful calculation without fake 93 fallback (B13)
                int connectedPct = (totalAssigned > 0) ? (int) Math.round(((double) examinees / totalAssigned) * 100.0) : 0;
                data.setConnectedPercentage(Math.min(100, Math.max(0, connectedPct)));
                data.setLiveFlaggedIncidents(flagged);
                data.setTotalFlaggedIncidents(flagged);

                // Remaining time: dynamic calculation without hardcoded fake "52m remaining" (B13)
                if (activeQuiz.getEndTime() != null) {
                    long remainingMillis = activeQuiz.getEndTime().getTime() - System.currentTimeMillis();
                    if (remainingMillis > 0) {
                        long totalMinutes = remainingMillis / (60 * 1000);
                        long hours = totalMinutes / 60;
                        long minutes = totalMinutes % 60;
                        String remainingStr = (hours > 0 ? (hours + "h ") : "") + minutes + "m remaining";
                        data.setRemainingTimeFormatted(remainingStr);
                    } else {
                        data.setRemainingTimeFormatted("Session concluding");
                    }
                } else if (activeQuiz.getDurationMinutes() > 0) {
                    data.setRemainingTimeFormatted(activeQuiz.getDurationMinutes() + "m duration");
                } else {
                    data.setRemainingTimeFormatted("In Progress");
                }
            }

            // 3. Concept Mastery Data for the Active or Primary Subject (without hardcoded subject ID 1 - B13)
            int subjectId = 0;
            if (data.getActiveQuiz() != null) {
                subjectId = data.getActiveQuiz().getSubjectId();
            } else {
                List<Quiz> teacherQuizzes = quizDao.findQuizzesByTeacher(teacherId);
                if (!teacherQuizzes.isEmpty()) {
                    subjectId = teacherQuizzes.get(0).getSubjectId();
                } else {
                    List<Subject> subjects = subjectDao.findAll();
                    if (!subjects.isEmpty()) {
                        subjectId = subjects.get(0).getSubjectId();
                    }
                }
            }
            data.setTopicMasteryList((subjectId > 0) ? analyticsDao.getTopicMasteryStats(subjectId) : Collections.emptyList());

            // 4. Cohort Comparisons
            data.setCohortComparisonList(analyticsDao.getCohortComparisonMetrics());

            // 5. Examination Schedule: truthfully scoped to current teacher's quizzes, or all if Admin (B13)
            List<Quiz> schedule = isAdmin ? quizDao.findAllQuizzes() : quizDao.findQuizzesByTeacher(teacherId);
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
        }
    }

    @Override
    public boolean updateQuiz(Quiz quiz, int teacherId) {
        if (!quizDao.isOwnedBy(quiz.getQuizId(), teacherId)) {
            logger.warn("Unauthorized attempt to update quiz ID: {} by teacher ID: {}", quiz.getQuizId(), teacherId);
            return false;
        }
        Optional<Quiz> existingOpt = quizDao.findById(quiz.getQuizId());
        if (existingOpt.isEmpty()) {
            return false;
        }
        Quiz existing = existingOpt.get();
        if (existing.hasActiveOrPastAttempts()) {
            boolean changedCritical = existing.getDurationMinutes() != quiz.getDurationMinutes()
                    || existing.isNegativeMarking() != quiz.isNegativeMarking()
                    || (existing.getPassPercentage() != null && quiz.getPassPercentage() != null && existing.getPassPercentage().compareTo(quiz.getPassPercentage()) != 0);
            if (changedCritical) {
                throw new IllegalArgumentException("Core parameters (duration, pass %, negative marking) cannot be altered once student examinee attempts exist.");
            }
        }

        validateQuizParameters(quiz);
        quiz.setTeacherId(teacherId);
        boolean updated = quizDao.update(quiz);
        if (updated && quiz.getQuizId() > 3) {
            quizDao.syncTotalMarks(quiz.getQuizId());
        }
        return updated;
    }

    @Override
    public void validateQuizForPublish(int quizId, int teacherId) {
        Optional<Quiz> quizOpt = quizDao.findById(quizId);
        if (quizOpt.isEmpty()) {
            throw new IllegalArgumentException("Examination not found.");
        }
        Quiz quiz = quizOpt.get();
        if (!quizDao.isOwnedBy(quizId, teacherId)) {
            throw new IllegalArgumentException("Unauthorized: You do not have permission to publish this examination.");
        }

        // 1. Question count check
        List<Question> questions = questionDao.findByQuizId(quizId);
        if (questions == null || questions.isEmpty()) {
            throw new IllegalArgumentException("Cannot publish: Examination must contain at least 1 question.");
        }

        // 2. Validate options and correctness for each question
        for (int i = 0; i < questions.size(); i++) {
            Question q = questions.get(i);
            int qNum = i + 1;
            if (q.getPoints() == null || q.getPoints().compareTo(BigDecimal.ZERO) <= 0) {
                throw new IllegalArgumentException("Question #" + qNum + " has invalid points (must be greater than 0).");
            }
            List<QuestionOption> options = q.getOptions();
            if (options == null || options.size() < 2) {
                throw new IllegalArgumentException("Question #" + qNum + " must have at least 2 answer choices.");
            }
            long correctCount = options.stream().filter(QuestionOption::isCorrect).count();
            String type = q.getQuestionType() != null ? q.getQuestionType().toUpperCase() : "SINGLE_CHOICE";
            if ("SINGLE_CHOICE".equals(type) && correctCount != 1) {
                throw new IllegalArgumentException("Question #" + qNum + " must have exactly one correct answer selected.");
            } else if ("TRUE_FALSE".equals(type) && (options.size() != 2 || correctCount != 1)) {
                throw new IllegalArgumentException("Question #" + qNum + " (True/False) must have exactly two choices and one correct answer.");
            } else if ("MULTI_CHOICE".equals(type) && correctCount < 1) {
                throw new IllegalArgumentException("Question #" + qNum + " (Multi-Choice) must have at least one correct answer selected.");
            }
        }

        // 3. Duration bounds
        int maxAllowedDuration = com.quiztrack.util.SystemSettingsHelper.getIntSetting("max_quiz_duration", 180);
        if (quiz.getDurationMinutes() < 1 || quiz.getDurationMinutes() > maxAllowedDuration) {
            throw new IllegalArgumentException("Duration must be between 1 and " + maxAllowedDuration + " minutes.");
        }

        // 4. Schedule window checks
        Timestamp now = new Timestamp(System.currentTimeMillis());
        if (quiz.getEndTime() != null && quiz.getEndTime().before(now)) {
            throw new IllegalArgumentException("Cannot publish: Examination scheduled end time has already elapsed.");
        }
        if (quiz.getStartTime() != null && quiz.getEndTime() != null) {
            if (!quiz.getStartTime().before(quiz.getEndTime())) {
                throw new IllegalArgumentException("Examination window start time must be before end time.");
            }
        }

        // 5. Assignment target check (at least 1 cohort or student assigned)
        int assignmentCount = quizAssignmentDao.countAssignmentsForQuiz(quizId);
        if (assignmentCount == 0) {
            throw new IllegalArgumentException("Cannot publish: You must assign the examination to at least one cohort or student before publishing.");
        }

        // 6. Synchronize aggregate marks for authored quizzes
        if (quizId > 3) {
            quizDao.syncTotalMarks(quizId);
        }
    }

    @Override
    public boolean syncTotalMarks(int quizId) {
        return quizDao.syncTotalMarks(quizId);
    }

    @Override
    public boolean deleteQuiz(int quizId, int teacherId) {
        if (!isQuizOwnedBy(quizId, teacherId)) {
            logger.warn("Unauthorized attempt to delete quiz ID: {} by teacher ID: {}", quizId, teacherId);
            return false;
        }
        Optional<User> uOpt = userDao.findById(teacherId);
        if (uOpt.isPresent() && uOpt.get().isAdmin()) {
            return quizDao.delete(quizId);
        }
        return quizDao.delete(quizId, teacherId);
    }

    @Override
    public boolean setQuizStatus(int quizId, int teacherId, String status) {
        if (!isQuizOwnedBy(quizId, teacherId)) {
            logger.warn("Unauthorized attempt to change status of quiz ID: {} by teacher ID: {}", quizId, teacherId);
            return false;
        }
        Optional<User> uOpt = userDao.findById(teacherId);
        if (uOpt.isPresent() && uOpt.get().isAdmin()) {
            return quizDao.updateStatus(quizId, status);
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
    public List<Quiz> getAllQuizzes() {
        return quizDao.findAllQuizzes();
    }

    @Override
    public boolean isQuizOwnedBy(int quizId, int teacherId) {
        Optional<User> uOpt = userDao.findById(teacherId);
        if (uOpt.isPresent() && uOpt.get().isAdmin()) {
            return quizDao.findById(quizId).isPresent();
        }
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
            if (question.getQuizId() != null && question.getQuizId() > 3) {
                quizDao.syncTotalMarks(question.getQuizId());
            }
            return question;
        }
        return null;
    }

    @Override
    public boolean updateQuestion(Question question, int teacherId) {
        Optional<User> uOpt = userDao.findById(teacherId);
        boolean isAdmin = uOpt.isPresent() && uOpt.get().isAdmin();
        if (!isAdmin && !questionDao.isOwnedBy(question.getQuestionId(), teacherId)) {
            logger.warn("Unauthorized attempt to update question ID: {} by teacher ID: {}", question.getQuestionId(), teacherId);
            return false;
        }
        validateQuestionParameters(question);
        boolean updated = questionDao.update(question);
        if (updated && question.getQuizId() != null && question.getQuizId() > 3) {
            quizDao.syncTotalMarks(question.getQuizId());
        }
        return updated;
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
        Optional<User> uOpt = userDao.findById(teacherId);
        boolean isAdmin = uOpt.isPresent() && uOpt.get().isAdmin();
        if (!isAdmin && !questionDao.isOwnedBy(questionId, teacherId)) {
            logger.warn("Unauthorized attempt to delete question ID: {} by teacher ID: {}", questionId, teacherId);
            return false;
        }
        if (isAdmin) {
            return questionDao.delete(questionId);
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
        if (!isQuizOwnedBy(quizId, teacherId)) {
            logger.warn("Teacher ID {} cannot add question to quiz ID {} (ownership mismatch)", teacherId, quizId);
            return false;
        }
        boolean added = questionDao.addQuestionToQuiz(questionId, quizId, 0, null);
        if (added && quizId > 3) {
            quizDao.syncTotalMarks(quizId);
        }
        return added;
    }

    @Override
    public boolean removeQuestionFromQuiz(int questionId, int quizId, int teacherId) {
        if (!isQuizOwnedBy(quizId, teacherId)) {
            logger.warn("Teacher ID {} cannot remove question from quiz ID {} (ownership mismatch)", teacherId, quizId);
            return false;
        }
        boolean removed = questionDao.removeQuestionFromQuiz(questionId, quizId);
        if (removed && quizId > 3) {
            quizDao.syncTotalMarks(quizId);
        }
        return removed;
    }

    @Override
    public int duplicateQuestion(int questionId, Integer targetQuizId, int teacherId) {
        if (targetQuizId != null && targetQuizId > 0 && !isQuizOwnedBy(targetQuizId, teacherId)) {
            logger.warn("Teacher ID {} cannot duplicate question into quiz ID {}", teacherId, targetQuizId);
            return -1;
        }
        int newId = questionDao.duplicateQuestion(questionId, targetQuizId, teacherId);
        if (newId > 0 && targetQuizId != null && targetQuizId > 3) {
            quizDao.syncTotalMarks(targetQuizId);
        }
        return newId;
    }

    @Override
    public List<QuizAssignment> getQuizAssignments(int quizId, int teacherId) {
        if (!quizDao.isOwnedBy(quizId, teacherId)) {
            logger.warn("Teacher ID {} unauthorized access to quiz assignments for quiz {}", teacherId, quizId);
            return Collections.emptyList();
        }
        return quizAssignmentDao.findByQuizId(quizId);
    }

    @Override
    public boolean assignQuizToCohort(int quizId, int cohortId, Timestamp dueAt, int teacherId) {
        if (!quizDao.isOwnedBy(quizId, teacherId)) {
            logger.warn("Teacher ID {} unauthorized attempt to assign cohort to quiz {}", teacherId, quizId);
            return false;
        }
        return quizAssignmentDao.assignQuizToCohort(quizId, cohortId, dueAt);
    }

    @Override
    public boolean assignQuizToStudent(int quizId, int studentId, Timestamp dueAt, int teacherId) {
        if (!quizDao.isOwnedBy(quizId, teacherId)) {
            logger.warn("Teacher ID {} unauthorized attempt to assign student to quiz {}", teacherId, quizId);
            return false;
        }
        return quizAssignmentDao.assignQuizToStudent(quizId, studentId, dueAt);
    }

    @Override
    public boolean removeQuizAssignment(int assignmentId, int quizId, int teacherId) {
        if (!quizDao.isOwnedBy(quizId, teacherId)) {
            logger.warn("Teacher ID {} unauthorized attempt to remove assignment from quiz {}", teacherId, quizId);
            return false;
        }
        return quizAssignmentDao.removeAssignment(assignmentId, quizId);
    }

    @Override
    public List<Cohort> getAvailableCohortsForTeacher(int teacherId) {
        Optional<User> teacherOpt = userDao.findById(teacherId);
        String dept = null;
        if (teacherOpt.isPresent()) {
            User teacher = teacherOpt.get();
            if (teacher.getRoleId() != 1) { // If not ADMIN, scope to teacher's department
                dept = teacher.getDepartment();
            }
        }
        return quizAssignmentDao.findAvailableCohorts(dept);
    }

    @Override
    public List<User> getAvailableStudentsForTeacher(int teacherId) {
        Optional<User> teacherOpt = userDao.findById(teacherId);
        String dept = null;
        if (teacherOpt.isPresent()) {
            User teacher = teacherOpt.get();
            if (teacher.getRoleId() != 1) { // If not ADMIN, scope to teacher's department
                dept = teacher.getDepartment();
            }
        }
        return quizAssignmentDao.findAvailableStudents(dept);
    }

    @Override
    public List<StudentResultDto> getQuizPerformanceReport(int quizId, int teacherId) {
        if (!quizDao.isOwnedBy(quizId, teacherId)) {
            logger.warn("Teacher {} is not authorized to view performance report for quiz {}", teacherId, quizId);
            return Collections.emptyList();
        }
        return resultDao.getResultsByQuizId(quizId);
    }
}
