<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Departmental Question Bank | QuizTrack Faculty</title>
    
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
                            <span>Item Bank Repository</span>
                            <span>•</span>
                            <span>Faculty Registry</span>
                        </div>
                        <h1 class="text-2xl sm:text-3xl font-display font-bold text-on-surface mt-1">Departmental Question Bank</h1>
                        <p class="text-sm text-on-surface-variant mt-1">
                            Author, calibrate, categorize, and curate peer-reviewed questions for multi-section examinations.
                        </p>
                    </div>
                    <div class="flex items-center gap-3 shrink-0">
                        <a href="${pageContext.request.contextPath}/teacher/quizzes" class="px-4 py-2.5 rounded-xl bg-surface-container hover:bg-surface-container-high text-on-surface font-semibold text-sm transition-all flex items-center gap-2">
                            <span class="material-symbols-outlined text-[18px]">arrow_back</span>
                            <span>Back to Quizzes</span>
                        </a>
                        <button type="button" onclick="toggleAuthorModal(true)" class="px-5 py-2.5 rounded-xl bg-primary text-on-primary hover:bg-primary-container font-semibold text-sm transition-all shadow-sm flex items-center gap-2">
                            <span class="material-symbols-outlined text-[20px]">add_circle</span>
                            <span>Author New Question</span>
                        </button>
                    </div>
                </div>

                <!-- Filter & Search Bar -->
                <form method="GET" action="${pageContext.request.contextPath}/teacher/question-bank" class="bg-surface-container-lowest p-5 rounded-2xl shadow-sm border border-surface-container-high flex flex-wrap items-center gap-4">
                    <div class="flex-1 min-w-[200px]">
                        <label class="block text-xs font-semibold text-on-surface-variant uppercase mb-1">Subject</label>
                        <select name="subjectId" class="w-full px-3 py-2 rounded-xl bg-surface-container-low border border-surface-container-high text-sm font-medium focus:ring-2 focus:ring-primary focus:outline-none">
                            <option value="ALL">All Subjects</option>
                            <c:forEach var="sub" items="${subjects}">
                                <option value="${sub.subjectId}" ${selectedSubjectId == sub.subjectId ? 'selected' : ''}>
                                    ${sub.subjectCode} - ${sub.subjectName}
                                </option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="w-40">
                        <label class="block text-xs font-semibold text-on-surface-variant uppercase mb-1">Difficulty</label>
                        <select name="difficulty" class="w-full px-3 py-2 rounded-xl bg-surface-container-low border border-surface-container-high text-sm font-medium focus:ring-2 focus:ring-primary focus:outline-none">
                            <option value="">All Difficulties</option>
                            <option value="EASY" ${selectedDifficulty == 'EASY' ? 'selected' : ''}>Easy</option>
                            <option value="MEDIUM" ${selectedDifficulty == 'MEDIUM' ? 'selected' : ''}>Medium</option>
                            <option value="HARD" ${selectedDifficulty == 'HARD' ? 'selected' : ''}>Hard</option>
                        </select>
                    </div>
                    <div class="w-48">
                        <label class="block text-xs font-semibold text-on-surface-variant uppercase mb-1">Topic / Domain</label>
                        <input type="text" name="topic" value="${selectedTopic}" placeholder="e.g. Distributed, SQL" class="w-full px-3 py-2 rounded-xl bg-surface-container-low border border-surface-container-high text-sm font-medium focus:ring-2 focus:ring-primary focus:outline-none"/>
                    </div>
                    <div class="flex-1 min-w-[200px]">
                        <label class="block text-xs font-semibold text-on-surface-variant uppercase mb-1">Keyword Search</label>
                        <div class="relative">
                            <span class="material-symbols-outlined absolute left-3 top-2.5 text-on-surface-variant text-[18px]">search</span>
                            <input type="text" name="search" value="${searchQuery}" placeholder="Search prompt, explanations..." class="w-full pl-9 pr-3 py-2 rounded-xl bg-surface-container-low border border-surface-container-high text-sm font-medium focus:ring-2 focus:ring-primary focus:outline-none"/>
                        </div>
                    </div>
                    <div class="flex items-end gap-2 pt-5">
                        <button type="submit" class="px-5 py-2 rounded-xl bg-primary text-on-primary hover:bg-primary-container font-semibold text-sm transition-all flex items-center gap-1.5 shadow-sm">
                            <span class="material-symbols-outlined text-[18px]">tune</span>
                            <span>Filter</span>
                        </button>
                        <a href="${pageContext.request.contextPath}/teacher/question-bank" class="px-4 py-2 rounded-xl bg-surface-container hover:bg-surface-container-high text-on-surface font-semibold text-sm transition-all">
                            Reset
                        </a>
                    </div>
                </form>

                <!-- Results Counter -->
                <div class="flex items-center justify-between text-sm px-2">
                    <span class="font-semibold text-on-surface-variant">
                        Showing <span class="text-on-surface font-bold">${questions.size()}</span> of <span class="text-on-surface font-bold">${totalCount}</span> peer-reviewed questions
                    </span>
                    <span class="font-mono text-xs text-primary font-semibold">PostgreSQL Relational Repository</span>
                </div>

                <!-- Questions List -->
                <div class="flex flex-col gap-4">
                    <c:choose>
                        <c:when test="${empty questions}">
                            <div class="p-12 text-center bg-surface-container-lowest rounded-2xl border border-surface-container-high shadow-sm">
                                <span class="material-symbols-outlined text-4xl text-on-surface-variant mb-2">find_in_page</span>
                                <h3 class="text-lg font-bold text-on-surface">No Questions Match Criteria</h3>
                                <p class="text-sm text-on-surface-variant mt-1">Try broadening your search or author a new question into the departmental repository.</p>
                                <button type="button" onclick="toggleAuthorModal(true)" class="mt-4 px-5 py-2.5 rounded-xl bg-primary text-on-primary font-semibold text-sm">
                                    Author First Question
                                </button>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="q" items="${questions}">
                                <div class="bg-surface-container-lowest rounded-2xl p-6 shadow-sm border border-surface-container-high hover:border-primary/40 transition-all flex flex-col gap-4">
                                    <!-- Card Header Bar -->
                                    <div class="flex flex-wrap items-center justify-between gap-3 pb-3 border-b border-surface-container-high">
                                        <div class="flex items-center gap-2 flex-wrap">
                                            <span class="px-2.5 py-1 rounded-md bg-surface-container font-mono text-xs font-bold text-primary">
                                                ITEM #${q.questionId}
                                            </span>
                                            <c:if test="${not empty q.subjectCode}">
                                                <span class="px-2.5 py-1 rounded-md bg-surface-container-high text-xs font-semibold text-on-surface">
                                                    ${q.subjectCode}
                                                </span>
                                            </c:if>
                                            <c:if test="${not empty q.taxonomyTopic}">
                                                <span class="px-2.5 py-1 rounded-md bg-indigo-50 text-indigo-700 text-xs font-semibold border border-indigo-100">
                                                    ${q.taxonomyTopic}
                                                </span>
                                            </c:if>
                                            <!-- Difficulty Badge -->
                                            <c:choose>
                                                <c:when test="${q.difficultyLevel == 'EASY'}">
                                                    <span class="px-2.5 py-1 rounded-md bg-emerald-50 text-emerald-700 text-xs font-bold border border-emerald-200">
                                                        EASY
                                                    </span>
                                                </c:when>
                                                <c:when test="${q.difficultyLevel == 'HARD'}">
                                                    <span class="px-2.5 py-1 rounded-md bg-rose-50 text-rose-700 text-xs font-bold border border-rose-200">
                                                        HARD
                                                    </span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="px-2.5 py-1 rounded-md bg-amber-50 text-amber-700 text-xs font-bold border border-amber-200">
                                                        MEDIUM
                                                    </span>
                                                </c:otherwise>
                                            </c:choose>
                                            <!-- Type & Points -->
                                            <span class="px-2.5 py-1 rounded-md bg-surface-container-low text-xs font-mono font-medium text-on-surface-variant">
                                                ${q.points} pt(s)
                                            </span>
                                        </div>

                                        <div class="flex items-center gap-2">
                                            <!-- Delete Form -->
                                            <form method="POST" action="${pageContext.request.contextPath}/teacher/question-bank" onsubmit="return confirm('Are you sure you want to permanently delete Question #${q.questionId}?');" class="inline">
                                                <input type="hidden" name="action" value="delete"/>
                                                <input type="hidden" name="questionId" value="${q.questionId}"/>
                                                <button type="submit" class="p-2 rounded-lg text-rose-600 hover:bg-rose-50 transition-colors" title="Delete Question">
                                                    <span class="material-symbols-outlined text-[18px]">delete</span>
                                                </button>
                                            </form>
                                        </div>
                                    </div>

                                    <!-- Question Prompt -->
                                    <div class="text-on-surface font-medium text-base leading-relaxed">
                                        ${q.questionText}
                                    </div>

                                    <!-- Code Snippet if present -->
                                    <c:if test="${not empty q.codeSnippet}">
                                        <pre class="bg-surface-container-high/60 p-4 rounded-xl text-xs font-mono text-on-surface border border-surface-container-high overflow-x-auto"><code>${q.codeSnippet}</code></pre>
                                    </c:if>

                                    <!-- Options Grid -->
                                    <div class="grid grid-cols-1 sm:grid-cols-2 gap-3 pt-2">
                                        <c:forEach var="opt" items="${q.options}">
                                            <div class="flex items-start gap-3 p-3 rounded-xl border ${opt.isCorrect ? 'bg-emerald-50/60 border-emerald-300 text-emerald-950 font-semibold' : 'bg-surface-container-low/50 border-surface-container-high text-on-surface-variant'} transition-all">
                                                <span class="flex-shrink-0 w-6 h-6 rounded-lg ${opt.isCorrect ? 'bg-emerald-600 text-white' : 'bg-surface-container text-on-surface-variant'} flex items-center justify-center font-bold font-mono text-xs">
                                                    ${opt.optionLetter}
                                                </span>
                                                <span class="text-sm flex-1">${opt.optionText}</span>
                                                <c:if test="${opt.isCorrect}">
                                                    <span class="material-symbols-outlined text-emerald-600 text-[18px]">check_circle</span>
                                                </c:if>
                                            </div>
                                        </c:forEach>
                                    </div>

                                    <!-- Explanation / Rationale -->
                                    <c:if test="${not empty q.explanation}">
                                        <div class="p-3.5 rounded-xl bg-surface-container-low border border-surface-container-high text-xs text-on-surface-variant flex items-start gap-2">
                                            <span class="material-symbols-outlined text-primary text-[18px] shrink-0">lightbulb</span>
                                            <div>
                                                <span class="font-bold text-on-surface">Pedagogical Rationale:</span>
                                                <span>${q.explanation}</span>
                                            </div>
                                        </div>
                                    </c:if>
                                </div>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </div>

            </div>
        </main>
    </div>

    <!-- Modal: Author New Question -->
    <div id="authorModal" class="fixed inset-0 z-50 bg-black/50 backdrop-blur-sm hidden flex items-center justify-center p-4">
        <div class="bg-surface-container-lowest rounded-2xl max-w-2xl w-full p-6 shadow-2xl border border-surface-container-high max-h-[90vh] overflow-y-auto">
            <div class="flex items-center justify-between pb-4 border-b border-surface-container-high">
                <div class="flex items-center gap-2">
                    <span class="material-symbols-outlined text-primary text-[24px]">post_add</span>
                    <h2 class="text-xl font-display font-bold text-on-surface">Author Repository Question</h2>
                </div>
                <button type="button" onclick="toggleAuthorModal(false)" class="p-1 rounded-lg text-on-surface-variant hover:bg-surface-container">
                    <span class="material-symbols-outlined">close</span>
                </button>
            </div>

            <form method="POST" action="${pageContext.request.contextPath}/teacher/question-bank" class="flex flex-col gap-4 mt-4">
                <input type="hidden" name="action" value="create"/>
                <input type="hidden" name="questionType" value="MCQ"/>

                <div class="grid grid-cols-1 sm:grid-cols-3 gap-4">
                    <div>
                        <label class="block text-xs font-semibold text-on-surface-variant uppercase mb-1">Subject</label>
                        <select name="subjectId" required class="w-full px-3 py-2 rounded-xl bg-surface-container-low border border-surface-container-high text-sm font-medium focus:ring-2 focus:ring-primary focus:outline-none">
                            <c:forEach var="sub" items="${subjects}">
                                <option value="${sub.subjectId}">${sub.subjectCode} - ${sub.subjectName}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div>
                        <label class="block text-xs font-semibold text-on-surface-variant uppercase mb-1">Difficulty</label>
                        <select name="difficultyLevel" required class="w-full px-3 py-2 rounded-xl bg-surface-container-low border border-surface-container-high text-sm font-medium focus:ring-2 focus:ring-primary focus:outline-none">
                            <option value="EASY">Easy</option>
                            <option value="MEDIUM" selected>Medium</option>
                            <option value="HARD">Hard</option>
                        </select>
                    </div>
                    <div>
                        <label class="block text-xs font-semibold text-on-surface-variant uppercase mb-1">Points</label>
                        <input type="number" step="0.5" name="points" value="1.0" min="0.5" max="10" required class="w-full px-3 py-2 rounded-xl bg-surface-container-low border border-surface-container-high text-sm font-medium focus:ring-2 focus:ring-primary focus:outline-none"/>
                    </div>
                </div>

                <div>
                    <label class="block text-xs font-semibold text-on-surface-variant uppercase mb-1">Topic / Conceptual Domain</label>
                    <input type="text" name="taxonomyTopic" placeholder="e.g. Consensus Protocols, Indexing" required class="w-full px-3 py-2 rounded-xl bg-surface-container-low border border-surface-container-high text-sm font-medium focus:ring-2 focus:ring-primary focus:outline-none"/>
                </div>

                <div>
                    <label class="block text-xs font-semibold text-on-surface-variant uppercase mb-1">Question Prompt / Statement</label>
                    <textarea name="questionText" rows="3" required placeholder="Type the question statement..." class="w-full px-3 py-2 rounded-xl bg-surface-container-low border border-surface-container-high text-sm font-medium focus:ring-2 focus:ring-primary focus:outline-none"></textarea>
                </div>

                <div>
                    <label class="block text-xs font-semibold text-on-surface-variant uppercase mb-1">Code Snippet (Optional)</label>
                    <textarea name="codeSnippet" rows="2" placeholder="Optional formatted code snippet..." class="w-full px-3 py-2 rounded-xl bg-surface-container-low border border-surface-container-high text-xs font-mono focus:ring-2 focus:ring-primary focus:outline-none"></textarea>
                </div>

                <!-- 4 Options -->
                <div>
                    <label class="block text-xs font-semibold text-on-surface-variant uppercase mb-2">Options &amp; Correct Answer Key</label>
                    <div class="flex flex-col gap-2.5">
                        <div class="flex items-center gap-3">
                            <input type="radio" name="correctOption" value="A" checked class="w-4 h-4 text-primary focus:ring-primary" title="Select if Option A is correct"/>
                            <span class="w-6 font-mono font-bold text-xs text-on-surface">A:</span>
                            <input type="text" name="optionText_A" required placeholder="Option A text" class="flex-1 px-3 py-1.5 rounded-lg bg-surface-container-low border border-surface-container-high text-sm focus:ring-2 focus:ring-primary focus:outline-none"/>
                        </div>
                        <div class="flex items-center gap-3">
                            <input type="radio" name="correctOption" value="B" class="w-4 h-4 text-primary focus:ring-primary" title="Select if Option B is correct"/>
                            <span class="w-6 font-mono font-bold text-xs text-on-surface">B:</span>
                            <input type="text" name="optionText_B" required placeholder="Option B text" class="flex-1 px-3 py-1.5 rounded-lg bg-surface-container-low border border-surface-container-high text-sm focus:ring-2 focus:ring-primary focus:outline-none"/>
                        </div>
                        <div class="flex items-center gap-3">
                            <input type="radio" name="correctOption" value="C" class="w-4 h-4 text-primary focus:ring-primary" title="Select if Option C is correct"/>
                            <span class="w-6 font-mono font-bold text-xs text-on-surface">C:</span>
                            <input type="text" name="optionText_C" required placeholder="Option C text" class="flex-1 px-3 py-1.5 rounded-lg bg-surface-container-low border border-surface-container-high text-sm focus:ring-2 focus:ring-primary focus:outline-none"/>
                        </div>
                        <div class="flex items-center gap-3">
                            <input type="radio" name="correctOption" value="D" class="w-4 h-4 text-primary focus:ring-primary" title="Select if Option D is correct"/>
                            <span class="w-6 font-mono font-bold text-xs text-on-surface">D:</span>
                            <input type="text" name="optionText_D" required placeholder="Option D text" class="flex-1 px-3 py-1.5 rounded-lg bg-surface-container-low border border-surface-container-high text-sm focus:ring-2 focus:ring-primary focus:outline-none"/>
                        </div>
                    </div>
                </div>

                <div>
                    <label class="block text-xs font-semibold text-on-surface-variant uppercase mb-1">Pedagogical Explanation / Rationale</label>
                    <textarea name="explanation" rows="2" placeholder="Explain why the correct answer is valid..." class="w-full px-3 py-2 rounded-xl bg-surface-container-low border border-surface-container-high text-sm focus:ring-2 focus:ring-primary focus:outline-none"></textarea>
                </div>

                <div class="flex items-center justify-end gap-3 pt-3 border-t border-surface-container-high">
                    <button type="button" onclick="toggleAuthorModal(false)" class="px-4 py-2 rounded-xl bg-surface-container hover:bg-surface-container-high text-sm font-semibold text-on-surface">
                        Cancel
                    </button>
                    <button type="submit" class="px-5 py-2 rounded-xl bg-primary text-on-primary hover:bg-primary-container text-sm font-semibold shadow-sm flex items-center gap-2">
                        <span class="material-symbols-outlined text-[18px]">check</span>
                        <span>Save to Item Bank</span>
                    </button>
                </div>
            </form>
        </div>
    </div>

    <script>
        function toggleAuthorModal(show) {
            const modal = document.getElementById('authorModal');
            if (show) {
                modal.classList.remove('hidden');
            } else {
                modal.classList.add('hidden');
            }
        }
    </script>
</body>
</html>
