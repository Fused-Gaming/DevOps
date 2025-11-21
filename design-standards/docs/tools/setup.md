---
id: setup
title: Development Setup
sidebar_position: 5
---

# Development Setup

Set up your local development environment for VLN projects.

## Prerequisites

```bash
# Check versions
node --version  # Should be 20+
pnpm --version  # Should be 8+
git --version
```

## Clone Repository

```bash
git clone https://github.com/Fused-Gaming/DevOps.git
cd DevOps/devops-panel
```

## Install Dependencies

```bash
pnpm install
```

## Start Dev Server

```bash
pnpm dev
```

Visit `http://localhost:3000`

## Recommended VS Code Extensions

- ESLint
- Prettier
- Tailwind CSS IntelliSense
- TypeScript and JavaScript Language Features

See [Component Development](/tools/component-development) for next steps.
