package com.quiztrack.controller.auth;

import com.quiztrack.model.Role;
import com.quiztrack.model.User;
import com.quiztrack.service.AuthService;
import com.quiztrack.service.impl.AuthServiceImpl;
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
 * Controller handling user authentication, role context evaluation, and session initialization.
 */
@WebServlet(name = "LoginServlet", urlPatterns = {"/auth/login", "/login"})
public class LoginServlet extends HttpServlet {

    private static final Logger logger = LoggerFactory.getLogger(LoginServlet.class);
    private final AuthService authService = new AuthServiceImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session != null) {
            User currentUser = (User) session.getAttribute("currentUser");
            if (currentUser != null) {
                // Already authenticated, redirect to authorized dashboard
                response.sendRedirect(request.getContextPath() + getRoleDashboard(currentUser.getRoleName()));
                return;
            }
        }

        // Check flash query parameters
        String logout = request.getParameter("logout");
        if ("success".equals(logout)) {
            request.setAttribute("infoMessage", "You have been securely signed out of QuizTrack.");
        }

        String auth = request.getParameter("auth");
        if ("required".equals(auth)) {
            request.setAttribute("warningMessage", "Please sign in to access your protected workspace.");
        }

        String registered = request.getParameter("registered");
        if ("success".equals(registered)) {
            request.setAttribute("successMessage", "Account successfully registered! Please sign in with your credentials.");
        }

        request.getRequestDispatcher("/WEB-INF/views/auth/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String identifier = request.getParameter("identifier");
        String password = request.getParameter("password");
        String role = request.getParameter("role"); // 'student', 'teacher', 'admin'
        boolean biometricConsent = "on".equalsIgnoreCase(request.getParameter("biometricConsent"))
                || "true".equalsIgnoreCase(request.getParameter("biometricConsent"));

        AuthService.AuthResult result = authService.authenticate(identifier, password, role);

        if (result.isSuccess()) {
            User user = result.getUser();

            // Maintenance mode check: if maintenance mode is active, only ADMIN accounts can log in
            boolean maintenance = com.quiztrack.util.SystemSettingsHelper.getBooleanSetting("maintenance_mode", false);
            if (maintenance && !user.isAdmin()) {
                logger.warn("Login blocked during maintenance mode for user '{}' [{}]", user.getIdentifier(), user.getRoleName());
                request.setAttribute("errorMessage", "System is currently undergoing scheduled maintenance. Non-administrative access is temporarily paused.");
                request.setAttribute("typedIdentifier", identifier);
                request.setAttribute("selectedRole", (role != null) ? role.toLowerCase() : "student");
                request.getRequestDispatcher("/WEB-INF/views/auth/login.jsp").forward(request, response);
                return;
            }

            // Session Fixation Protection: Invalidate old session and allocate new session ID
            HttpSession oldSession = request.getSession(false);
            String redirectTarget = null;
            if (oldSession != null) {
                redirectTarget = (String) oldSession.getAttribute("redirectTarget");
                oldSession.invalidate();
            }

            HttpSession session = request.getSession(true);
            session.setAttribute("currentUser", user);
            session.setAttribute("userId", user.getUserId());
            session.setAttribute("userRole", user.getRoleName());
            session.setAttribute("userFullName", user.getFullName());
            session.setAttribute("userIdentifier", user.getIdentifier());
            session.setAttribute("userDepartment", user.getDepartment());
            session.setAttribute("biometricConsent", biometricConsent || user.isBiometricConsent());
            session.setAttribute("csrfToken", java.util.UUID.randomUUID().toString());

            // Enforce dynamic session timeout from system settings
            int sessionTimeout = com.quiztrack.util.SystemSettingsHelper.getIntSetting("session_timeout", 30);
            session.setMaxInactiveInterval(sessionTimeout * 60);

            logger.info("Session established for user: {} [{}]", user.getIdentifier(), user.getRoleName());

            if (redirectTarget != null && !redirectTarget.isEmpty() && !redirectTarget.contains("/auth/")) {
                response.sendRedirect(redirectTarget);
            } else {
                response.sendRedirect(request.getContextPath() + result.getRedirectUrl());
            }
        } else {
            request.setAttribute("errorMessage", result.getMessage());
            request.setAttribute("typedIdentifier", identifier);
            request.setAttribute("selectedRole", (role != null) ? role.toLowerCase() : "student");
            request.getRequestDispatcher("/WEB-INF/views/auth/login.jsp").forward(request, response);
        }
    }

    private String getRoleDashboard(String roleName) {
        if (roleName == null) return "/student/dashboard";
        switch (roleName.toUpperCase()) {
            case Role.ROLE_ADMIN:
                return "/admin/dashboard";
            case Role.ROLE_TEACHER:
                return "/teacher/dashboard";
            case Role.ROLE_STUDENT:
            default:
                return "/student/dashboard";
        }
    }
}
