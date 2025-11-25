# Vercel Deployment Monitoring System

## Overview

This document describes the automated monitoring system for Vercel deployments, specifically designed to monitor **design.vln.gg** and automatically create GitHub issues when deployments fail.

## Features

✅ **Automated Monitoring** - Checks deployment status every 30 minutes
✅ **Smart Error Detection** - Analyzes build logs and identifies specific error types
✅ **Auto-Issue Creation** - Creates detailed GitHub issues on deployment failures
✅ **Solution Suggestions** - Provides context-aware solutions based on error type
✅ **Detailed Logging** - Includes full build logs and error traces
✅ **Duplicate Prevention** - Monitors and manages multiple failure issues

## Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                    GitHub Actions Workflow                   │
│                 (vercel-deployment-monitor.yml)              │
└─────────────────┬───────────────────────────────────────────┘
                  │
                  │ Triggers:
                  │ • Push to main (design-standards/**)
                  │ • Schedule (every 30 minutes)
                  │ • Manual dispatch
                  │
                  ▼
┌─────────────────────────────────────────────────────────────┐
│              Monitoring Script (Bash)                        │
│          (scripts/monitor-vercel-deployment.sh)              │
│                                                              │
│  1. Fetch latest deployment via Vercel API                  │
│  2. Check deployment state (READY/ERROR/BUILDING)           │
│  3. If failed: Fetch build logs                             │
│  4. Analyze errors and generate solutions                   │
│  5. Create GitHub issue with details                        │
└─────────────────┬───────────────────────────────────────────┘
                  │
                  ▼
┌─────────────────────────────────────────────────────────────┐
│                    GitHub Issue Created                      │
│                                                              │
│  Contains:                                                   │
│  • Error summary and details                                │
│  • Full build logs (expandable)                             │
│  • Possible solutions (context-aware)                       │
│  • Links to Vercel dashboard                                │
│  • Deployment ID and timestamp                              │
│                                                              │
│  Labels: deployment, bug, vercel, automated                 │
└─────────────────────────────────────────────────────────────┘
```

## Components

### 1. GitHub Actions Workflow

**File:** `.github/workflows/vercel-deployment-monitor.yml`

**Triggers:**
- **Push events:** Monitors pushes to `main` branch that affect `design-standards/` directory
- **Schedule:** Runs every 30 minutes via cron (`*/30 * * * *`)
- **Manual:** Can be triggered manually via GitHub Actions UI

**Jobs:**
- `monitor-deployment` - Runs the monitoring script and creates issues on failure
- `cleanup-duplicate-issues` - Helps manage multiple failure issues

### 2. Monitoring Script

**File:** `scripts/monitor-vercel-deployment.sh`

**Functionality:**
- Queries Vercel API for latest deployment status
- Analyzes deployment state (READY, ERROR, BUILDING, QUEUED)
- Fetches build logs when failures are detected
- Performs intelligent error pattern matching
- Generates context-aware solution recommendations
- Creates GitHub issues via GitHub API

**Error Detection Patterns:**
- Framework validation errors (vercel.json)
- Dependency installation failures (npm/yarn errors)
- Build process errors
- Timeout issues
- Generic deployment failures

### 3. Issue Creation

**Issue Format:**
```markdown
🚨 Vercel Deployment Failed: design.vln.gg

## Summary
- Domain, project, deployment ID
- Error state and timestamp

## Error
- Brief error summary

## Error Details
- Specific error messages from logs

## Possible Solutions
- Context-aware solutions (3-5 options)
- Links to documentation
- Step-by-step fixes

## Links
- Vercel dashboard links
- Project settings
- All deployments

## Build Logs Sample
- Expandable section with full logs
```

**Labels Applied:**
- `deployment` - Identifies deployment-related issues
- `bug` - Marks as a bug/error
- `vercel` - Platform-specific tag
- `automated` - Indicates auto-generated issue

## Setup Instructions

### Prerequisites

1. **Vercel API Token**
   - Go to [Vercel Account Settings](https://vercel.com/account/tokens)
   - Create a new token with appropriate permissions
   - Add to GitHub Secrets as `VERCEL_TOKEN`

2. **GitHub Token**
   - Automatically available as `${{ secrets.GITHUB_TOKEN }}`
   - Ensure workflow has `issues: write` permission

### Installation

1. **Add the monitoring script:**
```bash
# Script is already in scripts/monitor-vercel-deployment.sh
chmod +x scripts/monitor-vercel-deployment.sh
```

2. **Deploy the workflow:**
```bash
# Workflow is already in .github/workflows/vercel-deployment-monitor.yml
git add .github/workflows/vercel-deployment-monitor.yml
git commit -m "feat: add Vercel deployment monitoring"
git push
```

3. **Configure GitHub Secrets:**
```bash
# Using GitHub CLI
gh secret set VERCEL_TOKEN

# Or manually in GitHub UI:
# Settings → Secrets and variables → Actions → New repository secret
```

4. **Verify setup:**
```bash
# Manually trigger the workflow to test
gh workflow run vercel-deployment-monitor.yml
```

## Usage

### Automatic Monitoring

Once deployed, the system monitors automatically:
- Every 30 minutes via scheduled runs
- After pushes to `design-standards/` on main branch

No manual intervention required for normal operations.

### Manual Monitoring

To manually check deployment status:

**Via GitHub Actions UI:**
1. Go to **Actions** tab
2. Select **Vercel Deployment Monitor** workflow
3. Click **Run workflow**
4. Select branch (usually `main`)
5. Click **Run workflow**

**Via GitHub CLI:**
```bash
gh workflow run vercel-deployment-monitor.yml
```

**Via Script (Local):**
```bash
export VERCEL_TOKEN="your-token"
export GITHUB_TOKEN="your-token"
export GITHUB_REPOSITORY="owner/repo"

./scripts/monitor-vercel-deployment.sh design-standards
```

## Error Types and Solutions

### Framework Validation Error

**Symptoms:**
- Error message contains "framework"
- Deployment fails immediately

**Auto-Generated Solutions:**
1. Check `vercel.json` framework value
2. Use `"docusaurus-2"` for Docusaurus projects
3. Remove framework field to enable auto-detection
4. Validate JSON syntax

### Dependency Installation Failed

**Symptoms:**
- "npm error" or "yarn error" in logs
- Installation step fails

**Auto-Generated Solutions:**
1. Update `package-lock.json` or `yarn.lock`
2. Verify Node.js version compatibility
3. Clear Vercel cache and retry
4. Check for private package access

### Build Process Failed

**Symptoms:**
- "build failed" or "build error"
- Build step fails

**Auto-Generated Solutions:**
1. Run build locally first
2. Verify build command in `vercel.json`
3. Check output directory configuration
4. Review environment variables
5. Examine recent code changes

### Build Timeout

**Symptoms:**
- "timeout" in error logs
- Build exceeds time limit

**Auto-Generated Solutions:**
1. Optimize build process
2. Upgrade Vercel plan for longer timeouts
3. Reduce bundle size
4. Enable caching

## Monitoring Dashboard

### GitHub Actions Summary

Each workflow run generates a detailed summary:
- ✅ Deployment status (success/failed/unknown)
- 📊 Check timestamp
- 🔗 Links to issues and Vercel dashboard
- 📋 Next steps and recommendations

### Issue Tracking

View all deployment issues:
```bash
# Via GitHub CLI
gh issue list --label deployment,automated

# Or in browser:
# https://github.com/YOUR_ORG/YOUR_REPO/issues?q=is:issue+label:deployment+label:automated
```

## Configuration

### Change Monitoring Frequency

Edit `.github/workflows/vercel-deployment-monitor.yml`:

```yaml
schedule:
  # Every 30 minutes (current)
  - cron: '*/30 * * * *'

  # Every hour
  - cron: '0 * * * *'

  # Every 15 minutes
  - cron: '*/15 * * * *'
```

### Monitor Different Projects

Manual trigger with custom project:
```bash
gh workflow run vercel-deployment-monitor.yml \
  -f project_name=my-other-project
```

Or edit workflow defaults:
```yaml
env:
  PROJECT_NAME: ${{ github.event.inputs.project_name || 'your-project' }}
```

### Customize Issue Labels

Edit `scripts/monitor-vercel-deployment.sh`:

```bash
"labels": ["deployment", "bug", "vercel", "automated", "high-priority"]
```

## Troubleshooting

### Workflow Not Running

**Check:**
1. Workflow file syntax is valid
2. Repository has Actions enabled
3. Secrets are properly configured
4. Branch protection rules allow workflow runs

**Fix:**
```bash
# Validate workflow syntax
gh workflow view vercel-deployment-monitor.yml

# Check workflow runs
gh run list --workflow=vercel-deployment-monitor.yml
```

### Issues Not Being Created

**Check:**
1. `GITHUB_TOKEN` has `issues: write` permission
2. Repository settings allow issue creation
3. Script has execute permissions

**Fix:**
```bash
# Make script executable
chmod +x scripts/monitor-vercel-deployment.sh

# Test script locally
export VERCEL_TOKEN="..."
export GITHUB_TOKEN="..."
export GITHUB_REPOSITORY="owner/repo"
./scripts/monitor-vercel-deployment.sh design-standards
```

### Vercel API Errors

**Check:**
1. `VERCEL_TOKEN` is valid and not expired
2. Token has access to the project
3. Project name is correct

**Fix:**
```bash
# Verify token works
curl -H "Authorization: Bearer $VERCEL_TOKEN" \
  https://api.vercel.com/v6/deployments?limit=1

# List projects
curl -H "Authorization: Bearer $VERCEL_TOKEN" \
  https://api.vercel.com/v9/projects
```

### False Positives

If issues are created for successful deployments:

1. Check deployment state detection logic
2. Verify Vercel API response format hasn't changed
3. Add debug logging to script

## Best Practices

### Issue Management

1. **Close resolved issues promptly** - Once deployment is fixed
2. **Comment on existing issues** - Instead of creating duplicates
3. **Add context** - Include any manual fixes or workarounds
4. **Tag team members** - @ mention relevant developers

### Monitoring Hygiene

1. **Review issues weekly** - Ensure no critical failures are missed
2. **Update solutions** - Add new error patterns as discovered
3. **Monitor workflow runs** - Check Actions tab for monitoring health
4. **Adjust schedule** - Balance between responsiveness and API usage

### Development Workflow

1. **Test builds locally** - Before pushing to main
2. **Use preview deployments** - Test in Vercel preview first
3. **Monitor after deploys** - Check first scheduled run after push
4. **Fix issues quickly** - Automated alerts enable fast response

## Advanced Usage

### Add Custom Error Patterns

Edit `scripts/monitor-vercel-deployment.sh`:

```bash
elif echo "$BUILD_LOGS" | grep -qi "your-custom-error"; then
    ERROR_SUMMARY="Your custom error description"
    ERROR_DETAILS=$(echo "$BUILD_LOGS" | grep -i "your-pattern" | head -20)
    POSSIBLE_SOLUTIONS="## Possible Solutions

1. **Solution 1**
   - Step-by-step fix

2. **Solution 2**
   - Alternative approach"
```

### Integrate with Slack/Discord

Add notification step to workflow:

```yaml
- name: 📢 Send Slack Notification
  if: steps.monitor.outputs.deployment_status == 'failed'
  uses: slackapi/slack-github-action@v1
  with:
    webhook-url: ${{ secrets.SLACK_WEBHOOK }}
    payload: |
      {
        "text": "🚨 Vercel deployment failed for design.vln.gg",
        "blocks": [...]
      }
```

### Export Metrics

Add metrics collection:

```yaml
- name: 📊 Record Metrics
  run: |
    # Log to file or external service
    echo "$(date),${DEPLOYMENT_STATUS}" >> deployment-metrics.csv
```

## Support and Contribution

### Getting Help

- **Documentation Issues:** Open issue with `docs` label
- **Script Bugs:** Open issue with `bug`, `monitoring` labels
- **Feature Requests:** Open issue with `enhancement` label

### Contributing

To improve the monitoring system:

1. Fork the repository
2. Create feature branch
3. Update script and/or workflow
4. Test thoroughly
5. Submit pull request with clear description

## Changelog

### v1.0.0 (2025-11-21)

- ✅ Initial release
- ✅ Automated deployment monitoring
- ✅ Intelligent error detection
- ✅ Context-aware solution generation
- ✅ Auto-issue creation
- ✅ Scheduled and event-driven checks

## License

This monitoring system is part of the DevOps repository and follows the same license.

---

**Last Updated:** 2025-11-21
**Maintained By:** DevOps Team
**Status:** ✅ Active
