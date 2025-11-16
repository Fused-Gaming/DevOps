# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is **[PROJECT_NAME]** - [brief 1-2 sentence description of the project and its purpose].

**Current Status**: [MVP/Alpha/Beta/Production] - [brief status description]

**Tech Stack**:
- **Framework**: [Next.js/React/Vue/etc.] [version]
- **Language**: [TypeScript/JavaScript] [version]
- **Styling**: [Tailwind CSS/CSS-in-JS/SCSS/etc.]
- **UI Components**: [Component library if any]
- **Database**: [PostgreSQL/MongoDB/etc.] with [Prisma/TypeORM/etc.]
- **Authentication**: [NextAuth.js/Auth0/etc.] [(planned)]
- **Payments**: [Stripe/PayPal/etc.] [(planned)]
- **Package Manager**: [pnpm/npm/yarn]
- **Deployment**: [Vercel/Netlify/AWS/etc.]

## Commands

### Development
```bash
[pnpm/npm/yarn] dev              # Start development server
[pnpm/npm/yarn] build            # Production build (must pass before merging)
[pnpm/npm/yarn] start            # Run production build locally
[pnpm/npm/yarn] lint             # Run linter
[pnpm/npm/yarn] test             # Run tests
```

### Git Workflow
See parallel branch strategy below. Key points:

**Current Integration Branch**: `integration/[branch-name]`
- All feature branches should be created from and merged back into this branch
- Do NOT merge directly to `main` - integration branch will be merged to main when ready
- Run `[build command]` before every merge to ensure stability

**Feature Branch Pattern**: `feature/<feature-name>`
```bash
# Create new feature branch
git checkout integration/[branch-name]
git pull
git checkout -b feature/[feature-name]

# Verify build works before merging
[pnpm/npm/yarn] build

# Create PR to integration branch (not main)
gh pr create --base integration/[branch-name] \
  --title "feat(scope): [description]"
```

**Commit Convention**: Conventional Commits format
- `feat(scope): description` - New features
- `fix(scope): description` - Bug fixes
- `refactor(scope): description` - Code refactoring
- `docs: description` - Documentation only
- `style: description` - Formatting/styling only
- `test: description` - Adding tests
- `chore: description` - Dependencies, tooling

## Architecture

### Directory Structure
```
[Framework-specific structure - update based on your stack]

app/  (or src/)
├── [routes/pages]/
├── components/
│   ├── [ComponentName].tsx
│   └── ui/
├── api/
├── lib/
└── [layout/app].tsx

docs/
├── design/                 # Design system (mockups, flows, tokens)
├── devops/                 # DevOps documentation (CI/CD, deployment, testing)
├── planning/               # Roadmaps and checklists
├── technical/              # Technical specifications
└── guides/                 # Setup and deployment guides
```

### Color System & Theming

**Important**: [Describe your color philosophy and brand identity]

**Color Palette**:
- **Primary**: [Color] ([Hex]) - [Usage description]
- **Primary Light**: [Color] ([Hex]) - Hover states
- **Primary Dark**: [Color] ([Hex]) - Active states
- **Secondary**: [Color] - [Usage description]
- **Accent**: [Color] - [Usage description]
- **Gradient**: [Description]
  - CSS: `[gradient value]`

**CSS Design Tokens** (defined in `[path to main CSS file]`):
```css
--color-primary: [hex];           /* [Description] */
--color-primary-light: [hex];     /* Hover states */
--color-primary-dark: [hex];      /* Active states */
--color-secondary: [hex];         /* [Description] */
--color-accent: [hex];            /* [Description] */
--gradient-primary: [gradient];
```

**Usage in Components**:
```tsx
// ✅ Using framework color classes
<button className="bg-[primary] hover:bg-[primary-light]">Button</button>

// ✅ Using CSS variables
<div style={{ color: 'var(--color-primary)' }}>

// ✅ Dark backgrounds with transparency
<div className="bg-black/70 backdrop-blur-md">
```

**Reference**: See `docs/design/tokens/DESIGN_TOKENS.md` for complete design token specifications.

### Font System

[Number] fonts are configured:
- **[Primary Font]**: [Description]
  - Weights: [weights list]
  - Variable: `--font-[name]`
- **[Secondary Font]**: [Description]
  - Weights: [weights list]
  - Variable: `--font-[name]`

These are loaded via `[loading method]` for automatic optimization.

**Typography Scale** (CSS Design Tokens):
```css
--font-primary: '[Font]', [fallbacks];
--font-secondary: '[Font]', [fallbacks];

--font-xs: 0.75rem;      /* 12px */
--font-sm: 0.875rem;     /* 14px */
--font-base: 1rem;       /* 16px */
--font-lg: 1.125rem;     /* 18px */
--font-xl: 1.25rem;      /* 20px */
--font-2xl: 1.5rem;      /* 24px */
--font-3xl: 1.875rem;    /* 30px */
--font-4xl: 2.25rem;     /* 36px */
--font-5xl: 3rem;        /* 48px */
```

