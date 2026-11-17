package com.quiztrack.model;

import java.io.Serializable;
import java.math.BigDecimal;
import java.sql.Timestamp;

/**
 * Data Transfer Object representing an individual student's standing on the cohort leaderboard.
 * Incorporates academic marks, competitive ranking, proctor integrity, and verified credential status.
 */
public class LeaderboardEntryDto implements Serializable {
    private static final long serialVersionUID = 1L;

    private int rank;
    private int studentId;
    private String studentName;
    private String studentIdentifier; // e.g. CS-2022-041
    private String avatarInitials;
    private String department;
    private String cohort;
    private int quizId;
    private String quizTitle;
    private String subjectCode;
    private String subjectName;
    private BigDecimal score;
    private BigDecimal maxScore;
    private BigDecimal percentage;
    private String grade;
    private boolean passed;
    private double percentile;
    private int durationMinutes;
    private String durationFormatted; // e.g. "42m 10s"
    private int correctCount;
    private int totalQuestions;
    private double accuracyPercentage;
    private BigDecimal integrityIndex;
    private String integrityStatus; // "Proctored & Cleared", "Flagged"
    private String domainStrength; // e.g. "Consensus Protocols"
    private String certificateHash;
    private String certificateId; // e.g. "QT-CERT-2025-CS402-0841X"
    private Timestamp certifiedAt;
    private boolean isCurrentUser;
    private boolean isCertificateEligible;
    private boolean isTied;

    public LeaderboardEntryDto() {
        this.score = BigDecimal.ZERO;
        this.maxScore = BigDecimal.ZERO;
        this.percentage = BigDecimal.ZERO;
        this.integrityIndex = new BigDecimal("100.00");
    }

    public int getRank() {
        return rank;
    }

    public void setRank(int rank) {
        this.rank = rank;
    }

    public int getStudentId() {
        return studentId;
    }

    public void setStudentId(int studentId) {
        this.studentId = studentId;
    }

    public String getStudentName() {
        return studentName;
    }

    public void setStudentName(String studentName) {
        this.studentName = studentName;
        if (studentName != null && !studentName.isBlank()) {
            String[] parts = studentName.trim().split("\\s+");
            if (parts.length >= 2) {
                this.avatarInitials = ("" + parts[0].charAt(0) + parts[parts.length - 1].charAt(0)).toUpperCase();
            } else if (parts.length == 1 && !parts[0].isEmpty()) {
                this.avatarInitials = parts[0].substring(0, Math.min(2, parts[0].length())).toUpperCase();
            }
        }
    }

    public String getStudentIdentifier() {
        return studentIdentifier;
    }

    public void setStudentIdentifier(String studentIdentifier) {
        this.studentIdentifier = studentIdentifier;
    }

    public String getAvatarInitials() {
        return avatarInitials != null ? avatarInitials : "ST";
    }

    public void setAvatarInitials(String avatarInitials) {
        this.avatarInitials = avatarInitials;
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

    public BigDecimal getScore() {
        return score;
    }

    public void setScore(BigDecimal score) {
        this.score = score;
    }

    public BigDecimal getMaxScore() {
        return maxScore;
    }

    public void setMaxScore(BigDecimal maxScore) {
        this.maxScore = maxScore;
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

    public double getPercentile() {
        return percentile;
    }

    public void setPercentile(double percentile) {
        this.percentile = percentile;
    }

    public int getDurationMinutes() {
        return durationMinutes;
    }

    public void setDurationMinutes(int durationMinutes) {
        this.durationMinutes = durationMinutes;
    }

    public String getDurationFormatted() {
        return durationFormatted;
    }

    public void setDurationFormatted(String durationFormatted) {
        this.durationFormatted = durationFormatted;
    }

    public int getCorrectCount() {
        return correctCount;
    }

    public void setCorrectCount(int correctCount) {
        this.correctCount = correctCount;
    }

    public int getTotalQuestions() {
        return totalQuestions;
    }

    public void setTotalQuestions(int totalQuestions) {
        this.totalQuestions = totalQuestions;
    }

    public double getAccuracyPercentage() {
        return accuracyPercentage;
    }

    public void setAccuracyPercentage(double accuracyPercentage) {
        this.accuracyPercentage = accuracyPercentage;
    }

    public BigDecimal getIntegrityIndex() {
        return integrityIndex;
    }

    public void setIntegrityIndex(BigDecimal integrityIndex) {
        this.integrityIndex = integrityIndex;
    }

    public String getIntegrityStatus() {
        return integrityStatus;
    }

    public void setIntegrityStatus(String integrityStatus) {
        this.integrityStatus = integrityStatus;
    }

    public String getDomainStrength() {
        return domainStrength;
    }

    public void setDomainStrength(String domainStrength) {
        this.domainStrength = domainStrength;
    }

    public String getCertificateHash() {
        return certificateHash;
    }

    public void setCertificateHash(String certificateHash) {
        this.certificateHash = certificateHash;
    }

    public String getCertificateId() {
        return certificateId;
    }

    public void setCertificateId(String certificateId) {
        this.certificateId = certificateId;
    }

    public Timestamp getCertifiedAt() {
        return certifiedAt;
    }

    public void setCertifiedAt(Timestamp certifiedAt) {
        this.certifiedAt = certifiedAt;
    }

    public boolean isCurrentUser() {
        return isCurrentUser;
    }

    public void setCurrentUser(boolean currentUser) {
        isCurrentUser = currentUser;
    }

    public boolean isCertificateEligible() {
        return isCertificateEligible;
    }

    public void setCertificateEligible(boolean certificateEligible) {
        isCertificateEligible = certificateEligible;
    }

    public boolean isTied() {
        return isTied;
    }

    public void setTied(boolean tied) {
        isTied = tied;
    }
}
