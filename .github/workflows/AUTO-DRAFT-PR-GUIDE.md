# 🚀 Auto Draft PR System

This system automatically creates **draft pull requests** for `claude/*` branches with auto-review and auto-merge capabilities.

## How It Works

### 1. Push to Branch → Creates Draft PR

When you push to a `claude/*` branch:

```bash
git push origin claude/my-feature
```

**What happens automatically:**
1. ✅ Draft PR is created
2. ✅ PR description generated with commit analysis
3. ✅ Labels added: `auto-generated`, `claude`
4. ✅ Reviewers notified via comment
5. ✅ CI/CD checks start running

### 2. Checks Pass → Auto-Approve

When all CI/CD checks pass:
1. ✅ PR is automatically approved
2. ✅ Auto-merge is enabled
3. ✅ Status comment posted

### 3. Approved → Auto-Merge

Once approved and all checks pass:
1. ✅ PR merges automatically with squash
2. ✅ Branch is deleted
3. ✅ Done!

---

## Workflow Files

### `auto-draft-pr.yml`
**Trigger:** Push to `claude/**` branches
**Purpose:** Creates draft PRs automatically

**Features:**
- Analyzes commits and generates smart PR titles
- Categorizes changes (feat, fix, docs, chore, test)
- Creates comprehensive PR description
- Adds labels and assigns reviewers
- Updates existing PRs with new commit notifications

### `auto-merge-reviewed.yml`
**Trigger:** PR review, check completion, ready for review
**Purpose:** Auto-approves and merges when ready

**Features:**
- Checks PR status (draft, conflicts, checks)
- Auto-approves when all checks pass
- Enables auto-merge
- Posts status updates as comments
- Handles merge automatically

---

## Requirements

### GitHub Token

The workflows use `AUTO_PR_TOKEN` (or fallback to `GITHUB_TOKEN`):

```yaml
env:
  GH_TOKEN: ${{ secrets.AUTO_PR_TOKEN || secrets.GITHUB_TOKEN }}
```

**Setup AUTO_PR_TOKEN:**
1. Create PAT at: https://github.com/settings/tokens/new
2. Scopes needed: `repo`, `workflow`
3. Add to repository secrets: https://github.com/Fused-Gaming/DevOps/settings/secrets/actions
4. Name: `AUTO_PR_TOKEN`

### Repository Settings

**Required permissions:**
- ✅ Actions can create PRs (via PAT)
- ✅ Allow auto-merge
- ✅ Branch protection allows Actions

**Repository rules:**
- ✅ `claude/*` branches can push directly (bypassing PR requirement)
- ✅ Main branch still protected

---

## Usage Examples

### Example 1: Simple Feature

```bash
# Create feature branch
git checkout -b claude/add-user-auth

# Make changes
git add .
git commit -m "feat: add user authentication system"

# Push to remote
git push -u origin claude/add-user-auth
```

**Result:**
- Draft PR created automatically with title: "✨ add user authentication system"
- PR includes stats, categorized commits, and checklist
- When checks pass, auto-approves and merges

### Example 2: Bug Fix

```bash
# Create fix branch
git checkout -b claude/fix-login-error

# Make changes
git add .
git commit -m "fix: resolve login redirect issue"
git commit -m "test: add test for login flow"

# Push to remote
git push -u origin claude/fix-login-error
```

**Result:**
- Draft PR created with title: "🐛 resolve login redirect issue"
- Shows 1 bug fix, 1 test added
- Auto-merges when approved

### Example 3: Documentation Update

```bash
# Create docs branch
git checkout -b claude/update-readme

# Make changes
git add README.md
git commit -m "docs: improve setup instructions"
git commit -m "docs: add troubleshooting section"

# Push to remote
git push -u origin claude/update-readme
```

**Result:**
- Draft PR created with title: "📚 improve setup instructions"
- Shows 2 documentation updates
- Auto-merges when checks pass

---

## PR Lifecycle

