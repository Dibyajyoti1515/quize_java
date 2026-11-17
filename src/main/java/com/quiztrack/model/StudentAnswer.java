package com.quiztrack.model;

import java.io.Serializable;
import java.math.BigDecimal;
import java.sql.Timestamp;

/**
 * Model representing an autosaved response for an individual question within an attempt.
 */
public class StudentAnswer implements Serializable {
    private static final long serialVersionUID = 1L;

    private int answerId;
    private int attemptId;
    private int questionId;
    private Integer selectedOptionId;
    private String selectedOptionLetter;
    private String textResponse;
    private boolean isFlaggedForReview;
    private Boolean isCorrect;
    private BigDecimal marksAwarded;
    private Timestamp answeredAt;
    private Timestamp lastUpdatedAt;

    public StudentAnswer() {
        this.isFlaggedForReview = false;
        this.marksAwarded = BigDecimal.ZERO;
    }

    public StudentAnswer(int attemptId, int questionId, Integer selectedOptionId, boolean isFlaggedForReview) {
        this.attemptId = attemptId;
        this.questionId = questionId;
        this.selectedOptionId = selectedOptionId;
        this.isFlaggedForReview = isFlaggedForReview;
        this.marksAwarded = BigDecimal.ZERO;
    }

    public int getAnswerId() {
        return answerId;
    }

    public void setAnswerId(int answerId) {
        this.answerId = answerId;
    }

    public int getAttemptId() {
        return attemptId;
    }

    public void setAttemptId(int attemptId) {
        this.attemptId = attemptId;
    }

    public int getQuestionId() {
        return questionId;
    }

    public void setQuestionId(int questionId) {
        this.questionId = questionId;
    }

    public Integer getSelectedOptionId() {
        return selectedOptionId;
    }

    public void setSelectedOptionId(Integer selectedOptionId) {
        this.selectedOptionId = selectedOptionId;
    }

    public String getSelectedOptionLetter() {
        return selectedOptionLetter;
    }

    public void setSelectedOptionLetter(String selectedOptionLetter) {
        this.selectedOptionLetter = selectedOptionLetter;
    }

    public String getTextResponse() {
        return textResponse;
    }

    public void setTextResponse(String textResponse) {
        this.textResponse = textResponse;
    }

    public boolean isFlaggedForReview() {
        return isFlaggedForReview;
    }

    public void setFlaggedForReview(boolean flaggedForReview) {
        isFlaggedForReview = flaggedForReview;
    }

    public Boolean getIsCorrect() {
        return isCorrect;
    }

    public void setIsCorrect(Boolean isCorrect) {
        this.isCorrect = isCorrect;
    }

    public BigDecimal getMarksAwarded() {
        return marksAwarded;
    }

    public void setMarksAwarded(BigDecimal marksAwarded) {
        this.marksAwarded = marksAwarded;
    }

    public Timestamp getAnsweredAt() {
        return answeredAt;
    }

    public void setAnsweredAt(Timestamp answeredAt) {
        this.answeredAt = answeredAt;
    }

    public Timestamp getLastUpdatedAt() {
        return lastUpdatedAt;
    }

    public void setLastUpdatedAt(Timestamp lastUpdatedAt) {
        this.lastUpdatedAt = lastUpdatedAt;
    }
}
