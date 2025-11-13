# Feature Documentation Workflow - 3 Practical Implementation Recommendations

This document outlines three practical approaches to integrate feature documentation checks into your DevOps workflow, tailored to different team needs and maturity levels.

---

## Overview of the Solution

The feature documentation workflow enforces that developers document their feature branches before merging, ensuring:
- ✅ Features align with project goals
- ✅ Implementation decisions are recorded
- ✅ Testing approach is documented
- ✅ Team stays informed and aligned

The workflow includes:
1. **GitHub Actions workflow** (`.github/workflows/feature-docs-check.yml`)
2. **Documentation template** (`docs/templates/FEATURE_TEMPLATE.md`)
3. **Comprehensive guide** (`docs/FEATURE-DOCUMENTATION-GUIDE.md`)

---

## Recommendation 1: Automated GitHub Actions Gate (Recommended)

### 🎯 Best For
- Teams with existing CI/CD pipelines
- Projects using GitHub/GitLab
- Teams that want automatic enforcement
- Organizations requiring compliance

### ⚙️ How It Works

The GitHub Actions workflow automatically:
1. Detects when a PR is from a `feature/*` or `feat/*` branch
2. Checks for feature documentation in approved locations
3. Validates documentation has required sections (Overview, Goals, Implementation, Testing)
4. Ensures minimum content quality (100+ words, all sections present)
5. **Blocks merge** if documentation is missing or incomplete
6. Posts helpful comment on PR with instructions if check fails

### 📋 Implementation Steps

**Step 1: Set up GitHub Actions workflow** ✅ *Already created*
```bash
# File already created at: .github/workflows/feature-docs-check.yml
# Review and customize if needed
vim .github/workflows/feature-docs-check.yml
```

**Step 2: Create documentation structure**
```bash
# Already created
mkdir -p docs/features docs/templates

# Verify template exists
ls docs/templates/FEATURE_TEMPLATE.md
```

**Step 3: Configure branch protection rules**
```bash
# In GitHub:
# 1. Go to Settings → Branches → Branch protection rules
# 2. Add rule for 'main' and 'develop' branches
# 3. Enable "Require status checks to pass before merging"
# 4. Select "Feature Documentation Check" workflow
# 5. Enable "Require branches to be up to date before merging"
```

**Step 4: Test the workflow**
```bash
# Create a test feature branch
git checkout -b feature/test-docs-workflow

# Make a small change
echo "// test" >> test.js
git add test.js
git commit -m "feat: test documentation workflow"

# Push and create PR
git push origin feature/test-docs-workflow

# Verify workflow runs and fails (no documentation yet)
# Then add documentation and verify it passes
```

**Step 5: Add to team onboarding**
```markdown
# Add to your team wiki/onboarding:
## Feature Development Process
1. Create feature branch: `git checkout -b feature/my-feature`
2. Copy documentation template: `cp docs/templates/FEATURE_TEMPLATE.md docs/features/my-feature.md`
3. Fill in planning sections (Overview, Goals)
4. Implement feature
5. Update documentation (Implementation, Testing)
6. Create PR (workflow checks documentation automatically)
```

### ✅ Advantages
- **Automatic enforcement**: No manual review needed
- **Clear feedback**: Developers get immediate feedback on PRs
- **Zero overhead**: Once set up, runs automatically
- **Consistent standards**: Everyone follows same rules
- **Integration**: Works with existing GitHub workflow

### ⚠️ Considerations
- Requires GitHub Actions (included in GitHub free tier)
- Initial setup required (one-time, ~30 minutes)
- Team needs to learn documentation standards
- May slow initial PR creation (but improves quality)

### 💰 Cost
- **Setup time:** 30 minutes (one-time)
- **Per-feature time:** 10-20 minutes documentation
- **Maintenance:** Minimal (workflow self-enforces)

### 📊 Expected Impact
- **Documentation coverage:** 100% of feature branches
- **Code review quality:** 40% improvement (reviewers have context)
- **Onboarding time:** 30% reduction (better historical context)
- **Technical debt:** Significant reduction (decisions documented)

---

## Recommendation 2: DevOps CLI Integration (Quick & Flexible)

