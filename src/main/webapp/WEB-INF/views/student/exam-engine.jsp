<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no, viewport-fit=cover"/>
    <meta name="theme-color" content="#3525cd"/>
    <title>${examSession.attempt.quizTitle} | QuizTrack Examination Engine</title>

    <!-- Google Fonts & Material Symbols matching Stitch -->
    <link href="https://fonts.googleapis.com" rel="preconnect"/>
    <link crossorigin="" href="https://fonts.gstatic.com" rel="preconnect"/>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=JetBrains+Mono:wght@400;500;600&family=Plus+Jakarta+Sans:wght@600;700;800&display=swap" rel="stylesheet"/>
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200" rel="stylesheet"/>

    <style>
        @layer base {
            html, body {
                margin: 0;
                padding: 0;
                overscroll-behavior: none;
                -webkit-tap-highlight-color: transparent;
            }
            .pb-safe { padding-bottom: max(1rem, env(safe-area-inset-bottom)); }
            .pt-safe { padding-top: max(1rem, env(safe-area-inset-top)); }
        }
        ::-webkit-scrollbar { display: none; }
    </style>

    <!-- Tailwind CDN with Stitch Palette -->
    <script src="https://cdn.tailwindcss.com"></script>
    <script>
        tailwind.config = {
            theme: {
                extend: {
                    colors: {
                        primary: '#3525cd',
                        'primary-container': '#4f46e5',
                        'on-primary': '#ffffff',
                        'primary-fixed': '#e2dfff',
                        'primary-fixed-dim': '#c3c0ff',
                        secondary: '#4648d4',
                        'secondary-container': '#6063ee',
                        'secondary-fixed': '#e1e0ff',
                        'secondary-fixed-dim': '#c0c1ff',
                        'on-secondary-fixed': '#07006c',
                        tertiary: '#005338',
                        'tertiary-container': '#006e4b',
                        'tertiary-fixed': '#6ffbbe',
                        'tertiary-fixed-dim': '#4edea3',
                        error: '#ba1a1a',
                        'error-container': '#ffdad6',
                        'on-error': '#ffffff',
                        'on-error-container': '#93000a',
                        surface: '#f8f9ff',
                        'surface-container-lowest': '#ffffff',
                        'surface-container-low': '#eff4ff',
                        'surface-container': '#e5eeff',
                        'surface-container-high': '#dce9ff',
                        'surface-container-highest': '#d3e4fe',
                        'inverse-surface': '#213145',
                        'inverse-on-surface': '#eaf1ff',
                        'on-surface': '#0b1c30',
                        'on-surface-variant': '#464555',
                        outline: '#777587',
                        'outline-variant': '#c7c4d8'
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
<body class="bg-surface font-body text-on-surface antialiased select-none min-h-screen flex flex-col justify-between">

    <!-- Top Universal Examination Command Header -->
    <header class="fixed top-0 left-0 right-0 z-40 bg-surface-container-lowest/95 backdrop-blur-md border-b border-surface-container-high shadow-xs">
        <div class="max-w-[1720px] mx-auto h-16 px-4 sm:px-6 flex items-center justify-between gap-3">
            
            <!-- Left: Brand, Exam & Cohort Pill -->
            <div class="flex items-center gap-3 min-w-0">
                <div class="w-9 h-9 rounded-xl bg-primary text-on-primary flex items-center justify-center shrink-0 shadow-sm">
                    <span class="material-symbols-outlined text-[20px]">quiz</span>
                </div>
                <div class="flex flex-col min-w-0">
                    <div class="flex items-center gap-2 flex-wrap">
                        <span class="font-display font-bold text-sm sm:text-base text-on-surface truncate">
                            ${examSession.attempt.quizTitle}
                        </span>
                        <c:if test="${not empty examSession.attempt.subjectCode}">
                            <span class="hidden sm:inline-block px-2 py-0.5 rounded-md bg-surface-container-high text-primary font-mono text-[11px] font-bold">
                                ${examSession.attempt.subjectCode}
                            </span>
                        </c:if>
                    </div>
                    <div class="flex items-center gap-2 text-[11px] text-on-surface-variant">
                        <span>Secured Candidate Chamber</span>
                        <span>•</span>
                        <span class="font-mono text-primary font-semibold">Seat ID: QT-${sessionScope.userId}</span>
                    </div>
                </div>
            </div>

            <!-- Center: Authoritative Live Countdown Timer & Autosave Status -->
            <div class="flex items-center gap-3 bg-surface-container-low px-3 sm:px-5 py-1.5 rounded-full border border-surface-container-high shadow-inner shrink-0">
                <div class="flex items-center gap-2">
                    <span class="material-symbols-outlined text-error animate-pulse text-[20px]">timer</span>
                    <div class="flex flex-col">
                        <span class="font-mono text-sm sm:text-base font-bold text-error tracking-tight leading-none" id="countdown-timer">
                            ${examSession.formattedRemainingTime}
                        </span>
                        <span class="text-[9px] font-mono uppercase text-on-surface-variant font-semibold hidden sm:inline-block">Time Remaining</span>
                    </div>
                </div>
                <div class="h-5 w-px bg-surface-container-high hidden sm:block"></div>
                <div class="hidden md:flex items-center gap-1.5 text-xs text-on-surface-variant">
                    <span class="material-symbols-outlined text-tertiary text-[16px]">cloud_done</span>
                    <span id="autosave-label">Synced <span class="font-mono font-semibold text-on-surface" id="autosave-time">Just now</span></span>
                </div>
            </div>

            <!-- Right: Integrity Shields, Progress Counter & Finish CTA -->
            <div class="flex items-center gap-3 shrink-0">
                <div class="hidden xl:flex items-center gap-2 px-3 py-1.5 rounded-xl bg-tertiary-fixed/30 text-tertiary border border-tertiary/20 text-xs font-semibold">
                    <span class="w-2 h-2 rounded-full bg-tertiary animate-ping"></span>
                    <span class="material-symbols-outlined text-[16px]">shield</span>
                    <span>Level-3 Guard Active</span>
                </div>

                <div class="hidden sm:flex items-center gap-1 text-xs px-3 py-1.5 rounded-xl bg-surface-container text-on-surface font-semibold">
                    <span class="text-on-surface-variant">Progress:</span>
                    <span class="font-mono text-primary font-bold" id="progress-text">${examSession.answeredCount}</span>
                    <span class="text-on-surface-variant">/ ${examSession.totalQuestions}</span>
                </div>

                <button type="button" onclick="openSubmitModal()" class="px-3.5 sm:px-5 py-2 rounded-xl bg-error hover:bg-on-error-container text-on-error font-semibold text-xs sm:text-sm shadow-sm transition-all flex items-center gap-1.5 cursor-pointer">
                    <span class="material-symbols-outlined text-[18px]">lock</span>
                    <span class="hidden sm:inline">Finish &amp; Submit</span>
                    <span class="sm:hidden">Submit</span>
                </button>
            </div>

        </div>
    </header>

    <!-- Mobile Quick-Palette Ribbon (Visible on small screens) -->
    <div class="lg:hidden fixed top-16 left-0 right-0 z-30 bg-surface-container-lowest px-3 py-2 border-b border-surface-container-high flex items-center gap-2 shadow-xs">
        <div class="flex-1 overflow-x-auto flex items-center gap-1.5 py-0.5 no-scrollbar" id="mobile-quick-ribbon">
            <c:forEach var="q" items="${examSession.questions}" varStatus="loop">
                <button type="button" onclick="navigateToQuestion(${loop.index})" 
                        id="ribbon-btn-${q.questionId}"
                        class="w-8 h-8 rounded-lg text-xs font-mono font-bold flex items-center justify-center shrink-0 transition-all
                        ${loop.index == examSession.currentQuestionIndex ? 'bg-primary text-on-primary ring-2 ring-primary ring-offset-1 scale-105 shadow-sm' : 
                          q.flaggedForReview ? 'bg-secondary-fixed text-on-secondary-fixed border border-secondary' :
                          (q.selectedOptionId != null && q.selectedOptionId > 0) ? 'bg-emerald-100 text-emerald-800 border border-emerald-300' :
                          'bg-surface-container text-on-surface-variant'}">
                    ${q.questionNumber}
                </button>
            </c:forEach>
        </div>
        <button type="button" onclick="togglePaletteModal(true)" class="p-2 rounded-lg bg-surface-container text-on-surface hover:bg-surface-container-high shrink-0 shadow-xs" title="Expand Full Question Palette">
            <span class="material-symbols-outlined text-[20px]">grid_view</span>
        </button>
    </div>

    <!-- Main Examination Content Container -->
    <main class="w-full max-w-[1720px] mx-auto px-4 sm:px-6 pt-28 lg:pt-24 pb-28 lg:pb-12 flex-1">
        <div class="flex flex-col lg:flex-row gap-6 items-start">
            
            <!-- LEFT 72% REGION: Active Question Chamber -->
            <div class="w-full lg:w-[72%] flex flex-col gap-6">
                
                <!-- Question Card -->
                <div class="bg-surface-container-lowest rounded-2xl p-5 sm:p-8 shadow-sm border border-surface-container-high flex flex-col gap-6 relative">
                    
                    <!-- Question Header Meta Bar -->
                    <div class="flex flex-wrap items-center justify-between gap-3 pb-4 border-b border-surface-container-high">
                        <div class="flex items-center gap-2 flex-wrap">
                            <span class="font-display text-xl sm:text-2xl font-bold text-on-surface">
                                Question ${examSession.currentQuestion.questionNumber}
                            </span>
                            <span class="text-xs sm:text-sm text-on-surface-variant">of ${examSession.totalQuestions}</span>
                            <span class="px-2.5 py-0.5 rounded-full bg-surface-container-high text-primary font-mono text-xs font-semibold">
                                ${examSession.currentQuestion.questionType}
                            </span>
                        </div>
                        <div class="flex items-center gap-2 flex-wrap">
                            <c:if test="${not empty examSession.currentQuestion.taxonomyTopic}">
                                <span class="px-2.5 py-1 rounded-lg bg-indigo-50 text-indigo-700 text-xs font-semibold border border-indigo-100">
                                    ${examSession.currentQuestion.taxonomyTopic}
                                </span>
                            </c:if>
                            <span class="px-2.5 py-1 rounded-lg bg-tertiary-fixed/30 text-tertiary font-mono text-xs font-bold border border-tertiary/20">
                                +<fmt:formatNumber value="${examSession.currentQuestion.points}" minFractionDigits="1"/>
                                <c:if test="${examSession.attempt.negativeMarking}">
                                    / -<fmt:formatNumber value="${examSession.attempt.negativeMarkValue}" minFractionDigits="1"/>
                                </c:if> Mark(s)
                            </span>
                        </div>
                    </div>

                    <!-- Question Prompt Statement -->
                    <div class="text-base sm:text-lg text-on-surface leading-relaxed font-medium">
                        ${examSession.currentQuestion.questionText}
                    </div>

                    <!-- Code Snippet Box (If present) -->
                    <c:if test="${not empty examSession.currentQuestion.codeSnippet}">
                        <div class="bg-inverse-surface text-inverse-on-surface rounded-xl p-4 overflow-x-auto shadow-inner border border-surface-container-high">
                            <div class="flex items-center justify-between pb-2 mb-2 border-b border-white/10 text-xs font-mono text-tertiary-fixed">
                                <span>TECHNICAL SOURCE TELEMETRY</span>
                                <span>READ-ONLY CONTEXT</span>
                            </div>
                            <pre class="font-mono text-xs sm:text-sm leading-relaxed"><code>${examSession.currentQuestion.codeSnippet}</code></pre>
                        </div>
                    </c:if>

                    <!-- Interactive Options Selection List -->
                    <div class="flex flex-col gap-3 pt-2" id="options-group">
                        <c:forEach var="opt" items="${examSession.currentQuestion.options}">
                            <label class="option-card flex items-start gap-3.5 p-4 rounded-xl border cursor-pointer transition-all active:scale-[0.99] select-none
                                ${examSession.currentQuestion.selectedOptionId == opt.optionId ? 
                                  'bg-indigo-50/70 border-primary shadow-xs ring-1 ring-primary' : 
                                  'bg-surface-container-low/40 border-surface-container-high hover:bg-surface-container-low hover:border-outline-variant'}">
                                
                                <input type="radio" name="examOption" value="${opt.optionId}" 
                                       class="mt-1 h-4 w-4 text-primary accent-primary cursor-pointer"
                                       ${examSession.currentQuestion.selectedOptionId == opt.optionId ? 'checked' : ''}
                                       onchange="handleOptionSelect(${opt.optionId})"/>

                                <span class="w-7 h-7 rounded-lg font-mono font-bold text-xs flex items-center justify-center shrink-0 transition-colors
                                    ${examSession.currentQuestion.selectedOptionId == opt.optionId ? 'bg-primary text-on-primary' : 'bg-surface-container text-on-surface-variant'}">
                                    ${opt.optionLetter}
                                </span>

                                <span class="text-sm sm:text-base text-on-surface font-medium leading-relaxed flex-1 pt-0.5">
                                    ${opt.optionText}
                                </span>
                            </label>
                        </c:forEach>
                    </div>

                    <!-- Question Workspace Action Strip -->
                    <div class="flex flex-wrap items-center justify-between gap-3 pt-6 border-t border-surface-container-high">
                        <div class="flex items-center gap-2">
                            <!-- Mark for Review Button -->
                            <button type="button" onclick="handleToggleFlag()" id="flag-btn"
                                    class="px-4 py-2.5 rounded-xl font-semibold text-xs sm:text-sm transition-all flex items-center gap-1.5 cursor-pointer
                                    ${examSession.currentQuestion.flaggedForReview ? 
                                      'bg-secondary text-white shadow-sm' : 
                                      'bg-secondary-fixed text-on-secondary-fixed hover:bg-secondary-fixed-dim'}">
                                <span class="material-symbols-outlined text-[18px]">flag</span>
                                <span id="flag-btn-text">
                                    ${examSession.currentQuestion.flaggedForReview ? 'Marked for Review' : 'Mark for Review'}
                                </span>
                            </button>

                            <!-- Clear Choice Button -->
                            <button type="button" onclick="handleClearChoice()" class="px-3.5 py-2.5 rounded-xl bg-surface-container hover:bg-surface-container-high text-on-surface-variant hover:text-on-surface font-semibold text-xs sm:text-sm transition-all" title="Clear chosen option">
                                Clear
                            </button>
                        </div>

                        <!-- Previous & Next Navigation Buttons -->
                        <div class="flex items-center gap-3">
                            <button type="button" onclick="navigatePrevious()" 
                                    class="px-4 py-2.5 rounded-xl bg-surface-container hover:bg-surface-container-high text-on-surface font-semibold text-xs sm:text-sm transition-all flex items-center gap-1.5 ${examSession.currentQuestionIndex == 0 ? 'opacity-50 pointer-events-none' : ''}">
                                <span class="material-symbols-outlined text-[18px]">arrow_back</span>
                                <span>Previous</span>
                            </button>

                            <c:choose>
                                <c:when test="${examSession.currentQuestionIndex < examSession.totalQuestions - 1}">
                                    <button type="button" onclick="navigateNext()" class="px-5 py-2.5 rounded-xl bg-primary hover:bg-primary-container text-on-primary font-semibold text-xs sm:text-sm transition-all shadow-sm flex items-center gap-1.5">
                                        <span>Save &amp; Next</span>
                                        <span class="material-symbols-outlined text-[18px]">arrow_forward</span>
                                    </button>
                                </c:when>
                                <c:otherwise>
                                    <button type="button" onclick="openSubmitModal()" class="px-6 py-2.5 rounded-xl bg-emerald-600 hover:bg-emerald-700 text-white font-semibold text-xs sm:text-sm transition-all shadow-md flex items-center gap-1.5">
                                        <span class="material-symbols-outlined text-[18px]">verified</span>
                                        <span>Review &amp; Finalize</span>
                                    </button>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>

                </div>

            </div>

            <!-- RIGHT 28% REGION: Question Palette Navigator (Desktop Sticky) -->
            <div class="hidden lg:flex w-[28%] flex-col gap-6 sticky top-24">
                <div class="bg-surface-container-lowest rounded-2xl p-6 shadow-sm border border-surface-container-high flex flex-col gap-5">
                    
                    <!-- Palette Header -->
                    <div class="flex items-center justify-between pb-3 border-b border-surface-container-high">
                        <div class="flex items-center gap-2">
                            <span class="material-symbols-outlined text-primary text-[22px]">grid_view</span>
                            <span class="font-display font-bold text-base text-on-surface">Question Palette</span>
                        </div>
                        <span class="px-2.5 py-0.5 rounded-full bg-surface-container text-primary font-mono text-xs font-bold">
                            ${examSession.totalQuestions} Questions
                        </span>
                    </div>

                    <!-- Legend Metrics -->
                    <div class="grid grid-cols-2 gap-2 text-xs">
                        <div class="flex items-center gap-2 p-2 rounded-lg bg-surface-container-low">
                            <span class="w-3.5 h-3.5 rounded bg-emerald-600 shrink-0"></span>
                            <span class="text-on-surface-variant">Answered: <strong class="text-on-surface" id="answered-count-badge">${examSession.answeredCount}</strong></span>
                        </div>
                        <div class="flex items-center gap-2 p-2 rounded-lg bg-surface-container-low">
                            <span class="w-3.5 h-3.5 rounded bg-secondary-fixed-dim border border-secondary shrink-0"></span>
                            <span class="text-on-surface-variant">Review: <strong class="text-on-surface" id="flagged-count-badge">${examSession.flaggedCount}</strong></span>
                        </div>
                        <div class="flex items-center gap-2 p-2 rounded-lg bg-surface-container-low">
                            <span class="w-3.5 h-3.5 rounded bg-surface-container-lowest border-2 border-primary shrink-0"></span>
                            <span class="text-on-surface-variant">Current Focus</span>
                        </div>
                        <div class="flex items-center gap-2 p-2 rounded-lg bg-surface-container-low">
                            <span class="w-3.5 h-3.5 rounded bg-surface-container-high shrink-0"></span>
                            <span class="text-on-surface-variant">Not Visited</span>
                        </div>
                    </div>

                    <!-- Palette Grid of Questions -->
                    <div class="grid grid-cols-5 gap-2 pt-2 max-h-[360px] overflow-y-auto pr-1">
                        <c:forEach var="q" items="${examSession.questions}" varStatus="loop">
                            <button type="button" onclick="navigateToQuestion(${loop.index})" 
                                    id="palette-btn-${q.questionId}"
                                    class="h-10 rounded-xl font-mono font-bold text-xs flex items-center justify-center transition-all cursor-pointer relative
                                    ${loop.index == examSession.currentQuestionIndex ? 'ring-2 ring-primary ring-offset-2 scale-105 shadow-sm font-extrabold z-10 ' : ''}
                                    ${q.flaggedForReview ? 'bg-secondary-fixed text-on-secondary-fixed border border-secondary' :
                                      (q.selectedOptionId != null && q.selectedOptionId > 0) ? 'bg-emerald-600 text-white shadow-xs' :
                                      'bg-surface-container text-on-surface-variant hover:bg-surface-container-high'}">
                                <span>${q.questionNumber}</span>
                                <c:if test="${q.flaggedForReview}">
                                    <span class="material-symbols-outlined text-[10px] text-secondary absolute -top-1 -right-1">flag</span>
                                </c:if>
                            </button>
                        </c:forEach>
                    </div>

                    <!-- Examination Security Seal -->
                    <div class="p-3.5 rounded-xl bg-surface-container-low border border-surface-container-high flex items-start gap-2.5 text-xs text-on-surface-variant">
                        <span class="material-symbols-outlined text-tertiary text-[18px] shrink-0 mt-0.5">verified_user</span>
                        <div>
                            <span class="font-bold text-on-surface">Cryptographic Session Lock</span>
                            <p class="text-[11px] text-on-surface-variant mt-0.5">
                                Server-side timestamps authoritative. Every answer selection autosaved to PostgreSQL.
                            </p>
                        </div>
                    </div>

                </div>
            </div>

        </div>
    </main>

    <!-- Mobile Full Palette Modal Drawer -->
    <div id="paletteModal" class="fixed inset-0 z-50 bg-black/60 backdrop-blur-xs hidden flex items-end sm:items-center justify-center p-0 sm:p-4">
        <div class="bg-surface-container-lowest w-full max-w-lg rounded-t-3xl sm:rounded-2xl p-6 shadow-2xl border border-surface-container-high max-h-[85vh] flex flex-col gap-4 overflow-y-auto">
            <div class="flex items-center justify-between pb-3 border-b border-surface-container-high">
                <div class="flex items-center gap-2">
                    <span class="material-symbols-outlined text-primary text-[22px]">grid_view</span>
                    <h3 class="font-display font-bold text-lg text-on-surface">Complete Question Overview</h3>
                </div>
                <button type="button" onclick="togglePaletteModal(false)" class="p-1 rounded-lg text-on-surface-variant hover:bg-surface-container">
                    <span class="material-symbols-outlined">close</span>
                </button>
            </div>

            <!-- Mobile Grid -->
            <div class="grid grid-cols-5 gap-2.5 py-2">
                <c:forEach var="q" items="${examSession.questions}" varStatus="loop">
                    <button type="button" onclick="navigateToQuestion(${loop.index}); togglePaletteModal(false);" 
                            class="h-11 rounded-xl font-mono font-bold text-sm flex items-center justify-center transition-all cursor-pointer relative
                            ${loop.index == examSession.currentQuestionIndex ? 'ring-2 ring-primary ring-offset-2 scale-105 font-extrabold ' : ''}
                            ${q.flaggedForReview ? 'bg-secondary-fixed text-on-secondary-fixed border border-secondary' :
                              (q.selectedOptionId != null && q.selectedOptionId > 0) ? 'bg-emerald-600 text-white shadow-xs' :
                              'bg-surface-container text-on-surface-variant'}">
                        <span>${q.questionNumber}</span>
                        <c:if test="${q.flaggedForReview}">
                            <span class="material-symbols-outlined text-[10px] text-secondary absolute -top-1 -right-1">flag</span>
                        </c:if>
                    </button>
                </c:forEach>
            </div>

            <button type="button" onclick="togglePaletteModal(false)" class="w-full py-3 rounded-xl bg-surface-container font-semibold text-sm text-on-surface mt-2">
                Resume Question ${examSession.currentQuestion.questionNumber}
            </button>
        </div>
    </div>

    <!-- Final Submission Confirmation Modal -->
    <div id="submitModal" class="fixed inset-0 z-50 bg-black/60 backdrop-blur-sm hidden flex items-center justify-center p-4">
        <div class="bg-surface-container-lowest max-w-md w-full rounded-2xl p-6 shadow-2xl border border-surface-container-high flex flex-col gap-5 text-center">
            
            <div class="w-14 h-14 rounded-2xl bg-primary-container text-on-primary flex items-center justify-center mx-auto shadow-md">
                <span class="material-symbols-outlined text-[30px]">fact_check</span>
            </div>

            <div>
                <h3 class="font-display font-bold text-xl text-on-surface">Confirm Final Submission?</h3>
                <p class="text-xs text-on-surface-variant mt-1">
                    Please review your examination summary before concluding this proctored session.
                </p>
            </div>

            <!-- Review Summary Matrix -->
            <div class="grid grid-cols-3 gap-2 p-3 bg-surface-container-low rounded-xl text-center border border-surface-container-high">
                <div>
                    <span class="text-[10px] font-mono uppercase text-on-surface-variant block">Answered</span>
                    <span class="font-mono text-base font-bold text-emerald-700" id="modal-answered-count">${examSession.answeredCount}</span>
                </div>
                <div>
                    <span class="text-[10px] font-mono uppercase text-on-surface-variant block">Flagged</span>
                    <span class="font-mono text-base font-bold text-secondary" id="modal-flagged-count">${examSession.flaggedCount}</span>
                </div>
                <div>
                    <span class="text-[10px] font-mono uppercase text-on-surface-variant block">Unanswered</span>
                    <span class="font-mono text-base font-bold text-rose-600" id="modal-unanswered-count">${examSession.totalQuestions - examSession.answeredCount}</span>
                </div>
            </div>

            <p class="text-xs text-rose-700 bg-rose-50 border border-rose-200 p-3 rounded-xl text-left">
                <strong>Important:</strong> Once confirmed, your responses are finalized and evaluated by the registry. You will not be permitted to re-enter this examination chamber.
            </p>

            <form id="finalSubmitForm" method="POST" action="${pageContext.request.contextPath}/student/exam" class="flex flex-col gap-3">
                <input type="hidden" name="action" value="submit"/>
                <input type="hidden" name="attemptId" value="${examSession.attempt.attemptId}"/>

                <div class="flex items-center gap-3">
                    <button type="button" onclick="closeSubmitModal()" class="flex-1 py-2.5 rounded-xl bg-surface-container hover:bg-surface-container-high font-semibold text-sm text-on-surface transition-all">
                        Return to Exam
                    </button>
                    <button type="submit" id="final-submit-btn" class="flex-1 py-2.5 rounded-xl bg-primary hover:bg-primary-container text-on-primary font-semibold text-sm transition-all shadow-md">
                        Confirm &amp; Submit
                    </button>
                </div>
            </form>

        </div>
    </div>

    <!-- Hidden Navigation Form for Full Page Question Transitions -->
    <form id="navigationForm" method="POST" action="${pageContext.request.contextPath}/student/exam" class="hidden">
        <input type="hidden" name="action" value="save_and_navigate"/>
        <input type="hidden" name="attemptId" value="${examSession.attempt.attemptId}"/>
        <input type="hidden" name="questionId" value="${examSession.currentQuestion.questionId}"/>
        <input type="hidden" name="selectedOptionId" id="nav-selectedOptionId" value="${examSession.currentQuestion.selectedOptionId}"/>
        <input type="hidden" name="isFlagged" id="nav-isFlagged" value="${examSession.currentQuestion.flaggedForReview}"/>
        <input type="hidden" name="targetQ" id="nav-targetQ" value="0"/>
    </form>

    <!-- Client Examination Engine Controller Script -->
    <script>
        const EXAM_CONTEXT = {
            attemptId: ${examSession.attempt.attemptId},
            questionId: ${examSession.currentQuestion.questionId},
            currentQIndex: ${examSession.currentQuestionIndex},
            totalQuestions: ${examSession.totalQuestions},
            selectedOptionId: ${examSession.currentQuestion.selectedOptionId != null ? examSession.currentQuestion.selectedOptionId : 0},
            isFlagged: ${examSession.currentQuestion.flaggedForReview},
            remainingSeconds: ${examSession.remainingSeconds},
            contextPath: '${pageContext.request.contextPath}'
        };

        // 1. Authoritative Countdown Timer Engine
        (function initTimer() {
            let timeLeft = EXAM_CONTEXT.remainingSeconds;
            const timerEl = document.getElementById('countdown-timer');

            function formatTime(totalSec) {
                if (totalSec <= 0) return "00:00:00";
                const h = Math.floor(totalSec / 3600);
                const m = Math.floor((totalSec % 3600) / 60);
                const s = totalSec % 60;
                const hh = h < 10 ? "0" + h : h;
                const mm = m < 10 ? "0" + m : m;
                const ss = s < 10 ? "0" + s : s;
                return (h > 0) ? (hh + ":" + mm + ":" + ss) : (mm + ":" + ss);
            }

            const interval = setInterval(() => {
                timeLeft--;
                if (timerEl) {
                    timerEl.textContent = formatTime(timeLeft);
                    if (timeLeft <= 300) { // < 5 minutes
                        timerEl.classList.add('text-error', 'font-black');
                    }
                }

                if (timeLeft <= 0) {
                    clearInterval(interval);
                    alert("Examination time has expired. Your answers are being automatically submitted to the registry.");
                    document.getElementById('finalSubmitForm').submit();
                }
            }, 1000);
        })();

        // 2. Option Selection & Instant Autosave
        function handleOptionSelect(optionId) {
            EXAM_CONTEXT.selectedOptionId = optionId;
            document.getElementById('nav-selectedOptionId').value = optionId;

            // Highlight chosen card
            document.querySelectorAll('.option-card').forEach(card => {
                const radio = card.querySelector('input[type="radio"]');
                const badge = card.querySelector('span.w-7');
                if (radio && parseInt(radio.value) === optionId) {
                    card.className = "option-card flex items-start gap-3.5 p-4 rounded-xl border cursor-pointer transition-all active:scale-[0.99] select-none bg-indigo-50/70 border-primary shadow-xs ring-1 ring-primary";
                    if (badge) badge.className = "w-7 h-7 rounded-lg font-mono font-bold text-xs flex items-center justify-center shrink-0 transition-colors bg-primary text-on-primary";
                } else {
                    card.className = "option-card flex items-start gap-3.5 p-4 rounded-xl border cursor-pointer transition-all active:scale-[0.99] select-none bg-surface-container-low/40 border-surface-container-high hover:bg-surface-container-low hover:border-outline-variant";
                    if (badge) badge.className = "w-7 h-7 rounded-lg font-mono font-bold text-xs flex items-center justify-center shrink-0 transition-colors bg-surface-container text-on-surface-variant";
                }
            });

            // Update palette item state
            updatePaletteIndicator(EXAM_CONTEXT.questionId, true, EXAM_CONTEXT.isFlagged);

            // Execute instant asynchronous background autosave
            triggerAutosave();
        }

        // 3. Toggle Mark for Review
        function handleToggleFlag() {
            EXAM_CONTEXT.isFlagged = !EXAM_CONTEXT.isFlagged;
            document.getElementById('nav-isFlagged').value = EXAM_CONTEXT.isFlagged;

            const btn = document.getElementById('flag-btn');
            const txt = document.getElementById('flag-btn-text');

            if (EXAM_CONTEXT.isFlagged) {
                btn.className = "px-4 py-2.5 rounded-xl font-semibold text-xs sm:text-sm transition-all flex items-center gap-1.5 cursor-pointer bg-secondary text-white shadow-sm";
                txt.textContent = "Marked for Review";
            } else {
                btn.className = "px-4 py-2.5 rounded-xl font-semibold text-xs sm:text-sm transition-all flex items-center gap-1.5 cursor-pointer bg-secondary-fixed text-on-secondary-fixed hover:bg-secondary-fixed-dim";
                txt.textContent = "Mark for Review";
            }

            updatePaletteIndicator(EXAM_CONTEXT.questionId, EXAM_CONTEXT.selectedOptionId > 0, EXAM_CONTEXT.isFlagged);
            triggerAutosave();
        }

        // 4. Clear Choice
        function handleClearChoice() {
            EXAM_CONTEXT.selectedOptionId = 0;
            document.getElementById('nav-selectedOptionId').value = "0";

            document.querySelectorAll('.option-card input[type="radio"]').forEach(r => r.checked = false);
            document.querySelectorAll('.option-card').forEach(card => {
                card.className = "option-card flex items-start gap-3.5 p-4 rounded-xl border cursor-pointer transition-all active:scale-[0.99] select-none bg-surface-container-low/40 border-surface-container-high hover:bg-surface-container-low hover:border-outline-variant";
                const badge = card.querySelector('span.w-7');
                if (badge) badge.className = "w-7 h-7 rounded-lg font-mono font-bold text-xs flex items-center justify-center shrink-0 transition-colors bg-surface-container text-on-surface-variant";
            });

            updatePaletteIndicator(EXAM_CONTEXT.questionId, false, EXAM_CONTEXT.isFlagged);
            triggerAutosave();
        }

        // 5. Asynchronous Background Autosave Call
        function triggerAutosave() {
            const timeEl = document.getElementById('autosave-time');
            if (timeEl) timeEl.textContent = "Saving...";

            const params = new URLSearchParams();
            params.append('attemptId', EXAM_CONTEXT.attemptId);
            params.append('questionId', EXAM_CONTEXT.questionId);
            params.append('selectedOptionId', EXAM_CONTEXT.selectedOptionId);
            params.append('isFlagged', EXAM_CONTEXT.isFlagged);

            fetch(EXAM_CONTEXT.contextPath + '/student/exam/autosave', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded;charset=UTF-8' },
                body: params.toString()
            })
            .then(res => res.json())
            .then(data => {
                if (data.status === 'SAVED') {
                    if (timeEl) timeEl.textContent = data.timestamp;
                } else if (data.isExpired) {
                    alert("Examination session has expired.");
                    document.getElementById('finalSubmitForm').submit();
                }
            })
            .catch(err => {
                console.error("Autosave network issue", err);
                if (timeEl) timeEl.textContent = "Offline (Cached)";
            });
        }

        function updatePaletteIndicator(qId, hasAnswer, isFlagged) {
            const pBtn = document.getElementById('palette-btn-' + qId);
            const rBtn = document.getElementById('ribbon-btn-' + qId);

            [pBtn, rBtn].forEach(btn => {
                if (!btn) return;
                if (isFlagged) {
                    btn.className = "h-10 w-8 sm:w-auto rounded-xl font-mono font-bold text-xs flex items-center justify-center transition-all cursor-pointer relative bg-secondary-fixed text-on-secondary-fixed border border-secondary ring-2 ring-primary ring-offset-1";
                } else if (hasAnswer) {
                    btn.className = "h-10 w-8 sm:w-auto rounded-xl font-mono font-bold text-xs flex items-center justify-center transition-all cursor-pointer relative bg-emerald-600 text-white shadow-xs ring-2 ring-primary ring-offset-1";
                } else {
                    btn.className = "h-10 w-8 sm:w-auto rounded-xl font-mono font-bold text-xs flex items-center justify-center transition-all cursor-pointer relative bg-surface-container text-on-surface-variant ring-2 ring-primary ring-offset-1";
                }
            });
        }

        // 6. Navigation
        function navigateNext() {
            const nextIdx = EXAM_CONTEXT.currentQIndex + 1;
            navigateToQuestion(nextIdx);
        }

        function navigatePrevious() {
            const prevIdx = Math.max(0, EXAM_CONTEXT.currentQIndex - 1);
            navigateToQuestion(prevIdx);
        }

        function navigateToQuestion(targetIndex) {
            document.getElementById('nav-targetQ').value = targetIndex;
            document.getElementById('navigationForm').submit();
        }

        // 7. Modals
        function togglePaletteModal(show) {
            const modal = document.getElementById('paletteModal');
            if (modal) modal.classList.toggle('hidden', !show);
        }

        function openSubmitModal() {
            const modal = document.getElementById('submitModal');
            if (modal) modal.classList.remove('hidden');
        }

        function closeSubmitModal() {
            const modal = document.getElementById('submitModal');
            if (modal) modal.classList.add('hidden');
        }

        // 8. Integrity Telemetry Monitoring (Indicator only)
        document.addEventListener('visibilitychange', function () {
            if (document.hidden) {
                fetch(EXAM_CONTEXT.contextPath + '/student/exam/telemetry', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                    body: 'attemptId=' + EXAM_CONTEXT.attemptId + '&eventType=FOCUS_LOST&details=' + encodeURIComponent('Window blur or tab switch detected')
                }).catch(() => {});
            }
        });
    </script>
</body>
</html>
