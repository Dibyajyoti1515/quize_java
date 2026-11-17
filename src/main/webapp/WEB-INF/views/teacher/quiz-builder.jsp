<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8"/>
    <meta content="width=device-width, initial-scale=1.0" name="viewport"/>
    <meta content="web_dashboard" name="shell-type"/>
    <title>Quiz Architect &amp; Item Bank Matrix | QuizTrack Faculty</title>

    <!-- Google Fonts & Material Symbols matching Stitch -->
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

    <!-- Tailwind CDN with Stitch Palette -->
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
                        "secondary-fixed": "#e1e0ff",
                        "on-secondary": "#ffffff",
                        "on-secondary-fixed": "#07006c",
                        "tertiary": "#005338",
                        "tertiary-container": "#006e4b",
                        "tertiary-fixed": "#6ffbbe",
                        "tertiary-fixed-dim": "#4edea3",
                        "on-tertiary": "#ffffff",
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
<body class="bg-surface font-body-md text-on-surface antialiased">

    <!-- Reusable Teacher Sidebar -->
    <jsp:include page="components/sidebar.jsp"/>

    <div class="lg:pl-64">
        <!-- Reusable Teacher Header -->
        <jsp:include page="components/header.jsp"/>

        <main class="w-full pt-16 bg-surface min-h-screen">
            <div class="flex flex-col w-full">
                
                <!-- Top Breadcrumb & Action Command Bar -->
                <section class="bg-surface-container-lowest px-4 sm:px-gutter py-space-md shadow-sm border-b border-surface-container-high/60">
                    <div class="flex flex-col xl:flex-row xl:items-center xl:justify-between gap-space-md">
                        <!-- Breadcrumb & Autosave -->
                        <div class="flex flex-col gap-1 min-w-0">
                            <div class="flex items-center gap-space-xs text-on-surface-variant font-label-sm text-label-sm">
                                <a href="${pageContext.request.contextPath}/teacher/dashboard" class="hover:text-primary cursor-pointer transition-colors">Faculty Portal</a>
                                <span class="material-symbols-outlined text-[14px]">chevron_right</span>
                                <a href="${pageContext.request.contextPath}/teacher/quizzes" class="hover:text-primary cursor-pointer transition-colors">Examinations &amp; Assessment</a>
                                <span class="material-symbols-outlined text-[14px]">chevron_right</span>
                                <span class="text-primary font-semibold">Quiz Architect &amp; Matrix</span>
                            </div>
                            <div class="flex items-center gap-space-sm pt-0.5 flex-wrap">
                                <span class="font-headline-sm text-xl sm:text-2xl font-bold text-on-surface">Quiz Architect &amp; Item Bank Matrix</span>
                                <div class="inline-flex items-center gap-1.5 px-space-xs py-0.5 rounded-full bg-surface-container text-on-surface-variant font-code-telemetry text-code-telemetry">
                                    <span class="h-2 w-2 rounded-full bg-tertiary-fixed-dim animate-pulse"></span>
                                    <span>Draft auto-saved • PostgreSQL Session Store</span>
                                </div>
                            </div>
                        </div>

                        <!-- Action Buttons -->
                        <div class="flex flex-wrap items-center gap-space-sm">
                            <button class="inline-flex items-center gap-space-xs px-space-md py-2 rounded-lg bg-surface-container text-on-surface hover:bg-surface-container-high transition-colors font-label-md text-label-md font-semibold" id="openQuestionBankBtn" type="button">
                                <span class="material-symbols-outlined text-[18px] text-primary">inventory_2</span>
                                <span>Import from Question Bank</span>
                                <span class="px-1.5 py-0.2 rounded bg-surface-container-highest text-primary font-code-telemetry text-code-telemetry font-bold">
                                    <c:out value="${bankQuestions.size()}"/>+
                                </span>
                            </button>

                            <a href="${pageContext.request.contextPath}/student/quizzes" target="_blank" class="inline-flex items-center gap-space-xs px-space-md py-2 rounded-lg bg-surface-container-lowest text-on-surface shadow-sm border border-surface-container-high hover:bg-surface-container-low transition-colors font-label-md text-label-md font-semibold">
                                <span class="material-symbols-outlined text-[18px] text-secondary">visibility</span>
                                <span>Preview Student View</span>
                            </a>

                            <!-- Publish Form -->
                            <form action="${pageContext.request.contextPath}/teacher/quiz/builder" method="POST" class="inline">
                                <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}"/>
                                <input type="hidden" name="quizId" value="${quiz.quizId}"/>
                                <c:choose>
                                    <c:when test="${quiz.status == 'ACTIVE'}">
                                        <input type="hidden" name="action" value="save_draft"/>
                                        <button type="submit" class="inline-flex items-center gap-space-xs px-space-md py-2 rounded-lg bg-surface-container hover:bg-surface-container-high text-on-surface font-label-md text-label-md font-semibold transition-colors">
                                            <span class="material-symbols-outlined text-[18px]">pause</span>
                                            <span>Unpublish to Draft</span>
                                        </button>
                                    </c:when>
                                    <c:otherwise>
                                        <input type="hidden" name="action" value="publish_quiz"/>
                                        <button type="submit" class="inline-flex items-center gap-space-xs px-space-md py-2 rounded-lg bg-primary text-on-primary hover:bg-primary-container font-label-md text-label-md font-bold shadow-sm transition-colors">
                                            <span class="material-symbols-outlined text-[18px]">publish</span>
                                            <span>Publish Quiz &amp; Schedule</span>
                                        </button>
                                    </c:otherwise>
                                </c:choose>
                            </form>
                        </div>
                    </div>

                    <!-- Stepper Navigation -->
                    <div class="mt-space-lg pt-space-sm">
                        <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-space-sm">
                            <!-- Step 1 -->
                            <div class="flex items-center gap-space-sm p-space-sm rounded-lg bg-surface-container-low transition-all">
                                <div class="h-8 w-8 rounded-full bg-tertiary-container text-on-tertiary flex items-center justify-center font-bold text-[13px]">
                                    <span class="material-symbols-outlined text-[16px]">check</span>
                                </div>
                                <div class="flex flex-col min-w-0">
                                    <span class="font-label-sm text-label-sm text-on-surface-variant uppercase tracking-wider font-semibold">Step 1 • Completed</span>
                                    <span class="font-title-md text-title-md text-on-surface font-semibold truncate">Basic Info &amp; Settings</span>
                                </div>
                            </div>
                            <!-- Step 2 (Active) -->
                            <div class="flex items-center gap-space-sm p-space-sm rounded-lg bg-primary-container text-on-primary shadow-sm">
                                <div class="h-8 w-8 rounded-full bg-on-primary text-primary flex items-center justify-center font-bold text-[13px]">
                                    2
                                </div>
                                <div class="flex flex-col min-w-0">
                                    <span class="font-label-sm text-label-sm text-on-primary-container uppercase tracking-wider font-bold">Step 2 • Active</span>
                                    <span class="font-title-md text-title-md text-on-primary font-bold truncate">Question Builder &amp; Bank</span>
                                </div>
                            </div>
                            <!-- Step 3 -->
                            <div class="flex items-center gap-space-sm p-space-sm rounded-lg bg-surface-container-low transition-all">
                                <div class="h-8 w-8 rounded-full bg-tertiary-container text-on-tertiary flex items-center justify-center font-bold text-[13px]">
                                    <span class="material-symbols-outlined text-[16px]">check</span>
                                </div>
                                <div class="flex flex-col min-w-0">
                                    <span class="font-label-sm text-label-sm text-on-surface-variant uppercase tracking-wider font-semibold">Step 3 • Verified</span>
                                    <span class="font-title-md text-title-md text-on-surface font-semibold truncate">Anti-Cheat &amp; Lockout</span>
                                </div>
                            </div>
                            <!-- Step 4 -->
                            <div class="flex items-center gap-space-sm p-space-sm rounded-lg bg-surface-container-low transition-all">
                                <div class="h-8 w-8 rounded-full bg-surface-container-high text-on-surface-variant flex items-center justify-center font-bold text-[13px]">
                                    4
                                </div>
                                <div class="flex flex-col min-w-0">
                                    <span class="font-label-sm text-label-sm text-on-surface-variant uppercase tracking-wider font-semibold">Step 4 • Scheduled</span>
                                    <span class="font-title-md text-title-md text-on-surface font-semibold truncate">Cohorts &amp; Proctor Slates</span>
                                </div>
                            </div>
                        </div>
                    </div>
                </section>

                <!-- Flash Feedback Banners (PRG Pattern) -->
                <c:if test="${not empty flashSuccess}">
                    <div class="mx-4 sm:mx-gutter mt-space-md p-space-md rounded-xl bg-tertiary-container/20 border border-tertiary text-tertiary flex items-center justify-between shadow-xs">
                        <div class="flex items-center gap-space-sm">
                            <span class="material-symbols-outlined text-[22px]">check_circle</span>
                            <span class="font-body-md text-body-md font-semibold"><c:out value="${flashSuccess}"/></span>
                        </div>
                        <button type="button" onclick="this.parentElement.remove()" class="text-tertiary hover:opacity-75">
                            <span class="material-symbols-outlined text-[18px]">close</span>
                        </button>
                    </div>
                </c:if>
                <c:if test="${not empty flashError}">
                    <div class="mx-4 sm:mx-gutter mt-space-md p-space-md rounded-xl bg-error-container/30 border border-error text-error flex items-center justify-between shadow-xs">
                        <div class="flex items-center gap-space-sm">
                            <span class="material-symbols-outlined text-[22px]">error</span>
                            <span class="font-body-md text-body-md font-semibold"><c:out value="${flashError}"/></span>
                        </div>
                        <button type="button" onclick="this.parentElement.remove()" class="text-error hover:opacity-75">
                            <span class="material-symbols-outlined text-[18px]">close</span>
                        </button>
                    </div>
                </c:if>

                <!-- Main Workspace: Split Content Engine (72% Main / 28% Sidebar) -->
                <div class="p-4 sm:p-gutter grid grid-cols-1 lg:grid-cols-12 gap-gutter items-start max-w-[1600px] mx-auto w-full">
                    
                    <!-- LEFT / MAIN REGION (lg:col-span-8) -->
                    <div class="lg:col-span-8 flex flex-col gap-gutter">
                        
                        <!-- Quiz Configuration Summary Card (Collapsible) -->
                        <div class="bg-surface-container-lowest rounded-2xl shadow-sm border border-surface-container-high overflow-hidden">
                            <div class="p-space-md bg-surface-container-low flex flex-wrap items-center justify-between gap-space-sm border-b border-surface-container-high">
                                <div class="flex items-center gap-space-sm min-w-0">
                                    <span class="material-symbols-outlined text-primary text-[24px]">tune</span>
                                    <div class="flex flex-col min-w-0">
                                        <div class="flex items-center gap-space-xs">
                                            <span class="font-headline-sm text-lg font-bold text-on-surface truncate">
                                                <c:out value="${quiz.title}"/>
                                            </span>
                                            <span class="material-symbols-outlined text-[18px] text-tertiary">verified</span>
                                        </div>
                                        <span class="font-label-sm text-label-sm text-on-surface-variant">
                                            Course Code: <c:out value="${quiz.subjectCode}"/> • <c:out value="${quiz.subjectName}"/>
                                        </span>
                                    </div>
                                </div>
                                <button class="flex items-center gap-1 text-on-surface-variant hover:text-on-surface font-label-md text-label-md transition-colors" id="toggleConfigBtn" type="button">
                                    <span id="configToggleText">Hide Parameters</span>
                                    <span class="material-symbols-outlined text-[18px]" id="configToggleIcon">keyboard_arrow_up</span>
                                </button>
                            </div>

                            <div class="p-space-md space-y-space-md transition-all" id="quizConfigBody">
                                <!-- Parameter Metrics & Toggles -->
                                <div class="grid grid-cols-2 md:grid-cols-4 gap-space-sm">
                                    <div class="p-space-sm rounded-xl bg-surface-container flex flex-col justify-between">
                                        <span class="font-label-sm text-label-sm text-on-surface-variant font-medium">Time Duration</span>
                                        <div class="flex items-baseline gap-1 mt-1">
                                            <span class="font-title-lg text-2xl text-primary font-bold"><c:out value="${quiz.durationMinutes}"/></span>
                                            <span class="font-label-md text-label-md text-on-surface font-semibold">Mins</span>
                                        </div>
                                        <span class="font-code-telemetry text-[11px] text-on-surface-variant">Strict Auto-Submit</span>
                                    </div>

                                    <div class="p-space-sm rounded-xl bg-surface-container flex flex-col justify-between">
                                        <span class="font-label-sm text-label-sm text-on-surface-variant font-medium">Total Questions</span>
                                        <div class="flex items-baseline gap-1 mt-1">
                                            <span class="font-title-lg text-2xl text-on-surface font-bold"><c:out value="${quizQuestions.size()}"/></span>
                                            <span class="font-label-md text-label-md text-on-surface-variant font-semibold">Items</span>
                                        </div>
                                        <span class="font-code-telemetry text-[11px] text-tertiary font-semibold">100% Configured</span>
                                    </div>

                                    <div class="p-space-sm rounded-xl bg-surface-container flex flex-col justify-between">
                                        <span class="font-label-sm text-label-sm text-on-surface-variant font-medium">Marks Aggregate</span>
                                        <div class="flex items-baseline gap-1 mt-1">
                                            <span class="font-title-lg text-2xl text-secondary font-bold">
                                                <fmt:formatNumber value="${quiz.totalMarks}" maxFractionDigits="0"/>
                                            </span>
                                            <span class="font-label-md text-label-md text-on-surface-variant font-semibold">Pts</span>
                                        </div>
                                        <span class="font-code-telemetry text-[11px] text-on-surface-variant">
                                            Pass Benchmark: <fmt:formatNumber value="${quiz.passPercentage}" maxFractionDigits="0"/>%
                                        </span>
                                    </div>

                                    <div class="p-space-sm rounded-xl bg-error-container text-on-error-container flex flex-col justify-between">
                                        <span class="font-label-sm text-label-sm font-semibold">Negative Marking</span>
                                        <div class="flex items-baseline gap-1 mt-1">
                                            <span class="font-title-lg text-2xl font-bold">
                                                <c:choose>
                                                    <c:when test="${quiz.negativeMarking}">-<fmt:formatNumber value="${quiz.negativeMarkValue}" minFractionDigits="2"/></c:when>
                                                    <c:otherwise>0.00</c:otherwise>
                                                </c:choose>
                                            </span>
                                            <span class="font-label-md text-label-md font-semibold">/ item</span>
                                        </div>
                                        <span class="font-code-telemetry text-[11px] font-semibold text-error">Correct: +4.00 Marks</span>
                                    </div>
                                </div>

                                <!-- Randomization & Integrity Toggles -->
                                <div class="pt-space-xs flex flex-wrap items-center gap-space-md text-on-surface-variant font-body-sm text-body-sm">
                                    <label class="flex items-center gap-2 cursor-pointer">
                                        <input type="checkbox" ${quiz.shuffleQuestions ? 'checked' : ''} disabled class="h-4 w-4 rounded accent-primary cursor-pointer"/>
                                        <span class="text-on-surface font-medium">Randomize Question Sequence per Seat</span>
                                    </label>
                                    <label class="flex items-center gap-2 cursor-pointer">
                                        <input type="checkbox" checked disabled class="h-4 w-4 rounded accent-primary cursor-pointer"/>
                                        <span class="text-on-surface font-medium">Shuffle Choice / Option Ordering</span>
                                    </label>
                                    <label class="flex items-center gap-2 cursor-pointer">
                                        <input type="checkbox" checked disabled class="h-4 w-4 rounded accent-primary cursor-pointer"/>
                                        <span class="text-on-surface font-medium">Allow Embedded Scientific Calculator</span>
                                    </label>
                                </div>
                            </div>
                        </div>

                        <!-- Interactive Question Builder Card -->
                        <form action="${pageContext.request.contextPath}/teacher/quiz/builder" method="POST" id="questionBuilderForm" class="bg-surface-container-lowest rounded-2xl shadow-sm border border-surface-container-high flex flex-col overflow-hidden">
                            <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}"/>
                            <input type="hidden" name="action" value="save_question"/>
                            <input type="hidden" name="quizId" value="${quiz.quizId}"/>
                            <input type="hidden" name="questionId" value="${activeQuestion != null && activeQuestion.questionId > 0 ? activeQuestion.questionId : 0}"/>
                            <input type="hidden" name="subjectId" value="${quiz.subjectId}"/>

                            <!-- Builder Header -->
                            <div class="p-space-md bg-surface-container-lowest flex flex-wrap items-center justify-between gap-space-sm border-b border-surface-container-high">
                                <div class="flex items-center gap-space-sm">
                                    <span class="flex items-center justify-center w-8 h-8 rounded-lg bg-primary-container text-on-primary font-headline-sm text-headline-sm font-bold">
                                        <c:set var="qIndex" value="1"/>
                                        <c:choose>
                                            <c:when test="${activeQuestion != null && activeQuestion.questionId > 0}">
                                                <c:forEach var="item" items="${quizQuestions}" varStatus="status">
                                                    <c:if test="${item.questionId == activeQuestion.questionId}">
                                                        <c:set var="qIndex" value="${status.count}"/>
                                                    </c:if>
                                                </c:forEach>
                                            </c:when>
                                            <c:otherwise>
                                                <c:set var="qIndex" value="${quizQuestions.size() + 1}"/>
                                            </c:otherwise>
                                        </c:choose>
                                        <c:out value="${qIndex}"/>
                                    </span>
                                    <div>
                                        <div class="flex items-center gap-2">
                                            <span class="font-title-md text-title-md font-bold text-on-surface" id="questionHeaderTitle">
                                                Question #<c:out value="${qIndex}"/> 
                                                <c:choose>
                                                    <c:when test="${activeQuestion != null && activeQuestion.questionType == 'MULTI_CHOICE'}">(Multi-Correct)</c:when>
                                                    <c:when test="${activeQuestion != null && activeQuestion.questionType == 'TRUE_FALSE'}">(True / False)</c:when>
                                                    <c:otherwise>(Multiple Choice - Single Select)</c:otherwise>
                                                </c:choose>
                                            </span>
                                            <span class="px-2 py-0.5 rounded-full bg-surface-container-high text-primary font-label-sm text-label-sm font-semibold">
                                                <c:out value="${activeQuestion != null && activeQuestion.questionId > 0 ? 'Editing Active' : 'New Blank Item'}"/>
                                            </span>
                                        </div>
                                        <p class="font-label-sm text-label-sm text-on-surface-variant">
                                            Tagged: <c:out value="${activeQuestion != null && not empty activeQuestion.taxonomyTopic ? activeQuestion.taxonomyTopic : 'General Topic'}"/>
                                        </p>
                                    </div>
                                </div>

                                <!-- Question Type Switcher Pills -->
                                <div class="flex items-center bg-surface-container-low p-1 rounded-xl gap-1">
                                    <input type="hidden" name="questionType" id="questionTypeInput" value="${activeQuestion != null ? activeQuestion.questionType : 'SINGLE_CHOICE'}"/>
                                    <button class="px-space-sm py-1 rounded-lg font-label-sm text-label-sm font-bold transition-all ${activeQuestion == null || activeQuestion.questionType == 'SINGLE_CHOICE' ? 'bg-primary text-on-primary shadow-sm' : 'text-on-surface-variant hover:bg-surface-container-high'}" type="button" onclick="setQuestionType('SINGLE_CHOICE', this)">
                                        MCQ (Single)
                                    </button>
                                    <button class="px-space-sm py-1 rounded-lg font-label-sm text-label-sm font-bold transition-all ${activeQuestion != null && activeQuestion.questionType == 'MULTI_CHOICE' ? 'bg-primary text-on-primary shadow-sm' : 'text-on-surface-variant hover:bg-surface-container-high'}" type="button" onclick="setQuestionType('MULTI_CHOICE', this)">
                                        Multi-Correct
                                    </button>
                                    <button class="px-space-sm py-1 rounded-lg font-label-sm text-label-sm font-bold transition-all ${activeQuestion != null && activeQuestion.questionType == 'TRUE_FALSE' ? 'bg-primary text-on-primary shadow-sm' : 'text-on-surface-variant hover:bg-surface-container-high'}" type="button" onclick="setQuestionType('TRUE_FALSE', this)">
                                        True/False
                                    </button>
                                </div>
                            </div>

                            <!-- Question Attributes Strip -->
                            <div class="px-space-md py-space-sm bg-surface-container-low flex flex-wrap items-center justify-between gap-space-md border-b border-surface-container-high">
                                <div class="flex items-center gap-space-md">
                                    <div class="flex items-center gap-space-xs">
                                        <span class="font-label-sm text-label-sm text-on-surface-variant font-semibold">Correct Weight:</span>
                                        <input class="w-16 px-space-xs py-1 text-center font-code-telemetry text-code-telemetry rounded-lg bg-surface-container-lowest text-tertiary font-bold focus:outline-none focus:ring-1 focus:ring-primary shadow-xs" type="number" step="0.5" min="0.5" name="points" value="${activeQuestion != null && activeQuestion.points != null ? activeQuestion.points : 4.00}"/>
                                    </div>
                                    <div class="flex items-center gap-space-xs">
                                        <span class="font-label-sm text-label-sm text-on-surface-variant font-semibold">Topic Tag:</span>
                                        <input class="w-48 px-2 py-1 font-body-sm text-xs rounded-lg bg-surface-container-lowest text-on-surface focus:outline-none focus:ring-1 focus:ring-primary shadow-xs" type="text" name="taxonomyTopic" placeholder="e.g. Consensus Protocols" value="${activeQuestion != null ? activeQuestion.taxonomyTopic : ''}"/>
                                    </div>
                                </div>
                                <div class="flex items-center gap-space-sm">
                                    <span class="font-label-sm text-label-sm text-on-surface-variant font-semibold">Cognitive Depth:</span>
                                    <select name="difficultyLevel" class="px-3 py-1 rounded-full bg-secondary-fixed text-on-secondary-fixed font-label-sm text-label-sm font-bold focus:outline-none cursor-pointer">
                                        <option value="EASY" ${activeQuestion != null && activeQuestion.difficultyLevel == 'EASY' ? 'selected' : ''}>Easy (Knowledge)</option>
                                        <option value="MEDIUM" ${activeQuestion == null || activeQuestion.difficultyLevel == 'MEDIUM' ? 'selected' : ''}>Medium (Application)</option>
                                        <option value="HARD" ${activeQuestion != null && activeQuestion.difficultyLevel == 'HARD' ? 'selected' : ''}>Hard (Synthesis)</option>
                                    </select>
                                </div>
                            </div>

                            <!-- Rich Text / KaTeX Formatting Toolbar -->
                            <div class="px-space-md py-space-xs bg-surface-container flex flex-wrap items-center gap-1 text-on-surface-variant border-b border-surface-container-high">
                                <button class="p-1.5 rounded hover:bg-surface-container-highest transition-colors" title="Bold" type="button" onclick="insertSyntax('**', '**')"><span class="material-symbols-outlined text-[18px]">format_bold</span></button>
                                <button class="p-1.5 rounded hover:bg-surface-container-highest transition-colors" title="Italic" type="button" onclick="insertSyntax('*', '*')"><span class="material-symbols-outlined text-[18px]">format_italic</span></button>
                                <button class="p-1.5 rounded hover:bg-surface-container-highest transition-colors" title="Code Format" type="button" onclick="insertSyntax('`', '`')"><span class="material-symbols-outlined text-[18px]">code</span></button>
                                <div class="h-4 w-px bg-outline-variant mx-1"></div>
                                <button class="p-1.5 rounded hover:bg-surface-container-highest transition-colors text-primary" title="Insert LaTeX / Math" type="button" onclick="insertSyntax('$', '$')"><span class="material-symbols-outlined text-[18px]">functions</span></button>
                                <button class="p-1.5 rounded hover:bg-surface-container-highest transition-colors" title="Attach Architecture Diagram" type="button" onclick="alert('Diagram attachment initialized.')"><span class="material-symbols-outlined text-[18px]">image</span></button>
                                <div class="h-4 w-px bg-outline-variant mx-1"></div>
                                <span class="font-code-telemetry text-[11px] text-on-surface-variant ml-auto font-medium">Markdown &amp; KaTeX Supported</span>
                            </div>

                            <!-- Question Prompt Area -->
                            <div class="p-space-md flex flex-col gap-space-sm">
                                <label class="font-label-sm text-label-sm text-on-surface-variant uppercase tracking-wider font-semibold" for="questionPromptArea">Problem Statement / Question Prompt *</label>
                                <textarea id="questionPromptArea" name="questionText" required rows="3" placeholder="Enter question statement or problem description..." class="w-full p-space-md bg-surface-container-low rounded-xl font-body-md text-body-md text-on-surface focus:bg-surface-container-lowest focus:ring-2 focus:ring-primary focus:outline-none transition-all shadow-inner leading-relaxed resize-none"><c:out value="${activeQuestion != null ? activeQuestion.questionText : ''}"/></textarea>
                                
                                <!-- Code Context Snippet (Optional) -->
                                <div class="p-space-sm rounded-lg bg-surface-container text-on-surface font-code-telemetry text-code-telemetry flex items-center gap-2">
                                    <span class="material-symbols-outlined text-[16px] text-outline">terminal</span>
                                    <input type="text" name="codeSnippet" placeholder="Optional code snippet or algorithm invariant (e.g. votes_received > floor(N / 2))" value="${activeQuestion != null ? activeQuestion.codeSnippet : ''}" class="bg-transparent w-full text-xs font-mono text-on-surface focus:outline-none"/>
                                </div>
                            </div>

                            <!-- Interactive Options Builder -->
                            <div class="px-space-md pb-space-md flex flex-col gap-space-sm">
                                <div class="flex items-center justify-between">
                                    <span id="optionsHintText" class="font-label-sm text-label-sm text-on-surface-variant uppercase tracking-wider font-semibold">
                                        <c:choose>
                                            <c:when test="${activeQuestion != null && activeQuestion.questionType == 'TRUE_FALSE'}">
                                                Answer Choices (True / False - Radio indicates correct answer)
                                            </c:when>
                                            <c:when test="${activeQuestion != null && activeQuestion.questionType == 'MULTI_CHOICE'}">
                                                Answer Choices (Checkboxes indicate all correct solutions - Multi-Select)
                                            </c:when>
                                            <c:otherwise>
                                                Answer Choices (Radio indicates single correct solution)
                                            </c:otherwise>
                                        </c:choose>
                                    </span>
                                    <button type="button" id="addOptionBtn" onclick="addOption()" class="font-label-sm text-label-sm text-primary font-bold hover:underline flex items-center gap-1 ${activeQuestion != null && activeQuestion.questionType == 'TRUE_FALSE' ? 'hidden' : ''}">
                                        <span class="material-symbols-outlined text-[16px]">add_circle</span>
                                        <span>Add Option</span>
                                    </button>
                                </div>

                                <!-- Dynamic Options Loop -->
                                <div class="flex flex-col gap-2.5" id="optionsContainer">
                                    <c:set var="letters" value="${['A', 'B', 'C', 'D', 'E', 'F']}"/>
                                    <c:set var="isTf" value="${activeQuestion != null && activeQuestion.questionType == 'TRUE_FALSE'}"/>
                                    <c:set var="isMulti" value="${activeQuestion != null && activeQuestion.questionType == 'MULTI_CHOICE'}"/>

                                    <c:forEach var="letter" items="${letters}" varStatus="status">
                                        <c:set var="currentOptText" value=""/>
                                        <c:set var="currentOptCorrect" value="false"/>
                                        <c:set var="optExists" value="false"/>

                                        <c:if test="${activeQuestion != null && activeQuestion.options != null}">
                                            <c:forEach var="opt" items="${activeQuestion.options}">
                                                <c:if test="${opt.optionLetter == letter}">
                                                    <c:set var="currentOptText" value="${opt.optionText}"/>
                                                    <c:set var="currentOptCorrect" value="${opt.correct}"/>
                                                    <c:set var="optExists" value="true"/>
                                                </c:if>
                                            </c:forEach>
                                        </c:if>

                                        <c:if test="${not optExists && (activeQuestion == null || activeQuestion.questionId == 0)}">
                                            <c:if test="${isTf}">
                                                <c:if test="${letter == 'A'}"><c:set var="currentOptText" value="True"/><c:set var="currentOptCorrect" value="true"/></c:if>
                                                <c:if test="${letter == 'B'}"><c:set var="currentOptText" value="False"/></c:if>
                                            </c:if>
                                            <c:if test="${not isTf}">
                                                <c:if test="${letter == 'A'}"><c:set var="currentOptCorrect" value="true"/></c:if>
                                            </c:if>
                                        </c:if>

                                        <c:set var="isRowHidden" value="false"/>
                                        <c:choose>
                                            <c:when test="${isTf}">
                                                <c:set var="isRowHidden" value="${letter != 'A' && letter != 'B'}"/>
                                            </c:when>
                                            <c:otherwise>
                                                <c:set var="isRowHidden" value="${(letter == 'E' || letter == 'F') && empty currentOptText}"/>
                                            </c:otherwise>
                                        </c:choose>

                                        <!-- Option Row -->
                                        <div data-letter="${letter}" class="option-row p-space-sm rounded-xl ${currentOptCorrect ? 'bg-surface-container-high border border-primary/20 shadow-xs' : 'bg-surface-container-low'} flex flex-col gap-space-xs transition-all hover:bg-surface-container ${isRowHidden ? 'hidden' : ''}">
                                            <div class="flex items-center gap-space-sm">
                                                <span class="material-symbols-outlined text-outline cursor-grab text-[20px]">drag_indicator</span>
                                                <input class="option-correct-input h-4 w-4 accent-primary cursor-pointer" 
                                                       name="correctOption" 
                                                       type="${isMulti ? 'checkbox' : 'radio'}" 
                                                       value="${letter}" 
                                                       ${currentOptCorrect ? 'checked' : ''}/>
                                                <span class="font-bold ${currentOptCorrect ? 'text-primary' : 'text-on-surface'} w-6">${letter}.</span>
                                                <input class="option-text-input flex-1 bg-surface-container-lowest px-space-sm py-1.5 rounded-lg font-body-md text-body-md text-on-surface focus:outline-none focus:ring-1 focus:ring-primary shadow-xs" 
                                                       type="text" 
                                                       name="optionText_${letter}" 
                                                       value="<c:out value='${currentOptText}'/>" 
                                                       placeholder="Enter choice text for option ${letter}..."
                                                       ${isTf ? 'readonly' : ''}/>
                                                <c:if test="${letter != 'A' && letter != 'B'}">
                                                    <button type="button" onclick="removeOption('${letter}')" class="text-on-surface-variant hover:text-error p-1 rounded" title="Remove option">
                                                        <span class="material-symbols-outlined text-[18px]">close</span>
                                                    </button>
                                                </c:if>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </div>

                                <!-- Rationale / Explanation Field -->
                                <div class="mt-2 p-space-sm rounded-xl bg-surface-container-low flex items-start gap-space-sm">
                                    <span class="material-symbols-outlined text-[18px] text-primary shrink-0 mt-0.5">lightbulb</span>
                                    <div class="flex flex-col w-full gap-1">
                                        <span class="text-xs font-bold uppercase tracking-wider text-on-surface-variant">Explanation &amp; Correct Solution Rationale</span>
                                        <input class="w-full text-on-surface bg-transparent font-body-sm text-body-sm focus:outline-none focus:ring-1 focus:ring-primary rounded p-1" 
                                               type="text" 
                                               name="explanation" 
                                               placeholder="Provide explanation displayed to students on score publication..." 
                                               value="<c:out value='${activeQuestion != null ? activeQuestion.explanation : \"\"}'/>"/>
                                    </div>
                                </div>
                            </div>

                            <!-- Question Card Action Footer -->
                            <div class="p-space-md bg-surface-container-low flex flex-wrap items-center justify-between gap-space-sm border-t border-surface-container-high">
                                <div class="flex items-center gap-space-xs">
                                    <c:if test="${activeQuestion != null && activeQuestion.questionId > 0}">
                                        <button class="px-space-md py-2 rounded-lg bg-surface-container-lowest text-on-surface shadow-xs hover:bg-surface-container transition-colors font-label-md text-label-md flex items-center gap-1.5" type="submit" onclick="document.querySelector('#questionBuilderForm input[name=action]').value='duplicate_question';">
                                            <span class="material-symbols-outlined text-[18px] text-secondary">content_copy</span>
                                            <span>Duplicate Question</span>
                                        </button>
                                        <button class="px-space-md py-2 rounded-lg text-error hover:bg-error-container transition-colors font-label-md text-label-md flex items-center gap-1.5" type="submit" onclick="if(confirm('Remove this question from examination?')){document.querySelector('#questionBuilderForm input[name=action]').value='delete_question';}else{return false;}">
                                            <span class="material-symbols-outlined text-[18px]">delete</span>
                                            <span>Remove</span>
                                        </button>
                                    </c:if>
                                </div>
                                <div class="flex items-center gap-space-sm">
                                    <a href="${pageContext.request.contextPath}/teacher/quiz/builder?quizId=${quiz.quizId}&activeQuestionId=0" class="px-space-md py-2 rounded-lg bg-surface-container text-on-surface hover:bg-surface-container-high transition-colors font-label-md text-label-md font-semibold">
                                        + New Blank Item
                                    </a>
                                    <button class="px-space-md py-2 rounded-lg bg-primary text-on-primary hover:bg-primary-container transition-colors font-label-md text-label-md font-bold shadow-sm flex items-center gap-1.5" type="submit">
                                        <span>Save Question</span>
                                        <span class="material-symbols-outlined text-[18px]">arrow_forward</span>
                                    </button>
                                </div>
                            </div>
                        </form>

                        <!-- Question Bank Inline Browser / Slide Widget -->
                        <div class="bg-surface-container-lowest rounded-2xl shadow-sm border border-surface-container-high overflow-hidden" id="bankContainer">
                            <div class="p-space-md bg-surface-container flex flex-wrap items-center justify-between gap-space-sm border-b border-surface-container-high">
                                <div class="flex items-center gap-space-sm">
                                    <div class="h-9 w-9 rounded-xl bg-primary text-on-primary flex items-center justify-center shadow-sm">
                                        <span class="material-symbols-outlined text-[20px]">account_balance</span>
                                    </div>
                                    <div>
                                        <span class="font-title-md text-title-md font-bold text-on-surface">Departmental Item Bank: <c:out value="${quiz.subjectCode}"/> Repository</span>
                                        <p class="font-label-sm text-label-sm text-on-surface-variant">Access peer-reviewed questions with calibrated empirical difficulty</p>
                                    </div>
                                </div>
                                <div class="flex items-center gap-space-xs">
                                    <span class="px-space-sm py-1 rounded-full bg-surface-container-high text-primary font-code-telemetry text-code-telemetry font-bold">
                                        Showing <c:out value="${bankQuestions.size()}"/> Available Items
                                    </span>
                                </div>
                            </div>

                            <!-- Filter Bar -->
                            <form action="${pageContext.request.contextPath}/teacher/quiz/builder#bankContainer" method="GET" class="p-space-md bg-surface-container-low flex flex-wrap items-center gap-space-sm border-b border-surface-container-high">
                                <input type="hidden" name="quizId" value="${quiz.quizId}"/>
                                <div class="flex-1 min-w-[200px] relative">
                                    <span class="material-symbols-outlined absolute left-3 top-2 text-on-surface-variant text-[18px]">search</span>
                                    <input name="bankSearch" class="w-full pl-9 pr-space-md py-1.5 rounded-lg bg-surface-container-lowest text-on-surface font-body-sm text-body-sm focus:outline-none focus:ring-1 focus:ring-primary shadow-xs" placeholder="Search by topic, keyword, or concept (e.g., Paxos, Commit, Byzantine)..." type="text" value="${param.bankSearch}"/>
                                </div>
                                <select name="bankDifficulty" class="px-space-sm py-1.5 rounded-lg bg-surface-container-lowest text-on-surface font-body-sm text-body-sm focus:outline-none shadow-xs font-semibold">
                                    <option value="ALL">All Difficulties</option>
                                    <option value="EASY" ${param.bankDifficulty == 'EASY' ? 'selected' : ''}>Easy (>80% Pass)</option>
                                    <option value="MEDIUM" ${param.bankDifficulty == 'MEDIUM' ? 'selected' : ''}>Medium (50-80% Pass)</option>
                                    <option value="HARD" ${param.bankDifficulty == 'HARD' ? 'selected' : ''}>Hard (<50% Pass)</option>
                                </select>
                                <button class="px-space-md py-1.5 rounded-lg bg-primary-container text-on-primary font-label-md text-label-md font-bold" type="submit">
                                    Filter Results
                                </button>
                            </form>

                            <!-- Question Bank Items List -->
                            <div class="divide-y divide-surface-container-high">
                                <c:forEach var="bankItem" items="${bankQuestions}">
                                    <div class="p-space-md flex flex-col md:flex-row md:items-center justify-between gap-space-md hover:bg-surface-container-low transition-colors">
                                        <div class="flex flex-col gap-1 min-w-0 flex-1">
                                            <div class="flex items-center gap-2 flex-wrap">
                                                <span class="px-2 py-0.5 rounded bg-surface-container-high text-on-surface font-code-telemetry text-[11px] font-bold">
                                                    CS402-QB-<c:out value="${bankItem.questionId + 880}"/>
                                                </span>
                                                <span class="font-label-sm text-label-sm text-on-surface-variant font-semibold">• <c:out value="${bankItem.taxonomyTopic}"/></span>
                                                <span class="px-2 py-0.5 rounded-full ${bankItem.difficultyLevel == 'HARD' ? 'bg-error-container text-on-error-container' : (bankItem.difficultyLevel == 'EASY' ? 'bg-tertiary-fixed text-on-tertiary-fixed' : 'bg-secondary-fixed text-on-secondary-fixed')} font-label-sm text-[11px] font-bold">
                                                    <c:out value="${bankItem.difficultyLevel}"/>
                                                </span>
                                                <span class="font-label-sm text-label-sm text-tertiary flex items-center gap-1 font-medium">
                                                    <span class="material-symbols-outlined text-[14px]">history</span> Peer Reviewed (<c:out value="${bankItem.points}"/> pts)
                                                </span>
                                            </div>
                                            <p class="font-body-md text-body-md text-on-surface font-medium mt-1 leading-snug">
                                                <c:out value="${bankItem.questionText}"/>
                                            </p>
                                        </div>

                                        <form action="${pageContext.request.contextPath}/teacher/quiz/builder" method="POST" class="shrink-0">
                                            <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}"/>
                                            <input type="hidden" name="action" value="add_from_bank"/>
                                            <input type="hidden" name="quizId" value="${quiz.quizId}"/>
                                            <input type="hidden" name="questionId" value="${bankItem.questionId}"/>
                                            <button class="inline-flex items-center gap-1 px-space-md py-1.5 rounded-lg bg-surface-container-high text-primary hover:bg-primary hover:text-on-primary transition-colors font-label-md text-label-md font-bold" type="submit">
                                                <span class="material-symbols-outlined text-[16px]">add</span>
                                                <span>Add to Exam</span>
                                            </button>
                                        </form>
                                    </div>
                                </c:forEach>
                            </div>
                        </div>

                    </div>

                    <!-- RIGHT / SIDEBAR INSPECTOR (lg:col-span-4) -->
                    <div class="lg:col-span-4 flex flex-col gap-gutter">
                        
                        <!-- Live Scoring & Mark Breakdown Card -->
                        <div class="bg-surface-container-lowest rounded-2xl shadow-sm border border-surface-container-high p-space-md flex flex-col gap-space-md">
                            <div class="flex items-center justify-between">
                                <span class="font-title-md text-title-md font-bold text-on-surface">Assessment Balance</span>
                                <span class="px-2.5 py-0.5 rounded-full bg-tertiary text-on-tertiary font-label-sm text-label-sm font-bold">
                                    <fmt:formatNumber value="${allocatedPoints}" maxFractionDigits="0"/> / <fmt:formatNumber value="${quiz.totalMarks}" maxFractionDigits="0"/> Allocated
                                </span>
                            </div>

                            <!-- Metric visual distribution chart (Stacked Bar) -->
                            <div class="p-space-sm rounded-xl bg-surface-container-low flex flex-col gap-space-xs">
                                <div class="flex items-center justify-between font-label-sm text-label-sm text-on-surface-variant font-medium">
                                    <span>Item Type Proportions</span>
                                    <span class="font-code-telemetry text-on-surface font-bold"><c:out value="${quizQuestions.size()}"/> Total</span>
                                </div>
                                <div class="h-3 w-full rounded-full bg-surface-container flex overflow-hidden">
                                    <c:set var="totalQ" value="${quizQuestions.size() > 0 ? quizQuestions.size() : 1}"/>
                                    <div class="h-full bg-primary" style="width: ${(mcqCount * 100) / totalQ}%;" title="${mcqCount} Single MCQs"></div>
                                    <div class="h-full bg-secondary" style="width: ${(multiCount * 100) / totalQ}%;" title="${multiCount} Multi-Select"></div>
                                    <div class="h-full bg-tertiary" style="width: ${(tfCount * 100) / totalQ}%;" title="${tfCount} True/False"></div>
                                </div>
                                <div class="flex items-center justify-between text-[11px] font-label-sm text-on-surface-variant pt-1 font-semibold">
                                    <span class="flex items-center gap-1"><span class="h-2 w-2 rounded-full bg-primary"></span> <c:out value="${mcqCount}"/> MCQs</span>
                                    <span class="flex items-center gap-1"><span class="h-2 w-2 rounded-full bg-secondary"></span> <c:out value="${multiCount}"/> Multi</span>
                                    <span class="flex items-center gap-1"><span class="h-2 w-2 rounded-full bg-tertiary"></span> <c:out value="${tfCount}"/> T/F</span>
                                </div>
                            </div>

                            <!-- Risk Exposure Metric -->
                            <div class="p-space-sm rounded-xl bg-error-container/30 flex items-center justify-between border border-error/20">
                                <div class="flex items-center gap-2">
                                    <span class="material-symbols-outlined text-error text-[20px]">warning</span>
                                    <div class="flex flex-col">
                                        <span class="font-label-sm text-label-sm text-on-surface font-bold">Maximum Risk Drawdown</span>
                                        <span class="font-code-telemetry text-[11px] text-on-surface-variant">If all answered incorrectly</span>
                                    </div>
                                </div>
                                <span class="font-code-telemetry text-title-md font-bold text-error">
                                    -<fmt:formatNumber value="${quiz.negativeMarking ? (quizQuestions.size() * quiz.negativeMarkValue) : 0}" minFractionDigits="2"/>
                                </span>
                            </div>
                        </div>

                        <!-- Question Sequence Navigator / Palette -->
                        <div class="bg-surface-container-lowest rounded-2xl shadow-sm border border-surface-container-high flex flex-col overflow-hidden">
                            <div class="p-space-md bg-surface-container-low flex items-center justify-between border-b border-surface-container-high">
                                <div class="flex items-center gap-space-xs">
                                    <span class="font-title-md text-title-md font-bold text-on-surface">Question Palette</span>
                                    <span class="px-2 py-0.5 rounded bg-surface-container text-on-surface font-code-telemetry text-[11px] font-bold">
                                        <c:out value="${quizQuestions.size()}"/> Total
                                    </span>
                                </div>
                                <div class="flex items-center gap-1">
                                    <a href="${pageContext.request.contextPath}/teacher/quiz/builder?quizId=${quiz.quizId}&activeQuestionId=0" class="px-2 py-1 rounded text-xs flex items-center gap-1 font-bold ${activeQuestion == null || activeQuestion.questionId == 0 ? 'bg-primary text-on-primary shadow-xs' : 'bg-surface-container text-primary hover:bg-surface-container-high'}" title="Add New Question">
                                        <span class="material-symbols-outlined text-[16px]">add</span>
                                        <span>New Item</span>
                                    </a>
                                </div>
                            </div>

                            <!-- Scrollable List of Questions -->
                            <div class="max-h-[380px] overflow-y-auto divide-y divide-surface-container-low p-space-xs">
                                <c:forEach var="qItem" items="${quizQuestions}" varStatus="status">
                                    <c:set var="isActiveItem" value="${activeQuestion != null && qItem.questionId == activeQuestion.questionId}"/>
                                    <a href="${pageContext.request.contextPath}/teacher/quiz/builder?quizId=${quiz.quizId}&activeQuestionId=${qItem.questionId}" 
                                       class="p-space-sm rounded-xl flex items-center justify-between transition-all ${isActiveItem ? 'bg-primary-container text-on-primary shadow-sm font-bold' : 'hover:bg-surface-container-low'}">
                                        <div class="flex items-center gap-2 min-w-0">
                                            <span class="font-code-telemetry text-label-md font-bold ${isActiveItem ? 'text-on-primary' : 'text-on-surface'} w-6">
                                                <fmt:formatNumber value="${status.count}" minIntegerDigits="2"/>
                                            </span>
                                            <span class="px-1.5 py-0.5 rounded ${isActiveItem ? 'bg-on-primary text-primary' : 'bg-surface-container text-on-surface-variant'} text-[11px] font-bold">
                                                <c:choose>
                                                    <c:when test="${qItem.questionType == 'MULTI_CHOICE'}">Multi</c:when>
                                                    <c:when test="${qItem.questionType == 'TRUE_FALSE'}">T/F</c:when>
                                                    <c:otherwise>MCQ</c:otherwise>
                                                </c:choose>
                                            </span>
                                            <span class="font-body-sm text-body-sm truncate max-w-[140px] ${isActiveItem ? 'text-on-primary font-semibold' : 'text-on-surface'}">
                                                <c:out value="${qItem.taxonomyTopic != null ? qItem.taxonomyTopic : qItem.questionText}"/>
                                            </span>
                                        </div>
                                        <div class="flex items-center gap-2 shrink-0">
                                            <span class="font-code-telemetry text-[11px] ${isActiveItem ? 'text-on-primary-container' : 'text-tertiary'} font-bold">
                                                +<fmt:formatNumber value="${qItem.points}" maxFractionDigits="0"/>, -<fmt:formatNumber value="${quiz.negativeMarkValue}" maxFractionDigits="0"/>
                                            </span>
                                            <span class="material-symbols-outlined text-[16px] ${isActiveItem ? 'text-tertiary-fixed-dim' : 'text-tertiary'}">check_circle</span>
                                        </div>
                                    </a>
                                </c:forEach>
                            </div>
                        </div>

                        <!-- Target Cohorts & Security Presets Card -->
                        <div class="bg-surface-container-lowest rounded-2xl shadow-sm border border-surface-container-high p-space-md flex flex-col gap-space-sm">
                            <div class="flex items-center justify-between">
                                <span class="font-title-md text-title-md font-bold text-on-surface">Target Cohorts &amp; Security</span>
                                <span class="material-symbols-outlined text-primary text-[20px]">security</span>
                            </div>
                            <div class="space-y-space-sm pt-1">
                                <div class="p-space-sm rounded-xl bg-surface-container-low flex flex-col gap-1">
                                    <span class="font-label-sm text-label-sm text-on-surface-variant uppercase tracking-wider font-semibold">Assigned Cohort</span>
                                    <div class="flex items-center gap-2 flex-wrap">
                                        <span class="px-2 py-1 rounded-lg bg-surface-container text-on-surface font-body-sm text-body-sm font-semibold">CS402-A (62 Students)</span>
                                        <span class="px-2 py-1 rounded-lg bg-surface-container text-on-surface font-body-sm text-body-sm font-semibold">CS402-B (58 Students)</span>
                                    </div>
                                </div>
                                <div class="p-space-sm rounded-xl bg-surface-container-low flex items-center gap-space-sm">
                                    <span class="material-symbols-outlined text-secondary text-[22px]">calendar_clock</span>
                                    <div class="flex flex-col min-w-0">
                                        <span class="font-label-sm text-label-sm text-on-surface-variant font-semibold">Scheduled Window</span>
                                        <span class="font-body-sm text-body-sm font-semibold text-on-surface">March 24, 2025 • 10:00 - 11:30 AM UTC</span>
                                    </div>
                                </div>
                                <div class="p-space-sm rounded-xl bg-tertiary-container text-on-tertiary flex items-center justify-between">
                                    <div class="flex items-center gap-2">
                                        <span class="material-symbols-outlined text-[20px]">lock</span>
                                        <div class="flex flex-col">
                                            <span class="font-label-sm text-label-sm font-bold">Strict Proctoring Preset</span>
                                            <span class="font-code-telemetry text-[11px] text-on-tertiary-container">Webcam HUD + Screen Lock Active</span>
                                        </div>
                                    </div>
                                    <span class="px-2 py-0.5 rounded bg-surface-container-lowest text-tertiary font-bold text-[11px]">Level 3</span>
                                </div>
                            </div>
                        </div>

                    </div>
                </div>

            </div>
        </main>
    </div>

    <!-- Script for Collapsible & Rich formatting -->
    <script>
        (function () {
            const toggleBtn = document.getElementById('toggleConfigBtn');
            const configBody = document.getElementById('quizConfigBody');
            const toggleText = document.getElementById('configToggleText');
            const toggleIcon = document.getElementById('configToggleIcon');

            if (toggleBtn && configBody) {
                let isCollapsed = false;
                toggleBtn.addEventListener('click', function () {
                    isCollapsed = !isCollapsed;
                    if (isCollapsed) {
                        configBody.classList.add('hidden');
                        toggleText.textContent = 'Show Parameters';
                        toggleIcon.textContent = 'keyboard_arrow_down';
                    } else {
                        configBody.classList.remove('hidden');
                        toggleText.textContent = 'Hide Parameters';
                        toggleIcon.textContent = 'keyboard_arrow_up';
                    }
                });
            }

            const openBankBtn = document.getElementById('openQuestionBankBtn');
            const bankContainer = document.getElementById('bankContainer');
            if (openBankBtn && bankContainer) {
                openBankBtn.addEventListener('click', function () {
                    bankContainer.scrollIntoView({ behavior: 'smooth', block: 'start' });
                });
            }
        })();

        function setQuestionType(type, btn) {
            document.getElementById('questionTypeInput').value = type;
            const buttons = btn.parentElement.querySelectorAll('button');
            buttons.forEach(b => {
                b.className = "px-space-sm py-1 rounded-lg font-label-sm text-label-sm font-bold transition-all text-on-surface-variant hover:bg-surface-container-high";
            });
            btn.className = "px-space-sm py-1 rounded-lg font-label-sm text-label-sm font-bold transition-all bg-primary text-on-primary shadow-sm";

            const optInputs = document.querySelectorAll('.option-correct-input');
            const optRows = document.querySelectorAll('.option-row');
            const addOptBtn = document.getElementById('addOptionBtn');
            const hintText = document.getElementById('optionsHintText');
            const headerTitle = document.getElementById('questionHeaderTitle');

            if (type === 'TRUE_FALSE') {
                optInputs.forEach(i => i.type = 'radio');
                optRows.forEach(row => {
                    const letter = row.dataset.letter;
                    const textInput = row.querySelector('.option-text-input');
                    if (letter === 'A') {
                        row.classList.remove('hidden');
                        textInput.value = 'True';
                        textInput.readOnly = true;
                    } else if (letter === 'B') {
                        row.classList.remove('hidden');
                        textInput.value = 'False';
                        textInput.readOnly = true;
                    } else {
                        row.classList.add('hidden');
                    }
                });
                if (addOptBtn) addOptBtn.classList.add('hidden');
                if (hintText) hintText.textContent = "Answer Choices (True / False - Radio indicates correct answer)";
                if (headerTitle) {
                    const base = headerTitle.textContent.split('(')[0].trim();
                    headerTitle.textContent = base + " (True / False)";
                }
                const anyChecked = Array.from(optInputs).slice(0, 2).some(i => i.checked);
                if (!anyChecked && optInputs.length > 0) optInputs[0].checked = true;
            } else if (type === 'MULTI_CHOICE') {
                optInputs.forEach(i => i.type = 'checkbox');
                optRows.forEach(row => {
                    const letter = row.dataset.letter;
                    const textInput = row.querySelector('.option-text-input');
                    textInput.readOnly = false;
                    if (letter === 'A' || letter === 'B' || letter === 'C' || letter === 'D') {
                        row.classList.remove('hidden');
                    }
                });
                if (addOptBtn) addOptBtn.classList.remove('hidden');
                if (hintText) hintText.textContent = "Answer Choices (Checkboxes indicate all correct solutions - Multi-Select)";
                if (headerTitle) {
                    const base = headerTitle.textContent.split('(')[0].trim();
                    headerTitle.textContent = base + " (Multi-Correct)";
                }
            } else { // SINGLE_CHOICE
                optInputs.forEach(i => i.type = 'radio');
                optRows.forEach(row => {
                    const letter = row.dataset.letter;
                    const textInput = row.querySelector('.option-text-input');
                    textInput.readOnly = false;
                    if (letter === 'A' || letter === 'B' || letter === 'C' || letter === 'D') {
                        row.classList.remove('hidden');
                    }
                });
                if (addOptBtn) addOptBtn.classList.remove('hidden');
                if (hintText) hintText.textContent = "Answer Choices (Radio indicates single correct solution)";
                if (headerTitle) {
                    const base = headerTitle.textContent.split('(')[0].trim();
                    headerTitle.textContent = base + " (Multiple Choice - Single Select)";
                }
                let firstFound = false;
                optInputs.forEach(i => {
                    if (i.checked) {
                        if (!firstFound) firstFound = true;
                        else i.checked = false;
                    }
                });
                if (!firstFound && optInputs.length > 0) optInputs[0].checked = true;
            }
        }

        function addOption() {
            const hiddenRows = document.querySelectorAll('.option-row.hidden');
            if (hiddenRows.length > 0) {
                hiddenRows[0].classList.remove('hidden');
                const input = hiddenRows[0].querySelector('.option-text-input');
                if (input) input.focus();
            }
            const remainingHidden = document.querySelectorAll('.option-row.hidden');
            if (remainingHidden.length === 0) {
                const btn = document.getElementById('addOptionBtn');
                if (btn) btn.classList.add('hidden');
            }
        }

        function removeOption(letter) {
            const row = document.querySelector('.option-row[data-letter="' + letter + '"]');
            if (row) {
                const textInput = row.querySelector('.option-text-input');
                if (textInput) textInput.value = '';
                const checkInput = row.querySelector('.option-correct-input');
                if (checkInput) checkInput.checked = false;
                row.classList.add('hidden');
                const btn = document.getElementById('addOptionBtn');
                if (btn) btn.classList.remove('hidden');
            }
        }

        function insertSyntax(before, after) {
            const area = document.getElementById('questionPromptArea');
            if (!area) return;
            const start = area.selectionStart;
            const end = area.selectionEnd;
            const text = area.value;
            const selected = text.substring(start, end);
            area.value = text.substring(0, start) + before + selected + after + text.substring(end);
            area.focus();
            area.setSelectionRange(start + before.length, end + before.length);
        }
    </script>
</body>
</html>