**Reference**: See `docs/design/tokens/DESIGN_TOKENS.md` for complete typography specifications.

### Logo System

**Logo File**: `/public/[logo-file]`
- **Dimensions**: [width]x[height]px
- **Format**: [SVG/PNG/etc.]
- **Usage**: Navigation, footer, social media

**Logo Integration in CSS** (`[path to main CSS]`):
```css
.logo {
  width: [size];
  height: [size];
  transition: filter var(--duration-300) var(--ease-in-out);
}

.logo:hover {
  filter: drop-shadow(0 0 8px var(--color-primary));
}

/* Responsive sizing */
@media (min-width: [breakpoint]) {
  .logo {
    width: [larger-size];
    height: [larger-size];
  }
}
```

**Logo Usage in Components**:
```tsx
import Image from '[framework image component]'

<Image
  src="/[logo-file]"
  alt="[Project Name]"
  width={[size]}
  height={[size]}
  className="logo"
/>
```

### Component Patterns

**Client vs Server Components** (if applicable):
- Most components should be Server Components by default
- Use `'use client'` only when needed (useState, useEffect, event handlers)
- Current client components: [list]

**Accessibility Requirements**:
- All interactive elements must have proper ARIA labels
- Keyboard navigation must work fully (test with Tab key)
- Focus states must be visible
- Semantic HTML (nav, header, section, main, footer, etc.)
- Minimum touch target size: 44x44px for mobile
- Color contrast ratios meeting WCAG AA standards

**Responsive Design**:
- Mobile-first approach (design for mobile, enhance for desktop)
- Breakpoints: [xs], [sm], [md], [lg], [xl]
- Test all pages at: [mobile], [tablet], [desktop] breakpoints

### State Management

**Current State**: [Description of current state management approach]

**Planned State Management** (if applicable):
- **[Library]** for global state:
  - [Use case 1]
  - [Use case 2]
  - [Use case 3]

### Styling Approach

**[CSS Framework] [Approach]**:
- [Description of styling methodology]
- Responsive classes: [prefix examples]
- Custom patterns: [examples]

**Color Usage**:
```tsx
// ✅ Correct - Use framework color classes
<div className="text-[color] bg-[color]">

// ✅ Correct - Custom gradients
<div className="bg-gradient-to-b from-[color] via-[color] to-[color]">

// ✅ Correct - Transparency
<div className="bg-[color]/70 backdrop-blur-md">
```

### Container & Layout System

**Max Container Width**: [width]px
- All content should be constrained to this width on larger screens
- Use padding for mobile/tablet to ensure content doesn't touch edges

```css
--container-max: [width]px;
--container-padding: [size];
```

**Responsive Breakpoints**:
```css
--breakpoint-xs: [size]px;   /* Mobile small */
--breakpoint-sm: [size]px;   /* Mobile large / Phablet */
--breakpoint-md: [size]px;   /* Tablet */
--breakpoint-lg: [size]px;   /* Desktop */
--breakpoint-xl: [size]px;   /* Wide desktop */
```

**Reference**: See `docs/design/tokens/DESIGN_TOKENS.md` for complete spacing and layout specifications.

## Design System

### Mockups & Wireframes

**Available Mockups** (ASCII wireframes in `docs/design/mockups/`):
1. **[PAGE_1].md** - [Description]
2. **[PAGE_2].md** - [Description]
3. **[PAGE_3].md** - [Description]
4. **[FLOW].md** - [Description]
5. **[DASHBOARD].md** - [Description]

All mockups show responsive layouts for:
- Desktop ([width]px)
- Tablet ([width]px)
- Mobile ([width]px)

**Reference**: See `docs/design/README.md` for complete design system overview.

### User Flows

**Available User Journey Diagrams** (`docs/design/flows/`):
1. **USER_FLOWS.md** - [Number] complete user journeys with decision trees
2. **[PRIMARY_JOURNEY].md** - Detailed [number]-stage [process name]

Flows cover:
- [Flow 1 description]
- [Flow 2 description]
- [Flow 3 description]
- [Flow 4 description]

### Component Library

**Component Inventory**: [Number]+ components documented in `docs/design/tokens/COMPONENT_LIBRARY.md`

**Categories**:
1. **[Category 1]** ([count]) - [Components list]
2. **[Category 2]** ([count]) - [Components list]
3. **[Category 3]** ([count]) - [Components list]
4. **[Category 4]** ([count]) - [Components list]
5. **[Category 5]** ([count]) - [Components list]

