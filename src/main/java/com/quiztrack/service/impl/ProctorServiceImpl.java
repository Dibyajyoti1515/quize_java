package com.quiztrack.service.impl;

import com.quiztrack.dao.ProctorDao;
import com.quiztrack.dao.impl.ProctorDaoImpl;
import com.quiztrack.model.*;
import com.quiztrack.service.ProctorService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.List;
import java.util.Optional;

/**
 * Service implementation for live proctoring oversight, anomaly audits, and candidate interventions.
 */
public class ProctorServiceImpl implements ProctorService {

    private static final Logger logger = LoggerFactory.getLogger(ProctorServiceImpl.class);
    private final ProctorDao proctorDao;

    public ProctorServiceImpl() {
        this.proctorDao = new ProctorDaoImpl();
    }

    public ProctorServiceImpl(ProctorDao proctorDao) {
        this.proctorDao = proctorDao;
    }

    @Override
    public TeacherLiveMonitoringData getMonitoringDashboard(int quizId, int teacherId) {
        List<Quiz> quizzes = proctorDao.getMonitorableQuizzesForTeacher(teacherId);
        if (quizzes.isEmpty()) {
            TeacherLiveMonitoringData empty = new TeacherLiveMonitoringData();
            empty.setTeacherId(teacherId);
            return empty;
        }

        int targetQuizId = quizId;
        if (targetQuizId <= 0) {
            targetQuizId = quizzes.get(0).getQuizId();
        } else {
            // Verify teacher authorization for target quiz
            boolean authorized = proctorDao.isTeacherAuthorizedForQuiz(targetQuizId, teacherId);
            if (!authorized) {
                logger.warn("Teacher ID {} is NOT authorized to monitor quiz ID {}", teacherId, targetQuizId);
                throw new SecurityException("Unauthorized attempt to access another instructor's examination monitoring stream.");
            }
        }

        Quiz currentQuiz = null;
        for (Quiz q : quizzes) {
            if (q.getQuizId() == targetQuizId) {
                currentQuiz = q;
                break;
            }
        }

        TeacherLiveMonitoringData data = new TeacherLiveMonitoringData();
        data.setQuizId(targetQuizId);
        data.setTeacherId(teacherId);
        data.setAvailableQuizzes(quizzes);

        if (currentQuiz != null) {
            data.setQuizTitle(currentQuiz.getTitle());
            data.setSubjectCode(currentQuiz.getSubjectCode());
            data.setSubjectName(currentQuiz.getSubjectName());
            data.setQuizStatus(currentQuiz.getStatus());
            data.setDurationMinutes(currentQuiz.getDurationMinutes());
        }

        // Fetch examinees
        List<LiveExamineeDto> examinees = proctorDao.getExamineesForQuiz(targetQuizId);
        data.setExaminees(examinees);
        data.setTotalAssigned(examinees.size());

        int active = 0;
        int submitted = 0;
        int flagged = 0;
        int critical = 0;
        double sumProgress = 0.0;
        BigDecimal sumIntegrity = BigDecimal.ZERO;

        for (LiveExamineeDto e : examinees) {
            if ("IN_PROGRESS".equalsIgnoreCase(e.getStatus())) {
                active++;
            } else if ("SUBMITTED".equalsIgnoreCase(e.getStatus())) {
                submitted++;
            }

            if (e.isFlagged()) {
                flagged++;
            }

            if ("CRITICAL".equalsIgnoreCase(e.getIntegrityLevel())) {
                critical++;
            }

            sumProgress += e.getProgressPercentage();
            sumIntegrity = sumIntegrity.add(e.getIntegrityIndex());
        }

        data.setActiveCount(active);
        data.setSubmittedCount(submitted);
        data.setFlaggedCount(flagged);
        data.setCriticalCount(critical);

        if (!examinees.isEmpty()) {
            double avgProg = sumProgress / examinees.size();
            data.setAverageProgress(Math.round(avgProg * 10.0) / 10.0);

            BigDecimal avgInteg = sumIntegrity.divide(BigDecimal.valueOf(examinees.size()), 2, RoundingMode.HALF_UP);
            data.setAverageIntegrityIndex(avgInteg);
        }

        // Fetch recent proctoring activity events
        List<ProctorActivityEventDto> events = proctorDao.getRecentEventsForQuiz(targetQuizId, 40);
        data.setRecentEvents(events);

        // Fetch audit logs
        List<ProctorInterventionDto> audit = proctorDao.getInterventionAuditLogs(targetQuizId, 25);
        data.setAuditLogs(audit);

        return data;
    }

