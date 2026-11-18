<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Live Proctoring Command Center | QuizTrack Faculty Console</title>

    <link href="https://fonts.googleapis.com" rel="preconnect"/>
    <link crossorigin="" href="https://fonts.gstatic.com" rel="preconnect"/>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=JetBrains+Mono:wght@400;500;600&family=Plus+Jakarta+Sans:wght@600;700;800&display=swap" rel="stylesheet"/>
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200" rel="stylesheet"/>

    <style>
        @layer base {
            html, body { margin: 0; padding: 0; }
            ::-webkit-scrollbar { display: none; }
        }
        @keyframes pulse-fast {
            0%, 100% { opacity: 1; transform: scale(1); }
            50% { opacity: 0.4; transform: scale(1.15); }
        }
        .animate-pulse-live {
            animation: pulse-fast 1.5s cubic-bezier(0.4, 0, 0.6, 1) infinite;
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
                        'on-surface': '#0b1c30',
                        'on-surface-variant': '#464555',
                        outline: '#777587',
                        'outline-variant': '#c7c4d8'
                    },
                    fontFamily: {
                        display: ['Plus Jakarta Sans', 'sans-serif'],
                        body: ['Inter', 'sans-serif'],
                        mono: ['JetBrains Mono', 'monospace'],
                        'code-telemetry': ['JetBrains Mono', 'monospace'],
                        'label-md': ['Inter', 'sans-serif'],
                        'label-sm': ['Inter', 'sans-serif']
                    }
                }
            }
        };
    </script>
