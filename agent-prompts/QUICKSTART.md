# 🚀 Quick Start Guide

Get up and running with Claude Agent Prompts in under 5 minutes!

## ⚡ Super Quick Start

```bash
# 1. Navigate to agent-prompts directory
cd agent-prompts

# 2. Run the interactive tool
./integrate.js

# 3. Select a preset or browse categories

# 4. Done! Agents are now in your .claude/agents/ directory
```

## 🎯 Three Ways to Integrate

### 1. Interactive CLI (Recommended for First-Time Users)

**Best for:** Exploring agents, learning what's available, custom selections

```bash
./integrate.js
```

**What you can do:**
- 📚 Browse 9 categories
- 🔍 Search by keyword
- ✓ Select specific agents
- ⚡ Use quick presets
- 📋 View detailed info
- 🚀 One-click integration

**Navigation:**
- Use numbers to select options
- Type `0` to go back
- Type `q` to quit
- Type `a` to select all in a category

### 2. Quick Integration Script (Recommended for Experienced Users)

**Best for:** Fast integration, automation, CI/CD

```bash
# Integrate a preset
./quick-integrate.sh fullstack

# Available presets:
./quick-integrate.sh fullstack   # Complete development setup
./quick-integrate.sh github      # GitHub workflow automation
./quick-integrate.sh quality     # Code quality & testing
./quick-integrate.sh sparc       # SPARC methodology
./quick-integrate.sh swarm       # Swarm intelligence
./quick-integrate.sh minimal     # Essential agents only
./quick-integrate.sh all         # Everything!
```

**Options:**
```bash
# Custom target directory
./quick-integrate.sh github --target my-agents

# Specific project
./quick-integrate.sh fullstack --project-root /path/to/project

# List all agents
./quick-integrate.sh --list

# Show help
./quick-integrate.sh --help
```

### 3. Manual Copy (Recommended for Advanced Users)

**Best for:** Full control, custom organization

```bash
# Copy specific categories
cp -r agent-prompts/core .claude/agents/
cp -r agent-prompts/github .claude/agents/

# Copy individual agents
cp agent-prompts/core/coder.md .claude/agents/core/
cp agent-prompts/github/pr-manager.md .claude/agents/github/

# Copy everything
cp -r agent-prompts/* .claude/agents/
```

## 📦 Preset Details

### 🌐 Full-Stack Development
```bash
./quick-integrate.sh fullstack
```
**Includes:**
- **coder** - Write clean, efficient code
- **tester** - Generate comprehensive tests
- **reviewer** - Review code quality
- **planner** - Plan tasks and workflows

**Use when:** Building web applications, APIs, or full-stack projects

### 🐙 GitHub Workflow
```bash
./quick-integrate.sh github
```
**Includes:**
- **pr-manager** - Manage pull requests
- **code-review-swarm** - Automated reviews
- **issue-tracker** - Organize issues
- **ci-cd-github** - GitHub Actions automation

**Use when:** Working with GitHub, managing PRs, automating workflows

### ✨ Code Quality Focus
```bash
./quick-integrate.sh quality
```
**Includes:**
- **tester** - Test generation
- **reviewer** - Code review
- **code-analyzer** - Quality analysis
- **performance-monitor** - Performance tracking

**Use when:** Improving code quality, reducing technical debt, optimizing

### ⚡ SPARC Methodology
```bash
./quick-integrate.sh sparc
```
**Includes:**
- **specification** - Requirements analysis (Phase 1)
- **pseudocode** - Algorithm design (Phase 2)
- **architecture** - System design (Phase 3)
- **refinement** - Code optimization (Phase 4)

**Use when:** Following structured development, complex projects, team workflows

### 🐝 Swarm Intelligence
```bash
./quick-integrate.sh swarm
```
**Includes:**
- **queen-coordinator** - Top-level orchestration
- **collective-intelligence** - Distributed decisions
- **hierarchical-coordinator** - Structured coordination

**Use when:** Multi-agent tasks, complex coordination, distributed intelligence

### 🎯 Minimal Setup
```bash
./quick-integrate.sh minimal
```
**Includes:**
- **coder** - Write code
- **tester** - Write tests
- **reviewer** - Review code

