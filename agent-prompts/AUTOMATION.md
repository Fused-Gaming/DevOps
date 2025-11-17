# 🤖 Automation Options Guide

Complete guide to the three automation levels available for Claude Agent Prompts integration.

## 📋 Table of Contents

- [Overview](#overview)
- [Quick Start](#quick-start)
- [Option 1: Full Automation](#option-1-full-automation-github-actions)
- [Option 2: Smart Wizard](#option-2-smart-wizard-platform-agnostic)
- [Option 3: Lite Templates](#option-3-lite-templates-manual-control)
- [Comparison Matrix](#comparison-matrix)
- [Which Option Should I Choose?](#which-option-should-i-choose)

---

## Overview

The Claude Agent Prompts library offers **three automation levels** to match your development workflow and DevOps setup. Run the setup wizard to choose the best option for you:

```bash
cd agent-prompts
./setup-wizard.js
```

The wizard will:
1. 🔍 Detect your environment (CI/CD, platform, tools)
2. 💡 Recommend the best option for you
3. ⚙️ Configure automation based on your choice
4. 🚀 Set everything up automatically

---

## Quick Start

```bash
# Run the setup wizard
./setup-wizard.js

# Or choose directly
npm run setup:full      # Option 1: Full Automation
npm run setup:smart     # Option 2: Smart Wizard
npm run setup:lite      # Option 3: Lite Templates
```

---

## Option 1: Full Automation (GitHub Actions)

### 🎯 What It Includes

**Automatic Version Management:**
- ✅ Auto-bump version on merge (semantic versioning)
- ✅ Analyze commit messages for MAJOR/MINOR/PATCH
- ✅ Update VERSION file and package.json automatically
- ✅ Create git tags for each release
- ✅ No manual version management required

**Automated Changelog Generation:**
- ✅ Generate changelog from commit messages
- ✅ Update CHANGELOG.md on every release
- ✅ Organize changes by type (feat, fix, docs, etc.)
- ✅ Include commit hashes and links
- ✅ Follows Keep a Changelog format

**PR Integration:**
- ✅ Post test results as comments on PRs
- ✅ Show build status in PR conversations
- ✅ Display detailed test output
- ✅ Automatic success/failure indicators
- ✅ Integration test diagnostics

**Intelligent Issue Creation:**
- ✅ Auto-create issues for failed builds
- ✅ Include diagnostic information
- ✅ Link to failed workflow runs
- ✅ Tag with appropriate labels
- ✅ Provide troubleshooting steps

**Diagnostic Collection:**
- ✅ Collect integration health data
- ✅ Track agent file integrity
- ✅ Monitor catalog validity
- ✅ Export diagnostic reports
- ✅ Upload artifacts for analysis

**Health Monitoring:**
- ✅ Scheduled health checks (every 6 hours)
- ✅ Verify all agent files present
- ✅ Check catalog integrity
- ✅ Alert on issues
- ✅ Automatic recovery suggestions

### 📦 Generated Files

```
.github/workflows/
├── version-bump.yml        # Auto version bumping
├── changelog.yml           # Changelog generation
├── pr-comment.yml          # PR test result comments
├── issue-on-failure.yml    # Auto issue creation
├── diagnostics.yml         # Diagnostic collection
└── health-monitor.yml      # Health monitoring
```

### ⚙️ Configuration

The setup wizard will ask:
- ✓ Enable version bumping?
- ✓ Generate changelogs?
- ✓ Post PR comments?
- ✓ Create issues for failures?
- ✓ Collect diagnostics?
- ✓ Enable health monitoring?

### 🚀 Usage

Once set up, automation is **completely automatic**:

```bash
# Just work normally:
git add .
git commit -m "feat: add new agent"
git push

# Automation handles:
# - Version bump (minor)
# - Changelog update
# - Git tag creation
# - PR comments (if applicable)
```

### ✅ Best For

- **GitHub-native teams** using GitHub Actions
- **Teams wanting zero manual work**
- **Projects with frequent releases**
- **Organizations requiring audit trails**
- **Teams wanting automatic PR feedback**

### ⚠️ Requirements

- GitHub repository
- GitHub Actions enabled
- Write access to repository
- GITHUB_TOKEN permissions

---

## Option 2: Smart Wizard (Platform Agnostic)

### 🎯 What It Includes

**Auto-Detection System:**
- ✅ Detects your CI/CD platform (GitHub Actions, GitLab CI, Jenkins, CircleCI)
- ✅ Identifies project type (React, Vue, Express, etc.)
- ✅ Finds existing tools and dependencies
- ✅ Recommends best agent prompts for your stack
- ✅ Generates custom integration scripts

**Diagnostic Tools:**
- ✅ Comprehensive diagnostic collection
- ✅ Export diagnostics as JSON
- ✅ Integration health reporting
- ✅ Environment analysis
- ✅ Configuration validation

**Health Monitoring:**
- ✅ Manual and scheduled health checks
- ✅ Catalog integrity verification
- ✅ Agent file presence checks
- ✅ Version consistency validation
- ✅ Detailed health reports

**Smart Upgrade System:**
- ✅ Check for new versions
- ✅ Automatic backup before upgrade
- ✅ Conflict resolution
- ✅ Configuration migration
- ✅ Rollback support

**CI/CD Template Generation:**
- ✅ Generate templates for YOUR platform
- ✅ Custom scripts for your stack
- ✅ Platform-specific best practices
- ✅ Integration test templates
- ✅ Deployment workflow templates

**Dashboard & Feedback:**
- ✅ Visual progress tracking
- ✅ Integration status dashboard
- ✅ Usage analytics (opt-in)
- ✅ Improvement feedback system
- ✅ Community insights

### 📦 Generated Files

```
agent-prompts/tools/
├── diagnostic.js         # Diagnostic collection tool
├── health-check.js       # Health monitoring tool
├── upgrade.js            # Smart upgrade system
└── templates/            # CI/CD templates for your platform
    ├── github-actions/   # (if using GitHub)
    ├── gitlab-ci/        # (if using GitLab)
    ├── jenkins/          # (if using Jenkins)
    └── circleci/         # (if using CircleCI)
```

### ⚙️ Configuration

The setup wizard will ask:
- 🔍 Which CI/CD platform do you use?
- ✓ Enable auto-detection?
- ✓ Collect diagnostics?
- ✓ Enable health monitoring?
- ✓ Set up smart upgrades?
- ✓ Generate CI/CD templates?

### 🚀 Usage

**Run Diagnostics:**
```bash
npm run diagnose
# Outputs comprehensive diagnostic JSON
# Saves to diagnostics.json for sharing
```

**Health Check:**
```bash
npm run health
# Checks catalog integrity
# Verifies agent files
# Validates versions
# Exit code 0 = healthy, 1 = issues
```

**Check for Updates:**
```bash
npm run upgrade -- --check
# Checks GitHub for latest version
# Shows what's new
# Recommends upgrade if available
```

**Perform Upgrade:**
```bash
npm run upgrade -- --upgrade
# Backs up current installation
# Downloads new version
# Migrates configuration
# Preserves customizations
```

**Generate CI/CD Templates:**
```bash
# Templates generated during setup
# Customize for your needs
# Copy to your CI/CD directory
```

### ✅ Best For

- **Multi-platform teams** (not just GitHub)
- **Enterprise environments** with mixed CI/CD
- **Teams wanting control** with smart assistance
- **Projects with complex stacks**
- **Organizations requiring flexibility**

### ⚠️ Requirements

- Node.js 18+
- Any CI/CD platform (or none)
- Git (optional but recommended)

---

## Option 3: Lite Templates (Manual Control)

### 🎯 What It Includes

**NPM Scripts Collection:**
- ✅ `npm run release` - Manual version bump and release
- ✅ `npm run diagnose` - Export diagnostic data
- ✅ `npm run health` - Run health checks
- ✅ `npm run upgrade-check` - Check for updates
- ✅ `npm run generate-ci` - Generate CI templates

**CI/CD Templates:**
- ✅ GitHub Actions workflow templates
- ✅ GitLab CI pipeline templates
- ✅ Jenkinsfile templates
- ✅ CircleCI config templates
- ✅ Generic shell script templates

**Release Management:**
- ✅ Version bump scripts (major/minor/patch)
- ✅ Changelog generation helpers
- ✅ Git tag creation scripts
- ✅ Release checklist templates
- ✅ Manual PR templates

**Diagnostic Tools:**
- ✅ Simple diagnostic JSON export
- ✅ Basic health check script
- ✅ Integration verification
- ✅ File integrity checks
- ✅ Manual reporting templates

**Documentation Templates:**
- ✅ PR description templates
- ✅ Issue templates with diagnostics
- ✅ Release notes templates
- ✅ Migration guides
- ✅ Setup instructions

### 📦 Generated Files

```
agent-prompts/
├── scripts/
│   ├── release.sh          # Manual release script
│   ├── bump-version.sh     # Version bumping
│   └── health-check.sh     # Basic health check
├── templates/
│   └── cicd/
│       ├── github-actions/ # GitHub Actions templates
│       ├── gitlab-ci/      # GitLab CI templates
│       ├── jenkins/        # Jenkins templates
│       └── circleci/       # CircleCI templates
└── .github/                # (if GitHub selected)
    ├── PULL_REQUEST_TEMPLATE.md
    └── ISSUE_TEMPLATE/
        ├── bug_report.md
        └── feature_request.md
```

### ⚙️ Configuration

The setup wizard will ask:
- 📋 Which CI/CD templates to generate?
- ✓ Include release management?
- ✓ Generate diagnostic tools?
- ✓ Create health check scripts?
- ✓ Set up upgrade checks?

### 🚀 Usage

**Release a New Version:**
```bash
# Bump version
npm run release -- --minor

# Manually:
# 1. Update VERSION file
# 2. Update package.json version
# 3. Update CHANGELOG.md
# 4. Commit and tag
# 5. Push to remote
```

**Run Health Check:**
```bash
npm run health
# Runs basic checks
# Outputs results to console
# Exit code indicates health status
```

**Generate Diagnostics:**
```bash
npm run diagnose
# Exports diagnostic JSON
# Use for bug reports
# Share with maintainers
```

**Check for Updates:**
```bash
npm run upgrade-check
# Checks for new version
# Shows upgrade instructions
# Links to changelog
```

**Use CI/CD Templates:**
```bash
# Templates in agent-prompts/templates/cicd/
# Copy to your project:
cp agent-prompts/templates/cicd/github-actions/* .github/workflows/

# Customize as needed
```

### ✅ Best For

- **Small teams** wanting simplicity
- **Developers who prefer manual control**
- **Projects with custom workflows**
- **Learning DevOps automation**
- **Maximum flexibility needed**

### ⚠️ Requirements

- Basic shell knowledge
- Manual workflow comfort
- Any platform or no CI/CD

---

## Comparison Matrix

| Feature | Full Automation | Smart Wizard | Lite Templates |
|---------|----------------|--------------|----------------|
| **Setup Complexity** | Low | Medium | Low |
| **Automation Level** | 100% Automatic | Semi-Automatic | Manual |
| **Platform Support** | GitHub only | All platforms | All platforms |
| **Version Bumping** | ✅ Automatic | ⚙️ Script-based | 📝 Manual |
| **Changelog** | ✅ Auto-generated | ⚙️ Helper tools | 📝 Manual |
| **PR Comments** | ✅ Automatic | ⚠️ Template-based | 📝 Manual templates |
| **Issue Creation** | ✅ Automatic | ⚠️ Template-based | 📝 Manual templates |
| **Diagnostics** | ✅ Automatic collection | ⚙️ On-demand | ⚙️ On-demand |
| **Health Monitoring** | ✅ Scheduled | ⚙️ On-demand | ⚙️ On-demand |
| **Upgrade System** | ✅ Notified via GitHub | ⚙️ Smart upgrade tool | 📝 Manual check |
| **CI/CD Templates** | ✅ Auto-configured | ✅ Generated for your platform | ✅ Multiple platforms |
| **User Control** | Low | High | Very High |
| **Maintenance** | Very Low | Low | Medium |
| **Learning Curve** | None | Low | Medium |
| **Customization** | Limited | Extensive | Complete |

**Legend:**
- ✅ Fully supported / Automatic
- ⚙️ Tool-assisted / Semi-automatic
- ⚠️ Template provided / Manual setup
- 📝 Manual process

---

## Which Option Should I Choose?

### Choose **Option 1 (Full Automation)** if:
- ✅ You use GitHub and GitHub Actions
- ✅ You want zero manual work
- ✅ You release frequently
- ✅ You want automatic PR feedback
- ✅ You need audit trails and diagnostics
- ✅ Your team is comfortable with automation

### Choose **Option 2 (Smart Wizard)** if:
- ✅ You use GitLab, Jenkins, CircleCI, or mixed platforms
- ✅ You want smart assistance but keep control
- ✅ You need platform-agnostic tools
- ✅ You want diagnostic and health monitoring
- ✅ You upgrade agents regularly
- ✅ You need flexibility with automation

### Choose **Option 3 (Lite Templates)** if:
- ✅ You prefer manual control
- ✅ You're new to DevOps automation
- ✅ You have custom workflows
- ✅ You don't use CI/CD yet
- ✅ You want maximum customization
- ✅ You're comfortable with command-line tools

---

## Decision Tree

```
Start here
    │
    ├─ Using GitHub Actions?
    │   ├─ Yes → Want full automation?
    │   │   ├─ Yes → ✅ Option 1: Full Automation
    │   │   └─ No  → ⚙️ Option 2: Smart Wizard
    │   └─ No  → Using other CI/CD?
    │       ├─ Yes → ⚙️ Option 2: Smart Wizard
    │       └─ No  → Want to learn DevOps?
    │           ├─ Yes → 📝 Option 3: Lite Templates
    │           └─ No  → ⚙️ Option 2: Smart Wizard
```

---

## Getting Started

### Interactive Setup (Recommended)

```bash
cd agent-prompts
./setup-wizard.js
```

The wizard will:
1. Detect your environment
2. Recommend the best option
3. Ask about your preferences
4. Configure everything automatically
5. Provide next steps

### Direct Setup

```bash
# Option 1: Full Automation
npm run setup:full

# Option 2: Smart Wizard
npm run setup:smart

# Option 3: Lite Templates
npm run setup:lite
```

---

## Examples by Use Case

### Solo Developer (GitHub)
**Recommended:** Option 1 (Full Automation)
```bash
./setup-wizard.js
# Select: 1. Full Automation
# Enable: All features
# Result: Zero manual work, automatic everything
```

### Team Using GitLab
**Recommended:** Option 2 (Smart Wizard)
```bash
./setup-wizard.js
# Select: 2. Smart Wizard
# Platform: GitLab CI
# Result: Custom GitLab CI templates + smart tools
```

### Learning DevOps
**Recommended:** Option 3 (Lite Templates)
```bash
./setup-wizard.js
# Select: 3. Lite Templates
# Templates: All platforms
# Result: Learn by doing with helpful templates
```

### Enterprise Multi-Platform
**Recommended:** Option 2 (Smart Wizard)
```bash
./setup-wizard.js
# Select: 2. Smart Wizard
# Platform: Multiple
# Result: Platform-agnostic tools for all teams
```

---

## Migration Between Options

You can switch between options at any time:

```bash
# Currently using Lite Templates?
# Upgrade to Smart Wizard:
./setup-wizard.js
# Select: 2. Smart Wizard
# Your existing setup will be preserved

# Want Full Automation?
./setup-wizard.js
# Select: 1. Full Automation
# Old tools remain available
```

---

## Support

- **Documentation:** [README.md](README.md) | [QUICKSTART.md](QUICKSTART.md) | [INTEGRATION_GUIDE.md](INTEGRATION_GUIDE.md)
- **Setup Help:** Run `./setup-wizard.js` for guided setup
- **Issues:** [GitHub Issues](https://github.com/Fused-Gaming/DevOps/issues)
- **Questions:** Check documentation or open a discussion

---

**Ready to automate?** Run `./setup-wizard.js` to get started! 🚀
