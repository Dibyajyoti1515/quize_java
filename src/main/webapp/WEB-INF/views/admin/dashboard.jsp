<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en" class="h-full bg-slate-950">
<head>
    <meta charset="utf-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Executive Admin Console | QuizTrack Enterprise</title>
    <link rel="preconnect" href="https://fonts.googleapis.com"/>
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin/>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&family=Plus+Jakarta+Sans:wght@500;600;700;800&family=JetBrains+Mono:wght@400;500;600&display=swap" rel="stylesheet"/>
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200" rel="stylesheet"/>
    <script src="https://cdn.tailwindcss.com"></script>
    <script>
        tailwind.config = {
            theme: {
                extend: {
                    fontFamily: {
                        sans: ['Plus Jakarta Sans', 'Inter', 'sans-serif'],
                        mono: ['JetBrains Mono', 'monospace'],
                    },
                    colors: {
                        brand: {
                            50: '#eef2ff',
                            100: '#e0e7ff',
                            500: '#6366f1',
                            600: '#4f46e5',
                            700: '#4338ca',
                            900: '#312e81'
                        }
                    }
                }
            }
        }
    </script>
    <style>
        .glass-card {
            background: rgba(15, 23, 42, 0.75);
            backdrop-filter: blur(12px);
            border: 1px solid rgba(255, 255, 255, 0.08);
        }
        .custom-scrollbar::-webkit-scrollbar {
            width: 6px;
            height: 6px;
        }
        .custom-scrollbar::-webkit-scrollbar-track {
            background: rgba(15, 23, 42, 0.5);
        }
        .custom-scrollbar::-webkit-scrollbar-thumb {
            background: rgba(100, 116, 139, 0.4);
            border-radius: 9999px;
        }
    </style>
