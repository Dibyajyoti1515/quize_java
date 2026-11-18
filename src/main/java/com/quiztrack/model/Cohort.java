package com.quiztrack.model;

import java.io.Serializable;
import java.sql.Timestamp;

/**
 * Model representing an academic Cohort / Class Section in QuizTrack.
 */
public class Cohort implements Serializable {
    private static final long serialVersionUID = 1L;

    private int cohortId;
    private String cohortName;
    private String department;
    private String academicYear;
    private Timestamp createdAt;
    private int studentCount;

    public Cohort() {}

    public Cohort(int cohortId, String cohortName, String department, String academicYear) {
        this.cohortId = cohortId;
        this.cohortName = cohortName;
        this.department = department;
        this.academicYear = academicYear;
    }

    public int getCohortId() {
        return cohortId;
    }

    public void setCohortId(int cohortId) {
        this.cohortId = cohortId;
    }

    public String getCohortName() {
        return cohortName;
    }

    public String getCohortCode() {
        return cohortName;
    }

    public void setCohortName(String cohortName) {
        this.cohortName = cohortName;
    }

    public String getDepartment() {
        return department;
    }

    public void setDepartment(String department) {
        this.department = department;
    }

    public String getAcademicYear() {
        return academicYear;
    }

    public void setAcademicYear(String academicYear) {
        this.academicYear = academicYear;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public int getStudentCount() {
        return studentCount;
    }

    public void setStudentCount(int studentCount) {
        this.studentCount = studentCount;
    }
}
