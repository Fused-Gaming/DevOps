# Claude Usage Tracking - Complete Guide

## Overview

This repository includes an automated system to track Claude Code usage, estimating tokens and costs based on code changes.

## System Components

### 1. Tracking Workflow
**File**: `.github/workflows/claude-usage-tracking.yml`

**Triggers:**
- On every push to any branch
- On pull requests to main/develop
- Manual workflow dispatch

**What it does:**
- Calculates tokens based on code changes
- Estimates costs using Claude Sonnet 4.5 pricing
- Updates `CLAUDE_USAGE.md` with new entries
- Generates reports in GitHub Actions summary
- Comments on PRs with usage estimates

### 2. Tracking Script
**File**: `scripts/track-claude-usage.sh`

**Purpose:**
- Parses git diffs to calculate changes
- Estimates token usage (~12 tokens per line)
- Updates the usage tracking file
- Maintains running totals

### 3. Usage Log
**File**: `CLAUDE_USAGE.md`

**Contains:**
- Historical usage data (table format)
- Accumulated totals (tokens, cost, sessions)
- Pricing reference
- Documentation notes

## How Token Estimation Works

```bash
# Formula
TOTAL_CHANGES = LINES_ADDED + LINES_DELETED
ESTIMATED_TOKENS = (TOTAL_CHANGES * 12) + 500

# Cost Calculation (Claude Sonnet 4.5)
INPUT_TOKENS = ESTIMATED_TOKENS * 70%
OUTPUT_TOKENS = ESTIMATED_TOKENS * 30%

INPUT_COST = INPUT_TOKENS * ($3.00 / 1M tokens)
OUTPUT_COST = OUTPUT_TOKENS * ($15.00 / 1M tokens)
TOTAL_COST = INPUT_COST + OUTPUT_COST
```

## Workflow Process

```
Push to Branch
     ↓
GitHub Actions Triggered
     ↓
Calculate Changes (git diff)
     ↓
Estimate Tokens & Cost
     ↓
Run track-claude-usage.sh
     ↓
Update CLAUDE_USAGE.md
     ↓
Commit Changes [skip ci]
     ↓
Push to Same Branch
```

## Recent Fixes (2025-11-20)

### Problems Identified
1. ❌ Tracking only worked on `main` branch
2. ❌ Feature branch work wasn't tracked
3. ❌ File had formatting corruption
4. ❌ Totals were incorrect
5. ❌ Missing entries from recent work

### Solutions Applied
1. ✅ Updated workflow to track ALL branches
2. ✅ Fixed CLAUDE_USAGE.md formatting
3. ✅ Reconstructed missing history from git logs
4. ✅ Corrected totals calculation
5. ✅ Added `[skip ci]` to prevent infinite loops
6. ✅ Changed to use github-actions[bot] user

## How to Use

### Automatic Tracking
The system works automatically when you:
1. Make changes to code
2. Commit changes
3. Push to GitHub

The workflow will:
- Calculate usage for your changes
- Update CLAUDE_USAGE.md
- Commit the update automatically
- Show report in Actions summary

### Manual Tracking
To manually track usage:

```bash
# From repository root
bash scripts/track-claude-usage.sh "Your commit message"
```

### View Usage History
```bash
# View the tracking file
cat CLAUDE_USAGE.md

# Or on GitHub
# Navigate to: CLAUDE_USAGE.md
```

## Troubleshooting

### Issue: CLAUDE_USAGE.md Not Updating

**Symptoms:**
- File not changing after pushes
- Missing recent entries

**Solutions:**

1. **Check Workflow Status**
   ```bash
   # View recent workflow runs
   gh run list --workflow=claude-usage-tracking.yml

   # View specific run
   gh run view <run-id>
   ```

2. **Verify Workflow File**
   - Ensure `.github/workflows/claude-usage-tracking.yml` exists
   - Check if conditions on line 107 & 120 block execution
   - Verify permissions (should have `contents: write`)

3. **Check Branch Protection**
   - Some branches may block automatic commits
   - Verify github-actions[bot] has write access

4. **Manual Trigger**
   ```bash
   # Trigger workflow manually
   gh workflow run claude-usage-tracking.yml
   ```

### Issue: Tracking Shows $0.00 or 0 Tokens

**Cause:** No code changes detected (e.g., merge commits)

**Solutions:**
1. This is normal for merge commits
2. Check if `git diff` shows actual changes
3. Verify tracking script has correct permissions

### Issue: File Corruption/Formatting Problems

**Symptoms:**
- Table alignment broken
- Missing pipe characters `|`
- Truncated entries

**Solutions:**

1. **Restore from Backup**
   ```bash
   # If .bak file exists
   cp CLAUDE_USAGE.md.bak CLAUDE_USAGE.md
   ```