    @Override
    public LiveExamineeDto getExamineeDetails(int attemptId, int teacherId) {
        Optional<LiveExamineeDto> opt = proctorDao.getExamineeDetails(attemptId);
        if (opt.isEmpty()) {
            throw new IllegalArgumentException("Examination attempt not found: " + attemptId);
        }

        LiveExamineeDto dto = opt.get();
        boolean authorized = proctorDao.isTeacherAuthorizedForQuiz(dto.getQuizId(), teacherId);
        if (!authorized) {
            logger.warn("Teacher {} is not authorized for attempt {}", teacherId, attemptId);
            throw new SecurityException("Unauthorized attempt to access candidate monitoring details.");
        }
        return dto;
    }

    @Override
    public List<ProctorActivityEventDto> getStudentTimeline(int attemptId, int teacherId) {
        Optional<LiveExamineeDto> opt = proctorDao.getExamineeDetails(attemptId);
        if (opt.isEmpty()) {
            throw new IllegalArgumentException("Attempt not found: " + attemptId);
        }

        LiveExamineeDto dto = opt.get();
        boolean authorized = proctorDao.isTeacherAuthorizedForQuiz(dto.getQuizId(), teacherId);
        if (!authorized) {
            throw new SecurityException("Unauthorized access to candidate event timeline.");
        }

        return proctorDao.getStudentEventsTimeline(attemptId);
    }

    @Override
    public boolean reviewEvent(int logId, int teacherId, String reviewNotes) {
        return proctorDao.markEventReviewed(logId, teacherId, reviewNotes);
    }

    @Override
    public boolean flagStudentAttempt(int attemptId, int teacherId, String flagReason) {
        Optional<LiveExamineeDto> opt = proctorDao.getExamineeDetails(attemptId);
        if (opt.isEmpty()) {
            return false;
        }
        boolean authorized = proctorDao.isTeacherAuthorizedForQuiz(opt.get().getQuizId(), teacherId);
        if (!authorized) {
            throw new SecurityException("Unauthorized attempt to flag student in another instructor's quiz.");
        }

        return proctorDao.flagAttempt(attemptId, teacherId, flagReason);
    }

    @Override
    public boolean clearStudentFlag(int attemptId, int teacherId, String clearReason) {
        Optional<LiveExamineeDto> opt = proctorDao.getExamineeDetails(attemptId);
        if (opt.isEmpty()) {
            return false;
        }
        boolean authorized = proctorDao.isTeacherAuthorizedForQuiz(opt.get().getQuizId(), teacherId);
        if (!authorized) {
            throw new SecurityException("Unauthorized attempt to clear student flag in another instructor's quiz.");
        }

        return proctorDao.clearAttemptFlag(attemptId, teacherId, clearReason);
    }

    @Override
    public boolean broadcastNotice(int quizId, int teacherId, String message) {
        boolean authorized = proctorDao.isTeacherAuthorizedForQuiz(quizId, teacherId);
        if (!authorized) {
            throw new SecurityException("Unauthorized attempt to broadcast to another instructor's quiz.");
        }

        // Record in audit log
        List<LiveExamineeDto> examinees = proctorDao.getExamineesForQuiz(quizId);
        if (!examinees.isEmpty()) {
            int firstAttemptId = examinees.get(0).getAttemptId();
            return proctorDao.recordTeacherIntervention(firstAttemptId, teacherId, "BROADCAST", "Notice Broadcast: " + message);
        }
        return true;
    }
}
