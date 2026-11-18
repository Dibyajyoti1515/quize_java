<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%
  String currentUri = request.getRequestURI();
  request.setAttribute("reqUri", currentUri);
%>
<!-- Sidebar Overlay for Mobile -->
<div id="mobile-sidebar-backdrop" onclick="toggleSidebar()" class="fixed inset-0 z-40 bg-slate-900/60 backdrop-blur-sm lg:hidden hidden transition-opacity"></div>

<aside id="teacher-sidebar" class="fixed left-0 top-0 h-full w-64 bg-surface-container-lowest shadow-[0_1px_8px_rgba(0,0,0,0.04)] z-50 flex flex-col justify-between -translate-x-full lg:translate-x-0 transition-transform duration-200 ease-in-out border-r border-surface-container-high">
  <div class="flex flex-col">
    <!-- Brand Title Bar -->
    <div class="h-16 px-6 flex items-center justify-between border-b border-surface-container">
      <a href="${pageContext.request.contextPath}/teacher/dashboard" class="flex items-center gap-3">
        <div class="w-8 h-8 rounded-lg bg-primary flex items-center justify-center text-on-primary shadow-sm">
          <span class="material-symbols-outlined text-[20px]">verified_user</span>
        </div>
        <div class="flex flex-col">
          <span class="font-display font-bold text-lg text-on-surface leading-none">QuizTrack</span>
          <span class="font-code-telemetry text-[10px] text-on-surface-variant uppercase font-semibold">Faculty Console</span>
        </div>
      </a>
      <button type="button" onclick="toggleSidebar()" class="lg:hidden p-1 text-on-surface-variant hover:text-on-surface rounded-lg">
        <span class="material-symbols-outlined text-[20px]">close</span>
      </button>
    </div>

    <!-- Navigation Link Group -->
    <nav class="flex flex-col gap-1 px-3 mt-4">
      <span class="px-3 pb-1 text-[11px] font-mono font-bold uppercase tracking-wider text-outline">Academic Hub</span>

      <!-- Dashboard Home -->
      <a href="${pageContext.request.contextPath}/teacher/dashboard" 
         class="flex items-center gap-3 px-3 py-2.5 rounded-xl font-label-md text-sm transition-all ${reqUri.endsWith('/dashboard') ? 'bg-primary-container text-on-primary font-bold shadow-sm' : 'text-on-surface-variant hover:bg-surface-container hover:text-on-surface'}">
        <span class="material-symbols-outlined text-[20px]">dashboard</span>
        <span>Academic Overview</span>
      </a>

      <!-- Live Proctoring Matrix -->
      <a href="${pageContext.request.contextPath}/teacher/proctoring" 
         class="flex items-center justify-between px-3 py-2.5 rounded-xl font-label-md text-sm transition-all ${reqUri.contains('/proctoring') ? 'bg-primary-container text-on-primary font-bold shadow-sm' : 'text-on-surface-variant hover:bg-surface-container hover:text-on-surface'}">
        <div class="flex items-center gap-3">
          <span class="material-symbols-outlined text-[20px] text-error">grid_view</span>
          <span>Live Proctoring</span>
        </div>
        <span class="w-2 h-2 rounded-full bg-error animate-ping"></span>
      </a>

      <!-- Create Quiz -->
      <a href="${pageContext.request.contextPath}/teacher/quiz/create" 
         class="flex items-center gap-3 px-3 py-2.5 rounded-xl font-label-md text-sm transition-all ${reqUri.contains('/quiz/create') ? 'bg-primary-container text-on-primary font-bold shadow-sm' : 'text-on-surface-variant hover:bg-surface-container hover:text-on-surface'}">
        <span class="material-symbols-outlined text-[20px]">add_circle</span>
        <span>Create Quiz</span>
      </a>

      <!-- Quiz Console -->
      <a href="${pageContext.request.contextPath}/teacher/quizzes" 
         class="flex items-center gap-3 px-3 py-2.5 rounded-xl font-label-md text-sm transition-all ${reqUri.contains('/quizzes') || reqUri.contains('/quiz/builder') ? 'bg-primary-container text-on-primary font-bold shadow-sm' : 'text-on-surface-variant hover:bg-surface-container hover:text-on-surface'}">
        <span class="material-symbols-outlined text-[20px]">quiz</span>
        <span>Quiz Console</span>
      </a>

      <!-- Question Bank -->
      <a href="${pageContext.request.contextPath}/teacher/question-bank" 
         class="flex items-center gap-3 px-3 py-2.5 rounded-xl font-label-md text-sm transition-all ${reqUri.contains('/question-bank') ? 'bg-primary-container text-on-primary font-bold shadow-sm' : 'text-on-surface-variant hover:bg-surface-container hover:text-on-surface'}">
        <span class="material-symbols-outlined text-[20px]">inventory_2</span>
        <span>Question Bank</span>
      </a>

      <!-- Performance Reports -->
      <a href="${pageContext.request.contextPath}/teacher/reports" 
         class="flex items-center gap-3 px-3 py-2.5 rounded-xl font-label-md text-sm transition-all ${reqUri.contains('/reports') ? 'bg-primary-container text-on-primary font-bold shadow-sm' : 'text-on-surface-variant hover:bg-surface-container hover:text-on-surface'}">
        <span class="material-symbols-outlined text-[20px]">assessment</span>
        <span>Performance Reports</span>
      </a>
    </nav>
  </div>

  <!-- Bottom Workspace Switcher / Logout Link -->
  <div class="p-4 border-t border-surface-container flex flex-col gap-2">
    <div class="px-3 py-2 rounded-xl bg-surface-container-low flex items-center justify-between">
      <div class="flex items-center gap-2">
        <span class="w-2 h-2 rounded-full bg-emerald-500"></span>
        <span class="text-xs font-mono font-bold text-on-surface">FACULTY SESSION</span>
      </div>
      <span class="text-[10px] font-mono text-outline">SECURE</span>
    </div>
    <a href="${pageContext.request.contextPath}/auth/logout" class="flex items-center gap-2 px-3 py-2 rounded-lg text-xs font-semibold text-error hover:bg-error-container/30 transition-all">
      <span class="material-symbols-outlined text-[16px]">logout</span>
      <span>Sign Out of Faculty Hub</span>
    </a>
  </div>
</aside>
