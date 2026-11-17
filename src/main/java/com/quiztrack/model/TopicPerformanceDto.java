package com.quiztrack.model;

import java.io.Serializable;

/**
 * Data Transfer Object representing performance breakdown across a specific concept taxonomy / topic.
 */
public class TopicPerformanceDto implements Serializable {
    private static final long serialVersionUID = 1L;

    private String topicName;
    private int totalQuestions;
    private int correctCount;
    private int incorrectCount;
    private int unansweredCount;
    private double masteryPercentage;
    private String status; // 'Strong Mastery', 'Proficient', 'Needs Review'

    public TopicPerformanceDto() {}

    public TopicPerformanceDto(String topicName, int totalQuestions, int correctCount, int incorrectCount, int unansweredCount, double masteryPercentage, String status) {
        this.topicName = topicName;
        this.totalQuestions = totalQuestions;
        this.correctCount = correctCount;
        this.incorrectCount = incorrectCount;
        this.unansweredCount = unansweredCount;
        this.masteryPercentage = masteryPercentage;
        this.status = status;
    }

    public String getTopicName() {
        return topicName;
    }

    public void setTopicName(String topicName) {
        this.topicName = topicName;
    }

    public int getTotalQuestions() {
        return totalQuestions;
    }

    public void setTotalQuestions(int totalQuestions) {
        this.totalQuestions = totalQuestions;
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

    public double getMasteryPercentage() {
        return masteryPercentage;
    }

    public void setMasteryPercentage(double masteryPercentage) {
        this.masteryPercentage = masteryPercentage;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }
}
