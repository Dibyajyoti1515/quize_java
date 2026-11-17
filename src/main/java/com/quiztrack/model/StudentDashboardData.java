package com.quiztrack.model;

import java.io.Serializable;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

/**
 * Data Transfer Object containing dynamic data for the Student Portal Overview Dashboard
 * and Available Quizzes Pre-Flight instructions modal.
 */
public class StudentDashboardData implements Serializable {
    private static final long serialVersionUID = 1L;

    // Student identity & workspace telemetry
    private User student;
    private String semester = "Spring 2025 Semester";
    private String cohortCode = "COHORT CS-2025-A";
    private String nodeStatus = "NODE-EAST-04 • SYNCED";
    private String systemHealth = "System Ready & Verified";
    private int unreadNotifications = 2;

    // Diagnostic KPIs (Bento rhythm)
    private int quizzesAttemptedCount;
    private int totalScheduledQuizzes;
    private double cumulativeScore;
    private String gradeLetter = "Grade A-";
    private double cohortPercentile = 94.2;
    private int cohortRank = 3;
    private int cohortTotalStudents = 128;
    private double integrityIndex = 99.1;
    private String integrityTier = "Tier 1";
    private int flaggedIncidentsCount = 0;

    // Banner active quiz
    private Quiz activeQuiz;
    private String remainingTimeFormatted = "01h 44m 32s";

    // Quizzes assigned to student
    private List<StudentQuizCard> assignedQuizzes = new ArrayList<>();

    // Curricular subject mastery
    private List<SubjectMastery> subjectMasteryList = new ArrayList<>();

    // Latest verified result
    private LatestResult latestResult;

    // Hardware pre-flight telemetry
    private boolean cameraActive = true;
    private boolean micOptimal = true;
    private boolean networkConnected = true;
    private boolean displayLocked = true;
    private int networkLatencyMs = 24;

    public StudentDashboardData() {}

    // Inner classes
    public static class StudentQuizCard implements Serializable {
        private static final long serialVersionUID = 1L;

        private int quizId;
        private String quizCode;
        private String title;
        private String description;
        private String subjectName;
        private String teacherName;
        private int durationMinutes;
        private int totalQuestions;
        private double totalMarks;
        private boolean negativeMarking;
        private double negativeMarkValue;
        private String status; // 'ACTIVE', 'SCHEDULED', 'COMPLETED'
        private String badgeText;
        private String badgeType; // 'live', 'upcoming', 'practice', 'completed'
        private String proctorLevel;
        private Timestamp dueAt;
        private String formattedDueAt;
        private boolean canStart;
        private String attemptStatus;
        private Double studentScore;
        private String studentGrade;

        public StudentQuizCard() {}

        public int getQuizId() { return quizId; }
        public void setQuizId(int quizId) { this.quizId = quizId; }

        public String getQuizCode() { return quizCode; }
        public void setQuizCode(String quizCode) { this.quizCode = quizCode; }

        public String getTitle() { return title; }
        public void setTitle(String title) { this.title = title; }

        public String getDescription() { return description; }
        public void setDescription(String description) { this.description = description; }

        public String getSubjectName() { return subjectName; }
        public void setSubjectName(String subjectName) { this.subjectName = subjectName; }

        public String getTeacherName() { return teacherName; }
        public void setTeacherName(String teacherName) { this.teacherName = teacherName; }

        public int getDurationMinutes() { return durationMinutes; }
        public void setDurationMinutes(int durationMinutes) { this.durationMinutes = durationMinutes; }

        public int getTotalQuestions() { return totalQuestions; }
        public void setTotalQuestions(int totalQuestions) { this.totalQuestions = totalQuestions; }

        public double getTotalMarks() { return totalMarks; }
        public void setTotalMarks(double totalMarks) { this.totalMarks = totalMarks; }

        public boolean isNegativeMarking() { return negativeMarking; }
        public void setNegativeMarking(boolean negativeMarking) { this.negativeMarking = negativeMarking; }

        public double getNegativeMarkValue() { return negativeMarkValue; }
        public void setNegativeMarkValue(double negativeMarkValue) { this.negativeMarkValue = negativeMarkValue; }

        public String getStatus() { return status; }
        public void setStatus(String status) { this.status = status; }

        public String getBadgeText() { return badgeText; }
        public void setBadgeText(String badgeText) { this.badgeText = badgeText; }

        public String getBadgeType() { return badgeType; }
        public void setBadgeType(String badgeType) { this.badgeType = badgeType; }

        public String getProctorLevel() { return proctorLevel; }
        public void setProctorLevel(String proctorLevel) { this.proctorLevel = proctorLevel; }

