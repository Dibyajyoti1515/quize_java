<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<header class="fixed top-0 w-full z-50 bg-surface-container-lowest/90 backdrop-blur-xl shadow-[0_1px_8px_rgba(0,0,0,0.04)] border-b border-surface-container-high/60">
    <div class="h-16 w-full px-4 sm:px-6 lg:px-8 flex items-center justify-between">
        <!-- Logo & Brand Badge -->
        <div class="flex items-center gap-4 sm:gap-6">
            <a href="${pageContext.request.contextPath}/student/dashboard" class="flex items-center gap-2.5 text-decoration-none">
                <div class="w-8 h-8 rounded-lg bg-primary flex items-center justify-center shadow-sm">
                    <span class="material-symbols-outlined text-on-primary text-[20px]">verified_user</span>
                </div>
                <span class="font-headline-sm text-headline-sm font-bold text-on-surface">QuizTrack</span>
            </a>
            <div class="hidden md:flex items-center px-2.5 py-1 rounded-full bg-surface-container-low text-on-surface-variant font-label-sm text-label-sm uppercase tracking-wider font-semibold">
                <span>Candidate Secure Workspace</span>
            </div>
        </div>

        <!-- Desktop Navigation Links -->
        <nav class="hidden lg:flex items-center gap-6" data-active-classes="text-primary font-bold">
            <a href="${pageContext.request.contextPath}/student/dashboard" 
               class="font-title-md text-title-md transition-colors ${pageContext.request.servletPath == '/student/dashboard' ? 'text-primary font-bold border-b-2 border-primary py-4' : 'text-on-surface-variant hover:text-on-surface'}">
                Assigned Quizzes
            </a>
            <a href="${pageContext.request.contextPath}/student/quizzes" 
               class="font-title-md text-title-md transition-colors ${pageContext.request.servletPath == '/student/quizzes' ? 'text-primary font-bold border-b-2 border-primary py-4' : 'text-on-surface-variant hover:text-on-surface'}">
                Assessment Registry
            </a>
            <a href="${pageContext.request.contextPath}/student/results" 
               class="font-title-md text-title-md transition-colors ${pageContext.request.servletPath == '/student/results' ? 'text-primary font-bold border-b-2 border-primary py-4' : 'text-on-surface-variant hover:text-on-surface'}">
                Grade Reports
            </a>
            <a href="${pageContext.request.contextPath}/student/preflight" 
               class="font-title-md text-title-md transition-colors ${pageContext.request.servletPath == '/student/preflight' ? 'text-primary font-bold border-b-2 border-primary py-4' : 'text-on-surface-variant hover:text-on-surface'}">
                Diagnostic Preflight
            </a>
            <a href="${pageContext.request.contextPath}/student/leaderboard" 
               class="font-title-md text-title-md transition-colors ${pageContext.request.servletPath == '/student/leaderboard' ? 'text-primary font-bold border-b-2 border-primary py-4' : 'text-on-surface-variant hover:text-on-surface'}">
                Leaderboard
            </a>
        </nav>

        <!-- Right Side Telemetry & Candidate Profile -->
        <div class="flex items-center gap-3 sm:gap-4">
            <!-- Telemetry Indicator -->
            <div class="hidden sm:flex items-center gap-2 px-3 py-1.5 rounded-lg bg-surface-container text-on-surface font-code-telemetry text-code-telemetry">
                <span class="w-2 h-2 rounded-full bg-tertiary-container animate-pulse"></span>
                <span>Secure Link: 98.4%</span>
            </div>

            <!-- Notifications Icon -->
            <a href="${pageContext.request.contextPath}/student/notifications" 
               class="relative p-2 rounded-lg text-on-surface-variant hover:bg-surface-container-low hover:text-on-surface transition-colors"
               title="Notifications">
                <span class="material-symbols-outlined text-[22px]">notifications</span>
                <span class="absolute top-1.5 right-1.5 w-2 h-2 rounded-full bg-error ring-2 ring-surface-container-lowest"></span>
            </a>

            <div class="h-6 w-px bg-surface-container-high hidden sm:block"></div>

            <!-- Student Profile Badge -->
            <div class="flex items-center gap-2.5">
                <div class="hidden md:flex flex-col text-right">
                    <span class="font-title-md text-title-md text-on-surface font-semibold leading-tight">
                        <c:out value="${sessionScope.userFullName != null ? sessionScope.userFullName : 'Alex Mercer'}"/>
                    </span>
                    <span class="font-code-telemetry text-[11px] text-on-surface-variant">
                        <c:out value="${sessionScope.userIdentifier != null ? sessionScope.userIdentifier : 'CS-2022-041'}"/>
                    </span>
                </div>
                <div class="relative group cursor-pointer">
                    <div class="w-9 h-9 rounded-full bg-primary-container text-on-primary flex items-center justify-center font-title-md text-title-md shadow-sm font-bold">
                        <c:choose>
                            <c:when test="${not empty sessionScope.userFullName}">
                                <c:out value="${sessionScope.userFullName.substring(0, 1)}"/>
                            </c:when>
                            <c:otherwise>AM</c:otherwise>
                        </c:choose>
                    </div>
                    <span class="absolute bottom-0 right-0 w-2.5 h-2.5 rounded-full bg-tertiary-container ring-2 ring-surface-container-lowest"></span>
                    
                    <!-- Dropdown Menu on hover/focus -->
                    <div class="absolute right-0 top-full mt-2 w-56 bg-surface-container-lowest rounded-xl shadow-xl border border-surface-container-high p-2 hidden group-hover:block transition-all z-50">
                        <div class="px-3 py-2 border-b border-surface-container-high mb-1">
                            <p class="font-title-md text-title-md font-semibold text-on-surface"><c:out value="${sessionScope.userFullName}"/></p>
                            <p class="font-code-telemetry text-code-telemetry text-on-surface-variant"><c:out value="${sessionScope.userIdentifier}"/></p>
                            <span class="mt-1 inline-block px-2 py-0.5 rounded-full text-[10px] font-bold bg-primary-fixed text-on-primary-fixed-variant uppercase">
                                <c:out value="${sessionScope.userRole}"/>
                            </span>
                        </div>
                        <a href="${pageContext.request.contextPath}/student/profile" class="flex items-center gap-2.5 px-3 py-2 rounded-lg text-on-surface-variant hover:bg-surface-container-low hover:text-on-surface text-sm">
                            <span class="material-symbols-outlined text-[18px]">person</span>
                            <span>Candidate Profile</span>
                        </a>
                        <a href="${pageContext.request.contextPath}/student/preflight" class="flex items-center gap-2.5 px-3 py-2 rounded-lg text-on-surface-variant hover:bg-surface-container-low hover:text-on-surface text-sm">
                            <span class="material-symbols-outlined text-[18px]">sensors</span>
                            <span>Hardware Pre-Check</span>
                        </a>
                        <a href="${pageContext.request.contextPath}/student/settings" class="flex items-center gap-2.5 px-3 py-2 rounded-lg text-on-surface-variant hover:bg-surface-container-low hover:text-on-surface text-sm">
                            <span class="material-symbols-outlined text-[18px]">settings</span>
                            <span>Settings</span>
                        </a>
                        <div class="border-t border-surface-container-high my-1"></div>
                        <a href="${pageContext.request.contextPath}/auth/logout" class="flex items-center gap-2.5 px-3 py-2 rounded-lg text-error hover:bg-error-container/30 text-sm font-semibold">
                            <span class="material-symbols-outlined text-[18px]">logout</span>
                            <span>Sign Out Securely</span>
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</header>
