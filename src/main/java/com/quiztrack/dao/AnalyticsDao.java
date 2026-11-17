package com.quiztrack.dao;

import com.quiztrack.model.TeacherDashboardData;
import java.util.List;

/**
 * Data Access Object interface for aggregated academic and proctoring analytics.
 */
public interface AnalyticsDao {

    int countTotalStudents();

    double calculateAverageClassScore();

    int countActiveExaminees(int quizId);

    int countTotalAssignedStudents(int quizId);

    int countFlaggedEvents(int quizId);

    int countTotalCompletedSessions();

    double getProctorTrustIndex();

    List<TeacherDashboardData.TopicMastery> getTopicMasteryStats(int subjectId);

    List<TeacherDashboardData.CohortMetric> getCohortComparisonMetrics();

    List<TeacherDashboardData.PendingAudit> getPendingAudits();
}
