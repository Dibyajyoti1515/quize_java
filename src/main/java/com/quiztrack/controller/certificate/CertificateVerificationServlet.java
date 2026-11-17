package com.quiztrack.controller.certificate;

import com.quiztrack.model.CertificateDto;
import com.quiztrack.service.LeaderboardService;
import com.quiztrack.service.impl.LeaderboardServiceImpl;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;

/**
 * Publicly accessible academic credential verification servlet.
 * Verifies authenticity, proctor standing, and digital tamper status directly against PostgreSQL.
 */
@WebServlet(name = "CertificateVerificationServlet", urlPatterns = {"/verify/certificate", "/certificate/verify"})
public class CertificateVerificationServlet extends HttpServlet {

    private static final Logger logger = LoggerFactory.getLogger(CertificateVerificationServlet.class);
    private final LeaderboardService leaderboardService;

    public CertificateVerificationServlet() {
        this.leaderboardService = new LeaderboardServiceImpl();
    }

    public CertificateVerificationServlet(LeaderboardService leaderboardService) {
        this.leaderboardService = leaderboardService;
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String certQuery = request.getParameter("id");
        if (certQuery == null || certQuery.isBlank()) {
            certQuery = request.getParameter("hash");
        }
        if (certQuery == null || certQuery.isBlank()) {
            certQuery = request.getParameter("token");
        }

        CertificateDto cert;
        if (certQuery != null && !certQuery.isBlank()) {
            cert = leaderboardService.verifyCertificatePublic(certQuery.trim());
        } else {
            cert = new CertificateDto();
            cert.setStatus("INVALID");
        }

        String format = request.getParameter("format");
        String acceptHeader = request.getHeader("Accept");
        boolean requestedJson = "json".equalsIgnoreCase(format) ||
                (acceptHeader != null && acceptHeader.contains("application/json"));

        if (requestedJson) {
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().write(String.format(
                    "{\"status\":\"%s\",\"certificateId\":\"%s\",\"studentName\":\"%s\",\"subjectCode\":\"%s\",\"quizTitle\":\"%s\",\"score\":\"%s\",\"grade\":\"%s\",\"integrityIndex\":\"%s\",\"certifiedAt\":\"%s\"}",
                    cert.getStatus(),
                    cert.getCertificateId() != null ? cert.getCertificateId() : "",
                    "VALID".equals(cert.getStatus()) ? cert.getStudentName() : "",
                    cert.getSubjectCode() != null ? cert.getSubjectCode() : "",
                    cert.getQuizTitle() != null ? cert.getQuizTitle() : "",
                    cert.getScore() != null ? cert.getScore().toString() : "0.00",
                    cert.getGrade() != null ? cert.getGrade() : "",
                    cert.getIntegrityIndex() != null ? cert.getIntegrityIndex().toString() : "0.00",
                    cert.getCertifiedAt() != null ? cert.getCertifiedAt().toString() : ""
            ));
            return;
        }

        request.setAttribute("certificate", cert);
        request.setAttribute("queryToken", certQuery);
        request.getRequestDispatcher("/WEB-INF/views/public/verify-certificate.jsp").forward(request, response);
    }
}
