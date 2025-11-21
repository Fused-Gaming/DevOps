---
id: penpot-setup
title: Penpot Setup & Integration
sidebar_position: 8
---

# Penpot Setup & Integration

Complete guide to using Penpot with VLN design standards. Penpot is our recommended open-source design tool (Figma alternative).

## Why Penpot?

✅ **100% Free & Open Source** - No subscriptions, no limits
✅ **Web-Based** - Works in browser, no installation needed
✅ **Figma-Like** - Familiar interface if you've used Figma
✅ **Team Collaboration** - Real-time collaboration like Figma
✅ **Self-Hostable** - Optional self-hosting for privacy
✅ **Open Standards** - SVG-based, exports to industry formats

## Quick Start

### 1. Create Account

Visit: **https://penpot.app**

```
1. Click "Sign up" (top right)
2. Use email or GitHub account
3. Verify email
4. Start designing!
```

**No credit card required** - 100% free forever

### 2. Import VLN Design Kit

We've created a VLN Design Kit template with:
- Pre-configured VLN color palette
- Typography styles (Inter, JetBrains Mono)
- Component library (buttons, cards, inputs)
- Responsive artboard templates
- Design tokens

**Import the Kit:**

1. **Download VLN Design Kit** (coming soon - will be added to repo)
2. In Penpot: **File → Import → Select .penpot file**
3. Kit appears in your workspace
4. Duplicate and customize for your project

## VLN Color Palette Setup

### Manual Color Setup

If starting from scratch, add VLN colors:

**1. Open Color Palette Panel**
- Click color swatch in right sidebar
- Click "+" to add custom colors

**2. Add VLN Brand Colors**

```
Backgrounds:
• #0a0e0f - VLN Dark
• #151a1c - VLN Dark Light
• #1f2527 - VLN Dark Lighter

Primary (Sage Green):
• #86d993 - Sage
• #a8e9b4 - Sage Light
• #5fb76f - Sage Dark

Secondary (Sky Blue):
• #7dd3fc - Sky
• #bae6fd - Sky Light
• #0ea5e9 - Sky Dark

Tertiary (Amber):
• #fbbf24 - Amber
• #fcd34d - Amber Light
• #f59e0b - Amber Dark

Premium (Purple):
• #c084fc - Purple
• #d8b4fe - Purple Light
• #a855f7 - Purple Dark
```

**3. Save as Shared Library**
- Right-click palette → "Save as shared library"
- Name: "VLN Design System"
- Now available across all projects

## Typography Setup

### 1. Import Google Fonts

Penpot supports Google Fonts directly:

```
1. Click text tool (T)
2. Type some text
3. In font dropdown, search "Inter"
4. Select Inter (various weights: 400, 500, 600, 700)
5. For code: Search "JetBrains Mono"
```

### 2. Create Text Styles

Create reusable text styles:

**Heading 1:**
```
Font: Inter Bold (700)
Size: 60px
Line Height: 1.2
Color: #ffffff
```

**Body:**
```
Font: Inter Regular (400)
Size: 16px
Line Height: 1.6
Color: #ffffff
```

**Code:**
```
Font: JetBrains Mono (400)
Size: 14px
Line Height: 1.5
Color: #86d993
```

**Save Styles:**
- Select text → Right panel → "Create text style"
- Name it (e.g., "H1", "Body", "Code")
- Reuse across project

## Component Library

### Building VLN Components in Penpot

#### Button Component

```
1. Create button shape (rounded rectangle)
   - Width: auto (padding-based)
   - Height: 48px
   - Border radius: 12px
   - Fill: #86d993 (Sage)

2. Add text
   - Font: Inter Medium (500)
   - Size: 16px
   - Color: #0a0e0f (Dark on light button)
   - Center align

3. Make it a component
   - Right-click → "Create component"
   - Name: "Button/Primary"

4. Add variants
   - Duplicate component
   - Create: Primary, Secondary, Ghost
   - Different colors for each
```

#### Card Component

```
1. Rectangle with rounded corners
   - Border radius: 12px
   - Fill: #1f2527 (VLN Dark Lighter)
   - Border: 1px solid #151a1c
   - Shadow: 0 2px 8px rgba(0,0,0,0.2)

2. Add padding (24px all sides)
3. Add content (title, description, buttons)
4. Make component: "Card/Default"
5. Create variants: Hover, Active
```

## Responsive Artboards

### VLN Breakpoint Templates

Create artboards for each VLN breakpoint:

**Mobile (375 × 812)**
```
Name: "Mobile - iPhone 13"
Use for: sm breakpoint (< 640px)
```

**Tablet (768 × 1024)**
```
Name: "Tablet - iPad"
Use for: md breakpoint (768px)
```

**Desktop (1920 × 1080)**
```
Name: "Desktop - Full HD"
Use for: lg/xl breakpoints (1024px+)
```

**How to Create:**
```
1. Press 'A' for artboard tool
2. Click and drag to create artboard
3. Or use preset sizes in right panel
4. Name according to breakpoint
```

## Prototyping in Penpot

### Interactive Prototypes

Penpot supports Figma-like prototyping:

**1. Create Multiple Screens**
- Design each screen as separate artboard
- Example: Login → Dashboard → Settings

**2. Add Interactions**
```
1. Select element (button, link, etc.)
2. Right panel → "Interactions"
3. Click "+" to add interaction
4. Choose trigger: Click, Hover, etc.
5. Choose action: Navigate to, Open overlay, etc.
6. Select destination artboard
```

**3. Preview Prototype**
```
- Click "Play" button (top right)
- Test interactions in browser
- Share preview link with team
```

**4. Share with Stakeholders**
```
- Click "Share" (top right)
- Choose permissions (View/Edit)
- Copy link
- Send to team/clients
```

