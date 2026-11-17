package com.quiztrack.model;

import java.io.Serializable;
import java.sql.Timestamp;
import java.time.format.DateTimeFormatter;

/**
 * Data Transfer Object representing an enterprise system audit trail entry.
 */
public class AuditLogEntryDto implements Serializable {
    private static final long serialVersionUID = 1L;

    private int logId;
    private Integer attemptId;
    private int userId;
    private String userName;
    private String userIdentifier;
    private String userRole;
    private Integer targetUserId;
    private String targetUserName;
    private String targetUserIdentifier;
    private String eventType;
    private String severity; // 'INFO', 'CAUTION', 'CRITICAL'
    private String details;
    private Timestamp eventTimestamp;
    private String ipAddress;

    public AuditLogEntryDto() {}

    public int getLogId() {
        return logId;
    }

    public void setLogId(int logId) {
        this.logId = logId;
    }

    public Integer getAttemptId() {
        return attemptId;
    }

    public void setAttemptId(Integer attemptId) {
        this.attemptId = attemptId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }

    public String getUserIdentifier() {
        return userIdentifier;
    }

    public void setUserIdentifier(String userIdentifier) {
        this.userIdentifier = userIdentifier;
    }

    public String getUserRole() {
        return userRole;
    }

    public void setUserRole(String userRole) {
        this.userRole = userRole;
    }

    public Integer getTargetUserId() {
        return targetUserId;
    }

    public void setTargetUserId(Integer targetUserId) {
        this.targetUserId = targetUserId;
    }

    public String getTargetUserName() {
        return targetUserName;
    }

    public void setTargetUserName(String targetUserName) {
        this.targetUserName = targetUserName;
    }

    public String getTargetUserIdentifier() {
        return targetUserIdentifier;
    }

    public void setTargetUserIdentifier(String targetUserIdentifier) {
        this.targetUserIdentifier = targetUserIdentifier;
    }

    public String getEventType() {
        return eventType;
    }

    public void setEventType(String eventType) {
        this.eventType = eventType;
    }

    public String getSeverity() {
        return severity != null ? severity : "INFO";
    }

    public void setSeverity(String severity) {
        this.severity = severity;
    }

    public String getDetails() {
        return details;
    }

    public void setDetails(String details) {
        this.details = details;
    }

    public Timestamp getEventTimestamp() {
        return eventTimestamp;
    }

    public void setEventTimestamp(Timestamp eventTimestamp) {
        this.eventTimestamp = eventTimestamp;
    }

    public String getIpAddress() {
        return ipAddress;
    }

    public void setIpAddress(String ipAddress) {
        this.ipAddress = ipAddress;
    }

    public String getFormattedTimestamp() {
        if (eventTimestamp == null) return "N/A";
        return eventTimestamp.toLocalDateTime().format(DateTimeFormatter.ofPattern("MMM dd, yyyy HH:mm:ss"));
    }
}
