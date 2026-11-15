---
name: "Wara2tak Design System"
description: "AI-powered document understanding and application planning assistant for university students and graduates, supporting both Arabic RTL and English LTR."
---

# Wara2tak (ورقتك) — Master Design System

## Overview

Wara2tak (ورقتك) is an AI-powered document understanding and application planning assistant tailored for university students and recent graduates across the MENA region and globally. It empowers ambitious students navigating high-stakes opportunities—scholarships (like Chevening, Fulbright, DAAD), competitive student exchanges (Erasmus+), prestigious internships, and research grants.

The design philosophy embodies:
- **Clean, Modern, and Minimal**: Generous breathing room, structural clarity, and disciplined negative space. Free of excessive gradients, unnecessary decoration, and visual clutter.
- **Productivity & Confidence**: Calm, focused, and trust-inspiring. It transforms daunting 40-page PDF guidelines into clear, prioritized checklists, milestone deadlines, and instant multilingual AI answers.
- **Bilingual & Culturally Native**: Thoughtfully crafted for seamless dual-directionality, honoring Arabic typography (Cairo) in native Right-to-Left (RTL) reading flows as elegantly as English (Inter) Left-to-Right (LTR).

## Colors

The palette centers on an authoritative, intellectual **Deep Indigo** primary grounded by crisp neutral surfaces and functional status semantics for critical academic deadlines and requirements.