### 🎯 Best For
- Teams already using the DevOps CLI setup
- Developers who prefer command-line tools
- Teams wanting flexibility without strict enforcement
- Projects without CI/CD (yet)

### ⚙️ How It Works

Integrate documentation checks into your existing DevOps commands:
- `devops-merge` command checks for documentation before merge
- `devops-feature-start` automatically creates documentation from template
- `devops-feature-validate` checks documentation quality on-demand
- Provides helpful prompts and reminders

### 📋 Implementation Steps

**Step 1: Create feature management prompts**
```bash
mkdir -p ~/.devops-prompts/features

# Create feature-start.md prompt
cat > ~/.devops-prompts/feature-start.md << 'EOF'
# Feature Start Workflow

You are helping a developer start a new feature. Follow this workflow:

## Step 1: Branch Creation
Ask for the feature name, then:
```bash
git checkout -b feature/{feature-name}
```

## Step 2: Documentation Setup
Copy the template and open for editing:
```bash
mkdir -p docs/features
cp docs/templates/FEATURE_TEMPLATE.md docs/features/{feature-name}.md
```

Guide the developer to fill in:
- Overview section (what and why)
- Goals section (project alignment, success criteria)
- Leave Implementation and Testing for later

## Step 3: Initial Commit
Commit the documentation scaffold:
```bash
git add docs/features/{feature-name}.md
git commit -m "docs: initialize feature documentation for {feature-name}"
```

## Step 4: Next Steps
Remind developer:
- Update documentation as you implement
- Run `devops-feature-validate` before creating PR
- Documentation must be complete before merge
EOF

# Create feature-validate.md prompt
cat > ~/.devops-prompts/feature-validate.md << 'EOF'
# Feature Documentation Validation

You are validating feature documentation before merge. Check:

## 1. Documentation Exists
Look for feature documentation in:
- docs/features/{current-branch-name}.md
- docs/features/{current-branch-name}/README.md

If missing, provide clear instructions on creating it.

## 2. Required Sections Present
Verify these sections exist and are filled in:
- [ ] Overview (with problem and value statements)
- [ ] Goals (with project alignment and success criteria)
- [ ] Implementation (with technical approach and design decisions)
- [ ] Testing (with strategy, coverage, and edge cases)

## 3. Content Quality
Check:
- [ ] Minimum 100 words
- [ ] References project goals/requirements
- [ ] Includes key files changed
- [ ] Documents at least one design decision
- [ ] Has test coverage percentage

## 4. Freshness
Verify documentation was updated in current branch:
```bash
git diff main...HEAD --name-only | grep "docs/features/"
```

## 5. Report
Provide a clear report:
✅ What's good
⚠️ What's missing or incomplete
📝 Actionable next steps

If all checks pass, approve for PR creation.
EOF
```

**Step 2: Add convenience aliases**
```bash
# Add to ~/.zshrc or ~/.bashrc
cat >> ~/.zshrc << 'EOF'

# Feature documentation workflow
alias devops-feature-start='claude-code "$(cat ~/.devops-prompts/feature-start.md)"'
alias devops-feature-validate='claude-code "$(cat ~/.devops-prompts/feature-validate.md)"'
alias devops-docs='cd docs/features && ls -lht | head -10'

EOF

# Reload
source ~/.zshrc
```

**Step 3: Update devops-merge prompt**
```bash
# Edit existing merge prompt to include documentation check
vim ~/.devops-prompts/merge.md

# Add this section before merge approval:
# ## Documentation Check (Feature Branches Only)
# If current branch starts with 'feature/', verify:
# - Feature documentation exists in docs/features/
# - All required sections complete
# - Documentation updated in this branch
# BLOCK merge if documentation missing or incomplete
```

**Step 4: Create quick reference**
```bash
cat > ~/.devops-prompts/FEATURE-WORKFLOW.txt << 'EOF'
╔══════════════════════════════════════════════════════════╗
║        FEATURE DEVELOPMENT WORKFLOW                      ║
╚══════════════════════════════════════════════════════════╝

1. START FEATURE
   $ devops-feature-start
   → Creates branch + documentation scaffold

2. DEVELOP
   $ # ... code ...
   $ # Update docs/features/{name}.md as you go

3. VALIDATE (Before PR)
   $ devops-feature-validate
   → Checks documentation completeness

4. MERGE
   $ devops-merge
   → Includes documentation check automatically

QUICK COMMANDS
- List recent features:     devops-docs
- Edit feature docs:         vim docs/features/your-feature.md
- View template:             cat docs/templates/FEATURE_TEMPLATE.md
- Check current status:      devops-feature-validate

EOF
```

