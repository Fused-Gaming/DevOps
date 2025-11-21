---
id: overview
title: Tools Overview
sidebar_position: 0
---

# Tools & Workflows Overview

Complete tooling ecosystem for designing, developing, and deploying VLN products using open source solutions.

## Quick Reference

| Task | Tool | Time | Difficulty |
|------|------|------|-----------|
| **Wireframe** | ASCII / Excalidraw | 5 min | Easy |
| **UI Design** | Penpot | 30 min | Medium |
| **Development** | VS Code + Next.js | Varies | Medium-Hard |
| **Testing** | Responsively App | 15 min | Easy |
| **Screenshots** | Browser DevTools | 5 min | Easy |

## Design Phase

### 1. Ideation & Wireframing
- **ASCII Design**: Text-based wireframes for rapid iteration
- **Excalidraw**: Hand-drawn style collaborative sketches
- **Time**: 5-15 minutes

### 2. High-Fidelity Design
- **Penpot**: Full-featured design tool (Figma alternative)
- **Inkscape**: Vector graphics and logos
- **GIMP**: Photo editing and manipulation
- **Time**: 30-60 minutes

### 3. Asset Preparation
- **Icon Selection**: Lucide React library
- **Image Optimization**: ImageMagick, Sharp
- **Font Loading**: Google Fonts, Fontsource
- **Time**: 10-20 minutes

## Development Phase

### 4. Component Development
- **VS Code**: Primary code editor
- **Next.js 15**: React framework
- **Tailwind CSS**: Utility-first styling
- **Framer Motion**: Animations
- **Time**: Varies by complexity

### 5. Responsive Testing
- **Responsively App**: Multi-device preview
- **Browser DevTools**: Built-in testing
- **Real Devices**: Final validation
- **Time**: 15-30 minutes

### 6. Documentation
- **Docusaurus**: This site!
- **Storybook**: Component showcase
- **Screenshots**: Visual documentation
- **Time**: 10-20 minutes

## Recommended Stack

### Must-Have Tools

```bash
# Design
✓ Penpot (Web)            # UI design
✓ Excalidraw (Web)        # Wireframes

# Development
✓ VS Code                 # Code editor
✓ Node.js 20+             # Runtime
✓ pnpm                    # Package manager

# Testing
✓ Responsively App        # Multi-device testing
✓ Chrome/Firefox          # Browser testing
```

### Optional but Useful

```bash
# Design
○ Inkscape               # Vector graphics
○ GIMP                   # Image editing
○ Figma                  # Alternative to Penpot

# Development
○ GitHub Copilot         # AI pair programming
○ Storybook              # Component docs
○ Playwright             # E2E testing

# Utilities
○ ImageMagick            # Image processing
○ FFmpeg                 # Video/GIF creation
```

## Getting Started Checklist

### For Designers

- [ ] Create Penpot account at https://penpot.app
- [ ] Import VLN color tokens
- [ ] Install fonts (Inter, JetBrains Mono)
- [ ] Review [Design System](/design-system/colors)
- [ ] Try [ASCII Design](/tools/ascii-design) workflow

### For Engineers

- [ ] Clone DevOps repository
- [ ] Install Node.js 20+ and pnpm
- [ ] Run `pnpm install` in devops-panel
- [ ] Start dev server with `pnpm dev`
- [ ] Install Responsively App
- [ ] Review [Component Development](/tools/component-development)

## Workflow Diagrams

### Design to Production Flow

```
Idea
  ↓
ASCII Wireframe (5 min)
  ↓
Penpot Design (30 min)
  ↓
Export Assets (5 min)
  ↓
Component Development (varies)
  ↓
Responsive Testing (15 min)
  ↓
Documentation (10 min)
  ↓
Pull Request & Review
  ↓
Deploy to Production
```

### Multi-Resolution Workflow

```
Design in Penpot
  ↓
Export 3 Sizes
├─ Mobile (375px)
├─ Tablet (768px)
└─ Desktop (1920px)
  ↓
Develop Mobile-First
  ↓
Test in Responsively
├─ Check layout
├─ Test interactions
└─ Verify accessibility
  ↓
Screenshot All Sizes
  ↓
Document & Ship
```

## Time Estimates

### Small Feature (e.g., Button Component)
- Wireframe: 5 min
- Design: 15 min
- Development: 30 min
- Testing: 10 min
- Documentation: 10 min
- **Total: ~70 minutes**

### Medium Feature (e.g., Status Card)
- Wireframe: 10 min
- Design: 30 min
- Development: 1-2 hours
- Testing: 15 min
- Documentation: 15 min
- **Total: ~2-3 hours**

### Large Feature (e.g., Dashboard Page)
- Wireframe: 20 min
- Design: 1-2 hours
- Development: 4-8 hours
- Testing: 30 min
- Documentation: 30 min
- **Total: ~6-11 hours**

## Cost Breakdown

Everything is free and open source!

| Tool | License | Cost |
|------|---------|------|
| Penpot | MPL-2.0 | $0 |
| Excalidraw | MIT | $0 |
| VS Code | MIT | $0 |
| Next.js | MIT | $0 |
| Tailwind | MIT | $0 |
| Responsively | MIT | $0 |
| All Tools | Open Source | **$0/month** |

Compare to commercial alternatives:
- Figma Professional: $15/month per editor
- Adobe Creative Cloud: $60/month
- Sketch: $99/year
- **Total Savings: $75+/month!**

## Deep Dives

Explore each tool in detail:

### Design Tools
- [Design Tools](/tools/design-tools) - Complete guide to open source design tools
- [ASCII Design](/tools/ascii-design) - Rapid wireframing technique
- [Mockup Workflow](/tools/mockup-workflow) - Multi-resolution workflow

### Development
- [Setup](/tools/setup) - Development environment setup
- [Component Development](/tools/component-development) - Build VLN components
- [Testing](/tools/testing) - Testing strategies

### Design System
- [Colors](/design-system/colors) - VLN color palette
- [Typography](/design-system/typography) - Font system
- [Components](/design-system/components) - Component library

## Support & Resources

### Official Documentation
- [Penpot Docs](https://help.penpot.app)
- [Tailwind CSS](https://tailwindcss.com/docs)
- [Next.js Docs](https://nextjs.org/docs)
- [Framer Motion](https://www.framer.com/motion)

### Community
- [GitHub Discussions](https://github.com/Fused-Gaming/DevOps/discussions)
- [GitHub Issues](https://github.com/Fused-Gaming/DevOps/issues)

### Learning Resources
- [Tailwind CSS Tutorial](https://tailwindcss.com/docs/utility-first)
- [Next.js Learn](https://nextjs.org/learn)
- [Penpot Community](https://community.penpot.app)

## Next Steps

Choose your path:

**New to Design?**
1. Start with [ASCII Design](/tools/ascii-design)
2. Move to [Design Tools](/tools/design-tools)
3. Learn [Mockup Workflow](/tools/mockup-workflow)

**Ready to Build?**
1. Review [Colors](/design-system/colors)
2. Study [Components](/design-system/components)
3. Start [Component Development](/tools/component-development)

**Want the Full Picture?**
1. Read [Getting Started](/getting-started)
2. Explore [Design System](/design-system/colors)
3. Master [Responsive Design](/responsive/breakpoints)
