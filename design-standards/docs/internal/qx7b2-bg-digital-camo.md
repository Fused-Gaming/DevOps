---
title: VLN Digital Camo — Background Motion System
description: Internal design specification for the animated dark-green digital camouflage background system used across VLN products.
image: https://vln.gg/api/og?title=Visual%20Motion%20System&subtitle=Digital%20Camo%20Background%20Spec&accent=blue&subdomain=docs
unlisted: true
hide_table_of_contents: false
pagination_next: null
pagination_prev: null
---

# VLN Digital Camo — Background Motion System

> **Internal document — not indexed.** Direct URL access only.
> Spec version: `0x3-camo-bg` · Last updated: 2026-02-24

This document defines the **animated digital camouflage background** system for VLN products. It covers the design intent, color mapping, animation library stack, grid architecture, motion specs, and performance constraints.

---

## 1. Design Intent

The digital camo background is a **living texture** — not a static image. It signals:

- **Tactical precision** — every element is intentional, grid-locked, and structured
- **Alive infrastructure** — the UI breathes; pixels shift, fade, and re-emerge
- **Dark-first immersion** — the background always recedes; it never competes with content

The goal is a background that feels like a **low-power radar screen** overlaid with fragmenting digital terrain — organic enough to feel alive, structured enough to feel engineered.

---

## 2. Color System

The camo palette is derived from VLN brand tokens, extended into a tactical range. **Never deviate from these values.**

### Camo Color Map

| Token | Hex | Role |
|-------|-----|------|
| `--camo-void` | `#000000` | Darkest block — empty terrain |
| `--camo-deep` | `#0a0e0f` | VLN page background (base) |
| `--camo-shadow` | `#0d1a0f` | Near-black green, shadow cells |
| `--camo-forest` | `#004d00` | Core dark green — primary camo body |
| `--camo-olive` | `#3b5323` | Olive drab — mid-tone breakup |
| `--camo-moss` | `#2d4a1e` | Moss — transition between forest and olive |
| `--camo-sage-dim` | `#4a7c59` | Muted sage — highlight cell edges |
| `--camo-sage` | `#86d993` | VLN sage — accent glitch pulse only |

### CSS Custom Properties

```css
/* Add to :root in custom.css — camo system extension */
:root {
  --camo-void:      #000000;
  --camo-deep:      #0a0e0f;
  --camo-shadow:    #0d1a0f;
  --camo-forest:    #004d00;
  --camo-olive:     #3b5323;
  --camo-moss:      #2d4a1e;
  --camo-sage-dim:  #4a7c59;
  --camo-sage:      #86d993;   /* VLN primary — glitch only */

  --camo-cell-size: clamp(16px, 2.5vw, 32px);   /* Responsive pixel block size */
  --camo-gap:       2px;                          /* Cell gap — keep tight */
  --camo-opacity:   0.72;                         /* Base layer opacity */
  --camo-glow:      0 0 8px rgba(0, 77, 0, 0.4); /* Cell glow shadow */
}
```

### Usage Rules

- **`--camo-forest`** and **`--camo-olive`** make up ~70% of all cells — they are the primary texture
- **`--camo-void`** and **`--camo-shadow`** account for ~20% — negative space that makes it read as camo
- **`--camo-sage`** (`#86d993`) is used **only for the occasional glitch pulse** — it marks this as VLN, not generic military
- Never use `--camo-sage` as a fill color for more than 1–2% of cells at any time

---

## 3. Library Stack

### Recommended (in priority order)

| Library | Version | Role | Install |
|---------|---------|------|---------|
| **GSAP** (GreenSock) | `^3.12` | Primary animation engine — timelines, staggers, ScrollTrigger | `pnpm add gsap` |
| **Framer Motion** | `^11` | React-native motion — per-cell declarative variants | `pnpm add framer-motion` |
| **React Spring** | `^9` | Physics-based cell transitions — natural settling | `pnpm add @react-spring/web` |
| **React Bits** | latest | Pre-built `Threads` / `Hyperspeed` base components to skin | `pnpm add react-bits` |
| **React Three Fiber** | `^8` | Optional 3D layer — camera-through-terrain effect | `pnpm add @react-three/fiber three` |

> **Lightweight rule from CLAUDE.md §10:** For most page backgrounds, use only **GSAP + Framer Motion**. R3F is only justified for the hero landing page where 3D depth is the central design statement. Never install all five libraries for a single page.

### Decision Tree

```
Need background for a doc page?
  └── Use Framer Motion only (lightweight, declarative)

Need background for a product hero / landing?
  └── Use GSAP + Framer Motion (full stagger timelines + React variants)

Need 3D camera-fly-through terrain?
  └── Use React Three Fiber (only on marketing pages, never in the docs site)
```

---

## 4. Grid Architecture

### Structure

The camo background is a **CSS grid of uniformly-sized colored `<div>` cells**. JavaScript assigns randomized colors from the palette on mount, and the animation library drives opacity/color transitions.

```
┌──────────────────────────────────────────────────────┐
│  [cell][cell][cell][cell][cell][cell][cell][cell]...  │
│  [cell][cell][cell][cell][cell][cell][cell][cell]...  │
│  ... rows fill 100vw × 100vh                          │
└──────────────────────────────────────────────────────┘
```

### Cell Sizing

- Cell size: `clamp(16px, 2.5vw, 32px)` — scales with viewport
- Target cell count: ~800–1200 cells for a standard 1440×900 viewport
- Grid must overflow slightly (`110%` width/height) to prevent edge gaps on scroll parallax

### Color Distribution (per render)

