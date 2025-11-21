---
id: typography
title: Typography
sidebar_position: 2
---

# Typography

VLN uses a modern, readable typography system with Inter for UI and JetBrains Mono for code.

## Font Families

### Inter (Primary)

**Usage**: UI, headings, body text, buttons, navigation

- **Weights**: 400 (Regular), 500 (Medium), 600 (Semi-Bold), 700 (Bold)
- **License**: SIL Open Font License
- **Source**: Google Fonts

```css
font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
```

### JetBrains Mono (Code)

**Usage**: Code blocks, code snippets, monospaced data

- **Weights**: 400 (Regular), 500 (Medium)
- **License**: SIL Open Font License
- **Source**: Google Fonts

```css
font-family: 'JetBrains Mono', 'Courier New', monospace;
```

## Type Scale

### Desktop Scale

| Style | Size | Weight | Line Height | Usage |
|-------|------|--------|-------------|-------|
| **H1** | 60px (3.75rem) | 700 | 1.2 | Page titles |
| **H2** | 48px (3rem) | 700 | 1.25 | Section headers |
| **H3** | 36px (2.25rem) | 600 | 1.3 | Subsection headers |
| **H4** | 24px (1.5rem) | 600 | 1.4 | Card titles |
| **H5** | 20px (1.25rem) | 600 | 1.5 | Small headings |
| **H6** | 18px (1.125rem) | 600 | 1.5 | Tiny headings |
| **Body Large** | 18px (1.125rem) | 400 | 1.6 | Intro paragraphs |
| **Body** | 16px (1rem) | 400 | 1.6 | Default text |
| **Body Small** | 14px (0.875rem) | 400 | 1.5 | Secondary text |
| **Caption** | 12px (0.75rem) | 400 | 1.4 | Labels, captions |
| **Code** | 14px (0.875rem) | 400 | 1.5 | Code blocks |

### Mobile Scale

On mobile devices (< 768px), scale down by 0.75x:

| Style | Mobile Size | Desktop Size |
|-------|-------------|--------------|
| **H1** | 45px | 60px |
| **H2** | 36px | 48px |
| **H3** | 27px | 36px |
| **H4** | 21px | 24px |
| **Body** | 16px | 16px |

## Tailwind Classes

```tsx
// Headings
<h1 className="text-5xl md:text-6xl font-bold">H1 Heading</h1>
<h2 className="text-4xl md:text-5xl font-bold">H2 Heading</h2>
<h3 className="text-3xl md:text-4xl font-semibold">H3 Heading</h3>
<h4 className="text-2xl font-semibold">H4 Heading</h4>
<h5 className="text-xl font-semibold">H5 Heading</h5>
<h6 className="text-lg font-semibold">H6 Heading</h6>

// Body text
<p className="text-lg">Large body text</p>
<p className="text-base">Default body text</p>
<p className="text-sm">Small body text</p>
<p className="text-xs">Caption text</p>

// Code
<code className="font-mono text-sm">inline code</code>
```

## Usage Examples

### Hero Section

```tsx
<section className="py-20">
  <h1 className="text-5xl md:text-6xl font-bold mb-6">
    VLN Design System
  </h1>
  <p className="text-lg md:text-xl text-gray-400 max-w-2xl">
    Build beautiful, accessible interfaces with our design standards
  </p>
</section>
```

### Card Title

```tsx
<div className="bg-vln-bg-lighter p-6 rounded-vln">
  <h4 className="text-2xl font-semibold mb-2">Card Title</h4>
  <p className="text-sm text-gray-400 mb-4">Subtitle or description</p>
  <p className="text-base">Body content goes here...</p>
</div>
```

### Code Block

```tsx
<pre className="bg-vln-bg p-4 rounded-lg overflow-x-auto">
  <code className="font-mono text-sm text-vln-sage">
    npm install @vln/components
  </code>
</pre>
```

## Text Colors

