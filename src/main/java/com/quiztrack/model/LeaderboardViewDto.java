package com.quiztrack.model;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

/**
 * Aggregated Data Transfer Object for rendering the cohort leaderboard and distribution analytics.
 */
public class LeaderboardViewDto implements Serializable {
    private static final long serialVersionUID = 1L;

    private int selectedQuizId;
    private Integer selectedSubjectId;
    private String selectedTimeFilter;

    private List<Quiz> availableQuizzes = new ArrayList<>();
    private List<Subject> availableSubjects = new ArrayList<>();

    private LeaderboardEntryDto currentUserEntry;
    private CertificateDto currentUserCertificate;

    private LeaderboardEntryDto podiumGold;
    private LeaderboardEntryDto podiumSilver;
    private LeaderboardEntryDto podiumBronze;

    private List<LeaderboardEntryDto> entries = new ArrayList<>();

    private int totalParticipants;
    private double classAveragePercentage;
    private BigDecimal topScore;
    private BigDecimal passingCutoff;
    private BigDecimal lowerQuartileScore;
    private BigDecimal medianScore;
    private BigDecimal upperQuartileScore;

    public LeaderboardViewDto() {
        this.selectedTimeFilter = "ALL";
        this.topScore = BigDecimal.ZERO;
        this.passingCutoff = new BigDecimal("50.00");
        this.lowerQuartileScore = BigDecimal.ZERO;
        this.medianScore = BigDecimal.ZERO;
        this.upperQuartileScore = BigDecimal.ZERO;
    }

    public int getSelectedQuizId() {
        return selectedQuizId;
    }

    public void setSelectedQuizId(int selectedQuizId) {
        this.selectedQuizId = selectedQuizId;
    }

    public Integer getSelectedSubjectId() {
        return selectedSubjectId;
    }

    public void setSelectedSubjectId(Integer selectedSubjectId) {
        this.selectedSubjectId = selectedSubjectId;
    }

    public String getSelectedTimeFilter() {
        return selectedTimeFilter;
    }

    public void setSelectedTimeFilter(String selectedTimeFilter) {
        this.selectedTimeFilter = selectedTimeFilter;
    }

    public List<Quiz> getAvailableQuizzes() {
        return availableQuizzes;
    }

    public void setAvailableQuizzes(List<Quiz> availableQuizzes) {
        this.availableQuizzes = availableQuizzes;
    }

    public List<Subject> getAvailableSubjects() {
        return availableSubjects;
    }

    public void setAvailableSubjects(List<Subject> availableSubjects) {
        this.availableSubjects = availableSubjects;
    }

    public LeaderboardEntryDto getCurrentUserEntry() {
        return currentUserEntry;
    }

    public void setCurrentUserEntry(LeaderboardEntryDto currentUserEntry) {
        this.currentUserEntry = currentUserEntry;
    }

    public CertificateDto getCurrentUserCertificate() {
        return currentUserCertificate;
    }

    public void setCurrentUserCertificate(CertificateDto currentUserCertificate) {
        this.currentUserCertificate = currentUserCertificate;
    }

    public LeaderboardEntryDto getPodiumGold() {
        return podiumGold;
    }

    public void setPodiumGold(LeaderboardEntryDto podiumGold) {
        this.podiumGold = podiumGold;
    }

    public LeaderboardEntryDto getPodiumSilver() {
        return podiumSilver;
    }

    public void setPodiumSilver(LeaderboardEntryDto podiumSilver) {
        this.podiumSilver = podiumSilver;
    }

    public LeaderboardEntryDto getPodiumBronze() {
        return podiumBronze;
    }

    public void setPodiumBronze(LeaderboardEntryDto podiumBronze) {
        this.podiumBronze = podiumBronze;
    }

    public List<LeaderboardEntryDto> getEntries() {
        return entries;
    }

    public void setEntries(List<LeaderboardEntryDto> entries) {
        this.entries = entries;
    }

    public int getTotalParticipants() {
        return totalParticipants;
    }

    public void setTotalParticipants(int totalParticipants) {
        this.totalParticipants = totalParticipants;
    }

    public double getClassAveragePercentage() {
        return classAveragePercentage;
    }

    public void setClassAveragePercentage(double classAveragePercentage) {
        this.classAveragePercentage = classAveragePercentage;
    }

    public BigDecimal getTopScore() {
        return topScore;
    }

    public void setTopScore(BigDecimal topScore) {
        this.topScore = topScore;
    }

    public BigDecimal getPassingCutoff() {
        return passingCutoff;
    }

    public void setPassingCutoff(BigDecimal passingCutoff) {
        this.passingCutoff = passingCutoff;
    }

    public BigDecimal getLowerQuartileScore() {
        return lowerQuartileScore;
    }

    public void setLowerQuartileScore(BigDecimal lowerQuartileScore) {
        this.lowerQuartileScore = lowerQuartileScore;
    }

    public BigDecimal getMedianScore() {
        return medianScore;
    }

    public void setMedianScore(BigDecimal medianScore) {
        this.medianScore = medianScore;
    }

    public BigDecimal getUpperQuartileScore() {
        return upperQuartileScore;
    }

    public void setUpperQuartileScore(BigDecimal upperQuartileScore) {
        this.upperQuartileScore = upperQuartileScore;
    }
}
