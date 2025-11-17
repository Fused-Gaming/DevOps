# Releases

Official releases of the Claude Agent Prompts Library.

## Release Policy

We follow [Semantic Versioning](https://semver.org/):
- **MAJOR** version for incompatible API changes
- **MINOR** version for new functionality in a backwards compatible manner
- **PATCH** version for backwards compatible bug fixes

## Latest Release

### [v1.0.0](https://github.com/Fused-Gaming/DevOps/releases/tag/agent-prompts-v1.0.0) - 2025-11-17

🎉 **Initial Public Release**

The first official release of the Claude Agent Prompts Library!

#### Highlights

- **76+ Specialized Agent Prompts** across 9 main categories
- **Interactive CLI Tool** with beautiful UI and search
- **Quick Integration Script** with 7 pre-configured presets
- **Comprehensive Documentation** including README, Quick Start, and Integration Guide
- **Easy Integration** into any new or existing project
- **MIT Licensed** with attribution to original claude-flow project

#### What's Included

##### Agent Categories
- **Core Development** (5 agents) - coder, planner, researcher, reviewer, tester
- **GitHub Integration** (13 agents) - PR management, code review, issues, releases
- **Hive-Mind Intelligence** (5 agents) - swarm coordination and collective intelligence
- **Swarm Coordination** (3 agents) - hierarchical, mesh, adaptive topologies
- **SPARC Methodology** (4 agents) - 5-phase structured development
- **Optimization** (5 agents) - performance monitoring and benchmarking
- **Testing** (2 agents) - TDD and production validation
- **DevOps** (1 agent) - CI/CD automation
- **Analysis** (2 agents) - code quality and complexity

##### Integration Tools
- `integrate.js` - Interactive CLI with browse, search, and multi-select
- `quick-integrate.sh` - Fast preset-based integration
- 7 quick presets: fullstack, github, quality, sparc, swarm, minimal, all

##### Documentation
- README.md - Complete library documentation
- QUICKSTART.md - 5-minute getting started guide
- INTEGRATION_GUIDE.md - Developer integration guide
- CHANGELOG.md - Detailed version history

#### Installation

```bash
# Interactive CLI
cd agent-prompts
./integrate.js

# Quick integration
./quick-integrate.sh fullstack

# NPM installation
npm install
npm run integrate
```

#### Quick Start

Three ways to integrate:

1. **Interactive CLI** - Browse and select agents visually
   ```bash
   ./integrate.js
   ```

2. **Quick Script** - Use pre-configured presets
   ```bash
   ./quick-integrate.sh fullstack
   ```

3. **Manual** - Copy specific agents
   ```bash
   cp -r agent-prompts/core .claude/agents/
   ```

#### Statistics
- **Files:** 83
- **Lines of Code:** 26,957+
- **Agent Prompts:** 76+
- **Categories:** 9 main + additional specialized
- **Documentation Pages:** 4

#### Links
- [Full Changelog](CHANGELOG.md#100---2025-11-17)
- [README](README.md)
- [Quick Start Guide](QUICKSTART.md)
- [Integration Guide](INTEGRATION_GUIDE.md)

#### Credits
- **Based on:** [claude-flow](https://github.com/ruvnet/claude-flow/) by [@ruvnet](https://github.com/ruvnet)
- **Curated & Integrated by:** Fused Gaming

---

## Previous Releases

This is the initial release. No previous versions exist.

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

### From No Version (Fresh Install)
This is a fresh installation. Simply follow the installation instructions above.

### Future Upgrades
Upgrade instructions will be provided in future releases.

---

## Support

- **Documentation:** See [README.md](README.md)
- **Issues:** Report at [GitHub Issues](https://github.com/Fused-Gaming/DevOps/issues)
- **Discussions:** [GitHub Discussions](https://github.com/Fused-Gaming/DevOps/discussions)

---

**Latest Version:** 1.0.0
**Release Date:** November 17, 2025
**Status:** Stable
