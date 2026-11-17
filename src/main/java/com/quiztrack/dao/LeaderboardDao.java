package com.quiztrack.dao;

import com.quiztrack.model.CertificateDto;
import com.quiztrack.model.LeaderboardEntryDto;
import com.quiztrack.model.Quiz;
import com.quiztrack.model.Subject;

import java.math.BigDecimal;
import java.util.List;
import java.util.Optional;

/**
 * Data Access Object for cohort leaderboard calculations, competition rankings, and verified certificates.
 */
public interface LeaderboardDao {

    /**
     * Retrieves all ranked student attempts for a quiz using Standard Competition Ranking
     * with tie-breaking on completion time.
     */
    List<LeaderboardEntryDto> getLeaderboardEntries(int quizId);

    /**
     * Retrieves a student's personal standing for a quiz, even when outside top ranks.
     */
    Optional<LeaderboardEntryDto> getStudentStanding(int quizId, int studentId);

    /**
     * Retrieves verified certificate by unique SHA-256 cryptographic digest or formatted certificate ID.
     */
    Optional<CertificateDto> getCertificateByHashOrId(String hashOrId);

    /**
     * Retrieves verified certificate for a specific student and quiz attempt.
     */
    Optional<CertificateDto> getStudentCertificate(int quizId, int studentId);

    /**
     * Retrieves quizzes available for leaderboard analytics.
     */
    List<Quiz> getAvailableQuizzesForLeaderboard(Integer subjectId);

    /**
     * Retrieves subjects having published quizzes.
     */
    List<Subject> getSubjectsWithPublishedQuizzes();

    /**
     * Retrieves all sorted scores for a quiz to compute statistical quartiles and distributions.
     */
    List<BigDecimal> getScoresForDistribution(int quizId);
}
