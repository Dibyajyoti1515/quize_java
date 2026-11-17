package com.quiztrack.controller.teacher;

import com.quiztrack.model.*;
import com.quiztrack.service.ProctorService;
import com.quiztrack.service.impl.ProctorServiceImpl;
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
import java.util.List;

/**
 * Controller servlet for Teacher Live Monitoring & Proctoring Command Center.
 * Handles dashboard rendering, JSON polling feeds, and proctoring interventions.
 */
@WebServlet(name = "TeacherProctoringServlet", urlPatterns = {
        "/teacher/proctoring",
        "/teacher/proctoring/feed",
        "/teacher/proctoring/timeline",
        "/teacher/proctoring/action"
})
public class TeacherProctoringServlet extends HttpServlet {

    private static final Logger logger = LoggerFactory.getLogger(TeacherProctoringServlet.class);
    private final ProctorService proctorService;

    public TeacherProctoringServlet() {
        this.proctorService = new ProctorServiceImpl();
    }

    public TeacherProctoringServlet(ProctorService proctorService) {
        this.proctorService = proctorService;
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User currentUser = validateTeacherAccess(request, response);
        if (currentUser == null) return;

        String path = request.getServletPath();

        // 1. Live JSON Feed Endpoint for Client Polling
        if ("/teacher/proctoring/feed".equals(path)) {
            handleLiveFeedRequest(request, response, currentUser);
            return;
        }

        // 2. Student Event Timeline JSON Endpoint
        if ("/teacher/proctoring/timeline".equals(path)) {
            handleTimelineRequest(request, response, currentUser);
            return;
        }

        // 3. Main Command Center HTML View
        int quizId = parseQuizId(request);

        try {
            TeacherLiveMonitoringData data = proctorService.getMonitoringDashboard(quizId, currentUser.getUserId());
            request.setAttribute("monitoringData", data);
            request.setAttribute("currentUser", currentUser);
            request.setAttribute("activeTab", "proctoring");

            request.getRequestDispatcher("/WEB-INF/views/teacher/proctoring-command-center.jsp").forward(request, response);

        } catch (SecurityException se) {
            logger.warn("Security violation by teacher {}: {}", currentUser.getUserId(), se.getMessage());
            response.sendError(HttpServletResponse.SC_FORBIDDEN, se.getMessage());
        } catch (Exception e) {
            logger.error("Error loading teacher proctoring dashboard", e);
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Failed to load proctoring console.");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User currentUser = validateTeacherAccess(request, response);
        if (currentUser == null) return;

        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();

        String action = request.getParameter("action");
        if (action == null || action.isBlank()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.print("{\"status\":\"ERROR\",\"message\":\"Missing action parameter\"}");
            return;
        }

        try {
            switch (action.toLowerCase()) {
                case "flag": {
                    int attemptId = Integer.parseInt(request.getParameter("attemptId"));
                    String reason = request.getParameter("reason");
                    boolean ok = proctorService.flagStudentAttempt(attemptId, currentUser.getUserId(), reason);
                    out.print("{\"status\":\"" + (ok ? "SUCCESS" : "ERROR") + "\"}");
                    break;
                }
                case "clear_flag": {
                    int attemptId = Integer.parseInt(request.getParameter("attemptId"));
                    String reason = request.getParameter("reason");
                    boolean ok = proctorService.clearStudentFlag(attemptId, currentUser.getUserId(), reason);
                    out.print("{\"status\":\"" + (ok ? "SUCCESS" : "ERROR") + "\"}");
                    break;
                }
                case "review_event": {
                    int logId = Integer.parseInt(request.getParameter("logId"));
                    String notes = request.getParameter("notes");
                    boolean ok = proctorService.reviewEvent(logId, currentUser.getUserId(), notes);
                    out.print("{\"status\":\"" + (ok ? "SUCCESS" : "ERROR") + "\"}");
                    break;
                }
                case "broadcast": {
                    int quizId = Integer.parseInt(request.getParameter("quizId"));
                    String message = request.getParameter("message");
                    boolean ok = proctorService.broadcastNotice(quizId, currentUser.getUserId(), message);
                    out.print("{\"status\":\"" + (ok ? "SUCCESS" : "ERROR") + "\"}");
                    break;
                }
                default:
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    out.print("{\"status\":\"ERROR\",\"message\":\"Unsupported action: " + action + "\"}");
            }
        } catch (SecurityException se) {
            logger.warn("Unauthorized proctor action attempt by teacher {}: {}", currentUser.getUserId(), se.getMessage());
            response.setStatus(HttpServletResponse.SC_FORBIDDEN);
            out.print("{\"status\":\"FORBIDDEN\",\"message\":\"" + se.getMessage() + "\"}");
        } catch (Exception e) {
            logger.error("Error processing proctor action", e);
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print("{\"status\":\"ERROR\",\"message\":\"Internal server error\"}");
        }
    }

    private User validateTeacherAccess(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("currentUser") : null;

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/auth/login");
            return null;
        }

        String role = user.getRoleName();
        if (!"TEACHER".equalsIgnoreCase(role) && !"ADMIN".equalsIgnoreCase(role)) {
            logger.warn("Access denied to proctoring command center for role: {}", role);
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Student access is forbidden to Teacher Proctoring Command Center.");
            return null;
        }

        return user;
    }

