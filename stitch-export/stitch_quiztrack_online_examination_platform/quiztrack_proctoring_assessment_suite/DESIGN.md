---
name: QuizTrack Proctoring & Assessment Suite
colors:
  surface: '#f8f9ff'
  surface-dim: '#cbdbf5'
  surface-bright: '#f8f9ff'
  surface-container-lowest: '#ffffff'
  surface-container-low: '#eff4ff'
  surface-container: '#e5eeff'
  surface-container-high: '#dce9ff'
  surface-container-highest: '#d3e4fe'
  on-surface: '#0b1c30'
  on-surface-variant: '#464555'
  inverse-surface: '#213145'
  inverse-on-surface: '#eaf1ff'
  outline: '#777587'
  outline-variant: '#c7c4d8'
  surface-tint: '#4d44e3'
  primary: '#3525cd'
  on-primary: '#ffffff'
  primary-container: '#4f46e5'
  on-primary-container: '#dad7ff'
  inverse-primary: '#c3c0ff'
  secondary: '#4648d4'
  on-secondary: '#ffffff'
  secondary-container: '#6063ee'
  on-secondary-container: '#fffbff'
  tertiary: '#005338'
  on-tertiary: '#ffffff'
  tertiary-container: '#006e4b'
  on-tertiary-container: '#67f4b7'
  error: '#ba1a1a'
  on-error: '#ffffff'
  error-container: '#ffdad6'
  on-error-container: '#93000a'
  primary-fixed: '#e2dfff'
  primary-fixed-dim: '#c3c0ff'
  on-primary-fixed: '#0f0069'
  on-primary-fixed-variant: '#3323cc'
  secondary-fixed: '#e1e0ff'
  secondary-fixed-dim: '#c0c1ff'
  on-secondary-fixed: '#07006c'
  on-secondary-fixed-variant: '#2f2ebe'
  tertiary-fixed: '#6ffbbe'
  tertiary-fixed-dim: '#4edea3'
  on-tertiary-fixed: '#002113'
  on-tertiary-fixed-variant: '#005236'
  background: '#f8f9ff'
  on-background: '#0b1c30'
  surface-variant: '#d3e4fe'
typography:
  display:
    fontFamily: Plus Jakarta Sans
    fontSize: 48px
    fontWeight: '700'
    lineHeight: 56px
    letterSpacing: -0.02em
  display-mobile:
    fontFamily: Plus Jakarta Sans
    fontSize: 32px
    fontWeight: '700'
    lineHeight: 40px
    letterSpacing: -0.01em
  headline-lg:
    fontFamily: Plus Jakarta Sans
    fontSize: 32px
    fontWeight: '600'
    lineHeight: 40px
    letterSpacing: -0.015em
  headline-lg-mobile:
    fontFamily: Plus Jakarta Sans
    fontSize: 24px
    fontWeight: '600'
    lineHeight: 32px
    letterSpacing: -0.01em
  headline-md:
    fontFamily: Plus Jakarta Sans
    fontSize: 24px
    fontWeight: '600'
    lineHeight: 32px
    letterSpacing: -0.01em
  headline-sm:
    fontFamily: Plus Jakarta Sans
    fontSize: 20px
    fontWeight: '600'
    lineHeight: 28px
  title-lg:
    fontFamily: Plus Jakarta Sans
    fontSize: 18px
    fontWeight: '600'
    lineHeight: 26px
  title-md:
    fontFamily: Inter
    fontSize: 16px
    fontWeight: '600'
    lineHeight: 24px
  body-lg:
    fontFamily: Inter
    fontSize: 16px
    fontWeight: '400'
    lineHeight: 26px
  body-md:
    fontFamily: Inter
    fontSize: 14px
    fontWeight: '400'
    lineHeight: 22px
  body-sm:
    fontFamily: Inter
    fontSize: 13px
    fontWeight: '400'
    lineHeight: 18px
  label-md:
    fontFamily: Inter
    fontSize: 12px
    fontWeight: '600'
    lineHeight: 16px
    letterSpacing: 0.02em
  label-sm:
    fontFamily: Inter
    fontSize: 11px
    fontWeight: '600'
    lineHeight: 14px
    letterSpacing: 0.04em
  code-telemetry:
    fontFamily: JetBrains Mono
    fontSize: 12px
    fontWeight: '500'
    lineHeight: 16px
rounded:
  sm: 0.25rem
  DEFAULT: 0.5rem
  md: 0.75rem
  lg: 1rem
  xl: 1.5rem
  full: 9999px
spacing:
  gutter: 1.5rem
  gutter-sm: 1rem
  margin: 2rem
  margin-sm: 1rem
  space-xs: 0.25rem
  space-sm: 0.5rem
  space-md: 1rem
  space-lg: 1.5rem
  space-xl: 2rem
---

## Brand & Style

The design system embodies authoritative vigilance paired with an anxiety-reducing, professional interface. Built specifically for high-stakes online examinations, academic testing, and enterprise certification workflows, the design prioritizes absolute clarity, cognitive calm, and rapid anomaly detection.

