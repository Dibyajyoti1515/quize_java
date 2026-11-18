package com.quiztrack.controller.student;

import com.quiztrack.model.StudentResultDto;
import com.quiztrack.service.ResultService;
import com.quiztrack.service.impl.ResultServiceImpl;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;
import java.util.List;

/**
 * Controller delivering candidate examination scorecards, performance analytics, and question review.
 * Directly maps to Stitch 'student_exam_results_performance_analytics'.
 */
@WebServlet(name = "StudentResultsServlet", urlPatterns = {"/student/results", "/student/results/view"})
public class StudentResultsServlet extends HttpServlet {

    private static final Logger logger = LoggerFactory.getLogger(StudentResultsServlet.class);
    private final ResultService resultService;

    public StudentResultsServlet() {
        this.resultService = new ResultServiceImpl();
    }

    public StudentResultsServlet(ResultService resultService) {
        this.resultService = resultService;
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
        String quizIdStr = request.getParameter("quizId");

        try {
            List<StudentResultDto> historyList = resultService.getResultsHistory(studentId);
            StudentResultDto resultDto = null;

            if (attemptIdStr != null && !attemptIdStr.trim().isEmpty()) {
                try {
                    int attemptId = Integer.parseInt(attemptIdStr.trim());
                    resultDto = resultService.getExamResult(attemptId, studentId);
                } catch (NumberFormatException ignored) {}
            }

            if (resultDto == null && quizIdStr != null && !quizIdStr.trim().isEmpty()) {
                try {
                    int qId = Integer.parseInt(quizIdStr.trim());
                    for (StudentResultDto h : historyList) {
                        if (h.getQuizId() == qId) {
                            resultDto = resultService.getExamResult(h.getAttemptId(), studentId);
                            break;
                        }
                    }
                } catch (NumberFormatException ignored) {}
            }

            if (resultDto == null) {
                resultDto = resultService.getLatestResult(studentId);
            }

            request.setAttribute("result", resultDto);
            request.setAttribute("historyList", historyList);
            request.getRequestDispatcher("/WEB-INF/views/student/exam-results.jsp").forward(request, response);
            return;
        } catch (SecurityException se) {
            logger.warn("Unauthorized result access attempt by student {}: {}", studentId, se.getMessage());
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access forbidden to requested examination result transcript.");
            return;
        } catch (Exception e) {
            logger.error("Error loading results for student: {}", studentId, e);
        }

        response.sendRedirect(request.getContextPath() + "/student/dashboard");
    }
}
