package com.quiztrack.model;

import java.io.Serializable;
import java.sql.Timestamp;

/**
 * Model representing a User account in QuizTrack.
 */
public class User implements Serializable {
    private static final long serialVersionUID = 1L;

    private int userId;
    private String identifier; // Roll Number or Faculty/Admin Identifier
    private String email;
    private String passwordHash;
    private String fullName;
    private int roleId;
    private String roleName;    // Joined from roles table
    private String department;
    private String cohort;      // e.g. 'Class of 2026', 'Faculty'
    private boolean biometricConsent;
    private String status;      // 'ACTIVE', 'SUSPENDED', 'PENDING'
    private Timestamp createdAt;
    private Timestamp updatedAt;

    public User() {}

    public User(String identifier, String email, String passwordHash, String fullName, int roleId, String department, String cohort) {
        this.identifier = identifier;
        this.email = email;
        this.passwordHash = passwordHash;
        this.fullName = fullName;
        this.roleId = roleId;
        this.department = department;
        this.cohort = cohort;
        this.status = "ACTIVE";
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getIdentifier() {
        return identifier;
    }

    public void setIdentifier(String identifier) {
        this.identifier = identifier;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPasswordHash() {
        return passwordHash;
    }

    public void setPasswordHash(String passwordHash) {
        this.passwordHash = passwordHash;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public int getRoleId() {
        return roleId;
    }

    public void setRoleId(int roleId) {
        this.roleId = roleId;
    }

    public String getRoleName() {
        return roleName;
    }

    public void setRoleName(String roleName) {
        this.roleName = roleName;
    }

    public String getDepartment() {
        return department;
    }

    public void setDepartment(String department) {
        this.department = department;
    }

    public String getCohort() {
        return cohort;
    }

    public void setCohort(String cohort) {
        this.cohort = cohort;
    }

    public boolean isBiometricConsent() {
        return biometricConsent;
    }

    public void setBiometricConsent(boolean biometricConsent) {
        this.biometricConsent = biometricConsent;
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

    public boolean isAdmin() {
        return Role.ROLE_ADMIN.equalsIgnoreCase(this.roleName);
    }

    public boolean isTeacher() {
        return Role.ROLE_TEACHER.equalsIgnoreCase(this.roleName);
    }

    public boolean isStudent() {
        return Role.ROLE_STUDENT.equalsIgnoreCase(this.roleName);
    }

    public boolean isActive() {
        return "ACTIVE".equalsIgnoreCase(this.status);
    }

    @Override
    public String toString() {
        return "User{" +
                "userId=" + userId +
                ", identifier='" + identifier + '\'' +
                ", email='" + email + '\'' +
                ", fullName='" + fullName + '\'' +
                ", roleName='" + roleName + '\'' +
                ", status='" + status + '\'' +
                '}';
    }
}