**Current Status**: [X]/[Total] implemented ([Component names])

**Priority Levels**:
- **High**: Core MVP components ([examples])
- **Medium**: Enhanced features ([examples])
- **Low**: Nice-to-haves ([examples])

**Reference**: See `docs/design/STATUS.md` for implementation tracking.

## DevOps & CI/CD

### CI/CD Pipeline

**[Number]-Stage Pipeline** (GitHub Actions):
1. **Code Quality** - [Linter], [Formatter], [Type checker]
2. **Security** - [Tools list]
3. **Build** - [Build description]
4. **Test** - [Test types]
5. **Preview** - [Preview deployment description]
6. **Performance** - [Performance tools]
7. **Deploy** - [Deployment description]

**GitHub Actions Workflows** (`.github/workflows/`):
- **ci.yml** - Main CI pipeline
- **preview-deploy.yml** - Automatic preview deployments for PRs
- **lighthouse.yml** - Performance budgets and audits (if applicable)
- **security-scan.yml** - Security scans

**Performance Budgets** (if enforced):
- Performance: >[score]
- Accessibility: >[score]
- Best Practices: >[score]
- SEO: >[score]

**Reference**: See `docs/devops/` for complete CI/CD documentation.

### Testing Strategy

**Test Pyramid** ([unit]% unit, [integration]% integration, [e2e]% E2E):
- **Unit Tests**: [Framework] + [Library]
- **Integration Tests**: [Description]
- **E2E Tests**: [Framework] for critical user flows

**Reference**: See `docs/devops/TESTING.md` for testing strategy.

### Branch Strategy

**Protected Branches**:
- `main` - Production (protected, requires PR, passing checks)
- `integration/[name]` - Integration branch (all features merge here first)

**Branch Types**:
- `feature/*` - New features (merge to integration)
- `fix/*` - Bug fixes (merge to integration)
- `hotfix/*` - Emergency fixes (merge to main + integration)
- `claude/*` - Claude Code sessions (merge to integration)

**Reference**: See `docs/devops/BRANCH_STRATEGY.md` for complete workflow.

### Deployment

**Platform**: [Platform name]
- **Production**: Auto-deploy from `main` branch
- **Preview**: Auto-deploy from PRs to `main` or `integration/*`
- **Domain**: [Domain or TBD]

**Environment Variables** (required):
- `DATABASE_URL` - [Description]
- `[VAR_NAME]` - [Description]
- `[VAR_NAME]` - [Description]

**Reference**: See `docs/devops/DEPLOYMENT.md` for deployment guide.

## Development Guidelines

### When Adding New Components

1. **Location**: Place in appropriate subfolder of `[components path]`
   - Layout components: `[path]`
   - Feature-specific: `[path]`
   - Reusable UI: `[path]`

2. **TypeScript**: All components must be typed
   ```tsx
   interface [Component]Props {
     [prop]: [type]
     children?: React.ReactNode
   }

   export function [Component]({ [prop], ... }: [Component]Props) {
   ```

3. **Accessibility**: Include ARIA attributes, semantic HTML, keyboard support

4. **Responsive**: Use responsive classes ([sm:], [md:], [lg:])

5. **Theme-aware**: Support both light and dark themes via CSS variables (if applicable)

### When Building New Features

Follow this workflow for all new features:

1. **Create feature branch** from `integration/[name]`
2. **Build component** with [language] types
3. **Test responsive design** (mobile → tablet → desktop)
4. **Verify build passes**: `[build command]`
5. **Create PR** to integration branch
6. **Merge after review** and delete feature branch

### Accessibility Standards

Aim for WCAG AA compliance:
- Normal text: 4.5:1 contrast ratio minimum
- Large text (18pt+): 3:1 minimum
- Interactive elements: visible focus states
- Forms: proper labels and error messages
- Images: descriptive alt text

Test with browser DevTools accessibility panel before committing.

### Build Verification

**ALWAYS run `[build command]` before creating PRs**. The build:
- Type-checks all [language]
- Verifies [framework] can compile pages
- Catches many runtime errors

Common build errors:
- [Common error 1]
- [Common error 2]
- [Common error 3]

## MVP Development Strategy

### Development Tracks (Run in Parallel)

**TRACK 1: [Track Name]** [emoji]
- [Task 1]
- [Task 2]
- [Task 3]
- Duration: [X-Y] days

**TRACK 2: [Track Name]** [emoji]
- [Task 1]
- [Task 2]
- [Task 3]
- Duration: [X-Y] days
- **CRITICAL PATH** - blocks other tracks (if applicable)

**TRACK 3: [Track Name]** [emoji]
- [Task 1]
- [Task 2]
- [Task 3]
- Duration: [X-Y] days
- Dependencies: TRACK [X]

