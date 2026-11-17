package com.quiztrack.model;

import java.io.Serializable;
import java.math.BigDecimal;
import java.sql.Timestamp;

/**
 * Data Transfer Object representing an academic certificate issued for quiz achievement.
 */
public class CertificateDto implements Serializable {
    private static final long serialVersionUID = 1L;

    private int resultId;
    private int attemptId;
    private int studentId;
    private int quizId;
    private String certificateId;
    private String certificateHash;
    private String studentName;
    private String studentIdentifier;
    private String quizTitle;
    private String subjectCode;
    private String subjectName;
    private BigDecimal score;
    private BigDecimal maxScore;
    private BigDecimal percentage;
    private String grade;
    private boolean passed;
    private int rank;
    private double percentile;
    private BigDecimal integrityIndex;
    private String proctorStatus;
    private Timestamp certifiedAt;
    private String status; // VALID, REVOKED, INVALID, NOT_FOUND
    private String leadInstructor;
    private String academicDean;
    private String verificationUrl;

    public CertificateDto() {
        this.status = "NOT_FOUND";
        this.score = BigDecimal.ZERO;
        this.maxScore = BigDecimal.ZERO;
        this.percentage = BigDecimal.ZERO;
        this.integrityIndex = new BigDecimal("100.00");
    }

    public int getResultId() {
        return resultId;
    }

    public void setResultId(int resultId) {
        this.resultId = resultId;
    }

    public int getAttemptId() {
        return attemptId;
    }

    public void setAttemptId(int attemptId) {
        this.attemptId = attemptId;
    }

    public int getStudentId() {
        return studentId;
    }

    public void setStudentId(int studentId) {
        this.studentId = studentId;
    }

    public int getQuizId() {
        return quizId;
    }

    public void setQuizId(int quizId) {
        this.quizId = quizId;
    }

    public String getCertificateId() {
        return certificateId;
    }

    public void setCertificateId(String certificateId) {
        this.certificateId = certificateId;
    }

    public String getCertificateHash() {
        return certificateHash;
    }

    public void setCertificateHash(String certificateHash) {
        this.certificateHash = certificateHash;
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

    public int getRank() {
        return rank;
    }

    public void setRank(int rank) {
        this.rank = rank;
    }

    public double getPercentile() {
        return percentile;
    }

    public void setPercentile(double percentile) {
        this.percentile = percentile;
    }

    public BigDecimal getIntegrityIndex() {
        return integrityIndex;
    }

    public void setIntegrityIndex(BigDecimal integrityIndex) {
        this.integrityIndex = integrityIndex;
    }

    public String getProctorStatus() {
        return proctorStatus;
    }

    public void setProctorStatus(String proctorStatus) {
        this.proctorStatus = proctorStatus;
    }

    public Timestamp getCertifiedAt() {
        return certifiedAt;
    }

    public void setCertifiedAt(Timestamp certifiedAt) {
        this.certifiedAt = certifiedAt;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getLeadInstructor() {
        return leadInstructor;
    }

    public void setLeadInstructor(String leadInstructor) {
        this.leadInstructor = leadInstructor;
    }

    public String getAcademicDean() {
        return academicDean;
    }

    public void setAcademicDean(String academicDean) {
        this.academicDean = academicDean;
    }

    public String getVerificationUrl() {
        return verificationUrl;
    }

    public void setVerificationUrl(String verificationUrl) {
        this.verificationUrl = verificationUrl;
    }
}
