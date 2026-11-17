package com.quiztrack.model;

import java.io.Serializable;
import java.math.BigDecimal;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

/**
 * Aggregated Data Transfer Object representing the complete Examination Results & Performance Analytics report.
 * Directly maps to Stitch 'student_exam_results_performance_analytics'.
 */
public class StudentResultDto implements Serializable {
    private static final long serialVersionUID = 1L;

    // Metadata
    private int resultId;
    private int attemptId;
    private int quizId;
    private int studentId;
    private String studentName;
    private String studentIdentifier;
    private String quizTitle;
    private String quizDescription;
    private String subjectCode;
    private String subjectName;
    private String teacherName;
    private Timestamp startTime;
    private Timestamp endTime;
    private int durationMinutes;
    private String timeSpentFormatted;

    // Scoring & Standing
    private BigDecimal score;
    private BigDecimal maxScore;
    private BigDecimal percentage;
    private String grade;
    private boolean passed;
    private String markingSchemeFormatted;
    private int cohortRank;
    private int cohortTotalStudents;
    private double cohortPercentile;
    private double cohortAveragePercentage;
    private String certificateHash;
    private Timestamp certifiedAt;

    // Question Statistics
    private int totalQuestions;
    private int answeredCount;
    private int correctCount;
    private int incorrectCount;
    private int unansweredCount;
    private double accuracyPercentage;

    // Proctor Audit Standing
    private BigDecimal integrityIndex;
    private int tabSwitchCount;
    private int blurCount;
    private int fullscreenExitCount;
    private String proctorStatusText;

    // Detailed Analytics Lists
    private List<TopicPerformanceDto> topicBreakdowns = new ArrayList<>();
    private List<QuestionReviewDto> questionReviews = new ArrayList<>();
    private List<HistoryQuizDto> historicalQuizzes = new ArrayList<>();
    private List<String> strongTopics = new ArrayList<>();
    private List<String> weakTopics = new ArrayList<>();

    public StudentResultDto() {
        this.score = BigDecimal.ZERO;
        this.maxScore = BigDecimal.ZERO;
        this.percentage = BigDecimal.ZERO;
        this.integrityIndex = new BigDecimal("100.00");
    }

    // Getters and Setters
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

    public int getQuizId() {
        return quizId;
    }

    public void setQuizId(int quizId) {
        this.quizId = quizId;
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

    public String getQuizDescription() {
        return quizDescription;
    }

    public void setQuizDescription(String quizDescription) {
        this.quizDescription = quizDescription;
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

    public String getTeacherName() {
        return teacherName;
    }

    public void setTeacherName(String teacherName) {
        this.teacherName = teacherName;
    }

    public Timestamp getStartTime() {
        return startTime;
    }

    public void setStartTime(Timestamp startTime) {
        this.startTime = startTime;
    }

    public Timestamp getEndTime() {
        return endTime;
    }

    public void setEndTime(Timestamp endTime) {
        this.endTime = endTime;
    }

    public int getDurationMinutes() {
        return durationMinutes;
    }

    public void setDurationMinutes(int durationMinutes) {
        this.durationMinutes = durationMinutes;
    }

    public String getTimeSpentFormatted() {
        return timeSpentFormatted;
    }

    public void setTimeSpentFormatted(String timeSpentFormatted) {
        this.timeSpentFormatted = timeSpentFormatted;
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

    public String getMarkingSchemeFormatted() {
        return markingSchemeFormatted;
    }

    public void setMarkingSchemeFormatted(String markingSchemeFormatted) {
        this.markingSchemeFormatted = markingSchemeFormatted;
    }

    public int getCohortRank() {
        return cohortRank;
    }

    public void setCohortRank(int cohortRank) {
        this.cohortRank = cohortRank;
    }

    public int getCohortTotalStudents() {
        return cohortTotalStudents;
    }

    public void setCohortTotalStudents(int cohortTotalStudents) {
        this.cohortTotalStudents = cohortTotalStudents;
    }

    public double getCohortPercentile() {
        return cohortPercentile;
    }

    public void setCohortPercentile(double cohortPercentile) {
        this.cohortPercentile = cohortPercentile;
    }

    public double getCohortAveragePercentage() {
        return cohortAveragePercentage;
    }

    public void setCohortAveragePercentage(double cohortAveragePercentage) {
        this.cohortAveragePercentage = cohortAveragePercentage;
    }

    public String getCertificateHash() {
        return certificateHash;
    }

    public void setCertificateHash(String certificateHash) {
        this.certificateHash = certificateHash;
    }

    public Timestamp getCertifiedAt() {
        return certifiedAt;
    }

    public void setCertifiedAt(Timestamp certifiedAt) {
        this.certifiedAt = certifiedAt;
    }

    public int getTotalQuestions() {
        return totalQuestions;
    }

    public void setTotalQuestions(int totalQuestions) {
        this.totalQuestions = totalQuestions;
    }

    public int getAnsweredCount() {
        return answeredCount;
    }

    public void setAnsweredCount(int answeredCount) {
        this.answeredCount = answeredCount;
    }

    public int getCorrectCount() {
        return correctCount;
    }

    public void setCorrectCount(int correctCount) {
        this.correctCount = correctCount;
    }

    public int getIncorrectCount() {
        return incorrectCount;
    }

    public void setIncorrectCount(int incorrectCount) {
        this.incorrectCount = incorrectCount;
    }

    public int getUnansweredCount() {
        return unansweredCount;
    }

    public void setUnansweredCount(int unansweredCount) {
        this.unansweredCount = unansweredCount;
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

    public int getTabSwitchCount() {
        return tabSwitchCount;
    }

    public void setTabSwitchCount(int tabSwitchCount) {
        this.tabSwitchCount = tabSwitchCount;
    }

    public int getBlurCount() {
        return blurCount;
    }

    public void setBlurCount(int blurCount) {
        this.blurCount = blurCount;
    }

    public int getFullscreenExitCount() {
        return fullscreenExitCount;
    }

    public void setFullscreenExitCount(int fullscreenExitCount) {
        this.fullscreenExitCount = fullscreenExitCount;
    }

    public String getProctorStatusText() {
        return proctorStatusText;
    }

    public void setProctorStatusText(String proctorStatusText) {
        this.proctorStatusText = proctorStatusText;
    }

    public List<TopicPerformanceDto> getTopicBreakdowns() {
        return topicBreakdowns;
    }

    public void setTopicBreakdowns(List<TopicPerformanceDto> topicBreakdowns) {
        this.topicBreakdowns = topicBreakdowns;
    }

    public List<QuestionReviewDto> getQuestionReviews() {
        return questionReviews;
    }

    public void setQuestionReviews(List<QuestionReviewDto> questionReviews) {
        this.questionReviews = questionReviews;
    }

    public List<HistoryQuizDto> getHistoricalQuizzes() {
        return historicalQuizzes;
    }

    public void setHistoricalQuizzes(List<HistoryQuizDto> historicalQuizzes) {
        this.historicalQuizzes = historicalQuizzes;
    }

    public List<String> getStrongTopics() {
        return strongTopics;
    }

    public void setStrongTopics(List<String> strongTopics) {
        this.strongTopics = strongTopics;
    }

    public List<String> getWeakTopics() {
        return weakTopics;
    }

    public void setWeakTopics(List<String> weakTopics) {
        this.weakTopics = weakTopics;
    }
}
