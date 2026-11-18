<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en" class="h-full bg-[#f8faff]">
<head>
    <meta charset="utf-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>System Configuration | QuizTrack Administration</title>
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
               class="flex items-center gap-3 px-3.5 py-2.5 rounded-xl font-semibold text-sm transition-all bg-indigo-600 text-white shadow-xs">
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
                <h1 class="font-display text-lg font-bold text-slate-900 tracking-tight">System Configuration &amp; Governance</h1>
                <span class="text-xs font-mono px-2.5 py-0.5 rounded-full bg-indigo-50 text-indigo-700 border border-indigo-200 font-semibold">system_settings</span>
            </div>

            <div class="flex items-center gap-3">
                <a href="${pageContext.request.contextPath}/admin/dashboard" class="px-3.5 py-1.5 rounded-xl border border-slate-200 bg-white hover:bg-slate-50 text-slate-700 text-xs font-semibold transition-colors flex items-center gap-1.5 shadow-2xs">
                    <span class="material-symbols-outlined text-sm">arrow_back</span>
                    <span>Back to Overview</span>
                </a>
            </div>
        </header>

        <!-- Main Form Container -->
        <main class="p-6 md:p-8 space-y-6 max-w-5xl mx-auto w-full">

            <!-- Flash Feedback Messages -->
            <c:if test="${not empty sessionScope.flashSuccess}">
                <div class="p-4 rounded-xl bg-emerald-50 border border-emerald-200 text-emerald-800 text-xs flex items-center gap-2 shadow-2xs">
                    <span class="material-symbols-outlined text-emerald-600 text-lg">check_circle</span>
                    <span><c:out value="${sessionScope.flashSuccess}"/></span>
                </div>
                <c:remove var="flashSuccess" scope="session"/>
            </c:if>

            <c:if test="${not empty sessionScope.flashError}">
                <div class="p-4 rounded-xl bg-rose-50 border border-rose-200 text-rose-800 text-xs flex items-center gap-2 shadow-2xs">
                    <span class="material-symbols-outlined text-rose-600 text-lg">error</span>
                    <span><c:out value="${sessionScope.flashError}"/></span>
                </div>
                <c:remove var="flashError" scope="session"/>
            </c:if>

            <form method="POST" action="${pageContext.request.contextPath}/admin/settings" class="space-y-6">
                <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}"/>

                <!-- Card 1: Institution & Branding -->
                <div class="bg-white rounded-2xl p-6 shadow-2xs border border-slate-200/90 space-y-4">
                    <div class="flex items-center gap-2.5 border-b border-slate-100 pb-3.5">
                        <span class="material-symbols-outlined text-indigo-600">apartment</span>
                        <div>
                            <h3 class="font-display text-sm font-bold text-slate-900">Institutional Identity &amp; University Branding</h3>
                            <p class="text-xs text-slate-500">Global headers, candidate portals, and examination report headings</p>
                        </div>
                    </div>

                    <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
                        <div>
                            <label class="block text-xs font-semibold text-slate-700 mb-1.5">Application Title *</label>
                            <input type="text" name="application_name" required value="<c:out value="${settingsMap['application_name'].settingValue}"/>" 
                                   class="w-full bg-slate-50 border border-slate-200 focus:bg-white focus:border-indigo-600 rounded-xl px-3.5 py-2 text-xs text-slate-800 focus:outline-none font-medium transition-colors"/>
                            <span class="text-[11px] text-slate-400 mt-1 block">Branding displayed on candidate tabs.</span>
                        </div>

                        <div>
                            <label class="block text-xs font-semibold text-slate-700 mb-1.5">Institution / University *</label>
                            <input type="text" name="institution_name" required value="<c:out value="${settingsMap['institution_name'].settingValue}"/>" 
                                   class="w-full bg-slate-50 border border-slate-200 focus:bg-white focus:border-indigo-600 rounded-xl px-3.5 py-2 text-xs text-slate-800 focus:outline-none font-medium transition-colors"/>
                            <span class="text-[11px] text-slate-400 mt-1 block">Printed on certified result transcripts.</span>
                        </div>

                        <div>
                            <label class="block text-xs font-semibold text-slate-700 mb-1.5">Support Desk Email *</label>
                            <input type="email" name="support_email" required value="<c:out value="${settingsMap['support_email'].settingValue}"/>" 
                                   class="w-full bg-slate-50 border border-slate-200 focus:bg-white focus:border-indigo-600 rounded-xl px-3.5 py-2 text-xs text-slate-800 focus:outline-none font-medium transition-colors"/>
                            <span class="text-[11px] text-slate-400 mt-1 block">Direct escalation endpoint for candidates.</span>
                        </div>
                    </div>
                </div>

                <!-- Card 2: Examination Engine Policies -->
                <div class="bg-white rounded-2xl p-6 shadow-2xs border border-slate-200/90 space-y-4">
                    <div class="flex items-center gap-2.5 border-b border-slate-100 pb-3.5">
                        <span class="material-symbols-outlined text-amber-500">timer</span>
                        <div>
                            <h3 class="font-display text-sm font-bold text-slate-900">Examination Engine Default Parameters</h3>
                            <p class="text-xs text-slate-500">Baseline constraints applied during faculty quiz authoring</p>
                        </div>
                    </div>

                    <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
                        <div>
                            <label class="block text-xs font-semibold text-slate-700 mb-1.5">Default Duration (Minutes) *</label>
                            <input type="number" name="default_duration" required min="5" max="360" value="<c:out value="${settingsMap['default_duration'].settingValue}"/>" 
                                   class="w-full bg-slate-50 border border-slate-200 focus:bg-white focus:border-indigo-600 rounded-xl px-3.5 py-2 text-xs text-slate-800 focus:outline-none font-mono"/>
                            <span class="text-[11px] text-slate-400 mt-1 block">Standard quiz window length (5-360 min).</span>
                        </div>

                        <div>
                            <label class="block text-xs font-semibold text-slate-700 mb-1.5">Max Permitted Duration (Minutes) *</label>
                            <input type="number" name="max_quiz_duration" required min="30" max="720" value="<c:out value="${settingsMap['max_quiz_duration'].settingValue}"/>" 
                                   class="w-full bg-slate-50 border border-slate-200 focus:bg-white focus:border-indigo-600 rounded-xl px-3.5 py-2 text-xs text-slate-800 focus:outline-none font-mono"/>
                            <span class="text-[11px] text-slate-400 mt-1 block">Upper hard-cap for extended practicals.</span>
                        </div>

                        <div>
                            <label class="block text-xs font-semibold text-slate-700 mb-1.5">Default Passing Benchmark (%) *</label>
                            <input type="number" name="default_pass_percentage" required min="1" max="100" value="<c:out value="${settingsMap['default_pass_percentage'].settingValue}"/>" 
                                   class="w-full bg-slate-50 border border-slate-200 focus:bg-white focus:border-indigo-600 rounded-xl px-3.5 py-2 text-xs text-slate-800 focus:outline-none font-mono"/>
                            <span class="text-[11px] text-slate-400 mt-1 block">Passing grade threshold (1-100%).</span>
                        </div>
                    </div>
                </div>

                <!-- Card 3: Security & Session Rules -->
                <div class="bg-white rounded-2xl p-6 shadow-2xs border border-slate-200/90 space-y-4">
                    <div class="flex items-center gap-2.5 border-b border-slate-100 pb-3.5">
                        <span class="material-symbols-outlined text-rose-500">security</span>
                        <div>
                            <h3 class="font-display text-sm font-bold text-slate-900">Security &amp; Anti-Cheat Governance Thresholds</h3>
                            <p class="text-xs text-slate-500">Automated lockouts, authentication limits, and exam timeouts</p>
                        </div>
                    </div>

                    <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
                        <div>
                            <label class="block text-xs font-semibold text-slate-700 mb-1.5">Max Tab Switches (Strikes) *</label>
                            <input type="number" name="max_tab_switches" required min="0" max="10" value="<c:out value="${settingsMap['max_tab_switches'].settingValue}"/>" 
                                   class="w-full bg-slate-50 border border-slate-200 focus:bg-white focus:border-indigo-600 rounded-xl px-3.5 py-2 text-xs text-slate-800 focus:outline-none font-mono"/>
                            <span class="text-[11px] text-slate-400 mt-1 block">Blur violation limit before exam lockout (0-10).</span>
                        </div>

                        <div>
                            <label class="block text-xs font-semibold text-slate-700 mb-1.5">Max Failed Login Attempts *</label>
                            <input type="number" name="max_login_attempts" required min="1" max="20" value="<c:out value="${settingsMap['max_login_attempts'].settingValue}"/>" 
                                   class="w-full bg-slate-50 border border-slate-200 focus:bg-white focus:border-indigo-600 rounded-xl px-3.5 py-2 text-xs text-slate-800 focus:outline-none font-mono"/>
                            <span class="text-[11px] text-slate-400 mt-1 block">Failed authentication threshold (1-20 attempts).</span>
                        </div>

                        <div>
                            <label class="block text-xs font-semibold text-slate-700 mb-1.5">Session Inactivity Timeout (Minutes) *</label>
                            <input type="number" name="session_timeout" required min="5" max="480" value="<c:out value="${settingsMap['session_timeout'].settingValue}"/>" 
                                   class="w-full bg-slate-50 border border-slate-200 focus:bg-white focus:border-indigo-600 rounded-xl px-3.5 py-2 text-xs text-slate-800 focus:outline-none font-mono"/>
                            <span class="text-[11px] text-slate-400 mt-1 block">HTTP session expiration pacing (5-480 min).</span>
                        </div>
                    </div>
                </div>

                <!-- Card 4: Platform Availability & Registration -->
                <div class="bg-white rounded-2xl p-6 shadow-2xs border border-slate-200/90 space-y-4">
                    <div class="flex items-center gap-2.5 border-b border-slate-100 pb-3.5">
                        <span class="material-symbols-outlined text-emerald-600">toggle_on</span>
                        <div>
                            <h3 class="font-display text-sm font-bold text-slate-900">Application Lifecycle &amp; Availability</h3>
                            <p class="text-xs text-slate-500">Toggle public portal registration and maintenance flags</p>
                        </div>
                    </div>

                    <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                        <div class="p-4 rounded-xl bg-slate-50 border border-slate-200/80 flex items-center justify-between">
                            <div>
                                <span class="font-semibold text-xs text-slate-800 block">Maintenance Mode</span>
                                <span class="text-[11px] text-slate-500">When enabled, non-admin access displays maintenance notice.</span>
                            </div>
                            <select name="maintenance_mode" class="bg-white border border-slate-300 rounded-lg px-3 py-1.5 text-xs text-slate-800 font-medium">
                                <option value="false" <c:if test="${settingsMap['maintenance_mode'].settingValue == 'false'}">selected</c:if>>Disabled (Online)</option>
                                <option value="true" <c:if test="${settingsMap['maintenance_mode'].settingValue == 'true'}">selected</c:if>>Enabled (Maintenance)</option>
                            </select>
                        </div>

                        <div class="p-4 rounded-xl bg-slate-50 border border-slate-200/80 flex items-center justify-between">
                            <div>
                                <span class="font-semibold text-xs text-slate-800 block">Self-Registration</span>
                                <span class="text-[11px] text-slate-500">Allow candidate accounts to self-register via gateway.</span>
                            </div>
                            <select name="registration_enabled" class="bg-white border border-slate-300 rounded-lg px-3 py-1.5 text-xs text-slate-800 font-medium">
                                <option value="true" <c:if test="${settingsMap['registration_enabled'].settingValue == 'true'}">selected</c:if>>Open (Enabled)</option>
                                <option value="false" <c:if test="${settingsMap['registration_enabled'].settingValue == 'false'}">selected</c:if>>Closed (Admin Only)</option>
                            </select>
                        </div>
                    </div>
                </div>

                <div class="flex items-center justify-end gap-3 pt-2">
                    <a href="${pageContext.request.contextPath}/admin/dashboard" class="px-5 py-2.5 rounded-xl border border-slate-200 bg-white hover:bg-slate-50 text-slate-700 font-semibold text-xs transition-colors">
                        Cancel
                    </a>
                    <button type="submit" class="px-6 py-2.5 rounded-xl bg-indigo-600 hover:bg-indigo-700 text-white font-semibold text-xs transition-all shadow-sm hover:shadow flex items-center gap-2 cursor-pointer active:scale-95">
                        <span class="material-symbols-outlined text-base">save</span>
                        <span>Save System Configuration</span>
                    </button>
                </div>
            </form>

        </main>
    </div>

</body>
</html>
