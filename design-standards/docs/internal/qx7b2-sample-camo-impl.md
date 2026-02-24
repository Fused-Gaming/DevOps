---
title: VLN Camo BG — Sample Implementation
description: Annotated reference implementation of the VLN animated dark-green digital camouflage background component.
image: https://vln.gg/api/og?title=Camo%20BG%20Sample&subtitle=Reference%20Implementation&accent=blue&subdomain=docs
unlisted: true
hide_table_of_contents: false
pagination_next: null
pagination_prev: null
---

# VLN Camo BG — Sample Implementation

> **Internal document — not indexed.** Direct URL access only.
> Companion to [`qx7b2-bg-digital-camo`](./qx7b2-bg-digital-camo) · Spec version: `0x3-camo-bg`

Full annotated reference implementation of the VLN digital camouflage background component. Copy-paste ready, but read the inline comments before integrating.

---

## Prerequisites

Install required packages (add only what you need — see decision tree in the design spec):

```bash
# Core (required for the full reference impl)
pnpm add gsap framer-motion

# Optional — 3D hero variant only
pnpm add @react-three/fiber @react-three/drei three
```

---

## 1. Color Utility (`lib/camo-palette.ts`)

```ts
// lib/camo-palette.ts
// Weighted random color picker for the camo grid.
// Import this into the CamoBg component.

export const CAMO_PALETTE = [
  { color: '#000000', weight: 10 }, // void
  { color: '#0d1a0f', weight: 12 }, // shadow
  { color: '#004d00', weight: 38 }, // forest  ← primary mass
  { color: '#3b5323', weight: 28 }, // olive   ← secondary breakup
  { color: '#2d4a1e', weight: 10 }, // moss
  { color: '#4a7c59', weight: 2  }, // sage-dim
] as const;

export const CAMO_GLITCH_COLOR = '#86d993'; // VLN sage — glitch only

const TOTAL_WEIGHT = CAMO_PALETTE.reduce((s, c) => s + c.weight, 0);

export function pickCamoColor(): string {
  let rand = Math.random() * TOTAL_WEIGHT;
  for (const entry of CAMO_PALETTE) {
    if ((rand -= entry.weight) < 0) return entry.color;
  }
  return '#004d00';
}
```

---

## 2. Core Component (`components/CamoBg.tsx`)

