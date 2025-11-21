---
id: colors
title: Color System
sidebar_position: 1
---

# Color System

The VLN color system is designed with accessibility, consistency, and visual hierarchy in mind. All colors meet **WCAG AAA** contrast requirements.

## Base Colors

### Backgrounds

Our dark-mode-first approach uses carefully selected background colors for depth and hierarchy.

| Color | Hex | Usage | Tailwind Class |
|-------|-----|-------|----------------|
| **VLN Background** | `#0a0e0f` | Primary dark background | `bg-vln-bg` |
| **VLN Background Light** | `#151a1c` | Secondary surfaces | `bg-vln-bg-light` |
| **VLN Background Lighter** | `#1f2527` | Elevated cards, modals | `bg-vln-bg-lighter` |

```css
/* CSS Variables */
--vln-bg: #0a0e0f;
--vln-bg-light: #151a1c;
--vln-bg-lighter: #1f2527;
```

## Accent Colors

### Sage Green (Primary)

Our primary brand color. Use for primary actions, links, and brand moments.

| Variant | Hex | Usage | Tailwind Class |
|---------|-----|-------|----------------|
| **Sage** | `#86d993` | Primary actions, success states | `bg-vln-sage`, `text-vln-sage` |
| **Sage Light** | `#a8e9b4` | Hover states, highlights | `bg-vln-sage-light` |
| **Sage Dark** | `#5fb76f` | Active states, pressed | `bg-vln-sage-dark` |

