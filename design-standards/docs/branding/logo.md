---
id: logo
title: Logo Standards
sidebar_position: 1
image: https://vln.gg/api/og?title=Logo%20Standards&subtitle=VLN%20Brand%20Identity&accent=purple&subdomain=design
---

# Logo Standards

The VLN logo is a shield mark with an integrated chevron accent and wordmark. It represents security, structure, and technical precision. All variants use VLN brand tokens — never substitute colors or fonts.

---

## Logo Anatomy

The logo consists of two primary elements:

1. **Shield Mark** — the standalone icon used for compact contexts (navbar, favicon, app icons)
2. **Full Lockup** — shield mark paired with the wordmark and tagline

### Shield Mark Structure

```
┌─────────────────────────┐
│      ╱ chevron ╲        │  ← Accent chevron (#86d993)
│     ╱           ╲       │
│                         │
│        V L N            │  ← Brand text, Inter 700
│                         │
│     ╲           ╱       │
│      ╲─────────╱        │  ← Shield base
└─────────────────────────┘
```

- **Shield path**: Geometric shield with straight top edges tapering to a pointed base
- **Chevron**: Open upward-facing accent line above the wordmark (`stroke-linecap: round`)
- **VLN text**: Centered, Inter bold, `letter-spacing: 2`

---

## Logo Variants

### Dark Mode (Primary)

The dark mode logo is the **primary** variant. VLN defaults to dark mode.

```svg
<!-- Shield: #0a0e0f fill, #86d993 stroke -->
<!-- Chevron: #86d993 stroke -->
<!-- VLN text: #86d993 fill -->
<!-- Wordmark: #f8f9fa fill -->
<!-- Tagline: #cbd5e1 fill -->
```

| Element | Color | Token |
|---------|-------|-------|
| Shield fill | `#0a0e0f` | `--vln-bg` |
| Shield stroke | `#86d993` | `--vln-sage` |
| Chevron accent | `#86d993` | `--vln-sage` |
| VLN shield text | `#86d993` | `--vln-sage` |
| Wordmark | `#f8f9fa` | `--vln-white` |
| Tagline | `#cbd5e1` | `--vln-gray` |

**Dark mode shield mark:**

<div style={{background: '#0a0e0f', padding: '32px', borderRadius: '12px', textAlign: 'center', border: '1px solid rgba(134, 217, 147, 0.2)'}}>
  <img src="/img/logo.svg" alt="VLN Shield — Dark Mode" width="100" />
</div>

**Dark mode full lockup:**

<div style={{background: '#0a0e0f', padding: '32px', borderRadius: '12px', textAlign: 'center', border: '1px solid rgba(134, 217, 147, 0.2)'}}>
  <img src="/img/vln-logo-full-dark.svg" alt="VLN Full Logo — Dark Mode" width="480" />
</div>

### Light Mode

The light mode variant uses a dark shield fill without an outline stroke, maintaining brand presence on light backgrounds.

```svg
<!-- Shield: #151a1c fill, no stroke -->
<!-- Chevron: #86d993 stroke -->
<!-- VLN text: #f8f9fa fill -->
<!-- Wordmark: #0a0e0f fill -->
<!-- Tagline: #94a3b8 fill -->
```

| Element | Color | Token |
|---------|-------|-------|
| Shield fill | `#151a1c` | `--vln-bg-light` |
| Shield stroke | none | — |
| Chevron accent | `#86d993` | `--vln-sage` |
| VLN shield text | `#f8f9fa` | `--vln-white` |
| Wordmark | `#0a0e0f` | `--vln-bg` |
| Tagline | `#94a3b8` | `--vln-gray-dark` |

**Light mode shield mark:**

<div style={{background: '#ffffff', padding: '32px', borderRadius: '12px', textAlign: 'center', border: '1px solid #e2e8f0'}}>
  <img src="/img/logo-light.svg" alt="VLN Shield — Light Mode" width="100" />
</div>

**Light mode full lockup:**

<div style={{background: '#ffffff', padding: '32px', borderRadius: '12px', textAlign: 'center', border: '1px solid #e2e8f0'}}>
  <img src="/img/vln-logo-full-light.svg" alt="VLN Full Logo — Light Mode" width="480" />
