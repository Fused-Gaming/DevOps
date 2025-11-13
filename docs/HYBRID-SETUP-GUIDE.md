# Hybrid Approach - Quick Setup Guide

This guide helps you set up the **Hybrid Approach** (Recommendation 3) for feature documentation enforcement.

---

## What You're Getting

✅ **GitHub Actions** - Automatic tiered enforcement on PRs
✅ **CLI Tools** - Helpful commands to create and validate documentation
✅ **Tiered Requirements** - Appropriate rigor based on feature size
✅ **Progressive Rollout** - 6-week adoption plan

---

## Quick Start (5 Minutes)

### Step 1: Enable GitHub Actions Workflow

The workflow is already in place at `.github/workflows/feature-docs-check.yml`.

**To activate:**
```bash
# Ensure you're on the feature branch
git checkout claude/feature-docs-merge-workflow-01UF43BoM9uyqLAJhnUBGmVf

# Merge to main (or create PR)
# The workflow will automatically run on all future feature branch PRs
```

**Optional - Enable Branch Protection:**
1. Go to GitHub repo → Settings → Branches
2. Add rule for `main` and `develop`
3. Enable "Require status checks to pass before merging"
4. Select "Feature Documentation Check"

### Step 2: Set Up CLI Tools

**Create prompt files:**
```bash
# Create directory for prompts
mkdir -p ~/.devops-prompts/features

# Copy CLI prompt files from repo
cp .devops/prompts/features/feature-start.md ~/.devops-prompts/features/
cp .devops/prompts/features/feature-validate.md ~/.devops-prompts/features/
```

**Add aliases to your shell:**
```bash
# Add to ~/.zshrc or ~/.bashrc
cat >> ~/.zshrc << 'EOF'

# Feature documentation workflow
alias devops-feature-start='claude-code "$(cat ~/.devops-prompts/features/feature-start.md)"'
alias devops-feature-validate='claude-code "$(cat ~/.devops-prompts/features/feature-validate.md)"'
EOF

# Reload shell
source ~/.zshrc
```

### Step 3: Test It Out

**Try the CLI:**
```bash
# Start a new feature
devops-feature-start

# Validate existing feature documentation
devops-feature-validate
```

**Test the workflow:**
```bash
# Create a test feature branch
git checkout -b feature/test-hybrid-workflow

# Add small change
echo "test" >> test.txt
git add test.txt
git commit -m "feat: test hybrid workflow"

# Push and create PR
git push -u origin feature/test-hybrid-workflow

# Check GitHub Actions tab - workflow should run!
```

---

## Understanding the Tiers

The workflow automatically determines the tier based on lines changed:

| Tier | Lines Changed | Requirements | Enforcement |
|------|---------------|--------------|-------------|
| **1 (Small)** | <200 | Brief docs recommended | Warnings only |
| **2 (Medium)** | 200-1000 | All 4 sections, 100+ words | Blocks merge |
| **3 (Large)** | >1000 | Comprehensive docs, 200+ words | Blocks merge |

**See:** `docs/TIERED-FEATURE-WORKFLOW.md` for detailed explanation.

---

## How to Use

### Starting a New Feature

**Option 1: Use CLI (Recommended)**
```bash
# CLI guides you through creating branch + documentation
devops-feature-start
```

**Option 2: Manual**
```bash
# Create feature branch
git checkout -b feature/my-awesome-feature

# Copy template
cp docs/templates/FEATURE_TEMPLATE.md docs/features/my-awesome-feature.md

# Fill in Overview and Goals sections now
vim docs/features/my-awesome-feature.md

# Commit documentation scaffold
git add docs/features/my-awesome-feature.md
git commit -m "docs: initialize feature documentation"
```

### During Development

**Update documentation as you code:**
- Fill in Implementation section as you build
- Update Testing section as you write tests
- Commit documentation changes with code changes

### Before Creating PR

**Option 1: Use CLI**
```bash
devops-feature-validate
```

**Option 2: Manual Check**
```bash
# Check all 4 sections present
grep "^## Overview" docs/features/my-feature.md
grep "^## Goals" docs/features/my-feature.md
grep "^## Implementation" docs/features/my-feature.md
grep "^## Testing" docs/features/my-feature.md

# Check word count
wc -w docs/features/my-feature.md
```

### Creating the PR

```bash
# Ensure documentation is committed
git add docs/features/my-feature.md
git commit -m "docs: complete feature documentation"
git push origin feature/my-awesome-feature

# Create PR - workflow validates automatically!
```

---

## Rollout Plan

We recommend a **progressive 6-week rollout**:

### Weeks 1-2: Soft Launch (Warnings Only)
- Workflow runs but doesn't block merges
- Team gets familiar with process
- **Action:** Read guides, try CLI tools

### Weeks 3-4: Tier 3 Enforcement
- Large features (>1000 lines) require documentation
- Small/medium show warnings only
- **Action:** Document large features

### Weeks 5-6: Tier 2 & 3 Enforcement
- Medium (200-1000) and large features require docs
- Small features show warnings only
- **Action:** Document medium+ features

### Week 7+: Standard Practice
- Tier 2 & 3 enforcement continues
- Tier 1 remains recommended
- **Action:** Continuous improvement

**See:** `docs/ROLLOUT-PLAN.md` for complete timeline and communication templates.

---

## Monitoring Progress

**Run metrics script:**
```bash
./scripts/doc-metrics.sh
```

**Output shows:**
- Coverage by tier
- Documentation quality metrics
- Files needing improvement
- Overall quality score

**Run weekly** during rollout, monthly after.

---

## Configuration

### Adjusting Tier Thresholds

Edit `.github/workflows/feature-docs-check.yml`:

