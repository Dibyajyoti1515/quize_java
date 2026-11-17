<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8"/>
  <meta content="width=device-width, initial-scale=1.0" name="viewport"/>
  <meta content="web_dashboard" name="shell-type"/>
  <title>Teacher Dashboard • Academic Overview | QuizTrack</title>
  <link href="https://fonts.googleapis.com" rel="preconnect"/>
  <link crossorigin="" href="https://fonts.gstatic.com" rel="preconnect"/>
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=JetBrains+Mono:wght@400;500&family=Plus+Jakarta+Sans:wght@600;700;800&display=swap" rel="stylesheet"/>
  <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200" rel="stylesheet"/>
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
      "darkMode": "class",
      "theme": {
        "extend": {
          "colors": {
            "on-secondary-fixed-variant": "#2f2ebe",
            "inverse-on-surface": "#eaf1ff",
            "surface-container-low": "#eff4ff",
            "secondary-container": "#6063ee",
            "error": "#ba1a1a",
            "on-tertiary": "#ffffff",
            "outline-variant": "#c7c4d8",
            "surface-dim": "#cbdbf5",
            "on-tertiary-fixed-variant": "#005236",
            "primary-container": "#4f46e5",
            "on-secondary-container": "#fffbff",
            "primary-fixed-dim": "#c3c0ff",
            "error-container": "#ffdad6",
            "on-secondary-fixed": "#07006c",
            "primary": "#3525cd",
            "surface-tint": "#4d44e3",
            "on-background": "#0b1c30",
            "tertiary-fixed-dim": "#4edea3",
            "inverse-primary": "#c3c0ff",
            "surface-variant": "#d3e4fe",
            "on-error-container": "#93000a",
            "on-tertiary-container": "#67f4b7",
            "secondary-fixed": "#e1e0ff",
            "surface-bright": "#f8f9ff",
            "on-primary-fixed-variant": "#3323cc",
            "on-primary-container": "#dad7ff",
            "on-error": "#ffffff",
            "surface-container-high": "#dce9ff",
            "on-primary": "#ffffff",
            "surface": "#f8f9ff",
            "on-primary-fixed": "#0f0069",
            "tertiary-container": "#006e4b",
            "surface-container": "#e5eeff",
            "secondary": "#4648d4",
            "primary-fixed": "#e2dfff",
            "tertiary-fixed": "#6ffbbe",
            "on-surface-variant": "#464555",
            "on-secondary": "#ffffff",
            "tertiary": "#005338",
            "secondary-fixed-dim": "#c0c1ff",
            "surface-container-lowest": "#ffffff",
            "surface-container-highest": "#d3e4fe",
            "outline": "#777587",
            "on-tertiary-fixed": "#002113",
            "inverse-surface": "#213145",
            "on-surface": "#0b1c30",
            "background": "#f8f9ff"
          },
          "borderRadius": {
            "DEFAULT": "0.25rem",
            "lg": "0.5rem",
            "xl": "0.75rem",
            "2xl": "1rem",
            "full": "9999px"
          },
          "spacing": {
            "gutter": "1.5rem",
            "margin-sm": "1rem",
            "space-md": "1rem",
            "gutter-sm": "1rem",
            "space-lg": "1.5rem",
            "space-xl": "2rem",
            "space-xs": "0.25rem",
            "space-sm": "0.5rem",
            "margin": "2rem"
          },
          "fontFamily": {
            "label-md": ["Inter", "sans-serif"],
            "body-md": ["Inter", "sans-serif"],
            "body-sm": ["Inter", "sans-serif"],
            "label-sm": ["Inter", "sans-serif"],
            "display": ["Plus Jakarta Sans", "sans-serif"],
            "title-lg": ["Plus Jakarta Sans", "sans-serif"],
            "body-lg": ["Inter", "sans-serif"],
            "headline-lg": ["Plus Jakarta Sans", "sans-serif"],
            "title-md": ["Inter", "sans-serif"],
            "headline-sm": ["Plus Jakarta Sans", "sans-serif"],
            "headline-md": ["Plus Jakarta Sans", "sans-serif"],
            "code-telemetry": ["JetBrains Mono", "monospace"]
          }
        }
      }
    };
  </script>
