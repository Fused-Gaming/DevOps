---
id: mockup-workflow
title: Multi-Resolution Mockup Workflow
sidebar_position: 2
---

# Multi-Resolution Mockup Workflow

Complete workflow for creating, testing, and documenting designs across all device resolutions using open source tools.

## Overview

This workflow takes you from concept to production-ready mockups across multiple resolutions, using only free and open source tools.

## Workflow Steps

```
ASCII Wireframe (5 min)
         ↓
Penpot Design (30 min)
         ↓
Export Multi-Resolution (10 min)
         ↓
Development (varies)
         ↓
Responsive Testing (15 min)
         ↓
Screenshot Documentation (10 min)
```

## VLN Breakpoints

Our design system uses these breakpoints (Tailwind defaults):

| Breakpoint | Min Width | Device | Use Case |
|------------|-----------|--------|----------|
| **xs** | 0px | Mobile Small | iPhone SE, small Android |
| **sm** | 640px | Mobile | iPhone 13, standard mobile |
| **md** | 768px | Tablet | iPad, Android tablets |
| **lg** | 1024px | Laptop | MacBook, small laptops |
| **xl** | 1280px | Desktop | Standard desktop |
| **2xl** | 1536px | Large Desktop | 4K, large monitors |

## Step 1: ASCII Wireframe

**Time**: 5 minutes
**Tool**: Text editor or ASCIIFlow

Quick sketch of layout and structure.

```
Mobile:          Tablet:              Desktop:
┌──────────┐    ┌─────────────────┐  ┌────────────────────────┐
│  Header  │    │     Header      │  │       Header           │
├──────────┤    ├────┬────────────┤  ├───┬────────────────┬───┤
│          │    │ S  │            │  │ S │                │ S │
│ Content  │    │ I  │  Content   │  │ I │    Content     │ I │
│          │    │ D  │            │  │ D │                │ D │
│  Stack   │    │ E  │            │  │ E │                │ E │
│          │    │    │            │  │   │                │   │
├──────────┤    ├────┴────────────┤  ├───┴────────────────┴───┤
│  Footer  │    │     Footer      │  │       Footer           │
└──────────┘    └─────────────────┘  └────────────────────────┘
```

See [ASCII Design Guide](/tools/ascii-design) for detailed examples.

## Step 2: High-Fidelity Design in Penpot

