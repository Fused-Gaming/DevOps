---
id: ascii-design
title: ASCII Design & Wireframing
sidebar_position: 3
---

# ASCII Design & Wireframing

Rapid wireframing using ASCII art for quick iteration before moving to high-fidelity designs. Perfect for early-stage ideation, documentation, and collaboration.

## Why ASCII Design?

### Advantages

✅ **Lightning Fast**: No tools needed, just a text editor
✅ **Version Control Friendly**: Diffs show exactly what changed
✅ **Universal**: Works anywhere - issues, PRs, docs, emails
✅ **Low Fidelity**: Forces focus on structure, not pixels
✅ **Collaborative**: Easy to edit and iterate together
✅ **Documentation**: Lives alongside code

### When to Use

- **Early ideation**: Exploring layouts quickly
- **Issue descriptions**: Showing proposed UI changes
- **PR descriptions**: Documenting UI modifications
- **Documentation**: Explaining layouts in markdown
- **Async collaboration**: Sketching ideas in text
- **Rapid prototyping**: Before committing to design

## Basic Building Blocks

### Box Drawing Characters

```
┌─┬─┐  ╔═╦═╗  ╭─┬─╮  ┏━┳━┓
│ │ │  ║ ║ ║  │ │ │  ┃ ┃ ┃
├─┼─┤  ╠═╬═╣  ├─┼─┤  ┣━╋━┫
│ │ │  ║ ║ ║  │ │ │  ┃ ┃ ┃
└─┴─┘  ╚═╩═╝  ╰─┴─╯  ┗━┻━┛
```

### UI Elements

```
Button:     [  Click Me  ]   { Submit }   < Back >

Input:      [ Enter text here...        ]

Checkbox:   [x] Selected    [ ] Unselected

Radio:      (•) Selected    ( ) Unselected

Toggle:     [ON |   ]   [   | OFF]

Dropdown:   [ Select... ▼ ]

Icon:       ⚙ Settings   🔔 Notifications   ⭐ Favorite
```

### Layout Patterns

```
Header:
═══════════════════════════════════════
  LOGO    Nav   Nav   Nav   [Profile]
═══════════════════════════════════════

Sidebar Layout:
┌────────┬──────────────────────┐
│        │                      │
│ Sidebar│   Main Content       │
│        │                      │
│  Nav   │   Content            │
│  Nav   │                      │
│  Nav   │                      │
└────────┴──────────────────────┘

Card Grid:
┌────────┐ ┌────────┐ ┌────────┐
│ Card 1 │ │ Card 2 │ │ Card 3 │
│        │ │        │ │        │
│ [CTA]  │ │ [CTA]  │ │ [CTA]  │
└────────┘ └────────┘ └────────┘
```

## Real VLN Examples

### DevOps Dashboard

```
╔══════════════════════════════════════════════════════════════╗
║  VLN DEVOPS                          [🔔]  [⚙]  [@Profile]   ║
╚══════════════════════════════════════════════════════════════╝

┌────────────────────┬─────────────────────────────────────────┐
│                    │                                         │
│  📊 Dashboard      │  ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓  │
│  🚀 Deployments    │  ┃  Deployment Status               ┃  │
│  📝 Milestones     │  ┣━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┫  │
│  ⚙️  Settings      │  ┃  ✅ Production: Live             ┃  │
│                    │  ┃  🔄 Staging: Deploying...        ┃  │
│  ──────────────    │  ┃  ⏸️  Dev: Idle                   ┃  │
│                    │  ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛  │
│  👤 User           │                                         │
│  🚪 Logout         │  ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓  │
│                    │  ┃  Quick Actions                   ┃  │
└────────────────────┤  ┣━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┫  │
                     │  ┃  [  Deploy  ]  [  Rollback  ]   ┃  │
                     │  ┃  [ Restart  ]  [   Logs    ]    ┃  │
                     │  ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛  │
                     │                                         │
                     └─────────────────────────────────────────┘
```

### Login Page

```
                ╔════════════════════════════════╗
                ║                                ║
                ║           VLN LOGO             ║
                ║                                ║
                ║     Design Standards Portal    ║
                ║                                ║
                ╠════════════════════════════════╣
                ║                                ║
                ║  Email:                        ║
                ║  ┌──────────────────────────┐  ║
                ║  │ user@example.com         │  ║
                ║  └──────────────────────────┘  ║
                ║                                ║
                ║  Password:                     ║
                ║  ┌──────────────────────────┐  ║
                ║  │ ••••••••••••             │  ║
                ║  └──────────────────────────┘  ║
                ║                                ║
                ║  [x] Remember me               ║
                ║                                ║
                ║  ┌──────────────────────────┐  ║
                ║  │      SIGN IN             │  ║
                ║  └──────────────────────────┘  ║
                ║                                ║
                ║      Forgot password?          ║
                ║                                ║
                ╚════════════════════════════════╝
```

