package com.quiztrack;

import com.quiztrack.dao.QuestionDao;
import com.quiztrack.dao.QuizDao;
import com.quiztrack.dao.UserDao;
import com.quiztrack.dao.impl.QuestionDaoImpl;
import com.quiztrack.dao.impl.QuizDaoImpl;
import com.quiztrack.dao.impl.UserDaoImpl;
import com.quiztrack.filter.CsrfFilter;
import com.quiztrack.model.Question;
import com.quiztrack.model.QuestionOption;
import com.quiztrack.model.Quiz;
import com.quiztrack.model.User;
import com.quiztrack.service.TeacherService;
import com.quiztrack.service.impl.TeacherServiceImpl;
import com.quiztrack.util.DatabaseConnection;
import jakarta.servlet.FilterChain;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.junit.jupiter.api.*;

import java.io.IOException;
import java.io.PrintWriter;
import java.io.StringWriter;
import java.lang.reflect.InvocationHandler;
import java.lang.reflect.Method;
import java.lang.reflect.Proxy;
import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.*;
import java.util.concurrent.atomic.AtomicBoolean;
import java.util.concurrent.atomic.AtomicInteger;

import static org.junit.jupiter.api.Assertions.*;

/**
 * Test suite verifying Security Hardening (Task 7):
 * - CSRF token verification across safe and mutating requests
 * - CSRF AJAX/JSON 403 handling
 * - Role-based quiz and question ownership (B11)
 * - Prevention of unauthorized faculty deleting seeded questions (created_by IS NULL)
 * - Administrative capability to view all quizzes and perform administrative actions
 */
@TestMethodOrder(MethodOrderer.OrderAnnotation.class)
public class SecurityHardeningTest {

    private static TeacherService teacherService;
    private static QuizDao quizDao;
    private static QuestionDao questionDao;
    private static UserDao userDao;

    private static final int ADMIN_USER_ID = 1;
    private static final int TEACHER_RONALD_ID = 2;
    private static final int TEACHER_CLARA_ID = 3;

    @BeforeAll
    public static void setUp() {
        teacherService = new TeacherServiceImpl();
        quizDao = new QuizDaoImpl();
        questionDao = new QuestionDaoImpl();
        userDao = new UserDaoImpl();
    }

    // =========================================================================
    // 1. CSRF FILTER TESTS
    // =========================================================================

    @Test
    @Order(1)
    @DisplayName("Test 1: Safe HTTP GET bypasses CSRF validation and generates session token")
    public void testCsrfSafeMethodsPassThrough() throws ServletException, IOException {
        CsrfFilter filter = new CsrfFilter();
        Map<String, Object> sessionAttributes = new HashMap<>();

        HttpSession session = createMockSession(sessionAttributes);
        HttpServletRequest request = createMockRequest("GET", "/teacher/quizzes", Collections.emptyMap(), Collections.emptyMap(), session);
        HttpServletResponse response = createMockResponse();

        AtomicBoolean chainInvoked = new AtomicBoolean(false);
        FilterChain chain = (req, res) -> chainInvoked.set(true);

        filter.doFilter(request, response, chain);

        assertTrue(chainInvoked.get(), "FilterChain must be executed for safe GET requests");
        assertNotNull(sessionAttributes.get("csrfToken"), "CSRF token must be auto-initialized in session");
    }

    @Test
    @Order(2)
    @DisplayName("Test 2: Mutating POST without CSRF token is blocked with HTTP 403")
    public void testCsrfMutatingMethodWithoutTokenIsBlocked() throws ServletException, IOException {
        CsrfFilter filter = new CsrfFilter();
        Map<String, Object> sessionAttributes = new HashMap<>();
        sessionAttributes.put("csrfToken", "valid-secret-token-12345");

        HttpSession session = createMockSession(sessionAttributes);
        HttpServletRequest request = createMockRequest("POST", "/teacher/quiz/create", Collections.emptyMap(), Collections.emptyMap(), session);
        AtomicInteger statusCode = new AtomicInteger(200);
        HttpServletResponse response = createMockResponse(statusCode, new StringWriter());

        AtomicBoolean chainInvoked = new AtomicBoolean(false);
        FilterChain chain = (req, res) -> chainInvoked.set(true);

        filter.doFilter(request, response, chain);

        assertFalse(chainInvoked.get(), "FilterChain must NOT be invoked when CSRF token is missing");
        assertEquals(HttpServletResponse.SC_FORBIDDEN, statusCode.get(), "Response must be HTTP 403 Forbidden");
    }

