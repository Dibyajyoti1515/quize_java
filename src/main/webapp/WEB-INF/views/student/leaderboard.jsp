<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Cohort Leaderboard &amp; Verified Credential | QuizTrack Student Portal</title>

    <link href="https://fonts.googleapis.com" rel="preconnect"/>
    <link crossorigin="" href="https://fonts.gstatic.com" rel="preconnect"/>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=JetBrains+Mono:wght@400;500;600&family=Plus+Jakarta+Sans:wght@600;700;800&display=swap" rel="stylesheet"/>
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200" rel="stylesheet"/>

    <style>
        @layer base {
            html, body { margin: 0; padding: 0; }
            ::-webkit-scrollbar { display: none; }
        }
        @media print {
            aside, header, nav, button, .no-print { display: none !important; }
            #certificate-modal { position: static !important; display: block !important; background: transparent !important; padding: 0 !important; }
            #certificate-modal > div { max-width: 100% !important; box-shadow: none !important; border: none !important; }
            body { background: white !important; color: black !important; }
        }
    </style>

    <script src="https://cdn.tailwindcss.com"></script>
    <script>
        tailwind.config = {
            theme: {
                extend: {
                    colors: {
                        primary: '#3525cd',
                        'primary-container': '#4f46e5',
                        'on-primary': '#ffffff',
                        'primary-fixed': '#e2dfff',
                        'on-primary-fixed': '#0f0069',
                        secondary: '#4648d4',
                        'secondary-container': '#6063ee',
                        'secondary-fixed': '#e1e0ff',
                        'on-secondary-fixed': '#07006c',
                        tertiary: '#005338',
                        'tertiary-container': '#006e4b',
                        'tertiary-fixed': '#6ffbbe',
                        error: '#ba1a1a',
                        'error-container': '#ffdad6',
                        'on-error-container': '#93000a',
                        surface: '#f8f9ff',
                        'surface-container-lowest': '#ffffff',
                        'surface-container-low': '#eff4ff',
                        'surface-container': '#e5eeff',
                        'surface-container-high': '#dce9ff',
                        'surface-container-highest': '#d3e4fe',
                        'on-surface': '#0b1c30',
                        'on-surface-variant': '#464555',
                        outline: '#777587',
                        'outline-variant': '#c7c4d8'
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
<body class="bg-surface font-body text-sm text-on-surface antialiased min-h-screen flex">

    <!-- DESKTOP SIDEBAR -->
    <aside class="fixed left-0 top-0 h-full w-64 bg-surface-container-lowest border-r border-surface-container-high z-40 hidden lg:flex flex-col justify-between">
        <div class="flex flex-col">
            <div class="h-16 px-6 flex items-center gap-3 border-b border-surface-container">
                <div class="w-9 h-9 rounded-xl bg-primary-container flex items-center justify-center text-on-primary shadow-sm">
                    <span class="material-symbols-outlined text-[20px]">verified_user</span>
                </div>
                <div class="flex flex-col">
                    <span class="font-display font-bold text-base text-on-surface leading-tight">QuizTrack</span>
                    <span class="font-mono text-[10px] text-on-surface-variant uppercase tracking-wider">Candidate Portal</span>
                </div>
            </div>

            <nav class="p-4 flex flex-col gap-1.5">
                <a href="${pageContext.request.contextPath}/student/dashboard" class="flex items-center gap-3 px-3.5 py-2.5 rounded-xl font-medium text-on-surface-variant hover:bg-surface-container-low hover:text-on-surface transition-all">
                    <span class="material-symbols-outlined text-[20px]">dashboard</span>
                    <span>Dashboard</span>
                </a>
                <a href="${pageContext.request.contextPath}/student/quizzes" class="flex items-center gap-3 px-3.5 py-2.5 rounded-xl font-medium text-on-surface-variant hover:bg-surface-container-low hover:text-on-surface transition-all">
                    <span class="material-symbols-outlined text-[20px]">quiz</span>
                    <span>Available Quizzes</span>
                </a>
                <a href="${pageContext.request.contextPath}/student/results" class="flex items-center gap-3 px-3.5 py-2.5 rounded-xl font-medium text-on-surface-variant hover:bg-surface-container-low hover:text-on-surface transition-all">
                    <span class="material-symbols-outlined text-[20px]">analytics</span>
                    <span>Exam Results</span>
                </a>
                <a href="${pageContext.request.contextPath}/student/leaderboard" class="flex items-center gap-3 px-3.5 py-2.5 rounded-xl font-semibold bg-primary-fixed text-on-primary-fixed shadow-sm transition-all">
                    <span class="material-symbols-outlined text-[20px]">military_tech</span>
                    <span>Leaderboard</span>
                </a>
            </nav>
        </div>

        <div class="p-4 border-t border-surface-container-high flex flex-col gap-3">
            <div class="flex items-center gap-3 px-2">
                <div class="w-10 h-10 rounded-full bg-secondary-fixed text-on-secondary-fixed flex items-center justify-center font-bold text-sm">
                    <c:choose>
                        <c:when test="${not empty currentUser.fullName}">
                            ${currentUser.fullName.substring(0, 1)}
                        </c:when>
                        <c:otherwise>S</c:otherwise>
                    </c:choose>
                </div>
                <div class="flex flex-col overflow-hidden">
                    <span class="font-semibold text-xs text-on-surface truncate">${currentUser.fullName}</span>
                    <span class="font-mono text-[11px] text-on-surface-variant">${currentUser.identifier}</span>
                </div>
            </div>
            <a href="${pageContext.request.contextPath}/auth/logout" class="flex items-center justify-center gap-2 w-full py-2 rounded-xl text-error bg-error-container/20 hover:bg-error-container/40 font-semibold text-xs transition-colors">
                <span class="material-symbols-outlined text-[16px]">logout</span>
                <span>Sign Out</span>
            </a>
        </div>
    </aside>

    <!-- MAIN CONTENT REGION -->
    <div class="flex-1 lg:pl-64 flex flex-col min-h-screen">

        <!-- Top Header Navigation -->
        <header class="h-16 bg-surface-container-lowest/80 backdrop-blur-md border-b border-surface-container-high sticky top-0 z-30 px-4 sm:px-8 flex items-center justify-between">
            <div class="flex items-center gap-3">
                <div class="w-8 h-8 rounded-lg bg-surface-container-low text-primary flex items-center justify-center lg:hidden">
                    <span class="material-symbols-outlined text-[20px]">military_tech</span>
                </div>
                <h1 class="font-display font-bold text-lg text-on-surface">Cohort Standings &amp; Verified Credential</h1>
            </div>

            <!-- Quiz Filter Dropdown Form -->
            <form action="${pageContext.request.contextPath}/student/leaderboard" method="GET" class="flex items-center gap-2">
                <c:if test="${not empty leaderboardView.availableQuizzes}">
                    <div class="relative">
                        <select name="quizId" onchange="this.form.submit()" class="appearance-none bg-surface-container-low border border-surface-container-high text-on-surface text-xs font-semibold rounded-xl pl-3 pr-8 py-2 focus:outline-none focus:ring-2 focus:ring-primary cursor-pointer">
                            <c:forEach var="quiz" items="${leaderboardView.availableQuizzes}">
                                <option value="${quiz.quizId}" ${quiz.quizId == leaderboardView.selectedQuizId ? 'selected' : ''}>
                                    ${quiz.subjectCode}: ${quiz.title}
                                </option>
                            </c:forEach>
                        </select>
                        <span class="material-symbols-outlined text-[16px] text-on-surface-variant absolute right-2.5 top-2.5 pointer-events-none">expand_more</span>
                    </div>
                </c:if>
                <button type="button" onclick="window.print()" class="hidden sm:inline-flex items-center gap-1.5 px-3 py-2 rounded-xl bg-surface-container-low hover:bg-surface-container text-on-surface text-xs font-semibold transition-all">
                    <span class="material-symbols-outlined text-[16px]">print</span>
                    <span>Print Ledger</span>
                </button>
            </form>
        </header>

        <!-- Main Workspace -->
        <main class="flex-1 p-4 sm:p-8 max-w-7xl mx-auto w-full flex flex-col gap-6">

            <!-- 1. LOGGED-IN STUDENT FOCUS SPOTLIGHT HERO CARD -->
            <c:choose>
                <c:when test="${not empty leaderboardView.currentUserEntry}">
                    <c:set var="myEntry" value="${leaderboardView.currentUserEntry}"/>
                    <div class="relative overflow-hidden rounded-3xl bg-surface-container-lowest border border-surface-container-high p-6 sm:p-8 shadow-sm">
                        <div class="absolute -right-20 -top-20 w-80 h-80 rounded-full bg-primary/5 blur-3xl pointer-events-none"></div>

                        <div class="flex flex-col lg:flex-row items-start lg:items-center justify-between gap-6 relative z-10">
                            <!-- Left: Identity & Standing -->
                            <div class="flex items-start sm:items-center gap-4">
                                <div class="relative flex-shrink-0">
                                    <div class="w-16 h-16 sm:w-20 sm:h-20 rounded-2xl bg-primary flex items-center justify-center text-on-primary shadow-md">
                                        <span class="material-symbols-outlined text-[36px]">school</span>
                                    </div>
                                    <div class="absolute -bottom-2 -right-2 px-2.5 py-0.5 rounded-full bg-primary-container text-on-primary font-mono text-xs font-bold shadow-sm">
                                        #${myEntry.rank}
                                    </div>
                                </div>
                                <div class="flex flex-col gap-1">
                                    <div class="flex items-center gap-2 flex-wrap">
                                        <h2 class="font-display text-xl sm:text-2xl font-bold text-on-surface">${myEntry.studentName}</h2>
                                        <span class="px-2.5 py-0.5 rounded-full bg-primary-fixed text-on-primary-fixed font-mono text-xs font-bold uppercase tracking-wider">You</span>
                                        <span class="font-mono text-xs px-2 py-0.5 rounded-md bg-surface-container text-on-surface-variant">${myEntry.studentIdentifier}</span>
                                    </div>
                                    <p class="text-xs sm:text-sm text-on-surface-variant">
                                        ${myEntry.subjectCode}: ${myEntry.quizTitle} &bull;
                                        <span class="text-tertiary font-semibold">Rank #${myEntry.rank} &bull; Top ${myEntry.percentile}%ile</span>
                                    </p>
                                    <div class="flex flex-wrap items-center gap-2 mt-1">
                                        <span class="inline-flex items-center gap-1 px-2.5 py-0.5 rounded-md bg-surface-container text-on-surface text-xs font-medium">
                                            <span class="material-symbols-outlined text-[14px] text-primary">speed</span>
                                            Pacing: ${myEntry.durationFormatted}
                                        </span>
                                        <span class="inline-flex items-center gap-1 px-2.5 py-0.5 rounded-md bg-surface-container text-on-surface text-xs font-medium">
                                            <span class="material-symbols-outlined text-[14px] text-tertiary">verified_user</span>
                                            ${myEntry.integrityStatus} (${myEntry.integrityIndex}%)
                                        </span>
                                        <span class="inline-flex items-center gap-1 px-2.5 py-0.5 rounded-md bg-surface-container text-on-surface text-xs font-medium">
                                            <span class="material-symbols-outlined text-[14px] text-secondary">psychology</span>
                                            Strength: ${myEntry.domainStrength}
                                        </span>
                                    </div>
                                </div>
                            </div>

                            <!-- Right: Certificate Action / Eligibility -->
                            <div class="flex flex-col sm:flex-row items-stretch sm:items-center gap-3 w-full lg:w-auto">
                                <c:choose>
                                    <c:when test="${myEntry.certificateEligible}">
                                        <button type="button" onclick="document.getElementById('certificate-modal').classList.remove('hidden')" class="inline-flex items-center justify-center gap-2 px-5 py-3 rounded-xl bg-primary text-on-primary hover:bg-primary-container transition-all font-semibold text-sm shadow-md">
                                            <span class="material-symbols-outlined text-[20px]">verified</span>
                                            <span>View Verified Certificate</span>
                                        </button>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="px-4 py-3 rounded-xl bg-surface-container-low border border-surface-container-high text-xs text-on-surface-variant flex items-center gap-2">
                                            <span class="material-symbols-outlined text-[18px] text-outline">info</span>
                                            <span>Certificate Ineligible (Cutoff not met)</span>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>

                        <!-- Live Telemetry KPI Strip -->
                        <div class="grid grid-cols-2 sm:grid-cols-4 gap-3 mt-6 pt-5 border-t border-surface-container">
                            <div class="flex flex-col">
                                <span class="text-[11px] font-semibold uppercase tracking-wider text-outline">Score Achieved</span>
                                <span class="font-display text-lg sm:text-xl font-bold text-on-surface mt-0.5">
                                    ${myEntry.score} <span class="text-xs font-mono font-normal text-on-surface-variant">/ ${myEntry.maxScore}</span>
                                </span>
                            </div>
                            <div class="flex flex-col">
                                <span class="text-[11px] font-semibold uppercase tracking-wider text-outline">Accuracy Ratio</span>
                                <span class="font-display text-lg sm:text-xl font-bold text-primary mt-0.5">
                                    ${myEntry.percentage}% (${myEntry.grade})
                                </span>
                            </div>
                            <div class="flex flex-col">
                                <span class="text-[11px] font-semibold uppercase tracking-wider text-outline">Cohort Percentile</span>
                                <span class="font-display text-lg sm:text-xl font-bold text-tertiary mt-0.5">
                                    ${myEntry.percentile}th %ile
                                </span>
                            </div>
                            <div class="flex flex-col">
                                <span class="text-[11px] font-semibold uppercase tracking-wider text-outline">Integrity Standing</span>
                                <span class="font-display text-lg sm:text-xl font-bold text-on-surface mt-0.5">
                                    ${myEntry.integrityIndex}%
                                </span>
                            </div>
                        </div>
                    </div>
                </c:when>
                <c:otherwise>
                    <!-- Examinee Has Not Completed This Assessment -->
                    <div class="p-6 rounded-3xl bg-surface-container-low border border-surface-container-high flex flex-col sm:flex-row items-center justify-between gap-4">
                        <div class="flex items-center gap-3 text-center sm:text-left">
                            <div class="w-12 h-12 rounded-2xl bg-surface-container-lowest text-primary flex items-center justify-center flex-shrink-0 shadow-sm">
                                <span class="material-symbols-outlined text-2xl">pending_actions</span>
                            </div>
                            <div>
                                <h3 class="font-display font-bold text-base text-on-surface">You Have Not Submitted This Examination</h3>
                                <p class="text-xs text-on-surface-variant mt-0.5">Complete this assessment to establish your position on the cohort leaderboard and earn your verified certificate.</p>
                            </div>
                        </div>
                        <a href="${pageContext.request.contextPath}/student/quizzes" class="px-5 py-2.5 rounded-xl bg-primary hover:bg-primary-container text-on-primary font-semibold text-xs transition-all shadow-sm">
                            View Active Quizzes
                        </a>
                    </div>
                </c:otherwise>
            </c:choose>

            <!-- 2. TOP 3 PODIUM CARDS -->
            <div class="grid grid-cols-1 md:grid-cols-3 gap-4 items-end mt-2">

                <!-- Silver (#2) -->
                <c:choose>
                    <c:when test="${not empty leaderboardView.podiumSilver}">
                        <c:set var="silver" value="${leaderboardView.podiumSilver}"/>
                        <div class="rounded-2xl bg-surface-container-lowest border border-surface-container-high p-5 shadow-sm hover:shadow-md transition-shadow relative overflow-hidden flex flex-col justify-between order-2 md:order-1 min-h-[260px]">
                            <div class="absolute top-0 right-0 left-0 h-1.5 bg-slate-300"></div>
                            <div>
                                <div class="flex items-center justify-between">
                                    <span class="inline-flex items-center gap-1 px-2.5 py-0.5 rounded-full bg-slate-100 text-slate-700 font-mono text-xs font-bold">
                                        <span class="material-symbols-outlined text-[16px]">workspace_premium</span>
                                        #2 Silver Laureate
                                    </span>
                                    <span class="font-mono text-xs text-on-surface-variant">${silver.studentIdentifier}</span>
                                </div>
                                <div class="mt-4 flex items-center gap-3">
                                    <div class="w-12 h-12 rounded-xl bg-slate-100 text-slate-700 flex items-center justify-center font-bold text-base">
                                        ${silver.avatarInitials}
                                    </div>
                                    <div>
                                        <h3 class="font-display font-bold text-base text-on-surface leading-tight">${silver.studentName}</h3>
                                        <p class="text-xs text-on-surface-variant mt-0.5">${silver.department} &bull; ${silver.cohort}</p>
                                    </div>
                                </div>
                            </div>
                            <div class="mt-4 pt-3 border-t border-surface-container flex items-center justify-between">
                                <div>
                                    <span class="text-[11px] uppercase tracking-wider text-outline font-medium">Final Score</span>
                                    <p class="font-display font-bold text-xl text-on-surface">${silver.score} <span class="text-xs font-mono font-normal text-on-surface-variant">pts</span></p>
                                </div>
                                <div class="text-right">
                                    <span class="px-2 py-0.5 rounded-md bg-slate-100 text-slate-800 font-mono text-xs font-bold">${silver.percentage}%</span>
                                    <p class="text-[11px] text-on-surface-variant mt-0.5">${silver.durationFormatted}</p>
                                </div>
                            </div>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="rounded-2xl bg-surface-container-low border border-dashed border-surface-container-high p-5 flex items-center justify-center min-h-[220px] order-2 md:order-1 text-outline text-xs">
                            Position Open
                        </div>
                    </c:otherwise>
                </c:choose>

                <!-- Gold (#1) - Center Elevated -->
                <c:choose>
                    <c:when test="${not empty leaderboardView.podiumGold}">
                        <c:set var="gold" value="${leaderboardView.podiumGold}"/>
                        <div class="rounded-2xl bg-surface-container-lowest border-2 border-amber-300 p-6 shadow-md hover:shadow-xl transition-all relative overflow-hidden flex flex-col justify-between order-1 md:order-2 min-h-[290px] -mt-2">
                            <div class="absolute top-0 right-0 left-0 h-2 bg-gradient-to-r from-amber-400 via-primary to-amber-400"></div>
                            <div class="absolute -right-10 -top-10 w-28 h-28 rounded-full bg-amber-400/10 blur-xl pointer-events-none"></div>

                            <div>
                                <div class="flex items-center justify-between">
                                    <span class="inline-flex items-center gap-1 px-3 py-1 rounded-full bg-amber-100 text-amber-900 font-mono text-xs font-bold shadow-xs">
                                        <span class="material-symbols-outlined text-[18px] text-amber-600">emoji_events</span>
                                        #1 Gold Laureate
                                    </span>
                                    <span class="font-mono text-xs text-amber-900 font-semibold">${gold.studentIdentifier}</span>
                                </div>
                                <div class="mt-4 flex items-center gap-3">
                                    <div class="w-14 h-14 rounded-2xl bg-gradient-to-tr from-amber-400 to-amber-200 text-amber-950 flex items-center justify-center font-bold text-lg shadow-sm">
                                        ${gold.avatarInitials}
                                    </div>
                                    <div>
                                        <h3 class="font-display font-bold text-lg text-on-surface leading-tight">${gold.studentName}</h3>
                                        <p class="text-xs text-on-surface-variant mt-0.5">${gold.department} &bull; ${gold.cohort}</p>
                                    </div>
                                </div>
                            </div>
                            <div class="mt-4 pt-4 border-t border-amber-100 flex items-center justify-between">
                                <div>
                                    <span class="text-[11px] uppercase tracking-wider text-amber-900 font-semibold">Distinction Score</span>
                                    <p class="font-display font-bold text-2xl text-on-surface">${gold.score} <span class="text-xs font-mono font-normal text-on-surface-variant">pts</span></p>
                                </div>
                                <div class="text-right">
                                    <span class="px-2.5 py-0.5 rounded-md bg-amber-100 text-amber-900 font-mono text-xs font-bold">${gold.percentage}%</span>
                                    <p class="text-[11px] text-tertiary font-semibold mt-0.5">Top Distinction (A+)</p>
                                </div>
                            </div>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="rounded-2xl bg-surface-container-low border border-dashed border-surface-container-high p-5 flex items-center justify-center min-h-[240px] order-1 md:order-2 text-outline text-xs">
                            Position Open
                        </div>
                    </c:otherwise>
                </c:choose>

                <!-- Bronze (#3) -->
                <c:choose>
                    <c:when test="${not empty leaderboardView.podiumBronze}">
                        <c:set var="bronze" value="${leaderboardView.podiumBronze}"/>
                        <div class="rounded-2xl bg-surface-container-lowest border border-surface-container-high p-5 shadow-sm hover:shadow-md transition-shadow relative overflow-hidden flex flex-col justify-between order-3 min-h-[260px]">
                            <div class="absolute top-0 right-0 left-0 h-1.5 bg-amber-600/40"></div>
                            <div>
                                <div class="flex items-center justify-between">
                                    <span class="inline-flex items-center gap-1 px-2.5 py-0.5 rounded-full bg-amber-50 text-amber-900 font-mono text-xs font-bold">
                                        <span class="material-symbols-outlined text-[16px] text-amber-700">military_tech</span>
                                        #3 Bronze Laureate
                                        <c:if test="${bronze.studentId == currentUser.userId}">(You)</c:if>
                                    </span>
                                    <span class="font-mono text-xs text-on-surface-variant">${bronze.studentIdentifier}</span>
                                </div>
                                <div class="mt-4 flex items-center gap-3">
                                    <div class="w-12 h-12 rounded-xl bg-amber-100/60 text-amber-900 flex items-center justify-center font-bold text-base">
                                        ${bronze.avatarInitials}
                                    </div>
                                    <div>
                                        <h3 class="font-display font-bold text-base text-on-surface leading-tight">${bronze.studentName}</h3>
                                        <p class="text-xs text-on-surface-variant mt-0.5">${bronze.department} &bull; ${bronze.cohort}</p>
                                    </div>
                                </div>
                            </div>
                            <div class="mt-4 pt-3 border-t border-surface-container flex items-center justify-between">
                                <div>
                                    <span class="text-[11px] uppercase tracking-wider text-outline font-medium">Final Score</span>
                                    <p class="font-display font-bold text-xl text-on-surface">${bronze.score} <span class="text-xs font-mono font-normal text-on-surface-variant">pts</span></p>
                                </div>
                                <div class="text-right">
                                    <span class="px-2 py-0.5 rounded-md bg-amber-100 text-amber-900 font-mono text-xs font-bold">${bronze.percentage}%</span>
                                    <p class="text-[11px] text-on-surface-variant mt-0.5">${bronze.durationFormatted}</p>
                                </div>
                            </div>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="rounded-2xl bg-surface-container-low border border-dashed border-surface-container-high p-5 flex items-center justify-center min-h-[220px] order-3 text-outline text-xs">
                            Position Open
                        </div>
                    </c:otherwise>
                </c:choose>

            </div>

            <!-- 3. FULL COHORT RANKINGS LEDGER TABLE -->
            <div class="rounded-3xl bg-surface-container-lowest border border-surface-container-high shadow-sm overflow-hidden flex flex-col">
                <div class="px-6 py-4 border-b border-surface-container flex flex-wrap items-center justify-between gap-3 bg-surface-bright">
                    <div class="flex items-center gap-2">
                        <span class="material-symbols-outlined text-primary text-[22px]">format_list_numbered</span>
                        <h3 class="font-display font-bold text-base text-on-surface">Official Cohort Rankings Ledger</h3>
                        <span class="px-2 py-0.5 rounded-full bg-surface-container text-on-surface font-mono text-xs font-semibold">
                            ${leaderboardView.totalParticipants} Examinees
                        </span>
                    </div>
                    <span class="text-xs text-on-surface-variant">Standard Competition Ranking (Tie-break by duration)</span>
                </div>

                <div class="overflow-x-auto">
                    <table class="w-full text-left border-collapse">
                        <thead>
                            <tr class="bg-surface-container-low/60 text-on-surface-variant text-[11px] uppercase tracking-wider font-semibold border-b border-surface-container">
                                <th class="py-3.5 px-4 text-center w-16">Rank</th>
                                <th class="py-3.5 px-4">Student / Candidate</th>
                                <th class="py-3.5 px-4">Points &amp; Progress</th>
                                <th class="py-3.5 px-4">Percentile &amp; Grade</th>
                                <th class="py-3.5 px-4">Pacing &amp; Accuracy</th>
                                <th class="py-3.5 px-4">Integrity Status</th>
                                <th class="py-3.5 px-4">Domain Strength</th>
                                <th class="py-3.5 px-4 text-right">Credential</th>
                            </tr>
                        </thead>
                        <tbody class="divide-y divide-surface-container text-xs">
                            <c:choose>
                                <c:when test="${not empty leaderboardView.entries}">
                                    <c:forEach var="entry" items="${leaderboardView.entries}">
                                        <tr class="hover:bg-surface-container-low/40 transition-colors ${entry.studentId == currentUser.userId ? 'bg-primary-fixed/20 font-medium' : ''}">
                                            <!-- Rank Column -->
                                            <td class="py-3.5 px-4 text-center font-mono">
                                                <c:choose>
                                                    <c:when test="${entry.rank == 1}">
                                                        <span class="w-7 h-7 rounded-full bg-amber-400 text-amber-950 font-bold inline-flex items-center justify-center shadow-xs">1</span>
                                                    </c:when>
                                                    <c:when test="${entry.rank == 2}">
                                                        <span class="w-7 h-7 rounded-full bg-slate-300 text-slate-800 font-bold inline-flex items-center justify-center shadow-xs">2</span>
                                                    </c:when>
                                                    <c:when test="${entry.rank == 3}">
                                                        <span class="w-7 h-7 rounded-full bg-amber-600/40 text-amber-950 font-bold inline-flex items-center justify-center shadow-xs">3</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="text-on-surface-variant font-semibold">#${entry.rank}</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>

                                            <!-- Student Details -->
                                            <td class="py-3.5 px-4">
                                                <div class="flex items-center gap-2.5">
                                                    <div class="w-8 h-8 rounded-full bg-surface-container text-on-surface flex items-center justify-center font-bold text-xs flex-shrink-0">
                                                        ${entry.avatarInitials}
                                                    </div>
                                                    <div class="flex flex-col">
                                                        <div class="flex items-center gap-1.5 flex-wrap">
                                                            <span class="font-bold text-on-surface">${entry.studentName}</span>
                                                            <c:if test="${entry.studentId == currentUser.userId}">
                                                                <span class="px-1.5 py-0.2 rounded bg-primary text-on-primary font-mono text-[10px] font-bold">You</span>
                                                            </c:if>
                                                        </div>
                                                        <span class="font-mono text-[11px] text-on-surface-variant">${entry.studentIdentifier}</span>
                                                    </div>
                                                </div>
                                            </td>

                                            <!-- Points & Progress -->
                                            <td class="py-3.5 px-4">
                                                <div class="flex flex-col gap-1 w-32">
                                                    <div class="flex items-center justify-between text-[11px]">
                                                        <span class="font-bold text-on-surface">${entry.score}</span>
                                                        <span class="text-on-surface-variant font-mono">${entry.percentage}%</span>
                                                    </div>
                                                    <div class="w-full h-1.5 bg-surface-container rounded-full overflow-hidden">
                                                        <div class="h-full rounded-full ${entry.percentage >= 80 ? 'bg-emerald-600' : (entry.percentage >= 50 ? 'bg-primary' : 'bg-rose-500')}" style="width: ${entry.percentage}%"></div>
                                                    </div>
                                                </div>
                                            </td>

                                            <!-- Percentile & Grade -->
                                            <td class="py-3.5 px-4">
                                                <div class="flex items-center gap-2">
                                                    <span class="px-2 py-0.5 rounded-md font-mono text-xs font-bold
                                                        ${entry.grade.contains('A') ? 'bg-emerald-100 text-emerald-800' : (entry.grade.contains('B') ? 'bg-indigo-100 text-indigo-800' : 'bg-rose-100 text-rose-800')}">
                                                        ${entry.grade}
                                                    </span>
                                                    <span class="font-mono text-xs text-on-surface-variant">${entry.percentile}th %ile</span>
                                                </div>
                                            </td>

                                            <!-- Pacing & Accuracy -->
                                            <td class="py-3.5 px-4 font-mono text-xs text-on-surface-variant">
                                                <div>${entry.durationFormatted}</div>
                                                <div class="text-[11px] text-outline">${entry.accuracyPercentage}% accuracy</div>
                                            </td>

                                            <!-- Integrity Status -->
                                            <td class="py-3.5 px-4">
                                                <c:choose>
                                                    <c:when test="${entry.integrityIndex >= 90}">
                                                        <span class="inline-flex items-center gap-1 px-2 py-0.5 rounded-full bg-emerald-50 text-emerald-800 text-[11px] font-semibold border border-emerald-200">
                                                            <span class="w-1.5 h-1.5 rounded-full bg-emerald-600"></span>
                                                            Cleared (${entry.integrityIndex}%)
                                                        </span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="inline-flex items-center gap-1 px-2 py-0.5 rounded-full bg-amber-50 text-amber-800 text-[11px] font-semibold border border-amber-200">
                                                            <span class="w-1.5 h-1.5 rounded-full bg-amber-600"></span>
                                                            Review (${entry.integrityIndex}%)
                                                        </span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>

                                            <!-- Domain Strength -->
                                            <td class="py-3.5 px-4 text-xs font-medium text-on-surface truncate max-w-[150px]">
                                                ${entry.domainStrength}
                                            </td>

                                            <!-- Action Column -->
                                            <td class="py-3.5 px-4 text-right">
                                                <c:choose>
                                                    <c:when test="${entry.studentId == currentUser.userId && entry.certificateEligible}">
                                                        <button type="button" onclick="document.getElementById('certificate-modal').classList.remove('hidden')" class="px-3 py-1.5 rounded-lg bg-primary/10 hover:bg-primary text-primary hover:text-on-primary font-semibold text-xs transition-all">
                                                            View Certificate
                                                        </button>
                                                    </c:when>
                                                    <c:when test="${entry.studentId == currentUser.userId}">
                                                        <a href="${pageContext.request.contextPath}/student/results" class="px-3 py-1.5 rounded-lg bg-surface-container hover:bg-surface-container-high text-on-surface font-semibold text-xs transition-all">
                                                            View Scorecard
                                                        </a>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="text-xs text-outline italic">Verified Examinee</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <tr>
                                        <td colspan="8" class="p-12 text-center text-on-surface-variant">
                                            No completed examination attempts recorded for this assessment.
                                        </td>
                                    </tr>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>
                </div>
            </div>

            <!-- 4. COHORT STATISTICAL DISTRIBUTION (Bell Curve / Quartiles) -->
            <div class="rounded-3xl bg-surface-container-lowest border border-surface-container-high p-6 shadow-sm flex flex-col gap-4">
                <div class="flex items-center justify-between pb-3 border-b border-surface-container">
                    <div class="flex items-center gap-2">
                        <span class="material-symbols-outlined text-primary text-[22px]">ssid_chart</span>
                        <h3 class="font-display font-bold text-base text-on-surface">Empirical Cohort Score Distribution</h3>
                    </div>
                    <span class="text-xs text-on-surface-variant font-medium">Class Mean: <strong>${leaderboardView.classAveragePercentage}%</strong></span>
                </div>

                <div class="grid grid-cols-1 sm:grid-cols-4 gap-4 text-center">
                    <div class="p-4 rounded-2xl bg-surface-container-low border border-surface-container">
                        <span class="text-[11px] font-semibold uppercase tracking-wider text-outline">Lower Quartile (Q1)</span>
                        <p class="font-display font-bold text-xl text-on-surface mt-1">${leaderboardView.lowerQuartileScore} pts</p>
                        <span class="text-[11px] text-on-surface-variant">25th percentile</span>
                    </div>
                    <div class="p-4 rounded-2xl bg-surface-container-low border border-surface-container">
                        <span class="text-[11px] font-semibold uppercase tracking-wider text-outline">Cohort Median (Q2)</span>
                        <p class="font-display font-bold text-xl text-primary mt-1">${leaderboardView.medianScore} pts</p>
                        <span class="text-[11px] text-on-surface-variant">50th percentile</span>
                    </div>
                    <div class="p-4 rounded-2xl bg-surface-container-low border border-surface-container">
                        <span class="text-[11px] font-semibold uppercase tracking-wider text-outline">Upper Quartile (Q3)</span>
                        <p class="font-display font-bold text-xl text-tertiary mt-1">${leaderboardView.upperQuartileScore} pts</p>
                        <span class="text-[11px] text-on-surface-variant">75th percentile</span>
                    </div>
                    <div class="p-4 rounded-2xl bg-surface-container-low border border-surface-container">
                        <span class="text-[11px] font-semibold uppercase tracking-wider text-outline">Top Score</span>
                        <p class="font-display font-bold text-xl text-amber-800 mt-1">${leaderboardView.topScore} pts</p>
                        <span class="text-[11px] text-on-surface-variant">Cohort benchmark</span>
                    </div>
                </div>
            </div>

        </main>
    </div>

    <!-- 5. VERIFIED CERTIFICATE MODAL OVERLAY -->
    <c:if test="${not empty leaderboardView.currentUserCertificate}">
        <c:set var="cert" value="${leaderboardView.currentUserCertificate}"/>
        <div id="certificate-modal" class="fixed inset-0 bg-slate-900/60 backdrop-blur-sm z-50 flex items-center justify-center p-3 sm:p-4 overflow-y-auto ${openCertificateModal ? '' : 'hidden'}" onclick="if(event.target===this) this.classList.add('hidden')">
            <div class="relative w-full max-w-4xl bg-surface-container-lowest rounded-3xl shadow-2xl border border-surface-container-high my-6 overflow-hidden flex flex-col transition-all">

                <!-- Modal Header Bar -->
                <div class="flex items-center justify-between px-6 py-4 border-b border-surface-container bg-surface-bright">
                    <div class="flex items-center gap-3">
                        <div class="w-9 h-9 rounded-xl bg-tertiary/10 text-tertiary flex items-center justify-center">
                            <span class="material-symbols-outlined text-[22px]">verified</span>
                        </div>
                        <div>
                            <div class="flex items-center gap-2">
                                <h3 class="font-display font-bold text-base text-on-surface leading-tight">Official Academic Distinction Certificate</h3>
                                <span class="inline-flex items-center gap-1 px-2.5 py-0.5 rounded-full bg-tertiary/10 text-tertiary font-mono text-[11px] font-bold">
                                    <span class="w-1.5 h-1.5 rounded-full bg-tertiary"></span>
                                    Cryptographically Certified
                                </span>
                            </div>
                            <p class="text-xs text-on-surface-variant">Issued by Faculty Board of Assessors &amp; Office of Academic Integrity</p>
                        </div>
                    </div>
                    <button type="button" aria-label="Close modal" onclick="document.getElementById('certificate-modal').classList.add('hidden')" class="p-2 text-on-surface-variant hover:text-on-surface hover:bg-surface-container rounded-lg transition-colors">
                        <span class="material-symbols-outlined text-[20px]">close</span>
                    </button>
                </div>

                <!-- Certificate Document Parchment Frame -->
                <div class="p-6 sm:p-10 bg-surface-container-lowest overflow-y-auto max-h-[calc(85vh-140px)]">
                    <div class="relative rounded-2xl border-2 border-primary/20 bg-gradient-to-b from-surface via-surface-container-lowest to-surface-container-low/40 p-6 sm:p-10 shadow-inner overflow-hidden text-center flex flex-col items-center">

                        <!-- Corner Border Accents -->
                        <div class="absolute top-3 left-3 w-6 h-6 border-t-2 border-l-2 border-primary/30 rounded-tl pointer-events-none"></div>
                        <div class="absolute top-3 right-3 w-6 h-6 border-t-2 border-r-2 border-primary/30 rounded-tr pointer-events-none"></div>
                        <div class="absolute bottom-3 left-3 w-6 h-6 border-b-2 border-l-2 border-primary/30 rounded-bl pointer-events-none"></div>
                        <div class="absolute bottom-3 right-3 w-6 h-6 border-b-2 border-r-2 border-primary/30 rounded-br pointer-events-none"></div>

                        <!-- Top Authority Emblem -->
                        <div class="w-16 h-16 rounded-2xl bg-gradient-to-tr from-primary to-secondary text-on-primary flex items-center justify-center shadow-md mb-2">
                            <span class="material-symbols-outlined text-[34px]">school</span>
                        </div>
                        <span class="font-mono text-[11px] uppercase tracking-widest text-primary font-bold">QuizTrack Center for Academic Excellence</span>
                        <span class="text-xs text-on-surface-variant font-medium mt-0.5">Automated Proctoring &amp; Assessment Protocol</span>

                        <!-- Certificate Title -->
                        <h2 class="font-display text-xl sm:text-2xl font-bold text-on-surface mt-4 tracking-tight">
                            Certificate of Academic Distinction &amp; Proctor Integrity
                        </h2>
                        <p class="text-xs text-on-surface-variant italic mt-1 max-w-xl">
                            Recognizing exceptional curricular achievement, analytical proficiency, and verified integrity.
                        </p>

                        <!-- Recipient Name & Identifier -->
                        <div class="w-full max-w-xl py-4 border-y border-outline-variant/30 my-4 flex flex-col items-center">
                            <span class="text-[11px] font-semibold uppercase tracking-wider text-outline">This Distinction Is Conferred Upon</span>
                            <h3 class="font-display text-2xl sm:text-3xl font-bold text-primary mt-1 tracking-tight">${cert.studentName}</h3>
                            <div class="flex items-center gap-2 mt-1">
                                <span class="font-mono text-xs px-2.5 py-0.5 rounded-full bg-surface-container text-on-surface font-semibold">ID: ${cert.studentIdentifier}</span>
                                <span class="text-outline">&bull;</span>
                                <span class="text-xs text-on-surface-variant font-medium">${cert.subjectCode}: ${cert.subjectName}</span>
                            </div>
                        </div>

                        <!-- Core Distinction Score Strip -->
                        <div class="grid grid-cols-2 sm:grid-cols-4 gap-3 w-full max-w-xl my-2">
                            <div class="p-3 bg-surface-container-low rounded-xl">
                                <span class="text-[10px] font-semibold uppercase text-outline">Marks Obtained</span>
                                <p class="font-display font-bold text-base text-on-surface">${cert.score} / ${cert.maxScore}</p>
                            </div>
                            <div class="p-3 bg-surface-container-low rounded-xl">
                                <span class="text-[10px] font-semibold uppercase text-outline">Aggregate Grade</span>
                                <p class="font-display font-bold text-base text-primary">${cert.percentage}% (${cert.grade})</p>
                            </div>
                            <div class="p-3 bg-surface-container-low rounded-xl">
                                <span class="text-[10px] font-semibold uppercase text-outline">Cohort Standing</span>
                                <p class="font-display font-bold text-base text-tertiary">Top ${cert.percentile}%ile</p>
                            </div>
                            <div class="p-3 bg-surface-container-low rounded-xl">
                                <span class="text-[10px] font-semibold uppercase text-outline">Proctor Standing</span>
                                <p class="font-display font-bold text-base text-on-surface">${cert.integrityIndex}% Cleared</p>
                            </div>
                        </div>

                        <!-- Public Trust Verification Bar -->
                        <div class="w-full max-w-xl mt-4 p-4 rounded-xl bg-surface-container-low border border-surface-container flex flex-col sm:flex-row items-center justify-between gap-4 text-left">
                            <div class="flex flex-col gap-1 w-full overflow-hidden">
                                <div class="flex items-center justify-between text-xs">
                                    <span class="font-semibold text-outline uppercase tracking-wider text-[10px]">Certificate ID:</span>
                                    <span class="font-mono font-bold text-primary">${cert.certificateId}</span>
                                </div>
                                <div class="flex items-center justify-between text-xs">
                                    <span class="font-semibold text-outline uppercase tracking-wider text-[10px]">SHA-256 Digest:</span>
                                    <span class="font-mono text-[11px] text-on-surface-variant truncate max-w-[240px]" title="${cert.certificateHash}">${cert.certificateHash}</span>
                                </div>
                                <div class="flex items-center justify-between text-xs">
                                    <span class="font-semibold text-outline uppercase tracking-wider text-[10px]">Certified Date:</span>
                                    <span class="font-mono text-on-surface">${cert.certifiedAt}</span>
                                </div>
                            </div>
                        </div>

                        <!-- Signatures Row -->
                        <div class="grid grid-cols-2 gap-8 w-full max-w-xl mt-6 pt-4 border-t border-outline-variant/30 text-center">
                            <div class="flex flex-col items-center">
                                <div class="font-serif italic text-on-surface text-base mb-1 select-none">${cert.leadInstructor}</div>
                                <div class="w-32 h-0.5 bg-outline-variant/60 mb-1"></div>
                                <span class="font-semibold text-xs text-on-surface">${cert.leadInstructor}</span>
                                <span class="text-[11px] text-on-surface-variant">Course Lead &amp; Examiner</span>
                            </div>
                            <div class="flex flex-col items-center">
                                <div class="font-serif italic text-on-surface text-base mb-1 select-none">${cert.academicDean}</div>
                                <div class="w-32 h-0.5 bg-outline-variant/60 mb-1"></div>
                                <span class="font-semibold text-xs text-on-surface">${cert.academicDean}</span>
                                <span class="text-[11px] text-on-surface-variant">Dean of Academic Integrity</span>
                            </div>
                        </div>

                    </div>
                </div>

                <!-- Modal Action Controls Footer -->
                <div class="px-6 py-4 bg-surface-container-low border-t border-surface-container flex flex-wrap items-center justify-between gap-3">
                    <div class="flex items-center gap-2">
                        <button type="button" onclick="navigator.clipboard.writeText(window.location.origin + '${pageContext.request.contextPath}/verify/certificate?id=${cert.certificateId}'); alert('Public verification link copied to clipboard!');" class="inline-flex items-center gap-1.5 px-3.5 py-2 rounded-xl bg-surface-container-lowest text-on-surface hover:bg-surface-container-high transition-colors text-xs font-semibold border border-surface-container-high shadow-xs">
                            <span class="material-symbols-outlined text-[16px] text-primary">link</span>
                            <span>Copy Verification Link</span>
                        </button>
                    </div>
                    <div class="flex items-center gap-2">
                        <button type="button" onclick="window.print()" class="inline-flex items-center gap-1.5 px-4 py-2 rounded-xl bg-primary text-on-primary hover:bg-primary-container font-semibold text-xs transition-all shadow-sm">
                            <span class="material-symbols-outlined text-[16px]">print</span>
                            <span>Print / Save PDF</span>
                        </button>
                        <button type="button" onclick="document.getElementById('certificate-modal').classList.add('hidden')" class="px-4 py-2 rounded-xl bg-surface-container text-on-surface hover:bg-surface-container-high font-semibold text-xs transition-colors">
                            Close
                        </button>
                    </div>
                </div>

            </div>
        </div>
    </c:if>

    <script>
        // Keyboard ESC to close modal
        document.addEventListener('keydown', function(e) {
            if (e.key === 'Escape') {
                const modal = document.getElementById('certificate-modal');
                if (modal && !modal.classList.contains('hidden')) {
                    modal.classList.add('hidden');
                }
            }
        });
    </script>
</body>
</html>
