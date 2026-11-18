package com.quiztrack.service;

import com.quiztrack.model.Cohort;
import com.quiztrack.model.Question;
import com.quiztrack.model.Quiz;
import com.quiztrack.model.QuizAssignment;
import com.quiztrack.model.Subject;
import com.quiztrack.model.TeacherDashboardData;
import com.quiztrack.model.User;
import java.sql.Timestamp;
import java.util.List;
import java.util.Optional;

/**
 * Service interface for Teacher portal operations:
 * - Academic Overview & Live Proctoring summaries
 * - Quiz Creation, Publishing & Lifecycle Management
 * - Question Bank Authoring, Editing, Linking & Management
 */
public interface TeacherService {

    TeacherDashboardData getDashboardOverview(int teacherId);

    // Quiz Lifecycle
    Quiz createQuiz(Quiz quiz, int teacherId);

    boolean updateQuiz(Quiz quiz, int teacherId);

    boolean deleteQuiz(int quizId, int teacherId);

    boolean setQuizStatus(int quizId, int teacherId, String status);

    Optional<Quiz> getQuizById(int quizId);

    List<Quiz> getQuizzesByTeacher(int teacherId);

    List<Quiz> getAllQuizzes();

    boolean isQuizOwnedBy(int quizId, int teacherId);

    void validateQuizForPublish(int quizId, int teacherId);

    boolean syncTotalMarks(int quizId);

    List<Subject> getAllSubjects();

    // Question Bank & Quiz Item Management
    Question createQuestion(Question question, int teacherId);

    boolean updateQuestion(Question question, int teacherId);

    boolean deleteQuestion(int questionId, int teacherId);

    Optional<Question> getQuestionById(int questionId);

    List<Question> getQuestionsForQuiz(int quizId);

    List<Question> getQuestionBank(Integer subjectId, String difficulty, String topic, String searchQuery, int limit, int offset);

    int countQuestionBank(Integer subjectId, String difficulty, String topic, String searchQuery);

    boolean addQuestionToQuiz(int questionId, int quizId, int teacherId);

    boolean removeQuestionFromQuiz(int questionId, int quizId, int teacherId);

    int duplicateQuestion(int questionId, Integer targetQuizId, int teacherId);

    // Quiz Assignments & Target Slates (Task 5 / B1)
    List<QuizAssignment> getQuizAssignments(int quizId, int teacherId);

    boolean assignQuizToCohort(int quizId, int cohortId, Timestamp dueAt, int teacherId);

    boolean assignQuizToStudent(int quizId, int studentId, Timestamp dueAt, int teacherId);

    boolean removeQuizAssignment(int assignmentId, int quizId, int teacherId);

    List<Cohort> getAvailableCohortsForTeacher(int teacherId);

    List<User> getAvailableStudentsForTeacher(int teacherId);

    // Performance Reports
    List<com.quiztrack.model.StudentResultDto> getQuizPerformanceReport(int quizId, int teacherId);
}
