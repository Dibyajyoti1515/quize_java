<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Examination Submitted | QuizTrack Academic Registry</title>

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
                        secondary: '#4648d4',
                        tertiary: '#005338',
                        'tertiary-container': '#006e4b',
                        'tertiary-fixed': '#6ffbbe',
                        error: '#ba1a1a',
                        'error-container': '#ffdad6',
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
<body class="bg-surface font-body text-on-surface antialiased min-h-screen flex items-center justify-center p-4">
    <div class="w-full max-w-xl bg-surface-container-lowest rounded-3xl shadow-xl border border-surface-container-high p-8 sm:p-10 flex flex-col items-center text-center">
        
        <!-- Animated Success Badge -->
        <div class="w-20 h-20 rounded-3xl bg-emerald-50 text-emerald-600 border border-emerald-200 flex items-center justify-center mb-6 shadow-sm">
            <span class="material-symbols-outlined text-[44px]">verified</span>
        </div>

        <span class="px-3 py-1 rounded-full bg-emerald-50 text-emerald-700 font-mono text-xs font-bold uppercase tracking-wider mb-2 border border-emerald-200">
            Session Finalized &amp; Cryptographically Sealed
        </span>

        <h1 class="font-display text-2xl sm:text-3xl font-bold text-on-surface mb-2">
            Examination Submitted Successfully
        </h1>

        <p class="text-sm text-on-surface-variant max-w-md mb-6 leading-relaxed">
            Your responses for <strong class="text-on-surface font-semibold">${attempt.quizTitle}</strong> have been recorded to PostgreSQL and queued for automated grading and proctor audit.
        </p>

        <!-- Official Submission Receipt Dossier -->
        <div class="w-full bg-surface-container-low rounded-2xl p-5 text-left font-mono text-xs mb-8 border border-surface-container-high space-y-3">
            <div class="flex items-center justify-between">
                <span class="text-on-surface-variant font-semibold">Attempt Identification:</span>
                <span class="font-bold text-on-surface">ATTEMPT-#${attempt.attemptId}</span>
            </div>
            <div class="flex items-center justify-between">
                <span class="text-on-surface-variant font-semibold">Course Module:</span>
                <span class="font-bold text-primary">${attempt.subjectCode} - ${attempt.subjectName}</span>
            </div>
            <div class="flex items-center justify-between">
                <span class="text-on-surface-variant font-semibold">Candidate Seat:</span>
                <span class="font-bold text-on-surface">QT-${sessionScope.userId} (${sessionScope.userFullName})</span>
            </div>
            <div class="flex items-center justify-between">
                <span class="text-on-surface-variant font-semibold">Submission Timestamp:</span>
                <span class="font-bold text-on-surface">
                    <fmt:formatDate value="${attempt.endTime}" pattern="yyyy-MM-dd HH:mm:ss z"/>
                </span>
            </div>
            <div class="flex items-center justify-between">
                <span class="text-on-surface-variant font-semibold">Proctor Audit Standing:</span>
                <span class="font-bold text-emerald-700 flex items-center gap-1">
                    <span class="material-symbols-outlined text-[14px]">check_circle</span>
                    <span>Cleared (Verified Fullscreen)</span>
                </span>
            </div>
            <div class="flex items-center justify-between pt-2 border-t border-surface-container-high">
                <span class="text-on-surface-variant font-semibold">Status:</span>
                <span class="px-2 py-0.5 rounded bg-emerald-100 text-emerald-800 font-bold text-[11px]">
                    ${attempt.status}
                </span>
            </div>
        </div>

        <!-- Action CTAs -->
        <div class="flex flex-col sm:flex-row gap-3 w-full">
            <a href="${pageContext.request.contextPath}/student/dashboard" class="flex-1 py-3 px-5 rounded-xl bg-primary hover:bg-primary-container text-on-primary font-semibold text-sm transition-all shadow-sm text-center flex items-center justify-center gap-2">
                <span class="material-symbols-outlined text-[18px]">dashboard</span>
                <span>Return to Student Portal</span>
            </a>
            <a href="${pageContext.request.contextPath}/student/quizzes" class="py-3 px-5 rounded-xl bg-surface-container hover:bg-surface-container-high text-on-surface font-semibold text-sm transition-all text-center">
                Available Quizzes
            </a>
        </div>

    </div>
</body>
</html>
