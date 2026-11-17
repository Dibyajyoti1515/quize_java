package com.quiztrack.controller.admin;

import com.quiztrack.model.AuditLogEntryDto;
import com.quiztrack.model.User;
import com.quiztrack.service.AdminService;
import com.quiztrack.service.impl.AdminServiceImpl;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;
import java.sql.Timestamp;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeParseException;
import java.util.List;

/**
 * Controller servlet for Enterprise Audit Trail & Security Oversight.
 * Provides query capabilities, severity filtering, date range boundaries, and secret redaction.
 */
@WebServlet(name = "AdminAuditLogServlet", urlPatterns = {"/admin/audit-logs"})
public class AdminAuditLogServlet extends HttpServlet {

    private static final Logger logger = LoggerFactory.getLogger(AdminAuditLogServlet.class);
    private final AdminService adminService;

    public AdminAuditLogServlet() {
        this.adminService = new AdminServiceImpl();
    }

    public AdminAuditLogServlet(AdminService adminService) {
        this.adminService = adminService;
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User currentUser = validateAdminAccess(request, response);
        if (currentUser == null) return;

        String eventType = request.getParameter("eventType");
        String userQuery = request.getParameter("userQuery");
        String severity = request.getParameter("severity");
        String startDateStr = request.getParameter("startDate");
        String endDateStr = request.getParameter("endDate");

        Timestamp startTimestamp = null;
        Timestamp endTimestamp = null;

        if (startDateStr != null && !startDateStr.isBlank()) {
            try {
                LocalDate sd = LocalDate.parse(startDateStr.trim());
                startTimestamp = Timestamp.valueOf(sd.atStartOfDay());
            } catch (DateTimeParseException ignored) {}
        }

        if (endDateStr != null && !endDateStr.isBlank()) {
            try {
                LocalDate ed = LocalDate.parse(endDateStr.trim());
                endTimestamp = Timestamp.valueOf(ed.atTime(23, 59, 59));
            } catch (DateTimeParseException ignored) {}
        }

        int page = 1;
        int pageSize = 25;
        String pageParam = request.getParameter("page");
        if (pageParam != null && !pageParam.isBlank()) {
            try {
                page = Math.max(1, Integer.parseInt(pageParam.trim()));
            } catch (NumberFormatException ignored) {}
        }

        try {
            List<AuditLogEntryDto> logs = adminService.getAuditLogs(eventType, userQuery, severity, startTimestamp, endTimestamp, page, pageSize);
            int totalCount = adminService.countAuditLogs(eventType, userQuery, severity, startTimestamp, endTimestamp);
            int totalPages = (int) Math.ceil((double) totalCount / pageSize);

            request.setAttribute("auditLogs", logs);
            request.setAttribute("totalCount", totalCount);
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", Math.max(1, totalPages));
            request.setAttribute("eventTypeParam", eventType != null ? eventType : "ALL");
            request.setAttribute("userQueryParam", userQuery != null ? userQuery : "");
            request.setAttribute("severityParam", severity != null ? severity : "ALL");
            request.setAttribute("startDateParam", startDateStr != null ? startDateStr : "");
            request.setAttribute("endDateParam", endDateStr != null ? endDateStr : "");
            request.setAttribute("activeTab", "audit-logs");
            request.setAttribute("currentUser", currentUser);

            request.getRequestDispatcher("/WEB-INF/views/admin/audit-logs.jsp").forward(request, response);

        } catch (Exception e) {
            logger.error("Error retrieving system audit logs", e);
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Failed to load audit logs.");
        }
    }

    private User validateAdminAccess(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("currentUser") : null;

        if (user == null || !user.isAdmin()) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access forbidden to audit trail console.");
            return null;
        }
        return user;
    }
}
