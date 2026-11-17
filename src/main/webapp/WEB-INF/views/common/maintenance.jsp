<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>503 - System Maintenance | QuizTrack</title>
    <link rel="preconnect" href="https://fonts.googleapis.com"/>
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin=""/>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=JetBrains+Mono:wght@500&family=Plus+Jakarta+Sans:wght@600;700;800&display=swap" rel="stylesheet"/>
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200" rel="stylesheet"/>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-slate-950 text-slate-100 font-sans min-h-screen flex items-center justify-center p-4">
    <div class="w-full max-w-lg bg-slate-900 border border-slate-800 rounded-3xl shadow-2xl p-8 flex flex-col items-center text-center">
        <!-- Maintenance Icon -->
        <div class="w-16 h-16 rounded-2xl bg-amber-500/15 border border-amber-500/30 text-amber-400 flex items-center justify-center mb-6 shadow-inner">
            <span class="material-symbols-Outlined text-[36px]">construction</span>
        </div>

        <span class="px-3 py-1 rounded-full bg-amber-500/10 text-amber-300 font-mono text-xs font-bold uppercase tracking-wider mb-3 border border-amber-500/20">
            HTTP 503 • Scheduled Maintenance
        </span>

        <h1 class="text-2xl font-extrabold text-white mb-2">QuizTrack Under Maintenance</h1>
        <p class="text-slate-400 text-sm mb-6 max-w-sm">
            <c:out value="${maintenanceNotice != null ? maintenanceNotice : 'Institutional systems are currently undergoing scheduled maintenance and upgrades. Candidate and faculty access will resume shortly.'}"/>
        </p>

        <div class="p-4 rounded-xl bg-slate-950/60 border border-slate-800/80 w-full mb-6 text-left space-y-2 text-xs font-mono">
            <div class="flex justify-between text-slate-400">
                <span>System Status:</span>
                <span class="text-amber-400 font-bold">MAINTENANCE_ACTIVE</span>
            </div>
            <div class="flex justify-between text-slate-400">
                <span>Administrator Override:</span>
                <span class="text-emerald-400 font-bold">ENABLED</span>
            </div>
        </div>

        <div class="flex items-center gap-3 w-full">
            <a href="${pageContext.request.contextPath}/auth/login" class="flex-1 py-2.5 rounded-xl bg-indigo-600 hover:bg-indigo-500 text-white font-semibold text-xs transition-all shadow-lg shadow-indigo-600/30 text-center">
                Administrator Sign In
            </a>
            <a href="javascript:location.reload()" class="flex-1 py-2.5 rounded-xl bg-slate-800 hover:bg-slate-700 text-slate-300 font-semibold text-xs transition-colors text-center border border-slate-700">
                Check Again
            </a>
        </div>
    </div>
</body>
</html>
