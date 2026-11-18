package com.quiztrack.controller.teacher;

import com.quiztrack.model.Cohort;
import com.quiztrack.model.Question;
import com.quiztrack.model.QuestionOption;
import com.quiztrack.model.Quiz;
import com.quiztrack.model.QuizAssignment;
import com.quiztrack.model.Subject;
import com.quiztrack.model.User;
import com.quiztrack.service.TeacherService;
import com.quiztrack.service.impl.TeacherServiceImpl;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Optional;
import java.util.Set;

/**
 * Main Controller for Quiz Creation, Multi-Option Question Builder, and Item Bank Matrix.
 * Faithfully maps to the Stitch 'teacher_quiz_creation_question_bank' interface.
 */
@WebServlet(name = "TeacherQuizBuilderServlet", urlPatterns = {"/teacher/quiz/builder", "/teacher/create-quiz"})
public class TeacherQuizBuilderServlet extends HttpServlet {

    private static final Logger logger = LoggerFactory.getLogger(TeacherQuizBuilderServlet.class);
    private final TeacherService teacherService;

    public TeacherQuizBuilderServlet() {
        this.teacherService = new TeacherServiceImpl();
    }

    public TeacherQuizBuilderServlet(TeacherService teacherService) {
        this.teacherService = teacherService;
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/auth/login");
            return;
        }

        int teacherId = (Integer) session.getAttribute("userId");
        String quizIdStr = request.getParameter("quizId");
        int quizId = -1;

        if (quizIdStr != null && !quizIdStr.trim().isEmpty()) {
            try {
                quizId = Integer.parseInt(quizIdStr.trim());
            } catch (NumberFormatException ignored) {}
        }

        // If no quizId specified, take the first available quiz by this teacher or fallback
        List<Quiz> teacherQuizzes = teacherService.getQuizzesByTeacher(teacherId);
        if (quizId <= 0 && !teacherQuizzes.isEmpty()) {
            quizId = teacherQuizzes.get(0).getQuizId();
        }

        if (quizId <= 0) {
            // No quizzes yet for this teacher, redirect to quiz creation
            response.sendRedirect(request.getContextPath() + "/teacher/quiz/create");
            return;
        }

        Optional<Quiz> quizOpt = teacherService.getQuizById(quizId);
        if (quizOpt.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/teacher/quizzes");
            return;
        }

        Quiz quiz = quizOpt.get();

        // Flash Messages extraction
        String flashSuccess = (String) session.getAttribute("flashSuccess");
        if (flashSuccess != null) {
            request.setAttribute("flashSuccess", flashSuccess);
            session.removeAttribute("flashSuccess");
        }
        String flashError = (String) session.getAttribute("flashError");
        if (flashError != null) {
            request.setAttribute("flashError", flashError);
            session.removeAttribute("flashError");
        }

        // Load quiz questions
        List<Question> quizQuestions = teacherService.getQuestionsForQuiz(quizId);
        Set<Integer> quizQuestionIds = new HashSet<>();
        for (Question q : quizQuestions) {
            quizQuestionIds.add(q.getQuestionId());
        }

        // Load question bank repository (for this subject or all branches)
        String bankSearch = request.getParameter("bankSearch");
        String bankDifficulty = request.getParameter("bankDifficulty");
        String bankSubjectIdStr = request.getParameter("bankSubjectId");
        Integer bankSubjectId = null;
        if (bankSubjectIdStr != null && !bankSubjectIdStr.trim().isEmpty() && !"ALL".equalsIgnoreCase(bankSubjectIdStr.trim())) {
            try {
                bankSubjectId = Integer.parseInt(bankSubjectIdStr.trim());
            } catch (NumberFormatException ignored) {}
        } else if (bankSubjectIdStr == null) {
            bankSubjectId = quiz.getSubjectId();
        }

        List<Question> bankQuestions = teacherService.getQuestionBank(bankSubjectId, bankDifficulty, null, bankSearch, 50, 0);
        for (Question bq : bankQuestions) {
            bq.setInCurrentQuiz(quizQuestionIds.contains(bq.getQuestionId()));
        }

        // Active question selection
        String activeQIdStr = request.getParameter("activeQuestionId");
        boolean isNewItem = "0".equals(activeQIdStr) || "true".equalsIgnoreCase(request.getParameter("new"));
        int activeQId = -1;
        if (!isNewItem && activeQIdStr != null && !activeQIdStr.trim().isEmpty()) {
            try {
                activeQId = Integer.parseInt(activeQIdStr.trim());
            } catch (NumberFormatException ignored) {}
        }

