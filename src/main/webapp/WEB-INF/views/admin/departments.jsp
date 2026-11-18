<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en" class="h-full bg-[#f8faff]">
<head>
    <meta charset="utf-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Academic Department Management | QuizTrack Enterprise</title>
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
               class="flex items-center gap-3 px-3.5 py-2.5 rounded-xl font-medium text-sm transition-all text-slate-600 hover:text-slate-900 hover:bg-slate-100/80">
                <span class="material-symbols-outlined text-xl">dashboard</span>
                <span>Executive Overview</span>
            </a>

            <a href="${pageContext.request.contextPath}/admin/users" 
               class="flex items-center gap-3 px-3.5 py-2.5 rounded-xl font-medium text-sm transition-all text-slate-600 hover:text-slate-900 hover:bg-slate-100/80">
                <span class="material-symbols-outlined text-xl">group</span>
                <span>User Directory</span>
            </a>

            <a href="${pageContext.request.contextPath}/admin/departments" 
               class="flex items-center gap-3 px-3.5 py-2.5 rounded-xl font-semibold text-sm transition-all bg-indigo-600 text-white shadow-xs">
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

        <!-- Admin Profile Footer -->
        <div class="p-3 border-t border-slate-100 bg-slate-50/60">
            <div class="flex items-center justify-between p-2 rounded-xl bg-white border border-slate-200/80 shadow-2xs">
                <div class="flex items-center gap-2.5 min-w-0">
                    <div class="w-8 h-8 rounded-lg bg-indigo-50 border border-indigo-100 flex items-center justify-center font-bold text-xs text-indigo-700 shrink-0">
                        ${currentUser.fullName != null ? currentUser.fullName.substring(0,1).toUpperCase() : 'A'}
                    </div>
                    <div class="min-w-0">
                        <span class="font-semibold text-xs text-slate-800 block truncate leading-tight">${currentUser.fullName}</span>
                        <span class="text-[10px] font-mono uppercase text-indigo-600 font-bold">ADMIN &bull; ${currentUser.identifier}</span>
                    </div>
                </div>
                <a href="${pageContext.request.contextPath}/auth/logout" class="p-2 rounded-lg text-slate-400 hover:text-rose-600 hover:bg-rose-50 transition-colors" title="Sign out">
                    <span class="material-symbols-outlined text-lg">logout</span>
                </a>
            </div>
        </div>
    </aside>

    <!-- Main Content Area -->
    <div class="flex-1 flex flex-col min-w-0 overflow-y-auto custom-scrollbar">

        <!-- Top Header Strip -->
        <header class="h-16 bg-white border-b border-slate-200/90 px-6 flex items-center justify-between shrink-0 shadow-2xs">
            <div class="flex items-center gap-2">
                <span class="font-display font-bold text-lg text-slate-900">Academic Department Management</span>
                <span class="text-xs text-slate-400 hidden sm:inline">&bull; Branch Analytics &amp; Roster</span>
            </div>

            <div class="flex items-center gap-3">
                <span class="inline-flex items-center gap-1.5 px-3 py-1 rounded-full text-xs font-semibold bg-emerald-50 text-emerald-700 border border-emerald-200">
                    <span class="w-1.5 h-1.5 rounded-full bg-emerald-500 animate-pulse"></span>
                    Operational
                </span>
                <a href="${pageContext.request.contextPath}/admin/users" class="inline-flex items-center gap-1 px-3 py-1.5 rounded-lg text-xs font-semibold bg-indigo-50 text-indigo-700 hover:bg-indigo-100 transition-colors">
                    <span class="material-symbols-outlined text-base">person_add</span>
                    <span>Add Member</span>
                </a>
            </div>
        </header>

        <!-- Body Container -->
        <main class="p-6 sm:p-8 max-w-7xl w-full mx-auto space-y-6">

            <!-- Banner / Hero -->
            <div class="bg-gradient-to-r from-indigo-900 via-indigo-800 to-slate-900 rounded-2xl p-6 sm:p-8 text-white shadow-sm flex flex-col md:flex-row items-start md:items-center justify-between gap-6 relative overflow-hidden">
                <div class="relative z-10 max-w-2xl">
                    <div class="flex items-center gap-2 mb-2">
                        <span class="px-2.5 py-0.5 rounded-full text-[11px] font-mono font-bold uppercase tracking-wider bg-indigo-500/30 text-indigo-200 border border-indigo-400/30">
                            Branch Operations &amp; Benchmarks
                        </span>
                    </div>
                    <h2 class="font-display text-2xl sm:text-3xl font-extrabold tracking-tight">Department Roster &amp; Top Performers</h2>
                    <p class="text-xs sm:text-sm text-indigo-200 mt-2 leading-relaxed">
                        Continuous oversight of academic branch faculty, examination pipelines, and high-performing candidate cohorts aggregated from PostgreSQL.
                    </p>
                </div>

                <div class="relative z-10 flex items-center gap-4 bg-white/10 backdrop-blur-md px-5 py-3.5 rounded-xl border border-white/15">
                    <div class="w-12 h-12 rounded-xl bg-indigo-500/30 text-indigo-200 flex items-center justify-center shrink-0">
                        <span class="material-symbols-outlined text-2xl">account_balance</span>
                    </div>
                    <div>
                        <span class="text-xs text-indigo-200 block font-medium">Active Branch</span>
                        <span class="font-display text-lg font-bold text-white"><c:out value="${selectedDept.departmentName}"/></span>
                    </div>
                </div>
            </div>

            <!-- KPI Metric Cards Strip (4 Cards) -->
            <div class="grid grid-cols-2 lg:grid-cols-4 gap-4">
                <div class="bg-white rounded-2xl p-5 shadow-2xs border border-slate-200/90 flex flex-col justify-between">
                    <div class="flex items-center justify-between text-slate-400">
                        <span class="text-xs font-semibold uppercase tracking-wider text-slate-500">Departments</span>
                        <div class="w-9 h-9 rounded-xl bg-indigo-50 text-indigo-600 flex items-center justify-center">
                            <span class="material-symbols-outlined text-xl">domain</span>
                        </div>
                    </div>
                    <div class="mt-2">
                        <div class="font-display text-2xl sm:text-3xl font-extrabold text-slate-900"><c:out value="${totalDepartments}"/></div>
                        <div class="text-xs text-slate-500 font-semibold mt-0.5">Academic Branches</div>
                    </div>
                </div>

                <div class="bg-white rounded-2xl p-5 shadow-2xs border border-slate-200/90 flex flex-col justify-between">
                    <div class="flex items-center justify-between text-slate-400">
                        <span class="text-xs font-semibold uppercase tracking-wider text-slate-500">Faculty Roster</span>
                        <div class="w-9 h-9 rounded-xl bg-amber-50 text-amber-600 flex items-center justify-center">
                            <span class="material-symbols-outlined text-xl">school</span>
                        </div>
                    </div>
                    <div class="mt-2">
                        <div class="font-display text-2xl sm:text-3xl font-extrabold text-slate-900"><c:out value="${totalFaculty}"/></div>
                        <div class="text-xs text-slate-500 font-semibold mt-0.5">Faculty Instructors</div>
                    </div>
                </div>

                <div class="bg-white rounded-2xl p-5 shadow-2xs border border-slate-200/90 flex flex-col justify-between">
                    <div class="flex items-center justify-between text-slate-400">
                        <span class="text-xs font-semibold uppercase tracking-wider text-slate-500">Enrolled Students</span>
                        <div class="w-9 h-9 rounded-xl bg-emerald-50 text-emerald-600 flex items-center justify-center">
                            <span class="material-symbols-outlined text-xl">groups</span>
                        </div>
                    </div>
                    <div class="mt-2">
                        <div class="font-display text-2xl sm:text-3xl font-extrabold text-slate-900"><c:out value="${totalStudents}"/></div>
                        <div class="text-xs text-slate-500 font-semibold mt-0.5">Active Candidates</div>
                    </div>
                </div>

                <div class="bg-white rounded-2xl p-5 shadow-2xs border border-slate-200/90 flex flex-col justify-between">
                    <div class="flex items-center justify-between text-slate-400">
                        <span class="text-xs font-semibold uppercase tracking-wider text-slate-500">Department Quizzes</span>
                        <div class="w-9 h-9 rounded-xl bg-sky-50 text-sky-600 flex items-center justify-center">
                            <span class="material-symbols-outlined text-xl">quiz</span>
                        </div>
                    </div>
                    <div class="mt-2">
                        <div class="font-display text-2xl sm:text-3xl font-extrabold text-slate-900"><c:out value="${totalQuizzes}"/></div>
                        <div class="text-xs text-slate-500 font-semibold mt-0.5">Authored Assessments</div>
                    </div>
                </div>
            </div>

            <!-- Department Navigation Pills / Tabs -->
            <div class="bg-white rounded-2xl p-3 shadow-2xs border border-slate-200/90 flex items-center gap-2 overflow-x-auto custom-scrollbar">
                <span class="text-xs font-bold text-slate-500 px-3 uppercase tracking-wider shrink-0 flex items-center gap-1.5">
                    <span class="material-symbols-outlined text-base text-indigo-600">apartment</span>
                    Select Department:
                </span>
                <c:forEach var="dept" items="${departments}">
                    <a href="${pageContext.request.contextPath}/admin/departments?dept=${dept.departmentName}" 
                       class="px-4 py-2 rounded-xl text-xs font-semibold transition-all shrink-0 flex items-center gap-2
                              ${selectedDept.departmentName == dept.departmentName ? 'bg-indigo-600 text-white shadow-xs' : 'bg-slate-50 hover:bg-slate-100 text-slate-700 border border-slate-200/80'}">
                        <span><c:out value="${dept.departmentName}"/></span>
                        <span class="px-2 py-0.5 rounded-full text-[10px] font-mono font-bold
                                     ${selectedDept.departmentName == dept.departmentName ? 'bg-white/20 text-white' : 'bg-slate-200 text-slate-700'}">
                            <c:out value="${dept.studentCount}"/> students &bull; <c:out value="${dept.teacherCount}"/> faculty
                        </span>
                    </a>
                </c:forEach>
            </div>

            <!-- Department Content Grid (2 Columns: Left 7 Cols, Right 5 Cols) -->
            <div class="grid grid-cols-1 lg:grid-cols-12 gap-6 items-start">

                <!-- Left Column (7 Cols): Faculty Teachers & Quizzes Authored -->
                <div class="lg:col-span-7 space-y-6">

                    <!-- Section 1: Teachers in Department -->
                    <div class="bg-white rounded-2xl p-6 shadow-2xs border border-slate-200/90">
                        <div class="flex items-center justify-between pb-4 border-b border-slate-100">
                            <div>
                                <h3 class="font-display text-base font-bold text-slate-900 flex items-center gap-2">
                                    <span class="material-symbols-outlined text-indigo-600">school</span>
                                    <span>Faculty Instructors (<c:out value="${selectedDept.teachers.size()}"/>)</span>
                                </h3>
                                <p class="text-xs text-slate-500 mt-0.5">Faculty members assigned to <c:out value="${selectedDept.departmentName}"/></p>
                            </div>
                            <span class="px-3 py-1 rounded-full text-xs font-mono font-bold bg-indigo-50 text-indigo-700 border border-indigo-100">
                                <c:out value="${selectedDept.quizCount}"/> Quizzes Authored
                            </span>
                        </div>

                        <div class="divide-y divide-slate-100 mt-2">
                            <c:choose>
                                <c:when test="${not empty selectedDept.teachers}">
                                    <c:forEach var="teacher" items="${selectedDept.teachers}">
                                        <div class="py-4 flex flex-col sm:flex-row items-start sm:items-center justify-between gap-3 hover:bg-slate-50/60 p-2.5 rounded-xl transition-colors">
                                            <div class="flex items-center gap-3.5 min-w-0">
                                                <div class="w-10 h-10 rounded-xl bg-indigo-50 border border-indigo-100 flex items-center justify-center font-bold text-indigo-700 shrink-0">
                                                    <c:out value="${teacher.fullName.substring(0,1)}"/>
                                                </div>
                                                <div class="min-w-0">
                                                    <div class="flex items-center gap-2">
                                                        <span class="font-display font-bold text-sm text-slate-900 truncate"><c:out value="${teacher.fullName}"/></span>
                                                        <span class="px-2 py-0.5 rounded-full text-[10px] font-mono font-bold
                                                            ${teacher.status == 'ACTIVE' ? 'bg-emerald-50 text-emerald-700 border border-emerald-200' : 'bg-slate-100 text-slate-600 border border-slate-200'}">
                                                            <c:out value="${teacher.status}"/>
                                                        </span>
                                                    </div>
                                                    <div class="text-xs text-slate-500 flex items-center gap-2 mt-0.5">
                                                        <span class="font-mono text-slate-400 font-medium"><c:out value="${teacher.identifier}"/></span>
                                                        <span>&bull;</span>
                                                        <span class="truncate"><c:out value="${teacher.email}"/></span>
                                                    </div>
                                                </div>
                                            </div>

                                            <div class="flex items-center gap-2 shrink-0">
                                                <div class="text-right">
                                                    <span class="font-display font-extrabold text-base text-indigo-600 block leading-tight">
                                                        <c:out value="${teacher.quizCount}"/>
                                                    </span>
                                                    <span class="text-[10px] text-slate-400 font-semibold uppercase tracking-wider">Quizzes Authored</span>
                                                </div>
                                                <a href="${pageContext.request.contextPath}/admin/users?search=${teacher.identifier}&role=TEACHER" 
                                                   class="p-2 rounded-lg text-slate-400 hover:text-indigo-600 hover:bg-indigo-50 transition-colors" title="View in User Directory">
                                                    <span class="material-symbols-outlined text-lg">open_in_new</span>
                                                </a>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <div class="py-8 text-center text-slate-400 text-xs">
                                        <span class="material-symbols-outlined text-3xl mb-1 text-slate-300 block">person_off</span>
                                        No faculty instructors currently assigned to this department.
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>

                    <!-- Section 2: Quizzes Organized by Department -->
                    <div class="bg-white rounded-2xl p-6 shadow-2xs border border-slate-200/90">
                        <div class="flex items-center justify-between pb-4 border-b border-slate-100">
                            <div>
                                <h3 class="font-display text-base font-bold text-slate-900 flex items-center gap-2">
                                    <span class="material-symbols-outlined text-sky-600">quiz</span>
                                    <span>Department Examinations (<c:out value="${selectedDept.quizzes.size()}"/>)</span>
                                </h3>
                                <p class="text-xs text-slate-500 mt-0.5">Assessment slates authored by <c:out value="${selectedDept.departmentName}"/> faculty</p>
                            </div>
                        </div>

                        <div class="divide-y divide-slate-100 mt-2">
                            <c:choose>
                                <c:when test="${not empty selectedDept.quizzes}">
                                    <c:forEach var="q" items="${selectedDept.quizzes}">
                                        <div class="py-3.5 flex flex-col sm:flex-row items-start sm:items-center justify-between gap-3 hover:bg-slate-50/60 p-2.5 rounded-xl transition-colors">
                                            <div class="min-w-0">
                                                <div class="flex items-center gap-2">
                                                    <span class="font-display font-bold text-xs sm:text-sm text-slate-900 truncate"><c:out value="${q.title}"/></span>
                                                    <span class="px-2 py-0.5 rounded-full text-[10px] font-mono font-bold
                                                        ${q.status == 'ACTIVE' ? 'bg-emerald-50 text-emerald-700 border border-emerald-200' :
                                                          q.status == 'SCHEDULED' ? 'bg-indigo-50 text-indigo-700 border border-indigo-200' :
                                                          q.status == 'COMPLETED' ? 'bg-slate-100 text-slate-700 border border-slate-200' :
                                                          'bg-amber-50 text-amber-700 border border-amber-200'}">
                                                        <c:out value="${q.status}"/>
                                                    </span>
                                                </div>
                                                <div class="text-xs text-slate-500 mt-0.5">
                                                    <span>By <strong><c:out value="${q.teacherName}"/></strong></span>
                                                    <span>&bull;</span>
                                                    <span><c:out value="${q.questionCount}"/> Questions</span>
                                                    <span>&bull;</span>
                                                    <span><fmt:formatNumber value="${q.totalMarks}" maxFractionDigits="0"/> Marks</span>
                                                </div>
                                            </div>

                                            <div class="text-right shrink-0">
                                                <span class="font-mono text-xs font-bold text-slate-700 block">
                                                    <c:out value="${q.attemptsCount}"/> Submissions
                                                </span>
                                                <span class="text-[10px] text-slate-400 font-semibold">Examinee Attempts</span>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <div class="py-8 text-center text-slate-400 text-xs">
                                        <span class="material-symbols-outlined text-3xl mb-1 text-slate-300 block">assignment_late</span>
                                        No quizzes currently authored in this department.
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>

                </div>

                <!-- Right Column (5 Cols): Top 5 Students Performance Leaderboard -->
                <div class="lg:col-span-5 space-y-6">

                    <!-- Top 5 Students Card -->
                    <div class="bg-white rounded-2xl p-6 shadow-2xs border border-slate-200/90 flex flex-col">
                        <div class="flex items-center justify-between pb-4 border-b border-slate-100 mb-4">
                            <div>
                                <h3 class="font-display text-base font-bold text-slate-900 flex items-center gap-2">
                                    <span class="material-symbols-outlined text-amber-500">emoji_events</span>
                                    <span>Top 5 Student Performers</span>
                                </h3>
                                <p class="text-xs text-slate-500 mt-0.5">Top ranking candidates in <c:out value="${selectedDept.departmentName}"/></p>
                            </div>
                            <span class="text-xs font-mono font-bold text-emerald-700 bg-emerald-50 border border-emerald-100 px-2.5 py-1 rounded-lg">
                                Top Branch Standings
                            </span>
                        </div>

                        <div class="space-y-3.5">
                            <c:choose>
                                <c:when test="${not empty selectedDept.topStudents}">
                                    <c:forEach var="student" items="${selectedDept.topStudents}">
                                        <div class="p-3.5 rounded-xl border transition-all duration-150 flex items-center justify-between gap-3
                                                    ${student.rank == 1 ? 'bg-amber-50/50 border-amber-200 shadow-2xs' :
                                                      student.rank == 2 ? 'bg-slate-50/70 border-slate-200' :
                                                      student.rank == 3 ? 'bg-amber-100/30 border-amber-200/70' :
                                                      'bg-white border-slate-200/80 hover:bg-slate-50'}">
                                            
                                            <!-- Rank Badge & Student Details -->
                                            <div class="flex items-center gap-3 min-w-0">
                                                <div class="w-8 h-8 rounded-xl font-display font-extrabold text-sm flex items-center justify-center shrink-0 shadow-2xs
                                                            ${student.rank == 1 ? 'bg-amber-400 text-slate-900 ring-2 ring-amber-300' :
                                                              student.rank == 2 ? 'bg-slate-300 text-slate-800' :
                                                              student.rank == 3 ? 'bg-amber-600 text-white' :
                                                              'bg-slate-100 text-slate-600 border border-slate-200'}">
                                                    #<c:out value="${student.rank}"/>
                                                </div>

                                                <div class="min-w-0">
                                                    <span class="font-display font-bold text-xs sm:text-sm text-slate-900 block truncate">
                                                        <c:out value="${student.fullName}"/>
                                                    </span>
                                                    <div class="flex items-center gap-2 text-[11px] text-slate-500 font-mono mt-0.5">
                                                        <span class="text-indigo-600 font-semibold"><c:out value="${student.identifier}"/></span>
                                                        <span>&bull;</span>
                                                        <span class="truncate"><c:out value="${student.cohort}"/></span>
                                                    </div>
                                                </div>
                                            </div>

                                            <!-- Score & Percentage -->
                                            <div class="text-right shrink-0">
                                                <div class="font-display font-extrabold text-sm sm:text-base text-slate-900">
                                                    <fmt:formatNumber value="${student.averagePercentage}" minFractionDigits="1" maxFractionDigits="1"/>%
                                                </div>
                                                <div class="text-[10px] text-slate-500 font-mono">
                                                    <c:out value="${student.attemptsCount}"/> exam(s) &bull; <fmt:formatNumber value="${student.totalScore}" maxFractionDigits="0"/> pts
                                                </div>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <div class="py-8 text-center text-slate-400 text-xs">
                                        <span class="material-symbols-outlined text-3xl mb-1 text-slate-300 block">military_tech</span>
                                        No student examination results recorded yet in this department.
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>

                        <!-- Department Summary Mini Box -->
                        <div class="mt-6 pt-4 border-t border-slate-100 grid grid-cols-2 gap-3 text-center">
                            <div class="p-3 rounded-xl bg-slate-50 border border-slate-200/80">
                                <span class="text-[10px] text-slate-500 font-semibold block uppercase">Branch Candidate Total</span>
                                <span class="font-display text-xl font-bold text-slate-900"><c:out value="${selectedDept.studentCount}"/></span>
                            </div>
                            <div class="p-3 rounded-xl bg-slate-50 border border-slate-200/80">
                                <span class="text-[10px] text-slate-500 font-semibold block uppercase">Branch Pass / Avg Score</span>
                                <span class="font-display text-xl font-bold text-emerald-600">
                                    <c:choose>
                                        <c:when test="${selectedDept.averageScore > 0}">
                                            <fmt:formatNumber value="${selectedDept.averageScore}" minFractionDigits="1" maxFractionDigits="1"/>%
                                        </c:when>
                                        <c:otherwise>--</c:otherwise>
                                    </c:choose>
                                </span>
                            </div>
                        </div>

                    </div>

                </div>

            </div>

        </main>
    </div>

</body>
</html>
