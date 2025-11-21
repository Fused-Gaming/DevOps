# 📊 Milestone Tracking System

Automated system for tracking DevOps MVP milestones, creating issues, and monitoring progress.

## Overview

The DevOps repository uses GitHub Milestones to track MVP progress across 5 key areas:

1. **Installable Developer Toolkit** - Easy installation and setup
2. **CI/CD Templates** - Ready-to-use GitHub Actions workflows
3. **Security Baseline** - Security scanning and remediation
4. **Feature Documentation Enforcement** - Automated documentation checks
5. **Developer UX** - Polished experience and v0.1.0 release

## Quick Start

### Check Milestone Status

```bash
# Simple status check
bash scripts/milestone-status.sh

# Detailed progress report (requires jq)
bash scripts/check-milestone-progress.sh
```

### Create Missing Issues

```bash
# Interactive mode (prompts for confirmation)
bash scripts/create-milestone-issues.sh

# Automatic mode (via GitHub Actions)
gh workflow run init-milestones.yml
```

## Automated Workflows

### 1. Milestone Progress Tracking (`milestone-tracking.yml`)

**Triggers:**
- When issues are opened, closed, or updated
- When issues are assigned to milestones
- Manual dispatch

**Features:**
- 📊 Real-time progress updates
- 💬 Automatic comments on milestone-related issues
- ⚠️  Critical issue detection
- 📈 Progress bars and percentages

**Example Comment:**
```
🎯 Milestone Progress Update

This issue was closed, updating **CI/CD Templates** progress:

████████████████░░░░ 80%

Status: 4/5 issues completed

🔥 Almost there! Keep going!

[View Milestone](https://github.com/...)
```

### 2. Milestone Initialization (`init-milestones.yml`)

**Purpose:** Create all milestone issues for a new project

**Usage:**
```bash
# Via GitHub UI: Actions → Init Milestones → Run workflow

# Via CLI
gh workflow run init-milestones.yml

# Force recreate
gh workflow run init-milestones.yml -f force=true
```

**What it creates:**
- 37 total issues across all milestones
- Proper labels (enhancement, bug, testing, documentation)
- Priority tags (critical, high)
- Detailed descriptions with acceptance criteria

### 3. Stale Critical Issue Checker

**Runs:** Weekly (can also trigger manually)

**Purpose:** Find critical issues that haven't been updated in 30+ days

**Action:** Posts reminder comments and fails workflow

## Scripts

### `scripts/milestone-status.sh`

Simple status checker with zero dependencies (uses gh CLI only).

**Output:**
```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  📊 DevOps MVP Milestone Status
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Milestones:

1. Installable developer toolkit:
  Progress: 5/8 issues (62%)
  Open: 3 | Closed: 5

2. CI/CD Templates:
  Progress: 3/7 issues (42%)
  Open: 4 | Closed: 3

...
```

### `scripts/check-milestone-progress.sh`

Detailed progress report with visual progress bars (requires jq).

**Features:**
- 📊 Visual progress bars
- 🎯 Overall MVP percentage
- ⚠️  Critical issue listing
- 🎉 MVP completion detection
- 📋 Next steps recommendations

**Output:**
```
█████████████████████░░░ 60%

MVP Progress:   15/25 MVP issues completed
```

### `scripts/create-milestone-issues.sh`

Creates all 37 milestone issues with proper structure.

**Features:**
- ✅ Marks completed issues as closed
- 🏷️  Applies appropriate labels
- 📝 Includes detailed acceptance criteria
- 🎯 Assigns to correct milestones
- 🔄 Idempotent (can run multiple times)

## Issue Labels

### Priority Labels
- `priority:critical` - Blocking issues for MVP
- `priority:high` - Important but not blocking
- `priority:medium` - Normal priority (default)
- `priority:low` - Nice-to-have

### Type Labels
- `enhancement` - New features
- `bug` - Something isn't working
- `documentation` - Docs improvements
- `testing` - Test-related
- `ci-cd` - CI/CD workflow changes
- `security` - Security-related

### Milestone Labels
- `milestone-1` through `milestone-5` - Quick filtering by milestone

## Integrating with Your Workflow

### Daily Usage

