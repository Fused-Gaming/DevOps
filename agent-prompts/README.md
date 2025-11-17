# 🤖 Claude Agent Prompts Library

> **Comprehensive collection of 76+ specialized agent prompts for Claude Code**
> Organized, categorized, and ready to integrate into any project

[![Version](https://img.shields.io/badge/version-1.1.0-blue.svg)](RELEASES.md)
[![Agents](https://img.shields.io/badge/agents-76+-brightgreen.svg)]()
[![Categories](https://img.shields.io/badge/categories-9-orange.svg)]()
[![License](https://img.shields.io/badge/license-MIT-green.svg)]()
[![Node](https://img.shields.io/badge/node-%3E%3D18.0.0-brightgreen.svg)]()
[![Automation](https://img.shields.io/badge/automation-3_levels-purple.svg)](AUTOMATION.md)

[![Donate](https://img.shields.io/badge/Donate-Solana-9945FF?logo=solana&logoColor=white)](https://solscan.io/account/GMr9rXrFSt5H3xX1wi85vyCQfwwLsQpULwNEjrSghvRN)

💝 **Support this project:** `GMr9rXrFSt5H3xX1wi85vyCQfwwLsQpULwNEjrSghvRN` ([View on Solscan](https://solscan.io/account/GMr9rXrFSt5H3xX1wi85vyCQfwwLsQpULwNEjrSghvRN))

📖 **[Quick Start](QUICKSTART.md)** | 🔧 **[Integration Guide](INTEGRATION_GUIDE.md)** | 🤖 **[Automation](AUTOMATION.md)** | 📝 **[Changelog](CHANGELOG.md)** | 🚀 **[Releases](RELEASES.md)**

---

## 📚 Overview

This library provides a curated collection of specialized agent prompts extracted from the [claude-flow](https://github.com/ruvnet/claude-flow/) project. Each prompt is carefully organized by category and designed to work seamlessly with Claude Code and MCP (Model Context Protocol).

### What's Included

- **76+ Specialized Agent Prompts** - Covering all aspects of software development
- **9 Main Categories** - Core, GitHub, Hive-Mind, Swarm, SPARC, Optimization, Testing, DevOps, Analysis
- **Interactive CLI Tool** - Browse, search, and integrate with ease
- **Adaptive Automation** - 3 automation levels to match your DevOps workflow ⭐ NEW
- **Setup Wizard** - Auto-detects your environment and recommends best automation
- **Quick Presets** - Pre-configured bundles for common workflows
- **Complete Documentation** - Each agent includes detailed instructions

### 🆕 What's New in v1.1.0

**Adaptive Automation System** - Choose the perfect automation level for your workflow:

1. **Full Automation** (GitHub Actions) - Zero manual work, automatic everything
2. **Smart Wizard** (Platform Agnostic) - Intelligent tools for any CI/CD platform
3. **Lite Templates** (Manual Control) - Lightweight templates with maximum flexibility

Run the setup wizard to get started:
```bash
cd agent-prompts
./setup-wizard.js
```

👉 [Read the complete automation guide](AUTOMATION.md)

## 🎯 Key Features

### ✨ Organized by Category

```
agent-prompts/
├── core/                    # Essential development agents (coder, planner, tester, reviewer)
├── github/                  # GitHub integration (PR manager, code review, issues)
├── hive-mind/              # Distributed intelligence coordination
├── swarm/                  # Advanced swarm patterns
├── sparc/                  # SPARC methodology (5-phase development)
├── optimization/           # Performance and benchmarking
├── testing/                # Comprehensive testing strategies
├── devops/                 # CI/CD and automation
└── analysis/               # Code quality analysis
```

### 🎨 Interactive Integration Tool

Beautiful CLI interface with:
- 🔍 **Search** - Find agents by name, capability, or use case
- 📚 **Browse** - Explore by category with breadcrumbs
- ✓ **Select** - Multi-select agents for integration
- 🚀 **Integrate** - One-click integration into your project
- ⚡ **Presets** - Quick bundles for common workflows

### 🚀 Easy Integration

Three ways to integrate:

1. **Interactive CLI** (Recommended)
   ```bash
   npm run integrate
   # Or directly:
   ./integrate.js
   ```

2. **Quick Script**
   ```bash
   ./quick-integrate.sh
   ```

3. **Manual Copy**
   ```bash
   cp -r agent-prompts/core .claude/agents/
   ```

## 📦 Installation

### Prerequisites

- Node.js 18+ (for interactive CLI)
- Claude Code
- Git (optional, for GitHub agents)

### Quick Start

```bash
# 1. Navigate to your project
cd your-project

# 2. Clone or copy this library
cp -r /path/to/agent-prompts ./

# 3. Run the interactive integration tool
cd agent-prompts
npm install   # First time only
npm run integrate

# 4. Follow the interactive prompts to select and integrate agents
```

## 🎯 Usage

### Interactive CLI

The interactive CLI provides the easiest way to browse and integrate agents:

```bash
./integrate.js
```

**Features:**
- Browse all 9 categories
- Search by keyword
- View detailed agent information
- Select individual or bulk agents
- Generate integration scripts
- Use quick presets

### Quick Presets

Pre-configured bundles for common use cases:

#### 1. Full-Stack Development 🌐
```
Agents: coder, tester, reviewer, planner
Use for: Complete web application development
```

#### 2. GitHub Workflow 🐙
```
Agents: pr-manager, code-review-swarm, issue-tracker, ci-cd-github
Use for: PR management, code review, CI/CD automation
```

#### 3. Code Quality Focus ✨
```
Agents: tester, reviewer, code-analyzer, performance-monitor
Use for: Testing, analysis, optimization
```

#### 4. SPARC Methodology ⚡
```
Agents: specification, pseudocode, architecture, refinement
Use for: Structured 5-phase development
```

#### 5. Swarm Intelligence 🐝
```
Agents: queen-coordinator, collective-intelligence, hierarchical-coordinator
Use for: Multi-agent coordination
```

## 📖 Agent Categories

### 💻 Core Development Agents

Essential agents for everyday development tasks.

| Agent | Description | Priority | Use Case |
|-------|-------------|----------|----------|
| **coder** | Implementation specialist | High | Write clean, efficient code |
| **planner** | Task planning & orchestration | High | Break down complex tasks |
| **researcher** | Requirements analysis | Medium | Understand requirements |
| **reviewer** | Code quality & security | High | Review code, audit security |
| **tester** | Test generation & validation | High | Write tests, practice TDD |

### 🐙 GitHub Integration Agents

Specialized agents for GitHub workflows and automation.

| Agent | Description | Priority | Use Case |
|-------|-------------|----------|----------|
| **pr-manager** | Comprehensive PR management | High | Manage pull requests |
| **code-review-swarm** | Multi-agent code review | High | Parallel code reviews |
| **issue-tracker** | Issue management & triage | Medium | Organize issues |
| **release-manager** | Release automation | Medium | Automate releases |

### 👑 Hive-Mind Intelligence

Distributed intelligence and swarm coordination.

| Agent | Description | Priority | Use Case |
|-------|-------------|----------|----------|
| **queen-coordinator** | Sovereign orchestrator | Critical | Top-level coordination |
| **collective-intelligence** | Distributed decision-making | High | Consensus building |
| **scout-explorer** | Reconnaissance specialist | Medium | Explore codebases |
| **worker-specialist** | Task execution | Medium | Execute specific tasks |

### 🐝 Swarm Coordination

Advanced coordination patterns and topologies.

| Agent | Description | Priority | Use Case |
|-------|-------------|----------|----------|
| **hierarchical-coordinator** | Tiered command structure | High | Structured coordination |
| **mesh-coordinator** | Peer-to-peer network | High | Decentralized control |
| **adaptive-coordinator** | Self-organizing topology | High | Dynamic adaptation |

### ⚡ SPARC Methodology

5-phase structured development approach.

| Phase | Agent | Description | Use Case |
|-------|-------|-------------|----------|
| 1 | **specification** | Requirements analysis | Define specifications |
| 2 | **pseudocode** | Algorithm design | Design before coding |
| 3 | **architecture** | System design | Plan architecture |
| 4 | **refinement** | Code optimization | Refine implementation |
| 5 | **completion** | Integration | Complete the cycle |

### 🚀 Optimization & Performance

Performance monitoring and optimization.

| Agent | Description | Priority | Use Case |
|-------|-------------|----------|----------|
| **performance-monitor** | Real-time monitoring | Medium | Track performance |
| **benchmark-suite** | Benchmarking framework | Medium | Compare performance |

### ✅ Testing & Validation

Comprehensive testing strategies.

| Agent | Description | Priority | Use Case |
|-------|-------------|----------|----------|
| **tdd-london-swarm** | TDD coordination | High | Practice TDD |
| **production-validator** | Production validation | High | Validate deployments |

### ⚙️ DevOps & CI/CD

DevOps automation and pipelines.

| Agent | Description | Priority | Use Case |
|-------|-------------|----------|----------|
| **ci-cd-github** | GitHub Actions automation | High | Setup CI/CD |

### 🔍 Code Analysis

Code quality and analysis.

| Agent | Description | Priority | Use Case |
|-------|-------------|----------|----------|
| **code-analyzer** | Quality & complexity analysis | Medium | Analyze code quality |

## 🛠️ Integration Methods

### Method 1: Interactive CLI (Recommended)

```bash
./integrate.js
```

**Advantages:**
- Visual browsing with categories
- Search functionality
- Preview prompt content
- Generate integration scripts
- Use quick presets

### Method 2: Quick Integration Script

For automated or CI/CD integration:

```bash
./quick-integrate.sh [preset-name]
```

**Presets:**
- `fullstack` - Full-stack development
- `github` - GitHub workflow
- `quality` - Code quality focus
- `sparc` - SPARC methodology
- `swarm` - Swarm intelligence
- `all` - All agents

**Example:**
```bash
./quick-integrate.sh github
# Integrates: pr-manager, code-review-swarm, issue-tracker, ci-cd-github
```

### Method 3: Manual Integration

Copy specific categories:

```bash
# Core development agents
cp -r agent-prompts/core .claude/agents/

# GitHub integration
cp -r agent-prompts/github .claude/agents/

# SPARC methodology
cp -r agent-prompts/sparc .claude/agents/
```

### Method 4: Generated Script

Generate a custom shell script:

```bash
./integrate.js
# Select agents interactively
# Choose "Generate integration script"
# Run the generated script
./integrate-agents.sh
```

## 📝 Usage in Claude Code

Once integrated, use agents in your prompts:

### Direct Reference

```
Use the coder agent to implement user authentication
```

### Swarm Coordination

```
Coordinate with pr-manager to review and merge PR #42
```

### SPARC Workflow

```
Follow the SPARC methodology:
1. specification - Define requirements
2. pseudocode - Design algorithm
3. architecture - Plan structure
4. refinement - Implement with TDD
5. completion - Integrate and deploy
```

### Multi-Agent Tasks

```
Use hive-mind coordination:
- queen-coordinator: Oversee the task
- scout-explorer: Analyze the codebase
- worker-specialist: Implement features
- collective-intelligence: Build consensus
```

## 🎨 Customization

### Modifying Agent Prompts

Each agent prompt is a markdown file with YAML frontmatter:

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
---

# Agent Instructions
...
```

Edit any prompt to customize behavior, add tools, or modify instructions.

### Adding New Agents

1. Create a new `.md` file in the appropriate category
2. Add YAML frontmatter with metadata
3. Write agent instructions in markdown
4. Update `catalog.json` to include the new agent

### Creating Custom Presets

Edit `integrate.js` and add to the `presets` array:

```javascript
{
  name: 'My Custom Preset',
  icon: '🎯',
  description: 'Description of the preset',
  agents: ['agent1', 'agent2', 'agent3']
}
```

## 📊 Library Statistics

- **Total Agents:** 76+
- **Categories:** 9 main categories
- **Total Lines:** 27,000+ lines of prompts
- **Source:** Based on claude-flow v2.7.34
- **License:** Based on original source

## 🔗 Integration with Existing Projects

### New Project Setup

```bash
# Initialize Claude Code
mkdir -p .claude/agents

# Integrate agents
cd /path/to/agent-prompts
./integrate.js

# Select agents or use presets
# They will be copied to your .claude/agents/ directory
```

### Existing Project

```bash
# Navigate to your project
cd your-existing-project

# Integrate agents (they'll merge with existing .claude/ structure)
/path/to/agent-prompts/integrate.js

# Select integration target: .claude/agents/
```

### CI/CD Integration

Add to your CI pipeline:

```yaml
# .github/workflows/setup.yml
- name: Integrate Claude Agents
  run: |
    ./agent-prompts/quick-integrate.sh github
```

## 🚀 Advanced Usage

### MCP Tool Integration

Many agents use MCP (Model Context Protocol) tools:

```javascript
// Example from pr-manager.md
mcp__claude-flow__swarm_init { topology: "mesh", maxAgents: 4 }
mcp__claude-flow__agent_spawn { type: "reviewer" }
mcp__github__create_pull_request { ... }
```

### Swarm Coordination

Coordinate multiple agents:

```javascript
// Initialize swarm
mcp__claude-flow__swarm_init { topology: "hierarchical" }

// Spawn agents
mcp__claude-flow__agent_spawn { type: "coder" }
mcp__claude-flow__agent_spawn { type: "tester" }
mcp__claude-flow__agent_spawn { type: "reviewer" }

// Orchestrate task
mcp__claude-flow__task_orchestrate {
  task: "Implement feature X",
  strategy: "parallel"
}
```

### Memory Coordination

Share state between agents:

```javascript
// Store in shared memory
mcp__claude-flow__memory_usage {
  action: "store",
  key: "swarm/shared/context",
  value: { feature: "auth", status: "implementing" }
}

// Retrieve from memory
mcp__claude-flow__memory_usage {
  action: "retrieve",
  key: "swarm/shared/context"
}
```

## 🤝 Contributing

To contribute new agents or improvements:

1. Fork this repository
2. Add your agent in the appropriate category
3. Update `catalog.json` with metadata
4. Test with the integration tool
5. Submit a pull request

## 📚 Resources

- **Source Project:** [claude-flow](https://github.com/ruvnet/claude-flow/)
- **Claude Code Docs:** [docs.anthropic.com](https://docs.anthropic.com)
- **MCP Documentation:** Model Context Protocol guides
- **Changelog:** [CHANGELOG.md](CHANGELOG.md)
- **Releases:** [RELEASES.md](RELEASES.md)

## 📋 Version History

### Current Version: 1.1.0

**Release Date:** November 17, 2025

**Status:** Stable ✅

**What's New in 1.1.0:**
- 🤖 **Adaptive Automation System** - 3 automation levels (Full, Smart, Lite)
- 🧙 **Setup Wizard** - Auto-detects environment and recommends best option
- ⚡ **Full Automation** - GitHub Actions workflows for automatic version/changelog/PR comments
- 🛠️ **Smart Wizard** - Platform-agnostic tools with diagnostics and health monitoring
- 📋 **Lite Templates** - CI/CD templates for GitHub, GitLab, Jenkins, CircleCI
- 📚 **AUTOMATION.md** - Comprehensive automation guide with comparison matrix

**Previous Releases:**
- **1.0.0** (Nov 17, 2025) - Initial release with 76+ agent prompts and integration tools

**See Also:**
- [Full Changelog](CHANGELOG.md) - Detailed version history
- [Releases](RELEASES.md) - Official release notes
- [Automation Guide](AUTOMATION.md) - Automation options explained
- [Migration Guide](INTEGRATION_GUIDE.md) - Upgrade instructions

## 📄 License

Based on claude-flow. Please refer to the original project for licensing information.

## 💝 Support This Project

If you find this library helpful, consider supporting its development!

**Solana Donations:**

```
GMr9rXrFSt5H3xX1wi85vyCQfwwLsQpULwNEjrSghvRN
```

🔗 [View on Solscan](https://solscan.io/account/GMr9rXrFSt5H3xX1wi85vyCQfwwLsQpULwNEjrSghvRN)

Your support helps maintain and improve this library. Thank you! 🙏

## 🙏 Credits

- **Original Project:** [claude-flow](https://github.com/ruvnet/claude-flow/) by [@ruvnet](https://github.com/ruvnet)
- **Organization & Integration:** Fused Gaming

---

## 🚦 Quick Start Summary

```bash
# 1. Install (first time only)
cd agent-prompts
npm install

# 2. Run interactive tool
./integrate.js

# 3. Select agents or use presets

# 4. Integrate into your project

# 5. Start using agents in Claude Code!
```

**Questions?** Open an issue or check the documentation in each agent prompt file.

**Ready to supercharge your Claude Code workflow?** 🚀