</head>
<body class="bg-background font-body-md text-on-surface">

  <!-- Include Reusable Sidebar -->
  <jsp:include page="/WEB-INF/views/teacher/components/sidebar.jsp"/>

  <!-- Main View Area (Offset for 64-width Sidebar on Large Screens) -->
  <div class="lg:pl-64 flex flex-col min-h-screen">
    
    <!-- Include Sticky Top Header -->
    <jsp:include page="/WEB-INF/views/teacher/components/header.jsp"/>

    <main class="relative pt-16 bg-surface min-h-screen w-full px-4 sm:px-6 lg:px-8">
      <div class="flex flex-col w-full pb-space-xl">

        <!-- Top Executive Bar with Context Controls & Global Actions -->
        <div class="flex flex-col lg:flex-row lg:items-center lg:justify-between gap-space-md py-space-md mb-space-lg">
          <div class="flex flex-wrap items-center gap-space-sm">
            <div class="flex items-center gap-space-xs px-space-md py-space-xs rounded-xl bg-surface-container-high text-on-surface">
              <span class="material-symbols-outlined text-[18px] text-primary">calendar_month</span>
              <span class="font-label-md text-label-md font-semibold">Spring 2025 Semester</span>
            </div>
            <div class="flex items-center gap-space-xs px-space-md py-space-xs rounded-xl bg-surface-container-highest text-on-surface shadow-sm">
              <span class="material-symbols-outlined text-[18px] text-secondary">school</span>
              <span class="font-title-md text-title-md font-bold">CS402: Distributed Systems</span>
              <span class="material-symbols-outlined text-[16px] text-on-surface-variant">expand_more</span>
            </div>
            <div class="flex items-center gap-space-xs px-space-sm py-space-xs rounded-lg bg-surface-container text-on-surface-variant">
              <span class="font-code-telemetry text-code-telemetry">Cohorts: CS402-A, B, C</span>
            </div>
          </div>

          <!-- Quick CTAs -->
          <div class="flex flex-wrap items-center gap-space-sm">
            <button class="flex items-center gap-space-xs px-space-md py-space-sm rounded-lg bg-surface-container-lowest text-on-surface shadow-sm hover:bg-surface-container transition-all border border-surface-container-high" type="button" onclick="alert('Exporting verified student enrollment roster as CSV...')">
              <span class="material-symbols-outlined text-[18px] text-on-surface-variant">download</span>
              <span class="font-label-md text-label-md font-semibold">Export Roster CSV</span>
            </button>
            <a class="flex items-center gap-space-xs px-space-md py-space-sm rounded-lg bg-error text-on-error shadow-md hover:opacity-95 transition-all font-bold" href="${pageContext.request.contextPath}/teacher/proctoring">
              <span class="relative flex h-2 w-2">
                <span class="animate-ping absolute inline-flex h-full w-full rounded-full bg-on-error opacity-75"></span>
                <span class="relative inline-flex rounded-full h-2 w-2 bg-on-error"></span>
              </span>
              <span class="material-symbols-outlined text-[18px]">videocam</span>
              <span class="font-label-md text-label-md uppercase tracking-wider">Live Proctoring HUD</span>
            </a>
            <a class="flex items-center gap-space-xs px-space-md py-space-sm rounded-lg bg-primary-container text-on-primary shadow-sm hover:opacity-90 transition-all font-bold" href="${pageContext.request.contextPath}/teacher/quizzes/create">
              <span class="material-symbols-outlined text-[18px]">add_circle</span>
              <span class="font-label-md text-label-md">+ Create New Quiz</span>
            </a>
          </div>
        </div>

        <!-- In-Flight Live Examination Mission Alert -->
        <div class="relative overflow-hidden rounded-xl bg-surface-container-lowest shadow-md p-space-lg mb-space-lg border border-surface-container-high">
          <div class="absolute left-0 top-0 bottom-0 w-2 bg-error"></div>
          <div class="flex flex-col xl:flex-row xl:items-center justify-between gap-space-lg pl-space-sm">
            <div class="flex flex-col lg:flex-row items-start lg:items-center gap-space-lg">
              <div class="relative w-16 h-16 rounded-xl bg-surface-container-high flex items-center justify-center shrink-0">
                <span class="material-symbols-outlined text-primary text-[32px]">sensors</span>
                <span class="absolute -top-1 -right-1 flex h-3.5 w-3.5">
                  <span class="animate-ping absolute inline-flex h-full w-full rounded-full bg-error opacity-75"></span>
                  <span class="relative inline-flex rounded-full h-3.5 w-3.5 bg-error"></span>
                </span>
              </div>
              <div class="flex flex-col gap-space-xs">
                <div class="flex items-center gap-space-sm">
                  <span class="px-space-xs py-0.5 rounded-full bg-error-container text-on-error-container font-label-sm text-label-sm uppercase font-bold tracking-wider">Examination In Session</span>
                  <span class="font-code-telemetry text-code-telemetry text-outline">CRN-88219 • Window Closes: 11:45 AM (<c:out value="${dashboardData.remainingTimeFormatted}"/>)</span>
                </div>
                <h2 class="font-headline-md text-headline-md text-on-surface font-bold">
                  <c:out value="${not empty dashboardData.activeQuiz ? dashboardData.activeQuiz.title : 'CS402: Midterm Exam - Distributed Systems & Concurrency'}"/>
                </h2>
                <p class="font-body-md text-body-md text-on-surface-variant">
                  <c:out value="${not empty dashboardData.activeQuiz ? dashboardData.activeQuiz.description : 'Live neural telemetry scanning enabled: dual-cam verification, browser lockdown v3.1, audio frequency fingerprinting.'}"/>
                </p>
              </div>
            </div>

            <!-- Live Exam Telemetry Snapshot -->
            <div class="flex flex-wrap items-center gap-space-md bg-surface-container-low px-space-lg py-space-md rounded-xl border border-surface-container">
              <div class="flex flex-col">
                <span class="font-label-sm text-label-sm text-on-surface-variant uppercase font-semibold">Stream Status</span>
                <div class="flex items-center gap-space-xs mt-0.5">
                  <span class="font-headline-sm text-headline-sm text-on-surface font-bold">
                    <c:out value="${dashboardData.activeExaminees}"/><span class="text-outline text-[16px]">/<c:out value="${dashboardData.totalAssignedExaminees}"/></span>
                  </span>
                  <span class="px-space-xs py-0.5 rounded bg-emerald-100 text-emerald-800 font-label-sm text-label-sm font-semibold">
                    <c:out value="${dashboardData.connectedPercentage}"/>% Connected
                  </span>
                </div>
              </div>
              <div class="h-8 w-px bg-outline-variant"></div>
              <div class="flex flex-col">
                <span class="font-label-sm text-label-sm text-on-surface-variant uppercase font-semibold">AI Sentinel Flag</span>
                <div class="flex items-center gap-space-xs mt-0.5">
                  <span class="font-headline-sm text-headline-sm text-error font-bold">
                    <c:out value="${dashboardData.liveFlaggedIncidents}"/>
                  </span>
                  <span class="px-space-xs py-0.5 rounded bg-error-container text-on-error-container font-label-sm text-label-sm font-semibold">Review Pending</span>
                </div>
              </div>
              <div class="h-8 w-px bg-outline-variant"></div>
              <a class="flex items-center gap-space-xs px-space-lg py-space-sm rounded-lg bg-primary text-on-primary font-label-md text-label-md hover:bg-surface-tint transition-all shadow-sm font-bold" href="${pageContext.request.contextPath}/teacher/proctoring">
                <span class="material-symbols-outlined text-[18px]">fullscreen</span>
                <span>Open Live Monitoring Matrix</span>
              </a>
            </div>
          </div>
        </div>

        <!-- Executive Metric KPI Row (5 Metrics) -->
        <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-5 gap-space-md mb-space-lg">
          <!-- Metric 1: Enrolled Students -->
          <div class="p-space-lg rounded-xl bg-surface-container-lowest shadow-sm border border-surface-container-high flex flex-col justify-between">
            <div class="flex items-center justify-between text-on-surface-variant">
              <span class="font-label-sm text-label-sm uppercase tracking-wider font-bold">Enrolled Students</span>
              <div class="w-8 h-8 rounded-lg bg-surface-container flex items-center justify-center text-primary">
                <span class="material-symbols-outlined text-[20px]">groups</span>
              </div>
            </div>
            <div class="mt-space-md">
              <span class="font-headline-lg text-headline-lg text-on-surface font-bold"><c:out value="${dashboardData.totalStudents}"/></span>
              <span class="block font-body-sm text-body-sm text-on-surface-variant mt-space-xs">Across 3 Cohorts (A, B, C)</span>
            </div>
            <div class="mt-space-sm pt-space-xs flex items-center gap-space-xs text-emerald-700">
              <span class="material-symbols-outlined text-[16px]">check_circle</span>
              <span class="font-label-sm text-label-sm font-semibold">100% Identity Verified</span>
            </div>
          </div>

          <!-- Metric 2: Active Quizzes -->
          <div class="p-space-lg rounded-xl bg-surface-container-lowest shadow-sm border border-surface-container-high flex flex-col justify-between">
            <div class="flex items-center justify-between text-on-surface-variant">
              <span class="font-label-sm text-label-sm uppercase tracking-wider font-bold">Active Quizzes</span>
              <div class="w-8 h-8 rounded-lg bg-surface-container flex items-center justify-center text-secondary">
                <span class="material-symbols-outlined text-[20px]">quiz</span>
              </div>
            </div>
            <div class="mt-space-md">
              <span class="font-headline-lg text-headline-lg text-on-surface font-bold"><c:out value="${dashboardData.activeQuizzesCount}"/></span>
              <span class="block font-body-sm text-body-sm text-on-surface-variant mt-space-xs">1 Live Now • <c:out value="${dashboardData.scheduledQuizzesCount}"/> Scheduled</span>
            </div>
            <div class="mt-space-sm pt-space-xs flex items-center gap-space-xs text-indigo-700">
              <span class="material-symbols-outlined text-[16px]">schedule</span>
              <span class="font-label-sm text-label-sm font-semibold">Next: Raft Consensus</span>
            </div>
          </div>

          <!-- Metric 3: Completed Sessions -->
          <div class="p-space-lg rounded-xl bg-surface-container-lowest shadow-sm border border-surface-container-high flex flex-col justify-between">
            <div class="flex items-center justify-between text-on-surface-variant">
              <span class="font-label-sm text-label-sm uppercase tracking-wider font-bold">Completed Sessions</span>
              <div class="w-8 h-8 rounded-lg bg-surface-container flex items-center justify-center text-indigo-700">
                <span class="material-symbols-outlined text-[20px]">task_alt</span>
              </div>
            </div>
            <div class="mt-space-md">
              <span class="font-headline-lg text-headline-lg text-on-surface font-bold"><c:out value="${dashboardData.completedSessionsCount}"/></span>
              <span class="block font-body-sm text-body-sm text-on-surface-variant mt-space-xs">This semester to date</span>
            </div>
            <div class="mt-space-sm pt-space-xs flex items-center gap-space-xs text-on-surface-variant">
              <span class="material-symbols-outlined text-[16px]">fact_check</span>
              <span class="font-label-sm text-label-sm">2,208 total submissions</span>
            </div>
          </div>

          <!-- Metric 4: Class Average -->
          <div class="p-space-lg rounded-xl bg-surface-container-lowest shadow-sm border border-surface-container-high flex flex-col justify-between">
            <div class="flex items-center justify-between text-on-surface-variant">
              <span class="font-label-sm text-label-sm uppercase tracking-wider font-bold">Class Average</span>
              <div class="w-8 h-8 rounded-lg bg-surface-container flex items-center justify-center text-emerald-700">
                <span class="material-symbols-outlined text-[20px]">insights</span>
              </div>
            </div>
            <div class="mt-space-md">
              <span class="font-headline-lg text-headline-lg text-on-surface font-bold"><c:out value="${dashboardData.averageClassScore}"/>%</span>
              <span class="block font-body-sm text-body-sm text-on-surface-variant mt-space-xs">Coursewide mean benchmark</span>
            </div>
            <div class="mt-space-sm pt-space-xs flex items-center gap-space-xs text-emerald-700">
              <span class="material-symbols-outlined text-[16px]">trending_up</span>
              <span class="font-label-sm text-label-sm font-semibold">+4.2% vs previous term</span>
            </div>
          </div>

          <!-- Metric 5: Proctor Trust Index -->
          <div class="p-space-lg rounded-xl bg-surface-container-lowest shadow-sm border border-surface-container-high flex flex-col justify-between">
            <div class="flex items-center justify-between text-on-surface-variant">
              <span class="font-label-sm text-label-sm uppercase tracking-wider font-bold">Proctor Trust Index</span>
              <div class="w-8 h-8 rounded-lg bg-surface-container flex items-center justify-center text-primary-container">
                <span class="material-symbols-outlined text-[20px]">verified</span>
              </div>
            </div>
            <div class="mt-space-md">
              <span class="font-headline-lg text-headline-lg text-primary font-bold"><c:out value="${dashboardData.proctorTrustIndex}"/>%</span>
              <span class="block font-body-sm text-body-sm text-on-surface-variant mt-space-xs">Low anomaly & false-flag rate</span>
            </div>
            <div class="mt-space-sm pt-space-xs flex items-center gap-space-xs text-emerald-800">
              <span class="material-symbols-outlined text-[16px]">security</span>
              <span class="font-label-sm text-label-sm font-semibold">Sentinel Strict Integrity</span>
            </div>
          </div>
        </div>

        <!-- Analytics & Performance Section (Split Grid 8 / 4) -->
        <div class="grid grid-cols-1 lg:grid-cols-12 gap-space-lg mb-space-lg">
          <!-- Topic Mastery & Score Trend SVG Chart (8 Cols) -->
          <div class="lg:col-span-8 p-space-lg rounded-xl bg-surface-container-lowest shadow-sm border border-surface-container-high flex flex-col justify-between">
            <div class="flex flex-col sm:flex-row sm:items-center justify-between gap-space-sm pb-space-md border-b border-surface-container">
              <div>
                <span class="font-label-sm text-label-sm text-on-surface-variant uppercase tracking-wider font-bold">Curriculum Deep-Dive</span>
                <h3 class="font-headline-sm text-headline-sm text-on-surface font-bold">Distributed Systems Concept Mastery</h3>
              </div>
              <div class="flex items-center gap-space-xs">
                <span class="inline-flex items-center gap-1 font-label-sm text-label-sm text-on-surface-variant font-semibold">
                  <span class="w-3 h-3 rounded-full bg-primary-container"></span> Spring 2025
                </span>
                <span class="inline-flex items-center gap-1 font-label-sm text-label-sm text-outline ml-space-sm font-semibold">
                  <span class="w-3 h-3 rounded-full bg-surface-container-high"></span> Dept Median
                </span>
              </div>
            </div>

            <!-- High Polish SVG Analytics Visualization Chart from Stitch -->
            <div class="w-full my-space-md overflow-x-auto">
              <svg class="w-full min-w-[600px] h-auto text-on-surface" fill="none" viewBox="0 0 760 220" xmlns="http://www.w3.org/2000/svg">
                <!-- Horizontal Grid Lines -->
                <line stroke="#E2E8F0" stroke-dasharray="4 4" stroke-width="1" x1="40" x2="740" y1="30" y2="30"></line>
                <line stroke="#E2E8F0" stroke-dasharray="4 4" stroke-width="1" x1="40" x2="740" y1="80" y2="80"></line>
                <line stroke="#E2E8F0" stroke-dasharray="4 4" stroke-width="1" x1="40" x2="740" y1="130" y2="130"></line>
                <line stroke="#E2E8F0" stroke-width="1.5" x1="40" x2="740" y1="180" y2="180"></line>

                <text class="font-code-telemetry text-[11px]" fill="#777587" text-anchor="end" x="32" y="34">100%</text>
                <text class="font-code-telemetry text-[11px]" fill="#777587" text-anchor="end" x="32" y="84">75%</text>
                <text class="font-code-telemetry text-[11px]" fill="#777587" text-anchor="end" x="32" y="134">50%</text>
                <text class="font-code-telemetry text-[11px]" fill="#777587" text-anchor="end" x="32" y="184">25%</text>

                <!-- Dept Baseline Area -->
                <path d="M80 140 L290 110 L500 100 L710 90 L710 180 L80 180 Z" fill="#F1F5F9" opacity="0.6"></path>
                <path d="M80 140 L290 110 L500 100 L710 90" stroke="#CBD5E1" stroke-dasharray="6 6" stroke-width="2"></path>

                <!-- Active Spring Term Gradient Area -->
                <defs>
                  <linearGradient id="chartGradient" x1="0" x2="0" y1="0" y2="1">
                    <stop offset="0%" stop-color="#4F46E5" stop-opacity="0.3"></stop>
                    <stop offset="100%" stop-color="#4F46E5" stop-opacity="0.0"></stop>
                  </linearGradient>
                </defs>
                <path d="M80 120 C160 120, 210 60, 290 60 C370 60, 420 70, 500 70 C580 70, 630 40, 710 40 L710 180 L80 180 Z" fill="url(#chartGradient)"></path>
                <path d="M80 120 C160 120, 210 60, 290 60 C370 60, 420 70, 500 70 C580 70, 630 40, 710 40" stroke="#4F46E5" stroke-linecap="round" stroke-width="3.5"></path>

                <!-- Interactive Node Points -->
                <g>
                  <circle cx="80" cy="120" fill="#FFFFFF" r="5" stroke="#4F46E5" stroke-width="3"></circle>
                  <text class="font-label-sm text-[12px]" fill="#0B1C30" font-weight="600" text-anchor="middle" x="80" y="202">Lamport Clocks</text>
                  <text class="font-code-telemetry text-[11px]" fill="#3525CD" font-weight="700" text-anchor="middle" x="80" y="105">62.5%</text>
                </g>
                <g>
                  <circle cx="290" cy="60" fill="#FFFFFF" r="5" stroke="#4F46E5" stroke-width="3"></circle>
                  <text class="font-label-sm text-[12px]" fill="#0B1C30" font-weight="600" text-anchor="middle" x="290" y="202">Vector Clocks</text>
                  <text class="font-code-telemetry text-[11px]" fill="#3525CD" font-weight="700" text-anchor="middle" x="290" y="45">86.2%</text>
                </g>
                <g>
                  <circle cx="500" cy="70" fill="#FFFFFF" r="5" stroke="#4F46E5" stroke-width="3"></circle>
                  <text class="font-label-sm text-[12px]" fill="#0B1C30" font-weight="600" text-anchor="middle" x="500" y="202">2PC / Paxos Core</text>
                  <text class="font-code-telemetry text-[11px]" fill="#3525CD" font-weight="700" text-anchor="middle" x="500" y="55">81.0%</text>
                </g>
                <g>
                  <circle cx="710" cy="40" fill="#FFFFFF" r="5" stroke="#4F46E5" stroke-width="3"></circle>
                  <text class="font-label-sm text-[12px]" fill="#0B1C30" font-weight="600" text-anchor="middle" x="710" y="202">Raft Consensus</text>
                  <text class="font-code-telemetry text-[11px]" fill="#3525CD" font-weight="700" text-anchor="middle" x="710" y="25">92.4%</text>
                </g>
              </svg>
            </div>

            <!-- Taxonomy Summary Pills -->
            <div class="grid grid-cols-2 sm:grid-cols-4 gap-space-sm pt-space-md bg-surface-container-low rounded-xl p-space-md border border-surface-container">
              <div>
                <span class="font-label-sm text-label-sm text-on-surface-variant block">Strongest Area</span>
                <span class="block font-title-md text-title-md text-emerald-800 font-bold">Raft Protocols</span>
                <span class="font-code-telemetry text-code-telemetry text-outline">92.4% avg</span>
              </div>
              <div>
                <span class="font-label-sm text-label-sm text-on-surface-variant block">Need Review</span>
                <span class="block font-title-md text-title-md text-error font-bold">Lamport Clocks</span>
                <span class="font-code-telemetry text-code-telemetry text-outline">62.5% avg</span>
              </div>
              <div>
                <span class="font-label-sm text-label-sm text-on-surface-variant block">Assessment Integrity</span>
                <span class="block font-title-md text-title-md text-on-surface font-bold">Strict Cam-Locked</span>
                <span class="font-code-telemetry text-code-telemetry text-outline">0 flagged false</span>
              </div>
              <div>
                <span class="font-label-sm text-label-sm text-on-surface-variant block">Median Completion</span>
                <span class="block font-title-md text-title-md text-on-surface font-bold">38.4 mins</span>
                <span class="font-code-telemetry text-code-telemetry text-outline">Window: 90m</span>
              </div>
            </div>
          </div>

          <!-- Cohort Comparison & Faculty Audit Widget (4 Cols) -->
          <div class="lg:col-span-4 flex flex-col gap-space-md">
            <!-- Cohort Comparison Block -->
            <div class="p-space-lg rounded-xl bg-surface-container-lowest shadow-sm border border-surface-container-high flex flex-col justify-between flex-1">
              <div>
                <div class="flex items-center justify-between mb-space-md">
                  <h3 class="font-title-lg text-title-lg text-on-surface font-bold">Cohort Comparisons</h3>
                  <span class="px-space-xs py-0.5 rounded bg-surface-container font-code-telemetry text-code-telemetry text-on-surface-variant font-bold">CS402</span>
                </div>
                <div class="flex flex-col gap-space-md">
                  <c:forEach items="${dashboardData.cohortComparisonList}" var="c">
                    <div class="flex flex-col gap-space-xs">
                      <div class="flex justify-between items-center">
                        <span class="font-label-md text-label-md text-on-surface font-semibold"><c:out value="${c.cohortName}"/></span>
                        <span class="font-code-telemetry text-code-telemetry font-bold text-primary"><c:out value="${c.averageScore}"/>%</span>
                      </div>
                      <div class="w-full h-2.5 rounded-full bg-surface-container overflow-hidden">
                        <div class="h-full bg-primary rounded-full" style="width: ${c.averageScore}%"></div>
                      </div>
                      <span class="font-body-sm text-body-sm text-on-surface-variant"><c:out value="${c.studentCount}"/> Students • <c:out value="${c.proctorScore}"/>% Proctor score</span>
                    </div>
                  </c:forEach>
                </div>
              </div>

              <div class="pt-space-md mt-space-md bg-surface-container-low p-space-md rounded-xl flex items-center justify-between border border-surface-container">
                <div class="flex items-center gap-space-xs">
                  <span class="material-symbols-outlined text-[18px] text-emerald-700">balance</span>
                  <span class="font-label-sm text-label-sm text-on-surface font-semibold">Cohort Variance: ±3.1%</span>
                </div>
                <span class="font-code-telemetry text-code-telemetry text-emerald-800 font-bold">STABLE</span>
              </div>
            </div>

            <!-- Proctor Quick Actions & Pending Requests -->
            <div class="p-space-lg rounded-xl bg-surface-container-lowest shadow-sm border border-surface-container-high flex flex-col justify-between">
              <div class="flex items-center justify-between pb-space-sm border-b border-surface-container">
                <div class="flex items-center gap-space-xs">
                  <span class="material-symbols-outlined text-error text-[20px]">notification_important</span>
                  <h4 class="font-title-md text-title-md text-on-surface font-bold">Pending Proctor Audits</h4>
                </div>
                <span class="px-space-xs py-0.5 rounded-full bg-error-container text-on-error-container font-label-sm text-label-sm font-bold">3 Action Items</span>
              </div>
              <div class="flex flex-col gap-space-sm my-space-sm">
                <c:forEach items="${dashboardData.pendingAudits}" var="a">
                  <div class="p-space-sm rounded-lg bg-surface-container flex items-center justify-between">
                    <div class="flex items-center gap-space-sm">
                      <div class="w-7 h-7 rounded-full bg-error-container flex items-center justify-center text-on-error-container font-label-sm font-bold"><c:out value="${a.initials}"/></div>
                      <div class="flex flex-col">
                        <span class="font-label-md text-label-md text-on-surface font-semibold"><c:out value="${a.studentName}"/></span>
                        <span class="font-code-telemetry text-[11px] text-outline"><c:out value="${a.issueDescription}"/></span>
                      </div>
                    </div>
                    <button class="px-space-xs py-1 rounded bg-surface-container-highest text-on-surface font-label-sm text-label-sm hover:bg-primary hover:text-on-primary transition-all font-bold" type="button" onclick="alert('Viewing audit logs for ${a.studentName}')">Audit</button>
                  </div>
                </c:forEach>
              </div>
              <a class="text-center font-label-sm text-label-sm text-primary hover:underline pt-space-xs font-bold" href="${pageContext.request.contextPath}/teacher/violations">
                Open All Incident Reviews →
              </a>
            </div>
          </div>
        </div>

        <!-- Recent & Scheduled Quiz Activity Table -->
        <div class="rounded-xl bg-surface-container-lowest shadow-sm p-space-lg mb-space-lg border border-surface-container-high">
          <div class="flex flex-col sm:flex-row sm:items-center justify-between gap-space-md mb-space-lg">
            <div class="flex flex-col">
              <h3 class="font-headline-sm text-headline-sm text-on-surface font-bold">Course Examination Schedule & Activity</h3>
              <p class="font-body-sm text-body-sm text-on-surface-variant">Live telemetry status, past test audits, and scheduled assessments</p>
            </div>
            <div class="flex items-center gap-space-sm">
              <div class="relative">
                <input class="pl-9 pr-space-md py-space-xs rounded-lg bg-surface-container text-on-surface font-body-sm text-body-sm focus:outline-none focus:bg-surface-container-lowest transition-all w-60 border border-transparent focus:border-indigo-400" placeholder="Search assessments..." type="text"/>
                <span class="material-symbols-outlined absolute left-2.5 top-1/2 -translate-y-1/2 text-outline text-[18px]">search</span>
              </div>
              <button class="flex items-center gap-space-xs px-space-md py-space-xs rounded-lg bg-surface-container text-on-surface font-label-md text-label-md hover:bg-surface-container-high transition-all font-semibold" type="button">
                <span class="material-symbols-outlined text-[16px]">filter_list</span>
                <span>Filter</span>
              </button>
            </div>
          </div>

          <!-- Table Container -->
          <div class="overflow-x-auto">
            <table class="w-full text-left">
              <thead>
                <tr class="bg-surface-container text-on-surface-variant font-label-sm text-label-sm uppercase tracking-wider">
                  <th class="py-space-sm px-space-md rounded-l-lg font-bold">Assessment Details</th>
                  <th class="py-space-sm px-space-md font-bold">Subject / Module</th>
                  <th class="py-space-sm px-space-md font-bold">Scheduled Window</th>
                  <th class="py-space-sm px-space-md font-bold">Submissions</th>
                  <th class="py-space-sm px-space-md font-bold">Mean Score</th>
                  <th class="py-space-sm px-space-md font-bold">Sentinel Status</th>
                  <th class="py-space-sm px-space-md rounded-r-lg text-right font-bold">Actions</th>
                </tr>
              </thead>
              <tbody class="divide-y divide-surface-container-low">
                <c:forEach items="${dashboardData.examinationSchedule}" var="q">
                  <tr class="hover:bg-surface-container-low transition-colors">
                    <td class="py-space-md px-space-md">
                      <div class="flex items-center gap-space-sm">
                        <div class="w-10 h-10 rounded-lg ${q.liveNow ? 'bg-error-container text-error' : 'bg-surface-container-high text-primary'} flex items-center justify-center shrink-0">
                          <span class="material-symbols-outlined text-[20px]">${q.liveNow ? 'videocam' : 'assignment_turned_in'}</span>
                        </div>
                        <div>
                          <span class="font-title-md text-title-md text-on-surface font-bold block"><c:out value="${q.title}"/></span>
                          <span class="font-code-telemetry text-code-telemetry text-on-surface-variant"><c:out value="${q.subjectName}"/></span>
                        </div>
                      </div>
                    </td>
                    <td class="py-space-md px-space-md">
                      <span class="px-space-xs py-0.5 rounded bg-primary-fixed text-on-primary-fixed font-label-sm text-label-sm font-semibold">
                        <c:out value="${q.subjectCode}"/> Core
                      </span>
                    </td>
                    <td class="py-space-md px-space-md">
                      <div class="flex flex-col">
                        <c:choose>
                          <c:when test="${q.liveNow}">
                            <span class="font-label-md text-label-md text-error font-bold flex items-center gap-1">
                              <span class="w-2 h-2 rounded-full bg-error animate-ping"></span> Live Now
                            </span>
                            <span class="font-code-telemetry text-code-telemetry text-outline"><c:out value="${q.durationMinutes}"/>m Window</span>
                          </c:when>
                          <c:otherwise>
                            <span class="font-label-md text-label-md text-on-surface font-semibold">Scheduled</span>
                            <span class="font-code-telemetry text-code-telemetry text-outline"><c:out value="${q.durationMinutes}"/> Minutes</span>
                          </c:otherwise>
                        </c:choose>
                      </div>
                    </td>
                    <td class="py-space-md px-space-md">
                      <div class="flex flex-col">
                        <span class="font-title-md text-title-md font-bold text-on-surface">
                          <c:out value="${q.activeExaminees > 0 ? q.activeExaminees : q.totalSubmissions}"/> / 45
                        </span>
                        <div class="w-24 h-1.5 rounded-full bg-surface-container mt-1">
                          <div class="h-full bg-primary rounded-full" style="width: ${q.liveNow ? '93%' : '100%'}"></div>
                        </div>
                      </div>
                    </td>
                    <td class="py-space-md px-space-md">
                      <c:choose>
                        <c:when test="${q.liveNow}">
                          <span class="font-code-telemetry text-code-telemetry text-outline italic">In Progress</span>
                        </c:when>
                        <c:when test="${q.averageScore > 0}">
                          <span class="font-code-telemetry text-code-telemetry text-emerald-800 font-bold"><c:out value="${q.averageScore}"/>%</span>
                        </c:when>
                        <c:otherwise>
                          <span class="font-code-telemetry text-code-telemetry text-outline italic">Pending Start</span>
                        </c:otherwise>
                      </c:choose>
                    </td>
                    <td class="py-space-md px-space-md">
                      <c:choose>
                        <c:when test="${q.liveNow}">
                          <span class="px-space-xs py-0.5 rounded-full bg-error-container text-on-error-container font-label-sm text-label-sm font-bold flex items-center gap-1 w-max">
                            <span class="material-symbols-outlined text-[14px]">warning</span> 3 Flagged
                          </span>
                        </c:when>
                        <c:otherwise>
                          <span class="px-space-xs py-0.5 rounded-full bg-emerald-100 text-emerald-800 font-label-sm text-label-sm font-bold flex items-center gap-1 w-max">
                            <span class="material-symbols-outlined text-[14px]">verified</span> Pre-Audited
                          </span>
                        </c:otherwise>
                      </c:choose>
                    </td>
                    <td class="py-space-md px-space-md text-right">
                      <div class="flex items-center justify-end gap-space-xs">
                        <c:choose>
                          <c:when test="${q.liveNow}">
                            <a class="px-space-sm py-1 rounded bg-primary text-on-primary font-label-sm text-label-sm hover:opacity-90 font-bold" href="${pageContext.request.contextPath}/teacher/proctoring">Live Matrix</a>
                          </c:when>
                          <c:otherwise>
                            <a class="px-space-sm py-1 rounded bg-surface-container-high text-on-surface font-label-sm text-label-sm hover:bg-surface-container-highest font-bold" href="${pageContext.request.contextPath}/teacher/quizzes">Manage</a>
                          </c:otherwise>
                        </c:choose>
                      </div>
                    </td>
                  </tr>
                </c:forEach>
              </tbody>
            </table>
          </div>
        </div>

      </div>
    </main>
  </div>

</body>
</html>