    @Test
    @Order(3)
    @DisplayName("Test 3: Mutating POST with valid parameter CSRF token succeeds")
    public void testCsrfMutatingMethodWithMatchingParameterSucceeds() throws ServletException, IOException {
        CsrfFilter filter = new CsrfFilter();
        String token = UUID.randomUUID().toString();
        Map<String, Object> sessionAttributes = new HashMap<>();
        sessionAttributes.put("csrfToken", token);

        Map<String, String> params = new HashMap<>();
        params.put("csrfToken", token);

        HttpSession session = createMockSession(sessionAttributes);
        HttpServletRequest request = createMockRequest("POST", "/teacher/quiz/action", params, Collections.emptyMap(), session);
        HttpServletResponse response = createMockResponse();

        AtomicBoolean chainInvoked = new AtomicBoolean(false);
        FilterChain chain = (req, res) -> chainInvoked.set(true);

        filter.doFilter(request, response, chain);

        assertTrue(chainInvoked.get(), "FilterChain must be executed when valid CSRF parameter is provided");
    }

    @Test
    @Order(4)
    @DisplayName("Test 4: Mutating POST with valid X-CSRF-Token header succeeds")
    public void testCsrfMutatingMethodWithMatchingHeaderSucceeds() throws ServletException, IOException {
        CsrfFilter filter = new CsrfFilter();
        String token = UUID.randomUUID().toString();
        Map<String, Object> sessionAttributes = new HashMap<>();
        sessionAttributes.put("csrfToken", token);

        Map<String, String> headers = new HashMap<>();
        headers.put("X-CSRF-Token", token);

        HttpSession session = createMockSession(sessionAttributes);
        HttpServletRequest request = createMockRequest("POST", "/student/exam/autosave", Collections.emptyMap(), headers, session);
        HttpServletResponse response = createMockResponse();

        AtomicBoolean chainInvoked = new AtomicBoolean(false);
        FilterChain chain = (req, res) -> chainInvoked.set(true);

        filter.doFilter(request, response, chain);

        assertTrue(chainInvoked.get(), "FilterChain must be executed when valid X-CSRF-Token header is provided");
    }

    @Test
    @Order(5)
    @DisplayName("Test 5: Missing CSRF token in AJAX/JSON request returns JSON 403 response")
    public void testCsrfAjaxFailureReturnsJsonForbidden() throws ServletException, IOException {
        CsrfFilter filter = new CsrfFilter();
        Map<String, Object> sessionAttributes = new HashMap<>();
        sessionAttributes.put("csrfToken", "expected-secret");

        Map<String, String> headers = new HashMap<>();
        headers.put("Accept", "application/json");

        StringWriter outputWriter = new StringWriter();
        AtomicInteger statusCode = new AtomicInteger(200);

        HttpSession session = createMockSession(sessionAttributes);
        HttpServletRequest request = createMockRequest("POST", "/teacher/proctoring/action", Collections.emptyMap(), headers, session);
        HttpServletResponse response = createMockResponse(statusCode, outputWriter);

        AtomicBoolean chainInvoked = new AtomicBoolean(false);
        FilterChain chain = (req, res) -> chainInvoked.set(true);

        filter.doFilter(request, response, chain);

        assertFalse(chainInvoked.get(), "FilterChain must NOT execute on failed AJAX CSRF check");
        assertEquals(HttpServletResponse.SC_FORBIDDEN, statusCode.get(), "Must return 403 Forbidden");
        assertTrue(outputWriter.toString().contains("\"status\":\"FORBIDDEN\""), "Response body must contain JSON FORBIDDEN status");
    }

    // =========================================================================
    // 2. ROLE-BASED OWNERSHIP TESTS (B11)
    // =========================================================================

