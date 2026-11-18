package com.quiztrack.dao;

import com.quiztrack.model.*;

import java.util.List;
import java.util.Optional;

/**
 * Data Access Object for teacher live examination proctoring, event telemetry, and audit interventions.
 */
public interface ProctorDao {

    /**
     * Checks whether the given teacher is authorized to monitor the specified quiz.
     */
    boolean isTeacherAuthorizedForQuiz(int quizId, int teacherId);

    /**
     * Retrieves all published, active, or completed quizzes owned by the teacher.
     */
    List<Quiz> getMonitorableQuizzesForTeacher(int teacherId);

    /**
     * Retrieves all live or submitted examinees for a quiz.
     */
    List<LiveExamineeDto> getExamineesForQuiz(int quizId);

    /**
     * Retrieves detailed monitoring state for an individual student attempt.
     */
    Optional<LiveExamineeDto> getExamineeDetails(int attemptId);

    /**
     * Retrieves recent proctoring activity events for a quiz.
     */
    List<ProctorActivityEventDto> getRecentEventsForQuiz(int quizId, int limit);

    /**
     * Retrieves violation activity logs filtered by teacher and optional severity.
     */
    List<ProctorActivityEventDto> getViolationLogs(Integer teacherId, String severityFilter, int limit);

    /**
     * Retrieves complete chronological event timeline for a specific student attempt.
     */
    List<ProctorActivityEventDto> getStudentEventsTimeline(int attemptId);

    /**
     * Marks an activity event as reviewed by a proctor with optional notes.
     */
    boolean markEventReviewed(int logId, int teacherId, String reviewNotes);

    /**
     * Flags a student attempt for further academic investigation.
     */
    boolean flagAttempt(int attemptId, int teacherId, String reason);

    /**
     * Clears an investigation flag on a student attempt with recorded justification.
     */
    boolean clearAttemptFlag(int attemptId, int teacherId, String clearReason);

    /**
     * Records a proctor intervention or teacher action in the audit trail.
     */
    boolean recordTeacherIntervention(int attemptId, int teacherId, String actionType, String message);

    /**
     * Retrieves audit log history of teacher actions and interventions for a quiz.
     */
    List<ProctorInterventionDto> getInterventionAuditLogs(int quizId, int limit);
}
