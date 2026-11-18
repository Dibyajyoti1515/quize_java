package com.quiztrack.model;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

/**
 * Data Transfer Object representing detailed post-submission review of an individual question.
 * Displays student selection alongside verified answer key and pedagogical rationale.
 */
public class QuestionReviewDto implements Serializable {
    private static final long serialVersionUID = 1L;

    private int questionId;
    private int questionNumber;
    private String questionText;
    private String codeSnippet;
    private String taxonomyTopic;
    private BigDecimal points;
    private BigDecimal marksAwarded;
    private String status; // 'CORRECT', 'INCORRECT', 'UNANSWERED'
    private Integer selectedOptionId;
    private String selectedOptionLetter;
    private String selectedOptionText;
    private Integer correctOptionId;
    private String correctOptionLetter;
    private String correctOptionText;
    private String explanation;

    private List<ReviewOption> options = new ArrayList<>();

    public static class ReviewOption implements Serializable {
        private static final long serialVersionUID = 1L;
        private int optionId;
        private String optionLetter;
        private String optionText;
        private boolean isSelected;
        private boolean isCorrect;

        public ReviewOption() {}

        public ReviewOption(int optionId, String optionLetter, String optionText, boolean isSelected, boolean isCorrect) {
            this.optionId = optionId;
            this.optionLetter = optionLetter;
            this.optionText = optionText;
            this.isSelected = isSelected;
            this.isCorrect = isCorrect;
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

        public boolean isSelected() {
            return isSelected;
        }

        public boolean getIsSelected() {
            return isSelected;
        }

        public void setSelected(boolean selected) {
            isSelected = selected;
        }

        public boolean isCorrect() {
            return isCorrect;
        }

        public boolean getIsCorrect() {
            return isCorrect;
        }

        public void setCorrect(boolean correct) {
            isCorrect = correct;
        }
    }

    public QuestionReviewDto() {}

    public int getQuestionId() {
        return questionId;
    }

    public void setQuestionId(int questionId) {
        this.questionId = questionId;
    }

    public int getQuestionNumber() {
        return questionNumber;
    }

    public void setQuestionNumber(int questionNumber) {
        this.questionNumber = questionNumber;
    }

    public String getQuestionText() {
        return questionText;
    }

    public void setQuestionText(String questionText) {
        this.questionText = questionText;
    }

    public String getCodeSnippet() {
        return codeSnippet;
    }

    public void setCodeSnippet(String codeSnippet) {
        this.codeSnippet = codeSnippet;
    }

    public String getTaxonomyTopic() {
        return taxonomyTopic;
    }

    public String getTopicName() {
        return taxonomyTopic;
    }

    public void setTaxonomyTopic(String taxonomyTopic) {
        this.taxonomyTopic = taxonomyTopic;
    }

    public boolean isCorrect() {
        return "CORRECT".equalsIgnoreCase(status);
    }

    public BigDecimal getPoints() {
        return points;
    }

    public void setPoints(BigDecimal points) {
        this.points = points;
    }

    public BigDecimal getMarksAwarded() {
        return marksAwarded;
    }

    public void setMarksAwarded(BigDecimal marksAwarded) {
        this.marksAwarded = marksAwarded;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
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

    public String getSelectedOptionText() {
        return selectedOptionText;
    }

    public void setSelectedOptionText(String selectedOptionText) {
        this.selectedOptionText = selectedOptionText;
    }

    public Integer getCorrectOptionId() {
        return correctOptionId;
    }

    public void setCorrectOptionId(Integer correctOptionId) {
        this.correctOptionId = correctOptionId;
    }

    public String getCorrectOptionLetter() {
        return correctOptionLetter;
    }

    public void setCorrectOptionLetter(String correctOptionLetter) {
        this.correctOptionLetter = correctOptionLetter;
    }

    public String getCorrectOptionText() {
        return correctOptionText;
    }

    public void setCorrectOptionText(String correctOptionText) {
        this.correctOptionText = correctOptionText;
    }

    public String getExplanation() {
        return explanation;
    }

    public void setExplanation(String explanation) {
        this.explanation = explanation;
    }

    public List<ReviewOption> getOptions() {
        return options;
    }

    public void setOptions(List<ReviewOption> options) {
        this.options = options;
    }
}