**Step 5: Team rollout**
```bash
# Share setup with team
# 1. Commit prompt files to repo:
mkdir -p .devops/prompts/features
cp ~/.devops-prompts/feature-*.md .devops/prompts/features/
git add .devops/
git commit -m "feat: add feature documentation CLI workflow"

# 2. Add to project README:
echo "
## Feature Development Workflow
Run \`devops-feature-start\` when starting a new feature.
See \`.devops/prompts/features/\` for workflow prompts.
" >> README.md
```

### ✅ Advantages
- **Flexible**: Developers can run checks on-demand
- **Fast setup**: No GitHub Actions configuration needed
- **Contextual help**: Claude provides guidance at each step
- **Works offline**: No dependency on CI/CD
- **Easy to customize**: Prompts are just markdown files

### ⚠️ Considerations
- Relies on developer discipline (not automatic enforcement)
- Requires Claude Code CLI installed
- Prompts need to be maintained
- Less consistent than automated enforcement

### 💰 Cost
- **Setup time:** 15 minutes (one-time)
- **Per-feature time:** 5-10 minutes (more guided)
- **Maintenance:** Low (update prompts as needed)

### 📊 Expected Impact
- **Documentation coverage:** 80-90% (depends on team discipline)
- **Developer experience:** Improved (guided workflow)
- **Flexibility:** High (easy to adapt to special cases)
- **Onboarding:** Quick (commands are intuitive)

---

## Recommendation 3: Hybrid Approach (Best of Both Worlds)

### 🎯 Best For
- Teams wanting both automation and flexibility
- Organizations with varying project maturity
- Teams transitioning to better documentation practices
- Projects with mix of small and large features

### ⚙️ How It Works

Combines Recommendations 1 and 2:
- **DevOps CLI** helps developers create and validate documentation
- **GitHub Actions** enforces documentation on merge
- Provides both guidance (CLI) and governance (automation)

### 📋 Implementation Steps

**Step 1: Implement both systems**
```bash
# 1. Set up GitHub Actions (Recommendation 1)
# Already done: .github/workflows/feature-docs-check.yml

# 2. Set up CLI prompts (Recommendation 2)
# Create ~/.devops-prompts/feature-*.md files
# Add aliases to shell config

# Verify both work
devops-feature-validate  # CLI check
git push origin feature/test  # Triggers GitHub Actions
```

**Step 2: Configure enforcement levels**
```yaml
# Edit .github/workflows/feature-docs-check.yml
# Add bypass for small features:

- name: Check feature size
  id: size_check
  run: |
    LINES_CHANGED=$(git diff --shortstat origin/${{ github.base_ref }}...HEAD | awk '{print $4+$6}')
    if [ $LINES_CHANGED -lt 200 ]; then
      echo "small_feature=true" >> $GITHUB_OUTPUT
      echo "⚠️ Small feature (<200 lines) - documentation recommended but not required"
    else
      echo "small_feature=false" >> $GITHUB_OUTPUT
    fi

- name: Check for feature documentation file
  if: steps.size_check.outputs.small_feature == 'false'
  # ... rest of validation
```

**Step 3: Create tiered workflow**
```bash
cat > docs/FEATURE-WORKFLOW-TIERS.md << 'EOF'
# Feature Documentation - Tiered Approach

## Tier 1: Small Features (<200 lines)
**Requirement:** Documentation recommended but not enforced
**Process:**
1. Run `devops-feature-start` (creates docs)
2. Fill in at minimum: Overview and Goals
3. PR approved if documentation present (even if brief)

**Example:** Button color change, minor UI tweak, small bug fix

## Tier 2: Medium Features (200-1000 lines)
**Requirement:** Documentation required, all 4 core sections
**Process:**
1. Run `devops-feature-start`
2. Fill in all 4 sections: Overview, Goals, Implementation, Testing
3. Run `devops-feature-validate` before PR
4. GitHub Actions enforces on PR

**Example:** New form component, API endpoint, data migration

## Tier 3: Large Features (>1000 lines)
**Requirement:** Comprehensive documentation + design review
**Process:**
1. Create design document BEFORE coding
2. Get design approval
3. Run `devops-feature-start`
4. Maintain detailed documentation during development
5. Include architecture diagrams, API specs
6. Run `devops-feature-validate` before PR
7. GitHub Actions enforces on PR
8. Requires two approvals on PR

**Example:** New authentication system, payment integration, major refactor

EOF
```

