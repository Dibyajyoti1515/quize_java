<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!-- FIXED OVERLAY & ACTIVE PRE-EXAM READINESS MODAL -->
<div class="fixed inset-0 z-50 flex items-center justify-center p-3 sm:p-6 lg:p-8 bg-slate-900/60 backdrop-blur-sm transition-opacity duration-300 hidden" id="preflight-modal-overlay">
    <div class="w-full max-w-5xl max-h-[92vh] flex flex-col bg-surface-container-lowest rounded-2xl shadow-2xl border border-surface-container-high overflow-hidden animate-in fade-in zoom-in-95 duration-200">
        <!-- Modal Top Navigation / Identity Strip -->
        <div class="px-4 sm:px-space-lg py-4 bg-surface-container-low border-b border-surface-container-high flex items-center justify-between shrink-0">
            <div class="flex items-center gap-3">
                <div class="w-10 h-10 rounded-xl bg-primary-container text-on-primary flex items-center justify-center shadow-sm shrink-0">
                    <span class="material-symbols-outlined text-[22px]">policy</span>
                </div>
                <div class="flex flex-col">
                    <div class="flex flex-wrap items-center gap-2">
                        <span class="px-2 py-0.5 rounded bg-primary-fixed text-on-primary-fixed-variant font-code-telemetry text-code-telemetry font-bold">
                            <c:out value="${dashboardData.activeQuiz != null ? dashboardData.activeQuiz.subjectCode : 'CS402'}"/>
                        </span>
                        <span class="font-title-md text-title-md text-on-surface font-bold tracking-tight">
                            <c:out value="${dashboardData.activeQuiz != null ? dashboardData.activeQuiz.title : 'Midterm Exam: Distributed Systems & Concurrency'}"/>
                        </span>
                        <span class="hidden sm:inline-flex px-2 py-0.5 rounded-full bg-error-container text-on-error-container font-label-sm text-label-sm font-semibold">
                            Proctored Session
                        </span>
                    </div>
                    <div class="flex flex-wrap items-center gap-2 font-label-sm text-label-sm text-on-surface-variant mt-0.5">
                        <span>Host: Department of Computer Science</span>
                        <span class="text-outline-variant">•</span>
                        <span class="font-medium text-on-surface">Proctor: <c:out value="${dashboardData.activeQuiz != null ? dashboardData.activeQuiz.teacherName : 'Prof. Ronald Vance'}"/></span>
                        <span class="text-outline-variant">•</span>
                        <span class="font-code-telemetry text-code-telemetry text-tertiary">TOKEN: QT-8842-DISTRIB</span>
                    </div>
                </div>
            </div>
            <button class="p-2 rounded-lg text-on-surface-variant hover:bg-surface-container hover:text-on-surface transition-colors" 
                    onclick="closePreflightModal()" title="Close Pre-check">
                <span class="material-symbols-outlined text-[20px]">close</span>
            </button>
        </div>

        <!-- Modal Body Content: 2-Column Responsive Layout -->
        <div class="flex-1 overflow-y-auto p-4 sm:p-space-lg grid grid-cols-1 lg:grid-cols-12 gap-space-lg">
            <!-- Left Column (7 cols): Exam Rules & Integrity Instructions -->
            <div class="lg:col-span-7 flex flex-col gap-space-md">
                <!-- Exam Metrics Banner -->
                <div class="grid grid-cols-2 sm:grid-cols-4 gap-2 p-space-sm bg-surface-container-low rounded-xl border border-surface-container">
                    <div class="flex flex-col p-2 text-center bg-surface-container-lowest rounded-lg shadow-sm">
                        <span class="font-label-sm text-label-sm text-outline uppercase font-semibold">Time Limit</span>
                        <span class="font-title-lg text-title-lg text-on-surface font-bold mt-0.5">
                            <c:out value="${dashboardData.activeQuiz != null ? dashboardData.activeQuiz.durationMinutes : 90}"/> Min
                        </span>
                        <span class="font-label-sm text-label-sm text-on-surface-variant">Auto-submits</span>
                    </div>
                    <div class="flex flex-col p-2 text-center bg-surface-container-lowest rounded-lg shadow-sm">
                        <span class="font-label-sm text-label-sm text-outline uppercase font-semibold">Questions</span>
                        <span class="font-title-lg text-title-lg text-on-surface font-bold mt-0.5">
                            <c:out value="${dashboardData.activeQuiz != null && dashboardData.activeQuiz.totalQuestions > 0 ? dashboardData.activeQuiz.totalQuestions : 35}"/> Qs
                        </span>
                        <span class="font-label-sm text-label-sm text-on-surface-variant">Multiple Choice</span>
                    </div>
                    <div class="flex flex-col p-2 text-center bg-surface-container-lowest rounded-lg shadow-sm">
                        <span class="font-label-sm text-label-sm text-outline uppercase font-semibold">Total Score</span>
                        <span class="font-title-lg text-title-lg text-on-surface font-bold mt-0.5">
                            <c:out value="${dashboardData.activeQuiz != null ? dashboardData.activeQuiz.totalMarks : 140}"/> Pts
                        </span>
                        <span class="font-label-sm text-label-sm text-on-surface-variant">+4.00 correct</span>
                    </div>
                    <div class="flex flex-col p-2 text-center bg-surface-container-lowest rounded-lg shadow-sm">
                        <span class="font-label-sm text-label-sm text-error uppercase font-semibold">Negative</span>
                        <span class="font-title-lg text-title-lg text-error font-bold mt-0.5">
                            <c:choose>
                                <c:when test="${dashboardData.activeQuiz != null && dashboardData.activeQuiz.negativeMarking}">
                                    -<c:out value="${dashboardData.activeQuiz.negativeMarkValue}"/>
                                </c:when>
                                <c:otherwise>-1.00</c:otherwise>
                            </c:choose>
                        </span>
                        <span class="font-label-sm text-label-sm text-error/80">Per incorrect</span>
                    </div>
                </div>

                <!-- Section Headline -->
                <div class="flex items-center justify-between pt-1">
                    <h4 class="font-title-lg text-title-lg text-on-surface font-bold flex items-center gap-2">
                        <span class="material-symbols-outlined text-primary text-[20px]">gavel</span>
                        <span>Examination Rules &amp; Telemetry Guidelines</span>
                    </h4>
                    <span class="font-label-sm text-label-sm text-on-surface-variant bg-surface-container-low px-2 py-0.5 rounded font-mono">SEC-POL v4.2</span>
                </div>

                <!-- Rule Cards List -->
                <div class="flex flex-col gap-2.5">
                    <!-- Rule 1 -->
                    <div class="p-space-sm rounded-xl bg-surface-container-lowest border border-surface-container-high hover:border-primary-fixed-dim transition-all flex items-start gap-3">
                        <div class="w-8 h-8 rounded-lg bg-surface-container-low text-primary flex items-center justify-center shrink-0 mt-0.5">
                            <span class="material-symbols-outlined text-[18px]">fullscreen</span>
                        </div>
                        <div class="flex flex-col">
                            <span class="font-title-md text-title-md text-on-surface font-semibold">1. Fullscreen Lockdown &amp; Focus Trapping</span>
                            <p class="font-body-sm text-body-sm text-on-surface-variant mt-0.5">
                                The test engine locks your viewport. Pressing <kbd class="px-1.5 py-0.5 rounded bg-surface-container-low font-code-telemetry text-code-telemetry text-on-surface border border-surface-container-high font-semibold">Alt+Tab</kbd>, minimizing, or launching inspect element immediately generates an incident record in the live audit timeline.
                            </p>
                        </div>
                    </div>
                    <!-- Rule 2 -->
                    <div class="p-space-sm rounded-xl bg-surface-container-lowest border border-surface-container-high hover:border-primary-fixed-dim transition-all flex items-start gap-3">
                        <div class="w-8 h-8 rounded-lg bg-error-container/60 text-error flex items-center justify-center shrink-0 mt-0.5">
                            <span class="material-symbols-outlined text-[18px]">warning</span>
                        </div>
                        <div class="flex flex-col">
                            <span class="font-title-md text-title-md text-on-surface font-semibold">2. Blur Event Threshold (3 Strikes Escalation)</span>
                            <p class="font-body-sm text-body-sm text-on-surface-variant mt-0.5">
                                Losing browser window focus more than <strong>3 times</strong> immediately escalates to Prof. Vance's console with an alert ping and locks answering privileges until proctor unlock.
                            </p>
                        </div>
                    </div>
                    <!-- Rule 3 -->
                    <div class="p-space-sm rounded-xl bg-surface-container-lowest border border-surface-container-high hover:border-primary-fixed-dim transition-all flex items-start gap-3">
                        <div class="w-8 h-8 rounded-lg bg-surface-container-low text-tertiary flex items-center justify-center shrink-0 mt-0.5">
                            <span class="material-symbols-outlined text-[18px]">cloud_sync</span>
                        </div>
                        <div class="flex flex-col">
                            <span class="font-title-md text-title-md text-on-surface font-semibold">3. Real-Time Encrypted Cloud Autosave</span>
                            <p class="font-body-sm text-body-sm text-on-surface-variant mt-0.5">
                                Every selection is encrypted via SHA-256 and committed instantly to PostgreSQL. If your connection flickers, local cache retains your state until handshake re-sync occurs.
                            </p>
                        </div>
                    </div>
                    <!-- Rule 4 -->
                    <div class="p-space-sm rounded-xl bg-surface-container-lowest border border-surface-container-high hover:border-primary-fixed-dim transition-all flex items-start gap-3">
                        <div class="w-8 h-8 rounded-lg bg-surface-container-low text-on-surface-variant flex items-center justify-center shrink-0 mt-0.5">
                            <span class="material-symbols-outlined text-[18px]">devices_off</span>
                        </div>
                        <div class="flex flex-col">
                            <span class="font-title-md text-title-md text-on-surface font-semibold">4. Allowed Utilities &amp; Peripheral Policies</span>
                            <p class="font-body-sm text-body-sm text-on-surface-variant mt-0.5">
                                An embedded scientific calculator and scratchpad are provided in the test drawer. External monitors, secondary displays, headphones, and Bluetooth audio devices are prohibited.
                            </p>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Right Column (5 cols): Live System Check & Readiness Telemetry -->
            <div class="lg:col-span-5 flex flex-col gap-space-md">
                <div class="bg-surface-container-low p-space-md rounded-xl border border-surface-container flex flex-col gap-space-sm">
                    <div class="flex items-center justify-between pb-1 border-b border-surface-container-high">
                        <div class="flex items-center gap-2">
                            <span class="w-2.5 h-2.5 rounded-full bg-tertiary-container animate-pulse"></span>
                            <span class="font-title-md text-title-md font-bold text-on-surface">Hardware &amp; Pre-Flight Check</span>
                        </div>
                        <span class="font-code-telemetry text-code-telemetry text-tertiary font-semibold" id="hardware-check-badge">4/4 VERIFIED</span>
                    </div>

                    <!-- Diagnostic Items List -->
                    <div class="flex flex-col gap-2 pt-1">
                        <!-- Item 1: Camera Feed -->
                        <div class="p-2.5 bg-surface-container-lowest rounded-lg flex items-center justify-between shadow-xs">
                            <div class="flex items-center gap-3">
                                <div class="w-7 h-7 rounded-md bg-tertiary-fixed/40 text-tertiary flex items-center justify-center">
                                    <span class="material-symbols-outlined text-[18px]">videocam</span>
                                </div>
                                <div class="flex flex-col">
                                    <span class="font-body-md text-body-md font-semibold text-on-surface">Facial Biometrics Feed</span>
                                    <span class="font-label-sm text-label-sm text-on-surface-variant">Face tracked • 1080p WebCam</span>
                                </div>
                            </div>
                            <div class="flex items-center gap-1.5 text-tertiary font-label-sm text-label-sm font-semibold">
                                <span class="material-symbols-outlined text-[16px]">check_circle</span>
                                <span>Active</span>
                            </div>
                        </div>

                        <!-- Item 2: Microphone -->
                        <div class="p-2.5 bg-surface-container-lowest rounded-lg flex items-center justify-between shadow-xs">
                            <div class="flex items-center gap-3">
                                <div class="w-7 h-7 rounded-md bg-tertiary-fixed/40 text-tertiary flex items-center justify-center">
                                    <span class="material-symbols-outlined text-[18px]">mic</span>
                                </div>
                                <div class="flex flex-col">
                                    <span class="font-body-md text-body-md font-semibold text-on-surface">Audio Decibel Ambient</span>
                                    <span class="font-label-sm text-label-sm text-on-surface-variant">Noise floor: 22 dB (Quiet room)</span>
                                </div>
                            </div>
                            <div class="flex items-center gap-1.5 text-tertiary font-label-sm text-label-sm font-semibold">
                                <span class="material-symbols-outlined text-[16px]">check_circle</span>
                                <span>Optimal</span>
                            </div>
                        </div>

                        <!-- Item 3: Network Ping -->
                        <div class="p-2.5 bg-surface-container-lowest rounded-lg flex items-center justify-between shadow-xs">
                            <div class="flex items-center gap-3">
                                <div class="w-7 h-7 rounded-md bg-tertiary-fixed/40 text-tertiary flex items-center justify-center">
                                    <span class="material-symbols-outlined text-[18px]">wifi</span>
                                </div>
                                <div class="flex flex-col">
                                    <span class="font-body-md text-body-md font-semibold text-on-surface">Exam Node Latency</span>
                                    <span class="font-label-sm text-label-sm text-on-surface-variant">24ms • 0% Packet Loss</span>
                                </div>
                            </div>
                            <div class="flex items-center gap-1.5 text-tertiary font-label-sm text-label-sm font-semibold">
                                <span class="material-symbols-outlined text-[16px]">check_circle</span>
                                <span>Connected</span>
                            </div>
                        </div>

                        <!-- Item 4: Screen Sharing / Display Sandbox -->
                        <div class="p-2.5 bg-surface-container-lowest rounded-lg flex items-center justify-between shadow-xs">
                            <div class="flex items-center gap-3">
                                <div class="w-7 h-7 rounded-md bg-tertiary-fixed/40 text-tertiary flex items-center justify-center">
                                    <span class="material-symbols-outlined text-[18px]">desktop_windows</span>
                                </div>
                                <div class="flex flex-col">
                                    <span class="font-body-md text-body-md font-semibold text-on-surface">Display Integrity</span>
                                    <span class="font-label-sm text-label-sm text-on-surface-variant">1 Display (1920x1080) Detected</span>
                                </div>
                            </div>
                            <div class="flex items-center gap-1.5 text-tertiary font-label-sm text-label-sm font-semibold">
                                <span class="material-symbols-outlined text-[16px]">check_circle</span>
                                <span>Locked</span>
                            </div>
                        </div>
                    </div>

                    <!-- Mini Live Camera Preview Box -->
                    <div class="relative w-full h-24 rounded-lg bg-inverse-surface overflow-hidden flex items-center justify-center mt-1">
                        <div class="absolute inset-0 opacity-20 bg-[radial-gradient(#4f46e5_1px,transparent_1px)] [background-size:12px_12px]"></div>
                        <!-- Subtle camera simulation HUD -->
                        <div class="absolute inset-2 border border-tertiary/40 rounded flex flex-col justify-between p-1.5 pointer-events-none">
                            <div class="flex items-center justify-between">
                                <span class="font-code-telemetry text-[10px] text-tertiary-fixed font-bold tracking-widest flex items-center gap-1">
                                    <span class="w-1.5 h-1.5 rounded-full bg-tertiary-fixed animate-ping"></span>
                                    REC • CAM_01
                                </span>
                                <span class="font-code-telemetry text-[10px] text-inverse-on-surface/80">30 FPS • 1080P</span>
                            </div>
                            <div class="flex items-center justify-between text-[10px] font-code-telemetry text-tertiary-fixed">
                                <span>CONFIDENCE: 99.4%</span>
                                <span>FACE CENTERED</span>
                            </div>
                        </div>
                        <div class="flex flex-col items-center justify-center text-center z-10">
                            <span class="material-symbols-outlined text-inverse-on-surface/70 text-[24px]">face</span>
                            <span class="font-label-sm text-label-sm text-inverse-on-surface/90 font-medium">
                                <c:out value="${sessionScope.userFullName != null ? sessionScope.userFullName : 'Alex Mercer'}"/> 
                                (<c:out value="${sessionScope.userIdentifier != null ? sessionScope.userIdentifier : 'CS-2022-041'}"/>)
                            </span>
                        </div>
                    </div>
                </div>

                <!-- Academic Honor Code & Acknowledgments -->
                <div class="flex flex-col gap-2.5 pt-1">
                    <span class="font-label-sm text-label-sm font-semibold uppercase text-outline tracking-wider">Honor Pledge &amp; Consent</span>
                    <label class="flex items-start gap-2.5 cursor-pointer select-none group">
                        <input type="checkbox" id="pledge-check-1" checked class="mt-1 h-4 w-4 rounded text-primary focus:ring-primary border-outline-variant accent-primary cursor-pointer"/>
                        <span class="font-body-sm text-body-sm text-on-surface leading-snug group-hover:text-primary transition-colors">
                            I confirm that I am <c:out value="${sessionScope.userFullName != null ? sessionScope.userFullName : 'Alex Mercer'}"/> (<c:out value="${sessionScope.userIdentifier != null ? sessionScope.userIdentifier : 'CS-2022-041'}"/>) and I will complete this examination independently without unauthorized aids or secondary devices.
                        </span>
                    </label>
                    <label class="flex items-start gap-2.5 cursor-pointer select-none group">
                        <input type="checkbox" id="pledge-check-2" checked class="mt-1 h-4 w-4 rounded text-primary focus:ring-primary border-outline-variant accent-primary cursor-pointer"/>
                        <span class="font-body-sm text-body-sm text-on-surface leading-snug group-hover:text-primary transition-colors">
                            I understand that telemetry events (window focus loss, shortcuts, camera tracking) are logged to the proctor audit stream.
                        </span>
                    </label>
                </div>
            </div>
        </div>

        <!-- Modal Footer Controls -->
        <form id="preflight-start-form" method="POST" action="${pageContext.request.contextPath}/student/exam/start" class="m-0 p-0">
            <input type="hidden" name="quizId" id="modal-quiz-id" value="1"/>
            <div class="px-4 sm:px-space-lg py-4 bg-surface-container-low border-t border-surface-container-high flex flex-col sm:flex-row items-center justify-between gap-4 shrink-0">
                <div class="flex items-center gap-2 text-on-surface-variant font-label-sm text-label-sm">
                    <span class="material-symbols-outlined text-tertiary text-[18px]">verified_user</span>
                    <span>By clicking Begin, your browser will request Fullscreen permission and initialize encrypted session.</span>
                </div>
                <div class="flex items-center gap-3 w-full sm:w-auto justify-end">
                    <button type="button" class="px-space-md py-2.5 rounded-lg bg-surface-container-lowest text-on-surface border border-surface-container-high hover:bg-surface-container font-title-md text-title-md font-semibold transition-all" onclick="closePreflightModal()">
                        Return to Dashboard
                    </button>
                    <button type="button" class="px-space-lg py-2.5 rounded-lg bg-primary-container hover:bg-primary text-on-primary font-title-md text-title-md font-semibold shadow-md flex items-center justify-center gap-2 transition-all group" id="begin-exam-btn" onclick="simulateLaunch()">
                        <span class="material-symbols-outlined text-[20px] transition-transform group-hover:scale-110">lock_open</span>
                        <span>Enter Fullscreen &amp; Begin Exam</span>
                        <span class="material-symbols-outlined text-[18px] transition-transform group-hover:translate-x-1">arrow_forward</span>
                    </button>
                </div>
            </div>
        </form>
    </div>
