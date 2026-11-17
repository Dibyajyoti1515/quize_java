<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8"/>
  <meta content="width=device-width, initial-scale=1.0" name="viewport"/>
  <title>QuizTrack Unified Authentication & Role Gateway</title>
  <link href="https://fonts.googleapis.com" rel="preconnect"/>
  <link crossorigin="" href="https://fonts.gstatic.com" rel="preconnect"/>
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=JetBrains+Mono:wght@400;500&family=Plus+Jakarta+Sans:wght@600;700&display=swap" rel="stylesheet"/>
  <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200" rel="stylesheet"/>
  <style>
    @layer base {
      html, body { margin: 0; padding: 0; }
      body { overscroll-behavior: none; }
      main > :first-child { margin-top: 0 !important; }
      main > :last-child { margin-bottom: 0 !important; }
    }
    ::-webkit-scrollbar { display: none; }
  </style>
  <script src="https://cdn.tailwindcss.com"></script>
  <script id="tailwind-config">
    tailwind.config = {
      "darkMode": "class",
      "theme": {
        "extend": {
          "colors": {
            "on-secondary-fixed-variant": "#2f2ebe",
            "inverse-on-surface": "#eaf1ff",
            "surface-container-low": "#eff4ff",
            "secondary-container": "#6063ee",
            "error": "#ba1a1a",
            "on-tertiary": "#ffffff",
            "outline-variant": "#c7c4d8",
            "surface-dim": "#cbdbf5",
            "on-tertiary-fixed-variant": "#005236",
            "primary-container": "#4f46e5",
            "on-secondary-container": "#fffbff",
            "primary-fixed-dim": "#c3c0ff",
            "error-container": "#ffdad6",
            "on-secondary-fixed": "#07006c",
            "primary": "#3525cd",
            "surface-tint": "#4d44e3",
            "on-background": "#0b1c30",
            "tertiary-fixed-dim": "#4edea3",
            "inverse-primary": "#c3c0ff",
            "surface-variant": "#d3e4fe",
            "on-error-container": "#93000a",
            "on-tertiary-container": "#67f4b7",
            "secondary-fixed": "#e1e0ff",
            "surface-bright": "#f8f9ff",
            "on-primary-fixed-variant": "#3323cc",
            "on-primary-container": "#dad7ff",
            "on-error": "#ffffff",
            "surface-container-high": "#dce9ff",
            "on-primary": "#ffffff",
            "surface": "#f8f9ff",
            "on-primary-fixed": "#0f0069",
            "tertiary-container": "#006e4b",
            "surface-container": "#e5eeff",
            "secondary": "#4648d4",
            "primary-fixed": "#e2dfff",
            "tertiary-fixed": "#6ffbbe",
            "on-surface-variant": "#464555",
            "on-secondary": "#ffffff",
            "tertiary": "#005338",
            "secondary-fixed-dim": "#c0c1ff",
            "surface-container-lowest": "#ffffff",
            "surface-container-highest": "#d3e4fe",
            "outline": "#777587",
            "on-tertiary-fixed": "#002113",
            "inverse-surface": "#213145",
            "on-surface": "#0b1c30",
            "background": "#f8f9ff"
          },
          "borderRadius": {
            "DEFAULT": "0.25rem",
            "lg": "0.5rem",
            "xl": "0.75rem",
            "2xl": "1rem",
            "full": "9999px"
          },
          "fontFamily": {
            "label-md": ["Inter", "sans-serif"],
            "body-md": ["Inter", "sans-serif"],
            "body-sm": ["Inter", "sans-serif"],
            "label-sm": ["Inter", "sans-serif"],
            "display": ["Plus Jakarta Sans", "sans-serif"],
            "title-lg": ["Plus Jakarta Sans", "sans-serif"],
            "body-lg": ["Inter", "sans-serif"],
            "headline-lg": ["Plus Jakarta Sans", "sans-serif"],
            "title-md": ["Inter", "sans-serif"],
            "headline-sm": ["Plus Jakarta Sans", "sans-serif"],
            "headline-md": ["Plus Jakarta Sans", "sans-serif"],
            "code-telemetry": ["JetBrains Mono", "monospace"]
          }
        }
      }
    };
  </script>
