package com.quiztrack.model;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

/**
 * Encapsulates department-level analytics, faculty rosters, examination totals,
 * and top student performance benchmarks for the Administrative Console.
 */
public class DepartmentSummaryDto implements Serializable {
    private static final long serialVersionUID = 1L;

    private String departmentName;
    private int teacherCount;
    private int studentCount;
    private int quizCount;
    private double averageScore;
    private List<DepartmentTeacherDto> teachers = new ArrayList<>();
    private List<DepartmentTopStudentDto> topStudents = new ArrayList<>();
    private List<DepartmentQuizDto> quizzes = new ArrayList<>();

    public DepartmentSummaryDto() {}

    public DepartmentSummaryDto(String departmentName) {
        this.departmentName = departmentName;
    }

    public String getDepartmentName() {
        return departmentName;
    }

    public void setDepartmentName(String departmentName) {
        this.departmentName = departmentName;
    }

    public int getTeacherCount() {
        return teacherCount;
    }

    public void setTeacherCount(int teacherCount) {
        this.teacherCount = teacherCount;
    }

    public int getStudentCount() {
        return studentCount;
    }

    public void setStudentCount(int studentCount) {
        this.studentCount = studentCount;
    }

    public int getQuizCount() {
        return quizCount;
    }

    public void setQuizCount(int quizCount) {
        this.quizCount = quizCount;
    }

    public double getAverageScore() {
        return averageScore;
    }

    public void setAverageScore(double averageScore) {
        this.averageScore = averageScore;
    }

    public List<DepartmentTeacherDto> getTeachers() {
        return teachers;
    }

    public void setTeachers(List<DepartmentTeacherDto> teachers) {
        this.teachers = teachers;
    }

    public List<DepartmentTopStudentDto> getTopStudents() {
        return topStudents;
    }

    public void setTopStudents(List<DepartmentTopStudentDto> topStudents) {
        this.topStudents = topStudents;
    }

    public List<DepartmentQuizDto> getQuizzes() {
        return quizzes;
    }

    public void setQuizzes(List<DepartmentQuizDto> quizzes) {
        this.quizzes = quizzes;
    }

    /**
     * Teacher faculty member in this department.
     */
    public static class DepartmentTeacherDto implements Serializable {
        private static final long serialVersionUID = 1L;

        private int userId;
        private String fullName;
        private String email;
        private String identifier;
        private String status;
        private int quizCount;

        public DepartmentTeacherDto() {}

        public DepartmentTeacherDto(int userId, String fullName, String email, String identifier, String status, int quizCount) {
            this.userId = userId;
            this.fullName = fullName;
            this.email = email;
            this.identifier = identifier;
            this.status = status;
            this.quizCount = quizCount;
        }

        public int getUserId() { return userId; }
        public void setUserId(int userId) { this.userId = userId; }

        public String getFullName() { return fullName; }
        public void setFullName(String fullName) { this.fullName = fullName; }

        public String getEmail() { return email; }
        public void setEmail(String email) { this.email = email; }

        public String getIdentifier() { return identifier; }
        public void setIdentifier(String identifier) { this.identifier = identifier; }

        public String getStatus() { return status; }
        public void setStatus(String status) { this.status = status; }

        public int getQuizCount() { return quizCount; }
        public void setQuizCount(int quizCount) { this.quizCount = quizCount; }
    }

    /**
     * Top-ranking student enrolled in this department.
     */
    public static class DepartmentTopStudentDto implements Serializable {
        private static final long serialVersionUID = 1L;

        private int studentId;
        private String fullName;
        private String identifier;
        private String cohort;
        private int attemptsCount;
        private double averagePercentage;
        private double highestPercentage;
        private double totalScore;
        private int rank;

        public DepartmentTopStudentDto() {}

        public int getStudentId() { return studentId; }
        public void setStudentId(int studentId) { this.studentId = studentId; }

        public String getFullName() { return fullName; }
        public void setFullName(String fullName) { this.fullName = fullName; }

        public String getIdentifier() { return identifier; }
        public void setIdentifier(String identifier) { this.identifier = identifier; }

        public String getCohort() { return cohort; }
        public void setCohort(String cohort) { this.cohort = cohort; }

        public int getAttemptsCount() { return attemptsCount; }
        public void setAttemptsCount(int attemptsCount) { this.attemptsCount = attemptsCount; }

        public double getAveragePercentage() { return averagePercentage; }
        public void setAveragePercentage(double averagePercentage) { this.averagePercentage = averagePercentage; }

        public double getHighestPercentage() { return highestPercentage; }
        public void setHighestPercentage(double highestPercentage) { this.highestPercentage = highestPercentage; }

        public double getTotalScore() { return totalScore; }
        public void setTotalScore(double totalScore) { this.totalScore = totalScore; }

        public int getRank() { return rank; }
        public void setRank(int rank) { this.rank = rank; }
    }

    /**
     * Examination organized under this department.
     */
    public static class DepartmentQuizDto implements Serializable {
        private static final long serialVersionUID = 1L;

        private int quizId;
        private String title;
        private String teacherName;
        private String status;
        private double totalMarks;
        private int questionCount;
        private int attemptsCount;

        public DepartmentQuizDto() {}

        public int getQuizId() { return quizId; }
        public void setQuizId(int quizId) { this.quizId = quizId; }

        public String getTitle() { return title; }
        public void setTitle(String title) { this.title = title; }

        public String getTeacherName() { return teacherName; }
        public void setTeacherName(String teacherName) { this.teacherName = teacherName; }

        public String getStatus() { return status; }
        public void setStatus(String status) { this.status = status; }

        public double getTotalMarks() { return totalMarks; }
        public void setTotalMarks(double totalMarks) { this.totalMarks = totalMarks; }

        public int getQuestionCount() { return questionCount; }
        public void setQuestionCount(int questionCount) { this.questionCount = questionCount; }

        public int getAttemptsCount() { return attemptsCount; }
        public void setAttemptsCount(int attemptsCount) { this.attemptsCount = attemptsCount; }
    }
}