2. **Rebuild from Git History**
   ```bash
   # See this guide for reconstruction
   # We did this on 2025-11-20
   git log --all --since="2025-11-16" --pretty=format:"%h|%ai|%s" --numstat
   ```

3. **Manual Fix**
   - Edit CLAUDE_USAGE.md directly
   - Ensure proper table format:
     ```markdown
     | Date | Feature/Fix | Tokens | Cost | ID |
     |------|-------------|--------|------|----|
     | 2025-11-20 | feat: ... | 1000 | $0.01 | abc123 |
     ```

### Issue: Infinite Loop of Commits

**Symptoms:**
- Workflow keeps triggering itself
- Many "chore: update Claude usage tracking" commits

**Prevention:**
- All automatic commits include `[skip ci]` tag
- This prevents re-triggering the workflow

**Solutions:**
1. Verify commit messages include `[skip ci]`
2. Check workflow file line 127 has `[skip ci]`
3. Temporarily disable workflow if needed:
   ```yaml
   # Comment out workflow trigger
   # on:
   #   push:
   #     branches: ["**"]
   ```

### Issue: Permissions Error on Push

**Symptoms:**
```
error: failed to push some refs
Permission denied
```

**Solutions:**

1. **Check Workflow Permissions**
   ```yaml
   permissions:
     contents: write  # Required for push
     pull-requests: write
     issues: write
   ```

2. **Verify Token**
   - Workflow uses `${{ secrets.GITHUB_TOKEN }}`
   - Token should have write access
   - Check repository settings → Actions → General → Workflow permissions

3. **Branch Protection Rules**
   - May need to allow github-actions[bot]
   - Settings → Branches → Protection rules

## Advanced Usage

### Custom Token Estimates

To adjust token estimation formula, edit:
```bash
# File: scripts/track-claude-usage.sh
# Line 39
ESTIMATED_TOKENS=$((TOTAL_CHANGES * 12 + 500))

# Adjust multiplier (12) based on your average
# Adjust baseline (500) for context overhead
```

### Filter Certain Files

To exclude files from tracking:
```bash
# In calculate step (workflow line 64)
FILES_CHANGED=$(git diff --numstat $BASE_REF HEAD -- ':!*.md' ':!*.json' | wc -l)
```

### Custom Pricing

Update pricing in workflow (lines 79-80):
```yaml
# Claude Sonnet 4.5 pricing (per million tokens)
# Input: $3.00, Output: $15.00
```

## Monitoring & Reporting

### View Reports in GitHub Actions

1. Go to Actions tab
2. Click on workflow run
3. View "Summary" for detailed report

### Generate Local Report

```bash
# View totals
grep "Total" CLAUDE_USAGE.md

# Calculate monthly costs
awk -F'|' '/2025-11/ {gsub(/[$ ]/, "", $4); sum+=$4} END {print "November 2025: $" sum}' CLAUDE_USAGE.md
```

### Export to CSV

```bash
# Convert table to CSV
grep -E "^\| 20" CLAUDE_USAGE.md | \
  sed 's/^| //; s/ | /,/g; s/ |$//' > claude-usage.csv
```

## Best Practices

1. **Regular Reviews**
   - Check CLAUDE_USAGE.md monthly
   - Verify totals are accurate
   - Look for anomalies

2. **Backup**
   - Track CLAUDE_USAGE.md in git (already done)
   - Periodically export to CSV
   - Keep old versions for reference

3. **Optimization**
   - Review high-cost sessions
   - Look for patterns in usage
   - Optimize prompts and workflows

4. **Validation**
   - Compare estimates with actual bills
   - Adjust multipliers if needed
   - Document any manual corrections

## Integration with DevOps

This tracking system integrates with:
- **PR Automation**: Comments on PRs with usage
- **Milestone Tracking**: Correlates features with costs
- **CI/CD**: Runs on every build
- **Testing**: Estimates test-related usage

## Support & Updates

### Documentation
- This guide: `docs/USAGE-TRACKING-GUIDE.md`
- Usage log: `CLAUDE_USAGE.md`
- Workflow: `.github/workflows/claude-usage-tracking.yml`
- Script: `scripts/track-claude-usage.sh`

### Recent Changes
- **2025-11-20**: Fixed branch tracking, rebuilt history, added `[skip ci]`
- **2025-11-18**: Initial tracking system implementation

### Future Enhancements
- [ ] Integration with actual Claude API usage
- [ ] Real-time token counting
- [ ] Budget alerts and warnings
- [ ] Per-feature cost breakdown
- [ ] Monthly/quarterly reports
- [ ] Cost optimization suggestions

---

*Last Updated: 2025-11-20*
*Version: 1.1.0*
*Maintainer: DevOps Team*
