package com.quiztrack.controller.teacher;

import com.quiztrack.model.Quiz;
import com.quiztrack.model.StudentResultDto;
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
import java.util.Collections;
import java.util.List;
import java.util.Optional;

/**
 * Controller for Faculty Quiz Performance Reports.
 * Displays examinee attempts, scores, passing metrics, and detailed answer analytics.
 */
@WebServlet(name = "TeacherReportsServlet", urlPatterns = {"/teacher/reports"})
public class TeacherReportsServlet extends HttpServlet {

    private static final Logger logger = LoggerFactory.getLogger(TeacherReportsServlet.class);
    private final TeacherService teacherService;

    public TeacherReportsServlet() {
        this.teacherService = new TeacherServiceImpl();
    }

    public TeacherReportsServlet(TeacherService teacherService) {
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
        List<Quiz> quizzes = teacherService.getQuizzesByTeacher(teacherId);

        String quizIdStr = request.getParameter("quizId");
        int selectedQuizId = -1;

        if (quizIdStr != null && !quizIdStr.trim().isEmpty()) {
            try {
                selectedQuizId = Integer.parseInt(quizIdStr.trim());
            } catch (NumberFormatException ignored) {}
        }

        if (selectedQuizId <= 0 && !quizzes.isEmpty()) {
            selectedQuizId = quizzes.get(0).getQuizId();
        }

        Quiz selectedQuiz = null;
        List<StudentResultDto> results = Collections.emptyList();

        if (selectedQuizId > 0) {
            Optional<Quiz> qOpt = teacherService.getQuizById(selectedQuizId);
            if (qOpt.isPresent()) {
                selectedQuiz = qOpt.get();
                results = teacherService.getQuizPerformanceReport(selectedQuizId, teacherId);
            }
        }

        int totalCandidates = results.size();
        int passedCount = (int) results.stream().filter(StudentResultDto::isPassed).count();
        int failedCount = totalCandidates - passedCount;
        double passRate = totalCandidates > 0 ? (passedCount * 100.0) / totalCandidates : 0.0;
        double averageScore = totalCandidates > 0 ? results.stream().mapToDouble(r -> r.getScore() != null ? r.getScore().doubleValue() : 0.0).average().orElse(0.0) : 0.0;
        double highestScore = totalCandidates > 0 ? results.stream().mapToDouble(r -> r.getScore() != null ? r.getScore().doubleValue() : 0.0).max().orElse(0.0) : 0.0;
        double lowestScore = totalCandidates > 0 ? results.stream().mapToDouble(r -> r.getScore() != null ? r.getScore().doubleValue() : 0.0).min().orElse(0.0) : 0.0;

        request.setAttribute("quizzes", quizzes);
        request.setAttribute("selectedQuiz", selectedQuiz);
        request.setAttribute("results", results);
        request.setAttribute("totalCandidates", totalCandidates);
        request.setAttribute("passedCount", passedCount);
        request.setAttribute("failedCount", failedCount);
        request.setAttribute("passRate", Math.round(passRate * 10.0) / 10.0);
        request.setAttribute("averageScore", Math.round(averageScore * 100.0) / 100.0);
        request.setAttribute("highestScore", Math.round(highestScore * 100.0) / 100.0);
        request.setAttribute("lowestScore", Math.round(lowestScore * 100.0) / 100.0);

        request.getRequestDispatcher("/WEB-INF/views/teacher/reports.jsp").forward(request, response);
    }
}
