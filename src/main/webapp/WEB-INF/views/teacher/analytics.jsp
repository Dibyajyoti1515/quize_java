<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Faculty Analytics &amp; Academic Performance | QuizTrack</title>
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
                        <div class="flex items-center gap-2 text-xs font-mono font-semibold text-primary uppercase">
                            <span>Assessment Intelligence</span>
                            <span>•</span>
                            <span>Cohort Mastery</span>
                        </div>
                        <h1 class="text-2xl sm:text-3xl font-display font-bold text-on-surface mt-1">Faculty Analytics &amp; Performance</h1>
                        <p class="text-sm text-on-surface-variant mt-1">
                            Longitudinal score distribution, cohort benchmarking, and conceptual domain mastery telemetry.
                        </p>
                    </div>
                </div>

                <!-- KPI Metric Grid -->
                <div class="grid grid-cols-1 sm:grid-cols-3 gap-6">
                    <div class="bg-surface-container-lowest p-6 rounded-2xl border border-surface-container-high shadow-xs flex items-center gap-4">
                        <div class="w-12 h-12 rounded-xl bg-primary-container text-on-primary flex items-center justify-center font-bold shadow-sm">
                            <span class="material-symbols-outlined text-[24px]">grade</span>
                        </div>
                        <div>
                            <span class="text-xs font-mono font-semibold text-on-surface-variant uppercase">Average Class Benchmark</span>
                            <p class="text-2xl font-bold font-display text-on-surface mt-0.5"><c:out value="${avgScore}"/>%</p>
                        </div>
                    </div>

                    <div class="bg-surface-container-lowest p-6 rounded-2xl border border-surface-container-high shadow-xs flex items-center gap-4">
                        <div class="w-12 h-12 rounded-xl bg-emerald-600 text-white flex items-center justify-center font-bold shadow-sm">
                            <span class="material-symbols-outlined text-[24px]">verified_user</span>
                        </div>
                        <div>
                            <span class="text-xs font-mono font-semibold text-on-surface-variant uppercase">Proctor Trust Index</span>
                            <p class="text-2xl font-bold font-display text-emerald-700 mt-0.5"><c:out value="${trustIndex}"/>%</p>
                        </div>
                    </div>

                    <div class="bg-surface-container-lowest p-6 rounded-2xl border border-surface-container-high shadow-xs flex items-center gap-4">
                        <div class="w-12 h-12 rounded-xl bg-indigo-600 text-white flex items-center justify-center font-bold shadow-sm">
                            <span class="material-symbols-outlined text-[24px]">task_alt</span>
                        </div>
                        <div>
                            <span class="text-xs font-mono font-semibold text-on-surface-variant uppercase">Completed Sessions</span>
                            <p class="text-2xl font-bold font-display text-on-surface mt-0.5"><c:out value="${completedSessions}"/></p>
                        </div>
                    </div>
                </div>

                <!-- 2-Column: Cohort Comparisons & Topic Mastery -->
                <div class="grid grid-cols-1 lg:grid-cols-2 gap-6">
                    <!-- Cohort Metrics Table -->
                    <div class="bg-surface-container-lowest p-6 rounded-2xl border border-surface-container-high shadow-xs flex flex-col justify-between">
                        <div>
                            <h2 class="text-lg font-display font-bold text-on-surface mb-4 flex items-center gap-2">
                                <span class="material-symbols-outlined text-primary text-[20px]">groups</span>
                                <span>Cohort Performance Benchmarking</span>
                            </h2>
                            <div class="overflow-x-auto">
                                <table class="w-full text-left text-sm border-collapse">
                                    <thead>
                                        <tr class="bg-surface-container-low text-xs font-mono font-bold uppercase text-on-surface-variant border-b border-surface-container-high">
                                            <th class="py-2.5 px-3">Cohort Code</th>
                                            <th class="py-2.5 px-3">Average Score</th>
                                            <th class="py-2.5 px-3">Attendance</th>
                                            <th class="py-2.5 px-3">Pass Rate</th>
                                        </tr>
                                    </thead>
                                    <tbody class="divide-y divide-surface-container-high/60">
                                        <c:forEach var="cm" items="${cohortMetrics}">
                                            <tr class="hover:bg-surface-container-low/30">
                                                <td class="py-2.5 px-3 font-mono font-bold text-xs text-primary">
                                                    <c:out value="${cm.cohortName}"/>
                                                </td>
                                                <td class="py-2.5 px-3 font-semibold text-on-surface">
                                                    <c:out value="${cm.averageScore}"/>%
                                                </td>
                                                <td class="py-2.5 px-3 text-xs font-mono">
                                                    <c:out value="${cm.attendanceRate}"/>%
                                                </td>
                                                <td class="py-2.5 px-3 font-semibold text-xs text-emerald-700">
                                                    <c:out value="${cm.passRate}"/>%
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>

                    <!-- Conceptual Domain Mastery -->
                    <div class="bg-surface-container-lowest p-6 rounded-2xl border border-surface-container-high shadow-xs">
                        <h2 class="text-lg font-display font-bold text-on-surface mb-4 flex items-center gap-2">
                            <span class="material-symbols-outlined text-primary text-[20px]">psychology</span>
                            <span>Conceptual Domain Mastery</span>
                        </h2>
                        <div class="flex flex-col gap-3.5">
                            <c:forEach var="tm" items="${topicMastery}">
                                <div class="p-3.5 rounded-xl bg-surface-container-low/40 border border-surface-container-high flex flex-col gap-2">
                                    <div class="flex items-center justify-between">
                                        <span class="font-semibold text-xs text-on-surface"><c:out value="${tm.topicName}"/></span>
                                        <span class="font-mono text-xs font-bold text-primary"><c:out value="${tm.masteryPercentage}"/>%</span>
                                    </div>
                                    <div class="w-full bg-surface-container rounded-full h-2 overflow-hidden">
                                        <div class="bg-primary h-2 rounded-full transition-all" style="width: ${tm.masteryPercentage}%"></div>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </div>
                </div>

            </div>
        </main>
    </div>
</body>
</html>