**Step 4: Progressive adoption timeline**
```bash
cat > docs/DOCUMENTATION-ROLLOUT-PLAN.md << 'EOF'
# Documentation Workflow Rollout Plan

## Phase 1: Soft Launch (Weeks 1-2)
**Goal:** Familiarize team with tools
**Actions:**
- ✅ Install CLI prompts for all developers
- ✅ GitHub Actions runs but doesn't block merges (warning only)
- ✅ Team meeting to demo workflow
- ✅ Documentation office hours (2x per week)

**Success criteria:**
- 80% of team has CLI installed
- 50% of features have documentation (any quality)

## Phase 2: Guided Enforcement (Weeks 3-4)
**Goal:** Build documentation habit
**Actions:**
- ✅ GitHub Actions blocks merges for large features (>1000 lines)
- ✅ Warning for medium features (200-1000 lines)
- ✅ Code reviews include documentation check
- ✅ Monthly documentation quality review

**Success criteria:**
- 100% of large features documented
- 70% of medium features documented

## Phase 3: Full Enforcement (Week 5+)
**Goal:** Standard practice across all features
**Actions:**
- ✅ GitHub Actions enforces all feature branches (>200 lines)
- ✅ Documentation quality metrics tracked
- ✅ Best practices shared in team meetings
- ✅ Onboarding includes documentation training

**Success criteria:**
- 100% of features documented
- Average documentation quality score >80%
- New developers can navigate codebase using docs

EOF
```

**Step 5: Monitoring and iteration**
```bash
# Create monitoring script
cat > scripts/doc-metrics.sh << 'EOF'
#!/bin/bash
# Track documentation metrics

echo "📊 Feature Documentation Metrics"
echo "================================="

# Count features vs documented features
FEATURE_BRANCHES=$(git branch -r | grep -c "feature/")
DOCUMENTED_FEATURES=$(find docs/features -name "*.md" | wc -l)
COVERAGE=$((DOCUMENTED_FEATURES * 100 / FEATURE_BRANCHES))

echo "Feature branches: $FEATURE_BRANCHES"
echo "Documented features: $DOCUMENTED_FEATURES"
echo "Coverage: $COVERAGE%"
echo ""

# Check documentation quality
echo "📝 Documentation Quality"
echo "========================"
for doc in docs/features/*.md; do
  WORDS=$(wc -w < "$doc")
  SECTIONS=$(grep -c "^## " "$doc")
  NAME=$(basename "$doc")
  echo "$NAME: $WORDS words, $SECTIONS sections"
done

EOF
chmod +x scripts/doc-metrics.sh

# Run weekly
echo "0 9 * * 1 cd /path/to/repo && ./scripts/doc-metrics.sh" | crontab -
```

### ✅ Advantages
- **Best of both worlds**: Guidance + enforcement
- **Flexible adoption**: Progressive rollout
- **Better DX**: Developers get help, not just blocked
- **Tiered approach**: Appropriate rigor for feature size
- **Metrics**: Track adoption and quality

### ⚠️ Considerations
- More complex setup (both systems)
- Requires maintenance of both CLI and GitHub Actions
- Team needs training on both tools
- Higher initial time investment

### 💰 Cost
- **Setup time:** 45-60 minutes (one-time)
- **Per-feature time:** 5-20 minutes (varies by tier)
- **Maintenance:** Medium (two systems to maintain)
- **Training:** 1-hour team session

### 📊 Expected Impact
- **Documentation coverage:** 95-100%
- **Developer satisfaction:** High (help when needed, enforcement when required)
- **Adoption rate:** Gradual but thorough
- **Code quality:** Significant improvement
- **Team alignment:** Much better

