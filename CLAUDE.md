# **CLAUDE.md** — Fused-Gaming/DevOps

> Drop this file as `CLAUDE.md` at the root of the `Fused-Gaming/DevOps` repository.
> It provides Claude Code with the context, commands, and standards for that repo.

---

# **Project Overview**

This repository manages DevOps infrastructure and hosted documentation for the
**Fused Gaming** ecosystem, including:

- **design.vln.gg** — VLN Design System (Docusaurus v3, Active)
- **docs.vln.gg** — VLN Documentation Hub (Docusaurus v3, Planned)
- **GitHub Actions workflows** — CI/CD, security scanning, release automation
- **Shared DevOps patterns** — branching strategies, PR templates, hook configs

**Primary VLN codebase** (separate repo): `Fused-Gaming/vln`
**Deployment**: Vercel (Docusaurus sites), GitHub Actions (CI/CD)
**Package Manager**: pnpm

---

# **Tech Stack**

| Layer | Technology |
|-------|-----------|
| Docs Framework | Docusaurus v3 |
| Language | TypeScript |
| Styling | VLN design tokens + Docusaurus Infima overrides |
| Diagrams | Mermaid (via `@docusaurus/theme-mermaid`) |
| Fonts | Inter (UI), JetBrains Mono (code) |
| Package Manager | pnpm |
| Deployment | Vercel |
| CI/CD | GitHub Actions |
| Notifications | Discord webhooks |

---

# **Commands**

```bash
# Design site (design.vln.gg)
pnpm --filter design-site dev       # Start dev server
pnpm --filter design-site build     # Production build — REQUIRED before PR
pnpm --filter design-site serve     # Preview production build

# Docs site (docs.vln.gg)
pnpm --filter docs-site dev
pnpm --filter docs-site build
pnpm --filter docs-site serve

# All sites
pnpm build                          # Build all packages
pnpm lint                           # Lint all packages
```

> **Note:** If the repo is NOT a monorepo, omit `--filter` flags and run from the
> relevant site directory directly.

---

# **Repository Structure**

```
Fused-Gaming/DevOps/
├── CLAUDE.md                        ← This file
├── packages/
│   ├── design-site/                 ← design.vln.gg Docusaurus site
│   │   ├── docusaurus.config.ts
│   │   ├── docs/
│   │   │   ├── og-images.md         ← OG image system docs (from vln repo)
│   │   │   ├── design-tokens.md     ← VLN color/token reference
│   │   │   └── ...
│   │   ├── src/
│   │   │   └── css/custom.css       ← VLN brand overrides
│   │   └── static/
│   └── docs-site/                   ← docs.vln.gg Docusaurus site
│       ├── docusaurus.config.ts
│       ├── docs/
│       └── src/css/custom.css
├── .github/
│   ├── workflows/
│   │   ├── ci.yml
│   │   ├── deploy-design.yml
│   │   └── deploy-docs.yml
│   └── PR_BODY.md
└── docs/
    └── DISCORD-WEBHOOKS.md
```

> Adapt paths if the repo uses a flat layout (single site at root) or different
> package names.

---

# **VLN Brand Standards**

## CRITICAL: Always use these exact values — never substitute

### Color Tokens

```css
/* Backgrounds */
--vln-bg:           #0a0e0f   /* Matte Charcoal — page background */
--vln-bg-light:     #151a1c   /* Cards, sections */
--vln-bg-lighter:   #1f2527   /* Hover states */

/* Accent Colors */
--vln-sage:         #86d993   /* Primary brand — CTAs, success */
--vln-blue:         #7dd3fc   /* Docs/API — technical content */
--vln-amber:        #fbbf24   /* Alerts, urgency */
--vln-purple:       #c084fc   /* Design system, premium */

/* Text */
--vln-white:        #f8f9fa   /* Primary text */
--vln-gray:         #cbd5e1   /* Secondary text */
--vln-gray-dark:    #94a3b8   /* Muted text, captions */

/* Metrics */
--vln-radius:        12px
--vln-glow:          12px
--vln-card-lift:      4px
```

### Docusaurus Infima Overrides (src/css/custom.css)

