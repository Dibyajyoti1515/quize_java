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
import java.io.PrintWriter;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Optional;

/**
 * Endpoint for high-frequency background answer synchronization.
 * Supports AJAX autosave calls on radio selection and review toggles.
 */
@WebServlet(name = "StudentExamAutosaveServlet", urlPatterns = {"/student/exam/autosave"})
public class StudentExamAutosaveServlet extends HttpServlet {

    private static final Logger logger = LoggerFactory.getLogger(StudentExamAutosaveServlet.class);
    private final ExamService examService;

    public StudentExamAutosaveServlet() {
        this.examService = new ExamServiceImpl();
    }

    public StudentExamAutosaveServlet(ExamService examService) {
        this.examService = examService;
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            out.print("{\"status\":\"UNAUTHORIZED\",\"message\":\"Session expired\"}");
            return;
        }

        int studentId = (Integer) session.getAttribute("userId");

        try {
            int attemptId = Integer.parseInt(request.getParameter("attemptId"));
            int questionId = Integer.parseInt(request.getParameter("questionId"));
            boolean isFlagged = "true".equalsIgnoreCase(request.getParameter("isFlagged"));

            java.util.List<Integer> selectedOptionIds = new java.util.ArrayList<>();
            String[] multiParamValues = request.getParameterValues("selectedOptionId");
            if (multiParamValues != null) {
                for (String v : multiParamValues) {
                    if (v != null && !v.trim().isEmpty() && !"0".equals(v.trim())) {
                        try {
                            int id = Integer.parseInt(v.trim());
                            if (!selectedOptionIds.contains(id)) selectedOptionIds.add(id);
                        } catch (NumberFormatException ignored) {}
                    }
                }
            }
            String commaList = request.getParameter("selectedOptionIds");
            if (commaList != null && !commaList.trim().isEmpty()) {
                for (String part : commaList.split(",")) {
                    if (part != null && !part.trim().isEmpty() && !"0".equals(part.trim())) {
                        try {
                            int id = Integer.parseInt(part.trim());
                            if (!selectedOptionIds.contains(id)) selectedOptionIds.add(id);
                        } catch (NumberFormatException ignored) {}
                    }
                }
            }

            boolean saved = examService.saveAnswer(attemptId, studentId, questionId, selectedOptionIds, isFlagged);
            Optional<QuizAttempt> attemptOpt = examService.getAttemptById(attemptId, studentId);

            long remainingSec = 0;
            boolean isExpired = false;
            if (attemptOpt.isPresent()) {
                long now = System.currentTimeMillis();
                remainingSec = attemptOpt.get().getRemainingSeconds(now);
                isExpired = attemptOpt.get().isExpired(now);
            }

            String timestamp = new SimpleDateFormat("HH:mm:ss").format(new Date());

            if (saved) {
                out.printf("{\"status\":\"SAVED\",\"timestamp\":\"%s\",\"remainingSeconds\":%d,\"isExpired\":%b}",
                        timestamp, remainingSec, isExpired);
            } else {
                out.printf("{\"status\":\"REJECTED\",\"message\":\"Attempt invalid or expired\",\"isExpired\":%b}", isExpired);
            }
        } catch (Exception e) {
            logger.error("Autosave error", e);
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.print("{\"status\":\"ERROR\",\"message\":\"Invalid request parameters\"}");
        }
    }
}