</head>
<body class="h-full flex flex-col md:flex-row bg-slate-950 text-slate-100 font-sans selection:bg-brand-600 selection:text-white">

    <!-- Sidebar Navigation -->
    <aside class="w-full md:w-64 bg-slate-900 border-r border-slate-800 flex flex-col shrink-0">
        <!-- Brand Header -->
        <div class="p-5 border-b border-slate-800 flex items-center gap-3">
            <div class="w-10 h-10 rounded-xl bg-gradient-to-tr from-indigo-600 via-indigo-500 to-cyan-400 flex items-center justify-center text-white shadow-lg shadow-indigo-500/20">
                <span class="material-symbols-Outlined text-2xl font-bold">admin_panel_settings</span>
            </div>
            <div>
                <span class="font-extrabold text-base tracking-tight text-white block">QuizTrack™</span>
                <span class="text-[11px] font-mono uppercase tracking-wider text-indigo-400 font-semibold">Admin Gateway</span>
            </div>
        </div>

        <!-- Navigation Links -->
        <nav class="flex-1 p-3 space-y-1.5 overflow-y-auto custom-scrollbar">
            <a href="${pageContext.request.contextPath}/admin/dashboard" 
               class="flex items-center gap-3 px-3.5 py-2.5 rounded-xl font-medium text-sm transition-all bg-indigo-600/15 text-indigo-400 border border-indigo-500/30">
                <span class="material-symbols-Outlined text-xl">dashboard</span>
                <span>Executive Overview</span>
            </a>

            <a href="${pageContext.request.contextPath}/admin/users" 
               class="flex items-center gap-3 px-3.5 py-2.5 rounded-xl font-medium text-sm transition-all text-slate-400 hover:text-slate-200 hover:bg-slate-800/60">
                <span class="material-symbols-Outlined text-xl">group</span>
                <span>User Directory</span>
            </a>

            <a href="${pageContext.request.contextPath}/admin/settings" 
               class="flex items-center gap-3 px-3.5 py-2.5 rounded-xl font-medium text-sm transition-all text-slate-400 hover:text-slate-200 hover:bg-slate-800/60">
                <span class="material-symbols-Outlined text-xl">tune</span>
                <span>System Configuration</span>
            </a>

            <a href="${pageContext.request.contextPath}/admin/audit-logs" 
               class="flex items-center gap-3 px-3.5 py-2.5 rounded-xl font-medium text-sm transition-all text-slate-400 hover:text-slate-200 hover:bg-slate-800/60">
                <span class="material-symbols-Outlined text-xl">security</span>
                <span>System Audit Logs</span>
            </a>

            <div class="pt-4 pb-1 px-3">
                <span class="text-[10px] font-mono uppercase tracking-wider text-slate-400 font-semibold">Faculty / Student Views</span>
            </div>

            <a href="${pageContext.request.contextPath}/teacher/dashboard" 
               class="flex items-center gap-3 px-3.5 py-2.5 rounded-xl font-medium text-sm transition-all text-slate-400 hover:text-amber-300 hover:bg-slate-800/60">
                <span class="material-symbols-Outlined text-xl text-amber-400">school</span>
                <span>Teacher Workspace</span>
            </a>

            <a href="${pageContext.request.contextPath}/student/dashboard" 
               class="flex items-center gap-3 px-3.5 py-2.5 rounded-xl font-medium text-sm transition-all text-slate-400 hover:text-cyan-300 hover:bg-slate-800/60">
                <span class="material-symbols-Outlined text-xl text-cyan-400">person</span>
                <span>Student Portal</span>
            </a>
        </nav>

        <!-- Current Admin Identity Footer -->
        <div class="p-4 border-t border-slate-800 bg-slate-900/60">
            <div class="flex items-center justify-between">
                <div class="flex items-center gap-2.5 min-w-0">
                    <div class="w-8 h-8 rounded-full bg-indigo-500/20 border border-indigo-500/30 flex items-center justify-center text-indigo-300 font-bold text-xs shrink-0">
                        <c:out value="${currentUser.fullName.substring(0, 1)}"/>
                    </div>
                    <div class="min-w-0">
                        <span class="font-semibold text-xs text-white block truncate"><c:out value="${currentUser.fullName}"/></span>
                        <span class="text-[10px] font-mono text-emerald-400 block truncate">ADMIN • <c:out value="${currentUser.identifier}"/></span>
                    </div>
                </div>
                <a href="${pageContext.request.contextPath}/auth/logout" 
                   title="Sign Out" 
                   class="p-1.5 rounded-lg text-slate-400 hover:text-rose-400 hover:bg-rose-500/10 transition-colors">
                    <span class="material-symbols-Outlined text-lg">logout</span>
                </a>
            </div>
        </div>
    </aside>

    <!-- Main Content Area -->
    <div class="flex-1 flex flex-col min-w-0 overflow-y-auto custom-scrollbar">

        <!-- Top Header Bar -->
        <header class="h-16 border-b border-slate-800 bg-slate-900/40 backdrop-blur px-6 flex items-center justify-between sticky top-0 z-20">
            <div class="flex items-center gap-3">
                <h1 class="text-lg font-bold text-white tracking-tight">Executive System Console</h1>
                <span class="text-xs font-mono px-2 py-0.5 rounded-full bg-indigo-500/10 text-indigo-400 border border-indigo-500/20">Production Node</span>
            </div>

            <!-- Status Badges -->
            <div class="flex items-center gap-3">
                <c:choose>
                    <c:when test="${dashboardStats.maintenanceMode}">
                        <span class="inline-flex items-center gap-1.5 px-2.5 py-1 rounded-full text-xs font-medium bg-amber-500/15 text-amber-300 border border-amber-500/30">
                            <span class="w-2 h-2 rounded-full bg-amber-400 animate-pulse"></span>
                            Maintenance Active
                        </span>
                    </c:when>
                    <c:otherwise>
                        <span class="inline-flex items-center gap-1.5 px-2.5 py-1 rounded-full text-xs font-medium bg-emerald-500/15 text-emerald-300 border border-emerald-500/30">
                            <span class="w-2 h-2 rounded-full bg-emerald-400"></span>
                            System Operational
                        </span>
                    </c:otherwise>
                </c:choose>

                <c:if test="${dashboardStats.registrationEnabled}">
                    <span class="hidden sm:inline-flex items-center gap-1.5 px-2.5 py-1 rounded-full text-xs font-medium bg-cyan-500/15 text-cyan-300 border border-cyan-500/30">
                        <span class="material-symbols-Outlined text-sm">how_to_reg</span>
                        Self-Registration Open
                    </span>
                </c:if>

                <a href="${pageContext.request.contextPath}/admin/settings" class="p-2 rounded-xl bg-slate-800/80 hover:bg-slate-700/80 text-slate-300 hover:text-white transition-all" title="System Settings">
                    <span class="material-symbols-Outlined text-xl">settings</span>
                </a>
            </div>
        </header>

        <!-- Main Dashboard View Container -->
        <main class="p-6 md:p-8 space-y-8 max-w-7xl mx-auto w-full">

            <!-- Banner / Greeting -->
            <div class="glass-card rounded-2xl p-6 relative overflow-hidden border border-indigo-500/20 bg-gradient-to-r from-slate-900 via-indigo-950/30 to-slate-900">
                <div class="absolute -right-16 -top-16 w-64 h-64 bg-indigo-500/10 rounded-full blur-3xl pointer-events-none"></div>
                <div class="relative z-10 flex flex-col md:flex-row md:items-center justify-between gap-4">
                    <div>
                        <div class="flex items-center gap-2 mb-1">
                            <span class="text-xs font-mono uppercase tracking-wider text-indigo-400 font-semibold">Institutional Command Hub</span>
                            <span class="text-slate-400">•</span>
                            <span class="text-xs text-slate-400"><c:out value="${dashboardStats.applicationName != null ? dashboardStats.applicationName : 'QuizTrack Examination System'}"/></span>
                        </div>
                        <h2 class="text-2xl font-extrabold text-white">Welcome back, <c:out value="${currentUser.fullName}"/>.</h2>
                        <p class="text-sm text-slate-400 mt-1 max-w-2xl">
                            All operational metrics, user cohorts, and examination streams are synchronized from PostgreSQL.
                        </p>
                    </div>
                    <div class="flex items-center gap-3">
                        <a href="${pageContext.request.contextPath}/admin/users" class="px-4 py-2.5 rounded-xl bg-indigo-600 hover:bg-indigo-500 text-white font-semibold text-xs tracking-wide transition-all shadow-lg shadow-indigo-600/30 flex items-center gap-2">
                            <span class="material-symbols-Outlined text-base">person_add</span>
                            <span>Manage Users</span>
                        </a>
                        <a href="${pageContext.request.contextPath}/admin/audit-logs" class="px-4 py-2.5 rounded-xl bg-slate-800 hover:bg-slate-700 text-slate-200 font-semibold text-xs tracking-wide transition-all border border-slate-700 flex items-center gap-2">
                            <span class="material-symbols-Outlined text-base">history</span>
                            <span>Audit Logs</span>
                        </a>
                    </div>
                </div>
            </div>

            <!-- Primary Metric Cards (6 KPI Cards) -->
            <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-6 gap-4">

                <!-- 1. Registered Students -->
                <div class="glass-card rounded-2xl p-4 border-slate-800 hover:border-indigo-500/40 transition-all">
                    <div class="flex items-center justify-between text-indigo-400 mb-2">
                        <span class="material-symbols-Outlined text-2xl">school</span>
                        <span class="text-[10px] font-mono uppercase tracking-wider bg-indigo-500/10 px-2 py-0.5 rounded text-indigo-300">Cohort</span>
                    </div>
                    <div class="text-2xl font-extrabold text-white"><c:out value="${dashboardStats.totalStudents}"/></div>
                    <div class="text-xs text-slate-400 font-medium mt-0.5">Enrolled Students</div>
                </div>

                <!-- 2. Registered Teachers -->
                <div class="glass-card rounded-2xl p-4 border-slate-800 hover:border-amber-500/40 transition-all">
                    <div class="flex items-center justify-between text-amber-400 mb-2">
                        <span class="material-symbols-Outlined text-2xl">badge</span>
                        <span class="text-[10px] font-mono uppercase tracking-wider bg-amber-500/10 px-2 py-0.5 rounded text-amber-300">Faculty</span>
                    </div>
                    <div class="text-2xl font-extrabold text-white"><c:out value="${dashboardStats.totalTeachers}"/></div>
                    <div class="text-xs text-slate-400 font-medium mt-0.5">Academic Instructors</div>
                </div>

                <!-- 3. System Administrators -->
                <div class="glass-card rounded-2xl p-4 border-slate-800 hover:border-emerald-500/40 transition-all">
                    <div class="flex items-center justify-between text-emerald-400 mb-2">
                        <span class="material-symbols-Outlined text-2xl">shield_person</span>
                        <span class="text-[10px] font-mono uppercase tracking-wider bg-emerald-500/10 px-2 py-0.5 rounded text-emerald-300">Root</span>
                    </div>
                    <div class="text-2xl font-extrabold text-white"><c:out value="${dashboardStats.totalAdmins}"/></div>
                    <div class="text-xs text-slate-400 font-medium mt-0.5">Active Administrators</div>
                </div>

                <!-- 4. Total Quizzes -->
                <div class="glass-card rounded-2xl p-4 border-slate-800 hover:border-cyan-500/40 transition-all">
                    <div class="flex items-center justify-between text-cyan-400 mb-2">
                        <span class="material-symbols-Outlined text-2xl">quiz</span>
                        <span class="text-[10px] font-mono uppercase tracking-wider bg-cyan-500/10 px-2 py-0.5 rounded text-cyan-300">Repository</span>
                    </div>
                    <div class="text-2xl font-extrabold text-white"><c:out value="${dashboardStats.totalQuizzes}"/></div>
                    <div class="text-xs text-slate-400 font-medium mt-0.5">Created Quizzes</div>
                </div>

                <!-- 5. Active Examinations -->
                <div class="glass-card rounded-2xl p-4 border-slate-800 hover:border-rose-500/40 transition-all">
                    <div class="flex items-center justify-between text-rose-400 mb-2">
                        <span class="material-symbols-Outlined text-2xl">sensors</span>
                        <span class="text-[10px] font-mono uppercase tracking-wider bg-rose-500/10 px-2 py-0.5 rounded text-rose-300">Live</span>
                    </div>
                    <div class="text-2xl font-extrabold text-white"><c:out value="${dashboardStats.activeExaminations}"/></div>
                    <div class="text-xs text-slate-400 font-medium mt-0.5">Active Exams Now</div>
                </div>

                <!-- 6. Completed Attempts -->
                <div class="glass-card rounded-2xl p-4 border-slate-800 hover:border-purple-500/40 transition-all">
                    <div class="flex items-center justify-between text-purple-400 mb-2">
                        <span class="material-symbols-Outlined text-2xl">fact_check</span>
                        <span class="text-[10px] font-mono uppercase tracking-wider bg-purple-500/10 px-2 py-0.5 rounded text-purple-300">Graded</span>
                    </div>
                    <div class="text-2xl font-extrabold text-white"><c:out value="${dashboardStats.completedAttempts}"/></div>
                    <div class="text-xs text-slate-400 font-medium mt-0.5">Certified Submissions</div>
                </div>
            </div>

            <!-- Two-Column Operational Analysis & Audit Feed -->
            <div class="grid grid-cols-1 lg:grid-cols-3 gap-8">

                <!-- Left Column (2 Cols): Academic Performance & Cohort Distribution -->
                <div class="lg:col-span-2 space-y-6">

                    <!-- Performance Overview Strip -->
                    <div class="glass-card rounded-2xl p-6 border-slate-800">
                        <div class="flex items-center justify-between mb-4">
                            <div>
                                <h3 class="text-base font-bold text-white">Institutional Examination Performance</h3>
                                <p class="text-xs text-slate-400">Aggregated from completed exam sessions</p>
                            </div>
                            <span class="material-symbols-Outlined text-slate-400">analytics</span>
                        </div>

                        <div class="grid grid-cols-1 sm:grid-cols-3 gap-4 pt-2">
                            <div class="p-4 rounded-xl bg-slate-900/80 border border-slate-800">
                                <span class="text-xs text-slate-400 block mb-1">Average Exam Score</span>
                                <span class="text-2xl font-extrabold text-white"><c:out value="${dashboardStats.averageScorePercentage}"/>%</span>
                                <div class="w-full bg-slate-800 h-1.5 rounded-full mt-2 overflow-hidden">
                                    <div class="bg-indigo-500 h-1.5 rounded-full" style="width: ${dashboardStats.averageScorePercentage}%"></div>
                                </div>
                            </div>

                            <div class="p-4 rounded-xl bg-slate-900/80 border border-slate-800">
                                <span class="text-xs text-slate-400 block mb-1">Overall Pass Rate</span>
                                <span class="text-2xl font-extrabold text-emerald-400"><c:out value="${dashboardStats.overallPassRate}"/>%</span>
                                <div class="w-full bg-slate-800 h-1.5 rounded-full mt-2 overflow-hidden">
                                    <div class="bg-emerald-500 h-1.5 rounded-full" style="width: ${dashboardStats.overallPassRate}%"></div>
                                </div>
                            </div>

                            <div class="p-4 rounded-xl bg-slate-900/80 border border-slate-800">
                                <span class="text-xs text-slate-400 block mb-1">Total Question Items</span>
                                <span class="text-2xl font-extrabold text-cyan-400"><c:out value="${dashboardStats.totalQuestions}"/></span>
                                <span class="text-[11px] text-slate-400 mt-1 block">Across all departmental subjects</span>
                            </div>
                        </div>
                    </div>

                    <!-- User Cohort Distribution Table -->
                    <div class="glass-card rounded-2xl p-6 border-slate-800">
                        <div class="flex items-center justify-between mb-4">
                            <div>
                                <h3 class="text-base font-bold text-white">User Distribution &amp; Cohorts</h3>
                                <p class="text-xs text-slate-400">Total registered user accounts: <span class="font-bold text-white"><c:out value="${dashboardStats.totalUsers}"/></span></p>
                            </div>
                            <a href="${pageContext.request.contextPath}/admin/users" class="text-xs text-indigo-400 hover:text-indigo-300 font-semibold flex items-center gap-1">
                                <span>View All Users</span>
                                <span class="material-symbols-Outlined text-sm">arrow_forward</span>
                            </a>
                        </div>

                        <div class="space-y-3">
                            <c:forEach var="trend" items="${dashboardStats.registrationTrends}">
                                <div>
                                    <div class="flex items-center justify-between text-xs mb-1">
                                        <span class="font-medium text-slate-300"><c:out value="${trend.label}"/></span>
                                        <span class="font-mono font-bold text-indigo-400"><c:out value="${trend.count}"/> users</span>
                                    </div>
                                    <div class="w-full bg-slate-900 h-2 rounded-full overflow-hidden border border-slate-800">
                                        <div class="bg-gradient-to-r from-indigo-600 to-cyan-500 h-2 rounded-full" style="width: ${dashboardStats.totalUsers > 0 ? (trend.count * 100 / dashboardStats.totalUsers) : 0}%"></div>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </div>

                </div>

                <!-- Right Column (1 Col): Recent System Audit Feed -->
                <div class="glass-card rounded-2xl p-6 border-slate-800 flex flex-col">
                    <div class="flex items-center justify-between mb-4">
                        <div class="flex items-center gap-2">
                            <span class="material-symbols-Outlined text-indigo-400 text-xl">shield</span>
                            <h3 class="text-base font-bold text-white">Live System Audit</h3>
                        </div>
                        <a href="${pageContext.request.contextPath}/admin/audit-logs" class="text-xs text-indigo-400 hover:text-indigo-300 font-semibold">
                            Full Log
                        </a>
                    </div>

                    <div class="space-y-3 overflow-y-auto max-h-[460px] custom-scrollbar pr-1 flex-1">
                        <c:choose>
                            <c:when test="${not empty dashboardStats.recentActivities}">
                                <c:forEach var="act" items="${dashboardStats.recentActivities}">
                                    <div class="p-3 rounded-xl bg-slate-900/70 border border-slate-800/80 hover:border-slate-700 transition-colors">
                                        <div class="flex items-center justify-between mb-1.5">
                                            <span class="text-[10px] font-mono px-2 py-0.5 rounded font-bold
                                                <c:choose>
                                                    <c:when test="${act.severity == 'CRITICAL'}">bg-rose-500/20 text-rose-300 border border-rose-500/30</c:when>
                                                    <c:when test="${act.severity == 'CAUTION'}">bg-amber-500/20 text-amber-300 border border-amber-500/30</c:when>
                                                    <c:otherwise>bg-slate-800 text-slate-300 border border-slate-700</c:otherwise>
                                                </c:choose>">
                                                <c:out value="${act.eventType}"/>
                                            </span>
                                            <span class="text-[10px] font-mono text-slate-400"><c:out value="${act.formattedTimestamp}"/></span>
                                        </div>
                                        <p class="text-xs text-slate-300 leading-relaxed"><c:out value="${act.details}"/></p>
                                        <div class="mt-2 text-[10px] text-slate-400 font-mono flex items-center justify-between">
                                            <span>Actor: <c:out value="${act.userName}"/></span>
                                            <c:if test="${not empty act.targetUserName}">
                                                <span>Target: <c:out value="${act.targetUserName}"/></span>
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

                    <div class="mt-4 pt-4 border-t border-slate-800 flex items-center justify-between text-xs text-slate-400 font-mono">
                        <span class="flex items-center gap-1.5 text-emerald-400">
                            <span class="w-1.5 h-1.5 rounded-full bg-emerald-400"></span>
                            Telemetry Active
                        </span>
                        <span>PostgreSQL 17 JDBC</span>
                    </div>
                </div>

            </div>

        </main>
    </div>

</body>
</html>
