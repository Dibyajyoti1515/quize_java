package com.quiztrack.controller.admin;

import com.quiztrack.model.Role;
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
import java.util.List;
import java.util.UUID;

/**
 * Controller servlet for Enterprise User Roster Management.
 * Handles directory listing, search, filtering, user creation, profile editing,
 * account status toggles, role updates, and password resets.
 */
@WebServlet(name = "AdminUserServlet", urlPatterns = {
        "/admin/users",
        "/admin/users/create",
        "/admin/users/edit",
        "/admin/users/status",
        "/admin/users/role",
        "/admin/users/reset-password"
})
public class AdminUserServlet extends HttpServlet {

    private static final Logger logger = LoggerFactory.getLogger(AdminUserServlet.class);
    private final AdminService adminService;

    public AdminUserServlet() {
        this.adminService = new AdminServiceImpl();
    }

    public AdminUserServlet(AdminService adminService) {
        this.adminService = adminService;
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User currentUser = validateAdminAccess(request, response);
        if (currentUser == null) return;

        ensureCsrfToken(request.getSession());

        String search = request.getParameter("search");
        String role = request.getParameter("role");
        String status = request.getParameter("status");

        int page = 1;
        int pageSize = 20;

        String pageParam = request.getParameter("page");
        if (pageParam != null && !pageParam.isBlank()) {
            try {
                page = Math.max(1, Integer.parseInt(pageParam.trim()));
            } catch (NumberFormatException ignored) {}
        }

        try {
            List<User> users = adminService.listUsers(search, role, status, page, pageSize);
            int totalCount = adminService.countUsers(search, role, status);
            int totalPages = (int) Math.ceil((double) totalCount / pageSize);

            List<Role> allRoles = adminService.getAllRoles();

            request.setAttribute("users", users);
            request.setAttribute("totalCount", totalCount);
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", Math.max(1, totalPages));
            request.setAttribute("allRoles", allRoles);
            request.setAttribute("searchParam", search != null ? search : "");
            request.setAttribute("roleParam", role != null ? role : "ALL");
            request.setAttribute("statusParam", status != null ? status : "ALL");
            request.setAttribute("activeTab", "users");
            request.setAttribute("currentUser", currentUser);

            request.getRequestDispatcher("/WEB-INF/views/admin/users.jsp").forward(request, response);

        } catch (Exception e) {
            logger.error("Error loading user management roster", e);
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Failed to load user directory.");
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
            logger.warn("CSRF token missing or mismatch for admin user {}", currentUser.getUserId());
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Invalid or missing security token (CSRF). Action blocked.");
            return;
        }

        String path = request.getServletPath();

        try {
            switch (path) {
                case "/admin/users/create":
                    handleCreateUser(request, response, currentUser);
                    break;
                case "/admin/users/edit":
                    handleEditUser(request, response, currentUser);
                    break;
                case "/admin/users/status":
                    handleStatusChange(request, response, currentUser);
                    break;
                case "/admin/users/role":
                    handleRoleChange(request, response, currentUser);
                    break;
                case "/admin/users/reset-password":
                    handlePasswordReset(request, response, currentUser);
                    break;
                default:
                    response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (SecurityException se) {
            logger.warn("Security violation during admin operation: {}", se.getMessage());
            redirectWithError(request, response, se.getMessage());
        } catch (IllegalArgumentException iae) {
            logger.warn("Validation error during admin operation: {}", iae.getMessage());
            redirectWithError(request, response, iae.getMessage());
        } catch (Exception e) {
            logger.error("Unexpected error executing admin operation", e);
            redirectWithError(request, response, "An unexpected error occurred: " + e.getMessage());
        }
    }

    private void handleCreateUser(HttpServletRequest request, HttpServletResponse response, User admin) throws IOException {
        String fullName = request.getParameter("fullName");
        String identifier = request.getParameter("identifier");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String roleName = request.getParameter("roleName");
        String department = request.getParameter("department");
        String cohort = request.getParameter("cohort");

        boolean ok = adminService.createUser(fullName, identifier, email, password, roleName, department, cohort, admin.getUserId());
        if (ok) {
            redirectWithSuccess(request, response, "User account for '" + fullName + "' created successfully.");
        } else {
            redirectWithError(request, response, "Failed to create user account. Please check your inputs.");
        }
    }

    private void handleEditUser(HttpServletRequest request, HttpServletResponse response, User admin) throws IOException {
        int userId = Integer.parseInt(request.getParameter("userId"));
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String department = request.getParameter("department");
        String cohort = request.getParameter("cohort");

        boolean ok = adminService.editUserProfile(userId, fullName, email, department, cohort, admin.getUserId());
        if (ok) {
            redirectWithSuccess(request, response, "User profile updated successfully.");
        } else {
            redirectWithError(request, response, "Failed to update user profile.");
        }
    }

    private void handleStatusChange(HttpServletRequest request, HttpServletResponse response, User admin) throws IOException {
        int userId = Integer.parseInt(request.getParameter("userId"));
        String newStatus = request.getParameter("status");

        boolean ok = adminService.setUserStatus(userId, newStatus, admin.getUserId());
        if (ok) {
            redirectWithSuccess(request, response, "User account status changed to " + newStatus + ".");
        } else {
            redirectWithError(request, response, "Failed to update account status.");
        }
    }

    private void handleRoleChange(HttpServletRequest request, HttpServletResponse response, User admin) throws IOException {
        int userId = Integer.parseInt(request.getParameter("userId"));
        String newRole = request.getParameter("newRole");

        boolean ok = adminService.changeUserRole(userId, newRole, admin.getUserId());
        if (ok) {
            redirectWithSuccess(request, response, "User role modified to " + newRole + " successfully.");
        } else {
            redirectWithError(request, response, "Failed to modify user role.");
        }
    }

    private void handlePasswordReset(HttpServletRequest request, HttpServletResponse response, User admin) throws IOException {
        int userId = Integer.parseInt(request.getParameter("userId"));
        String newPassword = request.getParameter("newPassword");

        boolean ok = adminService.resetUserPassword(userId, newPassword, admin.getUserId());
        if (ok) {
            redirectWithSuccess(request, response, "Password securely reset for user ID " + userId + ".");
        } else {
            redirectWithError(request, response, "Failed to reset password.");
        }
    }

    private User validateAdminAccess(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("currentUser") : null;

        if (user == null || !user.isAdmin()) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access forbidden to administrative user management.");
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
        response.sendRedirect(request.getContextPath() + "/admin/users?success=" + URLEncoder.encode(message, StandardCharsets.UTF_8));
    }

    private void redirectWithError(HttpServletRequest request, HttpServletResponse response, String message) throws IOException {
        response.sendRedirect(request.getContextPath() + "/admin/users?error=" + URLEncoder.encode(message, StandardCharsets.UTF_8));
    }
}
