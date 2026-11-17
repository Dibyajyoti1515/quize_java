package com.quiztrack.service;

import com.quiztrack.model.CertificateDto;
import com.quiztrack.model.LeaderboardViewDto;

/**
 * Service interface for student leaderboard aggregation, podium rankings, and certificate verification.
 */
public interface LeaderboardService {

    /**
     * Compiles complete leaderboard view with podium, rankings, filters, quartiles, and current user focus card.
     */
    LeaderboardViewDto getLeaderboardView(int quizId, Integer subjectId, String timeFilter, int currentUserId);

    /**
     * Retrieves student's verified certificate for the modal with authorization check.
     */
    CertificateDto getVerifiedCertificate(int quizId, int studentId, int requestingUserId, String requestingRole);

    /**
     * Verifies certificate authenticity publicly using unique certificate ID or SHA-256 digest.
     */
    CertificateDto verifyCertificatePublic(String certificateIdOrHash);
}