</head>
<body class="bg-surface font-body text-sm text-on-surface antialiased min-h-screen">

    <!-- Reusable Teacher Sidebar -->
    <jsp:include page="components/sidebar.jsp"/>

    <!-- MAIN WORKSPACE -->
    <div class="lg:pl-64 flex flex-col min-h-screen">

        <!-- Top Header Navigation -->
        <header class="h-16 bg-surface-container-lowest/80 backdrop-blur-md border-b border-surface-container-high sticky top-0 z-30 px-4 sm:px-8 flex items-center justify-between">
            <div class="flex items-center gap-3">
                <button type="button" onclick="toggleSidebar()" class="lg:hidden p-2 rounded-lg text-on-surface-variant hover:bg-surface-container hover:text-on-surface transition-all" aria-label="Toggle navigation">
                    <span class="material-symbols-outlined text-[24px]">menu</span>
                </button>
                <div class="w-8 h-8 rounded-lg bg-surface-container-low text-primary hidden sm:flex items-center justify-center">
                    <span class="material-symbols-outlined text-[20px]">monitoring</span>
                </div>
                <div>
                    <h1 class="font-display font-bold text-lg text-on-surface leading-tight">Live Proctoring Command Center</h1>
                    <span class="font-mono text-[11px] text-tertiary flex items-center gap-1">
                        <span class="w-2 h-2 rounded-full bg-tertiary animate-pulse-live"></span>
                        Live Telemetry Stream Active
                    </span>
                </div>
            </div>

            <!-- Quiz Selector Dropdown -->
            <form action="${pageContext.request.contextPath}/teacher/proctoring" method="GET" class="flex items-center gap-2">
                <c:if test="${not empty monitoringData.availableQuizzes}">
                    <div class="relative">
                        <select name="quizId" onchange="this.form.submit()" class="appearance-none bg-surface-container-low border border-surface-container-high text-on-surface text-xs font-semibold rounded-xl pl-3 pr-8 py-2 focus:outline-none focus:ring-2 focus:ring-primary cursor-pointer">
                            <c:forEach var="q" items="${monitoringData.availableQuizzes}">
                                <option value="${q.quizId}" ${q.quizId == monitoringData.quizId ? 'selected' : ''}>
                                    ${q.subjectCode}: ${q.title}
                                </option>
                            </c:forEach>
                        </select>
                        <span class="material-symbols-outlined text-[16px] text-on-surface-variant absolute right-2.5 top-2.5 pointer-events-none">expand_more</span>
                    </div>
                </c:if>
                <button type="button" onclick="openBroadcastModal()" class="inline-flex items-center gap-1.5 px-3.5 py-2 rounded-xl bg-primary text-on-primary hover:bg-primary-container text-xs font-semibold shadow-sm transition-all">
                    <span class="material-symbols-outlined text-[16px]">campaign</span>
                    <span>Broadcast</span>
                </button>
            </form>
        </header>

        <!-- Command Center Workspace -->
        <main class="flex-1 p-4 sm:p-8 max-w-7xl mx-auto w-full flex flex-col gap-6">

            <!-- 1. KPI SUMMARY METRIC CARDS -->
            <div class="grid grid-cols-2 lg:grid-cols-4 gap-4">

                <!-- Card 1: Active Candidates -->
                <div class="p-5 rounded-2xl bg-surface-container-lowest border border-surface-container-high shadow-sm flex flex-col justify-between">
                    <div class="flex items-center justify-between">
                        <span class="text-[11px] font-semibold uppercase tracking-wider text-outline">Active Examinees</span>
                        <div class="w-8 h-8 rounded-lg bg-emerald-50 text-emerald-800 flex items-center justify-center">
                            <span class="material-symbols-outlined text-[18px]">how_to_reg</span>
                        </div>
                    </div>
                    <div class="my-2">
                        <span class="font-display text-3xl font-bold text-on-surface" id="kpi-active">${monitoringData.activeCount}</span>
                        <span class="text-xs text-on-surface-variant font-mono">/ ${monitoringData.totalAssigned} seated</span>
                    </div>
                    <div class="w-full bg-surface-container rounded-full h-1.5 overflow-hidden">
                        <div class="bg-emerald-600 h-full rounded-full transition-all" style="width: ${monitoringData.totalAssigned > 0 ? (monitoringData.activeCount * 100.0 / monitoringData.totalAssigned) : 0}%"></div>
                    </div>
                </div>

                <!-- Card 2: Flagged for Review -->
                <div class="p-5 rounded-2xl bg-surface-container-lowest border border-surface-container-high shadow-sm flex flex-col justify-between">
                    <div class="flex items-center justify-between">
                        <span class="text-[11px] font-semibold uppercase tracking-wider text-outline">Flagged Sessions</span>
                        <div class="w-8 h-8 rounded-lg bg-amber-50 text-amber-800 flex items-center justify-center">
                            <span class="material-symbols-outlined text-[18px]">flag</span>
                        </div>
                    </div>
                    <div class="my-2">
                        <span class="font-display text-3xl font-bold text-amber-700" id="kpi-flagged">${monitoringData.flaggedCount}</span>
                        <span class="text-xs text-on-surface-variant font-medium">Under Review</span>
                    </div>
                    <span class="text-[11px] text-on-surface-variant">Browser window / focus changes</span>
                </div>

                <!-- Card 3: Critical Alerts -->
                <div class="p-5 rounded-2xl bg-surface-container-lowest border border-surface-container-high shadow-sm flex flex-col justify-between">
                    <div class="flex items-center justify-between">
                        <span class="text-[11px] font-semibold uppercase tracking-wider text-outline">Critical Alerts</span>
                        <div class="w-8 h-8 rounded-lg bg-rose-50 text-rose-800 flex items-center justify-center">
                            <span class="material-symbols-outlined text-[18px]">warning</span>
                        </div>
                    </div>
                    <div class="my-2">
                        <span class="font-display text-3xl font-bold text-error" id="kpi-critical">${monitoringData.criticalCount}</span>
                        <span class="text-xs text-error font-semibold">Immediate Review</span>
                    </div>
                    <span class="text-[11px] text-error">Multiple fullscreen exits</span>
                </div>

                <!-- Card 4: Cohort Progress -->
                <div class="p-5 rounded-2xl bg-surface-container-lowest border border-surface-container-high shadow-sm flex flex-col justify-between">
                    <div class="flex items-center justify-between">
                        <span class="text-[11px] font-semibold uppercase tracking-wider text-outline">Cohort Progress</span>
                        <div class="w-8 h-8 rounded-lg bg-primary-fixed text-primary flex items-center justify-center">
                            <span class="material-symbols-outlined text-[18px]">donut_large</span>
                        </div>
                    </div>
                    <div class="my-2">
                        <span class="font-display text-3xl font-bold text-on-surface" id="kpi-progress">${monitoringData.averageProgress}%</span>
                        <span class="text-xs text-on-surface-variant font-mono">Mean Completion</span>
                    </div>
                    <div class="w-full bg-surface-container rounded-full h-1.5 overflow-hidden">
                        <div class="bg-primary h-full rounded-full transition-all" style="width: ${monitoringData.averageProgress}%"></div>
                    </div>
                </div>

            </div>

            <!-- 2. FILTER & CANDIDATE SEARCH TOOLBAR -->
            <div class="p-4 rounded-2xl bg-surface-container-lowest border border-surface-container-high shadow-sm flex flex-wrap items-center justify-between gap-3">
                <div class="flex items-center gap-2 flex-wrap">
                    <button type="button" onclick="filterExaminees('all')" class="filter-btn active px-3.5 py-1.5 rounded-xl bg-primary text-on-primary font-semibold text-xs shadow-xs transition-all">
                        All Candidates (${monitoringData.totalAssigned})
                    </button>
                    <button type="button" onclick="filterExaminees('active')" class="filter-btn px-3.5 py-1.5 rounded-xl bg-surface-container hover:bg-surface-container-high text-on-surface font-semibold text-xs transition-all">
                        Active (${monitoringData.activeCount})
                    </button>
                    <button type="button" onclick="filterExaminees('flagged')" class="filter-btn px-3.5 py-1.5 rounded-xl bg-surface-container hover:bg-surface-container-high text-amber-800 font-semibold text-xs transition-all">
                        Flagged (${monitoringData.flaggedCount})
                    </button>
                    <button type="button" onclick="filterExaminees('critical')" class="filter-btn px-3.5 py-1.5 rounded-xl bg-surface-container hover:bg-surface-container-high text-error font-semibold text-xs transition-all">
                        Critical (${monitoringData.criticalCount})
                    </button>
                    <button type="button" onclick="filterExaminees('submitted')" class="filter-btn px-3.5 py-1.5 rounded-xl bg-surface-container hover:bg-surface-container-high text-on-surface-variant font-semibold text-xs transition-all">
                        Submitted (${monitoringData.submittedCount})
                    </button>
                </div>

                <div class="relative w-full sm:w-64">
                    <span class="material-symbols-outlined text-[18px] text-on-surface-variant absolute left-3 top-2.5">search</span>
                    <input type="text" id="candidate-search" oninput="searchCandidates(this.value)" placeholder="Search student or roll no..." class="w-full pl-9 pr-3 py-2 bg-surface-container-low border border-surface-container-high rounded-xl text-xs text-on-surface focus:outline-none focus:ring-2 focus:ring-primary shadow-xs"/>
                </div>
            </div>

            <!-- 3. CANDIDATE LIVE MONITORING GRID -->
            <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4" id="examinee-grid">
                <c:choose>
                    <c:when test="${not empty monitoringData.examinees}">
                        <c:forEach var="ex" items="${monitoringData.examinees}">
                            <div class="candidate-card rounded-2xl bg-surface-container-lowest border p-5 shadow-sm hover:shadow-md transition-all flex flex-col justify-between gap-4
                                ${ex.flagged ? 'border-amber-400 bg-amber-50/10' : (ex.integrityLevel == 'CRITICAL' ? 'border-rose-400 bg-rose-50/10' : 'border-surface-container-high')}"
                                data-status="${ex.status.toLowerCase()}"
                                data-flagged="${ex.flagged}"
                                data-critical="${ex.integrityLevel == 'CRITICAL'}"
                                data-name="${ex.studentName.toLowerCase()}"
                                data-id="${ex.studentIdentifier.toLowerCase()}"
                                id="card-attempt-${ex.attemptId}">

                                <!-- Header: Student Info & Status Pill -->
                                <div class="flex items-start justify-between gap-2">
                                    <div class="flex items-center gap-3">
                                        <div class="w-10 h-10 rounded-xl bg-surface-container text-on-surface flex items-center justify-center font-bold text-sm flex-shrink-0">
                                            ${ex.avatarInitials}
                                        </div>
                                        <div class="flex flex-col overflow-hidden">
                                            <span class="font-display font-bold text-sm text-on-surface truncate">${ex.studentName}</span>
                                            <span class="font-mono text-xs text-on-surface-variant">${ex.studentIdentifier}</span>
                                        </div>
                                    </div>

                                    <!-- Status Pill -->
                                    <c:choose>
                                        <c:when test="${ex.flagged}">
                                            <span class="px-2 py-0.5 rounded-full bg-amber-100 text-amber-800 font-mono text-[11px] font-bold flex items-center gap-1">
                                                <span class="material-symbols-outlined text-[13px]">flag</span> Flagged
                                            </span>
                                        </c:when>
                                        <c:when test="${ex.status == 'IN_PROGRESS'}">
                                            <span class="px-2 py-0.5 rounded-full bg-emerald-100 text-emerald-800 font-mono text-[11px] font-bold flex items-center gap-1">
                                                <span class="w-1.5 h-1.5 rounded-full bg-emerald-600 animate-pulse-live"></span> Active
                                            </span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="px-2 py-0.5 rounded-full bg-slate-100 text-slate-700 font-mono text-[11px] font-bold">
                                                Submitted
                                            </span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>

                                <!-- Middle: Telemetry Counters & Timer -->
                                <div class="grid grid-cols-3 gap-2 p-3 bg-surface-container-low rounded-xl text-center">
                                    <div class="flex flex-col">
                                        <span class="text-[10px] uppercase font-semibold text-outline">Timer</span>
                                        <span class="font-mono font-bold text-xs ${ex.status == 'IN_PROGRESS' ? 'text-primary' : 'text-on-surface-variant'}">${ex.remainingFormatted}</span>
                                    </div>
                                    <div class="flex flex-col">
                                        <span class="text-[10px] uppercase font-semibold text-outline">Tab / Blur</span>
                                        <span class="font-mono font-bold text-xs ${ex.tabSwitchCount > 0 ? 'text-amber-700' : 'text-on-surface'}">${ex.tabSwitchCount} / ${ex.blurCount}</span>
                                    </div>
                                    <div class="flex flex-col">
                                        <span class="text-[10px] uppercase font-semibold text-outline">Integrity</span>
                                        <span class="font-mono font-bold text-xs ${ex.integrityIndex >= 90 ? 'text-emerald-700' : 'text-error'}">${ex.integrityIndex}%</span>
                                    </div>
                                </div>

                                <!-- Progress Bar -->
                                <div class="flex flex-col gap-1">
                                    <div class="flex items-center justify-between text-[11px] text-on-surface-variant font-mono">
                                        <span>Progress: ${ex.answeredCount} / ${ex.totalQuestions} Qs</span>
                                        <span>${ex.progressPercentage}%</span>
                                    </div>
                                    <div class="w-full bg-surface-container rounded-full h-1.5 overflow-hidden">
                                        <div class="bg-primary h-full rounded-full transition-all" style="width: ${ex.progressPercentage}%"></div>
                                    </div>
                                    <div class="flex items-center justify-between text-[10px] text-outline mt-0.5">
                                        <span>Heartbeat: ${ex.lastActivityFormatted}</span>
                                        <span>IP: ${ex.ipAddress != null ? ex.ipAddress : '127.0.0.1'}</span>
                                    </div>
                                </div>

                                <!-- Actions Strip -->
                                <div class="flex items-center gap-2 pt-2 border-t border-surface-container">
                                    <button type="button" onclick="openStudentTimeline(${ex.attemptId}, '${ex.studentName}')" class="flex-1 py-1.5 rounded-lg bg-surface-container hover:bg-surface-container-high text-on-surface font-semibold text-xs transition-colors flex items-center justify-center gap-1">
                                        <span class="material-symbols-outlined text-[15px]">timeline</span>
                                        <span>Audit Timeline</span>
                                    </button>

                                    <c:choose>
                                        <c:when test="${ex.flagged}">
                                            <button type="button" onclick="clearFlagPrompt(${ex.attemptId})" class="px-3 py-1.5 rounded-lg bg-amber-100 hover:bg-amber-200 text-amber-900 font-semibold text-xs transition-colors">
                                                Clear Flag
                                            </button>
                                        </c:when>
                                        <c:otherwise>
                                            <button type="button" onclick="flagAttemptPrompt(${ex.attemptId})" class="px-3 py-1.5 rounded-lg bg-surface-container hover:bg-amber-100 text-on-surface hover:text-amber-900 font-semibold text-xs transition-colors">
                                                Flag
                                            </button>
                                        </c:otherwise>
                                    </c:choose>
                                </div>

                            </div>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <div class="col-span-full p-12 text-center rounded-3xl bg-surface-container-lowest border border-surface-container-high flex flex-col items-center gap-3">
                            <span class="material-symbols-outlined text-4xl text-on-surface-variant">person_off</span>
                            <h3 class="font-display font-bold text-base text-on-surface">No Candidate Attempts Found</h3>
                            <p class="text-xs text-on-surface-variant max-w-sm">No examinees have started or submitted attempts for this assessment yet.</p>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>

            <!-- 4. LIVE AUDIT LOGS & PROCTOR ACTIONS STREAM -->
            <div class="rounded-3xl bg-surface-container-lowest border border-surface-container-high shadow-sm p-6 flex flex-col gap-4">
                <div class="flex items-center justify-between pb-3 border-b border-surface-container">
                    <div class="flex items-center gap-2">
                        <span class="material-symbols-outlined text-primary text-[22px]">history_edu</span>
                        <h3 class="font-display font-bold text-base text-on-surface">Proctor Intervention Audit Trail</h3>
                    </div>
                    <span class="text-xs text-on-surface-variant font-mono">Immutable Compliance Log</span>
                </div>

                <div class="overflow-x-auto">
                    <table class="w-full text-left border-collapse text-xs">
                        <thead>
                            <tr class="bg-surface-container-low/60 text-on-surface-variant font-semibold uppercase tracking-wider text-[11px] border-b border-surface-container">
                                <th class="py-2.5 px-3">Timestamp</th>
                                <th class="py-2.5 px-3">Proctor</th>
                                <th class="py-2.5 px-3">Action Type</th>
                                <th class="py-2.5 px-3">Intervention Note / Justification</th>
                            </tr>
                        </thead>
                        <tbody class="divide-y divide-surface-container" id="audit-table-body">
                            <c:choose>
                                <c:when test="${not empty monitoringData.auditLogs}">
                                    <c:forEach var="log" items="${monitoringData.auditLogs}">
                                        <tr class="hover:bg-surface-container-low/40">
                                            <td class="py-2.5 px-3 font-mono text-on-surface-variant">${log.createdAtFormatted}</td>
                                            <td class="py-2.5 px-3 font-semibold text-on-surface">${log.teacherName}</td>
                                            <td class="py-2.5 px-3">
                                                <span class="px-2 py-0.5 rounded-md font-mono text-[11px] font-bold
                                                    ${log.actionType == 'FLAG' ? 'bg-amber-100 text-amber-900' : (log.actionType == 'CLEAR_FLAG' ? 'bg-emerald-100 text-emerald-900' : 'bg-surface-container text-on-surface')}">
                                                    ${log.actionType}
                                                </span>
                                            </td>
                                            <td class="py-2.5 px-3 text-on-surface">${log.message}</td>
                                        </tr>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <tr>
                                        <td colspan="4" class="p-6 text-center text-on-surface-variant">
                                            No interventions recorded for this examination session.
                                        </td>
                                    </tr>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>
                </div>
            </div>

        </main>
    </div>

    <!-- STUDENT TIMELINE INSPECTION MODAL -->
    <div id="timeline-modal" class="fixed inset-0 bg-slate-900/60 backdrop-blur-sm z-50 flex items-center justify-center p-3 sm:p-4 overflow-y-auto hidden" onclick="if(event.target===this) this.classList.add('hidden')">
        <div class="relative w-full max-w-2xl bg-surface-container-lowest rounded-3xl shadow-2xl border border-surface-container-high my-6 overflow-hidden flex flex-col">
            <div class="flex items-center justify-between px-6 py-4 border-b border-surface-container bg-surface-bright">
                <div class="flex items-center gap-2">
                    <span class="material-symbols-outlined text-primary text-[22px]">manage_search</span>
                    <div>
                        <h3 class="font-display font-bold text-base text-on-surface" id="modal-student-name">Candidate Event Timeline</h3>
                        <span class="text-xs text-on-surface-variant font-mono">Browser telemetry events are diagnostic indicators for review</span>
                    </div>
                </div>
                <button type="button" onclick="document.getElementById('timeline-modal').classList.add('hidden')" class="p-2 text-on-surface-variant hover:text-on-surface hover:bg-surface-container rounded-lg">
                    <span class="material-symbols-outlined text-[20px]">close</span>
                </button>
            </div>

            <div class="p-6 max-h-[60vh] overflow-y-auto flex flex-col gap-3" id="timeline-events-container">
                <div class="p-8 text-center text-on-surface-variant">Loading student timeline...</div>
            </div>

            <div class="px-6 py-3 bg-surface-container-low border-t border-surface-container flex justify-end">
                <button type="button" onclick="document.getElementById('timeline-modal').classList.add('hidden')" class="px-4 py-2 rounded-xl bg-surface-container text-on-surface font-semibold text-xs hover:bg-surface-container-high">
                    Close
                </button>
            </div>
        </div>
    </div>

    <!-- BROADCAST NOTICE MODAL -->
    <div id="broadcast-modal" class="fixed inset-0 bg-slate-900/60 backdrop-blur-sm z-50 flex items-center justify-center p-3 sm:p-4 hidden" onclick="if(event.target===this) this.classList.add('hidden')">
        <div class="relative w-full max-w-md bg-surface-container-lowest rounded-3xl shadow-2xl border border-surface-container-high overflow-hidden p-6 flex flex-col gap-4">
            <div class="flex items-center gap-2">
                <span class="material-symbols-outlined text-primary text-[24px]">campaign</span>
                <h3 class="font-display font-bold text-base text-on-surface">Broadcast Announcement</h3>
            </div>
            <p class="text-xs text-on-surface-variant">Send a real-time advisory notice to all active candidates seated in this exam.</p>

            <textarea id="broadcast-message" rows="3" placeholder="e.g. 15 minutes remaining. Please ensure all answers are reviewed." class="w-full p-3 rounded-xl border border-surface-container-high bg-surface-container-low text-xs text-on-surface focus:outline-none focus:ring-2 focus:ring-primary"></textarea>

            <div class="flex items-center justify-end gap-2 pt-2">
                <button type="button" onclick="document.getElementById('broadcast-modal').classList.add('hidden')" class="px-4 py-2 rounded-xl bg-surface-container text-on-surface font-semibold text-xs hover:bg-surface-container-high">
                    Cancel
                </button>
                <button type="button" onclick="submitBroadcast()" class="px-5 py-2 rounded-xl bg-primary text-on-primary font-semibold text-xs hover:bg-primary-container shadow-sm">
                    Send Notice
                </button>
            </div>
        </div>
    </div>

    <script>
        const QUIZ_ID = ${monitoringData.quizId};
        const CONTEXT_PATH = '${pageContext.request.contextPath}';

        // 1. Filter examinee cards
        function filterExaminees(category) {
            document.querySelectorAll('.filter-btn').forEach(b => {
                b.classList.remove('bg-primary', 'text-on-primary');
                b.classList.add('bg-surface-container', 'text-on-surface');
            });
            event.target.classList.add('bg-primary', 'text-on-primary');
            event.target.classList.remove('bg-surface-container', 'text-on-surface');

            document.querySelectorAll('.candidate-card').forEach(card => {
                const status = card.getAttribute('data-status');
                const isFlagged = card.getAttribute('data-flagged') === 'true';
                const isCritical = card.getAttribute('data-critical') === 'true';

                if (category === 'all') {
                    card.style.display = '';
                } else if (category === 'active') {
                    card.style.display = (status === 'in_progress') ? '' : 'none';
                } else if (category === 'flagged') {
                    card.style.display = isFlagged ? '' : 'none';
                } else if (category === 'critical') {
                    card.style.display = isCritical ? '' : 'none';
                } else if (category === 'submitted') {
                    card.style.display = (status === 'submitted') ? '' : 'none';
                }
            });
        }

        // 2. Search candidates
        function searchCandidates(query) {
            const q = query.toLowerCase().trim();
            document.querySelectorAll('.candidate-card').forEach(card => {
                const name = card.getAttribute('data-name');
                const id = card.getAttribute('data-id');
                if (!q || name.includes(q) || id.includes(q)) {
                    card.style.display = '';
                } else {
                    card.style.display = 'none';
                }
            });
        }

        // 3. Open Student Timeline Modal
        function openStudentTimeline(attemptId, studentName) {
            document.getElementById('modal-student-name').innerText = studentName + ' - Audit Timeline';
            const container = document.getElementById('timeline-events-container');
            container.innerHTML = '<div class="p-8 text-center text-on-surface-variant text-xs">Loading telemetry events...</div>';
            document.getElementById('timeline-modal').classList.remove('hidden');

            fetch(CONTEXT_PATH + '/teacher/proctoring/timeline?attemptId=' + attemptId)
                .then(r => r.json())
                .then(events => {
                    if (!events || events.length === 0) {
                        container.innerHTML = '<div class="p-8 text-center text-on-surface-variant text-xs">No browser infractions or telemetry events recorded for this session.</div>';
                        return;
                    }
                    let html = '';
                    events.forEach(ev => {
                        const isRev = ev.isReviewed;
                        html += '<div class="p-3.5 rounded-xl border border-surface-container-high bg-surface-container-low flex flex-col gap-1.5">' +
                                '<div class="flex items-center justify-between text-xs">' +
                                    '<span class="font-mono font-bold ' + (ev.severity === 'CRITICAL' ? 'text-error' : (ev.severity === 'CAUTION' ? 'text-amber-800' : 'text-primary')) + '">' + ev.eventType + '</span>' +
                                    '<span class="font-mono text-on-surface-variant text-[11px]">' + ev.timestamp + '</span>' +
                                '</div>' +
                                '<p class="text-xs text-on-surface">' + (ev.details || 'Event logged by student browser sandbox.') + '</p>' +
                                '<div class="flex items-center justify-between pt-1 border-t border-surface-container text-[11px]">' +
                                    (isRev ? '<span class="text-emerald-700 font-semibold flex items-center gap-1"><span class="material-symbols-outlined text-[14px]">check_circle</span> Reviewed: ' + (ev.reviewNotes || '') + '</span>'
                                           : '<button type="button" onclick="promptReviewEvent(' + ev.logId + ')" class="px-2 py-0.5 rounded bg-surface-container hover:bg-surface-container-high text-primary font-semibold">Mark Reviewed</button>') +
                                '</div>' +
                                '</div>';
                    });
                    container.innerHTML = html;
                })
                .catch(err => {
                    container.innerHTML = '<div class="p-8 text-center text-error text-xs">Failed to load student events timeline.</div>';
                });
        }

        // 4. Proctor Actions: Flag Attempt
        function flagAttemptPrompt(attemptId) {
            const reason = prompt("Enter justification for flagging this student session for academic review:");
            if (!reason) return;

            const formData = new URLSearchParams();
            formData.append("csrfToken", '${sessionScope.csrfToken}');
            formData.append("action", "flag");
            formData.append("attemptId", attemptId);
            formData.append("reason", reason);

            fetch(CONTEXT_PATH + '/teacher/proctoring/action', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                    'X-CSRF-Token': '${sessionScope.csrfToken}'
                },
                body: formData
            }).then(r => r.json()).then(res => {
                if (res.status === 'SUCCESS') {
                    alert("Candidate attempt has been flagged for academic review.");
                    window.location.reload();
                } else {
                    alert("Error: " + (res.message || "Could not flag attempt."));
                }
            });
        }

        // 5. Proctor Actions: Clear Flag
        function clearFlagPrompt(attemptId) {
            const reason = prompt("Enter resolution notes to clear the flag on this student session:");
            if (!reason) return;

            const formData = new URLSearchParams();
            formData.append("csrfToken", '${sessionScope.csrfToken}');
            formData.append("action", "clear_flag");
            formData.append("attemptId", attemptId);
            formData.append("reason", reason);

            fetch(CONTEXT_PATH + '/teacher/proctoring/action', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                    'X-CSRF-Token': '${sessionScope.csrfToken}'
                },
                body: formData
            }).then(r => r.json()).then(res => {
                if (res.status === 'SUCCESS') {
                    alert("Candidate flag cleared successfully.");
                    window.location.reload();
                } else {
                    alert("Error: " + (res.message || "Could not clear flag."));
                }
            });
        }

        // 6. Review Event Action
        function promptReviewEvent(logId) {
            const notes = prompt("Enter review note for this proctoring event:");
            if (notes === null) return;

            const formData = new URLSearchParams();
            formData.append("csrfToken", '${sessionScope.csrfToken}');
            formData.append("action", "review_event");
            formData.append("logId", logId);
            formData.append("notes", notes || "Reviewed by proctor.");

            fetch(CONTEXT_PATH + '/teacher/proctoring/action', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                    'X-CSRF-Token': '${sessionScope.csrfToken}'
                },
                body: formData
            }).then(r => r.json()).then(res => {
                if (res.status === 'SUCCESS') {
                    alert("Event marked as reviewed.");
                    document.getElementById('timeline-modal').classList.add('hidden');
                }
            });
        }

        // 7. Broadcast Announcement
        function openBroadcastModal() {
            document.getElementById('broadcast-modal').classList.remove('hidden');
        }

        function submitBroadcast() {
            const msg = document.getElementById('broadcast-message').value.trim();
            if (!msg) return;

            const formData = new URLSearchParams();
            formData.append("csrfToken", '${sessionScope.csrfToken}');
            formData.append("action", "broadcast");
            formData.append("quizId", QUIZ_ID);
            formData.append("message", msg);

            fetch(CONTEXT_PATH + '/teacher/proctoring/action', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                    'X-CSRF-Token': '${sessionScope.csrfToken}'
                },
                body: formData
            }).then(r => r.json()).then(res => {
                if (res.status === 'SUCCESS') {
                    alert("Announcement broadcasted successfully to active examinees.");
                    document.getElementById('broadcast-modal').classList.add('hidden');
                    window.location.reload();
                }
            });
        }

        // 8. Lightweight Background Live Updates Polling (Every 10 seconds)
        setInterval(() => {
            if (QUIZ_ID <= 0) return;
            fetch(CONTEXT_PATH + '/teacher/proctoring/feed?quizId=' + QUIZ_ID)
                .then(r => r.json())
                .then(data => {
                    if (data && data.activeCount !== undefined) {
                        const activeEl = document.getElementById('kpi-active');
                        if (activeEl) activeEl.innerText = data.activeCount;
                        const flaggedEl = document.getElementById('kpi-flagged');
                        if (flaggedEl) flaggedEl.innerText = data.flaggedCount;
                        const critEl = document.getElementById('kpi-critical');
                        if (critEl) critEl.innerText = data.criticalCount;
                        const progEl = document.getElementById('kpi-progress');
                        if (progEl) progEl.innerText = data.averageProgress + '%';
                    }
                }).catch(err => {});
        }, 10000);
        // 9. Mobile Sidebar Toggle
        function toggleSidebar() {
            const sidebar = document.getElementById('teacher-sidebar');
            const backdrop = document.getElementById('mobile-sidebar-backdrop');
            if (sidebar) {
                sidebar.classList.toggle('-translate-x-full');
                if (backdrop) backdrop.classList.toggle('hidden');
            }
        }
    </script>

</body>
</html>