```yaml
# Current thresholds (lines 49-67)
if [ $LINES_CHANGED -lt 200 ]; then
  tier=1  # Small
elif [ $LINES_CHANGED -lt 1000 ]; then
  tier=2  # Medium
else
  tier=3  # Large
fi
```

**Recommended thresholds:**
- **Lenient:** 300 / 1500
- **Balanced:** 200 / 1000 (default)
- **Strict:** 100 / 500

### Adjusting Word Count Requirements

Edit `.github/workflows/feature-docs-check.yml` (lines 168-173):

```yaml
if [ "$TIER" = "1" ]; then
  MIN_WORDS=50    # Change this
elif [ "$TIER" = "2" ]; then
  MIN_WORDS=100   # Change this
else
  MIN_WORDS=200   # Change this
fi
```

---

## Team Communication

### Announce to Team

Use this template:

```
Subject: 📝 New Feature Documentation Workflow - Hybrid Approach

Hi Team,

We're implementing a new feature documentation workflow to improve our development process.

WHAT IT DOES:
- Ensures features are documented before merge
- Uses tiered approach based on feature size
- Provides CLI tools to make documentation easy

HOW IT WORKS:
- Small features (<200 lines): Documentation recommended
- Medium features (200-1000): Documentation required
- Large features (>1000 lines): Comprehensive docs required

ROLLOUT TIMELINE:
- Weeks 1-2: Soft launch (warnings only)
- Weeks 3-4: Large features enforced
- Weeks 5-6: Medium+ features enforced
- Week 7+: Standard practice

GETTING STARTED:
1. Read quick guide: docs/FEATURE-DOCS-README.md
2. Copy template when starting features: docs/templates/FEATURE_TEMPLATE.md
3. Use CLI tools: devops-feature-start, devops-feature-validate

RESOURCES:
- Quick Guide: docs/FEATURE-DOCS-README.md
- Full Guide: docs/FEATURE-DOCUMENTATION-GUIDE.md
- Tiered Workflow: docs/TIERED-FEATURE-WORKFLOW.md
- Rollout Plan: docs/ROLLOUT-PLAN.md

DEMO SESSION: [Schedule a 30-min demo]

Questions? Let me know!
```

### Office Hours

Schedule recurring help sessions:
- **Week 1-4:** 2x per week (1 hour each)
- **Week 5-8:** 1x per week
- **Week 9+:** 1x per month

---

## Common Questions

### Q: Do I need both GitHub Actions and CLI tools?
**A:** CLI tools are optional but recommended. They make the workflow easier. GitHub Actions is the enforcement mechanism.

### Q: Can I use just one or the other?
**A:** Yes!
- GitHub Actions only = Recommendation 1
- CLI tools only = Recommendation 2
- Both = Recommendation 3 (Hybrid - best results)

### Q: What if a developer doesn't use Claude Code CLI?
**A:** The GitHub Actions workflow will guide them via PR comments. CLI tools are a convenience, not required.

### Q: Can I customize the template?
**A:** Yes! Edit `docs/templates/FEATURE_TEMPLATE.md` to fit your needs.

### Q: What if the tier is wrong for my feature?
**A:** Use your judgment. If a 150-line feature is complex, create Tier 2 docs anyway. The tiers are guidelines.

### Q: How do I temporarily disable enforcement?
**A:** Edit `.github/workflows/feature-docs-check.yml` and add `if: false` to the job.

---

## Troubleshooting

### Workflow not running
- Check `.github/workflows/feature-docs-check.yml` exists
- Verify Actions are enabled in repo settings
- Check branch protection rules

### CLI commands not found
- Verify aliases added to `.zshrc` or `.bashrc`
- Run `source ~/.zshrc` to reload
- Check prompt files exist in `~/.devops-prompts/features/`

### Documentation check failing
- Read workflow output in Actions tab
- Run `devops-feature-validate` for detailed feedback
- Check template: `docs/templates/FEATURE_TEMPLATE.md`

### Metrics script errors
- Ensure running from repo root
- Check `docs/features/` directory exists
- Verify script is executable: `chmod +x scripts/doc-metrics.sh`

---

## Next Steps

1. **Review the guides:**
   - `docs/FEATURE-DOCS-README.md` - Quick reference
   - `docs/FEATURE-DOCUMENTATION-GUIDE.md` - Complete guide
   - `docs/TIERED-FEATURE-WORKFLOW.md` - Tier explanations

2. **Set up your environment:**
   - Install CLI tools (5 minutes)
   - Test with a sample feature

3. **Plan rollout:**
   - Review `docs/ROLLOUT-PLAN.md`
   - Schedule team demo
   - Set up office hours

4. **Monitor progress:**
   - Run `./scripts/doc-metrics.sh` weekly
   - Track adoption metrics
   - Gather feedback and iterate

---

## Success Checklist

### Week 1
- [ ] GitHub Actions workflow active
- [ ] CLI tools set up for team
- [ ] Documentation structure created
- [ ] Team announcement sent
- [ ] Demo session scheduled

### Week 4
- [ ] 100% Tier 3 features documented
- [ ] Team familiar with process
- [ ] Feedback collected and addressed

### Week 8
- [ ] 95%+ Tier 2 & 3 coverage
- [ ] Documentation quality >80%
- [ ] Process feels routine
- [ ] Measurable impact on code reviews

---

## Support

- **Documentation:** See `docs/` directory
- **Scripts:** See `scripts/` directory
- **Issues:** GitHub Issues in this repo
- **Questions:** [Your team channel / email]

---

**You're all set! The Hybrid Approach gives you the best of automation and guidance. Start with the rollout plan and iterate based on your team's feedback.**

---

**Last Updated:** 2025-11-13
**Version:** 1.0
**Maintained by:** DevOps Team
