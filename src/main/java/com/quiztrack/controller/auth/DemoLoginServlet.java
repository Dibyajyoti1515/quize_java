package com.quiztrack.controller.auth;

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
 * Controller powering the Stitch Instant Sandbox Access demo buttons.
 * Allows evaluators to switch between Student, Teacher and Admin roles with verified seed credentials.
 */
@WebServlet(name = "DemoLoginServlet", urlPatterns = {"/auth/demo"})
public class DemoLoginServlet extends HttpServlet {

    private static final Logger logger = LoggerFactory.getLogger(DemoLoginServlet.class);
    private final AuthService authService = new AuthServiceImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String role = request.getParameter("role");

        String demoIdentifier;
        String demoPassword = "password123";
        String demoRole;

        if ("teacher".equalsIgnoreCase(role)) {
            demoIdentifier = "ronald.vance";
            demoRole = "TEACHER";
        } else if ("admin".equalsIgnoreCase(role)) {
            demoIdentifier = "admin";
            demoRole = "ADMIN";
        } else {
            demoIdentifier = "CS-2022-041"; // Alex Mercer
            demoRole = "STUDENT";
        }

        logger.info("Executing sandbox demo authentication for role: {} (User: {})", demoRole, demoIdentifier);

        AuthService.AuthResult result = authService.authenticate(demoIdentifier, demoPassword, demoRole);
        if (result.isSuccess()) {
            User user = result.getUser();

            HttpSession session = request.getSession(true);
            session.setAttribute("currentUser", user);
            session.setAttribute("userId", user.getUserId());
            session.setAttribute("userRole", user.getRoleName());
            session.setAttribute("userFullName", user.getFullName());
            session.setAttribute("userIdentifier", user.getIdentifier());
            session.setAttribute("userDepartment", user.getDepartment());
            session.setAttribute("biometricConsent", true);
            session.setAttribute("csrfToken", java.util.UUID.randomUUID().toString());

            int sessionTimeout = com.quiztrack.util.SystemSettingsHelper.getIntSetting("session_timeout", 30);
            session.setMaxInactiveInterval(sessionTimeout * 60);

            response.sendRedirect(request.getContextPath() + result.getRedirectUrl());
        } else {
            response.sendRedirect(request.getContextPath() + "/auth/login?error=demo_failed");
        }
    }
}
