package com.quiztrack.service;

import com.quiztrack.model.StudentResultDto;
import java.util.List;

/**
 * Service interface for candidate examination results, grading breakdown, and cohort performance analytics.
 */
public interface ResultService {

    StudentResultDto getExamResult(int attemptId, int studentId);

    StudentResultDto getLatestResult(int studentId);

    List<StudentResultDto> getResultsHistory(int studentId);
}
