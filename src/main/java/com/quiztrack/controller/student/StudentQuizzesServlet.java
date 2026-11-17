package com.quiztrack.controller.student;

import com.quiztrack.model.StudentDashboardData;
import com.quiztrack.service.StudentService;
import com.quiztrack.service.impl.StudentServiceImpl;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

/**
 * Controller for the Student Available Quizzes & Assessment Registry view.
 * Displays the assessment list, filter controls, and pre-flight modal.
 */
@WebServlet(name = "StudentQuizzesServlet", urlPatterns = {"/student/quizzes"})
public class StudentQuizzesServlet extends HttpServlet {

    private final StudentService studentService;

    public StudentQuizzesServlet() {
        this.studentService = new StudentServiceImpl();
    }

    public StudentQuizzesServlet(StudentService studentService) {
        this.studentService = studentService;
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/auth/login");
            return;
        }

        int studentId = (Integer) session.getAttribute("userId");
        StudentDashboardData dashboardData = studentService.getStudentDashboardData(studentId);

        request.setAttribute("dashboardData", dashboardData);
        request.getRequestDispatcher("/WEB-INF/views/student/available-quizzes.jsp").forward(request, response);
    }
}