```css
/* ===== VLN Design System — Docusaurus Theme Overrides ===== */

:root {
  --ifm-color-primary:          #86d993;
  --ifm-color-primary-dark:     #5fb76f;
  --ifm-color-primary-darker:   #4fa560;
  --ifm-color-primary-darkest:  #3a8d48;
  --ifm-color-primary-light:    #a8e9b4;
  --ifm-color-primary-lighter:  #c4f0cc;
  --ifm-color-primary-lightest: #e0f8e4;

  /* Typography */
  --ifm-font-family-base:       'Inter', system-ui, -apple-system, sans-serif;
  --ifm-font-family-monospace:  'JetBrains Mono', 'Fira Code', monospace;
  --ifm-code-font-size:         95%;

  /* Layout */
  --ifm-border-radius:          12px;
  --docusaurus-highlighted-code-line-bg: rgba(134, 217, 147, 0.1);
}

/* Dark mode (default for VLN) */
[data-theme='dark'] {
  --ifm-background-color:         #0a0e0f;
  --ifm-background-surface-color: #151a1c;
  --ifm-font-color-base:          #f8f9fa;
  --ifm-heading-color:            #f8f9fa;
  --ifm-navbar-background-color:  #0a0e0f;
  --ifm-footer-background-color:  #0a0e0f;
  --ifm-toc-border-color:         rgba(134, 217, 147, 0.2);
  --ifm-hr-border-color:          rgba(134, 217, 147, 0.15);
}

/* Force dark mode by default */
html {
  color-scheme: dark;
}
```

### Typography

- **UI text**: Inter (loaded via Google Fonts or local)
- **Code/technical**: JetBrains Mono
- Add to `docusaurus.config.ts` > `headTags`:
  ```ts
  headTags: [
    {
      tagName: 'link',
      attributes: {
        rel: 'preconnect',
        href: 'https://fonts.googleapis.com',
      },
    },
    {
      tagName: 'link',
      attributes: {
        rel: 'stylesheet',
        href: 'https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700&family=JetBrains+Mono:wght@400;700&display=swap',
      },
    },
  ],
  ```

---

# **Open Graph Image Integration**

Both Docusaurus sites reference **OG images served by the vln.gg Next.js app**.
Do not host OG images in this repo — link to the API endpoints.

## Endpoint Reference

| Site | OG Endpoint | Accent | Notes |
|------|-------------|--------|-------|
| design.vln.gg | `https://vln.gg/api/og/design` | Purple | Static, no params needed |
| docs.vln.gg | `https://vln.gg/api/og/docs` | Blue | Static default, or `?title=X` for pages |
| Any page | `https://vln.gg/api/og?title=X&subtitle=Y&accent=blue&subdomain=docs` | Dynamic | Full query params |

## docusaurus.config.ts metadata block

```ts
// design.vln.gg
metadata: [
  { name: 'og:image',         content: 'https://vln.gg/api/og/design' },
  { name: 'og:image:width',   content: '1200' },
  { name: 'og:image:height',  content: '630' },
  { name: 'og:image:type',    content: 'image/png' },
  { name: 'og:type',          content: 'website' },
  { name: 'og:site_name',     content: 'VLN Design System' },
  { name: 'twitter:card',     content: 'summary_large_image' },
  { name: 'twitter:image',    content: 'https://vln.gg/api/og/design' },
  { name: 'twitter:site',     content: '@vlnsecurity' },
],

// docs.vln.gg
metadata: [
  { name: 'og:image',         content: 'https://vln.gg/api/og/docs' },
  { name: 'og:image:width',   content: '1200' },
  { name: 'og:image:height',  content: '630' },
  { name: 'og:image:type',    content: 'image/png' },
  { name: 'og:type',          content: 'website' },
  { name: 'og:site_name',     content: 'VLN Documentation' },
  { name: 'twitter:card',     content: 'summary_large_image' },
  { name: 'twitter:image',    content: 'https://vln.gg/api/og/docs' },
  { name: 'twitter:site',     content: '@vlnsecurity' },
],
```

## Per-page OG via front matter (Docusaurus MDX)

For individual doc pages that need custom OG images, add to the MDX front matter:

```mdx
---
title: API Reference
description: Complete VLN API documentation
image: https://vln.gg/api/og?title=API%20Reference&subtitle=Complete%20VLN%20API%20docs&accent=blue&subdomain=docs
---
```

