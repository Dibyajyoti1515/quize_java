<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Score Card &amp; Performance Analytics | QuizTrack Student Portal</title>

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
            ::-webkit-scrollbar { display: none; }
        }
        @media print {
            aside, header, nav, button, .no-print { display: none !important; }
            main { padding: 0 !important; width: 100% !important; margin: 0 !important; }
            .lg\:pl-64 { padding-left: 0 !important; }
            body { background: white !important; color: black !important; }
        }
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
                        "secondary-fixed": "#e1e0ff",
                        "secondary-fixed-dim": "#c0c1ff",
                        "on-secondary-fixed": "#07006c",
                        "on-secondary": "#ffffff",
                        "tertiary": "#005338",
                        "tertiary-container": "#006e4b",
                        "tertiary-fixed": "#6ffbbe",
                        "tertiary-fixed-dim": "#4edea3",
                        "on-tertiary-fixed-variant": "#005236",
                        "on-tertiary-container": "#67f4b7",
                        "error": "#ba1a1a",
                        "error-container": "#ffdad6",
                        "on-error": "#ffffff",
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

    <!-- Reusable Student Sidebar -->
    <jsp:include page="components/sidebar.jsp">
        <jsp:param name="activeNav" value="my-results"/>
    </jsp:include>

    <div class="lg:pl-64">
        <!-- Reusable Student Header -->
        <jsp:include page="components/header.jsp"/>

        <main class="w-full pt-16 bg-surface min-h-screen px-4 sm:px-space-lg py-space-lg">
            <div class="flex flex-col gap-space-lg w-full max-w-[1400px] mx-auto">

                <c:choose>
                    <%-- CASE 1: Student has a verified result record --%>
                    <c:when test="${not empty result}">
                        
                        <!-- Top Breadcrumb & Action Command Bar -->
                        <div class="flex flex-col md:flex-row md:items-center justify-between gap-4 bg-surface-container-lowest p-6 rounded-2xl shadow-sm border border-surface-container-high">
                            <div>
                                <div class="flex items-center gap-2 text-xs font-mono font-semibold text-primary uppercase">
                                    <span>Academic Transcript Registry</span>
                                    <span>•</span>
                                    <span>Certified Assessment</span>
                                </div>
                                <h1 class="text-2xl sm:text-3xl font-display font-bold text-on-surface mt-1">
                                    ${result.quizTitle}
                                </h1>
                                <div class="flex items-center gap-2 mt-2 text-xs text-on-surface-variant flex-wrap">
                                    <span class="px-2.5 py-0.5 rounded-md bg-surface-container-high text-primary font-mono font-bold">
                                        ${result.subjectCode} - ${result.subjectName}
                                    </span>
                                    <span>•</span>
                                    <span>Submitted: <fmt:formatDate value="${result.endTime}" pattern="MMM dd, yyyy • HH:mm z"/></span>
                                    <span>•</span>
                                    <span class="inline-flex items-center gap-1 text-emerald-700 font-semibold">
                                        <span class="w-2 h-2 rounded-full bg-emerald-500 animate-pulse"></span>
                                        Official Transcript Certified
                                    </span>
                                </div>
                            </div>

                            <div class="flex items-center gap-2.5 shrink-0 no-print flex-wrap">
                                <c:if test="${not empty historyList}">
                                    <div class="relative">
                                        <select onchange="window.location.href='${pageContext.request.contextPath}/student/results?attemptId=' + this.value" class="px-3 py-2 rounded-xl bg-surface-container-low border border-surface-container-high text-xs font-semibold text-on-surface focus:ring-2 focus:ring-primary focus:outline-none cursor-pointer">
                                            <c:forEach var="h" items="${historyList}">
                                                <option value="${h.attemptId}" ${h.attemptId == result.attemptId ? 'selected' : ''}>
                                                    <c:out value="${h.quizTitle != null ? h.quizTitle : h.subjectCode}"/> (<c:out value="${h.subjectCode}"/>) • <fmt:formatNumber value="${h.score}" minFractionDigits="1" maxFractionDigits="2"/> pts
                                                </option>
                                            </c:forEach>
                                        </select>
                                    </div>
                                </c:if>

                                <button type="button" onclick="window.print()" class="px-4 py-2.5 rounded-xl bg-primary hover:bg-primary-container text-on-primary font-semibold text-xs transition-all shadow-sm flex items-center gap-1.5 cursor-pointer">
                                    <span class="material-symbols-outlined text-[18px]">download</span>
                                    <span>Download PDF / Print</span>
                                </button>
                            </div>
                        </div>

                        <!-- Hero Scorecard Summary Grid (5 Bento Metrics matching Stitch) -->
                        <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-5 gap-4">
                            
                            <!-- Metric 1: Final Score & Grade -->
                            <div class="rounded-2xl bg-surface-container-lowest p-5 shadow-sm border border-surface-container-high flex flex-col justify-between hover:shadow-md transition-shadow">
                                <div class="flex items-center justify-between">
                                    <span class="text-xs font-semibold uppercase tracking-wider text-on-surface-variant">Final Score</span>
                                    <span class="px-2.5 py-0.5 rounded-full bg-primary-fixed text-on-primary-fixed font-mono text-xs font-bold">
                                        ${result.grade}
                                    </span>
                                </div>
                                <div class="my-2">
                                    <div class="flex items-baseline gap-1">
                                        <span class="font-display text-3xl sm:text-4xl font-bold text-on-surface">
                                            <fmt:formatNumber value="${result.score}" minFractionDigits="1" maxFractionDigits="2"/>
                                        </span>
                                        <span class="text-xs font-mono text-on-surface-variant">/ <fmt:formatNumber value="${result.maxScore}" maxFractionDigits="0"/> pts</span>
                                    </div>
                                    <p class="text-xs text-primary font-semibold mt-1">
                                        ${result.percentage}% Aggregate Score
                                    </p>
                                </div>
                                <div class="p-2 bg-surface-container-low rounded-xl text-[11px] text-on-surface-variant flex items-center justify-between">
                                    <span>Marking Rule</span>
                                    <span class="font-mono font-bold text-on-surface">${result.markingSchemeFormatted}</span>
                                </div>
                            </div>

                            <!-- Metric 2: Cohort Percentile & Rank -->
                            <div class="rounded-2xl bg-surface-container-lowest p-5 shadow-sm border border-surface-container-high flex flex-col justify-between hover:shadow-md transition-shadow">
                                <div class="flex items-center justify-between">
                                    <span class="text-xs font-semibold uppercase tracking-wider text-on-surface-variant">Cohort Standing</span>
                                    <div class="w-6 h-6 rounded-full bg-secondary-fixed flex items-center justify-center text-on-secondary-fixed">
                                        <span class="material-symbols-outlined text-[14px]">military_tech</span>
                                    </div>
                                </div>
                                <div class="my-2">
                                    <div class="flex items-baseline gap-1">
                                        <span class="font-display text-3xl sm:text-4xl font-bold text-on-surface">
                                            ${result.cohortPercentile}
                                        </span>
                                        <span class="text-xs font-mono text-on-surface-variant">th %ile</span>
                                    </div>
                                    <div class="flex items-center gap-1.5 mt-1 text-xs text-on-surface font-semibold">
                                        <span>Rank #${result.cohortRank}</span>
                                        <span class="text-on-surface-variant font-normal">of ${result.cohortTotalStudents} Students</span>
                                    </div>
                                </div>
                                <div class="h-2 w-full bg-surface-container-low rounded-full overflow-hidden">
                                    <div class="h-full bg-primary rounded-full transition-all duration-500" style="width: ${result.cohortPercentile}%"></div>
                                </div>
                            </div>

                            <!-- Metric 3: Accuracy Ratio -->
                            <div class="rounded-2xl bg-surface-container-lowest p-5 shadow-sm border border-surface-container-high flex flex-col justify-between hover:shadow-md transition-shadow">
                                <div class="flex items-center justify-between">
                                    <span class="text-xs font-semibold uppercase tracking-wider text-on-surface-variant">Accuracy Ratio</span>
                                    <span class="px-2 py-0.5 rounded-full bg-surface-container-low text-tertiary font-mono text-xs font-semibold">
                                        ${result.answeredCount} / ${result.totalQuestions} Att.
                                    </span>
                                </div>
                                <div class="my-2">
                                    <div class="flex items-baseline gap-1">
                                        <span class="font-display text-3xl sm:text-4xl font-bold text-on-surface">
                                            ${result.accuracyPercentage}%
                                        </span>
                                    </div>
                                    <p class="text-xs text-on-surface-variant mt-1">
                                        ${result.correctCount} Correct • ${result.incorrectCount} Missed • ${result.unansweredCount} Skip
                                    </p>
                                </div>
                                <div class="flex items-center gap-1 w-full h-2 rounded-full overflow-hidden bg-surface-container-low">
                                    <div class="h-full bg-emerald-600 rounded-full" style="width: ${result.totalQuestions > 0 ? (result.correctCount * 100.0 / result.totalQuestions) : 0}%"></div>
                                    <div class="h-full bg-rose-600 rounded-full" style="width: ${result.totalQuestions > 0 ? (result.incorrectCount * 100.0 / result.totalQuestions) : 0}%"></div>
                                    <div class="h-full bg-outline-variant rounded-full" style="width: ${result.totalQuestions > 0 ? (result.unansweredCount * 100.0 / result.totalQuestions) : 0}%"></div>
                                </div>
                            </div>

                            <!-- Metric 4: Timing & Pace -->
                            <div class="rounded-2xl bg-surface-container-lowest p-5 shadow-sm border border-surface-container-high flex flex-col justify-between hover:shadow-md transition-shadow">
                                <div class="flex items-center justify-between">
                                    <span class="text-xs font-semibold uppercase tracking-wider text-on-surface-variant">Time Invested</span>
                                    <span class="material-symbols-outlined text-[18px] text-on-surface-variant">timer</span>
                                </div>
                                <div class="my-2">
                                    <div class="flex items-baseline gap-1">
                                        <span class="font-display text-3xl sm:text-4xl font-bold text-on-surface">
                                            ${result.timeSpentFormatted}
                                        </span>
                                    </div>
                                    <p class="text-xs text-on-surface-variant mt-1">
                                        Allocated Limit: ${result.durationMinutes} Minutes
                                    </p>
                                </div>
                                <div class="p-2 bg-surface-container-low rounded-xl text-[11px] text-on-surface-variant flex items-center justify-between">
                                    <span>Pacing</span>
                                    <span class="font-mono font-bold text-on-surface">Avg 1m 58s / Q</span>
                                </div>
                            </div>

                            <!-- Metric 5: Proctor Standing & Trust -->
                            <div class="rounded-2xl bg-surface-container-lowest p-5 shadow-sm border border-surface-container-high flex flex-col justify-between hover:shadow-md transition-shadow">
                                <div class="flex items-center justify-between">
                                    <span class="text-xs font-semibold uppercase tracking-wider text-on-surface-variant">Integrity Trust</span>
                                    <span class="material-symbols-outlined text-[18px] text-tertiary">verified_user</span>
                                </div>
                                <div class="my-2">
                                    <div class="flex items-baseline gap-1">
                                        <span class="font-display text-3xl sm:text-4xl font-bold text-emerald-700">
                                            <fmt:formatNumber value="${result.integrityIndex}" minFractionDigits="1" maxFractionDigits="1"/>%
                                        </span>
                                    </div>
                                    <p class="text-xs text-on-surface-variant mt-1">
                                        ${result.proctorStatusText}
                                    </p>
                                </div>
                                <div class="p-2 bg-surface-container-low rounded-xl text-[11px] text-on-surface-variant flex items-center justify-between">
                                    <span>Telemetry Audits</span>
                                    <span class="font-mono font-bold text-emerald-800">${result.tabSwitchCount} Shifts / 0 Flags</span>
                                </div>
                            </div>

                        </div>

                        <!-- Main 2-Column Split Body Layout -->
                        <div class="grid grid-cols-1 lg:grid-cols-12 gap-6 items-start">
                            
                            <!-- LEFT 65% REGION: Concept Mastery & Detailed Question Review (lg:col-span-8) -->
                            <div class="lg:col-span-8 flex flex-col gap-6">
                                
                                <!-- Section A: Concept Taxonomy & Topic Mastery Breakdown -->
                                <div class="bg-surface-container-lowest rounded-2xl p-6 shadow-sm border border-surface-container-high flex flex-col gap-5">
                                    <div class="flex items-center justify-between pb-3 border-b border-surface-container-high">
                                        <div class="flex items-center gap-2">
                                            <span class="material-symbols-outlined text-primary text-[22px]">account_tree</span>
                                            <h2 class="font-display font-bold text-lg text-on-surface">Performance by Concept Taxonomy</h2>
                                        </div>
                                        <span class="text-xs text-on-surface-variant font-medium">Curricular Topic Diagnostics</span>
                                    </div>

                                    <div class="flex flex-col gap-4">
                                        <c:forEach var="topic" items="${result.topicBreakdowns}">
                                            <div class="p-4 rounded-xl bg-surface-container-low border border-surface-container-high flex flex-col gap-2.5">
                                                <div class="flex items-center justify-between gap-2 flex-wrap">
                                                    <span class="font-semibold text-sm text-on-surface">
                                                        ${topic.topicName}
                                                    </span>
                                                    <div class="flex items-center gap-2">
                                                        <span class="font-mono text-xs text-on-surface-variant">
                                                            ${topic.correctCount} / ${topic.totalQuestions} Correct
                                                        </span>
                                                        <span class="px-2 py-0.5 rounded-md font-mono text-xs font-bold
                                                            ${topic.masteryPercentage >= 80.0 ? 'bg-emerald-100 text-emerald-800' :
                                                              topic.masteryPercentage >= 60.0 ? 'bg-amber-100 text-amber-800' : 'bg-rose-100 text-rose-800'}">
                                                            ${topic.masteryPercentage}% (${topic.status})
                                                        </span>
                                                    </div>
                                                </div>
                                                <div class="h-2 w-full bg-surface-container rounded-full overflow-hidden">
                                                    <div class="h-full rounded-full transition-all duration-500
                                                        ${topic.masteryPercentage >= 80.0 ? 'bg-emerald-600' :
                                                          topic.masteryPercentage >= 60.0 ? 'bg-amber-500' : 'bg-rose-600'}"
                                                        style="width: ${topic.masteryPercentage}%">
                                                    </div>
                                                </div>
                                            </div>
                                        </c:forEach>
                                    </div>
                                </div>

                                <!-- Section B: Detailed Question-by-Question Review -->
                                <div class="bg-surface-container-lowest rounded-2xl p-6 shadow-sm border border-surface-container-high flex flex-col gap-5">
                                    <div class="flex items-center justify-between pb-3 border-b border-surface-container-high">
                                        <div class="flex items-center gap-2">
                                            <span class="material-symbols-outlined text-primary text-[22px]">assignment</span>
                                            <h2 class="font-display font-bold text-lg text-on-surface">Question-by-Question Review</h2>
                                        </div>
                                        <span class="text-xs text-on-surface-variant font-medium">Answer Key &amp; Pedagogical Rationale</span>
                                    </div>

                                    <div class="flex flex-col gap-5">
                                        <c:forEach var="qr" items="${result.questionReviews}">
                                            <div class="p-5 rounded-2xl border transition-all flex flex-col gap-4
                                                ${qr.status == 'CORRECT' ? 'bg-emerald-50/20 border-emerald-200' :
                                                  qr.status == 'INCORRECT' ? 'bg-rose-50/20 border-rose-200' :
                                                  'bg-surface-container-low border-surface-container-high'}">
                                                
                                                <!-- Review Question Header Strip -->
                                                <div class="flex flex-wrap items-center justify-between gap-2 pb-2 border-b border-surface-container-high">
                                                    <div class="flex items-center gap-2 flex-wrap">
                                                        <span class="font-mono text-xs font-bold px-2 py-0.5 rounded-md bg-surface-container text-primary">
                                                            Question ${qr.questionNumber}
                                                        </span>
                                                        <c:if test="${not empty qr.taxonomyTopic}">
                                                            <span class="text-xs font-semibold px-2 py-0.5 rounded-md bg-indigo-50 text-indigo-700 border border-indigo-100">
                                                                ${qr.taxonomyTopic}
                                                            </span>
                                                        </c:if>
                                                        <span class="text-xs font-mono text-on-surface-variant">
                                                            Allocated: ${qr.points} pt(s)
                                                        </span>
                                                    </div>

                                                    <div class="flex items-center gap-2">
                                                        <c:choose>
                                                            <c:when test="${qr.status == 'CORRECT'}">
                                                                <span class="px-2.5 py-0.5 rounded-md bg-emerald-100 text-emerald-800 text-xs font-bold flex items-center gap-1">
                                                                    <span class="material-symbols-outlined text-[16px]">check_circle</span>
                                                                    Correct (+<fmt:formatNumber value="${qr.marksAwarded}" minFractionDigits="1"/>)
                                                                </span>
                                                            </c:when>
                                                            <c:when test="${qr.status == 'INCORRECT'}">
                                                                <span class="px-2.5 py-0.5 rounded-md bg-rose-100 text-rose-800 text-xs font-bold flex items-center gap-1">
                                                                    <span class="material-symbols-outlined text-[16px]">cancel</span>
                                                                    Incorrect (<fmt:formatNumber value="${qr.marksAwarded}" minFractionDigits="1"/>)
                                                                </span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="px-2.5 py-0.5 rounded-md bg-slate-100 text-slate-700 text-xs font-bold flex items-center gap-1">
                                                                    <span class="material-symbols-outlined text-[16px]">remove_circle_outline</span>
                                                                    Unanswered (0.0)
                                                                </span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </div>
                                                </div>

                                                <!-- Question Prompt -->
                                                <div class="text-sm sm:text-base font-medium text-on-surface leading-relaxed">
                                                    ${qr.questionText}
                                                </div>

                                                <!-- Code context if available -->
                                                <c:if test="${not empty qr.codeSnippet}">
                                                    <pre class="p-3 bg-surface-container-high/60 rounded-xl font-mono text-xs text-on-surface overflow-x-auto border border-surface-container-high"><code>${qr.codeSnippet}</code></pre>
                                                </c:if>

                                                <!-- Options Comparison Grid -->
                                                <div class="grid grid-cols-1 sm:grid-cols-2 gap-2.5 pt-1">
                                                    <c:forEach var="opt" items="${qr.options}">
                                                        <div class="p-3 rounded-xl border text-xs sm:text-sm flex items-start gap-2.5 transition-all
                                                            ${opt.isCorrect ? 'bg-emerald-50 border-emerald-300 font-semibold text-emerald-950' : 
                                                              (opt.isSelected and not opt.isCorrect) ? 'bg-rose-50 border-rose-300 font-semibold text-rose-950' :
                                                              'bg-surface-container-lowest border-surface-container-high text-on-surface-variant'}">
                                                            
                                                            <span class="w-6 h-6 rounded-md font-mono font-bold text-xs flex items-center justify-center shrink-0
                                                                ${opt.isCorrect ? 'bg-emerald-600 text-white' : 
                                                                  (opt.isSelected and not opt.isCorrect) ? 'bg-rose-600 text-white' : 
                                                                  'bg-surface-container text-on-surface-variant'}">
                                                                ${opt.optionLetter}
                                                            </span>

                                                            <div class="flex-1">
                                                                <span>${opt.optionText}</span>
                                                                <c:if test="${opt.isSelected and opt.isCorrect}">
                                                                    <span class="block text-[11px] text-emerald-700 font-bold mt-0.5">Your Choice • Correct Answer</span>
                                                                </c:if>
                                                                <c:if test="${opt.isSelected and not opt.isCorrect}">
                                                                    <span class="block text-[11px] text-rose-700 font-bold mt-0.5">Your Choice</span>
                                                                </c:if>
                                                                <c:if test="${not opt.isSelected and opt.isCorrect}">
                                                                    <span class="block text-[11px] text-emerald-700 font-bold mt-0.5">Verified Correct Answer</span>
                                                                </c:if>
                                                            </div>

                                                            <c:if test="${opt.isCorrect}">
                                                                <span class="material-symbols-outlined text-emerald-600 text-[18px]">check_circle</span>
                                                            </c:if>
                                                            <c:if test="${opt.isSelected and not opt.isCorrect}">
                                                                <span class="material-symbols-outlined text-rose-600 text-[18px]">cancel</span>
                                                            </c:if>
                                                        </div>
                                                    </c:forEach>
                                                </div>

                                                <!-- Pedagogical Rationale Box -->
                                                <c:if test="${not empty qr.explanation}">
                                                    <div class="p-3.5 bg-surface-container-low rounded-xl border border-surface-container-high text-xs text-on-surface-variant flex items-start gap-2.5">
                                                        <span class="material-symbols-outlined text-primary text-[18px] shrink-0 mt-0.5">lightbulb</span>
                                                        <div>
                                                            <span class="font-bold text-on-surface">Pedagogical Rationale:</span>
                                                            <span class="text-on-surface-variant leading-relaxed">${qr.explanation}</span>
                                                        </div>
                                                    </div>
                                                </c:if>

                                            </div>
                                        </c:forEach>
                                    </div>
                                </div>

                            </div>

                            <!-- RIGHT 35% REGION: Analytical Benchmarks & Digital Authenticity (lg:col-span-4) -->
                            <div class="lg:col-span-4 flex flex-col gap-6">
                                
                                <!-- Cohort Comparison Card -->
                                <div class="bg-surface-container-lowest rounded-2xl p-6 shadow-sm border border-surface-container-high flex flex-col gap-4">
                                    <div class="flex items-center gap-2 pb-2 border-b border-surface-container-high">
                                        <span class="material-symbols-outlined text-primary text-[20px]">bar_chart</span>
                                        <h3 class="font-display font-bold text-base text-on-surface">Score vs. Cohort Mean</h3>
                                    </div>

                                    <div class="flex items-baseline justify-between pt-1">
                                        <div>
                                            <span class="text-xs text-on-surface-variant block">Your Score</span>
                                            <span class="font-display font-bold text-2xl text-primary">${result.percentage}%</span>
                                        </div>
                                        <div class="text-right">
                                            <span class="text-xs text-on-surface-variant block">Cohort Mean</span>
                                            <span class="font-display font-bold text-2xl text-on-surface">${result.cohortAveragePercentage}%</span>
                                        </div>
                                    </div>

                                    <!-- Visual Bar Graph -->
                                    <div class="space-y-2 pt-2">
                                        <div class="space-y-1">
                                            <div class="flex justify-between text-xs font-semibold">
                                                <span>You (Candidate)</span>
                                                <span class="text-primary font-mono">${result.percentage}%</span>
                                            </div>
                                            <div class="h-3 w-full bg-surface-container-low rounded-full overflow-hidden">
                                                <div class="h-full bg-primary rounded-full transition-all" style="width: ${result.percentage}%"></div>
                                            </div>
                                        </div>

                                        <div class="space-y-1">
                                            <div class="flex justify-between text-xs font-semibold">
                                                <span class="text-on-surface-variant">Cohort Average</span>
                                                <span class="text-on-surface-variant font-mono">${result.cohortAveragePercentage}%</span>
                                            </div>
                                            <div class="h-3 w-full bg-surface-container-low rounded-full overflow-hidden">
                                                <div class="h-full bg-surface-container-high rounded-full transition-all" style="width: ${result.cohortAveragePercentage}%"></div>
                                            </div>
                                        </div>
                                    </div>

                                    <p class="text-xs text-on-surface-variant leading-relaxed pt-1">
                                        <c:choose>
                                            <c:when test="${result.percentage >= result.cohortAveragePercentage}">
                                                You outperformed the sectional cohort average by <strong class="text-emerald-700 font-semibold">+<fmt:formatNumber value="${result.percentage - result.cohortAveragePercentage}" minFractionDigits="1" maxFractionDigits="1"/>%</strong>.
                                            </c:when>
                                            <c:otherwise>
                                                You performed within range of the course cohort baseline benchmark.
                                            </c:otherwise>
                                        </c:choose>
                                    </p>
                                </div>

                                <!-- Strengths & Growth Areas Card -->
                                <div class="bg-surface-container-lowest rounded-2xl p-6 shadow-sm border border-surface-container-high flex flex-col gap-4">
                                    <div class="flex items-center gap-2 pb-2 border-b border-surface-container-high">
                                        <span class="material-symbols-outlined text-secondary text-[20px]">psychology</span>
                                        <h3 class="font-display font-bold text-base text-on-surface">Strengths &amp; Growth Focus</h3>
                                    </div>

                                    <!-- Strongest Concepts -->
                                    <div>
                                        <span class="text-xs font-semibold text-emerald-700 uppercase tracking-wider block mb-2">Mastered Concepts (&ge;80%)</span>
                                        <c:choose>
                                            <c:when test="${not empty result.strongTopics}">
                                                <div class="space-y-1.5">
                                                    <c:forEach var="st" items="${result.strongTopics}">
                                                        <div class="p-2 rounded-lg bg-emerald-50 text-emerald-900 border border-emerald-200 text-xs font-medium flex items-center gap-2">
                                                            <span class="material-symbols-outlined text-emerald-600 text-[16px]">check_circle</span>
                                                            <span>${st}</span>
                                                        </div>
                                                    </c:forEach>
                                                </div>
                                            </c:when>
                                            <c:otherwise>
                                                <p class="text-xs text-on-surface-variant">Continue practicing to establish mastery benchmarks.</p>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>

                                    <!-- Focus Growth Areas -->
                                    <c:if test="${not empty result.weakTopics}">
                                        <div class="pt-2 border-t border-surface-container-high">
                                            <span class="text-xs font-semibold text-rose-700 uppercase tracking-wider block mb-2">Recommended Review Focus (&lt;60%)</span>
                                            <div class="space-y-1.5">
                                                <c:forEach var="wt" items="${result.weakTopics}">
                                                    <div class="p-2 rounded-lg bg-rose-50 text-rose-900 border border-rose-200 text-xs font-medium flex items-center gap-2">
                                                        <span class="material-symbols-outlined text-rose-600 text-[16px]">warning</span>
                                                        <span>${wt}</span>
                                                    </div>
                                                </c:forEach>
                                            </div>
                                        </div>
                                    </c:if>
                                </div>

                                <!-- Institutional Authenticity Stamp & Cryptographic Seal -->
                                <div class="bg-primary text-on-primary rounded-2xl p-6 shadow-md flex flex-col gap-4 relative overflow-hidden">
                                    <div class="flex items-center gap-2.5">
                                        <div class="w-8 h-8 rounded-lg bg-white/10 flex items-center justify-center">
                                            <span class="material-symbols-outlined text-[20px] text-tertiary-fixed">verified</span>
                                        </div>
                                        <div>
                                            <h4 class="font-display font-bold text-sm text-white">Institutional Authenticity Stamp</h4>
                                            <p class="text-[11px] text-white/70">Cryptographic Grade Transcript</p>
                                        </div>
                                    </div>

                                    <div class="space-y-2 text-xs font-mono text-white/80 pt-1 border-t border-white/10">
                                        <div class="flex justify-between">
                                            <span>Proctor of Record:</span>
                                            <span class="text-white font-bold">${result.teacherName}</span>
                                        </div>
                                        <div class="flex justify-between">
                                            <span>Candidate ID:</span>
                                            <span class="text-white font-bold">${result.studentIdentifier}</span>
                                        </div>
                                        <div class="flex justify-between">
                                            <span>Attempt Hash:</span>
                                            <span class="text-white font-bold">#QT-${result.attemptId}</span>
                                        </div>
                                    </div>

                                    <div class="p-2.5 rounded-xl bg-black/25 text-[10px] font-mono break-all text-white/90 border border-white/10">
                                        <span class="block text-white/60 mb-0.5">SHA-256 Verification Token:</span>
                                        <code>${result.certificateHash != null ? result.certificateHash : 'e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855'}</code>
                                    </div>
                                </div>

                            </div>

                        </div>

                    </c:when>

                    <%-- CASE 2: No completed exams found yet --%>
                    <c:otherwise>
                        <div class="p-12 text-center bg-surface-container-lowest rounded-3xl border border-surface-container-high shadow-sm max-w-2xl mx-auto flex flex-col items-center gap-4">
                            <div class="w-16 h-16 rounded-2xl bg-surface-container-low text-primary flex items-center justify-center">
                                <span class="material-symbols-outlined text-4xl">fact_check</span>
                            </div>
                            <div>
                                <h2 class="text-xl font-display font-bold text-on-surface">No Completed Examinations Found</h2>
                                <p class="text-sm text-on-surface-variant mt-1 max-w-md">
                                    You have not submitted any examinations yet. Check your dashboard for currently scheduled or active assessments.
                                </p>
                            </div>
                            <a href="${pageContext.request.contextPath}/student/quizzes" class="mt-2 px-6 py-2.5 rounded-xl bg-primary hover:bg-primary-container text-on-primary font-semibold text-sm transition-all shadow-sm">
                                View Available Quizzes
                            </a>
                        </div>
                    </c:otherwise>
                </c:choose>

            </div>
        </main>
    </div>

</body>
</html>
