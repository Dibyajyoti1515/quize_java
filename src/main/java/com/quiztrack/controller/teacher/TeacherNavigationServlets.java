package com.quiztrack.controller.teacher;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * Navigation routes for Teacher portal sub-modules ensuring 100% link integrity.
 */
public class TeacherNavigationServlets {

    @WebServlet(name = "TeacherStudentRosterRoute", urlPatterns = {"/teacher/students"})
    public static class StudentRosterServlet extends HttpServlet {
        @Override
        protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            req.setAttribute("pageTitle", "Student Roster & Cohort Management");
            req.setAttribute("pageNotice", "Candidate verification, cohort enrollment and student dossiers.");
            req.getRequestDispatcher("/WEB-INF/views/teacher/module-preview.jsp").forward(req, resp);
        }
    }

    @WebServlet(name = "TeacherViolationLogsRoute", urlPatterns = {"/teacher/violations"})
    public static class ViolationLogsServlet extends HttpServlet {
        @Override
        protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            req.setAttribute("pageTitle", "Proctoring Violation Logs & Audit Trail");
            req.setAttribute("pageNotice", "Full telemetry log with tab-switch, blur, and audio incident timelines.");
            req.getRequestDispatcher("/WEB-INF/views/teacher/module-preview.jsp").forward(req, resp);
        }
    }

    @WebServlet(name = "TeacherAnalyticsRoute", urlPatterns = {"/teacher/analytics"})
    public static class AnalyticsServlet extends HttpServlet {
        @Override
        protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            req.setAttribute("pageTitle", "Academic Analytics & Score Distribution");
            req.setAttribute("pageNotice", "Longitudinal cohort mastery, Gaussian bell curves, and item difficulty analytics.");
            req.getRequestDispatcher("/WEB-INF/views/teacher/module-preview.jsp").forward(req, resp);
        }
    }

    @WebServlet(name = "TeacherRulesEngineRoute", urlPatterns = {"/teacher/rules"})
    public static class RulesEngineServlet extends HttpServlet {
        @Override
        protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            req.setAttribute("pageTitle", "Proctor Rules Engine & Security Presets");
            req.setAttribute("pageNotice", "Configure webcam enforcement, tab limits, audio thresholds, and auto-lockdown rules.");
            req.getRequestDispatcher("/WEB-INF/views/teacher/module-preview.jsp").forward(req, resp);
        }
    }
}