- **Primary:** Deep Indigo (#4F46E5) conveys academic rigor, institutional prestige, and focused AI intelligence.
- **Secondary:** Soft Blue (#E0E7FF) provides gentle, airy contrast for container fills, highlights, and active state pill badges.
- **Background & Surface:** High-clarity, eye-friendly light neutral (#F8FAFC) canvas paired with pure white (#FFFFFF) elevated cards.
- **Text Hierarchy:** Dark Navy (#0F172A) provides high legibility for essential reading, paired with Slate Gray (#64748B) for supportive metadata and timestamps.
- **Semantic Statuses:** Purely informational and deadline-critical—Green (#16A34A) for completed requirements, Amber (#F59E0B) for upcoming deadlines, and Red (#EF4444) for urgent expirations and missing requirements.

```yaml
colors:
  indigo-deep: "#4F46E5"
  blue-soft: "#E0E7FF"
  neutral-bg: "#F8FAFC"
  text-navy: "#0F172A"
  text-slate: "#475569"
  success: "#16A34A"
  warning: "#F59E0B"
  warning-text: "#B45309"
  error: "#EF4444"
  light:
    primary: "#4F46E5"
    on-primary: "#FFFFFF"
    secondary: "#E0E7FF"
    on-secondary: "#1E1B4B"
    surface: "#FFFFFF"
    on-surface: "#0F172A"
    surface-variant: "#F1F5F9"
    on-surface-variant: "#475569"
    outline: "#CBD5E1"
    outline-variant: "#E2E8F0"
  dark:
    bg: "#0F172A"
    primary: "#818CF8"
    on-primary: "#0F172A"
    secondary: "#1E1B4B"
    on-secondary: "#E0E7FF"
    surface: "#1E293B"
    on-surface: "#F8FAFC"
    surface-variant: "#334155"
    on-surface-variant: "#CBD5E1"
    outline: "#475569"
    outline-variant: "#334155"
```

## Typography

Wara2tak uses a harmonious dual-font strategy: **Inter** for clean, legible English typography and **Cairo** for Arabic display and body text, ensuring typographic weight parity across both language modes.

```yaml
typography:
  display-lg:
    fontFamily: "Cairo"
    fontSize: 36px
    fontWeight: 700
    lineHeight: 44px
    letterSpacing: -0.5px
  display-lg-mobile:
    fontFamily: "Cairo"
    fontSize: 28px
    fontWeight: 700
    lineHeight: 36px
    letterSpacing: -0.25px
  headline-lg:
    fontFamily: "Cairo"
    fontSize: 32px
    fontWeight: 700
    lineHeight: 40px
    letterSpacing: -0.25px
  headline-lg-mobile:
    fontFamily: "Cairo"
    fontSize: 24px
    fontWeight: 700
    lineHeight: 32px
    letterSpacing: 0px
  headline-md:
    fontFamily: "Cairo"
    fontSize: 22px
    fontWeight: 600
    lineHeight: 30px
    letterSpacing: 0px
  headline-sm:
    fontFamily: "Cairo"
    fontSize: 18px
    fontWeight: 600
    lineHeight: 26px
    letterSpacing: 0px
  body-lg:
    fontFamily: "Inter"
    fontSize: 16px
    fontWeight: 400
    lineHeight: 24px
    letterSpacing: 0px
  body-md:
    fontFamily: "Inter"
    fontSize: 14px
    fontWeight: 400
    lineHeight: 20px
    letterSpacing: 0px
  body-sm:
    fontFamily: "Inter"
    fontSize: 12px
    fontWeight: 400
    lineHeight: 18px
    letterSpacing: 0px
  label-lg:
    fontFamily: "Inter"
    fontSize: 14px
    fontWeight: 600
    lineHeight: 20px
    letterSpacing: 0.1px
  label-md:
    fontFamily: "Inter"
    fontSize: 12px
    fontWeight: 500
    lineHeight: 16px
    letterSpacing: 0.2px
  label-sm:
    fontFamily: "Inter"
    fontSize: 11px
    fontWeight: 500
    lineHeight: 14px
    letterSpacing: 0.3px
```

## Layout & Spacing

Mobile-first architecture tailored for modern smartphones (390px viewport baseline). A strict 4px/8px modular spacing scale guarantees rhythmic alignment across document checklists, AI prompts, and navigation items.

```yaml
spacing:
  spacing-2xs: 4px
  spacing-xs: 4px
  spacing-sm: 8px
  spacing-md: 12px
  spacing-base: 16px
  spacing-lg: 20px
  spacing-xl: 24px
  spacing-2xl: 32px
  spacing-3xl: 40px
  gutter-mobile: 16px
  nav-height: 68px
  touch-target-min: 44px
```

## Elevation & Depth

Tactile, subtle elevation without heavy drop shadows or dramatic blurs. Visual separation is achieved through:
1. **Low-contrast hairlines**: Border color `outline-variant` (#E2E8F0) defining card boundaries clearly over neutral surfaces.
2. **Subtle ambient card shadow**: Soft 1px-3px blur with 4% opacity to create modest lift (`0 2px 8px -2px rgba(15, 23, 42, 0.05)`).
3. **Modal/Sheet lift**: Floating action sheets and bottom navigation utilize `0 10px 25px -5px rgba(15, 23, 42, 0.08)`.

## Shapes

Organic, friendly corner radii reinforcing modern mobile ergonomics. Cards and containers range consistently between 12px and 16px, preventing sharp, stressful corners while preserving structured organization.

```yaml
rounded:
  sm: 6px
  md: 10px
  DEFAULT: 12px
  lg: 16px
  xl: 20px
  pill: 9999px
```

## Motion & Micro-interaction

Micro-interactions are snappy and purposeful, confirming document uploads, checklist completion, and AI summary generation without delaying the student.

```yaml
motion:
  tap:
    duration: 120ms
    delay: 0ms
    timingFunction: cubic-bezier(0.4, 0, 0.2, 1)
  sheet-slide:
    duration: 260ms
    delay: 0ms
    timingFunction: cubic-bezier(0.16, 1, 0.3, 1)
  status-change:
    duration: 180ms
    delay: 0ms
    timingFunction: ease-out
```

## Voice & Content Strategy

The app speaks as a capable, reassuring academic mentor:
- **Tone:** Encouraging, structured, reliable, and articulate. Never verbose or bureaucratic.
- **Action Verbs:** Direct outcomes ("Upload Document", "Generate Checklist", "Translate Requirements", "Ask Wara2tak AI").
- **Clarity First:** Document dates are explicit with time-to-deadline chips (e.g., "14 days remaining", "Deadline: Oct 15, 2026").
- **Bilingual Consistency:** High-fidelity terminology mirrors between Arabic and English without mechanical translation artifacts (e.g., "ورقتك" / "Wara2tak", "قائمة المهام" / "Checklist", "تحليل الذكاء الاصطناعي" / "AI Summary").

## Components

Component implementations live as individual HTML sticker sheet files in
`components/`. Each file contains the canonical, styled HTML components with
`<!-- COMPONENT: name -->` comment markers. Read each file before use.

- **Badge** → `@components/badge.html`: `badge-numeric`, `badge-dot`
- **Button** → `@components/button.html`: `button-primary`, `button-icon`, `button-with-icon`
- **Card** → `@components/card.html`: `card-elevated`, `card-action`, `card-interactive`, `card-interactive-2`
- **Input Field** → `@components/input-field.html`: `input-field-text`, `input-field-icon`
- **Tabs** → `@components/tabs.html`: `tabs-horizontal`, `tabs-with-icon`
