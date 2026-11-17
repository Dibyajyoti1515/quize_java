package com.quiztrack.filter;

import com.quiztrack.model.User;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;

/**
 * Enforces session authentication for all protected dashboard and API paths.
 * Redirects unauthenticated requests to the login gateway.
 */
@WebFilter(filterName = "AuthenticationFilter", urlPatterns = {"/admin/*", "/teacher/*", "/student/*", "/api/*"})
public class AuthenticationFilter implements Filter {

    private static final Logger logger = LoggerFactory.getLogger(AuthenticationFilter.class);

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;

        HttpSession session = httpRequest.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("currentUser") : null;

        if (currentUser == null) {
            String requestUri = httpRequest.getRequestURI();
            String queryString = httpRequest.getQueryString();
            String targetUrl = (queryString == null) ? requestUri : requestUri + "?" + queryString;

            logger.warn("Unauthenticated access attempt to '{}' - redirecting to login gateway", targetUrl);

            // Store intended target in a new session if needed
            HttpSession newSession = httpRequest.getSession(true);
            newSession.setAttribute("redirectTarget", targetUrl);

            String contextPath = httpRequest.getContextPath();
            httpResponse.sendRedirect(contextPath + "/auth/login?auth=required");
            return;
        }

        // Enforce system maintenance_mode setting
        if (com.quiztrack.util.SystemSettingsHelper.getBooleanSetting("maintenance_mode", false)) {
            if (!currentUser.isAdmin()) {
                logger.warn("Access to '{}' blocked during maintenance mode for non-admin user '{}'",
                        httpRequest.getRequestURI(), currentUser.getIdentifier());
                httpResponse.setStatus(HttpServletResponse.SC_SERVICE_UNAVAILABLE);
                httpRequest.setAttribute("maintenanceNotice", "QuizTrack is undergoing scheduled system maintenance. Student and faculty workspaces are temporarily paused.");
                httpRequest.getRequestDispatcher("/WEB-INF/views/common/maintenance.jsp").forward(httpRequest, httpResponse);
                return;
            }
        }

        chain.doFilter(request, response);
    }
}
