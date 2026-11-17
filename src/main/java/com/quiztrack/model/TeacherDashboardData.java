package com.quiztrack.model;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

/**
 * Data Transfer Object containing all dynamic data required by the Teacher Academic Overview Dashboard.
 */
public class TeacherDashboardData implements Serializable {
    private static final long serialVersionUID = 1L;

    // Overview KPIs
    private int totalStudents;
    private int activeQuizzesCount;
    private int scheduledQuizzesCount;
    private int completedSessionsCount;
    private double averageClassScore;
    private double proctorTrustIndex;
    private int totalFlaggedIncidents;

    // In-Flight Mission Alert Banner
    private Quiz activeQuiz;
    private int activeExaminees;
    private int totalAssignedExaminees;
    private int connectedPercentage;
    private int liveFlaggedIncidents;
    private String remainingTimeFormatted;

    // Concept Mastery Radar / Bar Breakdown
    private List<TopicMastery> topicMasteryList = new ArrayList<>();

    // Cohort Comparisons
    private List<CohortMetric> cohortComparisonList = new ArrayList<>();

    // Examination Schedule & Activity
    private List<Quiz> examinationSchedule = new ArrayList<>();

    // Pending Proctor Audits
    private List<PendingAudit> pendingAudits = new ArrayList<>();

    public TeacherDashboardData() {}

    public int getTotalStudents() {
        return totalStudents;
    }

    public void setTotalStudents(int totalStudents) {
        this.totalStudents = totalStudents;
    }

    public int getActiveQuizzesCount() {
        return activeQuizzesCount;
    }

    public void setActiveQuizzesCount(int activeQuizzesCount) {
        this.activeQuizzesCount = activeQuizzesCount;
    }

    public int getScheduledQuizzesCount() {
        return scheduledQuizzesCount;
    }

    public void setScheduledQuizzesCount(int scheduledQuizzesCount) {
        this.scheduledQuizzesCount = scheduledQuizzesCount;
    }

    public int getCompletedSessionsCount() {
        return completedSessionsCount;
    }

    public void setCompletedSessionsCount(int completedSessionsCount) {
        this.completedSessionsCount = completedSessionsCount;
    }

    public double getAverageClassScore() {
        return averageClassScore;
    }

    public void setAverageClassScore(double averageClassScore) {
        this.averageClassScore = averageClassScore;
    }

    public double getProctorTrustIndex() {
        return proctorTrustIndex;
    }

    public void setProctorTrustIndex(double proctorTrustIndex) {
        this.proctorTrustIndex = proctorTrustIndex;
    }

    public int getTotalFlaggedIncidents() {
        return totalFlaggedIncidents;
    }

    public void setTotalFlaggedIncidents(int totalFlaggedIncidents) {
        this.totalFlaggedIncidents = totalFlaggedIncidents;
    }

    public Quiz getActiveQuiz() {
        return activeQuiz;
    }

    public void setActiveQuiz(Quiz activeQuiz) {
        this.activeQuiz = activeQuiz;
    }

    public int getActiveExaminees() {
        return activeExaminees;
    }

    public void setActiveExaminees(int activeExaminees) {
        this.activeExaminees = activeExaminees;
    }

    public int getTotalAssignedExaminees() {
        return totalAssignedExaminees;
    }

    public void setTotalAssignedExaminees(int totalAssignedExaminees) {
        this.totalAssignedExaminees = totalAssignedExaminees;
    }

    public int getConnectedPercentage() {
        return connectedPercentage;
    }

    public void setConnectedPercentage(int connectedPercentage) {
        this.connectedPercentage = connectedPercentage;
    }

    public int getLiveFlaggedIncidents() {
        return liveFlaggedIncidents;
    }

    public void setLiveFlaggedIncidents(int liveFlaggedIncidents) {
        this.liveFlaggedIncidents = liveFlaggedIncidents;
    }

    public String getRemainingTimeFormatted() {
        return remainingTimeFormatted;
    }

    public void setRemainingTimeFormatted(String remainingTimeFormatted) {
        this.remainingTimeFormatted = remainingTimeFormatted;
    }

    public List<TopicMastery> getTopicMasteryList() {
        return topicMasteryList;
    }

    public void setTopicMasteryList(List<TopicMastery> topicMasteryList) {
        this.topicMasteryList = topicMasteryList;
    }

    public List<CohortMetric> getCohortComparisonList() {
        return cohortComparisonList;
    }

    public void setCohortComparisonList(List<CohortMetric> cohortComparisonList) {
        this.cohortComparisonList = cohortComparisonList;
    }

    public List<Quiz> getExaminationSchedule() {
        return examinationSchedule;
    }

    public void setExaminationSchedule(List<Quiz> examinationSchedule) {
        this.examinationSchedule = examinationSchedule;
    }

    public List<PendingAudit> getPendingAudits() {
        return pendingAudits;
    }

    public void setPendingAudits(List<PendingAudit> pendingAudits) {
        this.pendingAudits = pendingAudits;
    }

    /**
     * Inner DTO representing topic/taxonomy mastery percentages.
     */
    public static class TopicMastery implements Serializable {
        private String topicName;
        private double masteryPercentage;
        private boolean reviewNeeded;
        private boolean strongestArea;

        public TopicMastery(String topicName, double masteryPercentage, boolean reviewNeeded, boolean strongestArea) {
            this.topicName = topicName;
            this.masteryPercentage = masteryPercentage;
            this.reviewNeeded = reviewNeeded;
            this.strongestArea = strongestArea;
        }

        public String getTopicName() { return topicName; }
        public double getMasteryPercentage() { return masteryPercentage; }
        public boolean isReviewNeeded() { return reviewNeeded; }
        public boolean isStrongestArea() { return strongestArea; }
    }

    /**
     * Inner DTO representing cohort academic metrics.
     */
    public static class CohortMetric implements Serializable {
        private String cohortName;
        private int studentCount;
        private double averageScore;
        private double proctorScore;

        public CohortMetric(String cohortName, int studentCount, double averageScore, double proctorScore) {
            this.cohortName = cohortName;
            this.studentCount = studentCount;
            this.averageScore = averageScore;
            this.proctorScore = proctorScore;
        }

        public String getCohortName() { return cohortName; }
        public int getStudentCount() { return studentCount; }
        public double getAverageScore() { return averageScore; }
        public double getProctorScore() { return proctorScore; }
    }

    /**
     * Inner DTO representing flagged audit items.
     */
    public static class PendingAudit implements Serializable {
        private int attemptId;
        private String initials;
        private String studentName;
        private String cohortName;
        private String issueDescription;
        private String severity; // 'CRITICAL', 'CAUTION', 'INFO'

        public PendingAudit(int attemptId, String initials, String studentName, String cohortName, String issueDescription, String severity) {
            this.attemptId = attemptId;
            this.initials = initials;
            this.studentName = studentName;
            this.cohortName = cohortName;
            this.issueDescription = issueDescription;
            this.severity = severity;
        }

        public int getAttemptId() { return attemptId; }
        public String getInitials() { return initials; }
        public String getStudentName() { return studentName; }
        public String getCohortName() { return cohortName; }
        public String getIssueDescription() { return issueDescription; }
        public String getSeverity() { return severity; }
    }
}