1. **Morning standup:**
   ```bash
   bash scripts/milestone-status.sh
   ```

2. **Before starting work:**
   - Check critical issues
   - Pick highest priority open issue
   - Create feature branch

3. **After completing work:**
   - Close issue in PR
   - Workflow automatically updates milestone

### Weekly Review

1. Run detailed progress report:
   ```bash
   bash scripts/check-milestone-progress.sh
   ```

2. Review critical issues
3. Update milestone due dates if needed
4. Close completed milestones

### MVP Completion

When MVP reaches 100%:

```bash
# 1. Verify all critical issues closed
bash scripts/check-milestone-progress.sh

# 2. Create CHANGELOG.md
# 3. Tag release
git tag -a v0.1.0 -m "Release v0.1.0: MVP Complete"
git push origin v0.1.0

# 4. Create GitHub release
gh release create v0.1.0 \
  --title "v0.1.0: MVP Release" \
  --notes-file CHANGELOG.md
```

## Adding to Setup Script

You can integrate milestone tracking into your setup:

```bash
# In setup-devops-quick-access.sh

# Add alias for milestone status
cat >> "$SHELL_RC" << 'EOF'

# Milestone tracking
alias devops-milestones='bash $(git rev-parse --show-toplevel)/scripts/milestone-status.sh'
alias devops-mvp-status='bash $(git rev-parse --show-toplevel)/scripts/check-milestone-progress.sh'

EOF
```

Then use:
```bash
devops-milestones        # Quick status
devops-mvp-status        # Detailed report
```

## API Access

### Get Milestone Progress Programmatically

```bash
# Get all milestones with issue counts
gh api repos/Fused-Gaming/DevOps/milestones --jq '.[] | {
  title: .title,
  number: .number,
  open_issues: .open_issues,
  closed_issues: .closed_issues,
  percentage: (if (.open_issues + .closed_issues) > 0 then ((.closed_issues * 100) / (.open_issues + .closed_issues) | floor) else 0 end)
}'

# Get issues for specific milestone
gh api repos/Fused-Gaming/DevOps/issues \
  --field milestone=2 \
  --field state=all

# Get critical issues
gh api repos/Fused-Gaming/DevOps/issues \
  --field labels=priority:critical \
  --field state=open
```

### Using in CI/CD

```yaml
# Example: Block deployment if critical issues exist
- name: Check critical issues
  run: |
    CRITICAL_COUNT=$(gh api repos/${{ github.repository }}/issues \
      --field labels=priority:critical \
      --field state=open \
      --jq 'length')

    if [ "$CRITICAL_COUNT" -gt 0 ]; then
      echo "::error::Cannot deploy: $CRITICAL_COUNT critical issues open"
      exit 1
    fi
```

## Troubleshooting

### Issues not appearing in milestone

Check the milestone was created correctly:
```bash
gh api repos/Fused-Gaming/DevOps/milestones
```

### Progress not updating

1. Verify issue is assigned to milestone
2. Check GitHub Actions workflow ran successfully
3. Manually trigger workflow:
   ```bash
   gh workflow run milestone-tracking.yml
   ```

### Script fails with authentication error

Authenticate gh CLI:
```bash
gh auth login
gh auth status
```

## Best Practices

1. **Always use labels** - Helps with filtering and prioritization
2. **Update critical issues first** - They block MVP completion
3. **Close issues in PRs** - Use `Closes #123` syntax
4. **Review weekly** - Keep milestones accurate
5. **Document blocking issues** - Add comments explaining delays

## Future Enhancements

Potential additions to the milestone tracking system:

- 📧 Email notifications for milestone completion
- 📊 Grafana dashboard integration
- 🤖 Slack bot for milestone updates
- 📈 Burndown chart generation
- 🎯 Automatic milestone creation from templates
- 🔄 Milestone cloning for new projects

## Resources

- [GitHub Milestones](https://github.com/Fused-Gaming/DevOps/milestones)
- [GitHub Issues](https://github.com/Fused-Gaming/DevOps/issues)
- [GitHub CLI Docs](https://cli.github.com/manual/)
- [GitHub Actions Docs](https://docs.github.com/en/actions)

---

**Questions or improvements?** Open an issue with the `documentation` label!
