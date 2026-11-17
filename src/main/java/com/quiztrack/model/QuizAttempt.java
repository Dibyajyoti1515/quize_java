package com.quiztrack.model;

import java.io.Serializable;
import java.math.BigDecimal;
import java.sql.Timestamp;

/**
 * Model representing a student's examination session/attempt.
 * Governed by server-side authoritative timestamps and status transitions.
 */
public class QuizAttempt implements Serializable {
    private static final long serialVersionUID = 1L;

    private int attemptId;
    private int quizId;
    private int studentId;
    private Timestamp startTime;
    private Timestamp endTime;
    private String status; // 'IN_PROGRESS', 'SUBMITTED', 'PAUSED', 'TERMINATED', 'FLAGGED'
    private BigDecimal totalScore;
    private BigDecimal percentage;
    private String grade;
    private boolean passed;
    private int tabSwitchCount;
    private int blurCount;
    private int fullscreenExitCount;
    private BigDecimal integrityIndex;
    private String ipAddress;
    private String userAgent;

    // Joined metadata from Quiz and Subject
    private String quizTitle;
    private String quizDescription;
    private int subjectId;
    private String subjectCode;
    private String subjectName;
    private int durationMinutes;
    private BigDecimal totalMarks;
    private BigDecimal passPercentage;
    private boolean negativeMarking;
    private BigDecimal negativeMarkValue;
    private int maxTabSwitches;
    private boolean fullscreenRequired;
    private boolean webcamRequired;

    public QuizAttempt() {
        this.status = "IN_PROGRESS";
        this.totalScore = BigDecimal.ZERO;
        this.percentage = BigDecimal.ZERO;
        this.integrityIndex = new BigDecimal("100.00");
    }

    /**
     * Calculates remaining examination time in seconds based strictly on server-side timestamps.
     */
    public long getRemainingSeconds(long serverNowMillis) {
        if (startTime == null || !"IN_PROGRESS".equalsIgnoreCase(status)) {
            return 0L;
        }
        long durationMillis = (long) durationMinutes * 60L * 1000L;
        long elapsedMillis = serverNowMillis - startTime.getTime();
        long remainingMillis = durationMillis - elapsedMillis;
        return Math.max(0L, remainingMillis / 1000L);
    }

    public boolean isExpired(long serverNowMillis) {
        return getRemainingSeconds(serverNowMillis) <= 0L;
    }

    public String getFormattedRemainingTime(long serverNowMillis) {
        long sec = getRemainingSeconds(serverNowMillis);
        long hours = sec / 3600L;
        long minutes = (sec % 3600L) / 60L;
        long seconds = sec % 60L;
        if (hours > 0) {
            return String.format("%02d:%02d:%02d", hours, minutes, seconds);
        } else {
            return String.format("%02d:%02d", minutes, seconds);
        }
    }

    // Getters and Setters
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

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public BigDecimal getTotalScore() {
        return totalScore;
    }

    public void setTotalScore(BigDecimal totalScore) {
        this.totalScore = totalScore;
    }

    public BigDecimal getPercentage() {
        return percentage;
    }

    public void setPercentage(BigDecimal percentage) {
        this.percentage = percentage;
    }

    public String getGrade() {
        return grade;
    }

    public void setGrade(String grade) {
        this.grade = grade;
    }

    public boolean isPassed() {
        return passed;
    }

    public void setPassed(boolean passed) {
        this.passed = passed;
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

    public BigDecimal getIntegrityIndex() {
        return integrityIndex;
    }

    public void setIntegrityIndex(BigDecimal integrityIndex) {
        this.integrityIndex = integrityIndex;
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

    public String getQuizTitle() {
        return quizTitle;
    }

    public void setQuizTitle(String quizTitle) {
        this.quizTitle = quizTitle;
    }

    public String getQuizDescription() {
        return quizDescription;
    }

    public void setQuizDescription(String quizDescription) {
        this.quizDescription = quizDescription;
    }

    public int getSubjectId() {
        return subjectId;
    }

    public void setSubjectId(int subjectId) {
        this.subjectId = subjectId;
    }

    public String getSubjectCode() {
        return subjectCode;
    }

    public void setSubjectCode(String subjectCode) {
        this.subjectCode = subjectCode;
    }

    public String getSubjectName() {
        return subjectName;
    }

    public void setSubjectName(String subjectName) {
        this.subjectName = subjectName;
    }

    public int getDurationMinutes() {
        return durationMinutes;
    }

    public void setDurationMinutes(int durationMinutes) {
        this.durationMinutes = durationMinutes;
    }

    public BigDecimal getTotalMarks() {
        return totalMarks;
    }

    public void setTotalMarks(BigDecimal totalMarks) {
        this.totalMarks = totalMarks;
    }

    public BigDecimal getPassPercentage() {
        return passPercentage;
    }

    public void setPassPercentage(BigDecimal passPercentage) {
        this.passPercentage = passPercentage;
    }

    public boolean isNegativeMarking() {
        return negativeMarking;
    }

    public void setNegativeMarking(boolean negativeMarking) {
        this.negativeMarking = negativeMarking;
    }

    public BigDecimal getNegativeMarkValue() {
        return negativeMarkValue;
    }

    public void setNegativeMarkValue(BigDecimal negativeMarkValue) {
        this.negativeMarkValue = negativeMarkValue;
    }

    public int getMaxTabSwitches() {
        return maxTabSwitches;
    }

    public void setMaxTabSwitches(int maxTabSwitches) {
        this.maxTabSwitches = maxTabSwitches;
    }

    public boolean isFullscreenRequired() {
        return fullscreenRequired;
    }

    public void setFullscreenRequired(boolean fullscreenRequired) {
        this.fullscreenRequired = fullscreenRequired;
    }

    public boolean isWebcamRequired() {
        return webcamRequired;
    }

    public void setWebcamRequired(boolean webcamRequired) {
        this.webcamRequired = webcamRequired;
    }
}
