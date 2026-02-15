---
id: logo
title: VLN Logo Standards
sidebar_position: 1
description: Comprehensive guidelines for using the VLN logo with proper spacing, sizing, colors, and placement rules
---

# VLN Logo Standards

Official guidelines for using the VLN logo across all products, platforms, and marketing materials.

## Overview

The VLN logo is our primary brand identifier. Consistent usage ensures brand recognition and professionalism across all touchpoints. These standards apply to all VLN products, documentation, marketing materials, and third-party partnerships.

## Logo Variants

### Primary Logo

The primary VLN logo consists of:
- **Wordmark**: "VLN" in custom typography
- **Icon**: Signature brand mark (if applicable)
- **Lockup**: Combined wordmark + icon

### Available Formats

| Format | Use Case | File |
|--------|----------|------|
| **SVG** | Web, scalable graphics | `logo.svg` |
| **PNG (512×512)** | High-resolution, transparency | `logo.png` |
| **PNG (180×180)** | iOS app icon | `apple-touch-icon.png` |
| **ICO** | Browser favicon | `favicon.ico` |
| **WebP** | Modern web format | `logo.webp` |

### Color Variants

The logo is available in multiple color configurations:

#### On Dark Backgrounds (Primary)
- **Full Color**: Sage green (#86d993) accent with white text
- **Monochrome White**: All white (#f8f9fa) for maximum contrast
- **Sage Variant**: All sage green (#86d993)

```css
/* Primary logo on dark backgrounds */
.logo-primary {
  color: var(--vln-sage); /* #86d993 */
  background: var(--vln-bg); /* #0a0e0f */
}

.logo-white {
  color: var(--vln-white); /* #f8f9fa */
  background: var(--vln-bg); /* #0a0e0f */
}
```

#### On Light Backgrounds (Secondary)
- **Full Color**: Sage green accent with dark text
- **Monochrome Dark**: All dark (#0a0e0f) for contrast

```css
/* Logo on light backgrounds (use sparingly) */
.logo-dark {
  color: var(--vln-bg); /* #0a0e0f */
  background: #ffffff;
}
```

## Clear Space

Maintain minimum clear space around the logo to ensure visibility and impact.

### Clear Space Rules

**Minimum clear space = X**
- X = Height of the logo ÷ 2
- Apply X on all four sides (top, right, bottom, left)
- No text, graphics, or other elements within clear space
- Clear space scales proportionally with logo size

```
┌────────────────────────────────┐
│         ← X →                  │
│    ┌─────────────────┐    ↑    │
│  ↑ │                 │    X    │
│  X │   VLN LOGO      │    ↓    │
│  ↓ │                 │         │
│    └─────────────────┘         │
│         ← X →                  │
└────────────────────────────────┘
```

### Examples

✅ **Correct**: Adequate breathing room
```

     ╔═══════════════╗
     ║   VLN LOGO    ║
     ╚═══════════════╝

```

❌ **Incorrect**: Too cramped
```
Text ╔═══════════╗ Other
Here ║ VLN LOGO  ║ Content
     ╚═══════════╝
```

## Sizing Guidelines

### Minimum Sizes

To maintain legibility and brand integrity:

| Format | Minimum Width | Minimum Height |
|--------|---------------|----------------|
| **Digital/Web** | 120px | 32px |
| **Print** | 0.75 inches | 0.25 inches |
| **Mobile App Icons** | 180px | 180px |
| **Favicon** | 32px | 32px |

### Recommended Sizes

| Context | Size | Notes |
|---------|------|-------|
| **Website Header** | 160-200px wide | Ensure readability on mobile |
| **Email Signature** | 120-150px wide | Balance with text |
| **Social Media Profile** | 400×400px min | Platform specific |
| **Print Letterhead** | 1.5-2 inches wide | Top left or center |
| **Business Cards** | 1-1.25 inches wide | Proportional to card size |
| **Presentations** | 200-300px wide | Slide corners |

### Scaling

✅ **Always scale proportionally**
- Lock aspect ratio when resizing
- Use vector formats (SVG) when possible
- Never stretch or compress

❌ **Never distort**
```
Correct:  ╔═══╗    Wrong:  ╔═════════╗
          ║ V ║            ║    V    ║
          ║ L ║            ║    L    ║  ← Stretched
          ║ N ║            ║    N    ║
          ╚═══╝            ╚═════════╝

Correct:  ╔═══╗    Wrong:  ╔═╗
          ║ V ║            ║V║
          ║ L ║            ║L║  ← Compressed
          ║ N ║            ║N║
          ╚═══╝            ╚═╝
```

## Color Usage

### Approved Color Combinations

#### Dark Backgrounds (Recommended)

| Logo Color | Background | Contrast Ratio | Grade |
|------------|------------|----------------|-------|
| Sage (#86d993) | VLN Dark (#0a0e0f) | 8.2:1 | AAA ✅ |
| White (#f8f9fa) | VLN Dark (#0a0e0f) | 19.2:1 | AAA ✅ |
| Sky Blue (#7dd3fc) | VLN Dark (#0a0e0f) | 9.5:1 | AAA ✅ |
| Purple (#c084fc) | VLN Dark (#0a0e0f) | 7.8:1 | AAA ✅ |

#### Light Backgrounds (Use Sparingly)

| Logo Color | Background | Contrast Ratio | Grade |
|------------|------------|----------------|-------|
| VLN Dark (#0a0e0f) | White (#ffffff) | 19.2:1 | AAA ✅ |
| VLN Dark (#0a0e0f) | Light Gray (#f1f5f9) | 17.1:1 | AAA ✅ |

### Color Don'ts

❌ **Never use**:
- Arbitrary colors outside VLN palette
- Low-contrast combinations (< 4.5:1)
- Gradients on the logo itself
- Neon or fluorescent colors
- Multiple accent colors simultaneously

### VLN Brand Colors Reference

```css
/* Copy these exact values */
--vln-bg:           #0a0e0f   /* Matte Charcoal - primary background */
--vln-bg-light:     #151a1c   /* Cards, sections */
--vln-bg-lighter:   #1f2527   /* Hover states */
--vln-sage:         #86d993   /* Primary brand - CTAs, success */
--vln-blue:         #7dd3fc   /* Docs/API - technical content */
--vln-amber:        #fbbf24   /* Alerts, urgency */
--vln-purple:       #c084fc   /* Design system, premium */
--vln-white:        #f8f9fa   /* Primary text */
--vln-gray:         #cbd5e1   /* Secondary text */
```

See [Color System](/design-system/colors) for complete palette.

## Placement Guidelines

### Website Headers

**Recommended placement:**
- Top left (standard web convention)
- Centered (landing pages, marketing)
- Size: 160-200px wide, adjust for mobile

```html
<!-- Responsive header logo -->
<header className="bg-vln-bg border-b border-vln-bg-lighter">
  <img
    src="/logo.svg"
    alt="VLN Logo"
    className="h-12 w-auto"
  />
</header>
```

### Marketing Materials

**Print placement:**
- Top left corner or centered header
- Bottom right for subtle branding
- Consistent placement across material series

**Digital placement:**
- Hero sections: Large, centered
- Cards/thumbnails: Top left, 40-60px
- Footers: 100-120px wide

### Social Media

| Platform | Specs | Notes |
|----------|-------|-------|
| **Twitter/X Profile** | 400×400px | Use square logo variant |
| **LinkedIn Profile** | 400×400px | Minimum 300×300px |
| **Facebook Profile** | 180×180px | Displays at 170×170px |
| **Instagram Profile** | 320×320px | Minimum 110×110px |
| **YouTube Channel** | 800×800px | Displays at 98×98px |
| **Discord Server** | 512×512px | Minimum 128×128px |

## Usage Examples

### Web Implementation

```tsx
// Next.js Image component (recommended)
import Image from 'next/image';

function Header() {
  return (
    <header className="bg-vln-bg p-4">
      <Image
        src="/logo.svg"
        alt="VLN Logo"
        width={160}
        height={40}
        priority
      />
    </header>
  );
}
```

```html
<!-- Standard HTML -->
<img
  src="/logo.svg"
  alt="VLN Logo"
  width="160"
  height="40"
  loading="eager"
/>
```

### Email Signatures

```html
<table>
  <tr>
    <td>
      <img
        src="https://vln.gg/logo.png"
        alt="VLN"
        width="120"
        height="30"
        style="display:block;"
      />
    </td>
  </tr>
</table>
```

### Print (CSS)

```css
@media print {
  .logo {
    width: 1.5in;
    height: auto;
  }
}
```

## Accessibility

### Alt Text

Always include descriptive alt text:

✅ **Good alt text:**
- `alt="VLN Logo"`
- `alt="VLN - Vulnerability Lifecycle Network"`
- `alt="VLN Security Platform"`

❌ **Poor alt text:**
- `alt="logo"`
- `alt="image"`
- `alt=""` (unless purely decorative)

### Contrast Requirements

- Logo must meet WCAG AA minimum (4.5:1) for text
- Recommended: WCAG AAA (7:1) for enhanced accessibility
- All VLN logo variants meet AAA standards on dark backgrounds

### Focus Indicators

When logo is clickable (e.g., links to homepage):

```css
.logo-link:focus {
  outline: 2px solid var(--vln-sage);
  outline-offset: 4px;
  border-radius: 4px;
}
```

## Best Practices

### Do's ✅

- **Use official logo files** from approved repository
- **Maintain aspect ratio** when scaling
- **Provide adequate clear space** (minimum = logo height ÷ 2)
- **Use high-contrast backgrounds** (WCAG AAA compliant)
- **Use vector formats (SVG)** for scalability
- **Include alt text** for accessibility
- **Test on multiple devices** before publishing
- **Follow VLN color palette** exactly (#86d993 sage, etc.)

### Don'ts ❌

- **Don't distort or skew** the logo
- **Don't rotate** to angles other than 0°, 90°, 180°, 270°
- **Don't add effects** (shadows, outlines, glows) unless specified
- **Don't place on busy backgrounds** (photos, complex patterns)
- **Don't use unapproved colors** outside VLN palette
- **Don't recreate or modify** logo elements
- **Don't place inside shapes** (circles, squares) unless lockup variant
- **Don't use low-resolution raster** images when vector available
- **Don't animate** without brand team approval
- **Don't use old versions** of the logo

### Common Mistakes

❌ **Incorrect:**
```
1. Logo on complex photo background (poor contrast)
2. Stretched logo (wrong aspect ratio)
3. Logo in unapproved color (#00ff00)
4. Text too close to logo (no clear space)
5. Tiny logo (below 32px minimum)
6. Drop shadow added to logo
```

✅ **Correct:**
```
1. Logo on solid VLN dark background (#0a0e0f)
2. Proportionally scaled logo
3. Logo in VLN sage (#86d993) or white (#f8f9fa)
4. Adequate clear space (logo height ÷ 2)
5. Logo meets minimum 32px height
6. Clean logo without effects
```

## Download & Access

### Official Repository

All logo files available at:
- **GitHub**: [Fused-Gaming/DevOps/design-standards/static/img/](https://github.com/Fused-Gaming/DevOps/tree/main/design-standards/static/img/)
- **CDN**: `https://design.vln.gg/img/logo.svg`
- **NPM Package**: `@vln/design-assets` (coming soon)

### File Structure

```
design-standards/static/img/
├── logo.svg           # Primary vector logo
├── logo.png           # 512×512px raster
├── logo-white.svg     # White variant
├── logo-dark.svg      # Dark variant (for light backgrounds)
├── favicon.ico        # Browser favicon
├── apple-touch-icon.png  # iOS icon (180×180)
└── logo-square.svg    # Square variant (social media)
```

### Quick Links

- 📦 [Download all logo files (ZIP)](https://github.com/Fused-Gaming/DevOps/archive/refs/heads/main.zip)
- 🎨 [View in Figma](https://figma.com/vln-design-system) *(coming soon)*
- 🖼️ [View in Penpot](https://penpot.vln.gg) *(coming soon)*

## Third-Party Usage

### Partner/Affiliate Guidelines

When using the VLN logo in partnership materials:

1. **Get approval**: Contact brand@vln.gg for usage approval
2. **Follow these standards**: All guidelines apply
3. **Provide attribution**: "VLN is a trademark of Fused Gaming"
4. **Avoid implications**: Don't imply endorsement without agreement
5. **Use current logo**: Always use latest version from repository

### Press & Media

Media outlets may use the VLN logo in coverage:
- Editorial use permitted without prior approval
- Commercial use requires written permission
- Must follow sizing and clear space guidelines
- Download from official repository only

### Prohibited Uses

❌ **Never**:
- Use logo to suggest VLN endorsement without permission
- Sell or distribute logo files
- Incorporate logo into your company name or logo
- Use logo in misleading or illegal context
- Claim trademark or ownership of VLN logo

## Brand Compliance

### Review Process

Before publishing materials with VLN logo:

1. **Self-review** against this checklist:
   - [ ] Using official logo file from repository
   - [ ] Logo sized at or above minimum (32px height)
   - [ ] Clear space maintained (logo height ÷ 2)
   - [ ] Correct colors from VLN palette
   - [ ] High contrast background (WCAG AAA)
   - [ ] Aspect ratio locked, no distortion
   - [ ] Alt text included (for web)

2. **Request review** (for major campaigns):
   - Email: brand@vln.gg
   - Include: Mockups, usage context, distribution plan

### Reporting Violations

If you encounter misuse of the VLN logo:
- Report to: brand@vln.gg
- Include: Screenshots, URL, context
- We'll address promptly to protect brand integrity

## Related Resources

- **[Brand Assets](/branding/assets)** - Complete asset library
- **[Color System](/design-system/colors)** - VLN color palette & tokens
- **[Typography](/design-system/typography)** - Font pairing with logo
- **[Voice & Tone](/branding/voice-tone)** - Brand communication style
- **[Design Tools](/tools/design-tools)** - Tools for working with assets

## Questions?

**Need help?**
- 📧 Email: brand@vln.gg
- 💬 Discord: [VLN Community](https://discord.gg/vln)
- 📚 Docs: [design.vln.gg](https://design.vln.gg)

---

**Last Updated**: 2026-02-15
**Version**: 1.0.0
**Maintained by**: VLN Design Team / Fused Gaming