**Use when:** Just getting started, simple projects, minimal overhead

## 💻 Using Agents in Claude Code

### Basic Usage

Once integrated, reference agents in your prompts:

```
Use the coder agent to implement user authentication
```

```
Have the reviewer agent analyze this code for security issues
```

```
Use the planner agent to break down this feature into tasks
```

### SPARC Workflow

Follow the 5-phase methodology:

```
Use SPARC methodology for this feature:
1. specification - Define requirements for login system
2. pseudocode - Design authentication algorithm
3. architecture - Plan database and API structure
4. refinement - Implement with TDD
5. completion - Integrate and deploy
```

### Multi-Agent Coordination

Coordinate multiple agents:

```
Coordinate these agents:
- planner: Break down the feature
- coder: Implement each task
- tester: Write tests for each component
- reviewer: Review before merge
```

### Swarm Intelligence

Use hive-mind coordination:

```
Use hive-mind swarm:
- queen-coordinator: Oversee the entire migration
- scout-explorer: Analyze the current codebase
- worker-specialist: Implement migrations
- collective-intelligence: Make architectural decisions
```

## 🎓 Examples

### Example 1: New Feature Development

```bash
# 1. Integrate full-stack preset
./quick-integrate.sh fullstack

# 2. In Claude Code:
"Use the planner agent to break down implementing a shopping cart feature"

"Use the coder agent to implement the shopping cart with these tasks"

"Use the tester agent to create comprehensive tests"

"Use the reviewer agent to review before committing"
```

### Example 2: GitHub PR Workflow

```bash
# 1. Integrate GitHub preset
./quick-integrate.sh github

# 2. In Claude Code:
"Use pr-manager to create a PR for my authentication feature"

"Use code-review-swarm to review PR #42 in parallel"

"Use issue-tracker to organize and triage open issues"
```

### Example 3: Code Quality Improvement

```bash
# 1. Integrate quality preset
./quick-integrate.sh quality

# 2. In Claude Code:
"Use code-analyzer to analyze technical debt in this module"

"Use reviewer to audit security vulnerabilities"

"Use performance-monitor to identify bottlenecks"

"Use tester to increase test coverage to 80%"
```

## 🔧 Troubleshooting

### "Agent not found"
- Ensure agents are in `.claude/agents/` directory
- Check file structure: `.claude/agents/core/coder.md`
- Verify files were copied correctly

### "Permission denied"
```bash
# Make scripts executable
chmod +x integrate.js
chmod +x quick-integrate.sh
```

### "Node.js not found"
```bash
# Install Node.js 18+
# Visit: https://nodejs.org
```

### "Cannot find catalog.json"
```bash
# Ensure you're in the agent-prompts directory
cd agent-prompts
./integrate.js
```

## 📚 Next Steps

1. **Explore Categories**
   ```bash
   ./integrate.js
   # Browse categories to see what's available
   ```

2. **Read Agent Documentation**
   ```bash
   # Each .md file contains detailed instructions
   cat .claude/agents/core/coder.md
   ```

3. **Customize Agents**
   - Edit any agent file to customize behavior
   - Add your own tools in YAML frontmatter
   - Modify instructions to fit your workflow

4. **Create Custom Presets**
   - Edit `quick-integrate.sh`
   - Add your own preset combinations
   - Share with your team

## 🎯 Common Workflows

### Solo Developer
```bash
./quick-integrate.sh minimal
# Use: coder, tester, reviewer for everyday development
```

### Team Development
```bash
./quick-integrate.sh fullstack
./quick-integrate.sh github
# Use: Full coordination with PR management
```

### Open Source Maintainer
```bash
./quick-integrate.sh github
./quick-integrate.sh quality
# Use: Issue triage, PR review, quality assurance
```

### Enterprise Project
```bash
./quick-integrate.sh all
# Use: Everything for comprehensive workflows
```

## 🚀 Ready to Go!

You're all set! Start using your agents in Claude Code.

**Need help?**
- Read the full [README.md](README.md)
- Check individual agent files for details
- Open an issue for questions

**Happy coding!** 🎉
