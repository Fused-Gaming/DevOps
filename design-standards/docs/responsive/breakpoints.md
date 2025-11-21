---
id: breakpoints
title: Responsive Breakpoints
sidebar_position: 1
---

# Responsive Breakpoints

VLN uses Tailwind CSS's default breakpoint system for responsive design. All designs should work seamlessly across devices.

## Breakpoint System

| Breakpoint | Min Width | Typical Devices | Prefix |
|------------|-----------|----------------|--------|
| **xs** | 0px | Small mobile (default) | (none) |
| **sm** | 640px | Mobile landscape | `sm:` |
| **md** | 768px | Tablets | `md:` |
| **lg** | 1024px | Laptops, small desktops | `lg:` |
| **xl** | 1280px | Desktops | `xl:` |
| **2xl** | 1536px | Large desktops, 4K | `2xl:` |

## Mobile-First Approach

VLN uses a **mobile-first** responsive design strategy. Start with mobile styles, then progressively enhance for larger screens.

```tsx
// ✅ Correct: Mobile first
<div className="p-4 md:p-8 lg:p-12">
  Content with increasing padding
</div>

// ❌ Wrong: Desktop first with overrides
<div className="p-12 lg:p-8 md:p-4">
  Don't do this!
</div>
```

## Common Patterns

### Responsive Grid

```tsx
// 1 column on mobile, 2 on tablet, 3 on desktop
<div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
  <Card />
  <Card />
  <Card />
</div>

// Auto-fit columns based on min-width
<div className="grid grid-cols-[repeat(auto-fit,minmax(300px,1fr))] gap-4">
  <Card />
  <Card />
  <Card />
</div>
```

### Responsive Padding/Margin

```tsx
// Increase spacing on larger screens
<section className="px-4 py-8 md:px-8 md:py-12 lg:px-16 lg:py-16">
  Content with responsive spacing
</section>
```

### Responsive Typography

```tsx
// Scale text size with viewport
<h1 className="text-3xl md:text-4xl lg:text-5xl xl:text-6xl">
  Responsive Heading
</h1>

<p className="text-base md:text-lg lg:text-xl">
  Body text that scales
</p>
```

### Responsive Flex Direction

```tsx
// Stack on mobile, row on desktop
<div className="flex flex-col md:flex-row gap-4">
  <div className="flex-1">Content 1</div>
  <div className="flex-1">Content 2</div>
</div>
```

### Hide/Show Elements

```tsx
{/* Mobile menu - show only on mobile */}
<div className="block md:hidden">
  <MobileMenu />
</div>

{/* Desktop nav - hide on mobile */}
<nav className="hidden md:block">
  <DesktopNav />
</nav>

{/* Show only on specific breakpoints */}
<div className="hidden lg:block xl:hidden">
  Only visible on large screens
</div>
```

## Real VLN Examples

### Dashboard Layout

```tsx
export function DashboardLayout({ children }) {
  return (
    <div className="min-h-screen bg-vln-bg">
      {/* Mobile: full width, Desktop: sidebar + content */}
      <div className="flex flex-col md:flex-row">
        {/* Sidebar */}
        <aside className="w-full md:w-64 lg:w-72 bg-vln-bg-light">
          <Sidebar />
        </aside>

        {/* Main content */}
        <main className="flex-1 p-4 md:p-6 lg:p-8">
          {children}
        </main>
      </div>
    </div>
  );
}
```

### Status Card Grid

```tsx
export function StatusGrid({ cards }) {
  return (
    <div className={cn(
      // Mobile: 1 column
      'grid grid-cols-1 gap-4',
      // Tablet: 2 columns
      'md:grid-cols-2 md:gap-6',
      // Desktop: 3 columns
      'lg:grid-cols-3 lg:gap-8'
    )}>
      {cards.map(card => (
        <StatusCard key={card.id} {...card} />
      ))}
    </div>
  );
}
```

### Responsive Button

```tsx
export function ResponsiveButton({ children }) {
  return (
    <button className={cn(
      // Mobile: full width
      'w-full px-4 py-3',
      // Tablet: auto width
      'md:w-auto md:px-6',
      // Desktop: larger padding
      'lg:px-8 lg:py-4',
      // Base styles
      'bg-vln-sage hover:bg-vln-sage-light',
      'rounded-vln font-medium transition-colors'
    )}>
      {children}
    </button>
  );
}
```

## Container Widths

Use max-width containers to prevent content from becoming too wide on large screens:

