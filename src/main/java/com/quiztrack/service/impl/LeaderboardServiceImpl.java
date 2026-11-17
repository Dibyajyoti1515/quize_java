package com.quiztrack.service.impl;

import com.quiztrack.dao.LeaderboardDao;
import com.quiztrack.dao.impl.LeaderboardDaoImpl;
import com.quiztrack.model.*;
import com.quiztrack.service.LeaderboardService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.Collections;
import java.util.List;
import java.util.Optional;

/**
 * Service implementation for cohort leaderboard rankings, podium determination, and verified certificates.
 */
public class LeaderboardServiceImpl implements LeaderboardService {

    private static final Logger logger = LoggerFactory.getLogger(LeaderboardServiceImpl.class);
    private final LeaderboardDao leaderboardDao;

    public LeaderboardServiceImpl() {
        this.leaderboardDao = new LeaderboardDaoImpl();
    }

    public LeaderboardServiceImpl(LeaderboardDao leaderboardDao) {
        this.leaderboardDao = leaderboardDao;
    }

    @Override
    public LeaderboardViewDto getLeaderboardView(int quizId, Integer subjectId, String timeFilter, int currentUserId) {
        LeaderboardViewDto view = new LeaderboardViewDto();
        view.setSelectedSubjectId(subjectId);
        view.setSelectedTimeFilter(timeFilter != null ? timeFilter : "ALL");

        // 1. Load subjects & quizzes for navigation filters
        List<Subject> subjects = leaderboardDao.getSubjectsWithPublishedQuizzes();
        view.setAvailableSubjects(subjects);

        List<Quiz> quizzes = leaderboardDao.getAvailableQuizzesForLeaderboard(subjectId);
        view.setAvailableQuizzes(quizzes);

        // Determine target quiz
        int targetQuizId = quizId;
        if (targetQuizId <= 0) {
            if (!quizzes.isEmpty()) {
                targetQuizId = quizzes.get(0).getQuizId();
            } else {
                targetQuizId = 1; // Default benchmark quiz
            }
        }
        view.setSelectedQuizId(targetQuizId);

        // 2. Fetch ranked leaderboard entries
        List<LeaderboardEntryDto> entries = leaderboardDao.getLeaderboardEntries(targetQuizId);
        view.setEntries(entries);
        view.setTotalParticipants(entries.size());

        // 3. Podium Assignment (Gold #1, Silver #2, Bronze #3)
        for (LeaderboardEntryDto entry : entries) {
            if (entry.getStudentId() == currentUserId) {
                entry.setCurrentUser(true);
                view.setCurrentUserEntry(entry);
            }
            if (entry.getRank() == 1 && view.getPodiumGold() == null) {
                view.setPodiumGold(entry);
            } else if (entry.getRank() == 2 && view.getPodiumSilver() == null) {
                view.setPodiumSilver(entry);
            } else if (entry.getRank() == 3 && view.getPodiumBronze() == null) {
                view.setPodiumBronze(entry);
            }
        }

        // If current user is not in top entries, check if standing exists
        if (view.getCurrentUserEntry() == null && currentUserId > 0) {
            Optional<LeaderboardEntryDto> standingOpt = leaderboardDao.getStudentStanding(targetQuizId, currentUserId);
            standingOpt.ifPresent(view::setCurrentUserEntry);
        }

        // 4. Retrieve student's verified certificate if eligible
        if (view.getCurrentUserEntry() != null && view.getCurrentUserEntry().isCertificateEligible()) {
            Optional<CertificateDto> certOpt = leaderboardDao.getStudentCertificate(targetQuizId, currentUserId);
            certOpt.ifPresent(view::setCurrentUserCertificate);
        }

        // 5. Statistical distribution metrics (Average, Top Score, Quartiles)
        List<BigDecimal> scores = leaderboardDao.getScoresForDistribution(targetQuizId);
        if (!scores.isEmpty()) {
            Collections.sort(scores);
            view.setTopScore(scores.get(scores.size() - 1));

            BigDecimal sumPercentage = BigDecimal.ZERO;
            for (LeaderboardEntryDto e : entries) {
                sumPercentage = sumPercentage.add(e.getPercentage());
            }
            if (!entries.isEmpty()) {
                double avg = sumPercentage.doubleValue() / entries.size();
                view.setClassAveragePercentage(Math.round(avg * 10.0) / 10.0);
            }

            // Empirical quartiles
            int n = scores.size();
            view.setLowerQuartileScore(scores.get((int) Math.floor(n * 0.25)));
            view.setMedianScore(scores.get((int) Math.floor(n * 0.50)));
            view.setUpperQuartileScore(scores.get((int) Math.floor(n * 0.75)));
        } else if (!entries.isEmpty()) {
            view.setTopScore(entries.get(0).getScore());
        }

        return view;
    }

    @Override
    public CertificateDto getVerifiedCertificate(int quizId, int studentId, int requestingUserId, String requestingRole) {
        boolean isSelf = (requestingUserId == studentId);
        boolean isPrivileged = "TEACHER".equalsIgnoreCase(requestingRole) || "ADMIN".equalsIgnoreCase(requestingRole);

        if (!isSelf && !isPrivileged) {
            logger.warn("Security violation: user {} attempted to access certificate of student {}", requestingUserId, studentId);
            throw new SecurityException("Unauthorized access to candidate certificate record.");
        }

        Optional<CertificateDto> certOpt = leaderboardDao.getStudentCertificate(quizId, studentId);
        if (certOpt.isEmpty()) {
            logger.warn("Certificate record not found for quiz {} and student {}", quizId, studentId);
            throw new IllegalArgumentException("No verified certificate found for requested student and assessment.");
        }

        CertificateDto cert = certOpt.get();
        if (!cert.isPassed() || cert.getCertificateHash() == null) {
            cert.setStatus("REVOKED");
        }
        return cert;
    }

    @Override
    public CertificateDto verifyCertificatePublic(String certificateIdOrHash) {
        if (certificateIdOrHash == null || certificateIdOrHash.trim().isEmpty()) {
            CertificateDto invalid = new CertificateDto();
            invalid.setStatus("INVALID");
            return invalid;
        }

        Optional<CertificateDto> opt = leaderboardDao.getCertificateByHashOrId(certificateIdOrHash);
        if (opt.isEmpty()) {
            CertificateDto notFound = new CertificateDto();
            notFound.setCertificateId(certificateIdOrHash);
            notFound.setStatus("NOT_FOUND");
            return notFound;
        }

        return opt.get();
    }
}
