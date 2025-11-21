---
id: getting-started
title: Getting Started
sidebar_position: 1
---

# Getting Started with VLN Design Standards

Welcome to the VLN Design Standards! This comprehensive guide provides engineers and designers with everything needed to build consistent, accessible, and beautiful interfaces for VLN products.

## What's Inside

### 🎨 Design System
Our custom design system built on modern web standards:
- **Color Palette**: WCAG AAA accessible color system with Sage Green, Sky Blue, Amber, and Purple accents
- **Typography**: Inter for UI, JetBrains Mono for code
- **Components**: Reusable UI components with variants
- **Animations**: Framer Motion powered interactions
- **Icons**: Lucide React icon library

### 📱 Responsive Design
Guidelines for building interfaces that work everywhere:
- Breakpoint system
- Layout patterns
- Testing strategies
- Multi-resolution mockups

### 🛠️ Tools & Workflows
Open source tools and workflows for rapid prototyping:
- **Design Tools**: Figma alternatives (Penpot, Inkscape)
- **Mockup Generation**: Multi-resolution screenshots and previews
- **ASCII Design**: Quick wireframing with text
- **Prototyping**: Interactive prototypes without Figma

### 🎯 Branding
Consistent brand identity across all touchpoints:
- Logo usage guidelines
- Voice and tone
- Asset library

## Quick Start

### For Designers

1. **Set Up Penpot (Recommended)**
   ```bash
   # Penpot (Figma alternative)
   # Visit https://penpot.app - web-based, no install needed
   ```

   ⭐ **New!** Complete [Penpot Setup Guide](/tools/penpot-setup) with:
   - VLN color palette import
   - Typography configuration
   - Component library setup
   - Collaboration features

2. **Review Color System**
   - Check out [Colors](/design-system/colors) for the complete palette
   - All colors are WCAG AAA compliant
   - Ready to import into Penpot

3. **Start with ASCII Wireframes**
   - Use [ASCII Design](/tools/ascii-design) for rapid iteration
   - Convert to high-fidelity with [Mockup Workflow](/tools/mockup-workflow)

### For Engineers

1. **Clone and Install**
   ```bash
   # Clone the DevOps repo
   git clone https://github.com/Fused-Gaming/DevOps.git
   cd DevOps/devops-panel

   # Install dependencies
   pnpm install

   # Start dev server
   pnpm dev
   ```

2. **Review Tech Stack**
   - Next.js 15.5.6
   - React 19.2.0
   - TailwindCSS 3.4.18
   - Framer Motion 12.23.24
   - Lucide React icons

3. **Use Design Tokens**
   ```tsx
   // Access VLN colors in your components
   className="bg-vln-bg text-vln-sage"

   // Use custom utilities
   className="glow-lift card-lift"
   ```

4. **Build Components**
   - See [Component Development](/tools/component-development)
   - Follow [Component Examples](/design-system/components)

## Design Principles

### 1. Accessibility First
All designs must meet WCAG AAA standards. Our color system is pre-validated for contrast ratios.

### 2. Performance Matters
- Optimize images and assets
- Use Next.js Image component
- Minimize bundle size
- Lazy load when possible

### 3. Mobile-First Responsive
- Design for mobile screens first
- Progressively enhance for larger screens
- Test on real devices

### 4. Consistency Over Novelty
- Reuse existing components
- Follow established patterns
- Document deviations

### 5. Open Source First
- Use freely available tools
- Contribute back to the community
- Share knowledge openly

## Key Resources

| Resource | Description | Link |
|----------|-------------|------|
| **Penpot** | Open source design tool (Figma alternative) | [penpot.app](https://penpot.app) |
| **Inkscape** | Vector graphics editor | [inkscape.org](https://inkscape.org) |
| **GIMP** | Image editor (Photoshop alternative) | [gimp.org](https://gimp.org) |
| **Lucide Icons** | Beautiful icon library | [lucide.dev](https://lucide.dev) |
| **Tailwind CSS** | Utility-first CSS framework | [tailwindcss.com](https://tailwindcss.com) |
| **Framer Motion** | Animation library | [framer.com/motion](https://framer.com/motion) |

## Need Help?

- **GitHub Issues**: Report bugs or request features at [github.com/Fused-Gaming/DevOps/issues](https://github.com/Fused-Gaming/DevOps/issues)
- **Documentation**: Browse the sidebar for detailed guides
- **Examples**: Check the DevOps Panel codebase for real-world examples

## Contributing

We welcome contributions! When adding to the design system:

1. Document your changes in this guide
2. Ensure WCAG AAA compliance
3. Provide code examples
4. Update the changelog
5. Submit a PR with screenshots

---

Let's build something beautiful! 🎨✨
