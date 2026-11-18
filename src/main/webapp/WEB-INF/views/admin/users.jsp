<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en" class="h-full bg-[#f8faff]">
<head>
    <meta charset="utf-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>User Roster &amp; Access Directory | QuizTrack Administration</title>
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
               class="flex items-center gap-3 px-3.5 py-2.5 rounded-xl font-semibold text-sm transition-all bg-indigo-600 text-white shadow-xs">
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
                <h1 class="font-display text-lg font-bold text-slate-900 tracking-tight">Institutional User Directory</h1>
                <span class="text-xs font-mono px-2.5 py-0.5 rounded-full bg-slate-100 text-slate-700 border border-slate-200 font-semibold">Total Users: <c:out value="${totalCount}"/></span>
            </div>

            <button type="button" onclick="openCreateUserModal()" 
                    class="px-4 py-2 rounded-xl bg-indigo-600 hover:bg-indigo-700 text-white font-semibold text-xs transition-all shadow-sm hover:shadow flex items-center gap-2 cursor-pointer active:scale-95">
                <span class="material-symbols-outlined text-base">person_add</span>
                <span>Add New User</span>
            </button>
        </header>

        <!-- Main Body -->
        <main class="p-6 md:p-8 space-y-6 max-w-7xl mx-auto w-full">

            <!-- Alerts -->
            <c:if test="${not empty param.success}">
                <div class="p-4 rounded-xl bg-emerald-50 border border-emerald-200 text-emerald-800 text-xs flex items-center gap-2 shadow-2xs">
                    <span class="material-symbols-outlined text-emerald-600 text-lg">check_circle</span>
                    <span><c:out value="${param.success}"/></span>
                </div>
            </c:if>

            <c:if test="${not empty param.error}">
                <div class="p-4 rounded-xl bg-rose-50 border border-rose-200 text-rose-800 text-xs flex items-center gap-2 shadow-2xs">
                    <span class="material-symbols-outlined text-rose-600 text-lg">error</span>
                    <span><c:out value="${param.error}"/></span>
                </div>
            </c:if>

            <!-- Search & Filter Controls -->
            <div class="bg-white rounded-2xl p-4 shadow-2xs border border-slate-200/90">
                <form method="get" action="${pageContext.request.contextPath}/admin/users" class="flex flex-col md:flex-row gap-3">
                    <div class="flex-1 relative">
                        <span class="material-symbols-outlined absolute left-3.5 top-1/2 -translate-y-1/2 text-slate-400 text-lg">search</span>
                        <input type="text" name="search" value="<c:out value="${searchParam}"/>" placeholder="Search by name, email, roll number, or department..." 
                               class="w-full bg-slate-50 border border-slate-200 focus:bg-white focus:border-indigo-600 rounded-xl pl-10 pr-4 py-2.5 text-xs text-slate-800 placeholder-slate-400 focus:outline-none transition-colors"/>
                    </div>

                    <div class="w-full md:w-44">
                        <select name="role" class="w-full bg-slate-50 border border-slate-200 focus:bg-white focus:border-indigo-600 rounded-xl px-3 py-2.5 text-xs text-slate-800 focus:outline-none font-medium">
                            <option value="ALL" <c:if test="${roleParam == 'ALL'}">selected</c:if>>All Roles</option>
                            <option value="STUDENT" <c:if test="${roleParam == 'STUDENT'}">selected</c:if>>Student</option>
                            <option value="TEACHER" <c:if test="${roleParam == 'TEACHER'}">selected</c:if>>Teacher</option>
                            <option value="ADMIN" <c:if test="${roleParam == 'ADMIN'}">selected</c:if>>Administrator</option>
                        </select>
                    </div>

                    <div class="w-full md:w-44">
                        <select name="status" class="w-full bg-slate-50 border border-slate-200 focus:bg-white focus:border-indigo-600 rounded-xl px-3 py-2.5 text-xs text-slate-800 focus:outline-none font-medium">
                            <option value="ALL" <c:if test="${statusParam == 'ALL'}">selected</c:if>>All Statuses</option>
                            <option value="ACTIVE" <c:if test="${statusParam == 'ACTIVE'}">selected</c:if>>Active</option>
                            <option value="INACTIVE" <c:if test="${statusParam == 'INACTIVE'}">selected</c:if>>Inactive</option>
                            <option value="SUSPENDED" <c:if test="${statusParam == 'SUSPENDED'}">selected</c:if>>Suspended</option>
                        </select>
                    </div>

                    <button type="submit" class="px-5 py-2.5 rounded-xl bg-indigo-600 hover:bg-indigo-700 text-white font-semibold text-xs transition-colors flex items-center justify-center gap-1.5 shrink-0 shadow-xs cursor-pointer">
                        <span class="material-symbols-outlined text-base">filter_list</span>
                        <span>Filter</span>
                    </button>
                    <a href="${pageContext.request.contextPath}/admin/users" class="px-3.5 py-2.5 rounded-xl border border-slate-200 bg-slate-50 hover:bg-slate-100 text-slate-600 text-xs transition-colors flex items-center justify-center shrink-0" title="Reset Filters">
                        <span class="material-symbols-outlined text-base">refresh</span>
                    </a>
                </form>
            </div>

            <!-- User Data Table -->
            <div class="bg-white rounded-2xl shadow-2xs border border-slate-200/90 overflow-hidden">
                <div class="overflow-x-auto">
                    <table class="w-full text-left text-xs border-collapse">
                        <thead>
                            <tr class="border-b border-slate-200 bg-slate-50/80 text-slate-500 font-mono text-[11px] uppercase tracking-wider font-bold">
                                <th class="py-3.5 px-4">User</th>
                                <th class="py-3.5 px-4">Identifier / ID</th>
                                <th class="py-3.5 px-4">Role</th>
                                <th class="py-3.5 px-4">Department / Cohort</th>
                                <th class="py-3.5 px-4">Status</th>
                                <th class="py-3.5 px-4">Registered</th>
                                <th class="py-3.5 px-4 text-right">Actions</th>
                            </tr>
                        </thead>
                        <tbody class="divide-y divide-slate-100">
                            <c:forEach var="u" items="${users}">
                                <tr class="hover:bg-slate-50/70 transition-colors">
                                    <td class="py-3.5 px-4">
                                        <div class="flex items-center gap-3">
                                            <div class="w-9 h-9 rounded-xl bg-indigo-50 border border-indigo-200 flex items-center justify-center text-xs font-bold text-indigo-700 shrink-0">
                                                <c:out value="${u.fullName.substring(0, 1)}"/>
                                            </div>
                                            <div>
                                                <span class="font-semibold text-slate-900 block"><c:out value="${u.fullName}"/></span>
                                                <span class="text-slate-400 text-[11px]"><c:out value="${u.email}"/></span>
                                            </div>
                                        </div>
                                    </td>
                                    <td class="py-3.5 px-4 font-mono font-semibold text-slate-700">
                                        <c:out value="${u.identifier}"/>
                                    </td>
                                    <td class="py-3.5 px-4">
                                        <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-[10px] font-bold tracking-wide
                                            <c:choose>
                                                <c:when test="${u.roleName == 'ADMIN'}">bg-purple-50 text-purple-700 border border-purple-200</c:when>
                                                <c:when test="${u.roleName == 'TEACHER'}">bg-amber-50 text-amber-700 border border-amber-200</c:when>
                                                <c:otherwise>bg-indigo-50 text-indigo-700 border border-indigo-200</c:otherwise>
                                            </c:choose>">
                                            <c:out value="${u.roleName}"/>
                                        </span>
                                    </td>
                                    <td class="py-3.5 px-4 text-slate-600">
                                        <div class="font-medium text-slate-800"><c:out value="${u.department != null ? u.department : 'N/A'}"/></div>
                                        <c:if test="${not empty u.cohort}">
                                            <span class="text-[10px] font-mono text-slate-400 block"><c:out value="${u.cohort}"/></span>
                                        </c:if>
                                    </td>
                                    <td class="py-3.5 px-4">
                                        <span class="inline-flex items-center gap-1.5 px-2.5 py-0.5 rounded-full text-[10px] font-semibold
                                            <c:choose>
                                                <c:when test="${u.status == 'ACTIVE'}">bg-emerald-50 text-emerald-700 border border-emerald-200</c:when>
                                                <c:when test="${u.status == 'INACTIVE'}">bg-slate-100 text-slate-600 border border-slate-200</c:when>
                                                <c:otherwise>bg-rose-50 text-rose-700 border border-rose-200</c:otherwise>
                                            </c:choose>">
                                            <span class="w-1.5 h-1.5 rounded-full ${u.status == 'ACTIVE' ? 'bg-emerald-500' : 'bg-slate-400'}"></span>
                                            <c:out value="${u.status}"/>
                                        </span>
                                    </td>
                                    <td class="py-3.5 px-4 text-slate-400 font-mono text-[11px]">
                                        <fmt:formatDate value="${u.createdAt}" pattern="yyyy-MM-dd"/>
                                    </td>
                                    <td class="py-3.5 px-4 text-right">
                                        <div class="flex items-center justify-end gap-1.5">
                                            <!-- Edit User Profile -->
                                            <button type="button" 
                                                    onclick="openEditUserModal(${u.userId}, '<c:out value="${u.fullName}"/>', '<c:out value="${u.email}"/>', '<c:out value="${u.department}"/>', '<c:out value="${u.cohort}"/>')"
                                                    class="p-1.5 rounded-lg border border-slate-200 text-slate-500 hover:text-indigo-600 hover:bg-indigo-50 transition-colors" 
                                                    title="Edit User">
                                                <span class="material-symbols-outlined text-base">edit</span>
                                            </button>

                                            <!-- Change Role (Not permitted on self) -->
                                            <c:if test="${u.userId != currentUser.userId}">
                                                <button type="button" 
                                                        onclick="openChangeRoleModal(${u.userId}, '<c:out value="${u.fullName}"/>', '<c:out value="${u.roleName}"/>')"
                                                        class="p-1.5 rounded-lg border border-slate-200 text-slate-500 hover:text-amber-600 hover:bg-amber-50 transition-colors" 
                                                        title="Change Role">
                                                    <span class="material-symbols-outlined text-base">manage_accounts</span>
                                                </button>
                                            </c:if>

                                            <!-- Reset Password -->
                                            <button type="button" 
                                                    onclick="openResetPasswordModal(${u.userId}, '<c:out value="${u.fullName}"/>')"
                                                    class="p-1.5 rounded-lg border border-slate-200 text-slate-500 hover:text-sky-600 hover:bg-sky-50 transition-colors" 
                                                    title="Reset Password">
                                                <span class="material-symbols-outlined text-base">lock_reset</span>
                                            </button>

                                            <!-- Status Toggle (Not permitted on self) -->
                                            <c:if test="${u.userId != currentUser.userId}">
                                                <form method="post" action="${pageContext.request.contextPath}/admin/users/status" class="inline" onsubmit="return confirm('Toggle status for <c:out value="${u.fullName}"/>?');">
                                                    <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}"/>
                                                    <input type="hidden" name="userId" value="${u.userId}"/>
                                                    <input type="hidden" name="status" value="${u.status == 'ACTIVE' ? 'INACTIVE' : 'ACTIVE'}"/>
                                                    <button type="submit" 
                                                            class="p-1.5 rounded-lg border border-slate-200 transition-colors ${u.status == 'ACTIVE' ? 'text-slate-500 hover:text-rose-600 hover:bg-rose-50' : 'text-emerald-600 hover:bg-emerald-50'}" 
                                                            title="${u.status == 'ACTIVE' ? 'Deactivate Account' : 'Activate Account'}">
                                                        <span class="material-symbols-outlined text-base">${u.status == 'ACTIVE' ? 'toggle_on' : 'toggle_off'}</span>
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
                    <div class="p-4 border-t border-slate-100 flex items-center justify-between text-xs text-slate-500 bg-slate-50/50">
                        <span>Page <strong class="text-slate-800 font-bold"><c:out value="${currentPage}"/></strong> of <c:out value="${totalPages}"/> (<c:out value="${totalCount}"/> total users)</span>
                        <div class="flex items-center gap-1.5">
                            <c:if test="${currentPage > 1}">
                                <a href="?page=${currentPage - 1}&search=<c:out value="${searchParam}"/>&role=<c:out value="${roleParam}"/>&status=<c:out value="${statusParam}"/>" 
                                   class="px-3 py-1.5 rounded-lg border border-slate-200 bg-white hover:bg-slate-50 text-slate-700 font-semibold transition-colors">Previous</a>
                            </c:if>
                            <c:if test="${currentPage < totalPages}">
                                <a href="?page=${currentPage + 1}&search=<c:out value="${searchParam}"/>&role=<c:out value="${roleParam}"/>&status=<c:out value="${statusParam}"/>" 
                                   class="px-3 py-1.5 rounded-lg border border-slate-200 bg-white hover:bg-slate-50 text-slate-700 font-semibold transition-colors">Next</a>
                            </c:if>
                        </div>
                    </div>
                </c:if>
            </div>

        </main>
    </div>

    <!-- MODAL 1: Create New User -->
    <div id="createUserModal" class="fixed inset-0 z-50 bg-black/60 backdrop-blur-xs hidden flex items-center justify-center p-4">
        <div class="bg-white rounded-2xl border border-slate-200 shadow-2xl max-w-lg w-full p-6 space-y-4">
            <div class="flex items-center justify-between border-b border-slate-100 pb-3">
                <h3 class="font-display text-base font-bold text-slate-900 flex items-center gap-2">
                    <span class="material-symbols-outlined text-indigo-600">person_add</span>
                    <span>Create User Account</span>
                </h3>
                <button type="button" onclick="closeCreateUserModal()" class="text-slate-400 hover:text-slate-700 p-1 rounded-lg">
                    <span class="material-symbols-outlined">close</span>
                </button>
            </div>

            <form method="post" action="${pageContext.request.contextPath}/admin/users/create" class="space-y-3.5">
                <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}"/>

                <div>
                    <label class="block text-xs font-semibold text-slate-700 mb-1">Full Legal Name *</label>
                    <input type="text" name="fullName" required placeholder="e.g. Dr. Jane Foster" 
                           class="w-full bg-slate-50 border border-slate-200 focus:bg-white focus:border-indigo-600 rounded-xl px-3.5 py-2 text-xs text-slate-800 focus:outline-none font-medium"/>
                </div>

                <div class="grid grid-cols-2 gap-3">
                    <div>
                        <label class="block text-xs font-semibold text-slate-700 mb-1">Roll / Employee ID *</label>
                        <input type="text" name="identifier" required placeholder="e.g. CS-2022-099" 
                               class="w-full bg-slate-50 border border-slate-200 focus:bg-white focus:border-indigo-600 rounded-xl px-3.5 py-2 text-xs text-slate-800 focus:outline-none font-mono"/>
                    </div>
                    <div>
                        <label class="block text-xs font-semibold text-slate-700 mb-1">Assigned Role *</label>
                        <select name="roleName" required class="w-full bg-slate-50 border border-slate-200 focus:bg-white focus:border-indigo-600 rounded-xl px-3 py-2 text-xs text-slate-800 focus:outline-none font-medium">
                            <option value="STUDENT">Student</option>
                            <option value="TEACHER">Teacher</option>
                            <option value="ADMIN">Administrator</option>
                        </select>
                    </div>
                </div>

                <div>
                    <label class="block text-xs font-semibold text-slate-700 mb-1">Institutional Email *</label>
                    <input type="email" name="email" required placeholder="e.g. user@university.edu" 
                           class="w-full bg-slate-50 border border-slate-200 focus:bg-white focus:border-indigo-600 rounded-xl px-3.5 py-2 text-xs text-slate-800 focus:outline-none"/>
                </div>

                <div>
                    <label class="block text-xs font-semibold text-slate-700 mb-1">Temporary Password *</label>
                    <input type="password" name="password" required minlength="6" placeholder="At least 6 characters" 
                           class="w-full bg-slate-50 border border-slate-200 focus:bg-white focus:border-indigo-600 rounded-xl px-3.5 py-2 text-xs text-slate-800 focus:outline-none font-mono"/>
                </div>

                <div class="grid grid-cols-2 gap-3">
                    <div>
                        <label class="block text-xs font-semibold text-slate-700 mb-1">Academic Department</label>
                        <select name="department" class="w-full bg-slate-50 border border-slate-200 focus:bg-white focus:border-indigo-600 rounded-xl px-3 py-2 text-xs text-slate-800 focus:outline-none font-medium">
                            <option value="Computer Science">Computer Science</option>
                            <option value="Information Technology">Information Technology</option>
                            <option value="Electrical Engineering">Electrical Engineering</option>
                            <option value="Mechanical Engineering">Mechanical Engineering</option>
                            <option value="Civil Engineering">Civil Engineering</option>
                            <option value="Electronics & Communication">Electronics & Communication</option>
                            <option value="Mathematics">Mathematics</option>
                            <option value="Physics">Physics</option>
                            <option value="Administration">Administration</option>
                        </select>
                    </div>
                    <div>
                        <label class="block text-xs font-semibold text-slate-700 mb-1">Cohort / Section</label>
                        <select name="cohort" class="w-full bg-slate-50 border border-slate-200 focus:bg-white focus:border-indigo-600 rounded-xl px-3 py-2 text-xs text-slate-800 focus:outline-none font-medium">
                            <option value="Class of 2026">Class of 2026</option>
                            <option value="Class of 2025">Class of 2025</option>
                            <option value="Class of 2027">Class of 2027</option>
                            <option value="Class of 2028">Class of 2028</option>
                            <option value="CS Senior Cohort 2026">CS Senior Cohort 2026</option>
                            <option value="Section A">Section A</option>
                            <option value="Section B">Section B</option>
                            <option value="Section C">Section C</option>
                            <option value="Faculty">Faculty</option>
                            <option value="Staff">Staff</option>
                        </select>
                    </div>
                </div>

                <div class="pt-2 flex items-center justify-end gap-2.5">
                    <button type="button" onclick="closeCreateUserModal()" class="px-4 py-2 rounded-xl border border-slate-200 bg-white hover:bg-slate-50 text-slate-700 text-xs font-semibold">Cancel</button>
                    <button type="submit" class="px-5 py-2 rounded-xl bg-indigo-600 hover:bg-indigo-700 text-white text-xs font-semibold shadow-xs">Create Account</button>
                </div>
            </form>
        </div>
    </div>

    <!-- MODAL 2: Edit User Profile -->
    <div id="editUserModal" class="fixed inset-0 z-50 bg-black/60 backdrop-blur-xs hidden flex items-center justify-center p-4">
        <div class="bg-white rounded-2xl border border-slate-200 shadow-2xl max-w-md w-full p-6 space-y-4">
            <div class="flex items-center justify-between border-b border-slate-100 pb-3">
                <h3 class="font-display text-base font-bold text-slate-900 flex items-center gap-2">
                    <span class="material-symbols-outlined text-indigo-600">edit</span>
                    <span>Edit User Profile</span>
                </h3>
                <button type="button" onclick="closeEditUserModal()" class="text-slate-400 hover:text-slate-700 p-1 rounded-lg">
                    <span class="material-symbols-outlined">close</span>
                </button>
            </div>

            <form method="post" action="${pageContext.request.contextPath}/admin/users/edit" class="space-y-3.5">
                <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}"/>
                <input type="hidden" id="editUserId" name="userId" value=""/>

                <div>
                    <label class="block text-xs font-semibold text-slate-700 mb-1">Full Legal Name *</label>
                    <input type="text" id="editFullName" name="fullName" required 
                           class="w-full bg-slate-50 border border-slate-200 focus:bg-white focus:border-indigo-600 rounded-xl px-3.5 py-2 text-xs text-slate-800 focus:outline-none font-medium"/>
                </div>

                <div>
                    <label class="block text-xs font-semibold text-slate-700 mb-1">Institutional Email *</label>
                    <input type="email" id="editEmail" name="email" required 
                           class="w-full bg-slate-50 border border-slate-200 focus:bg-white focus:border-indigo-600 rounded-xl px-3.5 py-2 text-xs text-slate-800 focus:outline-none"/>
                </div>

                <div>
                    <label class="block text-xs font-semibold text-slate-700 mb-1">Academic Department</label>
                    <select id="editDepartment" name="department" class="w-full bg-slate-50 border border-slate-200 focus:bg-white focus:border-indigo-600 rounded-xl px-3 py-2 text-xs text-slate-800 focus:outline-none font-medium">
                        <option value="Computer Science">Computer Science</option>
                        <option value="Information Technology">Information Technology</option>
                        <option value="Electrical Engineering">Electrical Engineering</option>
                        <option value="Mechanical Engineering">Mechanical Engineering</option>
                        <option value="Civil Engineering">Civil Engineering</option>
                        <option value="Electronics & Communication">Electronics & Communication</option>
                        <option value="Mathematics">Mathematics</option>
                        <option value="Physics">Physics</option>
                        <option value="Administration">Administration</option>
                    </select>
                </div>

                <div>
                    <label class="block text-xs font-semibold text-slate-700 mb-1">Cohort / Class Section</label>
                    <select id="editCohort" name="cohort" class="w-full bg-slate-50 border border-slate-200 focus:bg-white focus:border-indigo-600 rounded-xl px-3 py-2 text-xs text-slate-800 focus:outline-none font-medium">
                        <option value="Class of 2026">Class of 2026</option>
                        <option value="Class of 2025">Class of 2025</option>
                        <option value="Class of 2027">Class of 2027</option>
                        <option value="Class of 2028">Class of 2028</option>
                        <option value="CS Senior Cohort 2026">CS Senior Cohort 2026</option>
                        <option value="Section A">Section A</option>
                        <option value="Section B">Section B</option>
                        <option value="Section C">Section C</option>
                        <option value="Faculty">Faculty</option>
                        <option value="Staff">Staff</option>
                    </select>
                </div>

                <div class="pt-2 flex items-center justify-end gap-2.5">
                    <button type="button" onclick="closeEditUserModal()" class="px-4 py-2 rounded-xl border border-slate-200 bg-white hover:bg-slate-50 text-slate-700 text-xs font-semibold">Cancel</button>
                    <button type="submit" class="px-5 py-2 rounded-xl bg-indigo-600 hover:bg-indigo-700 text-white text-xs font-semibold shadow-xs">Save Changes</button>
                </div>
            </form>
        </div>
    </div>

    <!-- MODAL 3: Change Role Modal -->
    <div id="changeRoleModal" class="fixed inset-0 z-50 bg-black/60 backdrop-blur-xs hidden flex items-center justify-center p-4">
        <div class="bg-white rounded-2xl border border-slate-200 shadow-2xl max-w-md w-full p-6 space-y-4">
            <div class="flex items-center justify-between border-b border-slate-100 pb-3">
                <h3 class="font-display text-base font-bold text-slate-900 flex items-center gap-2">
                    <span class="material-symbols-outlined text-amber-500">manage_accounts</span>
                    <span>Reassign User Role</span>
                </h3>
                <button type="button" onclick="closeChangeRoleModal()" class="text-slate-400 hover:text-slate-700 p-1 rounded-lg">
                    <span class="material-symbols-outlined">close</span>
                </button>
            </div>

            <form method="post" action="${pageContext.request.contextPath}/admin/users/role" class="space-y-4">
                <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}"/>
                <input type="hidden" id="roleUserId" name="userId" value=""/>

                <p class="text-xs text-slate-600">
                    Reassigning permissions for <strong id="roleUserName" class="text-slate-900"></strong>. This immediately alters dashboard and routing authorization.
                </p>

                <div>
                    <label class="block text-xs font-semibold text-slate-700 mb-1">Target Role *</label>
                    <select id="newRoleSelect" name="roleName" required class="w-full bg-slate-50 border border-slate-200 focus:bg-white focus:border-indigo-600 rounded-xl px-3 py-2 text-xs text-slate-800 focus:outline-none font-medium">
                        <option value="STUDENT">Student</option>
                        <option value="TEACHER">Teacher</option>
                        <option value="ADMIN">Administrator</option>
                    </select>
                </div>

                <div class="pt-2 flex items-center justify-end gap-2.5">
                    <button type="button" onclick="closeChangeRoleModal()" class="px-4 py-2 rounded-xl border border-slate-200 bg-white hover:bg-slate-50 text-slate-700 text-xs font-semibold">Cancel</button>
                    <button type="submit" class="px-5 py-2 rounded-xl bg-amber-600 hover:bg-amber-700 text-white text-xs font-semibold shadow-xs">Update Role</button>
                </div>
            </form>
        </div>
    </div>

    <!-- MODAL 4: Reset Password Modal -->
    <div id="resetPasswordModal" class="fixed inset-0 z-50 bg-black/60 backdrop-blur-xs hidden flex items-center justify-center p-4">
        <div class="bg-white rounded-2xl border border-slate-200 shadow-2xl max-w-md w-full p-6 space-y-4">
            <div class="flex items-center justify-between border-b border-slate-100 pb-3">
                <h3 class="font-display text-base font-bold text-slate-900 flex items-center gap-2">
                    <span class="material-symbols-outlined text-sky-600">lock_reset</span>
                    <span>Administrative Password Reset</span>
                </h3>
                <button type="button" onclick="closeResetPasswordModal()" class="text-slate-400 hover:text-slate-700 p-1 rounded-lg">
                    <span class="material-symbols-outlined">close</span>
                </button>
            </div>

            <form method="post" action="${pageContext.request.contextPath}/admin/users/reset-password" class="space-y-4">
                <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}"/>
                <input type="hidden" id="resetUserId" name="userId" value=""/>

                <p class="text-xs text-slate-600">
                    Set a new temporary password for <strong id="resetUserName" class="text-slate-900"></strong>. The password will be hashed using BCrypt.
                </p>

                <div>
                    <label class="block text-xs font-semibold text-slate-700 mb-1">New Temporary Password *</label>
                    <input type="password" name="newPassword" required minlength="6" placeholder="Enter new password (min 6 chars)" 
                           class="w-full bg-slate-50 border border-slate-200 focus:bg-white focus:border-indigo-600 rounded-xl px-3.5 py-2 text-xs text-slate-800 focus:outline-none font-mono"/>
                </div>

                <div class="pt-2 flex items-center justify-end gap-2.5">
                    <button type="button" onclick="closeResetPasswordModal()" class="px-4 py-2 rounded-xl border border-slate-200 bg-white hover:bg-slate-50 text-slate-700 text-xs font-semibold">Cancel</button>
                    <button type="submit" class="px-5 py-2 rounded-xl bg-sky-600 hover:bg-sky-700 text-white text-xs font-semibold shadow-xs">Reset Password</button>
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

            const deptVal = (department === 'null' || !department) ? '' : department.trim();
            const deptSelect = document.getElementById('editDepartment');
            if (deptVal) {
                let foundDept = false;
                for (let i = 0; i < deptSelect.options.length; i++) {
                    if (deptSelect.options[i].value.toLowerCase() === deptVal.toLowerCase()) {
                        deptSelect.selectedIndex = i;
                        foundDept = true;
                        break;
                    }
                }
                if (!foundDept) {
                    const opt = document.createElement('option');
                    opt.value = deptVal;
                    opt.text = deptVal;
                    deptSelect.add(opt);
                    deptSelect.value = deptVal;
                }
            }

            const cohortVal = (cohort === 'null' || !cohort) ? '' : cohort.trim();
            const cohortSelect = document.getElementById('editCohort');
            if (cohortVal) {
                let foundCohort = false;
                for (let i = 0; i < cohortSelect.options.length; i++) {
                    if (cohortSelect.options[i].value.toLowerCase() === cohortVal.toLowerCase()) {
                        cohortSelect.selectedIndex = i;
                        foundCohort = true;
                        break;
                    }
                }
                if (!foundCohort) {
                    const opt = document.createElement('option');
                    opt.value = cohortVal;
                    opt.text = cohortVal;
                    cohortSelect.add(opt);
                    cohortSelect.value = cohortVal;
                }
            }

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
