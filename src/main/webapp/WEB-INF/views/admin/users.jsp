<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en" class="h-full bg-slate-950">
<head>
    <meta charset="utf-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>User Roster &amp; Access Directory | QuizTrack Administration</title>
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
               class="flex items-center gap-3 px-3.5 py-2.5 rounded-xl font-medium text-sm transition-all bg-indigo-600/15 text-indigo-400 border border-indigo-500/30">
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
                <h1 class="text-lg font-bold text-white tracking-tight">Institutional User Directory</h1>
                <span class="text-xs font-mono px-2 py-0.5 rounded-full bg-slate-800 text-slate-300 border border-slate-700">Total Users: <c:out value="${totalCount}"/></span>
            </div>

            <button type="button" onclick="openCreateUserModal()" 
                    class="px-4 py-2 rounded-xl bg-indigo-600 hover:bg-indigo-500 text-white font-semibold text-xs transition-all shadow-lg shadow-indigo-600/30 flex items-center gap-2">
                <span class="material-symbols-Outlined text-base">person_add</span>
                <span>Add New User</span>
            </button>
        </header>

        <!-- Main Body -->
        <main class="p-6 md:p-8 space-y-6 max-w-7xl mx-auto w-full">

            <!-- Alerts -->
            <c:if test="${not empty param.success}">
                <div class="p-4 rounded-xl bg-emerald-500/15 border border-emerald-500/30 text-emerald-300 text-sm flex items-center gap-3">
                    <span class="material-symbols-Outlined text-xl">check_circle</span>
                    <span><c:out value="${param.success}"/></span>
                </div>
            </c:if>

            <c:if test="${not empty param.error}">
                <div class="p-4 rounded-xl bg-rose-500/15 border border-rose-500/30 text-rose-300 text-sm flex items-center gap-3">
                    <span class="material-symbols-Outlined text-xl">error</span>
                    <span><c:out value="${param.error}"/></span>
                </div>
            </c:if>

            <!-- Search & Filter Controls -->
            <div class="glass-card rounded-2xl p-4 border-slate-800">
                <form method="get" action="${pageContext.request.contextPath}/admin/users" class="flex flex-col md:flex-row gap-3">
                    <div class="flex-1 relative">
                        <span class="material-symbols-Outlined absolute left-3.5 top-1/2 -translate-y-1/2 text-slate-400 text-lg">search</span>
                        <input type="text" name="search" value="<c:out value="${searchParam}"/>" placeholder="Search by name, email, roll number, or department..." 
                               class="w-full bg-slate-900 border border-slate-700 rounded-xl pl-10 pr-4 py-2.5 text-xs text-white placeholder-slate-400 focus:outline-none focus:border-indigo-500"/>
                    </div>

                    <div class="w-full md:w-44">
                        <select name="role" class="w-full bg-slate-900 border border-slate-700 rounded-xl px-3 py-2.5 text-xs text-white focus:outline-none focus:border-indigo-500">
                            <option value="ALL" <c:if test="${roleParam == 'ALL'}">selected</c:if>>All Roles</option>
                            <option value="STUDENT" <c:if test="${roleParam == 'STUDENT'}">selected</c:if>>Student</option>
                            <option value="TEACHER" <c:if test="${roleParam == 'TEACHER'}">selected</c:if>>Teacher</option>
                            <option value="ADMIN" <c:if test="${roleParam == 'ADMIN'}">selected</c:if>>Administrator</option>
                        </select>
                    </div>

                    <div class="w-full md:w-44">
                        <select name="status" class="w-full bg-slate-900 border border-slate-700 rounded-xl px-3 py-2.5 text-xs text-white focus:outline-none focus:border-indigo-500">
                            <option value="ALL" <c:if test="${statusParam == 'ALL'}">selected</c:if>>All Statuses</option>
                            <option value="ACTIVE" <c:if test="${statusParam == 'ACTIVE'}">selected</c:if>>Active</option>
                            <option value="INACTIVE" <c:if test="${statusParam == 'INACTIVE'}">selected</c:if>>Inactive</option>
                            <option value="SUSPENDED" <c:if test="${statusParam == 'SUSPENDED'}">selected</c:if>>Suspended</option>
                        </select>
                    </div>

                    <button type="submit" class="px-5 py-2.5 rounded-xl bg-slate-800 hover:bg-slate-700 text-white font-semibold text-xs transition-colors border border-slate-700 flex items-center justify-center gap-1.5 shrink-0">
                        <span class="material-symbols-Outlined text-base">filter_list</span>
                        <span>Filter</span>
                    </button>
                    <a href="${pageContext.request.contextPath}/admin/users" class="px-3 py-2.5 rounded-xl bg-slate-900 hover:bg-slate-800 text-slate-400 hover:text-white text-xs transition-colors border border-slate-800 flex items-center justify-center shrink-0" title="Reset Filters">
                        <span class="material-symbols-Outlined text-base">refresh</span>
                    </a>
                </form>
            </div>

            <!-- User Data Table -->
            <div class="glass-card rounded-2xl border-slate-800 overflow-hidden">
                <div class="overflow-x-auto">
                    <table class="w-full text-left text-xs border-collapse">
                        <thead>
                            <tr class="border-b border-slate-800 bg-slate-900/80 text-slate-400 font-mono text-[11px] uppercase tracking-wider">
                                <th class="py-3 px-4">User</th>
                                <th class="py-3 px-4">Identifier / ID</th>
                                <th class="py-3 px-4">Role</th>
                                <th class="py-3 px-4">Department / Cohort</th>
                                <th class="py-3 px-4">Status</th>
                                <th class="py-3 px-4">Registered</th>
                                <th class="py-3 px-4 text-right">Actions</th>
                            </tr>
                        </thead>
                        <tbody class="divide-y divide-slate-800/60">
                            <c:forEach var="u" items="${users}">
                                <tr class="hover:bg-slate-800/30 transition-colors">
                                    <td class="py-3 px-4">
                                        <div class="flex items-center gap-3">
                                            <div class="w-8 h-8 rounded-full bg-slate-800 border border-slate-700 flex items-center justify-center text-xs font-bold text-slate-300">
                                                <c:out value="${u.fullName.substring(0, 1)}"/>
                                            </div>
                                            <div>
                                                <span class="font-semibold text-white block"><c:out value="${u.fullName}"/></span>
                                                <span class="text-slate-400 text-[11px]"><c:out value="${u.email}"/></span>
                                            </div>
                                        </div>
                                    </td>
                                    <td class="py-3 px-4 font-mono font-medium text-slate-300">
                                        <c:out value="${u.identifier}"/>
                                    </td>
                                    <td class="py-3 px-4">
                                        <span class="px-2 py-0.5 rounded text-[10px] font-mono font-bold
                                            <c:choose>
                                                <c:when test="${u.roleName == 'ADMIN'}">bg-emerald-500/20 text-emerald-300 border border-emerald-500/30</c:when>
                                                <c:when test="${u.roleName == 'TEACHER'}">bg-amber-500/20 text-amber-300 border border-amber-500/30</c:when>
                                                <c:otherwise>bg-indigo-500/20 text-indigo-300 border border-indigo-500/30</c:otherwise>
                                            </c:choose>">
                                            <c:out value="${u.roleName}"/>
                                        </span>
                                    </td>
                                    <td class="py-3 px-4 text-slate-300">
                                        <span class="block text-slate-200"><c:out value="${u.department != null ? u.department : 'N/A'}"/></span>
                                        <span class="text-[10px] text-slate-400 font-mono block"><c:out value="${u.cohort != null ? u.cohort : 'No Cohort'}"/></span>
                                    </td>
                                    <td class="py-3 px-4">
                                        <span class="inline-flex items-center gap-1.5 px-2 py-0.5 rounded-full text-[10px] font-semibold
                                            <c:choose>
                                                <c:when test="${u.status == 'ACTIVE'}">bg-emerald-500/15 text-emerald-400 border border-emerald-500/30</c:when>
                                                <c:when test="${u.status == 'SUSPENDED'}">bg-rose-500/15 text-rose-400 border border-rose-500/30</c:when>
                                                <c:otherwise>bg-slate-700/50 text-slate-400 border border-slate-600</c:otherwise>
                                            </c:choose>">
                                            <span class="w-1.5 h-1.5 rounded-full <c:choose><c:when test="${u.status == 'ACTIVE'}">bg-emerald-400</c:when><c:when test="${u.status == 'SUSPENDED'}">bg-rose-400</c:when><c:otherwise>bg-slate-400</c:otherwise></c:choose>"></span>
                                            <c:out value="${u.status}"/>
                                        </span>
                                    </td>
                                    <td class="py-3 px-4 font-mono text-slate-400 text-[11px]">
                                        <fmt:formatDate value="${u.createdAt}" pattern="MMM dd, yyyy"/>
                                    </td>
                                    <td class="py-3 px-4 text-right">
                                        <div class="flex items-center justify-end gap-1.5">
                                            <!-- Edit User Profile -->
                                            <button type="button" 
                                                    onclick="openEditUserModal(${u.userId}, '<c:out value="${u.fullName}"/>', '<c:out value="${u.email}"/>', '<c:out value="${u.department}"/>', '<c:out value="${u.cohort}"/>')"
                                                    class="p-1 rounded bg-slate-800 hover:bg-slate-700 text-slate-300 hover:text-white transition-colors" title="Edit Profile">
                                                <span class="material-symbols-Outlined text-base">edit</span>
                                            </button>

                                            <!-- Change Role (Not permitted on self) -->
                                            <c:if test="${u.userId != currentUser.userId}">
                                                <button type="button" 
                                                        onclick="openChangeRoleModal(${u.userId}, '<c:out value="${u.fullName}"/>', '<c:out value="${u.roleName}"/>')"
                                                        class="p-1 rounded bg-slate-800 hover:bg-slate-700 text-amber-400 hover:text-amber-300 transition-colors" title="Change Role">
                                                    <span class="material-symbols-Outlined text-base">manage_accounts</span>
                                                </button>
                                            </c:if>

                                            <!-- Reset Password -->
                                            <button type="button" 
                                                    onclick="openResetPasswordModal(${u.userId}, '<c:out value="${u.fullName}"/>')"
                                                    class="p-1 rounded bg-slate-800 hover:bg-slate-700 text-cyan-400 hover:text-cyan-300 transition-colors" title="Reset Password">
                                                <span class="material-symbols-Outlined text-base">lock_reset</span>
                                            </button>

                                            <!-- Status Toggle (Not permitted on self) -->
                                            <c:if test="${u.userId != currentUser.userId}">
                                                <form method="post" action="${pageContext.request.contextPath}/admin/users/status" class="inline" onsubmit="return confirm('Toggle status for <c:out value="${u.fullName}"/>?');">
                                                    <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}"/>
                                                    <input type="hidden" name="userId" value="${u.userId}"/>
                                                    <input type="hidden" name="status" value="${u.status == 'ACTIVE' ? 'INACTIVE' : 'ACTIVE'}"/>
                                                    <button type="submit" 
                                                            class="p-1 rounded transition-colors ${u.status == 'ACTIVE' ? 'bg-slate-800 hover:bg-rose-950 text-slate-400 hover:text-rose-400' : 'bg-emerald-950 text-emerald-400 hover:bg-emerald-900'}" 
                                                            title="${u.status == 'ACTIVE' ? 'Deactivate Account' : 'Activate Account'}">
                                                        <span class="material-symbols-Outlined text-base">${u.status == 'ACTIVE' ? 'toggle_on' : 'toggle_off'}</span>
                                                    </button>
                                                </form>
                                            </c:if>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>

                <!-- Pagination Footer -->
                <c:if test="${totalPages > 1}">
                    <div class="p-4 border-t border-slate-800 flex items-center justify-between text-xs text-slate-400">
                        <span>Page <c:out value="${currentPage}"/> of <c:out value="${totalPages}"/> (<c:out value="${totalCount}"/> total users)</span>
                        <div class="flex items-center gap-1.5">
                            <c:if test="${currentPage > 1}">
                                <a href="?page=${currentPage - 1}&search=<c:out value="${searchParam}"/>&role=<c:out value="${roleParam}"/>&status=<c:out value="${statusParam}"/>" 
                                   class="px-3 py-1.5 rounded-lg bg-slate-800 hover:bg-slate-700 text-white font-medium transition-colors">Previous</a>
                            </c:if>
                            <c:if test="${currentPage < totalPages}">
                                <a href="?page=${currentPage + 1}&search=<c:out value="${searchParam}"/>&role=<c:out value="${roleParam}"/>&status=<c:out value="${statusParam}"/>" 
                                   class="px-3 py-1.5 rounded-lg bg-slate-800 hover:bg-slate-700 text-white font-medium transition-colors">Next</a>
                            </c:if>
                        </div>
                    </div>
                </c:if>
            </div>

        </main>
    </div>

    <!-- MODAL 1: Create New User -->
    <div id="createUserModal" class="fixed inset-0 z-50 bg-slate-950/80 backdrop-blur-sm hidden flex items-center justify-center p-4">
        <div class="glass-card rounded-2xl border-slate-800 max-w-lg w-full p-6 space-y-4">
            <div class="flex items-center justify-between border-b border-slate-800 pb-3">
                <h3 class="text-base font-bold text-white flex items-center gap-2">
                    <span class="material-symbols-Outlined text-indigo-400">person_add</span>
                    <span>Create User Account</span>
                </h3>
                <button type="button" onclick="closeCreateUserModal()" class="text-slate-400 hover:text-white">
                    <span class="material-symbols-Outlined">close</span>
                </button>
            </div>

            <form method="post" action="${pageContext.request.contextPath}/admin/users/create" class="space-y-3.5">
                <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}"/>

                <div>
                    <label class="block text-xs font-semibold text-slate-300 mb-1">Full Legal Name *</label>
                    <input type="text" name="fullName" required placeholder="e.g. Dr. Jane Foster" 
                           class="w-full bg-slate-900 border border-slate-700 rounded-xl px-3.5 py-2 text-xs text-white focus:outline-none focus:border-indigo-500"/>
                </div>

                <div class="grid grid-cols-2 gap-3">
                    <div>
                        <label class="block text-xs font-semibold text-slate-300 mb-1">Roll / Employee ID *</label>
                        <input type="text" name="identifier" required placeholder="e.g. CS-2022-099" 
                               class="w-full bg-slate-900 border border-slate-700 rounded-xl px-3.5 py-2 text-xs text-white focus:outline-none focus:border-indigo-500 font-mono"/>
                    </div>
                    <div>
                        <label class="block text-xs font-semibold text-slate-300 mb-1">Assigned Role *</label>
                        <select name="roleName" required class="w-full bg-slate-900 border border-slate-700 rounded-xl px-3 py-2 text-xs text-white focus:outline-none focus:border-indigo-500">
                            <option value="STUDENT">Student</option>
                            <option value="TEACHER">Teacher</option>
                            <option value="ADMIN">Administrator</option>
                        </select>
                    </div>
                </div>

                <div>
                    <label class="block text-xs font-semibold text-slate-300 mb-1">Institutional Email *</label>
                    <input type="email" name="email" required placeholder="e.g. user@university.edu" 
                           class="w-full bg-slate-900 border border-slate-700 rounded-xl px-3.5 py-2 text-xs text-white focus:outline-none focus:border-indigo-500"/>
                </div>

                <div>
                    <label class="block text-xs font-semibold text-slate-300 mb-1">Temporary Password *</label>
                    <input type="password" name="password" required minlength="6" placeholder="At least 6 characters" 
                           class="w-full bg-slate-900 border border-slate-700 rounded-xl px-3.5 py-2 text-xs text-white focus:outline-none focus:border-indigo-500 font-mono"/>
                </div>

                <div class="grid grid-cols-2 gap-3">
                    <div>
                        <label class="block text-xs font-semibold text-slate-300 mb-1">Department</label>
                        <input type="text" name="department" placeholder="e.g. Computer Science" 
                               class="w-full bg-slate-900 border border-slate-700 rounded-xl px-3.5 py-2 text-xs text-white focus:outline-none focus:border-indigo-500"/>
                    </div>
                    <div>
                        <label class="block text-xs font-semibold text-slate-300 mb-1">Cohort / Section</label>
                        <input type="text" name="cohort" placeholder="e.g. Class of 2026" 
                               class="w-full bg-slate-900 border border-slate-700 rounded-xl px-3.5 py-2 text-xs text-white focus:outline-none focus:border-indigo-500"/>
                    </div>
                </div>

                <div class="pt-2 flex items-center justify-end gap-2.5">
                    <button type="button" onclick="closeCreateUserModal()" class="px-4 py-2 rounded-xl bg-slate-800 hover:bg-slate-700 text-slate-300 text-xs font-semibold">Cancel</button>
                    <button type="submit" class="px-4 py-2 rounded-xl bg-indigo-600 hover:bg-indigo-500 text-white text-xs font-semibold">Create Account</button>
                </div>
            </form>
        </div>
    </div>

    <!-- MODAL 2: Edit User Profile -->
    <div id="editUserModal" class="fixed inset-0 z-50 bg-slate-950/80 backdrop-blur-sm hidden flex items-center justify-center p-4">
        <div class="glass-card rounded-2xl border-slate-800 max-w-md w-full p-6 space-y-4">
            <div class="flex items-center justify-between border-b border-slate-800 pb-3">
                <h3 class="text-base font-bold text-white flex items-center gap-2">
                    <span class="material-symbols-Outlined text-indigo-400">edit</span>
                    <span>Edit User Profile</span>
                </h3>
                <button type="button" onclick="closeEditUserModal()" class="text-slate-400 hover:text-white">
                    <span class="material-symbols-Outlined">close</span>
                </button>
            </div>

            <form method="post" action="${pageContext.request.contextPath}/admin/users/edit" class="space-y-3.5">
                <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}"/>
                <input type="hidden" id="editUserId" name="userId" value=""/>

                <div>
                    <label class="block text-xs font-semibold text-slate-300 mb-1">Full Legal Name *</label>
                    <input type="text" id="editFullName" name="fullName" required 
                           class="w-full bg-slate-900 border border-slate-700 rounded-xl px-3.5 py-2 text-xs text-white focus:outline-none focus:border-indigo-500"/>
                </div>

                <div>
                    <label class="block text-xs font-semibold text-slate-300 mb-1">Institutional Email *</label>
                    <input type="email" id="editEmail" name="email" required 
                           class="w-full bg-slate-900 border border-slate-700 rounded-xl px-3.5 py-2 text-xs text-white focus:outline-none focus:border-indigo-500"/>
                </div>

                <div class="grid grid-cols-2 gap-3">
                    <div>
                        <label class="block text-xs font-semibold text-slate-300 mb-1">Department</label>
                        <input type="text" id="editDepartment" name="department" 
                               class="w-full bg-slate-900 border border-slate-700 rounded-xl px-3.5 py-2 text-xs text-white focus:outline-none focus:border-indigo-500"/>
                    </div>
                    <div>
                        <label class="block text-xs font-semibold text-slate-300 mb-1">Cohort</label>
                        <input type="text" id="editCohort" name="cohort" 
                               class="w-full bg-slate-900 border border-slate-700 rounded-xl px-3.5 py-2 text-xs text-white focus:outline-none focus:border-indigo-500"/>
                    </div>
                </div>

                <div class="pt-2 flex items-center justify-end gap-2.5">
                    <button type="button" onclick="closeEditUserModal()" class="px-4 py-2 rounded-xl bg-slate-800 hover:bg-slate-700 text-slate-300 text-xs font-semibold">Cancel</button>
                    <button type="submit" class="px-4 py-2 rounded-xl bg-indigo-600 hover:bg-indigo-500 text-white text-xs font-semibold">Save Profile</button>
                </div>
            </form>
        </div>
    </div>

    <!-- MODAL 3: Change Role Modal -->
    <div id="changeRoleModal" class="fixed inset-0 z-50 bg-slate-950/80 backdrop-blur-sm hidden flex items-center justify-center p-4">
        <div class="glass-card rounded-2xl border-slate-800 max-w-md w-full p-6 space-y-4">
            <div class="flex items-center justify-between border-b border-slate-800 pb-3">
                <h3 class="text-base font-bold text-white flex items-center gap-2">
                    <span class="material-symbols-Outlined text-amber-400">shield</span>
                    <span>Modify System Role</span>
                </h3>
                <button type="button" onclick="closeChangeRoleModal()" class="text-slate-400 hover:text-white">
                    <span class="material-symbols-Outlined">close</span>
                </button>
            </div>

            <form method="post" action="${pageContext.request.contextPath}/admin/users/role" class="space-y-4">
                <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}"/>
                <input type="hidden" id="roleUserId" name="userId" value=""/>

                <p class="text-xs text-slate-300">
                    Modifying system privileges for <strong id="roleUserName" class="text-white"></strong>.
                </p>

                <div class="p-3 rounded-xl bg-amber-500/10 border border-amber-500/20 text-amber-300 text-xs">
                    <span class="font-semibold block mb-0.5">⚠️ Security Protection:</span>
                    Demoting an active Administrator is prevented if they are the last administrator in the system.
                </div>

                <div>
                    <label class="block text-xs font-semibold text-slate-300 mb-1">New Role Assignment *</label>
                    <select id="newRoleSelect" name="newRole" class="w-full bg-slate-900 border border-slate-700 rounded-xl px-3.5 py-2 text-xs text-white focus:outline-none focus:border-indigo-500">
                        <option value="STUDENT">Student</option>
                        <option value="TEACHER">Teacher</option>
                        <option value="ADMIN">Administrator</option>
                    </select>
                </div>

                <div class="pt-2 flex items-center justify-end gap-2.5">
                    <button type="button" onclick="closeChangeRoleModal()" class="px-4 py-2 rounded-xl bg-slate-800 hover:bg-slate-700 text-slate-300 text-xs font-semibold">Cancel</button>
                    <button type="submit" class="px-4 py-2 rounded-xl bg-amber-600 hover:bg-amber-500 text-white text-xs font-semibold">Update Role</button>
                </div>
            </form>
        </div>
    </div>

    <!-- MODAL 4: Reset Password Modal -->
    <div id="resetPasswordModal" class="fixed inset-0 z-50 bg-slate-950/80 backdrop-blur-sm hidden flex items-center justify-center p-4">
        <div class="glass-card rounded-2xl border-slate-800 max-w-md w-full p-6 space-y-4">
            <div class="flex items-center justify-between border-b border-slate-800 pb-3">
                <h3 class="text-base font-bold text-white flex items-center gap-2">
                    <span class="material-symbols-Outlined text-cyan-400">lock_reset</span>
                    <span>Administrative Password Reset</span>
                </h3>
                <button type="button" onclick="closeResetPasswordModal()" class="text-slate-400 hover:text-white">
                    <span class="material-symbols-Outlined">close</span>
                </button>
            </div>

            <form method="post" action="${pageContext.request.contextPath}/admin/users/reset-password" class="space-y-4">
                <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}"/>
                <input type="hidden" id="resetUserId" name="userId" value=""/>

                <p class="text-xs text-slate-300">
                    Set a new temporary password for <strong id="resetUserName" class="text-white"></strong>. The password will be hashed using BCrypt.
                </p>

                <div>
                    <label class="block text-xs font-semibold text-slate-300 mb-1">New Temporary Password *</label>
                    <input type="password" name="newPassword" required minlength="6" placeholder="Enter new password (min 6 chars)" 
                           class="w-full bg-slate-900 border border-slate-700 rounded-xl px-3.5 py-2 text-xs text-white focus:outline-none focus:border-indigo-500 font-mono"/>
                </div>

                <div class="pt-2 flex items-center justify-end gap-2.5">
                    <button type="button" onclick="closeResetPasswordModal()" class="px-4 py-2 rounded-xl bg-slate-800 hover:bg-slate-700 text-slate-300 text-xs font-semibold">Cancel</button>
                    <button type="submit" class="px-4 py-2 rounded-xl bg-cyan-600 hover:bg-cyan-500 text-white text-xs font-semibold">Reset Password</button>
                </div>
            </form>
        </div>
    </div>

    <!-- JavaScript for Modals -->
    <script>
        function openCreateUserModal() {
            document.getElementById('createUserModal').classList.remove('hidden');
        }
        function closeCreateUserModal() {
            document.getElementById('createUserModal').classList.add('hidden');
        }

        function openEditUserModal(userId, fullName, email, department, cohort) {
            document.getElementById('editUserId').value = userId;
            document.getElementById('editFullName').value = fullName;
            document.getElementById('editEmail').value = email;
            document.getElementById('editDepartment').value = department === 'null' ? '' : department;
            document.getElementById('editCohort').value = cohort === 'null' ? '' : cohort;
            document.getElementById('editUserModal').classList.remove('hidden');
        }
        function closeEditUserModal() {
            document.getElementById('editUserModal').classList.add('hidden');
        }

        function openChangeRoleModal(userId, fullName, currentRole) {
            document.getElementById('roleUserId').value = userId;
            document.getElementById('roleUserName').innerText = fullName;
            document.getElementById('newRoleSelect').value = currentRole;
            document.getElementById('changeRoleModal').classList.remove('hidden');
        }
        function closeChangeRoleModal() {
            document.getElementById('changeRoleModal').classList.add('hidden');
        }

        function openResetPasswordModal(userId, fullName) {
            document.getElementById('resetUserId').value = userId;
            document.getElementById('resetUserName').innerText = fullName;
            document.getElementById('resetPasswordModal').classList.remove('hidden');
        }
        function closeResetPasswordModal() {
            document.getElementById('resetPasswordModal').classList.add('hidden');
        }
    </script>
</body>
</html>
