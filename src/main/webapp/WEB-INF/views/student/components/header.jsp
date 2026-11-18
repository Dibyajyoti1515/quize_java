<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!-- Top App Header aligned with Left Sidebar -->
<header class="fixed top-0 left-0 lg:left-64 right-0 h-16 bg-surface-container-lowest/90 backdrop-blur-xl shadow-[0_1px_8px_rgba(0,0,0,0.04)] z-40 flex items-center justify-between px-4 sm:px-space-lg border-b border-surface-container-high/60">
    <div class="flex items-center gap-space-md">
        <div class="flex items-center gap-2 px-space-sm py-1 rounded-full bg-surface-container-low text-tertiary font-label-md text-label-md">
            <span class="w-2 h-2 rounded-full bg-tertiary-container animate-pulse"></span>
            <span class="font-semibold">System Healthy &amp; Verified</span>
        </div>
    </div>
    <div class="flex items-center gap-space-md">
        <!-- Notifications Bell -->
        <a href="${pageContext.request.contextPath}/student/notifications" class="relative p-2 rounded-lg text-on-surface-variant hover:bg-surface-container-low hover:text-on-surface transition-colors" title="Notifications">
            <span class="material-symbols-outlined text-[22px]">notifications</span>
            <span class="absolute top-2 right-2 w-2 h-2 rounded-full bg-error ring-2 ring-surface-container-lowest"></span>
        </a>
        
        <div class="h-6 w-px bg-surface-container-high"></div>
        
        <!-- Candidate Identity & Profile Badge -->
        <div class="flex items-center gap-3 pl-1">
            <div class="flex flex-col text-right">
                <span class="font-title-md text-title-md text-on-surface leading-tight font-semibold">
                    <c:out value="${sessionScope.userFullName != null ? sessionScope.userFullName : 'Alex Mercer'}"/>
                </span>
                <span class="font-code-telemetry text-code-telemetry text-on-surface-variant">
                    <c:out value="${sessionScope.userIdentifier != null ? sessionScope.userIdentifier : 'CS-2022-041'}"/>
                </span>
            </div>
            <div class="w-8 h-8 rounded-full bg-primary flex items-center justify-center shadow-sm text-on-primary font-bold text-xs">
                <c:choose>
                    <c:when test="${not empty sessionScope.userFullName}">
                        <c:out value="${sessionScope.userFullName.substring(0, 1)}"/>
                    </c:when>
                    <c:otherwise>AM</c:otherwise>
                </c:choose>
            </div>
            <a href="${pageContext.request.contextPath}/auth/logout" class="p-1.5 rounded-lg text-on-surface-variant hover:text-error hover:bg-error-container/20 transition-colors ml-1" title="Sign Out">
                <span class="material-symbols-outlined text-[20px]">logout</span>
            </a>
        </div>
    </div>
</header>
