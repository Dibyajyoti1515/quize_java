<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title><c:out value="${pageTitle}"/> | QuizTrack Faculty</title>
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=JetBrains+Mono:wght@400;500&family=Plus+Jakarta+Sans:wght@600;700&display=swap" rel="stylesheet"/>
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
            'on-surface-variant': '#464555'
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
<body class="bg-surface font-body text-on-surface">
  <jsp:include page="/WEB-INF/views/teacher/components/sidebar.jsp"/>
  <div class="lg:pl-64">
    <jsp:include page="/WEB-INF/views/teacher/components/header.jsp"/>
    <main class="pt-20 px-4 md:px-8 max-w-6xl mx-auto py-8">
      <div class="bg-surface-container-lowest rounded-2xl p-8 border border-surface-container-high shadow-sm">
        <div class="flex items-center gap-3 mb-4">
          <div class="w-12 h-12 rounded-xl bg-surface-container text-primary flex items-center justify-center font-bold">
            <span class="material-symbols-outlined text-[28px]">construction</span>
          </div>
          <div>
            <span class="text-xs font-mono font-bold uppercase text-primary tracking-wider">Scheduled Roadmap Milestone</span>
            <h1 class="text-2xl font-bold font-display text-on-surface"><c:out value="${pageTitle}"/></h1>
          </div>
        </div>
        <p class="text-on-surface-variant text-sm mb-6"><c:out value="${pageNotice}"/></p>
        <div class="p-4 rounded-xl bg-surface-container-low border border-surface-container flex items-center justify-between">
          <span class="text-xs text-on-surface font-medium">This module will be rendered with full interactive controls in accordance with the Phase implementation order.</span>
          <a href="${pageContext.request.contextPath}/teacher/dashboard" class="px-4 py-2 rounded-lg bg-primary text-on-primary text-xs font-bold hover:opacity-90 transition-all">
            Return to Academic Overview
          </a>
        </div>
      </div>
    </main>
  </div>
</body>
</html>
