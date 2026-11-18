package com.quiztrack.model;

import java.io.Serializable;
import java.math.BigDecimal;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

/**
 * Model representing an assessment Question in QuizTrack.
 * Can belong to a specific Quiz or exist standalone in the Departmental Question Bank.
 */
public class Question implements Serializable {
    private static final long serialVersionUID = 1L;

    private int questionId;
    private Integer quizId; // NULL if standalone Question Bank item
    private int subjectId;
    private String subjectCode; // Joined
    private String subjectName; // Joined
    private String questionText;
    private String questionType; // 'SINGLE_CHOICE', 'MULTI_CHOICE', 'TRUE_FALSE'
    private BigDecimal points;
    private BigDecimal negativeMarks = BigDecimal.ZERO;
    private String difficultyLevel; // 'EASY', 'MEDIUM', 'HARD'
    private String taxonomyTopic;
    private String explanation;
    private String codeSnippet;
    private Integer createdBy;
    private String createdByName; // Joined
    private Timestamp createdAt;

    // Associated Answer Options
    private List<QuestionOption> options = new ArrayList<>();
    private boolean inCurrentQuiz;

    public Question() {
        this.questionType = "SINGLE_CHOICE";
        this.points = new BigDecimal("4.00");
        this.difficultyLevel = "MEDIUM";
    }

    public int getQuestionId() {
        return questionId;
    }

    public void setQuestionId(int questionId) {
        this.questionId = questionId;
    }

    public Integer getQuizId() {
        return quizId;
    }

    public void setQuizId(Integer quizId) {
        this.quizId = quizId;
    }

    public int getSubjectId() {
        return subjectId;
    }

    public void setSubjectId(int subjectId) {
        this.subjectId = subjectId;
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

    public String getDifficultyLevel() {
        return difficultyLevel;
    }

    public void setDifficultyLevel(String difficultyLevel) {
        this.difficultyLevel = difficultyLevel;
    }

    public String getTaxonomyTopic() {
        return taxonomyTopic;
    }

    public void setTaxonomyTopic(String taxonomyTopic) {
        this.taxonomyTopic = taxonomyTopic;
    }

    public String getExplanation() {
        return explanation;
    }

    public void setExplanation(String explanation) {
        this.explanation = explanation;
    }

    public String getCodeSnippet() {
        return codeSnippet;
    }

    public void setCodeSnippet(String codeSnippet) {
        this.codeSnippet = codeSnippet;
    }

    public Integer getCreatedBy() {
        return createdBy;
    }

    public void setCreatedBy(Integer createdBy) {
        this.createdBy = createdBy;
    }

    public String getCreatedByName() {
        return createdByName;
    }

    public void setCreatedByName(String createdByName) {
        this.createdByName = createdByName;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public List<QuestionOption> getOptions() {
        return options;
    }

    public void setOptions(List<QuestionOption> options) {
        this.options = options;
    }

    public void addOption(QuestionOption option) {
        this.options.add(option);
    }

    public QuestionOption getCorrectOption() {
        for (QuestionOption opt : options) {
            if (opt.isCorrect()) {
                return opt;
            }
        }
        return null;
    }

    public String getCorrectOptionLetter() {
        QuestionOption opt = getCorrectOption();
        return opt != null ? opt.getOptionLetter() : "";
    }

    public boolean isInCurrentQuiz() {
        return inCurrentQuiz;
    }

    public boolean getInCurrentQuiz() {
        return inCurrentQuiz;
    }

    public boolean isCurrentQuiz() {
        return inCurrentQuiz;
    }

    public boolean getCurrentQuiz() {
        return inCurrentQuiz;
    }

    public void setInCurrentQuiz(boolean inCurrentQuiz) {
        this.inCurrentQuiz = inCurrentQuiz;
    }
}
