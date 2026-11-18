<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Quiz Management Console | QuizTrack Faculty</title>
    
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
                
                <!-- Header Strip -->
                <div class="flex flex-col sm:flex-row sm:items-center justify-between gap-4 bg-surface-container-lowest p-6 rounded-2xl shadow-sm border border-surface-container-high">
                    <div>
                        <div class="flex items-center gap-2 text-xs font-mono font-semibold text-primary uppercase">
                            <span>Assessment Registry</span>
                            <span>•</span>
                            <span>Faculty Console</span>
                        </div>
                        <h1 class="text-2xl sm:text-3xl font-display font-bold text-on-surface mt-1">Quiz Console &amp; Examination Manager</h1>
                        <p class="text-sm text-on-surface-variant mt-1">
                            Author, configure, publish, and proctor midterms, quizzes, and diagnostic assessments.
                        </p>
                    </div>
                    <div class="flex items-center gap-3 shrink-0">
                        <a href="${pageContext.request.contextPath}/teacher/question-bank" class="px-4 py-2.5 rounded-xl bg-surface-container hover:bg-surface-container-high text-on-surface font-semibold text-sm transition-all flex items-center gap-2">
                            <span class="material-symbols-outlined text-[18px]">inventory_2</span>
                            <span>Question Bank</span>
                        </a>
                        <a href="${pageContext.request.contextPath}/teacher/quiz/create" class="px-5 py-2.5 rounded-xl bg-primary text-on-primary hover:bg-primary-container font-semibold text-sm transition-all shadow-sm flex items-center gap-2">
                            <span class="material-symbols-outlined text-[20px]">add_circle</span>
                            <span>Create New Quiz</span>
                        </a>
                    </div>
                </div>

                <!-- Flash Notice -->
                <c:if test="${not empty sessionScope.flashMessage}">
                    <div class="p-4 rounded-xl bg-emerald-50 text-emerald-800 border border-emerald-200 text-sm font-semibold flex items-center justify-between">
                        <div class="flex items-center gap-2">
                            <span class="material-symbols-outlined text-[20px]">check_circle</span>
                            <span><c:out value="${sessionScope.flashMessage}"/></span>
                        </div>
                    </div>
                    <c:remove var="flashMessage" scope="session"/>
                </c:if>
                <c:if test="${not empty sessionScope.flashError}">
                    <div class="p-4 rounded-xl bg-rose-50 text-rose-800 border border-rose-200 text-sm font-semibold flex items-center justify-between">
                        <div class="flex items-center gap-2">
                            <span class="material-symbols-outlined text-[20px]">error</span>
                            <span><c:out value="${sessionScope.flashError}"/></span>
                        </div>
                    </div>
                    <c:remove var="flashError" scope="session"/>
                </c:if>
                <c:if test="${not empty param.msg}">
                    <div class="p-4 rounded-xl bg-emerald-50 text-emerald-800 border border-emerald-200 text-sm font-semibold flex items-center gap-2">
                        <span class="material-symbols-outlined text-[20px]">check_circle</span>
                        <c:choose>
                            <c:when test="${param.msg == 'published'}">Quiz published and schedule updated successfully.</c:when>
                            <c:when test="${param.msg == 'draft_saved'}">Quiz state reverted to draft.</c:when>
                            <c:otherwise>Operation executed successfully.</c:otherwise>
                        </c:choose>
                    </div>
                </c:if>

                <!-- Quizzes Grid -->
                <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
                    <c:forEach var="quiz" items="${quizzes}">
                        <div class="bg-surface-container-lowest rounded-2xl p-6 shadow-sm border border-surface-container-high flex flex-col justify-between hover:shadow-md transition-all relative">
                            <div class="flex flex-col gap-3">
                                <!-- Top status badge & code -->
                                <div class="flex items-center justify-between">
                                    <span class="px-2.5 py-0.5 rounded-md font-mono text-xs font-bold uppercase bg-primary-container text-on-primary">
                                        <c:out value="${quiz.subjectCode}"/>
                                    </span>
                                    <c:choose>
                                        <c:when test="${quiz.status == 'ACTIVE'}">
                                            <span class="px-2.5 py-0.5 rounded-full bg-error-container text-on-error-container text-xs font-bold flex items-center gap-1">
                                                <span class="w-1.5 h-1.5 rounded-full bg-error animate-ping"></span> ACTIVE
                                            </span>
                                        </c:when>
                                        <c:when test="${quiz.status == 'SCHEDULED'}">
                                            <span class="px-2.5 py-0.5 rounded-full bg-surface-container text-on-surface-variant text-xs font-semibold">
                                                SCHEDULED
                                            </span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="px-2.5 py-0.5 rounded-full bg-surface-container-high text-on-surface-variant text-xs font-semibold">
                                                DRAFT
                                            </span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>

                                <!-- Title & Description -->
                                <div>
                                    <h3 class="font-display font-bold text-lg text-on-surface leading-snug">
                                        <c:out value="${quiz.title}"/>
                                    </h3>
                                    <c:if test="${currentUser.isAdmin() || sessionScope.userRole == 'ADMIN'}">
                                        <p class="text-xs text-primary font-medium mt-0.5 flex items-center gap-1">
                                            <span class="material-symbols-outlined text-[14px]">school</span>
                                            <span>Faculty: <c:out value="${quiz.teacherName}"/></span>
                                        </p>
                                    </c:if>
                                    <p class="text-xs text-on-surface-variant mt-1 line-clamp-2">
                                        <c:out value="${quiz.description != null ? quiz.description : 'No description provided.'}"/>
                                    </p>
                                </div>

                                <!-- Metric Strip -->
                                <div class="grid grid-cols-3 gap-2 py-2 border-y border-surface-container-high text-center">
                                    <div>
                                        <p class="text-[11px] font-semibold text-on-surface-variant uppercase">Duration</p>
                                        <p class="font-bold text-sm text-on-surface"><c:out value="${quiz.durationMinutes}"/> Min</p>
                                    </div>
                                    <div>
                                        <p class="text-[11px] font-semibold text-on-surface-variant uppercase">Total Pts</p>
                                        <p class="font-bold text-sm text-primary"><fmt:formatNumber value="${quiz.totalMarks}" maxFractionDigits="0"/></p>
                                    </div>
                                    <div>
                                        <p class="text-[11px] font-semibold text-on-surface-variant uppercase">Questions</p>
                                        <p class="font-bold text-sm text-on-surface"><c:out value="${quiz.totalQuestions}"/> Items</p>
                                    </div>
                                </div>

                                <!-- Proctor Settings -->
                                <div class="flex items-center gap-2 text-xs text-on-surface-variant">
                                    <span class="material-symbols-outlined text-[16px] text-tertiary">security</span>
                                    <span>
                                        <c:choose>
                                            <c:when test="${quiz.webcamRequired && quiz.fullscreenRequired}">WebCam + Browser Lock (Level 3)</c:when>
                                            <c:otherwise>Standard Lockdown Mode</c:otherwise>
                                        </c:choose>
                                    </span>
                                </div>
                            </div>

                            <!-- Actions -->
                            <div class="mt-5 pt-3 border-t border-surface-container-high/60 flex items-center justify-between gap-2">
                                <a href="${pageContext.request.contextPath}/teacher/quiz/builder?quizId=${quiz.quizId}" 
                                   class="flex-1 py-2 rounded-xl bg-primary-container text-on-primary font-semibold text-xs text-center hover:opacity-90 transition-all flex items-center justify-center gap-1.5 shadow-sm">
                                    <span class="material-symbols-outlined text-[16px]">edit_document</span>
                                    <span>Question Builder</span>
                                </a>

                                <form action="${pageContext.request.contextPath}/teacher/quiz/action" method="POST" class="inline" onsubmit="return confirm('Are you sure you want to delete this quiz? All assigned items will be removed.')">
                                    <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}"/>
                                    <input type="hidden" name="quizId" value="${quiz.quizId}"/>
                                    <input type="hidden" name="action" value="delete"/>
                                    <button type="submit" class="p-2 rounded-xl text-on-surface-variant hover:text-error hover:bg-error-container/40 transition-colors" title="Delete Quiz">
                                        <span class="material-symbols-outlined text-[18px]">delete</span>
                                    </button>
                                </form>
                            </div>
                        </div>
                    </c:forEach>

                    <!-- Blank placeholder card for new quiz creation -->
                    <a href="${pageContext.request.contextPath}/teacher/quiz/create" class="border-2 border-dashed border-surface-container-high rounded-2xl p-8 flex flex-col items-center justify-center text-center hover:border-primary transition-all group min-h-[260px]">
                        <div class="w-12 h-12 rounded-xl bg-surface-container text-primary flex items-center justify-center group-hover:scale-110 transition-transform shadow-xs">
                            <span class="material-symbols-outlined text-[28px]">add</span>
                        </div>
                        <h4 class="font-display font-bold text-base text-on-surface mt-3">Author New Assessment</h4>
                        <p class="text-xs text-on-surface-variant mt-1 max-w-xs">Configure syllabus, timings, question matrices, and proctor thresholds.</p>
                    </a>
                </div>

            </div>
        </main>
    </div>
</body>
</html>