**Time**: 30-60 minutes
**Tool**: Penpot (https://penpot.app)

### Setup Artboards

Create artboards for each breakpoint:

1. **Mobile**: 375 x 812px (iPhone 13)
2. **Tablet**: 768 x 1024px (iPad)
3. **Desktop**: 1920 x 1080px (Standard desktop)

### Use VLN Design Tokens

Import VLN colors as color palette:

```json
{
  "backgrounds": {
    "dark": "#0a0e0f",
    "light": "#151a1c",
    "lighter": "#1f2527"
  },
  "primary": {
    "sage": "#86d993",
    "sage-light": "#a8e9b4",
    "sage-dark": "#5fb76f"
  },
  "secondary": {
    "sky": "#7dd3fc",
    "sky-light": "#bae6fd",
    "sky-dark": "#0ea5e9"
  },
  "tertiary": {
    "amber": "#fbbf24",
    "amber-light": "#fcd34d",
    "amber-dark": "#f59e0b"
  },
  "premium": {
    "purple": "#c084fc",
    "purple-light": "#d8b4fe",
    "purple-dark": "#a855f7"
  }
}
```

### Typography

- **Headings**: Inter Bold (700)
- **Body**: Inter Regular (400)
- **Code**: JetBrains Mono (400)

### Spacing System

Use 8px grid:

```
4px  - Tiny spacing
8px  - XS spacing
12px - SM spacing
16px - MD spacing
24px - LG spacing
32px - XL spacing
48px - 2XL spacing
64px - 3XL spacing
```

### Export from Penpot

```
File → Export → PNG

Mobile:   375w × auto
Tablet:   768w × auto
Desktop:  1920w × auto

Export @2x for Retina displays
```

## Step 3: Development

**Time**: Varies
**Tool**: VS Code, Next.js, Tailwind CSS

### Component Structure

```tsx
// components/ui/responsive-section.tsx
import { cn } from '@/lib/utils';

interface ResponsiveSectionProps {
  children: React.ReactNode;
  className?: string;
}

export function ResponsiveSection({
  children,
  className
}: ResponsiveSectionProps) {
  return (
    <section
      className={cn(
        // Mobile first
        'px-4 py-8',
        // Tablet
        'md:px-8 md:py-12',
        // Desktop
        'lg:px-16 lg:py-16',
        // Large desktop
        'xl:px-24 xl:py-20',
        className
      )}
    >
      {children}
    </section>
  );
}
```

### Responsive Grid

```tsx
// Grid that adapts to screen size
<div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
  <Card />
  <Card />
  <Card />
</div>
```

### Responsive Typography

```tsx
<h1 className="text-3xl md:text-4xl lg:text-5xl xl:text-6xl font-bold">
  Responsive Heading
</h1>

<p className="text-base md:text-lg lg:text-xl">
  Body text that scales
</p>
```

### Hide/Show Elements

```tsx
{/* Show on mobile only */}
<div className="block md:hidden">
  Mobile Menu
</div>

{/* Hide on mobile */}
<div className="hidden md:block">
  Desktop Navigation
</div>

{/* Show on specific breakpoints */}
<div className="hidden lg:block xl:hidden">
  Only on large screens
</div>
```

## Step 4: Responsive Testing

**Time**: 15 minutes
**Tool**: Responsively App or Browser DevTools

### Using Responsively App

```bash
# Install
brew install --cask responsively  # macOS
# or download from https://responsively.app

# Start your dev server
cd devops-panel
pnpm dev

# Open in Responsively
# Add custom devices for VLN breakpoints
```

**Custom Devices**:
```json
[
  { "name": "Mobile", "width": 375, "height": 812 },
  { "name": "Tablet", "width": 768, "height": 1024 },
  { "name": "Laptop", "width": 1024, "height": 768 },
  { "name": "Desktop", "width": 1920, "height": 1080 }
]
```

### Using Browser DevTools

```javascript
// Chrome DevTools
// 1. Open DevTools (Cmd/Ctrl + Shift + I)
// 2. Toggle device toolbar (Cmd/Ctrl + Shift + M)
// 3. Select device or enter custom dimensions

// Keyboard shortcuts:
// Cmd/Ctrl + Shift + M: Toggle device mode
// Cmd/Ctrl + R: Reload
// Cmd/Ctrl + Shift + R: Hard reload
```

### Testing Checklist

- [ ] **Layout**: Does content flow properly?
- [ ] **Typography**: Is text readable at all sizes?
- [ ] **Images**: Do images scale correctly?
- [ ] **Navigation**: Is nav accessible on mobile?
- [ ] **Buttons**: Are CTAs easily tappable? (44×44px min)
- [ ] **Forms**: Are inputs large enough on mobile?
- [ ] **Spacing**: Is content not too cramped?
- [ ] **Overflow**: Is horizontal scroll prevented?
- [ ] **Performance**: Does it load quickly on mobile?

## Step 5: Screenshot Documentation

**Time**: 10 minutes
**Tool**: Browser DevTools or Responsively

### Capture All Resolutions

```bash
# Using Chrome DevTools
# 1. Open DevTools
# 2. Cmd/Ctrl + Shift + P
# 3. Type "screenshot"
# 4. Select "Capture full size screenshot"
# 5. Repeat for each breakpoint

# Using Responsively
# Click "Screenshot All" button
# Saves all viewports at once
```

### File Naming Convention

```
feature-name-mobile.png     # 375w
feature-name-tablet.png     # 768w
feature-name-desktop.png    # 1920w
feature-name-mobile@2x.png  # Retina versions
```

### Optimize Screenshots

```bash
# Install imagemagick
brew install imagemagick  # macOS
sudo apt install imagemagick  # Linux

# Optimize PNG (lossless)
convert input.png -strip -quality 95 output.png

# Resize if needed
convert input.png -resize 1200x output.png

# Convert to WebP (better compression)
cwebp -q 90 input.png -o output.webp
```

## Step 6: Documentation

Add screenshots to your PR or documentation:

```markdown
## Responsive Preview

### Mobile (375px)
<!-- Screenshot: feature-mobile.png -->
_Add screenshot here after implementation_

### Tablet (768px)
<!-- Screenshot: feature-tablet.png -->
_Add screenshot here after implementation_

### Desktop (1920px)
<!-- Screenshot: feature-desktop.png -->
_Add screenshot here after implementation_

## Testing Notes

- ✅ Tested on iPhone 13
- ✅ Tested on iPad Pro
- ✅ Tested on Chrome desktop
- ✅ All interactions working
- ✅ Passes WCAG AA contrast
```

## Complete Example Workflow

### Real-World: Dashboard Status Card

#### 1. ASCII Wireframe (5 min)

```
Mobile:              Desktop:
┌─────────────┐     ┌───────────────────────────┐
│ 🚀 Prod     │     │ 🚀 Production      [ ⋮ ]  │
│ Live        │     │ Status: Live              │
│ ─────── 100%│     │ Last: 2h ago              │
└─────────────┘     │ ──────────────── 100%     │
                    │ [Details] [Logs]          │
                    └───────────────────────────┘
```

#### 2. Penpot Design (30 min)

Create 3 artboards:
- 375px: Single column card
- 768px: Wider card with more details
- 1920px: Full-width with all actions

Apply VLN colors:
- Background: `#1f2527`
- Text: `#ffffff`
- Accent: `#86d993` (sage green)
- Progress bar: `#86d993`

#### 3. Development (1 hour)

```tsx
// components/devops/status-card.tsx
export function StatusCard({ status, title, lastDeploy }) {
  return (
    <motion.div
      className={cn(
        // Base styles
        'bg-vln-bg-lighter rounded-vln p-4',
        // Responsive padding
        'md:p-6 lg:p-8',
        // Glow effect
        'glow-lift'
      )}
      whileHover={{ y: -4 }}
    >
      {/* Header */}
      <div className="flex items-center justify-between mb-4">
        <div className="flex items-center gap-3">
          <Rocket className="text-vln-sage" size={24} />
          <h3 className="text-lg md:text-xl font-semibold">{title}</h3>
        </div>
        {/* Hide menu on mobile, show on tablet+ */}
        <button className="hidden md:block">
          <MoreVertical size={20} />
        </button>
      </div>

      {/* Status */}
      <p className="text-vln-sage mb-2">{status}</p>
      <p className="text-sm text-gray-400 mb-4">Last deploy: {lastDeploy}</p>

      {/* Progress bar */}
      <div className="w-full bg-vln-bg h-2 rounded-full mb-4">
        <div className="bg-vln-sage h-2 rounded-full" style={{ width: '100%' }} />
      </div>

      {/* Actions - stack on mobile, row on desktop */}
      <div className="flex flex-col md:flex-row gap-2">
        <button className="btn-primary flex-1">Details</button>
        <button className="btn-secondary flex-1 hidden md:block">Logs</button>
      </div>
    </motion.div>
  );
}
```

#### 4. Test in Responsively (15 min)

- Open all viewports
- Verify layout adapts correctly
- Check touch targets on mobile (44×44px)
- Test interactions
- Take screenshots

#### 5. Document (10 min)

```markdown
## Status Card Component

### Preview

| Mobile | Tablet | Desktop |
|--------|--------|---------|
| ![Mobile](screenshots/status-card-mobile.png) | ![Tablet](screenshots/status-card-tablet.png) | ![Desktop](screenshots/status-card-desktop.png) |

### Responsive Behavior

- **Mobile**: Single column, essential info only
- **Tablet**: Expanded with secondary actions
- **Desktop**: Full width with all features

### Props

\`\`\`tsx
interface StatusCardProps {
  status: string;
  title: string;
  lastDeploy: string;
  progress: number;
}
\`\`\`
```

## Tips & Tricks

### 1. Start Mobile-First

Always design and code mobile first, then enhance for larger screens:

```tsx
// ✅ Good: Mobile first
className="text-base md:text-lg lg:text-xl"

// ❌ Bad: Desktop first with overrides
className="text-xl lg:text-lg md:text-base"
```

### 2. Use Container Queries (Future)

```tsx
// When browser support improves
<div className="@container">
  <div className="@lg:grid-cols-2">
    {/* Responds to container size, not viewport */}
  </div>
</div>
```

### 3. Test on Real Devices

Simulators are good, but real devices reveal:
- Touch target issues
- Performance problems
- Font rendering
- Actual user experience

### 4. Use Responsive Images

```tsx
import Image from 'next/image';

<Image
  src="/hero.png"
  alt="Hero image"
  width={1920}
  height={1080}
  sizes="(max-width: 768px) 100vw, (max-width: 1200px) 50vw, 33vw"
  priority
/>
```

### 5. Optimize for Touch

```tsx
// Minimum touch target: 44×44px
<button className="min-h-[44px] min-w-[44px] p-3">
  <Icon size={20} />
</button>
```

## Tools Summary

| Purpose | Tool | Cost | Why |
|---------|------|------|-----|
| Wireframe | ASCIIFlow | Free | Fast, version-controllable |
| Design | Penpot | Free | Open source Figma alternative |
| Dev | VS Code + Tailwind | Free | Industry standard |
| Testing | Responsively App | Free | Multi-device preview |
| Screenshots | Browser DevTools | Free | Built-in |
| Optimization | ImageMagick | Free | Powerful CLI tool |

## Next Steps

- [Responsive Design Breakpoints](/responsive/breakpoints) - Detailed breakpoint guide
- [Component Development](/tools/component-development) - Build responsive components
- [Testing Guide](/tools/testing) - Comprehensive testing strategies

## Resources

- [Responsively App](https://responsively.app) - Multi-device testing
- [Penpot](https://penpot.app) - Open source design tool
- [Tailwind Responsive Design](https://tailwindcss.com/docs/responsive-design) - Official docs
- [Next.js Image Optimization](https://nextjs.org/docs/basic-features/image-optimization) - Performance
