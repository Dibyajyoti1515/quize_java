<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en" class="h-full bg-slate-950">
<head>
    <meta charset="utf-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Enterprise System Audit Trail | QuizTrack Administration</title>
    <link rel="preconnect" href="https://fonts.googleapis.com"/>
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin/>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&family=Plus+Jakarta+Sans:wght@500;600;700;800&family=JetBrains+Mono:wght@400;500;600&display=swap" rel="stylesheet"/>
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200" rel="stylesheet"/>
    <script src="https://cdn.tailwindcss.com"></script>
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
<body class="h-full flex flex-col md:flex-row bg-slate-950 text-slate-100 font-sans selection:bg-indigo-600 selection:text-white">

    <!-- Sidebar Navigation -->
    <aside class="w-full md:w-64 bg-slate-900 border-r border-slate-800 flex flex-col shrink-0">
        <div class="p-5 border-b border-slate-800 flex items-center gap-3">
            <div class="w-10 h-10 rounded-xl bg-gradient-to-tr from-indigo-600 via-indigo-500 to-cyan-400 flex items-center justify-center text-white shadow-lg shadow-indigo-500/20">
                <span class="material-symbols-Outlined text-2xl font-bold">admin_panel_settings</span>
            </div>
            <div>
                <span class="font-extrabold text-base tracking-tight text-white block">QuizTrack™</span>
                <span class="text-[11px] font-mono uppercase tracking-wider text-indigo-400 font-semibold">Admin Gateway</span>
            </div>
        </div>

        <nav class="flex-1 p-3 space-y-1.5 overflow-y-auto custom-scrollbar">
            <a href="${pageContext.request.contextPath}/admin/dashboard" 
               class="flex items-center gap-3 px-3.5 py-2.5 rounded-xl font-medium text-sm transition-all text-slate-400 hover:text-slate-200 hover:bg-slate-800/60">
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
               class="flex items-center gap-3 px-3.5 py-2.5 rounded-xl font-medium text-sm transition-all bg-indigo-600/15 text-indigo-400 border border-indigo-500/30">
                <span class="material-symbols-Outlined text-xl">security</span>
                <span>System Audit Logs</span>
            </a>

            <div class="pt-4 pb-1 px-3">
                <span class="text-[10px] font-mono uppercase tracking-wider text-slate-400 font-semibold">Portals</span>
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
                <a href="${pageContext.request.contextPath}/auth/logout" title="Sign Out" class="p-1.5 rounded-lg text-slate-400 hover:text-rose-400 hover:bg-rose-500/10 transition-colors">
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
                <h1 class="text-lg font-bold text-white tracking-tight">System Audit &amp; Compliance Trail</h1>
                <span class="text-xs font-mono px-2 py-0.5 rounded-full bg-slate-800 text-slate-300 border border-slate-700">Total Entries: <c:out value="${totalCount}"/></span>
            </div>

            <!-- Redaction Protection Badge -->
            <div class="flex items-center gap-2 px-3 py-1 rounded-full bg-emerald-500/10 border border-emerald-500/30 text-emerald-300 text-xs font-mono">
                <span class="material-symbols-Outlined text-sm">verified_user</span>
                <span>Secret &amp; Hash Shield Active</span>
            </div>
        </header>

        <!-- Main Body -->
        <main class="p-6 md:p-8 space-y-6 max-w-7xl mx-auto w-full">

            <!-- Filter Controls -->
            <div class="glass-card rounded-2xl p-4 border-slate-800">
                <form method="get" action="${pageContext.request.contextPath}/admin/audit-logs" class="grid grid-cols-1 md:grid-cols-5 gap-3">

                    <!-- Action Type -->
                    <div>
                        <label class="block text-[11px] font-semibold text-slate-400 mb-1 font-mono uppercase">Action Type</label>
                        <select name="eventType" class="w-full bg-slate-900 border border-slate-700 rounded-xl px-3 py-2 text-xs text-white focus:outline-none focus:border-indigo-500 font-mono">
                            <option value="ALL" <c:if test="${eventTypeParam == 'ALL'}">selected</c:if>>All Actions</option>
                            <option value="USER_CREATED" <c:if test="${eventTypeParam == 'USER_CREATED'}">selected</c:if>>USER_CREATED</option>
                            <option value="USER_UPDATED" <c:if test="${eventTypeParam == 'USER_UPDATED'}">selected</c:if>>USER_UPDATED</option>
                            <option value="ACCOUNT_STATUS_CHANGED" <c:if test="${eventTypeParam == 'ACCOUNT_STATUS_CHANGED'}">selected</c:if>>ACCOUNT_STATUS_CHANGED</option>
                            <option value="ROLE_CHANGED" <c:if test="${eventTypeParam == 'ROLE_CHANGED'}">selected</c:if>>ROLE_CHANGED</option>
                            <option value="PASSWORD_RESET" <c:if test="${eventTypeParam == 'PASSWORD_RESET'}">selected</c:if>>PASSWORD_RESET</option>
                            <option value="SETTING_CHANGED" <c:if test="${eventTypeParam == 'SETTING_CHANGED'}">selected</c:if>>SETTING_CHANGED</option>
                            <option value="ADMIN_ACTION" <c:if test="${eventTypeParam == 'ADMIN_ACTION'}">selected</c:if>>ADMIN_ACTION</option>
                            <option value="TAB_SWITCH" <c:if test="${eventTypeParam == 'TAB_SWITCH'}">selected</c:if>>TAB_SWITCH</option>
                            <option value="FULLSCREEN_EXIT" <c:if test="${eventTypeParam == 'FULLSCREEN_EXIT'}">selected</c:if>>FULLSCREEN_EXIT</option>
                        </select>
                    </div>

                    <!-- Severity -->
                    <div>
                        <label class="block text-[11px] font-semibold text-slate-400 mb-1 font-mono uppercase">Severity</label>
                        <select name="severity" class="w-full bg-slate-900 border border-slate-700 rounded-xl px-3 py-2 text-xs text-white focus:outline-none focus:border-indigo-500">
                            <option value="ALL" <c:if test="${severityParam == 'ALL'}">selected</c:if>>All Severities</option>
                            <option value="INFO" <c:if test="${severityParam == 'INFO'}">selected</c:if>>INFO (Normal)</option>
                            <option value="CAUTION" <c:if test="${severityParam == 'CAUTION'}">selected</c:if>>CAUTION (Warning)</option>
                            <option value="CRITICAL" <c:if test="${severityParam == 'CRITICAL'}">selected</c:if>>CRITICAL (Security)</option>
                        </select>
                    </div>

                    <!-- User Search -->
                    <div>
                        <label class="block text-[11px] font-semibold text-slate-400 mb-1 font-mono uppercase">User Query</label>
                        <input type="text" name="userQuery" value="<c:out value="${userQueryParam}"/>" placeholder="Actor or target user..." 
                               class="w-full bg-slate-900 border border-slate-700 rounded-xl px-3 py-2 text-xs text-white placeholder-slate-400 focus:outline-none focus:border-indigo-500"/>
                    </div>

                    <!-- Date Range Start -->
                    <div>
                        <label class="block text-[11px] font-semibold text-slate-400 mb-1 font-mono uppercase">From Date</label>
                        <input type="date" name="startDate" value="<c:out value="${startDateParam}"/>" 
                               class="w-full bg-slate-900 border border-slate-700 rounded-xl px-3 py-2 text-xs text-white focus:outline-none focus:border-indigo-500"/>
                    </div>

                    <!-- Submit / Reset Actions -->
                    <div class="flex items-end gap-2">
                        <button type="submit" class="flex-1 py-2 rounded-xl bg-slate-800 hover:bg-slate-700 text-white font-semibold text-xs transition-colors border border-slate-700 flex items-center justify-center gap-1.5">
                            <span class="material-symbols-Outlined text-base">search</span>
                            <span>Filter</span>
                        </button>
                        <a href="${pageContext.request.contextPath}/admin/audit-logs" class="p-2 rounded-xl bg-slate-900 hover:bg-slate-800 text-slate-400 hover:text-white transition-colors border border-slate-800" title="Reset Filters">
                            <span class="material-symbols-Outlined text-base">refresh</span>
                        </a>
                    </div>
                </form>
            </div>

            <!-- Audit Logs Table -->
            <div class="glass-card rounded-2xl border-slate-800 overflow-hidden">
                <div class="overflow-x-auto">
                    <table class="w-full text-left text-xs border-collapse">
                        <thead>
                            <tr class="border-b border-slate-800 bg-slate-900/80 text-slate-400 font-mono text-[11px] uppercase tracking-wider">
                                <th class="py-3 px-4">Timestamp</th>
                                <th class="py-3 px-4">Event Type</th>
                                <th class="py-3 px-4">Severity</th>
                                <th class="py-3 px-4">Actor</th>
                                <th class="py-3 px-4">Target User</th>
                                <th class="py-3 px-4">Details</th>
                            </tr>
                        </thead>
                        <tbody class="divide-y divide-slate-800/60 font-sans">
                            <c:forEach var="log" items="${auditLogs}">
                                <tr class="hover:bg-slate-800/30 transition-colors">
                                    <td class="py-3 px-4 font-mono text-slate-400 text-[11px] whitespace-nowrap">
                                        <c:out value="${log.formattedTimestamp}"/>
                                    </td>
                                    <td class="py-3 px-4">
                                        <span class="px-2 py-0.5 rounded font-mono font-bold text-[10px] bg-slate-800 text-indigo-300 border border-slate-700">
                                            <c:out value="${log.eventType}"/>
                                        </span>
                                    </td>
                                    <td class="py-3 px-4">
                                        <span class="inline-flex items-center gap-1.5 px-2 py-0.5 rounded-full text-[10px] font-semibold
                                            <c:choose>
                                                <c:when test="${log.severity == 'CRITICAL'}">bg-rose-500/20 text-rose-300 border border-rose-500/30</c:when>
                                                <c:when test="${log.severity == 'CAUTION'}">bg-amber-500/20 text-amber-300 border border-amber-500/30</c:when>
                                                <c:otherwise>bg-slate-800 text-slate-300 border border-slate-700</c:otherwise>
                                            </c:choose>">
                                            <c:out value="${log.severity}"/>
                                        </span>
                                    </td>
                                    <td class="py-3 px-4">
                                        <span class="font-semibold text-white block"><c:out value="${log.userName}"/></span>
                                        <span class="text-[10px] font-mono text-slate-400 block"><c:out value="${log.userIdentifier}"/> (<c:out value="${log.userRole}"/>)</span>
                                    </td>
                                    <td class="py-3 px-4 text-slate-300">
                                        <c:choose>
                                            <c:when test="${not empty log.targetUserName}">
                                                <span class="font-medium text-slate-200 block"><c:out value="${log.targetUserName}"/></span>
                                                <span class="text-[10px] font-mono text-slate-400 block"><c:out value="${log.targetUserIdentifier}"/></span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="text-slate-400 font-mono text-[11px]">System / N/A</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="py-3 px-4 text-slate-300 max-w-md">
                                        <span class="line-clamp-2 text-xs leading-relaxed"><c:out value="${log.details}"/></span>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>

                <!-- Pagination Footer -->
                <c:if test="${totalPages > 1}">
                    <div class="p-4 border-t border-slate-800 flex items-center justify-between text-xs text-slate-400">
                        <span>Page <c:out value="${currentPage}"/> of <c:out value="${totalPages}"/> (<c:out value="${totalCount}"/> total events)</span>
                        <div class="flex items-center gap-1.5">
                            <c:if test="${currentPage > 1}">
                                <a href="?page=${currentPage - 1}&eventType=<c:out value="${eventTypeParam}"/>&severity=<c:out value="${severityParam}"/>&userQuery=<c:out value="${userQueryParam}"/>&startDate=<c:out value="${startDateParam}"/>&endDate=<c:out value="${endDateParam}"/>" 
                                   class="px-3 py-1.5 rounded-lg bg-slate-800 hover:bg-slate-700 text-white font-medium transition-colors">Previous</a>
                            </c:if>
                            <c:if test="${currentPage < totalPages}">
                                <a href="?page=${currentPage + 1}&eventType=<c:out value="${eventTypeParam}"/>&severity=<c:out value="${severityParam}"/>&userQuery=<c:out value="${userQueryParam}"/>&startDate=<c:out value="${startDateParam}"/>&endDate=<c:out value="${endDateParam}"/>" 
                                   class="px-3 py-1.5 rounded-lg bg-slate-800 hover:bg-slate-700 text-white font-medium transition-colors">Next</a>
                            </c:if>
                        </div>
                    </div>
                </c:if>
            </div>

        </main>
    </div>

</body>
</html>