## Collaboration Features

### Real-Time Collaboration

Multiple designers can work simultaneously:

```
1. Click "Share" button
2. Invite team members by email
3. Set permissions:
   - View only
   - Can edit
   - Can comment
4. Everyone sees live changes
```

### Comments & Feedback

```
1. Click comment icon (top bar)
2. Click anywhere on design
3. Type feedback
4. Tag team members with @mention
5. Resolve when addressed
```

## Export Assets

### Export for Development

**Export Individual Elements:**
```
1. Select element
2. Right panel → "Export"
3. Choose format:
   - SVG (for icons, vectors)
   - PNG (for images)
   - JPG (for photos)
4. Choose scale (@1x, @2x, @3x)
5. Click "Export"
```

**Export Entire Artboard:**
```
1. Select artboard
2. File → Export
3. Choose format
4. Download
```

### Export Icons for Web

```
1. Select icon
2. Export as SVG
3. Optimize: File → Export → SVG (optimized)
4. Use directly in React:
   - Copy SVG code
   - Use with SVGR
   - Or save as .svg file
```

## Keyboard Shortcuts

Essential Penpot shortcuts:

| Action | Shortcut |
|--------|----------|
| **Selection Tool** | V |
| **Rectangle** | R |
| **Circle** | C |
| **Text** | T |
| **Artboard** | A |
| **Pen Tool** | P |
| **Zoom In** | Cmd/Ctrl + |
| **Zoom Out** | Cmd/Ctrl - |
| **Duplicate** | Cmd/Ctrl + D |
| **Group** | Cmd/Ctrl + G |
| **Ungroup** | Cmd/Ctrl + Shift + G |
| **Copy** | Cmd/Ctrl + C |
| **Paste** | Cmd/Ctrl + V |
| **Undo** | Cmd/Ctrl + Z |
| **Redo** | Cmd/Ctrl + Shift + Z |

## Tips & Best Practices

### 1. Use Components

✅ **Do:**
- Create components for reusable elements
- Use component variants for different states
- Keep components organized in dedicated page

❌ **Don't:**
- Copy/paste the same element repeatedly
- Forget to update components when design changes

### 2. Name Layers Properly

```
✅ Good:
- Button/Primary
- Card/Product
- Icon/Search

❌ Bad:
- Rectangle 1
- Group 45
- Shape
```

### 3. Organize with Pages

```
📁 VLN Design Project
  ├─ 📄 Cover (Overview, notes)
  ├─ 📄 Components (Buttons, Cards, Forms)
  ├─ 📄 Mobile Screens
  ├─ 📄 Desktop Screens
  └─ 📄 Prototypes
```

### 4. Use Auto Layout

Penpot's flex layout (similar to CSS flexbox):

```
1. Select multiple elements
2. Right panel → "Flex layout"
3. Enable flex
4. Set direction (horizontal/vertical)
5. Set spacing between items
6. Elements auto-adjust when content changes
```

## VLN Design Workflow

### Recommended Process

```
1. ASCII Wireframe (5 min)
   ↓
2. Low-Fidelity in Penpot (15 min)
   - Basic shapes
   - No colors yet
   - Focus on layout
   ↓
3. High-Fidelity Design (30 min)
   - Apply VLN colors
   - Add typography
   - Add real content
   ↓
4. Prototype (10 min)
   - Link screens
   - Add interactions
   ↓
5. Share for Feedback (5 min)
   - Share link with team
   - Collect comments
   ↓
6. Export Assets (10 min)
   - Export for development
   - Hand off to engineers
```

## Self-Hosting (Advanced)

For teams wanting full control:

### Docker Setup

```bash
# Clone Penpot
git clone https://github.com/penpot/penpot
cd penpot

# Start with Docker Compose
docker-compose -f docker-compose.yaml up -d

# Access at http://localhost:9001
```

### Benefits of Self-Hosting

- **Full Control** - Own your data
- **Privacy** - No data sent to third parties
- **Customization** - Custom branding, features
- **No Limits** - Unlimited projects, users

## Troubleshooting

### Common Issues

**Q: Can't find Inter font**
```
A: Type "Inter" in font search
   If not available, use system font temporarily
   Or import from Google Fonts
```

**Q: Colors don't match VLN exactly**
```
A: Copy exact hex codes from design standards
   Paste into color picker
   Save to shared library
```

**Q: Prototype links not working**
```
A: Make sure interactions are set correctly
   Check destination artboard exists
   Try preview mode (Play button)
```

**Q: Export is blurry**
```
A: Export at @2x or @3x scale
   Use SVG for icons (vector, never blurry)
   Use PNG for photos/raster images
```

## Resources

### Official Penpot Resources

- **Website**: https://penpot.app
- **Documentation**: https://help.penpot.app
- **Community**: https://community.penpot.app
- **GitHub**: https://github.com/penpot/penpot
- **YouTube**: https://youtube.com/@penpot

### VLN Resources

- [Design System Colors](/design-system/colors)
- [Typography Guide](/design-system/typography)
- [Component Library](/design-system/components)
- [Design Tools Overview](/tools/design-tools)
- [Mockup Workflow](/tools/mockup-workflow)

## Next Steps

1. **Create Penpot Account** - https://penpot.app
2. **Import VLN Colors** - Use hex codes from this guide
3. **Set Up Typography** - Inter + JetBrains Mono
4. **Build First Component** - Start with button
5. **Share with Team** - Collaborate on designs

---

**Need Help?**
- Join Penpot Community: https://community.penpot.app
- Check Penpot Docs: https://help.penpot.app
- Ask in VLN Design Standards discussions

Happy designing! 🎨