```
┌─────────────────────────────────────────────────────────────┐
│  1. PUSH TO claude/* BRANCH                                 │
└─────────────────────┬───────────────────────────────────────┘
                      │
                      ▼
┌─────────────────────────────────────────────────────────────┐
│  2. AUTO-CREATE DRAFT PR                                    │
│     - Generate title & description                          │
│     - Add labels: auto-generated, claude                    │
│     - Post reviewer comment                                 │
└─────────────────────┬───────────────────────────────────────┘
                      │
                      ▼
┌─────────────────────────────────────────────────────────────┐
│  3. CI/CD CHECKS RUN                                        │
│     - Tests, linting, builds, etc.                          │
└─────────────────────┬───────────────────────────────────────┘
                      │
                      ▼
                 All Pass? ──No──> Manual fixes needed
                      │
                     Yes
                      │
                      ▼
┌─────────────────────────────────────────────────────────────┐
│  4. AUTO-APPROVE                                            │
│     - PR approved automatically                             │
│     - Auto-merge enabled                                    │
│     - Status comment posted                                 │
└─────────────────────┬───────────────────────────────────────┘
                      │
                      ▼
┌─────────────────────────────────────────────────────────────┐
│  5. AUTO-MERGE                                              │
│     - Squash merge to main                                  │
│     - Delete branch                                         │
│     - Done! ✅                                              │
└─────────────────────────────────────────────────────────────┘
```

---

## Manual Override

You can always intervene manually:

### Mark as Ready for Review
Click the "Ready for review" button to convert from draft

### Add Human Reviewers
```bash
gh pr edit <PR_NUMBER> --add-reviewer @username
```

### Disable Auto-Merge
```bash
gh pr merge <PR_NUMBER> --disable-auto
```

### Manual Merge
Use the GitHub UI "Merge" button

---

## Troubleshooting

### "Failed to create PR"
**Cause:** Permission issues or token expired
**Fix:**
1. Verify `AUTO_PR_TOKEN` is set correctly
2. Check token has `repo` and `workflow` scopes
3. Ensure token hasn't expired

### "Auto-merge not available"
**Cause:** Repository settings
**Fix:**
1. Go to: Settings → General
2. Scroll to "Pull Requests"
3. Enable "Allow auto-merge"

### "PR created but not auto-approved"
**Cause:** Checks still running or failed
**Fix:**
1. Wait for checks to complete
2. If checks fail, fix issues and push
3. Auto-approve will trigger when checks pass

### "Branch protection blocking merge"
**Cause:** Main branch requires specific approvals
**Fix:**
1. Add bypass for Actions or PAT user
2. Or manually approve the PR

---

## Configuration

### Customize PR Title Format

Edit `.github/workflows/auto-draft-pr.yml` around line 80-95:

```yaml
# Generate PR title based on primary commit type
if [ "$FEAT_COUNT" -gt 0 ]; then
  echo "pr_title=✨ Feature: $FIRST_FEAT" >> $GITHUB_OUTPUT
```

### Change Merge Strategy

Edit `.github/workflows/auto-merge-reviewed.yml` around line 125:

```bash
gh pr merge "$PR_NUMBER" \
  --merge \      # Change to: --squash, --rebase, or --merge
  --delete-branch
```

### Add More Labels

Edit `.github/workflows/auto-draft-pr.yml` around line 220:

```bash
gh pr edit "$PR_NUMBER" \
  --add-label "auto-generated" \
  --add-label "claude" \
  --add-label "needs-review"    # Add more labels
```

---

## Benefits

### For Developers
- ✅ No manual PR creation
- ✅ Automatic descriptions generated
- ✅ Less context switching
- ✅ Faster merge cycles

### For Reviewers
- ✅ Comprehensive PR descriptions
- ✅ Categorized commits
- ✅ Clear statistics
- ✅ Automated routine reviews

### For Repository
- ✅ Consistent PR format
- ✅ Better commit tracking
- ✅ Faster CI/CD feedback
- ✅ Reduced manual overhead

---

## Comparison with Previous System

| Feature | Old System | New Draft PR System |
|---------|-----------|---------------------|
| PR Creation | Manual | ✅ Automatic |
| PR Description | Manual | ✅ Auto-generated |
| Review Assignment | Manual | ✅ Automatic |
| Approval | Manual | ✅ Auto-approved |
| Merge | Manual | ✅ Auto-merged |
| Branch Cleanup | Manual | ✅ Automatic |
| Status Updates | None | ✅ Commented |
| Permission Issues | Common | ✅ Resolved with PAT |

---

## Next Steps

1. **Verify AUTO_PR_TOKEN is set** in repository secrets
2. **Test with a new claude/* branch**:
   ```bash
   git checkout -b claude/test-draft-pr
   echo "# Test" > TEST.md
   git add TEST.md
   git commit -m "test: verify draft PR system"
   git push -u origin claude/test-draft-pr
   ```
3. **Watch the magic happen** in Actions tab!
4. **Review the draft PR** that was created
5. **Wait for auto-merge** or manually approve

---

*For more details, see:*
- `PERMISSIONS_FIX.md` - Token setup guide
- `SETUP_NEXT_STEPS.md` - Complete setup workflow
- `.github/workflows/AUTO-PR-SETUP.md` - Original auto-PR guide
