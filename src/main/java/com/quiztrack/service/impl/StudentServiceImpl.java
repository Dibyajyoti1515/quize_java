package com.quiztrack.service.impl;

import com.quiztrack.dao.QuizDao;
import com.quiztrack.dao.StudentDao;
import com.quiztrack.dao.UserDao;
import com.quiztrack.dao.impl.QuizDaoImpl;
import com.quiztrack.dao.impl.StudentDaoImpl;
import com.quiztrack.dao.impl.UserDaoImpl;
import com.quiztrack.model.Quiz;
import com.quiztrack.model.StudentDashboardData;
import com.quiztrack.model.StudentDashboardData.StudentQuizCard;
import com.quiztrack.model.User;
import com.quiztrack.service.StudentService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.List;
import java.util.Optional;

/**
 * Service implementation for Student operations.
 */
public class StudentServiceImpl implements StudentService {

    private static final Logger logger = LoggerFactory.getLogger(StudentServiceImpl.class);

    private final StudentDao studentDao;
    private final UserDao userDao;
    private final QuizDao quizDao;

    public StudentServiceImpl() {
        this.studentDao = new StudentDaoImpl();
        this.userDao = new UserDaoImpl();
        this.quizDao = new QuizDaoImpl();
    }

    public StudentServiceImpl(StudentDao studentDao, UserDao userDao, QuizDao quizDao) {
        this.studentDao = studentDao;
        this.userDao = userDao;
        this.quizDao = quizDao;
    }

    @Override
    public StudentDashboardData getStudentDashboardData(int studentId) {
        StudentDashboardData data = new StudentDashboardData();

        // 1. Student User Profile
        Optional<User> userOpt = userDao.findById(studentId);
        if (userOpt.isPresent()) {
            User user = userOpt.get();
            data.setStudent(user);
            if (user.getCohort() != null && !user.getCohort().isEmpty()) {
                data.setCohortCode("COHORT " + user.getCohort());
            }
        }

        // 2. Assigned Quizzes
        List<StudentQuizCard> assignedQuizzes = studentDao.getAssignedQuizzes(studentId);
        data.setAssignedQuizzes(assignedQuizzes);

        // 3. Identify Banner Active Quiz (prioritize active unsubmitted quiz assigned to student)
        for (StudentQuizCard card : assignedQuizzes) {
            if ("ACTIVE".equalsIgnoreCase(card.getStatus()) && !"SUBMITTED".equalsIgnoreCase(card.getAttemptStatus())) {
                Optional<Quiz> qOpt = quizDao.findById(card.getQuizId());
                qOpt.ifPresent(data::setActiveQuiz);
                break;
            }
        }
        if (data.getActiveQuiz() == null) {
            Optional<Quiz> qOpt = quizDao.findActiveQuiz();
            qOpt.ifPresent(data::setActiveQuiz);
        }

        // 4. Curricular Subject Mastery
        data.setSubjectMasteryList(studentDao.getSubjectMastery(studentId));

        // 5. Latest Verified Result
        studentDao.getLatestResult(studentId).ifPresent(data::setLatestResult);

        // 6. Unread Notifications
        data.setUnreadNotifications(studentDao.countUnreadNotifications(studentId));

        // 7. Diagnostic KPIs (Attempts, Standing, GPA, Integrity Index)
        studentDao.populateStudentKPIs(studentId, data);

        return data;
    }

    @Override
    public List<StudentQuizCard> getAvailableQuizzes(int studentId) {
        return studentDao.getAssignedQuizzes(studentId);
    }

    @Override
    public Optional<StudentQuizCard> getQuizDetails(int quizId, int studentId) {
        List<StudentQuizCard> quizzes = studentDao.getAssignedQuizzes(studentId);
        for (StudentQuizCard card : quizzes) {
            if (card.getQuizId() == quizId) {
                return Optional.of(card);
            }
        }
        return Optional.empty();
    }
}
