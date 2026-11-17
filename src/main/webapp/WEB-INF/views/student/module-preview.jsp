<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8"/>
    <meta content="width=device-width, initial-scale=1.0" name="viewport"/>
    <title><c:out value="${moduleTitle}"/> | QuizTrack Student</title>
    
    <link href="https://fonts.googleapis.com" rel="preconnect"/>
    <link crossorigin="" href="https://fonts.gstatic.com" rel="preconnect"/>
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
                        'surface-container': '#e5eeff',
                        'surface-container-high': '#dce9ff',
                        'on-surface': '#0b1c30',
                        'on-surface-variant': '#464555',
                        tertiary: '#005338',
                        'tertiary-container': '#006e4b'
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
<body class="bg-surface font-body text-on-surface antialiased">
    <!-- Include universal student header -->
    <jsp:include page="components/header.jsp"/>

    <main class="pt-24 px-4 md:px-8 max-w-4xl mx-auto py-8">
        <div class="bg-surface-container-lowest rounded-2xl p-8 border border-surface-container-high shadow-sm">
            <div class="flex items-center gap-4 mb-4">
                <div class="w-12 h-12 rounded-xl bg-primary-container text-on-primary flex items-center justify-center font-bold shadow-sm">
                    <span class="material-symbols-outlined text-[28px]"><c:out value="${moduleIcon != null ? moduleIcon : 'school'}"/></span>
                </div>
                <div>
                    <span class="text-xs font-mono font-bold uppercase text-primary tracking-wider">
                        Candidate Module • Scheduled for <c:out value="${targetPhase}"/>
                    </span>
                    <h1 class="text-2xl font-bold font-display text-on-surface"><c:out value="${moduleTitle}"/></h1>
                </div>
            </div>
            
            <p class="text-on-surface-variant text-sm mb-6 leading-relaxed">
                <c:out value="${moduleDescription}"/>
            </p>

            <div class="p-4 rounded-xl bg-surface-container-low border border-surface-container flex flex-col sm:flex-row items-center justify-between gap-4">
                <div class="flex items-center gap-2 text-xs text-on-surface font-medium">
                    <span class="w-2 h-2 rounded-full bg-tertiary-container animate-ping"></span>
                    <span>Route verified &amp; protected by Student Role Authorization Filter.</span>
                </div>
                <div class="flex items-center gap-3">
                    <a href="${pageContext.request.contextPath}/student/dashboard" class="px-4 py-2 rounded-lg bg-surface-container hover:bg-surface-container-high text-on-surface text-xs font-bold transition-all">
                        Student Dashboard
                    </a>
                    <a href="${pageContext.request.contextPath}/student/quizzes" class="px-4 py-2 rounded-lg bg-primary text-on-primary text-xs font-bold hover:opacity-90 transition-all">
                        Available Quizzes
                    </a>
                </div>
            </div>
        </div>
    </main>
</body>
</html>
