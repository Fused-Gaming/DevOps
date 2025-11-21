# 🔧 GitHub Actions Permissions Fix

## Problem

You're trying to enable "Allow GitHub Actions to create and approve pull requests" but the checkbox isn't available in Settings → Actions → General → Workflow permissions.

## Why This Happens

This can occur when:
1. You don't have admin access to the repository
2. The repository is part of an organization with restricted settings
3. Organization-level policies override repository settings
4. The GitHub plan has limitations

## Solution: Use Personal Access Token (PAT)

Instead of relying on the default GITHUB_TOKEN, we'll use a Personal Access Token with explicit permissions.

---

## 🚀 Quick Fix (Automated Script)

Run this automated script to set everything up:

```bash
bash scripts/setup-auto-pr-permissions.sh
```

This script will:
1. ✅ Check GitHub CLI is installed and authenticated
2. ✅ Guide you through creating a PAT
3. ✅ Automatically add the PAT as a repository secret
4. ✅ Verify the setup

**Time required:** ~3 minutes

---

## 📋 Manual Setup (If Script Doesn't Work)

### Step 1: Create Personal Access Token

**Via GitHub Web UI:**
1. Go to: https://github.com/settings/tokens/new
2. Fill in:
   - **Token name:** `AUTO_PR_TOKEN`
   - **Expiration:** 90 days (or your preference)
   - **Scopes:** Select these checkboxes:
     - ☑ `repo` (Full control of private repositories)
     - ☑ `workflow` (Update GitHub Action workflows)
3. Click **"Generate token"**
4. **Copy the token** (starts with `ghp_` or `github_pat_`)
   - ⚠️ You won't be able to see it again!

**Via GitHub CLI (Alternative):**
```bash
# Login with required scopes
gh auth login --scopes repo,workflow

# Get your token
gh auth token
```

### Step 2: Add Token to Repository Secrets

**Via GitHub Web UI:**
1. Go to: https://github.com/Fused-Gaming/DevOps/settings/secrets/actions
2. Click **"New repository secret"**
3. Fill in:
   - **Name:** `AUTO_PR_TOKEN`
   - **Secret:** [paste your token here]
4. Click **"Add secret"**

**Via GitHub CLI:**
```bash
# Add secret (will prompt for token)
gh secret set AUTO_PR_TOKEN --repo Fused-Gaming/DevOps

# Verify it was added
gh secret list --repo Fused-Gaming/DevOps
```

### Step 3: Update Workflows (If Needed)

The workflows in the restored feature branch already have the correct structure. If you see permission errors after merging, update the workflow files to explicitly use the PAT:

```yaml
# Add this to workflows that create PRs
env:
  GH_TOKEN: ${{ secrets.AUTO_PR_TOKEN }}
```

Or for specific steps:

```yaml
- name: Create PR
  env:
    GH_TOKEN: ${{ secrets.AUTO_PR_TOKEN }}
  run: |
    gh pr create --title "..." --body "..."
```

---

## 🧪 Testing the Setup

After adding the PAT secret:

```bash
# 1. Switch to a test branch
git checkout -b test/permissions-fix

# 2. Make a small change
echo "# Testing auto-PR" >> TEST.md
git add TEST.md
git commit -m "test: verify auto-PR permissions"

# 3. Push to remote
git push -u origin test/permissions-fix

# 4. Watch the workflow run
gh run list --repo Fused-Gaming/DevOps --limit 1
```

Expected result:
- ✅ Workflow runs successfully
- ✅ PR is created automatically
- ✅ No "GitHub Actions is not permitted" errors

---

## 🔍 Troubleshooting

### "Secret not found"
- **Check secret name:** Must be exactly `AUTO_PR_TOKEN` (case-sensitive)
- **Verify secret exists:** Run `gh secret list --repo Fused-Gaming/DevOps`
- **Check repository:** Make sure you're adding to the correct repo

### "Bad credentials" or "401 Unauthorized"
- **Token expired:** Create a new token
- **Insufficient scopes:** Token needs `repo` and `workflow` scopes
- **Token revoked:** Check https://github.com/settings/tokens

### "Resource not accessible by integration"
- **Workflow permissions:** The workflow file needs `permissions:` block:
  ```yaml
  permissions:
    contents: write
    pull-requests: write
  ```

### Still having issues?
- **Check organization settings:** Admin may need to allow PAT usage
- **Branch protection:** Ensure branch rules allow Actions to push
- **Workflow logs:** Check Actions tab for detailed error messages

---

## 📖 References

- **Full setup guide:** `.github/workflows/AUTO-PR-SETUP.md`
- **Script source:** `scripts/setup-auto-pr-permissions.sh`
- **GitHub Docs:** [Automatic token authentication](https://docs.github.com/en/actions/security-guides/automatic-token-authentication)

---

## ✅ Verification Checklist

After setup, verify:

- [ ] PAT created with `repo` and `workflow` scopes
- [ ] PAT added as `AUTO_PR_TOKEN` repository secret
- [ ] Secret visible in: https://github.com/Fused-Gaming/DevOps/settings/secrets/actions
- [ ] Test push creates PR automatically
- [ ] No permission errors in workflow logs

---

## 🎯 Next Steps After Fix

Once permissions are working:

1. **Create the two pending PRs:**
   - https://github.com/Fused-Gaming/DevOps/pull/new/claude/update-devops-docs-automation-01VRrQ8p6abcAdWStQuPRf9u
   - https://github.com/Fused-Gaming/DevOps/pull/new/claude/restore-workflow-automation-features-01VRrQ8p6abcAdWStQuPRf9u

2. **Future feature branches will auto-create PRs** thanks to the restored workflow

3. **Monitoring:** Watch the Actions tab for the first few runs to ensure everything works

---

*Generated: 2025-11-20*
*See also: SETUP_NEXT_STEPS.md for complete setup guide*
