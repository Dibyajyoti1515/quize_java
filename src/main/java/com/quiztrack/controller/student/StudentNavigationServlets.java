package com.quiztrack.controller.student;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * Navigation controllers for candidate workspace modules.
 * Previews upcoming modules with Stitch design fidelity and planned route metadata.
 */
public class StudentNavigationServlets {

    @WebServlet(name = "StudentUpcomingServlet", urlPatterns = {"/student/upcoming"})
    public static class StudentUpcomingServlet extends HttpServlet {
        @Override
        protected void doGet(HttpServletRequest request, HttpServletResponse response)
                throws ServletException, IOException {
            request.setAttribute("moduleTitle", "Upcoming Examinations & Schedule");
            request.setAttribute("moduleCode", "SCHEDULE");
            request.setAttribute("moduleIcon", "event_upcoming");
            request.setAttribute("moduleDescription",
                    "Browse all proctored midterms, scheduled lab practicals, and diagnostic benchmarks assigned to your academic cohort.");
            request.setAttribute("targetPhase", "Phase 4 / Phase 6");
            request.getRequestDispatcher("/WEB-INF/views/student/module-preview.jsp").forward(request, response);
        }
    }

    // StudentResultsServlet moved to dedicated controller com.quiztrack.controller.student.StudentResultsServlet

    @WebServlet(name = "StudentAnalyticsServlet", urlPatterns = {"/student/analytics"})
    public static class StudentAnalyticsServlet extends HttpServlet {
        @Override
        protected void doGet(HttpServletRequest request, HttpServletResponse response)
                throws ServletException, IOException {
            request.setAttribute("moduleTitle", "Performance Analytics & Cohort Benchmarks");
            request.setAttribute("moduleCode", "ANALYTICS");
            request.setAttribute("moduleIcon", "analytics");
            request.setAttribute("moduleDescription",
                    "Deep-dive longitudinal mastery charts, bloom taxonomy progress, and time-per-question telemetry insights.");
            request.setAttribute("targetPhase", "Phase 7");
            request.getRequestDispatcher("/WEB-INF/views/student/module-preview.jsp").forward(request, response);
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

    @WebServlet(name = "StudentNotificationsServlet", urlPatterns = {"/student/notifications"})
    public static class StudentNotificationsServlet extends HttpServlet {
        @Override
        protected void doGet(HttpServletRequest request, HttpServletResponse response)
                throws ServletException, IOException {
            request.setAttribute("moduleTitle", "Academic Notifications & Proctor Alerts");
            request.setAttribute("moduleCode", "NOTIFICATIONS");
            request.setAttribute("moduleIcon", "notifications");
            request.setAttribute("moduleDescription",
                    "Review institutional announcements, exam schedule modifications, proctor clearance notices, and score publications.");
            request.setAttribute("targetPhase", "Phase 4 / Phase 5");
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