</div>

<script>
    function openPreflightModal(quizId, quizCode, quizTitle, totalMarks, duration, questions) {
        const modal = document.getElementById('preflight-modal-overlay');
        if (modal) {
            modal.classList.remove('hidden');
        }
        if (quizId) {
            const input = document.getElementById('modal-quiz-id');
            if (input) input.value = quizId;
        }
    }

    function closePreflightModal() {
        const modal = document.getElementById('preflight-modal-overlay');
        if (modal) {
            modal.classList.add('hidden');
        }
    }

    function simulateLaunch() {
        const check1 = document.getElementById('pledge-check-1');
        const check2 = document.getElementById('pledge-check-2');
        if (check1 && !check1.checked || check2 && !check2.checked) {
            alert("Please acknowledge and accept the Honor Pledge checkboxes before entering the examination chamber.");
            return;
        }

        const btn = document.getElementById('begin-exam-btn');
        if (!btn) return;
        btn.innerHTML = `
            <span class="material-symbols-outlined text-[20px] animate-spin">progress_activity</span>
            <span>Allocating Secure Sandbox...</span>
        `;
        btn.classList.add('opacity-80', 'pointer-events-none');
        
        setTimeout(() => {
            const form = document.getElementById('preflight-start-form');
            if (form) {
                form.submit();
            }
        }, 600);
    }
</script>
