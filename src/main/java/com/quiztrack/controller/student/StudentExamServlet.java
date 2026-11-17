package com.quiztrack.controller.student;

import com.quiztrack.model.ExamSessionDto;
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
 * Controller delivering the distraction-free candidate examination interface.
 * Coordinates question rendering, answer persistence, and final submission.
 */
@WebServlet(name = "StudentExamServlet", urlPatterns = {"/student/exam"})
public class StudentExamServlet extends HttpServlet {

    private static final Logger logger = LoggerFactory.getLogger(StudentExamServlet.class);
    private final ExamService examService;

    public StudentExamServlet() {
        this.examService = new ExamServiceImpl();
    }

    public StudentExamServlet(ExamService examService) {
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
            int questionIndex = 0;
            String qStr = request.getParameter("q");
            if (qStr != null && !qStr.trim().isEmpty()) {
                try {
                    questionIndex = Integer.parseInt(qStr.trim());
                } catch (NumberFormatException ignored) {}
            }

            ExamSessionDto examSession = examService.getExamSession(attemptId, studentId, questionIndex);
            if (examSession == null || examSession.getAttempt() == null) {
                response.sendRedirect(request.getContextPath() + "/student/dashboard?error=not_found");
                return;
            }

            // If exam has been submitted (or auto-submitted upon expiration)
            if ("SUBMITTED".equalsIgnoreCase(examSession.getAttempt().getStatus())) {
                response.sendRedirect(request.getContextPath() + "/student/exam/submitted?attemptId=" + attemptId);
                return;
            }

            request.setAttribute("examSession", examSession);
            request.getRequestDispatcher("/WEB-INF/views/student/exam-engine.jsp").forward(request, response);
            return;
        } catch (SecurityException se) {
            logger.warn("Unauthorized access by student {} to exam: {}", studentId, se.getMessage());
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access forbidden to requested examination chamber.");
            return;
        } catch (Exception e) {
            logger.error("Error loading examination session for student: {}", studentId, e);
        }

        response.sendRedirect(request.getContextPath() + "/student/dashboard");
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
        String attemptIdStr = request.getParameter("attemptId");
        String action = request.getParameter("action");

        if (attemptIdStr == null || attemptIdStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/student/dashboard");
            return;
        }

        int attemptId = Integer.parseInt(attemptIdStr.trim());

        try {
            if ("submit".equalsIgnoreCase(action)) {
                // Final submission
                QuizAttempt submitted = examService.submitExam(attemptId, studentId);
                response.sendRedirect(request.getContextPath() + "/student/exam/submitted?attemptId=" + attemptId);
                return;
            } else if ("save_and_navigate".equalsIgnoreCase(action) || "navigate".equalsIgnoreCase(action)) {
                // Persist current question answer
                String questionIdStr = request.getParameter("questionId");
                String selectedOptStr = request.getParameter("selectedOptionId");
                boolean isFlagged = "true".equalsIgnoreCase(request.getParameter("isFlagged"));

                if (questionIdStr != null && !questionIdStr.trim().isEmpty()) {
                    int questionId = Integer.parseInt(questionIdStr.trim());
                    Integer selectedOptId = null;
                    if (selectedOptStr != null && !selectedOptStr.trim().isEmpty() && !"0".equals(selectedOptStr.trim())) {
                        try {
                            selectedOptId = Integer.parseInt(selectedOptStr.trim());
                        } catch (NumberFormatException ignored) {}
                    }
                    examService.saveAnswer(attemptId, studentId, questionId, selectedOptId, isFlagged);
                }

                String targetQStr = request.getParameter("targetQ");
                int targetQ = 0;
                if (targetQStr != null && !targetQStr.trim().isEmpty()) {
                    targetQ = Integer.parseInt(targetQStr.trim());
                }

                response.sendRedirect(request.getContextPath() + "/student/exam?attemptId=" + attemptId + "&q=" + targetQ);
                return;
            } else if ("flag".equalsIgnoreCase(action)) {
                int questionId = Integer.parseInt(request.getParameter("questionId"));
                boolean isFlagged = "true".equalsIgnoreCase(request.getParameter("isFlagged"));
                examService.toggleFlag(attemptId, studentId, questionId, isFlagged);

                String currentQStr = request.getParameter("currentQ");
                int currentQ = (currentQStr != null && !currentQStr.trim().isEmpty()) ? Integer.parseInt(currentQStr.trim()) : 0;
                response.sendRedirect(request.getContextPath() + "/student/exam?attemptId=" + attemptId + "&q=" + currentQ);
                return;
            }
        } catch (Exception e) {
            logger.error("Error processing examination action: {}", action, e);
        }

        response.sendRedirect(request.getContextPath() + "/student/exam?attemptId=" + attemptId);
    }
}
