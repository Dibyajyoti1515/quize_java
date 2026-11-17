<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8"/>
    <meta content="width=device-width, initial-scale=1.0" name="viewport"/>
    <meta content="web_dashboard" name="shell-type"/>
    <title>Available Quizzes &amp; Assessment Registry | QuizTrack</title>

    <!-- Google Fonts & Material Symbols matching Stitch -->
    <link href="https://fonts.googleapis.com" rel="preconnect"/>
    <link crossorigin="" href="https://fonts.gstatic.com" rel="preconnect"/>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=JetBrains+Mono:wght@500&family=Plus+Jakarta+Sans:wght@600;700;800&display=swap" rel="stylesheet"/>
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
                        "on-tertiary-fixed-variant": "#005236",
                        "on-tertiary-container": "#67f4b7",
                        "error": "#ba1a1a",
                        "error-container": "#ffdad6",
                        "on-error": "#ffffff",
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
<body class="bg-surface font-body-md text-body-md text-on-surface antialiased">

    <!-- Fixed Left Sidebar Component -->
    <jsp:include page="components/sidebar.jsp">
        <jsp:param name="activeNav" value="available-quizzes"/>
    </jsp:include>

    <!-- Main Content Area offset by Sidebar (64 = 16rem = 256px) -->
    <div class="lg:pl-64">
        <!-- Top App Header -->
        <header class="fixed top-0 left-0 lg:left-64 right-0 h-16 bg-surface-container-lowest/90 backdrop-blur-xl shadow-[0_1px_8px_rgba(0,0,0,0.04)] z-40 flex items-center justify-between px-4 sm:px-space-lg border-b border-surface-container-high/60">
            <div class="flex items-center gap-space-md">
                <div class="flex items-center gap-2 px-space-sm py-1 rounded-full bg-surface-container-low text-tertiary font-label-md text-label-md">
                    <span class="w-2 h-2 rounded-full bg-tertiary-container animate-pulse"></span>
                    <span class="font-semibold">System Healthy &amp; Verified</span>
                </div>
            </div>
            <div class="flex items-center gap-space-md">
                <a href="${pageContext.request.contextPath}/student/notifications" class="relative p-2 rounded-lg text-on-surface-variant hover:bg-surface-container-low hover:text-on-surface transition-colors" title="Notifications">
                    <span class="material-symbols-outlined text-[22px]">notifications</span>
                    <span class="absolute top-2 right-2 w-2 h-2 rounded-full bg-error ring-2 ring-surface-container-lowest"></span>
                </a>
                <div class="h-6 w-px bg-surface-container-high"></div>
                <div class="flex items-center gap-3 pl-1">
                    <div class="flex flex-col text-right">
                        <span class="font-title-md text-title-md text-on-surface leading-tight font-semibold">
                            <c:out value="${sessionScope.userFullName != null ? sessionScope.userFullName : 'Alex Mercer'}"/>
                        </span>
                        <span class="font-code-telemetry text-code-telemetry text-on-surface-variant">
                            <c:out value="${sessionScope.userIdentifier != null ? sessionScope.userIdentifier : 'CS-2022-041'}"/>
                        </span>
                    </div>
                    <div class="w-8 h-8 rounded-full bg-primary flex items-center justify-center shadow-sm text-on-primary font-bold text-xs">
                        AM
                    </div>
                </div>
            </div>
        </header>

        <!-- Main Body -->
        <main class="w-full pt-16 bg-surface min-h-screen px-4 sm:px-space-lg py-space-lg">
            <div class="flex flex-col w-full relative">
                
                <div class="flex flex-col gap-space-lg w-full max-w-[1400px] mx-auto">
                    
                    <!-- Top Header Strip -->
                    <div class="flex flex-col md:flex-row md:items-end justify-between gap-space-md">
                        <div class="flex flex-col gap-1">
                            <div class="flex items-center gap-2">
                                <span class="font-code-telemetry text-code-telemetry uppercase tracking-wider text-primary font-bold">Assessment Registry</span>
                                <span class="text-outline-variant">•</span>
                                <span class="font-label-sm text-label-sm text-on-surface-variant font-medium">Live Academic Feed</span>
                            </div>
                            <h1 class="font-headline-lg text-2xl sm:text-3xl text-on-surface font-bold tracking-tight">Available Quizzes &amp; Assessments</h1>
                            <p class="font-body-md text-body-md text-on-surface-variant max-w-2xl">
                                Registered Spring 2025 cohort examinations, timed proctored midterms, and diagnostic knowledge benchmarks.
                            </p>
                        </div>
                        
                        <!-- Quick Session Badge -->
                        <div class="flex items-center gap-3 bg-surface-container-lowest px-space-md py-2.5 rounded-xl shadow-sm border border-surface-container-high">
                            <div class="flex h-2.5 w-2.5 rounded-full bg-tertiary-container animate-pulse"></div>
                            <div class="flex flex-col">
                                <span class="font-label-sm text-label-sm text-on-surface-variant uppercase font-semibold">Integrity Bridge</span>
                                <span class="font-code-telemetry text-code-telemetry font-bold text-tertiary">NODE-EAST-04 • SYNCED</span>
                            </div>
                        </div>
                    </div>

                    <!-- Metrics Row -->
                    <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-space-md">
                        <div class="bg-surface-container-lowest p-space-md rounded-xl shadow-sm border border-surface-container-high flex items-center justify-between">
                            <div class="flex flex-col">
                                <span class="font-label-sm text-label-sm text-on-surface-variant uppercase font-medium">Ready to Launch</span>
                                <div class="flex items-baseline gap-2 mt-1">
                                    <span class="font-headline-md text-2xl text-primary font-bold">0<c:out value="${dashboardData.readyToLaunchCount > 0 ? dashboardData.readyToLaunchCount : 1}"/></span>
                                    <span class="font-label-sm text-label-sm text-primary font-semibold">Assessments</span>
                                </div>
                                <span class="font-label-sm text-label-sm text-on-surface-variant mt-1">Window open right now</span>
                            </div>
                            <div class="w-12 h-12 rounded-xl bg-primary-fixed/50 text-primary flex items-center justify-center">
                                <span class="material-symbols-outlined text-[26px]">play_circle</span>
                            </div>
                        </div>

                        <div class="bg-surface-container-lowest p-space-md rounded-xl shadow-sm border border-surface-container-high flex items-center justify-between">
                            <div class="flex flex-col">
                                <span class="font-label-sm text-label-sm text-on-surface-variant uppercase font-medium">Scheduled Ahead</span>
                                <div class="flex items-baseline gap-2 mt-1">
                                    <span class="font-headline-md text-2xl text-on-surface font-bold">0<c:out value="${dashboardData.scheduledAheadCount > 0 ? dashboardData.scheduledAheadCount : 2}"/></span>
                                    <span class="font-label-sm text-label-sm text-outline font-semibold">Pending</span>
                                </div>
                                <span class="font-label-sm text-label-sm text-on-surface-variant mt-1">CS505 &amp; CS490 Finals</span>
                            </div>
                            <div class="w-12 h-12 rounded-xl bg-surface-container-low text-on-surface flex items-center justify-center">
                                <span class="material-symbols-outlined text-[26px]">calendar_clock</span>
                            </div>
                        </div>

                        <div class="bg-surface-container-lowest p-space-md rounded-xl shadow-sm border border-surface-container-high flex items-center justify-between">
                            <div class="flex flex-col">
                                <span class="font-label-sm text-label-sm text-on-surface-variant uppercase font-medium">Cohort Standing</span>
                                <div class="flex items-baseline gap-2 mt-1">
                                    <span class="font-headline-md text-2xl text-tertiary font-bold"><c:out value="${dashboardData.cohortPercentile > 0 ? dashboardData.cohortPercentile : 94.2}"/>%</span>
                                    <span class="font-label-sm text-label-sm text-tertiary font-semibold">Verified</span>
                                </div>
                                <span class="font-label-sm text-label-sm text-on-surface-variant mt-1">Full eligibility verified</span>
                            </div>
                            <div class="w-12 h-12 rounded-xl bg-tertiary-fixed/40 text-tertiary flex items-center justify-center">
                                <span class="material-symbols-outlined text-[26px]">verified</span>
                            </div>
                        </div>

                        <div class="bg-surface-container-lowest p-space-md rounded-xl shadow-sm border border-surface-container-high flex items-center justify-between">
                            <div class="flex flex-col">
                                <span class="font-label-sm text-label-sm text-on-surface-variant uppercase font-medium">Telemetry Node</span>
                                <div class="flex items-baseline gap-2 mt-1">
                                    <span class="font-headline-md text-2xl text-tertiary font-bold">Passed</span>
                                    <span class="font-code-telemetry text-code-telemetry text-tertiary font-semibold">24ms</span>
                                </div>
                                <span class="font-label-sm text-label-sm text-on-surface-variant mt-1">Hardware sandbox green</span>
                            </div>
                            <div class="w-12 h-12 rounded-xl bg-surface-container-low text-tertiary flex items-center justify-center">
                                <span class="material-symbols-outlined text-[26px]">sensors</span>
                            </div>
                        </div>
                    </div>

                    <!-- Filter & Sort Bar -->
                    <div class="bg-surface-container-lowest p-space-sm px-space-md rounded-xl shadow-sm border border-surface-container-high flex flex-wrap items-center justify-between gap-3">
                        <div class="flex items-center gap-2 flex-1 min-w-[280px]">
                            <span class="material-symbols-outlined text-outline text-[20px]">search</span>
                            <input id="quiz-search-input" class="w-full bg-transparent font-body-md text-body-md text-on-surface focus:outline-none placeholder:text-outline" placeholder="Search assessments by code, topic, or proctor..." type="text" onkeyup="searchQuizzes()"/>
                        </div>
                        <div class="flex items-center gap-2">
                            <div class="flex items-center gap-1.5 px-3 py-1.5 rounded-lg bg-surface-container-low text-on-surface font-label-md text-label-md cursor-pointer">
                                <span>All Subjects</span>
                                <span class="material-symbols-outlined text-[16px]">expand_more</span>
                            </div>
                            <div class="flex items-center gap-1.5 px-3 py-1.5 rounded-lg bg-primary-container text-on-primary font-label-md text-label-md cursor-pointer">
                                <span>Active Window</span>
                            </div>
                        </div>
                    </div>

                    <!-- Assessments Cards Grid (3 Columns) -->
                    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-space-lg" id="quiz-grid">
                        <c:forEach var="card" items="${dashboardData.assignedQuizzes}">
                            <div class="quiz-grid-card bg-surface-container-lowest rounded-xl p-space-md shadow-md border ${card.status == 'ACTIVE' ? 'border-2 border-primary/20' : 'border-surface-container-high'} flex flex-col justify-between relative overflow-hidden">
                                <div class="flex flex-col gap-3">
                                    <div class="flex items-center justify-between">
                                        <c:choose>
                                            <c:when test="${card.status == 'ACTIVE'}">
                                                <span class="px-2.5 py-1 rounded-full bg-error-container text-on-error-container font-label-sm text-label-sm font-semibold uppercase flex items-center gap-1.5">
                                                    <span class="w-1.5 h-1.5 rounded-full bg-error animate-ping"></span>
                                                    Closes in 2h 15m
                                                </span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="px-2.5 py-1 rounded-full bg-surface-container text-on-surface-variant font-label-sm text-label-sm font-semibold uppercase">
                                                    <c:out value="${card.formattedDueAt != null ? card.formattedDueAt : 'Scheduled Ahead'}"/>
                                                </span>
                                            </c:otherwise>
                                        </c:choose>
                                        <span class="font-code-telemetry text-code-telemetry text-on-surface-variant font-medium">
                                            <c:out value="${card.quizCode}"/>
                                        </span>
                                    </div>
                                    <div>
                                        <h3 class="font-title-lg text-lg text-on-surface font-bold card-quiz-title">
                                            <c:out value="${card.title}"/>
                                        </h3>
                                        <p class="font-body-sm text-body-sm text-on-surface-variant mt-1 card-quiz-sub">
                                            <c:out value="${card.subjectName}"/> • <c:out value="${card.teacherName}"/>
                                        </p>
                                    </div>
                                    <div class="grid grid-cols-3 gap-2 py-2 border-y border-surface-container-high text-center">
                                        <div>
                                            <p class="font-label-sm text-label-sm text-outline uppercase">Questions</p>
                                            <p class="font-title-md text-title-md font-semibold text-on-surface"><c:out value="${card.totalQuestions}"/> Items</p>
                                        </div>
                                        <div>
                                            <p class="font-label-sm text-label-sm text-outline uppercase">Duration</p>
                                            <p class="font-title-md text-title-md font-semibold text-on-surface"><c:out value="${card.durationMinutes}"/> Mins</p>
                                        </div>
                                        <div>
                                            <p class="font-label-sm text-label-sm text-outline uppercase">Total Pts</p>
                                            <p class="font-title-md text-title-md font-semibold text-on-surface"><fmt:formatNumber value="${card.totalMarks}" maxFractionDigits="0"/> Marks</p>
                                        </div>
                                    </div>
                                    <div class="flex items-center gap-2 text-on-surface-variant font-label-sm text-label-sm">
                                        <span class="material-symbols-outlined text-[16px] text-primary">security</span>
                                        <span class="truncate"><c:out value="${card.proctorLevel}"/></span>
                                    </div>
                                </div>
                                
                                <c:choose>
                                    <c:when test="${card.status == 'ACTIVE'}">
                                        <button type="button" class="w-full mt-5 py-2.5 rounded-lg bg-primary-container text-on-primary hover:bg-primary font-title-md text-title-md font-semibold flex items-center justify-center gap-2 shadow-sm transition-all" onclick="openPreflightModal(${card.quizId})">
                                            <span>Start Examination</span>
                                            <span class="material-symbols-outlined text-[18px]">arrow_forward</span>
                                        </button>
                                    </c:when>
                                    <c:otherwise>
                                        <button type="button" class="w-full mt-5 py-2.5 rounded-lg bg-surface-container hover:bg-surface-container-high text-on-surface font-title-md text-title-md font-semibold flex items-center justify-center gap-2 transition-all" onclick="alert('Quiz details: <c:out value="${card.title}"/>.\nScheduled window will open soon.')">
                                            <span>View Details</span>
                                            <span class="material-symbols-outlined text-[18px]">visibility</span>
                                        </button>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </c:forEach>
                    </div>

                    <!-- Browser Compliance Sticky Footer -->
                    <div class="mt-space-lg p-space-sm px-space-md rounded-xl bg-surface-container-lowest border border-surface-container-high flex flex-wrap items-center justify-between gap-2 shadow-xs">
                        <div class="flex items-center gap-4">
                            <div class="flex items-center gap-1.5 text-on-surface-variant font-label-md text-label-md">
                                <span class="material-symbols-outlined text-[18px] text-tertiary">check_circle</span>
                                <span>Chrome 122.0.6261 (Compliant)</span>
                            </div>
                            <div class="hidden sm:flex items-center gap-1.5 text-on-surface-variant font-label-md text-label-md">
                                <span class="material-symbols-outlined text-[18px] text-tertiary">check_circle</span>
                                <span>Screen Share Permissions Granted</span>
                            </div>
                            <div class="hidden md:flex items-center gap-1.5 text-on-surface-variant font-label-md text-label-md">
                                <span class="material-symbols-outlined text-[18px] text-tertiary">check_circle</span>
                                <span>Secure Sandbox Driver v2.4</span>
                            </div>
                        </div>
                        <div class="flex items-center gap-3">
                            <span class="font-code-telemetry text-code-telemetry text-on-surface-variant">HOST: exam-us-east.quiztrack.edu</span>
                            <span class="w-2 h-2 rounded-full bg-tertiary"></span>
                        </div>
                    </div>

                </div>

            </div>
        </main>
    </div>

    <!-- Active Pre-Exam Readiness Instructions Modal Component -->
    <jsp:include page="components/instructions-modal.jsp"/>

    <script>
        function searchQuizzes() {
            const query = document.getElementById('quiz-search-input').value.toLowerCase();
            const cards = document.querySelectorAll('.quiz-grid-card');
            cards.forEach(card => {
                const title = card.querySelector('.card-quiz-title').innerText.toLowerCase();
                const sub = card.querySelector('.card-quiz-sub').innerText.toLowerCase();
                if (title.includes(query) || sub.includes(query)) {
                    card.style.display = 'flex';
                } else {
                    card.style.display = 'none';
                }
            });
        }
    </script>
</body>
</html>