```tsx
// Standard container
<div className="container mx-auto px-4">
  Content
</div>

// Custom max widths
<div className="max-w-7xl mx-auto px-4">
  Wide content
</div>

<div className="max-w-4xl mx-auto px-4">
  Medium content (blog posts, articles)
</div>

<div className="max-w-prose mx-auto px-4">
  Optimal reading width (~65ch)
</div>
```

## Testing Breakpoints

### Browser DevTools

```javascript
// Chrome/Firefox DevTools
// Cmd/Ctrl + Shift + M: Toggle device mode

// Custom breakpoints for testing:
const testSizes = [
  { name: 'Mobile S', width: 375, height: 667 },   // iPhone SE
  { name: 'Mobile M', width: 390, height: 844 },   // iPhone 13
  { name: 'Mobile L', width: 428, height: 926 },   // iPhone 13 Pro Max
  { name: 'Tablet', width: 768, height: 1024 },    // iPad
  { name: 'Laptop', width: 1024, height: 768 },    // Small laptop
  { name: 'Desktop', width: 1920, height: 1080 },  // Full HD
  { name: '4K', width: 3840, height: 2160 },       // 4K display
];
```

### Responsively App

Free desktop app that shows multiple breakpoints simultaneously.

```bash
# Install
brew install --cask responsively  # macOS

# Or download from https://responsively.app
```

## Common Patterns

### Dashboard Stats

```tsx
// Mobile: stack, Desktop: grid
<div className={cn(
  'grid gap-4',
  'grid-cols-1',              // Mobile: 1 column
  'md:grid-cols-2',           // Tablet: 2 columns
  'lg:grid-cols-4'            // Desktop: 4 columns
)}>
  <StatCard title="Users" value="1,234" />
  <StatCard title="Revenue" value="$5,678" />
  <StatCard title="Orders" value="890" />
  <StatCard title="Growth" value="+12%" />
</div>
```

### Hero Section

```tsx
<section className={cn(
  'flex flex-col items-center text-center',
  'px-4 py-12',               // Mobile spacing
  'md:px-8 md:py-16',         // Tablet spacing
  'lg:px-16 lg:py-24'         // Desktop spacing
)}>
  <h1 className={cn(
    'font-bold mb-6',
    'text-4xl',                // Mobile
    'md:text-5xl',             // Tablet
    'lg:text-6xl'              // Desktop
  )}>
    Welcome to VLN
  </h1>

  <p className={cn(
    'text-gray-400 max-w-2xl mb-8',
    'text-base',               // Mobile
    'md:text-lg',              // Tablet
    'lg:text-xl'               // Desktop
  )}>
    Build amazing products with our design system
  </p>

  <button className={cn(
    'px-6 py-3',               // Mobile
    'md:px-8 md:py-4',         // Tablet+
    'bg-vln-sage rounded-vln'
  )}>
    Get Started
  </button>
</section>
```

## Best Practices

### ✅ Do

- Design mobile first
- Test on real devices
- Use semantic breakpoints (sm, md, lg)
- Maintain touch target size (44×44px minimum on mobile)
- Consider thumb-friendly zones on mobile
- Use responsive images with Next.js Image component
- Test at actual breakpoints, not arbitrary sizes

### ❌ Don't

- Don't design desktop-only
- Don't use fixed pixel widths for content
- Don't forget about landscape orientation
- Don't hide critical content on mobile
- Don't make buttons too small on touch devices
- Don't use hover-only interactions on mobile

## Touch Targets

Mobile devices require larger tap targets:

```tsx
// ✅ Good: 44×44px minimum
<button className="min-h-[44px] min-w-[44px] p-3">
  <Icon size={20} />
</button>

// ❌ Bad: Too small for fingers
<button className="p-1">
  <Icon size={12} />
</button>
```

## Responsive Images

```tsx
import Image from 'next/image';

// Responsive image with proper sizing
<Image
  src="/hero.png"
  alt="Hero image"
  width={1920}
  height={1080}
  sizes="(max-width: 768px) 100vw,
         (max-width: 1200px) 50vw,
         33vw"
  className="w-full h-auto"
  priority
/>
```

## Custom Breakpoints (If Needed)

```js
// tailwind.config.ts (don't change unless necessary)
module.exports = {
  theme: {
    screens: {
      'sm': '640px',
      'md': '768px',
      'lg': '1024px',
      'xl': '1280px',
      '2xl': '1536px',
      // Custom breakpoint (if needed)
      '3xl': '1920px',
    },
  },
};
```

## Related

- [Layouts](/responsive/layouts) - Common layout patterns
- [Testing](/responsive/testing) - Responsive testing guide
- [Mockup Workflow](/tools/mockup-workflow) - Multi-resolution mockups
