package com.quiztrack.model;

import java.io.Serializable;
import java.math.BigDecimal;
import java.sql.Timestamp;

/**
 * Data Transfer Object representing a candidate in an active or monitored examination session.
 */
public class LiveExamineeDto implements Serializable {
    private static final long serialVersionUID = 1L;

    private int attemptId;
    private int quizId;
    private int studentId;
    private String studentName;
    private String studentIdentifier;
    private String avatarInitials;
    private String status; // 'IN_PROGRESS', 'SUBMITTED', 'FLAGGED', 'PAUSED'
    private Timestamp startTime;
    private Timestamp endTime;
    private int durationMinutes;
    private long remainingSeconds;
    private String remainingFormatted;
    private Timestamp lastActivityTime;
    private String lastActivityFormatted;
    private String ipAddress;
    private String userAgent;

    // Telemetry and Anomaly Indicators
    private int tabSwitchCount;
    private int blurCount;
    private int fullscreenExitCount;
    private int inactivityCount;
    private int totalViolations;
    private BigDecimal integrityIndex;
    private String integrityLevel; // 'NORMAL', 'CAUTION', 'CRITICAL'

    // Proctor Flag State
    private boolean isFlagged;
    private String flagReason;
    private Timestamp flaggedAt;
    private String flaggedByName;

    // Exam Progress
    private int answeredCount;
    private int totalQuestions;
    private double progressPercentage;
    private BigDecimal currentScore;

    public LiveExamineeDto() {
        this.status = "IN_PROGRESS";
        this.integrityIndex = new BigDecimal("100.00");
        this.integrityLevel = "NORMAL";
        this.currentScore = BigDecimal.ZERO;
    }

    public int getAttemptId() {
        return attemptId;
    }

    public void setAttemptId(int attemptId) {
        this.attemptId = attemptId;
    }

    public int getQuizId() {
        return quizId;
    }

    public void setQuizId(int quizId) {
        this.quizId = quizId;
    }

    public int getStudentId() {
        return studentId;
    }

    public void setStudentId(int studentId) {
        this.studentId = studentId;
    }

    public String getStudentName() {
        return studentName;
    }

    public void setStudentName(String studentName) {
        this.studentName = studentName;
        if (studentName != null && !studentName.isBlank()) {
            String[] parts = studentName.trim().split("\\s+");
            if (parts.length >= 2) {
                this.avatarInitials = ("" + parts[0].charAt(0) + parts[parts.length - 1].charAt(0)).toUpperCase();
            } else if (parts.length == 1 && !parts[0].isEmpty()) {
                this.avatarInitials = parts[0].substring(0, Math.min(2, parts[0].length())).toUpperCase();
            }
        }
    }

    public String getStudentIdentifier() {
        return studentIdentifier;
    }

    public void setStudentIdentifier(String studentIdentifier) {
        this.studentIdentifier = studentIdentifier;
    }

    public String getAvatarInitials() {
        return avatarInitials != null ? avatarInitials : "ST";
    }

    public void setAvatarInitials(String avatarInitials) {
        this.avatarInitials = avatarInitials;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Timestamp getStartTime() {
        return startTime;
    }

    public void setStartTime(Timestamp startTime) {
        this.startTime = startTime;
    }

    public Timestamp getEndTime() {
        return endTime;
    }

    public void setEndTime(Timestamp endTime) {
        this.endTime = endTime;
    }

    public int getDurationMinutes() {
        return durationMinutes;
    }

    public void setDurationMinutes(int durationMinutes) {
        this.durationMinutes = durationMinutes;
    }

    public long getRemainingSeconds() {
        return remainingSeconds;
    }

    public void setRemainingSeconds(long remainingSeconds) {
        this.remainingSeconds = remainingSeconds;
    }

    public String getRemainingFormatted() {
        return remainingFormatted;
    }

    public void setRemainingFormatted(String remainingFormatted) {
        this.remainingFormatted = remainingFormatted;
    }

    public Timestamp getLastActivityTime() {
        return lastActivityTime;
    }

    public void setLastActivityTime(Timestamp lastActivityTime) {
        this.lastActivityTime = lastActivityTime;
    }

    public String getLastActivityFormatted() {
        return lastActivityFormatted != null ? lastActivityFormatted : "Active now";
    }

    public void setLastActivityFormatted(String lastActivityFormatted) {
        this.lastActivityFormatted = lastActivityFormatted;
    }

    public String getIpAddress() {
        return ipAddress;
    }

    public void setIpAddress(String ipAddress) {
        this.ipAddress = ipAddress;
    }

    public String getUserAgent() {
        return userAgent;
    }

    public void setUserAgent(String userAgent) {
        this.userAgent = userAgent;
    }

    public int getTabSwitchCount() {
        return tabSwitchCount;
    }

    public void setTabSwitchCount(int tabSwitchCount) {
        this.tabSwitchCount = tabSwitchCount;
    }

    public int getBlurCount() {
        return blurCount;
    }

    public void setBlurCount(int blurCount) {
        this.blurCount = blurCount;
    }

    public int getFullscreenExitCount() {
        return fullscreenExitCount;
    }

    public void setFullscreenExitCount(int fullscreenExitCount) {
        this.fullscreenExitCount = fullscreenExitCount;
    }

    public int getInactivityCount() {
        return inactivityCount;
    }

    public void setInactivityCount(int inactivityCount) {
        this.inactivityCount = inactivityCount;
    }

    public int getTotalViolations() {
        return totalViolations;
    }

    public void setTotalViolations(int totalViolations) {
        this.totalViolations = totalViolations;
    }

    public BigDecimal getIntegrityIndex() {
        return integrityIndex;
    }

    public void setIntegrityIndex(BigDecimal integrityIndex) {
        this.integrityIndex = integrityIndex;
    }

    public String getIntegrityLevel() {
        return integrityLevel;
    }

    public void setIntegrityLevel(String integrityLevel) {
        this.integrityLevel = integrityLevel;
    }

    public boolean isFlagged() {
        return isFlagged;
    }

    public void setFlagged(boolean flagged) {
        isFlagged = flagged;
    }

    public String getFlagReason() {
        return flagReason;
    }

    public void setFlagReason(String flagReason) {
        this.flagReason = flagReason;
    }

    public Timestamp getFlaggedAt() {
        return flaggedAt;
    }

    public void setFlaggedAt(Timestamp flaggedAt) {
        this.flaggedAt = flaggedAt;
    }

    public String getFlaggedByName() {
        return flaggedByName;
    }

    public void setFlaggedByName(String flaggedByName) {
        this.flaggedByName = flaggedByName;
    }

    public int getAnsweredCount() {
        return answeredCount;
    }

    public void setAnsweredCount(int answeredCount) {
        this.answeredCount = answeredCount;
    }

    public int getTotalQuestions() {
        return totalQuestions;
    }

    public void setTotalQuestions(int totalQuestions) {
        this.totalQuestions = totalQuestions;
    }

    public double getProgressPercentage() {
        return progressPercentage;
    }

    public void setProgressPercentage(double progressPercentage) {
        this.progressPercentage = progressPercentage;
    }

    public BigDecimal getCurrentScore() {
        return currentScore;
    }

    public void setCurrentScore(BigDecimal currentScore) {
        this.currentScore = currentScore;
    }
}
