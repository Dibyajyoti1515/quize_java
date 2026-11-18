<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no, viewport-fit=cover"/>
    <meta name="theme-color" content="#4f46e5"/>
    <title>${examSession.attempt.quizTitle} | QuizTrack Examination Engine</title>

    <!-- Google Fonts & Material Symbols -->
    <link href="https://fonts.googleapis.com" rel="preconnect"/>
    <link crossorigin="" href="https://fonts.gstatic.com" rel="preconnect"/>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=JetBrains+Mono:wght@400;500;600;700&family=Plus+Jakarta+Sans:wght@600;700;800&display=swap" rel="stylesheet"/>
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200" rel="stylesheet"/>

    <style>
        @layer base {
            html, body {
                margin: 0;
                padding: 0;
                overscroll-behavior: none;
                -webkit-tap-highlight-color: transparent;
            }
        }
        ::-webkit-scrollbar { display: none; }
        .material-symbols-outlined {
            font-variation-settings: 'FILL' 0, 'wght' 500, 'GRAD' 0, 'opsz' 24;
        }
        .material-symbols-outlined.filled {
            font-variation-settings: 'FILL' 1;
        }
    </style>

    <!-- Tailwind CDN with Extended Theme -->
    <script src="https://cdn.tailwindcss.com"></script>
    <script>
        tailwind.config = {
            theme: {
                extend: {
                    colors: {
                        primary: '#4f46e5',
                        'primary-dark': '#4338ca',
                        'primary-light': '#eef2ff'
                    },
                    fontFamily: {
                        display: ['Plus Jakarta Sans', 'sans-serif'],
                        body: ['Inter', 'sans-serif'],
                        mono: ['JetBrains Mono', 'monospace']
                    },
                    boxShadow: {
                        '2xs': '0 1px 2px 0 rgba(0, 0, 0, 0.05)',
                        'hud': '0 4px 20px -2px rgba(79, 70, 229, 0.08)'
                    }
                }
            }
        };
    </script>