        Question activeQuestion = null;
        if (activeQId > 0) {
            for (Question q : quizQuestions) {
                if (q.getQuestionId() == activeQId) {
                    activeQuestion = q;
                    break;
                }
            }
            if (activeQuestion == null) {
                Optional<Question> qOpt = teacherService.getQuestionById(activeQId);
                if (qOpt.isPresent()) {
                    activeQuestion = qOpt.get();
                }
            }
        }

        if (activeQuestion == null && !isNewItem && !quizQuestions.isEmpty()) {
            activeQuestion = quizQuestions.get(0);
        } else if (activeQuestion == null || isNewItem) {
            // New blank question template
            activeQuestion = new Question();
            activeQuestion.setQuestionId(0);
            activeQuestion.setQuizId(quizId);
            activeQuestion.setSubjectId(quiz.getSubjectId());
            activeQuestion.setQuestionType("SINGLE_CHOICE");
            activeQuestion.setPoints(new BigDecimal("4.00"));
            activeQuestion.setDifficultyLevel("MEDIUM");
            activeQuestion.setQuestionText("");
            activeQuestion.setTaxonomyTopic("");
            activeQuestion.setExplanation("");
            activeQuestion.setCodeSnippet("");
            activeQuestion.setOptions(createBlankOptions("SINGLE_CHOICE"));
        }

        // Calculate distribution metrics
        int mcqCount = 0;
        int multiCount = 0;
        int tfCount = 0;
        BigDecimal allocatedPoints = BigDecimal.ZERO;

        for (Question q : quizQuestions) {
            allocatedPoints = allocatedPoints.add(q.getPoints() != null ? q.getPoints() : BigDecimal.ZERO);
            String type = q.getQuestionType();
            if ("MULTI_CHOICE".equalsIgnoreCase(type)) multiCount++;
            else if ("TRUE_FALSE".equalsIgnoreCase(type)) tfCount++;
            else mcqCount++;
        }

        // Auto-compute total marks from question points for teacher authored quizzes (read-only in builder)
        if (quizId > 3 && (quiz.getTotalMarks() == null || quiz.getTotalMarks().compareTo(allocatedPoints) != 0)) {
            quiz.setTotalMarks(allocatedPoints);
            teacherService.syncTotalMarks(quizId);
        }

        List<Subject> subjects = teacherService.getAllSubjects();
        List<QuizAssignment> assignedSlates = teacherService.getQuizAssignments(quizId, teacherId);
        List<Cohort> availableCohorts = teacherService.getAvailableCohortsForTeacher(teacherId);
        List<User> availableStudents = teacherService.getAvailableStudentsForTeacher(teacherId);

        request.setAttribute("quiz", quiz);
        request.setAttribute("quizQuestions", quizQuestions);
        request.setAttribute("quizQuestionIds", quizQuestionIds);
        request.setAttribute("bankQuestions", bankQuestions);
        request.setAttribute("activeQuestion", activeQuestion);
        request.setAttribute("isNewItem", isNewItem);
        request.setAttribute("subjects", subjects);
        request.setAttribute("allocatedPoints", allocatedPoints);
        request.setAttribute("mcqCount", mcqCount);
        request.setAttribute("multiCount", multiCount);
        request.setAttribute("tfCount", tfCount);
        request.setAttribute("assignedSlates", assignedSlates);
        request.setAttribute("availableCohorts", availableCohorts);
        request.setAttribute("availableStudents", availableStudents);

        String activeTab = request.getParameter("tab");
        if (activeTab == null || activeTab.trim().isEmpty()) {
            activeTab = "questions";
        }
        request.setAttribute("activeTab", activeTab);

