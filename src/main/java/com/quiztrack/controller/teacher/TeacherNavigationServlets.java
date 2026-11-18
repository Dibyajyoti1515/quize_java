package com.quiztrack.controller.teacher;

import com.quiztrack.dao.AnalyticsDao;
import com.quiztrack.dao.ProctorDao;
import com.quiztrack.dao.QuizAssignmentDao;
import com.quiztrack.dao.QuizDao;
import com.quiztrack.dao.impl.AnalyticsDaoImpl;
import com.quiztrack.dao.impl.ProctorDaoImpl;
import com.quiztrack.dao.impl.QuizAssignmentDaoImpl;
import com.quiztrack.dao.impl.QuizDaoImpl;
import com.quiztrack.model.Cohort;
import com.quiztrack.model.ProctorActivityEventDto;
import com.quiztrack.model.Quiz;
import com.quiztrack.model.TeacherDashboardData;
import com.quiztrack.model.User;
import com.quiztrack.util.SystemSettingsHelper;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.Collections;
import java.util.List;

/**
 * Dedicated navigation controllers for faculty workspaces:
 * - Student Roster & Cohort Directory (/teacher/students)
 * - Proctoring Violation Logs & Live Audit Feed (/teacher/violations)
 * - Academic Performance Analytics (/teacher/analytics)
 * - Proctor Security Policies & Rules Engine (/teacher/rules)
 */
public class TeacherNavigationServlets {

    @WebServlet(name = "TeacherStudentRosterRoute", urlPatterns = {"/teacher/students"})
    public static class StudentRosterServlet extends HttpServlet {
        private final QuizAssignmentDao assignmentDao = new QuizAssignmentDaoImpl();

        @Override
        protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            HttpSession session = req.getSession(false);
            User currentUser = (session != null) ? (User) session.getAttribute("currentUser") : null;

            String dept = (currentUser != null) ? currentUser.getDepartment() : null;
            boolean isAdmin = (currentUser != null && currentUser.isAdmin());

            String filterDept = (isAdmin) ? null : dept;
            List<Cohort> cohorts = assignmentDao.findAvailableCohorts(filterDept);
            List<User> students = assignmentDao.findAvailableStudents(filterDept);

            req.setAttribute("cohorts", cohorts);
            req.setAttribute("students", students);
            req.setAttribute("totalStudents", students.size());
            req.setAttribute("department", (dept != null && !dept.isBlank()) ? dept : "All Academic Departments");

            req.getRequestDispatcher("/WEB-INF/views/teacher/students.jsp").forward(req, resp);
        }
    }

    @WebServlet(name = "TeacherViolationLogsRoute", urlPatterns = {"/teacher/violations"})
    public static class ViolationLogsServlet extends HttpServlet {
        private final ProctorDao proctorDao = new ProctorDaoImpl();

        @Override
        protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            HttpSession session = req.getSession(false);
            User currentUser = (session != null) ? (User) session.getAttribute("currentUser") : null;

            Integer teacherId = (currentUser != null && !currentUser.isAdmin()) ? currentUser.getUserId() : null;
            String severity = req.getParameter("severity");
            if (severity == null || severity.isBlank()) {
                severity = "ALL";
            }

            List<ProctorActivityEventDto> violations = proctorDao.getViolationLogs(teacherId, severity, 100);

            long criticalCount = violations.stream().filter(v -> "CRITICAL".equalsIgnoreCase(v.getSeverity())).count();
            long highCount = violations.stream().filter(v -> "HIGH".equalsIgnoreCase(v.getSeverity()) || "WARNING".equalsIgnoreCase(v.getSeverity())).count();
            long tabSwitchCount = violations.stream().filter(v -> "TAB_SWITCH".equalsIgnoreCase(v.getEventType()) || "FOCUS_LOST".equalsIgnoreCase(v.getEventType())).count();

            req.setAttribute("violations", violations);
            req.setAttribute("selectedSeverity", severity);
            req.setAttribute("totalCount", violations.size());
            req.setAttribute("criticalCount", criticalCount);
            req.setAttribute("highCount", highCount);
            req.setAttribute("tabSwitchCount", tabSwitchCount);

            req.getRequestDispatcher("/WEB-INF/views/teacher/violations.jsp").forward(req, resp);
        }
    }

    @WebServlet(name = "TeacherAnalyticsRoute", urlPatterns = {"/teacher/analytics"})
    public static class AnalyticsServlet extends HttpServlet {
        private final AnalyticsDao analyticsDao = new AnalyticsDaoImpl();
        private final QuizDao quizDao = new QuizDaoImpl();

        @Override
        protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            HttpSession session = req.getSession(false);
            User currentUser = (session != null) ? (User) session.getAttribute("currentUser") : null;
            int teacherId = (currentUser != null) ? currentUser.getUserId() : 2;

            double avgScore = analyticsDao.calculateAverageClassScore();
            double trustIndex = analyticsDao.getProctorTrustIndex();
            int completedSessions = analyticsDao.countTotalCompletedSessions();
            List<TeacherDashboardData.CohortMetric> cohortMetrics = analyticsDao.getCohortComparisonMetrics();

            List<Quiz> quizzes = quizDao.findQuizzesByTeacher(teacherId);
            int primarySubjectId = (!quizzes.isEmpty()) ? quizzes.get(0).getSubjectId() : 1;
            List<TeacherDashboardData.TopicMastery> topicMastery = analyticsDao.getTopicMasteryStats(primarySubjectId);

            req.setAttribute("avgScore", avgScore);
            req.setAttribute("trustIndex", trustIndex);
            req.setAttribute("completedSessions", completedSessions);
            req.setAttribute("cohortMetrics", cohortMetrics);
            req.setAttribute("topicMastery", topicMastery);

            req.getRequestDispatcher("/WEB-INF/views/teacher/analytics.jsp").forward(req, resp);
        }
    }

    @WebServlet(name = "TeacherRulesEngineRoute", urlPatterns = {"/teacher/rules"})
    public static class RulesEngineServlet extends HttpServlet {
        @Override
        protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            req.setAttribute("maxDuration", SystemSettingsHelper.getIntSetting("max_quiz_duration", 180));
            req.setAttribute("defaultDuration", SystemSettingsHelper.getIntSetting("default_quiz_duration", 90));
            req.setAttribute("defaultPassPercentage", SystemSettingsHelper.getDoubleSetting("pass_percentage_default", 40.0));
            req.setAttribute("allowRegistration", SystemSettingsHelper.getBooleanSetting("allow_student_registration", true));
            req.setAttribute("maintenanceMode", SystemSettingsHelper.getBooleanSetting("maintenance_mode", false));

            req.getRequestDispatcher("/WEB-INF/views/teacher/rules.jsp").forward(req, resp);
        }
    }
}
