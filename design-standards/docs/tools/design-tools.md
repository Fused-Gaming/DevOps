---
id: design-tools
title: Open Source Design Tools
sidebar_position: 1
---

# Open Source Design Tools

Comprehensive guide to free and open source design tools for creating mockups, prototypes, and production-ready assets for VLN products.

## Design & Prototyping

### Penpot (⭐ Recommended)

**The Open Source Figma Alternative**

- 🌐 **Web-based**: No installation required
- 🎨 **Full-featured**: Vector editing, prototyping, design systems
- 👥 **Collaboration**: Real-time collaboration like Figma
- 🔓 **Open Standards**: SVG-based, exports to industry standards
- 💾 **Self-hostable**: Host your own instance

**Getting Started**:
```bash
# Use web version (easiest)
Visit: https://penpot.app

# Or self-host with Docker
docker run -d \
  -p 8080:80 \
  --name penpot \
  penpotapp/frontend:latest
```

**Perfect For**:
- UI/UX design
- Design systems
- Interactive prototypes
- Team collaboration
- Component libraries

**Resources**:
- [Penpot Docs](https://help.penpot.app)
- [Penpot Community](https://community.penpot.app)
- [VLN Design Kit Template](https://penpot.app) - Import our color system

### Inkscape

**Vector Graphics Powerhouse**

- 🎯 **Professional**: Full SVG editor
- 🖼️ **Logo Design**: Perfect for icons and logos
- 📐 **Precision**: Exact measurements and paths
- 🔧 **Extensions**: Huge plugin ecosystem

**Installation**:
```bash
# Ubuntu/Debian
sudo apt install inkscape

# macOS (Homebrew)
brew install --cask inkscape

# Windows
# Download from https://inkscape.org/release/
```

**Perfect For**:
- Logo design
- Icon creation
- Vector illustrations
- Print design
- SVG optimization

**VLN Workflow**:
1. Create icons at 24x24px artboard
2. Export as optimized SVG
3. Use directly in React with SVGR
4. Import into component library

### GIMP

**Image Editing & Manipulation**

- 🖼️ **Full-featured**: Photoshop alternative
- 🎨 **Photo editing**: Professional retouching
- 🔧 **Scripting**: Python-based automation
- 🆓 **100% Free**: No subscriptions ever

**Installation**:
```bash
# Ubuntu/Debian
sudo apt install gimp

# macOS (Homebrew)
brew install --cask gimp

# Windows
# Download from https://gimp.org
```

**Perfect For**:
- Photo editing and retouching
- Creating og-images and social cards
- Mockup backgrounds
- Texture creation
- Banner design

## Mockup & Wireframing

### Excalidraw

**Quick Collaborative Wireframes**

- ✏️ **Hand-drawn style**: Perfect for early wireframes
- 🚀 **Fast**: No learning curve
- 👥 **Collaborative**: Real-time multi-user
- 🔒 **Privacy**: End-to-end encrypted

**Getting Started**:
```bash
# Use web version
Visit: https://excalidraw.com

# Or use VS Code extension
code --install-extension pomdtr.excalidraw-editor
```

**Perfect For**:
- Quick wireframes
- Architecture diagrams
- Flow charts
- Brainstorming sessions
- ASCII-style mockups before Penpot

### Lunacy

**Windows/Mac Sketch Alternative**

- 📂 **Sketch compatible**: Open .sketch files
- 🎨 **Built-in graphics**: Huge asset library
- 🆓 **Free**: No paid tiers
- 💻 **Offline-first**: No internet required

**Installation**:
```bash
# Download from https://icons8.com/lunacy
# Available for Windows, macOS, Linux
```

**Perfect For**:
- Opening Sketch files
- Quick mockups with built-in assets
- Windows/Mac native experience

## Multi-Resolution Mockups

### Responsively

**All-in-One Responsive Testing**

- 📱 **Multiple devices**: Test all breakpoints at once
- 🔄 **Synchronized**: Scroll and click mirrored across screens
- 📸 **Screenshots**: Capture all resolutions
- 🎯 **Developer-focused**: Hot reload support

**Installation**:
```bash
# Download from https://responsively.app
# Or install via package manager

# macOS
brew install --cask responsively

# Windows
choco install responsively

# Linux (AppImage available)
```

**VLN Workflow**:
```bash
# Start dev server
cd devops-panel
pnpm dev

# Open in Responsively
# Add devices: iPhone 13, iPad, Desktop (1920x1080)
# Test responsive behavior
# Take screenshots for documentation
```

**Perfect For**:
- Responsive testing
- Multi-device screenshots
- Design QA
- Documentation captures

### Polypane

**Professional Responsive Development**

- 🎨 **Multiple viewports**: Side-by-side testing
- ♿ **Accessibility**: Built-in a11y testing
- 📸 **Screenshot all**: Export all sizes at once
- 🔧 **Dev tools**: Per-viewport inspection

**Note**: Free for open source projects, paid otherwise

**Perfect For**:
- Accessibility testing
- Professional responsive development
- Client presentations

## Screenshots & Mockups

### Flameshot (Linux)

**Powerful Screenshot Tool**

```bash
# Install
sudo apt install flameshot

# Quick capture with annotation
flameshot gui

# Capture specific area and copy to clipboard
flameshot gui --clipboard
```

### Shottr (macOS)

**Fast Mac Screenshots**

```bash
# Install
brew install --cask shottr

# Features: Annotations, scrolling capture, OCR
```

### ShareX (Windows)

**All-in-One Screen Capture**

```bash
# Download from https://getsharex.com

# Features:
# - Screen recording
# - GIF creation
# - Scrolling capture
# - Annotatio
```

## Browser DevTools

### Chrome/Edge DevTools

**Built-in Responsive Testing**

```javascript
// Open DevTools
// Cmd/Ctrl + Shift + M for device mode

// Capture screenshots
// 1. Open DevTools
// 2. Cmd/Ctrl + Shift + P
// 3. Type "screenshot"
// 4. Choose "Capture full size screenshot"
```

**Device Emulation**:
```javascript
// Add custom devices matching VLN breakpoints
const devices = {
  mobile: { width: 375, height: 812 },   // sm
  tablet: { width: 768, height: 1024 },  // md
  laptop: { width: 1024, height: 768 },  // lg
  desktop: { width: 1920, height: 1080 } // xl
};
```

## Color & Accessibility

### Color Contrast Checker

**Free Online Tools**:
- [WebAIM Contrast Checker](https://webaim.org/resources/contrastchecker/)
- [Coolors Contrast Checker](https://coolors.co/contrast-checker)

### Pika (macOS Color Picker)

```bash
# Install
brew install --cask pika

# Pick any color from screen
# Get hex, rgb, hsl values
```

### ColorSlurp (macOS/iOS)

- Pick colors from anywhere
- Organize palettes
- Check accessibility
- Sync across devices

## Icon Libraries

### Lucide Icons (Used by VLN)

**React Component Library**

```bash
# Install
pnpm add lucide-react

# Use in React
import { Heart, Star, Zap } from 'lucide-react';

function MyComponent() {
  return (
    <>
      <Heart className="text-vln-sage" size={24} />
      <Star className="text-vln-amber" size={24} />
      <Zap className="text-vln-sky" size={24} />
    </>
  );
}
```

### Heroicons

**Tailwind CSS Official Icons**

```bash
pnpm add @heroicons/react

import { BeakerIcon } from '@heroicons/react/24/solid';
```

### Phosphor Icons

**Flexible Icon Family**

```bash
pnpm add @phosphor-icons/react

import { Lightning, Heart } from "@phosphor-icons/react";
```

## Typography

### Google Fonts

**Free Web Fonts**

```css
/* Already included in VLN */
@import url('https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap');
@import url('https://fonts.googleapis.com/css2?family=JetBrains+Mono:wght@400;500&display=swap');
```

### Fontsource

**Self-hosted Fonts**

```bash
# Install fonts locally
pnpm add @fontsource/inter @fontsource/jetbrains-mono

# Import in your app
import '@fontsource/inter/400.css';
import '@fontsource/inter/500.css';
import '@fontsource/jetbrains-mono/400.css';
```

## Animation & Interaction

### Framer Motion (Used by VLN)

**Production-Ready Animations**

```tsx
import { motion } from 'framer-motion';

<motion.div
  initial={{ opacity: 0, y: 20 }}
  animate={{ opacity: 1, y: 0 }}
  transition={{ duration: 0.3 }}
  className="bg-vln-bg-lighter"
>
  Animated content
</motion.div>
```

### LottieFiles

**Free Animation Library**

- [LottieFiles](https://lottiefiles.com)
- Export as JSON
- Use with `lottie-react`

```bash
pnpm add lottie-react

import Lottie from 'lottie-react';
import animation from './animation.json';

<Lottie animationData={animation} />
```

## Documentation & Handoff

### Storybook

**Component Documentation**

```bash
# Install in your project
cd devops-panel
pnpx storybook@latest init

# Run Storybook
pnpm storybook
```

**Perfect For**:
- Component library documentation
- Visual regression testing
- Design-dev handoff
- Component playground

## Recommended VLN Stack

| Purpose | Tool | Why |
|---------|------|-----|
| **UI Design** | Penpot | Full Figma alternative, web-based |
| **Icons** | Lucide React | Already integrated, consistent style |
| **Vector** | Inkscape | Logo and icon creation |
| **Wireframes** | Excalidraw | Fast, collaborative |
| **Photos** | GIMP | Professional editing |
| **Responsive Testing** | Responsively | Multi-device preview |
| **Animation** | Framer Motion | Already integrated |
| **Docs** | Storybook | Component showcase |
| **Screenshots** | Built-in tools | Platform-specific |

## Workflow Example

### From Idea to Production

1. **Wireframe** (5 min)
   ```bash
   # ASCII wireframe or Excalidraw
   # Quick layout and flow
   ```

2. **High-Fidelity Design** (30 min)
   ```bash
   # Open Penpot
   # Use VLN design tokens
   # Create mockup with real content
   ```

3. **Responsive Mockups** (15 min)
   ```bash
   # Export designs at different breakpoints
   # Mobile: 375px
   # Tablet: 768px
   # Desktop: 1920px
   ```

4. **Development** (varies)
   ```bash
   cd devops-panel
   # Build with Tailwind + Framer Motion
   # Use existing VLN components
   ```

5. **Testing** (10 min)
   ```bash
   # Open in Responsively
   # Test all breakpoints
   # Take screenshots for docs
   ```

6. **Documentation** (10 min)
   ```bash
   # Update design-standards docs
   # Add component to Storybook
   # Commit with screenshots
   ```

## Next Steps

- [Mockup Workflow](/tools/mockup-workflow) - Detailed multi-resolution workflow
- [ASCII Design](/tools/ascii-design) - Quick wireframing technique
- [Component Development](/tools/component-development) - Build with VLN system
- [Prototyping](/tools/prototyping) - Interactive prototypes without Figma

## Resources

- [Open Source Design](https://opensourcedesign.net/) - Community hub
- [Awesome Design Tools](https://github.com/goabstract/Awesome-Design-Tools) - Curated list
- [Design Resources for Developers](https://github.com/bradtraversy/design-resources-for-developers) - Massive collection
