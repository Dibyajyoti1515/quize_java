<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>403 - Access Forbidden | QuizTrack Security</title>
    <link rel="preconnect" href="https://fonts.googleapis.com"/>
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin=""/>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=JetBrains+Mono:wght@500&family=Plus+Jakarta+Sans:wght@600;700;800&display=swap" rel="stylesheet"/>
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200" rel="stylesheet"/>
    <script src="https://cdn.tailwindcss.com"></script>
    <script>
        tailwind.config = {
            theme: {
                extend: {
                    colors: {
                        primary: '#3525cd',
                        'primary-container': '#4f46e5',
                        'on-primary': '#ffffff',
                        surface: '#f8f9ff',
                        'surface-container-lowest': '#ffffff',
                        'surface-container-low': '#eff4ff',
                        'surface-container-high': '#dce9ff',
                        'on-surface': '#0b1c30',
                        'on-surface-variant': '#464555',
                        error: '#ba1a1a',
                        'error-container': '#ffdad6',
                        'on-error-container': '#93000a'
                    },
                    fontFamily: {
                        display: ['Plus Jakarta Sans', 'sans-serif'],
                        body: ['Inter', 'sans-serif'],
                        mono: ['JetBrains Mono', 'monospace']
                    }
                }
            }
        };
    </script>
</head>
<body class="bg-surface font-body text-on-surface min-h-screen flex items-center justify-center p-4">
    <div class="w-full max-w-lg bg-surface-container-lowest rounded-2xl shadow-xl border border-surface-container-high p-8 flex flex-col items-center text-center">
        <!-- Shield Icon -->
        <div class="w-16 h-16 rounded-2xl bg-error-container text-on-error-container flex items-center justify-center mb-6 shadow-inner">
            <span class="material-symbols-outlined text-[36px]">security</span>
        </div>

        <span class="px-3 py-1 rounded-full bg-error-container text-on-error-container font-mono text-xs font-bold uppercase tracking-wider mb-3">
            HTTP 403 Forbidden • Access Restricted
        </span>

        <h1 class="font-display text-2xl font-bold text-on-surface mb-2">
            Privileged Area Violation
        </h1>

        <p class="text-sm text-on-surface-variant max-w-md mb-6 leading-relaxed">
            Your authenticated role does not have authorization to view or execute actions on this resource.
        </p>

        <!-- Security Dossier Box -->
        <div class="w-full bg-surface-container-low rounded-xl p-4 text-left font-mono text-xs mb-6 border border-surface-container-high space-y-2">
            <div class="flex justify-between">
                <span class="text-on-surface-variant">Attempted Path:</span>
                <span class="font-bold text-on-surface"><c:out value="${deniedPath}"/></span>
            </div>
            <div class="flex justify-between">
                <span class="text-on-surface-variant">Your Active Role:</span>
                <span class="font-bold text-error"><c:out value="${userRole}"/></span>
            </div>
            <div class="flex justify-between">
                <span class="text-on-surface-variant">Required Privilege:</span>
                <span class="font-bold text-primary"><c:out value="${requiredRole}"/></span>
            </div>
            <div class="flex justify-between">
                <span class="text-on-surface-variant">Audit Action:</span>
                <span class="text-on-surface">Incident Logged to Security Register</span>
            </div>
        </div>

        <!-- Action CTAs -->
        <div class="flex flex-col sm:flex-row gap-3 w-full">
            <c:choose>
                <c:when test="${userRole == 'ADMIN'}">
                    <a href="${pageContext.request.contextPath}/admin/dashboard" class="flex-1 py-3 px-4 rounded-xl bg-primary-container text-on-primary font-semibold text-sm hover:opacity-90 transition-all text-center">
                        Return to Admin Portal
                    </a>
                </c:when>
                <c:when test="${userRole == 'TEACHER'}">
                    <a href="${pageContext.request.contextPath}/teacher/dashboard" class="flex-1 py-3 px-4 rounded-xl bg-primary-container text-on-primary font-semibold text-sm hover:opacity-90 transition-all text-center">
                        Return to Faculty Portal
                    </a>
                </c:when>
                <c:otherwise>
                    <a href="${pageContext.request.contextPath}/student/dashboard" class="flex-1 py-3 px-4 rounded-xl bg-primary-container text-on-primary font-semibold text-sm hover:opacity-90 transition-all text-center">
                        Return to Student Portal
                    </a>
                </c:otherwise>
            </c:choose>

            <a href="${pageContext.request.contextPath}/auth/logout" class="py-3 px-4 rounded-xl bg-surface-container-low text-on-surface font-semibold text-sm hover:bg-surface-container-high transition-all text-center">
                Sign Out
            </a>
        </div>
    </div>
</body>
</html>
