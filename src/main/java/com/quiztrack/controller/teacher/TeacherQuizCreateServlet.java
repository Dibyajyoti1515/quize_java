package com.quiztrack.controller.teacher;

import com.quiztrack.model.Quiz;
import com.quiztrack.model.Subject;
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
import java.math.BigDecimal;
import java.sql.Timestamp;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

/**
 * Controller for Step 1 of Quiz Creation: Basic info, timing, scoring, and proctoring parameters.
 */
@WebServlet(name = "TeacherQuizCreateServlet", urlPatterns = {"/teacher/quiz/create"})
public class TeacherQuizCreateServlet extends HttpServlet {

    private static final Logger logger = LoggerFactory.getLogger(TeacherQuizCreateServlet.class);
    private final TeacherService teacherService;

    public TeacherQuizCreateServlet() {
        this.teacherService = new TeacherServiceImpl();
    }

    public TeacherQuizCreateServlet(TeacherService teacherService) {
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

        if (session.getAttribute("csrfToken") == null) {
            session.setAttribute("csrfToken", java.util.UUID.randomUUID().toString());
        }

        populateFormAttributes(request);
        request.getRequestDispatcher("/WEB-INF/views/teacher/quiz-create.jsp").forward(request, response);
    }

    private void populateFormAttributes(HttpServletRequest request) {
        List<Subject> subjects = teacherService.getAllSubjects();
        request.setAttribute("subjects", subjects);

        int defaultDuration = com.quiztrack.util.SystemSettingsHelper.getIntSetting("default_quiz_duration", 60);
        double defaultPass = com.quiztrack.util.SystemSettingsHelper.getDoubleSetting("default_passing_percentage", 40.0);
        int maxDuration = com.quiztrack.util.SystemSettingsHelper.getIntSetting("max_quiz_duration", 180);
        request.setAttribute("defaultDuration", defaultDuration);
        request.setAttribute("defaultPassPercentage", defaultPass);
        request.setAttribute("maxAllowedDuration", maxDuration);
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

        // CSRF Token Verification
        String sessionCsrf = (String) session.getAttribute("csrfToken");
        String requestCsrf = request.getParameter("csrfToken");
        if (sessionCsrf != null && (requestCsrf == null || !sessionCsrf.equals(requestCsrf))) {
            logger.warn("CSRF mismatch in quiz create for teacher {}", teacherId);
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Invalid or missing security token (CSRF). Action blocked.");
            return;
        }

        String title = request.getParameter("title");
        String description = request.getParameter("description");
        String subjectIdStr = request.getParameter("subjectId");
        String durationStr = request.getParameter("durationMinutes");
        String totalMarksStr = request.getParameter("totalMarks");
        String passPercentageStr = request.getParameter("passPercentage");
        boolean negativeMarking = request.getParameter("negativeMarking") != null;
        String negativeMarkValueStr = request.getParameter("negativeMarkValue");
        String maxTabSwitchesStr = request.getParameter("maxTabSwitches");
        boolean fullscreenRequired = request.getParameter("fullscreenRequired") != null;
        boolean webcamRequired = request.getParameter("webcamRequired") != null;
        boolean shuffleQuestions = request.getParameter("shuffleQuestions") != null;
        String status = request.getParameter("status");
        String startStr = request.getParameter("startTime");
        String endStr = request.getParameter("endTime");

        // Preserve typed values for form re-rendering on validation error (B10)
        request.setAttribute("title", title);
        request.setAttribute("description", description);
        try {
            request.setAttribute("selectedSubjectId", subjectIdStr != null && !subjectIdStr.isBlank() ? Integer.parseInt(subjectIdStr.trim()) : 0);
        } catch (NumberFormatException ignored) {}
        request.setAttribute("durationMinutes", durationStr);
        request.setAttribute("totalMarks", totalMarksStr);
        request.setAttribute("passPercentage", passPercentageStr);
        request.setAttribute("negativeMarking", negativeMarking);
        request.setAttribute("negativeMarkValue", negativeMarkValueStr);
        request.setAttribute("maxTabSwitches", maxTabSwitchesStr != null ? maxTabSwitchesStr : "3");
        request.setAttribute("fullscreenRequired", fullscreenRequired);
        request.setAttribute("webcamRequired", webcamRequired);
        request.setAttribute("shuffleQuestions", shuffleQuestions);
        request.setAttribute("status", status != null ? status : "DRAFT");
        request.setAttribute("startTimeStr", startStr);
        request.setAttribute("endTimeStr", endStr);

        try {
            if (title == null || title.trim().length() < 3) {
                throw new IllegalArgumentException("Quiz title must contain at least 3 characters.");
            }
            if (title.trim().length() > 255) {
                throw new IllegalArgumentException("Quiz title cannot exceed 255 characters.");
            }

            int subjectId;
            try {
                subjectId = Integer.parseInt(subjectIdStr.trim());
            } catch (Exception e) {
                throw new IllegalArgumentException("Please select a valid subject course.");
            }

            int durationMinutes;
            try {
                durationMinutes = Integer.parseInt(durationStr.trim());
            } catch (Exception e) {
                throw new IllegalArgumentException("Please enter a valid examination duration in minutes.");
            }

            int maxAllowedDuration = com.quiztrack.util.SystemSettingsHelper.getIntSetting("max_quiz_duration", 180);
            if (durationMinutes < 1 || durationMinutes > maxAllowedDuration) {
                throw new IllegalArgumentException("Requested duration (" + durationMinutes + " min) exceeds maximum permitted examination limit of " + maxAllowedDuration + " min.");
            }

            BigDecimal totalMarks = BigDecimal.ZERO;
            if (totalMarksStr != null && !totalMarksStr.trim().isEmpty()) {
                try {
                    totalMarks = new BigDecimal(totalMarksStr.trim());
                } catch (Exception ignored) {}
            }

            BigDecimal passPercentage;
            try {
                passPercentage = new BigDecimal(passPercentageStr.trim());
                if (passPercentage.compareTo(BigDecimal.ZERO) < 0 || passPercentage.compareTo(new BigDecimal("100.0")) > 0) {
                    throw new IllegalArgumentException("Pass benchmark must be between 0% and 100%.");
                }
            } catch (NumberFormatException e) {
                throw new IllegalArgumentException("Please enter a valid pass benchmark percentage.");
            }

            BigDecimal negativeMarkValue = BigDecimal.ZERO;
            if (negativeMarking && negativeMarkValueStr != null && !negativeMarkValueStr.trim().isEmpty()) {
                try {
                    negativeMarkValue = new BigDecimal(negativeMarkValueStr.trim());
                    if (negativeMarkValue.compareTo(BigDecimal.ZERO) < 0) {
                        throw new IllegalArgumentException("Negative mark penalty cannot be negative.");
                    }
                } catch (NumberFormatException e) {
                    throw new IllegalArgumentException("Please enter a valid negative deduction point value.");
                }
            }

            int maxTabSwitches = 3;
            if (maxTabSwitchesStr != null && !maxTabSwitchesStr.trim().isEmpty()) {
                try {
                    maxTabSwitches = Integer.parseInt(maxTabSwitchesStr.trim());
                } catch (NumberFormatException ignored) {}
            }

            if (status == null || status.trim().isEmpty()) {
                status = "DRAFT";
            }
            status = status.toUpperCase().trim();
            if (!"DRAFT".equals(status) && !"SCHEDULED".equals(status)) {
                throw new IllegalArgumentException("Initial assessment lifecycle can only be DRAFT or SCHEDULED.");
            }

            Timestamp startTime = null;
            Timestamp endTime = null;
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm");
            sdf.setLenient(false);

            if (startStr != null && !startStr.trim().isEmpty()) {
                try {
                    Date d = sdf.parse(startStr.trim());
                    startTime = new Timestamp(d.getTime());
                } catch (ParseException pe) {
                    throw new IllegalArgumentException("Invalid schedule window start time format. Please provide a valid date and time.");
                }
            }

            if (endStr != null && !endStr.trim().isEmpty()) {
                try {
                    Date d = sdf.parse(endStr.trim());
                    endTime = new Timestamp(d.getTime());
                } catch (ParseException pe) {
                    throw new IllegalArgumentException("Invalid schedule window end time format. Please provide a valid date and time.");
                }
            }

            if ("SCHEDULED".equals(status)) {
                if (startTime == null || endTime == null) {
                    throw new IllegalArgumentException("Both start time and end time are required when initial status is set to Scheduled.");
                }
            }

            if (startTime != null && endTime != null) {
                if (!startTime.before(endTime)) {
                    throw new IllegalArgumentException("Schedule window start time must be strictly before the end time.");
                }
                long windowMinutes = (endTime.getTime() - startTime.getTime()) / (60 * 1000L);
                if (windowMinutes < durationMinutes) {
                    throw new IllegalArgumentException("Examination schedule window (" + windowMinutes + " min) cannot be shorter than the quiz duration (" + durationMinutes + " min).");
                }
            }

            Quiz quiz = new Quiz();
            quiz.setTitle(title.trim());
            quiz.setDescription(description != null ? description.trim() : "");
            quiz.setSubjectId(subjectId);
            quiz.setTeacherId(teacherId);
            quiz.setDurationMinutes(durationMinutes);
            quiz.setTotalMarks(totalMarks);
            quiz.setPassPercentage(passPercentage);
            quiz.setNegativeMarking(negativeMarking);
            quiz.setNegativeMarkValue(negativeMarkValue);
            quiz.setMaxTabSwitches(maxTabSwitches);
            quiz.setFullscreenRequired(fullscreenRequired);
            quiz.setWebcamRequired(webcamRequired);
            quiz.setShuffleQuestions(shuffleQuestions);
            quiz.setStartTime(startTime);
            quiz.setEndTime(endTime);
            quiz.setStatus(status);

            Quiz created = teacherService.createQuiz(quiz, teacherId);
            if (created != null && created.getQuizId() > 0) {
                response.sendRedirect(request.getContextPath() + "/teacher/quiz/builder?quizId=" + created.getQuizId());
                return;
            } else {
                request.setAttribute("errorMessage", "Failed to create quiz record in database.");
                populateFormAttributes(request);
                request.getRequestDispatcher("/WEB-INF/views/teacher/quiz-create.jsp").forward(request, response);
            }
        } catch (IllegalArgumentException iae) {
            logger.warn("Validation failure creating quiz: {}", iae.getMessage());
            request.setAttribute("errorMessage", iae.getMessage());
            populateFormAttributes(request);
            request.getRequestDispatcher("/WEB-INF/views/teacher/quiz-create.jsp").forward(request, response);
        } catch (Exception e) {
            logger.error("Error creating quiz", e);
            request.setAttribute("errorMessage", "Invalid form input: " + e.getMessage());
            populateFormAttributes(request);
            request.getRequestDispatcher("/WEB-INF/views/teacher/quiz-create.jsp").forward(request, response);
        }
    }
}