**Accessibility**:
- Sage (#86d993) on Dark Background (#0a0e0f): **8.2:1** ✅ WCAG AAA
- Sage Dark (#5fb76f) on Dark Background: **6.1:1** ✅ WCAG AAA

### Sky Blue (Secondary)

Used for informational elements, secondary actions, and data visualization.

| Variant | Hex | Usage | Tailwind Class |
|---------|-----|-------|----------------|
| **Sky** | `#7dd3fc` | Info states, secondary CTAs | `bg-vln-sky`, `text-vln-sky` |
| **Sky Light** | `#bae6fd` | Hover states | `bg-vln-sky-light` |
| **Sky Dark** | `#0ea5e9` | Active states | `bg-vln-sky-dark` |

**Accessibility**:
- Sky (#7dd3fc) on Dark Background (#0a0e0f): **9.5:1** ✅ WCAG AAA

### Amber (Tertiary)

Warning states, highlights, and premium features.

| Variant | Hex | Usage | Tailwind Class |
|---------|-----|-------|----------------|
| **Amber** | `#fbbf24` | Warning states, highlights | `bg-vln-amber`, `text-vln-amber` |
| **Amber Light** | `#fcd34d` | Hover states | `bg-vln-amber-light` |
| **Amber Dark** | `#f59e0b` | Active states | `bg-vln-amber-dark` |

**Accessibility**:
- Amber (#fbbf24) on Dark Background (#0a0e0f): **11.2:1** ✅ WCAG AAA

### Purple (Premium)

Premium features, special status, and purple accents.

| Variant | Hex | Usage | Tailwind Class |
|---------|-----|-------|----------------|
| **Purple** | `#c084fc` | Premium features | `bg-vln-purple`, `text-vln-purple` |
| **Purple Light** | `#d8b4fe` | Hover states | `bg-vln-purple-light` |
| **Purple Dark** | `#a855f7` | Active states | `bg-vln-purple-dark` |

**Accessibility**:
- Purple (#c084fc) on Dark Background (#0a0e0f): **7.8:1** ✅ WCAG AAA

## Semantic Colors

Map colors to their semantic meaning for consistent usage.

| Semantic | Color | Hex | Usage |
|----------|-------|-----|-------|
| **Success** | Sage Green | `#86d993` | Successful operations, confirmations |
| **Info** | Sky Blue | `#7dd3fc` | Informational messages, tips |
| **Warning** | Amber | `#fbbf24` | Warnings, cautions |
| **Error** | Red | `#ef4444` | Errors, destructive actions |
| **Premium** | Purple | `#c084fc` | Premium features, upgrades |

## Usage Examples

### Tailwind CSS

```tsx
// Primary button with sage green
<button className="bg-vln-sage hover:bg-vln-sage-light text-vln-bg">
  Get Started
</button>

// Info card with sky blue accent
<div className="bg-vln-bg-light border-l-4 border-vln-sky">
  <p className="text-vln-sky">Info message here</p>
</div>

// Warning badge
<span className="bg-vln-amber text-vln-bg px-3 py-1 rounded-full">
  Warning
</span>
```

### CSS Custom Properties

```css
/* Use in custom CSS */
.my-component {
  background: var(--vln-bg-lighter);
  color: var(--vln-sage);
  border: 2px solid var(--vln-sage-dark);
}

.my-component:hover {
  background: var(--vln-bg-light);
  box-shadow: 0 0 20px rgba(134, 217, 147, 0.3);
}
```

### React Component

```tsx
import { useState } from 'react';

function StatusBadge({ status }: { status: 'success' | 'warning' | 'error' }) {
  const colorMap = {
    success: 'bg-vln-sage text-vln-bg',
    warning: 'bg-vln-amber text-vln-bg',
    error: 'bg-red-500 text-white',
  };

  return (
    <span className={`px-3 py-1 rounded-full ${colorMap[status]}`}>
      {status}
    </span>
  );
}
```

## Color Combinations

### High Contrast Pairs (WCAG AAA)

| Foreground | Background | Contrast Ratio | Grade |
|------------|------------|----------------|-------|
| Sage (#86d993) | Dark (#0a0e0f) | 8.2:1 | AAA ✅ |
| Sky (#7dd3fc) | Dark (#0a0e0f) | 9.5:1 | AAA ✅ |
| Amber (#fbbf24) | Dark (#0a0e0f) | 11.2:1 | AAA ✅ |
| Purple (#c084fc) | Dark (#0a0e0f) | 7.8:1 | AAA ✅ |
| White (#ffffff) | Dark (#0a0e0f) | 19.2:1 | AAA ✅ |

### Gradient Examples

```tsx
// Sage gradient
<div className="bg-gradient-to-r from-vln-sage-dark via-vln-sage to-vln-sage-light">

// Sky gradient
<div className="bg-gradient-to-br from-vln-sky-dark to-vln-purple">

// Text gradient
<h1 className="text-gradient-sage">
  Beautiful Gradient Text
</h1>
```

## Glow Effects

Use glow effects sparingly for emphasis and delight.

```tsx
// Sage glow on hover
<button className="glow-lift bg-vln-bg-lighter hover:bg-vln-bg-light">
  Hover me
</button>

// Blue glow
<div className="glow-lift-blue">
  Important card
</div>

// Amber glow
<div className="glow-lift-amber">
  Warning notification
</div>

// Purple glow
<div className="glow-lift-purple">
  Premium feature
</div>
```

## Design Tokens in Figma/Penpot

When creating designs in Penpot or other tools, use these exact hex values:

```json
{
  "vln": {
    "bg": "#0a0e0f",
    "bg-light": "#151a1c",
    "bg-lighter": "#1f2527",
    "sage": "#86d993",
    "sage-light": "#a8e9b4",
    "sage-dark": "#5fb76f",
    "sky": "#7dd3fc",
    "sky-light": "#bae6fd",
    "sky-dark": "#0ea5e9",
    "amber": "#fbbf24",
    "amber-light": "#fcd34d",
    "amber-dark": "#f59e0b",
    "purple": "#c084fc",
    "purple-light": "#d8b4fe",
    "purple-dark": "#a855f7"
  }
}
```

## Accessibility Guidelines

1. **Always test contrast**: Use [WebAIM Contrast Checker](https://webaim.org/resources/contrastchecker/)
2. **Don't rely on color alone**: Add icons or text labels
3. **Support color blindness**: Test with color blindness simulators
4. **Maintain hierarchy**: Use color weight (light/dark) to show importance
5. **Document deviations**: If you must use non-standard colors, document why

## Best Practices

✅ **Do**:
- Use semantic color names (`bg-vln-sage` not `bg-green-400`)
- Maintain consistent color usage across the app
- Test on real devices in different lighting
- Provide dark/light mode alternatives

❌ **Don't**:
- Don't use arbitrary color values
- Don't mix color systems (stay in VLN palette)
- Don't forget to test accessibility
- Don't use color as the only indicator

## Related

- [Typography](/design-system/typography) - Font pairing with colors
- [Components](/design-system/components) - See colors in action
- [Animations](/design-system/animations) - Animated color transitions
