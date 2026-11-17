package com.quiztrack.model;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

/**
 * Model encapsulating real-time PostgreSQL statistics for the System Administrator Dashboard.
 */
public class AdminDashboardStats implements Serializable {
    private static final long serialVersionUID = 1L;

    // User Metrics
    private int totalStudents;
    private int totalTeachers;
    private int totalAdmins;
    private int totalUsers;
    private int activeUsers;
    private int inactiveUsers;
    private int suspendedUsers;

    // Examination & Academic Metrics
    private int totalQuizzes;
    private int activeExaminations;
    private int completedAttempts;
    private int totalQuestions;
    private double averageScorePercentage;
    private double overallPassRate;

    // System Status
    private boolean maintenanceMode;
    private boolean registrationEnabled;
    private String applicationName;

    // Lists for Dashboard Widgets
    private List<AuditLogEntryDto> recentActivities = new ArrayList<>();
    private List<UserTrendDto> registrationTrends = new ArrayList<>();

    public AdminDashboardStats() {}

    public int getTotalStudents() {
        return totalStudents;
    }

    public void setTotalStudents(int totalStudents) {
        this.totalStudents = totalStudents;
    }

    public int getTotalTeachers() {
        return totalTeachers;
    }

    public void setTotalTeachers(int totalTeachers) {
        this.totalTeachers = totalTeachers;
    }

    public int getTotalAdmins() {
        return totalAdmins;
    }

    public void setTotalAdmins(int totalAdmins) {
        this.totalAdmins = totalAdmins;
    }

    public int getTotalUsers() {
        return totalUsers;
    }

    public void setTotalUsers(int totalUsers) {
        this.totalUsers = totalUsers;
    }

    public int getActiveUsers() {
        return activeUsers;
    }

    public void setActiveUsers(int activeUsers) {
        this.activeUsers = activeUsers;
    }

    public int getInactiveUsers() {
        return inactiveUsers;
    }

    public void setInactiveUsers(int inactiveUsers) {
        this.inactiveUsers = inactiveUsers;
    }

    public int getSuspendedUsers() {
        return suspendedUsers;
    }

    public void setSuspendedUsers(int suspendedUsers) {
        this.suspendedUsers = suspendedUsers;
    }

    public int getTotalQuizzes() {
        return totalQuizzes;
    }

    public void setTotalQuizzes(int totalQuizzes) {
        this.totalQuizzes = totalQuizzes;
    }

    public int getActiveExaminations() {
        return activeExaminations;
    }

    public void setActiveExaminations(int activeExaminations) {
        this.activeExaminations = activeExaminations;
    }

    public int getCompletedAttempts() {
        return completedAttempts;
    }

    public void setCompletedAttempts(int completedAttempts) {
        this.completedAttempts = completedAttempts;
    }

    public int getTotalQuestions() {
        return totalQuestions;
    }

    public void setTotalQuestions(int totalQuestions) {
        this.totalQuestions = totalQuestions;
    }

    public double getAverageScorePercentage() {
        return averageScorePercentage;
    }

    public void setAverageScorePercentage(double averageScorePercentage) {
        this.averageScorePercentage = averageScorePercentage;
    }

    public double getOverallPassRate() {
        return overallPassRate;
    }

    public void setOverallPassRate(double overallPassRate) {
        this.overallPassRate = overallPassRate;
    }

    public boolean isMaintenanceMode() {
        return maintenanceMode;
    }

    public void setMaintenanceMode(boolean maintenanceMode) {
        this.maintenanceMode = maintenanceMode;
    }

    public boolean isRegistrationEnabled() {
        return registrationEnabled;
    }

    public void setRegistrationEnabled(boolean registrationEnabled) {
        this.registrationEnabled = registrationEnabled;
    }

    public String getApplicationName() {
        return applicationName;
    }

    public void setApplicationName(String applicationName) {
        this.applicationName = applicationName;
    }

    public List<AuditLogEntryDto> getRecentActivities() {
        return recentActivities;
    }

    public void setRecentActivities(List<AuditLogEntryDto> recentActivities) {
        this.recentActivities = recentActivities;
    }

    public List<UserTrendDto> getRegistrationTrends() {
        return registrationTrends;
    }

    public void setRegistrationTrends(List<UserTrendDto> registrationTrends) {
        this.registrationTrends = registrationTrends;
    }

    public static class UserTrendDto implements Serializable {
        private static final long serialVersionUID = 1L;
        private String label;
        private int count;

        public UserTrendDto() {}

        public UserTrendDto(String label, int count) {
            this.label = label;
            this.count = count;
        }

        public String getLabel() {
            return label;
        }

        public void setLabel(String label) {
            this.label = label;
        }

        public int getCount() {
            return count;
        }

        public void setCount(int count) {
            this.count = count;
        }
    }
}
