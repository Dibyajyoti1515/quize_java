package com.quiztrack.service;

import com.quiztrack.model.Question;
import com.quiztrack.model.Quiz;
import com.quiztrack.model.Subject;
import com.quiztrack.model.TeacherDashboardData;
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

    boolean isQuizOwnedBy(int quizId, int teacherId);

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
}
