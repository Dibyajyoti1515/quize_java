package com.quiztrack.model;

import java.io.Serializable;
import java.math.BigDecimal;
import java.sql.Timestamp;

/**
 * Model representing an Examination or Quiz in QuizTrack.
 */
public class Quiz implements Serializable {
    private static final long serialVersionUID = 1L;

    private int quizId;
    private String title;
    private String description;
    private int subjectId;
    private String subjectCode;
    private String subjectName;
    private int teacherId;
    private String teacherName;
    private int durationMinutes;
    private BigDecimal totalMarks;
    private BigDecimal passPercentage;
    private boolean negativeMarking;
    private BigDecimal negativeMarkValue;
    private int maxTabSwitches;
    private boolean fullscreenRequired;
    private boolean webcamRequired;
    private boolean shuffleQuestions;
    private Timestamp startTime;
    private Timestamp endTime;
    private String status; // 'DRAFT', 'SCHEDULED', 'ACTIVE', 'COMPLETED', 'ARCHIVED'
    private Timestamp createdAt;
    private Timestamp updatedAt;

    // Computed / Aggregate Fields
    private int totalQuestions;
    private int totalSubmissions;
    private int activeExaminees;
    private double averageScore;
    private int flaggedCount;

    public Quiz() {
        this.totalMarks = new BigDecimal("100.00");
        this.passPercentage = new BigDecimal("40.00");
        this.negativeMarkValue = BigDecimal.ZERO;
        this.maxTabSwitches = 3;
        this.fullscreenRequired = true;
        this.webcamRequired = true;
        this.status = "DRAFT";
    }

    public int getQuizId() {
        return quizId;
    }

    public void setQuizId(int quizId) {
        this.quizId = quizId;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
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

    public boolean isShuffleQuestions() {
        return shuffleQuestions;
    }

    public void setShuffleQuestions(boolean shuffleQuestions) {
        this.shuffleQuestions = shuffleQuestions;
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

    public String getStartTimeIso() {
        if (startTime == null) return "";
        return new java.text.SimpleDateFormat("yyyy-MM-dd'T'HH:mm").format(startTime);
    }

    public String getEndTimeIso() {
        if (endTime == null) return "";
        return new java.text.SimpleDateFormat("yyyy-MM-dd'T'HH:mm").format(endTime);
    }

    public String getFormattedScheduleWindow() {
        if (startTime == null && endTime == null) return "Not Scheduled (Continuous)";
        java.text.SimpleDateFormat fmt = new java.text.SimpleDateFormat("MMM dd, yyyy • HH:mm");
        if (startTime != null && endTime != null) {
            return fmt.format(startTime) + " – " + fmt.format(endTime);
        } else if (startTime != null) {
            return "Opens: " + fmt.format(startTime);
        } else {
            return "Closes: " + fmt.format(endTime);
        }
    }

    public boolean hasActiveOrPastAttempts() {
        return totalSubmissions > 0 || activeExaminees > 0;
    }

    public boolean isHasActiveOrPastAttempts() {
        return hasActiveOrPastAttempts();
    }

    public boolean getHasActiveOrPastAttempts() {
        return hasActiveOrPastAttempts();
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public Timestamp getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(Timestamp updatedAt) {
        this.updatedAt = updatedAt;
    }

    public int getTotalQuestions() {
        return totalQuestions;
    }

    public void setTotalQuestions(int totalQuestions) {
        this.totalQuestions = totalQuestions;
    }

    public int getTotalSubmissions() {
        return totalSubmissions;
    }

    public void setTotalSubmissions(int totalSubmissions) {
        this.totalSubmissions = totalSubmissions;
    }

    public int getActiveExaminees() {
        return activeExaminees;
    }

    public void setActiveExaminees(int activeExaminees) {
        this.activeExaminees = activeExaminees;
    }

    public double getAverageScore() {
        return averageScore;
    }

    public void setAverageScore(double averageScore) {
        this.averageScore = averageScore;
    }

    public int getFlaggedCount() {
        return flaggedCount;
    }

    public void setFlaggedCount(int flaggedCount) {
        this.flaggedCount = flaggedCount;
    }

    public boolean isLiveNow() {
        return "ACTIVE".equalsIgnoreCase(this.status);
    }
}
