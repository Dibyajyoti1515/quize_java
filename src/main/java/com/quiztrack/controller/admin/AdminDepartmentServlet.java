package com.quiztrack.controller.admin;

import com.quiztrack.model.DepartmentSummaryDto;
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
import java.util.List;

/**
 * Controller servlet for Academic Department Management.
 * Surfaces faculty rosters, quizzes organized by department teachers,
 * and top 5 student performers per branch.
 */
@WebServlet(name = "AdminDepartmentServlet", urlPatterns = {"/admin/departments"})
public class AdminDepartmentServlet extends HttpServlet {

    private static final Logger logger = LoggerFactory.getLogger(AdminDepartmentServlet.class);
    private final AdminService adminService;

    public AdminDepartmentServlet() {
        this.adminService = new AdminServiceImpl();
    }

    public AdminDepartmentServlet(AdminService adminService) {
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
            List<DepartmentSummaryDto> departments = adminService.getDepartmentSummaries();
            String selectedDeptName = request.getParameter("dept");

            DepartmentSummaryDto selectedDept = null;
            if (selectedDeptName != null && !selectedDeptName.trim().isEmpty()) {
                for (DepartmentSummaryDto d : departments) {
                    if (d.getDepartmentName().equalsIgnoreCase(selectedDeptName.trim())) {
                        selectedDept = d;
                        break;
                    }
                }
            }

            if (selectedDept == null && !departments.isEmpty()) {
                selectedDept = departments.get(0);
            }

            // Compute global department aggregates
            int totalDepartments = departments.size();
            int totalFaculty = 0;
            int totalStudents = 0;
            int totalQuizzes = 0;

            for (DepartmentSummaryDto d : departments) {
                totalFaculty += d.getTeacherCount();
                totalStudents += d.getStudentCount();
                totalQuizzes += d.getQuizCount();
            }

            request.setAttribute("departments", departments);
            request.setAttribute("selectedDept", selectedDept);
            request.setAttribute("totalDepartments", totalDepartments);
            request.setAttribute("totalFaculty", totalFaculty);
            request.setAttribute("totalStudents", totalStudents);
            request.setAttribute("totalQuizzes", totalQuizzes);
            request.setAttribute("currentUser", currentUser);
            request.setAttribute("activeTab", "departments");

            request.getRequestDispatcher("/WEB-INF/views/admin/departments.jsp").forward(request, response);

        } catch (Exception e) {
            logger.error("Error loading department management console", e);
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Failed to load department management.");
        }
    }
}
