<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Student Roster &amp; Cohort Directory | QuizTrack</title>
    <link rel="preconnect" href="https://fonts.googleapis.com"/>
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin/>
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
    <!-- Faculty Navigation Sidebar -->
    <jsp:include page="components/sidebar.jsp"/>

    <div class="lg:pl-64">
        <!-- Faculty Header -->
        <jsp:include page="components/header.jsp"/>

        <main class="w-full pt-16 min-h-screen px-4 sm:px-8 py-8">
            <div class="max-w-7xl mx-auto flex flex-col gap-6">

                <!-- Title Banner Strip -->
                <div class="flex flex-col sm:flex-row sm:items-center justify-between gap-4 bg-surface-container-lowest p-6 rounded-2xl shadow-sm border border-surface-container-high">
                    <div>
                        <div class="flex items-center gap-2 text-xs font-mono font-semibold text-primary uppercase">
                            <span>Academic Management</span>
                            <span>•</span>
                            <span>Student Directory</span>
                        </div>
                        <h1 class="text-2xl sm:text-3xl font-display font-bold text-on-surface mt-1">Student Roster &amp; Cohorts</h1>
                        <p class="text-sm text-on-surface-variant mt-1">
                            Enrolled candidates and academic cohorts under <span class="font-semibold text-on-surface"><c:out value="${department}"/></span>.
                        </p>
                    </div>
                    <div class="flex items-center gap-3">
                        <span class="px-4 py-2 rounded-xl bg-primary-container/10 border border-primary/20 text-primary font-mono font-bold text-sm">
                            <c:out value="${totalStudents}"/> Enrolled Students
                        </span>
                    </div>
                </div>

                <!-- Cohorts Grid -->
                <div>
                    <h2 class="text-lg font-display font-bold text-on-surface mb-3 flex items-center gap-2">
                        <span class="material-symbols-outlined text-primary text-[20px]">groups</span>
                        <span>Academic Cohorts</span>
                    </h2>
                    <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-4">
                        <c:forEach var="c" items="${cohorts}">
                            <div class="bg-surface-container-lowest p-5 rounded-2xl border border-surface-container-high shadow-xs flex flex-col justify-between">
                                <div>
                                    <div class="flex items-center justify-between mb-2">
                                        <span class="px-2.5 py-1 rounded-md bg-primary-container text-on-primary font-mono text-xs font-bold">
                                            <c:out value="${c.cohortName}"/>
                                        </span>
                                        <span class="text-xs font-mono text-on-surface-variant">Class of <c:out value="${c.academicYear}"/></span>
                                    </div>
                                    <h3 class="font-display font-bold text-base text-on-surface"><c:out value="${c.cohortName}"/></h3>
                                    <p class="text-xs text-on-surface-variant mt-1 flex items-center gap-1">
                                        <span class="material-symbols-outlined text-[14px]">domain</span>
                                        <span><c:out value="${c.department}"/></span>
                                    </p>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </div>

                <!-- Students Roster Table -->
                <div class="bg-surface-container-lowest rounded-2xl shadow-sm border border-surface-container-high overflow-hidden">
                    <div class="p-5 border-b border-surface-container-high flex items-center justify-between">
                        <h2 class="text-lg font-display font-bold text-on-surface flex items-center gap-2">
                            <span class="material-symbols-outlined text-primary text-[20px]">badge</span>
                            <span>Student Directory Roster</span>
                        </h2>
                    </div>

                    <div class="overflow-x-auto">
                        <table class="w-full text-left text-sm border-collapse">
                            <thead>
                                <tr class="bg-surface-container-low/60 text-xs font-mono font-bold uppercase text-on-surface-variant border-b border-surface-container-high">
                                    <th class="py-3 px-4">Student ID / Roll No</th>
                                    <th class="py-3 px-4">Full Legal Name</th>
                                    <th class="py-3 px-4">Institutional Email</th>
                                    <th class="py-3 px-4">Department</th>
                                    <th class="py-3 px-4 text-center">Account Status</th>
                                </tr>
                            </thead>
                            <tbody class="divide-y divide-surface-container-high/60 text-on-surface">
                                <c:forEach var="st" items="${students}">
                                    <tr class="hover:bg-surface-container-low/30 transition-colors">
                                        <td class="py-3 px-4 font-mono font-bold text-xs text-primary">
                                            <c:out value="${st.identifier}"/>
                                        </td>
                                        <td class="py-3 px-4 font-semibold">
                                            <c:out value="${st.fullName}"/>
                                        </td>
                                        <td class="py-3 px-4 font-mono text-xs text-on-surface-variant">
                                            <c:out value="${st.email}"/>
                                        </td>
                                        <td class="py-3 px-4 text-xs text-on-surface-variant">
                                            <c:out value="${st.department}"/>
                                        </td>
                                        <td class="py-3 px-4 text-center">
                                            <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-semibold bg-emerald-50 text-emerald-700 border border-emerald-200">
                                                Active Candidate
                                            </span>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>

            </div>
        </main>
    </div>
</body>
</html>
