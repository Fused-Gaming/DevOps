# Releases

Official releases of the Claude Agent Prompts Library.

## Release Policy

We follow [Semantic Versioning](https://semver.org/):
- **MAJOR** version for incompatible API changes
- **MINOR** version for new functionality in a backwards compatible manner
- **PATCH** version for backwards compatible bug fixes

## Latest Release

### [v1.1.0](https://github.com/Fused-Gaming/DevOps/releases/tag/agent-prompts-v1.1.0) - 2025-11-17

🚀 **Major Feature Release: Adaptive Automation**

Added comprehensive automation system with three distinct levels to match any DevOps workflow!

#### Highlights

- 🤖 **Adaptive Setup Wizard** - Auto-detects environment and recommends best automation
- ⚡ **3 Automation Levels** - Choose Full, Smart, or Lite based on your workflow
- 🔄 **GitHub Actions Workflows** - Auto version bumping, changelog, PR comments, issue creation
- 🛠️ **Smart Wizard Tools** - Platform-agnostic diagnostics, health monitoring, upgrades
- 📋 **CI/CD Templates** - For GitHub Actions, GitLab CI, Jenkins, CircleCI
- 📚 **Comprehensive Guide** - New AUTOMATION.md with comparison matrix and decision tree
- ♻️ **Backwards Compatible** - All v1.0.0 features remain fully functional

#### What's New

##### Adaptive Setup Wizard
- Interactive environment detection
- Auto-detects CI/CD platform (GitHub Actions, GitLab CI, Jenkins, CircleCI)
- Identifies project type and existing tools
- Recommends best automation level
- Configures everything automatically

##### Option 1: Full Automation (GitHub Actions)
- Automatic version bumping (semantic versioning from commits)
- Automated changelog generation
- PR test result comments
- Auto-create issues for failed builds
- Diagnostic collection and health monitoring
- 6 pre-configured GitHub Actions workflows

##### Option 2: Smart Wizard (Platform Agnostic)
- Works with ANY CI/CD platform
- Diagnostic tools (`tools/diagnostic.js`)
- Health check system (`tools/health-check.js`)
- Smart upgrade tool (`tools/upgrade.js`)
- CI/CD template generator for your platform

##### Option 3: Lite Templates (Manual Control)
- NPM scripts for manual workflows
- CI/CD templates for all major platforms
- Release management helpers
- Maximum flexibility and customization

##### Documentation
- AUTOMATION.md - Complete automation guide (24KB)
- Comparison matrix for all 3 options
- Decision tree to choose the right level
- Use case examples and recommendations
- Migration guide between options

#### Quick Start

```bash
# Run setup wizard (recommended)
cd agent-prompts
./setup-wizard.js

# Or choose automation level directly
npm run setup:full     # Full automation
npm run setup:smart    # Smart wizard
npm run setup:lite     # Lite templates

# Then integrate agents
./integrate.js
```

#### Installation

See [AUTOMATION.md](AUTOMATION.md) for detailed setup instructions for each automation level.

#### Migration from v1.0.0

All v1.0.0 users can upgrade seamlessly:

```bash
cd agent-prompts
git pull  # Get latest version
./setup-wizard.js  # Add automation
```

Your existing integrations are preserved!

#### Statistics
- **New Files:** 2 (setup-wizard.js, AUTOMATION.md)
- **New Features:** 3 automation levels
- **GitHub Actions Workflows:** 6 (when Option 1 selected)
- **Smart Tools:** 3 (when Option 2 selected)
- **Total Documentation:** 5 pages (added AUTOMATION.md)

#### Links
- [Full Changelog](CHANGELOG.md#110---2025-11-17)
- [Automation Guide](AUTOMATION.md) - **NEW!**
- [README](README.md)
- [Quick Start Guide](QUICKSTART.md)
- [Integration Guide](INTEGRATION_GUIDE.md)

#### Credits
- **Based on:** [claude-flow](https://github.com/ruvnet/claude-flow/) by [@ruvnet](https://github.com/ruvnet)
- **Curated & Integrated by:** Fused Gaming

---

## Previous Releases

### [v1.0.0](https://github.com/Fused-Gaming/DevOps/releases/tag/agent-prompts-v1.0.0) - 2025-11-17

🎉 **Initial Public Release**

The first official release of the Claude Agent Prompts Library!

#### Highlights
- 76+ Specialized Agent Prompts across 9 main categories
- Interactive CLI Tool with beautiful UI and search
- Quick Integration Script with 7 pre-configured presets
- Comprehensive Documentation including README, Quick Start, and Integration Guide
- Easy Integration into any new or existing project

#### Agent Categories
- Core Development (5 agents)
- GitHub Integration (13 agents)
- Hive-Mind Intelligence (5 agents)
- Swarm Coordination (3 agents)
- SPARC Methodology (4 agents)
- Optimization (5 agents)
- Testing (2 agents)
- DevOps (1 agent)
- Analysis (2 agents)

#### Links
- [Full Changelog](CHANGELOG.md#100---2025-11-17)
- [README](README.md)

---

## Release Notes Format

Each release includes:
- **Version number** (semantic versioning)
- **Release date** (YYYY-MM-DD)
- **Highlights** - Key features and changes
- **What's Included** - Detailed component list
- **Installation** - Installation instructions
- **Breaking Changes** - Incompatible changes (if any)
- **Bug Fixes** - Resolved issues
- **Known Issues** - Current limitations
- **Credits** - Contributors and attributions

---

## Upgrade Guide

### From v1.0.0 to v1.1.0

**Upgrade is seamless and backwards compatible!**

```bash
# 1. Pull latest version
cd agent-prompts
git pull origin main

# 2. Run setup wizard to add automation (optional)
./setup-wizard.js

# 3. Continue using existing integration
# All your v1.0.0 features still work!
```

**What's preserved:**
- All integrated agents
- Your custom configurations
- Integration preferences
- Existing workflows

**What's new:**
- Adaptive setup wizard
- 3 automation levels to choose from
- AUTOMATION.md documentation

### From No Version (Fresh Install)
This is a fresh installation. Simply follow the installation instructions above.

### Future Upgrades
Version upgrade tools are available in Option 2 (Smart Wizard):
```bash
npm run upgrade -- --check  # Check for updates
npm run upgrade -- --upgrade  # Perform upgrade
```

---

## Support

- **Documentation:** See [README.md](README.md)
- **Issues:** Report at [GitHub Issues](https://github.com/Fused-Gaming/DevOps/issues)
- **Discussions:** [GitHub Discussions](https://github.com/Fused-Gaming/DevOps/discussions)

---

**Latest Version:** 1.1.0
**Release Date:** November 17, 2025
**Status:** Stable
