# GitHub Repository Rulesets

This directory contains JSON configurations for GitHub repository rulesets to protect branches and enforce workflow requirements.

## 📁 Files

- `main-branch-protection.json` - Strict protection for the main branch
- `feature-branch-workflow.json` - Rules for feature branches

## 🚀 Quick Setup

### Via GitHub Web UI

1. Go to **Settings** → **Rules** → **Rulesets**
2. Click **New ruleset** → **New branch ruleset**
3. Copy/paste the JSON from the files above
4. Or manually configure using the settings below

### Via GitHub CLI

```bash
# From repository root
cd .github/rulesets

# Create main branch protection
gh api \
  --method POST \
  -H "Accept: application/vnd.github+json" \
  /repos/Fused-Gaming/DevOps/rulesets \
  --input main-branch-protection.json

# Create feature branch workflow
gh api \
  --method POST \
  -H "Accept: application/vnd.github+json" \
  /repos/Fused-Gaming/DevOps/rulesets \
  --input feature-branch-workflow.json
```

## 📋 Ruleset Details

### Main Branch Protection

**Target:** `main` branch
**Purpose:** Prevent direct commits, require PRs and status checks

**Rules:**
- ✅ Require pull request (0 approvals needed for auto-merge)
- ✅ Require status checks:
  - 🔒 Security & Dependency Audit
  - 🔨 Build & Test
  - 📝 Code Quality
- ✅ Block force pushes
- ✅ Prevent branch deletion
- ✅ Require linear history
- ✅ Admin bypass allowed

### Feature Branch Workflow

**Target:** `feature/*`, `fix/*`, `claude/*` branches
**Purpose:** Prevent accidental deletion of work-in-progress branches

**Rules:**
- ✅ Prevent branch deletion
- ✅ Allow branch creation

## 🤖 Auto-Merge Compatibility

These rulesets are optimized for the auto-merge workflow:

- **0 required approvals** - Allows automated merging
- **Required checks** - Ensures quality before merge
- **No strict updates** - Branch doesn't need to be up-to-date
- **Linear history** - Keeps git history clean

## 🔧 Customization

### Require Human Approval

Edit `main-branch-protection.json`:
```json
"required_approving_review_count": 1
```

### Require Branch Updates

Edit `main-branch-protection.json`:
```json
"strict_required_status_checks_policy": true
```

### Add More Protected Branches

Edit `conditions.ref_name.include`:
```json
"include": ["refs/heads/main", "refs/heads/develop", "refs/heads/production"]
```

### Add More Required Checks

Edit `required_status_checks`:
```json
{
  "context": "Lint Commit Messages",
  "integration_id": null
}
```

## 📊 Status Check Names

Current workflow check names from your CI/CD pipeline:

| Check Name | Source Workflow |
|------------|----------------|
| 🔒 Security & Dependency Audit | `ci-cd-enhanced.yml` |
| 🔨 Build & Test | `ci-cd-enhanced.yml` |
| 📝 Code Quality | `ci-cd-enhanced.yml` |
| Lint Commit Messages | `commit-lint.yml` (optional) |
| 📊 Track Milestone Progress | `milestone-tracking.yml` (optional) |

## ⚠️ Important Notes

1. **Bypass actors `actor_id: 5`** = Repository administrators
2. **Integration ID `null`** = Any GitHub App/Action
3. **Enforcement `active`** = Rules are enforced (use `disabled` to test)
4. **Auto-merge** requires "Allow auto-merge" enabled in Settings → General

## 🧪 Testing

After applying rulesets:

```bash
# This should fail (direct push to main)
git checkout main
git commit --allow-empty -m "test"
git push  # ❌ Blocked

# This should work (feature branch + PR)
git checkout -b feature/test
git commit --allow-empty -m "test"
git push  # ✅ Allowed
# PR will be auto-created, checks run, auto-merged if passing
```

## 📚 Resources

- [GitHub Rulesets Documentation](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-rulesets)
- [Branch Protection Rules](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-protected-branches)
- [Auto-merge PRs](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/incorporating-changes-from-a-pull-request/automatically-merging-a-pull-request)