```ts
const CAMO_PALETTE = [
  { color: '#000000', weight: 10 },  // --camo-void
  { color: '#0d1a0f', weight: 12 },  // --camo-shadow
  { color: '#004d00', weight: 38 },  // --camo-forest  ← primary
  { color: '#3b5323', weight: 28 },  // --camo-olive   ← secondary
  { color: '#2d4a1e', weight: 10 },  // --camo-moss
  { color: '#4a7c59', weight: 2  },  // --camo-sage-dim
] as const;

// Weighted random picker
function pickColor(): string {
  const total = CAMO_PALETTE.reduce((s, c) => s + c.weight, 0);
  let rand = Math.random() * total;
  for (const entry of CAMO_PALETTE) {
    if ((rand -= entry.weight) < 0) return entry.color;
  }
  return CAMO_PALETTE[2].color;
}
```

---

## 5. Animation Specifications

### 5.1 GSAP Timeline — Stagger Reveal (Page Load)

**Intent:** On mount, cells fade in from opacity `0` → `0.72` in a staggered wave, creating a "powering up" feel.

```
Timeline: CamoReveal
  ├── duration: 2.4s total
  ├── stagger: 0.008s per cell (random order)
  ├── ease: "power2.inOut"
  ├── from: { opacity: 0, scale: 0.85 }
  └── to:   { opacity: var(--camo-opacity), scale: 1 }
```

### 5.2 GSAP ScrollTrigger — Parallax Drift

**Intent:** The background moves at 0.3× the scroll speed, creating depth separation from foreground content.

```
ScrollTrigger config:
  ├── trigger: document.body
  ├── start: "top top"
  ├── end: "bottom bottom"
  ├── scrub: 1.5        ← smooth catch-up
  └── animation: { y: "-15%" } on the background container
```

### 5.3 Framer Motion — Per-Cell Variant Pulse

**Intent:** Individual cells randomly cycle between two opacity states on a slow loop, simulating IR scatter or heat shimmer.

```ts
const cellVariants = {
  idle: { opacity: 0.72 },
  pulse: { opacity: [0.72, 0.45, 0.72] },
};

// Each cell gets a random delay 0–8s and duration 3–7s
const transition = {
  duration: Math.random() * 4 + 3,
  delay: Math.random() * 8,
  repeat: Infinity,
  ease: 'easeInOut',
};
```

### 5.4 Sage Glitch Pulse (VLN Signature)

**Intent:** Every 12–20s, 2–3 random cells briefly flash `--camo-sage` (`#86d993`) for ~200ms, then revert. This is the "VLN heartbeat" — subtle but unmistakable to those who know the brand.

```ts
// GSAP glitch pulse
gsap.to(glitchCells, {
  backgroundColor: '#86d993',
  duration: 0.08,
  yoyo: true,
  repeat: 3,
  ease: 'none',
  stagger: 0.04,
  onComplete: () => gsap.to(glitchCells, { backgroundColor: originalColor, duration: 0.3 }),
});
```

### 5.5 Timing Summary

| Effect | Trigger | Duration | Loop |
|--------|---------|----------|------|
| Stagger reveal | Mount | 2.4s | No |
| Parallax drift | Scroll | Continuous | Scrub |
| Cell pulse | Idle | 3–7s per cell | Infinite |
| Sage glitch | Timer (12–20s) | 200ms | Infinite |

---

## 6. Performance Constraints

1. **No canvas fallback needed** — CSS grid + div animation is GPU-composited when using `opacity` and `transform` only
2. **Never animate `background-color` on 1000+ cells simultaneously** — use `opacity` changes instead; only animate `backgroundColor` on the small glitch subset (≤3 cells at a time)
3. **`will-change: opacity, transform`** on the background container, **not** on individual cells
4. **Reduce motion:** Always respect `prefers-reduced-motion`:
   ```css
   @media (prefers-reduced-motion: reduce) {
     .camo-bg { animation: none !important; opacity: 0.55 !important; }
   }
   ```
5. **Debounce resize:** Recalculate cell count on resize with a 300ms debounce; do not re-animate on resize
6. **Mobile cap:** On viewports < 768px, reduce cell count by 50% and disable the parallax drift

---

## 7. Usage Guidelines

### Where to use

| Surface | Use camo bg? | Variant |
|---------|-------------|---------|
| Marketing / hero | Yes | Full (GSAP + Framer Motion + glitch) |
| Product dashboards | Limited | Dim, static (opacity 0.3, no animation) |
| Doc pages | Subtle only | Static grid, no animation — do not distract readers |
| Modals / overlays | No | Use `--vln-bg` solid |
| Error pages (404, 500) | Yes | Glitch-heavy — increase glitch frequency to ~every 3s |

### Layering Order (z-index)

```
z-index: -1  → camo-bg (background canvas)
z-index:  0  → page content
z-index: 10  → navbar
z-index: 50  → modals, tooltips
```

### Do Not

- Do not place camo behind text without a `backdrop-blur` or semi-transparent overlay
- Do not use camo in email templates or social share previews (use OG images instead)
- Do not export camo as a static PNG — it must be generated at runtime

---

## 8. Asset References

| Asset | Location |
|-------|----------|
| Sample implementation | [`internal/qx7b2-sample-camo-impl`](./qx7b2-sample-camo-impl) |
| VLN color tokens | [`design-system/colors`](/design-system/colors) |
| VLN animations guide | [`design-system/animations`](/design-system/animations) |
| CSS variables (full) | `design-standards/src/css/custom.css` |
| OG image integration | `CLAUDE.md §Open Graph Image Integration` |

---

> **Classification:** Internal design spec
> **Audience:** VLN design engineers, frontend leads
> **Do not** link from public-facing navigation, sitemap, or search indexes.
