package com.quiztrack.service;

import com.quiztrack.model.*;

import java.util.List;

/**
 * Service interface for teacher live monitoring, candidate session oversight, and proctoring interventions.
 */
public interface ProctorService {

    /**
     * Compiles complete live monitoring command center data for a quiz.
     * Enforces teacher quiz ownership authorization.
     */
    TeacherLiveMonitoringData getMonitoringDashboard(int quizId, int teacherId);

    /**
     * Retrieves single student's live examination state.
     */
    LiveExamineeDto getExamineeDetails(int attemptId, int teacherId);

    /**
     * Retrieves full chronological event timeline for a specific student attempt.
     */
    List<ProctorActivityEventDto> getStudentTimeline(int attemptId, int teacherId);

    /**
     * Marks an individual browser telemetry event as reviewed by a proctor with optional note.
     */
    boolean reviewEvent(int logId, int teacherId, String reviewNotes);

    /**
     * Flags a candidate session for academic investigation with recorded justification.
     */
    boolean flagStudentAttempt(int attemptId, int teacherId, String flagReason);

    /**
     * Clears an investigation flag on a candidate session with recorded justification.
     */
    boolean clearStudentFlag(int attemptId, int teacherId, String clearReason);

    /**
     * Broadcasts an administrative or technical notice to all active candidates in a quiz.
     */
    boolean broadcastNotice(int quizId, int teacherId, String message);
}
