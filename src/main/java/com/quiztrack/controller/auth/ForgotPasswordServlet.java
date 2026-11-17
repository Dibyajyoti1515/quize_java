package com.quiztrack.controller.auth;

import com.quiztrack.service.AuthService;
import com.quiztrack.service.impl.AuthServiceImpl;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;

/**
 * Controller handling password reset initiation and audit recording.
 */
@WebServlet(name = "ForgotPasswordServlet", urlPatterns = {"/auth/forgot-password"})
public class ForgotPasswordServlet extends HttpServlet {

    private static final Logger logger = LoggerFactory.getLogger(ForgotPasswordServlet.class);
    private final AuthService authService = new AuthServiceImpl();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        if (email != null && !email.trim().isEmpty()) {
            boolean requested = authService.requestPasswordReset(email.trim());
            logger.info("Password reset processed for email: '{}' (found: {})", email, requested);
            request.setAttribute("infoMessage", "If an account matches '" + email.trim() + "', a security token and verification link have been dispatched.");
        } else {
            request.setAttribute("warningMessage", "Please enter a valid account email address.");
        }

        request.getRequestDispatcher("/WEB-INF/views/auth/login.jsp").forward(request, response);
    }
}