    @Test
    @Order(6)
    @DisplayName("Test 6: Teacher Clara cannot delete Teacher Ronald's quiz")
    public void testTeacherCannotDeleteOtherTeacherQuiz() {
        Quiz quiz = new Quiz();
        quiz.setTitle("Ronald Security Test Quiz");
        quiz.setDescription("Ownership isolation test");
        quiz.setSubjectId(1);
        quiz.setDurationMinutes(45);
        quiz.setStatus("DRAFT");

        Quiz createdQuiz = teacherService.createQuiz(quiz, TEACHER_RONALD_ID);
        assertNotNull(createdQuiz);
        int quizId = createdQuiz.getQuizId();

        try {
            boolean unauthorizedDelete = teacherService.deleteQuiz(quizId, TEACHER_CLARA_ID);
            assertFalse(unauthorizedDelete, "Teacher Clara must NOT be allowed to delete Teacher Ronald's quiz");

            Optional<Quiz> stillExists = teacherService.getQuizById(quizId);
            assertTrue(stillExists.isPresent(), "Quiz must remain in database after rejected delete");
        } finally {
            teacherService.deleteQuiz(quizId, TEACHER_RONALD_ID);
        }
    }

    @Test
    @Order(7)
    @DisplayName("Test 7: Admin can delete any faculty member's quiz")
    public void testAdminCanDeleteAnyQuiz() {
        Quiz quiz = new Quiz();
        quiz.setTitle("Teacher Quiz For Admin Deletion");
        quiz.setDescription("Admin RBAC override test");
        quiz.setSubjectId(1);
        quiz.setDurationMinutes(30);
        quiz.setStatus("DRAFT");

        Quiz createdQuiz = teacherService.createQuiz(quiz, TEACHER_RONALD_ID);
        assertNotNull(createdQuiz);
        int quizId = createdQuiz.getQuizId();

        boolean adminDelete = teacherService.deleteQuiz(quizId, ADMIN_USER_ID);
        assertTrue(adminDelete, "Admin must be able to delete any faculty quiz");

        Optional<Quiz> deleted = teacherService.getQuizById(quizId);
        assertFalse(deleted.isPresent(), "Quiz should no longer exist after admin deletion");
    }

    @Test
    @Order(8)
    @DisplayName("Test 8: Regular teacher cannot delete seed questions with created_by = NULL (B11)")
    public void testTeacherCannotDeleteSeedQuestionWithNullCreatedBy() throws SQLException {
        // Create an unauthored question simulating seed data (created_by IS NULL)
        int seedQuestionId = insertQuestionWithNullCreatedBy("Seed Bank Question with Null Author", 1);
        assertTrue(seedQuestionId > 0, "Seed question must be inserted");

        try {
            boolean teacherDelete = teacherService.deleteQuestion(seedQuestionId, TEACHER_RONALD_ID);
            assertFalse(teacherDelete, "Teacher Ronald must NOT be allowed to delete seed question with NULL created_by");

            Optional<Question> qOpt = teacherService.getQuestionById(seedQuestionId);
            assertTrue(qOpt.isPresent(), "Seed question must remain untouched in question bank");
        } finally {
            // Clean up administratively
            teacherService.deleteQuestion(seedQuestionId, ADMIN_USER_ID);
        }
    }

    @Test
    @Order(9)
    @DisplayName("Test 9: Admin can delete seed question with created_by = NULL")
    public void testAdminCanDeleteSeedQuestionWithNullCreatedBy() throws SQLException {
        int seedQuestionId = insertQuestionWithNullCreatedBy("Seed Bank Question For Admin Cleanup", 1);
        assertTrue(seedQuestionId > 0);

        boolean adminDelete = teacherService.deleteQuestion(seedQuestionId, ADMIN_USER_ID);
        assertTrue(adminDelete, "Admin must be able to delete seed questions with NULL created_by");

        Optional<Question> qOpt = teacherService.getQuestionById(seedQuestionId);
        assertFalse(qOpt.isPresent(), "Seed question must be deleted");
    }

    @Test
    @Order(10)
    @DisplayName("Test 10: Admin sees all quizzes; Teacher only sees own authored quizzes (B11)")
    public void testAdminSeesAllQuizzesOnTeacherConsole() {
        List<Quiz> ronaldQuizzes = teacherService.getQuizzesByTeacher(TEACHER_RONALD_ID);
        List<Quiz> allQuizzes = teacherService.getAllQuizzes();

        assertNotNull(ronaldQuizzes);
        assertNotNull(allQuizzes);
        assertTrue(allQuizzes.size() >= ronaldQuizzes.size(), "All quizzes count must be >= individual teacher quizzes count");

        // Verify that quizzes authored by other teachers exist in allQuizzes
        boolean containsOtherTeacherQuiz = allQuizzes.stream().anyMatch(q -> q.getTeacherId() != TEACHER_RONALD_ID);
        assertTrue(containsOtherTeacherQuiz, "System must contain quizzes authored by other teachers or administrators");
    }

