package com.quiztrack.model;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

/**
 * Aggregated context container for an active Student Examination Interface session.
 * Exposes question palette, active question, countdown metrics, and progress.
 */
public class ExamSessionDto implements Serializable {
    private static final long serialVersionUID = 1L;

    private QuizAttempt attempt;
    private List<ExamQuestionDto> questions = new ArrayList<>();
    private int currentQuestionIndex; // 0-based
    private ExamQuestionDto currentQuestion;

    private int totalQuestions;
    private int answeredCount;
    private int flaggedCount;
    private int notAnsweredCount;
    private int notVisitedCount;

    private long remainingSeconds;
    private String formattedRemainingTime;
    private int progressPercentage;

    public ExamSessionDto() {}

    public void calculateMetrics(long serverNowMillis) {
        if (attempt != null) {
            this.remainingSeconds = attempt.getRemainingSeconds(serverNowMillis);
            this.formattedRemainingTime = attempt.getFormattedRemainingTime(serverNowMillis);
        }

        this.totalQuestions = questions.size();
        this.answeredCount = 0;
        this.flaggedCount = 0;
        this.notAnsweredCount = 0;
        this.notVisitedCount = 0;

        for (int i = 0; i < questions.size(); i++) {
            ExamQuestionDto q = questions.get(i);
            if (i == currentQuestionIndex && "NOT_VISITED".equalsIgnoreCase(q.getStatus())) {
                q.setStatus(q.getSelectedOptionId() != null ? "ANSWERED" : "NOT_ANSWERED");
            }

            if (q.isFlaggedForReview()) {
                flaggedCount++;
            } else if (q.getSelectedOptionId() != null && q.getSelectedOptionId() > 0) {
                answeredCount++;
            } else if ("NOT_ANSWERED".equalsIgnoreCase(q.getStatus())) {
                notAnsweredCount++;
            } else {
                notVisitedCount++;
            }
        }

        if (totalQuestions > 0) {
            this.progressPercentage = (int) Math.round(((double) answeredCount / (double) totalQuestions) * 100.0);
        }
    }

    public QuizAttempt getAttempt() {
        return attempt;
    }

    public void setAttempt(QuizAttempt attempt) {
        this.attempt = attempt;
    }

    public List<ExamQuestionDto> getQuestions() {
        return questions;
    }

    public void setQuestions(List<ExamQuestionDto> questions) {
        this.questions = questions;
    }

    public int getCurrentQuestionIndex() {
        return currentQuestionIndex;
    }

    public void setCurrentQuestionIndex(int currentQuestionIndex) {
        this.currentQuestionIndex = currentQuestionIndex;
    }

    public ExamQuestionDto getCurrentQuestion() {
        return currentQuestion;
    }

    public void setCurrentQuestion(ExamQuestionDto currentQuestion) {
        this.currentQuestion = currentQuestion;
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

    public int getFlaggedCount() {
        return flaggedCount;
    }

    public void setFlaggedCount(int flaggedCount) {
        this.flaggedCount = flaggedCount;
    }

    public int getNotAnsweredCount() {
        return notAnsweredCount;
    }

    public void setNotAnsweredCount(int notAnsweredCount) {
        this.notAnsweredCount = notAnsweredCount;
    }

    public int getNotVisitedCount() {
        return notVisitedCount;
    }

    public void setNotVisitedCount(int notVisitedCount) {
        this.notVisitedCount = notVisitedCount;
    }

    public long getRemainingSeconds() {
        return remainingSeconds;
    }

    public void setRemainingSeconds(long remainingSeconds) {
        this.remainingSeconds = remainingSeconds;
    }

    public String getFormattedRemainingTime() {
        return formattedRemainingTime;
    }

    public void setFormattedRemainingTime(String formattedRemainingTime) {
        this.formattedRemainingTime = formattedRemainingTime;
    }

    public int getProgressPercentage() {
        return progressPercentage;
    }

    public void setProgressPercentage(int progressPercentage) {
        this.progressPercentage = progressPercentage;
    }
}