</div>

---

## Logo Files

All logo assets live in `static/img/`:

| File | Variant | Use Case |
|------|---------|----------|
| `logo.svg` | Shield, dark mode | Navbar (dark theme), primary mark |
| `logo-light.svg` | Shield, light mode | Navbar (light theme) |
| `vln-logo-full-dark.svg` | Full lockup, dark mode | Hero sections, docs headers, presentations |
| `vln-logo-full-light.svg` | Full lockup, light mode | Print, light-background contexts |
| `favicon.svg` | Shield, compact | Browser favicon (SVG) |
| `favicon.ico` | Shield, raster | Browser favicon (legacy) |

---

## SVG Source — Dark Mode Shield

```xml
<svg width="120" height="125" viewBox="0 0 100 125"
     xmlns="http://www.w3.org/2000/svg">
  <path d="M50 0 L100 20 L100 70 C100 95 75 115 50 125
           C25 115 0 95 0 70 L0 20 Z"
        fill="#0a0e0f"
        stroke="#86d993"
        stroke-width="3"/>
  <path d="M20 40 L50 25 L80 40"
        stroke="#86d993"
        stroke-width="4"
        fill="none"
        stroke-linecap="round"/>
  <text x="50" y="78"
        text-anchor="middle"
        font-family="Inter, system-ui, -apple-system, sans-serif"
        font-size="32"
        font-weight="700"
        fill="#86d993"
        letter-spacing="2">
    VLN
  </text>
</svg>
```

## SVG Source — Dark Mode Full Lockup

```xml
<svg width="480" height="140" viewBox="0 0 480 140"
     xmlns="http://www.w3.org/2000/svg">
  <g transform="translate(20,20)">
    <path d="M50 0 L100 20 L100 70 C100 95 75 115 50 125
             C25 115 0 95 0 70 L0 20 Z"
          fill="#0a0e0f"
          stroke="#86d993"
          stroke-width="3"/>
    <path d="M20 40 L50 25 L80 40"
          stroke="#86d993"
          stroke-width="4"
          fill="none"
          stroke-linecap="round"/>
    <text x="50" y="78"
          text-anchor="middle"
          font-family="Inter, system-ui, -apple-system, sans-serif"
          font-size="32"
          font-weight="700"
          fill="#86d993"
          letter-spacing="2">
      VLN
    </text>
  </g>
  <g transform="translate(160,55)">
    <text font-family="Inter, system-ui, -apple-system, sans-serif"
          font-size="42"
          font-weight="700"
          fill="#f8f9fa"
          letter-spacing="4">
      VLN
    </text>
    <text y="32"
          font-family="Inter, system-ui, -apple-system, sans-serif"
          font-size="14"
          fill="#cbd5e1"
          letter-spacing="2">
      SMART CONTRACT SECURITY LAB
    </text>
  </g>
</svg>
```

## SVG Source — Light Mode Shield

```xml
<svg width="120" height="125" viewBox="0 0 100 125"
     xmlns="http://www.w3.org/2000/svg">
  <path d="M50 0 L100 20 L100 70 C100 95 75 115 50 125
           C25 115 0 95 0 70 L0 20 Z"
        fill="#151a1c"/>
  <path d="M20 40 L50 25 L80 40"
        stroke="#86d993"
        stroke-width="4"
        fill="none"
        stroke-linecap="round"/>
  <text x="50" y="78"
        text-anchor="middle"
        font-family="Inter, system-ui, -apple-system, sans-serif"
        font-size="32"
        font-weight="700"
        fill="#f8f9fa"
        letter-spacing="2">
    VLN
  </text>
</svg>
```

## SVG Source — Light Mode Full Lockup

