<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Academic Credential Verification | QuizTrack Public Registry</title>

    <link href="https://fonts.googleapis.com" rel="preconnect"/>
    <link crossorigin="" href="https://fonts.gstatic.com" rel="preconnect"/>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=JetBrains+Mono:wght@400;500;600&family=Plus+Jakarta+Sans:wght@600;700;800&display=swap" rel="stylesheet"/>
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200" rel="stylesheet"/>

    <script src="https://cdn.tailwindcss.com"></script>
    <script>
        tailwind.config = {
            theme: {
                extend: {
                    colors: {
                        primary: '#3525cd',
                        'primary-container': '#4f46e5',
                        'on-primary': '#ffffff',
                        surface: '#f8f9ff',
                        'surface-container-lowest': '#ffffff',
                        'surface-container-low': '#eff4ff',
                        'surface-container': '#e5eeff',
                        'surface-container-high': '#dce9ff',
                        'on-surface': '#0b1c30',
                        'on-surface-variant': '#464555'
                    },
                    fontFamily: {
                        display: ['Plus Jakarta Sans', 'sans-serif'],
                        body: ['Inter', 'sans-serif'],
                        mono: ['JetBrains Mono', 'monospace']
                    }
                }
            }
        };
    </script>
</head>
<body class="bg-surface font-body text-sm text-on-surface min-h-screen flex flex-col justify-between">

    <!-- Top Navigation Header -->
    <header class="h-16 bg-surface-container-lowest border-b border-surface-container-high px-4 sm:px-8 flex items-center justify-between">
        <div class="flex items-center gap-3">
            <div class="w-9 h-9 rounded-xl bg-primary-container text-on-primary flex items-center justify-center shadow-sm">
                <span class="material-symbols-outlined text-[20px]">verified_user</span>
            </div>
            <div>
                <span class="font-display font-bold text-base text-on-surface leading-tight">QuizTrack</span>
                <span class="block font-mono text-[10px] text-on-surface-variant uppercase tracking-wider">Credential Verification Registry</span>
            </div>
        </div>

        <a href="${pageContext.request.contextPath}/auth/login" class="text-xs font-semibold text-primary hover:text-primary-container transition-colors">
            Candidate Login &rarr;
        </a>
    </header>

    <!-- Main Verification Section -->
    <main class="flex-1 max-w-3xl mx-auto w-full p-4 sm:p-8 flex flex-col gap-6 justify-center">

        <!-- Verification Search Bar -->
        <form action="${pageContext.request.contextPath}/verify/certificate" method="GET" class="flex gap-2">
            <div class="relative flex-1">
                <span class="material-symbols-outlined text-[20px] text-on-surface-variant absolute left-3.5 top-3">search</span>
                <input type="text" name="id" value="${queryToken}" placeholder="Enter Certificate ID (e.g. QT-CERT-...) or SHA-256 Digest" class="w-full pl-10 pr-4 py-2.5 rounded-xl border border-surface-container-high bg-surface-container-lowest text-xs text-on-surface focus:outline-none focus:ring-2 focus:ring-primary shadow-xs"/>
            </div>
            <button type="submit" class="px-5 py-2.5 bg-primary hover:bg-primary-container text-on-primary rounded-xl font-semibold text-xs transition-all shadow-sm">
                Verify
            </button>
        </form>

        <!-- Verification Result Status Box -->
        <c:choose>
            <c:when test="${certificate.status == 'VALID'}">
                <div class="rounded-3xl bg-surface-container-lowest border-2 border-emerald-400 p-6 sm:p-8 shadow-sm flex flex-col gap-6">
                    <div class="flex items-center justify-between gap-3 border-b border-surface-container pb-4">
                        <div class="flex items-center gap-3">
                            <div class="w-12 h-12 rounded-2xl bg-emerald-100 text-emerald-800 flex items-center justify-center">
                                <span class="material-symbols-outlined text-3xl">verified</span>
                            </div>
                            <div>
                                <span class="px-2.5 py-0.5 rounded-full bg-emerald-100 text-emerald-800 font-mono text-xs font-bold uppercase tracking-wider">
                                    Authentic &amp; Validated
                                </span>
                                <h2 class="font-display font-bold text-lg text-on-surface mt-1">Official Academic Distinction Record</h2>
                            </div>
                        </div>
                        <span class="font-mono text-xs text-on-surface-variant hidden sm:inline">Registry Match</span>
                    </div>

                    <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
                        <div class="p-4 rounded-2xl bg-surface-container-low flex flex-col gap-1">
                            <span class="text-[11px] font-semibold uppercase text-on-surface-variant">Conferred Examinee</span>
                            <span class="font-display font-bold text-base text-on-surface">${certificate.studentName}</span>
                            <span class="font-mono text-xs text-on-surface-variant">Roll No: ${certificate.studentIdentifier}</span>
                        </div>
                        <div class="p-4 rounded-2xl bg-surface-container-low flex flex-col gap-1">
                            <span class="text-[11px] font-semibold uppercase text-on-surface-variant">Course &amp; Assessment</span>
                            <span class="font-display font-bold text-base text-on-surface">${certificate.subjectCode}: ${certificate.quizTitle}</span>
                            <span class="text-xs text-on-surface-variant">${certificate.subjectName}</span>
                        </div>
                        <div class="p-4 rounded-2xl bg-surface-container-low flex flex-col gap-1">
                            <span class="text-[11px] font-semibold uppercase text-on-surface-variant">Academic Distinction</span>
                            <span class="font-display font-bold text-base text-primary">${certificate.score} pts (${certificate.percentage}%)</span>
                            <span class="font-mono text-xs text-on-surface-variant">${certificate.grade} &bull; Top ${certificate.percentile}%ile</span>
                        </div>
                        <div class="p-4 rounded-2xl bg-surface-container-low flex flex-col gap-1">
                            <span class="text-[11px] font-semibold uppercase text-on-surface-variant">Proctor Integrity Audit</span>
                            <span class="font-display font-bold text-base text-emerald-700">${certificate.integrityIndex}% Cleared</span>
                            <span class="text-xs text-on-surface-variant">${certificate.proctorStatus}</span>
                        </div>
                    </div>

                    <div class="p-4 rounded-2xl bg-surface-container-low border border-surface-container flex flex-col gap-1 font-mono text-xs">
                        <div class="flex items-center justify-between">
                            <span class="text-on-surface-variant">Certificate ID:</span>
                            <span class="font-bold text-primary">${certificate.certificateId}</span>
                        </div>
                        <div class="flex items-center justify-between">
                            <span class="text-on-surface-variant">SHA-256 Digest:</span>
                            <span class="text-on-surface truncate max-w-xs sm:max-w-md" title="${certificate.certificateHash}">${certificate.certificateHash}</span>
                        </div>
                        <div class="flex items-center justify-between">
                            <span class="text-on-surface-variant">Conferred At:</span>
                            <span class="text-on-surface">${certificate.certifiedAt}</span>
                        </div>
                    </div>
                </div>
            </c:when>

            <c:when test="${certificate.status == 'REVOKED'}">
                <div class="rounded-3xl bg-surface-container-lowest border-2 border-rose-400 p-6 sm:p-8 shadow-sm flex flex-col gap-4">
                    <div class="flex items-center gap-3">
                        <div class="w-12 h-12 rounded-2xl bg-rose-100 text-rose-800 flex items-center justify-center">
                            <span class="material-symbols-outlined text-3xl">cancel</span>
                        </div>
                        <div>
                            <span class="px-2.5 py-0.5 rounded-full bg-rose-100 text-rose-800 font-mono text-xs font-bold uppercase tracking-wider">
                                Credential Revoked / Ineligible
                            </span>
                            <h2 class="font-display font-bold text-lg text-on-surface mt-1">Certificate Not in Good Standing</h2>
                        </div>
                    </div>
                    <p class="text-xs text-on-surface-variant">
                        This credential is not certified. The record associated with Certificate ID <strong>${certificate.certificateId}</strong> did not meet the mandatory passing cutoff or proctor integrity threshold.
                    </p>
                </div>
            </c:when>

            <c:otherwise>
                <div class="rounded-3xl bg-surface-container-lowest border border-surface-container-high p-6 sm:p-8 shadow-sm flex flex-col gap-4 text-center items-center">
                    <div class="w-12 h-12 rounded-2xl bg-surface-container text-on-surface-variant flex items-center justify-center">
                        <span class="material-symbols-outlined text-3xl">search_off</span>
                    </div>
                    <div>
                        <h2 class="font-display font-bold text-base text-on-surface">No Verifiable Record Found</h2>
                        <p class="text-xs text-on-surface-variant mt-1 max-w-md">
                            No active academic credential matches token <strong>${queryToken}</strong>. Please check the Certificate ID or SHA-256 digest and try again.
                        </p>
                    </div>
                </div>
            </c:otherwise>
        </c:choose>

    </main>

    <!-- Footer -->
    <footer class="h-12 border-t border-surface-container-high text-center flex items-center justify-center text-xs text-on-surface-variant">
        &copy; 2026 QuizTrack Online Examination &amp; Proctoring Platform. Department of Computer Science.
    </footer>

</body>
</html>
