<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8"/>
    <meta content="width=device-width, initial-scale=1.0" name="viewport"/>
    <meta content="web_standard" name="shell-type"/>
    <title>Candidate Assessment Portal | QuizTrack</title>

    <!-- Google Fonts & Material Symbols matching Stitch -->
    <link href="https://fonts.googleapis.com" rel="preconnect"/>
    <link crossorigin="" href="https://fonts.gstatic.com" rel="preconnect"/>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=JetBrains+Mono:wght@400;500;600&family=Plus+Jakarta+Sans:wght@600;700;800&display=swap" rel="stylesheet"/>
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200" rel="stylesheet"/>
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet"/>

    <style>
        @layer base {
            html, body { margin: 0; padding: 0; }
            body { overscroll-behavior: none; }
            main > :first-child { margin-top: 0 !important; }
            main > :last-child { margin-bottom: 0 !important; }
        }
        ::-webkit-scrollbar { display: none; }
    </style>

    <!-- Tailwind CDN with Stitch Palette -->
    <script src="https://cdn.tailwindcss.com"></script>
    <script id="tailwind-config">
        tailwind.config = {
            darkMode: "class",
            theme: {
                extend: {
                    colors: {
                        "primary": "#3525cd",
                        "primary-container": "#4f46e5",
                        "on-primary": "#ffffff",
                        "primary-fixed": "#e2dfff",
                        "primary-fixed-dim": "#c3c0ff",
                        "on-primary-fixed-variant": "#3323cc",
                        "secondary": "#4648d4",
                        "secondary-container": "#6063ee",
                        "on-secondary": "#ffffff",
                        "tertiary": "#005338",
                        "tertiary-container": "#006e4b",
                        "tertiary-fixed": "#6ffbbe",
                        "tertiary-fixed-dim": "#4edea3",
                        "on-tertiary-container": "#67f4b7",
                        "error": "#ba1a1a",
                        "error-container": "#ffdad6",
                        "on-error-container": "#93000a",
                        "surface": "#f8f9ff",
                        "background": "#f8f9ff",
                        "on-surface": "#0b1c30",
                        "on-surface-variant": "#464555",
                        "outline": "#777587",
                        "outline-variant": "#c7c4d8",
                        "surface-container-lowest": "#ffffff",
                        "surface-container-low": "#eff4ff",
                        "surface-container": "#e5eeff",
                        "surface-container-high": "#dce9ff",
                        "surface-container-highest": "#d3e4fe",
                        "inverse-surface": "#213145",
                        "inverse-on-surface": "#eaf1ff"
                    },
                    borderRadius: {
                        "DEFAULT": "0.25rem",
                        "lg": "0.5rem",
                        "xl": "0.75rem",
                        "2xl": "1rem",
                        "full": "9999px"
                    },
                    spacing: {
                        "gutter": "1.5rem",
                        "gutter-sm": "1rem",
                        "space-xs": "0.25rem",
                        "space-sm": "0.5rem",
                        "space-md": "1rem",
                        "space-lg": "1.5rem",
                        "space-xl": "2rem"
                    },
                    fontFamily: {
                        "body-sm": ["Inter"],
                        "body-md": ["Inter"],
                        "body-lg": ["Inter"],
                        "title-md": ["Inter"],
                        "title-lg": ["Plus Jakarta Sans"],
                        "headline-sm": ["Plus Jakarta Sans"],
                        "headline-md": ["Plus Jakarta Sans"],
                        "headline-lg": ["Plus Jakarta Sans"],
                        "display": ["Plus Jakarta Sans"],
                        "code-telemetry": ["JetBrains Mono"]
                    }
                }
            }
        };
    </script>
