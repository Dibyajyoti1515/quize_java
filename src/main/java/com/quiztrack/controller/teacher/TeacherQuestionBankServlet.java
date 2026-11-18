package com.quiztrack.controller.teacher;

import com.quiztrack.model.Question;
import com.quiztrack.model.QuestionOption;
import com.quiztrack.model.Subject;
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
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

/**
 * Controller for Departmental Question Bank management.
 * Supports filtering by topic, difficulty, subject, and full-text keyword search.
 */
@WebServlet(name = "TeacherQuestionBankServlet", urlPatterns = {"/teacher/question-bank"})
public class TeacherQuestionBankServlet extends HttpServlet {

    private static final Logger logger = LoggerFactory.getLogger(TeacherQuestionBankServlet.class);
    private final TeacherService teacherService;

    public TeacherQuestionBankServlet() {
        this.teacherService = new TeacherServiceImpl();
    }

    public TeacherQuestionBankServlet(TeacherService teacherService) {
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

        String subjectIdStr = request.getParameter("subjectId");
        Integer subjectId = null;
        if (subjectIdStr != null && !subjectIdStr.trim().isEmpty() && !"ALL".equalsIgnoreCase(subjectIdStr)) {
            try {
                subjectId = Integer.parseInt(subjectIdStr.trim());
            } catch (NumberFormatException ignored) {}
        }

        String difficulty = request.getParameter("difficulty");
        String topic = request.getParameter("topic");
        String search = request.getParameter("search");

        List<Question> questions = teacherService.getQuestionBank(subjectId, difficulty, topic, search, 50, 0);
        int totalCount = teacherService.countQuestionBank(subjectId, difficulty, topic, search);
        List<Subject> subjects = teacherService.getAllSubjects();

        request.setAttribute("questions", questions);
        request.setAttribute("totalCount", totalCount);
        request.setAttribute("subjects", subjects);
        request.setAttribute("selectedSubjectId", subjectId);
        request.setAttribute("selectedDifficulty", difficulty);
        request.setAttribute("selectedTopic", topic);
        request.setAttribute("searchQuery", search);

        request.getRequestDispatcher("/WEB-INF/views/teacher/question-bank.jsp").forward(request, response);
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
        String action = request.getParameter("action");

        try {
            if ("delete".equalsIgnoreCase(action)) {
                int questionId = Integer.parseInt(request.getParameter("questionId"));
                boolean deleted = teacherService.deleteQuestion(questionId, teacherId);
                if (deleted) {
                    session.setAttribute("flashMessage", "Question #" + questionId + " permanently deleted.");
                } else {
                    session.setAttribute("flashError", "Failed to delete question #" + questionId + ". Only the authoring faculty member or an administrator can delete this question.");
                }
            } else if ("create".equalsIgnoreCase(action)) {
                Question q = new Question();
                q.setSubjectId(Integer.parseInt(request.getParameter("subjectId")));
                q.setQuestionText(request.getParameter("questionText"));

                String qType = request.getParameter("questionType");
                if (qType == null || qType.isBlank() || "MCQ".equalsIgnoreCase(qType)) {
                    qType = "SINGLE_CHOICE";
                }
                q.setQuestionType(qType.toUpperCase());
                q.setPoints(new BigDecimal(request.getParameter("points")));
                q.setDifficultyLevel(request.getParameter("difficultyLevel"));
                q.setTaxonomyTopic(request.getParameter("taxonomyTopic"));
                q.setExplanation(request.getParameter("explanation"));
                q.setCodeSnippet(request.getParameter("codeSnippet"));

                List<QuestionOption> options = new ArrayList<>();
                if ("TRUE_FALSE".equalsIgnoreCase(qType)) {
                    String correctTF = request.getParameter("correctOption_TF");
                    if (correctTF == null) correctTF = request.getParameter("correctOption");
                    boolean aCorrect = "A".equalsIgnoreCase(correctTF) || "TRUE".equalsIgnoreCase(correctTF);
                    options.add(new QuestionOption("A", "True", aCorrect, 1));
                    options.add(new QuestionOption("B", "False", !aCorrect, 2));
                } else if ("MULTI_CHOICE".equalsIgnoreCase(qType)) {
                    String[] correctArr = request.getParameterValues("correctOptions");
                    java.util.Set<String> correctSet = new java.util.HashSet<>();
                    if (correctArr != null) {
                        for (String s : correctArr) correctSet.add(s.toUpperCase());
                    }
                    String[] letters = {"A", "B", "C", "D"};
                    int sortOrder = 1;
                    for (String l : letters) {
                        String optText = request.getParameter("optionText_" + l);
                        if (optText != null && !optText.trim().isEmpty()) {
                            options.add(new QuestionOption(l, optText.trim(), correctSet.contains(l), sortOrder++));
                        }
                    }
                } else {
                    // SINGLE_CHOICE
                    String correctLetter = request.getParameter("correctOption");
                    String[] letters = {"A", "B", "C", "D"};
                    int sortOrder = 1;
                    for (String l : letters) {
                        String optText = request.getParameter("optionText_" + l);
                        if (optText != null && !optText.trim().isEmpty()) {
                            options.add(new QuestionOption(l, optText.trim(), l.equalsIgnoreCase(correctLetter), sortOrder++));
                        }
                    }
                }

                q.setOptions(options);
                Question created = teacherService.createQuestion(q, teacherId);
                if (created != null) {
                    session.setAttribute("flashMessage", "Question successfully added to the departmental question bank.");
                } else {
                    session.setAttribute("flashError", "Failed to save question.");
                }
            }
        } catch (IllegalArgumentException iae) {
            logger.warn("Validation error in question bank authoring: {}", iae.getMessage());
            session.setAttribute("flashError", iae.getMessage());
        } catch (Exception e) {
            logger.error("Error in QuestionBankServlet doPost", e);
            session.setAttribute("flashError", "Failed to process question bank request: " + e.getMessage());
        }

        response.sendRedirect(request.getContextPath() + "/teacher/question-bank");
    }
}