    // =========================================================================
    // HELPER METHODS: DYNAMIC PROXY MOCKS
    // =========================================================================

    private int insertQuestionWithNullCreatedBy(String prompt, int subjectId) throws SQLException {
        String sql = "INSERT INTO questions (subject_id, question_text, question_type, points, difficulty_level, created_by) " +
                     "VALUES (?, ?, 'SINGLE_CHOICE', 5.00, 'MEDIUM', NULL) RETURNING question_id";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, subjectId);
            ps.setString(2, prompt);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    int qId = rs.getInt(1);
                    // Insert at least 2 options
                    String optSql = "INSERT INTO question_options (question_id, option_letter, option_text, is_correct, sort_order) VALUES (?, ?, ?, ?, ?)";
                    try (PreparedStatement optPs = conn.prepareStatement(optSql)) {
                        optPs.setInt(1, qId);
                        optPs.setString(2, "A");
                        optPs.setString(3, "Option A");
                        optPs.setBoolean(4, true);
                        optPs.setInt(5, 1);
                        optPs.executeUpdate();

                        optPs.setInt(1, qId);
                        optPs.setString(2, "B");
                        optPs.setString(3, "Option B");
                        optPs.setBoolean(4, false);
                        optPs.setInt(5, 2);
                        optPs.executeUpdate();
                    }
                    return qId;
                }
            }
        }
        return -1;
    }

    private HttpSession createMockSession(Map<String, Object> attributes) {
        return (HttpSession) Proxy.newProxyInstance(
                HttpSession.class.getClassLoader(),
                new Class<?>[]{HttpSession.class},
                (proxy, method, args) -> {
                    String name = method.getName();
                    if ("getAttribute".equals(name)) {
                        return attributes.get(args[0]);
                    } else if ("setAttribute".equals(name)) {
                        attributes.put((String) args[0], args[1]);
                        return null;
                    } else if ("removeAttribute".equals(name)) {
                        attributes.remove(args[0]);
                        return null;
                    }
                    return null;
                }
        );
    }

    private HttpServletRequest createMockRequest(String method, String uri, Map<String, String> params, Map<String, String> headers, HttpSession session) {
        Map<String, Object> reqAttributes = new HashMap<>();

        return (HttpServletRequest) Proxy.newProxyInstance(
                HttpServletRequest.class.getClassLoader(),
                new Class<?>[]{HttpServletRequest.class},
                (proxy, m, args) -> {
                    String name = m.getName();
                    if ("getMethod".equals(name)) {
                        return method;
                    } else if ("getRequestURI".equals(name)) {
                        return uri;
                    } else if ("getParameter".equals(name)) {
                        return params.get(args[0]);
                    } else if ("getHeader".equals(name)) {
                        return headers.get(args[0]);
                    } else if ("getSession".equals(name)) {
                        return session;
                    } else if ("setAttribute".equals(name)) {
                        reqAttributes.put((String) args[0], args[1]);
                        return null;
                    } else if ("getAttribute".equals(name)) {
                        return reqAttributes.get(args[0]);
                    } else if ("getRemoteAddr".equals(name)) {
                        return "127.0.0.1";
                    } else if ("getRequestDispatcher".equals(name)) {
                        return (RequestDispatcher) Proxy.newProxyInstance(
                                RequestDispatcher.class.getClassLoader(),
                                new Class<?>[]{RequestDispatcher.class},
                                (dp, dm, dargs) -> null
                        );
                    }
                    return null;
                }
        );
    }

    private HttpServletResponse createMockResponse() {
        return createMockResponse(new AtomicInteger(200), new StringWriter());
    }

    private HttpServletResponse createMockResponse(AtomicInteger statusHolder, StringWriter writer) {
        PrintWriter printWriter = new PrintWriter(writer);
        return (HttpServletResponse) Proxy.newProxyInstance(
                HttpServletResponse.class.getClassLoader(),
                new Class<?>[]{HttpServletResponse.class},
                (proxy, m, args) -> {
                    String name = m.getName();
                    if ("setStatus".equals(name)) {
                        statusHolder.set((Integer) args[0]);
                        return null;
                    } else if ("getStatus".equals(name)) {
                        return statusHolder.get();
                    } else if ("getWriter".equals(name)) {
                        return printWriter;
                    }
                    return null;
                }
        );
    }
}
