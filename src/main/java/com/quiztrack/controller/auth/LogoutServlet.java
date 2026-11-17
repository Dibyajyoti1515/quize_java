package com.quiztrack.controller.auth;

import com.quiztrack.dao.UserDao;
import com.quiztrack.dao.impl.UserDaoImpl;
import com.quiztrack.model.User;
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
 * Controller handling user sign-out, session invalidation, and audit logging.
 */
@WebServlet(name = "LogoutServlet", urlPatterns = {"/auth/logout", "/logout"})
public class LogoutServlet extends HttpServlet {

    private static final Logger logger = LoggerFactory.getLogger(LogoutServlet.class);
    private final UserDao userDao = new UserDaoImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        performLogout(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        performLogout(request, response);
    }

    private void performLogout(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        HttpSession session = request.getSession(false);
        if (session != null) {
            User user = (User) session.getAttribute("currentUser");
            if (user != null) {
                userDao.logActivity(user.getUserId(), "USER_LOGOUT", "INFO", "User logged out voluntarily");
                logger.info("User logged out: {} ({})", user.getIdentifier(), user.getRoleName());
            }
            session.invalidate();
        }
        response.sendRedirect(request.getContextPath() + "/auth/login?logout=success");
    }
}
