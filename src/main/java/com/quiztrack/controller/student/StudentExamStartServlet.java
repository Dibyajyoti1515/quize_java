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

/**
 * Initiates or resumes an examination attempt upon preflight clearance.
 */
@WebServlet(name = "StudentExamStartServlet", urlPatterns = {"/student/exam/start"})
public class StudentExamStartServlet extends HttpServlet {

    private static final Logger logger = LoggerFactory.getLogger(StudentExamStartServlet.class);
    private final ExamService examService;

    public StudentExamStartServlet() {
        this.examService = new ExamServiceImpl();
    }

    public StudentExamStartServlet(ExamService examService) {
        this.examService = examService;
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doPost(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/auth/login");
            return;
        }

        int studentId = (Integer) session.getAttribute("userId");
        String quizIdStr = request.getParameter("quizId");

        if (quizIdStr == null || quizIdStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/student/quizzes");
            return;
        }

        try {
            int quizId = Integer.parseInt(quizIdStr.trim());
            String ipAddress = request.getRemoteAddr();
            String userAgent = request.getHeader("User-Agent");

            QuizAttempt attempt = examService.startOrResumeExam(quizId, studentId, ipAddress, userAgent);
            if (attempt != null) {
                if ("SUBMITTED".equalsIgnoreCase(attempt.getStatus())) {
                    response.sendRedirect(request.getContextPath() + "/student/exam/submitted?attemptId=" + attempt.getAttemptId());
                } else {
                    response.sendRedirect(request.getContextPath() + "/student/exam?attemptId=" + attempt.getAttemptId() + "&q=0");
                }
                return;
            }
        } catch (SecurityException se) {
            logger.warn("Ineligible student {} attempted exam start: {}", studentId, se.getMessage());
            response.sendRedirect(request.getContextPath() + "/student/quizzes?error=ineligible");
            return;
        } catch (IllegalStateException ise) {
            logger.warn("Duplicate attempt rejected for student {}: {}", studentId, ise.getMessage());
            response.sendRedirect(request.getContextPath() + "/student/quizzes?error=already_completed");
            return;
        } catch (Exception e) {
            logger.error("Error starting exam for student: {}", studentId, e);
        }

        response.sendRedirect(request.getContextPath() + "/student/quizzes?error=start_failed");
    }
}
