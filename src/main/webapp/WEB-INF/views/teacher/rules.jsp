<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Proctor Rules Engine &amp; Security Presets | QuizTrack</title>
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
                            <span>Integrity Governance</span>
                            <span>•</span>
                            <span>Rules Engine</span>
                        </div>
                        <h1 class="text-2xl sm:text-3xl font-display font-bold text-on-surface mt-1">Proctor Rules &amp; Anti-Cheat Presets</h1>
                        <p class="text-sm text-on-surface-variant mt-1">
                            Anti-cheat surveillance profiles, hardware calibration constraints, and global assessment thresholds.
                        </p>
                    </div>
                </div>

                <!-- 3 Preset Profiles -->
                <div>
                    <h2 class="text-lg font-display font-bold text-on-surface mb-3 flex items-center gap-2">
                        <span class="material-symbols-outlined text-primary text-[20px]">security</span>
                        <span>Security Level Presets</span>
                    </h2>

                    <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
                        <!-- Level 1 -->
                        <div class="bg-surface-container-lowest p-6 rounded-2xl border border-surface-container-high shadow-xs flex flex-col justify-between">
                            <div>
                                <div class="flex items-center justify-between mb-3">
                                    <span class="px-2.5 py-1 rounded-md bg-surface-container text-on-surface font-mono text-xs font-bold">
                                        LEVEL 1
                                    </span>
                                    <span class="text-xs font-semibold text-emerald-700">Lenient</span>
                                </div>
                                <h3 class="font-display font-bold text-base text-on-surface">Standard Diagnostic</h3>
                                <p class="text-xs text-on-surface-variant mt-1 leading-relaxed">
                                    Recommended for formative self-assessments, practice quizzes, and homework reviews.
                                </p>
                                <ul class="mt-4 space-y-2 text-xs text-on-surface-variant">
                                    <li class="flex items-center gap-2">
                                        <span class="material-symbols-outlined text-emerald-600 text-[16px]">check</span>
                                        <span>Up to 5 tab switches allowed</span>
                                    </li>
                                    <li class="flex items-center gap-2">
                                        <span class="material-symbols-outlined text-emerald-600 text-[16px]">check</span>
                                        <span>Soft blur warning modal</span>
                                    </li>
                                    <li class="flex items-center gap-2">
                                        <span class="material-symbols-outlined text-slate-400 text-[16px]">close</span>
                                        <span>No webcam requirement</span>
                                    </li>
                                </ul>
                            </div>
                        </div>

                        <!-- Level 2 -->
                        <div class="bg-surface-container-lowest p-6 rounded-2xl border-2 border-primary shadow-xs flex flex-col justify-between relative">
                            <span class="absolute -top-3 right-6 px-2.5 py-0.5 rounded-full bg-primary text-on-primary text-[10px] font-bold uppercase tracking-wider">
                                Recommended
                            </span>
                            <div>
                                <div class="flex items-center justify-between mb-3">
                                    <span class="px-2.5 py-1 rounded-md bg-primary-container text-on-primary font-mono text-xs font-bold">
                                        LEVEL 2
                                    </span>
                                    <span class="text-xs font-semibold text-primary">Balanced</span>
                                </div>
                                <h3 class="font-display font-bold text-base text-on-surface">Supervised Assessment</h3>
                                <p class="text-xs text-on-surface-variant mt-1 leading-relaxed">
                                    Recommended for weekly graded chapter tests, quizzes, and standard coursework examinations.
                                </p>
                                <ul class="mt-4 space-y-2 text-xs text-on-surface-variant">
                                    <li class="flex items-center gap-2">
                                        <span class="material-symbols-outlined text-emerald-600 text-[16px]">check</span>
                                        <span>Mandatory fullscreen sandbox</span>
                                    </li>
                                    <li class="flex items-center gap-2">
                                        <span class="material-symbols-outlined text-emerald-600 text-[16px]">check</span>
                                        <span>Strict 3 tab switch threshold</span>
                                    </li>
                                    <li class="flex items-center gap-2">
                                        <span class="material-symbols-outlined text-emerald-600 text-[16px]">check</span>
                                        <span>Question &amp; option sequence shuffle</span>
                                    </li>
                                </ul>
                            </div>
                        </div>

                        <!-- Level 3 -->
                        <div class="bg-surface-container-lowest p-6 rounded-2xl border border-surface-container-high shadow-xs flex flex-col justify-between">
                            <div>
                                <div class="flex items-center justify-between mb-3">
                                    <span class="px-2.5 py-1 rounded-md bg-rose-600 text-white font-mono text-xs font-bold">
                                        LEVEL 3
                                    </span>
                                    <span class="text-xs font-semibold text-rose-700">High Stakes</span>
                                </div>
                                <h3 class="font-display font-bold text-base text-on-surface">Strict Proctoring</h3>
                                <p class="text-xs text-on-surface-variant mt-1 leading-relaxed">
                                    Recommended for Midterm, Final Exams, and competitive certification assessments.
                                </p>
                                <ul class="mt-4 space-y-2 text-xs text-on-surface-variant">
                                    <li class="flex items-center gap-2">
                                        <span class="material-symbols-outlined text-emerald-600 text-[16px]">check</span>
                                        <span>Continuous camera presence check</span>
                                    </li>
                                    <li class="flex items-center gap-2">
                                        <span class="material-symbols-outlined text-emerald-600 text-[16px]">check</span>
                                        <span>Instant session lockout on second violation</span>
                                    </li>
                                    <li class="flex items-center gap-2">
                                        <span class="material-symbols-outlined text-emerald-600 text-[16px]">check</span>
                                        <span>Negative deduction marking enabled</span>
                                    </li>
                                </ul>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Global System Configuration Thresholds -->
                <div class="bg-surface-container-lowest rounded-2xl shadow-sm border border-surface-container-high overflow-hidden">
                    <div class="p-5 border-b border-surface-container-high">
                        <h2 class="text-lg font-display font-bold text-on-surface flex items-center gap-2">
                            <span class="material-symbols-outlined text-primary text-[20px]">tune</span>
                            <span>System Configuration Defaults &amp; Guardrails</span>
                        </h2>
                    </div>
                    <div class="p-5 grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4">
                        <div class="p-4 rounded-xl bg-surface-container-low border border-surface-container">
                            <span class="text-xs font-mono font-semibold text-on-surface-variant uppercase">Max Allowed Duration</span>
                            <p class="text-xl font-bold font-display text-on-surface mt-1"><c:out value="${maxDuration}"/> Minutes</p>
                            <span class="text-[11px] text-on-surface-variant mt-0.5 block">Upper bound enforcement for any assessment</span>
                        </div>

                        <div class="p-4 rounded-xl bg-surface-container-low border border-surface-container">
                            <span class="text-xs font-mono font-semibold text-on-surface-variant uppercase">Default Exam Duration</span>
                            <p class="text-xl font-bold font-display text-on-surface mt-1"><c:out value="${defaultDuration}"/> Minutes</p>
                            <span class="text-[11px] text-on-surface-variant mt-0.5 block">Pre-filled on quiz creation step 1</span>
                        </div>

                        <div class="p-4 rounded-xl bg-surface-container-low border border-surface-container">
                            <span class="text-xs font-mono font-semibold text-on-surface-variant uppercase">Default Passing Benchmark</span>
                            <p class="text-xl font-bold font-display text-on-surface mt-1"><c:out value="${defaultPassPercentage}"/>%</p>
                            <span class="text-[11px] text-on-surface-variant mt-0.5 block">Passing score benchmark</span>
                        </div>

                        <div class="p-4 rounded-xl bg-surface-container-low border border-surface-container">
                            <span class="text-xs font-mono font-semibold text-on-surface-variant uppercase">Maintenance State</span>
                            <p class="text-xl font-bold font-display ${maintenanceMode ? 'text-rose-600' : 'text-emerald-700'} mt-1">
                                <c:choose>
                                    <c:when test="${maintenanceMode}">ACTIVE (Paused)</c:when>
                                    <c:otherwise>NORMAL (Online)</c:otherwise>
                                </c:choose>
                            </p>
                            <span class="text-[11px] text-on-surface-variant mt-0.5 block">Operational mode</span>
                        </div>
                    </div>
                </div>

            </div>
        </main>
    </div>
</body>
</html>