</head>
<body class="bg-background font-body-md text-on-surface min-h-screen flex items-center justify-center">
<main class="w-full">
<div class="flex flex-col w-full">
  <div class="w-full min-h-screen bg-surface flex flex-col justify-between p-4 md:p-8 lg:p-12 relative overflow-hidden">
    <!-- Background Gradients -->
    <div class="absolute -top-32 -left-32 w-96 h-96 bg-primary-container/10 rounded-full blur-3xl pointer-events-none"></div>
    <div class="absolute top-1/2 -right-48 w-[32rem] h-[32rem] bg-secondary-container/10 rounded-full blur-3xl pointer-events-none"></div>

    <!-- Top Global Header / Brand & Telemetry HUD -->
    <header class="w-full max-w-7xl mx-auto flex items-center justify-between z-10 py-2">
      <div class="flex items-center gap-3">
        <div class="w-10 h-10 rounded-xl bg-primary-container flex items-center justify-center shadow-sm">
          <span class="material-symbols-outlined text-on-primary text-[24px]">verified_user</span>
        </div>
        <div>
          <span class="font-display font-bold text-headline-sm text-on-surface tracking-tight">QuizTrack</span>
          <span class="hidden sm:inline-block ml-2 px-2 py-0.5 rounded text-[11px] font-code-telemetry bg-surface-container text-on-surface-variant font-semibold">ENTERPRISE SECURE GATEWAY</span>
        </div>
      </div>

      <!-- Real-Time Telemetry Indicator Strip -->
      <div class="flex items-center gap-3 px-3.5 py-1.5 rounded-full bg-surface-container-lowest border border-surface-container-low shadow-sm">
        <div class="flex items-center gap-2">
          <span class="w-2.5 h-2.5 rounded-full bg-emerald-500 animate-pulse"></span>
          <span class="font-code-telemetry text-[12px] text-emerald-700 font-bold">PROCTOR_NET: ACTIVE</span>
        </div>
        <span class="text-outline-variant font-code-telemetry text-xs">•</span>
        <span class="font-code-telemetry text-[12px] text-on-surface-variant">LATENCY: 14ms</span>
        <span class="text-outline-variant font-code-telemetry text-xs">•</span>
        <span class="font-label-sm text-label-sm text-on-surface-variant flex items-center gap-1">
          <span class="material-symbols-outlined text-[14px]">lock</span> 256-BIT SSL
        </span>
      </div>
    </header>

    <!-- Main Workspace Split Grid -->
    <div class="w-full max-w-7xl mx-auto grid grid-cols-1 lg:grid-cols-12 gap-8 my-auto items-stretch z-10 py-6">
      <!-- Left Column: Context, Integrity Preview & One-Click Role Launchers -->
      <div class="lg:col-span-5 flex flex-col justify-between gap-6">
        <!-- Live Proctoring HUD Feature Card -->
        <div class="bg-surface-container-lowest rounded-2xl p-6 shadow-sm border border-surface-container-high flex flex-col gap-5">
          <div class="flex items-center justify-between">
            <span class="font-label-sm text-label-sm uppercase tracking-wider text-primary font-bold">Active Proctored Chamber</span>
            <span class="flex items-center gap-1.5 px-2.5 py-1 rounded-full bg-surface-container-high text-on-surface-variant font-label-sm text-label-sm">
              <span class="w-2 h-2 rounded-full bg-error"></span> REC STREAM
            </span>
          </div>

          <!-- Video Stream Simulation Thumbnail -->
          <div class="relative w-full h-44 rounded-xl overflow-hidden bg-inverse-surface shadow-inner flex items-center justify-center">
            <div class="absolute inset-0 bg-slate-900 flex items-center justify-center">
              <span class="material-symbols-outlined text-slate-700 text-6xl">laptop_chromebook</span>
            </div>
            <!-- Video Overlay HUD Elements -->
            <div class="absolute inset-0 bg-gradient-to-t from-inverse-surface/90 via-transparent to-inverse-surface/40 flex flex-col justify-between p-3">
              <div class="flex justify-between items-start">
                <span class="bg-inverse-surface/80 backdrop-blur-md px-2 py-0.5 rounded text-inverse-on-surface font-code-telemetry text-label-sm flex items-center gap-1">
                  <span class="material-symbols-outlined text-[12px] text-emerald-400">center_focus_strong</span>
                  AI BIOMETRIC: 99.4%
                </span>
                <span class="bg-surface-container-lowest/20 backdrop-blur-md px-2 py-0.5 rounded text-inverse-on-surface font-code-telemetry text-label-sm">
                  AUDIO: -42 dB
                </span>
              </div>
              <div class="flex items-end justify-between">
                <div>
                  <p class="font-title-md text-title-md text-inverse-on-surface">CS402: Distributed Systems Midterm</p>
                  <p class="font-code-telemetry text-label-sm text-surface-dim">SESSION ID #QT-9921-US</p>
                </div>
                <span class="material-symbols-outlined text-inverse-on-surface text-[20px]">videocam</span>
              </div>
            </div>
          </div>

          <!-- Regulatory & Compliance Pillars -->
          <div class="grid grid-cols-2 gap-3 pt-1">
            <div class="bg-surface-container-low p-3 rounded-xl flex items-center gap-3">
              <div class="w-8 h-8 rounded-lg bg-surface-container-high text-primary flex items-center justify-center shrink-0">
                <span class="material-symbols-outlined text-[18px]">verified</span>
              </div>
              <div>
                <p class="font-label-md text-label-md text-on-surface font-semibold">FERPA & GDPR</p>
                <p class="font-body-sm text-[11px] text-on-surface-variant">Strict Privacy Compliant</p>
              </div>
            </div>
            <div class="bg-surface-container-low p-3 rounded-xl flex items-center gap-3">
              <div class="w-8 h-8 rounded-lg bg-surface-container-high text-primary flex items-center justify-center shrink-0">
                <span class="material-symbols-outlined text-[18px]">security</span>
              </div>
              <div>
                <p class="font-label-md text-label-md text-on-surface font-semibold">Anti-Tamper Lock</p>
                <p class="font-body-sm text-[11px] text-on-surface-variant">Dual-Display Lockdown</p>
              </div>
            </div>
          </div>
        </div>

        <!-- Quick Demo / One-Click Fast Launchers Card -->
        <div class="bg-surface-container-lowest rounded-2xl p-6 shadow-sm border border-surface-container-high flex flex-col gap-4">
          <div class="flex items-center justify-between">
            <div class="flex items-center gap-2">
              <span class="material-symbols-outlined text-primary text-[20px]">bolt</span>
              <h2 class="font-title-md text-title-md text-on-surface font-bold">Instant Sandbox Access</h2>
            </div>
            <span class="font-code-telemetry text-[11px] text-on-surface-variant uppercase font-semibold">Verified Sandbox Seeds</span>
          </div>
          <p class="font-body-sm text-body-sm text-on-surface-variant">
            Explore proctoring and assessment features using pre-authenticated institutional accounts:
          </p>
          <div class="flex flex-col gap-2.5">
            <!-- Launch Teacher -->
            <a href="${pageContext.request.contextPath}/auth/demo?role=teacher" class="w-full group text-left p-3.5 rounded-xl bg-surface-container-low hover:bg-surface-container transition-all flex items-center justify-between border border-transparent hover:border-amber-200">
              <div class="flex items-center gap-3">
                <div class="w-9 h-9 rounded-lg bg-amber-100 text-amber-800 flex items-center justify-center font-bold">
                  <span class="material-symbols-outlined text-[20px]">psychology</span>
                </div>
                <div>
                  <div class="flex items-center gap-2">
                    <span class="font-label-md text-label-md text-on-surface font-semibold">Prof. Ronald Vance</span>
                    <span class="px-2 py-0.5 rounded text-[10px] font-mono bg-amber-200/60 text-amber-900 font-bold uppercase">Faculty</span>
                  </div>
                  <p class="font-body-sm text-[11px] text-on-surface-variant">Chief Proctor • CS402 Distributed Systems Command Matrix</p>
                </div>
              </div>
              <span class="material-symbols-outlined text-primary group-hover:translate-x-1 transition-transform">arrow_forward</span>
            </a>

            <!-- Launch Student -->
            <a href="${pageContext.request.contextPath}/auth/demo?role=student" class="w-full group text-left p-3.5 rounded-xl bg-surface-container-low hover:bg-surface-container transition-all flex items-center justify-between border border-transparent hover:border-indigo-200">
              <div class="flex items-center gap-3">
                <div class="w-9 h-9 rounded-lg bg-indigo-100 text-indigo-800 flex items-center justify-center font-bold">
                  <span class="material-symbols-outlined text-[20px]">school</span>
                </div>
                <div>
                  <div class="flex items-center gap-2">
                    <span class="font-label-md text-label-md text-on-surface font-semibold">Alex Mercer</span>
                    <span class="px-2 py-0.5 rounded text-[10px] font-mono bg-indigo-200/60 text-indigo-900 font-bold uppercase">Candidate</span>
                  </div>
                  <p class="font-body-sm text-[11px] text-on-surface-variant">Roll ID: CS-2022-041 • Rank #3 Cohort Honor Standing</p>
                </div>
              </div>
              <span class="material-symbols-outlined text-primary group-hover:translate-x-1 transition-transform">arrow_forward</span>
            </a>

            <!-- Launch Admin -->
            <a href="${pageContext.request.contextPath}/auth/demo?role=admin" class="w-full group text-left p-3 rounded-xl bg-surface-container-low hover:bg-surface-container transition-all flex items-center justify-between border border-transparent hover:border-purple-200">
              <div class="flex items-center gap-3">
                <div class="w-8 h-8 rounded-lg bg-purple-100 text-purple-800 flex items-center justify-center font-bold">
                  <span class="material-symbols-outlined text-[18px]">admin_panel_settings</span>
                </div>
                <div>
                  <span class="font-label-md text-label-md text-on-surface font-semibold">System Administrator</span>
                  <p class="font-body-sm text-[11px] text-on-surface-variant">Full Institutional Account & Audit Access</p>
                </div>
              </div>
              <span class="material-symbols-outlined text-primary group-hover:translate-x-1 transition-transform text-sm">arrow_forward</span>
            </a>
          </div>
        </div>
      </div>

      <!-- Right Column: Interactive Role-Adaptive Authentication Card -->
      <div class="lg:col-span-7 flex flex-col justify-center">
        <div class="bg-surface-container-lowest rounded-2xl p-6 sm:p-10 shadow-lg border border-surface-container-high relative">
          
          <!-- Server Flash Alerts -->
          <c:if test="${not empty errorMessage}">
            <div class="mb-5 p-3.5 rounded-xl bg-error-container text-on-error-container text-sm flex items-center gap-3 border border-red-300">
              <span class="material-symbols-outlined text-error text-[20px]">error</span>
              <span class="font-medium"><c:out value="${errorMessage}"/></span>
            </div>
          </c:if>

          <c:if test="${not empty registerError}">
            <div class="mb-5 p-3.5 rounded-xl bg-error-container text-on-error-container text-sm flex items-center gap-3 border border-red-300">
              <span class="material-symbols-outlined text-error text-[20px]">error</span>
              <span class="font-medium"><c:out value="${registerError}"/></span>
            </div>
          </c:if>

          <c:if test="${not empty successMessage}">
            <div class="mb-5 p-3.5 rounded-xl bg-emerald-50 text-emerald-800 text-sm flex items-center gap-3 border border-emerald-300">
              <span class="material-symbols-outlined text-emerald-600 text-[20px]">check_circle</span>
              <span class="font-medium"><c:out value="${successMessage}"/></span>
            </div>
          </c:if>

          <c:if test="${not empty warningMessage}">
            <div class="mb-5 p-3.5 rounded-xl bg-amber-50 text-amber-800 text-sm flex items-center gap-3 border border-amber-300">
              <span class="material-symbols-outlined text-amber-600 text-[20px]">warning</span>
              <span class="font-medium"><c:out value="${warningMessage}"/></span>
            </div>
          </c:if>

          <c:if test="${not empty infoMessage}">
            <div class="mb-5 p-3.5 rounded-xl bg-blue-50 text-blue-800 text-sm flex items-center gap-3 border border-blue-300">
              <span class="material-symbols-outlined text-blue-600 text-[20px]">info</span>
              <span class="font-medium"><c:out value="${infoMessage}"/></span>
            </div>
          </c:if>

          <!-- Top Role Selector Toggle Strip -->
          <div class="flex flex-col gap-2 mb-6">
            <span class="font-label-sm text-label-sm uppercase tracking-wider text-on-surface-variant font-bold">1. Select Target Role Context</span>
            <div class="flex p-1 rounded-xl bg-surface-container-low border border-surface-container-high">
              <button id="role-btn-student" type="button" onclick="setRole('student')" 
                class="flex-1 py-2.5 px-4 rounded-lg font-label-md text-label-md flex items-center justify-center gap-2 transition-all bg-surface-container-lowest text-primary shadow-sm font-bold">
                <span class="material-symbols-outlined text-[18px]">school</span>
                Candidate (Student)
              </button>
              <button id="role-btn-teacher" type="button" onclick="setRole('teacher')"
                class="flex-1 py-2.5 px-4 rounded-lg font-label-md text-label-md flex items-center justify-center gap-2 transition-all text-on-surface-variant hover:text-on-surface font-bold">
                <span class="material-symbols-outlined text-[18px]">psychology</span>
                Faculty / Proctor
              </button>
              <button id="role-btn-admin" type="button" onclick="setRole('admin')"
                class="flex-1 py-2.5 px-4 rounded-lg font-label-md text-label-md flex items-center justify-center gap-2 transition-all text-on-surface-variant hover:text-on-surface font-bold">
                <span class="material-symbols-outlined text-[18px]">shield_person</span>
                Administrator
              </button>
            </div>
          </div>

          <!-- Authentication Tab Switcher (Sign In vs Register) -->
          <div class="flex items-center justify-between border-b border-surface-container pb-4 mb-6">
            <div class="flex gap-6">
              <button id="tab-btn-signin" type="button" onclick="setAuthTab('signin')"
                class="font-headline-sm text-headline-sm text-primary transition-colors pb-1 relative font-bold">
                Sign In
                <span id="tab-indicator-signin" class="absolute bottom-0 left-0 right-0 h-0.5 bg-primary rounded-full"></span>
              </button>
              <button id="tab-btn-register" type="button" onclick="setAuthTab('register')"
                class="font-headline-sm text-headline-sm text-on-surface-variant hover:text-on-surface transition-colors pb-1 relative font-bold">
                Register
                <span id="tab-indicator-register" class="absolute bottom-0 left-0 right-0 h-0.5 bg-primary rounded-full hidden"></span>
              </button>
            </div>
            <span id="role-context-badge" class="font-code-telemetry text-xs px-2.5 py-1 rounded-full bg-surface-container text-primary font-bold">
              Candidate Mode
            </span>
          </div>

          <!-- SIGN IN FORM -->
          <form id="signin-form" method="POST" action="${pageContext.request.contextPath}/auth/login" class="flex flex-col gap-4">
            <input type="hidden" name="role" id="auth-role-input" value="${not empty selectedRole ? selectedRole : 'student'}"/>

            <!-- Identifier Field -->
            <div class="flex flex-col gap-1.5">
              <label id="identifier-label" class="font-label-md text-label-md text-on-surface font-semibold" for="user-identifier">
                Institutional Email or Student Roll No
              </label>
              <div class="relative">
                <div class="absolute inset-y-0 left-0 pl-3.5 flex items-center pointer-events-none text-on-surface-variant">
                  <span id="identifier-icon" class="material-symbols-outlined text-[20px]">school</span>
                </div>
                <input class="w-full pl-11 pr-4 py-3 bg-surface-container-low text-on-surface placeholder:text-on-surface-variant/60 rounded-xl font-body-md text-body-md focus:bg-surface-container-lowest focus:outline-none focus:ring-2 focus:ring-primary-container transition-all border border-transparent focus:border-indigo-400" 
                  id="user-identifier" name="identifier" value="<c:out value="${typedIdentifier}"/>" placeholder="e.g. CS-2022-041 or user@university.edu" required type="text"/>
              </div>
            </div>

            <!-- Password Field -->
            <div class="flex flex-col gap-1.5">
              <div class="flex justify-between items-center">
                <label class="font-label-md text-label-md text-on-surface font-semibold" for="user-password">Account Password</label>
                <button type="button" onclick="openForgotModal()" class="font-label-sm text-label-sm text-primary hover:underline font-semibold">
                  Forgot Password?
                </button>
              </div>
              <div class="relative">
                <div class="absolute inset-y-0 left-0 pl-3.5 flex items-center pointer-events-none text-on-surface-variant">
                  <span class="material-symbols-outlined text-[20px]">lock</span>
                </div>
                <input class="w-full pl-11 pr-11 py-3 bg-surface-container-low text-on-surface rounded-xl font-body-md text-body-md focus:bg-surface-container-lowest focus:outline-none focus:ring-2 focus:ring-primary-container transition-all border border-transparent focus:border-indigo-400" 
                  id="user-password" name="password" placeholder="••••••••••••" required type="password"/>
                <button type="button" onclick="togglePasswordVisibility()" class="absolute inset-y-0 right-0 pr-3.5 flex items-center text-on-surface-variant hover:text-on-surface">
                  <span id="pwd-toggle-icon" class="material-symbols-outlined text-[20px]">visibility</span>
                </button>
              </div>
            </div>

            <!-- Biometric & Integrity Consent -->
            <div class="flex items-start gap-2.5 pt-1">
              <input class="mt-1 w-4 h-4 rounded text-primary focus:ring-primary cursor-pointer" id="biometric-consent" name="biometricConsent" type="checkbox" checked/>
              <label class="font-body-sm text-body-sm text-on-surface-variant cursor-pointer" for="biometric-consent">
                I authorize secure proctoring telemetry (tab switch monitoring, hardware readiness check, and full-screen sandbox lockdown).
              </label>
            </div>

            <!-- Submit Button -->
            <button id="submit-auth-btn" type="submit" 
              class="w-full py-3.5 px-6 rounded-xl bg-primary-container hover:bg-secondary transition-all text-on-primary font-label-md text-title-md flex items-center justify-center gap-2 shadow-md shadow-primary/25 mt-2 font-bold cursor-pointer">
              <span class="material-symbols-outlined text-[20px]">login</span>
              <span id="btn-text">Authenticate & Enter Examination Center</span>
            </button>
          </form>

          <!-- REGISTER FORM -->
          <form id="register-form" method="POST" action="${pageContext.request.contextPath}/auth/register" class="flex flex-col gap-4 hidden">
            <input type="hidden" name="role" id="reg-role-input" value="${not empty selectedRole ? selectedRole : 'student'}"/>

            <!-- Legal Name -->
            <div class="flex flex-col gap-1.5">
              <label class="font-label-md text-label-md text-on-surface font-semibold" for="reg-full-name">Full Legal Name</label>
              <div class="relative">
                <div class="absolute inset-y-0 left-0 pl-3.5 flex items-center pointer-events-none text-on-surface-variant">
                  <span class="material-symbols-outlined text-[20px]">person</span>
                </div>
                <input class="w-full pl-11 pr-4 py-3 bg-surface-container-low text-on-surface placeholder:text-on-surface-variant/60 rounded-xl font-body-md text-body-md focus:bg-surface-container-lowest focus:outline-none focus:ring-2 focus:ring-primary-container transition-all border border-transparent focus:border-indigo-400" 
                  id="reg-full-name" name="fullName" value="<c:out value="${regFullName}"/>" placeholder="e.g. Alex Mercer" required type="text"/>
              </div>
            </div>

            <!-- Identifier & Email Row -->
            <div class="grid grid-cols-1 md:grid-cols-2 gap-3">
              <div class="flex flex-col gap-1.5">
                <label id="reg-id-label" class="font-label-md text-label-md text-on-surface font-semibold" for="reg-identifier">Roll No / Staff ID</label>
                <input class="w-full px-4 py-3 bg-surface-container-low text-on-surface rounded-xl font-body-md text-body-md focus:bg-surface-container-lowest focus:outline-none focus:ring-2 focus:ring-primary-container transition-all" 
                  id="reg-identifier" name="identifier" value="<c:out value="${regIdentifier}"/>" placeholder="e.g. CS-2022-041" required type="text"/>
              </div>
              <div class="flex flex-col gap-1.5">
                <label class="font-label-md text-label-md text-on-surface font-semibold" for="reg-email">Institutional Email</label>
                <input class="w-full px-4 py-3 bg-surface-container-low text-on-surface rounded-xl font-body-md text-body-md focus:bg-surface-container-lowest focus:outline-none focus:ring-2 focus:ring-primary-container transition-all" 
                  id="reg-email" name="email" value="<c:out value="${regEmail}"/>" placeholder="user@university.edu" required type="email"/>
              </div>
            </div>

            <!-- Department & Cohort Row -->
            <div class="grid grid-cols-1 md:grid-cols-2 gap-3">
              <div class="flex flex-col gap-1.5">
                <label class="font-label-md text-label-md text-on-surface font-semibold" for="reg-dept">Department</label>
                <select class="w-full px-4 py-3 bg-surface-container-low text-on-surface rounded-xl font-body-md text-body-md focus:bg-surface-container-lowest focus:outline-none focus:ring-2 focus:ring-primary-container cursor-pointer" id="reg-dept" name="department">
                  <option value="Computer Science">Computer Science</option>
                  <option value="Mathematics">Mathematics</option>
                  <option value="Electrical Engineering">Electrical Engineering</option>
                  <option value="Information Technology">Information Technology</option>
                </select>
              </div>
              <div class="flex flex-col gap-1.5">
                <label id="reg-cohort-label" class="font-label-md text-label-md text-on-surface font-semibold" for="reg-cohort">Cohort / Graduation Year</label>
                <input class="w-full px-4 py-3 bg-surface-container-low text-on-surface rounded-xl font-body-md text-body-md focus:bg-surface-container-lowest focus:outline-none focus:ring-2 focus:ring-primary-container" 
                  id="reg-cohort" name="cohort" value="<c:out value="${regCohort}"/>" placeholder="Class of 2026" type="text"/>
              </div>
            </div>

            <!-- Password -->
            <div class="flex flex-col gap-1.5">
              <label class="font-label-md text-label-md text-on-surface font-semibold" for="reg-password">Create Strong Password</label>
              <input class="w-full px-4 py-3 bg-surface-container-low text-on-surface rounded-xl font-body-md text-body-md focus:bg-surface-container-lowest focus:outline-none focus:ring-2 focus:ring-primary-container" 
                id="reg-password" name="password" placeholder="At least 6 characters" required type="password"/>
            </div>

            <div class="flex items-start gap-2.5 pt-1">
              <input class="mt-1 w-4 h-4 rounded text-primary focus:ring-primary cursor-pointer" id="reg-consent" name="biometricConsent" type="checkbox" checked/>
              <label class="font-body-sm text-body-sm text-on-surface-variant cursor-pointer" for="reg-consent">
                I agree to the Academic Code of Conduct and proctoring telemetry standards.
              </label>
            </div>

            <!-- Submit Button -->
            <button type="submit" 
              class="w-full py-3.5 px-6 rounded-xl bg-primary-container hover:bg-secondary transition-all text-on-primary font-label-md text-title-md flex items-center justify-center gap-2 shadow-md shadow-primary/25 mt-2 font-bold cursor-pointer">
              <span class="material-symbols-outlined text-[20px]">how_to_reg</span>
              <span id="reg-btn-text">Create Candidate Account</span>
            </button>
          </form>

        </div>
      </div>
    </div>

    <!-- Global Footer -->
    <footer class="w-full max-w-7xl mx-auto flex flex-col sm:flex-row items-center justify-between py-4 border-t border-surface-container text-body-sm text-on-surface-variant/80 z-10 gap-2">
      <div class="flex items-center gap-4">
        <span>© 2025 QuizTrack Online Examination Platform.</span>
        <span class="text-outline-variant">•</span>
        <span class="font-code-telemetry text-xs">BUILD 4.12.0-STABLE</span>
      </div>
      <div class="flex items-center gap-6">
        <a class="hover:text-primary transition-colors text-xs font-semibold" href="${pageContext.request.contextPath}/sitemap">System Sitemap</a>
        <a class="hover:text-primary transition-colors text-xs font-semibold" href="#">Security Whitepaper</a>
        <a class="hover:text-primary transition-colors text-xs font-semibold" href="#">Technical Support</a>
      </div>
    </footer>

  </div>