```tsx
// Primary text
<p className="text-white">Primary text</p>

// Secondary text
<p className="text-gray-300">Secondary text</p>

// Muted text
<p className="text-gray-400">Muted text</p>

// Disabled text
<p className="text-gray-600">Disabled text</p>

// Accent colors
<p className="text-vln-sage">Success text</p>
<p className="text-vln-sky">Info text</p>
<p className="text-vln-amber">Warning text</p>
<p className="text-red-500">Error text</p>
```

## Text Alignment

```tsx
<p className="text-left">Left aligned (default)</p>
<p className="text-center">Center aligned</p>
<p className="text-right">Right aligned</p>
<p className="text-justify">Justified text</p>
```

## Text Truncation

```tsx
// Single line truncate
<p className="truncate">Very long text that will be cut off...</p>

// Multi-line clamp
<p className="line-clamp-2">
  Long text that will be truncated after two lines with ellipsis...
</p>

<p className="line-clamp-3">
  Even longer content that will show three lines maximum...
</p>
```

## Best Practices

### ✅ Do

- Use Inter for all UI text
- Use JetBrains Mono for code
- Maintain consistent line heights
- Use responsive text sizes
- Ensure sufficient contrast (WCAG AAA)
- Limit line length to 60-80 characters

### ❌ Don't

- Mix too many font sizes on one page
- Use font sizes below 12px
- Ignore responsive scaling
- Use poor contrast ratios
- Create walls of text without breaks

## Accessibility

### Contrast Ratios

All text must meet WCAG AAA standards:

- **Normal text**: 7:1 minimum
- **Large text** (18px+): 4.5:1 minimum

### Tested Combinations

| Text Color | Background | Ratio | Grade |
|------------|------------|-------|-------|
| White | Dark (#0a0e0f) | 19.2:1 | AAA ✅ |
| Sage | Dark (#0a0e0f) | 8.2:1 | AAA ✅ |
| Sky | Dark (#0a0e0f) | 9.5:1 | AAA ✅ |
| Amber | Dark (#0a0e0f) | 11.2:1 | AAA ✅ |
| Gray-300 | Dark (#0a0e0f) | 12.6:1 | AAA ✅ |

### Readable Text

```tsx
// Maximum line length for readability
<p className="max-w-prose">
  Content with optimal line length for reading comfort...
</p>

// Adequate line spacing
<p className="leading-relaxed">
  Text with comfortable line height for extended reading...
</p>
```

## Loading Fonts

### Next.js (Recommended)

```tsx
// app/layout.tsx
import { Inter, JetBrains_Mono } from 'next/font/google';

const inter = Inter({
  subsets: ['latin'],
  weight: ['400', '500', '600', '700'],
  variable: '--font-inter',
});

const jetbrainsMono = JetBrains_Mono({
  subsets: ['latin'],
  weight: ['400', '500'],
  variable: '--font-jetbrains-mono',
});

export default function RootLayout({ children }) {
  return (
    <html lang="en" className={`${inter.variable} ${jetbrainsMono.variable}`}>
      <body className="font-sans">{children}</body>
    </html>
  );
}
```

### Tailwind Config

```js
// tailwind.config.ts
module.exports = {
  theme: {
    extend: {
      fontFamily: {
        sans: ['var(--font-inter)', 'Inter', 'sans-serif'],
        mono: ['var(--font-jetbrains-mono)', 'JetBrains Mono', 'monospace'],
      },
    },
  },
};
```

### CSS Import (Alternative)

```css
@import url('https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=JetBrains+Mono:wght@400;500&display=swap');

:root {
  --font-inter: 'Inter', sans-serif;
  --font-jetbrains-mono: 'JetBrains Mono', monospace;
}

body {
  font-family: var(--font-inter);
}

code, pre {
  font-family: var(--font-jetbrains-mono);
}
```

## Related

- [Colors](/design-system/colors) - Color system
- [Components](/design-system/components) - Typography in components
- [Spacing](/design-system/spacing) - Layout spacing
