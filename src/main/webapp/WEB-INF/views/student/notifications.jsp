<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8"/>
    <meta content="width=device-width, initial-scale=1.0" name="viewport"/>
    <title>Academic Notifications &amp; Alerts | QuizTrack</title>

    <link href="https://fonts.googleapis.com" rel="preconnect"/>
    <link crossorigin="" href="https://fonts.gstatic.com" rel="preconnect"/>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=JetBrains+Mono:wght@400;500;600&family=Plus+Jakarta+Sans:wght@600;700;800&display=swap" rel="stylesheet"/>
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200" rel="stylesheet"/>
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet"/>

    <style>
        @layer base {
            html, body { margin: 0; padding: 0; }
            body { overscroll-behavior: none; }
            main > :first-child { margin-top: 0 !important; }
            main > :last-child { margin-bottom: 0 !important; }
        }
        ::-webkit-scrollbar { display: none; }
    </style>

    <script src="https://cdn.tailwindcss.com"></script>
    <script id="tailwind-config">
        tailwind.config = {
            darkMode: "class",
            theme: {
                extend: {
                    colors: {
                        "primary": "#3525cd",
                        "primary-container": "#4f46e5",
                        "on-primary": "#ffffff",
                        "primary-fixed": "#e2dfff",
                        "primary-fixed-dim": "#c3c0ff",
                        "on-primary-fixed-variant": "#3323cc",
                        "secondary": "#4648d4",
                        "secondary-container": "#6063ee",
                        "on-secondary": "#ffffff",
                        "tertiary": "#005338",
                        "tertiary-container": "#006e4b",
                        "tertiary-fixed": "#6ffbbe",
                        "tertiary-fixed-dim": "#4edea3",
                        "on-tertiary-container": "#67f4b7",
                        "error": "#ba1a1a",
                        "error-container": "#ffdad6",
                        "on-error-container": "#93000a",
                        "surface": "#f8f9ff",
                        "background": "#f8f9ff",
                        "on-surface": "#0b1c30",
                        "on-surface-variant": "#464555",
                        "outline": "#777587",
                        "outline-variant": "#c7c4d8",
                        "surface-container-lowest": "#ffffff",
                        "surface-container-low": "#eff4ff",
                        "surface-container": "#e5eeff",
                        "surface-container-high": "#dce9ff",
                        "surface-container-highest": "#d3e4fe",
                        "inverse-surface": "#213145",
                        "inverse-on-surface": "#eaf1ff"
                    },
                    borderRadius: {
                        "DEFAULT": "0.25rem",
                        "lg": "0.5rem",
                        "xl": "0.75rem",
                        "2xl": "1rem",
                        "full": "9999px"
                    },
                    spacing: {
                        "gutter": "1.5rem",
                        "gutter-sm": "1rem",
                        "space-xs": "0.25rem",
                        "space-sm": "0.5rem",
                        "space-md": "1rem",
                        "space-lg": "1.5rem",
                        "space-xl": "2rem"
                    },
                    fontFamily: {
                        "body-sm": ["Inter"],
                        "body-md": ["Inter"],
                        "body-lg": ["Inter"],
                        "title-md": ["Inter"],
                        "title-lg": ["Plus Jakarta Sans"],
                        "headline-sm": ["Plus Jakarta Sans"],
                        "headline-md": ["Plus Jakarta Sans"],
                        "headline-lg": ["Plus Jakarta Sans"],
                        "display": ["Plus Jakarta Sans"],
                        "code-telemetry": ["JetBrains Mono"]
                    }
                }
            }
        };
    </script>
