<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Quiz Architect &amp; Matrix | QuizTrack Faculty</title>
    
    <!-- Design Fonts & Material Symbols -->
    <link href="https://fonts.googleapis.com" rel="preconnect"/>
    <link crossorigin="" href="https://fonts.gstatic.com" rel="preconnect"/>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=JetBrains+Mono:wght@400;500;600&family=Plus+Jakarta+Sans:wght@600;700;800&display=swap" rel="stylesheet"/>
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200" rel="stylesheet"/>
    
    <!-- Tailwind CSS (CDN Engine) -->
    <script src="https://cdn.tailwindcss.com"></script>
    <script>
        tailwind.config = {
            theme: {
                extend: {
                    colors: {
                        "primary": "#3525cd",
                        "primary-container": "#4f46e5",
                        "on-primary": "#ffffff",
                        "on-primary-container": "#ffffff",
                        "secondary": "#4648d4",
                        "secondary-container": "#e0e0ff",
                        "on-secondary-container": "#02006d",
                        "secondary-fixed": "#e0e0ff",
                        "on-secondary-fixed": "#02006d",
                        "tertiary": "#005338",
                        "tertiary-container": "#006e4b",
                        "on-tertiary": "#ffffff",
                        "on-tertiary-container": "#ffffff",
                        "tertiary-fixed": "#6ffbbe",
                        "on-tertiary-fixed": "#002114",
                        "tertiary-fixed-dim": "#4edea3",
                        "error": "#ba1a1a",
                        "error-container": "#ffdad6",
                        "on-error-container": "#93000a",
                        "surface": "#f8f9ff",
                        "surface-container-lowest": "#ffffff",
                        "surface-container-low": "#eff4ff",
                        "surface-container": "#e5eeff",
                        "surface-container-high": "#dce9ff",
                        "surface-container-highest": "#d3e3ff",
                        "on-surface": "#0b1c30",
                        "on-surface-variant": "#464555",
                        "outline": "#777587",
                        "outline-variant": "#c7c4d8"
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
                                <span>Question Bank Repository</span>
                                <span class="px-1.5 py-0.2 rounded bg-surface-container-highest text-primary font-code-telemetry text-code-telemetry font-bold">
                                    <c:out value="${bankQuestions.size()}"/>+
                                </span>
                            </button>

                            <a href="${pageContext.request.contextPath}/student/quizzes" target="_blank" class="inline-flex items-center gap-space-xs px-space-md py-2 rounded-lg bg-surface-container-lowest text-on-surface shadow-sm border border-surface-container-high hover:bg-surface-container-low transition-colors font-label-md text-label-md font-semibold">
                                <span class="material-symbols-outlined text-[18px] text-secondary">visibility</span>
                                <span>Preview Student View</span>
                            </a>

                            <span class="px-2.5 py-1.5 rounded-full text-xs font-mono font-bold uppercase shadow-xs flex items-center gap-1.5 ${quiz.status == 'ACTIVE' ? 'bg-tertiary-container text-tertiary border border-tertiary/30' : (quiz.status == 'SCHEDULED' ? 'bg-secondary-container text-secondary border border-secondary/30' : (quiz.status == 'COMPLETED' ? 'bg-surface-container-highest text-on-surface border border-outline-variant' : 'bg-surface-container text-on-surface-variant border border-surface-container-high'))}">
                                <span class="h-2 w-2 rounded-full ${quiz.status == 'ACTIVE' ? 'bg-tertiary animate-pulse' : (quiz.status == 'SCHEDULED' ? 'bg-secondary' : 'bg-outline')}"></span>
                                <span><c:out value="${quiz.status}"/></span>
                            </span>

                            <!-- Publish / Status Action Form -->
                            <form action="${pageContext.request.contextPath}/teacher/quiz/builder" method="POST" class="inline">
                                <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}"/>
                                <input type="hidden" name="quizId" value="${quiz.quizId}"/>
                                <c:choose>
                                    <c:when test="${quiz.status == 'ACTIVE' || quiz.status == 'SCHEDULED'}">
                                        <input type="hidden" name="action" value="save_draft"/>
                                        <button type="submit" class="inline-flex items-center gap-space-xs px-space-md py-2 rounded-lg bg-surface-container hover:bg-surface-container-high text-on-surface font-label-md text-label-md font-semibold transition-colors">
                                            <span class="material-symbols-outlined text-[18px]">pause</span>
                                            <span>Revert to Draft</span>
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

                    <!-- Interactive Top Stepper Navigation (Tabs) -->
                    <div class="mt-space-lg pt-space-sm">
                        <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-space-sm">
                            <!-- Step 1: Info & Create Form link -->
                            <a href="${pageContext.request.contextPath}/teacher/quiz/create" class="flex items-center gap-space-sm p-space-sm rounded-xl bg-surface-container-low hover:bg-surface-container transition-all cursor-pointer">
                                <div class="h-8 w-8 rounded-full bg-tertiary-container text-on-tertiary flex items-center justify-center font-bold text-[13px]">
                                    <span class="material-symbols-outlined text-[16px]">check</span>
                                </div>
                                <div class="flex flex-col min-w-0">
                                    <span class="font-label-sm text-label-sm text-on-surface-variant uppercase tracking-wider font-semibold">Step 1 • Completed</span>
                                    <span class="font-title-md text-title-md text-on-surface font-semibold truncate">Basic Info &amp; Setup</span>
                                </div>
                            </a>

                            <!-- Step 2: Question Builder & Bank (Tab Button) -->
                            <button type="button" id="stepper-btn-questions" onclick="switchBuilderTab('questions')" class="stepper-tab-btn text-left flex items-center gap-space-sm p-space-sm rounded-xl transition-all ${empty activeTab || activeTab == 'questions' ? 'bg-primary-container text-on-primary shadow-sm' : 'bg-surface-container-low hover:bg-surface-container text-on-surface'} cursor-pointer">
                                <div class="stepper-num h-8 w-8 rounded-full ${empty activeTab || activeTab == 'questions' ? 'bg-on-primary text-primary' : 'bg-surface-container-high text-on-surface-variant'} flex items-center justify-center font-bold text-[13px]">
                                    2
                                </div>
                                <div class="flex flex-col min-w-0">
                                    <span class="stepper-status font-label-sm text-label-sm uppercase tracking-wider font-bold ${empty activeTab || activeTab == 'questions' ? 'text-on-primary-container' : 'text-on-surface-variant'}">Step 2 • Active</span>
                                    <span class="stepper-title font-title-md text-title-md font-bold truncate">Question Builder &amp; Bank</span>
                                </div>
                            </button>

                            <!-- Step 3: Settings & Parameters (Tab Button) -->
                            <button type="button" id="stepper-btn-settings" onclick="switchBuilderTab('settings')" class="stepper-tab-btn text-left flex items-center gap-space-sm p-space-sm rounded-xl transition-all ${activeTab == 'settings' ? 'bg-primary-container text-on-primary shadow-sm' : 'bg-surface-container-low hover:bg-surface-container text-on-surface'} cursor-pointer">
                                <div class="stepper-num h-8 w-8 rounded-full ${activeTab == 'settings' ? 'bg-on-primary text-primary' : 'bg-tertiary-container text-on-tertiary'} flex items-center justify-center font-bold text-[13px]">
                                    <c:choose>
                                        <c:when test="${activeTab == 'settings'}">3</c:when>
                                        <c:otherwise><span class="material-symbols-outlined text-[16px]">check</span></c:otherwise>
                                    </c:choose>
                                </div>
                                <div class="flex flex-col min-w-0">
                                    <span class="stepper-status font-label-sm text-label-sm uppercase tracking-wider font-semibold ${activeTab == 'settings' ? 'text-on-primary-container' : 'text-on-surface-variant'}">Step 3 • Parameters</span>
                                    <span class="stepper-title font-title-md text-title-md font-semibold truncate">Settings &amp; Parameters</span>
                                </div>
                            </button>

                            <!-- Step 4: Publish & Cohorts (Tab Button) -->
                            <button type="button" id="stepper-btn-publish" onclick="switchBuilderTab('publish')" class="stepper-tab-btn text-left flex items-center gap-space-sm p-space-sm rounded-xl transition-all ${activeTab == 'publish' ? 'bg-primary-container text-on-primary shadow-sm' : 'bg-surface-container-low hover:bg-surface-container text-on-surface'} cursor-pointer">
                                <div class="stepper-num h-8 w-8 rounded-full ${activeTab == 'publish' ? 'bg-on-primary text-primary' : (quiz.status == 'ACTIVE' || quiz.status == 'SCHEDULED' ? 'bg-tertiary-container text-on-tertiary' : 'bg-surface-container-high text-on-surface-variant')} flex items-center justify-center font-bold text-[13px]">
                                    <c:choose>
                                        <c:when test="${activeTab == 'publish'}">4</c:when>
                                        <c:when test="${quiz.status == 'ACTIVE' || quiz.status == 'SCHEDULED'}">
                                            <span class="material-symbols-outlined text-[16px]">check</span>
                                        </c:when>
                                        <c:otherwise>4</c:otherwise>
                                    </c:choose>
                                </div>
                                <div class="flex flex-col min-w-0">
                                    <span class="stepper-status font-label-sm text-label-sm uppercase tracking-wider font-semibold ${activeTab == 'publish' ? 'text-on-primary-container' : 'text-on-surface-variant'}">Step 4 • <c:out value="${quiz.status == 'ACTIVE' ? 'Published' : (quiz.status == 'SCHEDULED' ? 'Scheduled' : 'Draft')}"/></span>
                                    <span class="stepper-title font-title-md text-title-md font-semibold truncate">Publish &amp; Cohorts</span>
                                </div>
                            </button>
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

                <!-- ============================================================== -->
                <!-- TAB 2: STEP 2 • QUESTION BUILDER & BANK                        -->
                <!-- ============================================================== -->
                <div id="view-tab-questions" class="builder-view-tab ${empty activeTab || activeTab == 'questions' ? '' : 'hidden'} p-4 sm:p-gutter grid grid-cols-1 lg:grid-cols-12 gap-gutter items-start max-w-[1600px] mx-auto w-full">
                    
                    <!-- Left Region: Builder Form & Item Bank (lg:col-span-8) -->
                    <div class="lg:col-span-8 flex flex-col gap-gutter">
                        
                        <!-- Quick Examination Header Strip -->
                        <div class="p-space-md rounded-2xl bg-surface-container-lowest border border-surface-container-high shadow-xs flex flex-wrap items-center justify-between gap-space-sm">
                            <div class="flex items-center gap-space-sm min-w-0">
                                <span class="material-symbols-outlined text-primary text-[24px]">tune</span>
                                <div class="flex flex-col min-w-0">
                                    <div class="flex items-center gap-space-xs">
                                        <span class="font-headline-sm text-base sm:text-lg font-bold text-on-surface truncate">
                                            <c:out value="${quiz.title}"/>
                                        </span>
                                        <span class="material-symbols-outlined text-[18px] text-tertiary">verified</span>
                                    </div>
                                    <span class="font-label-sm text-xs text-on-surface-variant font-medium">
                                        <c:out value="${quiz.subjectCode}"/> • Duration: <c:out value="${quiz.durationMinutes}"/>m • Entry Window: <c:out value="${quiz.formattedScheduleWindow}"/>
                                    </span>
                                </div>
                            </div>
                            <button type="button" onclick="switchBuilderTab('settings')" class="flex items-center gap-1.5 px-3 py-1.5 rounded-lg bg-surface-container hover:bg-surface-container-high text-primary font-label-md text-xs font-bold transition-all shadow-xs">
                                <span class="material-symbols-outlined text-[16px]">edit</span>
                                <span>Edit Parameters (Step 3)</span>
                            </button>
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
                                            <span class="px-2 py-0.5 rounded-full ${activeQuestion != null && activeQuestion.questionId > 0 ? 'bg-surface-container-high text-primary' : 'bg-primary-container text-on-primary'} font-label-sm text-label-sm font-bold">
                                                <c:out value="${activeQuestion != null && activeQuestion.questionId > 0 ? 'Editing Active' : 'Drafting Question #'.concat(qIndex)}"/>
                                            </span>
                                        </div>
                                        <p class="font-label-sm text-label-sm text-on-surface-variant">
                                            Tagged: <c:out value="${activeQuestion != null && not empty activeQuestion.taxonomyTopic ? activeQuestion.taxonomyTopic : 'General Concept'}"/>
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

                            <!-- Rich Text Toolbar -->
                            <div class="px-space-md py-space-xs bg-surface-container flex flex-wrap items-center gap-1 text-on-surface-variant border-b border-surface-container-high">
                                <button class="p-1.5 rounded hover:bg-surface-container-highest transition-colors" title="Bold" type="button" onclick="insertSyntax('**', '**')"><span class="material-symbols-outlined text-[18px]">format_bold</span></button>
                                <button class="p-1.5 rounded hover:bg-surface-container-highest transition-colors" title="Italic" type="button" onclick="insertSyntax('*', '*')"><span class="material-symbols-outlined text-[18px]">format_italic</span></button>
                                <button class="p-1.5 rounded hover:bg-surface-container-highest transition-colors" title="Code Format" type="button" onclick="insertSyntax('`', '`')"><span class="material-symbols-outlined text-[18px]">code</span></button>
                                <div class="h-4 w-px bg-outline-variant mx-1"></div>
                                <button class="p-1.5 rounded hover:bg-surface-container-highest transition-colors text-primary" title="Insert LaTeX / Math" type="button" onclick="insertSyntax('$', '$')"><span class="material-symbols-outlined text-[18px]">functions</span></button>
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
                                    <span class="font-code-telemetry text-code-telemetry text-primary font-bold">Options Matrix</span>
                                </div>

                                <div id="optionsContainer" class="flex flex-col gap-space-sm">
                                    <c:set var="alphabet" value="A,B,C,D,E,F"/>
                                    <c:forEach var="letter" items="${alphabet}" varStatus="loop">
                                        <c:set var="opt" value="${null}"/>
                                        <c:if test="${activeQuestion != null && not empty activeQuestion.options}">
                                            <c:forEach var="o" items="${activeQuestion.options}">
                                                <c:if test="${o.optionLetter == letter}">
                                                    <c:set var="opt" value="${o}"/>
                                                </c:if>
                                            </c:forEach>
                                        </c:if>

                                        <c:set var="isRowVisible" value="${loop.index < 4 || (opt != null && not empty opt.optionText)}"/>
                                        <div class="option-row flex items-center gap-space-sm p-space-sm rounded-xl border border-surface-container bg-surface-container-low transition-all ${isRowVisible ? '' : 'hidden'}" data-letter="${letter}">
                                            <span class="material-symbols-outlined text-outline cursor-grab text-[18px]">drag_indicator</span>
                                            
                                            <!-- Correct Selection Input -->
                                            <input type="${activeQuestion != null && activeQuestion.questionType == 'MULTI_CHOICE' ? 'checkbox' : 'radio'}" 
                                                   name="${activeQuestion != null && activeQuestion.questionType == 'MULTI_CHOICE' ? 'correctOption_'.concat(letter) : 'correctOption'}" 
                                                   value="${letter}" 
                                                   ${opt != null && opt.isCorrect ? 'checked' : (activeQuestion == null && loop.index == 0 ? 'checked' : '')} 
                                                   class="option-correct-input h-4 w-4 accent-primary cursor-pointer"/>
                                            
                                            <span class="font-code-telemetry font-bold text-on-surface text-sm w-4"><c:out value="${letter}."/></span>
                                            
                                            <input type="text" 
                                                   name="optionText_${letter}" 
                                                   value="<c:out value='${opt != null ? opt.optionText : \"\"}'/>" 
                                                   placeholder="Option text statement..." 
                                                   ${activeQuestion != null && activeQuestion.questionType == 'TRUE_FALSE' ? 'readonly' : ''} 
                                                   class="option-text-input flex-1 px-3 py-1.5 rounded-lg bg-surface-container-lowest text-on-surface font-body-md text-sm focus:outline-none focus:ring-1 focus:ring-primary shadow-xs"/>
                                            
                                            <c:if test="${loop.index >= 2}">
                                                <button type="button" onclick="removeOption('${letter}')" class="option-remove-btn text-outline hover:text-error transition-colors p-1" title="Remove choice">
                                                    <span class="material-symbols-outlined text-[18px]">close</span>
                                                </button>
                                            </c:if>
                                        </div>
                                    </c:forEach>
                                </div>

                                <div class="pt-1 flex items-center justify-between">
                                    <button type="button" id="addOptionBtn" onclick="addOption()" class="inline-flex items-center gap-1 text-xs font-bold text-primary hover:underline">
                                        <span class="material-symbols-outlined text-[16px]">add</span>
                                        <span>Add Another Choice Option</span>
                                    </button>
                                    <span class="text-xs text-on-surface-variant font-mono">Max 6 choices supported</span>
                                </div>

                                <!-- Explanation & Rationales Area -->
                                <div class="mt-2 p-space-sm rounded-xl bg-surface-container flex flex-col gap-1 border border-surface-container-high">
                                    <span class="font-label-sm text-label-sm text-on-surface-variant font-bold uppercase tracking-wider flex items-center gap-1.5">
                                        <span class="material-symbols-outlined text-[16px] text-primary">lightbulb</span>
                                        Explanation &amp; Correct Solution Rationale
                                    </span>
                                    <input class="w-full px-3 py-1.5 rounded-lg bg-surface-container-lowest text-on-surface font-body-sm text-body-sm focus:outline-none focus:ring-1 focus:ring-primary shadow-xs" 
                                           type="text" 
                                           name="explanation" 
                                           placeholder="Provide explanation displayed to students on score publication..." 
                                           value="<c:out value='${activeQuestion != null ? activeQuestion.explanation : \"\"}'/>"/>
                                </div>
                            </div>

                            <!-- Question Card Action Footer (Progressive Saving) -->
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

                                <div class="flex items-center gap-space-sm flex-wrap">
                                    <c:choose>
                                        <c:when test="${activeQuestion != null && activeQuestion.questionId > 0}">
                                            <a href="${pageContext.request.contextPath}/teacher/quiz/builder?quizId=${quiz.quizId}&activeQuestionId=0&new=true" class="px-space-md py-2 rounded-lg bg-surface-container text-on-surface hover:bg-surface-container-high transition-colors font-label-md text-label-md font-semibold">
                                                + New Blank Item
                                            </a>
                                            <button class="px-space-md py-2 rounded-lg bg-surface-container text-primary hover:bg-surface-container-high transition-colors font-label-md text-label-md font-bold flex items-center gap-1.5 shadow-xs" type="submit" name="saveMode" value="update_stay">
                                                <span class="material-symbols-outlined text-[18px]">save</span>
                                                <span>Update Question</span>
                                            </button>
                                            <button class="px-space-md py-2 rounded-lg bg-primary text-on-primary hover:bg-primary-container transition-colors font-label-md text-label-md font-bold shadow-sm flex items-center gap-1.5" type="submit" name="saveMode" value="save_next">
                                                <span>Save &amp; Next Blank (+)</span>
                                                <span class="material-symbols-outlined text-[18px]">arrow_forward</span>
                                            </button>
                                        </c:when>
                                        <c:otherwise>
                                            <button class="px-space-md py-2 rounded-lg bg-primary text-on-primary hover:bg-primary-container transition-colors font-label-md text-label-md font-bold shadow-sm flex items-center gap-1.5" type="submit" name="saveMode" value="save_next">
                                                <span>Save &amp; Add Next Question</span>
                                                <span class="material-symbols-outlined text-[18px]">arrow_forward</span>
                                            </button>
                                        </c:otherwise>
                                    </c:choose>
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
                                        <span class="font-title-md text-title-md font-bold text-on-surface">Departmental Item Bank: Calibrated Repository</span>
                                        <p class="font-label-sm text-label-sm text-on-surface-variant">Access peer-reviewed questions across all branches with calibrated empirical difficulty</p>
                                    </div>
                                </div>
                                <div class="flex items-center gap-space-xs">
                                    <span class="px-space-sm py-1 rounded-full bg-surface-container-high text-primary font-code-telemetry text-code-telemetry font-bold">
                                        Showing <c:out value="${bankQuestions.size()}"/> Available Items
                                    </span>
                                </div>
                            </div>

                            <!-- Filter Bar with Branch & Difficulty -->
                            <form action="${pageContext.request.contextPath}/teacher/quiz/builder" method="GET" class="p-space-md bg-surface-container-low flex flex-wrap items-center gap-space-sm border-b border-surface-container-high">
                                <input type="hidden" name="quizId" value="${quiz.quizId}"/>
                                <input type="hidden" name="tab" value="questions"/>
                                <div class="flex-1 min-w-[200px] relative">
                                    <span class="material-symbols-outlined absolute left-3 top-2 text-on-surface-variant text-[18px]">search</span>
                                    <input name="bankSearch" class="w-full pl-9 pr-space-md py-1.5 rounded-lg bg-surface-container-lowest text-on-surface font-body-sm text-body-sm focus:outline-none focus:ring-1 focus:ring-primary shadow-xs" placeholder="Search by topic, keyword, or concept (e.g., Paxos, SQL, Math)..." type="text" value="${param.bankSearch}"/>
                                </div>
                                
                                <!-- Discipline / Subject Selector -->
                                <select name="bankSubjectId" class="px-space-sm py-1.5 rounded-lg bg-surface-container-lowest text-on-surface font-body-sm text-body-sm focus:outline-none shadow-xs font-semibold">
                                    <option value="ALL" ${param.bankSubjectId == 'ALL' ? 'selected' : ''}>All Academic Disciplines</option>
                                    <c:forEach items="${subjects}" var="s">
                                        <option value="${s.subjectId}" ${param.bankSubjectId == s.subjectId || (empty param.bankSubjectId && quiz.subjectId == s.subjectId) ? 'selected' : ''}>
                                            <c:out value="${s.subjectCode}"/> - <c:out value="${s.subjectName}"/>
                                        </option>
                                    </c:forEach>
                                </select>

                                <!-- Difficulty Selector -->
                                <select name="bankDifficulty" class="px-space-sm py-1.5 rounded-lg bg-surface-container-lowest text-on-surface font-body-sm text-body-sm focus:outline-none shadow-xs font-semibold">
                                    <option value="ALL">All Difficulties</option>
                                    <option value="EASY" ${param.bankDifficulty == 'EASY' ? 'selected' : ''}>Easy (>80% Pass)</option>
                                    <option value="MEDIUM" ${param.bankDifficulty == 'MEDIUM' ? 'selected' : ''}>Medium (50-80% Pass)</option>
                                    <option value="HARD" ${param.bankDifficulty == 'HARD' ? 'selected' : ''}>Hard (<50% Pass)</option>
                                </select>
                                <button class="px-space-md py-1.5 rounded-lg bg-primary text-on-primary font-label-md text-label-md font-bold hover:bg-primary-container transition-colors shadow-xs" type="submit">
                                    Filter Results
                                </button>
                            </form>

                            <!-- Question Bank Items List with 3 Distinct Actions -->
                            <div class="divide-y divide-surface-container-high">
                                <c:choose>
                                    <c:when test="${not empty bankQuestions}">
                                        <c:forEach var="bankItem" items="${bankQuestions}">
                                            <div class="p-space-md flex flex-col md:flex-row md:items-center justify-between gap-space-md hover:bg-surface-container-low transition-colors">
                                                <div class="flex flex-col gap-1 min-w-0 flex-1">
                                                    <div class="flex items-center gap-2 flex-wrap">
                                                        <span class="px-2 py-0.5 rounded bg-surface-container-high text-on-surface font-code-telemetry text-[11px] font-bold">
                                                            QB-<c:out value="${bankItem.questionId}"/>
                                                        </span>
                                                        <c:if test="${bankItem.inCurrentQuiz || (not empty quizQuestionIds && quizQuestionIds.contains(bankItem.questionId))}">
                                                            <span class="px-2 py-0.5 rounded-full bg-tertiary-fixed text-tertiary font-label-sm text-[11px] font-bold flex items-center gap-1">
                                                                <span class="material-symbols-outlined text-[12px]">check</span> In Exam
                                                            </span>
                                                        </c:if>
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

                                                <!-- The 3 Options: 1. Add, 2. Edit, 3. Remove -->
                                                <div class="flex items-center gap-2 shrink-0 flex-wrap">
                                                    <!-- Option 2: Edit Question in Builder -->
                                                    <a href="${pageContext.request.contextPath}/teacher/quiz/builder?quizId=${quiz.quizId}&activeQuestionId=${bankItem.questionId}&tab=questions" 
                                                       class="inline-flex items-center gap-1 px-3 py-1.5 rounded-lg bg-surface-container text-on-surface hover:bg-surface-container-high transition-colors font-label-md text-xs font-semibold"
                                                       title="Load into Question Builder to edit">
                                                        <span class="material-symbols-outlined text-[16px]">edit</span>
                                                        <span>Edit</span>
                                                    </a>

                                                    <!-- Option 1 & 3: Add to Exam / Remove from Exam -->
                                                    <c:choose>
                                                        <c:when test="${bankItem.inCurrentQuiz || (not empty quizQuestionIds && quizQuestionIds.contains(bankItem.questionId))}">
                                                            <form action="${pageContext.request.contextPath}/teacher/quiz/builder" method="POST" class="inline">
                                                                <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}"/>
                                                                <input type="hidden" name="action" value="remove_from_quiz"/>
                                                                <input type="hidden" name="quizId" value="${quiz.quizId}"/>
                                                                <input type="hidden" name="questionId" value="${bankItem.questionId}"/>
                                                                <button class="inline-flex items-center gap-1 px-3 py-1.5 rounded-lg bg-error-container text-error hover:bg-error hover:text-on-error transition-colors font-label-md text-xs font-bold" type="submit" title="Remove question from examination">
                                                                    <span class="material-symbols-outlined text-[16px]">remove_circle</span>
                                                                    <span>Remove from Exam</span>
                                                                </button>
                                                            </form>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <form action="${pageContext.request.contextPath}/teacher/quiz/builder" method="POST" class="inline">
                                                                <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}"/>
                                                                <input type="hidden" name="action" value="add_from_bank"/>
                                                                <input type="hidden" name="quizId" value="${quiz.quizId}"/>
                                                                <input type="hidden" name="questionId" value="${bankItem.questionId}"/>
                                                                <button class="inline-flex items-center gap-1 px-3 py-1.5 rounded-lg bg-surface-container-high text-primary hover:bg-primary hover:text-on-primary transition-colors font-label-md text-xs font-bold shadow-xs" type="submit" title="Add question to examination">
                                                                    <span class="material-symbols-outlined text-[16px]">add</span>
                                                                    <span>Add to Exam</span>
                                                                </button>
                                                            </form>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </div>
                                            </div>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="p-8 text-center text-on-surface-variant text-sm">
                                            No questions found in this repository branch matching your criteria.
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>

                    </div>

                    <!-- Right Region: Palette & Balance (lg:col-span-4) -->
                    <div class="lg:col-span-4 flex flex-col gap-gutter">
                        
                        <!-- Live Scoring & Mark Breakdown Card -->
                        <div class="bg-surface-container-lowest rounded-2xl shadow-sm border border-surface-container-high p-space-md flex flex-col gap-space-md">
                            <div class="flex items-center justify-between">
                                <span class="font-title-md text-title-md font-bold text-on-surface">Assessment Balance</span>
                                <span class="px-2.5 py-0.5 rounded-full bg-tertiary text-on-tertiary font-label-sm text-label-sm font-bold">
                                    <fmt:formatNumber value="${allocatedPoints}" maxFractionDigits="0"/> / <fmt:formatNumber value="${quiz.totalMarks}" maxFractionDigits="0"/> Allocated
                                </span>
                            </div>

                            <!-- Distribution proportions bar -->
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
                                    <a href="${pageContext.request.contextPath}/teacher/quiz/builder?quizId=${quiz.quizId}&activeQuestionId=0&new=true" class="px-2 py-1 rounded text-xs flex items-center gap-1 font-bold ${activeQuestion == null || activeQuestion.questionId == 0 ? 'bg-primary text-on-primary shadow-xs' : 'bg-surface-container text-primary hover:bg-surface-container-high'}" title="Add New Question">
                                        <span class="material-symbols-outlined text-[16px]">add</span>
                                        <span>New Item</span>
                                    </a>
                                </div>
                            </div>

                            <!-- Scrollable List of Questions -->
                            <div class="max-h-[380px] overflow-y-auto divide-y divide-surface-container-low p-space-xs">
                                <c:choose>
                                    <c:when test="${not empty quizQuestions}">
                                        <c:forEach var="qItem" items="${quizQuestions}" varStatus="status">
                                            <c:set var="isActiveItem" value="${activeQuestion != null && qItem.questionId == activeQuestion.questionId}"/>
                                            <a href="${pageContext.request.contextPath}/teacher/quiz/builder?quizId=${quiz.quizId}&activeQuestionId=${qItem.questionId}&tab=questions" 
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
                                                        <c:out value="${qItem.taxonomyTopic != null && not empty qItem.taxonomyTopic ? qItem.taxonomyTopic : qItem.questionText}"/>
                                                    </span>
                                                </div>
                                                <div class="flex items-center gap-2 shrink-0">
                                                    <span class="font-code-telemetry text-[11px] ${isActiveItem ? 'text-on-primary-container' : 'text-tertiary'} font-bold">
                                                        +<fmt:formatNumber value="${qItem.points}" maxFractionDigits="0"/>
                                                    </span>
                                                    <span class="material-symbols-outlined text-[16px] ${isActiveItem ? 'text-tertiary-fixed-dim' : 'text-tertiary'}">check_circle</span>
                                                </div>
                                            </a>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="p-6 text-center text-xs text-on-surface-variant">
                                            No questions added yet. Use the form above or import from Question Bank!
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>

                    </div>
                </div>

                <!-- ============================================================== -->
                <!-- TAB 3: STEP 3 • SETTINGS & PARAMETERS                          -->
                <!-- ============================================================== -->
                <div id="view-tab-settings" class="builder-view-tab ${activeTab == 'settings' ? '' : 'hidden'} p-4 sm:p-gutter grid grid-cols-1 lg:grid-cols-12 gap-gutter items-start max-w-[1600px] mx-auto w-full">
                    
                    <div class="lg:col-span-8 flex flex-col gap-gutter">
                        <!-- Full Editable Settings Card -->
                        <div class="bg-surface-container-lowest rounded-2xl shadow-sm border border-surface-container-high overflow-hidden">
                            <div class="p-space-md bg-surface-container-low flex items-center justify-between border-b border-surface-container-high">
                                <div class="flex items-center gap-2">
                                    <span class="material-symbols-outlined text-primary text-[24px]">tune</span>
                                    <div>
                                        <span class="font-title-md text-title-md font-bold text-on-surface">Step 3 • Examination Parameters &amp; Security</span>
                                        <p class="text-xs text-on-surface-variant font-medium">Fine-tune duration, passing benchmarks, late-join candidate entry windows, and proctoring locks</p>
                                    </div>
                                </div>
                            </div>

                            <form action="${pageContext.request.contextPath}/teacher/quiz/builder" method="POST" class="p-space-md flex flex-col gap-space-md">
                                <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}"/>
                                <input type="hidden" name="action" value="update_config"/>
                                <input type="hidden" name="quizId" value="${quiz.quizId}"/>

                                <!-- Candidate Attempts Lock Notice -->
                                <c:if test="${quiz.hasActiveOrPastAttempts()}">
                                    <div class="p-space-sm rounded-xl bg-error-container/20 border border-error/30 text-error flex items-center gap-2">
                                        <span class="material-symbols-outlined text-[20px]">lock</span>
                                        <span class="font-body-sm text-xs font-semibold">Examinee submissions or active sessions exist. Core parameters (duration, pass %, negative marking) are locked to maintain assessment integrity.</span>
                                    </div>
                                </c:if>

                                <!-- Title & Description -->
                                <div class="grid grid-cols-1 md:grid-cols-2 gap-space-md">
                                    <div class="flex flex-col gap-1">
                                        <label class="font-label-sm text-label-sm text-on-surface-variant font-bold uppercase tracking-wider" for="cfgTitle">Quiz Title *</label>
                                        <input type="text" id="cfgTitle" name="title" required minlength="3" maxlength="255" value="<c:out value='${quiz.title}'/>" class="px-3 py-2 rounded-xl bg-surface-container-low text-on-surface border border-surface-container-high focus:outline-none focus:ring-1 focus:ring-primary font-body-md text-sm font-semibold"/>
                                    </div>
                                    <div class="flex flex-col gap-1">
                                        <label class="font-label-sm text-label-sm text-on-surface-variant font-bold uppercase tracking-wider" for="cfgDescription">Description</label>
                                        <input type="text" id="cfgDescription" name="description" value="<c:out value='${quiz.description}'/>" placeholder="Examination instructions or scope..." class="px-3 py-2 rounded-xl bg-surface-container-low text-on-surface border border-surface-container-high focus:outline-none focus:ring-1 focus:ring-primary font-body-md text-sm"/>
                                    </div>
                                </div>

                                <!-- Duration, Pass %, Total Marks -->
                                <div class="grid grid-cols-1 sm:grid-cols-3 gap-space-md">
                                    <div class="flex flex-col gap-1">
                                        <label class="font-label-sm text-label-sm text-on-surface-variant font-bold uppercase tracking-wider" for="cfgDuration">Duration (Mins) *</label>
                                        <input type="number" id="cfgDuration" name="durationMinutes" required min="1" max="180" value="${quiz.durationMinutes}" ${quiz.hasActiveOrPastAttempts() ? 'readonly class=\"px-3 py-2 rounded-xl bg-surface-container text-on-surface-variant border border-surface-container-high font-mono text-sm font-bold cursor-not-allowed\"' : 'class=\"px-3 py-2 rounded-xl bg-surface-container-low text-on-surface border border-surface-container-high focus:outline-none focus:ring-1 focus:ring-primary font-mono text-sm font-bold\"'}/>
                                    </div>
                                    <div class="flex flex-col gap-1">
                                        <label class="font-label-sm text-label-sm text-on-surface-variant font-bold uppercase tracking-wider" for="cfgPassPct">Pass Benchmark (%) *</label>
                                        <input type="number" step="0.5" id="cfgPassPct" name="passPercentage" required min="0" max="100" value="${quiz.passPercentage}" ${quiz.hasActiveOrPastAttempts() ? 'readonly class=\"px-3 py-2 rounded-xl bg-surface-container text-on-surface-variant border border-surface-container-high font-mono text-sm font-bold cursor-not-allowed\"' : 'class=\"px-3 py-2 rounded-xl bg-surface-container-low text-on-surface border border-surface-container-high focus:outline-none focus:ring-1 focus:ring-primary font-mono text-sm font-bold\"'}/>
                                    </div>
                                    <div class="flex flex-col gap-1">
                                        <label class="font-label-sm text-label-sm text-on-surface-variant font-bold uppercase tracking-wider" for="cfgTotalMarks">Aggregate Marks</label>
                                        <div class="relative">
                                            <input type="text" id="cfgTotalMarks" readonly value="<fmt:formatNumber value='${quiz.totalMarks}' maxFractionDigits='2'/>" class="w-full px-3 py-2 rounded-xl bg-surface-container text-on-surface-variant border border-surface-container-high font-mono text-sm font-bold cursor-not-allowed"/>
                                            <span class="absolute right-2 top-2 text-[10px] font-mono font-bold text-primary bg-primary/10 px-1.5 py-0.5 rounded">Auto</span>
                                        </div>
                                    </div>
                                </div>

                                <!-- Schedule Entry Window (Opens & Closes) -->
                                <div class="p-space-sm rounded-xl bg-surface-container-low border border-surface-container flex flex-col gap-2">
                                    <span class="font-label-sm text-label-sm text-on-surface-variant font-bold uppercase tracking-wider flex items-center gap-1.5">
                                        <span class="material-symbols-outlined text-[16px] text-primary">calendar_month</span>
                                        Candidate Entry Window (Start &amp; End Cutoff)
                                    </span>
                                    <p class="text-xs text-on-surface-variant">Candidates may only join the examination during this window. Once started, candidate duration countdown runs individually.</p>
                                    <div class="grid grid-cols-1 sm:grid-cols-2 gap-space-md">
                                        <div class="flex flex-col gap-1">
                                            <label class="text-xs font-semibold text-on-surface-variant" for="cfgStartTime">Opens (Start Time)</label>
                                            <input type="datetime-local" id="cfgStartTime" name="startTime" value="${quiz.startTimeIso}" class="px-3 py-2 rounded-xl bg-surface-container-lowest text-on-surface border border-surface-container-high focus:outline-none focus:ring-1 focus:ring-primary font-mono text-xs font-semibold"/>
                                        </div>
                                        <div class="flex flex-col gap-1">
                                            <label class="text-xs font-semibold text-on-surface-variant" for="cfgEndTime">Closes (Entry Cutoff)</label>
                                            <input type="datetime-local" id="cfgEndTime" name="endTime" value="${quiz.endTimeIso}" class="px-3 py-2 rounded-xl bg-surface-container-lowest text-on-surface border border-surface-container-high focus:outline-none focus:ring-1 focus:ring-primary font-mono text-xs font-semibold"/>
                                        </div>
                                    </div>
                                </div>

                                <!-- Negative Marking & Lifecycle Status -->
                                <div class="grid grid-cols-1 md:grid-cols-2 gap-space-md">
                                    <div class="p-space-sm rounded-xl bg-surface-container-low border border-surface-container flex flex-col gap-2">
                                        <label class="flex items-center gap-2 cursor-pointer">
                                            <input type="checkbox" id="cfgNegativeMarking" name="negativeMarking" ${quiz.negativeMarking ? 'checked' : ''} onchange="document.getElementById('cfgNegValRow').style.display = this.checked ? 'flex' : 'none';" class="h-4 w-4 rounded accent-primary cursor-pointer"/>
                                            <span class="text-xs font-bold text-on-surface">Enable Negative Marking Deduction</span>
                                        </label>
                                        <div id="cfgNegValRow" class="items-center gap-2 pt-1" style="${quiz.negativeMarking ? 'display: flex;' : 'display: none;'}">
                                            <span class="text-xs font-semibold text-error">Deduct Pts / Wrong Answer:</span>
                                            <input type="number" step="0.25" min="0" max="10" name="negativeMarkValue" value="${quiz.negativeMarkValue}" class="w-20 px-2 py-1 rounded-lg bg-surface-container-lowest border border-surface-container-high text-xs font-mono font-bold text-error text-center"/>
                                        </div>
                                    </div>

                                    <div class="p-space-sm rounded-xl bg-surface-container-low border border-surface-container flex flex-col gap-2">
                                        <span class="text-xs font-bold text-on-surface">Lifecycle Status</span>
                                        <select name="status" class="px-3 py-1.5 rounded-lg bg-surface-container-lowest text-xs font-mono font-bold uppercase border border-surface-container-high">
                                            <option value="DRAFT" ${quiz.status == 'DRAFT' ? 'selected' : ''}>Draft</option>
                                            <option value="SCHEDULED" ${quiz.status == 'SCHEDULED' ? 'selected' : ''}>Scheduled</option>
                                            <option value="ACTIVE" ${quiz.status == 'ACTIVE' ? 'selected' : ''}>Active</option>
                                            <option value="COMPLETED" ${quiz.status == 'COMPLETED' ? 'selected' : ''}>Completed</option>
                                            <option value="ARCHIVED" ${quiz.status == 'ARCHIVED' ? 'selected' : ''}>Archived</option>
                                        </select>
                                    </div>
                                </div>

                                <!-- Anti-Cheat & Telemetry Presets -->
                                <div class="p-space-sm rounded-xl bg-surface-container-low border border-surface-container flex flex-col gap-2">
                                    <span class="text-xs font-bold uppercase tracking-wider text-on-surface-variant">Anti-Cheat &amp; Telemetry Presets</span>
                                    <div class="grid grid-cols-1 sm:grid-cols-2 gap-2">
                                        <label class="flex items-center gap-2 cursor-pointer">
                                            <input type="checkbox" name="fullscreenRequired" ${quiz.fullscreenRequired ? 'checked' : ''} class="h-4 w-4 rounded accent-primary cursor-pointer"/>
                                            <span class="text-xs font-semibold text-on-surface">Fullscreen Viewport Lock</span>
                                        </label>
                                        <label class="flex items-center gap-2 cursor-pointer">
                                            <input type="checkbox" name="webcamRequired" ${quiz.webcamRequired ? 'checked' : ''} class="h-4 w-4 rounded accent-primary cursor-pointer"/>
                                            <span class="text-xs font-semibold text-on-surface">Webcam &amp; Audio Telemetry</span>
                                        </label>
                                        <label class="flex items-center gap-2 cursor-pointer">
                                            <input type="checkbox" name="shuffleQuestions" ${quiz.shuffleQuestions ? 'checked' : ''} class="h-4 w-4 rounded accent-primary cursor-pointer"/>
                                            <span class="text-xs font-semibold text-on-surface">Shuffle Questions Sequence</span>
                                        </label>
                                        <div class="flex items-center gap-2">
                                            <span class="text-xs font-semibold text-on-surface-variant">Max Tab Switch Strikes:</span>
                                            <select name="maxTabSwitches" class="px-2 py-1 rounded bg-surface-container-lowest text-xs font-mono font-bold border border-surface-container-high">
                                                <option value="1" ${quiz.maxTabSwitches == 1 ? 'selected' : ''}>1 Strike</option>
                                                <option value="2" ${quiz.maxTabSwitches == 2 ? 'selected' : ''}>2 Strikes</option>
                                                <option value="3" ${quiz.maxTabSwitches == 3 ? 'selected' : ''}>3 Strikes</option>
                                                <option value="5" ${quiz.maxTabSwitches == 5 ? 'selected' : ''}>5 Strikes</option>
                                            </select>
                                        </div>
                                    </div>
                                </div>

                                <div class="flex items-center justify-end gap-3 pt-2">
                                    <button type="submit" class="px-6 py-2.5 rounded-xl bg-primary text-on-primary hover:bg-primary-container font-semibold text-sm shadow-sm transition-all flex items-center gap-2">
                                        <span class="material-symbols-outlined text-[18px]">save</span>
                                        <span>Save &amp; Update Parameters</span>
                                    </button>
                                </div>
                            </form>
                        </div>
                    </div>

                    <div class="lg:col-span-4 flex flex-col gap-gutter">
                        <!-- Summary metrics -->
                        <div class="bg-surface-container-lowest rounded-2xl shadow-sm border border-surface-container-high p-space-md flex flex-col gap-3">
                            <span class="font-title-md text-title-md font-bold text-on-surface">Settings Summary</span>
                            <div class="divide-y divide-surface-container-high text-xs">
                                <div class="py-2 flex justify-between">
                                    <span class="text-on-surface-variant">Duration:</span>
                                    <span class="font-bold text-on-surface"><c:out value="${quiz.durationMinutes}"/> Mins</span>
                                </div>
                                <div class="py-2 flex justify-between">
                                    <span class="text-on-surface-variant">Pass Benchmark:</span>
                                    <span class="font-bold text-tertiary"><fmt:formatNumber value="${quiz.passPercentage}" maxFractionDigits="0"/>%</span>
                                </div>
                                <div class="py-2 flex justify-between">
                                    <span class="text-on-surface-variant">Negative Marking:</span>
                                    <span class="font-bold text-error">${quiz.negativeMarking ? '-'.concat(quiz.negativeMarkValue).concat(' pts') : 'Disabled'}</span>
                                </div>
                                <div class="py-2 flex justify-between">
                                    <span class="text-on-surface-variant">Fullscreen Viewport:</span>
                                    <span class="font-bold">${quiz.fullscreenRequired ? 'Active Lock' : 'Off'}</span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- ============================================================== -->
                <!-- TAB 4: STEP 4 • PUBLISH & COHORTS                             -->
                <!-- ============================================================== -->
                <div id="view-tab-publish" class="builder-view-tab ${activeTab == 'publish' ? '' : 'hidden'} p-4 sm:p-gutter grid grid-cols-1 lg:grid-cols-12 gap-gutter items-start max-w-[1600px] mx-auto w-full">
                    
                    <div class="lg:col-span-8 flex flex-col gap-gutter">
                        
                        <!-- Publish Readiness & Verification Checklist Card -->
                        <div class="bg-surface-container-lowest rounded-2xl shadow-sm border border-surface-container-high p-space-md flex flex-col gap-space-md">
                            <div class="flex items-center justify-between">
                                <div class="flex items-center gap-2">
                                    <span class="material-symbols-outlined text-primary text-[24px]">verified</span>
                                    <div>
                                        <span class="font-title-md text-title-md font-bold text-on-surface">Step 4 • Publish Readiness Checklist</span>
                                        <p class="text-xs text-on-surface-variant font-medium">System verification of examination questions, allocated scoring, schedule windows, and assigned slates</p>
                                    </div>
                                </div>
                                <span class="px-2.5 py-1 rounded-full text-xs font-mono font-bold uppercase ${quiz.status == 'ACTIVE' ? 'bg-tertiary-container text-tertiary' : (quiz.status == 'SCHEDULED' ? 'bg-secondary-container text-secondary' : 'bg-surface-container text-on-surface-variant')}">
                                    Status: <c:out value="${quiz.status}"/>
                                </span>
                            </div>

                            <!-- Checklist Cards Grid -->
                            <div class="grid grid-cols-1 sm:grid-cols-2 gap-space-sm">
                                <div class="p-3 rounded-xl bg-surface-container-low border border-surface-container-high flex items-center justify-between">
                                    <div class="flex items-center gap-2">
                                        <span class="material-symbols-outlined text-[20px] ${quizQuestions.size() > 0 ? 'text-tertiary' : 'text-error'}">
                                            <c:out value="${quizQuestions.size() > 0 ? 'check_circle' : 'cancel'}"/>
                                        </span>
                                        <span class="text-xs font-semibold text-on-surface">Questions Allocated</span>
                                    </div>
                                    <span class="font-mono font-bold text-xs"><c:out value="${quizQuestions.size()}"/> items</span>
                                </div>

                                <div class="p-3 rounded-xl bg-surface-container-low border border-surface-container-high flex items-center justify-between">
                                    <div class="flex items-center gap-2">
                                        <span class="material-symbols-outlined text-[20px] ${quiz.totalMarks != null && quiz.totalMarks.compareTo(allocatedPoints) == 0 ? 'text-tertiary' : 'text-primary'}">check_circle</span>
                                        <span class="text-xs font-semibold text-on-surface">Total Marks Verified</span>
                                    </div>
                                    <span class="font-mono font-bold text-xs"><fmt:formatNumber value="${quiz.totalMarks}" maxFractionDigits="2"/> pts</span>
                                </div>

                                <div class="p-3 rounded-xl bg-surface-container-low border border-surface-container-high flex items-center justify-between">
                                    <div class="flex items-center gap-2">
                                        <span class="material-symbols-outlined text-[20px] ${not empty assignedSlates ? 'text-tertiary' : 'text-error'}">
                                            <c:out value="${not empty assignedSlates ? 'check_circle' : 'cancel'}"/>
                                        </span>
                                        <span class="text-xs font-semibold text-on-surface">Target Examinees Assigned</span>
                                    </div>
                                    <span class="font-mono font-bold text-xs"><c:out value="${assignedSlates.size()}"/> Targets</span>
                                </div>

                                <div class="p-3 rounded-xl bg-surface-container-low border border-surface-container-high flex items-center justify-between">
                                    <div class="flex items-center gap-2">
                                        <span class="material-symbols-outlined text-[20px] text-tertiary">calendar_clock</span>
                                        <span class="text-xs font-semibold text-on-surface">Entry Schedule Window</span>
                                    </div>
                                    <span class="font-mono font-bold text-[11px] text-on-surface-variant"><c:out value="${quiz.formattedScheduleWindow}"/></span>
                                </div>
                            </div>

                            <!-- Publish Command Button -->
                            <div class="p-4 rounded-xl bg-surface-container-low border border-surface-container flex flex-col sm:flex-row sm:items-center justify-between gap-3">
                                <div>
                                    <span class="font-bold text-sm text-on-surface block">Final Assessment Publication</span>
                                    <span class="text-xs text-on-surface-variant">Publishing makes the examination available to assigned candidate cohorts within the scheduled entry window.</span>
                                </div>
                                <form action="${pageContext.request.contextPath}/teacher/quiz/builder" method="POST" class="inline shrink-0">
                                    <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}"/>
                                    <input type="hidden" name="quizId" value="${quiz.quizId}"/>
                                    <c:choose>
                                        <c:when test="${quiz.status == 'ACTIVE' || quiz.status == 'SCHEDULED'}">
                                            <input type="hidden" name="action" value="save_draft"/>
                                            <button type="submit" class="px-5 py-2.5 rounded-xl bg-surface-container hover:bg-surface-container-high text-on-surface font-semibold text-sm transition-all flex items-center gap-2">
                                                <span class="material-symbols-outlined text-[18px]">pause</span>
                                                <span>Revert to Draft</span>
                                            </button>
                                        </c:when>
                                        <c:otherwise>
                                            <input type="hidden" name="action" value="publish_quiz"/>
                                            <button type="submit" class="px-6 py-2.5 rounded-xl bg-primary text-on-primary hover:bg-primary-container font-bold text-sm shadow-sm transition-all flex items-center gap-2">
                                                <span class="material-symbols-outlined text-[18px]">publish</span>
                                                <span>Publish Quiz &amp; Schedule</span>
                                            </button>
                                        </c:otherwise>
                                    </c:choose>
                                </form>
                            </div>
                        </div>

                        <!-- Target Cohorts & Candidate Slates Card -->
                        <div class="bg-surface-container-lowest rounded-2xl shadow-sm border border-surface-container-high p-space-md flex flex-col gap-space-sm">
                            <div class="flex items-center justify-between">
                                <div class="flex items-center gap-2">
                                    <span class="material-symbols-outlined text-primary text-[20px]">groups</span>
                                    <span class="font-title-md text-title-md font-bold text-on-surface">Target Cohorts &amp; Candidate Slates</span>
                                </div>
                                <button type="button" onclick="toggleAssignModal()" class="px-3 py-1.5 rounded-xl bg-primary-container text-on-primary-container hover:bg-primary/20 text-xs font-semibold flex items-center gap-1 transition-colors">
                                    <span class="material-symbols-outlined text-[16px]">add</span>
                                    <span>Assign New Slate</span>
                                </button>
                            </div>

                            <!-- Assignment Form (Collapsible) -->
                            <div id="assignTargetForm" class="hidden p-space-sm rounded-xl bg-surface-container-low border border-surface-container-high space-y-space-sm">
                                <div class="flex items-center justify-between border-b border-surface-container-high pb-2">
                                    <span class="font-label-sm text-label-sm font-bold text-on-surface">Assign Examination Slate</span>
                                    <button type="button" onclick="toggleAssignModal(false)" class="text-on-surface-variant hover:text-on-surface">
                                        <span class="material-symbols-outlined text-[16px]">close</span>
                                    </button>
                                </div>
                                
                                <form action="${pageContext.request.contextPath}/teacher/quiz/builder" method="POST" class="space-y-3">
                                    <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}"/>
                                    <input type="hidden" name="quizId" value="${quiz.quizId}"/>
                                    <input type="hidden" name="action" id="assignActionInput" value="assign_cohort"/>

                                    <!-- Target Type Selector -->
                                    <div class="flex items-center bg-surface-container-lowest p-0.5 rounded-lg border border-surface-container-high text-xs">
                                        <button type="button" id="tabCohortBtn" onclick="toggleTargetType('COHORT')" class="flex-1 py-1 rounded-md font-semibold bg-primary text-on-primary text-center">Entire Cohort</button>
                                        <button type="button" id="tabStudentBtn" onclick="toggleTargetType('STUDENT')" class="flex-1 py-1 rounded-md font-semibold text-on-surface-variant text-center hover:text-on-surface">Specific Student</button>
                                    </div>

                                    <!-- Cohort Select Field -->
                                    <div id="cohortSelectField" class="space-y-1">
                                        <label class="font-label-sm text-[11px] font-semibold text-on-surface-variant">Select Cohort (Your Academic Department)</label>
                                        <select name="cohortId" class="w-full px-2 py-1.5 rounded-lg bg-surface-container-lowest border border-surface-container-high text-xs text-on-surface font-medium focus:ring-1 focus:ring-primary">
                                            <c:choose>
                                                <c:when test="${not empty availableCohorts}">
                                                    <c:forEach items="${availableCohorts}" var="c">
                                                        <option value="${c.cohortId}"><c:out value="${c.cohortName}"/> (<c:out value="${c.studentCount}"/> candidates)</option>
                                                    </c:forEach>
                                                </c:when>
                                                <c:otherwise>
                                                    <option value="" disabled>No cohorts available in department</option>
                                                </c:otherwise>
                                            </c:choose>
                                        </select>
                                    </div>

                                    <!-- Student Select Field -->
                                    <div id="studentSelectField" class="hidden space-y-1">
                                        <label class="font-label-sm text-[11px] font-semibold text-on-surface-variant">Select Candidate Student</label>
                                        <select name="studentId" class="w-full px-2 py-1.5 rounded-lg bg-surface-container-lowest border border-surface-container-high text-xs text-on-surface font-medium focus:ring-1 focus:ring-primary">
                                            <c:choose>
                                                <c:when test="${not empty availableStudents}">
                                                    <c:forEach items="${availableStudents}" var="st">
                                                        <option value="${st.userId}"><c:out value="${st.fullName}"/> (<c:out value="${st.identifier}"/>)</option>
                                                    </c:forEach>
                                                </c:when>
                                                <c:otherwise>
                                                    <option value="" disabled>No students enrolled</option>
                                                </c:otherwise>
                                            </c:choose>
                                        </select>
                                    </div>

                                    <!-- Optional Due Date -->
                                    <div class="space-y-1">
                                        <label class="font-label-sm text-[11px] font-semibold text-on-surface-variant">Due Date &amp; Time (Optional)</label>
                                        <input type="datetime-local" name="dueAt" class="w-full px-2 py-1 rounded-lg bg-surface-container-lowest border border-surface-container-high text-xs text-on-surface font-mono"/>
                                    </div>

                                    <div class="flex items-center justify-end gap-2 pt-1">
                                        <button type="button" onclick="toggleAssignModal(false)" class="px-3 py-1 rounded bg-surface-container text-xs font-semibold text-on-surface">Cancel</button>
                                        <button type="submit" class="px-3 py-1 rounded bg-primary text-xs font-bold text-on-primary shadow-xs">Assign Slate</button>
                                    </div>
                                </form>
                            </div>

                            <!-- Assigned Slates List -->
                            <div class="space-y-2 pt-1">
                                <c:choose>
                                    <c:when test="${empty assignedSlates}">
                                        <div class="p-space-sm rounded-xl bg-error-container/20 border border-error/30 text-error flex items-start gap-2">
                                            <span class="material-symbols-outlined text-[18px] shrink-0 mt-0.5">warning</span>
                                            <div class="text-xs">
                                                <span class="font-semibold block">No Targets Assigned</span>
                                                <span class="opacity-90">Assign at least one cohort or candidate student to enable quiz publishing.</span>
                                            </div>
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <c:forEach items="${assignedSlates}" var="slate">
                                            <div class="p-2.5 rounded-xl bg-surface-container-low border border-surface-container-high flex items-center justify-between gap-2">
                                                <div class="flex items-center gap-2 min-w-0">
                                                    <span class="material-symbols-outlined text-primary text-[20px] shrink-0">
                                                        <c:out value="${slate.cohortId != null ? 'groups' : 'person'}"/>
                                                    </span>
                                                    <div class="min-w-0">
                                                        <span class="text-xs font-bold text-on-surface truncate block">
                                                            <c:choose>
                                                                <c:when test="${slate.cohortId != null}"><c:out value="${slate.cohortName}"/></c:when>
                                                                <c:otherwise><c:out value="${slate.studentName}"/></c:otherwise>
                                                            </c:choose>
                                                        </span>
                                                        <span class="text-[11px] text-on-surface-variant block">
                                                            <c:choose>
                                                                <c:when test="${slate.cohortId != null}"><c:out value="${slate.enrolledStudentsCount}"/> Enrolled Candidates</c:when>
                                                                <c:otherwise>ID: <c:out value="${slate.studentIdentifier}"/></c:otherwise>
                                                            </c:choose>
                                                        </span>
                                                    </div>
                                                </div>
                                                <form action="${pageContext.request.contextPath}/teacher/quiz/builder" method="POST" class="inline shrink-0" onsubmit="return confirm('Remove this assignment target?');">
                                                    <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}"/>
                                                    <input type="hidden" name="action" value="remove_assignment"/>
                                                    <input type="hidden" name="quizId" value="${quiz.quizId}"/>
                                                    <input type="hidden" name="assignmentId" value="${slate.assignmentId}"/>
                                                    <button type="submit" class="p-1 rounded text-error hover:bg-error-container/20 transition-colors" title="Remove target">
                                                        <span class="material-symbols-outlined text-[16px]">close</span>
                                                    </button>
                                                </form>
                                            </div>
                                        </c:forEach>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>

                    </div>

                    <div class="lg:col-span-4 flex flex-col gap-gutter">
                        <!-- Summary metrics -->
                        <div class="bg-surface-container-lowest rounded-2xl shadow-sm border border-surface-container-high p-space-md flex flex-col gap-3">
                            <span class="font-title-md text-title-md font-bold text-on-surface">Publish Overview</span>
                            <div class="divide-y divide-surface-container-high text-xs">
                                <div class="py-2 flex justify-between">
                                    <span class="text-on-surface-variant">Questions Count:</span>
                                    <span class="font-bold text-on-surface"><c:out value="${quizQuestions.size()}"/> Items</span>
                                </div>
                                <div class="py-2 flex justify-between">
                                    <span class="text-on-surface-variant">Allocated Points:</span>
                                    <span class="font-bold text-secondary"><fmt:formatNumber value="${allocatedPoints}" maxFractionDigits="2"/> Pts</span>
                                </div>
                                <div class="py-2 flex justify-between">
                                    <span class="text-on-surface-variant">Examinee Targets:</span>
                                    <span class="font-bold text-primary"><c:out value="${assignedSlates.size()}"/> Slates</span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

            </div>
        </main>
    </div>

    <!-- Script for Tab Switching & Rich Formatting -->
    <script>
        function switchBuilderTab(tab) {
            const tabs = ['questions', 'settings', 'publish'];
            tabs.forEach(t => {
                const el = document.getElementById('view-tab-' + t);
                const btn = document.getElementById('stepper-btn-' + t);
                if (el) {
                    if (t === tab) {
                        el.classList.remove('hidden');
                    } else {
                        el.classList.add('hidden');
                    }
                }
                if (btn) {
                    const numDiv = btn.querySelector('.stepper-num');
                    const statusSpan = btn.querySelector('.stepper-status');
                    if (t === tab) {
                        btn.className = "stepper-tab-btn text-left flex items-center gap-space-sm p-space-sm rounded-xl transition-all bg-primary-container text-on-primary shadow-sm cursor-pointer";
                        if (numDiv) numDiv.className = "stepper-num h-8 w-8 rounded-full bg-on-primary text-primary flex items-center justify-center font-bold text-[13px]";
                        if (statusSpan) statusSpan.className = "stepper-status font-label-sm text-label-sm uppercase tracking-wider font-bold text-on-primary-container";
                    } else {
                        btn.className = "stepper-tab-btn text-left flex items-center gap-space-sm p-space-sm rounded-xl transition-all bg-surface-container-low hover:bg-surface-container text-on-surface cursor-pointer";
                        if (numDiv) numDiv.className = "stepper-num h-8 w-8 rounded-full bg-surface-container-high text-on-surface-variant flex items-center justify-center font-bold text-[13px]";
                        if (statusSpan) statusSpan.className = "stepper-status font-label-sm text-label-sm uppercase tracking-wider font-semibold text-on-surface-variant";
                    }
                }
            });

            try {
                const url = new URL(window.location.href);
                url.searchParams.set('tab', tab);
                window.history.replaceState({}, '', url.toString());
            } catch(e) {}
        }

        document.addEventListener('DOMContentLoaded', function() {
            const urlParams = new URLSearchParams(window.location.search);
            const tabParam = urlParams.get('tab') || '<c:out value="${activeTab}"/>' || 'questions';
            switchBuilderTab(tabParam);
        });

        (function () {
            const openBankBtn = document.getElementById('openQuestionBankBtn');
            const bankContainer = document.getElementById('bankContainer');
            if (openBankBtn && bankContainer) {
                openBankBtn.addEventListener('click', function () {
                    switchBuilderTab('questions');
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
                optRows.forEach((row, idx) => {
                    const textInput = row.querySelector('.option-text-input');
                    textInput.readOnly = false;
                    if (idx < 4) row.classList.remove('hidden');
                });
                if (addOptBtn) addOptBtn.classList.remove('hidden');
                if (hintText) hintText.textContent = "Answer Choices (Checkboxes indicate all correct solutions - Multi-Select)";
                if (headerTitle) {
                    const base = headerTitle.textContent.split('(')[0].trim();
                    headerTitle.textContent = base + " (Multi-Correct)";
                }

            } else { // SINGLE_CHOICE
                optInputs.forEach(i => i.type = 'radio');
                optRows.forEach((row, idx) => {
                    const textInput = row.querySelector('.option-text-input');
                    textInput.readOnly = false;
                    if (idx < 4) row.classList.remove('hidden');
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

        function toggleAssignModal(show) {
            const form = document.getElementById('assignTargetForm');
            if (form) {
                if (show !== undefined) {
                    form.classList.toggle('hidden', !show);
                } else {
                    form.classList.toggle('hidden');
                }
            }
        }

        function toggleTargetType(type) {
            const cohortField = document.getElementById('cohortSelectField');
            const studentField = document.getElementById('studentSelectField');
            const actionInput = document.getElementById('assignActionInput');
            const tabCohortBtn = document.getElementById('tabCohortBtn');
            const tabStudentBtn = document.getElementById('tabStudentBtn');

            if (type === 'COHORT') {
                cohortField.classList.remove('hidden');
                studentField.classList.add('hidden');
                actionInput.value = 'assign_cohort';
                tabCohortBtn.className = "flex-1 py-1 rounded-md font-semibold bg-primary text-on-primary text-center";
                tabStudentBtn.className = "flex-1 py-1 rounded-md font-semibold text-on-surface-variant text-center hover:text-on-surface";
            } else {
                cohortField.classList.add('hidden');
                studentField.classList.remove('hidden');
                actionInput.value = 'assign_student';
                tabCohortBtn.className = "flex-1 py-1 rounded-md font-semibold text-on-surface-variant text-center hover:text-on-surface";
                tabStudentBtn.className = "flex-1 py-1 rounded-md font-semibold bg-primary text-on-primary text-center";
            }
        }
    </script>
</body>
</html>