</head>
<body class="bg-[#f8faff] font-body text-slate-800 antialiased select-none min-h-screen flex flex-col justify-between">

    <!-- Top Examination Command Bar -->
    <header class="fixed top-0 left-0 right-0 z-40 bg-white/95 backdrop-blur-md border-b border-slate-200/90 shadow-2xs">
        <div class="max-w-[1680px] mx-auto h-16 md:h-20 px-4 sm:px-6 lg:px-8 flex items-center justify-between gap-4">
            
            <!-- Left: Brand, Exam Title & Candidate Identity -->
            <div class="flex items-center gap-3.5 min-w-0">
                <div class="w-10 h-10 md:w-11 md:h-11 rounded-xl bg-gradient-to-tr from-indigo-600 to-indigo-500 text-white flex items-center justify-center shrink-0 shadow-sm">
                    <span class="material-symbols-outlined text-[22px]">quiz</span>
                </div>
                <div class="flex flex-col min-w-0">
                    <div class="flex items-center gap-2 flex-nowrap">
                        <h1 class="font-display font-bold text-sm sm:text-base md:text-lg text-slate-900 truncate leading-snug" title="${examSession.attempt.quizTitle}">
                            ${examSession.attempt.quizTitle}
                        </h1>
                        <c:if test="${not empty examSession.attempt.subjectCode}">
                            <span class="hidden sm:inline-block px-2.5 py-0.5 rounded-md bg-indigo-50 text-indigo-700 font-mono text-[11px] font-bold border border-indigo-100 shrink-0">
                                ${examSession.attempt.subjectCode}
                            </span>
                        </c:if>
                    </div>
                    <div class="flex items-center gap-2 text-xs text-slate-500 font-medium">
                        <span class="text-indigo-600 font-semibold flex items-center gap-1">
                            <span class="w-1.5 h-1.5 rounded-full bg-emerald-500 animate-pulse"></span>
                            Proctored Session
                        </span>
                        <span class="text-slate-300">•</span>
                        <span class="truncate hidden md:inline">Candidate: <strong class="text-slate-700 font-semibold"><c:out value="${sessionScope.userFullName}"/></strong></span>
                        <span class="text-slate-300 hidden md:inline">•</span>
                        <span class="font-mono text-slate-600">Seat ID: <strong class="text-indigo-600 font-bold">QT-${sessionScope.userId}</strong></span>
                    </div>
                </div>
            </div>

            <!-- Center: Authoritative Live Countdown Timer & Autosave HUD -->
            <div class="flex items-center gap-3 bg-slate-50/90 border border-slate-200/90 px-3.5 sm:px-5 py-1.5 rounded-full shadow-inner shrink-0">
                <div class="flex items-center gap-2">
                    <span class="material-symbols-outlined text-rose-600 animate-pulse text-[20px]">timer</span>
                    <div class="flex flex-col">
                        <span class="font-mono text-sm sm:text-base md:text-lg font-bold text-slate-800 tracking-wider leading-none" id="countdown-timer">
                            ${examSession.formattedRemainingTime}
                        </span>
                        <span class="text-[9px] font-mono uppercase text-slate-400 font-semibold hidden lg:inline-block">Time Remaining</span>
                    </div>
                </div>
                <div class="h-5 w-px bg-slate-200 hidden sm:block"></div>
                <div class="hidden md:flex items-center gap-1.5 text-xs text-slate-500">
                    <span class="material-symbols-outlined text-emerald-600 text-[18px]">cloud_done</span>
                    <span id="autosave-label">Synced: <span class="font-mono font-semibold text-slate-700" id="autosave-time">Just now</span></span>
                </div>
            </div>

            <!-- Right: Proctoring Telemetry, Fullscreen Toggle & Submit CTA -->
            <div class="flex items-center gap-2 sm:gap-3 shrink-0">
                
                <!-- Tab Switch Strike Telemetry Badge -->
                <div class="flex items-center gap-1.5 px-3 py-1.5 rounded-xl border border-slate-200 bg-slate-50 text-xs font-semibold" id="strike-badge" title="Tab-switch and focus violation counter">
                    <span class="material-symbols-outlined text-[16px] text-amber-500" id="strike-icon">warning</span>
                    <span class="text-slate-500 hidden sm:inline">Strikes:</span>
                    <span class="font-mono font-bold text-slate-800" id="strike-count">${examSession.attempt.tabSwitchCount}</span>
                    <span class="text-slate-400 font-mono">/ <c:out value="${examSession.attempt.maxTabSwitches > 0 ? examSession.attempt.maxTabSwitches : 3}"/></span>
                </div>

                <!-- Fullscreen Toggle Button -->
                <button type="button" onclick="toggleFullscreen()" id="fullscreen-toggle-btn" class="hidden md:flex items-center gap-1.5 px-3 py-1.5 rounded-xl border border-slate-200 bg-white hover:bg-slate-50 text-slate-700 text-xs font-semibold transition-colors cursor-pointer" title="Toggle Fullscreen Lockdown">
                    <span class="material-symbols-outlined text-[16px]" id="fullscreen-btn-icon">fullscreen</span>
                    <span id="fullscreen-btn-text">Fullscreen</span>
                </button>

                <!-- Level-3 Guard Status -->
                <div class="hidden xl:flex items-center gap-1.5 px-3 py-1.5 rounded-xl bg-emerald-50 text-emerald-700 border border-emerald-200/80 text-xs font-semibold">
                    <span class="w-2 h-2 rounded-full bg-emerald-500 animate-ping"></span>
                    <span class="material-symbols-outlined text-[16px]">shield</span>
                    <span>Level-3 Guard</span>
                </div>

                <!-- Answered Progress Counter -->
                <div class="hidden sm:flex items-center gap-1 text-xs px-3 py-1.5 rounded-xl bg-indigo-50/80 border border-indigo-100 text-slate-700 font-semibold">
                    <span class="text-slate-500">Progress:</span>
                    <span class="font-mono text-indigo-600 font-bold" id="progress-text">${examSession.answeredCount}</span>
                    <span class="text-slate-400">/ ${examSession.totalQuestions}</span>
                </div>

                <!-- Finish & Submit Primary Action -->
                <button type="button" onclick="openSubmitModal()" class="px-3.5 sm:px-5 py-2 rounded-xl bg-rose-600 hover:bg-rose-700 text-white font-semibold text-xs sm:text-sm shadow-sm hover:shadow transition-all flex items-center gap-1.5 cursor-pointer active:scale-95">
                    <span class="material-symbols-outlined text-[18px]">lock</span>
                    <span class="hidden sm:inline">Finish &amp; Submit</span>
                    <span class="sm:hidden">Submit</span>
                </button>
            </div>

        </div>
    </header>

    <!-- Mobile Quick-Palette Ribbon (Visible on small screens) -->
    <div class="lg:hidden fixed top-16 md:top-20 left-0 right-0 z-30 bg-white px-3 py-2 border-b border-slate-200 flex items-center gap-2 shadow-2xs">
        <div class="flex-1 overflow-x-auto flex items-center gap-1.5 py-0.5 no-scrollbar" id="mobile-quick-ribbon">
            <c:forEach var="q" items="${examSession.questions}" varStatus="loop">
                <button type="button" onclick="navigateToQuestion(${loop.index})" 
                        id="ribbon-btn-${q.questionId}"
                        class="w-8 h-8 rounded-lg text-xs font-mono font-bold flex items-center justify-center shrink-0 transition-all
                        ${loop.index == examSession.currentQuestionIndex ? 'bg-indigo-600 text-white ring-2 ring-indigo-600 ring-offset-1 scale-105 shadow-sm' : 
                          q.flaggedForReview ? 'bg-violet-600 text-white' :
                          (q.selectedOptionId != null && q.selectedOptionId > 0) ? 'bg-emerald-600 text-white' :
                          'bg-slate-100 text-slate-600'}">
                    ${q.questionNumber}
                </button>
            </c:forEach>
        </div>
        <button type="button" onclick="togglePaletteModal(true)" class="p-2 rounded-lg bg-slate-100 text-slate-700 hover:bg-slate-200 shrink-0" title="Expand Full Question Palette">
            <span class="material-symbols-outlined text-[20px]">grid_view</span>
        </button>
    </div>

    <!-- Main Examination Content Container -->
    <main class="w-full max-w-[1680px] mx-auto px-4 sm:px-6 lg:px-8 pt-24 md:pt-28 pb-20 lg:pb-12 flex-1">
        <div class="flex flex-col lg:flex-row gap-6 lg:gap-8 items-start">
            
            <!-- LEFT REGION: Active Question Chamber (72% Width) -->
            <div class="w-full lg:w-[72%] flex flex-col gap-6">
                
                <!-- Main Question Workspace Card -->
                <div class="bg-white rounded-2xl p-6 sm:p-8 md:p-10 shadow-sm border border-slate-200/90 relative">
                    <c:forEach var="q" items="${examSession.questions}" varStatus="loop">
                        <div id="question-chamber-${loop.index}" class="question-chamber ${loop.index == examSession.currentQuestionIndex ? '' : 'hidden'} flex flex-col gap-6">
                            
                            <!-- Question Meta Header -->
                            <div class="flex flex-wrap items-center justify-between gap-3 pb-5 border-b border-slate-100">
                                <div class="flex items-center gap-2 flex-wrap">
                                    <span class="font-display text-2xl sm:text-3xl font-bold text-slate-900 tracking-tight">
                                        Question ${q.questionNumber}
                                    </span>
                                    <span class="text-sm text-slate-400 font-medium">of ${examSession.totalQuestions}</span>
                                    
                                    <!-- Human-friendly Question Type Pill -->
                                    <span class="ml-2 px-3 py-1 rounded-full text-xs font-semibold border flex items-center gap-1.5
                                        ${q.questionType == 'MULTI_CHOICE' ? 'bg-violet-50 text-violet-700 border-violet-200' :
                                          q.questionType == 'TRUE_FALSE' ? 'bg-sky-50 text-sky-700 border-sky-200' :
                                          'bg-indigo-50 text-indigo-700 border-indigo-200'}">
                                        <span class="w-1.5 h-1.5 rounded-full ${q.questionType == 'MULTI_CHOICE' ? 'bg-violet-500' : q.questionType == 'TRUE_FALSE' ? 'bg-sky-500' : 'bg-indigo-500'}"></span>
                                        <c:choose>
                                            <c:when test="${q.questionType == 'SINGLE_CHOICE'}">Single Choice</c:when>
                                            <c:when test="${q.questionType == 'MULTI_CHOICE'}">Multiple Choice (Select all that apply)</c:when>
                                            <c:when test="${q.questionType == 'TRUE_FALSE'}">True / False</c:when>
                                            <c:otherwise>${q.questionType}</c:otherwise>
                                        </c:choose>
                                    </span>
                                </div>

                                <div class="flex items-center gap-2.5 flex-wrap">
                                    <c:if test="${not empty q.taxonomyTopic}">
                                        <span class="px-3 py-1 rounded-lg bg-slate-100 text-slate-700 text-xs font-semibold flex items-center gap-1">
                                            <span class="material-symbols-outlined text-[14px] text-slate-500">category</span>
                                            ${q.taxonomyTopic}
                                        </span>
                                    </c:if>
                                    <span class="px-3 py-1 rounded-lg bg-emerald-50 text-emerald-700 font-mono text-xs font-bold border border-emerald-200/80">
                                        +<fmt:formatNumber value="${q.points}" minFractionDigits="1"/>
                                        <c:if test="${examSession.attempt.negativeMarking}">
                                            / -<fmt:formatNumber value="${examSession.attempt.negativeMarkValue}" minFractionDigits="1"/>
                                        </c:if> Mark(s)
                                    </span>
                                </div>
                            </div>

                            <!-- Question Statement -->
                            <div class="text-lg sm:text-xl text-slate-900 leading-relaxed font-medium pt-1">
                                ${q.questionText}
                            </div>

                            <!-- Code Snippet Box (If present) -->
                            <c:if test="${not empty q.codeSnippet}">
                                <div class="bg-slate-900 text-slate-100 rounded-xl p-4 overflow-x-auto shadow-inner border border-slate-800">
                                    <div class="flex items-center justify-between pb-2 mb-2 border-b border-slate-800 text-xs font-mono text-indigo-400">
                                        <span>TECHNICAL SOURCE CONTEXT</span>
                                        <span>READ-ONLY</span>
                                    </div>
                                    <pre class="font-mono text-xs sm:text-sm leading-relaxed"><code>${q.codeSnippet}</code></pre>
                                </div>
                            </c:if>

                            <!-- Interactive Option Selection Cards -->
                            <div class="flex flex-col gap-3 pt-2" id="options-group-${q.questionId}">
                                <c:set var="isMulti" value="${q.questionType == 'MULTI_CHOICE'}"/>
                                <c:forEach var="opt" items="${q.options}">
                                    <c:set var="optChecked" value="${q.isOptionSelected(opt.optionId)}"/>
                                    
                                    <label id="opt-label-${q.questionId}-${opt.optionId}" 
                                           class="option-card option-card-${q.questionId} group relative flex items-center justify-between p-4 sm:p-5 rounded-2xl border-2 transition-all duration-150 cursor-pointer select-none
                                           ${optChecked ? 
                                             'bg-indigo-50/70 border-indigo-600 shadow-sm ring-1 ring-indigo-600/30' : 
                                             'bg-white border-slate-200/90 hover:border-indigo-300 hover:bg-slate-50/70 shadow-2xs'}">
                                        
                                        <div class="flex items-center gap-4 flex-1 min-w-0">
                                            <!-- Standard Hidden Input for State -->
                                            <input type="${isMulti ? 'checkbox' : 'radio'}" 
                                                   name="examOption_${q.questionId}" 
                                                   value="${opt.optionId}" 
                                                   class="sr-only"
                                                   ${optChecked ? 'checked' : ''}
                                                   onchange="handleOptionSelect(${loop.index}, ${q.questionId}, ${opt.optionId}, '${q.questionType}')"/>

                                            <!-- Letter Badge (A, B, C, D) -->
                                            <span id="opt-badge-${q.questionId}-${opt.optionId}" 
                                                  class="opt-letter-badge w-9 h-9 rounded-xl font-mono font-bold text-sm flex items-center justify-center shrink-0 transition-all
                                                  ${optChecked ? 
                                                    'bg-indigo-600 text-white shadow-xs scale-105' : 
                                                    'bg-slate-100 text-slate-700 border border-slate-200/80 group-hover:bg-indigo-100 group-hover:text-indigo-700'}">
                                                ${opt.optionLetter}
                                            </span>

                                            <!-- Option Text Content -->
                                            <span class="text-base sm:text-lg text-slate-800 font-medium leading-relaxed flex-1">
                                                ${opt.optionText}
                                            </span>
                                        </div>

                                        <!-- Selected Checkmark Indicator Pill -->
                                        <div id="opt-check-${q.questionId}-${opt.optionId}" class="opt-check-indicator shrink-0 pl-3 ${optChecked ? '' : 'hidden'}">
                                            <span class="px-2.5 py-1 rounded-full bg-indigo-600 text-white font-semibold text-xs flex items-center gap-1 shadow-xs">
                                                <span class="material-symbols-outlined text-[14px]">check</span>
                                                <span class="hidden sm:inline">Selected</span>
                                            </span>
                                        </div>
                                    </label>
                                </c:forEach>
                            </div>

                            <!-- Question Workspace Action Strip -->
                            <div class="flex flex-wrap items-center justify-between gap-4 pt-8 mt-2 border-t border-slate-100">
                                
                                <!-- Left Actions: Flag & Clear -->
                                <div class="flex items-center gap-2.5">
                                    <!-- Mark for Review Button -->
                                    <button type="button" onclick="handleToggleFlag(${loop.index}, ${q.questionId})" id="flag-btn-${q.questionId}"
                                            class="px-4 py-2.5 rounded-xl font-semibold text-xs sm:text-sm transition-all flex items-center gap-1.5 cursor-pointer
                                            ${q.flaggedForReview ? 
                                              'bg-violet-700 text-white shadow-sm' : 
                                              'border border-violet-200 bg-violet-50/70 hover:bg-violet-100 text-violet-700'}">
                                        <span class="material-symbols-outlined text-[18px]" id="flag-btn-icon-${q.questionId}">
                                            ${q.flaggedForReview ? 'bookmark' : 'bookmark_border'}
                                        </span>
                                        <span id="flag-btn-text-${q.questionId}">
                                            ${q.flaggedForReview ? 'Marked for Review' : 'Mark for Review'}
                                        </span>
                                    </button>

                                    <!-- Clear Choice Button -->
                                    <button type="button" onclick="handleClearChoice(${loop.index}, ${q.questionId}, '${q.questionType}')" 
                                            class="px-3.5 py-2.5 rounded-xl border border-slate-200 bg-white hover:bg-slate-100 text-slate-600 hover:text-slate-900 font-semibold text-xs sm:text-sm transition-all flex items-center gap-1 cursor-pointer" 
                                            title="Clear chosen option">
                                        <span class="material-symbols-outlined text-[16px]">backspace</span>
                                        <span>Clear</span>
                                    </button>
                                </div>

                                <!-- Right Actions: Previous & Next / Finish -->
                                <div class="flex items-center gap-3">
                                    <button type="button" onclick="navigatePrevious()" 
                                            class="px-4 py-2.5 rounded-xl border border-slate-200 bg-white hover:bg-slate-100 text-slate-700 font-semibold text-xs sm:text-sm transition-all flex items-center gap-1.5 cursor-pointer ${loop.first ? 'opacity-40 pointer-events-none' : ''}">
                                        <span class="material-symbols-outlined text-[18px]">arrow_back</span>
                                        <span>Previous</span>
                                    </button>

                                    <c:choose>
                                        <c:when test="${!loop.last}">
                                            <button type="button" onclick="navigateNext()" 
                                                    class="px-6 py-2.5 rounded-xl bg-indigo-600 hover:bg-indigo-700 text-white font-semibold text-xs sm:text-sm transition-all shadow-sm hover:shadow flex items-center gap-2 cursor-pointer active:scale-95">
                                                <span>Save &amp; Next</span>
                                                <span class="material-symbols-outlined text-[18px]">arrow_forward</span>
                                            </button>
                                        </c:when>
                                        <c:otherwise>
                                            <button type="button" onclick="openSubmitModal()" 
                                                    class="px-6 py-2.5 rounded-xl bg-emerald-600 hover:bg-emerald-700 text-white font-semibold text-xs sm:text-sm transition-all shadow-sm hover:shadow flex items-center gap-2 cursor-pointer active:scale-95">
                                                <span class="material-symbols-outlined text-[18px]">fact_check</span>
                                                <span>Review &amp; Finalize</span>
                                            </button>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>

                        </div>
                    </c:forEach>
                </div>

            </div>

            <!-- RIGHT REGION: Question Palette Navigator (28% Width, Sticky) -->
            <div class="hidden lg:flex w-full lg:w-[28%] flex-col gap-6 sticky top-24">
                <div class="bg-white rounded-2xl p-6 shadow-sm border border-slate-200/90 flex flex-col gap-5">
                    
                    <!-- Palette Header -->
                    <div class="flex items-center justify-between pb-3.5 border-b border-slate-100">
                        <div class="flex items-center gap-2">
                            <span class="material-symbols-outlined text-indigo-600 text-[22px]">grid_view</span>
                            <h2 class="font-display font-bold text-base text-slate-900">Question Palette</h2>
                        </div>
                        <span class="px-2.5 py-0.5 rounded-full bg-slate-100 text-slate-700 font-mono text-xs font-bold">
                            ${examSession.totalQuestions} Questions
                        </span>
                    </div>

                    <!-- Legend Status Metrics -->
                    <div class="grid grid-cols-2 gap-2 text-xs">
                        <div class="flex items-center gap-2 p-2 rounded-xl bg-slate-50 border border-slate-100">
                            <span class="w-3.5 h-3.5 rounded-md bg-emerald-600 shrink-0"></span>
                            <span class="text-slate-600">Answered: <strong class="text-slate-900 font-bold" id="answered-count-badge">${examSession.answeredCount}</strong></span>
                        </div>
                        <div class="flex items-center gap-2 p-2 rounded-xl bg-slate-50 border border-slate-100">
                            <span class="w-3.5 h-3.5 rounded-md bg-violet-600 shrink-0"></span>
                            <span class="text-slate-600">Review: <strong class="text-slate-900 font-bold" id="flagged-count-badge">${examSession.flaggedCount}</strong></span>
                        </div>
                        <div class="flex items-center gap-2 p-2 rounded-xl bg-slate-50 border border-slate-100">
                            <span class="w-3.5 h-3.5 rounded-md bg-white border-2 border-indigo-600 shrink-0"></span>
                            <span class="text-slate-600 font-medium">Current Focus</span>
                        </div>
                        <div class="flex items-center gap-2 p-2 rounded-xl bg-slate-50 border border-slate-100">
                            <span class="w-3.5 h-3.5 rounded-md bg-slate-200 shrink-0"></span>
                            <span class="text-slate-500 font-medium">Not Visited</span>
                        </div>
                    </div>

                    <!-- Question Number Grid -->
                    <div class="grid grid-cols-5 gap-2.5 pt-1 max-h-[380px] overflow-y-auto pr-1">
                        <c:forEach var="q" items="${examSession.questions}" varStatus="loop">
                            <button type="button" onclick="navigateToQuestion(${loop.index})" 
                                    id="palette-btn-${q.questionId}"
                                    class="w-full aspect-square rounded-xl font-mono font-bold text-sm flex items-center justify-center transition-all cursor-pointer relative shadow-2xs
                                    ${loop.index == examSession.currentQuestionIndex ? 'ring-2 ring-indigo-600 ring-offset-2 scale-105 font-black z-10 ' : ''}
                                    ${q.flaggedForReview ? 'bg-violet-600 text-white' :
                                      (q.selectedOptionId != null && q.selectedOptionId > 0) ? 'bg-emerald-600 text-white hover:bg-emerald-700' :
                                      'bg-slate-100 text-slate-600 hover:bg-slate-200'}">
                                <span>${q.questionNumber}</span>
                                <span class="palette-flag-icon material-symbols-outlined text-[10px] text-white absolute -top-1 -right-1 bg-violet-800 rounded-full p-0.5 ${q.flaggedForReview ? '' : 'hidden'}">bookmark</span>
                            </button>
                        </c:forEach>
                    </div>

                    <!-- Examination Cryptographic Session Seal -->
                    <div class="p-3.5 rounded-xl bg-slate-50 border border-slate-200/80 flex items-start gap-2.5 text-xs text-slate-500">
                        <span class="material-symbols-outlined text-emerald-600 text-[20px] shrink-0 mt-0.5">verified_user</span>
                        <div>
                            <span class="font-bold text-slate-800">Cryptographic Session Lock</span>
                            <p class="text-[11px] text-slate-500 mt-0.5 leading-snug">
                                Server-side timestamps authoritative. Every answer selection autosaved to PostgreSQL.
                            </p>
                        </div>
                    </div>

                </div>
            </div>

        </div>
    </main>

    <!-- Mobile Full Palette Drawer Modal -->
    <div id="paletteModal" class="fixed inset-0 z-50 bg-black/60 backdrop-blur-xs hidden flex items-end sm:items-center justify-center p-0 sm:p-4">
        <div class="bg-white w-full max-w-lg rounded-t-3xl sm:rounded-2xl p-6 shadow-2xl border border-slate-200 max-h-[85vh] flex flex-col gap-4 overflow-y-auto">
            <div class="flex items-center justify-between pb-3 border-b border-slate-100">
                <div class="flex items-center gap-2">
                    <span class="material-symbols-outlined text-indigo-600 text-[22px]">grid_view</span>
                    <h3 class="font-display font-bold text-lg text-slate-900">Complete Question Overview</h3>
                </div>
                <button type="button" onclick="togglePaletteModal(false)" class="p-1 rounded-lg text-slate-500 hover:bg-slate-100">
                    <span class="material-symbols-outlined">close</span>
                </button>
            </div>

            <!-- Mobile Grid -->
            <div class="grid grid-cols-5 gap-2.5 py-2">
                <c:forEach var="q" items="${examSession.questions}" varStatus="loop">
                    <button type="button" onclick="navigateToQuestion(${loop.index}); togglePaletteModal(false);" 
                            class="h-11 rounded-xl font-mono font-bold text-sm flex items-center justify-center transition-all cursor-pointer relative
                            ${loop.index == examSession.currentQuestionIndex ? 'ring-2 ring-indigo-600 ring-offset-2 scale-105 font-black ' : ''}
                            ${q.flaggedForReview ? 'bg-violet-600 text-white' :
                              (q.selectedOptionId != null && q.selectedOptionId > 0) ? 'bg-emerald-600 text-white' :
                              'bg-slate-100 text-slate-600'}">
                        <span>${q.questionNumber}</span>
                        <span class="palette-flag-icon material-symbols-outlined text-[10px] text-white absolute -top-1 -right-1 bg-violet-800 rounded-full p-0.5 ${q.flaggedForReview ? '' : 'hidden'}">bookmark</span>
                    </button>
                </c:forEach>
            </div>

            <button type="button" onclick="togglePaletteModal(false)" class="w-full py-3 rounded-xl bg-slate-100 hover:bg-slate-200 font-semibold text-sm text-slate-800 mt-2">
                Resume Question ${examSession.currentQuestion.questionNumber}
            </button>
        </div>
    </div>

    <!-- Final Submission Confirmation Modal -->
    <div id="submitModal" class="fixed inset-0 z-50 bg-black/60 backdrop-blur-sm hidden flex items-center justify-center p-4">
        <div class="bg-white max-w-md w-full rounded-2xl p-6 sm:p-8 shadow-2xl border border-slate-200 flex flex-col gap-5 text-center">
            
            <div class="w-14 h-14 rounded-2xl bg-indigo-50 text-indigo-600 flex items-center justify-center mx-auto shadow-sm border border-indigo-100">
                <span class="material-symbols-outlined text-[32px]">fact_check</span>
            </div>

            <div>
                <h3 class="font-display font-bold text-xl text-slate-900">Confirm Final Submission?</h3>
                <p class="text-xs text-slate-500 mt-1">
                    Please review your examination summary before concluding this proctored session.
                </p>
            </div>

            <!-- Review Summary Matrix -->
            <div class="grid grid-cols-3 gap-2 p-3.5 bg-slate-50 rounded-xl text-center border border-slate-200/80">
                <div>
                    <span class="text-[10px] font-mono uppercase text-slate-400 font-semibold block">Answered</span>
                    <span class="font-mono text-lg font-bold text-emerald-600" id="modal-answered-count">${examSession.answeredCount}</span>
                </div>
                <div>
                    <span class="text-[10px] font-mono uppercase text-slate-400 font-semibold block">Flagged</span>
                    <span class="font-mono text-lg font-bold text-violet-600" id="modal-flagged-count">${examSession.flaggedCount}</span>
                </div>
                <div>
                    <span class="text-[10px] font-mono uppercase text-slate-400 font-semibold block">Unanswered</span>
                    <span class="font-mono text-lg font-bold text-rose-600" id="modal-unanswered-count">${examSession.totalQuestions - examSession.answeredCount}</span>
                </div>
            </div>

            <div class="text-xs text-rose-700 bg-rose-50 border border-rose-200 p-3 rounded-xl text-left flex items-start gap-2">
                <span class="material-symbols-outlined text-rose-600 text-[18px] shrink-0 mt-0.5">warning</span>
                <p class="leading-relaxed">
                    <strong>Notice:</strong> Once submitted, your examination is sealed and calculated by the registry. You cannot re-enter this session.
                </p>
            </div>

            <form id="finalSubmitForm" method="POST" action="${pageContext.request.contextPath}/student/exam" class="flex flex-col gap-3">
                <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}"/>
                <input type="hidden" name="action" value="submit"/>
                <input type="hidden" name="attemptId" value="${examSession.attempt.attemptId}"/>

                <div class="flex items-center gap-3">
                    <button type="button" onclick="closeSubmitModal()" class="flex-1 py-3 rounded-xl border border-slate-200 bg-white hover:bg-slate-100 font-semibold text-sm text-slate-700 transition-all cursor-pointer">
                        Return to Exam
                    </button>
                    <button type="submit" id="final-submit-btn" class="flex-1 py-3 rounded-xl bg-indigo-600 hover:bg-indigo-700 text-white font-semibold text-sm transition-all shadow-md cursor-pointer">
                        Confirm &amp; Submit
                    </button>
                </div>
            </form>

        </div>
    </div>

    <!-- FULLSCREEN LOCKDOWN OVERLAY (Initial Entry) -->
    <div id="fullscreenLockModal" class="fixed inset-0 z-50 bg-slate-950/85 backdrop-blur-md hidden flex items-center justify-center p-4">
        <div class="bg-white max-w-md w-full rounded-2xl p-6 sm:p-8 shadow-2xl border border-indigo-200 flex flex-col items-center text-center">
            <div class="w-16 h-16 rounded-2xl bg-indigo-600 text-white flex items-center justify-center mb-4 shadow-md">
                <span class="material-symbols-outlined text-[36px]">fullscreen</span>
            </div>
            <span class="px-3 py-1 rounded-full bg-indigo-50 text-indigo-700 font-mono text-xs font-bold uppercase mb-2 border border-indigo-100">
                Proctored Environment
            </span>
            <h3 class="font-display font-bold text-xl text-slate-900">Fullscreen Lockdown Required</h3>
            <p class="text-xs text-slate-500 mt-2 leading-relaxed">
                This examination operates in strict proctored fullscreen lockdown. Click below to expand the browser into fullscreen mode and begin your assessment.
            </p>
            <button type="button" onclick="activateFullscreen()" class="mt-6 w-full py-3.5 rounded-xl bg-indigo-600 hover:bg-indigo-700 text-white font-bold text-sm shadow-md flex items-center justify-center gap-2 cursor-pointer transition-all">
                <span class="material-symbols-outlined text-[20px]">lock_open</span>
                <span>Enter Fullscreen &amp; Unlock Exam</span>
            </button>
        </div>
    </div>

    <!-- FULLSCREEN EXIT WARNING MODAL -->
    <div id="fullscreenExitModal" class="fixed inset-0 z-50 bg-slate-950/85 backdrop-blur-md hidden flex items-center justify-center p-4">
        <div class="bg-white max-w-md w-full rounded-2xl p-6 sm:p-8 shadow-2xl border-2 border-rose-500 flex flex-col items-center text-center">
            <div class="w-16 h-16 rounded-2xl bg-rose-600 text-white flex items-center justify-center mb-4 shadow-md">
                <span class="material-symbols-outlined text-[36px]">fullscreen_exit</span>
            </div>
            <span class="px-3 py-1 rounded-full bg-rose-50 text-rose-700 font-mono text-xs font-bold uppercase mb-2 border border-rose-200">
                Lockdown Alert
            </span>
            <h3 class="font-display font-bold text-xl text-slate-900">Fullscreen Viewport Exited</h3>
            <p class="text-xs text-slate-500 mt-2 leading-relaxed">
                You exited fullscreen lockdown mode. This action has been recorded in the proctoring audit log. Please restore fullscreen to continue.
            </p>
            <button type="button" onclick="activateFullscreen()" class="mt-6 w-full py-3.5 rounded-xl bg-rose-600 hover:bg-rose-700 text-white font-bold text-sm shadow-md flex items-center justify-center gap-2 cursor-pointer transition-all">
                <span class="material-symbols-outlined text-[20px]">fullscreen</span>
                <span>Resume Fullscreen Lockdown</span>
            </button>
        </div>
    </div>

    <!-- TAB SWITCH / FOCUS LOST STRIKE WARNING MODAL -->
    <div id="tabSwitchModal" class="fixed inset-0 z-50 bg-slate-950/90 backdrop-blur-sm hidden flex items-center justify-center p-4">
        <div class="bg-white max-w-md w-full rounded-2xl p-6 sm:p-8 shadow-2xl border-2 border-amber-500 flex flex-col items-center text-center">
            <div class="w-16 h-16 rounded-2xl bg-amber-100 text-amber-700 flex items-center justify-center mb-4 shadow-sm">
                <span class="material-symbols-outlined text-[36px]">tab_unselected</span>
            </div>
            <span class="px-3 py-1 rounded-full bg-amber-100 text-amber-800 font-mono text-xs font-bold uppercase mb-2 border border-amber-200">
                Proctoring Violation
            </span>
            <h3 class="font-display font-bold text-xl text-slate-900">Tab Switch Detected!</h3>
            <div class="my-3 p-3.5 rounded-xl bg-amber-50 border border-amber-200 text-amber-900 text-xs text-left w-full">
                <p class="font-bold flex items-center gap-1.5 text-sm mb-1 text-amber-800">
                    <span class="material-symbols-outlined text-[18px]">gavel</span>
                    <span>Strike <span id="modal-strike-num">1</span> of <span id="modal-max-strikes">3</span> Logged</span>
                </p>
                <p class="text-[11px] text-amber-700 leading-snug">
                    You switched tabs, minimized the window, or lost browser focus. This event is logged in real-time to the faculty proctoring console.
                </p>
                <p class="text-[11px] font-bold text-amber-800 mt-2" id="modal-remaining-strikes-text">
                    Remaining strikes before automatic exam lockout: 2
                </p>
            </div>
            <button type="button" onclick="acknowledgeStrike()" class="w-full py-3.5 rounded-xl bg-amber-600 hover:bg-amber-700 text-white font-bold text-sm shadow-md flex items-center justify-center gap-2 cursor-pointer transition-all">
                <span class="material-symbols-outlined text-[18px]">verified</span>
                <span>I Acknowledge &bull; Resume Exam</span>
            </button>
        </div>
    </div>

    <!-- STRIKE LOCKOUT TERMINATION MODAL -->
    <div id="strikeLockoutModal" class="fixed inset-0 z-50 bg-black/95 backdrop-blur-md hidden flex items-center justify-center p-4">
        <div class="bg-white max-w-md w-full rounded-2xl p-6 sm:p-8 shadow-2xl border-2 border-rose-600 flex flex-col items-center text-center">
            <div class="w-16 h-16 rounded-2xl bg-rose-600 text-white flex items-center justify-center mb-4 shadow-lg animate-pulse">
                <span class="material-symbols-outlined text-[36px]">block</span>
            </div>
            <span class="px-3 py-1 rounded-full bg-rose-50 text-rose-700 font-mono text-xs font-bold uppercase mb-2 border border-rose-200">
                Lockout Enforced
            </span>
            <h3 class="font-display font-bold text-2xl text-slate-900">Maximum Strikes Exceeded!</h3>
            <p class="text-xs text-slate-500 mt-2 leading-relaxed">
                You reached the maximum allowed tab switch threshold (<span id="lockout-strike-count">3</span>/<span id="lockout-max-strikes">3</span>). Answering has been disabled and your responses are being finalized.
            </p>
            <div class="mt-5 flex items-center justify-center gap-2 text-sm text-rose-600 font-semibold">
                <span class="material-symbols-outlined animate-spin text-[20px]">progress_activity</span>
                <span>Submitting responses to academic registry...</span>
            </div>
        </div>
    </div>

    <!-- Client Examination Engine Controller Script -->
    <script>
        const EXAM_TOTAL_QUESTIONS = ${examSession.totalQuestions};
        const EXAM_CONTEXT = {
            attemptId: ${examSession.attempt.attemptId},
            currentQIndex: ${examSession.currentQuestionIndex},
            totalQuestions: ${examSession.totalQuestions},
            remainingSeconds: ${examSession.remainingSeconds},
            contextPath: '${pageContext.request.contextPath}',
            questions: [
                <c:forEach var="q" items="${examSession.questions}" varStatus="loop">
                {
                    index: ${loop.index},
                    questionId: ${q.questionId},
                    questionType: '${q.questionType}',
                    selectedOptionId: ${q.selectedOptionId != null ? q.selectedOptionId : 0},
                    selectedOptionIds: [
                        <c:forEach var="sid" items="${q.selectedOptionIds}" varStatus="sloop">
                            ${sid}<c:if test="${!sloop.last}">,</c:if>
                        </c:forEach>
                    ],
                    isFlagged: ${q.flaggedForReview}
                }<c:if test="${!loop.last}">,</c:if>
                </c:forEach>
            ]
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
                        timerEl.classList.remove('text-slate-800');
                        timerEl.classList.add('text-rose-600', 'font-black');
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
        function handleOptionSelect(qIndex, qId, optionId, qType) {
            const q = EXAM_CONTEXT.questions[qIndex];
            const isMulti = qType === 'MULTI_CHOICE';

            const chamber = document.getElementById('question-chamber-' + qIndex);
            if (!chamber) return;

            const checkedInputs = chamber.querySelectorAll('input[name="examOption_' + qId + '"]:checked');
            const checkedIds = Array.from(checkedInputs).map(i => parseInt(i.value));

            if (isMulti) {
                q.selectedOptionIds = checkedIds;
                q.selectedOptionId = checkedIds.length > 0 ? checkedIds[0] : 0;
            } else {
                q.selectedOptionIds = [optionId];
                q.selectedOptionId = optionId;
            }

            // Update card styles within this chamber
            chamber.querySelectorAll('.option-card-' + qId).forEach(card => {
                const input = card.querySelector('input[name="examOption_' + qId + '"]');
                const badge = card.querySelector('.opt-letter-badge');
                const checkIndicator = card.querySelector('.opt-check-indicator');
                
                if (input && input.checked) {
                    card.className = "option-card option-card-" + qId + " group relative flex items-center justify-between p-4 sm:p-5 rounded-2xl border-2 transition-all duration-150 cursor-pointer select-none bg-indigo-50/70 border-indigo-600 shadow-sm ring-1 ring-indigo-600/30";
                    if (badge) badge.className = "opt-letter-badge w-9 h-9 rounded-xl font-mono font-bold text-sm flex items-center justify-center shrink-0 transition-all bg-indigo-600 text-white shadow-xs scale-105";
                    if (checkIndicator) checkIndicator.classList.remove('hidden');
                } else {
                    card.className = "option-card option-card-" + qId + " group relative flex items-center justify-between p-4 sm:p-5 rounded-2xl border-2 transition-all duration-150 cursor-pointer select-none bg-white border-slate-200/90 hover:border-indigo-300 hover:bg-slate-50/70 shadow-2xs";
                    if (badge) badge.className = "opt-letter-badge w-9 h-9 rounded-xl font-mono font-bold text-sm flex items-center justify-center shrink-0 transition-all bg-slate-100 text-slate-700 border border-slate-200/80 group-hover:bg-indigo-100 group-hover:text-indigo-700";
                    if (checkIndicator) checkIndicator.classList.add('hidden');
                }
            });

            updatePaletteIndicators(qIndex);
            triggerAutosave(qIndex);
        }

        // 3. Toggle Mark for Review
        function handleToggleFlag(qIndex, qId) {
            const q = EXAM_CONTEXT.questions[qIndex];
            q.isFlagged = !q.isFlagged;

            const btn = document.getElementById('flag-btn-' + qId);
            const icon = document.getElementById('flag-btn-icon-' + qId);
            const txt = document.getElementById('flag-btn-text-' + qId);

            if (q.isFlagged) {
                if (btn) btn.className = "px-4 py-2.5 rounded-xl font-semibold text-xs sm:text-sm transition-all flex items-center gap-1.5 cursor-pointer bg-violet-700 text-white shadow-sm";
                if (icon) icon.textContent = "bookmark";
                if (txt) txt.textContent = "Marked for Review";
            } else {
                if (btn) btn.className = "px-4 py-2.5 rounded-xl font-semibold text-xs sm:text-sm transition-all flex items-center gap-1.5 cursor-pointer border border-violet-200 bg-violet-50/70 hover:bg-violet-100 text-violet-700";
                if (icon) icon.textContent = "bookmark_border";
                if (txt) txt.textContent = "Mark for Review";
            }

            updatePaletteIndicators(qIndex);
            triggerAutosave(qIndex);
        }

        // 4. Clear Choice
        function handleClearChoice(qIndex, qId, qType) {
            const q = EXAM_CONTEXT.questions[qIndex];
            q.selectedOptionId = 0;
            q.selectedOptionIds = [];

            const chamber = document.getElementById('question-chamber-' + qIndex);
            if (!chamber) return;

            chamber.querySelectorAll('input[name="examOption_' + qId + '"]').forEach(r => r.checked = false);
            chamber.querySelectorAll('.option-card-' + qId).forEach(card => {
                card.className = "option-card option-card-" + qId + " group relative flex items-center justify-between p-4 sm:p-5 rounded-2xl border-2 transition-all duration-150 cursor-pointer select-none bg-white border-slate-200/90 hover:border-indigo-300 hover:bg-slate-50/70 shadow-2xs";
                const badge = card.querySelector('.opt-letter-badge');
                if (badge) badge.className = "opt-letter-badge w-9 h-9 rounded-xl font-mono font-bold text-sm flex items-center justify-center shrink-0 transition-all bg-slate-100 text-slate-700 border border-slate-200/80 group-hover:bg-indigo-100 group-hover:text-indigo-700";
                const checkIndicator = card.querySelector('.opt-check-indicator');
                if (checkIndicator) checkIndicator.classList.add('hidden');
            });

            updatePaletteIndicators(qIndex);
            triggerAutosave(qIndex);
        }

        // 5. Asynchronous Background Autosave Call
        function triggerAutosave(qIndex) {
            const q = EXAM_CONTEXT.questions[qIndex];
            if (!q) return;

            const timeEl = document.getElementById('autosave-time');
            if (timeEl) timeEl.textContent = "Saving...";

            const params = new URLSearchParams();
            params.append('attemptId', EXAM_CONTEXT.attemptId);
            params.append('questionId', q.questionId);
            params.append('selectedOptionId', q.selectedOptionId);
            if (q.selectedOptionIds && q.selectedOptionIds.length > 0) {
                params.append('selectedOptionIds', q.selectedOptionIds.join(','));
                q.selectedOptionIds.forEach(id => params.append('selectedOptionId', id));
            }
            params.append('isFlagged', q.isFlagged);
            params.append('csrfToken', '${sessionScope.csrfToken}');

            fetch(EXAM_CONTEXT.contextPath + '/student/exam/autosave', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded;charset=UTF-8',
                    'X-CSRF-Token': '${sessionScope.csrfToken}'
                },
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

        // Update Palette & Ribbon Indicators
        function updatePaletteIndicators(qIndex) {
            const q = EXAM_CONTEXT.questions[qIndex];
            if (!q) return;

            const pBtn = document.getElementById('palette-btn-' + q.questionId);
            const rBtn = document.getElementById('ribbon-btn-' + q.questionId);
            const isMulti = q.questionType === 'MULTI_CHOICE';
            const hasAnswer = isMulti ? (q.selectedOptionIds && q.selectedOptionIds.length > 0) : (q.selectedOptionId > 0);

            [pBtn, rBtn].forEach(btn => {
                if (!btn) return;
                
                // Clear state classes
                btn.className = btn.className
                    .replace(/\b(bg-violet-600|bg-emerald-600|hover:bg-emerald-700|bg-slate-100|text-slate-600|hover:bg-slate-200|text-white)\b/g, '')
                    .trim();

                const flagIcon = btn.querySelector('.palette-flag-icon');

                if (q.isFlagged) {
                    btn.classList.add('bg-violet-600', 'text-white');
                    if (flagIcon) flagIcon.classList.remove('hidden');
                } else if (hasAnswer) {
                    btn.classList.add('bg-emerald-600', 'text-white', 'hover:bg-emerald-700');
                    if (flagIcon) flagIcon.classList.add('hidden');
                } else {
                    btn.classList.add('bg-slate-100', 'text-slate-600', 'hover:bg-slate-200');
                    if (flagIcon) flagIcon.classList.add('hidden');
                }
            });

            // Update stats
            let ansCount = 0;
            let flagCount = 0;
            EXAM_CONTEXT.questions.forEach(item => {
                const m = item.questionType === 'MULTI_CHOICE';
                if (m ? (item.selectedOptionIds && item.selectedOptionIds.length > 0) : (item.selectedOptionId > 0)) {
                    ansCount++;
                }
                if (item.isFlagged) flagCount++;
            });

            const progEl = document.getElementById('progress-text');
            if (progEl) progEl.textContent = ansCount;

            const ansBadge = document.getElementById('answered-count-badge');
            if (ansBadge) ansBadge.textContent = ansCount;

            const flagBadge = document.getElementById('flagged-count-badge');
            if (flagBadge) flagBadge.textContent = flagCount;

            const mAns = document.getElementById('modal-answered-count');
            if (mAns) mAns.textContent = ansCount;

            const mFlag = document.getElementById('modal-flagged-count');
            if (mFlag) mFlag.textContent = flagCount;

            const mUnans = document.getElementById('modal-unanswered-count');
            if (mUnans) mUnans.textContent = (EXAM_TOTAL_QUESTIONS - ansCount);
        }

        // 6. Seamless In-Place Question Navigation (Zero Page Reloads - Fullscreen Preserved!)
        function navigateNext() {
            navigateToQuestion(EXAM_CONTEXT.currentQIndex + 1);
        }

        function navigatePrevious() {
            navigateToQuestion(Math.max(0, EXAM_CONTEXT.currentQIndex - 1));
        }

        function navigateToQuestion(targetIndex) {
            if (targetIndex < 0 || targetIndex >= EXAM_TOTAL_QUESTIONS) return;

            // 1. Hide currently active question chamber
            const oldChamber = document.getElementById('question-chamber-' + EXAM_CONTEXT.currentQIndex);
            if (oldChamber) oldChamber.classList.add('hidden');

            // 2. Show target question chamber
            const newChamber = document.getElementById('question-chamber-' + targetIndex);
            if (newChamber) newChamber.classList.remove('hidden');

            // 3. Update active question index
            EXAM_CONTEXT.currentQIndex = targetIndex;

            // 4. Update palette & mobile ribbon active focus
            updatePaletteFocus(targetIndex);

            // 5. Update browser history state seamlessly without page reload
            try {
                const newUrl = EXAM_CONTEXT.contextPath + '/student/exam?attemptId=' + EXAM_CONTEXT.attemptId + '&q=' + targetIndex;
                window.history.replaceState(null, '', newUrl);
            } catch (e) {}

            // 6. Scroll window to top smoothly
            window.scrollTo({ top: 0, behavior: 'smooth' });
        }

        function updatePaletteFocus(targetIndex) {
            EXAM_CONTEXT.questions.forEach((q, idx) => {
                const pBtn = document.getElementById('palette-btn-' + q.questionId);
                const rBtn = document.getElementById('ribbon-btn-' + q.questionId);
                [pBtn, rBtn].forEach(btn => {
                    if (!btn) return;
                    if (idx === targetIndex) {
                        btn.classList.add('ring-2', 'ring-indigo-600', 'ring-offset-2', 'scale-105', 'font-black', 'z-10');
                    } else {
                        btn.classList.remove('ring-2', 'ring-indigo-600', 'ring-offset-2', 'scale-105', 'font-black', 'z-10');
                    }
                });
                if (idx === targetIndex && rBtn) {
                    rBtn.scrollIntoView({ behavior: 'smooth', inline: 'center', block: 'nearest' });
                }
            });
        }

        // 7. Modals
        function togglePaletteModal(show) {
            const modal = document.getElementById('paletteModal');
            if (modal) modal.classList.toggle('hidden', !show);
        }

        function openSubmitModal() {
            let ansCount = 0;
            let flagCount = 0;
            EXAM_CONTEXT.questions.forEach(item => {
                const m = item.questionType === 'MULTI_CHOICE';
                if (m ? (item.selectedOptionIds && item.selectedOptionIds.length > 0) : (item.selectedOptionId > 0)) {
                    ansCount++;
                }
                if (item.isFlagged) flagCount++;
            });
            const mAns = document.getElementById('modal-answered-count');
            if (mAns) mAns.textContent = ansCount;
            const mFlag = document.getElementById('modal-flagged-count');
            if (mFlag) mFlag.textContent = flagCount;
            const mUnans = document.getElementById('modal-unanswered-count');
            if (mUnans) mUnans.textContent = (EXAM_TOTAL_QUESTIONS - ansCount);

            const modal = document.getElementById('submitModal');
            if (modal) modal.classList.remove('hidden');
        }

        function closeSubmitModal() {
            const modal = document.getElementById('submitModal');
            if (modal) modal.classList.add('hidden');
        }

        // 8. Strict Proctoring Telemetry: Tab-Change & Strike System
        let currentStrikes = ${examSession.attempt.tabSwitchCount};
        const maxStrikes = ${examSession.attempt.maxTabSwitches > 0 ? examSession.attempt.maxTabSwitches : 3};
        let isTabSwitchPending = false;

        function updateStrikeDisplay() {
            const strikeEl = document.getElementById('strike-count');
            const strikeBadge = document.getElementById('strike-badge');
            const strikeIcon = document.getElementById('strike-icon');
            if (strikeEl) strikeEl.textContent = currentStrikes;
            if (strikeBadge) {
                if (currentStrikes === 0) {
                    strikeBadge.className = "flex items-center gap-1.5 px-3 py-1.5 rounded-xl border border-slate-200 bg-slate-50 text-xs font-semibold cursor-pointer";
                    if (strikeIcon) strikeIcon.className = "material-symbols-outlined text-[16px] text-emerald-600";
                } else if (currentStrikes < maxStrikes) {
                    strikeBadge.className = "flex items-center gap-1.5 px-3 py-1.5 rounded-xl border border-amber-300 bg-amber-50 text-amber-900 text-xs font-semibold cursor-pointer animate-pulse";
                    if (strikeIcon) strikeIcon.className = "material-symbols-outlined text-[16px] text-amber-600";
                } else {
                    strikeBadge.className = "flex items-center gap-1.5 px-3 py-1.5 rounded-xl border border-rose-500 bg-rose-50 text-rose-700 text-xs font-semibold cursor-pointer animate-bounce";
                    if (strikeIcon) strikeIcon.className = "material-symbols-outlined text-[16px] text-rose-600";
                }
            }
        }

        function triggerTabSwitchViolation() {
            if (isTabSwitchPending) return;
            isTabSwitchPending = true;

            currentStrikes++;
            updateStrikeDisplay();

            fetch(EXAM_CONTEXT.contextPath + '/student/exam/telemetry', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded;charset=UTF-8',
                    'X-CSRF-Token': '${sessionScope.csrfToken}'
                },
                body: 'attemptId=' + EXAM_CONTEXT.attemptId + '&eventType=TAB_SWITCH&csrfToken=${sessionScope.csrfToken}&details=' + encodeURIComponent('Tab switch / window blur incident detected')
            })
            .then(res => res.json())
            .then(data => {
                if (data.tabSwitches !== undefined) {
                    currentStrikes = data.tabSwitches;
                    updateStrikeDisplay();
                }
            })
            .catch(() => {});

            if (currentStrikes >= maxStrikes) {
                const modal = document.getElementById('strikeLockoutModal');
                const cnt = document.getElementById('lockout-strike-count');
                const mx = document.getElementById('lockout-max-strikes');
                if (cnt) cnt.textContent = currentStrikes;
                if (mx) mx.textContent = maxStrikes;
                if (modal) modal.classList.remove('hidden');

                setTimeout(() => {
                    const form = document.getElementById('finalSubmitForm');
                    if (form) form.submit();
                }, 2200);
            } else {
                const modal = document.getElementById('tabSwitchModal');
                const sNum = document.getElementById('modal-strike-num');
                const mMax = document.getElementById('modal-max-strikes');
                const sRem = document.getElementById('modal-remaining-strikes-text');
                if (sNum) sNum.textContent = currentStrikes;
                if (mMax) mMax.textContent = maxStrikes;
                if (sRem) sRem.textContent = "Remaining strikes before automatic exam lockout: " + (maxStrikes - currentStrikes);
                if (modal) modal.classList.remove('hidden');
            }
        }

        function acknowledgeStrike() {
            const modal = document.getElementById('tabSwitchModal');
            if (modal) modal.classList.add('hidden');
            setTimeout(() => {
                isTabSwitchPending = false;
            }, 800);
        }

        // 9. Fullscreen Lockdown Management
        function activateFullscreen() {
            const docEl = document.documentElement;
            const req = docEl.requestFullscreen || docEl.webkitRequestFullscreen || docEl.mozRequestFullScreen || docEl.msRequestFullscreen;
            if (req) {
                req.call(docEl).then(() => {
                    const m1 = document.getElementById('fullscreenLockModal');
                    const m2 = document.getElementById('fullscreenExitModal');
                    if (m1) m1.classList.add('hidden');
                    if (m2) m2.classList.add('hidden');
                }).catch(err => {
                    console.log("Fullscreen request deferred or declined:", err);
                    const m1 = document.getElementById('fullscreenLockModal');
                    const m2 = document.getElementById('fullscreenExitModal');
                    if (m1) m1.classList.add('hidden');
                    if (m2) m2.classList.add('hidden');
                });
            } else {
                const m1 = document.getElementById('fullscreenLockModal');
                if (m1) m1.classList.add('hidden');
            }
        }

        function toggleFullscreen() {
            if (!document.fullscreenElement) {
                activateFullscreen();
            } else {
                if (document.exitFullscreen) {
                    document.exitFullscreen();
                }
            }
        }

        document.addEventListener('fullscreenchange', function() {
            const btnIcon = document.getElementById('fullscreen-btn-icon');
            const btnText = document.getElementById('fullscreen-btn-text');
            if (!document.fullscreenElement) {
                if (btnIcon) btnIcon.textContent = 'fullscreen';
                if (btnText) btnText.textContent = 'Fullscreen';

                const exitModal = document.getElementById('fullscreenExitModal');
                if (exitModal && !isTabSwitchPending) {
                    exitModal.classList.remove('hidden');
                }
            } else {
                if (btnIcon) btnIcon.textContent = 'fullscreen_exit';
                if (btnText) btnText.textContent = 'Exit';
                const m1 = document.getElementById('fullscreenLockModal');
                const m2 = document.getElementById('fullscreenExitModal');
                if (m1) m1.classList.add('hidden');
                if (m2) m2.classList.add('hidden');
            }
        });

        document.addEventListener('visibilitychange', function () {
            if (document.hidden) {
                triggerTabSwitchViolation();
            }
        });

        window.addEventListener('blur', function() {
            triggerTabSwitchViolation();
        });

        window.addEventListener('DOMContentLoaded', function() {
            updateStrikeDisplay();
            if (!document.fullscreenElement) {
                const lockModal = document.getElementById('fullscreenLockModal');
                if (lockModal) lockModal.classList.remove('hidden');
            }
        });
    </script>
</body>
</html>