### Component Card

```
┌─────────────────────────────────────────────┐
│ ⭐ Featured Component                       │
├─────────────────────────────────────────────┤
│                                             │
│  Title: Deployment Status Card              │
│                                             │
│  Preview:                                   │
│  ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓  │
│  ┃ 🚀 Production                         ┃  │
│  ┃ Status: Live                          ┃  │
│  ┃ Last deploy: 2 hours ago              ┃  │
│  ┃ ────────────────────── 100%           ┃  │
│  ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛  │
│                                             │
│  [  View Code  ]  [  Use Component  ]      │
│                                             │
└─────────────────────────────────────────────┘
```

## Responsive Layouts

### Mobile (< 768px)

```
┌──────────────┐
│   Header     │
├──────────────┤
│              │
│   Content    │
│              │
│   Stack      │
│              │
│  Vertical    │
│              │
├──────────────┤
│   Footer     │
└──────────────┘
```

### Tablet (768px - 1024px)

```
┌─────────────────────────┐
│       Header            │
├──────────┬──────────────┤
│          │              │
│ Sidebar  │   Content    │
│          │              │
│          │   2 Columns  │
│          │              │
├──────────┴──────────────┤
│       Footer            │
└─────────────────────────┘
```

### Desktop (> 1024px)

```
┌────────────────────────────────────────┐
│              Header                    │
├──────────┬────────────────┬────────────┤
│          │                │            │
│ Sidebar  │     Main       │  Sidebar   │
│          │    Content     │    Right   │
│  Left    │                │            │
│          │   3 Columns    │            │
│          │                │            │
├──────────┴────────────────┴────────────┤
│              Footer                    │
└────────────────────────────────────────┘
```

## Flow Diagrams

### User Authentication Flow

```
                     ┌───────────┐
                     │   START   │
                     └─────┬─────┘
                           │
                           ▼
                  ┌─────────────────┐
                  │  Landing Page   │
                  └────────┬────────┘
                           │
                           ▼
                    ┌──────────────┐
          ┌─────────│ Authenticated?│─────────┐
          │         └──────────────┘         │
          │ YES                          NO  │
          ▼                                  ▼
    ┌──────────┐                    ┌───────────┐
    │Dashboard │                    │Login Page │
    └──────────┘                    └─────┬─────┘
                                          │
                                          ▼
                                   ┌──────────────┐
                                   │ Enter Creds  │
                                   └──────┬───────┘
                                          │
                                          ▼
                                    ┌──────────┐
                              ┌─────│ Valid?   │─────┐
                              │     └──────────┘     │
                         YES  │                      │ NO
                              ▼                      ▼
                        ┌──────────┐          ┌──────────┐
                        │Dashboard │          │  Error   │
                        └──────────┘          └────┬─────┘
                                                   │
                                                   └──┐
                                                      │
                                                      ▼
                                                 ┌─────────┐
                                                 │Retry    │
                                                 └─────────┘
```

### Component Hierarchy

```
App
├── Header
│   ├── Logo
│   ├── Navigation
│   │   ├── NavItem
│   │   ├── NavItem
│   │   └── NavItem
│   └── UserMenu
│       ├── Avatar
│       └── Dropdown
├── Sidebar
│   ├── MenuItem
│   ├── MenuItem
│   └── MenuItem
├── MainContent
│   ├── StatusCards
│   │   ├── StatusCard (Sage)
│   │   ├── StatusCard (Sky)
│   │   └── StatusCard (Amber)
│   ├── QuickActions
│   │   └── ActionButton[]
│   └── DeploymentList
│       └── DeploymentItem[]
└── Footer
    ├── Copyright
    └── Links
```

## Data Tables

```
┌──────────────┬──────────────┬──────────┬────────────┐
│ Name         │ Status       │ Updated  │ Actions    │
├──────────────┼──────────────┼──────────┼────────────┤
│ production   │ ✅ Live      │ 2h ago   │ [View]     │
│ staging      │ 🔄 Deploying │ 5m ago   │ [Cancel]   │
│ development  │ ⏸️  Idle     │ 1d ago   │ [Deploy]   │
└──────────────┴──────────────┴──────────┴────────────┘
```

## State Variations

### Button States

```
Default:    [  Click Me  ]

Hover:      [  Click Me  ]  ← Sage glow
             ~~~~~~~~~~~~

Active:     [  Click Me  ]  ← Pressed state
            ═══════════════

Disabled:   [  Click Me  ]  ← Grayed out
            (disabled)

Loading:    [  ⟳ Loading... ]
```