        public Timestamp getDueAt() { return dueAt; }
        public void setDueAt(Timestamp dueAt) { this.dueAt = dueAt; }

        public String getFormattedDueAt() { return formattedDueAt; }
        public void setFormattedDueAt(String formattedDueAt) { this.formattedDueAt = formattedDueAt; }

        public boolean isCanStart() { return canStart; }
        public void setCanStart(boolean canStart) { this.canStart = canStart; }

        public String getAttemptStatus() { return attemptStatus; }
        public void setAttemptStatus(String attemptStatus) { this.attemptStatus = attemptStatus; }

        public Double getStudentScore() { return studentScore; }
        public void setStudentScore(Double studentScore) { this.studentScore = studentScore; }

        public String getStudentGrade() { return studentGrade; }
        public void setStudentGrade(String studentGrade) { this.studentGrade = studentGrade; }
    }

    public static class SubjectMastery implements Serializable {
        private static final long serialVersionUID = 1L;

        private String subjectCode;
        private String subjectName;
        private int masteryPercentage;
        private String masteryLevel; // 'Advanced', 'Proficient', 'Competent', 'Developing'
        private String progressColor; // 'primary', 'secondary', 'secondary-container', 'surface-variant'

        public SubjectMastery() {}

        public SubjectMastery(String subjectCode, String subjectName, int masteryPercentage, String masteryLevel, String progressColor) {
            this.subjectCode = subjectCode;
            this.subjectName = subjectName;
            this.masteryPercentage = masteryPercentage;
            this.masteryLevel = masteryLevel;
            this.progressColor = progressColor;
        }

        public String getSubjectCode() { return subjectCode; }
        public void setSubjectCode(String subjectCode) { this.subjectCode = subjectCode; }

        public String getSubjectName() { return subjectName; }
        public void setSubjectName(String subjectName) { this.subjectName = subjectName; }

        public int getMasteryPercentage() { return masteryPercentage; }
        public void setMasteryPercentage(int masteryPercentage) { this.masteryPercentage = masteryPercentage; }

        public String getMasteryLevel() { return masteryLevel; }
        public void setMasteryLevel(String masteryLevel) { this.masteryLevel = masteryLevel; }

        public String getProgressColor() { return progressColor; }
        public void setProgressColor(String progressColor) { this.progressColor = progressColor; }
    }

    public static class LatestResult implements Serializable {
        private static final long serialVersionUID = 1L;

        private int resultId;
        private int quizId;
        private String quizCode;
        private String quizTitle;
        private double score;
        private double maxScore;
        private double percentage;
        private String grade;
        private int cohortRank;
        private double cohortPercentile;
        private String certificateHash;
        private String attemptTimestamp;
        private String proctorClearance = "Clean (100% Signal)";

        public LatestResult() {}

        public int getResultId() { return resultId; }
        public void setResultId(int resultId) { this.resultId = resultId; }

        public int getQuizId() { return quizId; }
        public void setQuizId(int quizId) { this.quizId = quizId; }

        public String getQuizCode() { return quizCode; }
        public void setQuizCode(String quizCode) { this.quizCode = quizCode; }

        public String getQuizTitle() { return quizTitle; }
        public void setQuizTitle(String quizTitle) { this.quizTitle = quizTitle; }

        public double getScore() { return score; }
        public void setScore(double score) { this.score = score; }

        public double getMaxScore() { return maxScore; }
        public void setMaxScore(double maxScore) { this.maxScore = maxScore; }

        public double getPercentage() { return percentage; }
        public void setPercentage(double percentage) { this.percentage = percentage; }

        public String getGrade() { return grade; }
        public void setGrade(String grade) { this.grade = grade; }

        public int getCohortRank() { return cohortRank; }
        public void setCohortRank(int cohortRank) { this.cohortRank = cohortRank; }

        public double getCohortPercentile() { return cohortPercentile; }
        public void setCohortPercentile(double cohortPercentile) { this.cohortPercentile = cohortPercentile; }

        public String getCertificateHash() { return certificateHash; }
        public void setCertificateHash(String certificateHash) { this.certificateHash = certificateHash; }

        public String getAttemptTimestamp() { return attemptTimestamp; }
        public void setAttemptTimestamp(String attemptTimestamp) { this.attemptTimestamp = attemptTimestamp; }

        public String getProctorClearance() { return proctorClearance; }
        public void setProctorClearance(String proctorClearance) { this.proctorClearance = proctorClearance; }
    }

    // Getters and Setters
    public User getStudent() { return student; }
    public void setStudent(User student) { this.student = student; }

    public String getSemester() { return semester; }
    public void setSemester(String semester) { this.semester = semester; }

