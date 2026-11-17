package com.quiztrack.model;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

/**
 * Data Transfer Object representing a Question presented to a candidate during an examination session.
 * Excludes answers and pedagogical rationale.
 */
public class ExamQuestionDto implements Serializable {
    private static final long serialVersionUID = 1L;

    private int questionId;
    private int questionNumber; // 1-based index (1, 2, 3...)
    private String questionText;
    private String questionType; // 'SINGLE_CHOICE', 'MULTI_CHOICE', 'TRUE_FALSE'
    private BigDecimal points;
    private BigDecimal negativeMarks;
    private String taxonomyTopic;
    private String codeSnippet;

    private List<ExamOptionDto> options = new ArrayList<>();

    // Student Attempt State for this question
    private Integer selectedOptionId;
    private boolean flaggedForReview;
    private String status; // 'ANSWERED', 'REVIEW', 'NOT_ANSWERED', 'NOT_VISITED'

    public ExamQuestionDto() {
        this.status = "NOT_VISITED";
        this.flaggedForReview = false;
    }

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

    public String getQuestionType() {
        return questionType;
    }

    public void setQuestionType(String questionType) {
        this.questionType = questionType;
    }

    public BigDecimal getPoints() {
        return points;
    }

    public void setPoints(BigDecimal points) {
        this.points = points;
    }

    public BigDecimal getNegativeMarks() {
        return negativeMarks;
    }

    public void setNegativeMarks(BigDecimal negativeMarks) {
        this.negativeMarks = negativeMarks;
    }

    public String getTaxonomyTopic() {
        return taxonomyTopic;
    }

    public void setTaxonomyTopic(String taxonomyTopic) {
        this.taxonomyTopic = taxonomyTopic;
    }

    public String getCodeSnippet() {
        return codeSnippet;
    }

    public void setCodeSnippet(String codeSnippet) {
        this.codeSnippet = codeSnippet;
    }

    public List<ExamOptionDto> getOptions() {
        return options;
    }

    public void setOptions(List<ExamOptionDto> options) {
        this.options = options;
    }

    public Integer getSelectedOptionId() {
        return selectedOptionId;
    }

    public void setSelectedOptionId(Integer selectedOptionId) {
        this.selectedOptionId = selectedOptionId;
        updateStatus();
    }

    public boolean isFlaggedForReview() {
        return flaggedForReview;
    }

    public void setFlaggedForReview(boolean flaggedForReview) {
        this.flaggedForReview = flaggedForReview;
        updateStatus();
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public void updateStatus() {
        if (flaggedForReview) {
            this.status = "REVIEW";
        } else if (selectedOptionId != null && selectedOptionId > 0) {
            this.status = "ANSWERED";
        } else if ("NOT_VISITED".equalsIgnoreCase(this.status)) {
            // keep as is until visited
        } else {
            this.status = "NOT_ANSWERED";
        }
    }
}