---

# **Mermaid Diagrams**

Docusaurus v3 supports Mermaid natively. Ensure it's configured:

```ts
// docusaurus.config.ts
themes: ['@docusaurus/theme-mermaid'],
markdown: {
  mermaid: true,
},
```

Install if missing:
```bash
pnpm add @docusaurus/theme-mermaid
```

All diagrams from `Fused-Gaming/vln/docs/design/og-images.md` must render.
Supported types used in VLN docs: `gitGraph`, `flowchart TD`, `sequenceDiagram`, `graph LR`.

---

# **Git Workflow**

VLN follows the **Fused Gaming integration-first branching model**.

### Branches

| Branch | Purpose |
|--------|---------|
| `main` | Production (protected) |
| `integration/devops` | Active integration for DevOps |
| `claude/<session-id>` | Claude agent feature branches |

### Feature Workflow

```bash
git checkout integration/devops
git pull origin integration/devops
git checkout -b claude/<short-desc>-<session-id>

# Make changes, then:
pnpm build    # MUST pass
git add ...
git commit -m "feat(design.vln.gg): description"
git push -u origin claude/<short-desc>-<session-id>
```

### Commit Convention

```
feat(design.vln.gg): add OG metadata to docusaurus config
feat(docs.vln.gg): scaffold docs site with brand tokens
fix(design-site): correct custom.css variable names
docs: update og-images.md with docs.vln.gg coverage
chore: add mermaid theme support to both sites
```

### PR Rules

- **Base branch**: `integration/devops` (never `main` directly)
- Must include: passing build, lint clean, conventional commit title
- PR description must reference which site(s) were updated

---

# **Claude Directives**

When Claude modifies or generates code in this repo:

1. **Never hardcode OG images** — always reference `https://vln.gg/api/og/*` endpoints
2. **Never override VLN brand tokens** — use exact hex values from the color system above
3. **Build must pass** before any PR — run `pnpm build` for each affected site
4. **Mermaid diagrams must render** — verify `@docusaurus/theme-mermaid` is installed
5. **Dark mode is default** — all CSS overrides assume `[data-theme='dark']`
6. **Follow integration-first Git** — branch from `integration/devops`, PR back to it
7. **Per-page OG via front matter** — use `?title=` query params for dynamic images
8. **Mirror, don't diverge from vln.gg docs** — design system docs here should stay
   in sync with `Fused-Gaming/vln/docs/design/`
9. **Never install heavy dependencies** — Docusaurus sites must stay lightweight
10. **Fonts via Google Fonts CDN** — Inter + JetBrains Mono, loaded in `headTags`

---

# **Linked Resources**

| Resource | Location |
|----------|----------|
| VLN codebase | `Fused-Gaming/vln` |
| OG image source code | `Fused-Gaming/vln/app/api/og/` |
| OG image docs | `Fused-Gaming/vln/docs/design/og-images.md` |
| Color system | `Fused-Gaming/vln/docs/design/tokens/colors.md` |
| Visual Systems Protocol | `Fused-Gaming/vln/docs/prompts/visual-systems-graph-design-protocol.md` |
| Agent task prompt | `Fused-Gaming/vln/docs/prompts/devops-docusaurus-og-agent-prompt.md` |
| Discord webhook docs | `Fused-Gaming/vln/docs/devops/DISCORD-WEBHOOKS.md` |

---

# **Environment Variables**

```bash
# .env (never commit)
DISCORD_WEBHOOK_URL=""          # For CI/CD notifications
GITHUB_TOKEN=""                 # Auto-provided by GitHub Actions
VERCEL_TOKEN=""                 # For Vercel deployment
```

---

# **Deployment**

Both Docusaurus sites deploy to Vercel:

| Site | Vercel Project | Branch |
|------|---------------|--------|
| design.vln.gg | `vln-design-site` | `main` |
| docs.vln.gg | `vln-docs-site` | `main` |

Preview deployments trigger on any PR to `integration/devops`.

---

**Last Updated:** 2026-02-13
**Maintainer:** VLN DevOps Team / Fused Gaming
**License:** Proprietary — © 2025 VLN - Fused Gaming
