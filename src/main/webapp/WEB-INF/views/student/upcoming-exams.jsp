<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8"/>
    <meta content="width=device-width, initial-scale=1.0" name="viewport"/>
    <title>Upcoming Examinations &amp; Schedule | QuizTrack</title>

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
        <jsp:param name="activeNav" value="upcoming-exams"/>
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
                            <span>Academic Calendar</span>
                            <span>•</span>
                            <span>Cohort Schedule</span>
                        </div>
                        <h1 class="text-2xl sm:text-3xl font-display font-bold text-on-surface mt-1">
                            Upcoming Examinations &amp; Schedule
                        </h1>
                        <p class="text-xs text-on-surface-variant mt-1">
                            Synchronized schedule of proctored midterms, lab finals, and diagnostic assessments for your cohort.
                        </p>
                    </div>

                    <div class="flex items-center gap-3">
                        <div class="flex items-center gap-2 px-3.5 py-2 rounded-xl bg-surface-container-low border border-surface-container-high text-xs font-semibold text-on-surface">
                            <span class="w-2 h-2 rounded-full bg-tertiary-container animate-pulse"></span>
                            <span><c:out value="${totalUpcoming != null ? totalUpcoming : 0}"/> Assessments Scheduled</span>
                        </div>
                    </div>
                </div>

                <!-- KPI Metric Bento Strip -->
                <div class="grid grid-cols-1 sm:grid-cols-3 gap-space-md">
                    <div class="bg-surface-container-lowest p-5 rounded-2xl shadow-sm border border-surface-container-high flex items-center justify-between">
                        <div>
                            <span class="text-xs font-semibold uppercase text-outline">Total Scheduled</span>
                            <p class="font-display text-2xl font-bold text-on-surface mt-1"><c:out value="${totalUpcoming != null ? totalUpcoming : 0}"/></p>
                            <span class="text-xs text-on-surface-variant">Assigned to your cohort</span>
                        </div>
                        <div class="w-12 h-12 rounded-xl bg-primary-fixed text-on-primary-fixed-variant flex items-center justify-center">
                            <span class="material-symbols-outlined text-[24px]">event_note</span>
                        </div>
                    </div>

                    <div class="bg-surface-container-lowest p-5 rounded-2xl shadow-sm border border-surface-container-high flex items-center justify-between">
                        <div>
                            <span class="text-xs font-semibold uppercase text-outline">Active / Open Now</span>
                            <p class="font-display text-2xl font-bold text-tertiary mt-1"><c:out value="${activeCount != null ? activeCount : 0}"/></p>
                            <span class="text-xs text-on-surface-variant">Admission window active</span>
                        </div>
                        <div class="w-12 h-12 rounded-xl bg-tertiary-fixed text-tertiary flex items-center justify-center">
                            <span class="material-symbols-outlined text-[24px]">play_arrow</span>
                        </div>
                    </div>

                    <div class="bg-surface-container-lowest p-5 rounded-2xl shadow-sm border border-surface-container-high flex items-center justify-between">
                        <div>
                            <span class="text-xs font-semibold uppercase text-outline">Pending Future Window</span>
                            <p class="font-display text-2xl font-bold text-primary mt-1"><c:out value="${scheduledCount != null ? scheduledCount : 0}"/></p>
                            <span class="text-xs text-on-surface-variant">Opening soon</span>
                        </div>
                        <div class="w-12 h-12 rounded-xl bg-surface-container text-primary flex items-center justify-center">
                            <span class="material-symbols-outlined text-[24px]">schedule</span>
                        </div>
                    </div>
                </div>

                <!-- Upcoming Exams Grid -->
                <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-space-lg">
                    <c:choose>
                        <c:when test="${not empty upcomingQuizzes}">
                            <c:forEach var="card" items="${upcomingQuizzes}">
                                <div class="bg-surface-container-lowest rounded-2xl p-space-md shadow-sm border ${card.status == 'ACTIVE' ? 'border-2 border-primary' : 'border-surface-container-high'} flex flex-col justify-between hover:shadow-md transition-shadow">
                                    <div class="flex flex-col gap-3">
                                        <div class="flex items-center justify-between">
                                            <c:choose>
                                                <c:when test="${card.status == 'ACTIVE'}">
                                                    <span class="px-2.5 py-1 rounded-full bg-error-container text-on-error-container font-label-sm text-label-sm font-semibold uppercase flex items-center gap-1.5">
                                                        <span class="w-1.5 h-1.5 rounded-full bg-error animate-ping"></span>
                                                        <c:choose>
                                                            <c:when test="${card.formattedDueAt != null}">
                                                                Closes: <c:out value="${card.formattedDueAt}"/>
                                                            </c:when>
                                                            <c:otherwise>Chamber Open</c:otherwise>
                                                        </c:choose>
                                                    </span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="px-2.5 py-1 rounded-full bg-surface-container text-on-surface-variant font-label-sm text-label-sm font-semibold uppercase">
                                                        <c:out value="${card.formattedDueAt != null ? 'Opens: '.concat(card.formattedDueAt) : 'Scheduled Ahead'}"/>
                                                    </span>
                                                </c:otherwise>
                                            </c:choose>
                                            <span class="font-code-telemetry text-code-telemetry text-on-surface-variant font-medium">
                                                <c:out value="${card.quizCode}"/>
                                            </span>
                                        </div>

                                        <div>
                                            <h3 class="font-title-lg text-lg text-on-surface font-bold">
                                                <c:out value="${card.title}"/>
                                            </h3>
                                            <p class="font-body-sm text-body-sm text-on-surface-variant mt-1">
                                                <c:out value="${card.subjectName}"/> • <c:out value="${card.teacherName}"/>
                                            </p>
                                        </div>

                                        <p class="text-xs text-on-surface-variant leading-relaxed line-clamp-2">
                                            <c:out value="${card.description != null ? card.description : 'Proctored examination assessing cohort theoretical and applied domain competencies.'}"/>
                                        </p>

                                        <div class="grid grid-cols-3 gap-2 py-2 border-y border-surface-container-high text-center">
                                            <div>
                                                <p class="font-label-sm text-label-sm text-outline uppercase">Items</p>
                                                <p class="font-title-md text-title-md font-semibold text-on-surface"><c:out value="${card.totalQuestions}"/> Qs</p>
                                            </div>
                                            <div>
                                                <p class="font-label-sm text-label-sm text-outline uppercase">Duration</p>
                                                <p class="font-title-md text-title-md font-semibold text-on-surface"><c:out value="${card.durationMinutes}"/>m</p>
                                            </div>
                                            <div>
                                                <p class="font-label-sm text-label-sm text-outline uppercase">Marks</p>
                                                <p class="font-title-md text-title-md font-semibold text-on-surface"><fmt:formatNumber value="${card.totalMarks}" maxFractionDigits="0"/></p>
                                            </div>
                                        </div>

                                        <div class="flex items-center gap-2 text-on-surface-variant font-label-sm text-label-sm">
                                            <span class="material-symbols-outlined text-[16px] text-primary">security</span>
                                            <span class="truncate"><c:out value="${card.proctorLevel}"/></span>
                                        </div>
                                    </div>

                                    <div class="mt-4">
                                        <c:choose>
                                            <c:when test="${card.status == 'ACTIVE'}">
                                                <button type="button" class="w-full py-2.5 rounded-xl bg-primary-container text-on-primary hover:bg-primary font-title-md text-title-md font-semibold flex items-center justify-center gap-2 shadow-sm transition-all" onclick="openPreflightModal(${card.quizId}, '<c:out value="${card.quizCode}"/>', '<c:out value="${card.title}"/>', ${card.durationMinutes}, ${card.totalQuestions}, ${card.totalMarks}, ${card.negativeMarking}, ${card.negativeMarkValue}, '<c:out value="${card.teacherName}"/>', ${card.maxTabSwitches}, ${card.fullscreenRequired}, ${card.webcamRequired})">
                                                    <span>Start Examination</span>
                                                    <span class="material-symbols-outlined text-[18px]">arrow_forward</span>
                                                </button>
                                            </c:when>
                                            <c:otherwise>
                                                <div class="w-full py-2.5 rounded-xl bg-surface-container text-on-surface-variant font-title-md text-title-md font-semibold flex items-center justify-center gap-2 text-xs">
                                                    <span class="material-symbols-outlined text-[16px] text-outline">lock_clock</span>
                                                    <span>Scheduled • Window Opens Soon</span>
                                                </div>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <div class="col-span-full p-12 rounded-2xl bg-surface-container-lowest border border-surface-container-high text-center">
                                <span class="material-symbols-outlined text-[48px] text-outline">event_available</span>
                                <h3 class="font-display font-bold text-lg text-on-surface mt-2">No Upcoming Examinations Pending</h3>
                                <p class="text-xs text-on-surface-variant mt-1">All assigned cohort assessments have been completed or no new exams are scheduled.</p>
                                <a href="${pageContext.request.contextPath}/student/results" class="inline-flex items-center gap-2 px-5 py-2.5 rounded-xl bg-primary text-on-primary text-xs font-semibold mt-4 shadow-sm">
                                    <span>View My Results Transcript</span>
                                    <span class="material-symbols-outlined text-[16px]">arrow_forward</span>
                                </a>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>

            </div>
        </main>
    </div>

    <!-- Active Pre-Exam Readiness Instructions Modal Component -->
    <jsp:include page="components/instructions-modal.jsp"/>

</body>
</html>
