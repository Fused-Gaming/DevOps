---
id: assets
title: Brand Assets
sidebar_position: 3
image: https://vln.gg/api/og?title=Brand%20Assets&subtitle=VLN%20Asset%20Library&accent=purple&subdomain=design
---

# Brand Assets

VLN brand assets and graphics library. All assets use the VLN design token system — see [Logo Standards](/branding/logo) for detailed usage rules.

## Logo Assets

Located in `static/img/`:

| File | Type | Variant | Use Case |
|------|------|---------|----------|
| `logo.svg` | SVG | Shield, dark mode | Navbar (dark theme), primary mark |
| `logo-light.svg` | SVG | Shield, light mode | Navbar (light theme) |
| `vln-logo-full-dark.svg` | SVG | Full lockup, dark | Hero sections, docs headers, presentations |
| `vln-logo-full-light.svg` | SVG | Full lockup, light | Print, light-background contexts |
| `favicon.svg` | SVG | Shield, compact | Browser favicon (SVG) |
| `favicon.ico` | ICO | Shield, raster | Browser favicon (legacy) |
| `vln-social-card.svg` | SVG | Hero banner | Social sharing, OG fallback |

## Social Media Specs

| Platform | Dimensions | Source |
|----------|------------|--------|
| **Open Graph** | 1200x630px | `https://vln.gg/api/og/design` (API endpoint) |
| **Twitter** | 1200x630px | `https://vln.gg/api/og/design` (API endpoint) |
| **LinkedIn** | 1200x627px | Use OG endpoint |
| **Favicon** | 32x32px | `favicon.svg` / `favicon.ico` |

OG images are served by the vln.gg Next.js app — do not host OG images locally. See the [OG Image docs](https://vln.gg/api/og) for query parameters.

## Export Guidelines

- Use SVG for all logos — never rasterize to PNG unless a platform requires it
- If PNG export is needed, export at 2x resolution for Retina displays
- Optimize all images before committing
- All logo SVGs use `Inter` as the font family — ensure the font is loaded before rendering

## Color Reference

All logo assets reference these brand tokens:

| Token | Hex | Usage |
|-------|-----|-------|
| `--vln-sage` | `#86d993` | Primary accent (stroke, chevron, dark-mode text) |
| `--vln-bg` | `#0a0e0f` | Dark shield fill |
| `--vln-bg-light` | `#151a1c` | Light-mode shield fill |
| `--vln-white` | `#f8f9fa` | Light-mode shield text, dark-mode wordmark |
| `--vln-gray` | `#cbd5e1` | Dark-mode tagline |
| `--vln-gray-dark` | `#94a3b8` | Light-mode tagline |

See [Colors](/design-system/colors) for the full token system and [Logo Standards](/branding/logo) for detailed usage rules.
