# 🔧 Integration Guide for Developers

Complete guide for integrating Claude Agent Prompts into any project.

## 📋 Table of Contents

- [Overview](#overview)
- [System Requirements](#system-requirements)
- [Integration Methods](#integration-methods)
- [Project Structure](#project-structure)
- [Advanced Configuration](#advanced-configuration)
- [Troubleshooting](#troubleshooting)
- [Best Practices](#best-practices)

## Overview

This library provides a comprehensive integration system with three key components:

1. **Interactive CLI Tool** (`integrate.js`) - Browse and select agents
2. **Quick Integration Script** (`quick-integrate.sh`) - Fast preset-based integration
3. **Manual Integration** - Direct file copying for advanced users

## System Requirements

### Required
- **Claude Code** - AI coding assistant
- **File System Access** - Read/write permissions

### Optional
- **Node.js 18+** - For interactive CLI tool
- **Bash Shell** - For quick integration script
- **Git** - For GitHub integration agents
- **GitHub CLI (gh)** - For enhanced GitHub features

## Integration Methods

### Method 1: Interactive CLI

**Best for:** First-time users, exploration, custom selections

```bash
# Navigate to agent-prompts directory
cd agent-prompts

# Run interactive tool
./integrate.js
```

**Features:**
- Browse 9 categories with breadcrumbs
- Search by keyword across all agents
- Preview agent details and capabilities
- Multi-select agents with visual indicators
- Generate custom integration scripts
- Use pre-configured quick presets

**Navigation:**
```
1-9   → Select menu option
0     → Go back
q     → Quit
a     → Select/deselect all (in category view)
```

### Method 2: Quick Integration Script

**Best for:** Automation, CI/CD, experienced users

```bash
# Basic usage
./quick-integrate.sh [preset]

# Available presets
./quick-integrate.sh fullstack   # Full-stack development
./quick-integrate.sh github      # GitHub workflow
./quick-integrate.sh quality     # Code quality
./quick-integrate.sh sparc       # SPARC methodology
./quick-integrate.sh swarm       # Swarm intelligence
./quick-integrate.sh minimal     # Essential only
./quick-integrate.sh all         # Everything

# Custom options
./quick-integrate.sh github --target custom-agents
./quick-integrate.sh fullstack --project-root /path/to/project

# List available agents
./quick-integrate.sh --list

# Show help
./quick-integrate.sh --help
```

### Method 3: Manual Integration

**Best for:** Advanced users, custom organization, CI/CD

```bash
# Copy entire categories
cp -r agent-prompts/core .claude/agents/
cp -r agent-prompts/github .claude/agents/

# Copy specific agents
cp agent-prompts/core/coder.md .claude/agents/core/
cp agent-prompts/github/pr-manager.md .claude/agents/github/

# Copy everything
cp -r agent-prompts/* .claude/agents/
```

## Project Structure

### Directory Layout

```
your-project/
├── .claude/
│   ├── agents/              # Integrated agent prompts
│   │   ├── core/           # Core development agents
│   │   │   ├── coder.md
│   │   │   ├── tester.md
│   │   │   ├── reviewer.md
│   │   │   └── planner.md
│   │   ├── github/         # GitHub integration
│   │   │   ├── pr-manager.md
│   │   │   └── code-review-swarm.md
│   │   └── sparc/          # SPARC methodology
│   │       └── specification.md
│   ├── settings.json       # Claude Code settings
│   └── config.json         # Custom configuration
├── src/                    # Your source code
└── package.json
```

### Agent File Structure

Each agent file contains:

```yaml
---
name: coder
type: developer
color: "#FF6B35"
description: Implementation specialist
capabilities:
  - code_generation
  - refactoring
priority: high
author: "Fused Gaming"
---

# Agent Instructions
[Detailed markdown content]
```

## Advanced Configuration

### Custom Agent Selection

Create a custom integration script:

```bash
#!/bin/bash
# my-custom-integration.sh

TARGET=".claude/agents"
mkdir -p $TARGET

# Select specific agents
cp agent-prompts/core/coder.md $TARGET/core/
cp agent-prompts/core/tester.md $TARGET/core/
cp agent-prompts/github/pr-manager.md $TARGET/github/
cp agent-prompts/sparc/specification.md $TARGET/sparc/

echo "✓ Custom integration complete"
```

### Programmatic Integration (Node.js)

```javascript
const fs = require('fs');
const path = require('path');

const catalog = require('./agent-prompts/catalog.json');
const targetDir = '.claude/agents';

// Select agents by capability
const selectedAgents = Object.entries(catalog.categories)
  .flatMap(([catKey, cat]) =>
    cat.agents.filter(agent =>
      agent.capabilities?.includes('code_generation')
    )
  );

// Copy selected agents
selectedAgents.forEach(agent => {
  const source = path.join('agent-prompts', agent.file);
  const target = path.join(targetDir, agent.file);

  fs.mkdirSync(path.dirname(target), { recursive: true });
  fs.copyFileSync(source, target);

  console.log(`✓ Integrated ${agent.name}`);
});
```

### Environment Variables

Configure integration behavior:

```bash
# Set default target directory
export CLAUDE_AGENTS_DIR=".claude/agents"

# Set project root
export PROJECT_ROOT="/path/to/project"

# Use in scripts
./quick-integrate.sh github --target $CLAUDE_AGENTS_DIR
```

### CI/CD Integration

#### GitHub Actions

```yaml
# .github/workflows/setup-claude.yml
name: Setup Claude Agents

on:
  workflow_dispatch:
  push:
    branches: [main]

jobs:
  integrate:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3

      - name: Integrate Claude Agents
        run: |
          chmod +x agent-prompts/quick-integrate.sh
          ./agent-prompts/quick-integrate.sh fullstack

      - name: Commit integrated agents
        run: |
          git config user.name "GitHub Actions"
          git config user.email "actions@github.com"
          git add .claude/agents/
          git commit -m "chore: integrate Claude agents" || true
          git push
```

#### GitLab CI

```yaml
# .gitlab-ci.yml
integrate_agents:
  stage: setup
  script:
    - chmod +x agent-prompts/quick-integrate.sh
    - ./agent-prompts/quick-integrate.sh github
  artifacts:
    paths:
      - .claude/agents/
```

## Troubleshooting

### Common Issues

#### 1. "Permission Denied" Errors

```bash
# Fix script permissions
chmod +x agent-prompts/integrate.js
chmod +x agent-prompts/quick-integrate.sh
```

#### 2. "Node.js Not Found"

```bash
# Install Node.js (Ubuntu/Debian)
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt-get install -y nodejs

# Install Node.js (macOS)
brew install node@18
```

#### 3. "Catalog Not Found"

```bash
# Ensure you're in the correct directory
cd agent-prompts
./integrate.js

# Or use absolute paths
/path/to/agent-prompts/integrate.js
```

#### 4. Agents Not Recognized by Claude Code

```bash
# Verify directory structure
ls -la .claude/agents/

# Expected structure:
# .claude/agents/core/coder.md
# .claude/agents/github/pr-manager.md

# Check file permissions
chmod -R 644 .claude/agents/*.md
```

#### 5. Integration Script Fails

```bash
# Check source directory exists
test -d agent-prompts && echo "✓ Found" || echo "✗ Not found"

# Check target is writable
test -w .claude/agents && echo "✓ Writable" || echo "✗ Not writable"

# Run with verbose output
bash -x ./quick-integrate.sh fullstack
```

## Best Practices

### 1. Version Control

```bash
# Add to .gitignore if you don't want to commit agents
echo ".claude/agents/" >> .gitignore

# Or commit them for team consistency
git add .claude/agents/
git commit -m "feat: integrate Claude agent prompts"
```

### 2. Team Integration

Share with your team:

```bash
# Create team preset
cat > team-preset.sh << 'EOF'
#!/bin/bash
./quick-integrate.sh fullstack
./quick-integrate.sh github
echo "✓ Team agents integrated"
EOF

chmod +x team-preset.sh

# Document in README
echo "## Setup" >> README.md
echo "Run \`./team-preset.sh\` to integrate Claude agents" >> README.md
```

### 3. Incremental Integration

Start small, expand as needed:

```bash
# Week 1: Core agents only
./quick-integrate.sh minimal

# Week 2: Add GitHub integration
cp -r agent-prompts/github .claude/agents/

# Week 3: Add SPARC methodology
cp -r agent-prompts/sparc .claude/agents/

# Week 4: Full integration
./quick-integrate.sh all
```

### 4. Custom Workflows

Create workflow-specific integrations:

```bash
# Feature development workflow
cat > integrate-feature-dev.sh << 'EOF'
#!/bin/bash
mkdir -p .claude/agents/{core,testing,github}
cp agent-prompts/core/planner.md .claude/agents/core/
cp agent-prompts/core/coder.md .claude/agents/core/
cp agent-prompts/testing/tdd-london-swarm.md .claude/agents/testing/
cp agent-prompts/github/pr-manager.md .claude/agents/github/
EOF

# Bug fixing workflow
cat > integrate-bug-fix.sh << 'EOF'
#!/bin/bash
mkdir -p .claude/agents/{core,analysis}
cp agent-prompts/core/reviewer.md .claude/agents/core/
cp agent-prompts/core/tester.md .claude/agents/core/
cp agent-prompts/analysis/code-analyzer.md .claude/agents/analysis/
EOF
```

### 5. Documentation

Document your integration:

```bash
# Create AGENTS.md in your project
cat > .claude/AGENTS.md << 'EOF'
# Integrated Claude Agents

## Active Agents
- **coder** - Code implementation
- **tester** - Test generation
- **reviewer** - Code review
- **pr-manager** - GitHub PR management

## Usage
Use agents by referencing them in prompts:
\`\`\`
Use the coder agent to implement authentication
\`\`\`

## Integration Date
$(date)

## Source
Integrated from Fused Gaming Agent Prompts Library
EOF
```

## Integration Patterns

### Pattern 1: Solo Developer

```bash
# Minimal setup for individual work
./quick-integrate.sh minimal

# Use in prompts:
# "Use coder to implement this feature"
# "Use tester to write unit tests"
# "Use reviewer to check my code"
```

### Pattern 2: Team Development

```bash
# Full-stack + GitHub for team coordination
./quick-integrate.sh fullstack
./quick-integrate.sh github

# Team workflow:
# 1. Planner breaks down features
# 2. Coder implements
# 3. Tester writes tests
# 4. PR-manager handles reviews
```

### Pattern 3: Open Source Project

```bash
# Quality + GitHub + Documentation
./quick-integrate.sh quality
./quick-integrate.sh github
cp -r agent-prompts/documentation .claude/agents/

# Maintainer workflow:
# 1. Issue-tracker triages issues
# 2. Code-review-swarm reviews PRs
# 3. Production-validator tests releases
```

### Pattern 4: Enterprise Development

```bash
# Everything for comprehensive workflows
./quick-integrate.sh all

# Enterprise workflow:
# 1. SPARC methodology for planning
# 2. Swarm coordination for large tasks
# 3. Performance monitoring
# 4. Security review
```

## Support

### Getting Help

1. **Documentation** - Read [README.md](README.md) and [QUICKSTART.md](QUICKSTART.md)
2. **Examples** - Check individual agent files for detailed instructions
3. **Issues** - Open GitHub issue for bugs or questions
4. **Community** - Join discussions on GitHub

### Contributing

To contribute improvements:

1. Fork the repository
2. Make your changes
3. Test integration thoroughly
4. Submit pull request

---

**Integration support provided by Fused Gaming**