```tsx
// components/CamoBg.tsx
// Primary animated camo background component.
// Uses GSAP for the reveal + glitch, Framer Motion for idle pulse.

'use client'; // Next.js / App Router — remove if using Vite

import React, { useEffect, useRef, useMemo, useCallback } from 'react';
import { motion, useReducedMotion } from 'framer-motion';
import { gsap } from 'gsap';
import { ScrollTrigger } from 'gsap/ScrollTrigger';
import { pickCamoColor, CAMO_GLITCH_COLOR } from '../lib/camo-palette';

gsap.registerPlugin(ScrollTrigger);

// ─── Types ──────────────────────────────────────────────────────────────────

interface CamoBgProps {
  /** Base opacity of the background layer. Default: 0.72 */
  opacity?: number;
  /** Enable scroll-based parallax drift. Default: true */
  parallax?: boolean;
  /** Enable sage green glitch pulses. Default: true */
  glitch?: boolean;
  /** CSS class for the wrapper div */
  className?: string;
}

interface Cell {
  id: number;
  color: string;
  pulseDuration: number;
  pulseDelay: number;
}

// ─── Constants ───────────────────────────────────────────────────────────────

const CELL_SIZE = 24; // px — matches --camo-cell-size at 1440px base
const GAP = 2;        // px — tight grid gap

// ─── Hooks ──────────────────────────────────────────────────────────────────

function useCellGrid(containerRef: React.RefObject<HTMLDivElement>): Cell[] {
  return useMemo(() => {
    // Server-side: use a safe default. Client will hydrate with actual count.
    if (typeof window === 'undefined') return buildCells(50, 30);

    // Overshoot 110% so parallax drift never shows a gap
    const cols = Math.ceil((window.innerWidth  * 1.1) / (CELL_SIZE + GAP));
    const rows = Math.ceil((window.innerHeight * 1.1) / (CELL_SIZE + GAP));
    return buildCells(cols, rows);
  }, []); // Intentionally empty — recalc handled by resize observer separately
}

function buildCells(cols: number, rows: number): Cell[] {
  const cells: Cell[] = [];
  for (let i = 0; i < cols * rows; i++) {
    cells.push({
      id: i,
      color: pickCamoColor(),
      pulseDuration: Math.random() * 4 + 3,  // 3–7s
      pulseDelay:    Math.random() * 8,       // 0–8s offset
    });
  }
  return cells;
}

// ─── Component ───────────────────────────────────────────────────────────────

export function CamoBg({
  opacity = 0.72,
  parallax = true,
  glitch = true,
  className = '',
}: CamoBgProps) {
  const containerRef   = useRef<HTMLDivElement>(null);
  const cellsRef       = useRef<HTMLDivElement[]>([]);
  const glitchTimerRef = useRef<ReturnType<typeof setTimeout> | null>(null);
  const prefersReduced = useReducedMotion();

  const cells = useCellGrid(containerRef);

  // ── 1. Stagger reveal on mount ──────────────────────────────────────────
  useEffect(() => {
    if (prefersReduced || cellsRef.current.length === 0) return;

    gsap.fromTo(
      cellsRef.current,
      { opacity: 0, scale: 0.85 },
      {
        opacity: opacity,
        scale: 1,
        duration: 0.6,
        stagger: {
          amount: 2.4,       // total stagger spread across all cells
          from: 'random',    // random order → organic reveal
          ease: 'power2.inOut',
        },
        ease: 'power2.out',
      }
    );
  }, [opacity, prefersReduced]);

  // ── 2. ScrollTrigger parallax drift ────────────────────────────────────
  useEffect(() => {
    if (!parallax || prefersReduced || !containerRef.current) return;

    const tween = gsap.to(containerRef.current, {
      y: '-15%',
      ease: 'none',
      scrollTrigger: {
        trigger: document.body,
        start: 'top top',
        end: 'bottom bottom',
        scrub: 1.5,
      },
    });

    return () => {
      tween.scrollTrigger?.kill();
      tween.kill();
    };
  }, [parallax, prefersReduced]);

  // ── 3. Sage glitch pulse ────────────────────────────────────────────────
  const triggerGlitch = useCallback(() => {
    if (!glitch || prefersReduced || cellsRef.current.length === 0) return;

    // Pick 2–3 random cells
    const pool    = [...cellsRef.current];
    const targets = Array.from({ length: Math.floor(Math.random() * 2) + 2 }, () => {
      const idx = Math.floor(Math.random() * pool.length);
      return pool.splice(idx, 1)[0];
    });

    const originals = targets.map((el) => el.style.backgroundColor);

    gsap.to(targets, {
      backgroundColor: CAMO_GLITCH_COLOR,
      duration: 0.08,
      yoyo: true,
      repeat: 3,
      ease: 'none',
      stagger: 0.04,
      onComplete: () => {
        gsap.to(targets, {
          backgroundColor: originals[0], // snap back to original (approx)
          duration: 0.3,
          ease: 'power1.out',
        });
      },
    });

    // Schedule next glitch: 12–20s
    glitchTimerRef.current = setTimeout(
      triggerGlitch,
      Math.random() * 8000 + 12000
    );
  }, [glitch, prefersReduced]);

  useEffect(() => {
    const firstDelay = Math.random() * 8000 + 12000;
    glitchTimerRef.current = setTimeout(triggerGlitch, firstDelay);
    return () => {
      if (glitchTimerRef.current) clearTimeout(glitchTimerRef.current);
    };
  }, [triggerGlitch]);

  // ── Render ──────────────────────────────────────────────────────────────
  return (
    <div
      ref={containerRef}
      className={`camo-bg-root ${className}`}
      aria-hidden="true"          // decorative — hide from screen readers
      style={{
        position: 'fixed',
        inset: 0,
        zIndex: -1,
        overflow: 'hidden',
        display: 'grid',
        gridTemplateColumns: `repeat(auto-fill, ${CELL_SIZE}px)`,
        gap: `${GAP}px`,
        width: '110%',
        height: '110%',
        top: '-5%',
        left: '-5%',
        pointerEvents: 'none',
        willChange: 'transform',  // GPU layer for parallax
      }}
    >
      {cells.map((cell, i) => (
        <motion.div
          key={cell.id}
          ref={(el) => { if (el) cellsRef.current[i] = el; }}
          style={{
            backgroundColor: cell.color,
            width:  CELL_SIZE,
            height: CELL_SIZE,
            borderRadius: 2,
            opacity: 0, // GSAP will animate this in
          }}
          // Framer Motion idle pulse — runs after GSAP reveal
          animate={prefersReduced ? {} : { opacity: [opacity, opacity * 0.6, opacity] }}
          transition={{
            duration:  cell.pulseDuration,
            delay:     cell.pulseDelay + 2.4, // wait for reveal to finish
            repeat:    Infinity,
            ease:      'easeInOut',
          }}
        />
      ))}
    </div>
  );
}

export default CamoBg;
```

