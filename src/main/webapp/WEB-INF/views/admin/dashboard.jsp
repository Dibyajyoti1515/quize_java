<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en" class="h-full bg-[#f8faff]">
<head>
    <meta charset="utf-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Executive Admin Console | QuizTrack Enterprise</title>
    <link rel="preconnect" href="https://fonts.googleapis.com"/>
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin/>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=Plus+Jakarta+Sans:wght@500;600;700;800&family=JetBrains+Mono:wght@400;500;600&display=swap" rel="stylesheet"/>
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200" rel="stylesheet"/>
    <script src="https://cdn.tailwindcss.com"></script>
    <script>
        tailwind.config = {
            theme: {
                extend: {
                    fontFamily: {
                        sans: ['Plus Jakarta Sans', 'Inter', 'sans-serif'],
                        display: ['Plus Jakarta Sans', 'sans-serif'],
                        mono: ['JetBrains Mono', 'monospace'],
                    },
                    colors: {
                        primary: '#4f46e5',
                        'primary-dark': '#4338ca'
                    },
                    boxShadow: {
                        '2xs': '0 1px 2px 0 rgba(0, 0, 0, 0.05)'
                    }
                }
            }
        }
    </script>
    <style>
        .custom-scrollbar::-webkit-scrollbar {
            width: 6px;
            height: 6px;
        }
        .custom-scrollbar::-webkit-scrollbar-track {
            background: rgba(241, 245, 249, 0.8);
        }
        .custom-scrollbar::-webkit-scrollbar-thumb {
            background: rgba(203, 213, 225, 0.8);
            border-radius: 9999px;
        }
        .material-symbols-outlined {
            font-variation-settings: 'FILL' 0, 'wght' 500, 'GRAD' 0, 'opsz' 24;
        }
    </style>
</head>
<body class="h-full flex flex-col md:flex-row bg-[#f8faff] text-slate-800 font-sans selection:bg-indigo-600 selection:text-white">

    <!-- Sidebar Navigation -->
    <aside class="w-full md:w-64 bg-white border-r border-slate-200/90 flex flex-col shrink-0 shadow-2xs z-30">
        <!-- Brand Header -->
        <div class="p-5 border-b border-slate-100 flex items-center gap-3">
            <div class="w-10 h-10 rounded-xl bg-gradient-to-tr from-indigo-600 via-indigo-500 to-indigo-700 flex items-center justify-center text-white shadow-xs">
                <span class="material-symbols-outlined text-2xl font-bold">admin_panel_settings</span>
            </div>
            <div>
                <span class="font-display font-extrabold text-base tracking-tight text-slate-900 block">QuizTrack</span>
                <span class="text-[11px] font-mono uppercase tracking-wider text-indigo-600 font-semibold">Admin Gateway</span>
            </div>
        </div>

        <!-- Navigation Links -->
        <nav class="flex-1 p-3 space-y-1.5 overflow-y-auto custom-scrollbar">
            <a href="${pageContext.request.contextPath}/admin/dashboard" 
               class="flex items-center gap-3 px-3.5 py-2.5 rounded-xl font-semibold text-sm transition-all bg-indigo-600 text-white shadow-xs">
                <span class="material-symbols-outlined text-xl">dashboard</span>
                <span>Executive Overview</span>
            </a>

            <a href="${pageContext.request.contextPath}/admin/users" 
               class="flex items-center gap-3 px-3.5 py-2.5 rounded-xl font-medium text-sm transition-all text-slate-600 hover:text-slate-900 hover:bg-slate-100/80">
                <span class="material-symbols-outlined text-xl">group</span>
                <span>User Directory</span>
            </a>

            <a href="${pageContext.request.contextPath}/admin/departments" 
               class="flex items-center gap-3 px-3.5 py-2.5 rounded-xl font-medium text-sm transition-all text-slate-600 hover:text-slate-900 hover:bg-slate-100/80">
                <span class="material-symbols-outlined text-xl">domain</span>
                <span>Department Management</span>
            </a>

            <a href="${pageContext.request.contextPath}/admin/settings" 
               class="flex items-center gap-3 px-3.5 py-2.5 rounded-xl font-medium text-sm transition-all text-slate-600 hover:text-slate-900 hover:bg-slate-100/80">
                <span class="material-symbols-outlined text-xl">tune</span>
                <span>System Configuration</span>
            </a>

            <a href="${pageContext.request.contextPath}/admin/audit-logs" 
               class="flex items-center gap-3 px-3.5 py-2.5 rounded-xl font-medium text-sm transition-all text-slate-600 hover:text-slate-900 hover:bg-slate-100/80">
                <span class="material-symbols-outlined text-xl">security</span>
                <span>System Audit Logs</span>
            </a>
        </nav>

        <!-- Current User Profile & Sign Out Footer -->
        <div class="p-4 border-t border-slate-100 bg-slate-50/70">
            <div class="flex items-center justify-between">
                <div class="flex items-center gap-3 min-w-0">
                    <div class="w-9 h-9 rounded-xl bg-indigo-100 text-indigo-700 font-bold flex items-center justify-center shrink-0 text-sm border border-indigo-200">
                        ${currentUser.fullName != null ? currentUser.fullName.substring(0,1).toUpperCase() : 'A'}
                    </div>
                    <div class="min-w-0">
                        <span class="font-semibold text-xs text-slate-800 block truncate leading-tight">${currentUser.fullName}</span>
                        <span class="text-[10px] font-mono uppercase text-indigo-600 font-bold">ADMIN &bull; ${currentUser.identifier}</span>
                    </div>
                </div>
                <a href="${pageContext.request.contextPath}/auth/logout" class="p-2 rounded-lg text-slate-400 hover:text-rose-600 hover:bg-rose-50 transition-colors" title="Sign Out">
                    <span class="material-symbols-outlined text-lg">logout</span>
                </a>
            </div>
        </div>
    </aside>

    <!-- Main Content Area -->
    <div class="flex-1 flex flex-col min-w-0 overflow-y-auto custom-scrollbar">

        <!-- Top Header Bar -->
        <header class="h-16 border-b border-slate-200/90 bg-white/95 backdrop-blur-md px-6 flex items-center justify-between sticky top-0 z-20">
            <div class="flex items-center gap-3">
                <h1 class="font-display text-lg font-bold text-slate-900 tracking-tight">Executive System Console</h1>
                <span class="text-xs font-mono px-2.5 py-0.5 rounded-full bg-indigo-50 text-indigo-700 border border-indigo-200 font-semibold">Production Node</span>
            </div>

            <!-- Status Badges -->
            <div class="flex items-center gap-3">
                <c:choose>
                    <c:when test="${dashboardStats.maintenanceMode}">
                        <span class="inline-flex items-center gap-1.5 px-3 py-1 rounded-full text-xs font-semibold bg-amber-50 text-amber-700 border border-amber-200">
                            <span class="w-2 h-2 rounded-full bg-amber-500 animate-pulse"></span>
                            Maintenance Active
                        </span>
                    </c:when>
                    <c:otherwise>
                        <span class="inline-flex items-center gap-1.5 px-3 py-1 rounded-full text-xs font-semibold bg-emerald-50 text-emerald-700 border border-emerald-200">
                            <span class="w-2 h-2 rounded-full bg-emerald-500"></span>
                            System Operational
                        </span>
                    </c:otherwise>
                </c:choose>

                <c:if test="${dashboardStats.registrationEnabled}">
                    <span class="hidden sm:inline-flex items-center gap-1.5 px-3 py-1 rounded-full text-xs font-semibold bg-indigo-50 text-indigo-700 border border-indigo-200">
                        <span class="material-symbols-outlined text-[16px]">how_to_reg</span>
                        Self-Registration Open
                    </span>
                </c:if>

                <a href="${pageContext.request.contextPath}/admin/settings" class="p-2 rounded-xl bg-slate-100 hover:bg-slate-200 text-slate-600 hover:text-slate-900 transition-all" title="System Settings">
                    <span class="material-symbols-outlined text-xl">settings</span>
                </a>
            </div>
        </header>

        <!-- Main Dashboard View Container -->
        <main class="p-6 md:p-8 space-y-8 max-w-7xl mx-auto w-full">

            <!-- Banner / Greeting -->
            <div class="rounded-2xl p-6 sm:p-8 relative overflow-hidden bg-gradient-to-r from-indigo-600 to-indigo-800 text-white shadow-sm">
                <div class="absolute -right-16 -top-16 w-64 h-64 bg-white/10 rounded-full blur-2xl pointer-events-none"></div>
                <div class="relative z-10 flex flex-col md:flex-row md:items-center justify-between gap-4">
                    <div>
                        <div class="flex items-center gap-2 mb-1.5">
                            <span class="text-xs font-mono uppercase tracking-wider text-indigo-200 font-bold">Institutional Command Hub</span>
                            <span class="text-indigo-300">&bull;</span>
                            <span class="text-xs text-indigo-200"><c:out value="${dashboardStats.applicationName != null ? dashboardStats.applicationName : 'QuizTrack Examination System'}"/></span>
                        </div>
                        <h2 class="font-display text-2xl sm:text-3xl font-extrabold text-white">Welcome back, <c:out value="${currentUser.fullName}"/>.</h2>
                        <p class="text-sm text-indigo-100 mt-1 max-w-2xl leading-relaxed">
                            All operational metrics, user cohorts, and examination streams are synchronized from PostgreSQL.
                        </p>
                    </div>
                    <div class="flex items-center gap-3">
                        <a href="${pageContext.request.contextPath}/admin/users" class="px-4 py-2.5 rounded-xl bg-white text-indigo-700 hover:bg-indigo-50 font-semibold text-xs tracking-wide transition-all shadow-sm flex items-center gap-2">
                            <span class="material-symbols-outlined text-base">person_add</span>
                            <span>Manage Users</span>
                        </a>
                        <a href="${pageContext.request.contextPath}/admin/audit-logs" class="px-4 py-2.5 rounded-xl bg-indigo-700/80 hover:bg-indigo-700 text-white font-semibold text-xs tracking-wide transition-all border border-indigo-400/40 flex items-center gap-2">
                            <span class="material-symbols-outlined text-base">history</span>
                            <span>Audit Logs</span>
                        </a>
                    </div>
                </div>
            </div>

            <!-- Primary Metric Cards (6 KPI Cards) -->
            <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-6 gap-4">

                <!-- 1. Registered Students -->
                <div class="bg-white rounded-2xl p-5 shadow-2xs border border-slate-200/90 hover:shadow-sm transition-all">
                    <div class="flex items-center justify-between mb-3">
                        <div class="w-10 h-10 rounded-xl bg-indigo-50 text-indigo-600 flex items-center justify-center">
                            <span class="material-symbols-outlined text-2xl">school</span>
                        </div>
                        <span class="text-[10px] font-mono uppercase tracking-wider bg-indigo-50 px-2 py-0.5 rounded text-indigo-700 font-bold border border-indigo-100">Cohort</span>
                    </div>
                    <div class="font-display text-2xl sm:text-3xl font-extrabold text-slate-900"><c:out value="${dashboardStats.totalStudents}"/></div>
                    <div class="text-xs text-slate-500 font-semibold mt-0.5">Enrolled Students</div>
                </div>

                <!-- 2. Registered Teachers -->
                <div class="bg-white rounded-2xl p-5 shadow-2xs border border-slate-200/90 hover:shadow-sm transition-all">
                    <div class="flex items-center justify-between mb-3">
                        <div class="w-10 h-10 rounded-xl bg-amber-50 text-amber-600 flex items-center justify-center">
                            <span class="material-symbols-outlined text-2xl">badge</span>
                        </div>
                        <span class="text-[10px] font-mono uppercase tracking-wider bg-amber-50 px-2 py-0.5 rounded text-amber-700 font-bold border border-amber-100">Faculty</span>
                    </div>
                    <div class="font-display text-2xl sm:text-3xl font-extrabold text-slate-900"><c:out value="${dashboardStats.totalTeachers}"/></div>
                    <div class="text-xs text-slate-500 font-semibold mt-0.5">Academic Instructors</div>
                </div>

                <!-- 3. System Administrators -->
                <div class="bg-white rounded-2xl p-5 shadow-2xs border border-slate-200/90 hover:shadow-sm transition-all">
                    <div class="flex items-center justify-between mb-3">
                        <div class="w-10 h-10 rounded-xl bg-emerald-50 text-emerald-600 flex items-center justify-center">
                            <span class="material-symbols-outlined text-2xl">shield_person</span>
                        </div>
                        <span class="text-[10px] font-mono uppercase tracking-wider bg-emerald-50 px-2 py-0.5 rounded text-emerald-700 font-bold border border-emerald-100">Root</span>
                    </div>
                    <div class="font-display text-2xl sm:text-3xl font-extrabold text-slate-900"><c:out value="${dashboardStats.totalAdmins}"/></div>
                    <div class="text-xs text-slate-500 font-semibold mt-0.5">Active Administrators</div>
                </div>

                <!-- 4. Total Quizzes -->
                <div class="bg-white rounded-2xl p-5 shadow-2xs border border-slate-200/90 hover:shadow-sm transition-all">
                    <div class="flex items-center justify-between mb-3">
                        <div class="w-10 h-10 rounded-xl bg-sky-50 text-sky-600 flex items-center justify-center">
                            <span class="material-symbols-outlined text-2xl">quiz</span>
                        </div>
                        <span class="text-[10px] font-mono uppercase tracking-wider bg-sky-50 px-2 py-0.5 rounded text-sky-700 font-bold border border-sky-100">Repository</span>
                    </div>
                    <div class="font-display text-2xl sm:text-3xl font-extrabold text-slate-900"><c:out value="${dashboardStats.totalQuizzes}"/></div>
                    <div class="text-xs text-slate-500 font-semibold mt-0.5">Created Quizzes</div>
                </div>

                <!-- 5. Active Examinations -->
                <div class="bg-white rounded-2xl p-5 shadow-2xs border border-slate-200/90 hover:shadow-sm transition-all">
                    <div class="flex items-center justify-between mb-3">
                        <div class="w-10 h-10 rounded-xl bg-rose-50 text-rose-600 flex items-center justify-center">
                            <span class="material-symbols-outlined text-2xl">sensors</span>
                        </div>
                        <span class="text-[10px] font-mono uppercase tracking-wider bg-rose-50 px-2 py-0.5 rounded text-rose-700 font-bold border border-rose-100 flex items-center gap-1">
                            <span class="w-1.5 h-1.5 rounded-full bg-rose-500 animate-pulse"></span>
                            Live
                        </span>
                    </div>
                    <div class="font-display text-2xl sm:text-3xl font-extrabold text-slate-900"><c:out value="${dashboardStats.activeExaminations}"/></div>
                    <div class="text-xs text-slate-500 font-semibold mt-0.5">Active Exams Now</div>
                </div>

                <!-- 6. Completed Attempts -->
                <div class="bg-white rounded-2xl p-5 shadow-2xs border border-slate-200/90 hover:shadow-sm transition-all">
                    <div class="flex items-center justify-between mb-3">
                        <div class="w-10 h-10 rounded-xl bg-violet-50 text-violet-600 flex items-center justify-center">
                            <span class="material-symbols-outlined text-2xl">fact_check</span>
                        </div>
                        <span class="text-[10px] font-mono uppercase tracking-wider bg-violet-50 px-2 py-0.5 rounded text-violet-700 font-bold border border-violet-100">Graded</span>
                    </div>
                    <div class="font-display text-2xl sm:text-3xl font-extrabold text-slate-900"><c:out value="${dashboardStats.completedAttempts}"/></div>
                    <div class="text-xs text-slate-500 font-semibold mt-0.5">Certified Submissions</div>
                </div>

            </div>

            <!-- Detailed Grid: Performance Analytics & Audit Feed -->
            <div class="grid grid-cols-1 lg:grid-cols-3 gap-6">

                <!-- Left Column (2 Cols): Platform Health & User Distribution -->
                <div class="lg:col-span-2 space-y-6">

                    <!-- Examination Metrics Aggregation Card -->
                    <div class="bg-white rounded-2xl p-6 shadow-2xs border border-slate-200/90">
                        <div class="flex items-center justify-between mb-6">
                            <div>
                                <h3 class="font-display text-base font-bold text-slate-900">Institutional Examination Performance</h3>
                                <p class="text-xs text-slate-500 mt-0.5">Aggregated from completed exam sessions</p>
                            </div>
                            <span class="material-symbols-outlined text-indigo-600">analytics</span>
                        </div>

                        <div class="grid grid-cols-1 sm:grid-cols-3 gap-4">
                            <div class="p-4 rounded-xl bg-slate-50 border border-slate-200/80">
                                <span class="text-xs text-slate-500 font-semibold block mb-1">Average Exam Score</span>
                                <span class="font-display text-2xl font-bold text-slate-900">
                                    <fmt:formatNumber value="${dashboardStats.averageScorePercentage}" minFractionDigits="1" maxFractionDigits="1"/>%
                                </span>
                                <div class="w-full bg-slate-200 h-1.5 rounded-full mt-2.5 overflow-hidden">
                                    <div class="bg-indigo-600 h-1.5 rounded-full" style="width: ${dashboardStats.averageScorePercentage}%"></div>
                                </div>
                            </div>

                            <div class="p-4 rounded-xl bg-slate-50 border border-slate-200/80">
                                <span class="text-xs text-slate-500 font-semibold block mb-1">Overall Pass Rate</span>
                                <span class="font-display text-2xl font-bold text-emerald-600">
                                    <fmt:formatNumber value="${dashboardStats.overallPassRate}" minFractionDigits="1" maxFractionDigits="1"/>%
                                </span>
                                <div class="w-full bg-slate-200 h-1.5 rounded-full mt-2.5 overflow-hidden">
                                    <div class="bg-emerald-500 h-1.5 rounded-full" style="width: ${dashboardStats.overallPassRate}%"></div>
                                </div>
                            </div>

                            <div class="p-4 rounded-xl bg-slate-50 border border-slate-200/80">
                                <span class="text-xs text-slate-500 font-semibold block mb-1">Total Questions Seeded</span>
                                <span class="font-display text-2xl font-bold text-slate-900">
                                    <c:out value="${dashboardStats.totalQuestions}"/>
                                </span>
                                <div class="text-[11px] text-slate-500 mt-2 font-mono">
                                    Across all departmental subjects
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Department & Cohort Distribution -->
                    <div class="bg-white rounded-2xl p-6 shadow-2xs border border-slate-200/90">
                        <div class="flex items-center justify-between mb-4">
                            <div>
                                <h3 class="font-display text-base font-bold text-slate-900">Enrolled Student Cohort Distribution</h3>
                                <p class="text-xs text-slate-500 mt-0.5">Demographic breakdown across academic departments</p>
                            </div>
                            <span class="text-xs font-mono font-bold text-indigo-600 bg-indigo-50 border border-indigo-100 px-2.5 py-1 rounded-lg">
                                Total: <c:out value="${dashboardStats.totalUsers}"/> Users
                            </span>
                        </div>

                        <div class="space-y-4 pt-2">
                            <c:forEach var="trend" items="${dashboardStats.registrationTrends}">
                                <div>
                                    <div class="flex items-center justify-between text-xs mb-1.5 font-semibold">
                                        <span class="text-slate-700"><c:out value="${trend.label}"/></span>
                                        <span class="font-mono text-indigo-600"><c:out value="${trend.count}"/> users</span>
                                    </div>
                                    <div class="w-full bg-slate-100 h-2 rounded-full overflow-hidden border border-slate-200/80">
                                        <div class="bg-gradient-to-r from-indigo-600 to-indigo-500 h-2 rounded-full" style="width: ${dashboardStats.totalUsers > 0 ? (trend.count * 100 / dashboardStats.totalUsers) : 0}%"></div>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </div>

                </div>

                <!-- Right Column (1 Col): Recent System Audit Feed -->
                <div class="bg-white rounded-2xl p-6 shadow-2xs border border-slate-200/90 flex flex-col">
                    <div class="flex items-center justify-between mb-4 pb-2 border-b border-slate-100">
                        <div class="flex items-center gap-2">
                            <span class="material-symbols-outlined text-indigo-600 text-xl">shield</span>
                            <h3 class="font-display text-base font-bold text-slate-900">Live System Audit</h3>
                        </div>
                        <a href="${pageContext.request.contextPath}/admin/audit-logs" class="text-xs text-indigo-600 hover:text-indigo-700 font-bold">
                            Full Log &rarr;
                        </a>
                    </div>

                    <div class="space-y-3 overflow-y-auto max-h-[460px] custom-scrollbar pr-1 flex-1">
                        <c:choose>
                            <c:when test="${not empty dashboardStats.recentActivities}">
                                <c:forEach var="act" items="${dashboardStats.recentActivities}">
                                    <div class="p-3.5 rounded-xl bg-slate-50 border border-slate-200/70 hover:bg-slate-100/70 transition-colors">
                                        <div class="flex items-center justify-between mb-1.5">
                                            <span class="text-[10px] font-mono px-2 py-0.5 rounded font-bold
                                                <c:choose>
                                                    <c:when test="${act.severity == 'CRITICAL'}">bg-rose-50 text-rose-700 border border-rose-200</c:when>
                                                    <c:when test="${act.severity == 'CAUTION'}">bg-amber-50 text-amber-700 border border-amber-200</c:when>
                                                    <c:otherwise>bg-slate-200/70 text-slate-700 border border-slate-300</c:otherwise>
                                                </c:choose>">
                                                <c:out value="${act.eventType}"/>
                                            </span>
                                            <span class="text-[10px] font-mono text-slate-400 font-semibold"><c:out value="${act.formattedTimestamp}"/></span>
                                        </div>
                                        <p class="text-xs text-slate-700 leading-relaxed"><c:out value="${act.details}"/></p>
                                        <div class="mt-2 text-[10px] text-slate-500 font-mono flex items-center justify-between">
                                            <span>Actor: <strong class="text-slate-700 font-semibold"><c:out value="${act.userName}"/></strong></span>
                                            <c:if test="${not empty act.targetUserName}">
                                                <span>Target: <strong class="text-slate-700 font-semibold"><c:out value="${act.targetUserName}"/></strong></span>
                                            </c:if>
                                        </div>
                                    </div>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <div class="text-center py-8 text-slate-400 text-xs">
                                    No audit entries recorded yet.
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <div class="mt-4 pt-4 border-t border-slate-100 flex items-center justify-between text-xs text-slate-500 font-mono">
                        <span class="flex items-center gap-1.5 text-emerald-600 font-semibold">
                            <span class="w-1.5 h-1.5 rounded-full bg-emerald-500"></span>
                            Telemetry Active
                        </span>
                        <span class="text-slate-400">PostgreSQL 17 JDBC</span>
                    </div>
                </div>

            </div>

        </main>
    </div>

</body>
</html>
