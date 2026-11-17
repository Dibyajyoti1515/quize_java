package com.quiztrack.model;

import java.io.Serializable;
import java.sql.Timestamp;

/**
 * Data Transfer Object representing a proctor intervention or teacher action in the audit trail.
 */
public class ProctorInterventionDto implements Serializable {
    private static final long serialVersionUID = 1L;

    private int interventionId;
    private int attemptId;
    private int teacherId;
    private String teacherName;
    private String actionType; // 'FLAG', 'CLEAR_FLAG', 'REVIEW', 'NOTE', 'WARNING', 'PAUSE', 'RESUME', 'TERMINATE', 'BROADCAST'
    private String message;
    private Timestamp createdAt;
    private String createdAtFormatted;

    public ProctorInterventionDto() {}

    public int getInterventionId() {
        return interventionId;
    }

    public void setInterventionId(int interventionId) {
        this.interventionId = interventionId;
    }

    public int getAttemptId() {
        return attemptId;
    }

    public void setAttemptId(int attemptId) {
        this.attemptId = attemptId;
    }

    public int getTeacherId() {
        return teacherId;
    }

    public void setTeacherId(int teacherId) {
        this.teacherId = teacherId;
    }

    public String getTeacherName() {
        return teacherName;
    }

    public void setTeacherName(String teacherName) {
        this.teacherName = teacherName;
    }

    public String getActionType() {
        return actionType;
    }

    public void setActionType(String actionType) {
        this.actionType = actionType;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public String getDetails() {
        return message;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public String getCreatedAtFormatted() {
        return createdAtFormatted;
    }

    public void setCreatedAtFormatted(String createdAtFormatted) {
        this.createdAtFormatted = createdAtFormatted;
    }
}
