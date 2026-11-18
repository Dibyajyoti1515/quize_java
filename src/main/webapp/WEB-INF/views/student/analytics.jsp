<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8"/>
    <meta content="width=device-width, initial-scale=1.0" name="viewport"/>
    <title>Performance Analytics &amp; Cohort Benchmarks | QuizTrack</title>

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
<body class="bg-surface font-body-md text-body-md text-on-surface antialiased min-h-screen">

    <!-- Unified Student Sidebar Component -->
    <jsp:include page="components/sidebar.jsp">
        <jsp:param name="activeNav" value="performance-analytics"/>
    </jsp:include>

    <!-- Main Content Area offset by Sidebar (lg:pl-64) -->
    <div class="lg:pl-64">
        <!-- Reusable Student Header -->
        <jsp:include page="components/header.jsp"/>

        <main class="w-full pt-16 bg-surface min-h-screen px-4 sm:px-space-lg py-space-lg">
            <div class="flex flex-col gap-space-lg w-full max-w-[1400px] mx-auto">

                <!-- Header Breadcrumb & Command Bar -->
                <div class="flex flex-col md:flex-row md:items-center justify-between gap-4 bg-surface-container-lowest p-6 rounded-2xl shadow-sm border border-surface-container-high">
                    <div>
                        <div class="flex items-center gap-2 text-xs font-mono font-semibold text-primary uppercase">
                            <span>Candidate Mastery</span>
                            <span>•</span>
                            <span>Longitudinal Telemetry</span>
                        </div>
                        <h1 class="text-2xl sm:text-3xl font-display font-bold text-on-surface mt-1">
                            Performance Analytics &amp; Cohort Benchmarks
                        </h1>
                        <p class="text-xs text-on-surface-variant mt-1">
                            Curricular subject mastery progression, cohort percentile distribution, and longitudinal test analytics.
                        </p>
                    </div>

                    <div class="flex items-center gap-3">
                        <a href="${pageContext.request.contextPath}/student/leaderboard" class="flex items-center gap-2 px-4 py-2 rounded-xl bg-primary hover:bg-primary-container text-on-primary text-xs font-semibold shadow-sm transition-all">
                            <span class="material-symbols-outlined text-[16px]">military_tech</span>
                            <span>View Cohort Leaderboard</span>
                        </a>
                    </div>
                </div>

                <!-- Bento KPI Cards (4 Dimensions) -->
                <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-space-md">
                    <!-- KPI 1: Cumulative Score & Grade -->
                    <div class="bg-surface-container-lowest rounded-2xl p-space-md shadow-sm border border-surface-container-high flex flex-col justify-between">
                        <div class="flex items-center justify-between">
                            <span class="font-label-sm text-label-sm text-outline uppercase font-semibold">Cumulative Score</span>
                            <span class="px-2 py-0.5 rounded-full bg-primary-fixed text-on-primary-fixed font-mono text-xs font-bold">
                                Grade <c:out value="${dashboardData.cumulativeGrade != null ? dashboardData.cumulativeGrade : 'A'}"/>
                            </span>
                        </div>
                        <div class="my-3">
                            <span class="font-display text-3xl font-bold text-on-surface">
                                <fmt:formatNumber value="${dashboardData.cumulativeScore}" minFractionDigits="1" maxFractionDigits="1"/>%
                            </span>
                            <p class="text-xs text-on-surface-variant mt-1">Academic Progress Track</p>
                        </div>
                        <div class="h-1.5 w-full bg-surface-container-low rounded-full overflow-hidden">
                            <div class="h-full bg-primary rounded-full" style="width: ${dashboardData.cumulativeScore}%;"></div>
                        </div>
                    </div>

                    <!-- KPI 2: Assessments Attempted -->
                    <div class="bg-surface-container-lowest rounded-2xl p-space-md shadow-sm border border-surface-container-high flex flex-col justify-between">
                        <div class="flex items-center justify-between">
                            <span class="font-label-sm text-label-sm text-outline uppercase font-semibold">Assessments Completed</span>
                            <span class="material-symbols-outlined text-primary text-[20px]">assignment_turned_in</span>
                        </div>
                        <div class="my-3">
                            <span class="font-display text-3xl font-bold text-on-surface">
                                <c:out value="${dashboardData.quizzesAttempted}"/>
                            </span>
                            <span class="text-sm font-mono text-on-surface-variant">/ <c:out value="${dashboardData.totalQuizzesScheduled}"/> Scheduled</span>
                            <p class="text-xs text-tertiary font-semibold mt-1 flex items-center gap-1">
                                <span class="material-symbols-outlined text-[14px]">check_circle</span>
                                All mandatory attempts logged
                            </p>
                        </div>
                        <div class="h-1.5 w-full bg-surface-container-low rounded-full overflow-hidden">
                            <div class="h-full bg-tertiary rounded-full" style="width: ${dashboardData.totalQuizzesScheduled > 0 ? (dashboardData.quizzesAttempted * 100 / dashboardData.totalQuizzesScheduled) : 100}%;"></div>
                        </div>
                    </div>

                    <!-- KPI 3: Cohort Standing -->
                    <div class="bg-surface-container-lowest rounded-2xl p-space-md shadow-sm border border-surface-container-high flex flex-col justify-between">
                        <div class="flex items-center justify-between">
                            <span class="font-label-sm text-label-sm text-outline uppercase font-semibold">Cohort Standing</span>
                            <span class="material-symbols-outlined text-secondary text-[20px]">leaderboard</span>
                        </div>
                        <div class="my-3">
                            <span class="font-display text-3xl font-bold text-on-surface">
                                <c:choose>
                                    <c:when test="${dashboardData.cohortPercentile > 0}">
                                        <fmt:formatNumber value="${dashboardData.cohortPercentile}" minFractionDigits="1" maxFractionDigits="1"/>%
                                    </c:when>
                                    <c:otherwise>Top 10%</c:otherwise>
                                </c:choose>
                            </span>
                            <p class="text-xs text-on-surface-variant mt-1">
                                Rank #<c:out value="${dashboardData.cohortRank != null ? dashboardData.cohortRank : 1}"/> in Computer Science
                            </p>
                        </div>
                        <div class="h-1.5 w-full bg-surface-container-low rounded-full overflow-hidden">
                            <div class="h-full bg-secondary rounded-full" style="width: ${dashboardData.cohortPercentile > 0 ? dashboardData.cohortPercentile : 94}%;"></div>
                        </div>
                    </div>

                    <!-- KPI 4: Integrity Index -->
                    <div class="bg-surface-container-lowest rounded-2xl p-space-md shadow-sm border border-surface-container-high flex flex-col justify-between">
                        <div class="flex items-center justify-between">
                            <span class="font-label-sm text-label-sm text-outline uppercase font-semibold">Integrity Index</span>
                            <span class="material-symbols-outlined text-tertiary text-[20px]">verified_user</span>
                        </div>
                        <div class="my-3">
                            <span class="font-display text-3xl font-bold text-tertiary">
                                <fmt:formatNumber value="${dashboardData.integrityIndex}" minFractionDigits="1" maxFractionDigits="1"/>%
                            </span>
                            <p class="text-xs text-on-surface-variant mt-1">Tier 1 Verified Proctor Clearance</p>
                        </div>
                        <div class="h-1.5 w-full bg-surface-container-low rounded-full overflow-hidden">
                            <div class="h-full bg-tertiary-container rounded-full" style="width: ${dashboardData.integrityIndex}%;"></div>
                        </div>
                    </div>
                </div>

                <!-- Section: Curricular Subject Mastery Grid -->
                <div class="bg-surface-container-lowest rounded-2xl p-6 shadow-sm border border-surface-container-high">
                    <div class="flex items-center justify-between mb-4">
                        <div>
                            <h2 class="font-display text-lg font-bold text-on-surface">Curricular Subject Mastery</h2>
                            <p class="text-xs text-on-surface-variant">Empirical domain proficiency across certified examinations</p>
                        </div>
                        <span class="material-symbols-outlined text-primary text-[22px]">school</span>
                    </div>

                    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4">
                        <c:forEach var="sub" items="${dashboardData.subjectMastery}">
                            <div class="p-4 rounded-xl bg-surface-container-low border border-surface-container flex flex-col justify-between">
                                <div class="flex items-center justify-between">
                                    <span class="font-mono text-xs font-bold text-primary px-2 py-0.5 rounded bg-surface-container">
                                        <c:out value="${sub.code}"/>
                                    </span>
                                    <span class="text-xs font-semibold text-on-surface"><c:out value="${sub.level}"/></span>
                                </div>
                                <h4 class="font-display font-semibold text-sm text-on-surface mt-2 mb-3 line-clamp-1">
                                    <c:out value="${sub.name}"/>
                                </h4>
                                <div>
                                    <div class="flex items-center justify-between text-xs mb-1">
                                        <span class="text-outline">Mastery</span>
                                        <span class="font-mono font-bold text-on-surface"><c:out value="${sub.percentage}"/>%</span>
                                    </div>
                                    <div class="h-2 w-full bg-surface-container rounded-full overflow-hidden">
                                        <div class="h-full bg-primary rounded-full transition-all duration-500" style="width: ${sub.percentage}%;"></div>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </div>

                <!-- Section: Longitudinal Assessment Ledger -->
                <div class="bg-surface-container-lowest rounded-2xl p-6 shadow-sm border border-surface-container-high">
                    <div class="flex items-center justify-between mb-4">
                        <div>
                            <h2 class="font-display text-lg font-bold text-on-surface">Longitudinal Examination Ledger</h2>
                            <p class="text-xs text-on-surface-variant">Complete certified history of examination sessions, scores, and proctoring telemetry</p>
                        </div>
                        <span class="material-symbols-outlined text-primary text-[22px]">history_edu</span>
                    </div>

                    <c:choose>
                        <c:when test="${not empty historyList}">
                            <div class="overflow-x-auto">
                                <table class="w-full text-left text-xs border-collapse">
                                    <thead>
                                        <tr class="border-b border-surface-container-high text-outline uppercase font-semibold">
                                            <th class="py-3 px-4">Examination</th>
                                            <th class="py-3 px-4">Subject</th>
                                            <th class="py-3 px-4">Date Completed</th>
                                            <th class="py-3 px-4 text-right">Score</th>
                                            <th class="py-3 px-4 text-center">Accuracy</th>
                                            <th class="py-3 px-4 text-center">Grade</th>
                                            <th class="py-3 px-4 text-center">Integrity</th>
                                            <th class="py-3 px-4 text-right">Action</th>
                                        </tr>
                                    </thead>
                                    <tbody class="divide-y divide-surface-container">
                                        <c:forEach var="h" items="${historyList}">
                                            <tr class="hover:bg-surface-container-low/60 transition-colors">
                                                <td class="py-3.5 px-4 font-semibold text-on-surface">
                                                    <c:out value="${h.quizTitle}"/>
                                                </td>
                                                <td class="py-3.5 px-4">
                                                    <span class="px-2 py-0.5 rounded bg-surface-container font-mono text-[11px] font-bold text-primary">
                                                        <c:out value="${h.subjectCode}"/>
                                                    </span>
                                                </td>
                                                <td class="py-3.5 px-4 text-on-surface-variant font-mono">
                                                    <fmt:formatDate value="${h.endTime}" pattern="MMM dd, yyyy • HH:mm"/>
                                                </td>
                                                <td class="py-3.5 px-4 text-right font-mono font-bold text-on-surface">
                                                    <fmt:formatNumber value="${h.score}" minFractionDigits="1" maxFractionDigits="2"/> / <fmt:formatNumber value="${h.maxScore}" maxFractionDigits="0"/>
                                                </td>
                                                <td class="py-3.5 px-4 text-center font-mono font-semibold text-primary">
                                                    <fmt:formatNumber value="${h.percentage}" minFractionDigits="1" maxFractionDigits="1"/>%
                                                </td>
                                                <td class="py-3.5 px-4 text-center">
                                                    <span class="px-2 py-0.5 rounded-full bg-primary-fixed text-on-primary-fixed font-mono font-bold text-[11px]">
                                                        <c:out value="${h.grade}"/>
                                                    </span>
                                                </td>
                                                <td class="py-3.5 px-4 text-center">
                                                    <span class="inline-flex items-center gap-1 text-tertiary font-semibold text-[11px]">
                                                        <span class="material-symbols-outlined text-[14px]">verified</span>
                                                        <c:out value="${h.integrityIndex != null ? h.integrityIndex : 99.1}"/>%
                                                    </span>
                                                </td>
                                                <td class="py-3.5 px-4 text-right">
                                                    <a href="${pageContext.request.contextPath}/student/results?quizId=${h.quizId}&attemptId=${h.attemptId}" class="inline-flex items-center gap-1 px-3 py-1.5 rounded-lg bg-surface-container hover:bg-primary hover:text-on-primary text-on-surface font-semibold text-[11px] transition-all">
                                                        <span>Scorecard</span>
                                                        <span class="material-symbols-outlined text-[14px]">arrow_forward</span>
                                                    </a>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="p-8 text-center text-on-surface-variant">
                                <span class="material-symbols-outlined text-[40px] text-outline">analytics</span>
                                <p class="font-semibold text-sm mt-2">No Examination Records Found</p>
                                <p class="text-xs text-outline mt-1">Complete your assigned cohort assessments to populate performance analytics.</p>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>

            </div>
        </main>
    </div>

</body>
</html>