        request.getRequestDispatcher("/WEB-INF/views/teacher/quiz-builder.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/auth/login");
            return;
        }

        int teacherId = (Integer) session.getAttribute("userId");

        // CSRF Token Verification
        String sessionCsrf = (String) session.getAttribute("csrfToken");
        String requestCsrf = request.getParameter("csrfToken");
        if (sessionCsrf != null && (requestCsrf == null || !sessionCsrf.equals(requestCsrf))) {
            logger.warn("CSRF mismatch in quiz builder for teacher {}", teacherId);
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Invalid or missing security token (CSRF). Action blocked.");
            return;
        }

        String quizIdStr = request.getParameter("quizId");
        int quizId = -1;
        try {
            if (quizIdStr != null && !quizIdStr.trim().isEmpty()) {
                quizId = Integer.parseInt(quizIdStr.trim());
            }
        } catch (NumberFormatException e) {
            logger.warn("Invalid quizId in POST: {}", quizIdStr);
        }

        if (quizId <= 0) {
            session.setAttribute("flashError", "Invalid or missing Quiz ID.");
            response.sendRedirect(request.getContextPath() + "/teacher/quizzes");
            return;
        }

        if (!teacherService.isQuizOwnedBy(quizId, teacherId)) {
            logger.warn("Teacher ID {} is not authorized to edit quiz ID {}", teacherId, quizId);
            session.setAttribute("flashError", "Unauthorized: You do not have permission to modify this examination.");
            response.sendRedirect(request.getContextPath() + "/teacher/quizzes");
            return;
        }

        String action = request.getParameter("action");
        try {
            if ("save_question".equalsIgnoreCase(action)) {
                handleSaveQuestion(request, quizId, teacherId, response, session);
                return;
            } else if ("delete_question".equalsIgnoreCase(action) || "remove_from_quiz".equalsIgnoreCase(action)) {
                String qIdStr = request.getParameter("questionId");
                if (qIdStr != null && !qIdStr.trim().isEmpty()) {
                    int questionId = Integer.parseInt(qIdStr.trim());
                    teacherService.removeQuestionFromQuiz(questionId, quizId, teacherId);
                    session.setAttribute("flashSuccess", "Question removed from examination.");
                }
                response.sendRedirect(request.getContextPath() + "/teacher/quiz/builder?quizId=" + quizId + "&tab=questions");
                return;
            } else if ("duplicate_question".equalsIgnoreCase(action)) {
                int questionId = Integer.parseInt(request.getParameter("questionId"));
                int newQId = teacherService.duplicateQuestion(questionId, quizId, teacherId);
                if (newQId > 0) {
                    session.setAttribute("flashSuccess", "Question duplicated successfully.");
                    response.sendRedirect(request.getContextPath() + "/teacher/quiz/builder?quizId=" + quizId + "&activeQuestionId=" + newQId + "&tab=questions");
                } else {
                    session.setAttribute("flashError", "Failed to duplicate question.");
                    response.sendRedirect(request.getContextPath() + "/teacher/quiz/builder?quizId=" + quizId + "&tab=questions");
                }
                return;
            } else if ("add_from_bank".equalsIgnoreCase(action)) {
                int questionId = Integer.parseInt(request.getParameter("questionId"));
                boolean added = teacherService.addQuestionToQuiz(questionId, quizId, teacherId);
                if (added) {
                    session.setAttribute("flashSuccess", "Question added to examination from Question Bank.");
                    response.sendRedirect(request.getContextPath() + "/teacher/quiz/builder?quizId=" + quizId + "&activeQuestionId=" + questionId + "&tab=questions");
                } else {
                    session.setAttribute("flashError", "Failed to add question from Question Bank.");
                    response.sendRedirect(request.getContextPath() + "/teacher/quiz/builder?quizId=" + quizId + "&tab=questions");
                }
                return;
            } else if ("publish_quiz".equalsIgnoreCase(action)) {
                try {
                    teacherService.validateQuizForPublish(quizId, teacherId);
                    Optional<Quiz> qOpt = teacherService.getQuizById(quizId);
                    if (qOpt.isEmpty()) {
                        session.setAttribute("flashError", "Quiz not found.");
                        response.sendRedirect(request.getContextPath() + "/teacher/quizzes");
                        return;
                    }
                    Quiz q = qOpt.get();
                    Timestamp now = new Timestamp(System.currentTimeMillis());
                    String targetStatus;
                    String successMsg;
                    if (q.getStartTime() != null && q.getStartTime().after(now)) {
                        targetStatus = "SCHEDULED";
                        successMsg = "Examination successfully verified and scheduled to open on " + q.getFormattedScheduleWindow() + ".";
                    } else {
                        targetStatus = "ACTIVE";
                        successMsg = "Examination successfully verified and published. It is now active for candidates.";
                    }
                    teacherService.setQuizStatus(quizId, teacherId, targetStatus);
                    session.setAttribute("flashSuccess", successMsg);
                    response.sendRedirect(request.getContextPath() + "/teacher/quiz/builder?quizId=" + quizId + "&tab=publish");
                    return;
                } catch (IllegalArgumentException e) {
                    logger.warn("Publish validation failed for quiz ID {}: {}", quizId, e.getMessage());
                    session.setAttribute("flashError", e.getMessage());
                    response.sendRedirect(request.getContextPath() + "/teacher/quiz/builder?quizId=" + quizId + "&tab=publish");
                    return;
                }
            } else if ("save_draft".equalsIgnoreCase(action)) {
                teacherService.setQuizStatus(quizId, teacherId, "DRAFT");
                session.setAttribute("flashSuccess", "Examination status reverted to Draft.");
                response.sendRedirect(request.getContextPath() + "/teacher/quiz/builder?quizId=" + quizId + "&tab=publish");
                return;
            } else if ("update_config".equalsIgnoreCase(action)) {
                try {
                    handleUpdateConfig(request, quizId, teacherId);
                    session.setAttribute("flashSuccess", "Quiz parameters and security settings updated successfully.");
                } catch (IllegalArgumentException e) {
                    logger.warn("Update config failed for quiz ID {}: {}", quizId, e.getMessage());
                    session.setAttribute("flashError", e.getMessage());
                }
                response.sendRedirect(request.getContextPath() + "/teacher/quiz/builder?quizId=" + quizId + "&tab=settings");
                return;
            } else if ("assign_cohort".equalsIgnoreCase(action)) {
                String cohortIdStr = request.getParameter("cohortId");
                if (cohortIdStr == null || cohortIdStr.trim().isEmpty()) {
                    session.setAttribute("flashError", "Please select a cohort to assign.");
                } else {
                    int cohortId = Integer.parseInt(cohortIdStr.trim());
                    String dueAtStr = request.getParameter("dueAt");
                    Timestamp dueAt = parseTimestamp(dueAtStr);
                    boolean assigned = teacherService.assignQuizToCohort(quizId, cohortId, dueAt, teacherId);
                    if (assigned) {
                        session.setAttribute("flashSuccess", "Cohort successfully assigned to examination.");
                    } else {
                        session.setAttribute("flashError", "Failed to assign cohort (verify permissions or existing assignments).");
                    }
                }
                response.sendRedirect(request.getContextPath() + "/teacher/quiz/builder?quizId=" + quizId + "&tab=publish");
                return;
            } else if ("assign_student".equalsIgnoreCase(action)) {
                String studentIdStr = request.getParameter("studentId");
                if (studentIdStr == null || studentIdStr.trim().isEmpty()) {
                    session.setAttribute("flashError", "Please select a candidate student to assign.");
                } else {
                    int studentId = Integer.parseInt(studentIdStr.trim());
                    String dueAtStr = request.getParameter("dueAt");
                    Timestamp dueAt = parseTimestamp(dueAtStr);
                    boolean assigned = teacherService.assignQuizToStudent(quizId, studentId, dueAt, teacherId);
                    if (assigned) {
                        session.setAttribute("flashSuccess", "Student candidate successfully assigned to examination.");
                    } else {
                        session.setAttribute("flashError", "Failed to assign student (verify permissions or existing assignments).");
                    }
                }
                response.sendRedirect(request.getContextPath() + "/teacher/quiz/builder?quizId=" + quizId + "&tab=publish");
                return;
            } else if ("remove_assignment".equalsIgnoreCase(action)) {
                String assignmentIdStr = request.getParameter("assignmentId");
                if (assignmentIdStr != null && !assignmentIdStr.trim().isEmpty()) {
                    int assignmentId = Integer.parseInt(assignmentIdStr.trim());
                    boolean removed = teacherService.removeQuizAssignment(assignmentId, quizId, teacherId);
                    if (removed) {
                        session.setAttribute("flashSuccess", "Assignment target successfully removed.");
                    } else {
                        session.setAttribute("flashError", "Failed to remove assignment.");
                    }
                }
                response.sendRedirect(request.getContextPath() + "/teacher/quiz/builder?quizId=" + quizId + "&tab=publish");
                return;
            }
        } catch (Exception e) {
            logger.error("Error processing quiz builder action: {}", action, e);
            session.setAttribute("flashError", "An unexpected error occurred while processing your request.");
        }

        response.sendRedirect(request.getContextPath() + "/teacher/quiz/builder?quizId=" + quizId);
    }

    private void handleSaveQuestion(HttpServletRequest request, int quizId, int teacherId, HttpServletResponse response, HttpSession session) throws IOException {
        String qIdStr = request.getParameter("questionId");
        int questionId = (qIdStr != null && !qIdStr.trim().isEmpty()) ? Integer.parseInt(qIdStr.trim()) : 0;

        String questionText = request.getParameter("questionText");
        if (questionText == null || questionText.trim().length() < 3) {
            session.setAttribute("flashError", "Question prompt statement must be at least 3 characters long.");
            response.sendRedirect(request.getContextPath() + "/teacher/quiz/builder?quizId=" + quizId + (questionId > 0 ? "&activeQuestionId=" + questionId : "&activeQuestionId=0"));
            return;
        }

        String questionType = request.getParameter("questionType");
        if (questionType == null || (!"SINGLE_CHOICE".equalsIgnoreCase(questionType) && !"MULTI_CHOICE".equalsIgnoreCase(questionType) && !"TRUE_FALSE".equalsIgnoreCase(questionType))) {
            questionType = "SINGLE_CHOICE";
        }

        BigDecimal points = new BigDecimal("4.00");
        String pointsStr = request.getParameter("points");
        try {
            if (pointsStr != null && !pointsStr.trim().isEmpty()) {
                points = new BigDecimal(pointsStr.trim());
            }
        } catch (NumberFormatException e) {
            session.setAttribute("flashError", "Invalid points value entered.");
            response.sendRedirect(request.getContextPath() + "/teacher/quiz/builder?quizId=" + quizId + (questionId > 0 ? "&activeQuestionId=" + questionId : "&activeQuestionId=0"));
            return;
        }
        if (points.compareTo(BigDecimal.ZERO) <= 0) {
            session.setAttribute("flashError", "Question points must be greater than 0.");
            response.sendRedirect(request.getContextPath() + "/teacher/quiz/builder?quizId=" + quizId + (questionId > 0 ? "&activeQuestionId=" + questionId : "&activeQuestionId=0"));
            return;
        }

        String difficultyLevel = request.getParameter("difficultyLevel");
        String taxonomyTopic = request.getParameter("taxonomyTopic");
        String explanation = request.getParameter("explanation");
        String codeSnippet = request.getParameter("codeSnippet");
        int subjectId = 1;
        try {
            subjectId = Integer.parseInt(request.getParameter("subjectId"));
        } catch (NumberFormatException ignored) {}

        String[] correctArr = request.getParameterValues("correctOption");
        Set<String> correctSet = new HashSet<>();
        if (correctArr != null) {
            for (String c : correctArr) {
                if (c != null && !c.trim().isEmpty()) {
                    correctSet.add(c.trim().toUpperCase());
                }
            }
        }

        List<QuestionOption> options = new ArrayList<>();
        if ("TRUE_FALSE".equalsIgnoreCase(questionType)) {
            options.add(new QuestionOption("A", "True", correctSet.contains("A"), 1));
            options.add(new QuestionOption("B", "False", correctSet.contains("B"), 2));
            long correctCount = options.stream().filter(QuestionOption::isCorrect).count();
            if (correctCount != 1) {
                session.setAttribute("flashError", "True/False questions must have exactly one correct answer selected (True or False).");
                response.sendRedirect(request.getContextPath() + "/teacher/quiz/builder?quizId=" + quizId + (questionId > 0 ? "&activeQuestionId=" + questionId : "&activeQuestionId=0"));
                return;
            }
        } else {
            String[] letters = {"A", "B", "C", "D", "E", "F"};
            int sortOrder = 1;
            for (String letter : letters) {
                String optText = request.getParameter("optionText_" + letter);
                if (optText != null && !optText.trim().isEmpty()) {
                    boolean isCorrect = correctSet.contains(letter);
                    options.add(new QuestionOption(letter, optText.trim(), isCorrect, sortOrder++));
                }
            }

            if (options.size() < 2) {
                session.setAttribute("flashError", "Question must have at least 2 non-empty answer choices.");
                response.sendRedirect(request.getContextPath() + "/teacher/quiz/builder?quizId=" + quizId + (questionId > 0 ? "&activeQuestionId=" + questionId : "&activeQuestionId=0"));
                return;
            }

            long correctCount = options.stream().filter(QuestionOption::isCorrect).count();
            if ("SINGLE_CHOICE".equalsIgnoreCase(questionType)) {
                if (correctCount != 1) {
                    session.setAttribute("flashError", "Single-choice questions must have exactly one correct answer selected.");
                    response.sendRedirect(request.getContextPath() + "/teacher/quiz/builder?quizId=" + quizId + (questionId > 0 ? "&activeQuestionId=" + questionId : "&activeQuestionId=0"));
                    return;
                }
            } else if ("MULTI_CHOICE".equalsIgnoreCase(questionType)) {
                if (correctCount < 1) {
                    session.setAttribute("flashError", "Multi-choice questions must have at least one correct answer selected.");
                    response.sendRedirect(request.getContextPath() + "/teacher/quiz/builder?quizId=" + quizId + (questionId > 0 ? "&activeQuestionId=" + questionId : "&activeQuestionId=0"));
                    return;
                }
            }
        }

        Question question = new Question();
        question.setQuestionId(questionId);
        question.setQuizId(quizId);
        question.setSubjectId(subjectId);
        question.setQuestionText(questionText.trim());
        question.setQuestionType(questionType);
        question.setPoints(points);
        question.setDifficultyLevel(difficultyLevel != null ? difficultyLevel : "MEDIUM");
        question.setTaxonomyTopic(taxonomyTopic != null ? taxonomyTopic.trim() : "");
        question.setExplanation(explanation != null ? explanation.trim() : "");
        question.setCodeSnippet(codeSnippet != null ? codeSnippet.trim() : "");
        question.setOptions(options);

        String saveMode = request.getParameter("saveMode");
        int savedId;
        try {
            if (questionId > 0) {
                boolean ok = teacherService.updateQuestion(question, teacherId);
                if (ok) {
                    savedId = questionId;
                } else {
                    session.setAttribute("flashError", "Failed to update question.");
                    savedId = questionId;
                }
            } else {
                Question created = teacherService.createQuestion(question, teacherId);
                if (created != null && created.getQuestionId() > 0) {
                    savedId = created.getQuestionId();
                } else {
                    session.setAttribute("flashError", "Failed to create question in database.");
                    savedId = 0;
                }
            }
        } catch (IllegalArgumentException e) {
            session.setAttribute("flashError", e.getMessage());
            response.sendRedirect(request.getContextPath() + "/teacher/quiz/builder?quizId=" + quizId + (questionId > 0 ? "&activeQuestionId=" + questionId : "&activeQuestionId=0"));
            return;
        }

        // If newly created OR explicitly chosen "Save & Add Next Question", advance to clean blank template for next item
        if (questionId == 0 || "save_next".equalsIgnoreCase(saveMode)) {
            int nextCount = teacherService.getQuestionsForQuiz(quizId).size() + 1;
            session.setAttribute("flashSuccess", "Question successfully saved! Ready to draft Question #" + nextCount + ".");
            response.sendRedirect(request.getContextPath() + "/teacher/quiz/builder?quizId=" + quizId + "&activeQuestionId=0&new=true");
        } else {
            session.setAttribute("flashSuccess", "Question updated successfully.");
            response.sendRedirect(request.getContextPath() + "/teacher/quiz/builder?quizId=" + quizId + "&activeQuestionId=" + savedId);
        }
    }

    private void handleUpdateConfig(HttpServletRequest request, int quizId, int teacherId) {
        Optional<Quiz> qOpt = teacherService.getQuizById(quizId);
        if (qOpt.isEmpty()) {
            throw new IllegalArgumentException("Examination not found.");
        }

        Quiz quiz = qOpt.get();

        String title = request.getParameter("title");
        if (title != null && !title.trim().isEmpty()) {
            quiz.setTitle(title.trim());
        }

        String description = request.getParameter("description");
        if (description != null) {
            quiz.setDescription(description.trim());
        }

        String durationStr = request.getParameter("durationMinutes");
        if (durationStr != null && !durationStr.trim().isEmpty()) {
            try {
                quiz.setDurationMinutes(Integer.parseInt(durationStr.trim()));
            } catch (NumberFormatException e) {
                throw new IllegalArgumentException("Invalid duration specified.");
            }
        }

        String passPctStr = request.getParameter("passPercentage");
        if (passPctStr != null && !passPctStr.trim().isEmpty()) {
            try {
                quiz.setPassPercentage(new BigDecimal(passPctStr.trim()));
            } catch (NumberFormatException e) {
                throw new IllegalArgumentException("Invalid passing percentage specified.");
            }
        }

        // Schedule window (datetime-local format: yyyy-MM-ddTHH:mm)
        if (request.getParameter("startTime") != null) {
            String startTimeStr = request.getParameter("startTime").trim();
            if (!startTimeStr.isEmpty()) {
                try {
                    String normalized = startTimeStr.replace("T", " ");
                    if (normalized.length() == 16) normalized += ":00";
                    quiz.setStartTime(Timestamp.valueOf(normalized));
                } catch (Exception e) {
                    throw new IllegalArgumentException("Invalid start date/time format.");
                }
            } else {
                quiz.setStartTime(null);
            }
        }

        if (request.getParameter("endTime") != null) {
            String endTimeStr = request.getParameter("endTime").trim();
            if (!endTimeStr.isEmpty()) {
                try {
                    String normalized = endTimeStr.replace("T", " ");
                    if (normalized.length() == 16) normalized += ":00";
                    quiz.setEndTime(Timestamp.valueOf(normalized));
                } catch (Exception e) {
                    throw new IllegalArgumentException("Invalid end date/time format.");
                }
            } else {
                quiz.setEndTime(null);
            }
        }

        // Negative marking
        quiz.setNegativeMarking(request.getParameter("negativeMarking") != null);
        if (quiz.isNegativeMarking()) {
            String negValStr = request.getParameter("negativeMarkValue");
            if (negValStr != null && !negValStr.trim().isEmpty()) {
                try {
                    quiz.setNegativeMarkValue(new BigDecimal(negValStr.trim()));
                } catch (NumberFormatException e) {
                    throw new IllegalArgumentException("Invalid negative marking deduction value.");
                }
            }
        } else {
            quiz.setNegativeMarkValue(BigDecimal.ZERO);
        }

        // Integrity & Anti-cheat rules
        quiz.setShuffleQuestions(request.getParameter("shuffleQuestions") != null);
        quiz.setFullscreenRequired(request.getParameter("fullscreenRequired") != null);
        quiz.setWebcamRequired(request.getParameter("webcamRequired") != null);

        String tabSwitchesStr = request.getParameter("maxTabSwitches");
        if (tabSwitchesStr != null && !tabSwitchesStr.trim().isEmpty()) {
            try {
                quiz.setMaxTabSwitches(Integer.parseInt(tabSwitchesStr.trim()));
            } catch (NumberFormatException ignored) {}
        }

        // Status update if explicitly permitted
        String statusParam = request.getParameter("status");
        if (statusParam != null && !statusParam.trim().isEmpty()) {
            String upperStatus = statusParam.trim().toUpperCase();
            if ("DRAFT".equals(upperStatus) || "SCHEDULED".equals(upperStatus) || "ACTIVE".equals(upperStatus) || "COMPLETED".equals(upperStatus) || "ARCHIVED".equals(upperStatus)) {
                quiz.setStatus(upperStatus);
            }
        }

        boolean updated = teacherService.updateQuiz(quiz, teacherId);
        if (!updated) {
            throw new IllegalArgumentException("Failed to update examination parameters in database.");
        }
    }

    private List<QuestionOption> createBlankOptions(String questionType) {
        List<QuestionOption> opts = new ArrayList<>();
        if ("TRUE_FALSE".equalsIgnoreCase(questionType)) {
            opts.add(new QuestionOption("A", "True", true, 1));
            opts.add(new QuestionOption("B", "False", false, 2));
        } else {
            opts.add(new QuestionOption("A", "", true, 1));
            opts.add(new QuestionOption("B", "", false, 2));
            opts.add(new QuestionOption("C", "", false, 3));
            opts.add(new QuestionOption("D", "", false, 4));
        }
        return opts;
    }

    private Timestamp parseTimestamp(String dtStr) {
        if (dtStr == null || dtStr.trim().isEmpty()) {
            return null;
        }
        try {
            String normalized = dtStr.trim().replace("T", " ");
            if (normalized.length() == 16) {
                normalized += ":00";
            }
            return Timestamp.valueOf(normalized);
        } catch (Exception e) {
            logger.warn("Failed to parse timestamp string: {}", dtStr, e);
            return null;
        }
    }
}