</head>
<body class="bg-background font-body-md text-on-surface antialiased">

    <!-- Top Universal Header -->
    <jsp:include page="components/header.jsp"/>

    <main class="w-full pt-16 bg-surface min-h-screen">
        <div class="flex flex-col w-full">
            
            <!-- Sub-Header Command Bar / Secondary Telemetry Strip -->
            <div class="w-full bg-surface-container-lowest px-4 sm:px-gutter py-space-sm shadow-sm flex flex-wrap items-center justify-between gap-space-md border-b border-surface-container-high/40">
                <div class="flex items-center gap-space-lg flex-wrap">
                    <div class="flex items-center gap-space-xs bg-surface-container-low px-space-md py-space-xs rounded-full">
                        <span class="w-2.5 h-2.5 rounded-full bg-tertiary-container animate-ping"></span>
                        <span class="font-label-md text-label-md text-on-surface font-semibold">System Ready &amp; Verified</span>
                    </div>
                    <div class="hidden sm:flex items-center gap-space-xs text-on-surface-variant font-label-md text-label-md">
                        <span class="material-symbols-outlined text-[16px] text-primary">calendar_today</span>
                        <span><c:out value="${dashboardData.semester != null ? dashboardData.semester : 'Spring 2025 Semester'}"/></span>
                    </div>
                    <div class="h-4 w-px bg-surface-container-high hidden md:block"></div>
                    <div class="flex items-center gap-space-md">
                        <button type="button" class="flex items-center gap-space-xs text-on-surface-variant hover:text-primary transition-colors font-label-md text-label-md" onclick="openPreflightModal()">
                            <span class="material-symbols-outlined text-[16px]">sensors</span>
                            <span>System Hardware Pre-Check</span>
                        </button>
                        <button type="button" class="flex items-center gap-space-xs text-on-surface-variant hover:text-primary transition-colors font-label-md text-label-md" onclick="openPreflightModal()">
                            <span class="material-symbols-outlined text-[16px]">policy</span>
                            <span>Integrity Rules v4.2</span>
                        </button>
                    </div>
                </div>

                <!-- Profile Info Strip -->
                <div class="flex items-center gap-space-md ml-auto">
                    <div class="text-right">
                        <div class="font-title-md text-title-md text-on-surface leading-tight font-semibold">
                            <c:out value="${sessionScope.userFullName != null ? sessionScope.userFullName : 'Alex Mercer'}"/>
                        </div>
                        <div class="font-code-telemetry text-code-telemetry text-on-surface-variant">
                            <c:out value="${sessionScope.userIdentifier != null ? sessionScope.userIdentifier : 'CS-2022-041'}"/> • Dept of Computer Science
                        </div>
                    </div>
                    <div class="relative">
                        <div class="w-10 h-10 rounded-full bg-primary-container text-on-primary flex items-center justify-center font-title-lg text-title-lg shadow-sm font-bold">
                            <c:choose>
                                <c:when test="${not empty sessionScope.userFullName}">
                                    <c:out value="${sessionScope.userFullName.substring(0, 1)}"/>
                                </c:when>
                                <c:otherwise>AM</c:otherwise>
                            </c:choose>
                        </div>
                        <span class="absolute bottom-0 right-0 w-3 h-3 rounded-full bg-tertiary-container ring-2 ring-surface-container-lowest"></span>
                    </div>
                </div>
            </div>

            <!-- Primary Workspace Content -->
            <div class="w-full px-4 sm:px-gutter py-space-lg flex flex-col gap-space-xl max-w-7xl mx-auto">
                
                <!-- Section 1: Urgent Action Chamber Banner -->
                <div class="relative overflow-hidden rounded-2xl bg-gradient-to-r from-primary to-secondary p-6 sm:p-space-xl text-on-primary shadow-xl">
                    <!-- Ambient Visual Layer -->
                    <div class="absolute -right-16 -top-16 w-80 h-80 rounded-full bg-white/10 blur-3xl pointer-events-none"></div>
                    <div class="absolute right-12 bottom-0 opacity-10 pointer-events-none hidden lg:block">
                        <span class="material-symbols-outlined text-[180px]">security_update_good</span>
                    </div>

                    <div class="relative z-10 flex flex-col lg:flex-row lg:items-center justify-between gap-space-xl">
                        <div class="flex flex-col gap-space-xs max-w-3xl">
                            <div class="flex items-center gap-space-sm flex-wrap">
                                <span class="bg-error-container text-on-error-container font-label-sm text-label-sm px-space-sm py-0.5 rounded-full flex items-center gap-1 font-bold">
                                    <span class="w-2 h-2 rounded-full bg-error animate-pulse"></span> LIVE EXAM PORTAL
                                </span>
                                <span class="bg-surface-container-lowest/20 backdrop-blur-md text-on-primary font-code-telemetry text-code-telemetry px-space-sm py-0.5 rounded-full">
                                    <c:out value="${dashboardData.cohortCode != null ? dashboardData.cohortCode : 'COHORT CS-2025-A'}"/>
                                </span>
                            </div>
                            <h1 class="font-display text-3xl sm:text-4xl lg:text-5xl text-on-primary font-bold tracking-tight">
                                Welcome back, <c:out value="${sessionScope.userFullName != null ? sessionScope.userFullName.split(' ')[0] : 'Alex'}"/>!
                            </h1>
                            <p class="font-body-lg text-body-lg text-primary-fixed leading-relaxed">
                                <strong class="text-white font-semibold">
                                    <c:out value="${dashboardData.activeQuiz != null ? dashboardData.activeQuiz.title : 'CS402 Midterm Exam'}"/>
                                </strong> is currently <strong class="text-white font-semibold">LIVE</strong> and authenticated for your workstation. 
                                Candidate admission window closes in <span class="font-code-telemetry font-bold text-tertiary-fixed" id="countdown">01h 44m 32s</span>.
                            </p>
                        </div>
                        <div class="flex flex-col sm:flex-row items-stretch sm:items-center gap-space-md shrink-0">
                            <button type="button" class="flex items-center justify-center gap-space-sm px-6 py-3.5 bg-surface-container-lowest text-primary hover:bg-surface-container-low transition-all duration-200 rounded-xl shadow-md font-title-md text-title-md font-bold hover:scale-[1.02] active:scale-[0.98]" onclick="openPreflightModal(${dashboardData.activeQuiz != null ? dashboardData.activeQuiz.quizId : 1})">
                                <span class="material-symbols-outlined text-[20px]" style="font-variation-settings: 'FILL' 1;">play_circle</span>
                                <span>Review Instructions &amp; Launch Pre-Flight Check</span>
                            </button>
                        </div>
                    </div>
                </div>

                <!-- Section 2: Student Diagnostic KPIs (Bento Rhythm) -->
                <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-space-md">
                    <!-- Metric 1: Attempted -->
                    <div class="bg-surface-container-lowest rounded-xl p-space-lg shadow-sm border border-surface-container-high/40 flex flex-col justify-between hover:shadow-md transition-shadow">
                        <div class="flex items-center justify-between mb-space-sm">
                            <span class="font-label-md text-label-md text-on-surface-variant uppercase tracking-wider font-semibold">Quizzes Attempted</span>
                            <div class="w-9 h-9 rounded-lg bg-surface-container-low text-primary flex items-center justify-center">
                                <span class="material-symbols-outlined text-[20px]">assignment_turned_in</span>
                            </div>
                        </div>
                        <div>
                            <div class="flex items-baseline gap-space-xs">
                                <span class="font-headline-lg text-3xl font-bold text-on-surface">
                                    <c:out value="${dashboardData.quizzesAttemptedCount > 0 ? dashboardData.quizzesAttemptedCount : 14}"/>
                                </span>
                                <span class="font-body-md text-body-md text-on-surface-variant">
                                    / <c:out value="${dashboardData.totalScheduledQuizzes > 0 ? dashboardData.totalScheduledQuizzes : 16}"/> Scheduled
                                </span>
                            </div>
                            <div class="mt-space-sm flex items-center gap-space-xs text-tertiary font-label-sm text-label-sm font-medium">
                                <span class="material-symbols-outlined text-[14px]">check_circle</span>
                                <span>All mandatory attempts logged</span>
                            </div>
                        </div>
                    </div>

                    <!-- Metric 2: Cumulative GPA -->
                    <div class="bg-surface-container-lowest rounded-xl p-space-lg shadow-sm border border-surface-container-high/40 flex flex-col justify-between hover:shadow-md transition-shadow">
                        <div class="flex items-center justify-between mb-space-sm">
                            <span class="font-label-md text-label-md text-on-surface-variant uppercase tracking-wider font-semibold">Cumulative Score</span>
                            <div class="w-9 h-9 rounded-lg bg-surface-container-low text-primary flex items-center justify-center">
                                <span class="material-symbols-outlined text-[20px]">grade</span>
                            </div>
                        </div>
                        <div>
                            <div class="flex items-baseline gap-space-xs">
                                <span class="font-headline-lg text-3xl font-bold text-on-surface">
                                    <c:out value="${dashboardData.cumulativeScore > 0 ? dashboardData.cumulativeScore : 86.2}"/>%
                                </span>
                                <span class="bg-surface-container px-space-xs py-0.5 rounded font-label-md text-label-md text-primary font-bold">
                                    <c:out value="${dashboardData.gradeLetter != null ? dashboardData.gradeLetter : 'Grade A-'}"/>
                                </span>
                            </div>
                            <div class="mt-space-sm flex items-center gap-space-xs text-tertiary font-label-sm text-label-sm font-medium">
                                <span class="material-symbols-outlined text-[14px]">trending_up</span>
                                <span>+3.4% from Mid-Semester baseline</span>
                            </div>
                        </div>
                    </div>

                    <!-- Metric 3: Standing / Percentile -->
                    <div class="bg-surface-container-lowest rounded-xl p-space-lg shadow-sm border border-surface-container-high/40 flex flex-col justify-between hover:shadow-md transition-shadow">
                        <div class="flex items-center justify-between mb-space-sm">
                            <span class="font-label-md text-label-md text-on-surface-variant uppercase tracking-wider font-semibold">Cohort Standing</span>
                            <div class="w-9 h-9 rounded-lg bg-surface-container-low text-primary flex items-center justify-center">
                                <span class="material-symbols-outlined text-[20px]">leaderboard</span>
                            </div>
                        </div>
                        <div>
                            <div class="flex items-baseline gap-space-xs">
                                <span class="font-headline-lg text-3xl font-bold text-on-surface">
                                    <c:out value="${dashboardData.cohortPercentile > 0 ? dashboardData.cohortPercentile : 94.2}"/><sup class="text-lg font-normal">th</sup>
                                </span>
                                <span class="font-body-md text-body-md text-on-surface-variant">Percentile</span>
                            </div>
                            <div class="mt-space-sm flex items-center gap-space-xs font-label-sm text-label-sm text-on-surface-variant">
                                <span class="font-code-telemetry text-code-telemetry px-1.5 py-0.5 bg-surface-container rounded text-primary font-bold">
                                    Rank #<c:out value="${dashboardData.cohortRank > 0 ? dashboardData.cohortRank : 3}"/>
                                </span>
                                <span>in CS402 (128 Students)</span>
                            </div>
                        </div>
                    </div>

                    <!-- Metric 4: Academic Integrity -->
                    <div class="bg-surface-container-lowest rounded-xl p-space-lg shadow-sm border border-surface-container-high/40 flex flex-col justify-between hover:shadow-md transition-shadow">
                        <div class="flex items-center justify-between mb-space-sm">
                            <span class="font-label-md text-label-md text-on-surface-variant uppercase tracking-wider font-semibold">Integrity Index</span>
                            <div class="w-9 h-9 rounded-lg bg-surface-container-low text-tertiary flex items-center justify-center">
                                <span class="material-symbols-outlined text-[20px]">verified</span>
                            </div>
                        </div>
                        <div>
                            <div class="flex items-baseline gap-space-xs">
                                <span class="font-headline-lg text-3xl font-bold text-tertiary-container">
                                    <c:out value="${dashboardData.integrityIndex > 0 ? dashboardData.integrityIndex : 99.1}"/>%
                                </span>
                                <span class="bg-surface-container-low text-tertiary-container px-space-xs py-0.5 rounded font-label-sm text-label-sm font-semibold">
                                    <c:out value="${dashboardData.integrityTier != null ? dashboardData.integrityTier : 'Tier 1'}"/>
                                </span>
                            </div>
                            <div class="mt-space-sm flex items-center gap-space-xs text-tertiary font-label-sm text-label-sm font-medium">
                                <span class="material-symbols-outlined text-[14px]">shield</span>
                                <span>Zero flagged incidents (14 audits)</span>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Main Grid Content Area: Available Deck (Left) & Diagnostics / Summary (Right) -->
                <div class="grid grid-cols-1 lg:grid-cols-12 gap-space-xl items-start">
                    
                    <!-- Primary Column (Left 8 Cols): Available & Upcoming Quizzes Interactive Deck -->
                    <div class="lg:col-span-8 flex flex-col gap-space-lg">
                        <div class="flex items-center justify-between flex-wrap gap-space-sm">
                            <div>
                                <h2 class="font-headline-md text-2xl font-bold text-on-surface tracking-tight">Active &amp; Scheduled Assessments</h2>
                                <p class="font-body-sm text-body-sm text-on-surface-variant">Live proctored exams and upcoming departmental certification modules</p>
                            </div>
                            <div class="flex items-center gap-space-xs bg-surface-container-low p-1 rounded-xl">
                                <button type="button" class="px-space-md py-1 bg-surface-container-lowest text-primary font-label-sm text-label-sm font-bold rounded-lg shadow-sm" onclick="filterQuizDeck('all', this)">
                                    All (<c:out value="${dashboardData.assignedQuizzes.size()}"/>)
                                </button>
                                <button type="button" class="px-space-md py-1 text-on-surface-variant hover:text-on-surface font-label-sm text-label-sm font-medium rounded-lg" onclick="filterQuizDeck('live', this)">
                                    Live (<c:out value="${dashboardData.readyToLaunchCount}"/>)
                                </button>
                                <button type="button" class="px-space-md py-1 text-on-surface-variant hover:text-on-surface font-label-sm text-label-sm font-medium rounded-lg" onclick="filterQuizDeck('upcoming', this)">
                                    Upcoming (<c:out value="${dashboardData.scheduledAheadCount}"/>)
                                </button>
                            </div>
                        </div>

                        <!-- Assessments Cards Container -->
                        <div class="flex flex-col gap-space-md" id="quiz-deck-container">
                            <c:forEach var="quizCard" items="${dashboardData.assignedQuizzes}">
                                <c:choose>
                                    <c:when test="${quizCard.status == 'ACTIVE' && quizCard.attemptStatus != 'SUBMITTED'}">
                                        <%-- LIVE READY CARD --%>
                                        <div class="quiz-card-item bg-surface-container-lowest rounded-2xl p-6 sm:p-space-xl shadow-md border-2 border-primary/20 hover:shadow-lg transition-all duration-200 relative overflow-hidden group" data-category="live">
                                            <div class="absolute top-0 left-0 bottom-0 w-2 bg-primary"></div>
                                            <div class="flex flex-col gap-space-md pl-space-xs">
                                                <div class="flex items-start justify-between gap-space-md flex-wrap">
                                                    <div class="flex flex-col">
                                                        <div class="flex items-center gap-space-sm mb-space-xs flex-wrap">
                                                            <span class="bg-primary text-on-primary font-code-telemetry text-label-sm px-2.5 py-0.5 rounded font-bold uppercase tracking-wider">
                                                                <c:out value="${quizCard.quizCode}"/>
                                                            </span>
                                                            <span class="bg-error-container text-on-error-container font-label-sm text-label-sm px-2.5 py-0.5 rounded-full flex items-center gap-1 font-semibold">
                                                                <span class="w-1.5 h-1.5 rounded-full bg-error animate-ping"></span> 
                                                                <c:out value="${quizCard.badgeText}"/>
                                                            </span>
                                                            <span class="font-label-sm text-label-sm text-on-surface-variant hidden sm:inline">
                                                                Instructor: <c:out value="${quizCard.teacherName}"/>
                                                            </span>
                                                        </div>
                                                        <h3 class="font-headline-sm text-xl font-bold text-on-surface">
                                                            <c:out value="${quizCard.title}"/>
                                                        </h3>
                                                    </div>
                                                    <div class="text-right">
                                                        <span class="font-code-telemetry text-2xl text-primary font-bold">
                                                            <fmt:formatNumber value="${quizCard.totalMarks}" maxFractionDigits="0"/>
                                                        </span>
                                                        <span class="font-label-sm text-label-sm text-on-surface-variant block font-medium">Total Points</span>
                                                    </div>
                                                </div>

                                                <!-- Exam Parameters Badge Strip -->
                                                <div class="grid grid-cols-2 sm:grid-cols-4 gap-space-sm py-space-sm bg-surface-container-low rounded-xl px-space-md">
                                                    <div class="flex items-center gap-space-xs">
                                                        <span class="material-symbols-outlined text-[18px] text-primary">timer</span>
                                                        <div>
                                                            <span class="font-label-sm text-label-sm text-on-surface-variant block">Time Limit</span>
                                                            <span class="font-label-md text-label-md text-on-surface font-semibold"><c:out value="${quizCard.durationMinutes}"/> Minutes</span>
                                                        </div>
                                                    </div>
                                                    <div class="flex items-center gap-space-xs">
                                                        <span class="material-symbols-outlined text-[18px] text-primary">help_outline</span>
                                                        <div>
                                                            <span class="font-label-sm text-label-sm text-on-surface-variant block">Structure</span>
                                                            <span class="font-label-md text-label-md text-on-surface font-semibold"><c:out value="${quizCard.totalQuestions}"/> Questions</span>
                                                        </div>
                                                    </div>
                                                    <div class="flex items-center gap-space-xs">
                                                        <span class="material-symbols-outlined text-[18px] text-error">warning</span>
                                                        <div>
                                                            <span class="font-label-sm text-label-sm text-on-surface-variant block">Penalty Rule</span>
                                                            <span class="font-label-md text-label-md text-error font-semibold">
                                                                <c:choose>
                                                                    <c:when test="${quizCard.negativeMarking}">-<c:out value="${quizCard.negativeMarkValue}"/> Negative</c:when>
                                                                    <c:otherwise>No Negative</c:otherwise>
                                                                </c:choose>
                                                            </span>
                                                        </div>
                                                    </div>
                                                    <div class="flex items-center gap-space-xs">
                                                        <span class="material-symbols-outlined text-[18px] text-tertiary">lock</span>
                                                        <div>
                                                            <span class="font-label-sm text-label-sm text-on-surface-variant block">Proctor Level</span>
                                                            <span class="font-label-md text-label-md text-on-surface font-semibold">AI + Human Guard</span>
                                                        </div>
                                                    </div>
                                                </div>

                                                <!-- Card Bottom Bar -->
                                                <div class="flex items-center justify-between pt-space-xs flex-wrap gap-space-md">
                                                    <div class="flex items-center gap-space-sm text-on-surface-variant font-body-sm text-body-sm">
                                                        <span class="material-symbols-outlined text-[16px] text-primary">verified_user</span>
                                                        <span>Requires Guardian Fullscreen Browser Lock • WebCam + Screen Feed Enabled</span>
                                                    </div>
                                                    <button type="button" class="flex items-center gap-space-xs px-5 py-2.5 bg-primary text-on-primary hover:bg-secondary transition-colors rounded-xl font-title-md text-title-md font-semibold shadow-sm" onclick="openPreflightModal(${quizCard.quizId})">
                                                        <span>Start Quiz &amp; Enter Lockdown</span>
                                                        <span class="material-symbols-outlined text-[18px]">arrow_forward</span>
                                                    </button>
                                                </div>
                                            </div>
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <%-- UPCOMING / SCHEDULED CARD --%>
                                        <div class="quiz-card-item bg-surface-container-lowest rounded-2xl p-6 shadow-sm border border-surface-container-high/60 hover:shadow-md transition-shadow" data-category="upcoming">
                                            <div class="flex flex-col sm:flex-row items-start sm:items-center justify-between gap-space-md">
                                                <div class="flex flex-col gap-space-xs">
                                                    <div class="flex items-center gap-space-sm flex-wrap">
                                                        <span class="bg-surface-container text-on-surface-variant font-code-telemetry text-label-sm px-2.5 py-0.5 rounded font-bold">
                                                            <c:out value="${quizCard.quizCode}"/>
                                                        </span>
                                                        <span class="bg-surface-container-high text-on-surface-variant font-label-sm text-label-sm px-2.5 py-0.5 rounded-full font-medium">
                                                            <c:out value="${quizCard.badgeText}"/>
                                                        </span>
                                                    </div>
                                                    <h3 class="font-title-lg text-lg font-bold text-on-surface">
                                                        <c:out value="${quizCard.title}"/>
                                                    </h3>
                                                    <p class="font-body-sm text-body-sm text-on-surface-variant">
                                                        <c:out value="${quizCard.durationMinutes}"/> Minutes • <c:out value="${quizCard.totalQuestions}"/> Questions • <fmt:formatNumber value="${quizCard.totalMarks}" maxFractionDigits="0"/> Points • Proctor Level: <c:out value="${quizCard.proctorLevel}"/>
                                                    </p>
                                                </div>
                                                <div class="flex items-center gap-space-sm w-full sm:w-auto shrink-0">
                                                    <button type="button" class="flex-1 sm:flex-initial flex items-center justify-center gap-space-xs px-4 py-2 bg-surface-container-low hover:bg-surface-container text-on-surface rounded-xl font-label-md text-label-md font-semibold transition-colors" onclick="alert('Calendar reminder created for <c:out value="${quizCard.quizCode}"/>.')">
                                                        <span class="material-symbols-outlined text-[16px]">event</span>
                                                        <span>Add to Calendar</span>
                                                    </button>
                                                    <button type="button" class="px-3 py-2 bg-surface-container-lowest text-on-surface-variant hover:text-on-surface font-label-md text-label-md font-medium" onclick="alert('Detailed Syllabus: Topics cover <c:out value="${quizCard.description}"/>')">
                                                        Syllabus
                                                    </button>
                                                </div>
                                            </div>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </c:forEach>
                        </div>

                        <!-- Section 4: Performance Trend & Subject Progress -->
                        <div class="mt-space-md bg-surface-container-lowest rounded-2xl p-6 sm:p-space-xl shadow-sm border border-surface-container-high/40 flex flex-col gap-space-lg">
                            <div class="flex items-center justify-between flex-wrap gap-space-sm">
                                <div>
                                    <h3 class="font-title-lg text-xl font-bold text-on-surface">Curricular Subject Mastery</h3>
                                    <p class="font-body-sm text-body-sm text-on-surface-variant">Continuous performance evaluation across proctored core modules</p>
                                </div>
                                <span class="font-code-telemetry text-code-telemetry text-on-surface-variant bg-surface-container-low px-2.5 py-1 rounded-lg">
                                    Updated 2 hours ago
                                </span>
                            </div>
                            
                            <!-- Progress Bars Grid -->
                            <div class="grid grid-cols-1 md:grid-cols-2 gap-space-lg">
                                <c:forEach var="mastery" items="${dashboardData.subjectMasteryList}">
                                    <div class="flex flex-col gap-space-xs">
                                        <div class="flex justify-between items-center font-label-md text-label-md">
                                            <span class="text-on-surface font-semibold"><c:out value="${mastery.subjectName}"/></span>
                                            <span class="font-code-telemetry text-primary font-bold">
                                                <c:out value="${mastery.masteryPercentage}"/>% (<c:out value="${mastery.masteryLevel}"/>)
                                            </span>
                                        </div>
                                        <div class="w-full h-2.5 bg-surface-container-low rounded-full overflow-hidden">
                                            <div class="h-full rounded-full transition-all duration-500 bg-primary" 
                                                 style="width: ${mastery.masteryPercentage}%"></div>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </div>
                    </div>

                    <!-- Secondary Sidebar Column (Right 4 Cols): Pre-Flight Check & Recent Results -->
                    <div class="lg:col-span-4 flex flex-col gap-space-lg">
                        
                        <!-- Section 5: Pre-Flight Hardware Readiness Quick-Check Widget -->
                        <div class="bg-surface-container-lowest rounded-2xl p-6 shadow-sm border border-surface-container-high/40 flex flex-col gap-space-md">
                            <div class="flex items-center justify-between">
                                <div class="flex items-center gap-space-xs">
                                    <span class="material-symbols-outlined text-primary text-[20px]">monitor_heart</span>
                                    <h3 class="font-title-lg text-lg font-bold text-on-surface">Hardware Pre-Flight</h3>
                                </div>
                                <span class="w-2.5 h-2.5 rounded-full bg-tertiary-container animate-pulse"></span>
                            </div>
                            <p class="font-body-sm text-body-sm text-on-surface-variant">
                                Candidate station verified for High-Stakes Proctoring Session.
                            </p>

                            <!-- Checklist Rows -->
                            <div class="flex flex-col gap-space-xs" id="preflight-list">
                                <!-- Camera Item -->
                                <div class="flex items-center justify-between p-space-sm bg-surface-container-low rounded-xl">
                                    <div class="flex items-center gap-3">
                                        <div class="w-7 h-7 rounded-lg bg-tertiary-fixed/40 flex items-center justify-center text-tertiary">
                                            <span class="material-symbols-outlined text-[16px]">videocam</span>
                                        </div>
                                        <div>
                                            <span class="font-label-md text-label-md text-on-surface font-semibold block">Primary Camera</span>
                                            <span class="font-code-telemetry text-[11px] text-on-surface-variant">HD 1080p • 30 FPS Stream</span>
                                        </div>
                                    </div>
                                    <span class="material-symbols-outlined text-tertiary text-[20px]">check_circle</span>
                                </div>

                                <!-- Mic Item -->
                                <div class="flex items-center justify-between p-space-sm bg-surface-container-low rounded-xl">
                                    <div class="flex items-center gap-3">
                                        <div class="w-7 h-7 rounded-lg bg-tertiary-fixed/40 flex items-center justify-center text-tertiary">
                                            <span class="material-symbols-outlined text-[16px]">mic</span>
                                        </div>
                                        <div>
                                            <span class="font-label-md text-label-md text-on-surface font-semibold block">Microphone Feed</span>
                                            <span class="font-code-telemetry text-[11px] text-on-surface-variant">Quiet Ambient (22 dB)</span>
                                        </div>
                                    </div>
                                    <span class="material-symbols-outlined text-tertiary text-[20px]">check_circle</span>
                                </div>

                                <!-- Browser Lock Item -->
                                <div class="flex items-center justify-between p-space-sm bg-surface-container-low rounded-xl">
                                    <div class="flex items-center gap-3">
                                        <div class="w-7 h-7 rounded-lg bg-tertiary-fixed/40 flex items-center justify-center text-tertiary">
                                            <span class="material-symbols-outlined text-[16px]">lock_clock</span>
                                        </div>
                                        <div>
                                            <span class="font-label-md text-label-md text-on-surface font-semibold block">Browser Lockdown API</span>
                                            <span class="font-code-telemetry text-[11px] text-on-surface-variant">Lockdown 3.4.1 Supported</span>
                                        </div>
                                    </div>
                                    <span class="material-symbols-outlined text-tertiary text-[20px]">check_circle</span>
                                </div>

                                <!-- Network Item -->
                                <div class="flex items-center justify-between p-space-sm bg-surface-container-low rounded-xl">
                                    <div class="flex items-center gap-3">
                                        <div class="w-7 h-7 rounded-lg bg-tertiary-fixed/40 flex items-center justify-center text-tertiary">
                                            <span class="material-symbols-outlined text-[16px]">network_check</span>
                                        </div>
                                        <div>
                                            <span class="font-label-md text-label-md text-on-surface font-semibold block">Network Latency</span>
                                            <span class="font-code-telemetry text-[11px] text-on-surface-variant">24ms Ping • Excellent</span>
                                        </div>
                                    </div>
                                    <span class="material-symbols-outlined text-tertiary text-[20px]">check_circle</span>
                                </div>
                            </div>

                            <!-- Pre-Flight Action -->
                            <div class="pt-space-xs flex items-center justify-between">
                                <button type="button" class="w-full flex items-center justify-center gap-space-xs py-2.5 bg-surface-container hover:bg-surface-variant text-on-surface rounded-xl font-label-md text-label-md font-semibold transition-colors" id="retest-btn" onclick="runPreflightDiagnostics()">
                                    <span class="material-symbols-outlined text-[16px]">refresh</span>
                                    <span>Run Diagnostic Re-test</span>
                                </button>
                            </div>
                        </div>

                        <!-- Section 6: Latest Verified Result Card -->
                        <div class="bg-surface-container-lowest rounded-2xl p-6 shadow-sm border border-surface-container-high/40 flex flex-col gap-space-md">
                            <div class="flex items-center justify-between">
                                <span class="font-label-md text-label-md text-on-surface-variant uppercase tracking-wider font-semibold">Latest Verified Result</span>
                                <span class="bg-tertiary-fixed/60 text-on-tertiary-fixed-variant font-code-telemetry text-label-sm px-2.5 py-0.5 rounded-full font-bold">APPROVED</span>
                            </div>
                            <div class="bg-surface-container-low p-space-md rounded-xl flex flex-col gap-space-xs">
                                <span class="font-label-sm text-label-sm text-primary font-bold uppercase">
                                    <c:out value="${dashboardData.latestResult != null ? dashboardData.latestResult.quizCode : 'CS401'}"/> • 
                                    <c:out value="${dashboardData.latestResult != null ? dashboardData.latestResult.quizTitle : 'Advanced Algorithms'}"/>
                                </span>
                                <div class="flex items-baseline justify-between">
                                    <span class="font-headline-md text-2xl font-bold text-on-surface">
                                        <fmt:formatNumber value="${dashboardData.latestResult != null ? dashboardData.latestResult.score : 118}" maxFractionDigits="0"/> 
                                        <span class="font-body-md text-sm text-on-surface-variant font-normal">/ <fmt:formatNumber value="${dashboardData.latestResult != null ? dashboardData.latestResult.maxScore : 140}" maxFractionDigits="0"/> Pts</span>
                                    </span>
                                    <span class="font-headline-sm text-lg font-bold text-tertiary-container">
                                        <c:out value="${dashboardData.latestResult != null ? dashboardData.latestResult.percentage : 84.3}"/>% (<c:out value="${dashboardData.latestResult != null ? dashboardData.latestResult.grade : 'Grade A'}"/>)
                                    </span>
                                </div>
                                <div class="w-full bg-surface-container-highest h-1.5 rounded-full overflow-hidden mt-1">
                                    <div class="bg-tertiary-container h-full rounded-full" style="width: ${dashboardData.latestResult != null ? dashboardData.latestResult.percentage : 84.3}%"></div>
                                </div>
                            </div>
                            <div class="flex flex-col gap-space-xs text-on-surface-variant font-body-sm text-body-sm">
                                <div class="flex justify-between">
                                    <span>Attempt Timestamp:</span>
                                    <span class="font-code-telemetry text-code-telemetry text-on-surface">
                                        <c:out value="${dashboardData.latestResult != null ? dashboardData.latestResult.attemptTimestamp : 'March 22, 2025 • 14:10'}"/>
                                    </span>
                                </div>
                                <div class="flex justify-between">
                                    <span>Proctor Clearance:</span>
                                    <span class="font-code-telemetry text-code-telemetry text-tertiary font-semibold">
                                        <c:out value="${dashboardData.latestResult != null ? dashboardData.latestResult.proctorClearance : 'Clean (100% Signal)'}"/>
                                    </span>
                                </div>
                                <div class="flex justify-between">
                                    <span>Cohort Percentile:</span>
                                    <span class="font-code-telemetry text-code-telemetry text-on-surface font-semibold">
                                        <c:out value="${dashboardData.latestResult != null ? dashboardData.latestResult.cohortPercentile : 94.2}"/>%
                                    </span>
                                </div>
                            </div>
                            <a href="${pageContext.request.contextPath}/student/results" class="w-full flex items-center justify-center gap-space-xs py-2.5 bg-surface-container-low hover:bg-surface-container text-primary rounded-xl font-label-md text-label-md font-semibold transition-colors">
                                <span class="material-symbols-outlined text-[16px]">receipt_long</span>
                                <span>View Detailed Scorecard &amp; Solutions</span>
                            </a>
                        </div>

                        <!-- Quick Proctor Announcement / Guardian Notice -->
                        <div class="bg-surface-container-low rounded-2xl p-space-md flex items-start gap-space-sm border border-surface-container-high/60">
                            <span class="material-symbols-outlined text-secondary text-[24px] shrink-0 mt-0.5">verified_user</span>
                            <div class="flex flex-col gap-space-xs">
                                <span class="font-label-md text-label-md font-bold text-on-surface">Guardian Integrity Shield Active</span>
                                <p class="font-body-sm text-body-sm text-on-surface-variant">
                                    Secondary external displays, clipboard monitors, and virtual audio cables are automatically disabled during testing.
                                </p>
                            </div>
                        </div>

                    </div>
                </div>

            </div>
        </div>
    </main>

    <!-- Pre-Flight Readiness Modal Component -->
    <jsp:include page="components/instructions-modal.jsp"/>

    <!-- Micro-Interactivity Script -->
    <script>
        // Countdown timer simulation
        let totalSeconds = 1 * 3600 + 44 * 60 + 32;
        setInterval(() => {
            if (totalSeconds > 0) {
                totalSeconds--;
                const h = String(Math.floor(totalSeconds / 3600)).padStart(2, '0');
                const m = String(Math.floor((totalSeconds % 3600) / 60)).padStart(2, '0');
                const s = String(totalSeconds % 60).padStart(2, '0');
                const countdownEl = document.getElementById('countdown');
                if (countdownEl) {
                    countdownEl.innerText = h + "h " + m + "m " + s + "s";
                }
            }
        }, 1000);

        // Deck Filter (All, Live, Upcoming)
        function filterQuizDeck(category, btn) {
            const buttons = btn.parentElement.querySelectorAll('button');
            buttons.forEach(b => {
                b.className = "px-space-md py-1 text-on-surface-variant hover:text-on-surface font-label-sm text-label-sm font-medium rounded-lg";
            });
            btn.className = "px-space-md py-1 bg-surface-container-lowest text-primary font-label-sm text-label-sm font-bold rounded-lg shadow-sm";

            const cards = document.querySelectorAll('.quiz-card-item');
            cards.forEach(card => {
                if (category === 'all' || card.getAttribute('data-category') === category) {
                    card.style.display = 'block';
                } else {
                    card.style.display = 'none';
                }
            });
        }

        // Hardware diagnostic re-test
        function runPreflightDiagnostics() {
            const btn = document.getElementById('retest-btn');
            if (!btn) return;
            btn.innerHTML = `<span class="material-symbols-outlined text-[16px] animate-spin">refresh</span><span>Verifying Hardware Nodes...</span>`;
            setTimeout(() => {
                btn.innerHTML = `<span class="material-symbols-outlined text-[16px] text-tertiary">check</span><span class="text-tertiary font-bold">All 4 Peripherals Calibrated</span>`;
                setTimeout(() => {
                    btn.innerHTML = `<span class="material-symbols-outlined text-[16px]">refresh</span><span>Run Diagnostic Re-test</span>`;
                }, 2000);
            }, 1200);
        }
    </script>
</body>
</html>