    private int parseQuizId(HttpServletRequest request) {
        String param = request.getParameter("quizId");
        if (param != null && !param.isBlank()) {
            try {
                return Integer.parseInt(param.trim());
            } catch (NumberFormatException ignored) {}
        }
        return 0;
    }

    private void handleLiveFeedRequest(HttpServletRequest request, HttpServletResponse response, User teacher) throws IOException {
        int quizId = parseQuizId(request);
        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();

        try {
            TeacherLiveMonitoringData data = proctorService.getMonitoringDashboard(quizId, teacher.getUserId());

            StringBuilder json = new StringBuilder("{");
            json.append("\"quizId\":").append(data.getQuizId()).append(",");
            json.append("\"activeCount\":").append(data.getActiveCount()).append(",");
            json.append("\"submittedCount\":").append(data.getSubmittedCount()).append(",");
            json.append("\"flaggedCount\":").append(data.getFlaggedCount()).append(",");
            json.append("\"criticalCount\":").append(data.getCriticalCount()).append(",");
            json.append("\"averageProgress\":").append(data.getAverageProgress()).append(",");
            json.append("\"averageIntegrity\":").append(data.getAverageIntegrityIndex()).append(",");

            // Examinees array
            json.append("\"examinees\":[");
            List<LiveExamineeDto> list = data.getExaminees();
            for (int i = 0; i < list.size(); i++) {
                LiveExamineeDto e = list.get(i);
                if (i > 0) json.append(",");
                json.append("{")
                    .append("\"attemptId\":").append(e.getAttemptId()).append(",")
                    .append("\"studentName\":\"").append(escapeJson(e.getStudentName())).append("\",")
                    .append("\"identifier\":\"").append(escapeJson(e.getStudentIdentifier())).append("\",")
                    .append("\"status\":\"").append(e.getStatus()).append("\",")
                    .append("\"remaining\":\"").append(e.getRemainingFormatted()).append("\",")
                    .append("\"lastActivity\":\"").append(e.getLastActivityFormatted()).append("\",")
                    .append("\"tabSwitches\":").append(e.getTabSwitchCount()).append(",")
                    .append("\"blurs\":").append(e.getBlurCount()).append(",")
                    .append("\"fullscreenExits\":").append(e.getFullscreenExitCount()).append(",")
                    .append("\"integrityIndex\":").append(e.getIntegrityIndex()).append(",")
                    .append("\"integrityLevel\":\"").append(e.getIntegrityLevel()).append("\",")
                    .append("\"isFlagged\":").append(e.isFlagged())
                    .append("}");
            }
            json.append("],");

            // Recent Events count
            json.append("\"recentEventCount\":").append(data.getRecentEvents().size());
            json.append("}");

            out.print(json.toString());

        } catch (SecurityException se) {
            response.setStatus(HttpServletResponse.SC_FORBIDDEN);
            out.print("{\"status\":\"FORBIDDEN\"}");
        } catch (Exception e) {
            logger.error("Error generating live feed", e);
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print("{\"status\":\"ERROR\"}");
        }
    }

    private void handleTimelineRequest(HttpServletRequest request, HttpServletResponse response, User teacher) throws IOException {
        String attemptParam = request.getParameter("attemptId");
        if (attemptParam == null || attemptParam.isBlank()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing attemptId parameter");
            return;
        }

        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();

        try {
            int attemptId = Integer.parseInt(attemptParam.trim());
            List<ProctorActivityEventDto> timeline = proctorService.getStudentTimeline(attemptId, teacher.getUserId());

            StringBuilder json = new StringBuilder("[");
            for (int i = 0; i < timeline.size(); i++) {
                ProctorActivityEventDto ev = timeline.get(i);
                if (i > 0) json.append(",");
                json.append("{")
                    .append("\"logId\":").append(ev.getLogId()).append(",")
                    .append("\"eventType\":\"").append(ev.getEventType()).append("\",")
                    .append("\"severity\":\"").append(ev.getSeverity()).append("\",")
                    .append("\"details\":\"").append(escapeJson(ev.getDetails())).append("\",")
                    .append("\"timestamp\":\"").append(ev.getTimestampFormatted()).append("\",")
                    .append("\"isReviewed\":").append(ev.isReviewed()).append(",")
                    .append("\"reviewNotes\":\"").append(escapeJson(ev.getReviewNotes())).append("\"")
                    .append("}");
            }
            json.append("]");
            out.print(json.toString());

        } catch (SecurityException se) {
            response.setStatus(HttpServletResponse.SC_FORBIDDEN);
            out.print("{\"status\":\"FORBIDDEN\"}");
        } catch (Exception e) {
            logger.error("Error retrieving student timeline", e);
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print("{\"status\":\"ERROR\"}");
        }
    }

    private String escapeJson(String s) {
        if (s == null) return "";
        return s.replace("\\", "\\\\").replace("\"", "\\\"").replace("\n", "\\n").replace("\r", "");
    }
}