---

## Comparison Matrix

| Aspect | Recommendation 1 (GitHub Actions) | Recommendation 2 (CLI) | Recommendation 3 (Hybrid) |
|--------|-----------------------------------|------------------------|---------------------------|
| **Setup Time** | 30 min | 15 min | 60 min |
| **Enforcement** | Automatic | Manual | Tiered |
| **Flexibility** | Low | High | Medium |
| **Coverage** | 100% | 80-90% | 95-100% |
| **Developer Experience** | Can feel restrictive | Helpful/guided | Balanced |
| **Maintenance** | Low | Low | Medium |
| **Best For** | Mature teams | Starting out | Growing teams |
| **Cost** | Free (GitHub Actions) | Free (CLI) | Free |
| **Learning Curve** | Low | Medium | Medium |

---

## Decision Guide

### Choose Recommendation 1 (GitHub Actions) if:
- ✅ You want automatic enforcement
- ✅ Team is experienced with CI/CD
- ✅ You need compliance/audit trails
- ✅ Consistency is critical

### Choose Recommendation 2 (CLI) if:
- ✅ You want flexibility
- ✅ Team prefers command-line tools
- ✅ You're starting documentation practices
- ✅ You don't have CI/CD yet

### Choose Recommendation 3 (Hybrid) if:
- ✅ You want both guidance and governance
- ✅ Team has varied skill levels
- ✅ You're willing to invest in setup
- ✅ You want progressive adoption

---

## Quick Start: Choose Your Path

### Path A: Start Simple (Recommendation 2 → 1)
```bash
# Week 1: Set up CLI
bash setup-devops-quick-access.sh
# Add feature-*.md prompts

# Week 2-4: Team learns workflow
# Developers use CLI voluntarily

# Week 5+: Add enforcement
# Enable GitHub Actions workflow
```

### Path B: Start Strong (Recommendation 1)
```bash
# Day 1: Enable GitHub Actions
git add .github/workflows/feature-docs-check.yml
git commit -m "feat: add feature documentation enforcement"
git push

# Configure branch protection
# Team meeting to explain

# Day 2+: Team adapts
# Enforcement from day one
```

### Path C: Best Practice (Recommendation 3)
```bash
# Week 1: Set up both systems
# GitHub Actions (warning mode)
# CLI tools for guidance

# Week 2-3: Soft enforcement
# Week 4+: Full enforcement
# Iterate based on feedback
```

---

## Measuring Success

### Key Metrics

**Coverage:**
```bash
# Percentage of feature branches with documentation
DOCUMENTED=$(find docs/features -name "*.md" | wc -l)
FEATURES=$(git branch -r | grep -c "feature/")
echo "Coverage: $((DOCUMENTED * 100 / FEATURES))%"
```

**Quality:**
- Average word count per doc
- Required sections completion rate
- Time to review PRs (should decrease)

**Adoption:**
- Workflow failures (should decrease over time)
- Time to create documentation (should decrease as team learns)
- Developer feedback (surveys)

### Success Indicators

After 1 month:
- [ ] 90%+ feature branch documentation coverage
- [ ] <5% workflow failures (vs. 20%+ initially)
- [ ] 30% reduction in "what does this do?" questions during code review
- [ ] Positive developer feedback on process

After 3 months:
- [ ] 100% documentation coverage
- [ ] Documentation cited in code reviews
- [ ] New developers using docs to onboard
- [ ] Historical decisions easily found

---

## Next Steps

1. **Choose your approach** based on team needs
2. **Set up the basics** (template, guide, workflow)
3. **Train the team** (demo, office hours, documentation)
4. **Start small** (pilot with one team/project)
5. **Iterate** based on feedback
6. **Expand** to other teams once proven

---

## Support

**Setup Questions:** Check FEATURE-DOCUMENTATION-GUIDE.md
**Technical Issues:** Review workflow logs in GitHub Actions
**Process Questions:** Ask in #devops or #documentation channels

**This is a living document.** Provide feedback and suggest improvements!

---

**Created:** 2025-11-13
**Version:** 1.0
**Maintainer:** DevOps Team
