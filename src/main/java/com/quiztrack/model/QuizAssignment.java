package com.quiztrack.model;

import java.io.Serializable;
import java.sql.Timestamp;

/**
 * Model representing a Quiz Assignment to a Cohort or an individual Student.
 */
public class QuizAssignment implements Serializable {
    private static final long serialVersionUID = 1L;

    private int assignmentId;
    private int quizId;
    private Integer cohortId;
    private String cohortName;
    private Integer studentId;
    private String studentName;
    private String studentIdentifier;
    private Timestamp assignedAt;
    private Timestamp dueAt;
    private int enrolledStudentsCount;

    public QuizAssignment() {}

    public int getAssignmentId() {
        return assignmentId;
    }

    public void setAssignmentId(int assignmentId) {
        this.assignmentId = assignmentId;
    }

    public int getQuizId() {
        return quizId;
    }

    public void setQuizId(int quizId) {
        this.quizId = quizId;
    }

    public Integer getCohortId() {
        return cohortId;
    }

    public void setCohortId(Integer cohortId) {
        this.cohortId = cohortId;
    }

    public String getCohortName() {
        return cohortName;
    }

    public void setCohortName(String cohortName) {
        this.cohortName = cohortName;
    }

    public Integer getStudentId() {
        return studentId;
    }

    public void setStudentId(Integer studentId) {
        this.studentId = studentId;
    }

    public String getStudentName() {
        return studentName;
    }

    public void setStudentName(String studentName) {
        this.studentName = studentName;
    }

    public String getStudentIdentifier() {
        return studentIdentifier;
    }

    public void setStudentIdentifier(String studentIdentifier) {
        this.studentIdentifier = studentIdentifier;
    }

    public Timestamp getAssignedAt() {
        return assignedAt;
    }

    public void setAssignedAt(Timestamp assignedAt) {
        this.assignedAt = assignedAt;
    }

    public Timestamp getDueAt() {
        return dueAt;
    }

    public void setDueAt(Timestamp dueAt) {
        this.dueAt = dueAt;
    }

    public int getEnrolledStudentsCount() {
        return enrolledStudentsCount;
    }

    public void setEnrolledStudentsCount(int enrolledStudentsCount) {
        this.enrolledStudentsCount = enrolledStudentsCount;
    }

    public boolean isCohortAssignment() {
        return cohortId != null && cohortId > 0;
    }
}
