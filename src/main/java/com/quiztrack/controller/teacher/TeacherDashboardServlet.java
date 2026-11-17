package com.quiztrack.controller.teacher;

import com.quiztrack.model.TeacherDashboardData;
import com.quiztrack.model.User;
import com.quiztrack.service.TeacherService;
import com.quiztrack.service.impl.TeacherServiceImpl;
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
 * Controller for the Teacher Academic Dashboard.
 * Retrieves real-time academic analytics, live proctoring stream metrics, and quiz schedules.
 */
@WebServlet(name = "TeacherDashboardServlet", urlPatterns = {"/teacher/dashboard"})
public class TeacherDashboardServlet extends HttpServlet {

    private static final Logger logger = LoggerFactory.getLogger(TeacherDashboardServlet.class);
    private final TeacherService teacherService = new TeacherServiceImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("currentUser") : null;
        int teacherId = (currentUser != null) ? currentUser.getUserId() : 2; // Default to Prof. Ronald Vance

        logger.info("Loading Teacher Academic Overview for teacher ID: {}", teacherId);

        TeacherDashboardData data = teacherService.getDashboardOverview(teacherId);
        request.setAttribute("dashboardData", data);

        request.getRequestDispatcher("/WEB-INF/views/teacher/dashboard.jsp").forward(request, response);
    }
}
