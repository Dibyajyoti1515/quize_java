<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<header class="fixed top-0 left-0 lg:left-64 right-0 h-16 bg-surface-container-lowest/90 backdrop-blur-xl border-b border-surface-container-high z-40 flex items-center justify-between px-4 sm:px-8 shadow-sm">
  <!-- Left Side: Mobile Menu Toggle & Telemetry Nodes -->
  <div class="flex items-center gap-3 sm:gap-4">
    <!-- Hamburger Button for Small Screens -->
    <button type="button" onclick="toggleSidebar()" class="lg:hidden p-2 rounded-lg text-on-surface-variant hover:bg-surface-container hover:text-on-surface transition-all">
      <span class="material-symbols-outlined text-[24px]">menu</span>
    </button>

    <div class="hidden sm:flex items-center gap-2 text-on-surface-variant">
      <span class="material-symbols-outlined text-[18px]">terminal</span>
      <span class="font-code-telemetry text-xs uppercase tracking-wider font-semibold">Node: us-east-mon-02</span>
    </div>

    <div class="hidden sm:block h-4 w-px bg-outline-variant"></div>

    <div class="flex items-center gap-1.5">
      <span class="material-symbols-outlined text-emerald-700 text-[18px]">shield</span>
      <span class="font-label-md text-xs sm:text-sm font-semibold text-on-surface">AI Sentinel Active (v4.2)</span>
    </div>
  </div>

  <!-- Right Side: Notifications & User Profile -->
  <div class="flex items-center gap-3 sm:gap-4">
    <!-- Notifications Flyout -->
    <button aria-label="Notifications" type="button" onclick="toggleNotifications()" class="relative p-2 rounded-lg text-on-surface-variant hover:bg-surface-container hover:text-on-surface transition-all">
      <span class="material-symbols-outlined text-[22px]">notifications</span>
      <span class="absolute top-1.5 right-1.5 w-2 h-2 rounded-full bg-error"></span>
    </button>

    <div class="h-6 w-px bg-outline-variant"></div>

    <!-- User Profile Dropdown Strip -->
    <div class="flex items-center gap-3">
      <div class="text-right hidden sm:block">
        <span class="block font-label-md text-sm font-bold text-on-surface">
          <c:out value="${not empty sessionScope.userFullName ? sessionScope.userFullName : 'Prof. Ronald Vance'}"/>
        </span>
        <span class="block font-label-sm text-[11px] text-on-surface-variant font-medium">Chief Proctor • Computer Science</span>
      </div>
      <div class="w-9 h-9 rounded-full bg-primary flex items-center justify-center text-on-primary font-bold shadow-sm">
        <span class="material-symbols-outlined text-[20px]">person</span>
      </div>
      <a href="${pageContext.request.contextPath}/auth/logout" class="p-1.5 rounded-lg text-on-surface-variant hover:text-error hover:bg-error-container/30 transition-all" title="Sign Out">
        <span class="material-symbols-outlined text-[20px]">logout</span>
      </a>
    </div>
  </div>
</header>

<script>
  function toggleSidebar() {
    const sidebar = document.getElementById('teacher-sidebar');
    const backdrop = document.getElementById('mobile-sidebar-backdrop');
    if (sidebar) {
      sidebar.classList.toggle('-translate-x-full');
      if (backdrop) backdrop.classList.toggle('hidden');
    }
  }

  function toggleNotifications() {
    alert("Notifications Center:\n• 42 students currently active in CS402 Midterm Exam\n• 3 suspicious telemetry events flagged for review\n• Class average currently trending at 78.4%");
  }
</script>
