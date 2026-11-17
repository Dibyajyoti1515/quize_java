package com.quiztrack.controller.admin;

import com.quiztrack.model.AdminDashboardStats;
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

/**
 * Controller for the System Administrator Executive Dashboard.
 * Serves real-time institutional metrics, active examination counters, and audit feeds.
 */
@WebServlet(name = "AdminDashboardServlet", urlPatterns = {"/admin/dashboard"})
public class AdminDashboardServlet extends HttpServlet {

    private static final Logger logger = LoggerFactory.getLogger(AdminDashboardServlet.class);
    private final AdminService adminService;

    public AdminDashboardServlet() {
        this.adminService = new AdminServiceImpl();
    }

    public AdminDashboardServlet(AdminService adminService) {
        this.adminService = adminService;
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("currentUser") : null;

        if (currentUser == null || !currentUser.isAdmin()) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access forbidden to administrative console.");
            return;
        }

        try {
            AdminDashboardStats stats = adminService.getDashboardStatistics();
            request.setAttribute("dashboardStats", stats);
            request.setAttribute("currentUser", currentUser);
            request.setAttribute("activeTab", "dashboard");

            request.getRequestDispatcher("/WEB-INF/views/admin/dashboard.jsp").forward(request, response);

        } catch (Exception e) {
            logger.error("Error loading admin dashboard statistics", e);
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Failed to load administration dashboard.");
        }
    }
}