[Continue for all tracks...]

### Post-MVP Features (Deferred)

- [Feature 1]
- [Feature 2]
- [Feature 3]
- [Feature 4]

### Technical Decisions

- **Database**: [Choice] ([Reason])
- **Payments**: [Choice] ([Reason])
- **Authentication**: [Choice] ([Reason])
- **Email**: [Choice] ([Reason])
- **Images**: [Choice] ([Reason])
- **Analytics**: [Choice] ([Reason])

## Important Constraints

1. **No Direct Main Merges**: All work goes through `integration/[name]` first
2. **Build Must Pass**: Run `[build command]` successfully before any PR
3. **Mobile First**: Design and test mobile ([size]px) before desktop
4. **[Language]**: All components must be properly typed (avoid `any`)
5. **Responsive**: Test at [size1]px, [size2]px, [size3]px breakpoints
6. **Accessibility**: WCAG AA compliance minimum
7. **Performance**: [Performance requirement]

## Common Tasks

### Add a New Page
```bash
# Create page file
mkdir -p [path]
touch [path]/[file]

# Build the page component
# Test responsive design
# Verify build passes

[build command]
git add .
git commit -m "feat([scope]): add [page name] page"
```

### Add API Endpoint
```bash
# Create API route
mkdir -p [api path]
touch [api path]/[file]

# Implement handlers
# Test with curl or Postman
# Verify build passes

[build command]
git add .
git commit -m "feat(api): add [endpoint name] endpoint"
```

### Add New Dependency
```bash
[package manager] add <package-name>           # Production dependency
[package manager] add -D <package-name>        # Dev dependency

# Update package.json
# Test that build still works
[build command]

git add package.json [lockfile]
git commit -m "chore(deps): add <package-name>"
```

## Path Aliases

[Language/Framework] is configured with path aliases in `[config file]`:
- `@/*` maps to [path]

Usage:
```tsx
import [Component] from '@/[path]'
import [Util] from '@/[path]'
```

## Documentation Hub

### Internal Documentation

**Design System** (`docs/design/`):
- [Design System README](docs/design/README.md) - Complete overview
- [Implementation Status](docs/design/STATUS.md) - Component progress tracking
- [Design Tokens](docs/design/tokens/DESIGN_TOKENS.md) - CSS variables, colors, typography
- [Component Library](docs/design/tokens/COMPONENT_LIBRARY.md) - Component inventory
- [Mockups](docs/design/mockups/) - Wireframe files
- [User Flows](docs/design/flows/) - Journey diagrams

**DevOps** (`docs/devops/`):
- [DevOps README](docs/devops/README.md) - CI/CD architecture overview
- [CI/CD Setup](docs/devops/CI_CD_SETUP.md) - Complete pipeline documentation
- [Deployment Guide](docs/devops/DEPLOYMENT.md) - Deployment instructions
- [Testing Strategy](docs/devops/TESTING.md) - Test pyramid and frameworks
- [Branch Strategy](docs/devops/BRANCH_STRATEGY.md) - Git workflow and conventions

**Planning** (`docs/planning/`):
- [Engineering Plan](docs/planning/engineering-plan.md) - Roadmap
- [Development Checklist](docs/planning/development-checklist.md) - Task items

**Technical** (`docs/technical/`):
- [Technical Specification](docs/technical/technical-specification.md) - Architecture decisions

**Guides** (`docs/guides/`):
- [Quick Start Guide](docs/guides/quick-start-guide.md) - Setup instructions
- [Deployment Guide](docs/guides/deployment-guide.md) - Deployment walkthrough

**Other**:
- [KICKSTARTER_CLAUDE.md](KICKSTARTER_CLAUDE.md) - Generic template for design/DevOps kickstart
- [CLAUDE_USAGE.md](CLAUDE_USAGE.md) - Token usage tracking for billing
- [docs/README.md](docs/README.md) - Documentation hub index

### External Reference Documentation

**Framework & Tools**:
- [[Framework]](https://[url]) - [Description]
- [[Tool]](https://[url]) - [Description]

**Backend & Database**:
- [[Database]](https://[url]) - [Description]
- [[ORM]](https://[url]) - [Description]

**Payments & Services**:
- [[Service]](https://[url]) - [Description]

**DevOps & Deployment**:
- [[Platform]](https://[url]) - [Description]
- [[CI/CD]](https://[url]) - [Description]

**Testing**:
- [[Framework]](https://[url]) - [Description]

## Project Identity

**Name**: [Project Name]
**Tagline**: "[Project Tagline]"
**Focus**: [Project focus and unique value proposition]
**Brand Colors**: [Primary], [Secondary], [Accent]
**Target Audience**: [Target audience description]
