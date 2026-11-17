package com.quiztrack.controller.teacher;

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
 * Controller handling quick actions on quizzes (Delete, Publish, Draft).
 */
@WebServlet(name = "TeacherQuizActionServlet", urlPatterns = {"/teacher/quiz/action"})
public class TeacherQuizActionServlet extends HttpServlet {

    private static final Logger logger = LoggerFactory.getLogger(TeacherQuizActionServlet.class);
    private final TeacherService teacherService;

    public TeacherQuizActionServlet() {
        this.teacherService = new TeacherServiceImpl();
    }

    public TeacherQuizActionServlet(TeacherService teacherService) {
        this.teacherService = teacherService;
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/auth/login");
            return;
        }

        int teacherId = (Integer) session.getAttribute("userId");
        String action = request.getParameter("action");
        String quizIdStr = request.getParameter("quizId");

        if (quizIdStr != null && !quizIdStr.trim().isEmpty()) {
            try {
                int quizId = Integer.parseInt(quizIdStr.trim());
                if ("delete".equalsIgnoreCase(action)) {
                    boolean success = teacherService.deleteQuiz(quizId, teacherId);
                    if (!success) {
                        logger.warn("Could not delete quiz ID: {}", quizId);
                    }
                } else if ("publish".equalsIgnoreCase(action)) {
                    teacherService.setQuizStatus(quizId, teacherId, "ACTIVE");
                } else if ("draft".equalsIgnoreCase(action)) {
                    teacherService.setQuizStatus(quizId, teacherId, "DRAFT");
                }
            } catch (Exception e) {
                logger.error("Error executing quiz action", e);
            }
        }

        response.sendRedirect(request.getContextPath() + "/teacher/quizzes");
    }
}
