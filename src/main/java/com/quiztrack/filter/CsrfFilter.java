package com.quiztrack.filter;

import jakarta.servlet.*;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;
import java.util.Set;
import java.util.UUID;

/**
 * Enforces Cross-Site Request Forgery (CSRF) protection on state-changing HTTP operations
 * across protected routes (/admin/*, /teacher/*, /student/*).
 *
 * Validates 'csrfToken' parameter or 'X-CSRF-Token' request header against the authenticated session token.
 */
public class CsrfFilter implements Filter {

    private static final Logger logger = LoggerFactory.getLogger(CsrfFilter.class);
    private static final Set<String> SAFE_METHODS = Set.of("GET", "HEAD", "OPTIONS", "TRACE");

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;

        HttpSession session = httpRequest.getSession(false);
        String method = httpRequest.getMethod();

        // 1. Ensure a CSRF token exists for any active session
        if (session != null && session.getAttribute("csrfToken") == null) {
            session.setAttribute("csrfToken", UUID.randomUUID().toString());
        }

        // 2. Safe read-only HTTP methods do not mutate server state
        if (SAFE_METHODS.contains(method.toUpperCase())) {
            chain.doFilter(request, response);
            return;
        }

        // 3. Mutating methods (POST, PUT, DELETE, PATCH) require valid CSRF token
        String sessionCsrf = (session != null) ? (String) session.getAttribute("csrfToken") : null;
        String requestCsrf = httpRequest.getParameter("csrfToken");

        if (requestCsrf == null || requestCsrf.isBlank()) {
            requestCsrf = httpRequest.getHeader("X-CSRF-Token");
        }
        if (requestCsrf == null || requestCsrf.isBlank()) {
            requestCsrf = httpRequest.getHeader("X-CSRF-TOKEN");
        }

        boolean valid = sessionCsrf != null && !sessionCsrf.isBlank() && sessionCsrf.equals(requestCsrf);

        if (!valid) {
            String uri = httpRequest.getRequestURI();
            logger.warn("CSRF validation failed for method '{}' on URI '{}'. Session token present: {}, Request token present: {}",
                    method, uri, (sessionCsrf != null), (requestCsrf != null));

            boolean isAjaxOrJson = "XMLHttpRequest".equalsIgnoreCase(httpRequest.getHeader("X-Requested-With"))
                    || (httpRequest.getHeader("Accept") != null && httpRequest.getHeader("Accept").contains("application/json"))
                    || (httpRequest.getContentType() != null && httpRequest.getContentType().contains("application/json"))
                    || uri.endsWith("/autosave")
                    || uri.endsWith("/telemetry")
                    || uri.endsWith("/action");

            if (isAjaxOrJson) {
                httpResponse.setStatus(HttpServletResponse.SC_FORBIDDEN);
                httpResponse.setContentType("application/json;charset=UTF-8");
                httpResponse.getWriter().write("{\"status\":\"FORBIDDEN\",\"message\":\"Security validation failed: Invalid or missing CSRF token.\"}");
                return;
            }

            httpRequest.setAttribute("deniedPath", uri);
            httpRequest.setAttribute("requiredRole", "Valid CSRF Security Token");
            httpRequest.setAttribute("securityError", "Cross-Site Request Forgery (CSRF) validation failed. Your form submission was blocked for safety.");
            httpResponse.setStatus(HttpServletResponse.SC_FORBIDDEN);
            httpRequest.getRequestDispatcher("/WEB-INF/views/common/access-denied.jsp").forward(httpRequest, httpResponse);
            return;
        }

        chain.doFilter(request, response);
    }
}
