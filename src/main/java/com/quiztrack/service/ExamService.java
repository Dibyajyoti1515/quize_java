package com.quiztrack.service;

import com.quiztrack.model.ExamSessionDto;
import com.quiztrack.model.QuizAttempt;

import java.util.Optional;

/**
 * Service interface for Candidate Examination lifecycle:
 * Pre-flight verification, authoritative timer calculation, autosave, and submission evaluation.
 */
public interface ExamService {

    QuizAttempt startOrResumeExam(int quizId, int studentId, String ipAddress, String userAgent);

    Optional<QuizAttempt> getAttemptById(int attemptId, int studentId);

    ExamSessionDto getExamSession(int attemptId, int studentId, Integer questionIndex);

    boolean saveAnswer(int attemptId, int studentId, int questionId, Integer selectedOptionId, boolean isFlagged);

    boolean saveAnswer(int attemptId, int studentId, int questionId, java.util.List<Integer> selectedOptionIds, boolean isFlagged);

    boolean toggleFlag(int attemptId, int studentId, int questionId, boolean isFlagged);

    QuizAttempt submitExam(int attemptId, int studentId);

    boolean recordTelemetry(int attemptId, int studentId, String eventType, String severity, String details);
}
