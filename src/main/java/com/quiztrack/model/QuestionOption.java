package com.quiztrack.model;

import java.io.Serializable;

/**
 * Model representing an option/choice for a question.
 */
public class QuestionOption implements Serializable {
    private static final long serialVersionUID = 1L;

    private int optionId;
    private int questionId;
    private String optionLetter; // 'A', 'B', 'C', 'D', etc.
    private String optionText;
    private boolean isCorrect;
    private int sortOrder;

    public QuestionOption() {
        this.sortOrder = 1;
        this.isCorrect = false;
    }

    public QuestionOption(String optionLetter, String optionText, boolean isCorrect, int sortOrder) {
        this.optionLetter = optionLetter;
        this.optionText = optionText;
        this.isCorrect = isCorrect;
        this.sortOrder = sortOrder;
    }

    public int getOptionId() {
        return optionId;
    }

    public void setOptionId(int optionId) {
        this.optionId = optionId;
    }

    public int getQuestionId() {
        return questionId;
    }

    public void setQuestionId(int questionId) {
        this.questionId = questionId;
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

    public boolean isCorrect() {
        return isCorrect;
    }

    public boolean getIsCorrect() {
        return isCorrect;
    }

    public void setCorrect(boolean isCorrect) {
        this.isCorrect = isCorrect;
    }

    public int getSortOrder() {
        return sortOrder;
    }

    public void setSortOrder(int sortOrder) {
        this.sortOrder = sortOrder;
    }
}
