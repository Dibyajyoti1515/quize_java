package com.quiztrack.controller.admin;

import com.quiztrack.model.SystemSetting;
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
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

/**
 * Controller servlet for Enterprise System Configuration & Application Parameters.
 * Manages institutional settings, quiz constraints, security pacing, and maintenance modes.
 */
@WebServlet(name = "AdminSettingsServlet", urlPatterns = {"/admin/settings"})
public class AdminSettingsServlet extends HttpServlet {

    private static final Logger logger = LoggerFactory.getLogger(AdminSettingsServlet.class);
    private final AdminService adminService;

    public AdminSettingsServlet() {
        this.adminService = new AdminServiceImpl();
    }

    public AdminSettingsServlet(AdminService adminService) {
        this.adminService = adminService;
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User currentUser = validateAdminAccess(request, response);
        if (currentUser == null) return;

        ensureCsrfToken(request.getSession());

        try {
            List<SystemSetting> settingsList = adminService.getSystemSettings();
            Map<String, SystemSetting> settingsMap = new HashMap<>();
            for (SystemSetting s : settingsList) {
                settingsMap.put(s.getSettingKey(), s);
            }

            request.setAttribute("settingsList", settingsList);
            request.setAttribute("settingsMap", settingsMap);
            request.setAttribute("activeTab", "settings");
            request.setAttribute("currentUser", currentUser);

            request.getRequestDispatcher("/WEB-INF/views/admin/settings.jsp").forward(request, response);

        } catch (Exception e) {
            logger.error("Error loading system configuration settings", e);
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Failed to load system settings.");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User currentUser = validateAdminAccess(request, response);
        if (currentUser == null) return;

        // Verify CSRF token strictly
        HttpSession session = request.getSession(false);
        String sessionCsrf = (session != null) ? (String) session.getAttribute("csrfToken") : null;
        String requestCsrf = request.getParameter("csrfToken");
        if (sessionCsrf == null || requestCsrf == null || !sessionCsrf.equals(requestCsrf)) {
            logger.warn("CSRF token missing or mismatch for admin settings update by {}", currentUser.getUserId());
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Invalid or missing security token (CSRF). Action blocked.");
            return;
        }

        Map<String, String> updatedSettings = new HashMap<>();
        String[] keys = {
                "app_name",
                "default_quiz_duration",
                "max_quiz_duration",
                "default_passing_percentage",
                "max_login_attempts",
                "session_timeout",
                "maintenance_mode",
                "registration_enabled"
        };

        for (String k : keys) {
            String v = request.getParameter(k);
            if (v != null) {
                updatedSettings.put(k, v.trim());
            }
        }

        try {
            boolean ok = adminService.updateSystemSettings(updatedSettings, currentUser.getUserId());
            if (ok) {
                redirectWithSuccess(request, response, "System configuration settings updated successfully.");
            } else {
                redirectWithError(request, response, "No configuration settings were updated.");
            }
        } catch (IllegalArgumentException iae) {
            logger.warn("System settings validation error: {}", iae.getMessage());
            redirectWithError(request, response, iae.getMessage());
        } catch (Exception e) {
            logger.error("Error updating system settings", e);
            redirectWithError(request, response, "Failed to update configuration: " + e.getMessage());
        }
    }

    private User validateAdminAccess(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("currentUser") : null;

        if (user == null || !user.isAdmin()) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access forbidden to system configuration.");
            return null;
        }
        return user;
    }

    private void ensureCsrfToken(HttpSession session) {
        if (session.getAttribute("csrfToken") == null) {
            session.setAttribute("csrfToken", UUID.randomUUID().toString());
        }
    }

    private void redirectWithSuccess(HttpServletRequest request, HttpServletResponse response, String message) throws IOException {
        response.sendRedirect(request.getContextPath() + "/admin/settings?success=" + URLEncoder.encode(message, StandardCharsets.UTF_8));
    }

    private void redirectWithError(HttpServletRequest request, HttpServletResponse response, String message) throws IOException {
        response.sendRedirect(request.getContextPath() + "/admin/settings?error=" + URLEncoder.encode(message, StandardCharsets.UTF_8));
    }
}
