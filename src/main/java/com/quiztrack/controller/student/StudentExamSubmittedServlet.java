package com.quiztrack.controller.student;

import com.quiztrack.model.QuizAttempt;
import com.quiztrack.service.ExamService;
import com.quiztrack.service.impl.ExamServiceImpl;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;
import java.util.Optional;

/**
 * Controller displaying post-submission confirmation and security seal.
 */
@WebServlet(name = "StudentExamSubmittedServlet", urlPatterns = {"/student/exam/submitted"})
public class StudentExamSubmittedServlet extends HttpServlet {

    private static final Logger logger = LoggerFactory.getLogger(StudentExamSubmittedServlet.class);
    private final ExamService examService;

    public StudentExamSubmittedServlet() {
        this.examService = new ExamServiceImpl();
    }

    public StudentExamSubmittedServlet(ExamService examService) {
        this.examService = examService;
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/auth/login");
            return;
        }

        int studentId = (Integer) session.getAttribute("userId");
        String attemptIdStr = request.getParameter("attemptId");

        if (attemptIdStr == null || attemptIdStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/student/dashboard");
            return;
        }

        try {
            int attemptId = Integer.parseInt(attemptIdStr.trim());
            Optional<QuizAttempt> attemptOpt = examService.getAttemptById(attemptId, studentId);

            if (attemptOpt.isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/student/dashboard");
                return;
            }

            QuizAttempt attempt = attemptOpt.get();
            request.setAttribute("attempt", attempt);
            request.getRequestDispatcher("/WEB-INF/views/student/exam-submitted.jsp").forward(request, response);
            return;
        } catch (Exception e) {
            logger.error("Error loading submitted screen for student: {}", studentId, e);
        }

        response.sendRedirect(request.getContextPath() + "/student/dashboard");
    }
}
