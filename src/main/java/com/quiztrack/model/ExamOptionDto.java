package com.quiztrack.model;

import java.io.Serializable;

/**
 * Data Transfer Object representing an option presented to a student during an active exam.
 * Deliberately omits the correctness flag to maintain absolute question integrity.
 */
public class ExamOptionDto implements Serializable {
    private static final long serialVersionUID = 1L;

    private int optionId;
    private String optionLetter; // 'A', 'B', 'C', 'D'
    private String optionText;
    private int sortOrder;

    public ExamOptionDto() {}

    public ExamOptionDto(int optionId, String optionLetter, String optionText, int sortOrder) {
        this.optionId = optionId;
        this.optionLetter = optionLetter;
        this.optionText = optionText;
        this.sortOrder = sortOrder;
    }

    public int getOptionId() {
        return optionId;
    }

    public void setOptionId(int optionId) {
        this.optionId = optionId;
    }

    public String getOptionLetter() {
        return optionLetter;
    }

    public void setOptionLetter(String optionLetter) {
        this.optionLetter = optionLetter;
    }

    public String getOptionText() {
        return optionText;
    }

    public void setOptionText(String optionText) {
        this.optionText = optionText;
    }

    public int getSortOrder() {
        return sortOrder;
    }

    public void setSortOrder(int sortOrder) {
        this.sortOrder = sortOrder;
    }
}