### Brand Personality & Emotional Baseline
- **Vigilant yet Unobtrusive:** The system maintains unwavering operational integrity without intimidating honest test-takers or inducing panic.
- **Calm & Objective:** Critical proctoring alerts deliver decisive signal with zero sensory noise. Statuses are diagnostic and factual rather than punitive.
- **Enterprise Precision:** Dense analytics, live webcam monitoring streams, screen telemetry, and event audit trails are organized into disciplined, scannable data layouts.

### Visual Style Direction
The aesthetic merges **Modern Corporate SaaS** with **Minimalist Heads-Up Display (HUD)** architecture. Surfaces use crisp hairline borders (`#E2E8F0`), deep slate typography for surgical readability, and soft, tiered surface elevations. In assessment candidate view, the interface strips away all non-essential furniture to form a distraction-free testing chamber. In proctor view, the system provides high-density, multi-feed observation tiles, real-time audio/visual incident heatmaps, and low-latency interaction controls.

## Colors

The palette is engineered around high functional contrast, clear state delineation, and WCAG AAA compliance for critical test and surveillance elements.

### Color Archetypes & Semantic Mapping
- **Primary Indigo (`#4F46E5`) & Secondary Violet (`#6366F1`):** Represents system authority, primary interactions, active question states, verified telemetry connections, and administrative actions.
- **Neutral Canvas (`#F8FAFC`) & Elevated Card Surfaces (`#FFFFFF`):** Delivers clean contrast while eliminating harsh pure-white glare during lengthy exam sessions.
- **Text & Structure:**
  - Ink Heavy / Primary Text: `#0F172A` (Slate 900)
  - Muted Text / Meta Labels: `#64748B` (Slate 500)
  - Borders & Outlines: `#E2E8F0` (Slate 200)
  - Subtle Dividing Fills: `#F1F5F9` (Slate 100)

### Real-Time Proctoring & Telemetry Status System
Color tokens in proctor mode communicate immediate, unequivocal behavioral states:
- **Normal / Safe / Verified (`#10B981`):** Face detected, single display active, audio within ambient threshold, connection stable.
- **Caution / Flagged / Suspicious (`#F59E0B`):** Eye deviation detected, background audio anomaly, second screen pinged, focus lost momentarily.
- **Danger / Critical Violation (`#EF4444`):** Absence detected, unauthorized face in frame, clipboard hijacking, browser window switch, audio speech detected.
- **Disconnected / Inactive (`#94A3B8`):** Video feed drop, ping timeout, candidate idle, uninitiated environment check.

## Typography

The typographic hierarchy utilizes **Plus Jakarta Sans** for headings, structural milestones, and metric readouts, bringing modern geometric warmth to administrative views. **Inter** is assigned to body content, questions, answers, and data grids to guarantee legibility under rigorous scrutiny. **JetBrains Mono** is utilized strictly for hardware IDs, IP addresses, latency monitors (ms), cryptographic validation tokens, and time-stamped proctor event logs.

### Application Rules
- **Question Stems:** Always rendered in `title-lg` or `body-lg` at 400–600 weight with generous line height (minimum 1.6x) to avoid visual fatigue during 2+ hour exams.
- **Proctor Feed Overlays:** Badges and metric callouts inside video streams must utilize `label-md` or `label-sm` with tabular numerical figures to prevent layout jitter when counters update.
- **Monospace Discipline:** Timestamp counters (`01:42:19`), network ping rates, and exam hashes must always rely on `code-telemetry` with fixed character widths.

## Layout & Spacing

The layout model is anchored on an 8pt architectural rhythm with distinct behavior between Candidate Testing Environments and Administrative Proctoring Consoles.

### Grid Structures & Consoles
- **Candidate Focus Mode:** A centered, constrained-width container (maximum 840px) that eliminates sidebars and navigational distractions. Sticky persistent header displays the timer, connectivity badge, and emergency proctor communication link.
- **Live Proctoring Control Matrix:** A 12-column dynamic fluid grid supporting 4, 9, 16, or 25 concurrent candidate video and audio feeds. Feeds dynamically snap into balanced aspect ratios (`16:9` default, reflowing to `4:3` on sub-1440px displays).
- **Split Audit Layout:** 65% left viewport for exam question timeline and candidate screen broadcast; 35% right viewport for proctor notes, AI violation log, and biometric confidence scores.

### Responsive Breakpoints
- **Mobile (< 768px):** Proctor view disabled; candidate views switch to full-width linear layout with stacked answer controls, drawer-based navigation, and fixed bottom question navigation bar.
- **Tablet (768px – 1024px):** 2x2 grid in proctor monitor; candidate view margins compress to `margin-sm`.
- **Desktop (1024px – 1440px):** Full 12-column grid; 3x3 proctor feed layout with collapsible secondary log sidebar.
- **Ultra-Wide (> 1440px):** High-density 4x4 or 5x5 proctor feed matrix with dedicated split-pane inspection panels.

## Elevation & Depth

Visual hierarchy uses crisp boundaries paired with soft, low-intensity ambient shadowing. This prevents visual clutter in high-density surveillance views.

