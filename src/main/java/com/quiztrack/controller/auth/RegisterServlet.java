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
 * Controller handling user registration for candidate and faculty accounts.
 */
@WebServlet(name = "RegisterServlet", urlPatterns = {"/auth/register", "/register"})
public class RegisterServlet extends HttpServlet {

    private static final Logger logger = LoggerFactory.getLogger(RegisterServlet.class);
    private final AuthService authService = new AuthServiceImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        boolean registrationEnabled = com.quiztrack.util.SystemSettingsHelper.getBooleanSetting("registration_enabled", true);
        if (!registrationEnabled) {
            request.setAttribute("registrationDisabled", true);
            request.setAttribute("warningMessage", "Public candidate registration is currently disabled by institutional administrators.");
        }
        request.setAttribute("activeTab", "register");
        request.getRequestDispatcher("/WEB-INF/views/auth/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        boolean registrationEnabled = com.quiztrack.util.SystemSettingsHelper.getBooleanSetting("registration_enabled", true);
        if (!registrationEnabled) {
            request.setAttribute("errorMessage", "Public candidate registration is currently disabled by institutional administrators.");
            request.setAttribute("activeTab", "register");
            request.getRequestDispatcher("/WEB-INF/views/auth/login.jsp").forward(request, response);
            return;
        }

        String fullName = request.getParameter("fullName");
        String identifier = request.getParameter("identifier");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String roleStr = request.getParameter("role"); // 'student' or 'teacher'
        String department = request.getParameter("department");
        String cohort = request.getParameter("cohort");
        boolean biometricConsent = "on".equalsIgnoreCase(request.getParameter("biometricConsent"))
                || "true".equalsIgnoreCase(request.getParameter("biometricConsent"));

        User user = new User();
        user.setFullName(fullName);
        user.setIdentifier(identifier);
        user.setEmail(email);
        user.setDepartment(department);
        user.setCohort(cohort);
        user.setBiometricConsent(biometricConsent);

        if ("teacher".equalsIgnoreCase(roleStr)) {
            user.setRoleId(2);
            user.setRoleName(Role.ROLE_TEACHER);
        } else {
            user.setRoleId(3);
            user.setRoleName(Role.ROLE_STUDENT);
        }

        AuthService.AuthResult result = authService.register(user, password);

        if (result.isSuccess()) {
            logger.info("Auto-authenticating newly registered user: {}", user.getIdentifier());

            // Establish active session immediately
            HttpSession session = request.getSession(true);
            session.setAttribute("currentUser", result.getUser());
            session.setAttribute("userId", result.getUser().getUserId());
            session.setAttribute("userRole", result.getUser().getRoleName());
            session.setAttribute("userFullName", result.getUser().getFullName());
            session.setAttribute("userIdentifier", result.getUser().getIdentifier());
            session.setAttribute("userDepartment", result.getUser().getDepartment());
            session.setAttribute("biometricConsent", result.getUser().isBiometricConsent());

            response.sendRedirect(request.getContextPath() + result.getRedirectUrl());
        } else {
            request.setAttribute("registerError", result.getMessage());
            request.setAttribute("activeTab", "register");
            request.setAttribute("regFullName", fullName);
            request.setAttribute("regIdentifier", identifier);
            request.setAttribute("regEmail", email);
            request.setAttribute("regDepartment", department);
            request.setAttribute("regCohort", cohort);
            request.setAttribute("selectedRole", (roleStr != null) ? roleStr.toLowerCase() : "student");
            request.getRequestDispatcher("/WEB-INF/views/auth/login.jsp").forward(request, response);
        }
    }
}
