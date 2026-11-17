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
                teacherService.deleteQuestion(questionId, teacherId);
            } else if ("create".equalsIgnoreCase(action)) {
                Question q = new Question();
                q.setSubjectId(Integer.parseInt(request.getParameter("subjectId")));
                q.setQuestionText(request.getParameter("questionText"));
                q.setQuestionType(request.getParameter("questionType"));
                q.setPoints(new BigDecimal(request.getParameter("points")));
                q.setDifficultyLevel(request.getParameter("difficultyLevel"));
                q.setTaxonomyTopic(request.getParameter("taxonomyTopic"));
                q.setExplanation(request.getParameter("explanation"));
                q.setCodeSnippet(request.getParameter("codeSnippet"));

                String correctLetter = request.getParameter("correctOption");
                List<QuestionOption> options = new ArrayList<>();
                String[] letters = {"A", "B", "C", "D"};
                int sortOrder = 1;
                for (String l : letters) {
                    String optText = request.getParameter("optionText_" + l);
                    if (optText != null && !optText.trim().isEmpty()) {
                        options.add(new QuestionOption(l, optText.trim(), l.equalsIgnoreCase(correctLetter), sortOrder++));
                    }
                }
                q.setOptions(options);
                teacherService.createQuestion(q, teacherId);
            }
        } catch (Exception e) {
            logger.error("Error in QuestionBankServlet doPost", e);
        }

        response.sendRedirect(request.getContextPath() + "/teacher/question-bank");
    }
}