### Elevation Hierarchy
- **Level 0 (Flat Base):** `#F8FAFC` canvas. Used for test chamber background and administrative shells.
- **Level 1 (Card & Module Layer):** `#FFFFFF` surfaces bounded by a solid hairline border (`1px solid #E2E8F0`). Shadow: `0 1px 3px 0 rgba(15, 23, 42, 0.05), 0 1px 2px -1px rgba(15, 23, 42, 0.03)`. Used for questions, assessment setting containers, and data table blocks.
- **Level 2 (Active & Hover State):** Elevated cards, selected multiple-choice options, and active candidate inspection panels. Shadow: `0 4px 6px -1px rgba(15, 23, 42, 0.07), 0 2px 4px -2px rgba(15, 23, 42, 0.04)`.
- **Level 3 (Floating HUD Elements & Modals):** Sticky countdown timers, warning alert flyouts, exam termination confirmation dialogues, and full-screen candidate video inspect drawers. Shadow: `0 20px 25px -5px rgba(15, 23, 42, 0.1), 0 8px 10px -6px rgba(15, 23, 42, 0.04)`. Border: `1px solid #CBD5E1`.

### Video Stream HUD Overlays
Feeds utilize an internal gradient scrim at top and bottom (`linear-gradient(180deg, rgba(15, 23, 42, 0.7) 0%, transparent 40%)`) to render status badges, candidate names, and signal rates cleanly over bright background cameras.

## Shapes

The design system standardizes on clean, approachable corners that communicate modern software without sliding into casual toy-like roundness.

### Corner Radius System
- **Base Components (`0.5rem` / 8px):** Buttons, standard form inputs, multiple-choice option rows, data table action buttons, and dropdown menus.
- **Containers & Feeds (`1rem` / 16px):** Webcam preview frames, candidate test cards, analytical chart cards, and modal dialogs.
- **Compound Indicators (`rounded-full` / 9999px):** Status pill badges (Normal, Caution, Danger), test question index navigation nodes, and proctor action pills.

## Components

### Buttons
- **Primary Action:** Solid background `#4F46E5`, text `#FFFFFF`, corner radius 8px, hover `#4338CA`, active `#3730A3`. Focus ring: 2px offset with `#6366F1`.
- **Secondary / Outlined:** Surface `#FFFFFF`, border `1px solid #E2E8F0`, text `#0F172A`, hover `#F8FAFC`, hover border `#CBD5E1`.
- **Destructive Action (Terminate Exam / Reject Submission):** Surface `#EF4444`, text `#FFFFFF`, hover `#DC2626`.
- **Proctor HUD Controls:** Semi-translucent dark pill buttons (`rgba(15, 23, 42, 0.85)` background, `#FFFFFF` icon and text) nested directly inside video monitors.

### High-Contrast Badges & Status Chips
Badges use tinted backgrounds paired with matching high-contrast foreground text and crisp border rings:
- **Normal:** Background `#ECFDF5`, border `#A7F3D0`, text `#065F46`, paired with an active pulsing `#10B981` dot.
- **Caution:** Background `#FFFBEB`, border `#FDE68A`, text `#92400E`.
- **Danger:** Background `#FEF2F2`, border `#FECACA`, text `#991B1B`.
- **Disconnected / Offline:** Background `#F1F5F9`, border `#E2E8F0`, text `#475569`.

### Examination Input Fields & Option Selectors
- **Multiple Choice Radio Panels:** Outlined container cards (`1px solid #E2E8F0`), padding `1rem`, transition `all 0.15s ease`.
  - *Default:* Surface `#FFFFFF`, text `#0F172A`.
  - *Selected:* Surface `#EEF2FF`, border `2px solid #4F46E5`, text `#312E81`.
- **Text Inputs & Essay Response Blocks:** Clean border `1px solid #CBD5E1`, background `#FFFFFF`, inner padding `0.75rem 1rem`. Focus state features zero ambient glow, strictly switching to a crisp `2px solid #4F46E5`.
- **Autosave Indicator:** Discrete inline micro-indicator with spinner and label (`"Draft saved to server 12s ago"` in `#64748B`).

### Video Monitoring & Telemetry Cards
- **Proctor Candidate Tile:** 16:9 ratio card containing candidate stream, dynamic face-tracking bounding box overlay (green for tracked, red for anomaly), audio level indicator bar along the bottom edge, and a header strip featuring candidate name, candidate seat number, and violation badge counter.
- **Exam Event Audit Table:** Alternating row styling with hover state `#F8FAFC`, columns for Timestamp (`JetBrains Mono`), Candidate, Incident Type, Confidence Score (`%`), and Instant Replay quick action trigger.

### Examination Navigation Palette
- A grid of numbered circle pills representing all test questions.
  - *Answered:* `#4F46E5` fill, `#FFFFFF` text.
  - *Current Active:* `#FFFFFF` fill, `2px solid #4F46E5` border, `#4F46E5` text.
  - *Flagged for Review:* `#FEF3C7` fill, `1px solid #F59E0B` border, `#B45309` text with flag icon indicator.
  - *Unanswered:* `#F1F5F9` fill, `#64748B` text.