</head>
<body class="bg-surface font-body-md text-body-md text-on-surface antialiased min-h-screen">

    <!-- Unified Student Sidebar Component -->
    <jsp:include page="components/sidebar.jsp">
        <jsp:param name="activeNav" value="notifications"/>
    </jsp:include>

    <!-- Main Content Area offset by Sidebar (lg:pl-64) -->
    <div class="lg:pl-64">
        <!-- Reusable Student Header -->
        <jsp:include page="components/header.jsp"/>

        <main class="w-full pt-16 bg-surface min-h-screen px-4 sm:px-space-lg py-space-lg">
            <div class="flex flex-col gap-space-lg w-full max-w-[1200px] mx-auto">

                <!-- Header Breadcrumb & Command Bar -->
                <div class="flex flex-col md:flex-row md:items-center justify-between gap-4 bg-surface-container-lowest p-6 rounded-2xl shadow-sm border border-surface-container-high">
                    <div>
                        <div class="flex items-center gap-2 text-xs font-mono font-semibold text-primary uppercase">
                            <span>Academic Communications</span>
                            <span>•</span>
                            <span>Institutional Feed</span>
                        </div>
                        <h1 class="text-2xl sm:text-3xl font-display font-bold text-on-surface mt-1">
                            Academic Notifications &amp; Alerts
                        </h1>
                        <p class="text-xs text-on-surface-variant mt-1">
                            Official exam publications, proctor clearances, and candidate admission notices.
                        </p>
                    </div>

                    <div class="flex items-center gap-3">
                        <c:if test="${unreadCount > 0}">
                            <a href="${pageContext.request.contextPath}/student/notifications?action=markAllRead" class="flex items-center gap-2 px-4 py-2 rounded-xl bg-surface-container hover:bg-surface-container-high text-on-surface text-xs font-semibold border border-surface-container-high transition-all">
                                <span class="material-symbols-outlined text-[16px] text-primary">done_all</span>
                                <span>Mark All as Read</span>
                            </a>
                        </c:if>
                    </div>
                </div>

                <!-- Notifications Feed List -->
                <div class="flex flex-col gap-3">
                    <c:choose>
                        <c:when test="${not empty notifications}">
                            <c:forEach var="n" items="${notifications}">
                                <div class="bg-surface-container-lowest rounded-2xl p-5 shadow-sm border ${n.read ? 'border-surface-container-high' : 'border-2 border-primary/40 bg-surface-container-low/40'} flex flex-col sm:flex-row items-start justify-between gap-4 transition-all">
                                    <div class="flex items-start gap-4 flex-1">
                                        <!-- Icon Type Badge -->
                                        <div class="w-10 h-10 rounded-xl flex items-center justify-center shrink-0 shadow-sm
                                            <c:choose>
                                                <c:when test="${n.type == 'EXAM'}">bg-primary text-on-primary</c:when>
                                                <c:when test="${n.type == 'ALERT'}">bg-error text-white</c:when>
                                                <c:when test="${n.type == 'WARNING'}">bg-amber-500 text-white</c:when>
                                                <c:otherwise>bg-tertiary text-white</c:otherwise>
                                            </c:choose>">
                                            <span class="material-symbols-outlined text-[20px]">
                                                <c:choose>
                                                    <c:when test="${n.type == 'EXAM'}">quiz</c:when>
                                                    <c:when test="${n.type == 'ALERT'}">crisis_alert</c:when>
                                                    <c:when test="${n.type == 'WARNING'}">warning</c:when>
                                                    <c:otherwise>info</c:otherwise>
                                                </c:choose>
                                            </span>
                                        </div>

                                        <div class="flex flex-col gap-1">
                                            <div class="flex items-center gap-2 flex-wrap">
                                                <h3 class="font-display font-bold text-sm text-on-surface">
                                                    <c:out value="${n.title}"/>
                                                </h3>
                                                <c:if test="${!n.read}">
                                                    <span class="px-2 py-0.5 rounded-full bg-primary-container text-on-primary font-mono text-[10px] font-bold uppercase tracking-wider">New</span>
                                                </c:if>
                                            </div>
                                            <p class="text-xs text-on-surface-variant leading-relaxed">
                                                <c:out value="${n.message}"/>
                                            </p>
                                            <span class="font-mono text-[11px] text-outline mt-1">
                                                <fmt:formatDate value="${n.createdAt}" pattern="MMM dd, yyyy • HH:mm z"/>
                                            </span>
                                        </div>
                                    </div>

                                    <div class="shrink-0 sm:self-center">
                                        <c:choose>
                                            <c:when test="${!n.read}">
                                                <a href="${pageContext.request.contextPath}/student/notifications?action=markRead&id=${n.notificationId}" class="inline-flex items-center gap-1 px-3 py-1.5 rounded-lg bg-surface-container hover:bg-surface-container-high text-primary font-semibold text-xs transition-all">
                                                    <span class="material-symbols-outlined text-[14px]">check</span>
                                                    <span>Mark Read</span>
                                                </a>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="text-[11px] text-outline font-medium flex items-center gap-1">
                                                    <span class="material-symbols-outlined text-[14px] text-tertiary">done</span>
                                                    <span>Read</span>
                                                </span>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <div class="p-12 rounded-2xl bg-surface-container-lowest border border-surface-container-high text-center">
                                <span class="material-symbols-outlined text-[48px] text-outline">notifications_off</span>
                                <h3 class="font-display font-bold text-lg text-on-surface mt-2">All Caught Up!</h3>
                                <p class="text-xs text-on-surface-variant mt-1">You have no active alerts or notifications at this time.</p>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>

            </div>
        </main>
    </div>

</body>
</html>