    public String getCohortCode() { return cohortCode; }
    public void setCohortCode(String cohortCode) { this.cohortCode = cohortCode; }

    public String getNodeStatus() { return nodeStatus; }
    public void setNodeStatus(String nodeStatus) { this.nodeStatus = nodeStatus; }

    public String getSystemHealth() { return systemHealth; }
    public void setSystemHealth(String systemHealth) { this.systemHealth = systemHealth; }

    public int getUnreadNotifications() { return unreadNotifications; }
    public void setUnreadNotifications(int unreadNotifications) { this.unreadNotifications = unreadNotifications; }

    public int getQuizzesAttemptedCount() { return quizzesAttemptedCount; }
    public void setQuizzesAttemptedCount(int quizzesAttemptedCount) { this.quizzesAttemptedCount = quizzesAttemptedCount; }

    public int getTotalScheduledQuizzes() { return totalScheduledQuizzes; }
    public void setTotalScheduledQuizzes(int totalScheduledQuizzes) { this.totalScheduledQuizzes = totalScheduledQuizzes; }

    public double getCumulativeScore() { return cumulativeScore; }
    public void setCumulativeScore(double cumulativeScore) { this.cumulativeScore = cumulativeScore; }

    public String getGradeLetter() { return gradeLetter; }
    public void setGradeLetter(String gradeLetter) { this.gradeLetter = gradeLetter; }

    public double getCohortPercentile() { return cohortPercentile; }
    public void setCohortPercentile(double cohortPercentile) { this.cohortPercentile = cohortPercentile; }

    public int getCohortRank() { return cohortRank; }
    public void setCohortRank(int cohortRank) { this.cohortRank = cohortRank; }

    public int getCohortTotalStudents() { return cohortTotalStudents; }
    public void setCohortTotalStudents(int cohortTotalStudents) { this.cohortTotalStudents = cohortTotalStudents; }

    public double getIntegrityIndex() { return integrityIndex; }
    public void setIntegrityIndex(double integrityIndex) { this.integrityIndex = integrityIndex; }

    public String getIntegrityTier() { return integrityTier; }
    public void setIntegrityTier(String integrityTier) { this.integrityTier = integrityTier; }

    public int getFlaggedIncidentsCount() { return flaggedIncidentsCount; }
    public void setFlaggedIncidentsCount(int flaggedIncidentsCount) { this.flaggedIncidentsCount = flaggedIncidentsCount; }

    public Quiz getActiveQuiz() { return activeQuiz; }
    public void setActiveQuiz(Quiz activeQuiz) { this.activeQuiz = activeQuiz; }

    public String getRemainingTimeFormatted() { return remainingTimeFormatted; }
    public void setRemainingTimeFormatted(String remainingTimeFormatted) { this.remainingTimeFormatted = remainingTimeFormatted; }

    public List<StudentQuizCard> getAssignedQuizzes() { return assignedQuizzes; }
    public void setAssignedQuizzes(List<StudentQuizCard> assignedQuizzes) { this.assignedQuizzes = assignedQuizzes; }

    public List<SubjectMastery> getSubjectMasteryList() { return subjectMasteryList; }
    public void setSubjectMasteryList(List<SubjectMastery> subjectMasteryList) { this.subjectMasteryList = subjectMasteryList; }

    public LatestResult getLatestResult() { return latestResult; }
    public void setLatestResult(LatestResult latestResult) { this.latestResult = latestResult; }

    public boolean isCameraActive() { return cameraActive; }
    public void setCameraActive(boolean cameraActive) { this.cameraActive = cameraActive; }

    public boolean isMicOptimal() { return micOptimal; }
    public void setMicOptimal(boolean micOptimal) { this.micOptimal = micOptimal; }

    public boolean isNetworkConnected() { return networkConnected; }
    public void setNetworkConnected(boolean networkConnected) { this.networkConnected = networkConnected; }

    public boolean isDisplayLocked() { return displayLocked; }
    public void setDisplayLocked(boolean displayLocked) { this.displayLocked = displayLocked; }

    public int getNetworkLatencyMs() { return networkLatencyMs; }
    public void setNetworkLatencyMs(int networkLatencyMs) { this.networkLatencyMs = networkLatencyMs; }

    public int getReadyToLaunchCount() {
        int count = 0;
        for (StudentQuizCard card : assignedQuizzes) {
            if ("ACTIVE".equalsIgnoreCase(card.getStatus())) {
                count++;
            }
        }
        return count;
    }

    public int getScheduledAheadCount() {
        int count = 0;
        for (StudentQuizCard card : assignedQuizzes) {
            if ("SCHEDULED".equalsIgnoreCase(card.getStatus())) {
                count++;
            }
        }
        return count;
    }
}
