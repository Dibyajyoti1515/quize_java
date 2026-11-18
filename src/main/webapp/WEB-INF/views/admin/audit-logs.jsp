<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en" class="h-full bg-[#f8faff]">
<head>
    <meta charset="utf-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Enterprise System Audit Trail | QuizTrack Administration</title>
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
        <div class="p-5 border-b border-slate-100 flex items-center gap-3">
            <div class="w-10 h-10 rounded-xl bg-gradient-to-tr from-indigo-600 via-indigo-500 to-indigo-700 flex items-center justify-center text-white shadow-xs">
                <span class="material-symbols-outlined text-2xl font-bold">admin_panel_settings</span>
            </div>
            <div>
                <span class="font-display font-extrabold text-base tracking-tight text-slate-900 block">QuizTrack</span>
                <span class="text-[11px] font-mono uppercase tracking-wider text-indigo-600 font-semibold">Admin Gateway</span>
            </div>
        </div>

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
               class="flex items-center gap-3 px-3.5 py-2.5 rounded-xl font-semibold text-sm transition-all bg-indigo-600 text-white shadow-xs">
                <span class="material-symbols-outlined text-xl">security</span>
                <span>System Audit Logs</span>
            </a>
        </nav>

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
                <h1 class="font-display text-lg font-bold text-slate-900 tracking-tight">Immutable Security Audit Trail</h1>
                <span class="text-xs font-mono px-2.5 py-0.5 rounded-full bg-indigo-50 text-indigo-700 border border-indigo-200 font-semibold">activity_logs</span>
            </div>

            <div class="flex items-center gap-3">
                <span class="inline-flex items-center gap-1.5 px-3 py-1 rounded-full text-xs font-semibold bg-emerald-50 text-emerald-700 border border-emerald-200">
                    <span class="material-symbols-outlined text-sm">verified_user</span>
                    <span>PostgreSQL Append-Only Log</span>
                </span>
            </div>
        </header>

        <!-- Main Content View -->
        <main class="p-6 md:p-8 space-y-6 max-w-7xl mx-auto w-full">

            <!-- Filter Strip Card -->
            <form method="GET" action="${pageContext.request.contextPath}/admin/audit-logs" 
                  class="bg-white rounded-2xl p-5 shadow-2xs border border-slate-200/90 flex flex-wrap items-end gap-3.5">
                
                <div class="flex-1 min-w-[180px]">
                    <label class="block text-xs font-semibold text-slate-600 mb-1">Actor / Target Search</label>
                    <input type="text" name="userQuery" placeholder="Search by name or identifier..." value="<c:out value="${userQueryParam}"/>" 
                           class="w-full bg-slate-50 border border-slate-200 focus:bg-white focus:border-indigo-600 rounded-xl px-3 py-2 text-xs text-slate-800 focus:outline-none transition-colors"/>
                </div>

                <div class="w-40">
                    <label class="block text-xs font-semibold text-slate-600 mb-1">Event Type</label>
                    <select name="eventType" class="w-full bg-slate-50 border border-slate-200 focus:bg-white focus:border-indigo-600 rounded-xl px-3 py-2 text-xs text-slate-800 focus:outline-none">
                        <option value="">All Event Types</option>
                        <c:forEach var="type" items="${eventTypes}">
                            <option value="<c:out value="${type}"/>" <c:if test="${eventTypeParam == type}">selected</c:if>><c:out value="${type}"/></option>
                        </c:forEach>
                    </select>
                </div>

                <div class="w-36">
                    <label class="block text-xs font-semibold text-slate-600 mb-1">Severity</label>
                    <select name="severity" class="w-full bg-slate-50 border border-slate-200 focus:bg-white focus:border-indigo-600 rounded-xl px-3 py-2 text-xs text-slate-800 focus:outline-none">
                        <option value="">All Severities</option>
                        <option value="INFO" <c:if test="${severityParam == 'INFO'}">selected</c:if>>INFO</option>
                        <option value="CAUTION" <c:if test="${severityParam == 'CAUTION'}">selected</c:if>>CAUTION</option>
                        <option value="CRITICAL" <c:if test="${severityParam == 'CRITICAL'}">selected</c:if>>CRITICAL</option>
                    </select>
                </div>

                <div class="w-36">
                    <label class="block text-xs font-semibold text-slate-600 mb-1">Start Date</label>
                    <input type="date" name="startDate" value="<c:out value="${startDateParam}"/>" 
                           class="w-full bg-slate-50 border border-slate-200 focus:bg-white focus:border-indigo-600 rounded-xl px-3 py-2 text-xs text-slate-800 focus:outline-none font-mono"/>
                </div>

                <div class="w-36">
                    <label class="block text-xs font-semibold text-slate-600 mb-1">End Date</label>
                    <input type="date" name="endDate" value="<c:out value="${endDateParam}"/>" 
                           class="w-full bg-slate-50 border border-slate-200 focus:bg-white focus:border-indigo-600 rounded-xl px-3 py-2 text-xs text-slate-800 focus:outline-none font-mono"/>
                </div>

                <div class="flex items-center gap-2 pt-1">
                    <button type="submit" class="px-4 py-2 bg-indigo-600 hover:bg-indigo-700 text-white rounded-xl font-semibold text-xs transition-colors flex items-center gap-1.5 shadow-xs cursor-pointer">
                        <span class="material-symbols-outlined text-base">search</span>
                        <span>Filter</span>
                    </button>
                    <a href="${pageContext.request.contextPath}/admin/audit-logs" class="px-3.5 py-2 bg-slate-100 hover:bg-slate-200 text-slate-600 rounded-xl font-semibold text-xs transition-colors flex items-center gap-1.5">
                        <span class="material-symbols-outlined text-base">refresh</span>
                        <span>Reset</span>
                    </a>
                </div>
            </form>

            <!-- Audit Trail Table -->
            <div class="bg-white rounded-2xl shadow-2xs border border-slate-200/90 overflow-hidden">
                <div class="overflow-x-auto">
                    <table class="w-full text-left border-collapse text-xs">
                        <thead>
                            <tr class="border-b border-slate-200 bg-slate-50/80 text-[11px] font-bold text-slate-500 uppercase tracking-wider font-mono">
                                <th class="py-3 px-4">Timestamp</th>
                                <th class="py-3 px-4">Event Type</th>
                                <th class="py-3 px-4">Severity</th>
                                <th class="py-3 px-4">Actor</th>
                                <th class="py-3 px-4">Target Context</th>
                                <th class="py-3 px-4">Event Payload / Diagnostics</th>
                            </tr>
                        </thead>
                        <tbody class="divide-y divide-slate-100">
                            <c:if test="${empty auditLogs}">
                                <tr>
                                    <td colspan="6" class="text-center py-12 text-slate-400">
                                        No audit events matching current criteria.
                                    </td>
                                </tr>
                            </c:if>

                            <c:forEach var="log" items="${auditLogs}">
                                <tr class="hover:bg-slate-50/70 transition-colors">
                                    <td class="py-3 px-4 font-mono text-slate-500 text-[11px] whitespace-nowrap">
                                        <c:out value="${log.formattedTimestamp}"/>
                                    </td>
                                    <td class="py-3 px-4">
                                        <span class="px-2 py-0.5 rounded font-mono font-bold text-[10px] bg-slate-100 text-slate-700 border border-slate-200">
                                            <c:out value="${log.eventType}"/>
                                        </span>
                                    </td>
                                    <td class="py-3 px-4">
                                        <span class="inline-flex items-center gap-1.5 px-2.5 py-0.5 rounded-full text-[10px] font-bold
                                            <c:choose>
                                                <c:when test="${log.severity == 'CRITICAL'}">bg-rose-50 text-rose-700 border border-rose-200</c:when>
                                                <c:when test="${log.severity == 'CAUTION'}">bg-amber-50 text-amber-700 border border-amber-200</c:when>
                                                <c:otherwise>bg-slate-100 text-slate-700 border border-slate-200</c:otherwise>
                                            </c:choose>">
                                            <c:out value="${log.severity}"/>
                                        </span>
                                    </td>
                                    <td class="py-3 px-4">
                                        <span class="font-semibold text-slate-900 block"><c:out value="${log.userName}"/></span>
                                        <span class="text-[10px] font-mono text-slate-400 block"><c:out value="${log.userIdentifier}"/> (<c:out value="${log.userRole}"/>)</span>
                                    </td>
                                    <td class="py-3 px-4 text-slate-600">
                                        <c:choose>
                                            <c:when test="${not empty log.targetUserName}">
                                                <span class="font-medium text-slate-800 block"><c:out value="${log.targetUserName}"/></span>
                                                <span class="text-[10px] font-mono text-slate-400 block"><c:out value="${log.targetUserIdentifier}"/></span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="text-slate-400 font-mono text-[11px]">System / N/A</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="py-3 px-4 text-slate-700 max-w-md">
                                        <span class="line-clamp-2 text-xs leading-relaxed"><c:out value="${log.details}"/></span>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>

                <!-- Pagination Footer -->
                <c:if test="${totalPages > 1}">
                    <div class="p-4 border-t border-slate-100 flex items-center justify-between text-xs text-slate-500 bg-slate-50/50">
                        <span>Page <strong class="text-slate-800 font-bold"><c:out value="${currentPage}"/></strong> of <c:out value="${totalPages}"/> (<c:out value="${totalCount}"/> total events)</span>
                        <div class="flex items-center gap-1.5">
                            <c:if test="${currentPage > 1}">
                                <a href="?page=${currentPage - 1}&eventType=<c:out value="${eventTypeParam}"/>&severity=<c:out value="${severityParam}"/>&userQuery=<c:out value="${userQueryParam}"/>&startDate=<c:out value="${startDateParam}"/>&endDate=<c:out value="${endDateParam}"/>" 
                                   class="px-3 py-1.5 rounded-lg border border-slate-200 bg-white hover:bg-slate-50 text-slate-700 font-semibold transition-colors">Previous</a>
                            </c:if>
                            <c:if test="${currentPage < totalPages}">
                                <a href="?page=${currentPage + 1}&eventType=<c:out value="${eventTypeParam}"/>&severity=<c:out value="${severityParam}"/>&userQuery=<c:out value="${userQueryParam}"/>&startDate=<c:out value="${startDateParam}"/>&endDate=<c:out value="${endDateParam}"/>" 
                                   class="px-3 py-1.5 rounded-lg border border-slate-200 bg-white hover:bg-slate-50 text-slate-700 font-semibold transition-colors">Next</a>
                            </c:if>
                        </div>
                    </div>
                </c:if>
            </div>

        </main>
    </div>

</body>
</html>
