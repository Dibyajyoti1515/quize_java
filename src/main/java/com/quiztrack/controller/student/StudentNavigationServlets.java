package com.quiztrack.controller.student;

import com.quiztrack.dao.NotificationDao;
import com.quiztrack.dao.StudentDao;
import com.quiztrack.dao.impl.NotificationDaoImpl;
import com.quiztrack.dao.impl.StudentDaoImpl;
import com.quiztrack.model.Notification;
import com.quiztrack.model.StudentDashboardData;
import com.quiztrack.model.StudentResultDto;
import com.quiztrack.service.ResultService;
import com.quiztrack.service.StudentService;
import com.quiztrack.service.impl.ResultServiceImpl;
import com.quiztrack.service.impl.StudentServiceImpl;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

/**
 * Navigation controllers for candidate workspace modules.
 * Delivers dynamic database-driven views for Upcoming Exams, Performance Analytics, and Notifications.
 */
public class StudentNavigationServlets {

    @WebServlet(name = "StudentUpcomingServlet", urlPatterns = {"/student/upcoming"})
    public static class StudentUpcomingServlet extends HttpServlet {
        private final StudentDao studentDao = new StudentDaoImpl();

        @Override
        protected void doGet(HttpServletRequest request, HttpServletResponse response)
                throws ServletException, IOException {
            HttpSession session = request.getSession(false);
            if (session == null || session.getAttribute("userId") == null) {
                response.sendRedirect(request.getContextPath() + "/auth/login");
                return;
            }

            int studentId = (Integer) session.getAttribute("userId");
            List<StudentDashboardData.StudentQuizCard> allCards = studentDao.getAssignedQuizzes(studentId);

            List<StudentDashboardData.StudentQuizCard> upcoming = new ArrayList<>();
            int activeCount = 0;
            int scheduledCount = 0;

            for (StudentDashboardData.StudentQuizCard card : allCards) {
                if (!"SUBMITTED".equalsIgnoreCase(card.getAttemptStatus())) {
                    upcoming.add(card);
                    if ("ACTIVE".equalsIgnoreCase(card.getStatus())) {
                        activeCount++;
                    } else {
                        scheduledCount++;
                    }
                }
            }

            request.setAttribute("upcomingQuizzes", upcoming);
            request.setAttribute("totalUpcoming", upcoming.size());
            request.setAttribute("activeCount", activeCount);
            request.setAttribute("scheduledCount", scheduledCount);
            request.getRequestDispatcher("/WEB-INF/views/student/upcoming-exams.jsp").forward(request, response);
        }
    }

    @WebServlet(name = "StudentAnalyticsServlet", urlPatterns = {"/student/analytics"})
    public static class StudentAnalyticsServlet extends HttpServlet {
        private final StudentService studentService = new StudentServiceImpl();
        private final ResultService resultService = new ResultServiceImpl();

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
            List<StudentResultDto> historyList = resultService.getResultsHistory(studentId);

            request.setAttribute("dashboardData", dashboardData);
            request.setAttribute("historyList", historyList);
            request.getRequestDispatcher("/WEB-INF/views/student/analytics.jsp").forward(request, response);
        }
    }

    @WebServlet(name = "StudentNotificationsServlet", urlPatterns = {"/student/notifications"})
    public static class StudentNotificationsServlet extends HttpServlet {
        private final NotificationDao notificationDao = new NotificationDaoImpl();

        @Override
        protected void doGet(HttpServletRequest request, HttpServletResponse response)
                throws ServletException, IOException {
            HttpSession session = request.getSession(false);
            if (session == null || session.getAttribute("userId") == null) {
                response.sendRedirect(request.getContextPath() + "/auth/login");
                return;
            }

            int studentId = (Integer) session.getAttribute("userId");
            String action = request.getParameter("action");

            if ("markRead".equals(action)) {
                String idStr = request.getParameter("id");
                if (idStr != null) {
                    try {
                        notificationDao.markAsRead(Integer.parseInt(idStr), studentId);
                    } catch (NumberFormatException ignored) {}
                }
                response.sendRedirect(request.getContextPath() + "/student/notifications");
                return;
            } else if ("markAllRead".equals(action)) {
                notificationDao.markAllAsRead(studentId);
                response.sendRedirect(request.getContextPath() + "/student/notifications");
                return;
            }

            List<Notification> notifications = notificationDao.getNotificationsByUserId(studentId);
            int unreadCount = notificationDao.countUnread(studentId);

            request.setAttribute("notifications", notifications);
            request.setAttribute("unreadCount", unreadCount);
            request.getRequestDispatcher("/WEB-INF/views/student/notifications.jsp").forward(request, response);
        }
    }

    @WebServlet(name = "StudentPreflightServlet", urlPatterns = {"/student/preflight"})
    public static class StudentPreflightServlet extends HttpServlet {
        @Override
        protected void doGet(HttpServletRequest request, HttpServletResponse response)
                throws ServletException, IOException {
            request.setAttribute("moduleTitle", "Diagnostic Preflight & Hardware Sandbox Check");
            request.setAttribute("moduleCode", "PREFLIGHT");
            request.setAttribute("moduleIcon", "sensors");
            request.setAttribute("moduleDescription",
                    "Run real-time diagnostics on WebCam facial biometrics feed, ambient microphone decibels, network latency, and display isolation.");
            request.setAttribute("targetPhase", "Phase 4 / Phase 6");
            request.getRequestDispatcher("/WEB-INF/views/student/module-preview.jsp").forward(request, response);
        }
    }

    @WebServlet(name = "StudentSettingsServlet", urlPatterns = {"/student/settings"})
    public static class StudentSettingsServlet extends HttpServlet {
        @Override
        protected void doGet(HttpServletRequest request, HttpServletResponse response)
                throws ServletException, IOException {
            request.setAttribute("moduleTitle", "Candidate Profile & Telemetry Settings");
            request.setAttribute("moduleCode", "SETTINGS");
            request.setAttribute("moduleIcon", "settings");
            request.setAttribute("moduleDescription",
                    "Manage candidate profile credentials, biometric encryption consent, notification channels, and high-contrast theme preferences.");
            request.setAttribute("targetPhase", "Phase 4");
            request.getRequestDispatcher("/WEB-INF/views/student/module-preview.jsp").forward(request, response);
        }
    }
}
