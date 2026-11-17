<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<aside class="fixed left-0 top-0 h-full w-64 bg-surface-container-lowest shadow-[0_1px_8px_rgba(0,0,0,0.04)] z-50 flex flex-col justify-between border-r border-surface-container-high/60">
    <div class="flex flex-col">
        <!-- Brand Header -->
        <div class="h-16 px-space-md flex items-center gap-space-sm border-b border-surface-container-high/40">
            <div class="w-9 h-9 rounded-lg bg-primary-container flex items-center justify-center text-on-primary shadow-sm">
                <span class="material-symbols-outlined text-[20px]">verified_user</span>
            </div>
            <div class="flex flex-col">
                <div class="flex items-center gap-1.5">
                    <span class="font-title-lg text-title-lg font-bold tracking-tight text-on-surface">QuizTrack</span>
                </div>
                <span class="font-label-sm text-label-sm uppercase tracking-wider text-on-surface-variant font-semibold">Student Portal</span>
            </div>
        </div>

        <!-- Semester Badge -->
        <div class="px-space-md py-space-sm">
            <div class="flex items-center gap-2 px-space-sm py-1.5 rounded-full bg-surface-container-low text-on-surface-variant font-label-md text-label-md">
                <span class="material-symbols-outlined text-[16px] text-primary">calendar_today</span>
                <span><c:out value="${dashboardData.semester != null ? dashboardData.semester : 'Spring 2025 Semester'}"/></span>
            </div>
        </div>

        <!-- Academic Space Nav Section -->
        <div class="px-space-md pt-space-xs">
            <p class="px-space-sm mb-1.5 font-label-sm text-label-sm uppercase tracking-wider text-outline font-semibold">Academic Space</p>
        </div>
        <nav class="flex flex-col gap-1 px-space-sm" data-active-classes="bg-primary-container text-on-primary font-title-md">
            <a class="flex items-center gap-3 px-space-md py-2.5 rounded-lg text-on-surface-variant hover:bg-surface-container-low hover:text-on-surface transition-all ${param.activeNav == 'overview' || pageContext.request.servletPath == '/student/dashboard' ? 'bg-primary-container text-on-primary font-title-md shadow-sm' : ''}" 
               href="${pageContext.request.contextPath}/student/dashboard">
                <span class="material-symbols-outlined text-[20px]">grid_view</span>
                <span class="font-title-md text-title-md">Overview</span>
            </a>
            <a class="flex items-center justify-between px-space-md py-2.5 rounded-lg transition-all ${param.activeNav == 'available-quizzes' || pageContext.request.servletPath == '/student/quizzes' ? 'bg-primary-container text-on-primary font-title-md shadow-sm' : 'text-on-surface-variant hover:bg-surface-container-low hover:text-on-surface'}" 
               href="${pageContext.request.contextPath}/student/quizzes">
                <div class="flex items-center gap-3">
                    <span class="material-symbols-outlined text-[20px]">assignment_late</span>
                    <span class="font-title-md text-title-md">Available Quizzes</span>
                </div>
                <span class="w-2 h-2 rounded-full bg-tertiary-container animate-pulse"></span>
            </a>
            <a class="flex items-center gap-3 px-space-md py-2.5 rounded-lg text-on-surface-variant hover:bg-surface-container-low hover:text-on-surface transition-all ${param.activeNav == 'upcoming-exams' || pageContext.request.servletPath == '/student/upcoming' ? 'bg-primary-container text-on-primary font-title-md shadow-sm' : ''}" 
               href="${pageContext.request.contextPath}/student/upcoming">
                <span class="material-symbols-outlined text-[20px]">event_upcoming</span>
                <span class="font-title-md text-title-md">Upcoming Exams</span>
            </a>
            <a class="flex items-center gap-3 px-space-md py-2.5 rounded-lg text-on-surface-variant hover:bg-surface-container-low hover:text-on-surface transition-all ${param.activeNav == 'my-results' || pageContext.request.servletPath == '/student/results' ? 'bg-primary-container text-on-primary font-title-md shadow-sm' : ''}" 
               href="${pageContext.request.contextPath}/student/results">
                <span class="material-symbols-outlined text-[20px]">fact_check</span>
                <span class="font-title-md text-title-md">My Results</span>
            </a>
            <a class="flex items-center gap-3 px-space-md py-2.5 rounded-lg text-on-surface-variant hover:bg-surface-container-low hover:text-on-surface transition-all ${param.activeNav == 'performance-analytics' || pageContext.request.servletPath == '/student/analytics' ? 'bg-primary-container text-on-primary font-title-md shadow-sm' : ''}" 
               href="${pageContext.request.contextPath}/student/analytics">
                <span class="material-symbols-outlined text-[20px]">analytics</span>
                <span class="font-title-md text-title-md">Performance Analytics</span>
            </a>
            <a class="flex items-center gap-3 px-space-md py-2.5 rounded-lg text-on-surface-variant hover:bg-surface-container-low hover:text-on-surface transition-all ${param.activeNav == 'leaderboard' || pageContext.request.servletPath == '/student/leaderboard' ? 'bg-primary-container text-on-primary font-title-md shadow-sm' : ''}" 
               href="${pageContext.request.contextPath}/student/leaderboard">
                <span class="material-symbols-outlined text-[20px]">military_tech</span>
                <span class="font-title-md text-title-md">Leaderboard</span>
            </a>
        </nav>

        <!-- Preferences Nav Section -->
        <div class="px-space-md pt-space-md">
            <p class="px-space-sm mb-1.5 font-label-sm text-label-sm uppercase tracking-wider text-outline font-semibold">Preferences</p>
        </div>
        <nav class="flex flex-col gap-1 px-space-sm" data-active-classes="bg-primary-container text-on-primary font-title-md">
            <a class="flex items-center justify-between px-space-md py-2.5 rounded-lg text-on-surface-variant hover:bg-surface-container-low hover:text-on-surface transition-all ${param.activeNav == 'notifications' || pageContext.request.servletPath == '/student/notifications' ? 'bg-primary-container text-on-primary font-title-md shadow-sm' : ''}" 
               href="${pageContext.request.contextPath}/student/notifications">
                <div class="flex items-center gap-3">
                    <span class="material-symbols-outlined text-[20px]">notifications</span>
                    <span class="font-title-md text-title-md">Notifications</span>
                </div>
                <span class="font-label-sm text-label-sm bg-error-container text-on-error-container font-semibold px-1.5 py-0.5 rounded-full">
                    <c:out value="${dashboardData.unreadNotifications != null ? dashboardData.unreadNotifications : 3}"/>
                </span>
            </a>
            <a class="flex items-center gap-3 px-space-md py-2.5 rounded-lg text-on-surface-variant hover:bg-surface-container-low hover:text-on-surface transition-all ${param.activeNav == 'settings' || pageContext.request.servletPath == '/student/settings' ? 'bg-primary-container text-on-primary font-title-md shadow-sm' : ''}" 
               href="${pageContext.request.contextPath}/student/settings">
                <span class="material-symbols-outlined text-[20px]">settings</span>
                <span class="font-title-md text-title-md">Settings</span>
            </a>
        </nav>
    </div>

    <!-- Integrity Node Telemetry Status Box -->
    <div class="p-space-md">
        <div class="p-space-sm rounded-xl bg-surface-container-low flex flex-col gap-2 border border-surface-container-high/60">
            <div class="flex items-center justify-between">
                <span class="font-label-sm text-label-sm font-semibold uppercase text-on-surface-variant">Integrity Node</span>
                <span class="flex h-2 w-2 rounded-full bg-tertiary-container animate-ping"></span>
            </div>
            <p class="font-code-telemetry text-code-telemetry text-on-surface-variant font-bold text-tertiary">V-LOCK: ENFORCED</p>
            <p class="font-label-sm text-label-sm text-outline">Secure browser sandbox online</p>
        </div>
    </div>
</aside>