### Form Validation

```
Valid:
┌──────────────────────────┐
│ john@example.com         │ ✅
└──────────────────────────┘

Invalid:
┌──────────────────────────┐
│ invalid-email            │ ❌ Invalid email format
└──────────────────────────┘

Required:
┌──────────────────────────┐
│                          │ ⚠️ This field is required
└──────────────────────────┘
```

## Tools for ASCII Art

### Online Tools

1. **ASCIIFlow** (https://asciiflow.com)
   - Draw boxes and lines
   - Export as text
   - Great for diagrams

2. **Textik** (https://textik.com)
   - Interactive ASCII drawing
   - Save and share

3. **Monodraw** (macOS)
   - Professional ASCII tool
   - $9.99 one-time purchase

### VS Code Extensions

```bash
# Install ASCII Art extension
code --install-extension aaron-bond.better-comments

# ASCII Tree Generator
code --install-extension me-dutour-mathieu.vscode-github-actions
```

### Characters Cheat Sheet

```
Single Line Box:
┌ ─ ┬ ┐
│   │
├ ─ ┼ ┤
└ ─ ┴ ┘

Double Line Box:
╔ ═ ╦ ╗
║   ║
╠ ═ ╬ ╣
╚ ═ ╩ ╝

Rounded Box:
╭ ─ ┬ ╮
│   │
├ ─ ┼ ┤
╰ ─ ┴ ╯

Heavy Box:
┏ ━ ┳ ┓
┃   ┃
┣ ━ ╋ ┫
┗ ━ ┻ ┛

Arrows:
← → ↑ ↓ ↔ ↕ ⇐ ⇒ ⇑ ⇓

Symbols:
✓ ✗ ★ ☆ ♥ ● ○ ■ □ ▲ ▼ ◆ ◇

Bullets:
• ‣ ⁃ ◦ ▪ ▫
```

## Workflow: ASCII to High-Fidelity

### Step 1: ASCII Wireframe (5 min)

```
┌─────────────────────────────┐
│  LOGO    Nav  Nav  Nav      │
├─────────────────────────────┤
│                             │
│    Hero Heading             │
│    Subheading text          │
│    [  Get Started  ]        │
│                             │
├─────────────┬───────────────┤
│   Feature 1 │  Feature 2    │
│   Icon      │  Icon         │
│   Text      │  Text         │
└─────────────┴───────────────┘
```

### Step 2: Penpot Design (30 min)

- Import VLN color tokens
- Add actual content
- Apply typography
- Add spacing/padding
- Include real icons

### Step 3: Development (varies)

```tsx
// Translate ASCII structure to React components
<Layout>
  <Header logo={Logo} navigation={Nav} />
  <Hero
    heading="Hero Heading"
    subheading="Subheading text"
    cta="Get Started"
  />
  <Features>
    <FeatureCard icon={Icon1} title="Feature 1" />
    <FeatureCard icon={Icon2} title="Feature 2" />
  </Features>
</Layout>
```

## Best Practices

✅ **Do**:
- Use ASCII for early ideation
- Include in issue descriptions
- Version control wireframes
- Keep it simple and clear
- Focus on structure, not details

❌ **Don't**:
- Spend too long perfecting ASCII
- Use for final designs
- Include too much detail
- Forget to move to high-fidelity
- Use for client presentations

## Examples in Issues/PRs

### GitHub Issue Template

```markdown
## Proposed UI

\`\`\`
┌────────────────────────────┐
│  New Dashboard Widget      │
├────────────────────────────┤
│  📊 Metrics                │
│  ─────────────── 75%       │
│  ↑ 12% from last week      │
│                            │
│  [View Details]            │
└────────────────────────────┘
\`\`\`

### Acceptance Criteria
- [ ] Widget displays current metrics
- [ ] Progress bar shows percentage
- [ ] Comparison with previous week
- [ ] CTA button navigates to details
```

## Related

- [Mockup Workflow](/tools/mockup-workflow) - Next step after ASCII
- [Design Tools](/tools/design-tools) - Tools for high-fidelity designs
- [Prototyping](/tools/prototyping) - Interactive prototypes

## Resources

- [ASCIIFlow](https://asciiflow.com) - Draw ASCII diagrams
- [Textik](https://textik.com) - ASCII drawing tool
- [Box Drawing Unicode](https://en.wikipedia.org/wiki/Box-drawing_character) - Character reference
- [ASCII Art Generator](https://www.ascii-art-generator.org/) - Text to ASCII
