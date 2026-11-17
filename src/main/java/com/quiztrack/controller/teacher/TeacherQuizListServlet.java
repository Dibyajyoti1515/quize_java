package com.quiztrack.controller.teacher;

import com.quiztrack.model.Quiz;
import com.quiztrack.service.TeacherService;
import com.quiztrack.service.impl.TeacherServiceImpl;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

/**
 * Controller displaying all quizzes owned by the authenticated teacher.
 */
@WebServlet(name = "TeacherQuizListServlet", urlPatterns = {"/teacher/quizzes"})
public class TeacherQuizListServlet extends HttpServlet {

    private final TeacherService teacherService;

    public TeacherQuizListServlet() {
        this.teacherService = new TeacherServiceImpl();
    }

    public TeacherQuizListServlet(TeacherService teacherService) {
        this.teacherService = teacherService;
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/auth/login");
            return;
        }

        int teacherId = (Integer) session.getAttribute("userId");
        List<Quiz> quizzes = teacherService.getQuizzesByTeacher(teacherId);

        request.setAttribute("quizzes", quizzes);
        request.getRequestDispatcher("/WEB-INF/views/teacher/quiz-list.jsp").forward(request, response);
    }
}
