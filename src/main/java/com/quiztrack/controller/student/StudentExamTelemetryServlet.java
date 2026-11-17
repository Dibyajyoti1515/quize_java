package com.quiztrack.controller.student;

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

/**
 * Controller receiving candidate integrity telemetry (window blur, tab switch, fullscreen changes).
 */
@WebServlet(name = "StudentExamTelemetryServlet", urlPatterns = {"/student/exam/telemetry"})
public class StudentExamTelemetryServlet extends HttpServlet {

    private static final Logger logger = LoggerFactory.getLogger(StudentExamTelemetryServlet.class);
    private final ExamService examService;

    public StudentExamTelemetryServlet() {
        this.examService = new ExamServiceImpl();
    }

    public StudentExamTelemetryServlet(ExamService examService) {
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
            out.print("{\"status\":\"UNAUTHORIZED\"}");
            return;
        }

        int studentId = (Integer) session.getAttribute("userId");

        try {
            int attemptId = Integer.parseInt(request.getParameter("attemptId"));
            String eventType = request.getParameter("eventType");
            String details = request.getParameter("details");

            examService.recordTelemetry(attemptId, studentId, eventType, "CAUTION", details);
            out.print("{\"status\":\"RECORDED\"}");
        } catch (Exception e) {
            logger.error("Telemetry logging error", e);
            out.print("{\"status\":\"ERROR\"}");
        }
    }
}