</div>
</main>

<!-- FORGOT PASSWORD MODAL DIALOG -->
<div id="forgot-password-modal" class="fixed inset-0 z-50 flex items-center justify-center bg-slate-900/60 backdrop-blur-sm p-4 hidden">
  <div class="w-full max-w-md bg-surface-container-lowest rounded-2xl shadow-2xl border border-surface-container-high p-6 flex flex-col gap-4 animate-in fade-in zoom-in-95 duration-150">
    <div class="flex items-center justify-between border-b border-surface-container pb-3">
      <div class="flex items-center gap-2">
        <span class="material-symbols-outlined text-primary text-[24px]">vpn_key</span>
        <h3 class="font-title-md text-title-md text-on-surface font-bold">Reset Exam Credentials</h3>
      </div>
      <button type="button" onclick="closeForgotModal()" class="w-8 h-8 rounded-lg bg-surface-container-low text-on-surface-variant hover:text-on-surface flex items-center justify-center">
        <span class="material-symbols-outlined text-[18px]">close</span>
      </button>
    </div>
    <p class="font-body-sm text-body-sm text-on-surface-variant leading-relaxed">
      Enter the institutional email address registered with your student or faculty record. We will dispatch a temporary authorization token and reset link.
    </p>
    <form method="POST" action="${pageContext.request.contextPath}/auth/forgot-password" class="flex flex-col gap-4">
      <div class="flex flex-col gap-1.5">
        <label class="font-label-md text-label-md text-on-surface font-semibold" for="reset-email">Institutional Email</label>
        <input id="reset-email" name="email" class="w-full px-4 py-3 bg-surface-container-low text-on-surface rounded-xl font-body-md text-body-md focus:bg-surface-container-lowest focus:outline-none focus:ring-2 focus:ring-primary-container" placeholder="roll.number@institution.edu" required type="email"/>
      </div>
      <div class="flex justify-end gap-2 pt-2">
        <button type="button" onclick="closeForgotModal()" class="py-2.5 px-4 rounded-xl bg-surface-container-low text-on-surface hover:bg-surface-container font-label-md text-label-md transition-colors font-semibold">
          Cancel
        </button>
        <button type="submit" class="py-2.5 px-5 rounded-xl bg-primary-container text-on-primary hover:bg-secondary font-label-md text-label-md shadow-md transition-all font-bold">
          Send Recovery Link
        </button>
      </div>
    </form>
  </div>
