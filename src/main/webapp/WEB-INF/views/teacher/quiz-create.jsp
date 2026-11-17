<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Create New Examination | QuizTrack Faculty</title>

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
            <div class="max-w-4xl mx-auto flex flex-col gap-6">

                <!-- Breadcrumb Strip -->
                <div class="flex items-center gap-2 text-xs font-mono font-medium text-on-surface-variant">
                    <a href="${pageContext.request.contextPath}/teacher/dashboard" class="hover:text-primary">Faculty Portal</a>
                    <span class="material-symbols-outlined text-[14px]">chevron_right</span>
                    <a href="${pageContext.request.contextPath}/teacher/quizzes" class="hover:text-primary">Examinations</a>
                    <span class="material-symbols-outlined text-[14px]">chevron_right</span>
                    <span class="text-primary font-bold">New Assessment Setup</span>
                </div>

                <!-- Stepper Progress (B12) -->
                <div class="grid grid-cols-1 sm:grid-cols-4 gap-3 bg-surface-container-lowest p-3 rounded-2xl shadow-sm border border-surface-container-high">
                    <div class="flex items-center gap-3 p-3 rounded-xl bg-primary-container text-on-primary">
                        <span class="w-7 h-7 rounded-full bg-on-primary text-primary flex items-center justify-center font-bold text-xs">1</span>
                        <div class="flex flex-col min-w-0">
                            <span class="text-[10px] uppercase tracking-wider font-mono font-bold text-on-primary-container">Step 1 • Active</span>
                            <span class="text-xs font-bold truncate">Basics &amp; Rules</span>
                        </div>
                    </div>
                    <div class="flex items-center gap-3 p-3 rounded-xl bg-surface-container-low text-on-surface-variant">
                        <span class="w-7 h-7 rounded-full bg-surface-container flex items-center justify-center font-bold text-xs">2</span>
                        <div class="flex flex-col min-w-0">
                            <span class="text-[10px] uppercase tracking-wider font-mono font-semibold">Step 2 • Pending</span>
                            <span class="text-xs font-semibold truncate">Question Builder</span>
                        </div>
                    </div>
                    <div class="flex items-center gap-3 p-3 rounded-xl bg-surface-container-low text-on-surface-variant">
                        <span class="w-7 h-7 rounded-full bg-surface-container flex items-center justify-center font-bold text-xs">3</span>
                        <div class="flex flex-col min-w-0">
                            <span class="text-[10px] uppercase tracking-wider font-mono font-semibold">Step 3 • Pending</span>
                            <span class="text-xs font-semibold truncate">Settings &amp; Policies</span>
                        </div>
                    </div>
                    <div class="flex items-center gap-3 p-3 rounded-xl bg-surface-container-low text-on-surface-variant">
                        <span class="w-7 h-7 rounded-full bg-surface-container flex items-center justify-center font-bold text-xs">4</span>
                        <div class="flex flex-col min-w-0">
                            <span class="text-[10px] uppercase tracking-wider font-mono font-semibold">Step 4 • Pending</span>
                            <span class="text-xs font-semibold truncate">Publish &amp; Assign</span>
                        </div>
                    </div>
                </div>

                <!-- Error Notice (B10) -->
                <c:if test="${not empty errorMessage}">
                    <div class="p-4 rounded-xl bg-error-container text-on-error-container text-sm font-semibold flex items-center gap-2 border border-red-300">
                        <span class="material-symbols-outlined text-[20px]">error</span>
                        <span><c:out value="${errorMessage}"/></span>
                    </div>
                </c:if>

                <!-- Configuration Form -->
                <form action="${pageContext.request.contextPath}/teacher/quiz/create" method="POST" class="bg-surface-container-lowest p-6 sm:p-8 rounded-2xl shadow-sm border border-surface-container-high flex flex-col gap-6">
                    <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}"/>

                    <div class="border-b border-surface-container-high pb-4">
                        <h2 class="text-xl font-display font-bold text-on-surface">Step 1: Assessment Definition &amp; Parameters</h2>
                        <p class="text-xs text-on-surface-variant mt-1">Specify title, department module, time allotments, examination window, and proctoring rules.</p>
                    </div>

                    <!-- Title & Subject -->
                    <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
                        <div class="md:col-span-2 flex flex-col gap-1.5">
                            <label class="text-xs font-bold uppercase tracking-wider text-on-surface-variant" for="title">Quiz / Examination Title *</label>
                            <input type="text" id="title" name="title" required value="<c:out value='${not empty title ? title : \"\"}'/>" placeholder="e.g. CS402: Midterm Exam - Distributed Systems &amp; Concurrency" class="px-4 py-2.5 rounded-xl bg-surface-container-low text-on-surface border border-surface-container-high focus:outline-none focus:ring-2 focus:ring-primary text-sm font-medium"/>
                        </div>
                        <div class="flex flex-col gap-1.5">
                            <label class="text-xs font-bold uppercase tracking-wider text-on-surface-variant" for="subjectId">Departmental Course *</label>
                            <select id="subjectId" name="subjectId" required class="px-4 py-2.5 rounded-xl bg-surface-container-low text-on-surface border border-surface-container-high focus:outline-none focus:ring-2 focus:ring-primary text-sm font-medium">
                                <c:forEach var="subj" items="${subjects}">
                                    <option value="${subj.subjectId}" ${(subj.subjectId == selectedSubjectId) ? 'selected' : ''}><c:out value="${subj.subjectCode}"/> - <c:out value="${subj.subjectName}"/></option>
                                </c:forEach>
                            </select>
                        </div>
                    </div>

                    <!-- Description -->
                    <div class="flex flex-col gap-1.5">
                        <label class="text-xs font-bold uppercase tracking-wider text-on-surface-variant" for="description">Syllabus &amp; Scope Overview</label>
                        <textarea id="description" name="description" rows="3" placeholder="Covers consensus protocols, Raft, Byzantine fault tolerance, replicated state machines, and vector clocks." class="px-4 py-2.5 rounded-xl bg-surface-container-low text-on-surface border border-surface-container-high focus:outline-none focus:ring-2 focus:ring-primary text-sm"><c:out value='${not empty description ? description : \"\"}'/></textarea>
                    </div>

                    <!-- Timing & Scoring Matrix (B12 & User Decision) -->
                    <div class="grid grid-cols-1 sm:grid-cols-3 gap-4">
                        <div class="flex flex-col gap-1.5">
                            <label class="text-xs font-bold uppercase tracking-wider text-on-surface-variant" for="durationMinutes">Duration (Minutes) *</label>
                            <input type="number" id="durationMinutes" name="durationMinutes" required min="1" max="${maxAllowedDuration}" value="<c:out value='${not empty durationMinutes ? durationMinutes : defaultDuration}'/>" class="px-4 py-2.5 rounded-xl bg-surface-container-low text-on-surface border border-surface-container-high focus:outline-none focus:ring-2 focus:ring-primary text-sm font-semibold"/>
                            <span class="text-[10px] text-on-surface-variant">System Maximum: ${maxAllowedDuration} mins</span>
                        </div>
                        <div class="flex flex-col gap-1.5">
                            <label class="text-xs font-bold uppercase tracking-wider text-on-surface-variant" for="totalMarks">Aggregate Marks</label>
                            <div class="relative">
                                <input type="number" step="0.5" id="totalMarks" name="totalMarks" readonly value="<c:out value='${not empty totalMarks ? totalMarks : \"0.00\"}'/>" class="w-full px-4 py-2.5 rounded-xl bg-surface-container text-on-surface-variant border border-surface-container-high text-sm font-semibold cursor-not-allowed"/>
                                <span class="absolute right-3 top-2.5 text-[10px] font-mono font-semibold text-primary bg-primary/10 px-2 py-0.5 rounded">Auto-computed</span>
                            </div>
                            <span class="text-[10px] text-on-surface-variant">Summed automatically from questions in Step 2</span>
                        </div>
                        <div class="flex flex-col gap-1.5">
                            <label class="text-xs font-bold uppercase tracking-wider text-on-surface-variant" for="passPercentage">Pass Benchmark (%) *</label>
                            <input type="number" step="0.5" id="passPercentage" name="passPercentage" required min="0" max="100" value="<c:out value='${not empty passPercentage ? passPercentage : defaultPassPercentage}'/>" class="px-4 py-2.5 rounded-xl bg-surface-container-low text-on-surface border border-surface-container-high focus:outline-none focus:ring-2 focus:ring-primary text-sm font-semibold"/>
                            <span class="text-[10px] text-on-surface-variant">Default benchmark: ${defaultPassPercentage}%</span>
                        </div>
                    </div>

                    <!-- Examination Schedule Window (B3) -->
                    <div class="p-4 rounded-xl bg-surface-container-low border border-surface-container flex flex-col gap-3">
                        <div class="flex flex-col">
                            <span class="text-xs font-bold uppercase tracking-wider text-on-surface-variant flex items-center gap-1.5">
                                <span class="material-symbols-outlined text-[16px] text-primary">calendar_month</span>
                                Examination Schedule Window (Start &amp; End Date/Time)
                            </span>
                            <p class="text-xs text-on-surface-variant mt-0.5">Define when candidates are permitted to sit for this examination. Required if Initial Lifecycle is set to Scheduled.</p>
                        </div>
                        <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
                            <div class="flex flex-col gap-1.5">
                                <label class="text-xs font-bold uppercase tracking-wider text-on-surface-variant" for="startTime">Window Opens (Start Time)</label>
                                <input type="datetime-local" id="startTime" name="startTime" value="<c:out value='${startTimeStr}'/>" class="px-4 py-2.5 rounded-xl bg-surface-container-lowest text-on-surface border border-surface-container-high focus:outline-none focus:ring-2 focus:ring-primary text-sm font-medium"/>
                            </div>
                            <div class="flex flex-col gap-1.5">
                                <label class="text-xs font-bold uppercase tracking-wider text-on-surface-variant" for="endTime">Window Closes (End Time)</label>
                                <input type="datetime-local" id="endTime" name="endTime" value="<c:out value='${endTimeStr}'/>" class="px-4 py-2.5 rounded-xl bg-surface-container-lowest text-on-surface border border-surface-container-high focus:outline-none focus:ring-2 focus:ring-primary text-sm font-medium"/>
                            </div>
                        </div>
                    </div>

                    <!-- Negative Marking Strip -->
                    <div class="p-4 rounded-xl bg-surface-container-low border border-surface-container flex flex-col sm:flex-row items-start sm:items-center justify-between gap-4">
                        <div class="flex items-center gap-3">
                            <input type="checkbox" id="negativeMarking" name="negativeMarking" ${negativeMarking ? 'checked' : ''} class="h-5 w-5 rounded accent-primary cursor-pointer" onchange="toggleNegativeValue(this)"/>
                            <div>
                                <label for="negativeMarking" class="text-sm font-bold text-on-surface cursor-pointer">Enforce Negative Marking Penalty</label>
                                <p class="text-xs text-on-surface-variant">Deduct points for incorrect multiple-choice submissions.</p>
                            </div>
                        </div>
                        <div class="flex items-center gap-2" id="negativeValueGroup" style="${negativeMarking ? 'display: flex;' : 'display: none;'}">
                            <span class="text-xs font-mono font-semibold text-error">Deduct Pts:</span>
                            <input type="number" step="0.25" min="0" max="10" name="negativeMarkValue" value="<c:out value='${not empty negativeMarkValue ? negativeMarkValue : \"1.00\"}'/>" class="w-20 px-2 py-1.5 rounded-lg bg-surface-container-lowest border border-surface-container-high text-sm font-mono font-bold text-error text-center"/>
                        </div>
                    </div>

                    <!-- Anti-Cheat & Lockout Toggles -->
                    <div class="flex flex-col gap-3">
                        <span class="text-xs font-bold uppercase tracking-wider text-on-surface-variant">Anti-Cheat &amp; Telemetry Presets</span>
                        <div class="grid grid-cols-1 sm:grid-cols-2 gap-3">
                            <label class="flex items-center gap-3 p-3 rounded-xl bg-surface-container-low border border-surface-container cursor-pointer hover:bg-surface-container transition-all">
                                <input type="checkbox" name="fullscreenRequired" ${(fullscreenRequired == null || fullscreenRequired) ? 'checked' : ''} class="h-4 w-4 rounded accent-primary cursor-pointer"/>
                                <div class="flex flex-col">
                                    <span class="text-sm font-semibold text-on-surface">Fullscreen Viewport Lock</span>
                                    <span class="text-xs text-on-surface-variant">Traps focus, logs Alt+Tab &amp; window blur events</span>
                                </div>
                            </label>

                            <label class="flex items-center gap-3 p-3 rounded-xl bg-surface-container-low border border-surface-container cursor-pointer hover:bg-surface-container transition-all">
                                <input type="checkbox" name="webcamRequired" ${webcamRequired ? 'checked' : ''} class="h-4 w-4 rounded accent-primary cursor-pointer"/>
                                <div class="flex flex-col">
                                    <span class="text-sm font-semibold text-on-surface">Webcam &amp; Audio Telemetry</span>
                                    <span class="text-xs text-on-surface-variant">AI facial gaze tracking and ambient noise checks</span>
                                </div>
                            </label>

                            <label class="flex items-center gap-3 p-3 rounded-xl bg-surface-container-low border border-surface-container cursor-pointer hover:bg-surface-container transition-all">
                                <input type="checkbox" name="shuffleQuestions" ${(shuffleQuestions == null || shuffleQuestions) ? 'checked' : ''} class="h-4 w-4 rounded accent-primary cursor-pointer"/>
                                <div class="flex flex-col">
                                    <span class="text-sm font-semibold text-on-surface">Randomize Question Sequence</span>
                                    <span class="text-xs text-on-surface-variant">Shuffles question ordering per examinee seat</span>
                                </div>
                            </label>

                            <div class="flex items-center justify-between p-3 rounded-xl bg-surface-container-low border border-surface-container">
                                <div class="flex flex-col">
                                    <span class="text-sm font-semibold text-on-surface">Max Tab Switch Threshold</span>
                                    <span class="text-xs text-on-surface-variant">Escalates to proctor lockout on exceed</span>
                                </div>
                                <select name="maxTabSwitches" class="px-2.5 py-1 rounded-lg bg-surface-container-lowest text-sm font-mono font-bold border border-surface-container-high">
                                    <option value="1" ${maxTabSwitches == '1' ? 'selected' : ''}>1 Strike</option>
                                    <option value="2" ${maxTabSwitches == '2' ? 'selected' : ''}>2 Strikes</option>
                                    <option value="3" ${maxTabSwitches == '3' or empty maxTabSwitches ? 'selected' : ''}>3 Strikes</option>
                                    <option value="5" ${maxTabSwitches == '5' ? 'selected' : ''}>5 Strikes</option>
                                </select>
                            </div>
                        </div>
                    </div>

                    <!-- Initial Status (B3: limited to DRAFT or SCHEDULED) -->
                    <div class="flex items-center justify-between pt-4 border-t border-surface-container-high">
                        <div class="flex items-center gap-2">
                            <span class="text-xs font-semibold text-on-surface-variant">Initial Lifecycle:</span>
                            <select name="status" class="px-3 py-1.5 rounded-lg bg-surface-container-low text-xs font-mono font-bold uppercase border border-surface-container-high focus:outline-none focus:ring-2 focus:ring-primary">
                                <option value="DRAFT" ${status == 'DRAFT' or empty status ? 'selected' : ''}>Draft (Authoring In Progress)</option>
                                <option value="SCHEDULED" ${status == 'SCHEDULED' ? 'selected' : ''}>Scheduled (Ready for Calendar)</option>
                            </select>
                        </div>
                        <div class="flex items-center gap-3">
                            <a href="${pageContext.request.contextPath}/teacher/quizzes" class="px-4 py-2.5 rounded-xl bg-surface-container hover:bg-surface-container-high text-xs font-bold text-on-surface transition-all">
                                Cancel
                            </a>
                            <button type="submit" class="px-6 py-2.5 rounded-xl bg-primary hover:bg-primary-container text-on-primary text-xs font-bold transition-all shadow-md flex items-center gap-2">
                                <span>Save &amp; Continue to Question Builder</span>
                                <span class="material-symbols-outlined text-[16px]">arrow_forward</span>
                            </button>
                        </div>
                    </div>

                </form>

            </div>
        </main>
    </div>

    <script>
        function toggleNegativeValue(checkbox) {
            const group = document.getElementById('negativeValueGroup');
            if (group) {
                group.style.display = checkbox.checked ? 'flex' : 'none';
            }
        }
    </script>
</body>
</html>
