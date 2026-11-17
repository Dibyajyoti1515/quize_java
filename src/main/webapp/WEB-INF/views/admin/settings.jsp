<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en" class="h-full bg-slate-950">
<head>
    <meta charset="utf-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>System Configuration | QuizTrack Administration</title>
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
               class="flex items-center gap-3 px-3.5 py-2.5 rounded-xl font-medium text-sm transition-all bg-indigo-600/15 text-indigo-400 border border-indigo-500/30">
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
                <h1 class="text-lg font-bold text-white tracking-tight">System Configuration &amp; Parameters</h1>
                <span class="text-xs font-mono px-2 py-0.5 rounded-full bg-slate-800 text-slate-300 border border-slate-700">PostgreSQL Persistent</span>
            </div>
        </header>

        <!-- Main Body -->
        <main class="p-6 md:p-8 space-y-6 max-w-5xl mx-auto w-full">

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

            <form method="post" action="${pageContext.request.contextPath}/admin/settings" class="space-y-6">
                <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}"/>

                <!-- Card 1: Institutional Identity -->
                <div class="glass-card rounded-2xl p-6 border-slate-800 space-y-4">
                    <div class="flex items-center gap-2.5 border-b border-slate-800 pb-3">
                        <span class="material-symbols-Outlined text-indigo-400">domain</span>
                        <div>
                            <h3 class="text-sm font-bold text-white">General &amp; Institutional Identity</h3>
                            <p class="text-xs text-slate-400">Institutional branding and platform identity</p>
                        </div>
                    </div>

                    <div>
                        <label class="block text-xs font-semibold text-slate-300 mb-1">Application Name / Institution Title *</label>
                        <input type="text" name="app_name" required value="<c:out value="${settingsMap['app_name'].settingValue}"/>" 
                               class="w-full bg-slate-900 border border-slate-700 rounded-xl px-3.5 py-2 text-xs text-white focus:outline-none focus:border-indigo-500"/>
                        <span class="text-[11px] text-slate-400 mt-1 block">Displayed on student certification seals and authentication banners.</span>
                    </div>
                </div>

                <!-- Card 2: Examination Engine Constraints -->
                <div class="glass-card rounded-2xl p-6 border-slate-800 space-y-4">
                    <div class="flex items-center gap-2.5 border-b border-slate-800 pb-3">
                        <span class="material-symbols-Outlined text-cyan-400">timer</span>
                        <div>
                            <h3 class="text-sm font-bold text-white">Examination Engine Bounds &amp; Academic Standards</h3>
                            <p class="text-xs text-slate-400">Enforced by the examination scheduler and faculty question builder</p>
                        </div>
                    </div>

                    <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
                        <div>
                            <label class="block text-xs font-semibold text-slate-300 mb-1">Default Quiz Duration (Minutes) *</label>
                            <input type="number" name="default_quiz_duration" required min="5" max="300" value="<c:out value="${settingsMap['default_quiz_duration'].settingValue}"/>" 
                                   class="w-full bg-slate-900 border border-slate-700 rounded-xl px-3.5 py-2 text-xs text-white focus:outline-none focus:border-indigo-500 font-mono"/>
                            <span class="text-[11px] text-slate-400 mt-1 block">Pre-filled default for new quizzes (5-300 min).</span>
                        </div>

                        <div>
                            <label class="block text-xs font-semibold text-slate-300 mb-1">Maximum Allowed Duration (Minutes) *</label>
                            <input type="number" name="max_quiz_duration" required min="10" max="600" value="<c:out value="${settingsMap['max_quiz_duration'].settingValue}"/>" 
                                   class="w-full bg-slate-900 border border-slate-700 rounded-xl px-3.5 py-2 text-xs text-white focus:outline-none focus:border-indigo-500 font-mono"/>
                            <span class="text-[11px] text-slate-400 mt-1 block">Upper bound limit across all faculty quizzes (10-600 min).</span>
                        </div>

                        <div>
                            <label class="block text-xs font-semibold text-slate-300 mb-1">Default Passing Percentage (%) *</label>
                            <input type="number" step="0.1" name="default_passing_percentage" required min="0" max="100" value="<c:out value="${settingsMap['default_passing_percentage'].settingValue}"/>" 
                                   class="w-full bg-slate-900 border border-slate-700 rounded-xl px-3.5 py-2 text-xs text-white focus:outline-none focus:border-indigo-500 font-mono"/>
                            <span class="text-[11px] text-slate-400 mt-1 block">Academic threshold for Grade Pass (0.0 - 100.0%).</span>
                        </div>
                    </div>
                </div>

                <!-- Card 3: Security & Session Management -->
                <div class="glass-card rounded-2xl p-6 border-slate-800 space-y-4">
                    <div class="flex items-center gap-2.5 border-b border-slate-800 pb-3">
                        <span class="material-symbols-Outlined text-amber-400">shield_lock</span>
                        <div>
                            <h3 class="text-sm font-bold text-white">Security &amp; Session Management</h3>
                            <p class="text-xs text-slate-400">Access control pacing and user session lifecycle</p>
                        </div>
                    </div>

                    <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                        <div>
                            <label class="block text-xs font-semibold text-slate-300 mb-1">Max Login Attempts *</label>
                            <input type="number" name="max_login_attempts" required min="1" max="20" value="<c:out value="${settingsMap['max_login_attempts'].settingValue}"/>" 
                                   class="w-full bg-slate-900 border border-slate-700 rounded-xl px-3.5 py-2 text-xs text-white focus:outline-none focus:border-indigo-500 font-mono"/>
                            <span class="text-[11px] text-slate-400 mt-1 block">Failed authentication threshold (1-20 attempts).</span>
                        </div>

                        <div>
                            <label class="block text-xs font-semibold text-slate-300 mb-1">Session Inactivity Timeout (Minutes) *</label>
                            <input type="number" name="session_timeout" required min="5" max="480" value="<c:out value="${settingsMap['session_timeout'].settingValue}"/>" 
                                   class="w-full bg-slate-900 border border-slate-700 rounded-xl px-3.5 py-2 text-xs text-white focus:outline-none focus:border-indigo-500 font-mono"/>
                            <span class="text-[11px] text-slate-400 mt-1 block">HTTP session expiration pacing (5-480 min).</span>
                        </div>
                    </div>
                </div>

                <!-- Card 4: Platform Availability & Registration -->
                <div class="glass-card rounded-2xl p-6 border-slate-800 space-y-4">
                    <div class="flex items-center gap-2.5 border-b border-slate-800 pb-3">
                        <span class="material-symbols-Outlined text-emerald-400">toggle_on</span>
                        <div>
                            <h3 class="text-sm font-bold text-white">Application Lifecycle &amp; Availability</h3>
                            <p class="text-xs text-slate-400">Toggle public portal registration and maintenance flags</p>
                        </div>
                    </div>

                    <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                        <div class="p-4 rounded-xl bg-slate-900 border border-slate-700/80 flex items-center justify-between">
                            <div>
                                <span class="font-semibold text-xs text-white block">Maintenance Mode</span>
                                <span class="text-[11px] text-slate-400">When enabled, non-admin access displays maintenance notice.</span>
                            </div>
                            <select name="maintenance_mode" class="bg-slate-800 border border-slate-600 rounded-lg px-2.5 py-1.5 text-xs text-white">
                                <option value="false" <c:if test="${settingsMap['maintenance_mode'].settingValue == 'false'}">selected</c:if>>Disabled (Online)</option>
                                <option value="true" <c:if test="${settingsMap['maintenance_mode'].settingValue == 'true'}">selected</c:if>>Enabled (Maintenance)</option>
                            </select>
                        </div>

                        <div class="p-4 rounded-xl bg-slate-900 border border-slate-700/80 flex items-center justify-between">
                            <div>
                                <span class="font-semibold text-xs text-white block">Self-Registration</span>
                                <span class="text-[11px] text-slate-400">Allow candidate accounts to self-register via gateway.</span>
                            </div>
                            <select name="registration_enabled" class="bg-slate-800 border border-slate-600 rounded-lg px-2.5 py-1.5 text-xs text-white">
                                <option value="true" <c:if test="${settingsMap['registration_enabled'].settingValue == 'true'}">selected</c:if>>Open (Enabled)</option>
                                <option value="false" <c:if test="${settingsMap['registration_enabled'].settingValue == 'false'}">selected</c:if>>Closed (Admin Only)</option>
                            </select>
                        </div>
                    </div>
                </div>

                <div class="flex items-center justify-end gap-3 pt-2">
                    <a href="${pageContext.request.contextPath}/admin/dashboard" class="px-5 py-2.5 rounded-xl bg-slate-800 hover:bg-slate-700 text-slate-300 font-semibold text-xs transition-colors">
                        Cancel
                    </a>
                    <button type="submit" class="px-6 py-2.5 rounded-xl bg-indigo-600 hover:bg-indigo-500 text-white font-semibold text-xs transition-all shadow-lg shadow-indigo-600/30 flex items-center gap-2">
                        <span class="material-symbols-Outlined text-base">save</span>
                        <span>Save System Configuration</span>
                    </button>
                </div>
            </form>

        </main>
    </div>

</body>
</html>