```xml
<svg width="480" height="140" viewBox="0 0 480 140"
     xmlns="http://www.w3.org/2000/svg">
  <g transform="translate(20,20)">
    <path d="M50 0 L100 20 L100 70 C100 95 75 115 50 125
             C25 115 0 95 0 70 L0 20 Z"
          fill="#151a1c"/>
    <path d="M20 40 L50 25 L80 40"
          stroke="#86d993"
          stroke-width="4"
          fill="none"
          stroke-linecap="round"/>
    <text x="50" y="78"
          text-anchor="middle"
          font-family="Inter, system-ui, -apple-system, sans-serif"
          font-size="32"
          font-weight="700"
          fill="#f8f9fa"
          letter-spacing="2">
      VLN
    </text>
  </g>
  <g transform="translate(160,55)">
    <text font-family="Inter, system-ui, -apple-system, sans-serif"
          font-size="42"
          font-weight="700"
          fill="#0a0e0f"
          letter-spacing="4">
      VLN
    </text>
    <text y="32"
          font-family="Inter, system-ui, -apple-system, sans-serif"
          font-size="14"
          fill="#94a3b8"
          letter-spacing="2">
      SMART CONTRACT SECURITY LAB
    </text>
  </g>
</svg>
```

---

## Usage Guidelines

### Clear Space

Maintain a minimum clear space equal to the height of the chevron accent around all sides of the logo. No other elements should intrude into this zone.

```
        ┌───────────────────────┐
        │     clear space       │
        │   ┌───────────────┐   │
        │   │               │   │
        │   │  SHIELD MARK  │   │
        │   │               │   │
        │   └───────────────┘   │
        │     clear space       │
        └───────────────────────┘
```

### Minimum Sizes

| Variant | Minimum Width | Use Case |
|---------|---------------|----------|
| Shield mark | 32px | Favicon, app icons |
| Shield mark | 48px | Inline UI, navigation |
| Full lockup | 200px | Headers, hero sections |
| Full lockup | 320px | Print, presentations |

### Do's

- Use the dark mode variant on dark backgrounds (`#0a0e0f`, `#151a1c`)
- Use the light mode variant on white or light gray backgrounds
- Maintain the aspect ratio — never stretch or distort
- Use SVG format whenever possible for crisp rendering at all sizes
- Reference the `--vln-sage` token (`#86d993`) for the accent color

### Don'ts

- Don't change the shield fill, stroke, or text colors
- Don't remove the chevron accent — it's part of the mark
- Don't add drop shadows, outer glows, or other effects to the logo
- Don't place the dark mode logo on light backgrounds (or vice versa)
- Don't rotate, skew, or apply perspective transforms
- Don't substitute Montserrat, Arial, or other fonts — use Inter only
- Don't use the original `#00CFFF` cyan — always use `#86d993` sage

### Background Compatibility

| Background | Logo Variant | Notes |
|------------|-------------|-------|
| `#0a0e0f` (--vln-bg) | Dark mode | Primary usage |
| `#151a1c` (--vln-bg-light) | Dark mode | Cards, panels |
| `#1f2527` (--vln-bg-lighter) | Dark mode | Hover states |
| `#ffffff` (white) | Light mode | Print, light UI |
| `#f9fafb` (light gray) | Light mode | Light surfaces |

---

## Docusaurus Integration

### Navbar Logo Config

The design site uses theme-aware logos via `srcDark`:

```ts
// docusaurus.config.ts
navbar: {
  title: 'VLN Design',
  logo: {
    alt: 'VLN Shield Logo',
    src: 'img/logo-light.svg',     // Light theme
    srcDark: 'img/logo.svg',       // Dark theme (primary)
  },
},
```

### Favicon Config

```ts
favicon: 'img/favicon.ico',
```

The SVG favicon at `img/favicon.svg` uses the shield mark with the VLN text at 8px for browser tab rendering.

---

## Design Token Reference

All logo colors map directly to the VLN design token system. See [Colors](/design-system/colors) for the complete token reference.

| Token | Hex | Logo Usage |
|-------|-----|------------|
| `--vln-bg` | `#0a0e0f` | Dark shield fill |
| `--vln-bg-light` | `#151a1c` | Light-mode shield fill |
| `--vln-sage` | `#86d993` | Accent stroke, chevron, dark text |
| `--vln-white` | `#f8f9fa` | Light-mode shield text, dark wordmark |
| `--vln-gray` | `#cbd5e1` | Dark-mode tagline |
| `--vln-gray-dark` | `#94a3b8` | Light-mode tagline |