---

## 3. Usage in a Page

### Next.js App Router (`app/page.tsx`)

```tsx
// app/page.tsx
import { CamoBg } from '@/components/CamoBg';

export default function HeroPage() {
  return (
    <>
      {/* Background sits behind everything at z-index: -1 */}
      <CamoBg opacity={0.72} parallax glitch />

      {/* Content layer needs a subtle overlay so text stays readable */}
      <main className="relative z-10 min-h-screen">
        {/* Optional overlay — semi-transparent to let camo bleed through */}
        <div className="absolute inset-0 bg-[#0a0e0f]/60 pointer-events-none" />

        <section className="relative z-10 flex flex-col items-center justify-center min-h-screen px-6 text-center">
          <h1 className="text-5xl font-bold text-[#f8f9fa] tracking-tight">
            VLN Platform
          </h1>
          <p className="mt-4 text-lg text-[#cbd5e1] max-w-xl">
            Tactical infrastructure. Engineered precision.
          </p>
        </section>
      </main>
    </>
  );
}
```

### Docusaurus (MDX Page)

```tsx
// src/pages/camo-demo.tsx  (Docusaurus custom page — not a doc)
import React from 'react';
import Layout from '@theme/Layout';
import { CamoBg } from '../components/CamoBg';

export default function CamoDemoPage() {
  return (
    <Layout title="Camo Demo" noFooter>
      <CamoBg opacity={0.6} parallax={false} glitch />
      <div style={{ position: 'relative', zIndex: 10, padding: '4rem 2rem' }}>
        <h1 style={{ color: '#f8f9fa' }}>Camo Background Demo</h1>
      </div>
    </Layout>
  );
}
```

---

## 4. Reduced-Motion Static Fallback

When `prefers-reduced-motion: reduce` is active, Framer Motion's `useReducedMotion()` disables all animation variants, and GSAP reveals are skipped. Add this CSS as a hard stop:

```css
/* design-standards/src/css/custom.css — append to existing file */

@media (prefers-reduced-motion: reduce) {
  .camo-bg-root {
    animation: none !important;
    transform: none !important;
    opacity: 0.55 !important;
  }
  .camo-bg-root > * {
    animation: none !important;
    transition: none !important;
  }
}
```

---

## 5. Mobile Optimization

On screens < 768px, reduce cell count by rendering at 2× cell size and disabling parallax:

```tsx
// In the page that renders CamoBg:
import { useMediaQuery } from '@/hooks/useMediaQuery'; // or a lib

function HeroSection() {
  const isMobile = useMediaQuery('(max-width: 767px)');

  return (
    <CamoBg
      opacity={isMobile ? 0.55 : 0.72}
      parallax={!isMobile}  // disable parallax on mobile
      glitch={!isMobile}    // optional — disable on mobile to save paint
    />
  );
}
```

---

## 6. Variant — Framer Motion Only (Lightweight)

For doc pages where GSAP is not already loaded, use this lighter variant that relies solely on Framer Motion:

