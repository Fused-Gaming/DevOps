---
id: spacing
title: Spacing
sidebar_position: 3
---

# Spacing

VLN uses an 8px grid system for consistent spacing throughout the design system.

## Spacing Scale

| Token | Value | Tailwind | Usage |
|-------|-------|----------|-------|
| **0** | 0px | `p-0`, `m-0` | No spacing |
| **1** | 4px | `p-1`, `m-1` | Tiny spacing |
| **2** | 8px | `p-2`, `m-2` | XS spacing |
| **3** | 12px | `p-3`, `m-3` | SM spacing |
| **4** | 16px | `p-4`, `m-4` | MD spacing (default) |
| **6** | 24px | `p-6`, `m-6` | LG spacing |
| **8** | 32px | `p-8`, `m-8` | XL spacing |
| **12** | 48px | `p-12`, `m-12` | 2XL spacing |
| **16** | 64px | `p-16`, `m-16` | 3XL spacing |

## Component Spacing

```tsx
// Card padding
<div className="p-6 md:p-8">Card content</div>

// Section spacing
<section className="py-12 md:py-16 lg:py-20">Section</section>

// Gap between elements
<div className="flex gap-4">Items with 16px gap</div>
```

See [Tailwind Spacing Docs](https://tailwindcss.com/docs/customizing-spacing) for more details.
