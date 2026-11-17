package com.quiztrack.controller.student;

import com.quiztrack.model.CertificateDto;
import com.quiztrack.model.LeaderboardViewDto;
import com.quiztrack.model.User;
import com.quiztrack.service.LeaderboardService;
import com.quiztrack.service.impl.LeaderboardServiceImpl;
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
 * Controller servlet for candidate cohort leaderboards, podium stand, and verified credential modals.
 */
@WebServlet(name = "StudentLeaderboardServlet", urlPatterns = {"/student/leaderboard", "/student/leaderboard/certificate"})
public class StudentLeaderboardServlet extends HttpServlet {

    private static final Logger logger = LoggerFactory.getLogger(StudentLeaderboardServlet.class);
    private final LeaderboardService leaderboardService;

    public StudentLeaderboardServlet() {
        this.leaderboardService = new LeaderboardServiceImpl();
    }

    public StudentLeaderboardServlet(LeaderboardService leaderboardService) {
        this.leaderboardService = leaderboardService;
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("currentUser") : null;
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/auth/login");
            return;
        }

        String path = request.getServletPath();

        // 1. Certificate Modal Data Endpoint
        if ("/student/leaderboard/certificate".equals(path)) {
            handleCertificateRequest(request, response, currentUser);
            return;
        }

        // 2. Main Leaderboard Page
        int quizId = 0;
        String quizParam = request.getParameter("quizId");
        if (quizParam != null && !quizParam.isBlank()) {
            try {
                quizId = Integer.parseInt(quizParam.trim());
            } catch (NumberFormatException ignored) {}
        }

        Integer subjectId = null;
        String subjectParam = request.getParameter("subjectId");
        if (subjectParam != null && !subjectParam.isBlank()) {
            try {
                int sId = Integer.parseInt(subjectParam.trim());
                if (sId > 0) {
                    subjectId = sId;
                }
            } catch (NumberFormatException ignored) {}
        }

        String timeFilter = request.getParameter("time");
        if (timeFilter == null || timeFilter.isBlank()) {
            timeFilter = "ALL";
        }

        try {
            LeaderboardViewDto leaderboardView = leaderboardService.getLeaderboardView(
                    quizId, subjectId, timeFilter, currentUser.getUserId());

            request.setAttribute("leaderboardView", leaderboardView);
            request.setAttribute("currentUser", currentUser);
            request.setAttribute("activeTab", "leaderboard");

            String openCertParam = request.getParameter("openCert");
            if ("true".equalsIgnoreCase(openCertParam)) {
                request.setAttribute("openCertificateModal", true);
            }

            request.getRequestDispatcher("/WEB-INF/views/student/leaderboard.jsp").forward(request, response);

        } catch (Exception e) {
            logger.error("Error loading cohort leaderboard for user: {}", currentUser.getUserId(), e);
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Failed to load leaderboard data.");
        }
    }

    private void handleCertificateRequest(HttpServletRequest request, HttpServletResponse response, User currentUser)
            throws IOException {
        String quizParam = request.getParameter("quizId");
        String studentParam = request.getParameter("studentId");

        int quizId = 0;
        int studentId = currentUser.getUserId();

        try {
            if (quizParam != null) {
                quizId = Integer.parseInt(quizParam.trim());
            }
            if (studentParam != null) {
                studentId = Integer.parseInt(studentParam.trim());
            }
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid query parameters.");
            return;
        }

        try {
            CertificateDto cert = leaderboardService.getVerifiedCertificate(
                    quizId, studentId, currentUser.getUserId(), currentUser.getRoleName());

            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().write(String.format(
                    "{\"status\":\"%s\",\"certificateId\":\"%s\",\"studentName\":\"%s\",\"quizTitle\":\"%s\",\"score\":\"%s\",\"grade\":\"%s\",\"hash\":\"%s\"}",
                    cert.getStatus(), cert.getCertificateId(), cert.getStudentName(), cert.getQuizTitle(),
                    cert.getScore().toString(), cert.getGrade(), cert.getCertificateHash()
            ));

        } catch (SecurityException se) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, se.getMessage());
        } catch (IllegalArgumentException iae) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, iae.getMessage());
        } catch (Exception e) {
            logger.error("Error fetching certificate modal data", e);
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Internal server error.");
        }
    }
}