```tsx
// components/CamoBgLite.tsx
// Framer Motion only — no GSAP dependency.
// Use for doc/blog pages. No parallax, no glitch.

'use client';

import React, { useMemo } from 'react';
import { motion, useReducedMotion } from 'framer-motion';
import { pickCamoColor } from '../lib/camo-palette';

const CELL = 28;
const GAP  = 2;

export function CamoBgLite({ opacity = 0.45 }: { opacity?: number }) {
  const prefersReduced = useReducedMotion();

  const cells = useMemo(() => {
    if (typeof window === 'undefined') return Array.from({ length: 600 }, (_, i) => i);
    const cols = Math.ceil((window.innerWidth  * 1.05) / (CELL + GAP));
    const rows = Math.ceil((window.innerHeight * 1.05) / (CELL + GAP));
    return Array.from({ length: cols * rows }, (_, i) => i);
  }, []);

  return (
    <div
      aria-hidden="true"
      style={{
        position: 'fixed', inset: 0, zIndex: -1, overflow: 'hidden',
        display: 'grid',
        gridTemplateColumns: `repeat(auto-fill, ${CELL}px)`,
        gap: `${GAP}px`,
        pointerEvents: 'none',
        opacity,
      }}
    >
      {cells.map((id) => {
        const color    = useMemo(pickCamoColor, []); // stable per cell
        const duration = 4 + Math.random() * 4;
        const delay    = Math.random() * 6;

        return (
          <motion.div
            key={id}
            style={{ backgroundColor: color, width: CELL, height: CELL, borderRadius: 2 }}
            animate={prefersReduced ? {} : { opacity: [1, 0.5, 1] }}
            transition={{ duration, delay, repeat: Infinity, ease: 'easeInOut' }}
          />
        );
      })}
    </div>
  );
}
```

---

## 7. Tailwind CSS Color Reference

When using Tailwind instead of inline styles, these classes most closely match the camo palette:

| Token | Hex | Tailwind Closest |
|-------|-----|-----------------|
| `--camo-void` | `#000000` | `bg-black` |
| `--camo-forest` | `#004d00` | `bg-green-950` (closest) |
| `--camo-olive` | `#3b5323` | `bg-green-900` / `bg-emerald-900` |
| `--camo-moss` | `#2d4a1e` | `bg-green-900` |
| `--camo-sage-dim` | `#4a7c59` | `bg-emerald-700` |

> Tailwind's built-in green shades top out around `#14532d` for `green-950`. For exact VLN camo values use `bg-[#004d00]` arbitrary value syntax.

```html
<!-- Tailwind arbitrary values for exact camo colors -->
<div class="bg-[#004d00]">forest</div>
<div class="bg-[#3b5323]">olive</div>
<div class="bg-[#2d4a1e]">moss</div>
```

---

## 8. Storybook Story (Optional)

```tsx
// stories/CamoBg.stories.tsx
import type { Meta, StoryObj } from '@storybook/react';
import { CamoBg } from '../components/CamoBg';

const meta: Meta<typeof CamoBg> = {
  title: 'Internal/CamoBg',
  component: CamoBg,
  parameters: { layout: 'fullscreen' },
};

export default meta;
type Story = StoryObj<typeof CamoBg>;

export const Default: Story = {
  args: { opacity: 0.72, parallax: true, glitch: true },
};

export const Subtle: Story = {
  args: { opacity: 0.35, parallax: false, glitch: false },
};

export const GlitchHeavy: Story = {
  // Simulates 404 error page variant
  args: { opacity: 0.72, parallax: false, glitch: true },
};
```

---

## 9. Checklist Before Shipping

- [ ] `pnpm build` passes — no type errors
- [ ] Tested with `prefers-reduced-motion: reduce` in DevTools → all animation stops
- [ ] Tested on iPhone SE (375px) — background renders, no perf jank
- [ ] Glitch pulse fires on a real device (not just emulator)
- [ ] No `--camo-sage` (`#86d993`) cells visible at rest — only during glitch
- [ ] `aria-hidden="true"` on root div — verified with accessibility tree
- [ ] `zIndex: -1` confirmed — content not obscured

---

> **Classification:** Internal reference implementation
> **Audience:** VLN design engineers, frontend leads
> **Related spec:** [`qx7b2-bg-digital-camo`](./qx7b2-bg-digital-camo)
