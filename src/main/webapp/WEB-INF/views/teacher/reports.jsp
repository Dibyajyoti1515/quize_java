<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Quiz Performance Reports | QuizTrack Faculty</title>
    
    <link href="https://fonts.googleapis.com" rel="preconnect"/>
    <link crossorigin="" href="https://fonts.gstatic.com" rel="preconnect"/>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=JetBrains+Mono:wght@400;500;600&family=Plus+Jakarta+Sans:wght@600;700;800&display=swap" rel="stylesheet"/>
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
                        secondary: '#4648d4',
                        tertiary: '#005338',
                        'tertiary-container': '#006e4b',
                        'tertiary-fixed': '#6ffbbe',
                        error: '#ba1a1a',
                        'error-container': '#ffdad6',
                        'on-error-container': '#93000a',
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
<body class="bg-surface font-body text-on-surface antialiased">
    <!-- Include teacher sidebar & header -->
    <jsp:include page="components/sidebar.jsp"/>

    <div class="lg:pl-64">
        <jsp:include page="components/header.jsp"/>

        <main class="w-full pt-16 bg-surface min-h-screen px-4 sm:px-8 py-8">
            <div class="max-w-7xl mx-auto flex flex-col gap-6">
                
                <!-- Top Header & Quiz Selector -->
                <div class="flex flex-col md:flex-row md:items-center justify-between gap-4 bg-surface-container-lowest p-6 rounded-2xl shadow-sm border border-surface-container-high">
                    <div>
                        <div class="flex items-center gap-2 text-xs font-mono font-semibold text-primary uppercase">
                            <span>Performance Analytics</span>
                            <span>•</span>
                            <span>Candidate Submissions</span>
                        </div>
                        <h1 class="text-2xl sm:text-3xl font-display font-bold text-on-surface mt-1">Quiz Performance &amp; Evaluation Reports</h1>
                        <p class="text-sm text-on-surface-variant mt-1">
                            Inspect candidate scores, passing rates, grade distribution, and proctoring telemetry.
                        </p>
                    </div>

                    <!-- Quiz Dropdown Selector -->
                    <div class="flex items-center gap-3 shrink-0">
                        <form method="GET" action="${pageContext.request.contextPath}/teacher/reports" id="quizSelectForm" class="flex items-center gap-2">
                            <label for="quizSelect" class="text-xs font-semibold text-on-surface-variant shrink-0">Select Quiz:</label>
                            <select id="quizSelect" name="quizId" onchange="document.getElementById('quizSelectForm').submit();" class="px-3 py-2 rounded-xl bg-surface-container text-on-surface font-semibold text-sm border border-surface-container-high focus:outline-none focus:ring-2 focus:ring-primary">
                                <c:choose>
                                    <c:when test="${not empty quizzes}">
                                        <c:forEach items="${quizzes}" var="q">
                                            <option value="${q.quizId}" ${selectedQuiz != null && selectedQuiz.quizId == q.quizId ? 'selected' : ''}>
                                                <c:out value="${q.title}"/> (<c:out value="${q.subjectCode}"/> - <c:out value="${q.status}"/>)
                                            </option>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <option value="">No quizzes authored</option>
                                    </c:otherwise>
                                </c:choose>
                            </select>
                        </form>
                    </div>
                </div>

                <c:choose>
                    <c:when test="${selectedQuiz != null}">
                        <!-- Selected Quiz Meta Banner -->
                        <div class="p-5 rounded-2xl bg-surface-container-lowest border border-surface-container-high shadow-xs flex flex-wrap items-center justify-between gap-4">
                            <div class="flex items-center gap-3">
                                <div class="w-10 h-10 rounded-xl bg-primary text-on-primary flex items-center justify-center font-bold shadow-xs">
                                    <span class="material-symbols-outlined text-[22px]">quiz</span>
                                </div>
                                <div>
                                    <div class="flex items-center gap-2 flex-wrap">
                                        <span class="text-lg font-bold text-on-surface"><c:out value="${selectedQuiz.title}"/></span>
                                        <span class="px-2 py-0.5 rounded text-[11px] font-mono font-bold uppercase ${selectedQuiz.status == 'ACTIVE' ? 'bg-tertiary-container text-tertiary' : (selectedQuiz.status == 'SCHEDULED' ? 'bg-secondary-container text-secondary' : 'bg-surface-container text-on-surface-variant')}">
                                            <c:out value="${selectedQuiz.status}"/>
                                        </span>
                                    </div>
                                    <p class="text-xs text-on-surface-variant font-medium">
                                        Course: <c:out value="${selectedQuiz.subjectCode}"/> • <c:out value="${selectedQuiz.subjectName}"/> | Duration: <c:out value="${selectedQuiz.durationMinutes}"/> mins | Pass Benchmark: <fmt:formatNumber value="${selectedQuiz.passPercentage}" maxFractionDigits="0"/>%
                                    </p>
                                </div>
                            </div>
                            <div class="flex items-center gap-2">
                                <a href="${pageContext.request.contextPath}/teacher/quiz/builder?quizId=${selectedQuiz.quizId}" class="px-3.5 py-1.5 rounded-xl bg-surface-container hover:bg-surface-container-high text-primary text-xs font-bold transition-all flex items-center gap-1">
                                    <span class="material-symbols-outlined text-[16px]">edit</span>
                                    <span>Edit Examination</span>
                                </a>
                            </div>
                        </div>

                        <!-- KPI Summary Cards -->
                        <div class="grid grid-cols-2 md:grid-cols-4 gap-4">
                            <!-- Card 1: Examinees -->
                            <div class="p-5 rounded-2xl bg-surface-container-lowest border border-surface-container-high shadow-xs flex flex-col justify-between">
                                <div class="flex items-center justify-between text-on-surface-variant">
                                    <span class="text-xs font-semibold uppercase tracking-wider">Total Examinees</span>
                                    <span class="material-symbols-outlined text-primary text-[20px]">groups</span>
                                </div>
                                <div class="mt-3">
                                    <div class="text-3xl font-bold font-display text-on-surface"><c:out value="${totalCandidates}"/></div>
                                    <span class="text-[11px] text-on-surface-variant font-medium">Submissions finalized</span>
                                </div>
                            </div>

                            <!-- Card 2: Pass Rate -->
                            <div class="p-5 rounded-2xl bg-surface-container-lowest border border-surface-container-high shadow-xs flex flex-col justify-between">
                                <div class="flex items-center justify-between text-on-surface-variant">
                                    <span class="text-xs font-semibold uppercase tracking-wider">Pass Benchmark</span>
                                    <span class="material-symbols-outlined text-tertiary text-[20px]">verified</span>
                                </div>
                                <div class="mt-3">
                                    <div class="text-3xl font-bold font-display text-tertiary"><c:out value="${passRate}"/>%</div>
                                    <span class="text-[11px] text-tertiary font-medium"><c:out value="${passedCount}"/> passed • <c:out value="${failedCount}"/> failed</span>
                                </div>
                            </div>

                            <!-- Card 3: Class Average -->
                            <div class="p-5 rounded-2xl bg-surface-container-lowest border border-surface-container-high shadow-xs flex flex-col justify-between">
                                <div class="flex items-center justify-between text-on-surface-variant">
                                    <span class="text-xs font-semibold uppercase tracking-wider">Average Score</span>
                                    <span class="material-symbols-outlined text-secondary text-[20px]">analytics</span>
                                </div>
                                <div class="mt-3">
                                    <div class="text-3xl font-bold font-display text-on-surface"><c:out value="${averageScore}"/></div>
                                    <span class="text-[11px] text-on-surface-variant font-medium">Out of <fmt:formatNumber value="${selectedQuiz.totalMarks}" maxFractionDigits="2"/> total points</span>
                                </div>
                            </div>

                            <!-- Card 4: Top Score -->
                            <div class="p-5 rounded-2xl bg-surface-container-lowest border border-surface-container-high shadow-xs flex flex-col justify-between">
                                <div class="flex items-center justify-between text-on-surface-variant">
                                    <span class="text-xs font-semibold uppercase tracking-wider">Highest Score</span>
                                    <span class="material-symbols-outlined text-amber-600 text-[20px]">military_tech</span>
                                </div>
                                <div class="mt-3">
                                    <div class="text-3xl font-bold font-display text-amber-600"><c:out value="${highestScore}"/></div>
                                    <span class="text-[11px] text-on-surface-variant font-medium">Lowest: <c:out value="${lowestScore}"/> pts</span>
                                </div>
                            </div>
                        </div>

                        <!-- Examinee Submissions Table Card -->
                        <div class="bg-surface-container-lowest rounded-2xl shadow-sm border border-surface-container-high overflow-hidden">
                            <div class="p-5 bg-surface-container-low border-b border-surface-container-high flex items-center justify-between">
                                <div class="flex items-center gap-2">
                                    <span class="material-symbols-outlined text-primary text-[20px]">assignment_turned_in</span>
                                    <span class="font-bold text-base text-on-surface">Candidate Submissions &amp; Score Ledger</span>
                                    <span class="px-2 py-0.5 rounded-full bg-surface-container-high text-xs font-mono font-bold text-primary">
                                        <c:out value="${results.size()}"/>
                                    </span>
                                </div>
                            </div>

                            <c:choose>
                                <c:when test="${not empty results}">
                                    <div class="overflow-x-auto">
                                        <table class="w-full text-left border-collapse">
                                            <thead>
                                                <tr class="bg-surface-container-lowest text-on-surface-variant border-b border-surface-container text-xs font-mono font-semibold uppercase tracking-wider">
                                                    <th class="py-3 px-4">Candidate Student</th>
                                                    <th class="py-3 px-4">Score &amp; %</th>
                                                    <th class="py-3 px-4">Grade</th>
                                                    <th class="py-3 px-4">Outcome</th>
                                                    <th class="py-3 px-4">Time Spent</th>
                                                    <th class="py-3 px-4">Integrity / Strikes</th>
                                                    <th class="py-3 px-4">Submitted At</th>
                                                    <th class="py-3 px-4 text-right">Actions</th>
                                                </tr>
                                            </thead>
                                            <tbody class="divide-y divide-surface-container-low text-sm">
                                                <c:forEach items="${results}" var="r">
                                                    <tr class="hover:bg-surface-container-low/50 transition-colors">
                                                        <!-- Candidate -->
                                                        <td class="py-3 px-4">
                                                            <div class="flex items-center gap-2.5">
                                                                <div class="w-8 h-8 rounded-full bg-primary/10 text-primary flex items-center justify-center font-bold text-xs">
                                                                    <c:out value="${r.studentName.substring(0, 1)}"/>
                                                                </div>
                                                                <div class="flex flex-col">
                                                                    <span class="font-semibold text-on-surface"><c:out value="${r.studentName}"/></span>
                                                                    <span class="text-xs font-mono text-on-surface-variant"><c:out value="${r.studentIdentifier}"/></span>
                                                                </div>
                                                            </div>
                                                        </td>

                                                        <!-- Score & % -->
                                                        <td class="py-3 px-4 font-mono">
                                                            <span class="font-bold text-on-surface"><fmt:formatNumber value="${r.score}" maxFractionDigits="2"/></span>
                                                            <span class="text-xs text-on-surface-variant">/ <fmt:formatNumber value="${r.maxScore}" maxFractionDigits="2"/></span>
                                                            <span class="text-xs font-semibold text-primary ml-1">(<fmt:formatNumber value="${r.percentage}" maxFractionDigits="1"/>%)</span>
                                                        </td>

                                                        <!-- Grade -->
                                                        <td class="py-3 px-4 font-mono font-bold">
                                                            <span class="px-2 py-0.5 rounded text-xs ${r.grade == 'A' ? 'bg-emerald-100 text-emerald-800' : (r.grade == 'B' ? 'bg-blue-100 text-blue-800' : (r.grade == 'C' ? 'bg-amber-100 text-amber-800' : 'bg-red-100 text-red-800'))}">
                                                                <c:out value="${r.grade}"/>
                                                            </span>
                                                        </td>

                                                        <!-- Outcome -->
                                                        <td class="py-3 px-4">
                                                            <c:choose>
                                                                <c:when test="${r.passed}">
                                                                    <span class="inline-flex items-center gap-1 px-2.5 py-0.5 rounded-full text-xs font-semibold bg-tertiary-container/20 text-tertiary border border-tertiary/30">
                                                                        <span class="material-symbols-outlined text-[14px]">check</span> Passed
                                                                    </span>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <span class="inline-flex items-center gap-1 px-2.5 py-0.5 rounded-full text-xs font-semibold bg-error-container/20 text-error border border-error/30">
                                                                        <span class="material-symbols-outlined text-[14px]">close</span> Failed
                                                                    </span>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </td>

                                                        <!-- Time Spent -->
                                                        <td class="py-3 px-4 font-mono text-xs text-on-surface">
                                                            <c:out value="${r.timeSpentFormatted}"/>
                                                        </td>

                                                        <!-- Integrity / Strikes -->
                                                        <td class="py-3 px-4">
                                                            <div class="flex items-center gap-1 text-xs">
                                                                <span class="font-mono font-bold ${r.tabSwitchCount > 0 ? 'text-amber-600' : 'text-emerald-600'}">
                                                                    <c:out value="${r.tabSwitchCount}"/> strikes
                                                                </span>
                                                                <span class="text-on-surface-variant font-mono text-[11px]">(<fmt:formatNumber value="${r.integrityIndex}" maxFractionDigits="0"/>%)</span>
                                                            </div>
                                                        </td>

                                                        <!-- Submitted At -->
                                                        <td class="py-3 px-4 text-xs font-mono text-on-surface-variant">
                                                            <fmt:formatDate value="${r.endTime}" pattern="MMM dd, yyyy HH:mm"/>
                                                        </td>

                                                        <!-- Actions -->
                                                        <td class="py-3 px-4 text-right">
                                                            <a href="${pageContext.request.contextPath}/student/results/summary?attemptId=${r.attemptId}" target="_blank" class="px-2.5 py-1 rounded-lg bg-surface-container hover:bg-surface-container-high text-xs font-semibold text-primary inline-flex items-center gap-1 transition-all">
                                                                <span class="material-symbols-outlined text-[14px]">visibility</span>
                                                                <span>Review</span>
                                                            </a>
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                            </tbody>
                                        </table>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div class="p-12 text-center flex flex-col items-center justify-center gap-3 text-on-surface-variant">
                                        <span class="material-symbols-outlined text-[48px] text-surface-container-high">assignment_late</span>
                                        <p class="font-bold text-on-surface text-base">No Candidate Submissions Recorded Yet</p>
                                        <p class="text-xs max-w-md">Examinees assigned to this quiz have not yet completed their attempts. As soon as examinees submit their exams, their performance data will automatically appear here in real-time.</p>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="p-12 text-center bg-surface-container-lowest rounded-2xl border border-surface-container-high shadow-xs">
                            <span class="material-symbols-outlined text-[48px] text-surface-container-high">quiz</span>
                            <p class="font-bold text-on-surface text-base mt-2">No Quizzes Available</p>
                            <p class="text-xs text-on-surface-variant mt-1">Create an examination first to monitor performance reports.</p>
                        </div>
                    </c:otherwise>
                </c:choose>

            </div>
        </main>
    </div>
</body>
</html>
