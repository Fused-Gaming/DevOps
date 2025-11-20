# Auto PR & Merge Workflow Setup

## Issue: GitHub Actions Cannot Create PRs

The auto-pr-merge workflow requires permission to create pull requests, but GitHub Actions has a security restriction by default.

**Error:**
```
GraphQL: GitHub Actions is not permitted to create or approve pull requests
```

## Solution Options

### Option 1: Enable in Repository Settings (Recommended)

1. Go to your repository on GitHub
2. Navigate to **Settings** → **Actions** → **General**
3. Scroll down to **Workflow permissions**
4. Check the box: **"Allow GitHub Actions to create and approve pull requests"**
5. Click **Save**

![Workflow Permissions](https://docs.github.com/assets/cb-78858/mw-1440/images/help/repository/actions-workflow-permissions-write.webp)

### Option 2: Use Personal Access Token (PAT)

If you can't enable the setting above, create a PAT with `repo` scope:

1. **Create a PAT:**
   - Go to GitHub Settings → Developer settings → Personal access tokens → Tokens (classic)
   - Click "Generate new token (classic)"
   - Name: `AUTO_PR_TOKEN`
   - Scopes: Select `repo` (full control)
   - Click "Generate token"
   - Copy the token

2. **Add to Repository Secrets:**
   - Go to your repo → Settings → Secrets and variables → Actions
   - Click "New repository secret"
   - Name: `AUTO_PR_TOKEN`
   - Value: Paste your PAT
   - Click "Add secret"

3. **Update workflow to use PAT:**
   ```yaml
   env:
     GH_TOKEN: ${{ secrets.AUTO_PR_TOKEN }}
   ```

### Option 3: Manual PR Creation

If you prefer not to auto-create PRs, you can:

1. Disable the `create-pr` job in the workflow
2. Manually create PRs through GitHub UI
3. The workflow will still auto-merge existing PRs when checks pass

## Testing the Fix

After applying Option 1 or 2:

1. Push a commit to a feature branch
2. The workflow should automatically create a PR
3. Watch the Actions tab for the workflow run
4. The PR should be created successfully

## Troubleshooting

### Still getting permission errors?

- **Check branch protection rules**: Make sure the workflow can push to your branch
- **Verify permissions**: Ensure the workflow file has correct permissions set
- **Check organization settings**: Some organizations restrict workflow permissions

### Workflow creates PR but can't merge?

- **Enable auto-merge**: Repository must allow auto-merge
- **Branch protection**: Check if required reviews or status checks are configured
- **Token permissions**: Ensure token has write access to repository

## Current Workflow Permissions

```yaml
permissions:
  contents: write        # Push commits and tags
  pull-requests: write   # Create and update PRs
  checks: read          # Read check status
  issues: write         # Add PR comments
```

## What Happens After Setup

Once configured, the workflow will:

1. ✅ **Auto-create PR** when you push to a feature branch
2. ✅ **Wait for checks** (build, test, lint, etc.)
3. ✅ **Collect results** from all workflows
4. ✅ **Auto-merge** if all checks pass
5. ✅ **Auto-close** with detailed report if checks fail
6. ✅ **Post summaries** to PR with all test results

## Need Help?

- [GitHub Actions Permissions Docs](https://docs.github.com/en/actions/security-guides/automatic-token-authentication#permissions-for-the-github_token)
- [Auto-merge PRs Guide](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/incorporating-changes-from-a-pull-request/automatically-merging-a-pull-request)
