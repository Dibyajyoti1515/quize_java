<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Proctoring Violation Logs &amp; Audit Trail | QuizTrack</title>
    <link rel="preconnect" href="https://fonts.googleapis.com"/>
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin/>
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
<body class="bg-surface font-body text-on-surface antialiased">
    <!-- Faculty Navigation Sidebar -->
    <jsp:include page="components/sidebar.jsp"/>

    <div class="lg:pl-64">
        <!-- Faculty Header -->
        <jsp:include page="components/header.jsp"/>

        <main class="w-full pt-16 min-h-screen px-4 sm:px-8 py-8">
            <div class="max-w-7xl mx-auto flex flex-col gap-6">

                <!-- Header Strip -->
                <div class="flex flex-col sm:flex-row sm:items-center justify-between gap-4 bg-surface-container-lowest p-6 rounded-2xl shadow-sm border border-surface-container-high">
                    <div>
                        <div class="flex items-center gap-2 text-xs font-mono font-semibold text-rose-600 uppercase">
                            <span>Integrity Telemetry</span>
                            <span>•</span>
                            <span>Security Audit Log</span>
                        </div>
                        <h1 class="text-2xl sm:text-3xl font-display font-bold text-on-surface mt-1">Proctoring Violation Logs</h1>
                        <p class="text-sm text-on-surface-variant mt-1">
                            Chronological integrity telemetry, browser blur alerts, tab switch violations, and hardware status changes.
                        </p>
                    </div>
                    <div class="flex items-center gap-3">
                        <a href="${pageContext.request.contextPath}/teacher/proctoring" class="px-4 py-2.5 rounded-xl bg-primary text-on-primary font-semibold text-sm hover:bg-primary-container transition-all flex items-center gap-2 shadow-sm">
                            <span class="material-symbols-outlined text-[18px]">grid_view</span>
                            <span>Live Proctoring Matrix</span>
                        </a>
                    </div>
                </div>

                <!-- Violation Counters -->
                <div class="grid grid-cols-2 sm:grid-cols-4 gap-4">
                    <div class="bg-surface-container-lowest p-4 rounded-xl border border-surface-container-high shadow-xs">
                        <span class="text-xs font-mono font-semibold text-on-surface-variant uppercase">Total Logged Incidents</span>
                        <p class="text-2xl font-bold font-display text-on-surface mt-1"><c:out value="${totalCount}"/></p>
                    </div>
                    <div class="bg-rose-50/70 p-4 rounded-xl border border-rose-200 shadow-xs">
                        <span class="text-xs font-mono font-semibold text-rose-700 uppercase">Critical Flags</span>
                        <p class="text-2xl font-bold font-display text-rose-700 mt-1"><c:out value="${criticalCount}"/></p>
                    </div>
                    <div class="bg-amber-50/70 p-4 rounded-xl border border-amber-200 shadow-xs">
                        <span class="text-xs font-mono font-semibold text-amber-700 uppercase">Warnings / High</span>
                        <p class="text-2xl font-bold font-display text-amber-700 mt-1"><c:out value="${highCount}"/></p>
                    </div>
                    <div class="bg-surface-container-lowest p-4 rounded-xl border border-surface-container-high shadow-xs">
                        <span class="text-xs font-mono font-semibold text-on-surface-variant uppercase">Tab / Blur Transitions</span>
                        <p class="text-2xl font-bold font-display text-primary mt-1"><c:out value="${tabSwitchCount}"/></p>
                    </div>
                </div>

                <!-- Filter Strip -->
                <div class="flex items-center justify-between gap-4 bg-surface-container-lowest p-4 rounded-xl border border-surface-container-high">
                    <div class="flex items-center gap-2">
                        <span class="text-xs font-mono font-bold uppercase text-on-surface-variant">Filter Severity:</span>
                        <div class="flex items-center gap-1.5">
                            <a href="${pageContext.request.contextPath}/teacher/violations?severity=ALL" 
                               class="px-3 py-1 rounded-lg text-xs font-semibold ${selectedSeverity == 'ALL' ? 'bg-primary text-on-primary' : 'bg-surface-container text-on-surface hover:bg-surface-container-high'}">All</a>
                            <a href="${pageContext.request.contextPath}/teacher/violations?severity=CRITICAL" 
                               class="px-3 py-1 rounded-lg text-xs font-semibold ${selectedSeverity == 'CRITICAL' ? 'bg-rose-600 text-white' : 'bg-surface-container text-on-surface hover:bg-surface-container-high'}">Critical</a>
                            <a href="${pageContext.request.contextPath}/teacher/violations?severity=HIGH" 
                               class="px-3 py-1 rounded-lg text-xs font-semibold ${selectedSeverity == 'HIGH' ? 'bg-amber-600 text-white' : 'bg-surface-container text-on-surface hover:bg-surface-container-high'}">High</a>
                            <a href="${pageContext.request.contextPath}/teacher/violations?severity=MEDIUM" 
                               class="px-3 py-1 rounded-lg text-xs font-semibold ${selectedSeverity == 'MEDIUM' ? 'bg-indigo-600 text-white' : 'bg-surface-container text-on-surface hover:bg-surface-container-high'}">Medium</a>
                            <a href="${pageContext.request.contextPath}/teacher/violations?severity=LOW" 
                               class="px-3 py-1 rounded-lg text-xs font-semibold ${selectedSeverity == 'LOW' ? 'bg-slate-700 text-white' : 'bg-surface-container text-on-surface hover:bg-surface-container-high'}">Low</a>
                        </div>
                    </div>
                </div>

                <!-- Log Events Table -->
                <div class="bg-surface-container-lowest rounded-2xl shadow-sm border border-surface-container-high overflow-hidden">
                    <div class="overflow-x-auto">
                        <table class="w-full text-left text-sm border-collapse">
                            <thead>
                                <tr class="bg-surface-container-low/60 text-xs font-mono font-bold uppercase text-on-surface-variant border-b border-surface-container-high">
                                    <th class="py-3 px-4">Timestamp</th>
                                    <th class="py-3 px-4">Candidate Identifier</th>
                                    <th class="py-3 px-4">Event Type</th>
                                    <th class="py-3 px-4">Severity</th>
                                    <th class="py-3 px-4">Audit Details</th>
                                    <th class="py-3 px-4 text-center">Review Status</th>
                                </tr>
                            </thead>
                            <tbody class="divide-y divide-surface-container-high/60 text-on-surface font-normal">
                                <c:choose>
                                    <c:when test="${empty violations}">
                                        <tr>
                                            <td colspan="6" class="text-center py-8 text-on-surface-variant text-sm">
                                                No violation activity recorded matching the selected filter criteria.
                                            </td>
                                        </tr>
                                    </c:when>
                                    <c:otherwise>
                                        <c:forEach var="v" items="${violations}">
                                            <tr class="hover:bg-surface-container-low/30 transition-colors">
                                                <td class="py-3 px-4 font-mono text-xs text-on-surface-variant whitespace-nowrap">
                                                    <c:out value="${v.timestampFormatted}"/>
                                                </td>
                                                <td class="py-3 px-4 whitespace-nowrap">
                                                    <div class="font-semibold text-xs text-on-surface"><c:out value="${v.studentName}"/></div>
                                                    <div class="font-mono text-[11px] text-primary"><c:out value="${v.studentIdentifier}"/></div>
                                                </td>
                                                <td class="py-3 px-4 font-mono text-xs font-bold text-on-surface whitespace-nowrap">
                                                    <c:out value="${v.eventType}"/>
                                                </td>
                                                <td class="py-3 px-4 whitespace-nowrap">
                                                    <c:choose>
                                                        <c:when test="${v.severity == 'CRITICAL'}">
                                                            <span class="px-2 py-0.5 rounded text-[11px] font-bold bg-rose-100 text-rose-800 border border-rose-300">CRITICAL</span>
                                                        </c:when>
                                                        <c:when test="${v.severity == 'HIGH'}">
                                                            <span class="px-2 py-0.5 rounded text-[11px] font-bold bg-amber-100 text-amber-800 border border-amber-300">HIGH</span>
                                                        </c:when>
                                                        <c:when test="${v.severity == 'MEDIUM'}">
                                                            <span class="px-2 py-0.5 rounded text-[11px] font-bold bg-indigo-100 text-indigo-800 border border-indigo-300">MEDIUM</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="px-2 py-0.5 rounded text-[11px] font-semibold bg-slate-100 text-slate-800 border border-slate-300"><c:out value="${v.severity}"/></span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td class="py-3 px-4 text-xs text-on-surface-variant">
                                                    <c:out value="${v.details}"/>
                                                </td>
                                                <td class="py-3 px-4 text-center whitespace-nowrap">
                                                    <c:choose>
                                                        <c:when test="${v.reviewed}">
                                                            <span class="inline-flex items-center gap-1 text-xs text-emerald-700 font-semibold">
                                                                <span class="material-symbols-outlined text-[16px]">check_circle</span>
                                                                <span>Reviewed</span>
                                                            </span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="inline-flex items-center gap-1 text-xs text-amber-700 font-semibold">
                                                                <span class="material-symbols-outlined text-[16px]">pending</span>
                                                                <span>Unreviewed</span>
                                                            </span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </c:otherwise>
                                </c:choose>
                            </tbody>
                        </table>
                    </div>
                </div>

            </div>
        </main>
    </div>
</body>
</html>
