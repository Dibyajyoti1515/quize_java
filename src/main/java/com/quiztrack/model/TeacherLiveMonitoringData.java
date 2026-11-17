package com.quiztrack.model;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

/**
 * Aggregated view model for the Teacher Live Monitoring & Proctoring Command Center.
 */
public class TeacherLiveMonitoringData implements Serializable {
    private static final long serialVersionUID = 1L;

    private int quizId;
    private String quizTitle;
    private String subjectCode;
    private String subjectName;
    private int teacherId;
    private String teacherName;
    private String quizStatus;
    private int durationMinutes;

    // KPI Metrics
    private int totalAssigned;
    private int activeCount;
    private int submittedCount;
    private int flaggedCount;
    private int criticalCount;
    private double averageProgress;
    private BigDecimal averageIntegrityIndex;

    // Collections
    private List<LiveExamineeDto> examinees = new ArrayList<>();
    private List<ProctorActivityEventDto> recentEvents = new ArrayList<>();
    private List<ProctorInterventionDto> auditLogs = new ArrayList<>();
    private List<Quiz> availableQuizzes = new ArrayList<>();

    public TeacherLiveMonitoringData() {
        this.averageIntegrityIndex = new BigDecimal("100.00");
    }

    public int getQuizId() {
        return quizId;
    }

    public void setQuizId(int quizId) {
        this.quizId = quizId;
    }

    public String getQuizTitle() {
        return quizTitle;
    }

    public void setQuizTitle(String quizTitle) {
        this.quizTitle = quizTitle;
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

    public String getQuizStatus() {
        return quizStatus;
    }

    public void setQuizStatus(String quizStatus) {
        this.quizStatus = quizStatus;
    }

    public int getDurationMinutes() {
        return durationMinutes;
    }

    public void setDurationMinutes(int durationMinutes) {
        this.durationMinutes = durationMinutes;
    }

    public int getTotalAssigned() {
        return totalAssigned;
    }

    public void setTotalAssigned(int totalAssigned) {
        this.totalAssigned = totalAssigned;
    }

    public int getActiveCount() {
        return activeCount;
    }

    public void setActiveCount(int activeCount) {
        this.activeCount = activeCount;
    }

    public int getSubmittedCount() {
        return submittedCount;
    }

    public void setSubmittedCount(int submittedCount) {
        this.submittedCount = submittedCount;
    }

    public int getFlaggedCount() {
        return flaggedCount;
    }

    public void setFlaggedCount(int flaggedCount) {
        this.flaggedCount = flaggedCount;
    }

    public int getCriticalCount() {
        return criticalCount;
    }

    public void setCriticalCount(int criticalCount) {
        this.criticalCount = criticalCount;
    }

    public double getAverageProgress() {
        return averageProgress;
    }

    public void setAverageProgress(double averageProgress) {
        this.averageProgress = averageProgress;
    }

    public BigDecimal getAverageIntegrityIndex() {
        return averageIntegrityIndex;
    }

    public void setAverageIntegrityIndex(BigDecimal averageIntegrityIndex) {
        this.averageIntegrityIndex = averageIntegrityIndex;
    }

    public List<LiveExamineeDto> getExaminees() {
        return examinees;
    }

    public void setExaminees(List<LiveExamineeDto> examinees) {
        this.examinees = examinees;
    }

    public List<ProctorActivityEventDto> getRecentEvents() {
        return recentEvents;
    }

    public void setRecentEvents(List<ProctorActivityEventDto> recentEvents) {
        this.recentEvents = recentEvents;
    }

    public List<ProctorInterventionDto> getAuditLogs() {
        return auditLogs;
    }

    public void setAuditLogs(List<ProctorInterventionDto> auditLogs) {
        this.auditLogs = auditLogs;
    }

    public List<Quiz> getAvailableQuizzes() {
        return availableQuizzes;
    }

    public void setAvailableQuizzes(List<Quiz> availableQuizzes) {
        this.availableQuizzes = availableQuizzes;
    }
}