</div>

<script>
  let currentRole = '${not empty selectedRole ? selectedRole : "student"}';
  let currentTab = '${not empty activeTab ? activeTab : "signin"}';

  function setRole(role) {
    currentRole = role;
    const studentBtn = document.getElementById('role-btn-student');
    const teacherBtn = document.getElementById('role-btn-teacher');
    const adminBtn = document.getElementById('role-btn-admin');
    const identifierLabel = document.getElementById('identifier-label');
    const identifierInput = document.getElementById('user-identifier');
    const identifierIcon = document.getElementById('identifier-icon');
    const roleBadge = document.getElementById('role-context-badge');
    const authRoleInput = document.getElementById('auth-role-input');
    const regRoleInput = document.getElementById('reg-role-input');
    const btnText = document.getElementById('btn-text');
    const regBtnText = document.getElementById('reg-btn-text');
    const regIdLabel = document.getElementById('reg-id-label');
    const regCohortLabel = document.getElementById('reg-cohort-label');

    // Reset button styles
    const inactiveClass = 'flex-1 py-2.5 px-4 rounded-lg font-label-md text-label-md flex items-center justify-center gap-2 transition-all text-on-surface-variant hover:text-on-surface font-bold';
    const activeClass = 'flex-1 py-2.5 px-4 rounded-lg font-label-md text-label-md flex items-center justify-center gap-2 transition-all bg-surface-container-lowest text-primary shadow-sm font-bold';

    studentBtn.className = inactiveClass;
    teacherBtn.className = inactiveClass;
    adminBtn.className = inactiveClass;

    authRoleInput.value = role;
    regRoleInput.value = role;

    if (role === 'teacher') {
      teacherBtn.className = activeClass;
      identifierLabel.textContent = 'Faculty ID or Academic Email';
      identifierInput.placeholder = 'e.g. ronald.vance or r.vance@university.edu';
      identifierIcon.textContent = 'psychology';
      roleBadge.textContent = 'Proctor & Faculty Mode';
      btnText.textContent = 'Authenticate Faculty Console';
      regBtnText.textContent = 'Register Proctor Credentials';
      regIdLabel.textContent = 'Faculty Staff ID';
      regCohortLabel.textContent = 'Faculty Designation';
    } else if (role === 'admin') {
      adminBtn.className = activeClass;
      identifierLabel.textContent = 'Administrator Username or Email';
      identifierInput.placeholder = 'e.g. admin or admin@quiztrack.edu';
      identifierIcon.textContent = 'shield_person';
      roleBadge.textContent = 'Administrator Mode';
      btnText.textContent = 'Authenticate Admin Gateway';
      regBtnText.textContent = 'Register Admin Credentials';
      regIdLabel.textContent = 'Admin Identifier';
      regCohortLabel.textContent = 'Administrative Unit';
    } else {
      studentBtn.className = activeClass;
      identifierLabel.textContent = 'Institutional Email or Student Roll No';
      identifierInput.placeholder = 'e.g. CS-2022-041 or user@university.edu';
      identifierIcon.textContent = 'school';
      roleBadge.textContent = 'Candidate Mode';
      btnText.textContent = 'Authenticate & Enter Examination Center';
      regBtnText.textContent = 'Create Candidate Account';
      regIdLabel.textContent = 'Student Roll Number';
      regCohortLabel.textContent = 'Cohort / Graduation Year';
    }
  }

  function setAuthTab(tab) {
    currentTab = tab;
    const signinBtn = document.getElementById('tab-btn-signin');
    const registerBtn = document.getElementById('tab-btn-register');
    const signinIndicator = document.getElementById('tab-indicator-signin');
    const registerIndicator = document.getElementById('tab-indicator-register');
    const signinForm = document.getElementById('signin-form');
    const registerForm = document.getElementById('register-form');

    if (tab === 'register') {
      registerBtn.classList.replace('text-on-surface-variant', 'text-primary');
      signinBtn.classList.replace('text-primary', 'text-on-surface-variant');
      registerIndicator.classList.remove('hidden');
      signinIndicator.classList.add('hidden');
      signinForm.classList.add('hidden');
      registerForm.classList.remove('hidden');
    } else {
      signinBtn.classList.replace('text-on-surface-variant', 'text-primary');
      registerBtn.classList.replace('text-primary', 'text-on-surface-variant');
      signinIndicator.classList.remove('hidden');
      registerIndicator.classList.add('hidden');
      signinForm.classList.remove('hidden');
      registerForm.classList.add('hidden');
    }
  }

  function togglePasswordVisibility() {
    const pwdInput = document.getElementById('user-password');
    const icon = document.getElementById('pwd-toggle-icon');
    if (pwdInput.type === 'password') {
      pwdInput.type = 'text';
      icon.textContent = 'visibility_off';
    } else {
      pwdInput.type = 'password';
      icon.textContent = 'visibility';
    }
  }

  function openForgotModal() {
    document.getElementById('forgot-password-modal').classList.remove('hidden');
  }

  function closeForgotModal() {
    document.getElementById('forgot-password-modal').classList.add('hidden');
  }

  // Initialize UI based on state
  window.addEventListener('DOMContentLoaded', () => {
    setRole(currentRole);
    setAuthTab(currentTab);
  });
</script>
</body>
</html>
