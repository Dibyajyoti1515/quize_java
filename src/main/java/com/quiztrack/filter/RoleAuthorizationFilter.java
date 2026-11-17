package com.quiztrack.filter;

import com.quiztrack.dao.UserDao;
import com.quiztrack.dao.impl.UserDaoImpl;
import com.quiztrack.model.Role;
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
 * Enforces Role-Based Access Control (RBAC) across Admin, Teacher, and Student routes.
 * Strictly prevents privilege escalation and lateral movement.
 */
@WebFilter(filterName = "RoleAuthorizationFilter", urlPatterns = {"/admin/*", "/teacher/*", "/student/*"})
public class RoleAuthorizationFilter implements Filter {

    private static final Logger logger = LoggerFactory.getLogger(RoleAuthorizationFilter.class);
    private final UserDao userDao = new UserDaoImpl();

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;

        HttpSession session = httpRequest.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("currentUser") : null;

        if (currentUser == null) {
            // Let AuthenticationFilter handle unauthenticated state
            chain.doFilter(request, response);
            return;
        }

        String requestPath = httpRequest.getRequestURI();
        String contextPath = httpRequest.getContextPath();
        String relativePath = requestPath.substring(contextPath.length());
        String role = (currentUser.getRoleName() != null) ? currentUser.getRoleName().toUpperCase() : "";

        boolean authorized = true;
        String requiredRole = "";

        if (relativePath.startsWith("/admin/")) {
            requiredRole = Role.ROLE_ADMIN;
            authorized = Role.ROLE_ADMIN.equals(role);
        } else if (relativePath.startsWith("/teacher/")) {
            requiredRole = Role.ROLE_TEACHER;
            authorized = Role.ROLE_TEACHER.equals(role) || Role.ROLE_ADMIN.equals(role);
        } else if (relativePath.startsWith("/student/")) {
            requiredRole = Role.ROLE_STUDENT;
            authorized = Role.ROLE_STUDENT.equals(role) || Role.ROLE_ADMIN.equals(role);
        }

        if (!authorized) {
            logger.warn("Security Alert: User '{}' with role '{}' denied access to '{}' (Requires: {})",
                    currentUser.getIdentifier(), role, relativePath, requiredRole);

            userDao.logActivity(currentUser.getUserId(), "UNAUTHORIZED_ACCESS_BLOCKED", "CRITICAL",
                    "Blocked attempt to access " + relativePath + " (User Role: " + role + ", Required: " + requiredRole + ")");

            httpRequest.setAttribute("deniedPath", relativePath);
            httpRequest.setAttribute("userRole", role);
            httpRequest.setAttribute("requiredRole", requiredRole);

            httpResponse.setStatus(HttpServletResponse.SC_FORBIDDEN);
            httpRequest.getRequestDispatcher("/WEB-INF/views/common/access-denied.jsp").forward(httpRequest, httpResponse);
            return;
        }

        chain.doFilter(request, response);
    }
}
